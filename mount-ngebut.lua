-- GUI Fishing Auto Farm dengan Pagination System
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishingFarmGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner untuk smooth edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Judul
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "🎣 Fishing Auto Farm v2.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Tombol close
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -40, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 15, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Text = "Status: OFF"
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Frame untuk dropdown ikan dengan pagination
local FishSelectFrame = Instance.new("Frame")
FishSelectFrame.Name = "FishSelectFrame"
FishSelectFrame.Size = UDim2.new(1, -30, 0, 140)
FishSelectFrame.Position = UDim2.new(0, 15, 0, 80)
FishSelectFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FishSelectFrame.Parent = MainFrame

local FishSelectCorner = Instance.new("UICorner")
FishSelectCorner.CornerRadius = UDim.new(0, 6)
FishSelectCorner.Parent = FishSelectFrame

local FishLabel = Instance.new("TextLabel")
FishLabel.Name = "FishLabel"
FishLabel.Size = UDim2.new(1, 0, 0, 25)
FishLabel.Position = UDim2.new(0, 0, 0, 0)
FishLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FishLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FishLabel.Text = " Pilih Ikan"
FishLabel.Font = Enum.Font.GothamBold
FishLabel.TextSize = 14
FishLabel.TextXAlignment = Enum.TextXAlignment.Left
FishLabel.Parent = FishSelectFrame

local FishLabelCorner = Instance.new("UICorner")
FishLabelCorner.CornerRadius = UDim.new(0, 6)
FishLabelCorner.Parent = FishLabel

-- Scrolling frame untuk daftar ikan dengan pagination
local FishScrollFrame = Instance.new("ScrollingFrame")
FishScrollFrame.Name = "FishScrollFrame"
FishScrollFrame.Size = UDim2.new(1, -10, 0, 85)
FishScrollFrame.Position = UDim2.new(0, 5, 0, 30)
FishScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FishScrollFrame.BorderSizePixel = 0
FishScrollFrame.ScrollBarThickness = 6
FishScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
FishScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
FishScrollFrame.Parent = FishSelectFrame

local FishListLayout = Instance.new("UIListLayout")
FishListLayout.Padding = UDim.new(0, 2)
FishListLayout.SortOrder = Enum.SortOrder.Name
FishListLayout.Parent = FishScrollFrame

-- Pagination controls
local PaginationFrame = Instance.new("Frame")
PaginationFrame.Name = "PaginationFrame"
PaginationFrame.Size = UDim2.new(1, 0, 0, 25)
PaginationFrame.Position = UDim2.new(0, 0, 1, -25)
PaginationFrame.BackgroundTransparency = 1
PaginationFrame.Parent = FishSelectFrame

local PrevPageButton = Instance.new("TextButton")
PrevPageButton.Name = "PrevPageButton"
PrevPageButton.Size = UDim2.new(0, 60, 1, 0)
PrevPageButton.Position = UDim2.new(0, 5, 0, 0)
PrevPageButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PrevPageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PrevPageButton.Text = "◀ Prev"
PrevPageButton.Font = Enum.Font.Gotham
PrevPageButton.TextSize = 12
PrevPageButton.Visible = false
PrevPageButton.Parent = PaginationFrame

local PrevCorner = Instance.new("UICorner")
PrevCorner.CornerRadius = UDim.new(0, 4)
PrevCorner.Parent = PrevPageButton

local NextPageButton = Instance.new("TextButton")
NextPageButton.Name = "NextPageButton"
NextPageButton.Size = UDim2.new(0, 60, 1, 0)
NextPageButton.Position = UDim2.new(1, -65, 0, 0)
NextPageButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NextPageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NextPageButton.Text = "Next ▶"
NextPageButton.Font = Enum.Font.Gotham
NextPageButton.TextSize = 12
NextPageButton.Visible = false
NextPageButton.Parent = PaginationFrame

local NextCorner = Instance.new("UICorner")
NextCorner.CornerRadius = UDim.new(0, 4)
NextCorner.Parent = NextPageButton

local PageInfo = Instance.new("TextLabel")
PageInfo.Name = "PageInfo"
PageInfo.Size = UDim2.new(0, 100, 1, 0)
PageInfo.Position = UDim2.new(0.5, -50, 0, 0)
PageInfo.BackgroundTransparency = 1
PageInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
PageInfo.Text = "Page 1/1"
PageInfo.Font = Enum.Font.Gotham
PageInfo.TextSize = 12
PageInfo.Parent = PaginationFrame

-- Selected fish display
local SelectedFishFrame = Instance.new("Frame")
SelectedFishFrame.Name = "SelectedFishFrame"
SelectedFishFrame.Size = UDim2.new(1, -10, 0, 25)
SelectedFishFrame.Position = UDim2.new(0, 5, 0, 120)
SelectedFishFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SelectedFishFrame.Parent = FishSelectFrame

local SelectedCorner = Instance.new("UICorner")
SelectedCorner.CornerRadius = UDim.new(0, 4)
SelectedCorner.Parent = SelectedFishFrame

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Name = "SelectedLabel"
SelectedLabel.Size = UDim2.new(1, 0, 1, 0)
SelectedLabel.Position = UDim2.new(0, 0, 0, 0)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
SelectedLabel.Text = "Belum ada ikan terpilih"
SelectedLabel.Font = Enum.Font.GothamMedium
SelectedLabel.TextSize = 12
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Center
SelectedLabel.Parent = SelectedFishFrame

-- Toggle Auto Farm
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 140, 0, 45)
ToggleButton.Position = UDim2.new(0.5, -70, 0, 230)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "▶ START EWE"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Config Frame
local ConfigFrame = Instance.new("Frame")
ConfigFrame.Name = "ConfigFrame"
ConfigFrame.Size = UDim2.new(1, -30, 0, 40)
ConfigFrame.Position = UDim2.new(0, 15, 1, -50)
ConfigFrame.BackgroundTransparency = 1
ConfigFrame.Parent = MainFrame

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Name = "DelayLabel"
DelayLabel.Size = UDim2.new(0, 100, 1, 0)
DelayLabel.Position = UDim2.new(0, 0, 0, 0)
DelayLabel.BackgroundTransparency = 1
DelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayLabel.Text = "Delay (detik):"
DelayLabel.Font = Enum.Font.GothamMedium
DelayLabel.TextSize = 14
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = ConfigFrame

local DelayBox = Instance.new("TextBox")
DelayBox.Name = "DelayBox"
DelayBox.Size = UDim2.new(0, 80, 0, 30)
DelayBox.Position = UDim2.new(0, 110, 0, 5)
DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Text = "0"
DelayBox.Font = Enum.Font.Gotham
DelayBox.TextSize = 14
DelayBox.PlaceholderText = "0"
DelayBox.Parent = ConfigFrame

local DelayCorner = Instance.new("UICorner")
DelayCorner.CornerRadius = UDim.new(0, 6)
DelayCorner.Parent = DelayBox

-- Info penggunaan
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Size = UDim2.new(1, -20, 0, 20)
InfoLabel.Position = UDim2.new(0, 15, 0, 280)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.Text = "F6: Toggle | F7: Hide/Show | F8: Random | F9: Auto All"
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 11
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = MainFrame

-- Sistem Auto Farm
local isFarming = false
local selectedFish = nil
local FishingSystem = game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem")
local FishGiver = FishingSystem:WaitForChild("FishGiver")

-- Daftar ikan dari aset
local fishAssets = {
    "Aglet",
    "Amberjack",
    "Ancient Relic Crocodile",
    "Ancient Whale",
    "ArapaimaFish",
    "Arwana",
    "Barracuda Fish",
    "Bicolor Blenny",
    "Big Louhan",
    "BlackNemo",
    "Blackcap Basslet",
    "Blue Fish",
    "Bluen",
    "Blueskin",
    "Boar Fish",
    "Bone Fish",
    "Boxfish",
    "Buaya Hutan",
    "Charcoal",
    "Chines Blue Fish",
    "Chines Fish",
    "Chines Green Fish",
    "Cleo Fish",
    "Cobia",
    "Cod",
    "Crimsom Ray",
    "Dead Scary Clownfish",
    "Dead Spooky Koi Fish",
    "Deep Fish",
    "Domber",
    "El Grand Black Maja",
    "El Grand Gold Maja",
    "El Grand Green Maja",
    "El Grand Pink Maja",
    "El Grand Purple Maja",
    "El Grand Red Maja",
    "El Grand White Maja",
    "El Grand Yellow Maja",
    "El Maja",
    "Fangtooth",
    "Fish Black",
    "Fish Lake",
    "Fish Tipis",
    "Fish benrtol",
    "Fish gead",
    "Freshwater Piranha",
    "Genetik Fish",
    "Geo Fish",
    "Ghost Fish",
    "Ghost Ray",
    "GoldenTrout",
    "Goldfish",
    "Green Fish",
    "Grouper",
    "Hermit Crab",
    "Jack",
    "Jellyfish",
    "King Crab",
    "KingJally Strong",
    "Kraken",
    "Kumis",
    "Light Dolphin",
    "Lion Fish",
    "Longbill Spearfish",
    "Louhan",
    "Loving Shark",
    "Luminous Fish",
    "Mas",
    "Megalodon",
    "Monster Shark",
    "Morning Star",
    "Mujaer",
    "Naga",
    "Nemo",
    "Nila Fish",
    "Octopus",
    "Orange",
    "Pink Dolphin",
    "Plasma Shark",
    "Pompano",
    "Puffy Blowhog",
    "Pumpkin Carved Shark",
    "Queen Crab",
    "Red Arwana",
    "Red Snapper",
    "Reddy",
    "Robin",
    "Rock Fish",
    "Rooster Fish",
    "Roster Fish",
    "Sapu Sapu Goib",
    "Shark",
    "Shark Bone",
    "Sotong",
    "Totol",
    "Udang",
    "Ular kadut",
    "Whale",
    "Wraithfin Abyssal",
    "Yellow Fish",
    "Zombie Shark",
    "purple Kraken"
}

-- Pagination variables
local currentPage = 1
local itemsPerPage = 8
local totalPages = math.ceil(#fishAssets / itemsPerPage)

-- Fungsi untuk mengupdate pagination
local function updatePagination()
    PageInfo.Text = "Page " .. currentPage .. "/" .. totalPages
    PrevPageButton.Visible = currentPage > 1
    NextPageButton.Visible = currentPage < totalPages
end

-- Fungsi untuk menampilkan ikan di halaman tertentu
local function displayFishPage(page)
    -- Clear existing fish buttons
    for _, child in ipairs(FishScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Calculate start and end index
    local startIndex = (page - 1) * itemsPerPage + 1
    local endIndex = math.min(page * itemsPerPage, #fishAssets)
    
    -- Create fish buttons for current page
    for i = startIndex, endIndex do
        local fishName = fishAssets[i]
        
        local FishOption = Instance.new("TextButton")
        FishOption.Name = fishName
        FishOption.Size = UDim2.new(1, -10, 0, 22)
        FishOption.Position = UDim2.new(0, 5, 0, (i - startIndex) * 24)
        FishOption.BackgroundColor3 = selectedFish == fishName and Color3.fromRGB(80, 120, 200) or Color3.fromRGB(60, 60, 60)
        FishOption.TextColor3 = Color3.fromRGB(255, 255, 255)
        FishOption.Text = fishName
        FishOption.Font = Enum.Font.Gotham
        FishOption.TextSize = 12
        FishOption.TextXAlignment = Enum.TextXAlignment.Left
        FishOption.Parent = FishScrollFrame
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 4)
        OptionCorner.Parent = FishOption
        
        FishOption.MouseButton1Click:Connect(function()
            selectedFish = fishName
            SelectedLabel.Text = "Terpilih: " .. fishName
            
            -- Update all button colors
            for _, btn in ipairs(FishScrollFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Name == fishName and Color3.fromRGB(80, 120, 200) or Color3.fromRGB(60, 60, 60)
                end
            end
        end)
        
        FishOption.MouseEnter:Connect(function()
            if selectedFish ~= fishName then
                FishOption.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end
        end)
        
        FishOption.MouseLeave:Connect(function()
            if selectedFish ~= fishName then
                FishOption.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end)
    end
    
    -- Update canvas size
    local numItems = endIndex - startIndex + 1
    FishScrollFrame.CanvasSize = UDim2.new(0, 0, 0, numItems * 24)
    
    -- Update pagination controls
    updatePagination()
end

-- Pagination button events
PrevPageButton.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        currentPage = currentPage - 1
        displayFishPage(currentPage)
    end
end)

NextPageButton.MouseButton1Click:Connect(function()
    if currentPage < totalPages then
        currentPage = currentPage + 1
        displayFishPage(currentPage)
    end
end)

-- Initialize with first page
displayFishPage(1)

-- Fungsi untuk mendapatkan data ikan
local function getFishData(fishName)
    local defaultPosition = vector.create(2470.336669921875, 110.60306549072266, -5894.072265625)
    
    local rarity = "Secret"
    local weight = math.random(998, 999)
    
    if fishName:find("Dead") or fishName:find("Spooky") or fishName:find("Ghost") then
        rarity = "Uncommon"
    elseif fishName:find("Golden") or fishName:find("Grand") or fishName:find("King") or fishName:find("Queen") then
        rarity = "Secret"
        weight = math.random(899, 999)
    elseif fishName:find("Megalodon") or fishName:find("Kraken") or fishName:find("Ancient") or fishName:find("Whale") then
        rarity = "Secret"
        weight = math.random(899, 999)
    elseif fishName:find("Shark") then
        rarity = "Secret"
        weight = math.random(899, 999)
    end
    
    return {
        hookPosition = defaultPosition,
        name = fishName,
        rarity = rarity,
        weight = weight
    }
end

-- Auto farm semua ikan secara bergantian
local autoAllMode = false
local currentFishIndex = 1

local function sendFishData(fishName)
    local fishData = getFishData(fishName)
    local args = {fishData}
    FishGiver:FireServer(unpack(args))
    return true
end

local function startFarming()
    if not selectedFish and not autoAllMode then
        SelectedLabel.Text = "PILIH IKAN DULU!"
        SelectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(0.5)
        SelectedLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
        return
    end
    
    isFarming = true
    ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    ToggleButton.Text = "⏸ STOP EWE"
    StatusLabel.Text = autoAllMode and "Status: FARMING ALL" or "Status: FARMING " .. selectedFish
    
    spawn(function()
        local delayTime = tonumber(DelayBox.Text) or 0
        
        while isFarming do
            if autoAllMode then
                -- Farm semua ikan secara bergantian
                local currentFish = fishAssets[currentFishIndex]
                sendFishData(currentFish)
                
                SelectedLabel.Text = "Auto All: " .. currentFish
                currentFishIndex = currentFishIndex + 1
                if currentFishIndex > #fishAssets then
                    currentFishIndex = 1
                end
            else
                -- Farm ikan terpilih
                sendFishData(selectedFish)
            end
            
            if delayTime > 0 then
                wait(delayTime)
            else
                wait(0.01)
            end
        end
    end)
end

local function stopFarming()
    isFarming = false
    autoAllMode = false
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    ToggleButton.Text = "▶ START EWE"
    StatusLabel.Text = "Status: OFF"
    
    if selectedFish then
        SelectedLabel.Text = "Terpilih: " .. selectedFish
    else
        SelectedLabel.Text = "Belum ada ikan terpilih"
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    if not isFarming then
        startFarming()
    else
        stopFarming()
    end
end)

-- Hotkeys
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F6 then
            if not isFarming then
                startFarming()
            else
                stopFarming()
            end
        elseif input.KeyCode == Enum.KeyCode.F7 then
            MainFrame.Visible = not MainFrame.Visible
        elseif input.KeyCode == Enum.KeyCode.F8 then
            local randomFish = fishAssets[math.random(1, #fishAssets)]
            selectedFish = randomFish
            SelectedLabel.Text = "Terpilih: " .. randomFish
            
            -- Update button colors
            for _, btn in ipairs(FishScrollFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Name == randomFish and Color3.fromRGB(80, 120, 200) or Color3.fromRGB(60, 60, 60)
                end
            end
        elseif input.KeyCode == Enum.KeyCode.F9 then
            if not isFarming then
                autoAllMode = true
                currentFishIndex = 1
                startFarming()
            else
                stopFarming()
            end
        end
    end
end)

-- Search functionality (opsional)
local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(0, 120, 0, 25)
SearchBox.Position = UDim2.new(1, -125, 0, 5)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Text = ""
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.PlaceholderText = "Cari ikan..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Parent = FishSelectFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchBox

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = string.lower(SearchBox.Text)
    
    if searchText == "" then
        displayFishPage(currentPage)
        return
    end
    
    -- Clear and show search results
    for _, child in ipairs(FishScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local filteredFish = {}
    for _, fishName in ipairs(fishAssets) do
        if string.find(string.lower(fishName), searchText) then
            table.insert(filteredFish, fishName)
        end
    end
    
    for i, fishName in ipairs(filteredFish) do
        local FishOption = Instance.new("TextButton")
        FishOption.Name = fishName
        FishOption.Size = UDim2.new(1, -10, 0, 22)
        FishOption.Position = UDim2.new(0, 5, 0, (i - 1) * 24)
        FishOption.BackgroundColor3 = selectedFish == fishName and Color3.fromRGB(80, 120, 200) or Color3.fromRGB(60, 60, 60)
        FishOption.TextColor3 = Color3.fromRGB(255, 255, 255)
        FishOption.Text = fishName
        FishOption.Font = Enum.Font.Gotham
        FishOption.TextSize = 12
        FishOption.TextXAlignment = Enum.TextXAlignment.Left
        FishOption.Parent = FishScrollFrame
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 4)
        OptionCorner.Parent = FishOption
        
        FishOption.MouseButton1Click:Connect(function()
            selectedFish = fishName
            SelectedLabel.Text = "Terpilih: " .. fishName
            
            for _, btn in ipairs(FishScrollFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Name == fishName and Color3.fromRGB(80, 120, 200) or Color3.fromRGB(60, 60, 60)
                end
            end
        end)
    end
    
    FishScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #filteredFish * 24)
    PrevPageButton.Visible = false
    NextPageButton.Visible = false
    PageInfo.Text = "Hasil: " .. #filteredFish .. " ikan"
end)

-- Notifikasi
local function notify(message)
    print("[Fishing Farm]: " .. message)
end

-- Initialize
notify("Fishing Auto Farm GUI Loaded!")
notify("Total ikan: " .. #fishAssets .. " | Item per halaman: " .. itemsPerPage)
notify("Hotkeys: F6=Toggle, F7=Hide/Show, F8=Random, F9=Auto All")