util.AddNetworkString("cdqs_AcceptQuest")
util.AddNetworkString("cdqs_LocalTotalQuestsCompleted")


net.Receive("cdqs_AcceptQuest", function(len, ply)
    if (ply.dqs_selectedNPC == nil) then return end
    if (ply.dqs_activeQuestIDType != nil) then return end -- No exploit allowed
    -- Why 2 variables? Idk
    ply.dqs_activeQuestNPC = ply.dqs_selectedNPC
    ply.dqs_selectedNPC = nil

    ply.dqs_activeQuestNPC.dqs_ply = ply

    ply.dqs_activeQuestIDType = ply.dqs_activeQuestNPC:GetQuestType()

    ply.dqs_activeQuestNPC.UseCustomUseFunc = true

    for i, type_ in pairs(costin_dqs.questType.types) do
        if(i == ply.dqs_activeQuestIDType) then
            costin_dqs.questType.types[i].runFunc(ply)
            break
        end
    end
end)