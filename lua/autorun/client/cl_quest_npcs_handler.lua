costin_dqs = costin_dqs or {}

// No need to pool inactive/"sleeping" quest NPCs on client, it's a memory waste (sarcasm)
// Just check for transparency.
costin_dqs.npcs = costin_dqs.npcs or {}
costin_dqs.localTotalQuestsCompleted = costin_dqs.localTotalQuestsCompleted or 0

local animPos = Vector(0, 0, 0)
local matArrowDown = Material("icon16/arrow_down.png")

local npcHintOverlayOffset = Vector(0, 0, 60)


hook.Add("InitPostEntity", "costin_dqs_playerinit", function()
    LocalPlayer():SetNW2Bool("CanSeeQuestNpcsXray", false)
end)

hook.Add("HUDPaint", "costin_dynamicquestgiver_predrawplayerhands", function()
    local ply = LocalPlayer()
    if(!ply:GetNW2Bool("CanSeeQuestNpcsXray")) then return false end
    for i, npc in pairs(costin_dqs.npcs) do
        if(npc:GetColor().a < 255) then continue end

        local screenData = (npc:GetPos() + animPos):ToScreen()
        local dist = ply:GetPos():Distance(npc:GetPos() + animPos)

        // For some reason works, so can't complain.
        // This is used to make the overlay not go too far from the top of an NPC.
        fDist = math.sqrt(dist)

        animPos.z = 200 + math.sin(CurTime() + i) * 1 * fDist

        if(!screenData.visible) then continue end

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

local questData = nil

net.Receive("cdqs_UpdateVariables", function()
    questData = net.ReadTable()
end)

net.Receive("cdqs_ActiveQuestUpdate", function()
    local questCompleteStatus = net.ReadInt(32)
    local questError = net.ReadString()
    questData = net.ReadTable()

    if(questCompleteStatus == 1) then
        LocalPlayer().dqs_activeQuestID = nil
        costin_dqs.localTotalQuestsCompleted = costin_dqs.localTotalQuestsCompleted + 1
        chat.AddText("[QUEST COMPLETED]")
        chat.AddText("[COMPLETED QUEST COUNT: " .. costin_dqs.localTotalQuestsCompleted .. "]")
        return 
    end

    if(questError != "") then
        chat.AddText(questError)
    end

    if(questCompleteStatus == 2) then
        LocalPlayer().dqs_activeQuestID = nil
        chat.AddText("[QUEST CANCELLED]")
        return 
    end

    chat.AddText("[QUEST OBJECTIVE UPDATED]")

    if(LocalPlayer().dqs_activeQuestID == 1) then // Go to area
        local gotoPos = questData[1]
        local returnToQuestNPC = questData[2]

        if(!returnToQuestNPC) then
            LocalPlayer().dqs_activeQuestMsg = "Go to area."
        else
            LocalPlayer().dqs_activeQuestMsg = "Go back to the Quest NPC."
        end

        // Ugly but works
        costin_dqs.visualizerFunc = function()
            local screenData = gotoPos:ToScreen()

            if(!screenData.visible) then return end

            surface.SetDrawColor(255, 0, 0, 255)

            surface.DrawCircle(screenData.x, screenData.y, 100, 255, 0, 0, 255)
        end
    end
    if(LocalPlayer().dqs_activeQuestID == 2) then // Bring me item
        local gotoPos = questData[1]
        local itemPickedUp = questData[2]

        if(!itemPickedUp) then
            LocalPlayer().dqs_activeQuestMsg = "Go and pick up the item."
        else
            LocalPlayer().dqs_activeQuestMsg = "Give the item to the NPC."
        end

        // Ugly but works
        costin_dqs.visualizerFunc = function()
            local screenData = gotoPos:ToScreen()
        
            if(!screenData.visible) then return end
        
            surface.SetDrawColor(0, 0, 255, 255)
        
            surface.DrawCircle(screenData.x, screenData.y, 100, 255, 0, 0, 255)
        end
    end
    if(LocalPlayer().dqs_activeQuestID == 3) then // Bring me item
        LocalPlayer().dqs_activeQuestMsg = "Defend Me!"

        // Ugly but works
        costin_dqs.visualizerFunc = function()
            for i = 1, #questData do
                local gotoPos = questData[i]
                local screenData = (gotoPos + npcHintOverlayOffset):ToScreen()
            
                surface.SetDrawColor(0, 0, 255, 255)
            
                surface.DrawCircle(screenData.x, screenData.y, 100, 255, 0, 0, 255)
            end
        end
    end
end)

net.Receive("cdqs_LocalTotalQuestsCompleted", function()
    costin_dqs.localTotalQuestsCompleted = net.ReadInt(32)
    chat.AddText("[TOTAL QUESTS COMPLETED: " .. costin_dqs.localTotalQuestsCompleted .. "]")
end)