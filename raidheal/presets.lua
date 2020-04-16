local RaidHeal = _G.RaidHeal
local Config = RaidHeal.Config
local Presets = RaidHeal.Presets
local IO = RaidHeal.IO

Presets.DB = IO.LoadFile("config/presets.lua", true)

Presets.LoadPreset = function(presetType, presetID)
    local function checkForPreset(data)
        return data and data[presetType] and data[presetType][presetID] or nil
    end
    local preset = (RaidHeal_GlobalConfig.Presets and checkForPreset(RaidHeal_GlobalConfig.Presets)) or (RaidHeal_Config.Presets and checkForPreset(RaidHeal_Config.Presets)) or checkForPreset(Presets.DB)

    return preset
end

Presets.Load = function(profile, deep)
    if not profile then error("Invalid Argument #1 for Presets.Load", 2) end
    local result = {}

    if profile._preset then
        local preset = Presets.Load(Presets.LoadPreset(profile._preset.Type, profile._preset.ID), false)
        IO.DeepCopy(preset, result)
    end

    IO.DeepCopy(profile, result)

    if deep then
        for key, value in pairs(result) do
            if type(value) == "table" then
                result[key] = Presets.Load(value, deep)
            end
        end
    end

    return result
end

Presets.SavePreset = function(preset)
    if not preset._preset then return end

    local presetBase = Presets.Load(Presets.LoadPreset(preset._preset.Type, preset._preset.ID), true)

    local result = IO.StripCopy(preset, presetBase)
    result._preset = preset._preset
    return result
end

Presets.Save = function(profile)
    if not profile then return end
    local savedProfile = {}

    for key, value in pairs(profile) do
        if type(value) == "table" then
            if value._preset then
                savedProfile[key] = Presets.SavePreset(value)
            else
                savedProfile[key] = Presets.Save(value)
            end
        else
            savedProfile[key] = value
        end
    end

    if next(savedProfile) == nil then savedProfile = nil end
    return savedProfile
end
