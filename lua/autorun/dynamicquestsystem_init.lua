AddCSLuaFile()

costin_dqs = costin_dqs or {}
costin_dqs.npcs = costin_dqs.npcs or {}
costin_dqs.utils = costin_dqs.utils or {}
costin_dqs.questType = costin_dqs.questType or {}

costin_dqs.baseDir = "dynamicquestsystem/"

function costin_dqs.LoadShared(fn)
    local f = costin_dqs.baseDir .. fn
    if (SERVER) then
        AddCSLuaFile(f)
    end
    include(f)
end

function costin_dqs.LoadClient(fn)
    local f = costin_dqs.baseDir .. "client/" .. fn
    if (SERVER) then
        AddCSLuaFile(f)
    else
        include(f)
    end
end

function costin_dqs.LoadServer(fn)
    if(CLIENT) then return end

    local f = costin_dqs.baseDir .. "server/" .. fn
    include(f)
end

-- Server-only initialization stuff
if(SERVER) then
    costin_dqs.convars = costin_dqs.convars or {}

    -- Used to pool NPCs instead of spawning/deleting over and over.
    -- Very slight performance increase.
    costin_dqs.sleepingNPCs = costin_dqs.sleepingNPCs or {}

    local function LoadNavmeshAreas()
        if(costin_dqs.navmeshAreas != nil) then return end
        costin_dqs.navmeshAreas = navmesh.GetAllNavAreas()
    end

    local function InitPlyStuff(ply)
        ply:SetNW2Bool("CanSeeQuestNpcsXray", false)

        local totalQuestsCompleted = costin_dqs:GetPlayerTotalQuestsCompleted(ply)
        totalQuestsCompleted = totalQuestsCompleted or 0

        net.Start("cdqs_LocalTotalQuestsCompleted")
        net.WriteInt(totalQuestsCompleted, 32)
        net.Send(ply)
    end

    hook.Add("PlayerInitialSpawn", "costin_dqs_playerinitialspawn", function(ply)
        -- Dirty hack; Couldn't find a better init hook
        -- Probably not necessary and could have been added directly in HandleSpawnSystem()
        LoadNavmeshAreas()

        -- Writting this here so I don't make more hooks
        InitPlyStuff(ply)
    end)
end


-- Quest complete statuses. I didn't feel like making a separate file just for this.
costin_dqs.completeStatus = {}
costin_dqs.completeStatus.PROGRESSING = 0
costin_dqs.completeStatus.COMPLETE = 1
costin_dqs.completeStatus.FAILED = 2

-- Loading stuff
costin_dqs.LoadShared("util.lua")
//costin_dqs.LoadShared("quest_types.lua")

costin_dqs.LoadServer("sv_quest_types.lua")
costin_dqs.LoadServer("active_quest_updater.lua")
costin_dqs.LoadServer("data_handler.lua")
costin_dqs.LoadServer("enemyhorde_spawner.lua")
costin_dqs.LoadServer("quest_npcs_handler.lua")
costin_dqs.LoadServer("quest_npcs_spawner.lua")

costin_dqs.LoadClient("cl_quest_types.lua")
costin_dqs.LoadClient("cl_quest_npcs_handler.lua")
costin_dqs.LoadClient("settings_menu.lua")
costin_dqs.LoadClient("draw/active_quest_gui.lua")
costin_dqs.LoadClient("draw/quest_menu_gui.lua")
costin_dqs.LoadClient("draw/quest_visualizer.lua")