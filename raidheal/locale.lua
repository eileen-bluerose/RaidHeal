local Locale = _G.RaidHeal.Locale
local IO = _G.RaidHeal.IO
local Config = _G.RaidHeal.Config
local Events = _G.RaidHeal.Events

if not Locale or Locale == nil then SendSystemChat("|cffff0000Error initializing RaidHeal.Locale") end

Locale.Messages = {}

function Locale.LoadDefault()
    local path = string.format(Locale._path, Locale._defaultLocale)

    local defaultLocale = IO.LoadFile(path, true)
    if defaultLocale == nil then return end

    IO.DeepCopy(defaultLocale, Locale.Messages)

    if Locale._loadDebugMessages then
        local debugLocale = IO.LoadFile("debug/locale.lua", true)
        if not debugLocale then return end

        IO.DeepCopy(debugLocale, Locale.Messages)
    end
end

function Locale.LoadLocale(locale)
    if not locale then
        locale = GetLanguage():lower():sub(1, 2)
    end

    local path = string.format(Locale._path, locale)

    local messages = IO.LoadFile(path, true)
    if not messages then SendSystemChat("|cffffffff[RaidHeal]: |cffff0000Could not load locale \"" .. locale .. "\"") return end

    IO.DeepCopy(messages, Locale.Messages)
end

function Locale.Init()
    Locale.LoadDefault()

    if Locale._waitForConfigLoaded then
        Events.Register("PROFILE_LOADED", function() Locale.LoadLocale() end)
    else
        Locale.LoadLocale()
    end
end

Locale.Init()
