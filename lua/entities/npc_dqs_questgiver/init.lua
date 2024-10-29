include("entities/npc_dqs_questgiver/shared.lua")

costin_dqs = costin_dqs or {}
costin_dqs.npcs = costin_dqs.npcs or {}

// Used to pool NPCs instead of spawning/deleting over and over.
// Very slight performance increase.
costin_dqs.sleepingNPCs = costin_dqs.sleepingNPCs or {}

util.AddNetworkString("cdqs_OpenNpcQuestMenu")
util.AddNetworkString("cdqs_TransparencyTransition")

ENT.UseCustomUseFunc = false

local eyeHeight = Vector(0, 0, 64)

function ENT:UseFunction(ply)
   ply:ChatPrint("[FINISH THE QUEST BEFORE RETURNING TO THE NPC!]")
end

function ENT:Disappear(ply)
    self.UseFunction = function()
        // No use, I don't "exist" anymore.
    end

    table.RemoveByValue(costin_dqs.npcs, self)

    self:SetCollisionGroup(COLLISION_GROUP_WORLD)

    undo.ReplaceEntity(self, nil)

    self.disappear = true
    net.Start("cdqs_TransparencyTransition")
    net.WriteEntity(self)
    net.Broadcast()
end

function ENT:RunBehaviour()
	while(true) do
        if(self.disappear) then

            self:StartActivity( ACT_WALK )
            self.loco:SetDesiredSpeed( 100 )
            self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 750 )
            self:StartActivity( ACT_IDLE )
            
            self.disappear = false
            table.insert(costin_dqs.sleepingNPCs, self)
        end
		coroutine.yield()
	end
end

function ENT:Use(ply)
    if(self.UseCustomUseFunc) then
        if(self.dqs_ply == ply) then
            self:UseFunction(ply)
        else
            local tableContainsMe = false
            for i, npc in pairs(costin_dqs.sleepingNPCs) do
                if(npc == self) then
                    tableContainsMe = true
                    break
                end
            end
            if(!tableContainsMe && !self.disappear) then
                ply:ChatPrint("[ANOTHER PLAYER IS USING THIS QUEST NPC!]")
            end
        end
    else
        if(ply.dqs_activeQuestNPC != nil) then
            ply:ChatPrint("[A QUEST IS ALREADY ACTIVE!]")
            return 
        end

        ply.dqs_selectedNPC = self
        net.Start("cdqs_OpenNpcQuestMenu")
        net.WriteEntity(self)
        net.Send(ply)

        // Used so the timer can get removed if the entity is removed
        local index = self:EntIndex()

        // Anti-exploit I guess, hope I made it right.
        // It checks if the player is in entity range to make sure that he can't start a quest while far away.
        timer.Create("costin_dqs_validitycheck_" .. index, 1, 0, function()
            if(!self:IsValid() or !ply:IsValid()) then
                timer.Remove("costin_dqs_validitycheck_" .. index)
                return
            end
            local distance = ply:GetPos():Distance(self:GetPos())
            if(self.dqs_ply != nil) then
                timer.Remove("costin_dqs_validitycheck_" .. index)
                return
            end
            if(distance > 150) then
                ply.dqs_selectedNPC = nil
                timer.Remove("costin_dqs_validitycheck_" .. index)
            end
        end)
    end
end

// Placeholder for custom quest cleanups.
function ENT:CleanupFunc() 

end

// This is used for slight performance increase.
// Default hooks will get called on creation, and to be honest I'm lazy to carefully use ENT:Spawn().
// This offers no disadvantage, so I don't care.

// This is also used for NPC pooling via costin_dqs.sleepingNPCs to improve a bit of performance even more.
function ENT:ActualInit()
    self:SetMaxHealth(99999999)
    self:SetHealth(99999999)
    local variant = 0
    if(math.random(1, 2) == 1) then
        // Man
        variant = math.random(1, 9)
        self:SetModel("models/humans/group01/male_0" .. variant.. ".mdl")
    else
        // Woman
        variant = math.random(1, 7)
        if(variant == 5) then variant = 6 end // 5 doesn't exist bruh
        self:SetModel("models/humans/group01/female_0" .. variant.. ".mdl")
    end

    self:SetAngles(Angle(0, math.random(-180, 180), 0))

    self:SetSolid(SOLID_BBOX)

    self:SetMoveType(MOVETYPE_NONE)
    self:StartActivity(ACT_IDLE)
    self:SetUseType(SIMPLE_USE)

    self:SetColor(Color(255, 255, 255, 255))
    
    self:DropToFloor()

    table.insert(costin_dqs.npcs, self)
end