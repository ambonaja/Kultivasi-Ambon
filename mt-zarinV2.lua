while true do
task.wait(2.5)

local args = {
	vector.create(31.991918563842773, 23.017704010009766, 278.2765197753906),
	vector.create(-0.11380718648433685, 5, -24.999740600585938),
	"Basic Rod",
	91
}
game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CastReplication"):FireServer(unpack(args))

task.wait(2.5)

game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("PrecalcFish"):InvokeServer()

task.wait(2.5)

local args = {
	"rbxassetid://78467245624383"
}
game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("ReplicatePullAlert"):FireServer(unpack(args))

task.wait(2.5)

local args = {
	{
		hookPosition = vector.create(31.936351776123047, 3.6855530738830566, 266.0902099609375)
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("FishGiver"):FireServer(unpack(args))

task.wait(2.5)

game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CleanupCast"):FireServer()


end
