--// AUTO FARM FISH GIVER + GUI + MINIMIZE ICON (DRAGGABLE)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local FishAssets = RS.FishingSystem.Assets.Fish
local FishGiver = RS.FishingSystem.FishGiver

-- ===== STATE =====
local SelectedFishName = nil
local AutoFarm = false

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "FishGiverGUI"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

-- ===== MAIN FRAME =====
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.35, 0.55)
main.Position = UDim2.fromScale(0.325, 0.22)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1, 0.08)
title.Text = "Ambon Penghancur Apem🩲"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- MINIMIZE BUTTON
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.fromScale(0.1, 0.08)
minBtn.Position = UDim2.fromScale(0.88, 0.01)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold

-- ICON (DRAGGABLE)
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.06, 0.09)
icon.Position = UDim2.fromScale(0.02, 0.4)
icon.Text = "🩲"
icon.TextScaled = true
icon.BackgroundColor3 = Color3.fromRGB(0,120,255)
icon.TextColor3 = Color3.new(1,1,1)
icon.Visible = false
icon.Active = true
icon.Draggable = true
icon.ZIndex = 10

-- DROPDOWN BUTTON
local dropBtn = Instance.new("TextButton", main)
dropBtn.Position = UDim2.fromScale(0.05, 0.1)
dropBtn.Size = UDim2.fromScale(0.9, 0.08)
dropBtn.Text = "Pilih Memek"
dropBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropBtn.TextColor3 = Color3.new(1,1,1)

-- LIST
local listFrame = Instance.new("ScrollingFrame", main)
listFrame.Position = UDim2.fromScale(0.05, 0.19)
listFrame.Size = UDim2.fromScale(0.9, 0.32)
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.ScrollBarImageTransparency = 0.3
listFrame.Visible = false

local layout = Instance.new("UIListLayout", listFrame)
layout.Padding = UDim.new(0,4)

-- WEIGHT
local weightBox = Instance.new("TextBox", main)
weightBox.Position = UDim2.fromScale(0.05, 0.52)
weightBox.Size = UDim2.fromScale(0.9, 0.07)
weightBox.PlaceholderText = "Weight (kosong = random)"
weightBox.Text = ""
weightBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
weightBox.TextColor3 = Color3.new(1,1,1)

-- DELAY
local delayBox = Instance.new("TextBox", main)
delayBox.Position = UDim2.fromScale(0.05, 0.60)
delayBox.Size = UDim2.fromScale(0.9, 0.07)
delayBox.PlaceholderText = "Delay (detik)"
delayBox.Text = "1"
delayBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
delayBox.TextColor3 = Color3.new(1,1,1)

-- TOGGLE AUTO FARM
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Position = UDim2.fromScale(0.05, 0.69)
toggleBtn.Size = UDim2.fromScale(0.9, 0.08)
toggleBtn.Text = "AUTO COLI : OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true

-- ===== POPULATE FISH LIST (NAMA ASSET) =====
for _,fish in ipairs(FishAssets:GetChildren()) do
	local btn = Instance.new("TextButton", listFrame)
	btn.Size = UDim2.new(1, -5, 0, 28)
	btn.Text = fish.Name
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14

	btn.MouseButton1Click:Connect(function()
		SelectedFishName = fish.Name
		dropBtn.Text = "Ikan: "..fish.Name
		listFrame.Visible = false
	end)
end

task.wait()
listFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)

-- ===== UI LOGIC =====
dropBtn.MouseButton1Click:Connect(function()
	listFrame.Visible = not listFrame.Visible
end)

toggleBtn.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm
	toggleBtn.Text = AutoFarm and "AUTO COLI : ON" or "AUTO COLI : OFF"
	toggleBtn.BackgroundColor3 = AutoFarm and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
end)

minBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	main.Visible = true
	icon.Visible = false
end)

-- ===== AUTO FARM LOOP =====
task.spawn(function()
	while task.wait(0.1) do
		if AutoFarm and SelectedFishName then
			local char = Player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if not hrp then continue end

			local weight = tonumber(weightBox.Text) or math.random(5000,10000000000)
			local delayTime = tonumber(delayBox.Text) or 1

			local args = {
				{
					hookPosition = hrp.Position,
					name = SelectedFishName,
					rarity = "Secret",
					weight = weight
				}
			}

			FishGiver:FireServer(unpack(args))
			task.wait(delayTime)
		end
	end
end)