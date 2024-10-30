net.Receive("cdqs_OpenNpcQuestMenu", function(len, ply)
    local questNPC = net.ReadEntity()
    local questType = questNPC:GetQuestType()

    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:Center()
    frame:SetTitle("Quest Menu")
    frame:MakePopup()

    local label = vgui.Create("DLabel", frame)

    local labelTitle = "Quest: " .. costin_dqs.questType.types[questType].printName

    surface.SetFont("Trebuchet24")
    local x, _ = surface.GetTextSize(labelTitle)

    label:SetFont("Trebuchet24")
    label:SetPos(200 - x / 2, 40)
    label:SetSize(360, 20)
    label:SetText(labelTitle)

    local button = vgui.Create("DButton", frame)
    button:SetPos(150, 100)
    button:SetSize(100, 30)
    button:SetText("Accept quest")
    
    button.DoClick = function()
        chat.AddText("[QUEST ACCEPTED]")
        net.Start("cdqs_AcceptQuest")
        net.SendToServer()
        frame:Close()
        LocalPlayer().dqs_activeQuestID = questType
    end
end)