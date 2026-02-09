-- Auto Fish Farm GUI Compact dengan Semua Ikan
-- Created for Roblox fishing game

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Referensi RemoteEvents
local CastReplication = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("CastReplication")
local CleanupCast = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("CleanupCast")
local FishGiver = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("FishingSystemEvents"):WaitForChild("FishGiver")

-- Daftar Ikan Lengkap (SEMUA IKAN)
local AllFishList = {
    "Ancient Lochness Lava",
    "Ancient Lochness Monster",
    "Bajak Laut Dreadfin", 
    "Bajak Laut Megalodon",
    "Belut Panther",
    "Blackcap Basslet",
    "Blueflame Ray",
    "Boar Fish",
    "Candy Butterfly",
    "Cumi-cumi Penjaga Suci",
    "Cypress Ratua",
    "Domino Damsel",
    "Dory",
    "Dotted Stingray",
    "El Maja",
    "El Maja Merah",
    "Ences Maja",
    "Enchanted Angelfish",
    "Fangtooth",
    "Fossilized Shark",
    "Frostborn Shark",
    "Gadis Lava",
    "Goliath Tiger",
    "Green Gillfish",
    "Gurita Hijau",
    "Guttenfang",
    "Hammerhead Shark",
    "Hiu Magma",
    "Ikan Badut",
    "Ikan Cutlas",
    "Ikan Layar Bajak Laut",
    "Ikan Malaikat",
    "Kapten Ikan Buntal",
    "Kardian Lava",
    "Kelomang",
    "Kepala Ular",
    "Kepiting Biru",
    "Kepiting Harta Karun",
    "Kepiting Pelaut",
    "Kupu-Kupu Lava",
    "Loggerhead Turtle",
    "Lopster Biru",
    "Lopster Merah",
    "Megalodon",
    "Purple Megalodon",
    "Tulang Koi",
    "Tuna Lava",
    "Volsail Tang",
    "Zombie Megalodon",
    "ikan bandit",
    "Ancient Magma Whale"
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 420) -- Sedikit lebih tinggi untuk semua ikan
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AmbonXLonely🚯"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -55, 0.5, -12.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0.5, -12.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Content Area dengan Scroll
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, 0, 1, -35)
ScrollFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, 0)
ContentFrame.Position = UDim2.new(0, 10, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = ScrollFrame

-- Status Section
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(1, 0, 0, 50)
StatusFrame.Position = UDim2.new(0, 0, 0, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = ContentFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 8)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "StatsLabel"
StatsLabel.Size = UDim2.new(1, -20, 0, 15)
StatsLabel.Position = UDim2.new(0, 10, 0, 30)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Fish: 0 | Weight: 0"
StatsLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
StatsLabel.TextSize = 12
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = StatusFrame

-- Settings Section
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Size = UDim2.new(1, 0, 0, 80)
SettingsFrame.Position = UDim2.new(0, 0, 0, 60)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Parent = ContentFrame

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SettingsFrame

-- Rod Input
local RodInput = Instance.new("TextBox")
RodInput.Name = "RodInput"
RodInput.Size = UDim2.new(0.6, -5, 0, 30)
RodInput.Position = UDim2.new(0, 10, 0, 10)
RodInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
RodInput.BorderSizePixel = 0
RodInput.Text = "Diamond Rod"
RodInput.PlaceholderText = "Rod Name"
RodInput.TextColor3 = Color3.fromRGB(255, 255, 255)
RodInput.TextSize = 14
RodInput.Font = Enum.Font.Gotham
RodInput.Parent = SettingsFrame

local RodInputCorner = Instance.new("UICorner")
RodInputCorner.CornerRadius = UDim.new(0, 4)
RodInputCorner.Parent = RodInput

-- Power Button
local PowerButton = Instance.new("TextButton")
PowerButton.Name = "PowerButton"
PowerButton.Size = UDim2.new(0.4, -5, 0, 30)
PowerButton.Position = UDim2.new(0.6, 5, 0, 10)
PowerButton.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
PowerButton.BorderSizePixel = 0
PowerButton.Text = "PWR: 96"
PowerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PowerButton.TextSize = 14
PowerButton.Font = Enum.Font.GothamBold
PowerButton.Parent = SettingsFrame

local PowerCorner = Instance.new("UICorner")
PowerCorner.CornerRadius = UDim.new(0, 4)
PowerCorner.Parent = PowerButton

-- Secret Mode Toggle
local SecretButton = Instance.new("TextButton")
SecretButton.Name = "SecretButton"
SecretButton.Size = UDim2.new(1, -20, 0, 30)
SecretButton.Position = UDim2.new(0, 10, 0, 45)
SecretButton.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
SecretButton.BorderSizePixel = 0
SecretButton.Text = "🔒 SECRET MODE"
SecretButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SecretButton.TextSize = 14
SecretButton.Font = Enum.Font.GothamBold
SecretButton.Parent = SettingsFrame

local SecretCorner = Instance.new("UICorner")
SecretCorner.CornerRadius = UDim.new(0, 4)
SecretCorner.Parent = SecretButton

-- Fish Selection dengan SEMUA IKAN
local FishFrame = Instance.new("Frame")
FishFrame.Name = "FishFrame"
FishFrame.Size = UDim2.new(1, 0, 0, 180) -- Tinggi ditambah untuk semua ikan
FishFrame.Position = UDim2.new(0, 0, 0, 150)
FishFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FishFrame.BorderSizePixel = 0
FishFrame.Parent = ContentFrame

local FishCorner = Instance.new("UICorner")
FishCorner.CornerRadius = UDim.new(0, 6)
FishCorner.Parent = FishFrame

local FishTitle = Instance.new("TextLabel")
FishTitle.Name = "FishTitle"
FishTitle.Size = UDim2.new(1, -20, 0, 20)
FishTitle.Position = UDim2.new(0, 10, 0, 5)
FishTitle.BackgroundTransparency = 1
FishTitle.Text = "🐟 Select Fish (" .. #AllFishList .. " total)"
FishTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FishTitle.TextSize = 14
FishTitle.Font = Enum.Font.GothamBold
FishTitle.TextXAlignment = Enum.TextXAlignment.Left
FishTitle.Parent = FishFrame

-- Search Box
local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -20, 0, 25)
SearchBox.Position = UDim2.new(0, 10, 0, 30)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "🔍 Search fish..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.Gotham
SearchBox.Parent = FishFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchBox

-- Selected Fish Display
local SelectedFishLabel = Instance.new("TextLabel")
SelectedFishLabel.Name = "SelectedFishLabel"
SelectedFishLabel.Size = UDim2.new(1, -20, 0, 20)
SelectedFishLabel.Position = UDim2.new(0, 10, 0, 155)
SelectedFishLabel.BackgroundTransparency = 1
SelectedFishLabel.Text = "Selected: Kepiting Biru"
SelectedFishLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
SelectedFishLabel.TextSize = 13
SelectedFishLabel.Font = Enum.Font.GothamBold
SelectedFishLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedFishLabel.TextTruncate = Enum.TextTruncate.AtEnd
SelectedFishLabel.Parent = FishFrame

-- Fish Grid Scrollable
local FishGrid = Instance.new("ScrollingFrame")
FishGrid.Name = "FishGrid"
FishGrid.Size = UDim2.new(1, -20, 0, 95)
FishGrid.Position = UDim2.new(0, 10, 0, 60)
FishGrid.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FishGrid.BorderSizePixel = 0
FishGrid.ScrollBarThickness = 6
FishGrid.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
FishGrid.Parent = FishFrame

local FishGridLayout = Instance.new("UIGridLayout")
FishGridLayout.Name = "FishGridLayout"
FishGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
FishGridLayout.CellSize = UDim2.new(1, -10, 0, 25)
FishGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
FishGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FishGridLayout.Parent = FishGrid

-- Main Control Button
local ControlButton = Instance.new("TextButton")
ControlButton.Name = "ControlButton"
ControlButton.Size = UDim2.new(1, 0, 0, 40)
ControlButton.Position = UDim2.new(0, 0, 0, 340)
ControlButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ControlButton.BorderSizePixel = 0
ControlButton.Text = "▶ START FARMING"
ControlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ControlButton.TextSize = 16
ControlButton.Font = Enum.Font.GothamBold
ControlButton.Parent = ContentFrame

local ControlCorner = Instance.new("UICorner")
ControlCorner.CornerRadius = UDim.new(0, 6)
ControlCorner.Parent = ControlButton

-- Variables
local isFarming = false
local fishCaught = 0
local totalWeight = 0
local currentPower = 96
local selectedFishName = "Kepiting Biru"
local secretMode = true

-- Create ALL Fish Buttons
local function createFishButtons(fishList)
    -- Clear existing buttons
    for _, child in pairs(FishGrid:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Create new buttons
    for i, fishName in ipairs(fishList) do
        local fishButton = Instance.new("TextButton")
        fishButton.Name = fishName
        fishButton.LayoutOrder = i
        fishButton.Size = UDim2.new(1, 0, 0, 25)
        fishButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        -- Color coding based on fish type
        if fishName == selectedFishName then
            fishButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            fishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif fishName:find("Megalodon") or fishName:find("Lochness") or fishName:find("Ancient") then
            fishButton.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
            fishButton.TextColor3 = Color3.fromRGB(255, 220, 255)
        elseif fishName:find("Lava") or fishName:find("Secret") or fishName:find("Enchanted") then
            fishButton.BackgroundColor3 = Color3.fromRGB(255, 120, 80)
            fishButton.TextColor3 = Color3.fromRGB(255, 255, 220)
        elseif fishName:find("Bajak Laut") or fishName:find("Pirate") then
            fishButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
            fishButton.TextColor3 = Color3.fromRGB(255, 255, 220)
        else
            fishButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        end
        
        fishButton.BorderSizePixel = 0
        fishButton.Text = fishName
        fishButton.TextSize = 11
        fishButton.Font = Enum.Font.Gotham
        fishButton.TextTruncate = Enum.TextTruncate.AtEnd
        fishButton.Parent = FishGrid
        
        local fishButtonCorner = Instance.new("UICorner")
        fishButtonCorner.CornerRadius = UDim.new(0, 4)
        fishButtonCorner.Parent = fishButton
        
        fishButton.MouseButton1Click:Connect(function()
            selectedFishName = fishName
            SelectedFishLabel.Text = "Selected: " .. fishName
            
            -- Update all buttons
            for _, child in pairs(FishGrid:GetChildren()) do
                if child:IsA("TextButton") then
                    if child.Name == selectedFishName then
                        child.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
                        child.TextColor3 = Color3.fromRGB(255, 255, 255)
                    elseif child.Name:find("Megalodon") or child.Name:find("Lochness") or child.Name:find("Ancient") then
                        child.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
                        child.TextColor3 = Color3.fromRGB(255, 220, 255)
                    elseif child.Name:find("Lava") or child.Name:find("Secret") or child.Name:find("Enchanted") then
                        child.BackgroundColor3 = Color3.fromRGB(255, 120, 80)
                        child.TextColor3 = Color3.fromRGB(255, 255, 220)
                    elseif child.Name:find("Bajak Laut") or child.Name:find("Pirate") then
                        child.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
                        child.TextColor3 = Color3.fromRGB(255, 255, 220)
                    else
                        child.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                        child.TextColor3 = Color3.fromRGB(220, 220, 220)
                    end
                end
            end
        end)
    end
    
    FishGrid.CanvasSize = UDim2.new(0, 0, 0, FishGridLayout.AbsoluteContentSize.Y + 10)
end

-- Initial create all fish buttons
createFishButtons(AllFishList)

-- Search Functionality
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = string.lower(SearchBox.Text)
    
    if searchText == "" then
        createFishButtons(AllFishList)
        FishTitle.Text = "🐟 Select Fish (" .. #AllFishList .. " total)"
        return
    end
    
    -- Filter fish based on search
    local filteredFish = {}
    for _, fishName in ipairs(AllFishList) do
        if string.lower(fishName):find(searchText) then
            table.insert(filteredFish, fishName)
        end
    end
    
    createFishButtons(filteredFish)
    FishTitle.Text = "🐟 Select Fish (" .. #filteredFish .. " found)"
end)

-- Power Control
local powerLevels = {50, 75, 96, 100}
local powerIndex = 3

PowerButton.MouseButton1Click:Connect(function()
    powerIndex = powerIndex + 1
    if powerIndex > #powerLevels then
        powerIndex = 1
    end
    
    currentPower = powerLevels[powerIndex]
    PowerButton.Text = "PWR: " .. currentPower
end)

-- Secret Mode Toggle
SecretButton.MouseButton1Click:Connect(function()
    secretMode = not secretMode
    
    if secretMode then
        SecretButton.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
        SecretButton.Text = "🔒 SECRET MODE"
    else
        SecretButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        SecretButton.Text = "🔓 NORMAL MODE"
    end
end)

-- Minimize Function
local isMinimized = false

MinimizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        MainFrame.Size = UDim2.new(0, 420, 0, 35)
        ScrollFrame.Visible = false
        MinimizeButton.Text = "□"
        Title.Text = "AmbonXLonely🚯"
        isMinimized = true
    else
        MainFrame.Size = UDim2.new(0, 420, 0, 420)
        ScrollFrame.Visible = true
        MinimizeButton.Text = "_"
        Title.Text = "AmbonXLonely🚯"
        isMinimized = false
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Fishing Functions
function castFishingRod()
    if not isFarming then return end
    
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local castPosition = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 10
    local lookPosition = castPosition + Vector3.new(0, -10, 0)
    
    local args = {
        castPosition,
        lookPosition,
        RodInput.Text,
        currentPower
    }
    
    CastReplication:FireServer(unpack(args))
end

function cleanupCast()
    CleanupCast:FireServer()
end

function giveFish()
    if not isFarming then return end
    
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local hookPosition = humanoidRootPart.Position + Vector3.new(0, -5, 0)
    
    -- Secret Mode: Semua ikan rarity Secret dan weight 999
    local rarity = secretMode and "Secret" or "Rare"
    local weight = secretMode and 999 or math.random(10, 100) / 10
    
    local args = {
        {
            hookPosition = hookPosition,
            rarity = rarity,
            name = selectedFishName,
            weight = weight
        }
    }
    
    FishGiver:FireServer(unpack(args))
    
    -- Update stats
    fishCaught = fishCaught + 1
    totalWeight = totalWeight + weight
    
    StatusLabel.Text = "Status: FARMING"
    StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
    StatsLabel.Text = string.format("Fish: %d | Weight: %.0f", fishCaught, totalWeight)
end

-- Auto Farm Loop
spawn(function()
    while true do
        if isFarming then
            -- Cast fishing rod
            castFishingRod()
            wait(0.5)
            
            -- Simulate waiting for fish to bite
            local biteTime = math.random(1, 1.1)
            wait(biteTime)
            
            if isFarming then
                -- Give fish
                giveFish()
                
                -- Cleanup cast
                cleanupCast()
                
                -- Wait before next cast
                wait(1)
            end
        else
            wait(0.5)
        end
    end
end)

-- Main Control Button
ControlButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    
    if isFarming then
        ControlButton.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
        ControlButton.Text = "⏸ STOP FARMING"
        StatusLabel.Text = "Status: FARMING"
        StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
    else
        ControlButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ControlButton.Text = "▶ START FARMING"
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Keybind to toggle GUI (F9)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F9 then
        if isMinimized then
            MainFrame.Size = UDim2.new(0, 420, 0, 420)
            ScrollFrame.Visible = true
            MinimizeButton.Text = "_"
            Title.Text = "AmbonXLonely🚯"
            isMinimized = false
        else
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- Update ContentFrame size untuk scroll
ContentFrame.Size = UDim2.new(1, -20, 0, 390)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 390)

-- Initial update
StatsLabel.Text = string.format("Fish: %d | Weight: %.0f", fishCaught, totalWeight)

-- Auto-refresh grid size
FishGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FishGrid.CanvasSize = UDim2.new(0, 0, 0, FishGridLayout.AbsoluteContentSize.Y + 10)
end)

print("🎣 Auto Fish Farm GUI Loaded!")
print("📌 Press F9 to show/hide")
print("🎯 Total Fish: " .. #AllFishList)
print("🎯 Selected: " .. selectedFishName)