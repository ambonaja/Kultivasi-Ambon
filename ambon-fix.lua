--====================================================
-- LOADING SCREEN + PROGRESS %
--====================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Rep = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local loadingGui = Instance.new("ScreenGui", Player.PlayerGui)
loadingGui.ResetOnSpawn = false

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,10)
bg.BackgroundTransparency = 1
TweenService:Create(bg,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()

local box = Instance.new("Frame", bg)
box.Size = UDim2.new(0,280,0,140)
box.Position = UDim2.new(0.5,-140,0.5,-70)
box.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",box)

local title = Instance.new("TextLabel", box)
title.Size = UDim2.new(1,0,0,36)
title.Position = UDim2.new(0,0,0,16)
title.Text = "Loading Auto Fish"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local percent = Instance.new("TextLabel", box)
percent.Size = UDim2.new(1,0,0,20)
percent.Position = UDim2.new(0,0,0,52)
percent.Text = "0%"
percent.Font = Enum.Font.Gotham
percent.TextSize = 12
percent.TextColor3 = Color3.fromRGB(180,180,180)
percent.BackgroundTransparency = 1

local barBG = Instance.new("Frame", box)
barBG.Size = UDim2.new(1,-40,0,10)
barBG.Position = UDim2.new(0,20,1,-36)
barBG.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner",barBG)

local barLoad = Instance.new("Frame", barBG)
barLoad.Size = UDim2.new(0,0,1,0)
barLoad.BackgroundColor3 = Color3.fromRGB(90,170,255)
Instance.new("UICorner",barLoad)

local start = tick()
local duration = 1.3
task.spawn(function()
	while tick()-start < duration do
		local p = math.clamp((tick()-start)/duration,0,1)
		percent.Text = math.floor(p*100).."%"
		barLoad.Size = UDim2.new(p,0,1,0)
		RunService.RenderStepped:Wait()
	end
end)

task.wait(duration)
TweenService:Create(bg,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
task.wait(0.45)
loadingGui:Destroy()

--====================================================
-- AUTO FARM FISH GUI
--====================================================
pcall(function()
	if _G.AUTO_FISH_GUI then _G.AUTO_FISH_GUI:Destroy() end
end)

local FishingSystem = Rep:WaitForChild("FishingSystem",5)
local FishGiver = FishingSystem:WaitForChild("FishGiver")

local FishList = {
	"Ciyup Carber","Megalodon Core","Hammer Shark",
	"Jellyfish core","Amber","Voyage",
	"King Monster","Paus Corda","Kuzjuy Shark","Cindera Fish"
}

local AutoFarm = false
local RandomFish = true
local Mode = "BRUTAL"
local Delay = 0.12
local SelectedFish = FishList[1]

-- GUI ROOT
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name = "AUTO_FISH_GUI"
gui.ResetOnSpawn = false
_G.AUTO_FISH_GUI = gui

-- ICON IKAN
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,12,0.5,-24)
icon.Text = "🐟"
icon.Font = Enum.Font.GothamBold
icon.TextSize = 24
icon.BackgroundColor3 = Color3.fromRGB(35,35,35)
icon.TextColor3 = Color3.new(1,1,1)
icon.Active = true
icon.Draggable = true
Instance.new("UICorner",icon)

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,360,0,240)
main.Position = UDim2.new(0.5,-180,0.5,-120)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner",main)

-- HEADER
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,-40,0,32)
header.Position = UDim2.new(0,10,0,0)
header.Text = "AUTO FARM FISH"
header.TextXAlignment = Enum.TextXAlignment.Left
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.TextColor3 = Color3.new(1,1,1)
header.BackgroundTransparency = 1

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-34,0,2)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
minimize.BackgroundTransparency = 1
minimize.TextColor3 = Color3.new(1,1,1)

-- TAB BAR
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1,-20,0,28)
tabBar.Position = UDim2.new(0,10,0,36)
tabBar.BackgroundTransparency = 1

local function tab(txt,x)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(0,80,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.Text = txt
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)
	return b
end

local tMain = tab("MAIN",0)
local tFish = tab("FISH",90)
local tDiscord = tab("DISCORD",180)
local tSet = tab("SET",270)

-- PAGES
local pages = Instance.new("Frame", main)
pages.Size = UDim2.new(1,-20,1,-90)
pages.Position = UDim2.new(0,10,0,72)
pages.BackgroundTransparency = 1

local pageMain = Instance.new("Frame", pages)
local pageFish = Instance.new("Frame", pages)
local pageDiscord = Instance.new("Frame", pages)
local pageSet = Instance.new("Frame", pages)

for _,p in pairs({pageMain,pageFish,pageDiscord,pageSet}) do
	p.Size = UDim2.new(1,0,1,0)
	p.BackgroundTransparency = 1
	p.Visible = false
end
pageMain.Visible = true

local function show(p)
	for _,pg in pairs({pageMain,pageFish,pageDiscord,pageSet}) do
		pg.Visible = false
	end
	p.Visible = true
end

tMain.MouseButton1Click:Connect(function() show(pageMain) end)
tFish.MouseButton1Click:Connect(function() show(pageFish) end)
tDiscord.MouseButton1Click:Connect(function() show(pageDiscord) end)
tSet.MouseButton1Click:Connect(function() show(pageSet) end)

-- MAIN PAGE
local autoBtn = Instance.new("TextButton", pageMain)
autoBtn.Size = UDim2.new(1,0,0,36)
autoBtn.Text = "AUTO FARM : OFF"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 13
autoBtn.BackgroundColor3 = Color3.fromRGB(120,50,50)
autoBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",autoBtn)

autoBtn.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm
	autoBtn.Text = AutoFarm and "AUTO FARM : ON" or "AUTO FARM : OFF"
	autoBtn.BackgroundColor3 = AutoFarm and Color3.fromRGB(60,150,90) or Color3.fromRGB(120,50,50)
end)

-- SET PAGE
local modeBtn = Instance.new("TextButton", pageSet)
modeBtn.Size = UDim2.new(1,0,0,32)
modeBtn.Text = "MODE : BRUTAL"
modeBtn.Font = Enum.Font.Gotham
modeBtn.TextSize = 12
modeBtn.BackgroundColor3 = Color3.fromRGB(140,60,60)
modeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",modeBtn)

modeBtn.MouseButton1Click:Connect(function()
	if Mode == "SAFE" then
		Mode = "BRUTAL"
		Delay = 0.12
		modeBtn.Text = "MODE : BRUTAL"
		modeBtn.BackgroundColor3 = Color3.fromRGB(140,60,60)
	else
		Mode = "SAFE"
		Delay = 1.5
		modeBtn.Text = "MODE : SAFE"
		modeBtn.BackgroundColor3 = Color3.fromRGB(60,120,160)
	end
end)

-- FISH PAGE
local list = Instance.new("ScrollingFrame", pageFish)
list.Size = UDim2.new(1,0,1,0)
list.CanvasSize = UDim2.new(0,0,0,#FishList*36)
list.ScrollBarThickness = 4
list.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,6)

for _,fish in ipairs(FishList) do
	local b = Instance.new("TextButton", list)
	b.Size = UDim2.new(1,-6,0,30)
	b.Text = fish
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)

	b.MouseButton1Click:Connect(function()
		SelectedFish = fish
		pcall(function()
			FishGiver:FireServer(true,{
				name = fish,
				rarity = "Secret",
				weight = 600,
				hookPosition = Vector3.new(0,0,0)
			})
		end)
	end)
end

-- DISCORD PAGE
local dBtn = Instance.new("TextButton", pageDiscord)
dBtn.Size = UDim2.new(1,0,0,36)
dBtn.Text = "OPEN DISCORD"
dBtn.Font = Enum.Font.GothamBold
dBtn.TextSize = 13
dBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
dBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",dBtn)
dBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/DCgbDXE6p")
end)

-- PROGRESS BAR DELAY
local barBG2 = Instance.new("Frame", main)
barBG2.Size = UDim2.new(1,-20,0,10)
barBG2.Position = UDim2.new(0,10,1,-18)
barBG2.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",barBG2)

local bar = Instance.new("Frame", barBG2)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(90,170,255)
Instance.new("UICorner",bar)

local glow = Instance.new("UIStroke", bar)
glow.Color = Color3.fromRGB(255,80,80)
glow.Thickness = 0

-- MINIMIZE
minimize.MouseButton1Click:Connect(function()
	main.Visible = false
end)
icon.MouseButton1Click:Connect(function()
	main.Visible = true
	show(pageMain)
end)

-- LOOP
task.spawn(function()
	while true do
		if AutoFarm then
			bar.Size = UDim2.new(0,0,1,0)
			glow.Thickness = Mode=="BRUTAL" and 2 or 0

			TweenService:Create(
				bar,
				TweenInfo.new(Delay,Enum.EasingStyle.Linear),
				{Size = UDim2.new(1,0,1,0)}
			):Play()

			local fish = RandomFish and FishList[math.random(#FishList)] or SelectedFish
			pcall(function()
				FishGiver:FireServer(true,{
					name = fish,
					rarity = "Secret",
					weight = 600,
					hookPosition = Vector3.new(0,0,0)
				})
			end)
			task.wait(Delay)
		else
			bar.Size = UDim2.new(0,0,1,0)
			glow.Thickness = 0
			task.wait(0.25)
		end
	end
end)

print("✅ AUTO FARM FISH FULL SCRIPT READY")