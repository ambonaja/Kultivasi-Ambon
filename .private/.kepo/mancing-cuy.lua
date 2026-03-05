-- AmbonHub🚯 - Rayfield UI Latest Version
-- Super Keren dengan Rayfield Library Terbaru + Teleport + Complete Fish Database (All Secret)
-- FIXED: Semua koordinat menggunakan HumanoidRootPart + Fixed dropdown TABLE error + Fixed readonly table error

-- Load Rayfield Library dengan link terbaru
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Custom Theme untuk AmbonHub
local Theme = {
    Background = Color3.fromRGB(20, 20, 30),
    Glow = Color3.fromRGB(255, 100, 100),
    Accent = Color3.fromRGB(255, 150, 100),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200)
}

local Window = Rayfield:CreateWindow({
    Name = "AmbonHub🚯",
    LoadingTitle = "AmbonHub🚯 Loading...",
    LoadingSubtitle = "by Ambon Team",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonHubConfig",
        FileName = "AmbonHubData"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "AmbonHub🚯 Key System",
        Subtitle = "Enter Key",
        Note = "Join Discord for key",
        FileName = "AmbonHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"ambonhub123", "superkeren"}
    }
})

-- Create Tabs dengan icon yang keren
local Tabs = {
    Main = Window:CreateTab("🏠 Main", 4483362458),
    Teleport = Window:CreateTab("🌍 Teleport", 4483362458),
    Fishing = Window:CreateTab("🎣 Fishing", 4483362458),
    FishDB = Window:CreateTab("🐟 Fish Database", 4483362458),
    Settings = Window:CreateTab("⚙️ Settings", 4483362458),
    Stats = Window:CreateTab("📊 Stats", 4483362458),
    Credit = Window:CreateTab("❤️ Credit", 4483362458),
    Debug = Window:CreateTab("🔧 Debug", 4483362458)
}

-- Helper function untuk mencari di table (bukan method)
local function findInTable(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

-- Variables
local Toggles = {
    AutoFish = false,
    AutoCast = false,
    AutoReel = false,
    Notifications = true,
    SoundEffects = true,
    RandomFish = true
}

local Settings = {
    CastDelay = 1,
    LoopDelay = 0.5,
    SelectedRod = "Basic Rod",
    SelectedArea = "Lembah Pink",
    LuckBoost = 96,
    SelectedFish = "Love Nessie",
    MinWeight = 650,
    MaxWeight = 770,
    -- Jarak untuk casting (akan ditambahkan ke posisi HRP)
    CastOffset1 = Vector3.new(0, 0, -10),  -- Offset untuk CastPos1 dari HRP
    CastOffset2 = Vector3.new(5, 0, -5),   -- Offset untuk CastPos2 dari HRP
    HookOffset = Vector3.new(0, -5, -15)    -- Offset untuk HookPos dari HRP
}

-- Global variables untuk keamanan
_G.SelectedFish = "Love Nessie"
_G.LastFishGiven = ""
_G.DebugMode = false

local Stats = {
    FishCaught = 0,
    TotalWeight = 0,
    StartTime = os.time(),
    SessionTime = "0m 0s",
    FishHistory = {}
}

-- ==================== DATABASE IKAN SUPER LENGKAP (ALL SECRET) ====================
local FishDatabase = {
    "Ancient Lochness Lava",
    "Ancient Lochness Monster",
    "Ancient Magma Whale",
    "Bajak Laut Dreadfin",
    "Bajak Laut Megalodon",
    "Belut Panther",
    "Blackcap Basslet",
    "Blueflame Ray",
    "Blushwave",
    "Boar Fish",
    "Broken Heart Nessie",
    "Candy Butterfly",
    "Cumi-cumi Penjaga Suci",
    "Cupid Octopus",
    "Cutsie Fish",
    "Cypress Ratua",
    "Domino Damsel",
    "Dory",
    "Dotted Stingray",
    "El Maja",
    "El Maja Merah",
    "Elegant Eel",
    "Ences Maja",
    "Enchanted Angelfish",
    "Fangtooth",
    "Flying Hearts",
    "Forever Forehead",
    "Fossilized Shark",
    "Frostborn Shark",
    "Gadis Lava",
    "Goliath Tiger",
    "Green Gillfish",
    "Gummy Fish",
    "Gurita Hijau",
    "Guttenfang",
    "Hammerhead Shark",
    "Heart Dolphin",
    "Heart Walrus",
    "Hiu Magma",
    "Ikan Badut",
    "Ikan Cutlas",
    "Ikan Layar Bajak Laut",
    "Ikan Malaikat",
    "Jellyfin",
    "Kapten Ikan Buntal",
    "Kardian Lava",
    "Kelomang",
    "Kepala Ular",
    "Kepiting Biru",
    "Kepiting Harta Karun",
    "Kepiting Pelaut",
    "Kupu-Kupu Lava",
    "Leviathan",
    "Loggerhead Turtle",
    "Lopster Biru",
    "Lopster Merah",
    "Love Nessie",
    "Loving Tang",
    "Lovtopus",
    "Megalodon",
    "Peach Bubbler",
    "Peach Clownfish",
    "Peach Tailfish",
    "Peach Tuna",
    "Purple Megalodon",
    "Rose Swordfish",
    "Tulang Koi",
    "Tuna Lava",
    "Valentine Pearl Fish",
    "Volsail Tang",
    "Walrus Bride",
    "Zombie Megalodon",
    "ikan bandit"
}

-- Sort database alphabetically
table.sort(FishDatabase)

-- Set default fish yang valid
Settings.SelectedFish = FishDatabase[1] or "Love Nessie"
_G.SelectedFish = FishDatabase[1] or "Love Nessie"

-- ==================== MAIN TAB ====================
local MainSection = Tabs.Main:CreateSection("Main Controls")

local AutoFishToggle = Tabs.Main:CreateToggle({
    Name = "🤖 Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        Toggles.AutoFish = Value
        if Value then
            AutoFishLoop()
            ShowNotification("Auto Fish Started", "✨ Auto fishing activated!")
        else
            ShowNotification("Auto Fish Stopped", "⏸️ Auto fishing deactivated")
        end
    end
})

local StatusSection = Tabs.Main:CreateSection("Status Info")

-- Status Label yang akan diupdate
local StatusLabel = Tabs.Main:CreateLabel("🔴 Status: Idle")
local UserLabel = Tabs.Main:CreateLabel("👤 User: " .. game.Players.LocalPlayer.Name)
local ServerLabel = Tabs.Main:CreateLabel("🌐 Server: " .. game.JobId:sub(1,8) .. "...")
local LocationLabel = Tabs.Main:CreateLabel("📍 Location: Getting position...")
local LastFishLabel = Tabs.Main:CreateLabel("🐟 Last Fish: None")
local TargetFishLabel = Tabs.Main:CreateLabel("🎯 Target Fish: " .. Settings.SelectedFish)

-- ==================== TELEPORT TAB ====================
local TeleportSection = Tabs.Teleport:CreateSection("🌍 Teleport Locations")

-- Daftar Lokasi Teleport
local TeleportLocations = {
    ["Lembah Pink"] = Vector3.new(374, 36, -1916),
    ["Hutan"] = Vector3.new(811, 24, -1288),
    ["Mega Hunt"] = Vector3.new(852, 25, -353),
    ["Bajak Laut"] = Vector3.new(1078, 18, 484),
    ["Maja Hunt"] = Vector3.new(-539, 30, -956),
    ["Merapi"] = Vector3.new(-848, 62, -1887),
    ["Lautan"] = Vector3.new(-231, 20, -948)
}

-- Fungsi Teleport
local function TeleportTo(locationName, position)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        ShowNotification("Teleported!", "📍 Teleport ke " .. locationName)
        UpdateLocation()
    else
        ShowNotification("Error!", "Character not found!")
    end
end

-- Buat button untuk setiap lokasi
for locationName, position in pairs(TeleportLocations) do
    Tabs.Teleport:CreateButton({
        Name = "📍 " .. locationName .. " (" .. math.floor(position.X) .. ", " .. math.floor(position.Y) .. ", " .. math.floor(position.Z) .. ")",
        Callback = function()
            TeleportTo(locationName, position)
        end
    })
end

-- Quick Teleport Section
local QuickSection = Tabs.Teleport:CreateSection("⚡ Quick Actions")

Tabs.Teleport:CreateButton({
    Name = "🎯 Teleport to Mouse",
    Callback = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.X, mouse.Hit.Y + 5, mouse.Hit.Z)
            ShowNotification("Teleported!", "📍 Teleport ke posisi mouse")
        end
    end
})

Tabs.Teleport:CreateButton({
    Name = "📋 Copy Current Position",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local pos = character.HumanoidRootPart.Position
            local posString = string.format("Vector3.new(%.0f, %.0f, %.0f)", pos.X, pos.Y, pos.Z)
            setclipboard(posString)
            ShowNotification("Position Copied!", "📍 " .. posString)
        end
    end
})

-- ==================== FISH DATABASE TAB ====================
local FishDBSection = Tabs.FishDB:CreateSection("🐟 Complete Fish Database (All Secret)")

-- Tampilkan jumlah ikan
local totalFish = #FishDatabase

Tabs.FishDB:CreateLabel("📊 Total Fish: " .. totalFish .. " species")
Tabs.FishDB:CreateLabel("✨ All Rarity: SECRET")
Tabs.FishDB:CreateLabel("━━━━━━━━━━━━━━━━━━")

-- Tampilkan ikan per baris (3 ikan per baris biar rapi)
local line = ""
for i, fishName in ipairs(FishDatabase) do
    line = line .. fishName
    if i % 3 == 0 or i == #FishDatabase then
        Tabs.FishDB:CreateLabel("• " .. line)
        line = ""
    else
        line = line .. " | "
    end
end

-- ==================== FISHING TAB ====================
local FishingSection = Tabs.Fishing:CreateSection("Fishing Controls")

-- Rod Selector
local Rods = {"Basic Rod", "Advanced Rod", "Pro Rod", "Legendary Rod", "Mythical Rod"}
local RodDropdown = Tabs.Fishing:CreateDropdown({
    Name = "🎣 Select Rod",
    Options = Rods,
    CurrentOption = "Basic Rod",
    Flag = "RodSelector",
    Callback = function(Option)
        if Option then
            Settings.SelectedRod = Option
            ShowNotification("Rod Selected", "Using: " .. Option)
        end
    end
})

-- Area Selector
local AreaDropdown = Tabs.Fishing:CreateDropdown({
    Name = "📍 Select Area",
    Options = {"Lembah Pink", "Hutan", "Mega Hunt", "Bajak Laut", "Maja Hunt", "Merapi", "Lautan"},
    CurrentOption = "Lembah Pink",
    Flag = "AreaSelector",
    Callback = function(Option)
        if Option then
            Settings.SelectedArea = Option
        end
    end
})

local LuckSlider = Tabs.Fishing:CreateSlider({
    Name = "🍀 Luck Boost",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 96,
    Flag = "LuckBoost",
    Callback = function(Value)
        Settings.LuckBoost = Value
    end
})

-- Fish Selection Section
local FishSelectSection = Tabs.Fishing:CreateSection("🐟 Fish Selection")

local RandomFishToggle = Tabs.Fishing:CreateToggle({
    Name = "🎲 Random Fish",
    CurrentValue = true,
    Flag = "RandomFish",
    Callback = function(Value)
        Toggles.RandomFish = Value
        if Value then
            TargetFishLabel:Set("🎯 Target Fish: Random")
            ShowNotification("Random Mode", "Fishing random fish")
        else
            TargetFishLabel:Set("🎯 Target Fish: " .. Settings.SelectedFish)
            ShowNotification("Manual Mode", "Targeting: " .. Settings.SelectedFish)
        end
    end
})

-- ==================== FIXED DROPDOWN UNTUK HANDLE TABLE ====================
local FishDropdown = Tabs.Fishing:CreateDropdown({
    Name = "🐟 Select Fish",
    Options = FishDatabase,
    CurrentOption = Settings.SelectedFish,
    Flag = "FishSelector",
    Callback = function(selected)
        -- Debug untuk lihat apa yang dikirim dropdown
        print("🔍 DROPDOWN DEBUG - Received:", selected, "Type:", type(selected))
        
        local selectedFish = FishDatabase[1] -- Default
        
        -- KALAU YANG DIKIRIM ADALAH TABLE
        if type(selected) == "table" then
            -- Coba ambil dari table
            print("📦 Received TABLE, attempting to extract value")
            
            -- Cek berbagai kemungkinan struktur table
            if selected.Value then
                selectedFish = selected.Value
                print("  - Using selected.Value:", selectedFish)
            elseif selected.Text then
                selectedFish = selected.Text
                print("  - Using selected.Text:", selectedFish)
            elseif selected.Index then
                selectedFish = FishDatabase[selected.Index]
                print("  - Using selected.Index:", selected.Index, "->", selectedFish)
            elseif selected.Name then
                selectedFish = selected.Name
                print("  - Using selected.Name:", selectedFish)
            elseif selected[1] then
                selectedFish = selected[1]
                print("  - Using selected[1]:", selectedFish)
            else
                -- Coba konversi ke string dan cari kecocokan di database
                local str = tostring(selected)
                for _, fish in ipairs(FishDatabase) do
                    if str:find(fish) then
                        selectedFish = fish
                        print("  - Found by string match:", fish)
                        break
                    end
                end
            end
            
        -- KALAU YANG DIKIRIM ADALAH ANGKA (INDEX)
        elseif type(selected) == "number" then
            selectedFish = FishDatabase[selected]
            print("📊 Selected by INDEX:", selected, "->", selectedFish)
            
        -- KALAU YANG DIKIRIM ADALAH STRING (NAMA IKAN)
        elseif type(selected) == "string" and selected ~= "" then
            selectedFish = selected
            print("📝 Selected by NAME:", selectedFish)
        end
        
        -- Validasi fish (gunakan findInTable, bukan table.find)
        if selectedFish then
            -- Cek apakah ada di database
            local isValid = findInTable(FishDatabase, selectedFish) ~= nil
            
            if isValid then
                Settings.SelectedFish = selectedFish
                _G.SelectedFish = selectedFish
                TargetFishLabel:Set("🎯 Target Fish: " .. selectedFish)
                
                if not Toggles.RandomFish then
                    ShowNotification("Fish Selected", "Now targeting: " .. selectedFish)
                end
                
                print("✅ Valid fish selected:", selectedFish)
            else
                print("❌ Invalid fish '" .. tostring(selectedFish) .. "', using default")
                Settings.SelectedFish = FishDatabase[1]
                _G.SelectedFish = FishDatabase[1]
                TargetFishLabel:Set("🎯 Target Fish: " .. FishDatabase[1])
            end
        else
            print("⚠️ Empty selection, using default")
            Settings.SelectedFish = FishDatabase[1]
            _G.SelectedFish = FishDatabase[1]
            TargetFishLabel:Set("🎯 Target Fish: " .. FishDatabase[1])
        end
    end
})

-- Weight Settings
local WeightSection = Tabs.Fishing:CreateSection("⚖️ Weight Settings")

local MinWeightSlider = Tabs.Fishing:CreateSlider({
    Name = "⬇️ Min Weight",
    Range = {100, 1000},
    Increment = 10,
    CurrentValue = 650,
    Flag = "MinWeight",
    Callback = function(Value)
        Settings.MinWeight = Value
    end
})

local MaxWeightSlider = Tabs.Fishing:CreateSlider({
    Name = "⬆️ Max Weight",
    Range = {100, 1000},
    Increment = 10,
    CurrentValue = 770,
    Flag = "MaxWeight",
    Callback = function(Value)
        Settings.MaxWeight = Value
    end
})

-- ==================== HRP POSITION SETTINGS ====================
local HRPSection = Tabs.Fishing:CreateSection("🤖 HRP Position Settings (Otomatis)")

Tabs.Fishing:CreateLabel("📌 Semua posisi akan menggunakan HRP + Offset")
Tabs.Fishing:CreateLabel("📍 Cast Position = HRP Position + Offset")

-- Offset Settings
local OffsetSection = Tabs.Fishing:CreateSection("📐 Offset Settings (HRP + Offset)")

local CastOffsetX = Tabs.Fishing:CreateSlider({
    Name = "➡️ Cast Offset X",
    Range = {-50, 50},
    Increment = 1,
    CurrentValue = 0,
    Flag = "CastOffsetX",
    Callback = function(Value)
        Settings.CastOffset1 = Vector3.new(Value, Settings.CastOffset1.Y, Settings.CastOffset1.Z)
    end
})

local CastOffsetY = Tabs.Fishing:CreateSlider({
    Name = "⬆️ Cast Offset Y",
    Range = {-50, 50},
    Increment = 1,
    CurrentValue = 0,
    Flag = "CastOffsetY",
    Callback = function(Value)
        Settings.CastOffset1 = Vector3.new(Settings.CastOffset1.X, Value, Settings.CastOffset1.Z)
    end
})

local CastOffsetZ = Tabs.Fishing:CreateSlider({
    Name = "⬅️ Cast Offset Z",
    Range = {-50, 50},
    Increment = 1,
    CurrentValue = -10,
    Flag = "CastOffsetZ",
    Callback = function(Value)
        Settings.CastOffset1 = Vector3.new(Settings.CastOffset1.X, Settings.CastOffset1.Y, Value)
    end
})

local HookOffsetX = Tabs.Fishing:CreateSlider({
    Name = "➡️ Hook Offset X",
    Range = {-50, 50},
    Increment = 1,
    CurrentValue = 0,
    Flag = "HookOffsetX",
    Callback = function(Value)
        Settings.HookOffset = Vector3.new(Value, Settings.HookOffset.Y, Settings.HookOffset.Z)
    end
})

local HookOffsetY = Tabs.Fishing:CreateSlider({
    Name = "⬆️ Hook Offset Y",
    Range = {-50, 50},
    Increment = 1,
    CurrentValue = -5,
    Flag = "HookOffsetY",
    Callback = function(Value)
        Settings.HookOffset = Vector3.new(Settings.HookOffset.X, Value, Settings.HookOffset.Z)
    end
})

local HookOffsetZ = Tabs.Fishing:CreateSlider({
    Name = "⬅️ Hook Offset Z",
    Range = {-50, 50},
    Increment = 1,
    CurrentValue = -15,
    Flag = "HookOffsetZ",
    Callback = function(Value)
        Settings.HookOffset = Vector3.new(Settings.HookOffset.X, Settings.HookOffset.Y, Value)
    end
})

-- Tombol untuk reset offset
Tabs.Fishing:CreateButton({
    Name = "🔄 Reset Offset ke Default",
    Callback = function()
        Settings.CastOffset1 = Vector3.new(0, 0, -10)
        Settings.HookOffset = Vector3.new(0, -5, -15)
        
        -- Update slider
        CastOffsetX:Set(0)
        CastOffsetY:Set(0)
        CastOffsetZ:Set(-10)
        HookOffsetX:Set(0)
        HookOffsetY:Set(-5)
        HookOffsetZ:Set(-15)
        
        ShowNotification("Offset Reset", "Kembali ke default")
    end
})

-- Tombol untuk test posisi
Tabs.Fishing:CreateButton({
    Name = "📍 Test Current HRP + Offset",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart.Position
            local castPos = hrp + Settings.CastOffset1
            local hookPos = hrp + Settings.HookOffset
            
            print("===== HRP POSITION TEST =====")
            print("HRP Position:", string.format("%.1f, %.1f, %.1f", hrp.X, hrp.Y, hrp.Z))
            print("Cast Position (HRP + Offset):", string.format("%.1f, %.1f, %.1f", castPos.X, castPos.Y, castPos.Z))
            print("Hook Position (HRP + Offset):", string.format("%.1f, %.1f, %.1f", hookPos.X, hookPos.Y, hookPos.Z))
            print("Offset Values:")
            print("  Cast Offset:", string.format("%.1f, %.1f, %.1f", Settings.CastOffset1.X, Settings.CastOffset1.Y, Settings.CastOffset1.Z))
            print("  Hook Offset:", string.format("%.1f, %.1f, %.1f", Settings.HookOffset.X, Settings.HookOffset.Y, Settings.HookOffset.Z))
            
            ShowNotification("Position Test", "Cek F9 console untuk detail")
        end
    end
})

-- ==================== SETTINGS TAB ====================
local SettingsSection = Tabs.Settings:CreateSection("Delay Settings")

local CastDelaySlider = Tabs.Settings:CreateSlider({
    Name = "⏱️ Cast Delay (seconds)",
    Range = {0.1, 3},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "CastDelay",
    Callback = function(Value)
        Settings.CastDelay = Value
    end
})

local LoopDelaySlider = Tabs.Settings:CreateSlider({
    Name = "⏱️ Loop Delay (seconds)",
    Range = {0.1, 3},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "LoopDelay",
    Callback = function(Value)
        Settings.LoopDelay = Value
    end
})

local ToggleSection = Tabs.Settings:CreateSection("Toggle Options")

local NotificationsToggle = Tabs.Settings:CreateToggle({
    Name = "🔔 Notifications",
    CurrentValue = true,
    Flag = "Notifications",
    Callback = function(Value)
        Toggles.Notifications = Value
    end
})

local SoundToggle = Tabs.Settings:CreateToggle({
    Name = "🔊 Sound Effects",
    CurrentValue = false,
    Flag = "SoundEffects",
    Callback = function(Value)
        Toggles.SoundEffects = Value
    end
})

-- ==================== STATS TAB ====================
local StatsSection = Tabs.Stats:CreateSection("Fishing Statistics")

-- Stats Labels yang akan diupdate
local FishCountLabel = Tabs.Stats:CreateLabel("🐟 Fish Caught: 0")
local WeightLabel = Tabs.Stats:CreateLabel("⚖️ Total Weight: 0 kg")
local TimeLabel = Tabs.Stats:CreateLabel("⏰ Session Time: 0m 0s")
local RateLabel = Tabs.Stats:CreateLabel("📈 Catch Rate: 0/min")
local UniqueFishLabel = Tabs.Stats:CreateLabel("🎲 Unique Fish: 0")

-- Fish History Section
local HistorySection = Tabs.Stats:CreateSection("📜 Last 10 Fish")

local HistoryLabels = {}
for i = 1, 10 do
    HistoryLabels[i] = Tabs.Stats:CreateLabel(i .. ". -")
end

Tabs.Stats:CreateButton({
    Name = "🔄 Reset Stats",
    Callback = function()
        Stats.FishCaught = 0
        Stats.TotalWeight = 0
        Stats.StartTime = os.time()
        Stats.FishHistory = {}
        UpdateStats()
        ShowNotification("Stats Reset", "Statistics have been reset!")
    end
})

-- ==================== DEBUG TAB ====================
local DebugSection = Tabs.Debug:CreateSection("🔍 Debug Information")

Tabs.Debug:CreateLabel("Current Settings:")
local DebugSelectedFish = Tabs.Debug:CreateLabel("🐟 Selected Fish: " .. Settings.SelectedFish)
local DebugRandomMode = Tabs.Debug:CreateLabel("🎲 Random Mode: " .. tostring(Toggles.RandomFish))
local DebugLastFish = Tabs.Debug:CreateLabel("📦 Last Fish Given: None")
local DebugHRPPos = Tabs.Debug:CreateLabel("📍 HRP Position: Unknown")
local DebugCastPos = Tabs.Debug:CreateLabel("🎣 Cast Position: Unknown")
local DebugHookPos = Tabs.Debug:CreateLabel("🪝 Hook Position: Unknown")

Tabs.Debug:CreateButton({
    Name = "🔍 Check Current Values",
    Callback = function()
        print("========== DEBUG INFO ==========")
        print("SelectedFish (Settings):", Settings.SelectedFish or "nil")
        print("SelectedFish (_G):", _G.SelectedFish or "nil")
        print("RandomFish Toggle:", tostring(Toggles.RandomFish))
        print("AutoFish Status:", tostring(Toggles.AutoFish))
        print("Selected Rod:", Settings.SelectedRod or "nil")
        print("Selected Area:", Settings.SelectedArea or "nil")
        print("Cast Offset:", string.format("%.1f, %.1f, %.1f", Settings.CastOffset1.X, Settings.CastOffset1.Y, Settings.CastOffset1.Z))
        print("Hook Offset:", string.format("%.1f, %.1f, %.1f", Settings.HookOffset.X, Settings.HookOffset.Y, Settings.HookOffset.Z))
        print("=================================")
        
        ShowNotification("Debug Info", "Check F9 console for details")
    end
})

Tabs.Debug:CreateButton({
    Name = "🔍 Test Dropdown Selection",
    Callback = function()
        print("===== DROPDOWN DEBUG =====")
        print("Settings.SelectedFish:", Settings.SelectedFish or "nil")
        print("_G.SelectedFish:", _G.SelectedFish or "nil")
        print("Toggles.RandomFish:", tostring(Toggles.RandomFish))
        
        -- Tampilkan 10 ikan pertama dengan index
        print("Sample database with index (first 10):")
        for i = 1, math.min(10, #FishDatabase) do
            print("  " .. i .. ". " .. FishDatabase[i])
        end
        print("==========================")
    end
})

Tabs.Debug:CreateButton({
    Name = "🔬 Test Dropdown Structure",
    Callback = function()
        print("===== DROPDOWN STRUCTURE TEST =====")
        -- Coba buat dropdown test sementara
        local testOptions = {"Option 1", "Option 2", "Option 3"}
        local testDropdown = Tabs.Debug:CreateDropdown({
            Name = "Test Dropdown",
            Options = testOptions,
            CurrentOption = "Option 1",
            Flag = "TestDropdown",
            Callback = function(sel)
                print("Test dropdown received:", sel, "Type:", type(sel))
                if type(sel) == "table" then
                    print("Table contents:")
                    for k, v in pairs(sel) do
                        print("  ", k, "=", tostring(v))
                    end
                end
            end
        })
        ShowNotification("Test", "Cek console untuk hasil test")
    end
})

Tabs.Debug:CreateButton({
    Name = "🎯 Test Pilih Ikan Index 10",
    Callback = function()
        local testFish = FishDatabase[10]
        print("🧪 Testing select fish at index 10:", testFish)
        Settings.SelectedFish = testFish
        _G.SelectedFish = testFish
        TargetFishLabel:Set("🎯 Target Fish: " .. testFish)
        ShowNotification("Test", "Selected: " .. testFish)
    end
})

Tabs.Debug:CreateButton({
    Name = "📊 Tampilkan Semua Index Ikan",
    Callback = function()
        print("===== FISH DATABASE WITH INDEX =====")
        for i, fish in ipairs(FishDatabase) do
            print(i .. ": " .. fish)
        end
        print("Total:", #FishDatabase, "fish")
    end
})

-- ==================== CREDIT TAB ====================
local CreditSection = Tabs.Credit:CreateSection("About AmbonHub🚯")

Tabs.Credit:CreateLabel("🌟 AmbonHub🚯 Super Edition")
Tabs.Credit:CreateLabel("━━━━━━━━━━━━━━━━━━")
Tabs.Credit:CreateLabel("👑 Created by: Ambon Team")
Tabs.Credit:CreateLabel("💎 Version: 3.2.4 (Fixed Readonly Table Error)")
Tabs.Credit:CreateLabel("📅 Release: 2024")
Tabs.Credit:CreateLabel("📍 7 Teleport Locations")
Tabs.Credit:CreateLabel("🐟 " .. totalFish .. " Secret Fish Species")
Tabs.Credit:CreateLabel("🤖 All positions use HRP + Offset")
Tabs.Credit:CreateLabel("━━━━━━━━━━━━━━━━━━")

local SocialSection = Tabs.Credit:CreateSection("Social Media")

Tabs.Credit:CreateButton({
    Name = "📱 Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/ambonhub")
        ShowNotification("Discord Link Copied!", "Paste di browser untuk join")
    end
})

Tabs.Credit:CreateButton({
    Name = "💰 Support Us",
    Callback = function()
        setclipboard("https://saweria.co/ambonhub")
        ShowNotification("Saweria Link Copied!", "Terima kasih atas dukungannya ❤️")
    end
})

-- ==================== FUNCTIONS ====================

-- Fungsi untuk mendapatkan posisi HRP
local function GetHRPPosition()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart.Position
    end
    return nil
end

-- Fungsi untuk mendapatkan Cast Position (HRP + Offset)
local function GetCastPosition()
    local hrpPos = GetHRPPosition()
    if hrpPos then
        return hrpPos + Settings.CastOffset1
    end
    return Vector3.new(0, 0, 0) -- Fallback
end

-- Fungsi untuk mendapatkan Hook Position (HRP + Offset)
local function GetHookPosition()
    local hrpPos = GetHRPPosition()
    if hrpPos then
        return hrpPos + Settings.HookOffset
    end
    return Vector3.new(0, 0, 0) -- Fallback
end

-- Show Notification
function ShowNotification(title, content)
    if Toggles.Notifications then
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = 3,
            Image = 4483362458
        })
    end
end

-- Get Random Fish
function GetRandomFish()
    return FishDatabase[math.random(1, #FishDatabase)]
end

-- Update Fish History
function UpdateFishHistory(fishName, weight)
    table.insert(Stats.FishHistory, 1, {
        name = fishName,
        weight = weight,
        time = os.time()
    })
    
    -- Keep only last 10
    if #Stats.FishHistory > 10 then
        table.remove(Stats.FishHistory)
    end
    
    -- Update history labels
    for i = 1, 10 do
        if Stats.FishHistory[i] then
            local fish = Stats.FishHistory[i]
            HistoryLabels[i]:Set(i .. ". " .. fish.name .. " (" .. fish.weight .. "kg)")
        else
            HistoryLabels[i]:Set(i .. ". -")
        end
    end
    
    LastFishLabel:Set("🐟 Last Fish: " .. fishName .. " (" .. weight .. "kg)")
    _G.LastFishGiven = fishName
    DebugLastFish:Set("📦 Last Fish Given: " .. fishName)
end

-- Update Lokasi
function UpdateLocation()
    local hrpPos = GetHRPPosition()
    if hrpPos then        
        -- Cari lokasi terdekat dari daftar
        local closestLocation = "Unknown"
        local closestDistance = math.huge
        
        for name, locPos in pairs(TeleportLocations) do
            local distance = (hrpPos - locPos).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestLocation = name
            end
        end
        
        -- Kalau jarak > 50, tampilkan koordinat saja
        if closestDistance > 50 then
            LocationLabel:Set("📍 Location: " .. math.floor(hrpPos.X) .. ", " .. math.floor(hrpPos.Y) .. ", " .. math.floor(hrpPos.Z))
        else
            LocationLabel:Set("📍 Location: " .. closestLocation .. " (" .. math.floor(hrpPos.X) .. ", " .. math.floor(hrpPos.Y) .. ", " .. math.floor(hrpPos.Z) .. ")")
        end
        
        -- Update debug HRP
        DebugHRPPos:Set("📍 HRP Position: " .. math.floor(hrpPos.X) .. ", " .. math.floor(hrpPos.Y) .. ", " .. math.floor(hrpPos.Z))
        
        local castPos = GetCastPosition()
        DebugCastPos:Set("🎣 Cast Position: " .. math.floor(castPos.X) .. ", " .. math.floor(castPos.Y) .. ", " .. math.floor(castPos.Z))
        
        local hookPos = GetHookPosition()
        DebugHookPos:Set("🪝 Hook Position: " .. math.floor(hookPos.X) .. ", " .. math.floor(hookPos.Y) .. ", " .. math.floor(hookPos.Z))
    end
end

-- Update Stats
function UpdateStats()
    FishCountLabel:Set("🐟 Fish Caught: " .. Stats.FishCaught)
    WeightLabel:Set("⚖️ Total Weight: " .. math.floor(Stats.TotalWeight) .. " kg")
    
    local sessionTime = os.time() - Stats.StartTime
    local minutes = math.floor(sessionTime / 60)
    local seconds = sessionTime % 60
    TimeLabel:Set("⏰ Session Time: " .. minutes .. "m " .. seconds .. "s")
    
    local rate = minutes > 0 and math.floor((Stats.FishCaught / minutes) * 100) / 100 or 0
    RateLabel:Set("📈 Catch Rate: " .. rate .. "/min")
    
    -- Unique fish count
    local uniqueFish = {}
    for _, fish in ipairs(Stats.FishHistory) do
        uniqueFish[fish.name] = true
    end
    local uniqueCount = 0
    for _ in pairs(uniqueFish) do uniqueCount = uniqueCount + 1 end
    UniqueFishLabel:Set("🎲 Unique Fish: " .. uniqueCount)
    
    -- Update status
    if Toggles.AutoFish then
        StatusLabel:Set("🟢 Status: Running")
    else
        StatusLabel:Set("🔴 Status: Idle")
    end
    
    -- Update debug
    DebugSelectedFish:Set("🐟 Selected Fish: " .. Settings.SelectedFish)
    DebugRandomMode:Set("🎲 Random Mode: " .. tostring(Toggles.RandomFish))
    
    UpdateLocation()
end

-- Cast Function (menggunakan HRP + Offset)
function Cast()
    local castPos1 = GetCastPosition()
    local castPos2 = castPos1 + Vector3.new(5, 0, 5) -- Offset kecil untuk posisi kedua
    
    local args = {
        castPos1,
        castPos2,
        Settings.SelectedRod,
        Settings.LuckBoost,
        Settings.SelectedArea
    }
    
    print("🎣 Casting from HRP position:", string.format("%.1f, %.1f, %.1f", castPos1.X, castPos1.Y, castPos1.Z))
    
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CastReplication"):FireServer(unpack(args))
        task.wait(0.2)
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("FishingSystemEvents"):WaitForChild("GetPersonalLuck"):InvokeServer()
    end)
    
    if not success then
        warn("Cast error:", err)
    end
end

-- Start Minigame
function StartMinigame()
    local args = {
        Settings.SelectedRod,
        true
    }
    
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("MinigameStarted"):FireServer(unpack(args))
        task.wait(1.5)
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CleanupCast"):FireServer()
    end)
    
    if not success then
        warn("Minigame error:", err)
    end
end

-- ==================== FIXED GIVEFISH FUNCTION ====================
function GiveFish()
    -- Debug info
    print("===== GIVEFISH DEBUG =====")
    print("Toggles.RandomFish:", tostring(Toggles.RandomFish))
    print("Settings.SelectedFish:", Settings.SelectedFish or "nil")
    print("_G.SelectedFish:", _G.SelectedFish or "nil")
    
    -- Determine fish dengan validasi lengkap
    local fishName
    
    if Toggles.RandomFish then
        fishName = GetRandomFish()
        print("🎲 Random fish selected:", fishName)
    else
        -- Ambil dari Settings
        fishName = Settings.SelectedFish
        
        -- Jika Settings kosong, coba dari global
        if not fishName or fishName == "" then
            fishName = _G.SelectedFish
            print("📋 Using _G.SelectedFish:", fishName)
        end
        
        -- Validasi: cek apakah fishName valid (ada di database) - gunakan findInTable
        local isValid = findInTable(FishDatabase, fishName) ~= nil
        local validIndex = findInTable(FishDatabase, fishName) or 0
        
        -- Jika tidak valid, pake default
        if not isValid or not fishName then
            print("⚠️ Invalid fish selection:", fishName or "nil", "using fallback")
            fishName = FishDatabase[1] -- Ambil ikan pertama sebagai fallback
            print("📌 Fallback to:", fishName)
            
            -- Update Settings dengan nilai valid
            Settings.SelectedFish = fishName
            _G.SelectedFish = fishName
        else
            print("🎯 Manual fish selected:", fishName, "(index:", validIndex, ")")
        end
    end
    
    -- Pastikan fishName tidak nil
    if not fishName then
        fishName = FishDatabase[1]
        print("⚠️ Emergency fallback to:", fishName)
    end
    
    -- Generate weight
    local weight = math.random(Settings.MinWeight, Settings.MaxWeight)
    
    -- Dapatkan hook position dari HRP + Offset
    local hookPos = GetHookPosition()
    
    print("📤 FINAL - Sending fish:", fishName)
    print("=========================")
    
    -- Siapkan arguments dengan hookPosition dari HRP
    local args = {
        {
            hookPosition = hookPos,
            rarity = "Secret",
            name = fishName,
            weight = weight
        }
    }
    
    -- Kirim ke server
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("FishingSystemEvents"):WaitForChild("FishGiver"):FireServer(unpack(args))
        
        -- Update stats
        Stats.FishCaught = Stats.FishCaught + 1
        Stats.TotalWeight = Stats.TotalWeight + weight
        UpdateFishHistory(fishName, weight)
        UpdateStats()
        
        -- Update target label
        if Toggles.RandomFish then
            TargetFishLabel:Set("🎯 Target Fish: Random")
        else
            TargetFishLabel:Set("🎯 Target Fish: " .. Settings.SelectedFish)
        end
        
        if Toggles.Notifications then
            ShowNotification("🎣 Fish Caught!", fishName .. " (" .. weight .. "kg)")
        end
        
        print("✅ Fish given successfully:", fishName)
    end)
    
    if not success then
        warn("❌ FishGiver error:", err)
        print("   Fish name attempted:", fishName or "nil")
    end
end

-- Auto Fish Loop
function AutoFishLoop()
    coroutine.wrap(function()
        while Toggles.AutoFish and task.wait(Settings.LoopDelay) do
            for i = 1, 2 do
                if not Toggles.AutoFish then break end
                
                StatusLabel:Set("🟢 Status: Casting...")
                Cast()
                
                task.wait(Settings.CastDelay)
                
                if not Toggles.AutoFish then break end
                
                StatusLabel:Set("🟢 Status: Minigame...")
                StartMinigame()
                
                task.wait(1.5)
                
                if not Toggles.AutoFish then break end
                
                StatusLabel:Set("🟢 Status: Getting Fish...")
                GiveFish()
                
                task.wait(0.2)
            end
        end
        StatusLabel:Set("🔴 Status: Idle")
    end)()
end

-- Auto update stats every second
coroutine.wrap(function()
    while task.wait(1) do
        UpdateStats()
    end
end)()

-- Welcome Notification
task.wait(1)
ShowNotification("✨ Welcome to AmbonHub🚯", "Selamat datang " .. game.Players.LocalPlayer.Name .. "!")
ShowNotification("🐟 " .. totalFish .. " Secret Fish Species", "Database ikan secret super lengkap!")
ShowNotification("📍 7 Teleport Locations", "Cek tab Teleport untuk berpindah lokasi!")
ShowNotification("🤖 HRP Based System", "Semua posisi menggunakan HRP + Offset!")
ShowNotification("🔧 Bug Fixed", "Readonly table error telah diperbaiki!")

print("✅ AmbonHub🚯 Rayfield Latest Version Loaded Successfully!")
print("🐟 Total Secret Fish in Database: " .. totalFish)
print("🤖 All positions using HRP + Offset")
print("🔧 Readonly table error has been fixed!")
print("📦 Default fish: " .. FishDatabase[1])