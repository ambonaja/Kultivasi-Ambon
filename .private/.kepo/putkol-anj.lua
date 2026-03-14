

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- // =================[ 1. FULL DATABASE ]================= //

local FishingZones = {
	["Pulau Pemuda"] = {PartName = "Pulau Pemuda", AvailableFish = {"Amberjack", "Coelocanth", "Kerapi", "Opah", "Reef Shark", "Snapper", "Tiger Muskellunge", "Whale Shark", "While BloodShack", "Nagasa Putra", "Cype Darcopink"}},
	["Laut Terbuka"] = {PartName = "Laut Terbuka", AvailableFish = {"Cobias", "Crab", "Mas Fish", "Longbill Spearfish", "Ciyup Carber", "Mujaer", "Roster Fishs", "Salmon", "Joar Cusyu", "Doplin Pink", "Doplin Blue"}},
	["Megalodon Core"] = {PartName = "Megalodon Core", AvailableFish = {"Cobias", "Crab", "Mas Fish", "Longbill Spearfish", "Ciyup Carber", "Megalodon Core", "Mujaer", "Roster Fishs", "Salmon", "Joar Cusyu", "Doplin Pink", "Doplin Blue"}},
	["King Megalodon"] = {PartName = "King Megalodon", AvailableFish = {"Cobias", "Crab", "Mas Fish", "Longbill Spearfish", "Ciyup Carber", "King Megalodon", "Mujaer", "Roster Fishs", "Salmon", "Joar Cusyu", "Doplin Pink", "Doplin Blue"}},
	["Pulau Rantau"] = {PartName = "Pulau Rantau", AvailableFish = {"Blenny", "BlueFish", "Dumbo Octopus", "Grouper", "Hammer Shark", "Jellyfish core", "Octopus", "Pompano", "Saupe Fish", "Sea Crocodile"}},
	["Pulau Esotrea"] = {PartName = "Pulau Esotrea", AvailableFish = {"Bloom", "Cadas", "Selo", "Tontatta", "Ulater Kadut", "Kurami", "Kudasay", "Gumi", "Wadas", "Wicca", "Yellowtail Barracuda", "While Bloodmon", "Cype Darcoyellow", "Amber", "Voyage", "Leviathan Core"}},
	["Merapi"] = {PartName = "Merapi", AvailableFish = {"Angler Piranha", "Ciup Cobat", "Empu", "Kawah", "King Monster", "Magma", "Pijar", "Tephra", "Ubun Ubun", "Xuzuy Care"}},
	["Pulau Echant"] = {PartName = "Pulau Echant", AvailableFish = {"Atol", "Basalt", "Granit", "Mercu", "Paus Corda", "Tanjung"}},
	["Pulau Baretam"] = {PartName = "Pulau Baretam", AvailableFish = {"Angle Fish", "Salmon Fish", "Cucup Cipung", "Red Snapper", "Isopod", "Empa Fish", "Sand Tiger Shark", "Sting Ray", "White Shark", "Cindera Fish", "Kuzjuy Shark"}},
	["Classic Core"] = {PartName = "Classic Core", AvailableFish = {"Mochi Kitty", "Leafy Bloom", "Sparkle Spike", "Bluey Polis", "Captain Fin", "Princess Bubbles", "Aqua Toaster", "Sunny Sombrero", "PutraNaga", "Kraken Moster", "Hiu Moster", "NabilaNaga", "Batu Bulat"}},
	["Carval Cristal"] = {PartName = "Carval Cristal", AvailableFish = {"Amberjack", "Coelocanth", "Kerapi", "Opah", "Reef Shark", "Snapper", "Tiger Muskellunge", "Leviatholotl", "Obsidian Snapper", "Blight Puff", "Grondar Mudscale", "Abyss Fang", "Azragon Tide"}},
	["Pulau Pasir"] = {PartName = "Pulau Pasir", AvailableFish = {"Cilik Blue", "Sultan Sirip Emas", "Azura Splash", "Bintang Cilik", "Naira Ombak", "Barakiel Fin", "Nur Delmare", "Ting Ramadhan"}},
	["Pulau Crismis"] = {PartName = "Pulau Crismis", AvailableFish = {"Lula", "Jellie", "Lala", "Blush", "Sharky", "Bluey", "Nunu", "Draco", "Lopa", "Puff Puff", "Skittles"}}
}

local FishTable = {
	{name = "Dolphin Wiliw", minKg = 520, maxKg = 650, rarity = "Secret"}, {name = "Dolphin Wheal", minKg = 520, maxKg = 650, rarity = "Secret"},
	{name = "Whale Shark", minKg = 550, maxKg = 800, rarity = "Secret"}, {name = "Snapper", minKg = 20, maxKg = 30, rarity = "Rare"},
	{name = "Kerapi", minKg = 5, maxKg = 12, rarity = "Common"}, {name = "Tiger Muskellunge", minKg = 5, maxKg = 12, rarity = "Common"},
	{name = "Coelocanth", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Opah", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Reef Shark", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Amberjack", minKg = 30, maxKg = 60, rarity = "Mitos"},
	{name = "Basalt", minKg = 5, maxKg = 12, rarity = "Common"}, {name = "Mercu", minKg = 5, maxKg = 12, rarity = "Common"},
	{name = "Tanjung", minKg = 12, maxKg = 19, rarity = "Rare"}, {name = "Atol", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Granit", minKg = 50, maxKg = 80, rarity = "Mitos"}, {name = "Paus Corda", minKg = 500, maxKg = 750, rarity = "Secret"},
	{name = "Xuzuy Care", minKg = 5, maxKg = 12, rarity = "Common"}, {name = "Kawah", minKg = 5, maxKg = 12, rarity = "Common"},
	{name = "Ubun Ubun", minKg = 20, maxKg = 30, rarity = "Rare"}, {name = "Tephra", minKg = 20, maxKg = 30, rarity = "Rare"},
	{name = "Ciup Cobat", minKg = 20, maxKg = 30, rarity = "Rare"}, {name = "Pijar", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Empu", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Magma", minKg = 50, maxKg = 80, rarity = "Mitos"},
	{name = "Angler Piranha", minKg = 50, maxKg = 100, rarity = "Mitos"}, {name = "King Monster", minKg = 500, maxKg = 750, rarity = "Secret"},
	{name = "Dumbo Octopus", minKg = 5, maxKg = 12, rarity = "Common"}, {name = "Pompano", minKg = 5, maxKg = 12, rarity = "Common"},
	{name = "Saupe Fish", minKg = 5, maxKg = 12, rarity = "Common"}, {name = "BlueFish", minKg = 5, maxKg = 12, rarity = "Common"},
	{name = "Octopus", minKg = 20, maxKg = 30, rarity = "Rare"}, {name = "Grouper", minKg = 20, maxKg = 30, rarity = "Rare"},
	{name = "Blenny", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Sea Crocodile", minKg = 50, maxKg = 100, rarity = "Mitos"},
	{name = "Hammer Shark", minKg = 500, maxKg = 750, rarity = "Secret"}, {name = "Jellyfish core", minKg = 500, maxKg = 750, rarity = "Secret"},
	{name = "Bloom", minKg = 20, maxKg = 25, rarity = "Common"}, {name = "Cadas", minKg = 20, maxKg = 30, rarity = "Rare"},
	{name = "Selo", minKg = 20, maxKg = 30, rarity = "Rare"}, {name = "Wicca", minKg = 20, maxKg = 30, rarity = "Rare"},
	{name = "Tontatta", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Ulater Kadut", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Wadas", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Yellowtail Barracuda", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Voyage", minKg = 500, maxKg = 750, rarity = "Secret"}, {name = "Amber", minKg = 500, maxKg = 750, rarity = "Secret"},
	{name = "Crab", minKg = 20, maxKg = 25, rarity = "Common"}, {name = "Mas Fish", minKg = 20, maxKg = 25, rarity = "Common"},
	{name = "Mujaer", minKg = 20, maxKg = 25, rarity = "Common"}, {name = "Salmon", minKg = 20, maxKg = 25, rarity = "Common"},
	{name = "Cobias", minKg = 20, maxKg = 30, rarity = "Rare"}, {name = "Roster Fishs", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Longbill Spearfish", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Megalodon Core", minKg = 500, maxKg = 750, rarity = "Secret"},
	{name = "Ciyup Carber", minKg = 500, maxKg = 750, rarity = "Secret"}, {name = "Empa Fish", minKg = 20, maxKg = 25, rarity = "Common"},
	{name = "Salmon Fish", minKg = 30, maxKg = 35, rarity = "Rare"}, {name = "Cucup Cipung", minKg = 30, maxKg = 35, rarity = "Rare"},
	{name = "Angle Fish", minKg = 30, maxKg = 35, rarity = "Rare"}, {name = "Red Snapper", minKg = 30, maxKg = 35, rarity = "Rare"},
	{name = "Sand Tiger Shark", minKg = 70, maxKg = 100, rarity = "Mitos"}, {name = "White Shark ", minKg = 70, maxKg = 100, rarity = "Mitos"},
	{name = "Sting Ray", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "Isopod", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Cindera Fish", minKg = 700, maxKg = 850, rarity = "Secret"}, {name = "Kuzjuy Shark", minKg = 650, maxKg = 750, rarity = "Secret"},
	{name = "Moster Kelelawar", minKg = 520, maxKg = 700, rarity = "Secret"}, {name = "Suytu Care", minKg = 510, maxKg = 660, rarity = "Secret"},
	{name = "Leviathan Core", minKg = 520, maxKg = 690, rarity = "Secret"}, {name = "Joar Cusyu", minKg = 800, maxKg = 870, rarity = "Secret"},
	{name = "While BloodShack", minKg = 520, maxKg = 690, rarity = "Secret"}, {name = "Nagasa Putra", minKg = 720, maxKg = 860, rarity = "Secret"},
	{name = "Cype Darcopink", minKg = 580, maxKg = 690, rarity = "Secret"}, {name = "Cype Darcoyellow", minKg = 580, maxKg = 690, rarity = "Secret"},
	{name = "Doplin Pink", minKg = 350, maxKg = 450, rarity = "Secret"}, {name = "Doplin Blue", minKg = 350, maxKg = 450, rarity = "Secret"},
	{name = "Kurami", minKg = 60, maxKg = 70, rarity = "Legendary"}, {name = "Kudasay", minKg = 60, maxKg = 70, rarity = "Mitos"},
	{name = "Gumi", minKg = 60, maxKg = 70, rarity = "Mitos"}, {name = "Mochi Kitty", minKg = 20, maxKg = 25, rarity = "Common"},
	{name = "Leafy Bloom", minKg = 20, maxKg = 25, rarity = "Common"}, {name = "Sparkle Spike", minKg = 20, maxKg = 25, rarity = "Common"},
	{name = "Bluey Polis", minKg = 30, maxKg = 35, rarity = "Rare"}, {name = "Captain Fin", minKg = 50, maxKg = 55, rarity = "Epic"},
	{name = "Princess Bubbles", minKg = 60, maxKg = 70, rarity = "Mitos"}, {name = "Aqua Toaster", minKg = 30, maxKg = 50, rarity = "Legendary"},
	{name = "Sunny Sombrero", minKg = 30, maxKg = 50, rarity = "Legendary"}, {name = "PutraNaga", minKg = 580, maxKg = 690, rarity = "Secret"},
	{name = "Kraken Moster", minKg = 350, maxKg = 450, rarity = "Secret"}, {name = "Hiu Moster", minKg = 350, maxKg = 450, rarity = "Secret"},
	{name = "NabilaNaga", minKg = 580, maxKg = 690, rarity = "Secret"}, {name = "Sempak Putra", minKg = 20, maxKg = 50, rarity = "Secret"},
	{name = "Kaos Kaki Putra", minKg = 80, maxKg = 90, rarity = "Secret"}, {name = "Batu Bintang", minKg = 60, maxKg = 70, rarity = "Secret"},
	{name = "Batu Bulat", minKg = 60, maxKg = 70, rarity = "Secret"}, {name = "Batu Segiempat", minKg = 60, maxKg = 70, rarity = "Secret"},
	{name = "Batu Segipanjang", minKg = 60, maxKg = 70, rarity = "Secret"}, {name = "Batu Segitiga", minKg = 60, maxKg = 70, rarity = "Secret"},
	{name = "Hiu Valentine Reds", minKg = 450, maxKg = 610, rarity = "Secret"}, {name = "Hiu Valentine Pink", minKg = 450, maxKg = 610, rarity = "Secret"},
	{name = "Leviatholotl", minKg = 100, maxKg = 150, rarity = "Mitos"}, {name = "Grondar Mudscale", minKg = 60, maxKg = 80, rarity = "Mitos"},
	{name = "Blight Puff", minKg = 390, maxKg = 410, rarity = "Secret"}, {name = "Abyss Fang", minKg = 560, maxKg = 780, rarity = "Secret"},
	{name = "Azragon Tide", minKg = 600, maxKg = 800, rarity = "Secret"}, {name = "Obsidian Snapper", minKg = 50, maxKg = 70, rarity = "Legendary"},
	{name = "Cilik Blue", minKg = 15, maxKg = 45, rarity = "Common"}, {name = "Bintang Cilik", minKg = 35, maxKg = 45, rarity = "Rare"},
	{name = "Naira Ombak", minKg = 60, maxKg = 79, rarity = "Epic"}, {name = "Azura Splash", minKg = 60, maxKg = 79, rarity = "Legendary"},
	{name = "Barakiel Fin", minKg = 660, maxKg = 780, rarity = "Secret"}, {name = "Nur Delmare", minKg = 760, maxKg = 800, rarity = "Secret"},
	{name = "Ting Ramadhan", minKg = 20, maxKg = 23, rarity = "Limited"}, {name = "Puff Puff", minKg = 15, maxKg = 45, rarity = "Common"},
	{name = "Jellie", minKg = 35, maxKg = 45, rarity = "Rare"}, {name = "Lala", minKg = 60, maxKg = 79, rarity = "Epic"},
	{name = "Skittles", minKg = 60, maxKg = 79, rarity = "Legendary"}, {name = "Sharky", minKg = 60, maxKg = 79, rarity = "Legendary"},
	{name = "Nunu", minKg = 60, maxKg = 79, rarity = "Legendary"}, {name = "Lula", minKg = 60, maxKg = 79, rarity = "Legendary"},
	{name = "Blush", minKg = 100, maxKg = 150, rarity = "Mitos"}, {name = "Bluey", minKg = 100, maxKg = 150, rarity = "Mitos"},
	{name = "Lopa", minKg = 660, maxKg = 780, rarity = "Secret"}, {name = "Draco", minKg = 760, maxKg = 800, rarity = "Secret"},
	{name = "Blood Ramadhan", minKg = 790, maxKg = 840, rarity = "Secret"}
}

local RarityOrder = {["Common"]=1, ["Uncommon"]=2, ["Rare"]=3, ["Epic"]=4, ["Legendary"]=5, ["Mitos"]=6, ["Secret"]=7, ["Limited"]=8}

local RodConfig = {
    ["Basic Rod"] = {maxRarity = "Rare", maxWeight = 50},
    ["Angelic Rod"] = {maxRarity = "Epic", maxWeight = 120},
    ["Gold Rod"] = {maxRarity = "Epic", maxWeight = 120},
    ["Lucky Rod"] = {maxRarity = "Epic", maxWeight = 150},
    ["Lightning"] = {maxRarity = "Legendary", maxWeight = 180},
    ["Polarized"] = {maxRarity = "Legendary", maxWeight = 200},
    ["Fluorescent Rod"] = {maxRarity = "Legendary", maxWeight = 220},
    ["GhostRod"] = {maxRarity = "Legendary", maxWeight = 250},
    ["Frozen Rod"] = {maxRarity = "Legendary", maxWeight = 250},
    ["LightingPunk Rod"] = {maxRarity = "Legendary", maxWeight = 280},
    ["Pirate Octopus"] = {maxRarity = "Legendary", maxWeight = 300},
    ["Aqua Prism"] = {maxRarity = "Legendary", maxWeight = 300},
    ["Flery"] = {maxRarity = "Legendary", maxWeight = 300},
    ["Loving"] = {maxRarity = "Legendary", maxWeight = 300},
    ["ZombieRod"] = {maxRarity = "Legendary", maxWeight = 300},
    ["Forsaken"] = {maxRarity = "Mitos", maxWeight = 300},
    ["Crystalized"] = {maxRarity = "Legendary", maxWeight = 300},
    ["Earthly"] = {maxRarity = "Mitos", maxWeight = 250},
    ["Manifest"] = {maxRarity = "Mitos", maxWeight = 250},
    ["Megalofriend"] = {maxRarity = "Mitos", maxWeight = 250},
    ["Purple Saber"] = {maxRarity = "Secret", maxWeight = 870},
    ["Kysmes Rod"] = {maxRarity = "Secret", maxWeight = 700},
    ["Crismes Rod"] = {maxRarity = "Secret", maxWeight = 700},
    ["Katana"] = {maxRarity = "Secret", maxWeight = 650},
    ["GuitarRod"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Corruption Edge"] = {maxRarity = "Secret", maxWeight = 650},
    ["Darci Rods"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Darco Rods"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Dragon Hole"] = {maxRarity = "Secret", maxWeight = 1650},
    ["DragonPink Hole"] = {maxRarity = "Secret", maxWeight = 1650},
    ["DragonBlue Hole"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Cyritical Pink"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Cyritical Blue"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Binary Edge"] = {maxRarity = "Secret", maxWeight = 650},
    ["Copblue x1x1x"] = {maxRarity = "Secret", maxWeight = 650},
    ["HellowenRod"] = {maxRarity = "Secret", maxWeight = 650},
    ["Crey Comunitas"] = {maxRarity = "Secret", maxWeight = 900},
    ["Sabit Snows"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Rod Kalwater"] = {maxRarity = "Secret", maxWeight = 450},
    ["Halmer Moster"] = {maxRarity = "Secret", maxWeight = 1000},
    ["Element Electricity"] = {maxRarity = "Secret", maxWeight = 1000},
    ["Megalodon Rods"] = {maxRarity = "Secret", maxWeight = 1600},
    ["Classic Rods"] = {maxRarity = "Secret", maxWeight = 1200},
    ["Element EsoGreen"] = {maxRarity = "Secret", maxWeight = 1500},
    ["Hammer Rods"] = {maxRarity = "Secret", maxWeight = 1000},
    ["Vip Rods"] = {maxRarity = "Secret", maxWeight = 1000},
    ["Astraling Rods"] = {maxRarity = "Secret", maxWeight = 1100},
    ["Kristal Rods"] = {maxRarity = "Secret", maxWeight = 1100},
    ["Hancor Hunter"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Hancor Hunterpink"] = {maxRarity = "Secret", maxWeight = 1650},
    ["Sevens Rods"] = {maxRarity = "Secret", maxWeight = 1700},
    ["Ninja Rods"] = {maxRarity = "Secret", maxWeight = 1700},
    ["Sangklut Rods"] = {maxRarity = "Secret", maxWeight = 1100},
    ["Developer Rod"] = {maxRarity = "Limited", maxWeight = 1000},
    ["Admin Rod"] = {maxRarity = "Limited", maxWeight = 5000},
    ["Owner Rod"] = {maxRarity = "Limited", maxWeight = 10000},
    ["default"] = {maxRarity = "Secret", maxWeight = 50}
}

-- Koordinat Pasti (Fix Teleport Failures)
local TeleportLocations = {
    ["Pulau Crismis"] = Vector3.new(364, 141, -2472),
    ["Pulau Echant"] = Vector3.new(1564, 140, -2966),
    ["Merapi"] = Vector3.new(2695, 149, -812),
    ["Pulau Baretam"] = Vector3.new(620, 140, 535),
    ["Megalodon Core"] = Vector3.new(-105, 138, 471),
    ["Pulau Rantau"] = Vector3.new(-823, 137, 993),
    ["Pulau Esotrea"] = Vector3.new(-1201, 141, -406),
    ["King Megalodon"] = Vector3.new(-551, 143, -935),
    ["Pulau Pasir"] = Vector3.new(-650, 132, -1804),
    ["Pulau Pemuda"] = Vector3.new(710, 145, -729), -- Original Backup
    ["Laut Terbuka"] = Vector3.new(100, 135, 100), -- Original Backup
    ["Carval Cristal"] = Vector3.new(-24, 140, 0) -- Based on Kuil logs backup
}

-- Ikan Prioritas Quest (Diambil dari Screenshot)
local QuestPriorityFish = {
    "Whale Shark",
    "Leviathan Core",
    "Azragon Tide",
    "Hammer Shark",
    "Abyss Fang",
    "Paus Corda",
    "King Monster",
    "Doplin Pink",
    "Ting Ramadhan" -- Bonus event ramadhan
}

-- // =================[ 2. (ANTI-BAN LOGIC) ]================= //

local Settings = {
    AutoFarm = false, 
    HumanizeDelay = true,
    TargetRarity = "All",
    AutoQuest = false,
    AutoSell = false,
    AntiAfk = true
}

local lastWarning = ""

-- Mengambil Joran di Tangan
local function GetEquippedRod()
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool.Name end
    end
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if string.find(item.Name, "Rod") or RodConfig[item.Name] then 
            return item.Name 
        end
    end
    return "Basic Rod"
end

-- Deteksi Zona Akurat berdasarkan Koordinat Radius (Pencegah Banned 267)
local function GetCurrentZone()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return "Laut Terbuka" end
    local pos = char.HumanoidRootPart.Position

    -- Cek menggunakan jarak absolut dari waypoint teleport yang pasti valid
    for zoneName, coords in pairs(TeleportLocations) do
        if (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(coords.X, 0, coords.Z)).Magnitude < 250 then
            return zoneName
        end
    end
    
    return "Laut Terbuka" -- Fallback aman
end

-- Hitung Posisi Lemparan Joran Dinamis
local function GetDynamicWaterPosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local randomDistance = math.random(150, 250) / 10 
        local randomSide = math.random(-50, 50) / 10
        return hrp.Position + (hrp.CFrame.LookVector * randomDistance) + (hrp.CFrame.RightVector * randomSide) - Vector3.new(0, hrp.Position.Y - 130, 0)
    end
    return Vector3.new(795.5, 128.1, -904.3)
end

-- AUTO QUEST & SAFE FISH LOGIC
local function GetSafeFish(zoneName, equippedRod)
    local zoneData = FishingZones[zoneName] or FishingZones["Laut Terbuka"]
    local rodData = RodConfig[equippedRod] or RodConfig["default"]
    local rodMaxRarityNum = RarityOrder[rodData.maxRarity] or 8
    local rodMaxWeight = rodData.maxWeight or 50
    
    local possibleFishes = {}
    local questFishes = {}
    
    for _, fishName in ipairs(zoneData.AvailableFish) do
        for _, fishInfo in ipairs(FishTable) do
            if fishInfo.name == fishName then
                local fishRarityNum = RarityOrder[fishInfo.rarity] or 1
                
                -- VALIDASI KETAT ANTI BANNED:
                if fishRarityNum <= rodMaxRarityNum and rodMaxWeight >= fishInfo.minKg then
                    
                    -- Kumpulkan Ikan Misi jika Auto Quest ON
                    if Settings.AutoQuest then
                        for _, qName in ipairs(QuestPriorityFish) do
                            if fishInfo.name == qName then
                                table.insert(questFishes, fishInfo)
                            end
                        end
                    end

                    -- Kumpulkan Ikan Biasa sesuai Rarity Sniper
                    if Settings.TargetRarity == "All" or Settings.TargetRarity == fishInfo.rarity then
                        table.insert(possibleFishes, fishInfo)
                    end
                end
                break
            end
        end
    end

    -- 1. PRIORITAS AUTO QUEST
    if Settings.AutoQuest and #questFishes > 0 then
        return questFishes[math.random(1, #questFishes)]
    end

    -- 2. PRIORITAS SNIPER NORMAL
    if #possibleFishes > 0 then
        return possibleFishes[math.random(1, #possibleFishes)]
    end

    -- 3. JIKA GAGAL SEMUA (Joran tidak kuat / Zona Salah) -> TANGKAP IKAN TUMBAL
    if Settings.TargetRarity ~= "All" or Settings.AutoQuest then
        local msg = "⚠️ GAGAL SNIPE/QUEST: Joran ["..equippedRod.."] tidak kuat ATAU Ikan tidak ada di ["..zoneName.."]."
        if lastWarning ~= msg then
            Rayfield:Notify({Title = "Anti-Ban System", Content = msg, Duration = 5})
            lastWarning = msg
        end
    end
    
    -- Ikan Tumbal (Common) agar loop pancing tidak putus dan tidak dicurigai server
    local safeName = zoneData.AvailableFish[1] or "Kerapi"
    for _, f in ipairs(FishTable) do
        if f.name == safeName then return f end
    end
    return {name = "Kerapi", rarity = "Common", minKg = 5, maxKg = 12}
end

-- Algoritma Berat Ikan
local function CalculateSafeWeight(minKg, maxKg, rodMaxWeight)
    local actualMax = math.min(maxKg, rodMaxWeight)
    if actualMax <= minKg then return minKg end
    local rawWeight = minKg + (math.random() * (actualMax - minKg))
    return math.floor(rawWeight * 10) / 10
end

-- // =================[ 3. LOOPERS & ANTI-AFK ]================= //

-- Memisahkan loop agar eksekusi memancing tidak lag
task.spawn(function()
    while task.wait(5) do
        if Settings.AutoFarm then
            pcall(function()
                for i = 1, 8 do
                    local eventName = "QuestEvents" .. (i == 1 and "" or tostring(i))
                    local remote = ReplicatedStorage:FindFirstChild(eventName)
                    if remote then remote:FireServer("GetQuests") end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(30) do 
        if Settings.AutoSell then
            pcall(function()
                local invData = ReplicatedStorage.GetPlayerInventory:InvokeServer("GetAllFish")
                if invData and invData.fish and #invData.fish > 0 then
                    local batch = {}
                    for _, f in ipairs(invData.fish) do
                        table.insert(batch, {name = f.name, weight = f.weight, rarity = f.rarity, fishId = f.uniqueId})
                    end
                    ReplicatedStorage.FishingSystem.SellFish:FireServer("SellAllBatch", batch)
                end
            end)
        end
    end
end)

-- Anti AFK Server Kick Bypass
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAfk then
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

-- // =================[ 4. USER INTERFACE RAYFIELD ]================= //

local Window = Rayfield:CreateWindow({
    Name = "Ambonhub🚯 V12 | PUTRA KONTOL",
    LoadingTitle = "Loading sedang mengakses Puthol...",
    LoadingSubtitle = "V12 AmbonHub🚯 Active",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false,
})

local TabFarm = Window:CreateTab("Safe Farm", 4483362458)
local TabTeleport = Window:CreateTab("Teleport", 4483362458)
local TabHack = Window:CreateTab("Exploits", 4483362458)

-- [ TAB: AUTO FARM ]
TabFarm:CreateSection("Quest & Snipe (Anti-Ban Enabled)")

TabFarm:CreateToggle({
    Name = "Enable AUTO QUEST Mode",
    CurrentValue = false,
    Callback = function(Value)
        Settings.AutoQuest = Value
        if Value then
            Rayfield:Notify({Title = "Auto Quest", Content = "Hanya akan menangkap ikan Misi jika ada di Zona ini!"})
        end
    end,
})

TabFarm:CreateDropdown({
    Name = "Target Rarity",
    Options = {"All", "Common", "Rare", "Epic", "Legendary", "Mitos", "Secret", "Limited"},
    CurrentOption = {"All"},
    Flag = "RaritySniper",
    Callback = function(Opt)
        Settings.TargetRarity = Opt[1]
    end,
})

TabFarm:CreateToggle({
    Name = "START AUTO FARM",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        Settings.AutoFarm = Value
        
        task.spawn(function()
            while Settings.AutoFarm do
                pcall(function()
                    if not LocalPlayer.Character then task.wait(2) return end
                    
                    local rodName = GetEquippedRod()
                    local currentZone = GetCurrentZone()
                    local targetPos = GetDynamicWaterPosition()
                    
                    local targetFish = GetSafeFish(currentZone, rodName)
                    local rodMaxWt = (RodConfig[rodName] or RodConfig["default"]).maxWeight
                    local finalWeight = CalculateSafeWeight(targetFish.minKg, targetFish.maxKg, rodMaxWt)
                    
                    -- Dynamic Checksum
                    local fakeCs = math.random(500, 3500)
                    
                    -- [ SEQUENCE 1: CASTING ]
                    ReplicatedStorage.StatusLemparUmpan1:FireServer()
                    ReplicatedStorage.FishingSystem.CastReplication:FireServer(targetPos, Vector3.new(1.2, 5, -25), rodName, math.random(90, 100))
                    
                    -- *ANTI-BAN WAIT 1* (Tunggu umpan dimakan)
                    if Settings.HumanizeDelay then task.wait(math.random(20, 35) / 10) else task.wait(0.5) end
                    
                    -- [ SEQUENCE 2: MINIGAME ]
                    ReplicatedStorage.statusrod:FireServer(finalWeight)
                    ReplicatedStorage.RequestMinigameEvent:FireServer()
                    ReplicatedStorage.StatusLemparUmpan2:FireServer()
                    
                    -- *ANTI-BAN WAIT 2* (Durasi minigame berdasar rarity)
                    if Settings.HumanizeDelay then
                        local rarityDelay = RarityOrder[targetFish.rarity] or 1
                        task.wait(1.5 + (rarityDelay * 0.5)) 
                    else
                        task.wait(0.5)
                    end
                    
                    -- [ SEQUENCE 3: FINISHING MINIGAME & SYNC ]
                    ReplicatedStorage.ShowRarityExclamation:FireServer(targetFish.rarity)
                    ReplicatedStorage.data:FireServer()
                    ReplicatedStorage.ShowRarityExclamations:FireServer()
                    ReplicatedStorage.playersdata:FireServer()
                    ReplicatedStorage.datarod:FireServer("rod")
                    
                    task.wait(0.2)
                    
                    -- [ SEQUENCE 4: CATCHING ]
                    ReplicatedStorage.FishingSystem.CleanupCast:FireServer()
                    ReplicatedStorage.FishingCatchSuccess:FireServer()
                    
                    -- [ SEQUENCE 5: THE FINAL PAYLOAD ]
                    local payload = {
                        [1] = {
                            hookPosition = targetPos,
                            name = targetFish.name,
                            weight = finalWeight,
                            cs = fakeCs,
                            rarity = targetFish.rarity
                        }
                    }
                    ReplicatedStorage.FishingSystem.codedata:FireServer(unpack(payload))
                    
                    -- Broadcast tangkapan agar terlihat real
                    pcall(function()
                        ReplicatedStorage.FishingSystem.GlobalFishAnimationEvent:FireServer(targetFish.name, targetFish.rarity)
                    end)
                    
                    -- *ANTI-BAN WAIT 3* (Jeda sebelum lempar lagi. Secret butuh istirahat lama agar tidak auto-kick 267) WAJIB CUKI
                    if Settings.HumanizeDelay then 
                        if targetFish.rarity == "Secret" or targetFish.rarity == "Mitos" then
                            task.wait(math.random(50, 100) / 10) -- Tunggu 5-10 detik
                        else
                            task.wait(math.random(15, 25) / 10) 
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end,
})

TabFarm:CreateToggle({
    Name = "Jamu kuat Aman dan tahan lama (WAJIB ON)",
    CurrentValue = true,
    Callback = function(Value) Settings.HumanizeDelay = Value end,
})

TabFarm:CreateToggle({
    Name = "Auto Sell Batch (Per 30 Detik)",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoSell = Value end,
})

-- [ TAB: TELEPORTASI ]
TabTeleport:CreateSection("Titik Koordinat Pasti (Safe TP)")

for locName, coords in pairs(TeleportLocations) do
    TabTeleport:CreateButton({
        Name = "Teleport: " .. locName,
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Teleport dengan gaya aman
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(coords) + Vector3.new(0, 5, 0)
                Rayfield:Notify({Title = "Teleported", Content = "Menuju: " .. locName})
            end
        end,
    })
end

-- [ TAB: ADMIN EXPLOITS ]
TabHack:CreateSection("Server Vulnerabilities")

TabHack:CreateButton({
    Name = "Execute Admin Luck Boost (Bug)",
    Callback = function()
        pcall(function()
            ReplicatedStorage.AdminLuckBoostEvent:FireServer()
            ReplicatedStorage.AdminLuckCommand:FireServer()
            Rayfield:Notify({Title = "Exploit", Content = "Admin Luck Command Sent!"})
        end)
    end,
})

TabHack:CreateButton({
    Name = "🛑 Trigger Admin Sell Performance",
    Callback = function()
        pcall(function()
            ReplicatedStorage.AdminSellPerformance:InvokeServer()
            Rayfield:Notify({Title = "Exploit", Content = "Sell Performance Triggered"})
        end)
    end,
})

Rayfield:Notify({
    Title = "AmbonHub🚯 V12 Loaded",
    Content = "Putra Galeri Telah aktif!.",
    Duration = 5,
    Image = 4483362458,
})