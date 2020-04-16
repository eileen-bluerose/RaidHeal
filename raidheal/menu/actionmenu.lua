local RaidHeal = _G.RaidHeal
local Menu = RaidHeal.Menu
local ActionMenu = Menu.ActionMenu
local SkillMenu = Menu.SkillMenu

local IO = RaidHeal.IO
local Hotkeys = RaidHeal.Hotkeys

local shown = false
local heightData = nil

ActionMenu.TargetText = ""

ActionMenu.Show = function(callee)
    if callee and callee.GetParent then
        RH_ActionMenu:ClearAllAnchors()
        RH_ActionMenu:SetAnchor("TOPLEFT", "TOPRIGHT", callee, 5, 35)
    end

    RH_ActionMenu:Show()
end

ActionMenu.Hide = function()
    if ActionMenu.Callee then
        ActionMenu.Callee:Show()
        ActionMenu.Callee = nil
    end

    RH_ActionMenu:Hide()
end

ActionMenu.OnShow = function()
    if not heightData then
        heightData = {}
        heightData.Info = RH_ActionMenu_DetailsPanel_Info:GetHeight()
        heightData.Target = RH_ActionMenu_DetailsPanel_Target:GetHeight()
    end

    if not ActionMenu.Action then
        ActionMenu.Action = {}
    end

    ActionMenu.ShowAction()
end

ActionMenu.ShowAction = function()
    local lutTextures = {
        SKILL = function()
            local skill = ActionMenu.Action
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
        end,
        ACTION = function()
            return (GetActionInfo(ActionMenu.Action.Slot))
        end,
        TARGET = function()
            return "interface/addons/raidheal/graphics/highlight.tga"
        end,
        MOVERAID = function()
            return "interface/addons/raidheal/graphics/highlight.tga"
        end,
        DROPDOWN = function()
            return "interface/addons/raidheal/graphics/highlight.tga"
        end,
    }

    local action = ActionMenu.Action

    if action and action.Type then
        RH_ActionMenu_DetailsPanel:Show()
        RH_ActionMenu_SelectActionPanel:Hide()
        RH_ActionMenu_DetailsPanel_Title_Icon:SetTexture(lutTextures[action.Type]())

        local titleText = ""
        local info1 = { Desc = "", Value = "" }
        local info2 = { Desc = "", Value = "" }
        local showTargetOptions = true

        if action.Type == "SKILL" then
            titleText = TEXT("Sys" .. action.ID .. "_name")

            info1.Desc = "Tab:"
            info1.Value = action.Tab

            info2.Desc = "Index:"
            info2.Value = action.Index
        elseif action.Type == "ACTION" then
            titleText = ({GetActionInfo(action.Slot)})[2]

            info1.Desc = "Slot:"
            info1.Value = action.Slot
        elseif action.Type == "TARGET" then
            titleText = "TARGET"
        elseif action.Type == "MOVERAID" then
            titleText = "MOVERAID"

            showTargetOptions = false
        elseif action.Type == "DROPDOWN" then
            titleText = "DROPDOWN"

            showTargetOptions = false
        end

        RH_ActionMenu_DetailsPanel_Title_Desc:SetText(titleText)

        RH_ActionMenu_DetailsPanel_Info_Desc1:SetText(info1.Desc)
        RH_ActionMenu_DetailsPanel_Info_Value1:SetText(info1.Value)

        RH_ActionMenu_DetailsPanel_Info_Desc2:SetText(info2.Desc)
        RH_ActionMenu_DetailsPanel_Info_Value2:SetText(info2.Value)

        if info2.Desc == "" and info2.Value == "" then
            if info1.Desc == "" and info1.Value == "" then
                RH_ActionMenu_DetailsPanel_Info:SetHeight(0)
                RH_ActionMenu_DetailsPanel_Info:Hide()
            else
                RH_ActionMenu_DetailsPanel_Info:SetHeight(heightData.Info / 2)
                RH_ActionMenu_DetailsPanel_Info:Show()
            end
        else
            RH_ActionMenu_DetailsPanel_Info:SetHeight(heightData.Info)
            RH_ActionMenu_DetailsPanel_Info:Show()
        end

        if showTargetOptions then
            RH_ActionMenu_DetailsPanel_Target_DescFree:SetText(IO.Format("AM_FREETARGET_DESC"))
            RH_ActionMenu_DetailsPanel_Target_DescSelect:SetText(IO.Format("AM_TARGETSELECT_DESC"))
            RH_ActionMenu_DetailsPanel_Target_DescExperts:SetText(IO.Format("AM_EXPERTS_DESC"))

            if action.FreeTargeting then
                ActionMenu.TargetText = ""
                RH_ActionMenu_DetailsPanel_Target_CheckBtnIsFree:SetChecked(true)
            else
                ActionMenu.TargetText = "(unit_clicked)"
                RH_ActionMenu_DetailsPanel_Target_CheckBtnIsFree:SetChecked(false)
            end

            if not action.Target then action.Target = "" end
            ActionMenu.TargetText = ActionMenu.TargetText .. action.Target

            RH_ActionMenu_DetailsPanel_Target_EditExperts:SetText(ActionMenu.TargetText)

            local btnTargetText = action.Target
            if action.Target == "" then
                btnTargetText = action.FreeTargeting and IO.Format("AM_TARGET_NONE_DESC") or IO.Format("AM_TARGET_SELF_DESC")
            elseif action.Target == "target" then
                btnTargetText = IO.Format("AM_TARGET_TARGET_DESC")
            elseif action.Target == "targettarget" then
                btnTargetText = IO.Format("AM_TARGET_TARGET2_DESC")
            elseif action.Target == "targettargettarget" then
                btnTargetText = IO.Format("AM_TARGET_TARGET3_DESC")
            elseif action.Target == "pet" then
                btnTargetText = IO.Format("AM_TARGET_PET_DESC")
            end
            RH_ActionMenu_DetailsPanel_Target_BtnSelectTarget:SetText(btnTargetText)

            RH_ActionMenu_DetailsPanel_Target:SetHeight(heightData.Target)
            RH_ActionMenu_DetailsPanel_Target:Show()
        else
            RH_ActionMenu_DetailsPanel_Target:Hide()
            RH_ActionMenu_DetailsPanel_Target:SetHeight(0)
        end

        RH_ActionMenu_DetailsPanel_SaveButton:SetText(IO.Format("AM_SAVEBUTTON_DESC"))
    else
        RH_ActionMenu_DetailsPanel:Hide()
        RH_ActionMenu_SelectActionPanel:Show()

        RH_ActionMenu_SelectActionPanel_SelectSkill:SetText(IO.Format("AM_SELECTSKILL_DESC"))
        RH_ActionMenu_SelectActionPanel_SelectAction:SetText(IO.Format("AM_SELECTACTION_DESC"))
        RH_ActionMenu_SelectActionPanel_SelectExtra:SetText(IO.Format("AM_SELECTEXTRA_DESC"))

        if not ActionMenu.SelectMode or ActionMenu.SelectMode == "" then
            ActionMenu.SelectMode = ""

            RH_ActionMenu_SelectActionPanel_SelectAction:ClearAllAnchors()
            RH_ActionMenu_SelectActionPanel_SelectAction:SetAnchor("TOP", "BOTTOM", RH_ActionMenu_SelectActionPanel_SelectSkill, 0, 5)

            RH_ActionMenu_SelectActionPanel_SelectExtra:ClearAllAnchors()
            RH_ActionMenu_SelectActionPanel_SelectExtra:SetAnchor("TOP", "BOTTOM", RH_ActionMenu_SelectActionPanel_SelectAction, 0, 5)

            RH_ActionMenu_SelectActionPanel_ScrollSelect:Hide()
        else
            local function createList(mode)
                local list = {}
                if mode == "SKILL" then
                    for i = 1, 5 do
                        for j = 1, GetNumSkill(i) or 0 do
                            local name, _, texture, isPassive = GetSkillDetail(i, j)

                            if isPassive ~= 2 then
                                local id = ({ParseHyperlink(GetSkillHyperLink(i, j))})[2]:sub(1,6)

                                list[#list+1] = {
                                    Name = name,
                                    Texture = texture,
                                    Action = {
                                        Type = "SKILL",
                                        ID = id,
                                        Tab = i,
                                        Index = j
                                    }
                                }
                            end
                        end
                    end
                elseif mode == "ACTION" then
                    for i = 1, 80 do
                        local texture, name = GetActionInfo(i)
                        if not name then name = IO.Format("AM_ACTIONSLOT_DESC", i) end

                        list[#list + 1] = {
                            Name = name,
                            Texture = texture,
                            Action = {
                                Type = "ACTION",
                                Slot = i
                            }
                        }
                    end
                else
                    list[#list + 1] = {
                        Name = IO.Format("AM_SELECTMOVERAID_DESC"),
                        Texture = "interface/addons/raidheal/graphics/highlight.tga",
                        Action = {
                            Type = "MOVERAID"
                        }
                    }
                    list[#list + 1] = {
                        Name = IO.Format("AM_SELECTTARGET_DESC"),
                        Texture = "interface/addons/raidheal/graphics/highlight.tga",
                        Action = {
                            Type = "TARGET"
                        }
                    }
                    list[#list + 1] = {
                        Name = IO.Format("AM_SELECTDROPDOWN_DESC"),
                        Texture = "interface/addons/raidheal/graphics/highlight.tga",
                        Action = {
                            Type = "DROPDOWN"
                        }
                    }
                end

                return list
            end

            local offset = 0
            local lastElem = RH_ActionMenu_SelectActionPanel_SelectSkill
            local function resetX(elem, x, y)
                elem:ClearAllAnchors()
                elem:SetAnchor("TOP", "BOTTOM", lastElem, (x or 0) - offset, y or 5)

                offset = (x or 0)

                lastElem = elem
            end

            if ActionMenu.SelectMode == "SKILL" then resetX(RH_ActionMenu_SelectActionPanel_ScrollSelect, -15) end
            resetX(RH_ActionMenu_SelectActionPanel_SelectAction)
            if ActionMenu.SelectMode == "ACTION" then resetX(RH_ActionMenu_SelectActionPanel_ScrollSelect, -15) end
            resetX(RH_ActionMenu_SelectActionPanel_SelectExtra)
            if ActionMenu.SelectMode == "EXTRA" then resetX(RH_ActionMenu_SelectActionPanel_ScrollSelect, -15) end

            if not ActionMenu.SelectList then
                ActionMenu.SelectList = createList(ActionMenu.SelectMode)
                RH_ActionMenu_SelectActionPanel_ScrollSelect_Slider:SetValue(1)
            end

            RH_ActionMenu_SelectActionPanel_ScrollSelect:Show()

            ActionMenu.UpdateScrollSelect()
        end
    end
end

ActionMenu.OnHide = function()
    if ActionMenu.Callee then
        if ActionMenu.Callee.Show then
            ActionMenu.Callee:Show()
        end
        ActionMenu.Callee = nil
    end
end

ActionMenu.LoadAction = function(classToken, hotkey)
    ActionMenu.ClassToken = classToken
    ActionMenu.Hotkey = hotkey

    local action = {}
    if RaidHeal_Config and RaidHeal_Config.Hotkeys and RaidHeal_Config.Hotkeys[classToken] and RaidHeal_Config.Hotkeys[classToken][hotkey] then
        IO.DeepCopy(RaidHeal_Config.Hotkeys[classToken][hotkey], action)
    end
    ActionMenu.Action = action

    ActionMenu.SelectList = nil
end

ActionMenu.OnFreeTargetingChanged = function()
    ActionMenu.Action.FreeTargeting = RH_ActionMenu_DetailsPanel_Target_CheckBtnIsFree:IsChecked()
    ActionMenu.ShowAction()
end

ActionMenu.OnExpertTargetChanged = function()
    -- check for "(unit_clicked)"
    local expertsTarget = RH_ActionMenu_DetailsPanel_Target_EditExperts:GetText()
    if expertsTarget:len() >= 14 and expertsTarget:sub(1,14) == "(unit_clicked)" then
        ActionMenu.Action.FreeTargeting = false
        ActionMenu.Action.Target = expertsTarget:sub(15) or ""
    else
        ActionMenu.Action.FreeTargeting = true
        ActionMenu.Action.Target = expertsTarget
    end

    ActionMenu.ShowAction()
end

ActionMenu.CreateSelectTargetList = function()
    local lut = {
        { Target = "", Desc = ActionMenu.Action and ActionMenu.Action.FreeTargeting and "NONE" or "SELF" },
        { Target = "target", Desc = "TARGET" },
        { Target = "targettarget", Desc = "TARGET2" },
        { Target = "targettargettarget", Desc = "TARGET3" },
        { Target = "pet", Desc = "PET" },
    }

    for i = 1, #lut do
        local info = {
            text = IO.Format("AM_TARGET_" .. lut[i].Desc .. "_DESC"),
            func = function()
                ActionMenu.Action.Target = lut[i].Target
                ActionMenu.ShowAction()
            end,
            notCheckable = 1
        }
        UIDropDownMenu_AddButton(info)
    end
end

ActionMenu.Save = function()
    if not ActionMenu.Hotkey then error("No hotkey specified") end
    if not ActionMenu.ClassToken then error("No class token specified") end

    local action = {}
    action.Type = ActionMenu.Action.Type

    if action.Type ~= "MOVERAID" and action.Type ~= "DROPDOWN" then
        action.FreeTargeting = ActionMenu.Action.FreeTargeting
        action.Target = ActionMenu.Action.Target
    end

    if action.Type == "SKILL" then
        action.ID = ActionMenu.Action.ID
        action.Tab = ActionMenu.Action.Tab
        action.Index = ActionMenu.Action.Index
    elseif action.Type == "ACTION" then
        action.Slot = ActionMenu.Action.Slot
        action.SaveTarget = ActionMenu.Action.SaveTarget
        action.RestoreTarget = ActionMenu.Action.RestoreTarget
    end

    Hotkeys.SetAction(ActionMenu.Hotkey, ActionMenu.ClassToken, action)
    ActionMenu.Hide()

    if SkillMenu then
        SkillMenu.LoadSkills(SkillMenu.GetMainClass(), SkillMenu.GetSubClass(), RaidHeal_Config.Hotkeys)
    end
end

ActionMenu.SetSelectMode = function(newMode)
    ActionMenu.SelectMode = newMode
    ActionMenu.SelectList = nil
    ActionMenu.SelectListStartIndex = 1
end

ActionMenu.UpdateScrollSelect = function()
    if not ActionMenu.SelectList then
        ActionMenu.ShowAction()
        return
    end
    ActionMenu.SelectListStartIndex = RH_ActionMenu_SelectActionPanel_ScrollSelect_Slider:GetValue()

    for i = 1, 8 do
        local index = i + ActionMenu.SelectListStartIndex - 1
        local listItem = getglobal("RH_ActionMenu_SelectActionPanel_ScrollSelect_ListItem" .. i)

        if ActionMenu.SelectList[index] then
            listItem:Show()
            listItem.Icon:SetTexture(ActionMenu.SelectList[index].Texture)
            listItem.Text:SetText(ActionMenu.SelectList[index].Name)
        else
            listItem:Hide()
        end
    end

    RH_ActionMenu_SelectActionPanel_ScrollSelect_Slider:SetMinMaxValues(1, math.max(1, #ActionMenu.SelectList - 8))
    RH_ActionMenu_SelectActionPanel_ScrollSelect_Slider:SetValue(ActionMenu.SelectListStartIndex)
end

ActionMenu.OnScrollSelectClick = function(id)
    local dataIndex = ActionMenu.SelectListStartIndex + id - 1
    local data = ActionMenu.SelectList[dataIndex]

    ActionMenu.Action = data.Action
    ActionMenu.ShowAction()
end
