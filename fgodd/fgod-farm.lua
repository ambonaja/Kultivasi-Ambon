--############################################################-- 
--####      AUTO FISHING SCRIPT - AMBONHUB 🚯         ####--
--####          DOUBLE SPAM MODE - EXTREME            ####--
--####          OWNER : AMBONHUB 🚯                   ####--
--####          JANGAN REUPLOAD GOBLOK                ####--
--############################################################--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local QuestRemotes = ReplicatedStorage:WaitForChild("QuestRemotes")
local player = Players.LocalPlayer

-- WATERMARK KECIL 🚯
local function showWatermark()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AmbonHubWatermark"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 180, 0, 18)
    textLabel.Position = UDim2.new(0, 8, 1, -25)
    textLabel.BackgroundTransparency = 0.6
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    textLabel.Text = "AMBONHUB 🚯 | DOUBLE SPAM"
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 11
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.Parent = screenGui
end
showWatermark()

-- Fungsi buat dapetin rod
local function getEquippedRod()
    local inventory = player:FindFirstChild("PlayerGui"):FindFirstChild("Inventory")
    if inventory then
        local rods = inventory:FindFirstChild("Rods")
        if rods then
            for _, rod in pairs(rods:GetChildren()) do
                if rod:FindFirstChild("Equipped") and rod.Equipped.Value == true then
                    return rod.Name
                end
            end
        end
    end
    return "Seraphic Sunspire"
end

-- Fungsi spam fishing
local function doFishing()
    local hrp = player.Character.HumanoidRootPart
    local pos = hrp.Position
    local currentRod = getEquippedRod()
    
    local hookPos = vector.create(pos.X, pos.Y - 3, pos.Z)
    local castPos = vector.create(pos.X, pos.Y + 2, pos.Z)
    
    -- CastReplication
    local args1 = { hookPos, castPos, currentRod, 93 }
    FishingSystem:WaitForChild("CastReplication"):FireServer(unpack(args1))
    
    -- StartFishing
    local args2 = { castPos }
    FishingSystem:WaitForChild("StartFishing"):FireServer(unpack(args2))
    
    -- CastRodEvent
    QuestRemotes:WaitForChild("CastRodEvent"):FireServer()
    
    -- RequestFishRoll
    local args3 = { castPos }
task.wait(0.001)
    FishingSystem:WaitForChild("RequestFishRoll"):InvokeServer(unpack(args3))
    
    -- CleanupCast
    FishingSystem:WaitForChild("CleanupCast"):FireServer()
    
    -- FishGiver
    local args4 = { { hookPosition = hookPos, zone = "stater" } }
task.wait(0.001)
    FishingSystem:WaitForChild("FishGiver"):FireServer(unpack(args4))
end

print("[AMBONHUB 🚯] DOUBLE SPAM MODE ACTIVATED! GANAS!")

-- DOUBLE SPAM LOOP
while task.wait() do
    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    -- Spam pertama
    doFishing()
    task.wait(0.001)
    
    -- Spam kedua langsung gas
    doFishing()
    task.wait(0.001)
end