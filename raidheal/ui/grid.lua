local RaidHeal = _G.RaidHeal
local UI = RaidHeal.UI
local Grid = UI.Grid

local Events = RaidHeal.Events
local Tasks = RaidHeal.Tasks
local Config = RaidHeal.Config
local Frames = RaidHeal.Frames
local Data = UI.Data
local Log = RaidHeal.Log

local _FILENAME_ = "ui/grid.lua"

Grid.BackFrame = nil
Grid.UnitFrameTemplate = nil
Grid.Units = {}
Grid.Data = {}
Grid.PetPosData = {}

local active = nil

Grid.OnProfileLoaded = function(profileName)
    local backFrameTemplate = { Type = "Frame" }
    Grid.UnitFrameTemplate = UI.CreateTemplateFromConfig("UnitFrameTemplate", Config.Grid.Unit)

    if not Grid.BackFrame then
        Grid.BackFrame = Frames.CreateFromTemplate(backFrameTemplate, "RH_Grid_BackFrame", Config.Grid.Parent)
    else
        Frames.Arrange(Grid.BackFrame, backFrameTemplate)

        if not active then Grid.BackFrame:Hide() end
    end

    Grid.BackFrame.API = Grid

    ---------------------------------------------------------------------

    local parentWidth, parentHeight = Grid.BackFrame:GetParent():GetSize()

    -- TODO: Implement fail saves
    Grid.BackFrame:SetSize(Config.Grid.Size.Width * parentWidth, Config.Grid.Size.Height * parentHeight)
    Grid.BackFrame:ClearAllAnchors()
    Grid.BackFrame:SetAnchor(Config.Grid.Anchor.Point, Config.Grid.Anchor.RelPoint, Config.Grid.Parent, Config.Grid.Anchor.OffsetX * parentWidth, Config.Grid.Anchor.OffsetY * parentHeight)

    ---------------------------------------------------------------------

    UI.InitUnits(Grid.Units, Config.Grid, Grid.BackFrame, Grid.UnitFrameTemplate, "RH_Grid_Unit")

    if Grid.FakeMoveUnit then
        Grid.FakeMoveUnit:SetSize(Grid.Units[1]:GetSize())
        Frames.Arrange(Grid.FakeMoveUnit, Grid.UnitFrameTemplate)
        UI.ArrangeUnit(Grid.FakeMoveUnit, Config.Grid.Unit)

        Grid.FakeMoveUnit:SetFrameLevel(1)
    end

    if Config.Grid.Active then
        Grid.Enable()
    else
        Grid.Disable()
    end
end

Grid.Update = function()
    local data = {}
    local petData = {}

    local function checkPet(index, unit)
        local hasPet, pet = Data.CheckForUnitPet(unit)
        if hasPet then
            local petIndex = #petData + 1
            data[index].HasPet = true
            data[index].PetIndex = petIndex

            petData[petIndex] = pet
            pet.MasterIndex = index
        end
    end

    if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
        if Config.Grid.SoloMode then
            data[1] = Data.CollectUnitData("player")
            if data[1] then
                data[1].RaidIndex = 1

                checkPet(1, "player")
            end
        end
    else
        for i = 1, Config.Grid.MaxNumUnits do
            data[i] = Data.CollectUnitData("raid"..i)
            if data[i] then
                data[i].RaidIndex = i
            end

            checkPet(i, "raid"..i)
        end
    end

    data, Grid.PetPosData = Data.Sort(data, petData, Grid.PetPosData, Config.Grid)

    --data = UI.Data.Sort(data, petData)
    data = Data.Process(data, Config.Grid)

    local movingData = Grid.Moving and { UnitID = "", HP = 0, HPMax = 0, MP = 0, MPMax = 0, SP = 0, SPMax = 0, Name = "", HealthDisplay = "" } or nil
    for i = 1, Config.Grid.MaxNumUnits do
        if i == Grid.MoveStartIndex and Config.Grid.ShowFakeMove then
            UI.UpdateUnit(Grid.FakeMoveUnit, data[i], Config.Grid.Unit)
            UI.UpdateUnit(Grid.Units[i], movingData, Config.Grid.Unit)
        else
            UI.UpdateUnit(Grid.Units[i], data[i] or movingData, Config.Grid.Unit)
        end
    end

    Grid.Data = data
end

Grid.Enable = function()
    if active or not Grid.BackFrame then return end

    Grid.BackFrame:Show()
    Tasks.Add(Grid.Update, 0, 0, true, "grid_update")
    active = true
end

Grid.Disable = function()
    if active == false then return end

    Grid.BackFrame:Hide()
    Tasks.Remove("grid_update")
    active = false
end

Grid.StartMoving = function(index)
    if Grid.Moving or not Grid.Units[index] or not Grid.Data[index] then return end

    if not Grid.Data[index].IsPet and (GetNumRaidMembers() <= 1 or (not UnitIsRaidAssistant("player") and not UnitIsRaidLeader("player"))) then return end

    local function createFakeMoveUnit()
        local parent = Grid.BackFrame:GetName()
        --UI.FakeMoveUnit = Frames.Create("UnitFrame", "RH_FakeMoveUnitFrame", parent)
        local fakeUnit = Frames.CreateFromTemplate(Grid.UnitFrameTemplate, "RH_Grid_FakeMoveUnit", parent)
        --local fakeUnit = UI.CreateUnit("RH_FakeMoveUnitFrame", parent)
        local mouseCatch = CreateUIComponent("Frame", "RH_FakeMoveUnitFrameMouseCatch", parent)
        fakeUnit.MouseCatch = mouseCatch

        Grid.FakeMoveUnit = fakeUnit

        fakeUnit:SetSize(Grid.Units[index]:GetSize())
        Frames.Arrange(fakeUnit, Grid.UnitFrameTemplate)
        UI.ArrangeUnit(fakeUnit, Config.Grid.Unit)
        --UI.ArrangeUnitBuffs(fakeUnit)
        --UI.Arrange()

        -- Begin: MAGIC
        mouseCatch:ClearAllAnchors()
        mouseCatch:SetAnchor("TOPLEFT", "TOPLEFT", fakeUnit)
        mouseCatch:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", fakeUnit)

        fakeUnit:SetFrameLevel(1)
        mouseCatch:SetFrameLevel(-1)

        mouseCatch:SetMouseEnable(true)
        mouseCatch:RegisterForClicks("LeftButton", "MiddleButton", "RightButton")
        mouseCatch:SetScripts("OnMouseDown", "RaidHeal.UI.Grid.StopMoving(RaidHeal.UI.Grid.MoveStartIndex)")
        -- End: MAGIC

        return fakeUnit
    end

    if Config.Grid.ShowFakeMove then
        local fakeUnit = Grid.FakeMoveUnit or createFakeMoveUnit()
        UI.UpdateUnit(fakeUnit, Grid.Data[index], Config.Grid.Unit)

        fakeUnit:ClearAllAnchors()
        fakeUnit:SetAnchor("TOPLEFT", "TOPLEFT", Grid.Units[index])
        fakeUnit:Show()

        fakeUnit.MouseCatch:Show()
        fakeUnit:StartMoving()
        fakeUnit.Shown = true
    end


    Grid.MoveStartIndex = index
    Grid.Moving = true
end

Grid.StopMoving = function(index)
    if not Grid.Moving or not Grid.MoveStartIndex or not index then return end

    if GetNumRaidMembers() <= 1 or (not UnitIsRaidAssistant("player") and not UnitIsRaidLeader("player")) then
        if Grid.Data[index] and not Grid.Data[index].IsPet then return end
    end

    local function getPetMasterName(petIndex)
        local masterIndex = Grid.Data[petIndex].MasterIndex
        if Grid.Data[masterIndex] then
            return Grid.Data[masterIndex].Name
        end
        return -1
    end

    if Grid.Data[Grid.MoveStartIndex] then
        if Grid.Data[Grid.MoveStartIndex].RaidIndex then
            local startPos = Grid.Data[Grid.MoveStartIndex].RaidIndex
            local endPos = index

            if Grid.Data[index] and Grid.Data[index].RaidIndex then
                endPos = Grid.Data[index].RaidIndex
            elseif Grid.Data[index] and Grid.Data[index].IsPet then
                Grid.PetPosData[getPetMasterName(index)] = Grid.MoveStartIndex
            end

            MoveRaidMember(startPos, endPos)
        elseif Grid.Data[Grid.MoveStartIndex].IsPet then
            if Grid.Data[index] then
                if Grid.Data[index].RaidIndex then
                    MoveRaidMember(Grid.Data[index].RaidIndex, Grid.MoveStartIndex)
                elseif Grid.Data[index].IsPet then
                    Grid.PetPosData[getPetMasterName(index)] = Grid.MoveStartIndex
                end
            end

            Grid.PetPosData[getPetMasterName(Grid.MoveStartIndex)] = index
        end
    end

    if Grid.FakeMoveUnit and Grid.FakeMoveUnit.Shown then
        local fakeUnit = Grid.FakeMoveUnit
        fakeUnit:StopMovingOrSizing()
        fakeUnit.MouseCatch:Hide()
        fakeUnit:Hide()
        fakeUnit.Shown = false
    end

    Grid.MoveStartIndex = nil
    Grid.Moving = false
end

Events.Register("PROFILE_LOADED", Grid.OnProfileLoaded)
Events.Register("PROFILE_UPDATE", Grid.OnProfileLoaded)
Events.Register("SCREEN_RESIZE", Grid.OnProfileLoaded)
