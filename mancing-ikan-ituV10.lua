-- Auto Fish Farm Script dengan Multi-Page GUI
-- Made for Roblox Fishing Game

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

-- Database lokasi ikan (HANYA IKAN YANG DIMINTA)
local FishLocations = {
    -- Ikan Original
    ["Tiger Muskellunge"] = {
        position = Vector3.new(744.3958129882812, 143.81532287597656, -714.9364624023438),
        castVector = Vector3.new(-0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = 10.8,
        rarity = "Common",
        minWait = 10,
        maxWait = 12
    },
    ["King Monster"] = {
        position = Vector3.new(2817, 148, -758),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Hammer Shark"] = {
        position = Vector3.new(-2007, 384, 2594),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Jellyfish core"] = {
        position = Vector3.new(-2007, 384, 2594),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Whale Shark"] = {
        position = Vector3.new(786, 134, -873),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Cype Darcopink"] = {
        position = Vector3.new(786, 134, -873),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    
    -- Ikan Baru (Semua Secret, Weight 650-770)
    ["Doplin Pink"] = {
        position = Vector3.new(),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Doplin Blue"] = {
        position = Vector3.new(),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Cype Darcoyellow"] = {
        position = Vector3.new(),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Joar Cusyu"] = {
        position = Vector3.new(),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["Nagasa Putra"] = {
        position = Vector3.new(),
        castVector = Vector3.new(0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["While Bloodmon"] = {
        position = Vector3.new(),
        castVector = Vector3.new(-0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    ["While BloodShack"] = {
        position = Vector3.new(),
        castVector = Vector3.new(-0, 5, 25),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 770),
        rarity = "Secret",
        minWait = 10,
        maxWait = 12
    },
    
    -- LEVIATHAN CORE (Special - Weight lebih tinggi)
    ["Leviathan Core"] = {
        position = Vector3.new(), -- Special position
        castVector = Vector3.new(0, 10, 30),
        rodName = "Darco Rods",
        power = 99,
        weight = math.random(650, 850), -- Weight lebih tinggi 650-850
        rarity = "Secret",
        minWait = 10,
        maxWait = 15, -- Waktu tunggu lebih lama untuk ikan special
        isSpecial = true
    }
}

-- Tabel untuk menyimpan history ikan yang sudah ditangkap
local FishHistory = {}
local TotalFishCaught = 0
local SessionStartTime = os.time()

-- ============================================
-- MINIMIZED ICON (Dragable Floating Icon)
-- ============================================
local MinimizedIcon = Instance.new("TextButton")
local IconLabel = Instance.new("TextLabel")

MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Parent = Player.PlayerGui
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
MinimizedIcon.BackgroundTransparency = 0.3
MinimizedIcon.BorderSizePixel = 0
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0.9, 0, 0.1, 0)
MinimizedIcon.ZIndex = 100
MinimizedIcon.Active = true
MinimizedIcon.Draggable = true
MinimizedIcon.Visible = false

IconLabel.Name = "IconLabel"
IconLabel.Parent = MinimizedIcon
IconLabel.BackgroundTransparency = 1
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.Font = Enum.Font.GothamBold
IconLabel.Text = "🎣"
IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IconLabel.TextSize = 20

-- Corner untuk rounded effect
local UICorner = Instance.new("UICorner")
UICorner.Parent = MinimizedIcon
UICorner.CornerRadius = UDim.new(0.3, 0)

-- ============================================
-- MAIN GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local TabContainer = Instance.new("Frame")
local FarmTabButton = Instance.new("TextButton")
local FishTabButton = Instance.new("TextButton")
local PagesContainer = Instance.new("Frame")

-- Inisialisasi ScreenGui
ScreenGui.Name = "AutoFishGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Ukuran optimal untuk 14 ikan)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 35)

-- Title
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🎣 Auto Fish Farm v4.1"
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.78, 0, 0.15, 0)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.88, 0, 0.15, 0)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

-- Tab Container
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.Size = UDim2.new(1, 0, 0, 40)

-- Farm Tab Button
FarmTabButton.Name = "FarmTabButton"
FarmTabButton.Parent = TabContainer
FarmTabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
FarmTabButton.BorderSizePixel = 0
FarmTabButton.Position = UDim2.new(0.05, 0, 0.15, 0)
FarmTabButton.Size = UDim2.new(0.45, 0, 0.7, 0)
FarmTabButton.Font = Enum.Font.GothamBold
FarmTabButton.Text = "🎯 FARM"
FarmTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmTabButton.TextSize = 14

-- Fish Tab Button
FishTabButton.Name = "FishTabButton"
FishTabButton.Parent = TabContainer
FishTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
FishTabButton.BorderSizePixel = 0
FishTabButton.Position = UDim2.new(0.52, 0, 0.15, 0)
FishTabButton.Size = UDim2.new(0.45, 0, 0.7, 0)
FishTabButton.Font = Enum.Font.GothamBold
FishTabButton.Text = "🐟 PICK FISH"
FishTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
FishTabButton.TextSize = 14

-- Pages Container
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
PagesContainer.BorderSizePixel = 0
PagesContainer.Position = UDim2.new(0, 0, 0, 75)
PagesContainer.Size = UDim2.new(1, 0, 1, -75)

-- ====================
-- PAGE 1: FARM PAGE
-- ====================
local FarmPage = Instance.new("Frame")
local FarmPageContent = Instance.new("Frame")

FarmPage.Name = "FarmPage"
FarmPage.Parent = PagesContainer
FarmPage.BackgroundTransparency = 1
FarmPage.Size = UDim2.new(1, 0, 1, 0)
FarmPage.Visible = true

FarmPageContent.Name = "FarmPageContent"
FarmPageContent.Parent = FarmPage
FarmPageContent.BackgroundTransparency = 1
FarmPageContent.Size = UDim2.new(1, 0, 1, 0)

-- Current Fish Info
local CurrentFishLabel = Instance.new("TextLabel")
local CurrentFishInfo = Instance.new("TextLabel")

CurrentFishLabel.Name = "CurrentFishLabel"
CurrentFishLabel.Parent = FarmPageContent
CurrentFishLabel.BackgroundTransparency = 1
CurrentFishLabel.Position = UDim2.new(0.1, 0, 0.03, 0)
CurrentFishLabel.Size = UDim2.new(0.8, 0, 0, 25)
CurrentFishLabel.Font = Enum.Font.GothamBold
CurrentFishLabel.Text = "🎯 CURRENT TARGET"
CurrentFishLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
CurrentFishLabel.TextSize = 16
CurrentFishLabel.TextXAlignment = Enum.TextXAlignment.Left

CurrentFishInfo.Name = "CurrentFishInfo"
CurrentFishInfo.Parent = FarmPageContent
CurrentFishInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CurrentFishInfo.BorderSizePixel = 0
CurrentFishInfo.Position = UDim2.new(0.1, 0, 0.12, 0)
CurrentFishInfo.Size = UDim2.new(0.8, 0, 0, 50)
CurrentFishInfo.Font = Enum.Font.Gotham
CurrentFishInfo.Text = "Tiger Muskellunge\nRarity: Common | Weight: 10.8"
CurrentFishInfo.TextColor3 = Color3.fromRGB(180, 180, 255)
CurrentFishInfo.TextSize = 14
CurrentFishInfo.TextWrapped = true

-- Change Fish Button
local ChangeFishButton = Instance.new("TextButton")
ChangeFishButton.Name = "ChangeFishButton"
ChangeFishButton.Parent = FarmPageContent
ChangeFishButton.BackgroundColor3 = Color3.fromRGB(70, 100, 180)
ChangeFishButton.BorderSizePixel = 0
ChangeFishButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ChangeFishButton.Size = UDim2.new(0.8, 0, 0, 30)
ChangeFishButton.Font = Enum.Font.Gotham
ChangeFishButton.Text = "🔄 CHANGE FISH"
ChangeFishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeFishButton.TextSize = 13

-- Toggle Button
local ToggleFarmButton = Instance.new("TextButton")
ToggleFarmButton.Name = "ToggleFarmButton"
ToggleFarmButton.Parent = FarmPageContent
ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
ToggleFarmButton.BorderSizePixel = 0
ToggleFarmButton.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleFarmButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleFarmButton.Font = Enum.Font.GothamBold
ToggleFarmButton.Text = "🎣 START FARMING"
ToggleFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFarmButton.TextSize = 14

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = FarmPageContent
StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
StatusLabel.BorderSizePixel = 0
StatusLabel.Position = UDim2.new(0.1, 0, 0.52, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 25)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 13

-- Stats Container
local StatsFrame = Instance.new("Frame")
local FishCountLabel = Instance.new("TextLabel")
local TimeLabel = Instance.new("TextLabel")
local EfficiencyLabel = Instance.new("TextLabel")

StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = FarmPageContent
StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.1, 0, 0.62, 0)
StatsFrame.Size = UDim2.new(0.8, 0, 0, 70)

FishCountLabel.Name = "FishCountLabel"
FishCountLabel.Parent = StatsFrame
FishCountLabel.BackgroundTransparency = 1
FishCountLabel.Position = UDim2.new(0, 10, 0, 5)
FishCountLabel.Size = UDim2.new(1, -20, 0, 20)
FishCountLabel.Font = Enum.Font.Gotham
FishCountLabel.Text = "🐟 Total Fish: 0"
FishCountLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
FishCountLabel.TextSize = 12
FishCountLabel.TextXAlignment = Enum.TextXAlignment.Left

TimeLabel.Name = "TimeLabel"
TimeLabel.Parent = StatsFrame
TimeLabel.BackgroundTransparency = 1
TimeLabel.Position = UDim2.new(0, 10, 0, 25)
TimeLabel.Size = UDim2.new(1, -20, 0, 20)
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.Text = "⏱️ Time: 00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
TimeLabel.TextSize = 12
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left

EfficiencyLabel.Name = "EfficiencyLabel"
EfficiencyLabel.Parent = StatsFrame
EfficiencyLabel.BackgroundTransparency = 1
EfficiencyLabel.Position = UDim2.new(0, 10, 0, 45)
EfficiencyLabel.Size = UDim2.new(1, -20, 0, 20)
EfficiencyLabel.Font = Enum.Font.Gotham
EfficiencyLabel.Text = "⚡ Efficiency: 0 fish/hour"
EfficiencyLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
EfficiencyLabel.TextSize = 12
EfficiencyLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ====================
-- PAGE 2: PICK FISH PAGE
-- ====================
local PickFishPage = Instance.new("Frame")
local PickFishPageContent = Instance.new("Frame")

PickFishPage.Name = "PickFishPage"
PickFishPage.Parent = PagesContainer
PickFishPage.BackgroundTransparency = 1
PickFishPage.Size = UDim2.new(1, 0, 1, 0)
PickFishPage.Visible = false

PickFishPageContent.Name = "PickFishPageContent"
PickFishPageContent.Parent = PickFishPage
PickFishPageContent.BackgroundTransparency = 1
PickFishPageContent.Size = UDim2.new(1, 0, 1, 0)

-- Title Pick Fish
local PickFishTitle = Instance.new("TextLabel")
PickFishTitle.Name = "PickFishTitle"
PickFishTitle.Parent = PickFishPageContent
PickFishTitle.BackgroundTransparency = 1
PickFishTitle.Position = UDim2.new(0.1, 0, 0.02, 0)
PickFishTitle.Size = UDim2.new(0.8, 0, 0, 25)
PickFishTitle.Font = Enum.Font.GothamBold
PickFishTitle.Text = "🐟 PICK YOUR FISH (" .. #FishLocations .. " FISH)"
PickFishTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
PickFishTitle.TextSize = 16

-- Search Bar
local SearchBar = Instance.new("TextBox")
SearchBar.Name = "SearchBar"
SearchBar.Parent = PickFishPageContent
SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SearchBar.BorderSizePixel = 0
SearchBar.Position = UDim2.new(0.1, 0, 0.1, 0)
SearchBar.Size = UDim2.new(0.8, 0, 0, 30)
SearchBar.Font = Enum.Font.Gotham
SearchBar.PlaceholderText = "🔍 Search fish..."
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.TextSize = 13
SearchBar.ClearTextOnFocus = false

-- Fish List Container
local FishListFrame = Instance.new("ScrollingFrame")
FishListFrame.Name = "FishListFrame"
FishListFrame.Parent = PickFishPageContent
FishListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
FishListFrame.BorderSizePixel = 0
FishListFrame.Position = UDim2.new(0.1, 0, 0.18, 0)
FishListFrame.Size = UDim2.new(0.8, 0, 0.70, 0)
FishListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
FishListFrame.ScrollBarThickness = 5

-- Selected Fish Info
local SelectedFishInfoFrame = Instance.new("Frame")
SelectedFishInfoFrame.Name = "SelectedFishInfoFrame"
SelectedFishInfoFrame.Parent = PickFishPageContent
SelectedFishInfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SelectedFishInfoFrame.BorderSizePixel = 0
SelectedFishInfoFrame.Position = UDim2.new(0.1, 0, 0.90, 0)
SelectedFishInfoFrame.Size = UDim2.new(0.8, 0, 0, 40)
SelectedFishInfoFrame.Visible = false

local SelectedFishName = Instance.new("TextLabel")
SelectedFishName.Name = "SelectedFishName"
SelectedFishName.Parent = SelectedFishInfoFrame
SelectedFishName.BackgroundTransparency = 1
SelectedFishName.Position = UDim2.new(0, 10, 0, 5)
SelectedFishName.Size = UDim2.new(1, -20, 0, 15)
SelectedFishName.Font = Enum.Font.GothamBold
SelectedFishName.Text = "Selected: None"
SelectedFishName.TextColor3 = Color3.fromRGB(255, 255, 200)
SelectedFishName.TextSize = 13
SelectedFishName.TextXAlignment = Enum.TextXAlignment.Left

local SelectedFishDetails = Instance.new("TextLabel")
SelectedFishDetails.Name = "SelectedFishDetails"
SelectedFishDetails.Parent = SelectedFishInfoFrame
SelectedFishDetails.BackgroundTransparency = 1
SelectedFishDetails.Position = UDim2.new(0, 10, 0, 20)
SelectedFishDetails.Size = UDim2.new(1, -20, 0, 15)
SelectedFishDetails.Font = Enum.Font.Gotham
SelectedFishDetails.Text = "Rarity: - | Weight: -"
SelectedFishDetails.TextColor3 = Color3.fromRGB(200, 200, 255)
SelectedFishDetails.TextSize = 11
SelectedFishDetails.TextXAlignment = Enum.TextXAlignment.Left

-- Variabel
local isFarming = false
local fishingInProgress = false
local waitingForFish = false
local fishCount = 0
local selectedFish = "Tiger Muskellunge"
local startTime = os.time()
local isMinimized = false
local allFishButtons = {}

-- Fungsi untuk minimize/maximize GUI
function toggleMinimize()
    if isMinimized then
        -- Restore GUI
        MainFrame.Visible = true
        MinimizedIcon.Visible = false
        isMinimized = false
    else
        -- Minimize to icon
        MainFrame.Visible = false
        MinimizedIcon.Visible = true
        isMinimized = true
    end
end

-- Fungsi untuk mengupdate semua stats
function updateAllStats()
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = elapsedTime % 60
    
    local timeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    local fishPerHour = 0
    
    if elapsedTime > 0 then
        fishPerHour = math.floor((fishCount / elapsedTime) * 3600)
    end
    
    -- Update Farm Page Stats
    FishCountLabel.Text = string.format("🐟 Total Fish: %d", fishCount)
    TimeLabel.Text = string.format("⏱️ Time: %s", timeString)
    EfficiencyLabel.Text = string.format("⚡ Efficiency: %d fish/hour", fishPerHour)
    
    -- Update icon jika minimized
    if isMinimized then
        IconLabel.Text = string.format("🎣\n%d", fishCount)
    end
end

-- Fungsi untuk mengupdate info ikan di Farm Page
function updateFishInfo()
    local fishData = FishLocations[selectedFish]
    if fishData then
        if selectedFish == "Tiger Muskellunge" then
            CurrentFishInfo.Text = selectedFish .. "\nRarity: Common | Weight: 10.8"
            CurrentFishInfo.TextColor3 = Color3.fromRGB(180, 180, 255)
        elseif selectedFish == "Leviathan Core" then
            CurrentFishInfo.Text = selectedFish .. " 🌟\nRarity: Secret | Weight: 650-850"
            CurrentFishInfo.TextColor3 = Color3.fromRGB(255, 50, 50) -- Merah special untuk Leviathan
        else
            CurrentFishInfo.Text = selectedFish .. "\nRarity: Secret | Weight: 650-770"
            CurrentFishInfo.TextColor3 = Color3.fromRGB(255, 100, 180)
        end
    end
end

-- Fungsi untuk filter fish list berdasarkan search
function filterFishList(searchText)
    searchText = string.lower(searchText)
    
    for fishName, button in pairs(allFishButtons) do
        if searchText == "" or string.find(string.lower(fishName), searchText) then
            button.Visible = true
        else
            button.Visible = false
        end
    end
    
    -- Update layout
    updateFishListLayout()
end

-- Fungsi untuk update layout fish list
function updateFishListLayout()
    local yPosition = 0
    local itemHeight = 50
    local spacing = 5
    
    for _, button in pairs(allFishButtons) do
        if button.Visible then
            button.Position = UDim2.new(0, 0, 0, yPosition)
            yPosition = yPosition + itemHeight + spacing
        end
    end
    
    -- Update canvas size
    FishListFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition)
end

-- Fungsi untuk membuat fish list di Pick Fish Page
function createFishList()
    local yPosition = 0
    local itemHeight = 50
    local spacing = 5
    
    for fishName, fishData in pairs(FishLocations) do
        local fishItem = Instance.new("TextButton")
        fishItem.Name = fishName .. "_Button"
        fishItem.Parent = FishListFrame
        
        -- Warna berdasarkan rarity dan jenis ikan
        if fishName == "Tiger Muskellunge" then
            fishItem.BackgroundColor3 = Color3.fromRGB(50, 50, 100) -- Biru untuk Common
        elseif fishName == "Leviathan Core" then
            fishItem.BackgroundColor3 = Color3.fromRGB(120, 40, 40) -- Merah gelap untuk Leviathan
        else
            -- Warna berbeda untuk ikan Secret berdasarkan nama
            if fishName:find("Pink") or fishName:find("pink") then
                fishItem.BackgroundColor3 = Color3.fromRGB(120, 60, 100) -- Pinkish
            elseif fishName:find("Blue") or fishName:find("blue") then
                fishItem.BackgroundColor3 = Color3.fromRGB(60, 80, 120) -- Bluish
            elseif fishName:find("Yellow") or fishName:find("yellow") then
                fishItem.BackgroundColor3 = Color3.fromRGB(120, 100, 60) -- Yellowish
            elseif fishName:find("Blood") then
                fishItem.BackgroundColor3 = Color3.fromRGB(120, 50, 50) -- Reddish
            else
                fishItem.BackgroundColor3 = Color3.fromRGB(80, 50, 90) -- Default purple
            end
        end
        
        fishItem.BorderSizePixel = 0
        fishItem.Position = UDim2.new(0, 0, 0, yPosition)
        fishItem.Size = UDim2.new(1, 0, 0, itemHeight)
        fishItem.Font = Enum.Font.Gotham
        fishItem.Text = ""
        fishItem.TextColor3 = Color3.fromRGB(255, 255, 255)
        fishItem.TextSize = 13
        fishItem.Visible = true
        
        -- Nama ikan
        local fishNameLabel = Instance.new("TextLabel")
        fishNameLabel.Name = "FishName"
        fishNameLabel.Parent = fishItem
        fishNameLabel.BackgroundTransparency = 1
        fishNameLabel.Position = UDim2.new(0, 10, 0, 5)
        fishNameLabel.Size = UDim2.new(0.7, 0, 0, 20)
        fishNameLabel.Font = Enum.Font.GothamBold
        if fishName == "Leviathan Core" then
            fishNameLabel.Text = fishName .. " 🌟"
        else
            fishNameLabel.Text = fishName
        end
        fishNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        fishNameLabel.TextSize = 14
        fishNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Rarity
        local fishRarityLabel = Instance.new("TextLabel")
        fishRarityLabel.Name = "FishRarity"
        fishRarityLabel.Parent = fishItem
        fishRarityLabel.BackgroundTransparency = 1
        fishRarityLabel.Position = UDim2.new(0, 10, 0, 25)
        fishRarityLabel.Size = UDim2.new(0.7, 0, 0, 15)
        fishRarityLabel.Font = Enum.Font.Gotham
        fishRarityLabel.Text = "Rarity: " .. fishData.rarity
        fishRarityLabel.TextColor3 = fishData.rarity == "Secret" and Color3.fromRGB(255, 150, 200) or Color3.fromRGB(150, 200, 255)
        fishRarityLabel.TextSize = 11
        fishRarityLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Weight (special untuk Leviathan Core)
        local fishWeightLabel = Instance.new("TextLabel")
        fishWeightLabel.Name = "FishWeight"
        fishWeightLabel.Parent = fishItem
        fishWeightLabel.BackgroundTransparency = 1
        fishWeightLabel.Position = UDim2.new(0.7, 0, 0, 15)
        fishWeightLabel.Size = UDim2.new(0.25, 0, 0, 20)
        fishWeightLabel.Font = Enum.Font.GothamBold
        if fishName == "Tiger Muskellunge" then
            fishWeightLabel.Text = "10.8"
        elseif fishName == "Leviathan Core" then
            fishWeightLabel.Text = "650-850"
            fishWeightLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Merah untuk weight tinggi
        else
            fishWeightLabel.Text = "650-770"
        end
        fishWeightLabel.TextColor3 = fishWeightLabel.TextColor3 or Color3.fromRGB(255, 255, 200)
        fishWeightLabel.TextSize = 14
        
        -- Select indicator
        local selectIndicator = Instance.new("TextLabel")
        selectIndicator.Name = "SelectIndicator"
        selectIndicator.Parent = fishItem
        selectIndicator.BackgroundTransparency = 1
        selectIndicator.Position = UDim2.new(0.85, 0, 0, 15)
        selectIndicator.Size = UDim2.new(0.15, 0, 0, 20)
        selectIndicator.Font = Enum.Font.GothamBold
        selectIndicator.Text = fishName == selectedFish and "✓" or ""
        selectIndicator.TextColor3 = Color3.fromRGB(0, 255, 0)
        selectIndicator.TextSize = 16
        
        -- Click event untuk memilih ikan
        fishItem.MouseButton1Click:Connect(function()
            selectedFish = fishName
            updateFishInfo()
            
            -- Update semua indikator
            for _, item in pairs(FishListFrame:GetChildren()) do
                if item:IsA("TextButton") then
                    local indicator = item:FindFirstChild("SelectIndicator")
                    if indicator then
                        indicator.Text = item.Name:gsub("_Button", "") == selectedFish and "✓" or ""
                    end
                end
            end
            
            -- Tampilkan info ikan yang dipilih
            SelectedFishInfoFrame.Visible = true
            SelectedFishName.Text = "Selected: " .. selectedFish
            if selectedFish == "Tiger Muskellunge" then
                SelectedFishDetails.Text = "Rarity: Common | Weight: 10.8"
                SelectedFishDetails.TextColor3 = Color3.fromRGB(180, 180, 255)
            elseif selectedFish == "Leviathan Core" then
                SelectedFishDetails.Text = "Rarity: Secret | Weight: 650-850"
                SelectedFishDetails.TextColor3 = Color3.fromRGB(255, 100, 100)
            else
                SelectedFishDetails.Text = "Rarity: Secret | Weight: 650-770"
                SelectedFishDetails.TextColor3 = Color3.fromRGB(255, 100, 180)
            end
            
            -- Kembali ke Farm Page otomatis setelah 1 detik
            spawn(function()
                wait(1)
                switchPage("farm")
                SearchBar.Text = "" -- Clear search
                filterFishList("")
            end)
        end)
        
        -- Simpan reference
        allFishButtons[fishName] = fishItem
        
        yPosition = yPosition + itemHeight + spacing
    end
    
    -- Update canvas size
    updateFishListLayout()
end

-- Fungsi untuk switch page
function switchPage(pageName)
    if isMinimized then
        toggleMinimize() -- Auto restore jika minimized
    end
    
    if pageName == "farm" then
        FarmPage.Visible = true
        PickFishPage.Visible = false
        FarmTabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
        FarmTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FishTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        FishTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        Title.Text = "🎣 Auto Fish Farm v4.1 - FARMING"
        updateFishInfo()
    elseif pageName == "pickfish" then
        FarmPage.Visible = false
        PickFishPage.Visible = true
        FarmTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        FarmTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        FishTabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
        FishTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Text = "🎣 Auto Fish Farm v4.1 - PICK FISH"
        
        -- Reset selected info
        SelectedFishInfoFrame.Visible = false
        SearchBar.Text = ""
        filterFishList("")
        PickFishTitle.Text = "🐟 PICK YOUR FISH (" .. #FishLocations .. " FISH)"
    end
end

-- Fungsi untuk memanggil event memancing
function startFishing()
    if fishingInProgress then return end
    
    -- Update weight random untuk ikan
    local fishData = FishLocations[selectedFish]
    if selectedFish == "Tiger Muskellunge" then
        fishData.weight = 10.8
    elseif selectedFish == "Leviathan Core" then
        fishData.weight = math.random(650, 850) -- Special weight untuk Leviathan
    else
        fishData.weight = math.random(650, 770)
    end
    
    updateFishInfo()
    
    if not fishData then
        StatusLabel.Text = "Status: Error - Fish data not found"
        return
    end
    
    fishingInProgress = true
    waitingForFish = false
    
    -- Update status
    StatusLabel.Text = "Status: Casting for " .. selectedFish
    
    -- Step 1: Status Lempar Umpan 2
    game:GetService("ReplicatedStorage"):WaitForChild("StatusLemparUmpan2"):FireServer()
    wait(1.5)
    
    -- Step 2: Status Lempar Umpan 1
    game:GetService("ReplicatedStorage"):WaitForChild("StatusLemparUmpan1"):FireServer()
    wait(1.25)
    
    -- Step 3: Cast Replication
    local args = {
        fishData.position,
        fishData.castVector,
        fishData.rodName,
        fishData.power
    }
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CastReplication"):FireServer(unpack(args))
    wait(1)
    
    -- Step 4: Status Rod
    local args = {fishData.weight}
    game:GetService("ReplicatedStorage"):WaitForChild("statusrod"):FireServer(unpack(args))
    wait(1)
    
    -- Step 5: Request Minigame
    game:GetService("ReplicatedStorage"):WaitForChild("RequestMinigameEvent"):FireServer()
    wait(1)
    
    -- Step 6: Status Lempar Umpan 2 lagi
    game:GetService("ReplicatedStorage"):WaitForChild("StatusLemparUmpan2"):FireServer()
    wait(1.5)
    
    -- Menunggu ikan (waktu lebih lama untuk Leviathan)
    waitingForFish = true
    local waitTime = math.random(fishData.minWait, fishData.maxWait)
    
    for i = 1, waitTime do
        if not isFarming then break end
        StatusLabel.Text = string.format("Status: Waiting... (%d/%d)", i, waitTime)
        wait(1)
    end
    
    if isFarming then
        catchFish(fishData)
    end
end

function catchFish(fishData)
    if not waitingForFish then return end
    
    StatusLabel.Text = "Status: Catching " .. selectedFish
    
    -- Step 7: Data events
    game:GetService("ReplicatedStorage"):WaitForChild("data"):FireServer()
    wait(0.5)
    
    game:GetService("ReplicatedStorage"):WaitForChild("ShowRarityExclamations"):FireServer()
    wait(0.5)
    
    game:GetService("ReplicatedStorage"):WaitForChild("playersdata"):FireServer()
    wait(0.5)
    
    -- Step 8: Data rod
    local args = {"rod"}
    game:GetService("ReplicatedStorage"):WaitForChild("datarod"):FireServer(unpack(args))
    wait(0.5)
    
    -- Step 9: Cleanup
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CleanupCast"):FireServer()
    wait(0.5)
    
    game:GetService("ReplicatedStorage"):WaitForChild("ShowRarityExclamations"):FireServer()
    wait(0.5)
    
    -- Step 10: Fishing success
    game:GetService("ReplicatedStorage"):WaitForChild("FishingCatchSuccess"):FireServer()
    wait(0.5)
    
    -- Step 11: Broadcast fish animation
    local args = {
        selectedFish,
        CFrame.new(746.5498046875, 140.02049255371094, -720.7835693359375, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("BroadcastFishAnimation"):FireServer(unpack(args))
    wait(0.5)
    
    -- Step 12: Give fish
    local args = {
        {
            hookPosition = fishData.position - Vector3.new(0, 15, 10),
            name = selectedFish,
            rarity = fishData.rarity,
            weight = fishData.weight
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("KasihIkanItu"):FireServer(unpack(args))
    
    -- Update counts
    fishCount = fishCount + 1
    updateAllStats()
    
    -- Tampilkan status special untuk Leviathan
    if selectedFish == "Leviathan Core" then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        StatusLabel.Text = "🔥 LEVIATHAN CORE CAUGHT! 🔥"
    elseif fishData.rarity == "Secret" then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        StatusLabel.Text = "✨ Secret Fish Caught! ✨"
    else
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusLabel.Text = "Status: Fish caught! Next..."
    end
    
    -- Reset status
    fishingInProgress = false
    waitingForFish = false
    
    if isFarming then
        wait(2)
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        startFishing()
    end
end

-- ====================
-- EVENT HANDLERS
-- ====================

-- Inisialisasi
createFishList()
updateFishInfo()

-- Minimize button
MinimizeButton.MouseButton1Click:Connect(function()
    toggleMinimize()
end)

-- Minimized icon click
MinimizedIcon.MouseButton1Click:Connect(function()
    toggleMinimize()
end)

-- Tab switching
FarmTabButton.MouseButton1Click:Connect(function()
    switchPage("farm")
end)

FishTabButton.MouseButton1Click:Connect(function()
    switchPage("pickfish")
end)

-- Change Fish button
ChangeFishButton.MouseButton1Click:Connect(function()
    switchPage("pickfish")
end)

-- Search bar events
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    filterFishList(SearchBar.Text)
end)

-- Toggle farming
ToggleFarmButton.MouseButton1Click:Connect(function()
    if isFarming then
        -- Stop farming
        isFarming = false
        fishingInProgress = false
        waitingForFish = false
        ToggleFarmButton.Text = "🎣 START FARMING"
        ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
        StatusLabel.Text = "Status: Stopped"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        -- Start farming
        isFarming = true
        fishCount = 0
        startTime = os.time()
        ToggleFarmButton.Text = "⛔ STOP FARMING"
        ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        
        local fishData = FishLocations[selectedFish]
        if selectedFish == "Leviathan Core" then
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            StatusLabel.Text = "🔥 FARMING LEVIATHAN CORE! 🔥"
        elseif fishData.rarity == "Secret" then
            StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
            StatusLabel.Text = "✨ Farming Secret Fish: " .. selectedFish .. " ✨"
        else
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            StatusLabel.Text = "Status: Starting farm for " .. selectedFish
        end
        
        -- Mulai proses memancing
        spawn(function()
            wait(1)
            if isFarming then
                startFishing()
            end
        end)
    end
    updateAllStats()
end)

-- Close GUI
CloseButton.MouseButton1Click:Connect(function()
    isFarming = false
    ScreenGui:Destroy()
    MinimizedIcon:Destroy()
end)

-- Hotkeys
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F9 then
            if isMinimized then
                toggleMinimize()
            else
                MainFrame.Visible = not MainFrame.Visible
            end
        elseif input.KeyCode == Enum.KeyCode.F8 then
            ToggleFarmButton:MouseButton1Click()
        elseif input.KeyCode == Enum.KeyCode.F7 then
            -- Switch between pages
            if FarmPage.Visible then
                switchPage("pickfish")
            else
                switchPage("farm")
            end
        elseif input.KeyCode == Enum.KeyCode.F6 then
            -- Toggle minimize
            toggleMinimize()
        end
    end
end)

-- Notifikasi
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎣 Auto Fish Farm v4.1 Loaded!",
    Text = "Total Fish: " .. #FishLocations .. " | F6: Minimize | F7: Switch | F8: Start/Stop | F9: Hide/Show",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

print("==========================================")
print("Auto Fish Farm v4.1 - Clean Version")
print("==========================================")
print("Total Ikan: " .. #FishLocations)
print("Common: 1 (Tiger Muskellunge)")
print("Secret: " .. (#FishLocations - 1) .. " ikan")
print("==========================================")
print("DAFTAR IKAN:")
print("1. Tiger Muskellunge (Common, 10.8)")
print("2. King Monster (Secret, 650-770)")
print("3. Hammer Shark (Secret, 650-770)")
print("4. Jellyfish core (Secret, 650-770)")
print("5. Whale Shark (Secret, 650-770)")
print("6. Cype Darcopink (Secret, 650-770)")
print("7. Doplin Pink (Secret, 650-770)")
print("8. Doplin Blue (Secret, 650-770)")
print("9. Cype Darcoyellow (Secret, 650-770)")
print("10. Joar Cusyu (Secret, 650-770)")
print("11. Nagasa Putra (Secret, 650-770)")
print("12. While Bloodmon (Secret, 650-770)")
print("13. While BloodShack (Secret, 650-770)")
print("14. Leviathan Core ⭐ (Secret, 650-850)")
print("==========================================")
print("IKAN TAMBAHAN LAINNYA TELAH DIHAPUS!")
print("==========================================")