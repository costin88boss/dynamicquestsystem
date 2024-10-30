AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Deploy()
    self:GetOwner():SetNW2Bool("CanSeeQuestNpcsXray", true)
    return true
end

function SWEP:Holster()
    self:GetOwner():SetNW2Bool("CanSeeQuestNpcsXray", false)
    return true
end