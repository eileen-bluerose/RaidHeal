local RaidHeal = _G.RaidHeal
local UI = RaidHeal.UI

local Log = RaidHeal.Log
local IO = RaidHeal.IO
local Presets = RaidHeal.Presets
local Frames = RaidHeal.Frames
local Tasks = RaidHeal.Tasks

local _FILENAME_ = "ui/ui.lua"

UI.UpdateUnit = function(unitFrame, unitData, config)
    if not unitData or not unitData.UnitID then
        unitFrame:Hide()
        unitFrame.UnitID = ""
    else
        local function getColor(colorConfig)
            if colorConfig.Colors then
                if colorConfig.ColorIndex and unitData[colorConfig.ColorIndex] then
                    return colorConfig.Colors[unitData[colorConfig.ColorIndex]] or { 1, 1, 1 }
                end
            end

            if colorConfig.Color then return colorConfig.Color end
            return { 1, 1, 1 }
        end

        -------------------------------------------------------------------------

        local function updateBar(bar, curValue, maxValue)
            local barAlign = config[bar].BarAlign

            if barAlign == "LEFT" or barAlign == "RIGHT" then
                unitFrame[bar].Bar:SetWidth(curValue/maxValue * (unitFrame[bar]:GetWidth() - config[bar].Padding))
            else
                unitFrame[bar].Bar:SetHeight(curValue/maxValue * (unitFrame[bar]:GetHeight() - config[bar].Padding))
            end

            local barColor = getColor(config[bar])
            unitFrame[bar].Bar:SetColor(unpack(barColor))
        end

        -------------------------------------------------------------------------

        local function updateBuffIcon(buffIcon, buffData, buffConfig)
            if buffData then
                buffIcon.Icon:SetTexture(buffData.Texture)

                if buffConfig.ShowCDTimer then
                    buffIcon.Icon:SetCooldown(buffData.TimeMax, buffData.TimeLeft)
                end

                if buffIcon.StackCount and buffConfig.ShowStackCount and buffData.StackCount then
                    buffIcon.StackCount:SetText(tostring(buffData.StackCount))
                elseif buffIcon.StackCount then
                    buffIcon.StackCount:SetText("")
                end

                buffIcon:Show()
            else
                buffIcon.Icon:SetCooldown(0, 0)
                buffIcon:Hide()
            end
        end

        -------------------------------------------------------------------------

        local function updateTextDisplay(display, text, displayConfig)
            display.Text:SetText(text)

            local displayColor = getColor(displayConfig)
            display.Text:SetColor(unpack(displayColor))
        end

        -------------------------------------------------------------------------

        local function createInterpolateTimer(highlight)
            local timerName = "interpolate_"..highlight:GetName()

            local up = false
            local curAlpha = config.Highlight.MaxAlpha

            local timeFunc = function(dTime)
                local delta = dTime / config.Highlight.Timeout * (config.Highlight.MaxAlpha - config.Highlight.MinAlpha)

                if up then
                    curAlpha = curAlpha + delta

                    if curAlpha > config.Highlight.MaxAlpha then
                        curAlpha = 2 * config.Highlight.MaxAlpha - curAlpha
                        up = false
                    end
                else
                    curAlpha = curAlpha - delta

                    if curAlpha < config.Highlight.MinAlpha then
                        curAlpha = 2 * config.Highlight.MinAlpha - curAlpha
                        up = true
                    end
                end

                highlight:SetAlpha(curAlpha)
            end

            Tasks.Add(timeFunc, 0, 0, true, timerName)

            return timerName
        end

        local function checkHighlight(highlight, param)
            if unitFrame[highlight] then
                if unitData[param] then
                    if not unitFrame[highlight].Timer then
                        unitFrame[highlight]:Show()
                        unitFrame[highlight].Timer = createInterpolateTimer(unitFrame[highlight])
                    end
                else
                    if unitFrame[highlight].Timer then
                        Tasks.Remove(unitFrame[highlight].Timer)
                        unitFrame[highlight].Timer = nil
                    end
                    unitFrame[highlight]:Hide()
                end
            end
        end

        -------------------------------------------------------------------

        for elemName, elemData in pairs(config) do
            if elemData and type(elemData) == "table" then
                if elemData._preset then
                    local elemType = elemData._preset.Type

                    if elemType == "BarSettings" then
                        if unitFrame[elemName] then
                            updateBar(elemName, unitData[elemData.ParamCur] or 0, unitData[elemData.ParamMax] or 1)
                        end
                    elseif elemType == "DisplaySettings" then
                        local text = ""

                        if elemData.FormatFunc then
                            local formatFunc = IO.FormatFuncs
                            if formatFunc and formatFunc[elemData.FormatFunc.Type] then
                                formatFunc = formatFunc[elemData.FormatFunc.Type]
                                if formatFunc and formatFunc[elemData.FormatFunc.Mode] then
                                    formatFunc = formatFunc[elemData.FormatFunc.Mode]

                                    local args = {}
                                    for i = 1, #elemData.FormatFunc.Args do
                                        args[i] = unitData[elemData.FormatFunc.Args[i]]
                                    end

                                    text = formatFunc(unpack(args))
                                end
                            end
                        elseif elemData.Param then
                            local param = elemData.Param
                            text = tostring(unitData[param])
                        end

                        if unitFrame[elemName] then
                            updateTextDisplay(unitFrame[elemName], text, elemData)
                        end
                    elseif elemType == "HighlightSettings" then
                        checkHighlight(elemName, elemData.Param)
                    else
                        Log.Error(_FILENAME_, "UI.UpdateUnit: " .. unitFrame:GetName() .. ": Unknown preset type: " .. elemType)
                    end
                else
                    if elemName == "Buffs" and config.Buffs and config.Buffs.Count > 0 and unitFrame.Buffs then
                        for i = 1, config.Buffs.Count do
                            if unitFrame.Buffs[i] then
                                updateBuffIcon(unitFrame.Buffs[i], unitData.Buffs and unitData.Buffs[i] or nil, config.Buffs[i])
                            else
                                Log.Warning(_FILENAME_, "Buff #%d not found on unit frame '%s'", i, unitFrame:GetName())
                            end
                        end
                    elseif elemName == "Debuffs" and config.Debuffs and config.Debuffs.Count > 0 and unitFrame.Debuffs then
                        for i = 1, config.Debuffs.Count do
                            if unitFrame.Debuffs[i] then
                                updateBuffIcon(unitFrame.Debuffs[i], unitData.Debuffs and unitData.Debuffs[i] or nil, config.Debuffs[i])
                            else
                                Log.Warning(_FILENAME_, "Debuff #%d not found on unit frame '%s'", i, unitFrame:GetName())
                            end
                        end
                    else
                        -- nothing yet
                    end
                end
            end
        end

        -------------------------------------------------------------------

        unitFrame.UnitID = unitData.UnitID
        unitFrame:Show()
    end
end

UI.CreateTemplateFromConfig = function(basePreset, config)
    local template = Presets.Load(Presets.LoadPreset("FrameTemplates", basePreset), true)

    if not template.Elements then template.Elements = {} end

    local function check(table)
        local result = {}

        if table.Template then
            return table.Template
        end

        for key, value in pairs(table) do
            if type(value) == "table" then
                result[key] = check(value)
            end
        end

        if next(result) == nil then result = nil end
        return result
    end

    IO.DeepCopy(check(config), template.Elements)
    if next(template.Elements) == nil then template.Elements = nil end

    return template
end

UI.ArrangeUnit = function(unitFrame, config)
    local lutBars = { "HealthBar", "ManaBar", "SkillBar" }

    local function checkBar(barType)
        local bar = unitFrame[barType]
        local barConfig = config[barType]

        if not bar or not barConfig then return end

        local offsetX, offsetY = 0, 0

        if barConfig.BarAlign == "LEFT" or barConfig.BarAlign == "RIGHT" then
            offsetX = barConfig.Padding / 2
        else
            offsetY = barConfig.Padding / 2
        end

        bar.Bar:ClearAllAnchors()
        bar.Bar:SetAnchor(barConfig.BarAlign, barConfig.BarAlign, bar, offsetX, offsetY)
        bar.Bar:SetSize(bar:GetWidth() - barConfig.Padding, bar:GetHeight() - barConfig.Padding)
    end

    for _, barType in pairs(lutBars) do
        if unitFrame[barType] then checkBar(barType) end
    end

    --------------------------------------------------------------
end

UI.SetUnitScripts = function(unitFrame, index)
    unitFrame:SetScripts("OnMouseDown", "RaidHeal.UI.Handlers.OnUnitMouseDown(this, key, "..index..")")
    unitFrame:SetScripts("OnMouseUp", "RaidHeal.UI.Handlers.OnUnitMouseUp(this, "..index..")")
    unitFrame:SetScripts("OnEnter", "RaidHeal.UI.Handlers.OnUnitEnter(this, "..index..")")
    unitFrame:SetScripts("OnLeave", "RaidHeal.UI.Handlers.OnUnitLeave(this, "..index..")")

    unitFrame:SetMouseEnable(true)
    unitFrame:RegisterForClicks("LeftButton", "RightButton", "MiddleButton")
end

UI.InitUnits = function(units, config, backFrame, template, name)
    local numGroups = math.ceil((config.MaxNumUnits or 36) / (config.UnitsPerGroup or 6))
    local unitWidth, unitHeight = backFrame:GetSize()
    local anchorPoint = config.GroupAlign .. config.UnitAlign

    if config.GroupAlign == "BOTTOM" or config.GroupAlign == "TOP" then
        unitHeight = (unitHeight - (numGroups - 1) * config.Spacing.Vertical) / numGroups
        unitWidth = (unitWidth - (config.UnitsPerGroup - 1) * config.Spacing.Horizontal) / config.UnitsPerGroup
    else
        unitWidth = (unitWidth - (numGroups - 1) * config.Spacing.Horizontal) / numGroups
        unitHeight = (unitHeight - (config.UnitsPerGroup - 1) * config.Spacing.Vertical) / config.UnitsPerGroup
        anchorPoint = config.UnitAlign .. config.GroupAlign
    end

    for i = 1, config.MaxNumUnits do
        if not units[i] then
            units[i] = Frames.CreateFromTemplate(template, name..i, backFrame:GetName())
            UI.SetUnitScripts(units[i], i)
        end

        local unit = units[i]
        unit:SetSize(unitWidth, unitHeight)

        local offsetX, offsetY = 0, 0
        local group, place = math.ceil(i / config.UnitsPerGroup) - 1, (i - 1) % config.UnitsPerGroup
        if config.GroupAlign == "TOP" or config.GroupAlign == "BOTTOM" then
            offsetY = group * (unitHeight + config.Spacing.Vertical)
            offsetX = place * (unitWidth + config.Spacing.Horizontal)

            if config.GroupAlign == "BOTTOM" then offsetY = -offsetY end
            if config.UnitAlign == "RIGHT" then offsetX = -offsetX end
        else
            offsetX = group * (unitWidth + config.Spacing.Horizontal)
            offsetY = place * (unitHeight + config.Spacing.Vertical)

            if config.GroupAlign == "RIGHT" then offsetX = -offsetX end
            if config.UnitAlign == "BOTTOM" then offsetY = -offsetY end
        end

        unit:ClearAllAnchors()
        unit:SetAnchor(anchorPoint, anchorPoint, backFrame, offsetX, offsetY)

        Frames.Arrange(unit, template)
        UI.ArrangeUnit(unit, config.Unit)
    end
end
