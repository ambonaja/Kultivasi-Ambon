-- =====================================
-- SIMPLE AUTO FARM GUI (ANTI FREEZE)
-- =====================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local autofarm = false

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFarmGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 45)
btn.Position = UDim2.new(0, 20, 0.5, -22)
btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
btn.Text = "AUTO FARM : OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.BorderSizePixel = 0
btn.Parent = gui

-- ===== AUTO FARM LOOP =====
task.spawn(function()
	while true do
		if autofarm then
			-- ===== Remote 1 =====
			task.wait(0.1)
			pcall(function()
				local args1 = {
					buffer.fromstring("?\000\000\000@\240>{>\000\000\000\192\002\218\239\191\000\000\000@!\160\184?\028\255\135U\145s\237?")
				}
				RS.Modules.Networking.ByteNetMax.system.ByteNetReliable:FireServer(unpack(args1))
			end)

			-- ===== Remote 2 (InvokeServer ANTI FREEZE) =====
			task.wait(0.1)
			task.spawn(function()
				pcall(function()
					local args2 = {
						buffer.fromstring("\014\001"),
						{ player },
						14
					}
					RS.Modules.Networking.ByteNetMax.system.ByteNetQuery:InvokeServer(unpack(args2))
				end)
			end)

			-- ===== Remote 3 =====
			task.wait(0.1)
			pcall(function()
				local args3 = {
					buffer.fromstring("\017\001\000")
				}
				RS.Modules.Networking.ByteNetMax.system.ByteNetReliable:FireServer(unpack(args3))
			end)
		end

		task.wait(0.05)
	end
end)

-- ===== BUTTON TOGGLE =====
btn.MouseButton1Click:Connect(function()
	autofarm = not autofarm

	if autofarm then
		btn.Text = "AUTO FARM : ON"
		btn.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
	else
		btn.Text = "AUTO FARM : OFF"
		btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	end
end)