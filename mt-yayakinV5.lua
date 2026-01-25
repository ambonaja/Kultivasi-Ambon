-- MT YAYAKIN V3 AUTO TP
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- COORDINATES
local Points = {
	Vector3.new(-456,252,753),  -- CP1
	Vector3.new(-338,390,538),  -- CP2
	Vector3.new(286,432,523),   -- CP3
	Vector3.new(333,492,345),   -- CP4
	Vector3.new(235,316,-145),  -- CP5
	Vector3.new(-614,908,-551), -- SUMMIT
	Vector3.new(-946,172,860)   -- BC
}

-- STATE
local AutoTP = false
local DelayTime = 1

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MT_YAYAKIN_V3"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.25,0.32)
main.Position = UDim2.fromScale(0.37,0.3)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.18,0)
title.BackgroundTransparency = 1
title.Text = "MT YAYAKIN V3"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local delayBox = Instance.new("TextBox", main)
delayBox.Size = UDim2.new(0.8,0,0.18,0)
delayBox.Position = UDim2.new(0.1,0,0.22,0)
delayBox.PlaceholderText = "Delay (1-10)"
delayBox.Text = "1"
delayBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.Font = Enum.Font.Gotham
delayBox.TextScaled = true
Instance.new("UICorner", delayBox)

local startBtn = Instance.new("TextButton", main)
startBtn.Size = UDim2.new(0.8,0,0.18,0)
startBtn.Position = UDim2.new(0.1,0,0.45,0)
startBtn.Text = "START AUTO TP"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextScaled = true
Instance.new("UICorner", startBtn)

local stopBtn = Instance.new("TextButton", main)
stopBtn.Size = UDim2.new(0.8,0,0.18,0)
stopBtn.Position = UDim2.new(0.1,0,0.67,0)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextScaled = true
Instance.new("UICorner", stopBtn)

-- MINIMIZE
local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.fromScale(0.06,0.1)
mini.Position = UDim2.fromScale(0.02,0.45)
mini.Text = "MT"
mini.Visible = false
mini.BackgroundColor3 = Color3.fromRGB(30,30,30)
mini.TextColor3 = Color3.new(1,1,1)
mini.Font = Enum.Font.GothamBold
mini.TextScaled = true
Instance.new("UICorner", mini)

title.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton2 then
		main.Visible = false
		mini.Visible = true
	end
end)

mini.MouseButton1Click:Connect(function()
	main.Visible = true
	mini.Visible = false
end)

-- LOGIC
startBtn.MouseButton1Click:Connect(function()
	local val = tonumber(delayBox.Text)
	if val and val >= 1 and val <= 10 then
		DelayTime = val
	end
	AutoTP = true

	task.spawn(function()
		while AutoTP do
			for _,pos in ipairs(Points) do
				if not AutoTP then break end
				if HumanoidRootPart then
					HumanoidRootPart.CFrame = CFrame.new(pos)
				end
				task.wait(DelayTime)
			end
		end
	end)
end)

stopBtn.MouseButton1Click:Connect(function()
	AutoTP = false
end)