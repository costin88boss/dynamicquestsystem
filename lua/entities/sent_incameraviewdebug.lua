// File not removed for demonstration purposes
AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Spawnable = true
ENT.Category = "Dynamic Quest System"
ENT.PrintName = "CAMERA VIEW DEBUG TEST"

if(CLIENT) then return end

local y2 = 0
local ply = nil

function ENT:SpawnFunction(ply_, tr)
	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

    local ent = ents.Create("sent_incameraviewdebug")
	ent:SetPos(SpawnPos)
    ent:SetModel("models/props_c17/oildrum001.mdl")
    ent:SetMaterial("models/debug/debugwhite")
    ent:SetSolid(SOLID_VPHYSICS)
	ent:Spawn()
	ent:Activate()

    ply = ply_    
    return ent
end

function ENT:Think()
    if costin_dqs.utils:IsEntityInPlayerView(ply, self) then
        costin_dqs.utils:Print("In player view!")
    else
        costin_dqs.utils:Print("Not in player view!")
    end

    self:NextThink(CurTime())
    return true
end