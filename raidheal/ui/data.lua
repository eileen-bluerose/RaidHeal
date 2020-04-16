local RaidHeal = _G.RaidHeal

local UI = RaidHeal.UI
local Data = UI.Data
local IO = RaidHeal.IO
local Log = RaidHeal.Log

local _FILENAME_ = "ui/data.lua"

----- imports for performance
local UnitHealth = UnitHealth
local UnitMaxHealth = UnitMaxHealth
local UnitMana = UnitMana
local UnitMaxMana = UnitMaxMana
local UnitManaType = UnitManaType
local UnitSkill = UnitSkill
local UnitMaxSkill = UnitMaxSkill
local UnitSkillType = UnitSkillType
local UnitName = UnitName
local UnitClassToken = UnitClassToken
local UnitIsRaidLeader = UnitIsRaidLeader
local UnitBuff = UnitBuff
local UnitBuffLeftTime = UnitBuffLeftTime
local UnitDebuff = UnitDebuff
local UnitDebuffLeftTime = UnitDebuffLeftTime
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit

Data.CollectUnitData = function(unit)
    if not UnitExists(unit) then
        return nil
    end

    local data = {}

    data.UnitID = unit

    data.HP = UnitHealth(unit)
    data.HPMax = UnitMaxHealth(unit)

    data.MP = UnitMana(unit)
    data.MPMax = UnitMaxMana(unit)
    data.MPType = UnitManaType(unit)

    data.SP = UnitSkill(unit)
    data.SPMax = UnitMaxSkill(unit)
    data.SPType = UnitSkillType(unit)

    data.Name = UnitName(unit)
    data.MainClass, data.SubClass = UnitClassToken(unit)

    data.IsRaidLead = UnitIsRaidLeader(unit)

    data.Buffs = {}
    data.Debuffs = {}

    local function getBuffData(buffType, index)
        local _LUT = { Buffs = { UnitBuff, UnitBuffLeftTime }, Debuffs = { UnitDebuff, UnitDebuffLeftTime } }
        local buffFunc, buffTimeFunc = _LUT[buffType][1], _LUT[buffType][2]

        local _name, _texture, _count, _id, _params = buffFunc(unit, index)
        local _timeLeft = buffTimeFunc(unit, index)
        local _timeMax = RaidHeal.DB.GetMaxTimeLeft(buffType, _id, _timeLeft)

        return { Name = _name, Texture = _texture, Stacks = _count, ID = _id, Params = _params, TimeLeft = _timeLeft, TimeMax = _timeMax }
    end

    for i = 1, 40 do
        local buff = getBuffData("Buffs", i)
        local debuff = getBuffData("Debuffs", i)

        if buff and buff.ID then
            data.Buffs[i] = buff
        end

        if debuff and debuff.ID then
            data.Debuffs[i] = debuff
        end

        if not (debuff and debuff.ID) and not (buff and buff.ID) then break end
    end

    return data
end

Data.CheckForUnitPet = function(unit)
    if not UnitExists(unit .. "pet") then return false, nil end

    local petData = Data.CollectUnitData(unit .. "pet")
    petData.IsPet = true

    return true, petData
end

Data.Sort = function(raidData, petData, oldPetPosData, config)
    local sortFunc = Data.SortDataFuncs[config.SortFunc or "Normal"] or Data.SortDataFuncs.Normal

    local success, sortedData, petPosData = pcall(sortFunc, raidData, petData, oldPetPosData, config)

    if not success then
        Log.Error(_FILENAME_, "Data.Sort: " .. sortedData)
        return raidData, oldPetPosData
    else
        return sortedData, petPosData
    end
end

Data.UpdateData = function(oldData, oldPosData)
    local newData = {}
    local petData = {}

    local function collectUnitData(unit)
        if not UnitExists(unit) then
            return {}
        end

        local data = {}

        data.UnitID = unit

        data.HP = UnitHealth(unit)
        data.HPMax = UnitMaxHealth(unit)

        data.MP = UnitMana(unit)
        data.MPMax = UnitMaxMana(unit)
        data.MPType = UnitManaType(unit)

        data.SP = UnitSkill(unit)
        data.SPMax = UnitMaxSkill(unit)
        data.SPType = UnitSkillType(unit)

        data.Name = UnitName(unit)
        data.MainClass, data.SubClass = UnitClassToken(unit)

        data.IsRaidLead = UnitIsRaidLeader(unit)

        data.Buffs = {}
        data.Debuffs = {}

        local function getBuffData(buffType, index)
            local _LUT = { Buffs = { UnitBuff, UnitBuffLeftTime }, Debuffs = { UnitDebuff, UnitDebuffLeftTime } }
            local buffFunc, buffTimeFunc = _LUT[buffType][1], _LUT[buffType][2]

            local _name, _texture, _count, _id, _params = buffFunc(unit, index)
            local _timeLeft = buffTimeFunc(unit, index)
            local _timeMax = RaidHeal.DB.GetMaxTimeLeft(buffType, _id, _timeLeft)

            return { Name = _name, Texture = _texture, Stacks = _count, ID = _id, Params = _params, TimeLeft = _timeLeft, TimeMax = _timeMax }
        end

        for i = 1, 40 do
            local buff = getBuffData("Buffs", i)
            local debuff = getBuffData("Debuffs", i)

            if buff and buff.ID then
                data.Buffs[i] = buff
            end

            if debuff and debuff.ID then
                data.Debuffs[i] = debuff
            end

            if not (debuff and debuff.ID) and not (buff and buff.ID) then break end
        end

        return data
    end

    local function checkPet(index, unit)
        if not UnitExists(unit .. "pet") then return false, nil end

        local _pet = collectUnitData(unit .. "pet")
        _pet.IsPet = true
        _pet.MasterIndex = index

        local petIndex = #petData + 1
        petData[petIndex] = _pet

        return true, petIndex
    end

    local function updateIndex(index)
        local data = {}
        local unit = "raid" .. index

        if UnitExists(unit) then
            data = collectUnitData(unit)

            local function checkDC()
                local _, online = GetRaidMember(index)
                return not online
            end

            data.DC = checkDC()
            data.HasPet, data.PetIndex = checkPet(index, unit)
            data.RaidIndex = index
        end

        if data and next(data) then newData[index] = data end
    end

    local function updatePlayer()
        local data = collectUnitData("player")

        data.HasPet, data.PetIndex = checkPet(1, "player")

        newData[1] = data
    end

    if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
        if Config.SoloMode then
            updatePlayer()
        end
    else
        for i = 1, Config.MaxNumPartyMember do
            updateIndex(i)
        end
    end

    Grid.Data, Grid.PetPosData = Grid.SortData(newData, petData)

    local success, err = pcall(Grid.ProcessData)
    if not success and err then
        Log.Error(_FILENAME_, err)
    end
end

--------------------------------------------------------------------
-- SortData Func Format:                                          --
--  Args: [1] = raw Data, [2] = pet Data                          --
--  Returns: [1] = sorted Data, [2] = pet pos data                --
--------------------------------------------------------------------

Data.SortDataFuncs = {
    Normal = function(raidData, petData, oldPetPosData, config)
        local gridData = raidData
        local newPetPosData = {}

        local function checkPetSavedPos(masterName)
            if masterName and oldPetPosData[masterName] and not gridData[oldPetPosData[masterName]] then
                return oldPetPosData[masterName]
            else
                return nil
            end
        end

        local function getNextFreePos(index)
            local max = config.MaxNumUnits
            for i = 1, math.max(index, config.MaxNumUnits - index + 1) do
                local check = (index + i)
                if check <= config.MaxNumUnits and not gridData[check] then return check end
                check = (index - i)
                if check > 0 and not gridData[check] then return check end
            end
            return nil
        end

        for _, pet in pairs(petData) do
            local master = gridData[pet.MasterIndex]

            if master then
                if (config.ShowWardenPet and master.MainClass == "WARDEN")
                or (config.ShowPriestPet and master.MainClass == "AUGUR")
                or (config.ShowOwnPet and UnitIsUnit("player", master.UnitID)) then
                    local petPos = checkPetSavedPos(master.Name) or getNextFreePos(pet.MasterIndex)

                    gridData[petPos] = pet
                    master.PetIndex = petPos
                    newPetPosData[master.Name] = petPos
                end
            end
        end

        return gridData, newPetPosData
    end,
}

Data.BuffFilterFuncs = {
    Default = function(buffData, filterData)
        local result = {}

        for i = 1, #buffData do
            if buffData[i] and buffData[i].ID then
                if filterData.Ignore and filterData.Ignore[buffData[i].ID] then
                else
                    result[#result + 1] = buffData[i]
                end
            end
        end

        if #result > 1 then
            local function comp(a, b)
                if not b or not b.ID then return true end
                if not a or not a.ID then return false end

                --return (a.TimeLeft or -1) < (b.TimeLeft or -1)
                if not a.TimeLeft then
                    return false
                elseif not b.TimeLeft then
                    return a.TimeLeft > 0
                else
                    return a.TimeLeft < b.TimeLeft
                end
            end

            table.sort(result, comp)
        end

        return result[filterData.Index or 1]
    end,
    ParamsWhiteList = function(buffData, filterData, extra)
        local result = {}

        for i = 1, #buffData do
            if buffData[i] and buffData[i].ID then
                if filterData.Ignore and filterData.Ignore[buffData[i].ID] then
                elseif filterData.Include and filterData.Include[buffData[i].ID] then
                    result[#result + 1] = buffData[i]
                elseif buffData[i].Params and filterData.Params and filterData.Params[buffData[i].Params] then
                    result[#result + 1] = buffData[i]
                end
            end
        end

        if #result > 1 then
            local function comp(a, b)
                if not b or not b.ID then return true end
                if not a or not a.ID then return false end

                if filterData.Include[a.ID] then
                    if filterData.Include[b.ID] then
                        return filterData.Include[a.ID] > filterData.Include[b.ID]
                    else
                        return true
                    end
                elseif filterData.Include[b.ID] then
                    return false
                else
                    return (a.TimeLeft or 111) < (b.TimeLeft or -1)
                end
            end

            table.sort(result, comp)
        end

        return result[filterData.Index or 1]
    end,
    ParamsBlackList = function(buffData, filterData)
        local result = {}

        for i = 1, #buffData do
            if buffData[i] and buffData[i].ID then
                if filterData.Ignore and filterData.Ignore[buffData[i].ID] then
                elseif filterData.Include and filterData.Include[buffData[i].ID] then
                    result[#result + 1] = buffData[i]
                elseif buffData[i].Params and filterData.Params and not filterData.Params[buffData[i].Params] then
                    result[#result + 1] = buffData[i]
                elseif not buffData[i].Params then
                    result[#result + 1] = buffData[i]
                end
            end
        end

        if #result > 1 then
            local function comp(a, b)
                if not b or not b.ID then return true end
                if not a or not a.ID then return false end

                if filterData.Include[a.ID] then
                    if filterData.Include[b.ID] then
                        return filterData.Include[a.ID] > filterData.Include[b.ID]
                    else
                        return true
                    end
                elseif filterData.Include[b.ID] then
                    return false
                else
                    return (a.TimeLeft or -1) < (b.TimeLeft or -1)
                end
            end

            table.sort(result, comp)
        end

        return result[filterData.Index or 1]
    end,
    WhiteListOnly = function(buffData, filterData)
        local result = {}

        for i = 1, #buffData do
            if buffData[i] and buffData[i].ID and filterData.Include[buffData[i].ID] then
                result[#result + 1] = buffData[i]
            end
        end

        if #result > 1 then
            local function comp(a, b)
                if not b or not b.ID then return true end
                if not a or not a.ID then return false end

                --return filterData.Include[a.ID] > filterData.Include[b.ID]
                return a.TimeLeft < b.TimeLeft
            end

            table.sort(result, comp)
        end

        return result[filterData.Index or 1]
    end
}

Data.FormatHealthFuncs = {
    Simplified = function(health, maxHealth)
        local result = ""
        local numFormat = "%.1f"

        if type(health) ~= "number" or type(maxHealth) ~= "number" then return result end

        if health == 0 then return "DEAD" end

        local diff = health - maxHealth
        if diff == 0 then return "" end

        if math.abs(diff) < 751 then
            return string.format("%d", diff)
        end

        while math.abs(diff) / 1000 > 1.0 do
            result = result .. "k"
            diff = diff / 1000
        end
        if math.abs(diff) > 750 then
            diff = math.floor(diff / 100) / 10
            result = result .. "k"
        elseif math.abs(health) > 99 then
            diff = math.floor(diff)
            numFormat = "%d"
        else
            diff = math.floor(diff * 10) / 10
        end
        result = string.format(numFormat .. "%s", diff, result)

        return result
    end,
    Unformatted = function(health, maxHealth)
        if health == 0 then return "DEAD" end

        local diff = health - maxHealth
        if diff == 0 then return "" end

        return string.format("%d", diff)
    end
}

Data.Process = function(data, config)
    local function safecall(func, ...)
        local result = { pcall(func, ...) }

        local success = table.remove(result, 1)
        if not success then
            Log.Error(_FILENAME_, result[1])
        else
            return unpack(result)
        end
    end

    local function checkRaidMemberHasAggro()
        local targetedList = {}
        local targetedRaidIndices = {}

        local function collectTargetedList()
            for i = 1, config.MaxNumUnits do
                if data[i] then
                    local unit = data[i].UnitID
                    if UnitExists(unit .. "target") and UnitCanAttack("player", unit .. "target") and UnitExists(unit .. "targettarget") then
                        targetedList[#targetedList+1] = unit .. "targettarget"
                    end
                end
            end
        end

        local function processTargetedList()
            for i = 1, #targetedList do
                if UnitInRaid(targetedList[i]) then
                    local raidIndex = UnitRaidIndex(targetedList[i])
                    targetedRaidIndices[raidIndex] = (targetedRaidIndices[raidIndex] or 0) + 1
                elseif GetNumRaidMembers() == 0 and config.SoloMode and UnitIsUnit(targetedList[i], "player") then
                    targetedRaidIndices[1] = (targetedRaidIndices[1] or 0) + 1
                end
            end
        end

        local function applyTargetedList()
            for i = 1, config.MaxNumUnits do
                if data[i] and targetedRaidIndices[data[i].RaidIndex or i] then
                    data[i].HasAggro = targetedRaidIndices[data[i].RaidIndex or i]
                end
            end
        end

        collectTargetedList()
        processTargetedList()
        applyTargetedList()
    end

    local function fillDummies()
        local function createDummyData(index)
            local dummyData = {
                UnitID = "",
                HP = 50,
                HPMax = 100,
                MP = index,
                MPMax = config.MaxNumUnits,
                MPType = index % 4 + 1,
                SP = index * (config.Unit.Debuffs and config.Unit.Debuffs.Count or 1) + config.MaxNumUnits,
                SPMax = index * config.MaxNumUnits,
                SPType = (index + 1) % 4 + 1,
                Name = "Dummy " .. tostring(index),
                MainClass = ({ GetClassInfoByID((index - 1) % 10 + 1)})[2]
            }

            local function fillDummyBuffData(buffs, count)
                for i = 1, count do
                    buffs[i] = { Name = "Dummybuff "..i, Texture = "", Stack = i, ID = -i, TimeLeft = i, TimeMax = count }
                end
            end

            dummyData.Buffs = {}
            dummyData.Debuffs = {}

            if config.DummyModeBuffs then
                fillDummyBuffData(dummyData.Buffs, config.Unit.Buffs.Count)
                fillDummyBuffData(dummyData.Debuffs, config.Unit.Debuffs.Count)
            end

            return dummyData
        end

        for i = 1, config.MaxNumUnits do
            if not data[i] then
                data[i] = createDummyData(i)
            end
        end
    end

    local function sortBuffs(buffType)
        -- DEBUG CHeCK
        if not config.Unit[buffType] or not config.Unit[buffType].Count or config.Unit[buffType].Count < 1 then
            error("RaidHeal.UI.Data.Process: sortBuffs(\""..buffType.."\"): Missing Config")
            return
        end

        for i = 1, config.MaxNumUnits do
            if data[i] and data[i][buffType] then
                local buffResult = {}

                for buffIndex = 1, config.Unit[buffType].Count do
                    local filter = config.Unit[buffType][buffIndex] and config.Unit[buffType][buffIndex].Filter or { Ignore = {}, Include = {}, Params = {} }
                    local sortFunc = Data.BuffFilterFuncs[filter.Mode or "Default"] or Data.BuffFilterFuncs.Default

                    buffResult[buffIndex] = safecall(sortFunc, data[i][buffType], filter, config.Unit[buffType])
                end

                data[i][buffType] = buffResult
            end
        end
    end

    if config.HighlightAggro then safecall(checkRaidMemberHasAggro) end
    if config.Unit.Buffs and config.Unit.Buffs.Count > 0 then safecall(sortBuffs, "Buffs") end
    if config.Unit.Debuffs and config.Unit.Debuffs.Count > 0 then safecall(sortBuffs, "Debuffs") end
    if config.DummyMode then safecall(fillDummies) end

    return data
end

Data.InitData = function()
    Grid.SortData = Grid.SortDataFuncs[Config.SortDataFunc or "Normal"] or Grid.SortDataFuncs.Normal
    Grid.FormatHealth = Grid.FormatHealthFuncs[Config.FormatHealthFunc or "Simplified"] or Grid.FormatHealthFuncs.Simplified
end
