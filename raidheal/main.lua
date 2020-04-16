local RaidHeal = _G.RaidHeal
local IO = RaidHeal.IO
local Commands = RaidHeal.Commands
local Tasks = RaidHeal.Tasks
local Events = RaidHeal.Events

SLASH_RaidHeal1 = "/rh"
SLASH_RaidHeal2 = "//rh"
SLASH_RaidHeal3 = "/raidheal"
SLASH_RaidHeal4 = "//raidheal"
SLASH_RaidHeal5 = "/RaidHeal"
SLASH_RaidHeal6 = "//RaidHeal"

local function split(p, d)
    local t, ll
    t = {}
    ll = 0
    if (#p == 1) then return { p } end
    while true do
        l = string.find(p, d, ll, true) -- find the next d in the string
        if l ~= nil then -- if "not not" found then..
            table.insert(t, string.sub(p, ll, l - 1)) -- Save it in our array.
            ll = l + 1 -- save just after where we found it for searching next time.
        else
            table.insert(t, string.sub(p, ll)) -- Save what's left in our array.
            break -- Break at end, as it should be, according to the lua manual.
        end
    end
    return t
end

SlashCmdList["RaidHeal"] = function(editbox, msg)
    local cmds = split(msg, " ")
    if msg ~= "" and #cmds > 0 then
        local cmd = (table.remove(cmds, 1)):lower()

        if Commands[cmd] then
            Commands[cmd](unpack(cmds))
        else
            IO.Print("ERROR_COMMAND_NOT_FOUND", cmd)
            RaidHeal.PrintCommands()
        end
    else
        RaidHeal.PrintCommands()
    end
end

function RaidHeal.PrintCommands()
    IO.Print("MSG_COMMANDS_AVAILABLE")

    local cmds = {}
    for cmd, _ in pairs(Commands) do
        cmds[#cmds + 1] = cmd
    end

    IO.PrintRaw(table.concat(cmds, ", "))
end

Commands["list"] = RaidHeal.PrintCommands
Commands["help"] = function(cmd)
    if not cmd then
        IO.Print("CMD_HELP_USAGE")
        return
    end

    cmd = cmd:lower()

    if Commands[cmd] then
        local locale = string.format("CMD_%s_DESC", cmd:upper())

        IO.Print("MSG_CMD_HELP", cmd, IO.Format(locale))
    end
end

Commands["config"] = function()
    RH_ConfigMenu:Show()
end

Commands["action"] = function()
    RaidHeal.Menu.SkillMenu.Show()
end

--[[Commands["export"] = function(profileName)
    if not profileName then profileName = Profiles.LoadedProfile end
    local success, err = pcall(Profiles.Export, profileName)

    if success then
        IO.PrintRaw("Exporting successful")
    else
        IO.PrintError("Error during export: " .. tostring(err))
    end
end--]]

local function onload()
    if _G.AddonManager then
        local addon = {
            name = "RaidHeal",
            version = RaidHeal._VERSION,
            author = "hoffmale",
            description = IO.Format("ADDON_DESC"),
            icon = "Interface/widgeticons/classicon_druid",
            category = "Interface",
            configFrame = RH_ConfigMenu,
            slashCommand = "/rh /raidheal /RaidHeal",
            disableScript = RaidHeal.UI.Grid.Disable,
            enableScript = RaidHeal.UI.Grid.Enable,
            mini_icon = "Interface/widgeticons/classicon_druid",
            mini_icon_pushed = "Interface/widgeticons/classicon_druid",
            mini_onClickScript = function(this, key)
                --RH_MiniMapDropDownMenu.relTo = this
                UIDropDownMenu_SetAnchor(RH_MiniMapDropDownMenu, 0, 0, "TOPLEFT", "CENTER", this)
                ToggleDropDownMenu(RH_MiniMapDropDownMenu)
            end
        }
        if AddonManager.RegisterAddonTable then
            AddonManager.RegisterAddonTable(addon)
            RH_MiniMapButton:Hide()
        elseif AddonManager.RegisterAddon then
            AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, addon.configFrame, addon.slashCommand, nil, addon.mini_onClickScript, addon.version, addon.author, addon.disableScript, addon.enableScript)
            RH_MiniMapButton:Hide()
        else
            IO.Print("MSG_LOADED", RaidHeal._VERSION)
        end
    else
        IO.Print("MSG_LOADED", RaidHeal._VERSION)
    end
    Tasks.Add(function() Events.Release("PROFILE_LOADED", onload) end, 0, 0, false)
end

Events.Register("PROFILE_LOADED", onload)
