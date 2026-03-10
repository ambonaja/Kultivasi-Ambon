--[[
    FISCH AUTO FARM - RAYFIELD UI EDITION
    Created by AmbonHub🚯
    Dengan Auto Detect + Remote Hit + Multiple Locations (7 Locations)
    FIXED: Dropdown lokasi tidak hilang + Delay bisa diatur
]]

-- Load Rayfield dengan method alternatif
local Rayfield

-- Coba load dari beberapa source
local success, result = pcall(function()
    return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Sirius-Roblox/rayfield/main/source"))()
end)

if success then
    Rayfield = result
else
    -- Fallback ke source lain
    Rayfield = loadstring(game:HttpGetAsync("https://sirius.menu/rayfield"))()
end

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Remote setup
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit")
local ShovelService = Knit:WaitForChild("Services"):WaitForChild("ShovelService")
local HitRemote = ShovelService:WaitForChild("RF"):WaitForChild("Hit")

-- Multiple Locations
local locations = {
    {
        name = "Sidewalk",
        path = {"Snow", "Parts", "Sidewalk", "Visual_138"},
        id = "138",
        nodeCount = 0,
        objects = {},
        object = nil
    },
    {
        name = "Construction",
        path = {"Snow", "Parts", "Construction", "Visual_282"},
        id = "282",
        nodeCount = 0,
        objects = {},
        object = nil
    },
    {
        name = "Ice",
        path = {"Snow", "Parts", "Ice", "Visual_278"},
        id = "278",
        nodeCount = 0,
        objects = {},
        object = nil
    },
    {
        name = "Farmland",
        path = {"Snow", "Parts", "Farmland", "Visual_281"},
        id = "281",
        nodeCount = 0,
        objects = {},
        object = nil
    },
    {
        name = "Magma",
        path = {"Snow", "Parts", "Magma", "Visual_277"},
        id = "277",
        nodeCount = 0,
        objects = {},
        object = nil
    },
    {
        name = "Road",
        path = {"Snow", "Parts", "Road", "Visual_167"},
        id = "167",
        nodeCount = 0,
        objects = {},
        object = nil
    },
    {
        name = "Debris",
        path = {"Debris"},
        id = "debris",
        nodeCount = 0,
        objects = {},
        object = nil,
        isDebris = true
    }
}

-- Cari semua lokasi
local validLocations = {}
for i, loc in ipairs(locations) do
    local obj = workspace
    local valid = true
    
    if loc.isDebris then
        obj = workspace:FindFirstChild("Debris")
        if not obj then valid = false end
    else
        for _, part in ipairs(loc.path) do
            obj = obj:FindFirstChild(part)
            if not obj then
                valid = false
                break
            end
        end
    end
    
    if valid and obj then
        loc.object = obj
        table.insert(validLocations, loc)
    end
end

if #validLocations == 0 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Tidak ada lokasi valid ditemukan!",
        Duration = 3
    })
    return
end

-- Variables
local allNodes = {}
local nodesByLocation = {}
local processedNodes = {}
local autoFarm = false
local autoDetect = true
local farmRadius = 100
local collected = 0
local detectionInterval = 5
local hitCount = 0
local failedCount = 0
local selectedLocation = validLocations[1].name

-- DELAY SETTINGS
local moveDelay = 1.0        -- Delay antar pindah node (default 1 detik)
local teleportDelay = 0.5     -- Delay setelah teleport sebelum hit (default 0.5 detik)

-- Hit parameters
local hitParams = {
    id = "138",
    param2 = 7,
    param3 = 4,
    timestamp = 1773165167.495627
}

-- Fungsi khusus untuk scan Debris
local function scanDebris(loc)
    local newNodes = {}
    local locationNodes = nodesByLocation[loc.name] or {}
    
    loc.objects = {}
    
    local debrisChild12 = loc.object:GetChildren()[12]
    if debrisChild12 then
        for _, child in pairs(debrisChild12:GetChildren()) do
            if child:IsA("BasePart") then
                if not processedNodes[child] then
                    table.insert(newNodes, child)
                    processedNodes[child] = true
                    table.insert(allNodes, child)
                end
                table.insert(locationNodes, child)
                table.insert(loc.objects, child)
            end
        end
    end
    
    for _, child in pairs(loc.object:GetChildren()) do
        if child:IsA("BasePart") then
            if not processedNodes[child] then
                table.insert(newNodes, child)
                processedNodes[child] = true
                table.insert(allNodes, child)
            end
            table.insert(locationNodes, child)
            table.insert(loc.objects, child)
        end
    end
    
    nodesByLocation[loc.name] = locationNodes
    loc.nodeCount = #locationNodes
    
    return newNodes
end

-- Fungsi scan nodes dari semua lokasi
local function scanAllLocations()
    local newNodes = {}
    
    for _, loc in ipairs(validLocations) do
        if loc.isDebris then
            local debrisNodes = scanDebris(loc)
            for _, node in ipairs(debrisNodes) do
                table.insert(newNodes, node)
            end
        else
            local obj = loc.object
            local locationNodes = nodesByLocation[loc.name] or {}
            
            loc.objects = {}
            
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("BasePart") then
                    if not processedNodes[child] then
                        table.insert(newNodes, child)
                        processedNodes[child] = true
                        table.insert(allNodes, child)
                    end
                    table.insert(locationNodes, child)
                    table.insert(loc.objects, child)
                end
            end
            
            if obj:FindFirstChild("Active") and obj.Active:IsA("BasePart") then
                if not processedNodes[obj.Active] then
                    table.insert(newNodes, obj.Active)
                    processedNodes[obj.Active] = true
                    table.insert(allNodes, obj.Active)
                end
                table.insert(locationNodes, obj.Active)
                table.insert(loc.objects, obj.Active)
            end
            
            nodesByLocation[loc.name] = locationNodes
            loc.nodeCount = #locationNodes
        end
    end
    
    return newNodes
end

-- Initial scan
scanAllLocations()

-- Auto detect loop
spawn(function()
    while true do
        wait(detectionInterval)
        if autoDetect then
            local new = scanAllLocations()
            if #new > 0 and Rayfield then
                Rayfield:Notify({
                    Title = "AmbonHub🚯 Auto Detect",
                    Content = string.format("Ditemukan %d node baru! Total: %d", #new, #allNodes),
                    Duration = 3
                })
            end
        end
    end
end)

-- Fungsi untuk menentukan ID berdasarkan posisi node
local function getLocationIdForNode(node)
    for _, loc in ipairs(validLocations) do
        if loc.isDebris then
            if node:IsDescendantOf(loc.object) then
                return loc.id
            end
        else
            if node:IsDescendantOf(loc.object) then
                return loc.id
            end
        end
    end
    return hitParams.id
end

-- Fungsi hit node dengan delay yang bisa diatur
local function hitNode(node)
    if not node or not node:IsA("BasePart") then return false end
    if not character:FindFirstChild("HumanoidRootPart") then return false end
    
    -- Teleport dengan delay sesuai pengaturan
    character.HumanoidRootPart.CFrame = node.CFrame + Vector3.new(0, 3, 0)
    wait(teleportDelay) -- Delay setelah teleport sebelum hit
    
    local nodeId = getLocationIdForNode(node)
    
    local success, result = pcall(function()
        local args = {
            [1] = {
                [1] = nodeId,
                [2] = hitParams.param2,
                [3] = hitParams.param3
            },
            [2] = hitParams.timestamp
        }
        return HitRemote:InvokeServer(unpack(args))
    end)
    
    if success then
        collected = collected + 1
        hitCount = hitCount + 1
        return true
    else
        failedCount = failedCount + 1
        return false
    end
end

-- Get nodes in radius
local function getNodesInRadius(radius)
    local inRadius = {}
    local charPos = character:FindFirstChild("HumanoidRootPart")
    if not charPos then return inRadius end
    charPos = charPos.Position
    
    for _, node in ipairs(allNodes) do
        if node and node:IsA("BasePart") then
            local dist = (node.Position - charPos).Magnitude
            if dist <= radius then
                table.insert(inRadius, node)
            end
        end
    end
    return inRadius
end

-- Get nodes per lokasi dalam radius
local function getNodesByLocationInRadius(radius, locationName)
    local inRadius = {}
    local charPos = character:FindFirstChild("HumanoidRootPart")
    if not charPos then return inRadius end
    charPos = charPos.Position
    
    local locationNodes = nodesByLocation[locationName] or {}
    for _, node in ipairs(locationNodes) do
        if node and node:IsA("BasePart") then
            local dist = (node.Position - charPos).Magnitude
            if dist <= radius then
                table.insert(inRadius, node)
            end
        end
    end
    return inRadius
end

-- Farm loop dengan delay yang bisa diatur
local function farmLoop()
    while autoFarm do
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            character = player.Character or player.CharacterAdded:Wait()
            wait(1)
        end
        
        local farmedAny = false
        
        for _, loc in ipairs(validLocations) do
            if autoFarm then
                local nodesInRadius = getNodesByLocationInRadius(farmRadius, loc.name)
                
                if #nodesInRadius > 0 then
                    for _, node in ipairs(nodesInRadius) do
                        if autoFarm then
                            hitNode(node)
                            farmedAny = true
                            wait(moveDelay) -- Delay antar pindah node (bisa diatur)
                        end
                    end
                end
            end
        end
        
        if not farmedAny and autoFarm then
            local nearest = nil
            local shortest = math.huge
            local charPos = character:FindFirstChild("HumanoidRootPart")
            
            if charPos then
                charPos = charPos.Position
                for _, node in ipairs(allNodes) do
                    if node and node:IsA("BasePart") then
                        local dist = (node.Position - charPos).Magnitude
                        if dist < shortest then
                            shortest = dist
                            nearest = node
                        end
                    end
                end
            end
            
            if nearest then
                hitNode(nearest)
                wait(moveDelay) -- Delay setelah node terdekat
            else
                wait(2)
            end
        end
        
        wait(1)
    end
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "AmbonHub🚯 Fisch Auto Farm - 7 Locations",
    LoadingTitle = "Loading AmbonHub🚯 Auto Farm...",
    LoadingSubtitle = "by AmbonHub🚯",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonHubConfig",
        FileName = "FischAutoFarm"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- Hitung total nodes
local totalNodes = #allNodes

-- Tab Utama
local MainTab = Window:CreateTab("Main", "home")
local MainSection = MainTab:CreateSection("Control by AmbonHub🚯")

local locationInfo = "Total Nodes: " .. totalNodes .. "\n\nLokasi:\n"
for _, loc in ipairs(validLocations) do
    locationInfo = locationInfo .. string.format("• %s: %d nodes\n", loc.name, loc.nodeCount)
end

MainTab:CreateParagraph({
    Title = "Informasi AmbonHub🚯",
    Content = locationInfo
})

MainTab:CreateToggle({
    Name = "Start Auto Farm (Semua Lokasi)",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        autoFarm = Value
        if Value then
            collected = 0
            hitCount = 0
            failedCount = 0
            Rayfield:Notify({
                Title = "AmbonHub🚯 Auto Farm",
                Content = string.format("Dimulai dengan radius %d - Delay %ds", farmRadius, moveDelay),
                Duration = 3
            })
            spawn(farmLoop)
        else
            Rayfield:Notify({
                Title = "AmbonHub🚯 Auto Farm",
                Content = "Auto Farm dihentikan",
                Duration = 2
            })
        end
    end
})

-- Tab Radius
local RadiusTab = Window:CreateTab("Radius", "radar")
local RadiusSection = RadiusTab:CreateSection("Pengaturan Radius - AmbonHub🚯")

local RadiusSlider = RadiusTab:CreateSlider({
    Name = "Radius Farm",
    Range = {10, 500},
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = 100,
    Flag = "RadiusSlider",
    Callback = function(Value)
        farmRadius = Value
    end
})

RadiusTab:CreateButton({
    Name = "Dekat (50)",
    Callback = function()
        farmRadius = 50
        RadiusSlider:Set(50)
    end
})

RadiusTab:CreateButton({
    Name = "Sedang (150)",
    Callback = function()
        farmRadius = 150
        RadiusSlider:Set(150)
    end
})

RadiusTab:CreateButton({
    Name = "Jauh (300)",
    Callback = function()
        farmRadius = 300
        RadiusSlider:Set(300)
    end
})

-- Tab Delay Settings (BARU)
local DelayTab = Window:CreateTab("Delay", "clock")
local DelaySection = DelayTab:CreateSection("Pengaturan Delay - AmbonHub🚯")

-- Slider untuk delay antar node
local MoveDelaySlider = DelayTab:CreateSlider({
    Name = "Delay Antar Node (detik)",
    Range = {0.1, 5.0},
    Increment = 0.1,
    Suffix = "detik",
    CurrentValue = 1.0,
    Flag = "MoveDelaySlider",
    Callback = function(Value)
        moveDelay = Value
    end
})

-- Slider untuk delay setelah teleport
local TeleportDelaySlider = DelayTab:CreateSlider({
    Name = "Delay Setelah Teleport (detik)",
    Range = {0.1, 2.0},
    Increment = 0.1,
    Suffix = "detik",
    CurrentValue = 0.5,
    Flag = "TeleportDelaySlider",
    Callback = function(Value)
        teleportDelay = Value
    end
})

-- Preset delay
DelayTab:CreateButton({
    Name = "Mode Cepat (0.5s)",
    Callback = function()
        moveDelay = 0.5
        teleportDelay = 0.2
        MoveDelaySlider:Set(0.5)
        TeleportDelaySlider:Set(0.2)
        Rayfield:Notify({
            Title = "Delay Settings",
            Content = "Mode Cepat: 0.5s antar node",
            Duration = 2
        })
    end
})

DelayTab:CreateButton({
    Name = "Mode Normal (1.0s)",
    Callback = function()
        moveDelay = 1.0
        teleportDelay = 0.5
        MoveDelaySlider:Set(1.0)
        TeleportDelaySlider:Set(0.5)
        Rayfield:Notify({
            Title = "Delay Settings",
            Content = "Mode Normal: 1.0s antar node",
            Duration = 2
        })
    end
})

DelayTab:CreateButton({
    Name = "Mode Lambat (2.0s)",
    Callback = function()
        moveDelay = 2.0
        teleportDelay = 1.0
        MoveDelaySlider:Set(2.0)
        TeleportDelaySlider:Set(1.0)
        Rayfield:Notify({
            Title = "Delay Settings",
            Content = "Mode Lambat: 2.0s antar node",
            Duration = 2
        })
    end
})

DelayTab:CreateButton({
    Name = "Mode Sangat Lambat (3.0s)",
    Callback = function()
        moveDelay = 3.0
        teleportDelay = 1.5
        MoveDelaySlider:Set(3.0)
        TeleportDelaySlider:Set(1.5)
        Rayfield:Notify({
            Title = "Delay Settings",
            Content = "Mode Sangat Lambat: 3.0s antar node",
            Duration = 2
        })
    end
})

-- Tab Auto Detect
local DetectTab = Window:CreateTab("Detect", "eye")
local DetectSection = DetectTab:CreateSection("Auto Detect - AmbonHub🚯")

DetectTab:CreateToggle({
    Name = "Auto Detect Node Baru",
    CurrentValue = true,
    Flag = "AutoDetectToggle",
    Callback = function(Value)
        autoDetect = Value
    end
})

DetectTab:CreateSlider({
    Name = "Interval Deteksi (detik)",
    Range = {1, 30},
    Increment = 1,
    Suffix = "detik",
    CurrentValue = 5,
    Flag = "IntervalSlider",
    Callback = function(Value)
        detectionInterval = Value
    end
})

DetectTab:CreateButton({
    Name = "Scan Manual Semua Lokasi",
    Callback = function()
        local new = scanAllLocations()
        Rayfield:Notify({
            Title = "AmbonHub🚯 Manual Scan",
            Content = string.format("Ditemukan %d node baru. Total: %d", #new, totalNodes),
            Duration = 3
        })
    end
})

-- Tab Lokasi
local LocationTab = Window:CreateTab("Lokasi", "map-pin")
local LocationSection = LocationTab:CreateSection("Info Per Lokasi")

for _, loc in ipairs(validLocations) do
    local idText = loc.isDebris and "Debris" or ("ID: " .. loc.id)
    LocationTab:CreateParagraph({
        Title = loc.name,
        Content = string.format("%s\nTotal Objek: %d\nNodes: %d\nObject: %s", 
            idText, #loc.objects, loc.nodeCount, tostring(loc.object))
    })
end

-- Tab Teleport
local TeleportTab = Window:CreateTab("Teleport", "rotate-cw")
local TeleportSection = TeleportTab:CreateSection("Teleport ke Objek")

-- Buat options list
local locationOptions = {}
for _, loc in ipairs(validLocations) do
    table.insert(locationOptions, loc.name)
end

-- Buat dropdown langsung dengan options
local locationDropdown = TeleportTab:CreateDropdown({
    Name = "Pilih Lokasi",
    Options = locationOptions,
    CurrentOption = validLocations[1].name,
    Flag = "LocationDropdown",
    Callback = function(option)
        if option and option ~= "" then
            selectedLocation = option
            -- Cari info lokasi
            for _, loc in ipairs(validLocations) do
                if loc.name == option then
                    Rayfield:Notify({
                        Title = "Lokasi Dipilih",
                        Content = string.format("%s: %d objek tersedia (1-%d)", loc.name, #loc.objects, #loc.objects),
                        Duration = 2
                    })
                    break
                end
            end
        end
    end
})

-- Input untuk teleport
TeleportTab:CreateInput({
    Name = "Nomor Objek",
    PlaceholderText = "Contoh: 50",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if not num then
            Rayfield:Notify({
                Title = "Error",
                Content = "Masukkan angka yang valid!",
                Duration = 2
            })
            return
        end
        
        -- Cari lokasi yang dipilih
        local found = false
        for _, loc in ipairs(validLocations) do
            if loc.name == selectedLocation then
                if num >= 1 and num <= #loc.objects then
                    local targetObj = loc.objects[num]
                    if targetObj and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = targetObj.CFrame + Vector3.new(0, 3, 0)
                        Rayfield:Notify({
                            Title = "AmbonHub🚯 Teleport",
                            Content = string.format("Teleport ke %s objek #%d", loc.name, num),
                            Duration = 2
                        })
                        found = true
                    end
                else
                    Rayfield:Notify({
                        Title = "Error",
                        Content = string.format("Nomor tidak valid! (1 - %d)", #loc.objects),
                        Duration = 2
                    })
                    found = true
                end
                break
            end
        end
        
        if not found then
            Rayfield:Notify({
                Title = "Error",
                Content = "Lokasi tidak ditemukan!",
                Duration = 2
            })
        end
    end
})

-- Info rentang objek
for _, loc in ipairs(validLocations) do
    TeleportTab:CreateParagraph({
        Title = string.format("%s: 1 - %d", loc.name, #loc.objects),
        Content = string.format("%d objek tersedia", #loc.objects)
    })
end

-- Teleport random
TeleportTab:CreateButton({
    Name = "Teleport ke Node Random (Semua Lokasi)",
    Callback = function()
        if #allNodes > 0 then
            local randomNode = allNodes[math.random(1, #allNodes)]
            if randomNode and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = randomNode.CFrame + Vector3.new(0, 3, 0)
                
                for _, loc in ipairs(validLocations) do
                    if randomNode:IsDescendantOf(loc.object) then
                        Rayfield:Notify({
                            Title = "AmbonHub🚯 Teleport",
                            Content = string.format("Teleport ke %s (random)", loc.name),
                            Duration = 2
                        })
                        break
                    end
                end
            end
        end
    end
})

-- Teleport ke lokasi utama
for _, loc in ipairs(validLocations) do
    TeleportTab:CreateButton({
        Name = "Teleport ke " .. loc.name,
        Callback = function()
            if loc.object and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = loc.object.CFrame + Vector3.new(0, 3, 0)
                Rayfield:Notify({
                    Title = "AmbonHub🚯 Teleport",
                    Content = "Teleport ke " .. loc.name,
                    Duration = 2
                })
            end
        end
    })
end

-- Tab Remote Settings
local RemoteTab = Window:CreateTab("Remote", "settings")
local RemoteSection = RemoteTab:CreateSection("Parameter Remote - AmbonHub🚯")

RemoteTab:CreateInput({
    Name = "Parameter 2",
    PlaceholderText = "7",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            hitParams.param2 = num
        end
    end
})

RemoteTab:CreateInput({
    Name = "Parameter 3",
    PlaceholderText = "4",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            hitParams.param3 = num
        end
    end
})

RemoteTab:CreateInput({
    Name = "Timestamp",
    PlaceholderText = "1773165167.495627",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            hitParams.timestamp = num
        end
    end
})

RemoteTab:CreateButton({
    Name = "Reset ke Default",
    Callback = function()
        hitParams.param2 = 7
        hitParams.param3 = 4
        hitParams.timestamp = 1773165167.495627
        Rayfield:Notify({
            Title = "AmbonHub🚯 Remote",
            Content = "Parameter direset ke default",
            Duration = 2
        })
    end
})

-- Tab Stats
local StatsTab = Window:CreateTab("Stats", "chart-bar")
local StatsSection = StatsTab:CreateSection("Statistik AmbonHub🚯")

StatsTab:CreateParagraph({
    Title = "Statistik Real-time",
    Content = string.format("Total Nodes: %d\nTerkumpul: %d\nSukses: %d\nGagal: %d\nNode dalam radius: 0\n\nLokasi Aktif: %d\nDelay: %.1fs\n\nCreated by AmbonHub🚯", 
        totalNodes, collected, hitCount, failedCount, #validLocations, moveDelay)
})

StatsTab:CreateButton({
    Name = "Refresh Stats",
    Callback = function()
        local inRadius = #getNodesInRadius(farmRadius)
        StatsTab:CreateParagraph({
            Title = "Statistik Real-time",
            Content = string.format("Total Nodes: %d\nTerkumpul: %d\nSukses: %d\nGagal: %d\nNode dalam radius: %d\n\nLokasi Aktif: %d\nDelay: %.1fs\n\nCreated by AmbonHub🚯", 
                totalNodes, collected, hitCount, failedCount, inRadius, #validLocations, moveDelay)
        })
    end
})

-- Tab Credit
local CreditTab = Window:CreateTab("Credit", "star")
local CreditSection = CreditTab:CreateSection("Info Creator")

CreditTab:CreateParagraph({
    Title = "AmbonHub🚯",
    Content = [[
Created with ❤️ by:
AmbonHub🚯

Version: 10.0 (Delay Settings)
Game: Fisch

Lokasi Support:
• Sidewalk (Visual_138)
• Construction (Visual_282)
• Ice (Visual_278)
• Farmland (Visual_281)
• Magma (Visual_277)
• Road (Visual_167)
• Debris

Total Nodes: ~3000+

Fitur:
✓ Auto Farm SEMUA Lokasi
✓ Auto Detect Node Baru
✓ Remote Hit dengan ID Otomatis
✓ Teleport ke Setiap Objek
✓ Pengaturan Delay (0.1s - 5.0s)
✓ Statistik Real-time
✓ Anti AFK

Terima kasih telah menggunakan
script dari AmbonHub🚯
    ]]
})

-- Anti AFK
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if autoFarm then
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- Notifikasi awal
Rayfield:Notify({
    Title = "AmbonHub🚯 Fisch Auto Farm",
    Content = string.format("Loaded! %d nodes dari %d lokasi", totalNodes, #validLocations),
    Duration = 4
})

-- Load konfigurasi
Rayfield:LoadConfiguration()

-- Update stats otomatis
spawn(function()
    while true do
        wait(3)
        if Rayfield and Window and autoFarm then
            local inRadius = #getNodesInRadius(farmRadius)
            Rayfield:Notify({
                Title = "AmbonHub🚯 Progress",
                Content = string.format("Terkumpul: %d/%d | In radius: %d | Delay: %.1fs", 
                    collected, totalNodes, inRadius, moveDelay),
                Duration = 2
            })
        end
    end
end)