include("shared.lua")
local TEXT_OFFSET = Vector(0, 0, -20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = lia.util.drawText
local configGetcolor = lia.config.Color
function ENT:onDrawEntityInfo(alpha)
    local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
    local x, y = position.x, position.y
    drawText("Serial numbers computer", x, y, colorAlpha(configGetcolor, alpha), 1, 1, nil, alpha * 0.65)
end