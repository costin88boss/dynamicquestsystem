
-- Map spawner shouldn't be saved.
costin_dqs.convars.convar_mapspawnerenabled = CreateConVar("costin_dqs_mapspawnerenabled", "0", FCVAR_NOTIFY)

costin_dqs.convars.convar_delay = CreateConVar("costin_dqs_spawndelay", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })
costin_dqs.convars.convar_mindistancefromplayers = CreateConVar("costin_dqs_mindistancefromplayers", "2000", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })
costin_dqs.convars.convar_maxnpcamount = CreateConVar("costin_dqs_maxnpcamount", "5", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })

costin_dqs.convars.convar_enemyspawn_distmax = CreateConVar("costin_dqs_enemyspawn_distmax", "2500", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })
costin_dqs.convars.convar_enemyspawn_distmin = CreateConVar("costin_dqs_enemyspawn_distmin", "500", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })