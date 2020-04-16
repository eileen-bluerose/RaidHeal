local RaidHeal = _G.RaidHeal
local DB = RaidHeal.DB
local IO = RaidHeal.IO
local Events = RaidHeal.Events

DB.Buffs = {}
DB.Debuffs = {}

DB.GetMaxTimeLeft = function(buffType, id, curTimeLeft)
    if not id then return -1 end

    local maxTime = (DB[buffType] and DB[buffType][id]) and DB[buffType][id] or -1
    --DB[buffType][id] = math.max(DB[buffType][id] or -1, curTimeLeft or -1)
    DB[buffType][id] = math.max(maxTime, curTimeLeft or -1)
    return DB[buffType][id]
end

DB.SaveBuffs = function()
    if not RaidHeal_GlobalConfig.DB then
        RaidHeal_GlobalConfig.DB = { Buffs = {}, Debuffs = {} }
    end

    IO.DeepCopy(DB.Buffs, RaidHeal_GlobalConfig.DB.Buffs)
    IO.DeepCopy(DB.Debuffs, RaidHeal_GlobalConfig.DB.Debuffs)
end

DB.LoadBuffs = function()
    if RaidHeal_GlobalConfig.DB then
        IO.DeepCopy(RaidHeal_GlobalConfig.DB.Buffs, DB.Buffs)
        IO.DeepCopy(RaidHeal_GlobalConfig.DB.Debuffs, DB.Debuffs)
    end
end

Events.Register("SAVE_VARIABLES", DB.SaveBuffs)
Events.Register("PROFILE_LOADED", DB.LoadBuffs)
