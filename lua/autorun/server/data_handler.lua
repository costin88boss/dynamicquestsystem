// We're going to use json for everything because we're cool
// And SQL for player stats (aka just total quests completed lol) :sunglasses:

// NOTE: If the location of this file is not obvious, everything here is intended to be saved serverside only.

costin_dqs = costin_dqs or {}

function costin_dqs:GetPlayerTotalQuestsCompleted(ply)
    return sql.QueryValue("SELECT totalQuestsCompleted FROM costin_dqs_playerstats WHERE steamID = ".. sql.SQLStr(ply:SteamID()) .. ";")
end

function costin_dqs:SavePlayersStats()
    for i, ply in pairs(player.GetAll()) do
        ply.dqs_questsCompleted = ply.dqs_questsCompleted or 0
        if(ply.dqs_questsCompleted == 0) then continue end

        ply.dqs_questsCompleted = ply.dqs_questsCompleted + costin_dqs:GetPlayerTotalQuestsCompleted(ply)

        local data = sql.Query("SELECT * FROM costin_dqs_playerstats WHERE steamID = " .. sql.SQLStr(ply:SteamID()))
        if(data) then
            sql.Query("UPDATE costin_dqs_playerstats SET totalQuestsCompleted = " .. ply.dqs_questsCompleted .. " WHERE steamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        else
            sql.Query("INSERT INTO costin_dqs_playerstats(steamID, totalQuestsCompleted) VALUES(" .. sql.SQLStr(ply:SteamID()) .. ", " .. ply.dqs_questsCompleted .. ")")
        end
    end
end

function costin_dqs:GetBringMeItemTypes()
    return util.JSONToTable(file.Read("dynamicquestsystem/bringmeitem_types.json"))
end

// One hiccup that I've got in programming is that it's hard to think of names.
local function GenerateFilesIfTheyDontExist()
    if(!file.Exists("dynamicquestsystem/", "DATA")) then
        file.CreateDir("dynamicquestsystem")
    end
    if(!file.Exists("dynamicquestsystem/convars.json", "DATA")) then
        file.Write("dynamicquestsystem/convars.json", util.TableToJSON({}))
    end
    sql.Query("CREATE TABLE IF NOT EXISTS costin_dqs_playerstats(steamID TEXT, totalQuestsCompleted INT)")

    local bringMeItemTypes = {}
    bringMeItemTypes[1] = "models/props_junk/TrashBin01a.mdl"
    bringMeItemTypes[2] = "models/props_interiors/Furniture_Couch02a.mdl"
    bringMeItemTypes[3] = "models/props_lab/monitor01b.mdl"

    if(!file.Exists("dynamicquestsystem/bringmeitem_types.json", "DATA")) then
        file.Write("dynamicquestsystem/bringmeitem_types.json", util.TableToJSON(bringMeItemTypes))
    end
end

local function LoadConvars()
    GenerateFilesIfTheyDontExist()
    local convarData = util.JSONToTable(file.Read("dynamicquestsystem/convars.json"))
    costin_dqs.convar_mapspawnerenabled = CreateConVar("costin_dqs_mapspawnerenabled", "0", FCVAR_NOTIFY)
    costin_dqs.convar_delay = CreateConVar("costin_dqs_spawndelay", convarData.costin_dqs_spawndelay or "1", FCVAR_NOTIFY)
    costin_dqs.convar_mindistancefromplayers = CreateConVar("costin_dqs_mindistancefromplayers", convarData.costin_dqs_mindistancefromplayers or "2000", FCVAR_NOTIFY)
    costin_dqs.convar_maxnpcamount = CreateConVar("costin_dqs_maxnpcamount", convarData.costin_dqs_maxnpcamount or "5", FCVAR_NOTIFY)

    costin_dqs.convar_enemyspawn_distmax = CreateConVar("costin_dqs_enemyspawn_distmax", convarData.costin_dqs_enemyspawn_distmax or "2500", FCVAR_NOTIFY)
    costin_dqs.convar_enemyspawn_distmin = CreateConVar("costin_dqs_enemyspawn_distmin", convarData.costin_dqs_enemyspawn_distmin or "500", FCVAR_NOTIFY)
end

local function SaveConvars()
    GenerateFilesIfTheyDontExist()
    local convarData = {}
    // I don't want to make 'enabled' persistent.
    //convarData.costin_dqs_enabled                = cvars.Bool("costin_dqs_mapspawnerenabled", false)
    convarData.costin_dqs_spawndelay             = tostring(cvars.Number("costin_dqs_spawndelay", 1))
    convarData.costin_dqs_mindistancefromplayers = tostring(cvars.Number("costin_dqs_mindistancefromplayers", 2000))
    convarData.costin_dqs_maxnpcamount = tostring(cvars.Number("costin_dqs_maxnpcamount", 5))

    convarData.convar_enemyspawn_distmax = tostring(cvars.Number("costin_dqs_enemyspawn_distmax", 2500))
    convarData.convar_enemyspawn_distmin = tostring(cvars.Number("costin_dqs_enemyspawn_distmin", 500))
    file.Write("dynamicquestsystem/convars.json", util.TableToJSON(convarData))
end

// If the server crashes, this may not work.
// An alternative is to always save the convars when a change to one of them is made.
hook.Add("ShutDown", "costin_dqs_shutdown_saveconvars", SaveConvars)

LoadConvars()