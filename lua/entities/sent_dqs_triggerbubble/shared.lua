AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "TRIGGERBUBBLE"
ENT.Category = "Dynamic Quest System"

ENT.Spawnable = false -- Intentional

-- Also intentional because cl_init.lua is not getting run, even with AddCSLuaFile()..
function ENT:Draw()
    if (LocalPlayer() == self:GetNW2Entity("quest_player")) then
        self:DrawModel()
    end
end