--==================================================
-- AUTO FISH + AUTO SELL + LEADERBOARD SEED ABUSE
-- SAFE / BRUTAL / GOD (BURST CYCLING)
--==================================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Remotes = RS:WaitForChild("Remotes")

-- ROD
local Rod = RS:WaitForChild("Assets"):WaitForChild("Rods"):WaitForChild("Phoenixflare")

-- REMOTES
local Cast = Remotes:WaitForChild("Cast")
local getFish = Remotes:WaitForChild("getFish")
local CatchReplication = Remotes:WaitForChild("CatchReplication")
local pickupFish = Remotes:WaitForChild("pickupFish")
local Sell = Remotes:WaitForChild("Sell")

--==================================================
-- MODE CONFIG
--==================================================
local MODES = {
	SAFE   = { delay = 0.35, basePower = 6,  sell = 10 },
	BRUTAL = { delay = 0.15, basePower = 9,  sell = 6  },
	GOD    = { delay = 0,    basePower = 14, sell = 0  }
}

local ACTIVE_MODE = nil
local ENABLED = false

--==================================================
-- LEADERBOARD SEED ENGINE (V2)
--==================================================
local RNG = Random.new()
local seedTick = 0

local function leaderboardSeed()
	seedTick += 1
	local t  = tick()
	local c  = os.clock()
	local r1 = RNG:NextNumber(1e4, 1e7)
	local r2 = RNG:NextInteger(1e5, 1e9)
	return (t * c * r1 + r2) % 1e9 + seedTick
end

--==================================================
-- UI (ICON + FRAME)
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,45,0,45)
icon.Position = UDim2.new(0.03,0,0.5,0)
icon.Text = "🐟"
icon.TextSize = 22
icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
icon.TextColor3 = Color3.new(1,1,1)
icon.Active = true
icon.Draggable = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,190)
frame.Position = UDim2.new(0.05,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Active = true
frame.Draggable = true

icon.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,25,0,25)
minBtn.Position = UDim2.new(1,-30,0,5)
minBtn.Text = "–"
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

--==================================================
-- MODE BUTTONS
--==================================================
local function makeToggle(text, y, mode)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1,-10,0,40)
	btn.Position = UDim2.new(0,5,0,y)
	btn.Text = text.." [OFF]"
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.new(1,1,1)

	btn.MouseButton1Click:Connect(function()
		if ACTIVE_MODE == mode then
			ACTIVE_MODE = nil
			ENABLED = false
			btn.Text = text.." [OFF]"
			btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		else
			ACTIVE_MODE = mode
			ENABLED = true
			for _,b in pairs(frame:GetChildren()) do
				if b:IsA("TextButton") and b ~= minBtn then
					b.Text = b.Text:gsub("%[ON%]","[OFF]")
					b.BackgroundColor3 = Color3.fromRGB(40,40,40)
				end
			end
			btn.Text = text.." [ON]"
			btn.BackgroundColor3 = Color3.fromRGB(0,150,80)
		end
	end)
end

makeToggle("SAFE MODE",   40,  "SAFE")
makeToggle("BRUTAL MODE", 85,  "BRUTAL")
makeToggle("GOD MODE",    130, "GOD")

--==================================================
-- AUTO SELL LOOP
--==================================================
task.spawn(function()
	while true do
		if ENABLED and ACTIVE_MODE then
			local cfg = MODES[ACTIVE_MODE]
			pcall(function()
				Sell:InvokeServer("sellAll")
			end)
			if cfg.sell > 0 then task.wait(cfg.sell) end
		else
			task.wait(0.5)
		end
	end
end)

--==================================================
-- AUTO FISH LOOP (BURST CYCLING)
--==================================================
local burstPhase = 0

task.spawn(function()
	while true do
		if ENABLED and ACTIVE_MODE then
			local cfg = MODES[ACTIVE_MODE]

			-- phase cycle (anti soft-cap)
			burstPhase = (burstPhase % 4) + 1

			local multi
			if ACTIVE_MODE == "SAFE" then
				multi = 1
			elseif ACTIVE_MODE == "BRUTAL" then
				multi = math.random(6,12)
			else -- GOD
				if burstPhase == 1 then
					multi = math.random(20,40)
				elseif burstPhase == 2 then
					multi = math.random(60,90)
				elseif burstPhase == 3 then
					multi = math.random(120,180) -- 🔥 SECRET SPIKE
				else
					multi = math.random(10,25)   -- cooldown disguise
				end
			end

			local power =
				cfg.basePower
				+ (burstPhase * 0.6)
				+ RNG:NextNumber(0,1.2)

			pcall(function()
				Cast:FireServer(Rod)

				for i = 1, multi do
					getFish:InvokeServer(
						leaderboardSeed(),
						CFrame.new(
							math.random(-8,8),
							0,
							math.random(-8,8)
						),
						power,
						false,
						Rod
					)
				end

				CatchReplication:FireServer()
				pickupFish:FireServer()
			end)

			if cfg.delay > 0 then task.wait(cfg.delay) end
		else
			task.wait(0.2)
		end
	end
end)