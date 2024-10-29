include("weapons/swep_dqs_snitcher/shared.lua")

function SWEP:Deploy()
    self:GetOwner():SetNW2Bool("CanSeeQuestNpcsXray", true)
    return true
end

function SWEP:Holster()
    self:GetOwner():SetNW2Bool("CanSeeQuestNpcsXray", false)
    return true
end