local RaidHeal = _G.RaidHeal
local Menu = RaidHeal.Menu
local Config = RaidHeal.Config
local FilterMenu = Menu.FilterMenu

FilterMenu.Filter = ""
FilterMenu.BuffList = {}
FilterMenu.IgnoreList = {}
FilterMenu.IncludeList = {}

FilterMenu.Callee = nil
FilterMenu.Show = function(caller, buffType, data)
    FilterMenu.Caller = caller
    FilterMenu.BuffType = buffType
    FilterMenu.Data = data

    if caller and caller.Hide then caller:Hide() end

    FilterMenu.LoadBuffList(buffType)
    FilterMenu.LoadBuffIndexData(buffType, data)

    RH_FilterMenu:Show()
end

FilterMenu.LoadBuffList = function(buffType)
    FilterMenu.BuffList = RaidHeal.DB[buffType]
end

FilterMenu.LoadBuffIndexData = function(buffType, data)
    local filterConfig = data.Filter or {}
    FilterMenu.IgnoreList = filterConfig.Ignore or {}
    FilterMenu.IncludeList = filterConfig.Include or {}
    FilterMenu.FilterMode = filterConfig.Mode or "Normal"
    FilterMenu.FilterIndex = filterConfig.Index or 1
    FilterMenu.FilterParams = filterConfig.Params or {}
end

FilterMenu.Hide = function()
    RH_FilterMenu:Hide()
    if FilterMenu.Caller and FilterMenu.Caller.Show then FilterMenu.Caller:Show() end
    FilterMenu.Caller = nil

    if RH_ConfigMenu:IsVisible() then
        --Menu.ConfigMenu.ReloadPage()
    end
end

local function spairs(_table, _compFunc)
    local keys = {}
    for k in pairs(_table) do keys[#keys+1] = k end

    if _compFunc then
        table.sort(keys, function(a, b) _compFunc(_table, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], _table[keys[i]]
        end
    end
end

local function comp(t, a, b)
    return t[a] > t[b]
end

local function createLocaName(buffID)
    return string.format("[%06d] %s", buffID, TEXT("Sys"..buffID.."_name"))
end

local function createLocaTooltip(buffID)
    return string.format("%s\n%s", TEXT("Sys"..buffID.."_name"), TEXT("Sys"..buffID.."_shortnote"))
end

local function filterList(list, sortFunc, filter)
    local filterList = {}
    filter = filter and filter:lower() or nil

    for buffID in spairs(list, sortFunc) do
        local entry = { Display = createLocaName(buffID), Value = buffID, Tooltip = createLocaTooltip(buffID) }

        if filter == nil then
            filterList[#filterList + 1] = entry
        else
            if FilterMenu.IgnoreList[buffID] or FilterMenu.IncludeList[buffID] then
            elseif filter == "" or entry.Display:lower():find(filter) or entry.Tooltip:lower():find(filter) then
                filterList[#filterList + 1] = entry
            end
        end
    end

    return filterList
end

FilterMenu.FilterIncludeList = function()
    return filterList(FilterMenu.IncludeList, comp)
end

FilterMenu.FilterIgnoreList = function()
    return filterList(FilterMenu.IgnoreList, comp)
end

FilterMenu.FilterBuffList = function()
    local function compare(t, a, b)
        return a < b
    end

    return filterList(FilterMenu.BuffList, compare, tostring(FilterMenu.Filter))
end

FilterMenu.SaveTemp = function()
    local function saveData(list)
        local dest = {}
        local num = #list._listData.FillListData
        for key, value in ipairs(list._listData.FillListData) do
            dest[value.Value] = num - key + 1
        end

        return dest
    end

    FilterMenu.IncludeList = saveData(RH_FilterMenu_IncludeList)
    FilterMenu.IgnoreList = saveData(RH_FilterMenu_IgnoreList)

    Menu.UpdateList(RH_FilterMenu_IncludeList)
    Menu.UpdateList(RH_FilterMenu_IgnoreList)
    Menu.UpdateList(RH_FilterMenu_BuffList)
end

FilterMenu.Shift = function(listFrom, listTo)
    local function getSelectedData()
        local selectedData = {}

        for i = 1, #listFrom._listData.FillListData do
            if listFrom._listData.SelectedIndices[i] then
                table.remove(listFrom._listData.SelectedIndices, i)
                selectedData[#selectedData+1] = table.remove(listFrom._listData.FillListData, i)
                i = i-1
            end
        end

        return selectedData
    end

    for _, selectedData in pairs(getSelectedData()) do
        listTo._listData.FillListData[#listTo._listData.FillListData+1] = selectedData
    end

    FilterMenu.SaveTemp()
end

FilterMenu.ShiftLeft = function(list)
    return FilterMenu.Shift(RH_FilterMenu_BuffList, list)
end

FilterMenu.ShiftRight = function(list)
    return FilterMenu.Shift(list, RH_FilterMenu_BuffList)
end

FilterMenu.Save = function()
    FilterMenu.SaveTemp()

    filterConfig = {}
    filterConfig.Include = FilterMenu.IncludeList or {}
    filterConfig.Ignore = FilterMenu.IgnoreList or {}
    filterConfig.Mode = FilterMenu.FilterMode or "Default"
    filterConfig.Index = FilterMenu.FilterIndex or 1
    filterConfig.Params = FilterMenu.FilterParams or nil

    --[[local config = Config[FilterMenu.Category].Unit[FilterMenu.BuffType]
    if config and config[FilterMenu.BuffIndex] then
        config[FilterMenu.BuffIndex].Filter = filterConfig
    else
        config[FilterMenu.BuffIndex] = { Filter = filterConfig }
    end--]]

    if FilterMenu.Data then FilterMenu.Data.Filter = filterConfig end

    FilterMenu.Hide()
end
