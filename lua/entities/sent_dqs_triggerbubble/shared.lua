AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "TRIGGERBUBBLE"
ENT.Category = "Dynamic Quest System"

ENT.Spawnable = false // intentional

// Also intentional as cl_init.lua doesn't get run in multiplayer.
function ENT:Draw()
    if(LocalPlayer() == self:GetNW2Entity("quest_player")) then
        self:DrawModel()
    end
end