include("shared.lua")

function ENT:Draw()
    if (LocalPlayer() == self:GetNW2Entity("quest_player")) then
        self:DrawModel()
    end
end