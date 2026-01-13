--==================================================
-- AUTO TARGET TAP + AUTO FIGHTCLICK (FORCE WORK)
--==================================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- REMOTES
local fishing = RS:WaitForChild("events"):WaitForChild("fishing")
local targetTap  = fishing:WaitForChild("targetTap")
local fightClick = fishing:WaitForChild("fightClick")

-- ================= CONFIG =================
local ENABLED = true
local TARGET_TAP_RATE = 40
local FIGHT_RATE = 40
-- =========================================

local targetCount = 0
local fightCount = 0
local lastReset = tick()

-- ================= TARGET TAP DETECT =================
local autoTargetTap = false

local function isTargetTapUI(obj)
	if not obj:IsA("GuiObject") then return false end
	local n = obj.Name:lower()
	return n:find("tap") or n:find("target")
end

PlayerGui.DescendantAdded:Connect(function(obj)
	if isTargetTapUI(obj) then
		autoTargetTap = true
	end
end)

PlayerGui.DescendantRemoving:Connect(function(obj)
	if isTargetTapUI(obj) then
		autoTargetTap = false
	end
end)

-- ================= BAR DETECT (REAL) =================
local function fightBarExists()
	for _,v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("ImageLabel") or v:IsA("Frame") then
			local n = v.Name:lower()
			if n:find("bar") or n:find("fill") or n:find("progress") then
				if v.AbsoluteSize.Y > 10 then
					return true
				end
			end
		end
	end
	return false
end

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end

	-- reset tiap 1 detik
	if tick() - lastReset >= 1 then
		targetCount = 0
		fightCount = 0
		lastReset = tick()
	end

	-- ===== TARGET TAP =====
	if autoTargetTap and targetCount < TARGET_TAP_RATE then
		pcall(function()
			targetTap:InvokeServer()
		end)
		targetCount += 1
	end

	-- ===== FIGHT CLICK (PASTI NAIK) =====
	if fightBarExists() and fightCount < FIGHT_RATE then
		pcall(function()
			fightClick:FireServer()
		end)
		fightCount += 1
	end
end)

print("✅ AUTO TARGET TAP + AUTO FIGHTCLICK (FORCED) LOADED")