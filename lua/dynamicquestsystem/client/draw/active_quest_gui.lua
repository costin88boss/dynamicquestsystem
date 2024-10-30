hook.Add("HUDPaintBackground", "costin_dqs_activequestgui", function()
    if (LocalPlayer().dqs_activeQuestID == nil) then return end
    if (LocalPlayer().dqs_activeQuestMsg == nil) then return end

    surface.SetDrawColor(50, 50, 50, 170)
    surface.DrawRect(ScrW() - 350, 0, 350, 150)

    surface.SetFont("Trebuchet24")

    local text = "Active Quest"
    local x, _ = surface.GetTextSize(text)

    surface.SetTextColor(255, 255, 255, 255)
    surface.SetTextPos(ScrW() - 350 / 2 - x / 2, 10)
    surface.DrawText(text)

    text = LocalPlayer().dqs_activeQuestMsg
    x, _ = surface.GetTextSize(text)

    surface.SetTextPos(ScrW() - 350 / 2 - x / 2, 80)
    surface.DrawText(text)

end)