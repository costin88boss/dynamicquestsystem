-- There probably exists a better way to print and having an option to disable it.
local enablePrinting = true

-- A bit funky
function costin_dqs.utils:IsEntityInPlayerView(ply, ent)
    if not IsValid(ply) or not IsValid(ent) then return false end

    local plyPos = ply:GetPos()
    local viewAngles = ply:GetAimVector()
    local entPos = ent:GetPos()

    local dirToEnt = (entPos - plyPos):GetNormalized()
    local angleDiff = viewAngles:Dot(dirToEnt)
    local fov = ply:GetFOV()

    return angleDiff >= math.cos(math.rad(fov))
end

-- There probably exists a better way to print and having an option to disable it.
function costin_dqs.utils:Print(msg)
    if (enablePrinting) then
        --debug.Trace()
        print(msg)
    end
end