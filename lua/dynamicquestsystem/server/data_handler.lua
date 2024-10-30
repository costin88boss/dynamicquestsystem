-- We're going to use json for everything because we're cool
-- And SQL for player stats (aka just total quests completed lol) :sunglasses:

-- NOTE: If the location of this file is not obvious, everything here is intended to be saved serverside only.
function costin_dqs:GetPlayerTotalQuestsCompleted(ply)
    return sql.QueryValue("SELECT totalQuestsCompleted FROM costin_dqs_playerstats WHERE steamID = ".. sql.SQLStr(ply:SteamID()) .. ";")
end

function costin_dqs:SavePlayersStats()
    for i, ply in pairs(player.GetAll()) do
        ply.dqs_questsCompleted = ply.dqs_questsCompleted or 0
        if (ply.dqs_questsCompleted == 0) then continue end

        local totalQuests = 1 + costin_dqs:GetPlayerTotalQuestsCompleted(ply)

        local data = sql.Query("SELECT * FROM costin_dqs_playerstats WHERE steamID = " .. sql.SQLStr(ply:SteamID()))
        if (data) then
            sql.Query("UPDATE costin_dqs_playerstats SET totalQuestsCompleted = " .. totalQuests .. " WHERE steamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
        else
            sql.Query("INSERT INTO costin_dqs_playerstats(steamID, totalQuestsCompleted) VALUES(" .. sql.SQLStr(ply:SteamID()) .. ", " .. totalQuests .. ")")
        end
    end
end


function costin_dqs:GetBringMeItemTypes()
    return util.JSONToTable(file.Read("dynamicquestsystem/bringmeitem_types.json"))
end

-- One hiccup that I've got in programming is that it's hard to think of names.
local function GenerateFilesIfTheyDontExist()
    if (!file.Exists("dynamicquestsystem/", "DATA")) then
        file.CreateDir("dynamicquestsystem")
    end
    if (!file.Exists("dynamicquestsystem/convars.json", "DATA")) then
        file.Write("dynamicquestsystem/convars.json", util.TableToJSON({}))
    end
    sql.Query("CREATE TABLE IF NOT EXISTS costin_dqs_playerstats(steamID TEXT, totalQuestsCompleted INT)")

    local bringMeItemTypes = {}
    bringMeItemTypes[1] = "models/props_junk/TrashBin01a.mdl"
    bringMeItemTypes[2] = "models/props_interiors/Furniture_Couch02a.mdl"
    bringMeItemTypes[3] = "models/props_lab/monitor01b.mdl"

    if (!file.Exists("dynamicquestsystem/bringmeitem_types.json", "DATA")) then
        file.Write("dynamicquestsystem/bringmeitem_types.json", util.TableToJSON(bringMeItemTypes))
    end
end