local RaidHeal = _G.RaidHeal
local UI = RaidHeal.UI
local Handlers = UI.Handlers
local Hotkeys = RaidHeal.Hotkeys
local Focus = UI.Focus
local IO = RaidHeal.IO
local Events = RaidHeal.Events
local Tasks = RaidHeal.Tasks

local _isCasting, _isCastingStart, _isCastingFailed = false, false, false

Handlers.OnUnitMouseDown = function(unit, mouseButton, unitIndex)
    if unit.UnitID and SpellIsTargeting() then
        SpellTargetUnit(unit.UnitID)
        return
    end

    local parent = unit:GetParent()
    local api = parent.API

    if api and api.Moving and api.StopMoving then
        api.StopMoving(unitIndex)
        return
    end

    if not unit.UnitID or not UnitExists(unit.UnitID) then return end

    local ctrl = IsCtrlKeyDown() and "Ctrl" or ""
    local alt = IsAltKeyDown() and "Alt" or ""
    local shift = IsShiftKeyDown() and "Shift" or ""

    local hotkey = mouseButton .. ctrl .. alt .. shift

    local action = Hotkeys.GetAction(hotkey)

    if not action or action.Type == "SKILL" or action.Type == "ACTION" and unit.UnitID and UnitExists(unit.UnitID) then
        local unitHealth = UnitHealth(unit.UnitID)
        if unitHealth == 0 then
            hotkey = "REVIVE2"

            local function unitHasBuffID(unit, buffID)
                local id = nil
                i = 0
                repeat
                    i = i + 1
                    _, _, _, id = UnitBUff(unit, i)

                    if id == buffID then return true end
                until not id

                return false
            end

            if UnitLevel(unit.UnitID) < 11 or GetBagItemCount(203606) < 1 or unitHasBuffID(unit.UnitID, 501387) then hotkey = "REVIVE" end

            local reviveAction = Hotkeys.GetAction(hotkey)
            if not reviveAction and hotkey == "REVIVE2" then reviveAction = Hotkeys.GetAction("REVIVE") end

            if reviveAction then action = reviveAction end
        end
    end

    if not action then return end

    local function setTarget()
        local target = action.FreeTargeting and "" or unit.UnitID
        target = target .. action.Target

        TargetUnit(target)
    end

    if action.Type == "TARGET" then
        setTarget()
        return
    elseif action.Type == "MOVERAID" then
        if api and api.StartMoving then

            api.StartMoving(unitIndex)
            unit.IsMoving = true
        end
        return
    elseif action.Type == "DROPDOWN" then
        local dropDown = RH_DropDownMenu
        local x, y = GetCursorPos()

        dropDown:ClearAllAnchors()
        dropDown:SetAnchor("TOPLEFT", "TOPLEFT", UIParent, x+3, y-3)
        dropDown._unit = unit.UnitID

        ToggleDropDownMenu(dropDown)
        return
    end


    local oldTarget = false

    if action.Type == "SKILL" or (action.Type == "ACTION" and action.SaveTarget) then
        oldTarget = Focus.SaveTarget()
    end

    setTarget()

    if action.Type == "SKILL" then
        CastSpellByName(TEXT("Sys"..action.ID.."_name"))
    elseif action.Type == "ACTION" then
        UseAction(action.Slot)
    end

    if action.CheckForCast then
        Tasks.Add(function() if not _isCasting then MoveForwardStop() end end, 0, 0, false, "check_casting")
    end

    if action.Type == "SKILL" or (action.Type == "ACTION" and action.RestoreTarget) then
        Focus.RestoreTarget(oldTarget)
    end
end

Handlers.OnUnitMouseUp = function(unit, index)
    local api = unit:GetParent().API
    if api and api.Moving then
        if api and api.StopMoving and api.MouseOverIndex and api.MouseOverIndex ~= index then
            api.StopMoving(api.MouseOverIndex)
            unit.IsMoving = false
        end
    end
end

Handlers.OnUnitEnter = function(unit, index)
    local parent = unit:GetParent()

    if parent.API then
        parent.API.MouseOverUnit = index
    end
end

Handlers.OnUnitLeave = function(unit, index)
    local parent = unit:GetParent()

    if parent.API then
        parent.API.MouseOverUnit = nil
        parent.API.MouseOverLastUnit = index
    end
end

Events.Register("CASTING_START", function() _isCastingStart = true _isCastingFailed = false end)
Events.Register("UNIT_CASTINGTIME", function(arg1) _isCasting = UnitIsUnit(arg1, "player") end)
Events.Register("CASTING_STOP", function() _isCasting = false _isCastingStart = false end)
Events.Register("CASTING_FAILED", function() _isCasting = false _isCastingStart = false _isCastingFailed = true end)
