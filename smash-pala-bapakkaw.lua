-- =====================================================
-- AUTO FARM ALL ZONE + SELL TOGGLE (FINAL)
-- =====================================================

-- SERVICES
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer

-- ================= CONFIG =================
local ATTACK_RADIUS = 100
local ATTACK_DELAY  = 0.01
local SCAN_DELAY    = 0.2
local OFFSET        = Vector3.new(0,6,0)

local SELL_DELAY = 3 -- detik

-- ================= STATE =================
local FARM_ON = false
local SELL_ON = false

-- ================= CHARACTER =================
local char, hrp
local function loadChar()
	char = lp.Character or lp.CharacterAdded:Wait()
	hrp = char:WaitForChild("HumanoidRootPart")
end
loadChar()
lp.CharacterAdded:Connect(loadChar)

-- ================= ACTION EVENT =================
local ActionEvent
repeat
	ActionEvent = RS:FindFirstChild("Events") and RS.Events:FindFirstChild("Action")
	task.wait()
until ActionEvent

-- ================= FARM LOGIC =================
local function alive(hitbox)
	return hitbox and hitbox:IsDescendantOf(workspace)
end

local function attack(hitbox)
	if not hrp or not alive(hitbox) then return end
	firetouchinterest(hrp, hitbox, 0)
	firetouchinterest(hrp, hitbox, 1)
end

local function getNearestTarget()
	if not hrp then return end
	local nearest, dist
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Name == "Hitbox" then
			local d = (v.Position - hrp.Position).Magnitude
			if d <= ATTACK_RADIUS and (not dist or d < dist) then
				nearest, dist = v, d
			end
		end
	end
	return nearest, dist
end

task.spawn(function()
	while task.wait(SCAN_DELAY) do
		if not FARM_ON or not hrp then continue end
		local target, dist = getNearestTarget()
		if target then
			if dist > 8 then
				hrp.CFrame = target.CFrame + OFFSET
			end
			ActionEvent:FireServer("Settings",{Name="AutoAttack",Value=true})
			local t = os.clock()
			while os.clock() - t < 1 do
				if not FARM_ON or not alive(target) then break end
				attack(target)
				task.wait(ATTACK_DELAY)
			end
		end
	end
end)

-- ================= SELL LOOP =================
task.spawn(function()
	while task.wait(SELL_DELAY) do
		if SELL_ON then
			ActionEvent:FireServer("SellAllTools",{Type="All"})
		end
	end
end)

-- ================= UI =================
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "AutoFarmAllUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45,0.36)
main.Position = UDim2.fromScale(0.5,0.1)
main.AnchorPoint = Vector2.new(0.5,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

-- DRAG MAIN
local dragging, dragStart, startPos
main.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = main.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging then
		local d = i.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() dragging = false end)

-- TOGGLE FARM
local farmBtn = Instance.new("TextButton", main)
farmBtn.Size = UDim2.fromScale(0.85,0.18)
farmBtn.Position = UDim2.fromScale(0.075,0.1)
farmBtn.Text = "FARM : OFF"
farmBtn.Font = Enum.Font.GothamBold
farmBtn.TextScaled = true
farmBtn.BackgroundColor3 = Color3.fromRGB(160,60,60)
farmBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", farmBtn)

farmBtn.MouseButton1Click:Connect(function()
	FARM_ON = not FARM_ON
	farmBtn.Text = FARM_ON and "FARM : ON" or "FARM : OFF"
	farmBtn.BackgroundColor3 = FARM_ON and Color3.fromRGB(60,160,60) or Color3.fromRGB(160,60,60)
	if not FARM_ON then
		ActionEvent:FireServer("Settings",{Name="AutoAttack",Value=false})
	end
end)

-- RADIUS LABEL
local label = Instance.new("TextLabel", main)
label.Size = UDim2.fromScale(0.85,0.1)
label.Position = UDim2.fromScale(0.075,0.32)
label.Text = "ATTACK RADIUS (100–999)"
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextColor3 = Color3.new(1,1,1)
label.BackgroundTransparency = 1

-- RADIUS INPUT
local radiusBox = Instance.new("TextBox", main)
radiusBox.Size = UDim2.fromScale(0.85,0.16)
radiusBox.Position = UDim2.fromScale(0.075,0.42)
radiusBox.Text = tostring(ATTACK_RADIUS)
radiusBox.Font = Enum.Font.GothamBold
radiusBox.TextScaled = true
radiusBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
radiusBox.TextColor3 = Color3.new(1,1,1)
radiusBox.ClearTextOnFocus = false
Instance.new("UICorner", radiusBox)

radiusBox.FocusLost:Connect(function()
	local v = tonumber(radiusBox.Text)
	if v then
		v = math.clamp(v,100,999)
		ATTACK_RADIUS = v
		radiusBox.Text = tostring(v)
	end
end)

-- SELL TOGGLE
local sellBtn = Instance.new("TextButton", main)
sellBtn.Size = UDim2.fromScale(0.85,0.18)
sellBtn.Position = UDim2.fromScale(0.075,0.62)
sellBtn.Text = "SELL : OFF"
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextScaled = true
sellBtn.BackgroundColor3 = Color3.fromRGB(160,80,60)
sellBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", sellBtn)

sellBtn.MouseButton1Click:Connect(function()
	SELL_ON = not SELL_ON
	sellBtn.Text = SELL_ON and "SELL : ON" or "SELL : OFF"
	sellBtn.BackgroundColor3 = SELL_ON and Color3.fromRGB(80,160,80) or Color3.fromRGB(160,80,60)
end)

-- ================= MINIMIZE + DRAG ICON =================
local minimized = false

local miniBtn = Instance.new("TextButton", main)
miniBtn.Size = UDim2.fromScale(0.12,0.14)
miniBtn.Position = UDim2.fromScale(0.86,0.02)
miniBtn.Text = "—"
miniBtn.TextScaled = true
miniBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
miniBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1,0)

local miniIcon = Instance.new("TextButton", gui)
miniIcon.Size = UDim2.fromScale(0.1,0.06)
miniIcon.Position = main.Position
miniIcon.Text = "👨‍💻"
miniIcon.TextScaled = true
miniIcon.BackgroundColor3 = Color3.fromRGB(120,60,160)
miniIcon.TextColor3 = Color3.new(1,1,1)
miniIcon.Visible = false
miniIcon.ZIndex = 1000
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1,0)

-- drag icon
local idrag, istart, ipos
miniIcon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		idrag = true; istart = i.Position; ipos = miniIcon.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if idrag then
		local d = i.Position - istart
		miniIcon.Position = UDim2.new(ipos.X.Scale,ipos.X.Offset+d.X,ipos.Y.Scale,ipos.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() idrag = false end)

miniBtn.MouseButton1Click:Connect(function()
	minimized = true
	miniIcon.Position = main.Position
	main.Visible = false
	miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
	minimized = false
	main.Visible = true
	miniIcon.Visible = false
end)

warn("✅ AUTO FARM ALL ZONE + SELL TOGGLE LOADED")