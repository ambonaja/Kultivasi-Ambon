--[[
  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃                                                                                  ┃
  ┃    ░█████╗░███╗░░░███╗██████╗░░█████╗░███╗░░██╗██╗░░██╗██╗░░░██╗██████╗░       ┃
  ┃    ██╔══██╗████╗░████║██╔══██╗██╔══██╗████╗░██║██║░░██║██║░░░██║██╔══██╗       ┃
  ┃    ███████║██╔████╔██║██████╦╝██║░░██║██╔██╗██║███████║██║░░░██║██████╦╝       ┃
  ┃    ██╔══██║██║╚██╔╝██║██╔══██╗██║░░██║██║╚████║██╔══██║██║░░░██║██╔══██╗       ┃
  ┃    ██║░░██║██║░╚═╝░██║██████╦╝╚█████╔╝██║░╚███║██║░░██║╚██████╔╝██████╦╝       ┃
  ┃    ╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░╚═════╝░       ┃
  ┃                                                                                  ┃
  ┃                    [ AMBONHUB🚯 ] - FISHING EXPLOIT ULTIMATE                    ┃
  ┃                    ─────────────────────────────────────────────                 ┃
  ┃                    OWNER  : AmbonHub🚯                                          ┃
  ┃                    CREDIT : PEMBUAT ONAR                                        ┃
  ┃                    VERSION : 9.9.9 (AMBONHUB EDITION)                           ┃
  ┃                    WEIGHT : 9999999                                             ┃
  ┃                                                                                  ┃
  ┃                    "TIDAK BERMORAL, TIDAK BERPERIKEMANUSIAAN"                  ┃
  ┃                                                                                  ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
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

-- Buat Window dengan WATERMARK AmbonHub🚯
local Window = nil
pcall(function() Window = Rayfield:CreateWindow({
    Name = "AMBONHUB🚯 | ULTIMATE FISHING",
    LoadingTitle = "AMBONHUB🚯 PRESENTS",
    LoadingSubtitle = "FISHING EXPLOIT v9.9.9",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
}) end)

if not Window then
    Window = { CreateTab = function() return {} end }
end

-- ============= [ CREDIT & OWNER ] =============
local OWNER = "AmbonHub🚯"
local CREATOR = "PEMBUAT ONAR"
local VERSION = "9.9.9"
local BIG_WEIGHT = 9999999

print([[
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                                                                  ┃
┃    ░█████╗░███╗░░░███╗██████╗░░█████╗░███╗░░██╗██╗░░██╗██╗░░░██╗██████╗░       ┃
┃    ██╔══██╗████╗░████║██╔══██╗██╔══██╗████╗░██║██║░░██║██║░░░██║██╔══██╗       ┃
┃    ███████║██╔████╔██║██████╦╝██║░░██║██╔██╗██║███████║██║░░░██║██████╦╝       ┃
┃    ██╔══██║██║╚██╔╝██║██╔══██╗██║░░██║██║╚████║██╔══██║██║░░░██║██╔══██╗       ┃
┃    ██║░░██║██║░╚═╝░██║██████╦╝╚█████╔╝██║░╚███║██║░░██║╚██████╔╝██████╦╝       ┃
┃    ╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░╚═════╝░       ┃
┃                                                                                  ┃
┃                    [ AMBONHUB🚯 ] - FISHING EXPLOIT ULTIMATE                    ┃
┃                    ─────────────────────────────────────────────                 ┃
┃                    OWNER  : AmbonHub🚯                                          ┃
┃                    CREDIT : PEMBUAT ONAR                                        ┃
┃                    VERSION : 9.9.9 (AMBONHUB EDITION)                           ┃
┃                    WEIGHT : 9999999                                             ┃
┃                                                                                  ┃
┃                    "TIDAK BERMORAL, TIDAK BERPERIKEMANUSIAAN"                  ┃
┃                                                                                  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
]])

-- ============= [ VARIABEL GLOBAL ] =============

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- WEIGHT GILA
local BIG_WEIGHT = 9999999

-- Settings
local Settings = {
    AutoSell = false,
    AutoEquip = false,
    AutoBuyTotem = false,
    SellDelay = 0.5,
    EquipDelay = 0.3,
    BuyDelay = 1,
    MinRarity = "Common",
    SelectedTotem = "Luck Totem",
    SellFormat = 0,
    UseGetData = true,
}

-- Stats
local Stats = {
    Sold = 0,
    TotalValue = 0,
    Method = "Unknown"
}

-- Remote storage
local Remotes = {
    FishingSystem = nil,
    SellFish = nil,
    EquipFish = nil,
    GetData = nil,
    BuyTotem = nil
}

-- Inventory storage
local MyFish = {}

-- ============= [ FUNGSI FIND REMOTE ] =============

local function findFishingSystem()
    local possibleNames = {
        "FishingSystem", "Fishing", "FishSystem", "FishingService", 
        "Fish", "Fisher", "FishingGame", "FishingRemote"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = ReplicatedStorage:FindFirstChild(name)
        if found then
            print("✅ FishingSystem: " .. name)
            return found
        end
    end
    
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child.Name:lower():find("fish") then
            print("🔍 FishingSystem mirip: " .. child.Name)
            return child
        end
    end
    
    return nil
end

local function findEvents(fishingSystem)
    if not fishingSystem then return nil end
    
    local possibleNames = {
        "FishingSystemEvents", "Events", "Remotes", "SystemEvents",
        "FishingEvents", "RemoteEvents", "System", "Main"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = fishingSystem:FindFirstChild(name)
        if found then
            print("✅ Events: " .. name)
            return found
        end
    end
    
    return fishingSystem
end

local function findSellRemote(events)
    if not events then return nil end
    
    local possibleNames = {
        "SellFish", "Sell", "FishSell", "SellRemote",
        "SellFishRemote", "FishSold", "SellItem", "SellTool",
        "RequestSell", "SellSingle"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = events:FindFirstChild(name)
        if found then
            print("✅ SellRemote: " .. name)
            return found
        end
    end
    
    return nil
end

local function findEquipRemote(events)
    if not events then return nil end
    
    local possibleNames = {
        "Inventory_EquipFish", "EquipFish", "Equip",
        "EquipRemote", "FishEquip", "Inventory_Equip",
        "EquipTool", "EquipItem"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = events:FindFirstChild(name)
        if found then
            print("✅ EquipRemote: " .. name)
            return found
        end
    end
    
    return nil
end

local function findGetDataRemote(events)
    if not events then return nil end
    
    local possibleNames = {
        "Inventory_GetData", "GetData", "GetInventory",
        "InventoryData", "GetFishData", "GetPlayerData",
        "RequestInventory", "FetchInventory"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = events:FindFirstChild(name)
        if found then
            print("✅ GetDataRemote: " .. name)
            return found
        end
    end
    
    return nil
end

local function findTotemShop()
    local possibleNames = {
        "TotemShop", "Totem", "Shop", "TotemSystem",
        "TotemService", "ShopSystem", "Store"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = ReplicatedStorage:FindFirstChild(name)
        if found then
            print("✅ TotemShop: " .. name)
            return found
        end
    end
    
    return nil
end

local function findBuyTotemRemote(shop)
    if not shop then return nil end
    
    local possibleNames = {
        "Shop_BuyTotem", "BuyTotem", "PurchaseTotem",
        "Buy", "Purchase", "TotemPurchase", "ShopEvents"
    }
    
    local shopEvents = shop:FindFirstChild("ShopEvents") or shop
    
    for _, name in ipairs(possibleNames) do
        local found = shopEvents:FindFirstChild(name)
        if found then
            print("✅ BuyTotemRemote: " .. name)
            return found
        end
    end
    
    return nil
end

-- ============= [ SCAN REMOTES ] =============

print("\n🔍 Scanning remotes... (AmbonHub🚯 Edition)")

Remotes.FishingSystem = findFishingSystem()
local events = findEvents(Remotes.FishingSystem)

Remotes.SellFish = findSellRemote(events)
Remotes.EquipFish = findEquipRemote(events)
Remotes.GetData = findGetDataRemote(events)

local totemShop = findTotemShop()
Remotes.BuyTotem = findBuyTotemRemote(totemShop)

print("\n=== REMOTE STATUS [AmbonHub🚯] ===")
print("SellFish:", Remotes.SellFish and "✅" or "❌")
print("EquipFish:", Remotes.EquipFish and "✅" or "❌")
print("GetData:", Remotes.GetData and "✅" or "❌")
print("BuyTotem:", Remotes.BuyTotem and "✅" or "❌")
print("====================================\n")

-- ============= [ FUNGSI GET INVENTORY ] =============

-- METHOD A: Pake Inventory_GetData
local function getInventoryViaGetData()
    if not Remotes.GetData then return nil end
    
    local success, data = pcall(function()
        return Remotes.GetData:InvokeServer()
    end)
    
    if success and data then
        print("✅ GetData success:", typeof(data))
        
        local fishList = {}
        
        if type(data) == "table" then
            local rawFish = data.Fish or data.fish or data.Inventory or data.Items or data
            
            if type(rawFish) == "table" then
                for _, fish in ipairs(rawFish) do
                    local id = fish.fishId or fish.Id or fish.id or fish.ID
                    local rarity = fish.rarity or fish.Rarity or "Unknown"
                    local weight = fish.weight or fish.Weight or BIG_WEIGHT
                    
                    if id then
                        table.insert(fishList, {
                            id = id,
                            rarity = rarity,
                            weight = weight
                        })
                    end
                end
            end
        end
        
        print("📦 GetData: " .. #fishList .. " fish found")
        return fishList
    end
    
    return nil
end

-- METHOD B: Scan manual
local function getInventoryManual()
    local fishList = {}
    
    pcall(function()
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local id = nil
                    
                    if tool:FindFirstChild("fishId") then
                        id = tool.fishId.Value
                    elseif tool:FindFirstChild("FishId") then
                        id = tool.FishId.Value
                    elseif tool:FindFirstChild("id") then
                        id = tool.id.Value
                    elseif tool:FindFirstChild("ID") then
                        id = tool.ID.Value
                    end
                    
                    if not id then
                        id = tool:GetAttribute("fishId") or 
                             tool:GetAttribute("id") or 
                             tool:GetAttribute("ID")
                    end
                    
                    if id then
                        local rarity = tool:GetAttribute("rarity") or 
                                      tool:GetAttribute("Rarity") or 
                                      "Common"
                        
                        table.insert(fishList, {
                            id = id,
                            rarity = rarity,
                            weight = BIG_WEIGHT,
                            tool = tool
                        })
                    end
                end
            end
        end
        
        if player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                local id = tool:GetAttribute("fishId") or tool:GetAttribute("id")
                if id then
                    local rarity = tool:GetAttribute("rarity") or "Common"
                    table.insert(fishList, {
                        id = id,
                        rarity = rarity,
                        weight = BIG_WEIGHT,
                        tool = tool,
                        equipped = true
                    })
                end
            end
        end
    end)
    
    print("📦 Manual scan: " .. #fishList .. " fish found")
    return fishList
end

local function refreshInventory()
    MyFish = {}
    
    if Settings.UseGetData and Remotes.GetData then
        local data = getInventoryViaGetData()
        if data and #data > 0 then
            MyFish = data
            Stats.Method = "GetData"
            return
        end
    end
    
    local data = getInventoryManual()
    if data and #data > 0 then
        MyFish = data
        Stats.Method = "Manual Scan"
    end
end

-- ============= [ FUNGSI SELL - MULTI FORMAT ] =============

local function sellFish(fishData)
    if not Remotes.SellFish or not fishData then return false end
    
    local success = false
    
    local format1 = {
        "SellSingle",
        {
            fishId = fishData.id,
            rarity = fishData.rarity,
            weight = BIG_WEIGHT
        }
    }
    
    local format2 = {
        [1] = "SellSingle",
        [2] = {
            fishId = fishData.id,
            rarity = fishData.rarity,
            weight = BIG_WEIGHT
        }
    }
    
    local format3 = {
        fishId = fishData.id,
        rarity = fishData.rarity,
        weight = BIG_WEIGHT
    }
    
    local format4 = {
        "Sell",
        {
            fishId = fishData.id,
            rarity = fishData.rarity,
            weight = BIG_WEIGHT
        }
    }
    
    if Settings.SellFormat == 1 or Settings.SellFormat == 0 then
        pcall(function() Remotes.SellFish:FireServer(unpack(format1)) success = true end)
        if success then Stats.Method = "Format 1" end
    end
    
    if not success and (Settings.SellFormat == 2 or Settings.SellFormat == 0) then
        pcall(function() Remotes.SellFish:FireServer(unpack(format2)) success = true end)
        if success then Stats.Method = "Format 2" end
    end
    
    if not success and (Settings.SellFormat == 3 or Settings.SellFormat == 0) then
        pcall(function() Remotes.SellFish:FireServer(unpack(format3)) success = true end)
        if success then Stats.Method = "Format 3" end
    end
    
    if not success and (Settings.SellFormat == 4 or Settings.SellFormat == 0) then
        pcall(function() Remotes.SellFish:FireServer(unpack(format4)) success = true end)
        if success then Stats.Method = "Format 4" end
    end
    
    if success then
        Stats.Sold = Stats.Sold + 1
        if Rayfield and Rayfield.Notify then
            Rayfield:Notify({
                Title = "💰 SOLD | AmbonHub🚯",
                Content = fishData.rarity .. " | Weight: " .. BIG_WEIGHT,
                Duration = 1
            })
        end
    end
    
    return success
end

-- ============= [ FUNGSI EQUIP ] =============

local function equipFish(fishId)
    if not Remotes.EquipFish then return end
    
    pcall(function()
        local args = { fishId }
        Remotes.EquipFish:FireServer(unpack(args))
        print("✅ Equip [AmbonHub]:", fishId)
    end)
end

-- ============= [ FUNGSI BUY TOTEM ] =============

local function buyTotem(totemName)
    if not Remotes.BuyTotem then return end
    
    pcall(function()
        local args = { totemName, 1, "coins" }
        local result = Remotes.BuyTotem:InvokeServer(unpack(args))
        print("✅ Buy Totem [AmbonHub]:", totemName)
    end)
end

-- ============= [ AUTO LOOPS ] =============

task.spawn(function()
    while true do
        if Settings.AutoSell then
            pcall(function()
                refreshInventory()
                
                local soldCount = 0
                for _, fish in ipairs(MyFish) do
                    if sellFish(fish) then
                        soldCount = soldCount + 1
                        task.wait(Settings.SellDelay)
                    end
                end
                
                if soldCount > 0 then
                    print("🔄 [AmbonHub] Sold " .. soldCount .. " fish")
                end
            end)
        end
        task.wait(2)
    end
end)

task.spawn(function()
    while true do
        if Settings.AutoEquip and #MyFish > 0 then
            pcall(function()
                for _, fish in ipairs(MyFish) do
                    equipFish(fish.id)
                    task.wait(Settings.EquipDelay)
                end
            end)
        end
        task.wait(3)
    end
end)

task.spawn(function()
    while true do
        if Settings.AutoBuyTotem then
            pcall(function()
                buyTotem(Settings.SelectedTotem)
            end)
        end
        task.wait(Settings.BuyDelay)
    end
end)

-- ============= [ CREATE UI DENGAN CREDIT ] =============

pcall(function()
    -- MAIN TAB
    local MainTab = Window:CreateTab("🎣 Main", 4483362458)
    
    MainTab:CreateSection("🔄 AUTO SELL | AmbonHub🚯")
    
    MainTab:CreateToggle({
        Name = "Aktifkan Auto Sell",
        CurrentValue = false,
        Flag = "AutoSellToggle",
        Callback = function(v) Settings.AutoSell = v end
    })
    
    MainTab:CreateToggle({
        Name = "Prioritaskan GetData",
        CurrentValue = true,
        Flag = "UseGetData",
        Callback = function(v) Settings.UseGetData = v end
    })
    
    MainTab:CreateSlider({
        Name = "Delay Sell",
        Range = {0.1, 2},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = 0.5,
        Flag = "SellDelay",
        Callback = function(v) Settings.SellDelay = v end
    })
    
    MainTab:CreateDropdown({
        Name = "Pilih Format",
        Options = {"Auto Detect", "Format 1", "Format 2", "Format 3", "Format 4"},
        CurrentOption = "Auto Detect",
        Flag = "FormatDropdown",
        Callback = function(o)
            if o == "Auto Detect" then Settings.SellFormat = 0
            elseif o == "Format 1" then Settings.SellFormat = 1
            elseif o == "Format 2" then Settings.SellFormat = 2
            elseif o == "Format 3" then Settings.SellFormat = 3
            elseif o == "Format 4" then Settings.SellFormat = 4
            end
        end
    })
    
    -- EQUIP TAB
    local EquipTab = Window:CreateTab("⚔️ Equip", 4483362458)
    
    EquipTab:CreateSection("🎣 AUTO EQUIP | AmbonHub🚯")
    
    EquipTab:CreateToggle({
        Name = "Aktifkan Auto Equip",
        CurrentValue = false,
        Flag = "AutoEquipToggle",
        Callback = function(v) Settings.AutoEquip = v end
    })
    
    EquipTab:CreateButton({
        Name = "⚔️ Equip Semua Ikan",
        Callback = function()
            refreshInventory()
            for _, fish in ipairs(MyFish) do
                equipFish(fish.id)
                task.wait(0.2)
            end
            Rayfield:Notify({ Title = "✅ AmbonHub", Content = "Equip selesai", Duration = 2 })
        end
    })
    
    -- TOTEM TAB
    local TotemTab = Window:CreateTab("🪄 Totem", 4483362458)
    
    TotemTab:CreateSection("✨ AUTO BUY TOTEM | AmbonHub🚯")
    
    TotemTab:CreateToggle({
        Name = "Aktifkan Auto Buy",
        CurrentValue = false,
        Flag = "AutoBuyToggle",
        Callback = function(v) Settings.AutoBuyTotem = v end
    })
    
    TotemTab:CreateDropdown({
        Name = "Pilih Totem",
        Options = {"Luck Totem", "Speed Totem", "Strength Totem", "Wealth Totem", "Experience Totem"},
        CurrentOption = "Luck Totem",
        Flag = "TotemDropdown",
        Callback = function(v) Settings.SelectedTotem = v end
    })
    
    TotemTab:CreateButton({
        Name = "✨ Beli 1 Totem",
        Callback = function()
            buyTotem(Settings.SelectedTotem)
            Rayfield:Notify({ Title = "✅ AmbonHub", Content = "Totem dibeli", Duration = 2 })
        end
    })
    
    -- CREDIT TAB
    local CreditTab = Window:CreateTab("📝 Credit", 4483362458)
    
    CreditTab:CreateSection("👑 OWNER")
    CreditTab:CreateLabel("AmbonHub🚯")
    
    CreditTab:CreateSection("✍️ CREDIT")
    CreditTab:CreateLabel("PEMBUAT ONAR")
    
    CreditTab:CreateSection("📋 INFO")
    CreditTab:CreateLabel("Version: 9.9.9")
    CreditTab:CreateLabel("Weight: " .. BIG_WEIGHT)
    CreditTab:CreateLabel("Method: " .. Stats.Method)
    CreditTab:CreateLabel("Status: AMBONHUB EDITION")
    
    CreditTab:CreateSection("💬 QUOTE")
    CreditTab:CreateLabel('"TIDAK BERMORAL"')
    CreditTab:CreateLabel('"TIDAK BERPERIKEMANUSIAAN"')
    
    -- STATUS TAB
    local StatusTab = Window:CreateTab("📊 Status", 4483362458)
    
    StatusTab:CreateSection("🔌 REMOTE STATUS")
    
    StatusTab:CreateLabel("SellFish: " .. (Remotes.SellFish and "✅" or "❌"))
    StatusTab:CreateLabel("EquipFish: " .. (Remotes.EquipFish and "✅" or "❌"))
    StatusTab:CreateLabel("GetData: " .. (Remotes.GetData and "✅" or "❌"))
    StatusTab:CreateLabel("BuyTotem: " .. (Remotes.BuyTotem and "✅" or "❌"))
    
    StatusTab:CreateSection("📦 INVENTORY (Weight: " .. BIG_WEIGHT .. ")")
    
    local FishCountLabel = StatusTab:CreateLabel("Jumlah Ikan: 0")
    local MethodLabel = StatusTab:CreateLabel("Method: -")
    local SoldLabel = StatusTab:CreateLabel("Terjual: 0")
    
    StatusTab:CreateButton({
        Name = "🔄 Refresh Inventory",
        Callback = function()
            refreshInventory()
            FishCountLabel:Set("Jumlah Ikan: " .. #MyFish)
            MethodLabel:Set("Method: " .. Stats.Method)
            Rayfield:Notify({ Title = "✅ AmbonHub", Content = #MyFish .. " ikan ditemukan", Duration = 2 })
        end
    })
    
    task.spawn(function()
        while true do
            if StatusTab then
                FishCountLabel:Set("Jumlah Ikan: " .. #MyFish)
                MethodLabel:Set("Method: " .. Stats.Method)
                SoldLabel:Set("Terjual: " .. Stats.Sold)
            end
            task.wait(1)
        end
    end)
end)

-- Refresh inventory awal
task.wait(1)
refreshInventory()

-- Notifikasi
if Rayfield and Rayfield.Notify then
    Rayfield:Notify({
        Title = "AMBONHUB🚯 | ULTIMATE",
        Content = "Weight: " .. BIG_WEIGHT .. " | " .. #MyFish .. " ikan | v" .. VERSION,
        Duration = 5
    })
end

print("\n=== AMBONHUB🚯 ULTIMATE EDITION ===")
print("✅ Weight:", BIG_WEIGHT)
print("✅ Owner: AmbonHub🚯")
print("✅ Credit: PEMBUAT ONAR")
print("✅ Version:", VERSION)
print("✅ Inventory:", #MyFish, "fish")
print("Method:", Stats.Method)
print('✅ Quote: "TIDAK BERMORAL, TIDAK BERPERIKEMANUSIAAN"')
print("====================================\n")