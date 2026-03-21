-- AMBONHUB🚯 FISHING EVENT SPAMMER v5.1
-- Dengan UI Rayfield + Bobber Shop + Rod Shop + Teleport (10 Locations) + Dynamic HRP Coordinates

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Status Variables
local spammers = {}
local spamEnabled = {}
local spamDelays = {}
local bobberBuyAmount = 1
local rodBuyAmount = 1
local teleportTweenEnabled = true
local tweenSpeed = 0.5

-- Default delays (detik)
local defaultDelay = 0.05

-- ============= [ TELEPORT LOCATIONS ] =============

local teleportLocations = {
    ["🏝️ Crismis Pulau"] = Vector3.new(364, 141, -2472),
    ["✨ Pulau Enchant"] = Vector3.new(1564, 140, -2966),
    ["🌋 Merapi"] = Vector3.new(2695, 149, -812),
    ["🏖️ Pulau Baretam"] = Vector3.new(620, 140, 535),
    ["🦈 Megalodon Core"] = Vector3.new(-105, 138, 471),
    ["🏝️ Pulau Rantau"] = Vector3.new(-823, 137, 993),
    ["🏝️ Pulau Esotrea"] = Vector3.new(-1201, 141, -406),
    ["👑 King Mega Hunt"] = Vector3.new(-551, 143, -935),
    ["🏜️ Pulau Pasir"] = Vector3.new(-650, 132, -1804),
    ["⚡ Asea Elmaja (Event)"] = Vector3.new(651, 136, -1249)
}

-- Fungsi teleport
local function teleportTo(position, useTween)
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    useTween = (useTween == nil and teleportTweenEnabled) or useTween
    
    if useTween then
        -- Teleport dengan animasi tween
        local tweenInfo = TweenInfo.new(tweenSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(position)})
        tween:Play()
        
        Rayfield:Notify({
            Title = "🌀 TELEPORT - AmbonHub🚯",
            Content = "Teleporting to " .. getLocationNameFromPos(position),
            Duration = 2
        })
    else
        -- Teleport instant
        hrp.CFrame = CFrame.new(position)
        Rayfield:Notify({
            Title = "⚡ TELEPORT - AmbonHub🚯",
            Content = "Instantly teleported to " .. getLocationNameFromPos(position),
            Duration = 2
        })
    end
end

-- Fungsi mendapatkan nama lokasi dari posisi
local function getLocationNameFromPos(position)
    for name, pos in pairs(teleportLocations) do
        if pos == position then
            return name
        end
    end
    return "Unknown Location"
end

-- Fungsi untuk mendapatkan posisi HRP
local function getHRPPosition()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.Position
        end
    end
    return Vector3.new(0, 0, 0)
end

-- Fungsi untuk mendapatkan CFrame HRP
local function getHRPCFrame()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.CFrame
        end
    end
    return CFrame.new(0, 0, 0)
end

-- List semua event yang bisa di-spam (dengan dynamic HRP)
local eventList = {
    -- Event tanpa args
    {name = "StatusLemparUmpan1", hasArgs = false, args = {}},
    {name = "RollFishEvent", hasArgs = false, args = {}},
    {name = "StatusLemparUmpan2", hasArgs = false, args = {}},
    {name = "CleanupCast", hasArgs = false, args = {}, parent = "FishingSystem"},
    {name = "ShowRarityExclamations", hasArgs = false, args = {}},
    {name = "FishingCatchSuccess", hasArgs = false, args = {}},
    {name = "GlobalFishAnimationEvent", hasArgs = false, args = {}, parent = "FishingSystem"},
    {name = "codedata", hasArgs = false, args = {}, parent = "FishingSystem"},
    {name = "data", hasArgs = false, args = {}},
    {name = "playersdata", hasArgs = false, args = {}},
    
    -- Event dengan args (dynamic menggunakan HRP)
    {name = "CastReplication", hasArgs = true, args = function()
        local hrpPos = getHRPPosition()
        local hrpCF = getHRPCFrame()
        local lookVector = hrpCF.LookVector
        return {
            hrpPos,
            lookVector,
            "Darco Rods",
            99
        }
    end, parent = "FishingSystem"},
    
    {name = "LightningStrikeEvent", hasArgs = true, args = function()
        local hrpPos = getHRPPosition()
        return {hrpPos}
    end},
    
    {name = "RodsNull", hasArgs = true, args = {"Darco Rods"}},
    
    {name = "statusrod", hasArgs = true, args = {29.3}},
    
    {name = "ShowRarityExclamation", hasArgs = true, args = {"Rare"}},
    
    {name = "datarod", hasArgs = true, args = {"rod"}},
    
    {name = "BroadcastFishAnimation", hasArgs = true, args = function()
        local hrpPos = getHRPPosition()
        return {
            "Snapper",
            CFrame.new(hrpPos.X, hrpPos.Y + 5, hrpPos.Z + 10),
            "Rare"
        }
    end, parent = "FishingSystem"}
}

-- ============= [ BOBBER SHOP FUNCTIONS ] =============

local bobberList = {
    "Pinked Bobber",
    "Crystal Bobber",
    "Gold Bobber"
}

local function buyBobber(bobberName, amount)
    amount = amount or bobberBuyAmount
    
    pcall(function()
        local fishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
        if not fishingSystem then
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "FishingSystem tidak ditemukan!",
                Duration = 3
            })
            return
        end
        
        local bobberShopEvents = fishingSystem:FindFirstChild("BobberShopEvents")
        if not bobberShopEvents then
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "BobberShopEvents tidak ditemukan!",
                Duration = 3
            })
            return
        end
        
        local requestPurchase = bobberShopEvents:FindFirstChild("RequestPurchase")
        if not requestPurchase then
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "RequestPurchase remote tidak ditemukan!",
                Duration = 3
            })
            return
        end
        
        for i = 1, amount do
            local args = {bobberName}
            requestPurchase:FireServer(unpack(args))
            if i % 10 == 0 or i == amount then
                print("🔥 AmbonHub🚯 - Membeli " .. bobberName .. " (" .. i .. "/" .. amount .. ")")
            end
            task.wait(0.1)
        end
        
        Rayfield:Notify({
            Title = "🛒 BOBBER SHOP - AmbonHub🚯",
            Content = "Berhasil membeli " .. amount .. "x " .. bobberName,
            Duration = 3
        })
    end)
end

local function buyAllBobbers(amount)
    amount = amount or bobberBuyAmount
    for _, bobber in ipairs(bobberList) do
        buyBobber(bobber, amount)
        task.wait(0.5)
    end
    Rayfield:Notify({
        Title = "🛒 BOBBER SHOP - AmbonHub🚯",
        Content = "Semua bobber (" .. amount .. " each) sudah dibeli!",
        Duration = 3
    })
end

-- ============= [ ROD SHOP FUNCTIONS ] =============

local rodList = {
    "Purple Saber",
    "Earthly",
    "Manifest",
    "Polarized",
    "Lightning",
    "Lucky Rod",
    "Gold Rod",
    "Angelic Rod"
}

local function buyRod(rodName, amount)
    amount = amount or rodBuyAmount
    
    pcall(function()
        local fishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
        if not fishingSystem then
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "FishingSystem tidak ditemukan!",
                Duration = 3
            })
            return
        end
        
        local rodShopEvents = fishingSystem:FindFirstChild("RodShopEvents")
        if not rodShopEvents then
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "RodShopEvents tidak ditemukan!",
                Duration = 3
            })
            return
        end
        
        local requestPurchase = rodShopEvents:FindFirstChild("RequestPurchase")
        if not requestPurchase then
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "RequestPurchase remote tidak ditemukan!",
                Duration = 3
            })
            return
        end
        
        for i = 1, amount do
            local args = {rodName}
            requestPurchase:FireServer(unpack(args))
            if i % 10 == 0 or i == amount then
                print("🔥 AmbonHub🚯 - Membeli " .. rodName .. " (" .. i .. "/" .. amount .. ")")
            end
            task.wait(0.1)
        end
        
        Rayfield:Notify({
            Title = "🎣 ROD SHOP - AmbonHub🚯",
            Content = "Berhasil membeli " .. amount .. "x " .. rodName,
            Duration = 3
        })
    end)
end

local function buyAllRods(amount)
    amount = amount or rodBuyAmount
    for _, rod in ipairs(rodList) do
        buyRod(rod, amount)
        task.wait(0.5)
    end
    Rayfield:Notify({
        Title = "🎣 ROD SHOP - AmbonHub🚯",
        Content = "Semua rod (" .. amount .. " each) sudah dibeli!",
        Duration = 3
    })
end

-- Fungsi untuk mendapatkan remote event
local function getRemote(eventData)
    local remote
    if eventData.parent then
        local parent = ReplicatedStorage:FindFirstChild(eventData.parent)
        if parent then
            remote = parent:FindFirstChild(eventData.name)
        end
    else
        remote = ReplicatedStorage:FindFirstChild(eventData.name)
    end
    
    if not remote then
        remote = ReplicatedStorage:WaitForChild(eventData.name, 1)
    end
    return remote
end

-- Fungsi untuk mendapatkan args (dynamic)
local function getEventArgs(eventData)
    if type(eventData.args) == "function" then
        return eventData.args()
    else
        return eventData.args
    end
end

-- Fungsi untuk fire event
local function fireEvent(eventData)
    local remote = getRemote(eventData)
    if remote then
        pcall(function()
            if eventData.hasArgs then
                local args = getEventArgs(eventData)
                remote:FireServer(unpack(args))
            else
                remote:FireServer()
            end
        end)
    end
end

-- Fungsi untuk start spam loop
local function startSpam(eventName, delay)
    if spammers[eventName] then
        task.cancel(spammers[eventName])
        spammers[eventName] = nil
    end
    
    local eventData
    for _, e in ipairs(eventList) do
        if e.name == eventName then
            eventData = e
            break
        end
    end
    
    if not eventData then
        print("❌ Event tidak ditemukan: " .. eventName)
        return
    end
    
    spamEnabled[eventName] = true
    spamDelays[eventName] = delay or defaultDelay
    
    spammers[eventName] = task.spawn(function()
        while spamEnabled[eventName] do
            fireEvent(eventData)
            task.wait(spamDelays[eventName])
        end
    end)
    
    print("✅ Started spamming: " .. eventName .. " (delay: " .. spamDelays[eventName] .. "s)")
end

-- Fungsi untuk stop spam
local function stopSpam(eventName)
    if spammers[eventName] then
        task.cancel(spammers[eventName])
        spammers[eventName] = nil
    end
    spamEnabled[eventName] = false
    print("❌ Stopped spamming: " .. eventName)
end

-- Fungsi untuk stop semua spam
local function stopAllSpam()
    for eventName, _ in pairs(spammers) do
        if spammers[eventName] then
            task.cancel(spammers[eventName])
            spammers[eventName] = nil
        end
        spamEnabled[eventName] = false
    end
    print("🛑 All spammers stopped!")
end

-- Fungsi untuk start semua spam
local function startAllSpam(delay)
    for _, eventData in ipairs(eventList) do
        startSpam(eventData.name, delay or defaultDelay)
        task.wait(0.05)
    end
    print("🚀 All spammers started!")
end

-- ============= [ CREATE UI ] =============

local Window = Rayfield:CreateWindow({
    Name = "🔥 AMBONHUB🚯 FISHING EVENT SPAMMER",
    LoadingTitle = "Loading AmbonHub🚯 Spammer...",
    LoadingSubtitle = "by Owner: AmbonHub🚯",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonHubSpammer",
        FileName = "Settings"
    },
    KeySystem = false
})

-- Main Control Tab
local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Global Control - AmbonHub🚯")

MainTab:CreateButton({
    Name = "🚀 START ALL SPAMMERS",
    Callback = function()
        startAllSpam()
        Rayfield:Notify({
            Title = "AmbonHub🚯",
            Content = "All spammers started!",
            Duration = 2
        })
    end
})

MainTab:CreateButton({
    Name = "🛑 STOP ALL SPAMMERS",
    Callback = function()
        stopAllSpam()
        Rayfield:Notify({
            Title = "AmbonHub🚯",
            Content = "All spammers stopped!",
            Duration = 2
        })
    end
})

MainTab:CreateSlider({
    Name = "Global Delay (Seconds)",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.05,
    Flag = "GlobalDelay",
    Callback = function(Value)
        for _, eventData in ipairs(eventList) do
            if spamEnabled[eventData.name] then
                startSpam(eventData.name, Value)
            end
            spamDelays[eventData.name] = Value
        end
        Rayfield:Notify({
            Title = "AmbonHub🚯",
            Content = "Global delay set to " .. Value .. "s",
            Duration = 1
        })
    end
})

MainTab:CreateSection("Position Info - AmbonHub🚯")

-- Live position display
local posLabel = MainTab:CreateLabel("HRP Position: --")
local cfLabel = MainTab:CreateLabel("HRP Direction: --")

-- Update position info
task.spawn(function()
    while true do
        local pos = getHRPPosition()
        local cf = getHRPCFrame()
        posLabel:Set(string.format("HRP Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z))
        cfLabel:Set(string.format("HRP Direction: %.2f, %.2f, %.2f", cf.LookVector.X, cf.LookVector.Y, cf.LookVector.Z))
        task.wait(0.5)
    end
end)

-- ============= [ TELEPORT TAB ] =============

local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local TeleportSection = TeleportTab:CreateSection("Teleport Settings - AmbonHub🚯")

-- Toggle untuk smooth teleport
TeleportTab:CreateToggle({
    Name = "Smooth Teleport (Tween)",
    CurrentValue = true,
    Flag = "SmoothTeleport",
    Callback = function(Value)
        teleportTweenEnabled = Value
        Rayfield:Notify({
            Title = "AmbonHub🚯",
            Content = Value and "Smooth teleport ON" or "Instant teleport ON",
            Duration = 1
        })
    end
})

-- Slider untuk kecepatan tween
TeleportTab:CreateSlider({
    Name = "Tween Speed (Seconds)",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "TweenSpeed",
    Callback = function(Value)
        tweenSpeed = Value
    end
})

TeleportTab:CreateSection("Teleport Locations - AmbonHub🚯 (10 Locations)")

-- Buat tombol teleport untuk setiap lokasi
for locationName, position in pairs(teleportLocations) do
    TeleportTab:CreateButton({
        Name = locationName,
        Callback = function()
            teleportTo(position)
        end
    })
end

TeleportTab:CreateSection("Custom Teleport")

-- Input custom koordinat
TeleportTab:CreateInput({
    Name = "Custom Coordinates",
    PlaceholderText = "X, Y, Z (contoh: 100, 50, -200)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local coords = {}
        for num in Text:gmatch("[-]?%d+%.?%d*") do
            table.insert(coords, tonumber(num))
        end
        
        if #coords >= 3 then
            teleportTo(Vector3.new(coords[1], coords[2], coords[3]))
        else
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "Format koordinat salah! Contoh: 100, 50, -200",
                Duration = 2
            })
        end
    end
})

-- Tombol save current position
TeleportTab:CreateButton({
    Name = "💾 Save Current Position",
    Callback = function()
        local pos = getHRPPosition()
        local name = "Custom " .. os.date("%H:%M:%S")
        teleportLocations[name] = pos
        
        -- Tambah tombol baru
        TeleportTab:CreateButton({
            Name = name,
            Callback = function()
                teleportTo(pos)
            end
        })
        
        Rayfield:Notify({
            Title = "💾 Position Saved - AmbonHub🚯",
            Content = "Position saved as: " .. name,
            Duration = 3
        })
    end
})

-- ============= [ BOBBER SHOP TAB ] =============

local BobberTab = Window:CreateTab("Bobber Shop", 4483362458)
local BobberSection = BobberTab:CreateSection("Pengaturan Jumlah - AmbonHub🚯")

BobberTab:CreateInput({
    Name = "Jumlah Pembelian",
    PlaceholderText = "Contoh: 10 atau 100",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local amount = tonumber(Text)
        if amount and amount > 0 then
            bobberBuyAmount = amount
            Rayfield:Notify({
                Title = "✅ Jumlah Diatur - AmbonHub🚯",
                Content = "Akan membeli " .. amount .. " bobber setiap kali klik",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "Masukkan angka yang valid!",
                Duration = 2
            })
        end
    end
})

BobberTab:CreateLabel("Current Amount: " .. bobberBuyAmount .. " bobber(s)")

BobberTab:CreateSection("Beli Bobber - AmbonHub🚯")

BobberTab:CreateButton({
    Name = "💗 Pinked Bobber",
    Callback = function()
        buyBobber("Pinked Bobber")
    end
})

BobberTab:CreateButton({
    Name = "🔮 Crystal Bobber",
    Callback = function()
        buyBobber("Crystal Bobber")
    end
})

BobberTab:CreateButton({
    Name = "🌟 Gold Bobber",
    Callback = function()
        buyBobber("Gold Bobber")
    end
})

BobberTab:CreateSection("Buy All - AmbonHub🚯")

BobberTab:CreateButton({
    Name = "⚡ Buy All Bobbers (1 each)",
    Callback = function()
        buyAllBobbers(1)
    end
})

BobberTab:CreateButton({
    Name = "⚡⚡ Buy All Bobbers (Bulk)",
    Callback = function()
        buyAllBobbers(bobberBuyAmount)
    end
})

BobberTab:CreateSection("Quick Amount")

BobberTab:CreateButton({
    Name = "Set 10",
    Callback = function()
        bobberBuyAmount = 10
        Rayfield:Notify({
            Title = "✅ Jumlah Diatur - AmbonHub🚯",
            Content = "Akan membeli 10 bobber setiap kali klik",
            Duration = 1
        })
    end
})

BobberTab:CreateButton({
    Name = "Set 100",
    Callback = function()
        bobberBuyAmount = 100
        Rayfield:Notify({
            Title = "✅ Jumlah Diatur - AmbonHub🚯",
            Content = "Akan membeli 100 bobber setiap kali klik",
            Duration = 1
        })
    end
})

BobberTab:CreateButton({
    Name = "Set 1000",
    Callback = function()
        bobberBuyAmount = 1000
        Rayfield:Notify({
            Title = "✅ Jumlah Diatur - AmbonHub🚯",
            Content = "Akan membeli 1000 bobber setiap kali klik",
            Duration = 1
        })
    end
})

BobberTab:CreateSection("Status Remote")

local function checkBobberRemote()
    local fishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
    if fishingSystem then
        local bobberShopEvents = fishingSystem:FindFirstChild("BobberShopEvents")
        if bobberShopEvents then
            local requestPurchase = bobberShopEvents:FindFirstChild("RequestPurchase")
            if requestPurchase then
                return "✅ RequestPurchase: FOUND"
            else
                return "❌ RequestPurchase: NOT FOUND"
            end
        else
            return "❌ BobberShopEvents: NOT FOUND"
        end
    else
        return "❌ FishingSystem: NOT FOUND"
    end
end

BobberTab:CreateLabel(checkBobberRemote())

-- ============= [ ROD SHOP TAB ] =============

local RodTab = Window:CreateTab("Rod Shop", 4483362458)
local RodSection = RodTab:CreateSection("Pengaturan Jumlah - AmbonHub🚯")

RodTab:CreateInput({
    Name = "Jumlah Pembelian",
    PlaceholderText = "Contoh: 10 atau 100",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local amount = tonumber(Text)
        if amount and amount > 0 then
            rodBuyAmount = amount
            Rayfield:Notify({
                Title = "✅ Jumlah Diatur - AmbonHub🚯",
                Content = "Akan membeli " .. amount .. " rod setiap kali klik",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "❌ ERROR - AmbonHub🚯",
                Content = "Masukkan angka yang valid!",
                Duration = 2
            })
        end
    end
})

RodTab:CreateLabel("Current Amount: " .. rodBuyAmount .. " rod(s)")

RodTab:CreateSection("Beli Rod - AmbonHub🚯")

RodTab:CreateButton({
    Name = "🟣 Purple Saber",
    Callback = function()
        buyRod("Purple Saber")
    end
})

RodTab:CreateButton({
    Name = "🌍 Earthly",
    Callback = function()
        buyRod("Earthly")
    end
})

RodTab:CreateButton({
    Name = "📜 Manifest",
    Callback = function()
        buyRod("Manifest")
    end
})

RodTab:CreateButton({
    Name = "❄️ Polarized",
    Callback = function()
        buyRod("Polarized")
    end
})

RodTab:CreateButton({
    Name = "⚡ Lightning",
    Callback = function()
        buyRod("Lightning")
    end
})

RodTab:CreateButton({
    Name = "🍀 Lucky Rod",
    Callback = function()
        buyRod("Lucky Rod")
    end
})

RodTab:CreateButton({
    Name = "🌟 Gold Rod",
    Callback = function()
        buyRod("Gold Rod")
    end
})

RodTab:CreateButton({
    Name = "👼 Angelic Rod",
    Callback = function()
        buyRod("Angelic Rod")
    end
})

RodTab:CreateSection("Buy All - AmbonHub🚯")

RodTab:CreateButton({
    Name = "⚡ Buy All Rods (1 each)",
    Callback = function()
        buyAllRods(1)
    end
})

RodTab:CreateButton({
    Name = "⚡⚡ Buy All Rods (Bulk)",
    Callback = function()
        buyAllRods(rodBuyAmount)
    end
})

RodTab:CreateSection("Quick Amount")

RodTab:CreateButton({
    Name = "Set 10",
    Callback = function()
        rodBuyAmount = 10
        Rayfield:Notify({
            Title = "✅ Jumlah Diatur - AmbonHub🚯",
            Content = "Akan membeli 10 rod setiap kali klik",
            Duration = 1
        })
    end
})

RodTab:CreateButton({
    Name = "Set 100",
    Callback = function()
        rodBuyAmount = 100
        Rayfield:Notify({
            Title = "✅ Jumlah Diatur - AmbonHub🚯",
            Content = "Akan membeli 100 rod setiap kali klik",
            Duration = 1
        })
    end
})

RodTab:CreateButton({
    Name = "Set 1000",
    Callback = function()
        rodBuyAmount = 1000
        Rayfield:Notify({
            Title = "✅ Jumlah Diatur - AmbonHub🚯",
            Content = "Akan membeli 1000 rod setiap kali klik",
            Duration = 1
        })
    end
})

RodTab:CreateSection("Status Remote")

local function checkRodRemote()
    local fishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
    if fishingSystem then
        local rodShopEvents = fishingSystem:FindFirstChild("RodShopEvents")
        if rodShopEvents then
            local requestPurchase = rodShopEvents:FindFirstChild("RequestPurchase")
            if requestPurchase then
                return "✅ RequestPurchase: FOUND"
            else
                return "❌ RequestPurchase: NOT FOUND"
            end
        else
            return "❌ RodShopEvents: NOT FOUND"
        end
    else
        return "❌ FishingSystem: NOT FOUND"
    end
end

RodTab:CreateLabel(checkRodRemote())

-- ============= [ INFO TAB ] =============

local InfoTab = Window:CreateTab("Info", 4483362458)
local InfoSection = InfoTab:CreateSection("Owner - AmbonHub🚯")

InfoTab:CreateLabel("")
InfoTab:CreateLabel("👑 OWNER: AMBONHUB🚯")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("🔥 PREMIUM FISHING SPAMMER 🔥")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("📍 10 Teleport Locations Available")
InfoTab:CreateLabel("🎣 3 Bobbers Available")
InfoTab:CreateLabel("🎣 8 Rods Available")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("💎 Thanks for using AmbonHub🚯 Scripts!")
InfoTab:CreateLabel("")

-- Status update loop
task.spawn(function()
    while true do
        local activeCount = 0
        for name, enabled in pairs(spamEnabled) do
            if enabled then activeCount = activeCount + 1 end
        end
        Window:SetName("🔥 AMBONHUB🚯 SPAMMER [" .. activeCount .. " active]")
        task.wait(1)
    end
end)

-- Startup notification
Rayfield:Notify({
    Title = "🔥 AMBONHUB🚯 SPAMMER READY",
    Content = "10 Teleport Locations + Bobber Shop + Rod Shop!",
    Duration = 5
})

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔥 AMBONHUB🚯 FISHING EVENT SPAMMER LOADED")
print("👑 OWNER: AmbonHub🚯")
print("📍 TELEPORT: 10 Locations + Custom")
print("🎣 BOBBER SHOP: 3 Bobbers Available")
print("🎣 ROD SHOP: 8 Rods Available")
print("⚡ GUI: Rayfield UI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")