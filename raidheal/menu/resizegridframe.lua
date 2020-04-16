local RaidHeal = _G.RaidHeal
local ResizeGridFrame = RaidHeal.Menu.ResizeGridFrame
local UI = RaidHeal.UI
local Config = RaidHeal.Config

ResizeGridFrame.Show = function(category, callee)
    if not category or not UI[category] then return end

    ResizeGridFrame.Callee = callee

    if callee then callee:Hide() end

    if UI[category].BackFrame then
        local resizeFrame = RH_ResizeGridFrame
        local gridFrame = UI[category].BackFrame

        resizeFrame:ClearAllAnchors()
        resizeFrame:SetAnchor("TOPLEFT", "TOPLEFT", gridFrame)
        resizeFrame:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", gridFrame)

        resizeFrame:Show()

        ResizeGridFrame.Category = category
    end
end

ResizeGridFrame.Hide = function()
    RH_ResizeGridFrame:Hide()

    if ResizeGridFrame.Callee then ResizeGridFrame.Callee:Show() end

    if RH_ConfigMenu:IsVisible() then
        RaidHeal.Menu.ConfigMenu.ReloadPage()
    end
end

ResizeGridFrame.StartSizing = function(anchor)
    local frame = RH_ResizeGridFrame

    local opposite = { TOPLEFT = "BOTTOMRIGHT", TOPRIGHT = "BOTTOMLEFT", BOTTOMLEFT = "TOPRIGHT", BOTTOMRIGHT = "TOPLEFT" }
    if not opposite[anchor] then error() end

    local posX, posY = frame:GetPos()
    local width, height = frame:GetSize()
    local scale = UIParent:GetRealScale()

    local offsetX, offsetY = posX / scale, posY / scale

    if anchor:sub(1,3) == "TOP" then offsetY = offsetY + height end
    if anchor:sub(-4) == "LEFT" then offsetX = offsetX + width end

    frame:ClearAllAnchors()
    frame:SetAnchor(opposite[anchor], "TOPLEFT", "UIParent", offsetX, offsetY)
    frame:StartSizing(anchor)
end

ResizeGridFrame.Save = function()
    local category = ResizeGridFrame.Category
    if not category then return end

    local gridParent = Config[category].Parent and _G[Config[category].Parent] or UIParent
    local resizeFrame = RH_ResizeGridFrame

    local absPosX, absPosY = resizeFrame:GetPos()
    local absWidth, absHeight = resizeFrame:GetSize()
    local screenWidth, screenHeight = gridParent:GetSize()
    local scale = UIParent:GetRealScale()

    local point = ResizeGridFrame.Point

    if not point then
        local oldAnchor = Config[category].Anchor
        point = oldAnchor.Point
    end

    local relPosX = absPosX / (scale * screenWidth)
    local relPosY = absPosY / (scale * screenHeight)

    local relWidth = absWidth / screenWidth
    local relHeight = absHeight / screenHeight

    if point:sub(-5) == "RIGHT" then
        relPosX = (relPosX + relWidth) - 1
    elseif point:sub(-4) == "LEFT" then
        -- nothing to do here
    else
        relPosX = (relPosX + 0.5 * relWidth) - 0.5
    end

    if point:sub(1,3) == "TOP" then
        -- nothing to do here
    elseif point:sub(1,6) == "BOTTOM" then
        relPosY = (relPosY + relHeight) - 1
    else
        relPosY = (relPosY + 0.5 * relHeight) - 0.5
    end

    Config[category].Anchor = { Point = point, RelPoint = point, OffsetX = relPosX, OffsetY = relPosY }
    --Config[category].Pos = { X = absPosX / (scale * screenWidth), Y = absPosY / (scale * screenHeight) }
    Config[category].Size = { Width = relWidth, Height = relHeight }

    UI[category].OnProfileLoaded()
    --GridUI.Arrange()
end
