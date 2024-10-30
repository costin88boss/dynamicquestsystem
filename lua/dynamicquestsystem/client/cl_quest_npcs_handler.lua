-- No need to pool inactive/"sleeping" quest NPCs on client, it's a memory waste (sarcasm)
-- Just check for transparency.
costin_dqs.npcs = costin_dqs.npcs or {}
costin_dqs.localTotalQuestsCompleted = costin_dqs.localTotalQuestsCompleted or 0

local animPos = Vector(0, 0, 0)
local matArrowDown = Material("icon16/arrow_down.png")

hook.Add("InitPostEntity", "costin_dqs_playerinit", function()
    LocalPlayer():SetNW2Bool("CanSeeQuestNpcsXray", false)
end)

hook.Add("HUDPaint", "costin_dynamicquestgiver_predrawplayerhands", function()
    local ply = LocalPlayer()
    if (!ply:GetNW2Bool("CanSeeQuestNpcsXray")) then return false end
    for i, npc in pairs(costin_dqs.npcs) do
        if (npc:GetColor().a < 255) then continue end

        local screenData = (npc:GetPos() + animPos):ToScreen()
        local dist = ply:GetPos():Distance(npc:GetPos() + animPos)

        -- For some reason works, so can't complain.
        -- This is used to make the overlay not go too far from the top of an NPC.
        fDist = math.sqrt(dist)

        animPos.z = 200 + math.sin(CurTime() + i) * 1 * fDist

        if (!screenData.visible) then continue end

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(matArrowDown)
        surface.DrawTexturedRect(screenData.x - 50, screenData.y + 40 - fDist, 100, 50)

        surface.SetTextColor(255, 255, 255, 255)
        surface.SetFont("Trebuchet24")
        local w, _ = surface.GetTextSize("Quest Giver")
        surface.SetTextPos(screenData.x - w / 2, screenData.y + 20 - fDist)
        surface.DrawText("Quest Giver")
    end

    return false
end)

net.Receive("cdqs_UpdateVariables", function()
    LocalPlayer().cdqs_questData = net.ReadTable()
end)

net.Receive("cdqs_ActiveQuestUpdate", function()
    local questCompleteStatus = net.ReadInt(32)
    local questError = net.ReadString()
    LocalPlayer().cdqs_questData = net.ReadTable()

    if (questCompleteStatus == costin_dqs.completeStatus.COMPLETE) then
        LocalPlayer().dqs_activeQuestID = nil
        costin_dqs.localTotalQuestsCompleted = costin_dqs.localTotalQuestsCompleted + 1
        chat.AddText("[QUEST COMPLETED]")
        chat.AddText("[COMPLETED QUEST COUNT: " .. costin_dqs.localTotalQuestsCompleted .. "]")
        return 
    end

    if (questError != "") then
        chat.AddText(questError)
    end

    if (questCompleteStatus == costin_dqs.completeStatus.FAILED) then
        LocalPlayer().dqs_activeQuestID = nil
        chat.AddText("[QUEST CANCELLED]")
        return 
    end

    chat.AddText("[QUEST OBJECTIVE UPDATED]")

    costin_dqs.questType.types[LocalPlayer().dqs_activeQuestID].clRunFunc(LocalPlayer())
end)

net.Receive("cdqs_LocalTotalQuestsCompleted", function()
    costin_dqs.localTotalQuestsCompleted = net.ReadInt(32)
    chat.AddText("[TOTAL QUESTS COMPLETED: " .. costin_dqs.localTotalQuestsCompleted .. "]")
end)