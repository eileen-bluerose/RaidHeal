local RaidHeal = _G.RaidHeal
local Menu = RaidHeal.Menu
local Colorizer = Menu.Colorizer

local IO = RaidHeal.IO
local Presets = RaidHeal.Presets

Colorizer.ShowMode = function(mode)
    local lut = {
        ClassColors = RH_Colorizer_ClassColors,
        ResourceColors = RH_Colorizer_ResourceColors,
        SingleColor = RH_Colorizer_SingleColor
    }

    for _, frame in pairs(lut) do
        frame:Hide()
    end

    local height = 100 + lut[mode]:GetHeight()
    RH_Colorizer:SetHeight(height)

    if mode == "ClassColors" then
        for i = 0,11 do
            local name, token = GetClassInfoByID(i)
            local colorOption = getglobal("RH_Colorizer_ClassColors_" .. token)

            colorOption._text:SetText(name)
            colorOption._colorbutton.R, colorOption._colorbutton.G, colorOption._colorbutton.B = unpack(Colorizer.Colors[token] or { 1, 1, 1 })
        end

        if not Colorizer.ColorIndex or Colorizer.ColorIndex ~= "SubClass" then Colorizer.ColorIndex = "MainClass" end
    elseif mode == "ResourceColors" then
        local lut = { "Mana", "Rage", "Focus", "Energy" }
        for i = 1,4 do
            local res = lut[i]
            local colorOption = getglobal("RH_Colorizer_ResourceColors_" .. res)

            colorOption._colorbutton.R, colorOption._colorbutton.G, colorOption._colorbutton.B = unpack(Colorizer.Colors[i] or { 1, 1, 1 })
        end

        if not Colorizer.ColorIndex or Colorizer.ColorIndex ~= "SPType" then Colorizer.ColorIndex = "MPType" end
    else
        local colorOption = RH_Colorizer_SingleColor

        colorOption._colorbutton.R, colorOption._colorbutton.G, colorOption._colorbutton.B = unpack(Colorizer.Color or { 1, 1, 1 })
    end

    lut[mode]:Show()
end

Colorizer.Show = function(config)
    Colorizer.Config = config
    if config.Colors then
        Colorizer.Color = nil
        --Colorizer.Colors = config.Colors
        Colorizer.Colors = {}
        IO.DeepCopy(config.Colors, Colorizer.Colors)
        Colorizer.ColorIndex = config.ColorIndex

        if config.ColorIndex == "MainClass" or config.ColorIndex == "SubClass" then
            -- ClassClors
            Colorizer.Mode = "ClassColors"
            Colorizer.ShowMode("ClassColors")
        else
            -- ResourceSolors
            Colorizer.Mode = "ResourceColors"
            Colorizer.ShowMode("ResourceColors")
        end
    else
        -- SingleColor
        Colorizer.Color = config.Color or { 1, 1, 1 }
        Colorizer.Colors = nil
        Colorizer.ColorIndex = nil

        Colorizer.Mode = "SingleColor"
        Colorizer.ShowMode("SingleColor")
    end

    RH_Colorizer:Show()
end

Colorizer.Save = function()
    if Colorizer.Mode == "SingleColor" then
        Colorizer.Config.Color = Colorizer.Color
        Colorizer.Config.ColorIndex = nil
        Colorizer.Config.Colors = nil
    else
        Colorizer.Config.Color = nil
        Colorizer.Config.ColorIndex = Colorizer.ColorIndex

        Colorizer.Config.Colors = {}
        IO.DeepCopy(Colorizer.Colors, Colorizer.Config.Colors)
        if not next(Colorizer.Config.Colors) then Colorizer.Config.Colors = nil end
    end
end

Colorizer.LoadPreset = function(presetID)
    if Colorizer.Mode == "SingleColor" then return end
    Colorizer.Colors = Presets.Load({ _preset = { Type = Colorizer.Mode, ID = presetID }}, true)

    Colorizer.ShowMode(Colorizer.Mode)
end

Colorizer.SaveAsPreset = function(presetID)
    if Colorizer.Mode == "SingleColor" then return end

    local presetTemplate = {
        [presetID] = {}
    }
    IO.DeepCopy(Colorizer.Colors, presetTemplate[presetID])
    if presetTemplate[presetID]._preset then presetTemplate[presetID]._preset = nil end

    if not RaidHeal_GlobalConfig.Presets then RaidHeal_GlobalConfig.Presets = {} end
    if not RaidHeal_GlobalConfig.Presets[Colorizer.Mode] then RaidHeal_GlobalConfig.Presets[Colorizer.Mode] = {} end
    IO.DeepCopy(presetTemplate, RaidHeal_GlobalConfig.Presets[Colorizer.Mode])
end