AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/hunter/misc/sphere1x1.mdl")
    self:SetMaterial("models/debug/debugwhite")

    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    self:SetColor(Color(255, 255, 255, 170))

    -- the VPhysics of the model doesn't work when increasing model scale
    -- (I'm probably just missing something)
    self:SetSolid(SOLID_OBB)

    self:SetModelScale(10)

    self:SetPos(self:GetPos() + Vector(0, 0, self:GetModelBounds().x))

    self:SetCustomCollisionCheck(true)
    self:EnableCustomCollisions()
end

ENT.TriggerFunc = function(ply)

end


-- No need to predict on client
hook.Add("ShouldCollide", "costin_dqs_triggerbubblecollide", function(ent1, ent2)
    -- Actual bubble collision yey
    local bubble = nil
    local ply = nil 
    

    if (ent1:GetClass() == "sent_dqs_triggerbubble") then
        bubble = ent1
        if (ent2:IsPlayer()) then
            ply = ent2
        end
    else 
        if (ent2:GetClass() == "sent_dqs_triggerbubble") then
            bubble = ent1
            if (ent1:IsPlayer()) then
                ply = ent1
            end
        end
    end
    if (ply == nil or bubble == nil) then return end 

    local distance = bubble:GetPos():Distance(ply:GetPos())

    if (!bubble or !ply) then return end
    
    if (distance < 250) then
        bubble.TriggerFunc(ply)
    end
    return
end)