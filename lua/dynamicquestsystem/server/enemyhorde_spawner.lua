-- Highly unoptimized
function costin_dqs:SpawnHordeRand(npcType, count, ply)
    if(#costin_dqs.navmeshAreas == 0) then
        print("No navmesh areas found!")
        return 
    end
    local npcs = {}

    for j = 1, count do
        for i = 1, 1000 do
            local area = costin_dqs.navmeshAreas[math.random(1, #costin_dqs.navmeshAreas)]

            if (area:IsUnderwater()) then continue end

            local pointPos = area:GetRandomPoint()

            local distance = ply.dqs_activeQuestNPC:GetPos():Distance(area:GetRandomPoint(pointPos))

            if (distance > costin_dqs.convars.convar_enemyspawn_distmax:GetInt() or distance < costin_dqs.convars.convar_enemyspawn_distmin:GetInt()) then continue end

            local traceCfg = {}
            traceCfg.start = ply:EyePos()
            traceCfg.endpos = pointPos + Vector(0, 0, 70)
            traceCfg.filter = function(ent)
                --if (ent == ply) then return false end
                --if (ent == ply.dqs_activeQuestNPC) then return false end
                return false
            end
            
            trace = util.TraceLine(traceCfg)

            if (!trace.Hit) then continue end

            local ent = ents.Create("npc_combine_s")
        
            ent:SetPos(pointPos + Vector(0, 0, 60))

            ent:Give("weapon_smg1")
            
            ent:SetNPCState(NPC_STATE_ALERT)
            
            ent:Spawn()
            ent:Activate()
            
            table.insert(npcs, ent)
            break 
        end
    end

    return npcs
end