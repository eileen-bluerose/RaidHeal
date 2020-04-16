local RaidHeal = _G.RaidHeal
local Commands = _G.RaidHeal.Commands
local Tasks = _G.RaidHeal.Tasks

local Debug = {}
RaidHeal.Debug = Debug

Commands["debug"] = function(path, to)
    setting = _G
    local pos = path:find("%.")
    while pos do
        sub = path:sub(1, pos-1)

        if not setting[sub] then setting[sub] = {} end
        setting = setting[sub]

        path = path:sub(pos+1)
        pos = path:find("%.")
    end
    setting = setting[path]

    local thread = coroutine.create(function()
        for k,v in pairs(setting) do
            if type(v) ~= "function" then
                SendChatMessage(string.format("%s [%s] = %s", k, type(v), tostring(v)), "WHISPER", 0, to)
                coroutine.yield()
            end
        end
        SendChatMessage("finished", "WHISPER", 0, to)
    end)

    local timer = function()
        if coroutine.status(thread) == "dead" then
            Tasks.Add(function() Tasks.Remove("debug_timer") end, 0, 0, false, "debug_timer_end")
        else
            coroutine.resume(thread)
        end
    end

    Tasks.Add(timer, 0, 2, true, "debug_timer")
end

if not DebugHelper then DebugHelper = { Inspect = function() end } end

RaidHeal.IO.PrintDebug = function(debugLvl, msg, ...)
    local diff = (RaidHeal.Config.DebugLevel or 0) - debugLvl
    if diff > -1 then
        IO.Print(string.format(msg, ...))
    end
end

local UNDO = {}

local function createTrace(funcName, func)
    local function helper(...)
        Debug.Return(funcName)
        return ...
    end

    return function(test, ...)
        if test and test == UNDO then
            return func
        else
            Debug.Call(funcName, { n = select("#", ...), ... })
            return helper(func(test, ...))
        end
    end
end

local function traceModule(moduleName, module)
    for key, value in pairs(module) do
        if type(value) == "function" then
            module[key] = createTrace(string.format("%s.%s", moduleName, key), value)
        elseif type(value) == "table" then
            traceModule(string.format("%s.%s", moduleName, key), value)
        end
    end
end

local function undoTrace(module)
    for key, value in pairs(module) do
        if type(value) == "function" then
            local check = value(UNDO)
            if check and type(check) == "function" then
                module[key] = check
            else
                error("function '"..key.."' wasn't traced!")
            end
        elseif type(value) == "table" then
            undoTrace(value)
        end
    end
end

Debug.CreateTrace = createTrace
Debug.TraceModule = traceModule
Debug.UndoTrace = undoTrace

Debug.ErrorStates = {}
Debug.Stack = {}
Debug.Call = function(funcName, args)
    Debug.Stack[#Debug.Stack+1] = { Func = funcName, Args = args }
end

Debug.Return = function(funcName)
    if #Debug.Stack == 0 then
        error("function '" .. funcName .. "' tried to return with no stack available")
        return
    end

    local last = Debug.Stack[#Debug.Stack]
    if last.Func == funcName then
        Debug.Stack[#Debug.Stack] = nil
        return
    end

    error("unexpected return call from '" .. funcName .. "'")
    return
end

Debug.Clear = function()
    local oldStack = Debug.Stack
    Debug.Stack = {}

    if oldStack and #oldStack > 0 then
        Debug.ErrorStates[#Debug.ErrorStates+1] = oldStack
        return #Debug.ErrorStates
    end
end
