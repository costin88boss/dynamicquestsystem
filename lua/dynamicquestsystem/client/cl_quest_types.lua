local npcHintOverlayOffset = Vector(0, 0, 60)

-- Should probably separate runFunc and clRuncFunc in separate files
costin_dqs.questType.GOTOAREA = {}
costin_dqs.questType.GOTOAREA.printName = "Go to area."
costin_dqs.questType.GOTOAREA.clRunFunc = function(ply)
    local gotoPos = LocalPlayer().cdqs_questData[1]
    local returnToQuestNPC = LocalPlayer().cdqs_questData[2]

    if (!returnToQuestNPC) then
        LocalPlayer().dqs_activeQuestMsg = "Go to area."
    else
        LocalPlayer().dqs_activeQuestMsg = "Go back to the Quest NPC."
    end

    -- Ugly but works
    costin_dqs.visualizerFunc = function()
        local screenData = gotoPos:ToScreen()

        if (!screenData.visible) then return end

        surface.SetDrawColor(255, 0, 0, 255)

        surface.DrawCircle(screenData.x, screenData.y, 100, 255, 0, 0, 255)
    end
end
costin_dqs.questType.BRINGITEM = {}
costin_dqs.questType.BRINGITEM.printName = "Bring me item."
costin_dqs.questType.BRINGITEM.clRunFunc = function(ply)
    local gotoPos = LocalPlayer().cdqs_questData[1]
    local itemPickedUp = LocalPlayer().cdqs_questData[2]

    if (!itemPickedUp) then
        LocalPlayer().dqs_activeQuestMsg = "Go and pick up the item."
    else
        LocalPlayer().dqs_activeQuestMsg = "Give the item to the NPC."
    end

    -- Ugly but works
    costin_dqs.visualizerFunc = function()
        local screenData = gotoPos:ToScreen()
    
        if (!screenData.visible) then return end
    
        surface.SetDrawColor(0, 0, 255, 255)
    
        surface.DrawCircle(screenData.x, screenData.y, 100, 255, 0, 0, 255)
    end
end
costin_dqs.questType.DEFENDME = {}
costin_dqs.questType.DEFENDME.printName = "Defend me."
costin_dqs.questType.DEFENDME.clRunFunc = function(ply)
    LocalPlayer().dqs_activeQuestMsg = "Defend Me!"

    -- Ugly but works
    costin_dqs.visualizerFunc = function()
        for i = 1, #LocalPlayer().cdqs_questData do
            local gotoPos = LocalPlayer().cdqs_questData[i]
            local screenData = (gotoPos + npcHintOverlayOffset):ToScreen()
        
            surface.SetDrawColor(0, 0, 255, 255)
        
            surface.DrawCircle(screenData.x, screenData.y, 100, 255, 0, 0, 255)
        end
    end
end

costin_dqs.questType.types = {
    [1] = costin_dqs.questType.GOTOAREA,
    [2] = costin_dqs.questType.BRINGITEM,
    [3] = costin_dqs.questType.DEFENDME
}