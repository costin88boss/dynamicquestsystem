AddCSLuaFile()

costin_dqs = costin_dqs or {}
costin_dqs.npcs = costin_dqs.npcs or {}

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

ENT.PrintName = "Quest Giver"
ENT.Category = "Dynamic Quest System"

ENT.Spawnable = true
ENT.AdminOnly = true

// Hacky var, check ENT:ActualInit() comment
if(SERVER) then
    ENT.worldSpawnerSpawned = false
end

if(CLIENT) then
    ENT.alphaTransition = 0
    ENT.color = Color(255, 255, 255, 255)
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "QuestType")
end

function ENT:Initialize()
    if(SERVER) then
        if(!self.worldSpawnerSpawned) then
            self:SetQuestType(math.random(1, costin_dqs.questType.MaxVal))
            self:ActualInit()
        end
    else
        table.insert(costin_dqs.npcs, self)
    end

    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
end

function ENT:OnRemove()
    // Both server and client.
    table.RemoveByValue(costin_dqs.npcs, self)

    if(SERVER) then
        table.RemoveByValue(costin_dqs.sleepingNPCs, self)
    end

    if(CLIENT) then return end
 
    if(self.dqs_ply != nil) then
        costin_dqs:UpdateQuest(self, 2)
    end
    self:CleanupFunc()
end

function ENT:Draw()
    // Look at local player
    local ply = LocalPlayer()

    if(ply:GetPos():Distance(self:GetPos()) < 256) then
        self:SetEyeTarget(ply:GetShootPos())

        //local headBone = self:LookupBone("ValveBiped.Bip01_Head1")
        //local headBonePos, headBoneAng = self:GetBonePosition(headBone)

        // For some reason the head gets duplicated when doing this, likely due to the idle anim.
        // I'm too lazy to find out how to fix it.

        //self:SetBonePosition(headBone, headBonePos, headBoneAng + Angle(0, math.sin(CurTime() * 2) * 10, 0))
    end

    if(self.alphaTransition > 0) then
        self.alphaTransition = self.alphaTransition - 30 * FrameTime()
        
        self.color.a = self.alphaTransition
        self:SetColor(self.color)
    end
    if(self.color.a > 0) then
        self:DrawModel()
    end
end

net.Receive("cdqs_TransparencyTransition", function()
    local ent = net.ReadEntity()
    ent.alphaTransition = 255
end)