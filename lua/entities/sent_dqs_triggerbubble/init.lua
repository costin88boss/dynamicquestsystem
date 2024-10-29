include("entities/sent_dqs_triggerbubble/shared.lua")

function ENT:Initialize()
    self:SetModel("models/hunter/misc/sphere1x1.mdl")
    self:SetMaterial("models/debug/debugwhite")

    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    self:SetColor(Color(255, 255, 255, 170))

    // the VPhysics of the model doesn't work when increasing model scale
    // (I'm probably just missing something)
    self:SetSolid(SOLID_OBB)

    self:SetModelScale(10)

    self:SetPos(self:GetPos() + Vector(0, 0, self:GetModelBounds().x))

    self:SetCustomCollisionCheck(true)
    self:EnableCustomCollisions()
end

ENT.TriggerFunc = function(ply)
    // Shouldn't be seen
   print("PLACEHOLDER TRIGGER FUNC")
end

// No need to predict on client
hook.Add("ShouldCollide", "costin_dqs_triggerbubblecollide", function(ent1, ent2)
    // Actual bubble collision yey
    local distance = ent1:GetPos():Distance(ent2:GetPos())

    if(ent1:GetClass() == "sent_dqs_triggerbubble") then
        if(!ent2:IsPlayer()) then return end
        if(distance < 250) then
            ent1:TriggerFunc(ent2)
        end
        return
    end
    if(ent2:GetClass() == "sent_dqs_triggerbubble") then
        if(!ent1:IsPlayer()) then return end
        if(distance < 250) then
            ent2:TriggerFunc(ent1)
        end
        return
    end
    
    return
end)