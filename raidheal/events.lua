local Events = _G.RaidHeal.Events
local Tasks = _G.RaidHeal.Tasks
local Log = _G.RaidHeal.Log
local IO = _G.RaidHeal.IO

local _FILENAME_ = "events.lua"

local activeTasks = {}

local Handlers = {}
local eventFrame = nil
local eventData = {}
local doingEvent = false

--- comment next two lines if not debugging
Events.Handlers = Handlers
Tasks.activeTasks = activeTasks

function Events.Register(event, handler)
    if not Handlers[event] then
        Handlers[event] = {}
        if eventFrame then eventFrame:RegisterEvent(event) end
    end

    local eventHandler = Handlers[event]

    for k, v in pairs(eventHandler) do
        if v == handler then return end
    end

    local pos = #eventHandler + 1
    eventHandler[pos] = handler

    return pos
end

function Events.Release(event, handler)
    if not Handlers[event] then
        Log.Info(_FILENAME_, "Events.Release: Tried to release handler for event '%s' - but there weren't any handlers registered for it", event)
        return
    end

    for k, v in pairs(Handlers[event]) do
        if k == handler or v == handler then
            Handlers[event][k] = nil
            break
        end
    end

    if #Handlers[event] == 0 then Handlers[event] = nil end
end

local function execEvent(event, ...)
    for _, handler in pairs(Handlers[event]) do
        local success, err = pcall(handler, ...)

        if not success and err then
            Log.Error(_FILENAME_, tostring(err))
            if RaidHeal.Debug then
                local res = RaidHeal.Debug.Clear()
                if res then Log.Debug(_FILENAME_, string.format("ErrorState: %d", res)) end
            end
        end
    end
end

function Events.DoEvent(event, ...)
    if not Handlers[event] then return end

    if doingEvent then eventData[#eventData + 1] = { Event = event, Args = { ... } } return end

    doingEvent = true

    execEvent(event, ...)

    data = table.remove(eventData, 1)
    while data do
        execEvent(data.Event, unpack(data.Args))
        data = table.remove(eventData, 1)
    end

    doingEvent = false
end

function Tasks.Add(task, firstExec, timeout, repeatable, name)
    local data = { Task = task, TimeLeft = firstExec, TimeOut = timeout or 1, Repeatable = repeatable or false }

    if name then activeTasks[name] = data else activeTasks[#activeTasks + 1] = data end
end

function Tasks.Remove(nameOrTask)
    if type(nameOrTask) == "function" then
        for key, value in pairs(activeTasks) do
            if value.Task == nameOrTask then
                activeTasks[key] = nil
                break
            end
        end
    else
        if activeTasks[nameOrTask] then activeTasks[nameOrTask] = nil end
    end
end

function Tasks.Tick(elapsedTime)
    local _oldTaskList = activeTasks
    activeTasks = {}
    for k, v in pairs(_oldTaskList) do
        v.TimeLeft = v.TimeLeft - elapsedTime
        if v.TimeLeft <= 0 then
            local func = v.Task
            v.TimeLeft = v.TimeOut

            if v.Repeatable and type(v.Repeatable) == "number" then
                v.Repeatable = v.Repeatable - 1
            end

            if v.Repeatable and v.Repeatable ~= 0 then activeTasks[k] = v end

            if func then
                local success, err = pcall(func, elapsedTime)
                if not success and err then
                    Log.Error(_FILENAME_, "Tasks.Tick:" .. tostring(k) .. ": " .. tostring(err))
                    if RaidHeal.Debug then
                        local res = RaidHeal.Debug.Clear()
                        if res then Log.Debug(_FILENAME_, string.format("ErrorState: %d", res)) end
                    end
                end
            end
        else
            activeTasks[k] = v
        end
    end
end

function Events.Init()
    eventFrame = CreateUIComponent("Frame", "", "WorldFrame")
    eventFrame:SetScripts("OnEvent", [=[ RaidHeal.Events.DoEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) ]=])
    eventFrame:SetScripts("OnLoad", [=[ RaidHeal.Events.DoEvent("OnLoad") ]=])
    eventFrame:SetScripts("OnUpdate", [=[ RaidHeal.Tasks.Tick(elapsedTime) RaidHeal.Events.DoEvent("OnUpdate", elapsedTime) ]=])

    for k, _ in pairs(Handlers) do
        eventFrame:RegisterEvent(k)
    end
end

function Events.Delay(event, ...)
    eventData[#eventData + 1] = { Event = event, Args = { ... } }
end

Events.Init()
