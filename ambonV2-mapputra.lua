--========================================
-- AUTO FISH SYSTEM (FARM + FISH PAGE)
-- 3 COLUMN GRID FIX + MINIMIZE ICON OK
--========================================

--============== SERVICES =================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

--============== REMOTES ==================
local FS = RS:WaitForChild("FishingSystem")
local Cast = FS:WaitForChild("CastReplication")
local Give = FS:WaitForChild("KasihIkanItu")
local Catch = RS:WaitForChild("FishingCatchSuccess")
local Valid = RS:WaitForChild("ShowValidasi")
local Rarity = RS:WaitForChild("ShowRarityExclamation")
local StatusUmpan = RS:WaitForChild("StatusLemparUmpan1")

--============== STATE ====================
local spam = false
local delayTime = 0.5
local timer = 0
local umpanSent = false
local selectedFish = {}

--============== DATA IKAN =================
local fishData = {
	{ name="King Monster", pos=Vector3.new(2527,141,-819) },
	{ name="Hammer Shark", pos=Vector3.new(-1874,144,2355) },
	{ name="Jellyfish core", pos=Vector3.new(-1874,144,2355) },
	{ name="Amber", pos=Vector3.new(-1162,160,-615) },
	{ name="Voyage", pos=Vector3.new(-1162,160,-615) },
	{ name="Puas Corda", pos=Vector3.new(1562,150,-3022) },
	{ name="Ciyup Carber", pos=Vector3.new(1439,209,-2509) },
	{ name="Megalodon Core", pos=Vector3.new(1439,209,-2509) },
	{ name="Kuzjuy Shark", pos=Vector3.new(710,134,1573) },
	{ name="Cindera Fish", pos=Vector3.new(710,134,1573) },
	{ name="Doplin Pink", pos=Vector3.new(710,134,1573) },
	{ name="Doplin Blue", pos=Vector3.new(710,134,1573) },
	{ name="Cype Darcoyellow", pos=Vector3.new(710,134,1573) },
	{ name="Cype Darcopink", pos=Vector3.new(710,134,1573) },
	{ name="Joar Cusyu", pos=Vector3.new(710,134,1573) },
}

--============== GUI ======================
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "AutoFish_System"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(300,340)
main.Position = UDim2.new(0.35,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

--============== TITLE ====================
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-40,0,32)
title.Position = UDim2.new(0,10,0,5)
title.Text = "AUTO FISH SYSTEM"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.fromOffset(26,26)
minimize.Position = UDim2.new(1,-32,0,6)
minimize.Text = "–"
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize)

--============== TABS =====================
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1,-20,0,30)
tabFrame.Position = UDim2.new(0,10,0,42)
tabFrame.BackgroundTransparency = 1

local farmTab = Instance.new("TextButton", tabFrame)
farmTab.Size = UDim2.new(0.5,-4,1,0)
farmTab.Text = "FARM"
farmTab.TextScaled = true
farmTab.BackgroundColor3 = Color3.fromRGB(40,120,40)
farmTab.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", farmTab)

local fishTab = farmTab:Clone()
fishTab.Parent = tabFrame
fishTab.Position = UDim2.new(0.5,4,0,0)
fishTab.Text = "FISH"
fishTab.BackgroundColor3 = Color3.fromRGB(40,40,40)

--============== PAGES ====================
local pages = Instance.new("Frame", main)
pages.Size = UDim2.new(1,-20,1,-90)
pages.Position = UDim2.new(0,10,0,78)
pages.BackgroundTransparency = 1

local farmPage = Instance.new("Frame", pages)
farmPage.Size = UDim2.fromScale(1,1)
farmPage.BackgroundTransparency = 1

local fishPage = Instance.new("Frame", pages)
fishPage.Size = UDim2.fromScale(1,1)
fishPage.Visible = false
fishPage.BackgroundTransparency = 1

--============== FARM PAGE ================
local spamBtn = Instance.new("TextButton", farmPage)
spamBtn.Size = UDim2.new(1,0,0,32)
spamBtn.Text = "SPAM : OFF"
spamBtn.TextScaled = true
spamBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
spamBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", spamBtn)

spamBtn.MouseButton1Click:Connect(function()
	spam = not spam
	timer = 0
	spamBtn.Text = "SPAM : "..(spam and "ON" or "OFF")
	spamBtn.BackgroundColor3 = spam and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)
end)

local delayBox = Instance.new("TextBox", farmPage)
delayBox.Size = UDim2.new(1,0,0,28)
delayBox.Position = UDim2.new(0,0,0,40)
delayBox.Text = tostring(delayTime)
delayBox.TextScaled = true
delayBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
delayBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", delayBox)

delayBox.FocusLost:Connect(function()
	local v = tonumber(delayBox.Text)
	if v then
		delayTime = math.clamp(v,0.05,2)
		delayBox.Text = tostring(delayTime)
	end
end)

local countdown = Instance.new("TextLabel", farmPage)
countdown.Size = UDim2.new(1,0,0,24)
countdown.Position = UDim2.new(0,0,0,74)
countdown.Text = "NEXT : -"
countdown.TextScaled = true
countdown.TextColor3 = Color3.new(1,1,1)
countdown.BackgroundTransparency = 1

--============== FISH PAGE (3 COLUMN) =====
local scroll = Instance.new("ScrollingFrame", fishPage)
scroll.Size = UDim2.fromScale(1,1)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarImageTransparency = 0.3
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

local grid = Instance.new("UIGridLayout", scroll)
grid.CellPadding = UDim2.fromOffset(6,6)

local function updateGrid()
	local width = scroll.AbsoluteWindowSize.X
	local cellWidth = math.floor((width - (grid.CellPadding.X.Offset * 2)) / 3)
	grid.CellSize = UDim2.fromOffset(cellWidth, 32)
end

scroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateGrid)
updateGrid()

grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,grid.AbsoluteContentSize.Y + 6)
end)

for _,f in ipairs(fishData) do
	local btn = Instance.new("TextButton", scroll)
	btn.Text = f.name
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		if selectedFish[f.name] then
			selectedFish[f.name] = nil
			btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		else
			selectedFish[f.name] = f
			btn.BackgroundColor3 = Color3.fromRGB(40,120,40)
		end
	end)
end

--============== TAB LOGIC ================
farmTab.MouseButton1Click:Connect(function()
	farmPage.Visible = true
	fishPage.Visible = false
	farmTab.BackgroundColor3 = Color3.fromRGB(40,120,40)
	fishTab.BackgroundColor3 = Color3.fromRGB(40,40,40)
end)

fishTab.MouseButton1Click:Connect(function()
	farmPage.Visible = false
	fishPage.Visible = true
	fishTab.BackgroundColor3 = Color3.fromRGB(40,120,40)
	farmTab.BackgroundColor3 = Color3.fromRGB(40,40,40)
end)

--============== FLOAT ICON ===============
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.fromOffset(44,44)
floatBtn.Position = UDim2.fromScale(0.05,0.5)
floatBtn.Text = "🎣"
floatBtn.TextScaled = true
floatBtn.Visible = false
floatBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.Active = true
floatBtn.Draggable = true
floatBtn.ZIndex = 999
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1,0)

minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	floatBtn.Visible = true
end)

floatBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	floatBtn.Visible = false
end)

--============== CORE LOOP ================
RunService.Heartbeat:Connect(function(dt)
	if not spam then
		timer = 0
		countdown.Text = "NEXT : -"
		return
	end

	timer += dt
	countdown.Text = string.format("NEXT : %.2fs", math.max(delayTime - timer,0))
	if timer < delayTime then return end
	timer = 0

	if not umpanSent then
		StatusUmpan:FireServer()
		umpanSent = true
	end

	for _,f in pairs(selectedFish) do
		Cast:FireServer(f.pos, Vector3.new(0,5,0), "Purple Saber", math.random(90,105))
		task.wait(0.05)

		Give:FireServer(true,{
			hookPosition = f.pos,
			name = f.name,
			rarity = "Secret",
			weight = math.random(400,650)
		})

		task.wait(0.05)
		Catch:FireServer()
		task.wait(0.03)
		Catch:FireServer()
		Valid:FireServer()
		Rarity:FireServer("Secret")
	end
end)