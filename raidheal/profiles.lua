local RaidHeal = _G.RaidHeal
local Profiles = RaidHeal.Profiles
local Presets = RaidHeal.Presets
local Config = RaidHeal.Config
local IO = RaidHeal.IO
local Events = RaidHeal.Events

local _FILENAME_ = "profiles.lua"

Profiles.KnownList = {}
Profiles.LoadedProfile = nil

Profiles.LoadFromArray = function(array, overwrite)
    if not array then return end

    for name, profile in pairs(array) do
        if Profiles.KnownList[name] and not overwrite then
            Log.Error(_FILENAME_, "Error: Profile \"" .. name .. "\" is already loaded")
        else
            Profiles.KnownList[name] = profile
        end
    end
end

Profiles.LoadProfile = function(profileName)
    if not profileName or not Profiles.KnownList[profileName] then error("Error: Need a valid profile name to load one") return end
    local profile = Profiles.KnownList[profileName]

    for k, v in pairs(Config) do -- clear Config, but keep existing table
        Config[k] = nil
    end

    local loadedProfile = Presets.Load(profile, true)
    IO.DeepCopy(loadedProfile, Config)

    Profiles.LoadedProfile = profileName
    Events.DoEvent("PROFILE_LOADED", profileName)
end

Profiles.LoadFile = function(fileName, permanent)
    local profileList = IO.LoadFile("config/"..fileName)

    if profileList and permanent then
        Profiles.LoadFromArray(profileList)
    end

    return profileList
end

Profiles.LoadConfig = function(overwrite)
    if not RaidHeal_GlobalConfig.Profiles then return end

    Profiles.LoadFromArray(RaidHeal_GlobalConfig.Profiles, overwrite)
end

Profiles.Load = function()
    if not RaidHeal_GlobalConfig.VERSION then
        RaidHeal_GlobalConfig = { VERSION = RaidHeal.VERSION }
    end
    if not RaidHeal_Config.VERSION then
        RaidHeal_Config = { VERSION = RaidHeal.VERSION }
    end

    local defaultProfiles = Profiles.LoadFile("profiles.lua", true)
    if next(defaultProfiles) == nil or not defaultProfiles.Default then
        error("Couln't find a default profile")
        return
    end

    Profiles.LoadConfig(true)
    local profileName = RaidHeal_Config and RaidHeal_Config.Profile or "Default"
    Profiles.LoadProfile(profileName)
end

Profiles.Save = function()
    local currentProfile = Profiles.LoadedProfile

    if not RaidHeal_GlobalConfig.Profiles then RaidHeal_GlobalConfig.Profiles = {} end
    RaidHeal_GlobalConfig.Profiles[currentProfile] = Presets.Save(RaidHeal.Config)
    RaidHeal_Config.Profile = currentProfile

    RaidHeal_Config.VERSION = RaidHeal.VERSION
    RaidHeal_GlobalConfig.VERSION = RaidHeal.VERSION
end

Profiles.Export = function(profileName)
    if not profileName or type(profileName) ~= "string" or not Profiles.KnownList[profileName] then error("Profiles.Export: Argument 'profileName' is invalid", 2) return end

    local profiles = {}
    profiles[profileName] = Profiles.KnownList[profileName]

    local presets = {}
    local presetsToCheck = {}
    local function checkForPreset(table)
        if table._preset then
            if not (presets[table._preset.Type] and presets[table._preset.Type][table._preset.ID]) then
                presetsToCheck[#presetsToCheck+1] = table._preset
            end
        end

        for key, value in pairs(table) do
            if type(value) == "table" and key ~= "_preset" then
                checkForPreset(value)
            end
        end
    end

    checkForPreset(profiles[profileName])
    local preset = table.remove(presetsToCheck)
    while preset ~= nil do
        local presetData = Presets.LoadPreset(preset.Type, preset.ID)
        if not presets[preset.Type] then
            presets[preset.Type] = {
                [preset.ID] = presetData
            }
        else
            presets[preset.Type][preset.ID] = presetData
        end
        checkForPreset(presetData)
        preset = table.remove(presetsToCheck)
    end

    return profiles, presets
end

Profiles.Import = function(fileName, overwrite)
    local profiles, presets = IO.LoadFile("config/"..fileName)

    Profiles.LoadFromArray(profiles, overwrite)

    for presetType, data in pairs(presets) do
        if not Presets.DB[presetType] then
            Presets.DB[presetType] = data
        else
            for presetID, preset in pairs(data) do
                if Presets.DB[presetType][presetID] and not overwrite then
                    error("Profile.Import: Preset { Type = \"" .. presetType .. "\", ID = \"" .. presetID .. "\" } already exists")
                else
                    Presets.DB[presetType][presetID] = preset
                end
            end
        end
    end
end

local loaded = false
local function onload()
    if not loaded then
        Profiles.Load()
        loaded = true
    end
    Events.Release("LOADING_END", onload)
end
Events.Register("VARIABLES_LOADED", onload)
Events.Register("LOADING_END", onload)
Events.Register("SAVE_VARIABLES", Profiles.Save)
