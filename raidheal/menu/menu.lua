local RaidHeal = _G.RaidHeal
local Menu = RaidHeal.Menu
local IO = RaidHeal.IO
local Locale = RaidHeal.Locale

local function getValue(path)
    local value = _G
    for key in string.gfind(path, "[%w_]+") do
        key = tonumber(key) or key
        if not value[key] then
            return nil
        else
            value = value[key]
        end
    end
    return value
end

local function setValue(path, value)
    local t = _G
    for key, sep in string.gfind(path, "([%w_]+)(.?)") do
        key = tonumber(key) or key
        if sep == "." then
            t[key] = t[key] or {}
            t = t[key]
        else
            t[key] = value
        end
    end
end

local function getText(textID)
    local desc = Locale.Messages[textID .. "_DESC"] or textID
    local tooltip = Locale.Messages[textID .. "_TOOLTIP"] or nil

    return desc, tooltip
end

Menu.Bind = function(frame, path, callback)
    if not frame._bind then frame._bind = {} end
    frame._bind.Path = path
    frame._bind.CallBack = callback
end

Menu.LoadText = function(frame, textID)
    frame._loadText = { TextID = textID }
end

Menu.ShowBoundElement = function(frame)
    local lut_optionTypes = {
        CheckButton = function()
            local checkButton = frame._checkButton or frame
            checkButton:Enable()
            checkButton:SetChecked(getValue(frame._bind.Path) and true or false)
            if frame._disable then checkButton:Disable() end
        end,
        DropDownButton = function()
            local button = frame._button or frame
            local value = getValue(frame._bind.Path)
            Menu.ChangeDropDownValue(frame, value)
            if frame._disable then button:Disable() else button:Enable() end
        end,
        EditBox = function()
            local editBox = frame._editBox or frame

            local value = getValue(frame._bind.Path) or ""
            editBox:SetText(value)
            if frame._disable then editBox:Disable() else editBox:Enable() end
        end,
        Color = function()
            local colorbutton = frame._colorbutton or frame
            colorbutton.R, colorbutton.G, colorbutton.B = unpack(getValue(frame._bind.Path) or { 1, 1, 1 })
            colorbutton.Display:SetColor(colorbutton.R, colorbutton.G, colorbutton.B)

            if frame._disable then colorbutton.Display:Hide() else colorbutton.Display:Show() end
        end
    }

    if frame._bind.Disable then
        frame._disable = getValue(frame._bind.Disable) and true or false
    elseif frame._bind.DisableIfNot then
        local check = getValue(frame._bind.DisableIfNot)
        frame._disable = (not check) and true or false
    end

    if frame._type and lut_optionTypes[frame._type] then
        lut_optionTypes[frame._type]()
    else
        IO.PrintError("Error in RaidHeal.Menu.ShowBoundElement: " .. frame:GetName() .. " cannot be identified")
    end
end

Menu.UpdateBoundElement = function(frame)
    local function checkCallBack(value)
        if frame._bind.CallBack then frame._bind.CallBack(value) end
    end

    local lut_OptionTypes = {
        CheckButton = function()
            local checkButton = frame._checkButton or frame
            local value = checkButton:IsChecked()

            setValue(frame._bind.Path, value)
            checkCallBack(value)
        end,
        DropDownButton = function()
            local button = frame._button or frame
            local value = button.Value

            setValue(frame._bind.Path, value)
            checkCallBack(value)
        end,
        EditBox = function()
            local editBox = frame._editBox or frame
            local value = editBox:GetText()
            value = tonumber(value) or value

            setValue(frame._bind.Path, value)
            checkCallBack(value)
        end,
        Color = function()
            local colorbutton = frame._colorbutton or frame
            local cpf = ColorPickerFrame
            value = { cpf.r, cpf.g, cpf.b }

            setValue(frame._bind.Path, value)
            colorbutton.R, colorbutton.G, colorbutton.B = unpack(value)
            checkCallBack(value)
        end
    }

    if lut_OptionTypes[frame._type] then
        lut_OptionTypes[frame._type]()
    end
end

Menu.ShowText = function(frame)
    local text, tooltipText = getText(frame._loadText.TextID)

    if text then
        if frame._text then
            frame._text:SetText(text)

            if frame._disable then
                frame._text:SetColor(0.33, 0.33, 0.33)
            else
                frame._text:SetColor(1, 1, 1)
            end
        elseif frame.SetText then
            frame:SetText(text)
        end
    end
    if tooltipText then frame.tooltip = tooltipText end
end

Menu.ShowTooltip = function(frame)
    GameTooltip:ClearAllAnchors()
    GameTooltip:SetAnchor("LEFT", "RIGHT", frame)
    GameTooltip:SetText(frame.tooltip)
    GameTooltip:Show()
end

Menu.HideTooltip = function(frame)
    GameTooltip:Hide()
end

Menu.LoadDropDownList = function(frame, name)
    local lut_DropDownLists = {
        FourDirections = {
            {
                TOP = { Display = "CM_DDM_ANCHORPOINTS_TOP" },
                BOTTOM = { Display = "CM_DDM_ANCHORPOINTS_BOTTOM" },
                LEFT = { Display = "CM_DDM_ANCHORPOINTS_LEFT" },
                RIGHT = { Display = "CM_DDM_ANCHORPOINTS_RIGHT" }
            },
            {
                Order = { "TOP", "BOTTOM", "LEFT", "RIGHT" }
            }
        },
        TwoDirections_Horizontal = {
            {
                LEFT = { Display = "CM_DDM_ANCHORPOINTS_LEFT" },
                RIGHT = { Display = "CM_DDM_ANCHORPOINTS_RIGHT" }
            },
            {
                Order = { "LEFT", "RIGHT" }
            }
        },
        TwoDirections_Vertical = {
            {
                TOP = { Display = "CM_DDM_ANCHORPOINTS_TOP" },
                BOTTOM = { Display = "CM_DDM_ANCHORPOINTS_BOTTOM" },
            },
            {
                Order = { "TOP", "BOTTOM" }
            }
        },
        AnchorPoints9 = {
            {
                TOPLEFT = { Display = "CM_DDM_ANCHORPOINTS_TOPLEFT" },
                TOP = { Display = "CM_DDM_ANCHORPOINTS_TOP" },
                TOPRIGHT = { Display = "CM_DDM_ANCHORPOINTS_TOPRIGHT" },
                LEFT = { Display = "CM_DDM_ANCHORPOINTS_LEFT" },
                CENTER = { Display = "CM_DDM_ANCHORPOINTS_CENTER" },
                RIGHT = { Display = "CM_DDM_ANCHORPOINTS_RIGHT" },
                BOTTOMLEFT = { Display = "CM_DDM_ANCHORPOINTS_BOTTOMLEFT" },
                BOTTOM = { Display = "CM_DDM_ANCHORPOINTS_BOTTOM" },
                BOTTOMRIGHT = { Display = "CM_DDM_ANCHORPOINTS_BOTTOMRIGHT" }
            },
            {
                Order = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" }
            }
        },
        Dock4 = {
            {
                TOP = { Display = "CM_DDA_TOP" },
                BOTTOM = { Display = "CM_DDA_BOTTOM" },
                LEFT = { Display = "CM_DDA_LEFT" },
                RIGHT = { Display = "CM_DDA_RIGHT" },
                FILL = { Display = "CM_DDA_DOCKFILL" }
            },
            {
                Order = { "TOP", "BOTTOM", "LEFT", "RIGHT" }
            }
        },
        Dock5 = {
            {
                TOP = { Display = "CM_DDA_TOP" },
                BOTTOM = { Display = "CM_DDA_BOTTOM" },
                LEFT = { Display = "CM_DDA_LEFT" },
                RIGHT = { Display = "CM_DDA_RIGHT" },
                FILL = { Display = "CM_DDA_DOCKFILL" }
            },
            {
                Order = { "TOP", "BOTTOM", "LEFT", "RIGHT", "FILL" }
            }
        },
        AnchorEdges4 = {
            {
                TOPLEFT = { Display = "CM_DDA_TOPLEFT" },
                TOPRIGHT = { Display = "CM_DDA_TOPRIGHT" },
                BOTTOMLEFT = { Display = "CM_DDA_BOTTOMLEFT" },
                BOTTOMRIGHT = { Display = "CM_DDA_BOTTOMRIGHT" }
            },
            {
                Order = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" }
            }
        },
        AnchorSides4 = {
            {
                LEFT = { Display = "CM_DDA_LEFT" },
                RIGHT = { Display = "CM_DDA_RIGHT" },
                TOP = { Display = "CM_DDA_TOP" },
                BOTTOM = { Display = "CM_DDA_BOTTOM" }
            },
            {
                Order = { "TOP", "BOTTOM", "LEFT", "RIGHT" }
            }
        },
        Anchors9 = {
            {
                LEFT = { Display = "CM_DDA_LEFT" },
                RIGHT = { Display = "CM_DDA_RIGHT" },
                TOP = { Display = "CM_DDA_TOP" },
                BOTTOM = { Display = "CM_DDA_BOTTOM" },
                CENTER = { Display = "CM_DDA_CENTER" },
                TOPLEFT = { Display = "CM_DDA_TOPLEFT" },
                TOPRIGHT = { Display = "CM_DDA_TOPRIGHT" },
                BOTTOMLEFT = { Display = "CM_DDA_BOTTOMLEFT" },
                BOTTOMRIGHT = { Display = "CM_DDA_BOTTOMRIGHT" }
            },
            {
                Order = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" }
            }
        },
        AnchorSides2H = {
            {
                LEFT = { Display = "CM_DDA_LEFT" },
                RIGHT = { Display = "CM_DDA_RIGHT" },
            },
            {
                Order = { "LEFT", "RIGHT" }
            }
        },
        AnchorSides2V = {
            {
                TOP = { Display = "CM_DDA_TOP" },
                BOTTOM = { Display = "CM_DDA_BOTTOM" },
            },
            {
                Order = { "TOP", "BOTTOM" }
            }
        },
        FilterModes = {
            {
                Normal = { Display = "Normal" },
                ParamsWhiteList = { Display = "ParamsWhiteList" },
                ParamsBlackList = { Display = "ParamsBlackList" },
                WhiteListOnly = { Display = "WhiteListOnly" }
            },
            {
                Order = { "Normal", "ParamsWhiteList", "ParamsBlackList", "WhiteListOnly" }
            }
        },
        COLORIZER_DYNAMIC = {
            {
                ResourceColors = { Display = "COLORIZER_RES_TITLE" },
                ClassColors = { Display = "COLORIZER_CLS_TITLE" },
                SingleColor = { Display = "COLORIZER_SINGLE_TITLE" }
            },
            {
                Order = { "SingleColor", "ClassColors", "ResourceColors" }
            }
        },
        COLORIZER_INDEX_CLS = {
            {
                MainClass = { Display = "COLORIZER_CLS_MAIN" },
                SubClass = { Display = "COLORIZER_CLS_SEC" }
            },
            {
                Order = { "MainClass", "SubClass" }
            }
        },
        COLORIZER_INDEX_RES = {
            {
                SPType = { Display = "COLORIZER_RES_SKILLTYPE" },
                MPType = { Display = "COLORIZER_RES_MANATYPE" }
            },
            {
                Order = { "MPType", "SPType" }
            }
        }
    }

    if not frame._bind then frame._bind = {} end

    if lut_DropDownLists[name] then
        frame._bind.DropDownData = lut_DropDownLists[name][1]
        frame._bind.DropDownDetails = lut_DropDownLists[name][2]

        local function createDropDown()
            for i = 1, #frame._bind.DropDownDetails.Order do
                local value = frame._bind.DropDownDetails.Order[i]
                local data = frame._bind.DropDownData[value]

                if value and data then
                    local info = {
                        text = (getText(data.Display)),
                        notCheckable = 1,
                        value = value,
                        func = function()
                            Menu.ChangeDropDownValue(frame, value)
                            Menu.UpdateBoundElement(frame)
                        end,
                        owner = frame._button
                    }
                    UIDropDownMenu_AddButton(info)
                end
            end
        end

        UIDropDownMenu_Initialize(frame._button, createDropDown)
    end
end

Menu.ChangeDropDownValue = function(frame, newValue)
    if not frame._bind.DropDownData then
        frame._button:SetText(tostring(newValue))
        return
    end

    if not frame._bind.DropDownData[newValue] then
        IO.PrintError("Unknown value \"" .. tostring(newValue) .. "\" for " .. frame:GetName())
    else
        local button = frame._button or frame
        button.Value = newValue

        local displayText = frame._bind.DropDownData[newValue] and getText(frame._bind.DropDownData[newValue].Display) or tostring(newValue)
        button:SetText(displayText)
    end
end

Menu.CreateDropDownList = function(frame, dropDownCreateFunc)
    local button = frame._button or frame
    UIDropDownMenu_Initialize(button, dropDownCreateFunc)
end

Menu.UpdateList = function(list)
    if not list or not list._listData then return end

    local data = list._listData.FillListCallBack and list._listData.FillListCallBack() or list._listData.FillListData
    if not data then data = {} end
    list._listData.FillListData = data

    for i = 1, #list._listItems do
        local index = list._listData.Offset + i
        local listItem = list._listItems[i]

        if data[index] then
            listItem._text:SetText(Menu.GetText(data[index].Display))
            listItem.tooltip = data[index].Tooltip
            listItem.selected = list._listData.SelectedIndices[index]

            if listItem.selected or listItem._isMouseOver then
                listItem._highlight:Show()
            else
                listItem._highlight:Hide()
            end

            listItem:Show()
        else
            listItem:Hide()
        end
    end
end

Menu.UpdateListItems = function(list)
    if not list or not list._listItems then return end

    list._listItems[1]:ClearAllAnchors()
    list._listItems[1]:SetAnchor("TOPLEFT", "TOPLEFT", list, 0, 0)
    list._listItems[1]:SetAnchor("TOPRIGHT", "TOPRIGHT", list, -19, 0)

    for i = 2, #list._listItems do
        list._listItems[i]:ClearAllAnchors()
        list._listItems[i]:SetAnchor("TOPLEFT", "BOTTOMLEFT", list._listItems[i-1], 0, 0)
        list._listItems[i]:SetAnchor("TOPRIGHT", "BOTTOMRIGHT", list._listItems[i-1], 0, 0)
    end
end

Menu.SelectListItem = function(list, listItem)
    if not list or not listItem or not list._listData then return end

    local listItemIndex = 0
    if type(listItem) == "number" then
        listItemIndex = listItem
    elseif type(listItem) == "table" and listItem.GetID then
        listItemIndex = list._listData.Offset + listItem:GetID()
    else
        IO.PrintError("Invalid param 'listItem' (" .. tostring(listItem) .. ")")
        return
    end

    if IsCtrlKeyDown() then
        list._listData.SelectedIndices[listItemIndex] = not list._listData.SelectedIndices[listItemIndex]
    else
        if list._listData.SelectedIndices[listItemIndex] then
            list._listData.SelectedIndices[listItemIndex] = nil
        else
            list._listData.SelectedIndices = { [listItemIndex] = true }
        end
    end
    if list._listItems and list._listItems[listItemIndex] then
        list._listItems[listItemIndex].selected = list._listData.SelectedIndices[listItemIndex]
    end

    Menu.UpdateList(list)
end

Menu.RegisterListItem = function(list, listItem, index)
    if not list or not listItem or not index then return end

    if not list._listItems then list._listItems = {} end
    list._listItems[index] = listItem
end

Menu.CreateList = function(list)
    if not list then return end

    if not list._listData then list._listData = {} end

    list._listData.Offset = 0
    list._listData.SelectedIndices = {}
end

Menu.GetValue = getValue
Menu.SetValue = setValue
Menu.GetText = getText
