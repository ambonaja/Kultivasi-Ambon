--[[
▓▓ ▓▓▓▓ ▓▓▓▓▓ ▓▓  ▓▓ ▓▓▓▓▓ ▓▓▓▓ ▓▓  ▓▓ ▓▓▓▓ ▓▓  ▓▓
 ▓▓  ▓▓  ▓▓    ▓▓ ▓▓  ▓▓   ▓▓    ▓▓ ▓▓  ▓▓   ▓▓ ▓▓
 ▓▓  ▓▓  ▓▓▓▓  ▓▓▓▓   ▓▓▓▓ ▓▓▓▓  ▓▓▓▓   ▓▓▓▓ ▓▓▓▓
 ▓▓  ▓▓  ▓▓    ▓▓ ▓▓  ▓▓   ▓▓    ▓▓ ▓▓  ▓▓   ▓▓ ▓▓
 ▓▓ ▓▓▓▓ ▓▓    ▓▓  ▓▓ ▓▓▓▓▓ ▓▓▓▓▓ ▓▓  ▓▓ ▓▓▓▓ ▓▓  ▓▓

███████╗██╗██╗  ██╗██╗███╗   ██╗ ██████╗ 
██╔════╝██║██║  ██║██║████╗  ██║██╔════╝ 
█████╗  ██║███████║██║██╔██╗ ██║██║  ███╗
██╔══╝  ██║██╔══██║██║██║╚██╗██║██║   ██║
██║     ██║██║  ██║██║██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 

██╗  ██╗██╗   ██╗██████╗ 
██║  ██║██║   ██║██╔══██╗
███████║██║   ██║██████╔╝
██╔══██║██║   ██║██╔══██╗
██║  ██║╚██████╔╝██████╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
]]

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- ============= [ VARIABEL GLOBAL ] =============

local Settings = {
    -- Teleport settings
    TeleportEnabled = false,
    -- Fishing settings
    FishingEnabled = false,
    Rod = "Basic Rod",
    Zone = "stater",
    Delay = 2.5,
    PowerMin = 10,
    PowerMax = 100,
    AutoBait = true,
    AutoEnchant = true,
    -- Fast cast settings
    FastCastEnabled = false,
    FastCastMultiplier = 5,
    FastCastCooldown = 0.1,
    -- Lock position
    LockPosition = nil,
    LockEnabled = false
}

local Stats = {
    Casts = 0,
    StartTime = tick(),
    LastCast = 0,
    FastCasts = 0
}

-- ============= [ FUNGSI LOCK POSITION ] =============

local function lockPosition(position)
    Settings.LockPosition = position
    Settings.LockEnabled = true
    Rayfield:Notify({
        Title = "POSISI TERKUNCI 🔒",
        Content = "Posisi bakal dikunci di Ocean!",
        Duration = 3,
        Image = 4483361278
    })
end

local function unlockPosition()
    Settings.LockPosition = nil
    Settings.LockEnabled = false
    Rayfield:Notify({
        Title = "POSISI TERBUKA 🔓",
        Content = "Posisi udah gak dikunci!",
        Duration = 3,
        Image = 4483361278
    })
end

-- LOOP UNTUK LOCK POSITION
RunService.Heartbeat:Connect(function()
    if Settings.LockEnabled and Settings.LockPosition then
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = Settings.LockPosition
            end
        end)
    end
end)

-- ============= [ FUNGSI TELEPORT ] =============

local tempat = {
    {"CANDY ISLAND 🍭", CFrame.new(-1055, 56, -18)},
    {"VOLCANO 🔥", CFrame.new(1498, 60, -11)},
    {"GLACIER ISLAND 🧊", CFrame.new(-31, 47, 684)},
    {"SKY ISLAND ☁️", CFrame.new(1970, 903, -648)},
    {"SHOP SELL 💰", CFrame.new(49, 68, -1054)},
    {"OCEAN 🌊", CFrame.new(-1180, 54, -1299)},
    {"RANDOM 🎲", CFrame.new(math.random(-2000,2000), math.random(50,500), math.random(-2000,2000))}
}

local function teleportTo(teleportData)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if type(teleportData) == "string" and teleportData == "RANDOM" then
            unlockPosition() -- Unlock posisi kalau random
            player.Character.HumanoidRootPart.CFrame = CFrame.new(
                math.random(-2000,2000), 
                math.random(50,500), 
                math.random(-2000,2000)
            )
            Rayfield:Notify({
                Title = "Random",
                Content = "Ke random spot!",
                Duration = 2,
                Image = 4483361278
            })
        elseif type(teleportData) == "table" then
            player.Character.HumanoidRootPart.CFrame = teleportData[2]
            
            -- CEK APAKAH TELEPORT KE OCEAN
            if teleportData[1] == "OCEAN 🌊" then
                lockPosition(teleportData[2])
            else
                unlockPosition() -- Unlock kalau ke tempat lain
            end
            
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Ke " .. teleportData[1],
                Duration = 2,
                Image = 4483361278
            })
        end
    else
        Rayfield:Notify({
            Title = "ERROR ANJING",
            Content = "Lu ga punya karakter tolol?",
            Duration = 3,
            Image = 4483361278
        })
    end
end

-- ============= [ FUNGSI FISHING DENGAN PCALL ] =============

local function getPlayerPosition()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart.Position
    end
    return Vector3.new(0, 50, 0)
end

local function generateCastPosition()
    local playerPos = getPlayerPosition()
    return Vector3.new(
        playerPos.X + math.random(-500, 500) / 10,
        playerPos.Y + 50 + math.random(-50, 50) / 10,
        playerPos.Z + math.random(-500, 500) / 10
    )
end

local function generateHookPosition()
    local playerPos = getPlayerPosition()
    return Vector3.new(
        playerPos.X + math.random(-200, 200) / 10,
        playerPos.Y - 10,
        playerPos.Z + math.random(-200, 200) / 10
    )
end

local function generateDirection()
    return Vector3.new(
        math.random(-100, 100) / 10,
        math.random(20, 30),
        math.random(-100, 100) / 10
    )
end

-- FUNGSI CAST UTAMA
local function doCast()
    pcall(function()
        if not Settings.FishingEnabled then return end
        
        local castPos = generateCastPosition()
        local hookPos = generateHookPosition()
        local direction = generateDirection()
        
        -- Auto Bait
        if Settings.AutoBait then
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local FishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
            if FishingSystem then
                local BaitShopEvents = FishingSystem:FindFirstChild("BaitShopEvents")
                if BaitShopEvents then
                    local GetEquippedBait = BaitShopEvents:FindFirstChild("GetEquippedBait")
                    if GetEquippedBait then
                        GetEquippedBait:InvokeServer()
                    end
                    
                    local GetBaitHook = BaitShopEvents:FindFirstChild("GetBaitHook")
                    if GetBaitHook then
                        GetBaitHook:InvokeServer()
                    end
                end
            end
        end
        
        -- Auto Enchant
        if Settings.AutoEnchant then
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local RodEnchantEvents = ReplicatedStorage:FindFirstChild("RodEnchantEvents")
            if RodEnchantEvents then
                local GetRodEnchants = RodEnchantEvents:FindFirstChild("GetRodEnchants")
                if GetRodEnchants then
                    GetRodEnchants:InvokeServer()
                end
            end
        end
        
        -- Cast Replication
        local castArgs = {
            castPos,
            direction,
            Settings.Rod,
            math.random(Settings.PowerMin, Settings.PowerMax)
        }
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local FishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
        if FishingSystem then
            local CastReplication = FishingSystem:FindFirstChild("CastReplication")
            if CastReplication then
                CastReplication:FireServer(unpack(castArgs))
            end
        end
        
        -- Start Fishing
        local startArgs = { hookPos }
        if FishingSystem then
            local StartFishing = FishingSystem:FindFirstChild("StartFishing")
            if StartFishing then
                StartFishing:FireServer(unpack(startArgs))
            end
        end
        
        -- Request Fish Roll
        local rollArgs = { hookPos }
        if FishingSystem then
            local RequestFishRoll = FishingSystem:FindFirstChild("RequestFishRoll")
            if RequestFishRoll then
                RequestFishRoll:InvokeServer(unpack(rollArgs))
            end
        end
        
        -- Cleanup Cast
        if FishingSystem then
            local CleanupCast = FishingSystem:FindFirstChild("CleanupCast")
            if CleanupCast then
                CleanupCast:FireServer()
            end
        end
        
        -- Fish Giver
        local giverArgs = {
            {
                hookPosition = hookPos,
                zone = Settings.Zone
            }
        }
        if FishingSystem then
            local FishGiver = FishingSystem:FindFirstChild("FishGiver")
            if FishGiver then
                FishGiver:FireServer(unpack(giverArgs))
            end
        end
        
        Stats.Casts = Stats.Casts + 1
        Stats.LastCast = tick()
    end)
end

-- LOOP UTAMA FISHING
task.spawn(function()
    while true do
        if Settings.FishingEnabled then
            if Settings.FastCastEnabled then
                for i = 1, Settings.FastCastMultiplier do
                    task.spawn(doCast)
                    if i < Settings.FastCastMultiplier then
                        task.wait(Settings.FastCastCooldown)
                    end
                end
                Stats.FastCasts = Stats.FastCasts + Settings.FastCastMultiplier
            else
                doCast()
            end
        end
        task.wait(Settings.Delay)
    end
end)

-- ============= [ BUAT UI RAYFIELD ] =============

local Window = Rayfield:CreateWindow({
    Name = "AmbonHub🚯 Ganz",
    LoadingTitle = "AmbonHub🚯 4ever",
    LoadingSubtitle = "by AmbonHub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonHub_Mega",
        FileName = "ConfigGila"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- ============= [ TAB TELEPORT ] =============

local TeleportTab = Window:CreateTab("🚀 TELEPORT", 4483361278)
local TeleportSection = TeleportTab:CreateSection("LOKASI SETAN")

-- BUTTON TELEPORT
for i, data in ipairs(tempat) do
    TeleportTab:CreateButton({
        Name = data[1],
        Callback = function()
            teleportTo(data)
        end
    })
end

TeleportTab:CreateSection("MODE GILA")

TeleportTab:CreateButton({
    Name = "MULUNG MUTER",
    Callback = function()
        unlockPosition() -- Unlock dulu sebelum muter
        for i = 1, 10 do
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(
                    math.random(-2000,2000), 
                    math.random(50,1000), 
                    math.random(-2000,2000)
                )
            end
            wait(0.1)
        end
        Rayfield:Notify({
            Title = "Keliling",
            Content = "Udah muter-muter tuan!",
            Duration = 2,
            Image = 4483361278
        })
    end
})

TeleportTab:CreateButton({
    Name = "💀 BUNUH DIRI",
    Callback = function()
        unlockPosition() -- Unlock dulu sebelum bunuh diri
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
            Rayfield:Notify({
                Title = "Die",
                Content = "Mampus lu wkwk",
                Duration = 2,
                Image = 4483361278
            })
        end
    end
})

-- TAMBAHIN BUTTON UNLOCK MANUAL
TeleportTab:CreateSection("KONTROL LOCK")
TeleportTab:CreateButton({
    Name = "🔓 UNLOCK POSISI",
    Callback = function()
        unlockPosition()
    end
})

-- ============= [ TAB FISHING ] =============

local FishingTab = Window:CreateTab("🎣 FISHING", 4483362458)
local FishingSection = FishingTab:CreateSection("AUTO CAST")

-- TOGGLE FISHING
FishingTab:CreateToggle({
    Name = "Auto Cast",
    CurrentValue = false,
    Flag = "FishingToggle",
    Callback = function(Value)
        Settings.FishingEnabled = Value
        if Value then
            Stats.StartTime = tick()
            Stats.Casts = 0
            Stats.FastCasts = 0
            Rayfield:Notify({
                Title = "Auto Cast",
                Content = "✅ MULAI MANCING ANJING!",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "Auto Cast",
                Content = "❌ BERHENTI MANCING",
                Duration = 2
            })
        end
    end
})

-- TOGGLE FAST CAST
FishingTab:CreateToggle({
    Name = "⚡ FAST CAST MODE (5x)",
    CurrentValue = false,
    Flag = "FastCastToggle",
    Callback = function(Value)
        Settings.FastCastEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "FAST CAST",
                Content = "🔥 MODE 5x CEPET AKTIF!",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "FAST CAST",
                Content = "❌ MODE NORMAL",
                Duration = 2
            })
        end
    end
})

-- SLIDER DELAY
FishingTab:CreateSlider({
    Name = "Delay (detik)",
    Range = {1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = Settings.Delay,
    Flag = "DelaySlider",
    Callback = function(Value)
        Settings.Delay = Value
    end
})

-- SLIDER POWER
FishingTab:CreateSlider({
    Name = "Power Range",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 100,
    Flag = "PowerSlider",
    Callback = function(Value)
        Settings.PowerMax = Value
        Settings.PowerMin = math.floor(Value * 0.3)
    end
})

-- INPUT ROD
FishingTab:CreateInput({
    Name = "Rod Name",
    PlaceholderText = "Basic Rod",
    RemoveTextAfterFocusLost = false,
    Flag = "RodInput",
    Callback = function(Text)
        Settings.Rod = Text
    end
})

-- ============= [ TAB FISHING SETTINGS ] =============

local FishingSettingsTab = Window:CreateTab("⚙️ FISH SET", 4483362458)
local FishingSettingsSection = FishingSettingsTab:CreateSection("Options")

-- TOGGLE AUTO BAIT
FishingSettingsTab:CreateToggle({
    Name = "Auto Bait",
    CurrentValue = true,
    Flag = "AutoBait",
    Callback = function(Value)
        Settings.AutoBait = Value
    end
})

-- TOGGLE AUTO ENCHANT
FishingSettingsTab:CreateToggle({
    Name = "Auto Enchant",
    CurrentValue = true,
    Flag = "AutoEnchant",
    Callback = function(Value)
        Settings.AutoEnchant = Value
    end
})

-- ============= [ TAB STATS ] =============

local StatsTab = Window:CreateTab("📊 STATS", 4483362458)
local StatsSection = StatsTab:CreateSection("FISHING STATISTICS")

-- LABEL CASTS
local CastsLabel = StatsTab:CreateLabel("Casts: 0")
local FastCastsLabel = StatsTab:CreateLabel("Fast Casts: 0")
local RateLabel = StatsTab:CreateLabel("Rate: 0/min")
local TimeLabel = StatsTab:CreateLabel("Time: 0m 0s")

-- UPDATE STATS
task.spawn(function()
    while true do
        if Settings.FishingEnabled then
            local elapsed = (tick() - Stats.StartTime) / 60
            local rate = Stats.Casts / (elapsed + 0.01)
            
            CastsLabel:Set("Casts: " .. Stats.Casts)
            FastCastsLabel:Set("Fast Casts: " .. Stats.FastCasts)
            RateLabel:Set(string.format("Rate: %.1f/min", rate))
            
            local minutes = math.floor(elapsed)
            local seconds = math.floor((elapsed - minutes) * 60)
            TimeLabel:Set(string.format("Time: %dm %ds", minutes, seconds))
        end
        task.wait(1)
    end
end)

-- NOTIF START
Rayfield:Notify({
    Title = "AmbonHub🚯",
    Content = "SIAP ON! 🥵 Ambon Hub Ganz",
    Duration = 5,
    Image = 4483361278
})

print("🔥 MEGAWATI DAN WOWO SIAP! 🥵")