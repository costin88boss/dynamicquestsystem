include("shared.lua")

ENT.alphaTransition = 0
ENT.color = Color(255, 255, 255, 255)

function ENT:Draw()
    -- Look at local player
    local ply = LocalPlayer()

    if (ply:GetPos():Distance(self:GetPos()) < 256) then
        self:SetEyeTarget(ply:GetShootPos())

        --local headBone = self:LookupBone("ValveBiped.Bip01_Head1")
        --local headBonePos, headBoneAng = self:GetBonePosition(headBone)

        -- For some reason the head gets duplicated when doing this, likely due to the idle anim.
        -- I'm too lazy to find out how to fix it.

        --self:SetBonePosition(headBone, headBonePos, headBoneAng + Angle(0, math.sin(CurTime() * 2) * 10, 0))
    end

    if (self.alphaTransition > 0) then
        self.alphaTransition = self.alphaTransition - 30 * FrameTime()
        
        self.color.a = self.alphaTransition
        self:SetColor(self.color)
    end
    if (self.color.a > 0) then
        self:DrawModel()
    end
end

net.Receive("cdqs_TransparencyTransition", function()
    local ent = net.ReadEntity()
    ent.alphaTransition = 255
end)