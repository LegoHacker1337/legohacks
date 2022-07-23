repeat wait() until game:IsLoaded()

local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacker1337/legohacks/main/PhysicsServiceOnClient.lua", true))()

PhysicsService:CreateCollisionGroup("Players")
PhysicsService:CollisionGroupSetCollidable("Players", "Players", false)

local function CharacterAdded(Character)
	Character.ChildAdded:Connect(function(obj)
		if obj:IsA("BasePart") and not PhysicsService:CollisionGroupContainsPart("Players", obj) then
			PhysicsService:SetPartCollisionGroup(obj, "Players")
		end
	end)
	for i,v in pairs(Character:GetChildren()) do
		if v:IsA("BasePart") and not PhysicsService:CollisionGroupContainsPart("Players", v) then
			PhysicsService:SetPartCollisionGroup(v, "Players")
		end
	end
end

local function PlayerAdded(Plr)
	Plr.CharacterAdded:Connect(CharacterAdded)
	if Plr.Character then
		CharacterAdded(Plr.Character)
	end
end

Players.PlayerAdded:Connect(PlayerAdded)

for i,v in pairs(Players:GetPlayers()) do
	PlayerAdded(v)
end
