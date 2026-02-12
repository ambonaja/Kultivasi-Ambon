--// ================================
--//  Fishing Auto Reel
--//  Credit  : Ambon|Hub
--//  Watermark: GET FISH EDITION
--// ================================

warn("=== GET FISH EDITION | Credit: Ambon|Hub ===")

while task.wait(4) do
	local args = {
		{
			duration = 2.9015033438336104,
			result = "SUCCESS",
			insideRatio = 0.8
		},
		"50ce4ba0-8926-4b70-a9de-f0db9c4f7d05"
	}

	game:GetService("ReplicatedStorage")
		:WaitForChild("Fishing")
		:WaitForChild("ToServer")
		:WaitForChild("ReelFinished")
		:FireServer(unpack(args))

	task.wait(0.1)
end