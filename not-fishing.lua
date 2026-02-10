if getgenv().FishingHB and getgenv().FishingHB.Connection then
	getgenv().FishingHB.Connection:Disconnect()
end

getgenv().FishingHB = {}

local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local net = RS
	:WaitForChild("Packages")
	:WaitForChild("_Index")
	:WaitForChild("sleitnick_net@0.2.0")
	:WaitForChild("net")

getgenv().FishingHB.Connection = RunService.Heartbeat:Connect(function()
	pcall(function()
		net:WaitForChild("RF/ChargeFishingRod"):InvokeServer()
		net:WaitForChild("RF/RequestFishingMinigameStarted")
			:InvokeServer(-1.233184814453125, 0.5, 1770664767.08607)
		net:WaitForChild("RE/FishingCompleted"):FireServer()
	end)
end)