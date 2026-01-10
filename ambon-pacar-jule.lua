--==================================================
-- AUTO FISH | FINAL FULL MOBILE FIX (NO TITLE)
-- TAB IN HEADER FIX
--==================================================

pcall(function()
	if _G.AMBON_GUI then _G.AMBON_GUI:Destroy() end
end)

--================ SERVICES =================
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(c)
	Char = c
	HRP = c:WaitForChild("HumanoidRootPart")
end)

--================ REMOTES =================
local FishRemote = RS:WaitForChild("FishingYahiko")
local CastRemote = FishRemote:WaitForChild("CastReplication")
local GiveRemote = FishRemote:WaitForChild("YahikoGiver")

--================ STATE =================
local AutoFish = false
local Brutal = false
local SoundEnabled = true
local CurrentRod = "Basic Rod"
local ForcedZone = nil
local CastDelay = 1

local RodList = {
	"Basic Rod","PokemonRod","RavenRod","IcePink","QueenRod","DeathRod"
}

local Zones = {
	["Shadowfin Isle"] = Vector3.new(2100,0,400),
	["Lost Jungle"]    = Vector3.new(1200,0,-600),
	["Hunter Island"]  = Vector3.new(-800,0,900)
}

--================ GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AMBON_GUI"
gui.ResetOnSpawn = false
_G.AMBON_GUI = gui

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(540,260)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", main)

--================ HEADER =================
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,-10,0,45)
header.Position = UDim2.fromOffset(5,5)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", header)

--================ HEADER TABS =================
local function headerTab(txt,x)
	local b = Instance.new("TextButton", header)
	b.Size = UDim2.fromOffset(90,30)
	b.Position = UDim2.fromOffset(x,7)
	b.Text = txt
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

--================ MINIMIZE =================
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.fromOffset(32,32)
minBtn.AnchorPoint = Vector2.new(1,0.5)
minBtn.Position = UDim2.new(1,-6,0.5,0)
minBtn.Text = "—"
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn)

local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.fromOffset(50,50)
icon.Position = UDim2.fromScale(0.1,0.5)
icon.Image = "rbxassetid://6026568198"
icon.BackgroundColor3 = Color3.fromRGB(25,25,25)
icon.Visible = false
Instance.new("UICorner", icon)

--================ DRAG =================
local function drag(obj)
	local dragStart, startPos
	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragStart = i.Position
			startPos = obj.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragStart and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			obj.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
		end
	end)
	UIS.InputEnded:Connect(function() dragStart=nil end)
end
drag(main)
drag(icon)

minBtn.MouseButton1Click:Connect(function()
	main.Visible=false
	icon.Visible=true
end)
icon.MouseButton1Click:Connect(function()
	main.Visible=true
	icon.Visible=false
end)

--================ PAGES =================
local FishPage = Instance.new("Frame", main)
FishPage.Size = UDim2.fromOffset(260,190)
FishPage.Position = UDim2.fromOffset(10,60)
FishPage.BackgroundTransparency = 1
FishPage.Visible = true

local SystemPage = Instance.new("Frame", main)
SystemPage.Size = UDim2.fromOffset(260,190)
SystemPage.Position = UDim2.fromOffset(270,60)
SystemPage.BackgroundTransparency = 1
SystemPage.Visible = false

--================ TAB LOGIC =================
local fishTab = headerTab("FISH",10)
local sysTab  = headerTab("SYSTEM",110)

fishTab.MouseButton1Click:Connect(function()
	FishPage.Visible = true
	SystemPage.Visible = false
end)

sysTab.MouseButton1Click:Connect(function()
	FishPage.Visible = false
	SystemPage.Visible = true
end)

--================ BUTTON MAKER =================
local function mkBtn(p,t,y)
	local b = Instance.new("TextButton",p)
	b.Size = UDim2.fromOffset(250,35)
	b.Position = UDim2.fromOffset(0,y)
	b.Text = t
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)
	return b
end

--================ FISH PAGE =================
local afBtn = mkBtn(FishPage,"AUTO FISH : OFF",0)
afBtn.MouseButton1Click:Connect(function()
	AutoFish = not AutoFish
	afBtn.Text = "AUTO FISH : "..(AutoFish and "ON" or "OFF")
end)

local rodBtn = mkBtn(FishPage,"ROD : "..CurrentRod,45)
rodBtn.MouseButton1Click:Connect(function()
	local i = table.find(RodList,CurrentRod) or 1
	CurrentRod = RodList[(i % #RodList) + 1]
	rodBtn.Text = "ROD : "..CurrentRod
end)

local zoneBtn = mkBtn(FishPage,"ZONE : AUTO",90)
zoneBtn.MouseButton1Click:Connect(function()
	local keys={"AUTO"}
	for k in pairs(Zones) do table.insert(keys,k) end
	local cur = ForcedZone or "AUTO"
	local idx = table.find(keys,cur) or 1
	local nxt = keys[(idx % #keys)+1]
	ForcedZone = nxt~="AUTO" and nxt or nil
	zoneBtn.Text = "ZONE : "..(ForcedZone or "AUTO")
end)

--================ SYSTEM PAGE =================
local modeBtn = mkBtn(SystemPage,"MODE : SAFE",0)
modeBtn.MouseButton1Click:Connect(function()
	Brutal = not Brutal
	modeBtn.Text = "MODE : "..(Brutal and "BRUTAL" or "SAFE")
end)

local speedBtn = mkBtn(SystemPage,"SPEED : "..CastDelay,45)
speedBtn.MouseButton1Click:Connect(function()
	CastDelay -= 0.2
	if CastDelay < 0.4 then CastDelay = 1.6 end
	speedBtn.Text = "SPEED : "..string.format("%.1f",CastDelay)
end)

local soundBtn = mkBtn(SystemPage,"BRUTAL SOUND : ON",90)
soundBtn.MouseButton1Click:Connect(function()
	SoundEnabled = not SoundEnabled
	soundBtn.Text = "BRUTAL SOUND : "..(SoundEnabled and "ON" or "OFF")
end)

--================ ZONE HELPER =================
local function getZone()
	if ForcedZone then return ForcedZone, Zones[ForcedZone] end
	local pos=HRP.Position
	local best,dist="Shadowfin Isle",math.huge
	for n,p in pairs(Zones) do
		local d=(Vector3.new(pos.X,0,pos.Z)-Vector3.new(p.X,0,p.Z)).Magnitude
		if d<dist then dist=d; best=n end
	end
	return best, Zones[best]
end

--================ AUTO FISH CORE =================
task.spawn(function()
	while true do
		if AutoFish and HRP then
			local zn,zp = getZone()

			CastRemote:FireServer(
				HRP.Position + Vector3.new(0,5,0),
				Vector3.new(0,5,0),
				CurrentRod,
				Brutal and 100 or 80
			)

			task.wait(0.45)

			GiveRemote:FireServer({
				rodName = CurrentRod,
				hookPosition = zp or HRP.Position,
				powerPercent = Brutal and 1 or 0.8,
				zone = zn
			})
		end
		task.wait(CastDelay)
	end
end)