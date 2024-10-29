AddCSLuaFile()

hook.Add("AddToolMenuCategories", "costin_dqs_createcat", function()
	spawnmenu.AddToolCategory( "Settings", "dqs_settings", "Costin's DQS" )
end )

hook.Add("PopulateToolMenu", "costin_dqs_createtoolmenu", function()
	spawnmenu.AddToolMenuOption( "Settings", "dqs_settings", "Main", "#Main", "", "", function( panel )
		panel:ClearControls()
		panel:CheckBox("Enable Quest Map Spawner", "costin_dqs_mapspawnerenabled")
		panel:NumSlider("NPC Spawn Delay", "costin_dqs_spawndelay", 1, 60, 0)
		panel:NumSlider("Max Spawn Retry Attempts", "costin_dqs_spawnretryattempts", 1, 20, 0)
		panel:NumSlider("Min Distance from Players", "costin_dqs_mindistancefromplayers", 200, 20000, 0)
		panel:NumSlider("Max NPC Amount", "costin_dqs_maxnpcamount", 1, 30, 0)

		panel:NumSlider("Min Distance for Quest Enemy spawn", "costin_dqs_enemyspawn_distmax", 500, 20000, 0)
		panel:NumSlider("Max Distance for Quest Enemy spawn", "costin_dqs_enemyspawn_distmin", 500, 20000, 0)
	end )
end )