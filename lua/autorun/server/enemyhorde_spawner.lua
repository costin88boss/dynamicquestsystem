costin_dqs = costin_dqs or {}

// Highly unoptimized
function costin_dqs:SpawnHordeRand(npcType, count, ply)
    local npcs = {}

    local pointPos = nil

    for j = 1, count do
        for i = 1, 1000 do
            local area = costin_dqs.navmeshAreas[math.random(1, #costin_dqs.navmeshAreas)]
            if(!area:IsUnderwater()) then 
                pointPos = area:GetRandomPoint()

                local distance = ply.dqs_activeQuestNPC:GetPos():Distance(area:GetRandomPoint(pointPos))
                if(distance < costin_dqs.convar_enemyspawn_distmax:GetInt() and distance > costin_dqs.convar_enemyspawn_distmin:GetInt()) then
                    local traceCfg = {}
                    traceCfg.start = ply:EyePos()
                    traceCfg.endpos = pointPos + Vector(0, 0, 70)
                    traceCfg.filter = function(ent)
                        //if(ent == ply) then return false end
                        //if(ent == ply.dqs_activeQuestNPC) then return false end
                        return false
                    end
                    
                    trace = util.TraceLine(traceCfg)

                    if(trace.Hit) then 
                        local ent = ents.Create("npc_combine_s")
        
                        ent:SetPos(pointPos + Vector(0, 0, 60))

                        ent:Give("weapon_smg1")
                
                        ent:SetNPCState(NPC_STATE_ALERT)
                
                        ent:Spawn()
                        ent:Activate()
                
                        table.insert(npcs, ent)
                        break 
                    else pointPos = nil
                    end
                else pointPos = nil
                end
            end
        end
    end

    return npcs
end