local spawningFailsafe = false

local function StartSpawnSystem()
    timer.Start("costin_dqs_spawntimer")
end

local function StopSpawnSystem()
    timer.Stop("costin_dqs_spawntimer")
end

local function HandleSpawnSystem()
    if(#costin_dqs.navmeshAreas == 0) then
        print("No navmesh areas found!")
        return 
    end
    
    if (spawningFailsafe == true) then 
        error("Spawning failsafe activated! There is no suitable navmesh area to spawn NPCs in.")
        return
    end

    if (#costin_dqs.npcs >= costin_dqs.convars.convar_maxnpcamount:GetInt()) then return end

    spawningFailsafe = true
    for i = 1, 1000 do
        local fail = false
        local area = costin_dqs.navmeshAreas[math.random(1, #costin_dqs.navmeshAreas)]

        if (area:IsUnderwater()) then
            costin_dqs.utils:Print("Failed to spawn, underwater! Re-trying!")
            continue
        end

        local vec = area:GetRandomPoint()

        local ent = nil
        if (table.IsEmpty(costin_dqs.sleepingNPCs)) then
            ent = ents.Create("npc_dqs_questgiver")
        else
            ent = costin_dqs.sleepingNPCs[1]
            table.remove(costin_dqs.sleepingNPCs, 1)
        end

        if (!ent:IsValid()) then
            continue
        end

        if (!ent:IsInWorld()) then
            -- Redundant, because navmeshes don't exist outside the world.
            costin_dqs.utils:Print("Failed to spawn, out of world! Re-trying!")
            table.insert(costin_dqs.sleepingNPCs, ent)
            continue
        end

        vec.z = vec.z + 20
        ent:SetPos(vec)

        for j, ply in pairs(player.GetHumans()) do
            local dist = ply:GetPos():Distance2D(vec)
            if (dist < costin_dqs.convars.convar_mindistancefromplayers:GetInt()) then
                costin_dqs.utils:Print("Failed to spawn, too close to a player! Re-trying!")
                fail = true 
                break
            end

            if (!costin_dqs.utils:IsEntityInPlayerView(ply, ent)) then continue end

            -- trace is a bit ineffective as it does just a ray
            local traceCfg = {}
            traceCfg.start = ply:GetPos()
            traceCfg.endpos = ent:GetPos()
            traceCfg.filter = { ply, ent }
            
            trace = util.TraceLine(traceCfg)

            if (trace.Hit) then continue end

            costin_dqs.utils:Print("Failed to spawn, in player view! Re-trying!")
            fail = true
            break
        end
        if (fail) then 
            table.insert(costin_dqs.sleepingNPCs, ent)
            continue 
        end

        -- FIXME: check if it's colliding with a prop or entity!!!!

        ent:SetQuestType(math.random(1, #costin_dqs.questType.types))

        -- Hacky stuff, check ENT:ActualInit() comment
        ent.worldSpawnerSpawned = true
        ent:ActualInit()
        
        ent:Spawn()
        ent:Activate()

        costin_dqs.utils:Print("Spawned at: " .. vec.x .. ", ".. vec.y.. ", ".. vec.z)
        spawningFailsafe = false
        break
    end
end

cvars.AddChangeCallback("costin_dqs_spawndelay", function(convar, old, new)
    timer.Adjust("costin_dqs_spawntimer", costin_dqs.convars.convar_delay:GetInt(), 0, HandleSpawnSystem)
end)

cvars.AddChangeCallback("costin_dqs_mapspawnerenabled", function(convar, old, new)
    if (tonumber(new) >= 1) then
        StartSpawnSystem()
        return
    end
    StopSpawnSystem()
end)

timer.Create("costin_dqs_spawntimer", costin_dqs.convars.convar_delay:GetInt(), 0, HandleSpawnSystem)
timer.Stop("costin_dqs_spawntimer")