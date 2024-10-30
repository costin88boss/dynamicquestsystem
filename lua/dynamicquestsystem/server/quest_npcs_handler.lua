util.AddNetworkString("cdqs_AcceptQuest")
util.AddNetworkString("cdqs_LocalTotalQuestsCompleted")


net.Receive("cdqs_AcceptQuest", function(len, ply)
    if (ply.dqs_selectedNPC == nil) then return end
    if (ply.dqs_activeQuestIDType != nil) then return end -- No exploit allowed
    -- Redundant to have 2 vars, but their different name simplify the whole process a bit
    ply.dqs_activeQuestNPC = ply.dqs_selectedNPC
    ply.dqs_selectedNPC = nil

    ply.dqs_activeQuestNPC.dqs_ply = ply

    ply.dqs_activeQuestIDType = ply.dqs_activeQuestNPC:GetQuestType()

    ply.dqs_activeQuestNPC.UseCustomUseFunc = true

    costin_dqs.questType.types[ply.dqs_activeQuestIDType].runFunc(ply)
end)