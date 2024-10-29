costin_dqs = costin_dqs or {}
costin_dqs.questType = costin_dqs.questType or {}

costin_dqs.questType.MinVal = 1
costin_dqs.questType.MaxVal = 3

costin_dqs.questType.GOTOAREA = "Go to area."
costin_dqs.questType.BRINGITEM = "Bring me item"
costin_dqs.questType.DEFENDME = "Defend me."

costin_dqs.questType.types = {
    [1] = costin_dqs.questType.GOTOAREA,
    [2] = costin_dqs.questType.BRINGITEM,
    [3] = costin_dqs.questType.DEFENDME
}