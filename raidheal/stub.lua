local RaidHeal = {}

RaidHeal.Log = {}
RaidHeal.Locale = {}
RaidHeal.IO = {}
RaidHeal.Events = {}
RaidHeal.Tasks = {}
RaidHeal.Config = {}
RaidHeal.Presets = {}
RaidHeal.Profiles = {}
RaidHeal.Frames = {}
RaidHeal.Hotkeys = {}
RaidHeal.Commands = {}
RaidHeal.DB = {}
RaidHeal.UI = {}
RaidHeal.Menu = {}

RaidHeal.Frames.Data = {}

RaidHeal.UI.Grid = {}
RaidHeal.UI.Focus = {}
RaidHeal.UI.Target = {}
RaidHeal.UI.Handlers = {}
RaidHeal.UI.Data = {}

RaidHeal.Menu.ResizeGridFrame = {}
RaidHeal.Menu.ConfigMenu = {}
RaidHeal.Menu.FilterMenu = {}
RaidHeal.Menu.SkillMenu = {}
RaidHeal.Menu.ActionMenu = {}
RaidHeal.Menu.Colorizer = {}

-- CONFIG SECTION -----------------

RaidHeal.IO._useScreenMessage = false
RaidHeal.IO._redirectScreenMessages = false
RaidHeal.IO._basePath = "Interface/Addons/RaidHeal/"
RaidHeal.IO._printErrors = true

RaidHeal.Locale._defaultLocale = "en"
RaidHeal.Locale._waitForConfigLoaded = true
RaidHeal.Locale._loadDebugMessages = true
RaidHeal.Locale._path = "loca/%s.lua"

RaidHeal.VERSION = {
    Major = 0,
    Minor = 9,
    Build = 7,
    Extra = "c BETA"
}

RaidHeal._VERSION = string.format("%d.%d.%d%s", RaidHeal.VERSION.Major, RaidHeal.VERSION.Minor, RaidHeal.VERSION.Build, RaidHeal.VERSION.Extra)

-- END OF CONFIG SECTION ----------

_G.RaidHeal = RaidHeal

RaidHeal_GlobalConfig = RaidHeal_GlobalConfig or {}
RaidHeal_Config = RaidHeal_Config or {}
SaveVariables("RaidHeal_GlobalConfig")
SaveVariablesPerCharacter("RaidHeal_Config")

return RaidHeal
