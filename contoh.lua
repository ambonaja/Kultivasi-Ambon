--// MT AETHERIA AUTO TP GUI
--// Simple • Clean • Loop • Minimize

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")

-- ===== COORDINATES =====
local CPs = {
    CFrame.new(-893,153,-813),
    CFrame.new(-893,265,221),
    CFrame.new(-900,265,1455),
    CFrame.new(-726,593,2395),
    CFrame.new(321,593,3110),
    CFrame.new(1366,593,4406),
    CFrame.new(1429,581,5427),
    CFrame.new(419,633,5972),
    CFrame.new(-189,633,7086),
    CFrame.new(-517,677,8364),
    CFrame.new(-393,589,10044),
    CFrame.new(1163,589,10063),
    CFrame.new(1155,605,11704),
    CFrame.new(1141,605,12818),
    CFrame.new(1111,589,14978),
    CFrame.new(1122,609,16905),
    CFrame.new(1122,609,18727),
    CFrame.new(1290,609,20622),
    CFrame.new(2681,609,20616),
    CFrame.new(5073,609,20436),
    CFrame.new(5041,609,18666),
    CFrame.new(4971,609,16141),
    CFrame.new(3579,609,14777),
    CFrame.new(3581,901,13676),
    CFrame.new(3678,1265,12387),
    CFrame.new(4706,1273,11691)
}

local SUMMIT = CFrame.new(4779,8484,10355)
local BC = CFrame.new(-1217,53,-2291)

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AetheriaGUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,220)
main.Position = UDim2.new(0.05,0,0.35,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Name = "Main"

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "MT AETHERIA AUTO TP"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local delayBox = Instance.new("TextBox", main)
delayBox.PlaceholderText = "Delay (1 - 10)"
delayBox.Text = "2"
delayBox.Size = UDim2.new(0.8,0,0,30)
delayBox.Position = UDim2.new(0.1,0,0,60)
delayBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 13
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0,8)

local startBtn = Instance.new("TextButton", main)
startBtn.Text = "START"
startBtn.Size = UDim2.new(0.8,0,0,35)
startBtn.Position = UDim2.new(0.1,0,0,105)
startBtn.BackgroundColor3 = Color3.fromRGB(60,180,75)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,8)

local stopBtn = Instance.new("TextButton", main)
stopBtn.Text = "STOP"
stopBtn.Size = UDim2.new(0.8,0,0,35)
stopBtn.Position = UDim2.new(0.1,0,0,150)
stopBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,8)

local minBtn = Instance.new("TextButton", main)
minBtn.Text = "_"
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,5)
minBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", minBtn)

-- ===== LOGIC =====
local running = false
local minimized = false

local function tp(cf)
    if hrp then
        hrp.CFrame = cf
    end
end

spawn(function()
    while true do
        task.wait(0.2)
        char = player.Character
        if char then
            hrp = char:FindFirstChild("HumanoidRootPart")
        end
    end
end)

startBtn.MouseButton1Click:Connect(function()
    if running then return end
    running = true

    task.spawn(function()
        while running do
            local delayTime = tonumber(delayBox.Text) or 2
            delayTime = math.clamp(delayTime,1,10)

            for _,cp in ipairs(CPs) do
                if not running then break end
                tp(cp)
                task.wait(delayTime)
            end

            if not running then break end
            tp(SUMMIT)
            task.wait(delayTime)

            tp(BC)
            task.wait(delayTime)
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0,160,0,35) or UDim2.new(0,260,0,220)
end)
