local Config = _G.RaidHeal.Config
local Events = _G.RaidHeal.Events
local IO = _G.RaidHeal.IO

local defaultConfig = {}

function Config.LoadDefault()
    local path = string.format(Config._path, Config._defaultName)
    defaultConfig = IO.LoadFile(path)

    IO.DeepCopy(defaultConfig, Config)
end

function Config.LoadFile(path, reload)
    if reload then Config.LoadDefault() end

    local configFile = IO.LoadFile(path)
    if not configFile then return end

    IO.DeepCopy(configFile, Config)

    Events.DoEvent("CONFIG_LOADED", path)
end

function Config.Load()
    IO.DeepCopy(RaidHeal_GlobalConfig, Config)
    IO.DeepCopy(RaidHeal_Config, Config)

    if RH_MiniMapButton and not AddonManager then
        RH_MiniMapButton:Show()
    end

    Events.DoEvent("CONFIG_LOADED")
end

function Config.Save()
    Events.DoEvent("CONFIG_SAVE")
    Config.Version = RaidHeal._VERSION

    RaidHeal_Config = {}
    IO.DeepCopy(Config, RaidHeal_Config)
    RaidHeal_Config = IO.StripCopy(RaidHeal_Config, RaidHeal_GlobalConfig)
    RaidHeal_Config = IO.StripCopy(RaidHeal_Config, defaultConfig)
end

function Config.SaveExtern()
    -- TODO
    IO.Print("ERROR_NOT_IMPLEMENTED", "Config.SaveExtern")
end

function Config.Init()
    if not Config._loaded then Config.Load() Config._loaded = true end
end

Config.LoadDefault()
Events.Register("LOADING_END", Config.Init)
Events.Register("SAVE_VARIABLES", Config.Save)
