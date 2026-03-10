--[[
    FISCH AUTO FARM - RAYFIELD UI EDITION
    Created by AmbonHub🚯
    Dengan Auto Detect + Remote Hit
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

-- Cari sidewalk
local sidewalk = workspace
for _, part in pairs({"Snow", "Parts", "Sidewalk", "Visual_138"}) do
    sidewalk = sidewalk:FindFirstChild(part)
    if not sidewalk then break end
end

if not sidewalk then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Sidewalk Visual_138 tidak ditemukan!",
        Duration = 3
    })
    return
end

-- Variables
local nodes = {}
local processedNodes = {}
local autoFarm = false
local autoDetect = true
local farmRadius = 100
local collected = 0
local detectionInterval = 5
local hitCount = 0
local failedCount = 0

-- Hit parameters (bisa diganti nanti)
local hitParams = {
    id = "138",
    param2 = 7,
    param3 = 4,
    timestamp = 1773165167.495627
}

-- Fungsi scan nodes
local function scanNewNodes()
    local newNodes = {}
    
    for _, child in pairs(sidewalk:GetChildren()) do
        if child:IsA("BasePart") and not processedNodes[child] then
            table.insert(newNodes, child)
            processedNodes[child] = true
            table.insert(nodes, child)
        end
    end
    
    if sidewalk:FindFirstChild("Active") and sidewalk.Active:IsA("BasePart") then
        if not processedNodes[sidewalk.Active] then
            table.insert(newNodes, sidewalk.Active)
            processedNodes[sidewalk.Active] = true
            table.insert(nodes, sidewalk.Active)
        end
    end
    
    return newNodes
end

-- Initial scan
scanNewNodes()

-- Auto detect loop
spawn(function()
    while true do
        wait(detectionInterval)
        if autoDetect then
            local new = scanNewNodes()
            if #new > 0 and Rayfield then
                Rayfield:Notify({
                    Title = "AmbonHub🚯 Auto Detect",
                    Content = string.format("Ditemukan %d node baru! Total: %d", #new, #nodes),
                    Duration = 3
                })
            end
        end
    end
end)

-- Fungsi hit node
local function hitNode(node)
    if not node or not node:IsA("BasePart") then return false end
    if not character:FindFirstChild("HumanoidRootPart") then return false end
    
    -- Teleport
    character.HumanoidRootPart.CFrame = node.CFrame + Vector3.new(0, 3, 0)
    wait(0.3)
    
    -- Hit pake remote
    local success, result = pcall(function()
        local args = {
            [1] = {
                [1] = hitParams.id,
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
    
    for _, node in ipairs(nodes) do
        if node and node:IsA("BasePart") then
            local dist = (node.Position - charPos).Magnitude
            if dist <= radius then
                table.insert(inRadius, node)
            end
        end
    end
    return inRadius
end

-- Farm loop
local function farmLoop()
    while autoFarm do
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            character = player.Character or player.CharacterAdded:Wait()
            wait(1)
        end
        
        local nodesInRadius = getNodesInRadius(farmRadius)
        
        if #nodesInRadius > 0 then
            for _, node in ipairs(nodesInRadius) do
                if autoFarm then
                    hitNode(node)
                    wait(0.5)
                end
            end
        else
            -- Cari node terdekat
            local nearest = nil
            local shortest = math.huge
            local charPos = character:FindFirstChild("HumanoidRootPart")
            
            if charPos then
                charPos = charPos.Position
                for _, node in ipairs(nodes) do
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
            else
                wait(2)
            end
        end
        
        wait(1)
    end
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "AmbonHub🚯 Auto Farm",
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

-- Tab Utama
local MainTab = Window:CreateTab("Main", "home")
local MainSection = MainTab:CreateSection("Control by AmbonHub🚯")

-- Info nodes
MainTab:CreateParagraph({
    Title = "Informasi AmbonHub🚯",
    Content = string.format("Total Nodes: %d\nAuto Detect: Aktif\nCreator: AmbonHub🚯", #nodes)
})

-- Toggle Auto Farm
MainTab:CreateToggle({
    Name = "Start Auto Farm",
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
                Content = string.format("Dimulai dengan radius %d", farmRadius),
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

-- Slider Radius
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

-- Preset Radius
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

-- Tab Auto Detect
local DetectTab = Window:CreateTab("Detect", "eye")
local DetectSection = DetectTab:CreateSection("Auto Detect - AmbonHub🚯")

-- Toggle Auto Detect
DetectTab:CreateToggle({
    Name = "Auto Detect Node Baru",
    CurrentValue = true,
    Flag = "AutoDetectToggle",
    Callback = function(Value)
        autoDetect = Value
    end
})

-- Slider Interval
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

-- Manual Scan
DetectTab:CreateButton({
    Name = "Scan Manual Sekarang",
    Callback = function()
        local new = scanNewNodes()
        Rayfield:Notify({
            Title = "AmbonHub🚯 Manual Scan",
            Content = string.format("Ditemukan %d node baru. Total: %d", #new, #nodes),
            Duration = 3
        })
    end
})

-- Tab Remote Settings
local RemoteTab = Window:CreateTab("Remote", "settings")
local RemoteSection = RemoteTab:CreateSection("Parameter Remote - AmbonHub🚯")

-- Input untuk parameter
RemoteTab:CreateInput({
    Name = "ID Node",
    PlaceholderText = "138",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text and Text ~= "" then
            hitParams.id = Text
        end
    end
})

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

-- Reset ke default
RemoteTab:CreateButton({
    Name = "Reset ke Default",
    Callback = function()
        hitParams.id = "138"
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

-- Label stats yang akan diupdate
StatsTab:CreateParagraph({
    Title = "Statistik Real-time",
    Content = string.format("Total Nodes: %d\nTerkumpul: %d\nSukses: %d\nGagal: %d\nNode dalam radius: 0\n\nCreated by AmbonHub🚯", 
        #nodes, collected, hitCount, failedCount)
})

-- Refresh stats button
StatsTab:CreateButton({
    Name = "Refresh Stats",
    Callback = function()
        local inRadius = #getNodesInRadius(farmRadius)
        -- Update paragraph (harus recreate)
        StatsTab:CreateParagraph({
            Title = "Statistik Real-time",
            Content = string.format("Total Nodes: %d\nTerkumpul: %d\nSukses: %d\nGagal: %d\nNode dalam radius: %d\n\nCreated by AmbonHub🚯", 
                #nodes, collected, hitCount, failedCount, inRadius)
        })
    end
})

-- Tab Teleport
local TeleportTab = Window:CreateTab("Teleport", "rotate-cw")
local TeleportSection = TeleportTab:CreateSection("Teleport - AmbonHub🚯")

-- Teleport random
TeleportTab:CreateButton({
    Name = "Teleport ke Node Random",
    Callback = function()
        if #nodes > 0 then
            local randomNode = nodes[math.random(1, #nodes)]
            if randomNode and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = randomNode.CFrame + Vector3.new(0, 3, 0)
                Rayfield:Notify({
                    Title = "AmbonHub🚯 Teleport",
                    Content = "Teleport ke node random",
                    Duration = 2
                })
            end
        end
    end
})

-- Teleport ke node pertama
TeleportTab:CreateButton({
    Name = "Teleport ke Node Pertama",
    Callback = function()
        if #nodes > 0 and nodes[1] and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = nodes[1].CFrame + Vector3.new(0, 3, 0)
        end
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

Version: 2.0
Game: Fisch

Fitur:
✓ Auto Farm dengan Radius
✓ Auto Detect Node Baru
✓ Remote Hit Support
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
    Content = string.format("Loaded! %d nodes ditemukan", #nodes),
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
                Content = string.format("Terkumpul: %d/%d | In radius: %d", collected, #nodes, inRadius),
                Duration = 2
            })
        end
    end
end)
