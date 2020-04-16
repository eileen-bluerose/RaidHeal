local RaidHeal = _G.RaidHeal
local UI = RaidHeal.UI
local Grid = UI.Grid
local Events = RaidHeal.Events
local Config = RaidHeal.Config

Grid.Active = false

Grid.OnProfileLoaded = function(profileName)
    if Config.Grid and Config.Grid.Active then
        Grid.Enable()
    else
        Grid.Disable()
    end
end

Grid.Enable = function()
    if Grid.Active or not Config.Grid then return end

    Grid.Active = true
end

Grid.Disable = function()
    if not Grid.Active then return end

    Grid.Active = false
end

Events.Register("PROFILE_LOADED", Grid.OnProfileLoaded)