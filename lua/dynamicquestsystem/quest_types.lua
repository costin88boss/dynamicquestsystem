costin_dqs.questType.GOTOAREA = {}
costin_dqs.questType.GOTOAREA.printName = "Go to area."
costin_dqs.questType.GOTOAREA.runFunc = function(ply)
    local area = nil
    while(true) do
        area = costin_dqs.navmeshAreas[math.random(1, #costin_dqs.navmeshAreas)]
        if (!area:IsUnderwater()) then break end
    end
    local targetPos = area:GetRandomPoint()

    local ent = ents.Create("sent_dqs_triggerbubble")
    ent:SetNW2Entity("quest_player", ply)
    ent:SetPos(targetPos)
    ent:Spawn()
    ent:Activate()

    ply.dqs_activeQuestNPC.CleanupFunc = function()
        if (ent:IsValid()) then ent:Remove() end
    end

    costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 0, { targetPos, false })
    ent.TriggerFunc = function(ply)
        if (ent:IsValid()) then ent:Remove() end
        costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 0, { ply.dqs_activeQuestNPC:GetPos() + Vector(0, 0, 60), true })

        ply.dqs_activeQuestNPC.UseFunction = function(ply_) 
            costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 1, { })
        end
    end
end
costin_dqs.questType.BRINGITEM = {}
costin_dqs.questType.BRINGITEM.printName = "Bring me item."
costin_dqs.questType.BRINGITEM.runFunc = function(ply)
    local area = nil
    while(true) do
        area = costin_dqs.navmeshAreas[math.random(1, #costin_dqs.navmeshAreas)]
        if (!area:IsUnderwater()) then break end
    end
    local targetPos = area:GetRandomPoint()

    local itemTypes = costin_dqs:GetBringMeItemTypes()

    local item = itemTypes[math.random(1, #itemTypes)]

    local ent = ents.Create("prop_physics")
    ent:SetModel(item)
    local _, max = ent:GetModelBounds()
    ent:SetPos(targetPos + Vector(0, 0, max.z + 15))

    ent:PhysicsInit(SOLID_VPHYSICS)
    ent:SetMoveType(MOVETYPE_VPHYSICS)
    ent:SetSolid(SOLID_VPHYSICS)

    
    ent:Spawn()
    ent:Activate()

    local defaultSpeed = ply:GetRunSpeed()

    ply.dqs_activeQuestNPC.CleanupFunc = function()
        if (ent:IsValid()) then ent:Remove() end
        ply:SetRunSpeed(defaultSpeed)
    end


    hook.Add("PlayerUse", "cdqs_bringmeitem_playeruse", function(ply_, ent_)
        if (ent_ != ent) then return end
        if (ply_ != ply) then return end
        if (ent_:IsPlayerHolding()) then return end

        costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 0, { ply.dqs_activeQuestNPC:GetPos(), true })

        local mass = ent_:GetPhysicsObject():GetMass()


        ply_:SetRunSpeed(defaultSpeed - mass)

        ply.dqs_activeQuestNPC.UseFunction = function(ply_) 
            ply:SetRunSpeed(defaultSpeed)
            costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 1, { })
        end

        hook.Remove("PlayerUse", "cdqs_bringmeitem_playeruse")
        ent_:Remove()
        return true
    end)

    costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 0, { ent:GetPos(), false })
end
costin_dqs.questType.DEFENDME = {}
costin_dqs.questType.DEFENDME.printName = "Defend me."
costin_dqs.questType.DEFENDME.runFunc = function(ply)
    local currentAmount = 5
    local npcs = costin_dqs:SpawnHordeRand("npc_combine_s", currentAmount, ply)

    if (npcs == {} || #npcs < currentAmount) then
        costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 2, { }, "QUEST ERROR: Could not spawn all NPCs validly! Try to increase the min/max ranges.")
        for i = 1, #npcs do
            npcs[i]:Remove()
        end
        return
    end

    ply.dqs_activeQuestNPC.CleanupFunc = function()
        timer.Remove("cdqs_defendme_updateinterval")
        for i = 1, #npcs do
            if (npcs[i]:IsValid()) then npcs[i]:Remove() end
        end
    end
    
    local tab = {}
    for i = 1, #npcs do
        table.insert(tab, npcs[i]:GetPos())
    end
    costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 0, tab)

    timer.Create("cdqs_defendme_updateinterval", 1, 0, function()
        if (ply.dqs_activeQuestNPC == nil) then
            timer.Remove("cdqs_defendme_updateinterval")
            return 
        end
        local tab = {}

        local alives = 0

        for i = 1, #npcs do
            if (npcs[i]:IsValid()) then
                table.insert(tab, npcs[i]:GetPos())
                alives = alives + 1
            end
        end
        costin_dqs:UpdateVariables(ply.dqs_activeQuestNPC, tab)

        if (alives < currentAmount) then
            currentAmount = alives

            -- Gives the "[OBJECTIVE UPDATED]" message
            costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 0, tab)
        end

        if (alives == 0) then
            costin_dqs:UpdateQuest(ply.dqs_activeQuestNPC, 1, {})
        end
    end)
end

costin_dqs.questType.types = {
    [1] = costin_dqs.questType.GOTOAREA,
    [2] = costin_dqs.questType.BRINGITEM,
    [3] = costin_dqs.questType.DEFENDME
}