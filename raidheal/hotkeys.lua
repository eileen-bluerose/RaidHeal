local RaidHeal = _G.RaidHeal
local Hotkeys = RaidHeal.Hotkeys

local IO = RaidHeal.IO
local Events = RaidHeal.Events

local hotkeys = {}

Hotkeys.GetAction = function(hotkey)
    if hotkeys[hotkey] then return hotkeys[hotkey] end
end

Hotkeys.SetAction = function(hotkey, classToken, action)
    if not RaidHeal_Config.Hotkeys then RaidHeal_Config.Hotkeys = {} end
    if not RaidHeal_Config.Hotkeys[classToken] then RaidHeal_Config.Hotkeys[classToken] = {} end

    RaidHeal_Config.Hotkeys[classToken][hotkey] = action

    Hotkeys.LoadHotkeys()
end

Hotkeys.LoadHotkeys = function()
    if not RaidHeal_Config.Hotkeys then RaidHeal_Config.Hotkeys = {} end

    local mainClass, subClass = UnitClassToken("player")
    if subClass == "" then subClass = nil end

    hotkeys = {}

    if RaidHeal_Config.Hotkeys["*"] then IO.DeepCopy(RaidHeal_Config.Hotkeys["*"], hotkeys) end
    if subClass and RaidHeal_Config.Hotkeys["*" .. subClass] then IO.DeepCopy(RaidHeal_Config.Hotkeys["*" .. subClass], hotkeys) end
    if RaidHeal_Config.Hotkeys["*" .. mainClass] then IO.DeepCopy(RaidHeal_Config.Hotkeys["*" .. mainClass], hotkeys) end
    if RaidHeal_Config.Hotkeys[mainClass .. "*"] then IO.DeepCopy(RaidHeal_Config.Hotkeys[mainClass .. "*"], hotkeys) end
    if subClass and RaidHeal_Config.Hotkeys[mainClass .. subClass] then IO.DeepCopy(RaidHeal_Config.Hotkeys[mainClass .. subClass], hotkeys) end

    Events.DoEvent("HOTKEYS_CHANGED")
end

Events.Register("LOADING_END", Hotkeys.LoadHotkeys)
Events.Register("EXCHANGECLASS_SUCCESS", Hotkeys.LoadHotkeys)
