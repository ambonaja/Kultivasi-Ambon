--[[
    [ SUMMER AI 🌀 ] AUTO SELL - MULTI FORMAT TEST
    BY: PEMBUAT ONAR | AmbonHub
    COBA BEBERAPA FORMAT SEKALIGUS
]]

-- Load Rayfield dengan pengamanan
local Rayfield = nil
pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not Rayfield then
    pcall(function()
        Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    end)
end

-- Fallback manual
if not Rayfield then
    Rayfield = {
        CreateWindow = function() return { CreateTab = function() return {} end } end,
        Notify = function(_, data) print("🔔 " .. (data.Content or "")) end
    }
end

task.wait(0.5)

-- Buat Window
local Window = nil
pcall(function() Window = Rayfield:CreateWindow({
    Name = "AmbonHub🚯 Multi Format",
    LoadingTitle = "Testing Multiple Formats",
    LoadingSubtitle = "by AmbonHub",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
}) end)

if not Window then
    Window = { CreateTab = function() return {} end }
end

-- ============= [ VARIABEL GLOBAL ] =============

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============= [ FUNGSI FIND REMOTE ] =============

local function findFishingSystem()
    local possibleNames = {
        "FishingSystem", "Fishing", "FishSystem", "FishingService", 
        "Fish", "Fisher", "FishingGame", "FishingRemote"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = ReplicatedStorage:FindFirstChild(name)
        if found then
            print("✅ FishingSystem ditemukan dengan nama: " .. name)
            return found
        end
    end
    
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child.Name:lower():find("fish") or child.Name:lower():find("fishing") then
            print("🔍 FishingSystem mirip: " .. child.Name)
            return child
        end
    end
    
    return nil
end

local function findSellRemote(fishingSystem)
    if not fishingSystem then return nil end
    
    local possibleNames = {
        "SellFish", "Sell", "FishSell", "SellRemote",
        "SellFishRemote", "FishSold", "SellItem", "SellTool"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = fishingSystem:FindFirstChild(name)
        if found then
            print("✅ Sell remote ditemukan dengan nama: " .. name)
            return found
        end
    end
    
    for _, child in ipairs(fishingSystem:GetChildren()) do
        if child.Name:lower():find("sell") or child.Name:lower():find("jual") then
            print("🔍 Sell remote mirip: " .. child.Name)
            return child
        end
    end
    
    return nil
end

local function findInventoryEvents(fishingSystem)
    if not fishingSystem then return nil end
    
    local possibleNames = {
        "InventoryEvents", "Inventory", "InvEvents",
        "InventorySystem", "PlayerInventory", "InventoryService"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = fishingSystem:FindFirstChild(name)
        if found then
            print("✅ InventoryEvents ditemukan dengan nama: " .. name)
            return found
        end
    end
    
    for _, child in ipairs(fishingSystem:GetChildren()) do
        if child.Name:lower():find("inventory") or child.Name:lower():find("inv") then
            print("🔍 Inventory mirip: " .. child.Name)
            return child
        end
    end
    
    return nil
end

local function findEquipRemote(inventoryEvents)
    if not inventoryEvents then return nil end
    
    local possibleNames = {
        "Inventory_EquipFish", "EquipFish", "Equip",
        "EquipRemote", "FishEquip", "Inventory_Equip"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = inventoryEvents:FindFirstChild(name)
        if found then
            print("✅ Equip remote ditemukan dengan nama: " .. name)
            return found
        end
    end
    
    for _, child in ipairs(inventoryEvents:GetChildren()) do
        if child.Name:lower():find("equip") or child.Name:lower():find("pakai") then
            print("🔍 Equip remote mirip: " .. child.Name)
            return child
        end
    end
    
    return nil
end

-- ============= [ INIT REMOTE ] =============

print("🔍 Mencari remotes dengan Find First Child...")

local FishingSystem = findFishingSystem()
local SellFish = FishingSystem and findSellRemote(FishingSystem)
local InventoryEvents = FishingSystem and findInventoryEvents(FishingSystem)
local EquipFish = InventoryEvents and findEquipRemote(InventoryEvents)

-- ============= [ SETTINGS ] =============

local Settings = {
    AutoSellEnabled = false,
    AutoSellDelay = 0.5,
    MinRarity = "Common",
    EquipAfterSell = true,
    FishingSystem = FishingSystem,
    SellFish = SellFish,
    EquipFish = EquipFish,
    -- Pilih format yang mau dipake
    SellFormat = 1 -- 1,2,3,4
}

local Stats = {
    Sold = 0,
    TotalValue = 0
}

-- ============= [ FUNGSI GET FISH ID ] =============

local function getFishIdFromTool(tool)
    if not tool then return nil end
    
    if tool:FindFirstChild("fishId") then
        return tool.fishId.Value
    elseif tool:FindFirstChild("FishId") then
        return tool.FishId.Value
    elseif tool:FindFirstChild("id") then
        return tool.id.Value
    elseif tool:FindFirstChild("ID") then
        return tool.ID.Value
    end
    
    if tool:GetAttribute("fishId") then
        return tool:GetAttribute("fishId")
    elseif tool:GetAttribute("id") then
        return tool:GetAttribute("id")
    end
    
    return nil
end

local function getCurrentEquippedFish()
    local success, result = pcall(function()
        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                return getFishIdFromTool(tool)
            end
        end
    end)
    return success and result or nil
end

-- ============= [ FUNGSI GET INVENTORY ] =============

local function getInventoryFish()
    local fishList = {}
    pcall(function()
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local fishId = getFishIdFromTool(child)
                    if fishId then
                        table.insert(fishList, {
                            fishId = fishId,
                            rarity = child:GetAttribute("rarity") or "Common",
                            tool = child
                        })
                    end
                end
            end
        end
    end)
    return fishList
end

-- ============= [ FUNGSI EQUIP FISH ] =============

local function equipFish(fishId)
    if not EquipFish then return end
    
    pcall(function()
        local args = { fishId }
        EquipFish:FireServer(unpack(args))
    end)
end

-- ============= [ FUNGSI SELL FISH - MULTI FORMAT ] =============

local function sellFish(fishData)
    if not SellFish then return end
    
    pcall(function()
        -- WEIGHT GEDE (number biasa kayak contoh)
        local bigWeight = 999999999999999999999999999999
        
        -- Coba berbagai format
        local success = false
        local lastError = ""
        
        -- FORMAT 1: Persis kayak contoh lo
        local format1 = {
            "SellSingle",
            {
                fishId = fishData.fishId,
                rarity = fishData.rarity or "Legendary",
                weight = bigWeight
            }
        }
        
        -- FORMAT 2: Pake string untuk "SellSingle"
        local format2 = {
            [1] = "SellSingle",
            [2] = {
                fishId = fishData.fishId,
                rarity = fishData.rarity or "Legendary",
                weight = bigWeight
            }
        }
        
        -- FORMAT 3: Tanpa "SellSingle"
        local format3 = {
            fishId = fishData.fishId,
            rarity = fishData.rarity or "Legendary",
            weight = bigWeight
        }
        
        -- FORMAT 4: Pake "Sell" instead of "SellSingle"
        local format4 = {
            "Sell",
            {
                fishId = fishData.fishId,
                rarity = fishData.rarity or "Legendary",
                weight = bigWeight
            }
        }
        
        -- Coba FORMAT 1 dulu
        pcall(function()
            SellFish:FireServer(unpack(format1))
            success = true
            print("✅ Format 1 work: " .. fishData.fishId)
        end)
        
        -- Kalo format 1 gagal, coba format 2
        if not success then
            pcall(function()
                SellFish:FireServer(unpack(format2))
                success = true
                print("✅ Format 2 work: " .. fishData.fishId)
                Settings.SellFormat = 2
            end)
        end
        
        -- Kalo format 2 gagal, coba format 3
        if not success then
            pcall(function()
                SellFish:FireServer(unpack(format3))
                success = true
                print("✅ Format 3 work: " .. fishData.fishId)
                Settings.SellFormat = 3
            end)
        end
        
        -- Kalo format 3 gagal, coba format 4
        if not success then
            pcall(function()
                SellFish:FireServer(unpack(format4))
                success = true
                print("✅ Format 4 work: " .. fishData.fishId)
                Settings.SellFormat = 4
            end)
        end
        
        if success then
            Stats.Sold = Stats.Sold + 1
            
            if Rayfield and Rayfield.Notify then
                Rayfield:Notify({
                    Title = "SOLD 💰",
                    Content = "Ikan ke-" .. Stats.Sold .. " terjual! (Format " .. Settings.SellFormat .. ")",
                    Duration = 1
                })
            end
        else
            print("❌ Gagal jual ikan: " .. fishData.fishId)
            if Rayfield and Rayfield.Notify then
                Rayfield:Notify({
                    Title = "GAGAL ❌",
                    Content = "Ikan gak kejual! Cek format",
                    Duration = 2
                })
            end
        end
    end)
end

-- ============= [ RARITY CHECK ] =============

local rarityLevel = {
    ["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3,
    ["Epic"] = 4, ["Legendary"] = 5, ["Mythic"] = 6
}

local function shouldSell(fishData)
    local minLevel = rarityLevel[Settings.MinRarity] or 1
    local fishLevel = rarityLevel[fishData.rarity] or 0
    return fishLevel >= minLevel
end

-- ============= [ MAIN LOOP ] =============

task.spawn(function()
    while true do
        if Settings.AutoSellEnabled then
            pcall(function()
                local equippedId = getCurrentEquippedFish()
                local inventory = getInventoryFish()
                local soldCount = 0
                
                for _, fishData in ipairs(inventory) do
                    if fishData.fishId ~= equippedId and shouldSell(fishData) then
                        sellFish(fishData)
                        soldCount = soldCount + 1
                        task.wait(Settings.AutoSellDelay)
                    end
                end
                
                if soldCount > 0 then
                    print("🔄 Sesi jual: " .. soldCount .. " ikan")
                end
            end)
        end
        task.wait(2)
    end
end)

-- ============= [ UI TAB ] =============

pcall(function()
    local MainTab = Window:CreateTab("💰 AUTO SELL", 4483362458)
    MainTab:CreateSection("PENGATURAN")
    
    MainTab:CreateToggle({
        Name = "Aktifkan Auto Sell",
        CurrentValue = false,
        Flag = "MainToggle",
        Callback = function(v) Settings.AutoSellEnabled = v end
    })
    
    MainTab:CreateDropdown({
        Name = "Minimal Rarity",
        Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},
        CurrentOption = "Common",
        Flag = "RarityDropdown",
        Callback = function(o) Settings.MinRarity = o end
    })
    
    MainTab:CreateSlider({
        Name = "Delay",
        Range = {0.1, 2},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = 0.5,
        Flag = "DelaySlider",
        Callback = function(v) Settings.AutoSellDelay = v end
    })
    
    MainTab:CreateDropdown({
        Name = "Pilih Format (Auto Detect)",
        Options = {"Format 1 (Default)", "Format 2", "Format 3", "Format 4", "Auto Detect"},
        CurrentOption = "Auto Detect",
        Flag = "FormatDropdown",
        Callback = function(o)
            if o == "Format 1 (Default)" then
                Settings.SellFormat = 1
            elseif o == "Format 2" then
                Settings.SellFormat = 2
            elseif o == "Format 3" then
                Settings.SellFormat = 3
            elseif o == "Format 4" then
                Settings.SellFormat = 4
            else
                Settings.SellFormat = 0 -- auto
            end
        end
    })
    
    local StatusTab = Window:CreateTab("📊 STATUS", 4483362458)
    StatusTab:CreateSection("REMOTE STATUS")
    
    StatusTab:CreateLabel(FishingSystem and "✅ FishingSystem: OK" or "❌ FishingSystem: Tidak ada")
    StatusTab:CreateLabel(SellFish and "✅ SellFish: OK" or "❌ SellFish: Tidak ada")
    StatusTab:CreateLabel(EquipFish and "✅ EquipFish: OK" or "❌ EquipFish: Tidak ada")
    
    StatusTab:CreateSection("DEBUG INFO")
    
    local FormatLabel = StatusTab:CreateLabel("Format Aktif: Auto Detect")
    local SoldLabel = StatusTab:CreateLabel("Ikan Terjual: 0")
    
    task.spawn(function()
        while true do
            if Settings.AutoSellEnabled then
                SoldLabel:Set("Ikan Terjual: " .. Stats.Sold)
                if Settings.SellFormat == 0 then
                    FormatLabel:Set("Format Aktif: Auto Detect")
                else
                    FormatLabel:Set("Format Aktif: " .. Settings.SellFormat)
                end
            end
            task.wait(1)
        end
    end)
    
    -- Tombol test manual
    StatusTab:CreateSection("TEST MANUAL")
    
    StatusTab:CreateButton({
        Name = "🔄 TEST FORMAT 1",
        Callback = function()
            local fishId = getCurrentEquippedFish()
            if fishId then
                print("🧪 Test format 1 dengan fish: " .. fishId)
                pcall(function()
                    local args = {
                        "SellSingle",
                        {
                            fishId = fishId,
                            rarity = "Legendary",
                            weight = 999999999999999999999999999999
                        }
                    }
                    SellFish:FireServer(unpack(args))
                    Rayfield:Notify({ Title = "TEST", Content = "Format 1 dicoba", Duration = 2 })
                end)
            end
        end
    })
    
    StatusTab:CreateButton({
        Name = "🔄 TEST FORMAT 2",
        Callback = function()
            local fishId = getCurrentEquippedFish()
            if fishId then
                print("🧪 Test format 2 dengan fish: " .. fishId)
                pcall(function()
                    local args = {
                        [1] = "SellSingle",
                        [2] = {
                            fishId = fishId,
                            rarity = "Legendary",
                            weight = 999999999999999999999999999999
                        }
                    }
                    SellFish:FireServer(unpack(args))
                    Rayfield:Notify({ Title = "TEST", Content = "Format 2 dicoba", Duration = 2 })
                end)
            end
        end
    })
end)

-- Notifikasi
if Rayfield and Rayfield.Notify then
    Rayfield:Notify({
        Title = "SUMMER AI 🌀",
        Content = "Multi Format Version - Cek console untuk hasil test",
        Duration = 4
    })
end

print("🔥 MULTI FORMAT VERSION JALAN!")
print("🔍 FishingSystem:", FishingSystem and "✅" or "❌")
print("🔍 SellFish:", SellFish and "✅" or "❌")
print("🔍 EquipFish:", EquipFish and "✅" or "❌")
print("📝 Script akan coba 4 format berbeda")