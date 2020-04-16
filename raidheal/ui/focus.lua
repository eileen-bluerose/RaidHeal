local RaidHeal = _G.RaidHeal
local UI = RaidHeal.UI
local Focus = UI.Focus

local Events = RaidHeal.Events
local Tasks = RaidHeal.Tasks
local Config = RaidHeal.Config
local Frames = RaidHeal.Frames
local Data = UI.Data

Focus.BackFrame = nil
Focus.UnitFrameTemplate = nil
Focus.Units = {}
Focus.Data = {}
Focus.PosData = {}

Focus.IgnoreFocus = 0

local active = nil

Focus.OnProfileLoaded = function(profileName)
    local backFrameTemplate = { Type = "Frame" }
    Focus.UnitFrameTemplate = UI.CreateTemplateFromConfig("UnitFrameTemplate", Config.Focus.Unit)

    if not Focus.BackFrame then
        Focus.BackFrame = Frames.CreateFromTemplate(backFrameTemplate, "RH_Focus_BackFrame", Config.Focus.Parent)
    else
        Frames.Arrange(Focus.BackFrame, backFrameTemplate)

        if not active then Focus.BackFrame:Hide() end
    end

    Focus.BackFrame.API = Focus

    ---------------------------------------------------------------------

    local parentWidth, parentHeight = Focus.BackFrame:GetParent():GetSize()
    Focus.BackFrame:SetSize(Config.Focus.Size.Width * parentWidth, Config.Focus.Size.Height * parentHeight)
    Focus.BackFrame:ClearAllAnchors()
    Focus.BackFrame:SetAnchor(Config.Focus.Anchor.Point, Config.Focus.Anchor.RelPoint, Config.Focus.Parent, Config.Focus.Anchor.OffsetX * parentWidth, Config.Focus.Anchor.OffsetY * parentHeight)

    ---------------------------------------------------------------------

    UI.InitUnits(Focus.Units, Config.Focus, Focus.BackFrame, Focus.UnitFrameTemplate, "RH_Focus_Unit")

    if Config.Focus.Active then
        Focus.Enable()
    else
        Focus.Disable()
    end
end

Focus.Update = function()
    local data = {}
    local countIgnored = 0

    for i = Config.Focus.MaxNumUnits, 1, -1 do
        data[i] = Data.CollectUnitData("focus"..i)

        if data[i] and countIgnored < Focus.IgnoreFocus then
            countIgnored = countIgnored + 1
            data[i] = nil
        end

        UI.UpdateUnit(Focus.Units[i], data[i], Config.Focus.Unit)
    end

    Focus.Data = data
end

Focus.Enable = function()
    if active == true or not Focus.BackFrame then return end

    active = true
    Tasks.Add(Focus.Update, 0, 0, true, "focus_update")
    Focus.BackFrame:Show()

    if Config.Focus.ToggleUI then
        FocusFrame:UnregisterEvent("FOCUS_CHANGED")
        FocusFrame:Hide()
    end
end

Focus.Disable = function()
    if active == false then return end

    active = false
    Tasks.Remove("focus_update")
    Focus.BackFrame:Hide()

    if Config.Focus.ToggleUI then
        FocusFrame:RegisterEvent("FOCUS_CHANGED")
        FocusFrame_OnEvent(FocusFrame, "FOCUS_CHANGED")
    end
end

Focus.SaveTarget = function()
    local oldTarget = UnitExists("target")

    if oldTarget then
        FocusUnit(12, "target")
        Focus.IgnoreFocus = Focus.IgnoreFocus + 1
    end

    return oldTarget
end

Focus.RestoreTarget = function(oldTarget)
    if Focus.IgnoreFocus > 0 and oldTarget then
        for i = 12, 1, -1 do
            if UnitExists("focus" .. i) then
                TargetUnit("focus" .. i)
                FocusUnit(i, "")

                Focus.IgnoreFocus = Focus.IgnoreFocus - 1
                break
            end
        end
    else
        TargetUnit("")
    end
end

Events.Register("PROFILE_LOADED", Focus.OnProfileLoaded)
Events.Register("PROFILE_UPDATE", Focus.OnProfileLoaded)
Events.Register("SCREEN_RESIZE", Focus.OnProfileLoaded)
