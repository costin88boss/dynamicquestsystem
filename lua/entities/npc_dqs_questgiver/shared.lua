ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

ENT.PrintName = "Quest Giver"
ENT.Category = "Dynamic Quest System"

ENT.Spawnable = true
--ENT.AdminOnly = true

-- Hacky var, check ENT:ActualInit() comment
if (SERVER) then
    ENT.worldSpawnerSpawned = false
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "QuestType")
end

function ENT:Initialize()
    if (SERVER) then
        if (!self.worldSpawnerSpawned) then
            self:SetQuestType(math.random(1, #costin_dqs.questType.types))
            self:ActualInit()
        end
    else
        table.insert(costin_dqs.npcs, self)
    end

    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
end

function ENT:OnRemove()
    -- Both server and client.
    table.RemoveByValue(costin_dqs.npcs, self)

    if (SERVER) then
        table.RemoveByValue(costin_dqs.sleepingNPCs, self)
    end

    if (CLIENT) then return end
 
    if (self.dqs_ply != nil) then
        costin_dqs:UpdateQuest(self, 2)
    end
    self:CleanupFunc()
end

