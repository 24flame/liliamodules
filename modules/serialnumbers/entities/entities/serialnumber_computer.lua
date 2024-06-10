AddCSLuaFile()

local MODULE = MODULE or {}
FlamesserialNumbers = FlamesserialNumbers or {}

ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName		= "Serial numbers computer"
ENT.Author			= "Flame"
ENT.Category        = "lilia"
ENT.Spawnable       = true

if SERVER then
    function ENT:Initialize()
        self:SetModel( "models/props_lab/monitor02.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        local physObj = self:GetPhysicsObject()
        if physObj:IsValid() then
            physObj:Wake()
        end
    end
    function ENT:Use( ply )
        if not FlamesserialNumbers.Factions[ply:Team()] then
            return
        end
        if ply:GetEyeTrace().Entity == nil || (ply:GetEyeTrace().Entity != nil && ply:GetEyeTrace().Entity:GetClass() != "serialnumber_computer") then
            ply:notify("Cannot perform: Make sure you are looking directly at the computer.")
            return false
        end
        net.Start( "SerialNumbers.OpenComputer" )
        net.Send( ply )
    end
end
if CLIENT then
    local TEXT_OFFSET = Vector(0, 0, -20)
    local toScreen = FindMetaTable("Vector").ToScreen
    local colorAlpha = ColorAlpha
    local drawText = lia.util.drawText
    local configGetcolor = lia.config.Color
    ENT.DrawEntityInfo = true
    function ENT:onDrawEntityInfo(alpha)
        local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
        local x, y = position.x, position.y
        drawText("Serial numbers computer", x, y, colorAlpha(configGetcolor, alpha), 1, 1, nil, alpha * 0.65)
    end
end