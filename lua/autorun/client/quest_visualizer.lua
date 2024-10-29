costin_dqs = costin_dqs or {}
costin_dqs.visualizerFunc = costin_dqs.visualizerFunc or function()
    //costin_dqs.utils.Print("Visualizer func not set!")
    // Broken print func
end

hook.Add("HUDPaintBackground", "costin_dqs_questvisualizer", function()
    if(LocalPlayer().dqs_activeQuestID == nil) then return end
    if(costin_dqs.visualizerFunc == nil) then return end
    costin_dqs:visualizerFunc()
end)