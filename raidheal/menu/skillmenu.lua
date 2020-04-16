local RaidHeal = _G.RaidHeal
local Menu = RaidHeal.Menu
local SkillMenu = Menu.SkillMenu
local ActionMenu = Menu.ActionMenu

local IO = RaidHeal.IO
local Hotkeys = RaidHeal.Hotkeys
local Events = RaidHeal.Events
local Tasks = RaidHeal.Tasks

local lutIconBtns = {
    LBUTTON = "Left",
    LBUTTONCtrl = "LeftCtrl",
    LBUTTONAlt = "LeftAlt",
    LBUTTONShift = "LeftShift",
    LBUTTONCtrlAlt = "LeftCtrlAlt",
    LBUTTONCtrlShift = "LeftCtrlShift",
    LBUTTONAltShift = "LeftAltShift",
    LBUTTONCtrlAltShift = "LeftCtrlAltShift",

    RBUTTON = "Right",
    RBUTTONCtrl = "RightCtrl",
    RBUTTONAlt = "RightAlt",
    RBUTTONShift = "RightShift",
    RBUTTONCtrlAlt = "RightCtrlAlt",
    RBUTTONCtrlShift = "RightCtrlShift",
    RBUTTONAltShift = "RightAltShift",
    RBUTTONCtrlAltShift = "RightCtrlAltShift",

    MBUTTON = "Middle",
    MBUTTONCtrl = "MiddleCtrl",
    MBUTTONAlt = "MiddleAlt",
    MBUTTONShift = "MiddleShift",
    MBUTTONCtrlAlt = "MiddleCtrlAlt",
    MBUTTONCtrlShift = "MiddleCtrlShift",
    MBUTTONAltShift = "MiddleAltShift",
    MBUTTONCtrlAltShift = "MiddleCtrlAltShift",

    REVIVE = "Revive",
    REVIVE2 = "ReviveExtra"
}

SkillMenu.Show = function(callee)
    SkillMenu.Callee = callee
    if callee and callee.Hide then callee:Hide() end

    RH_SkillMenu:Show()
end

SkillMenu.Hide = function()
    if SkillMenu.Callee then
        SkillMenu.Callee:Show()
        SkillMenu.Callee = nil
    end

    RH_SkillMenu:Hide()
end

SkillMenu.OnShow = function()
    if not RaidHeal_Config.Hotkeys then RaidHeal_Config.Hotkeys = {} end
    local mainClass, subClass = UnitClassToken("player")
    SkillMenu.LoadSkills(mainClass, subClass, RaidHeal_Config.Hotkeys)

    Tasks.Add(function()
        ActionMenu.SelectList = nil
        ActionMenu.ShowAction()
    end, 0.05, 0.05, false, "")
end

SkillMenu.OnHide = function()
    ActionMenu.Hide()
end

local memoizedButtons = {}
SkillMenu.GetIconButton = function(hotkey)
    if not hotkey then IO.PrintError("Expected hotkey") return nil end

    if memoizedButtons[hotkey] then return memoizedButtons[hotkey] end

    local iconBtn = getglobal("RH_SkillMenu_IconBtn" .. lutIconBtns[hotkey])
    memoizedButtons[hotkey] = iconBtn

    return iconBtn
end

SkillMenu.SetIconButtonTexture = function(hotkey, texture, color)
    local iconBtn = SkillMenu.GetIconButton(hotkey)
    if not iconBtn then return end

    iconBtn.Color = color
    iconBtn.Border:SetColor(unpack(color))

    if texture then
        iconBtn.Texture:SetTexture(texture)
        iconBtn.Texture:Show()
    else
        iconBtn.Texture:Hide()
    end
end

SkillMenu.LoadSkills = function(mainClass, subClass, db)
    if not db then db = SkillMenu.DB end

    local function getTexture(skill)
        if skill.Type == "ACTION" then
            return (GetActionInfo(skill.Slot))
        elseif skill.Type == "SKILL" then
            local name, _, texture = GetSkillDetail(skill.Tab or 1, skill.Index or 1)
            local skillName = TEXT("Sys" .. skill.ID .. "_name")

            if name == skillName then
                return texture
            else
                -- thorough search
                for i = 1, 5 do
                    for j = 1, GetNumSkill(i) do
                        local name, _, texture = GetSkillDetail(i, j)

                        if name == skillName then
                            skill.Tab, skill.Index = i, j

                            return texture
                        end
                    end
                end
            end
        elseif skill.Type == "MOVERAID" then
            return ""
        elseif skill.Type == "DROPDOWN" then
            return ""
        elseif skill.Type == "TARGET" then
            return ""
        else
            IO.PrintError("Unknown Action: " .. tostring(skill.Type))
        end
    end

    local function loadFromDB(index, color)
        if not db or not db[index] then return end
        for hotkey, skill in pairs(db[index]) do
            SkillMenu.SetIconButtonTexture(hotkey, getTexture(skill), color)
        end
    end

    local colorInactive = { 0.4, 0.4, 0.4 }
    local colorActive = { 0.75, 1, 0 }
    local colorEmpty = { 0, 0, 0 }

    SkillMenu.MainClass = mainClass
    SkillMenu.SubClass = subClass
    SkillMenu.DB = db

    local function getLocalizedClassname(class)
        if class == "" or class == "*" then
            return (Menu.GetText("SM_OPTIONANY"))
        end

        for i = 0, GetNumClasses() do
            local locaName, tokenName = GetClassInfoByID(i)

            if locaName and tokenName and tokenName == class then
                return locaName
            end
        end

        return (Menu.GetText("SM_OPTIONANY"))
    end

    RH_SkillMenu_DropDownMainClass:SetText(getLocalizedClassname(mainClass))
    RH_SkillMenu_DropDownSubClass:SetText(getLocalizedClassname(subClass))

    for hotkey in pairs(lutIconBtns) do
        SkillMenu.SetIconButtonTexture(hotkey, nil, colorEmpty)
    end

    if (mainClass == "*" or mainClass == "") and (subClass == "*" or subClass == "") then
        loadFromDB("*", colorActive)
        return
    else
        loadFromDB("*", colorInactive)
    end

    if (mainClass == "*" or mainClass == "") then
        loadFromDB("*" .. subClass, colorActive)
        return
    else
        loadFromDB("*" .. subClass, colorInactive)
    end

    loadFromDB("*" .. mainClass, colorInactive)
    if (subClass == "*" or subClass == "") then
        loadFromDB(mainClass .. "*", colorActive)
        return
    else
        loadFromDB(mainClass .. "*", colorInactive)
    end

    loadFromDB(mainClass .. subClass, colorActive)
end

SkillMenu.SetMainClass = function(newMainClass)
    SkillMenu.LoadSkills(newMainClass, SkillMenu.SubClass, SkillMenu.DB)
end

SkillMenu.SetSubClass = function(newSubClass)
    SkillMenu.LoadSkills(SkillMenu.MainClass, newSubClass, SkillMenu.DB)
end

SkillMenu.GetMainClass = function()
    return SkillMenu.MainClass or ""
end

SkillMenu.GetSubClass = function()
    return SkillMenu.SubClass or ""
end

SkillMenu.CreateDropDown = function(mainClass)
    local info = {
        text = (Menu.GetText("SM_OPTIONANY")),
        notCheckable = 1,
        func = mainClass and function() SkillMenu.SetMainClass("*") end or function() SkillMenu.SetSubClass("*") end
    }
    UIDropDownMenu_AddButton(info)

    for i = 1, GetNumClasses() do
        local name, token = GetPlayerClassInfo(i)
        if name then
            if mainClass or token ~= SkillMenu.GetMainClass() then
                info = {
                    text = name,
                    notCheckable = 1,
                    func = mainClass and function() SkillMenu.SetMainClass(token) end or function() SkillMenu.SetSubClass(token) end
                }
                UIDropDownMenu_AddButton(info)
            end
        end
    end
end

SkillMenu.OnIconButtonClick = function(iconButton, key)
    -- name schema: "RH_SkillMenu_IconBtnXXX"
    -- extract XXX and fin its key in lutIconBtns
    local btnName = string.sub(iconButton:GetName(), 21) -- 21 = string.len("RH_SkillMenu_IconBtn") + 1

    local hotkey = ""

    for k, v in pairs(lutIconBtns) do
        if btnName == v then
            hotkey = k
            break
        end
    end

    if hotkey == "" then
        IO.PrintError("unable to find hotkey identifier for icon button '" .. iconButton:GetName() .. "'")
        return
    end

    local mainClass, subClass = SkillMenu.GetMainClass(), SkillMenu.GetSubClass()

    local classToken = ""

    if (mainClass == "" or mainClass == "*") and (subClass == "" or subClass == "*") then
        classToken = "*"
    elseif mainClass == "" or mainClass == "*" then
        classToken = "*" .. subClass
    elseif subClass == "*" or subClass == "" then
        classToken = mainClass .. "*"
    else
        classToken = mainClass .. subClass
    end

    if key == "LBUTTON" then
        ActionMenu.LoadAction(classToken, hotkey)
        ActionMenu.Show(RH_SkillMenu)
    elseif key == "RBUTTON" then
        Hotkeys.SetAction(hotkey, classToken, nil)
        SkillMenu.LoadSkills(SkillMenu.GetMainClass(), SkillMenu.GetSubClass(), RaidHeal_Config.Hotkeys)
    end
end

Events.Register("HOTKEYS_CHANGED", SkillMenu.OnShow)
