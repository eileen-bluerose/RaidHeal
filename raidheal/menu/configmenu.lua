local RaidGeal = _G.RaidHeal
local Menu = RaidHeal.Menu
local ConfigMenu = Menu.ConfigMenu

local Config = RaidHeal.Config
local IO = RaidHeal.IO
local Events = RaidHeal.Events
local Presets = RaidHeal.Presets
local Profiles = RaidHeal.Profiles
local Frames = RaidHeal.Frames
local Log = RaidHeal.Log

local _FILENAME_ = "menu/configmenu.lua"

local buffOptionTemplate = {
    Type = "Frame",
    Size = { Width = 135, Height = 25 },
    Elements = {
        Text = {
            Type = "FontString",
            Layer = 3,
            Anchors = {
                { Point = "RIGHT", RelPoint = "RIGHT" },
                { Point = "LEFT", RelPoint = "LEFT", OffsetX = 25 }
            },
            Color = { 1, 1, 1 },
            Font = { Path = "Fonts/DFHEIMDU.TTF", Size = 12, Weight = "NORMAL", Outline = "NORMAL" },
            Justify = "LEFT"
        },
        highlight = {
            Type = "Texture",
            Layer = 2,
            Anchors = {
                { Point = "TOPLEFT", RelPoint = "TOPLEFT" },
                { Point = "BOTTOMRIGHT", RelPoint = "BOTTOMRIGHT" }
            },
            AlphaMode = "ADD",
            Texture = "interface/Buttons/ListItemHighlight"
        }
    }
}

ConfigMenu.OnProfileChanged = function(newProfileName)
end

ConfigMenu.Show = function()
    RH_ConfigMenu:Show()
end

ConfigMenu.Hide = function()
    RH_ConfigMenu:Hide()
end

ConfigMenu.LoadPage = function(name, ...)
    if name and ConfigMenu.Pages[name] then
        local function loadPage(category, elemType, presetBaseID, ...)
            local page = ConfigMenu.Pages[name]

            if type(page.Page) == "string" then
                page.Page = _G[page.Page] or page.Page
            end

            page.Category = category
            page.Type = elemType
            page.PresetBaseID = presetBaseID

            if page.Load then
                page.Load(category, elemType, presetBaseID, ...)
            else
                local config = Config and Config[category] and Config[category].Unit and Config[category].Unit[elemType]
                page.Config = {}
                page.Active = config and true or false

                if page.Active then
                    IO.DeepCopy(config, page.Config)
                else
                    page.Config = Presets.Load({ _preset = { Type = page.PresetType, ID = presetBaseID} }, true)
                end
            end

            page.Update()
            return page.Page
        end

        local success, page = pcall(loadPage, ...)

        if success then
            if ConfigMenu.CurrentPage then ConfigMenu.CurrentPage:Hide() end
            ConfigMenu.CurrentPage = page
            ConfigMenu.Mode = name
            page:Show()
        else
            IO.PrintError(page)
        end
    else
        IO.PrintError("Page '" .. name .. "' not found")
    end
end

ConfigMenu.SavePage = function()
    --[[local mode = ConfigMenu.Mode
    if not mode or mode == "" then return end

    local curProfileName = Profiles.LoadedProfile --RaidHeal_Config.Profile
    local profilePath = "RaidHeal_GlobalConfig.Profiles." .. curProfileName

    if ConfigMenu.Pages[mode] and ConfigMenu.Pages[mode].Save then
        profilePath = profilePath .. "." .. ConfigMenu.Pages[mode].Save()
    end

    if ConfigMenu.Pages[mode].Active then
        local saveData = Presets.Save(ConfigMenu.Pages[mode].Config)
        Menu.SetValue(profilePath, saveData)
    else
        Menu.SetValue(profilePath, nil)
    end

    --Events.DoEvent("PROFILE_UPDATE")
    Profiles.LoadConfig(true)
    Profiles.LoadProfile(curProfileName)--]]
    local mode = ConfigMenu.Mode

    if not mode or not ConfigMenu.Pages[mode] then
        Log.Error(_FILENAME_, "Invalid mode '%s'", tostring(mode))
        return
    end
    local page = ConfigMenu.Pages[mode]

    local basePath = "RaidHeal.Config."
    if page.Save then
        basePath = basePath .. page.Save()
    else
        Log.Error(_FILENAME_, "got no additional save path, aborting save")
        return
    end

    if page.Active then
        Menu.SetValue(basePath, ConfigMenu.Pages[mode].Config)
    else
        Menu.SetValue(basePath, nil)
    end
    ConfigMenu.ReloadPage()

    Events.DoEvent("PROFILE_LOADED")
end

ConfigMenu.SelectChild = function(child)
    if ConfigMenu.Selected then
        ConfigMenu.Selected._select = false
        ConfigMenu.Selected.highlight:Hide()
    end
    child._select = true
    child.highlight:Show()
    ConfigMenu.Selected = child
end

local childrenList = {}
ConfigMenu.CreateChild = function(parent, textID, category, buffType)
    local num = (parent.children or 0) + 1

    local child = nil
    if parent.freeChildren and #parent.freeChildren > 0 then
        child = table.remove(parent.freeChildren, 1)
    else
        child = Frames.CreateFromTemplate(buffOptionTemplate, parent:GetName() .. "_Child" .. num, parent:GetName())
    end
    child:Hide()

    parent.children = num
    table.insert(parent.nodes, num, child)

    child:ClearAllAnchors()
    if num == 1 then
        child:SetAnchor("TOPRIGHT", "TOPRIGHT", parent, 0, 25)
        child:SetAnchor("TOPLEFT", "TOPRIGHT", parent:GetName() .. "_Catch")

        childrenList[#childrenList + 1] = child
    else
        local anchor = parent.nodes[num-1]
        child:SetAnchor("TOPLEFT", "BOTTOMLEFT", anchor)
        child:SetAnchor("TOPRIGHT", "BOTTOMRIGHT", anchor)
    end

    child:SetScripts("OnEnter", "this.highlight:Show()")
    child:SetScripts("OnLeave", "if not this._select then this.highlight:Hide() end")
    child:SetScripts("OnMouseWheel", [=[
        local slider = RH_ConfigMenu_Slider
        if delta > 0 then
            slider:SetValue(slider:GetValue() - 25)
        else
            slider:SetValue(slider:GetValue() + 25)
        end
    ]=])
    child:SetScripts("OnClick", [=[
        RaidHeal.Menu.ConfigMenu.SelectChild(this)
        RaidHeal.Menu.ConfigMenu.LoadPage("Buff", "]=] .. category .. [=[", "]=] .. buffType .. [=[", "Default", this.Index)
    ]=])
    child:SetScripts("OnShow", [=[
        this.Text:SetText(RaidHeal.IO.Format("]=] .. textID .. [=[", this.Index))
    ]=])
    child:SetMouseEnable(true)

    child.Text:SetText(IO.Format(textID, num))
    child.Index = num
    child.highlight:Hide()

    child:Show()

    --[[local addButton = getglobal(parent:GetName() .. "_Add")
    addButton:ClearAllAnchors()
    addButton:SetAnchor("TOPLEFT", "BOTTOMLEFT", child)
    addButton:SetAnchor("TOPRIGHT", "BOTTOMRIGHT", child)--]]

    parent:UpdateExpanded()

    return child
end

ConfigMenu.RemoveChild = function(parent, index)
    if not parent.children or parent.children < index then return end

    local child = table.remove(parent.nodes, index)
    if not child then return end

    if not parent.freeChildren then parent.freeChildren = {} end
    parent.freeChildren[#parent.freeChildren+1] = child

    parent.children = parent.children - 1

    if index == 1 then
        for k, v in pairs(childrenList) do
            if v == child then
                table.remove(childrenList, k)
                break
            end
        end
        if parent.children > 0 then
            local top = parent.nodes[1]
            childrenList[#childrenList+1] = top

            top:ClearAllAnchors()
            top:SetAnchor("TOPRIGHT", "TOPRIGHT", parent, 0, 25)
            top:SetAnchor("TOPLEFT", "TOPRIGHT", parent:GetName() .. "_Catch", 0, 0)
        end
    elseif parent.children >= index then
        local top = parent.nodes[index-1]
        local bottom = parent.nodes[index]
        bottom:ClearAllAnchors()
        bottom:SetAnchor("TOPLEFT", "BOTTOMLEFT", top)
        bottom:SetAnchor("TOPRIGHT", "BOTTOMRIGHT", top)
    end

    child:Hide()
    parent:UpdateExpanded()
    parent:Hide()
    parent:Show()
end

ConfigMenu.UpdateChildrenOffset = function(offset)
    for i = 1, #childrenList do
        local child = childrenList[i]
        local anchor1 = { child:GetAnchor(0) }
        local anchor2 = { child:GetAnchor(1) }

        anchor1[5] = 25 + offset
        anchor2[5] = 25 + offset

        child:ClearAllAnchors()
        child:SetAnchor(unpack(anchor1))
        child:SetAnchor(unpack(anchor2))
    end
end

ConfigMenu.UpdatePreview = function(category, size, anchors,  canMove)
    local unitFrame = RH_ConfigMenu_Preview_UnitFrame

    local uWidth, uHeight = RaidHeal.UI[category].Units[1]:GetSize()
    unitFrame:SetSize(uWidth, uHeight)

    local elem = RH_ConfigMenu_Preview_UnitFrame_Elem

    elem:ClearAllAnchors()
    for _, anchor in pairs(anchors) do
        elem:SetAnchor(anchor.Point, anchor.RelPoint or anchor.Point, elem:GetParent(), anchor.OffsetX or 0, anchor.OffsetY or 0)
    end

    if size and size.Width and size.Height then
        elem:SetSize(size.Width, size.Height)
    elseif size and (size.dWidth or size.fWidth) and (size.dHeight or size.fHeight) then
        local w, h = elem:GetParent():GetSize()

        w = w * (size.fWidth or 0) + (size.dWidth or 0)
        h = h * (size.fHeight or 0) + (size.dHeight or 0)

        elem:SetSize(w, h)
    end

    elem.CanMove = canMove
end

ConfigMenu.CheckPreview = function()
    local elem = RH_ConfigMenu_Preview_UnitFrame_Elem
    local unit = elem:GetParent()
    local previewFrame = unit:GetParent()
    local anchor, _, _, posX, posY = elem:GetAnchor()
    local unitWidth, unitHeight = unit:GetSize()
    local buffWidth, buffHeight = elem:GetSize()

    local dx, dx2, dy, dy2 = unitWidth - buffWidth, unitWidth / 2 - buffWidth / 2, unitHeight - buffHeight, unitHeight / 2 - buffHeight / 2

    local lut = {
        TOPLEFT = { 0, 0, dx, dy },
        TOP = { -dx2, 0, dx2, dy },
        TOPRIGHT = { -dx, 0, 0, dy },
        LEFT = { 0, -dy2, dx, dy2 },
        CENTER = { -dx2, -dy2, dx2, dy2 },
        RIGHT = { -dx, -dy2, 0, dy2 },
        BOTTOMLEFT = { 0, -dy, dx, 0 },
        BOTTOM = { -dx2, -dy, dx2, 0 },
        BOTTOMRIGHT = { -dx, -dy, 0, 0 }
    }

    local minX, minY, maxX, maxY = unpack(lut[anchor])
    local resetPos = false

    if minY > posY then
        resetPos = true
        posY = minY
    elseif maxY < posY then
        resetPos = true
        posY = maxY
    end

    if minX > posX then
        resetPos = true
        posX = minX
    elseif maxX < posX then
        resetPos = true
        posX = maxX
    end

    if resetPos then
        elem:ClearAllAnchors()
        elem:SetAnchor(anchor, anchor, unit, posX, posY)
    end

    local mode = ConfigMenu.Mode
    ConfigMenu.Pages[mode].Anchor = anchor
    ConfigMenu.Pages[mode].OffsetX = posX
    ConfigMenu.Pages[mode].OffsetY = posY

    ConfigMenu.Pages[mode].Update()
end

Events.Register("PROFILE_LOADED", ConfigMenu.OnProfileChanged)
Events.Register("PROFILE_UPDATE", ConfigMenu.OnProfileChanged)

-----------------------------------------------------------

local function getDockFromAnchors(anchor1, anchor2)
    local lut = {
        TOPLEFT = {
            TOPRIGHT = "TOP",
            BOTTOMLEFT = "LEFT",
            BOTTOMRIGHT = "FILL",
        },
        TOPRIGHT = {
            TOPLEFT = "TOP",
            BOTTOMRIGHT = "RIGHT",
            BOTTOMLEFT = "FILL",
        },
        BOTTOMLEFT = {
            TOPLEFT = "LEFT",
            TOPRIGHT = "FILL",
            BOTTOMRIGHT = "BOTTOM",
        },
        BOTTOMRIGHT = {
            TOPLEFT = "FILL",
            TOPRIGHT = "RIGHT",
            BOTTOMLEFT = "BOTTOM",
        }
    }

    if not anchor1 or not anchor2 or anchor1 == anchor2 or not lut[anchor1] or not lut[anchor2] then return nil end

    return lut[anchor1][anchor2]
end

local function getAnchorsFromDock(dock)
    local lut = {
        TOP = { "TOPLEFT", "TOPRIGHT" },
        LEFT = { "TOPLEFT", "BOTTOMLEFT" },
        BOTTOM = { "BOTTOMLEFT", "BOTTOMRIGHT" },
        RIGHT = { "TOPRIGHT", "BOTTOMRIGHT" },
        FILL = { "TOPLEFT", "BOTTOMRIGHT" }
    }
    if lut[dock] then
        return unpack(lut[dock])
    else
        return nil
    end
end

-----------------------------------------------------------

ConfigMenu.Pages = {
    Bar = {
        Page = "RH_ConfigMenu_PageBar",
        PresetType = "BarSettings"
    },
    Text = {
        Page = "RH_ConfigMenu_PageText",
        PresetType = "DisplaySettings"
    },
    CatGeneral = {
        Page = "RH_ConfigMenu_PageCategoryGeneral"
    },
    Buff = {
        Page = "RH_ConfigMenu_PageBuff",
        PresetType = "BuffSettings"
    }
}

local Pages = ConfigMenu.Pages

Pages.Bar.Load = function(category, elemType, presetBaseID)
    local page = Pages.Bar

    local config = Config and Config[category] and Config[category].Unit and Config[category].Unit[elemType]
    page.Config = {}
    page.Active = config and true or false

    if page.Active then
        IO.DeepCopy(config, page.Config)
    else
        page.Config = Presets.Load({ _preset = { Type = page.PresetType, ID = presetBaseID} }, true)
    end

    config = page.Config

    local anchor1 = config and config.Template and config.Template.Anchors and config.Template.Anchors[1] or nil
    local anchor2 = config and config.Template and config.Template.Anchors and config.Template.Anchors[2] or nil
    Pages.Bar.Dock = getDockFromAnchors(anchor1 and anchor1.Point, anchor2 and anchor2.Point)

    if config and config.Template and config.Template.dSize and Pages.Bar.Dock then
        if Pages.Bar.Dock == "TOP" or Pages.Bar.Dock == "BOTTOM" then
            Pages.Bar.Thickness = config.Template.dSize.dHeight or 3
        else
            Pages.Bar.Thickness = config.Template.dSize.dWidth or 3
        end
    end
end

Pages.Bar.Update = function()
    local config = Pages.Bar.Config
    Pages.Bar.CanToggle = Pages.Bar.Type == "HealthBar"

    if Pages.Bar.Dock then
        local baralign = Pages.Bar.Config.BarAlign
        if Pages.Bar.Dock == "TOP" or Pages.Bar.Dock == "BOTTOM" then
            if baralign ~= "RIGHT" then baralign = "LEFT" end
            RaidHeal.Menu.LoadDropDownList(RH_ConfigMenu_PageBar_BarAlign, "AnchorSides2H")
        elseif Pages.Bar.Dock == "LEFT" or Pages.Bar.Dock == "RIGHT" then
            if baralign ~= "BOTTOM" then baralign = "TOP" end
            Menu.LoadDropDownList(RH_ConfigMenu_PageBar_BarAlign, "AnchorSides2V")
        elseif Pages.Bar.Dock == "FILL" then
            Menu.LoadDropDownList(RH_ConfigMenu_PageBar_BarAlign, "AnchorSides4")
        end
        Pages.Bar.Config.BarAlign = baralign
    end

    Pages.Bar.Page:Hide()
    Pages.Bar.Page:Show()

    local anchor1, anchor2 = getAnchorsFromDock(Pages.Bar.Dock)
    local anchors = {
        { Point = anchor1, RelPoint = anchor1, OffsetX = 0, OffsetY = 0 },
        { Point = anchor2, RelPoint = anchor2, OffsetX = 0, OffsetY = 0 },
    }

    RH_ConfigMenu_Preview:Show()
    ConfigMenu.UpdatePreview(Pages.Bar.Category, config.Template and config.Template.Size or { Height = Pages.Bar.Thickness, Width = Pages.Bar.Thickness }, anchors)
end

Pages.Bar.Save = function()
    local config = Pages.Bar.Config

    if Pages.Bar.Type == "HealthBar" then
        config.ParamCur = "HP"
        config.ParamMax = "HPMax"
        Pages.Bar.Dock = "FILL"
        Pages.Bar.Thickness = nil
    elseif Pages.Bar.Type == "ManaBar" then
        config.ParamCur = "MP"
        config.ParamMax = "MPMax"

        if config.Colors and config.Colors._preset.Type == "ResourceColors" then
            config.ColorIndex = "MPType"
        end
    elseif Pages.Bar.Type == "SkillBar" then
        config.ParamCur = "SP"
        config.ParamMax = "SPMax"

        if config.Colors and config.Colors._preset.Type == "ResourceColors" then
            config.ColorIndex = "SPType"
        end
    end

    if Pages.Bar.Thickness then
        if Pages.Bar.Dock == "TOP" or Pages.Bar.Dock == "BOTTOM" then
            config.Template.dSize = { fHeight = 0, dHeight = Pages.Bar.Thickness, fWidth = 1, dWidth = 0 }
        else
            config.Template.dSize = { fHeight = 1, dHeight = 0, fWidth = 0, dWidth = Pages.Bar.Thickness }
        end
    end

    if Pages.Bar.Dock and config.Template then
        local anchor1, anchor2 = getAnchorsFromDock(Pages.Bar.Dock)

        if anchor1 and anchor2 then
            config.Template.Anchors = {
                { Point = anchor1, RelPoint = anchor1 },
                { Point = anchor2, RelPoint = anchor2 }
            }
        end
    end

    return Pages.Bar.Category .. ".Unit." .. Pages.Bar.Type
end

Pages.Text.Load = function(category, dispType, defaultPresetID)
    local page = Pages.Text
    local config = Config and Config[category] and Config[category].Unit and Config[category].Unit[dispType]

    if type(page.Page) == "string" then
        page.Page = _G[page.Page] or page.Page
    end

    if not config then
        config = Presets.Load({ _preset = { Type = page.PresetType, ID = defaultPresetID } }, true)
    else
        page.Active = true
    end

    page.Config = {}
    IO.DeepCopy(config, page.Config)

    local anchor = page.Config.Template and page.Config.Template.Anchors[1] or { Point = "CENTER", RelPoint = "CENTER", OffsetX = 0, OffsetY = 0 }
    --local size = page.Config.Template and page.Config.Template.Size or { Width = 16, Height = 16 }
    page.Anchor = anchor.Point or "CENTER"
    page.OffsetX = anchor.OffsetX or 0
    page.OffsetY = anchor.OffsetY or 0
    --Pages.Buff.Width = size.Width or 16
    --Pages.Buff.Height = size.Height or 16
    --page.Active = true
end

Pages.Text.Update = function()
    local page = Pages.Text
    page.Page:Hide()
    page.Page:Show()

    page.CanToggle = page.Type == "NameDisplay"

    local anchor = { Point = page.Anchor, RelPoint = page.Anchor, OffsetX = page.OffsetX, OffsetY = page.OffsetY }
    local size = page.Config.Template.dSize

    RH_ConfigMenu_Preview:Show()
    ConfigMenu.UpdatePreview(page.Category, size, {anchor}, true)
end

Pages.Text.Save = function()
    return Pages.Text.Category .. ".Unit." .. Pages.Text.Type
end

Pages.CatGeneral.Load = function(category)
    local page = Pages.CatGeneral

    if type(page.Page) == "string" then
        page.Page = _G[page.Page] or page.Page
    end

    local config = RaidHeal.Config[category]
    if not config then
        config = Profiles.KnownList.Default[category]
    end

    page.Config = {}
    IO.DeepCopy(config, page.Config)

    page.Active = true
end

Pages.CatGeneral.Update = function()
    Pages.CatGeneral.IsGrid = Pages.CatGeneral.Category == "Grid"

    local groupAlign = Pages.CatGeneral.Config.GroupAlign
    local unitAlign = Pages.CatGeneral.Config.UnitAlign
    if groupAlign == "TOP" or groupAlign == "BOTTOM" then
        if unitAlign ~= "RIGHT" then unitAlign = "LEFT" end
        Menu.LoadDropDownList(RH_ConfigMenu_PageCategoryGeneral_UnitAlign, "AnchorSides2H")
    else
        if unitAlign ~= "BOTTOM" then unitAlign = "TOP" end
        Menu.LoadDropDownList(RH_ConfigMenu_PageCategoryGeneral_UnitAlign, "AnchorSides2V")
    end
    Pages.CatGeneral.Config.UnitAlign = unitAlign

    RH_ConfigMenu_Preview:Hide()
    Pages.CatGeneral.Page:Hide()
    Pages.CatGeneral.Page:Show()
end

Pages.CatGeneral.Save = function()
    return Pages.CatGeneral.Category
end

Pages.Buff.Load = function(category, buffType, defaultPresetID, index)
    local page = Pages.Buff
    local config = Config and Config[category] and Config[category].Unit and Config[category].Unit[buffType] and Config[category].Unit[buffType][index]

    if type(page.Page) == "string" then
        page.Page = _G[page.Page] or page.Page
    end

    if not config then
        config = Presets.Load({ _preset = { Type = Pages.Buff.PresetType, ID = defaultPresetID } }, true)
    end

    Pages.Buff.Index = index
    Pages.Buff.Config = {}
    IO.DeepCopy(config, Pages.Buff.Config)

    local anchor = Pages.Buff.Config.Template and Pages.Buff.Config.Template.Anchors and Pages.Buff.Config.Template.Anchors[1] or { Point = "CENTER", RelPoint = "CENTER", OffsetX = 0, OffsetY = 0 }
    local size = Pages.Buff.Config.Template and Pages.Buff.Config.Template.Size or { Width = 16, Height = 16 }
    Pages.Buff.Anchor = anchor.Point or "CENTER"
    Pages.Buff.OffsetX = anchor.OffsetX or 0
    Pages.Buff.OffsetY = anchor.OffsetY or 0
    Pages.Buff.Width = size.Width or 16
    Pages.Buff.Height = size.Height or 16

    Pages.Buff.Active = true
end

Pages.Buff.Update = function()
    local page = Pages.Buff
    page.Page:Hide()
    page.Page:Show()

    local anchor = { Point = page.Anchor, RelPoint = page.Anchor, OffsetX = page.OffsetX, OffsetY = page.OffsetY }
    local size = { Width = page.Width, Height = page.Height }

    RH_ConfigMenu_Preview:Show()
    ConfigMenu.UpdatePreview(page.Category, size, {anchor}, true)
end

Pages.Buff.Save = function()
    local page = Pages.Buff

    local anchor = { Point = page.Anchor, RelPoint = page.Anchor, OffsetX = page.OffsetX, OffsetY = page.OffsetY }
    local size = { Width = page.Width, Height = page.Height }

    page.Config.Template.Anchors = { anchor }
    page.Config.Template.Size = size

    return page.Category .. ".Unit." .. page.Type .. "." .. page.Index
end

------------------------------------------------------

ConfigMenu.OnAddBuffButtonClick = function(parent, category, buffType, defaultPresetID)
    if not Config or not Config[category] or not Config[category].Unit then
        Log.Error(_FILENAME_, "Invalid Config")
        return
    end

    if not Config[category].Unit[buffType] then
        Config[category].Unit[buffType] = { Count = 0 }
    end

    local buffConfig = Config[category].Unit[buffType]
    buffConfig.Count = (buffConfig.Count or 0) + 1
    buffConfig[buffConfig.Count] = Presets.Load({ _preset = { Type = Pages.Buff.PresetType, ID = defaultPresetID } }, true)

    Events.DoEvent("PROFILE_LOADED")

    parent:Hide()
    parent:Show()
end

ConfigMenu.OnRemoveBuffButtonClick = function()
    local page = Pages.Buff

    local category = page.Category
    local buffType = page.Type
    local index = page.Index

    if not Config or not Config[category] or not Config[category].Unit or not Config[category].Unit[buffType] then
        Log.Error(_FILENAME_, "Invaid Config state")
        return
    end

    local buffConfig = Config[category].Unit[buffType]

    if not buffConfig[index] then
        Log.Error(_FILENAME_, "Tried to delete %s #%d: index not found", buffType, index)
        return
    end

    table.remove(buffConfig, index)
    buffConfig.Count = math.max(0, (buffConfig.Count or 0) - 1)

    page.Page:Hide()
    RH_ConfigMenu_Preview:Hide()

    local treeParent = ConfigMenu.Selected:GetParent()
    ConfigMenu.RemoveChild(treeParent, index)
    Events.DoEvent("PROFILE_LOADED")
end

ConfigMenu.ReloadPage = function()
    local mode = ConfigMenu.Mode
    local page = Pages[mode]

    local category = page.Category
    local elemType = page.Type
    local presetID = page.PresetBaseID
    local index = page.Index or nil

    ConfigMenu.LoadPage(mode, category, elemType, presetID, index)
end