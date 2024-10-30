util.AddNetworkString("cdqs_UpdateVariables")
util.AddNetworkString("cdqs_ActiveQuestUpdate")

function costin_dqs:UpdateQuest(ent, completeStatus, attributes, errorMsg)
    local ply = ent.dqs_ply
    if (attributes == nil) then attributes = {} end
    ply.dqs_activeQuestAttributes = attributes
    if (completeStatus != costin_dqs.completeStatus.PROGRESSING) then
        ply.dqs_activeQuestNPC = nil
        ply.dqs_activeQuestAttributes = {}
        ply.dqs_activeQuestIDType = nil 
        ent.dqs_ply = nil
        ent:Disappear(ply)
        if (completeStatus == costin_dqs.completeStatus.COMPLETE) then
            ply.dqs_questsCompleted = ply.dqs_questsCompleted or 0
            ply.dqs_questsCompleted = ply.dqs_questsCompleted + 1

            -- A performance improvement could be done by placing this into a hook like ShutDown.
            -- However for demonstration purposes I'll keep it here.
            costin_dqs:SavePlayersStats()
        end
    end
    net.Start("cdqs_ActiveQuestUpdate")
    net.WriteInt(completeStatus, 32)
    net.WriteString(errorMsg or "")
    net.WriteTable(attributes)
    net.Send(ply)
end

-- Similar to UpdateQuest but silent and doesn't send error msg or complete status
function costin_dqs:UpdateVariables(ent, attributes)
    local ply = ent.dqs_ply
    if (attributes == nil) then attributes = {} end
    net.Start("cdqs_UpdateVariables")
    net.WriteTable(attributes)
    net.Send(ply)
end