local RaidHeal = _G.RaidHeal
local Frames = RaidHeal.Frames

local Events = _G.RaidHeal.Events
local IO = _G.RaidHeal.IO
local Log = _G.RaidHeal.Log

local _FILENAME_ = "frames.lua"

Frames.CreateFromTemplate = function(template, name, parent)
    if not template or type(template) ~= "table" then
        error("Frames.CreateFromTemplate: Invalid Template specified", 2)
    end
    if not name then error("Frames.CreateFromTemplate: Name required", 2) end
    if not parent then parent = "UIParent" end

    if template.Type then
        local frame = CreateUIComponent(template.Type, name, parent)
        frame._type = template.Type

        return Frames.Arrange(frame, template)
    else
        local result = {}

        for key, value in pairs(template) do
            if value and type(value) == "table" then
                result[key] = Frames.CreateFromTemplate(value, name..key, parent)
            end
        end

        if next(result) == nil then
            result = nil
        end

        return result
    end
end

Frames.Arrange = function(frame, template)
    local lutOptions = {
        Texture = "SetTexture",
        Text = "SetText",
        Justify = "SetJustifyHType",
        BackDrop = "SetBackdrop",
        Alpha = "SetAlpha",
        AlphaMode = "SetAlphaMode",
        FrameLevel = "SetFrameLevel",
    }
    for key, value in pairs(template) do
        if lutOptions[key] and frame[lutOptions[key]] then
            frame[lutOptions[key]](frame, value)
        end
    end

    if template.Font and frame.SetFont then frame:SetFont(template.Font.Path, template.Font.Size, template.Font.Weight, template.Font.Outline) end
    if template.TexCoord and frame.SetTexCoord then frame:SetTexCoord(template.TexCoord.Left, template.TexCoord.Right, template.TexCoord.Top, template.TexCoord.Bottom) end
    if template.Size then frame:SetSize(template.Size.Width or 0, template.Size.Height or 0) end

    -------------------------------------------------------

    local oldElems = frame._oldElems or {}

    for k, v in pairs(frame) do
        if type(v) == "table" and v._type then
            oldElems[k] = v
            frame[k] = nil
            v:Hide()
        end
    end

    local function setAnchor(elem, anchor)
        local relTo = frame

        if anchor.RelTo then
            if type(anchor.RelTo) == "string" then
                if frame[anchor.RelTo] then
                    relTo = frame[anchor.RelTo]
                elseif _G[anchor.RelTo] then
                    relTo = _G[anchor.RelTo]
                end
            elseif type(anchor.RelTo) == "table" then
                relTo = anchor.RelTo
            end
        end

        elem:SetAnchor(anchor.Point, anchor.RelPoint or anchor.Point, relTo, anchor.OffsetX or 0, anchor.OffsetY or 0)
    end

    if template.Elements then
        local iterateList = {}

        local function iterate(elements, oldElems, parent, parentName)
            for elemName, elemTemplate in pairs(elements) do
                if oldElems and oldElems[elemName] and oldElems[elemName]._type then
                    parent[elemName] = Frames.Arrange(oldElems[elemName], elemTemplate)
                    oldElems[elemName] = nil

                    iterateList[parent[elemName]] = elemTemplate
                else
                    if elemTemplate.Type and elemName ~= "_preset" then
                        parent[elemName] = Frames.CreateFromTemplate(elemTemplate, frame:GetName() .. "_" .. parentName .. elemName, frame:GetName())

                        iterateList[parent[elemName]] = elemTemplate
                    elseif type(elemTemplate) == "table" then
                        local data = {}
                        local oldData = parent[elemName] or {}

                        iterate(elemTemplate, oldData, data, parentName .. elemName)
                        if next(data) == nil then
                            data = nil
                        end

                        parent[elemName] = data
                    else
                        Log.Error(_FILENAME_, "cant find appropriate handling for element %s", tostring(elemName))
                    end
                end
            end
        end

        iterate(template.Elements, oldElems, frame, "")

        for elem, elemTemplate in pairs(iterateList) do
            if elemTemplate.dSize then
                elem:SetHeight(frame:GetHeight() * (elemTemplate.dSize.fHeight or 1) + (elemTemplate.dSize.dHeight or 0))
                elem:SetWidth(frame:GetWidth() * (elemTemplate.dSize.fWidth or 1) + (elemTemplate.dSize.dWidth or 0))
            end

            if elemTemplate.Anchors then
                elem:ClearAllAnchors()
                for _, anchor in pairs(elemTemplate.Anchors) do
                    setAnchor(elem, anchor)
                end
            elseif elemTemplate.Anchor then
                elem:ClearAllAnchors()
                setAnchor(elem, elemTemplate.Anchor)
            end

            if elemTemplate.Layer and (elem._type == "Texture" or elem._type == "FontString") and not elem._layer then
                frame:SetLayers(elemTemplate.Layer, elem)
                elem._layer = elemTemplate.Layer
            end
        end
    end

    if next(oldElems) == nil then oldElems = nil end
    frame._oldElems = oldElems

    frame:Show()

    return frame
end
