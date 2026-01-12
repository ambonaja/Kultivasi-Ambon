--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==================================================
-- REMOTES
--==================================================
local FishGiver = RS:WaitForChild("FishingSystem"):WaitForChild("FishGiver")
local PublishFishCatch = RS:WaitForChild("FishingSystem"):WaitForChild("PublishFishCatch")
local FishingCatchSuccess = RS:WaitForChild("FishingCatchSuccess")
local SellAll = RS
	:WaitForChild("FishingSystem")
	:WaitForChild("InventoryEvents")
	:WaitForChild("Inventory_SellAll")

--==================================================
-- SETTINGS
--==================================================
local autoFarm = false
local autoSell = false

local delayTime = 0.2   -- auto farm delay
local sellDelay = 5     -- auto sell delay

local fishName = "El Maja"
local fishWeight = 9999
local fishRarity = "Secret"

--==================================================
-- AUTO FARM LOOP
--==================================================
task.spawn(function()
	while true do
		if autoFarm then
			pcall(function()
				FishGiver:FireServer({
					hookPosition = vector.create(
						19.420610427856445,
						4.149969577789307,
						-64.56523895263672
					),
					name = fishName,
					rarity = fishRarity,
					weight = fishWeight
				})
			end)

			task.wait(0.05)

			pcall(function()
				PublishFishCatch:FireServer(
					fishName,
					fishWeight,
					fishRarity
				)
			end)

			task.wait(0.05)

			pcall(function()
				FishingCatchSuccess:FireServer()
			end)
		end
		task.wait(delayTime)
	end
end)

--==================================================
-- AUTO SELL LOOP
--==================================================
task.spawn(function()
	while true do
		if autoSell then
			pcall(function()
				SellAll:InvokeServer()
			end)
		end
		task.wait(sellDelay)
	end
end)

--==================================================
-- GUI ROOT
--==================================================
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

--==================================================
-- MAIN FRAME
--==================================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(250,190)
frame.Position = UDim2.fromScale(0.05,0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0,170,255)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-40,0,35)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "🎣 Auto Fishing Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

-- DRAG MAIN (TITLE ONLY)
local dragging, dragStart, startPos
title.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = frame.Position
	end
end)
title.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
	or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end)

--==================================================
-- MINIMIZE BUTTON (SMALL)
--==================================================
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.fromOffset(25,25)
minBtn.Position = UDim2.fromOffset(215,5)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1,0)

--==================================================
-- FLOATING ICON (HIDDEN INIT)
--==================================================
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromOffset(45,45)
icon.Position = UDim2.fromScale(0.5,0.5)
icon.Text = "🎣"
icon.Font = Enum.Font.GothamBold
icon.TextSize = 22
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.fromRGB(0,170,255)
icon.Visible = false
icon.Active = true
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- DRAG ICON
local idrag, istart, ipos
icon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		idrag = true
		istart = i.Position
		ipos = icon.Position
	end
end)
icon.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		idrag = false
	end
end)
UIS.InputChanged:Connect(function(i)
	if idrag and (i.UserInputType == Enum.UserInputType.MouseMovement
	or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - istart
		icon.Position = UDim2.new(
			ipos.X.Scale, ipos.X.Offset + d.X,
			ipos.Y.Scale, ipos.Y.Offset + d.Y
		)
	end
end)

-- MINIMIZE / RESTORE
minBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	icon.Visible = false
	frame.Visible = true
end)

--==================================================
-- AUTO FARM BUTTON
--==================================================
local farmBtn = Instance.new("TextButton", frame)
farmBtn.Size = UDim2.fromOffset(210,40)
farmBtn.Position = UDim2.fromOffset(20,55)
farmBtn.Text = "AUTO FARM : OFF"
farmBtn.Font = Enum.Font.GothamBold
farmBtn.TextSize = 14
farmBtn.TextColor3 = Color3.new(1,1,1)
farmBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner", farmBtn)

farmBtn.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	farmBtn.Text = autoFarm and "AUTO FARM : ON" or "AUTO FARM : OFF"
	farmBtn.BackgroundColor3 = autoFarm
		and Color3.fromRGB(0,170,0)
		or Color3.fromRGB(170,0,0)
end)

--==================================================
-- AUTO SELL BUTTON
--==================================================
local sellBtn = Instance.new("TextButton", frame)
sellBtn.Size = UDim2.fromOffset(210,40)
sellBtn.Position = UDim2.fromOffset(20,105)
sellBtn.Text = "AUTO SELL : OFF"
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 14
sellBtn.TextColor3 = Color3.new(1,1,1)
sellBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner", sellBtn)

sellBtn.MouseButton1Click:Connect(function()
	autoSell = not autoSell
	sellBtn.Text = autoSell and "AUTO SELL : ON" or "AUTO SELL : OFF"
	sellBtn.BackgroundColor3 = autoSell
		and Color3.fromRGB(255,170,0)
		or Color3.fromRGB(170,0,0)
end)