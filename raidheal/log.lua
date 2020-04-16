local RaidHeal = _G.RaidHeal
local Log = RaidHeal.Log

Log.Settings = {
    ERROR = {
        Show = true,
        Color = { 1.0, 0, 0 },
        Prefix = "RaidHeal Error: "
    },
    WARNING = {
        Show = true,
        Color = { 1.0, 0.5, 0},
        Prefix = "RaidHeal Warning: "
    },
    INFO = {
        Show = false,
        Color = { 0, 1.0, 0 },
        Prefix = "RaidHeal Info: "
    },
    DEBUG = {
        Show = false,
        Color = { 1, 1, 0 },
        Prefix = "RaidHeal Debug: "
    }
}

Log.PrintFunc = DEFAULT_CHAT_FRAME.AddMessage
Log.PrintCallee = DEFAULT_CHAT_FRAME
Log.PrintMaxLength = 500

Log.Messages = {}

Log.Print = function(setting, msg)
    local function printMessage(message, r, g, b)
        if message:len() > Log.PrintMaxLength then
            printMessage(message:sub(1, Log.PrintMaxLength), r, g, b)
            return printMessage(message:sub(Log.PrintMaxLength), r, g, b)
        else
            local args = {}

            if Log.PrintCallee then
                args[#args + 1] = Log.PrintCallee
            end

            args[#args + 1] = message
            args[#args + 1] = r
            args[#args + 1] = g
            args[#args + 1] = b

            Log.PrintFunc(unpack(args))
        end
    end

    if setting.Prefix then
        msg = setting.Prefix .. msg
    end

    local r, g, b = unpack(setting.Color or { 1, 1, 1 })
    printMessage(msg, r, g, b)
end

Log.AddMessage = function(category, message)
    if not Log.Messages[category] then
        Log.Messages[category] = {}
    end

    table.insert(Log.Messages[category], message)
end

local function createHandler(handler)
    return function(filename, msg, ...)
        if Log.Settings and Log.Settings[handler] then
            local message = string.format("\"%s\" - %s", filename, string.format(msg, ...) )
            Log.AddMessage(handler, message)

            if Log.Settings[handler].Show then Log.Print(Log.Settings[handler], message) end
        end
    end
end

Log.Error = createHandler("ERROR")
Log.Warning = createHandler("WARNING")
Log.Info = createHandler("INFO")
Log.Debug = createHandler("DEBUG")

Log.PrintStats = function()
    SendSystemChat("RaidHeal Log statistics start")

    local total = 0
    for category, entries in pairs(Log.Messages) do
        SendSystemChat(string.format("%s: %d entries", category, #entries))
        total = total + #entries
    end
    SendSystemChat(string.format("Total: %d entries", total))

    SendSystemChat("RaidHeal Log statistics end")
end