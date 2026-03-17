-- Script Fishing Auto Farm dengan Rayfield UI + Auto Sell Multi Format + Anti AFK Premium + Teleport
-- OWNER: AmbonHub🚯
-- WATERMARK: AMBONHUB🚯 PREMIUM FISHING BOT

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Status Variables
local autoFarmEnabled = false
local autoSellEnabled = false
local antiAfkEnabled = false
local selectedRod = "Basic Rod"
local selectedZone = "stater"
local castDelay = 0.1
local reelDelay = 0.1
local loopDelay = 0.1
local sellInterval = 30
local minRaritySell = "Common"
local autoDetectFormat = true
local selectedFormat = 1

-- Anti AFK Premium Variables
local antiAfkMethod = "Mouse Move"
local lastMoveTime = 0
local moveInterval = 30
local virtualClickEnabled = true
local jumpEnabled = false
local cameraRotateEnabled = false
local bhopEnabled = false
local bhopSpeed = 16
local bhopActive = false
local bhopConnection = nil

-- Teleport Variables
local teleportPoints = {
    ["Sky Island"] = CFrame.new(1909, 903, -650),
    ["Candy Island"] = CFrame.new(-1355, 49, 95),
    ["Ocean"] = CFrame.new(-265, 46, -408),
    ["Glacier"] = CFrame.new(-33, 69, 1214),
    ["Stater Island"] = CFrame.new(83, 45, -802),
    ["Volcano Island"] = CFrame.new(1498, 60, -11)
}

-- Remote Variables
local FishingSystem = nil
local SellRemote = nil
local EquipRemote = nil
local CastReplication = nil
local StartFishing = nil
local RequestFishRoll = nil
local CleanupCast = nil
local FishGiver = nil
local QuestRemotes = nil

-- Stats Variables (hidden but still counting)
local fishCaught = 0
local castsDone = 0
local soldCount = 0
local currentFormat = 1

-- Rarity Levels
local rarityLevel = {
    ["Common"] = 1,
    ["Uncommon"] = 2, 
    ["Rare"] = 3,
    ["Epic"] = 4, 
    ["Legendary"] = 5,
    ["Mythic"] = 6
}

-- ============= [ WATERMARK & OWNER ] =============

-- Console Watermark
print([[

    █████╗ ███╗   ███╗██████╗  ██████╗ ███╗   ██╗██╗  ██╗██╗   ██╗
   ██╔══██╗████╗ ████║██╔══██╗██╔═══██╗████╗  ██║██║  ██║██║   ██║
   ███████║██╔████╔██║██████╔╝██║   ██║██╔██╗ ██║███████║██║   ██║
   ██╔══██║██║╚██╔╝██║██╔══██╗██║   ██║██║╚██╗██║██╔══██║██║   ██║
   ██║  ██║██║ ╚═╝ ██║██████╔╝╚██████╔╝██║ ╚████║██║  ██║╚██████╔╝
   ╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ 
                                                                    
██╗    ██╗ █████╗ ████████╗███████╗██████╗ ███╗   ███╗ █████╗ ██████╗ ██╗  ██╗
██║    ██║██╔══██╗╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔══██╗██║  ██║
██║ █╗ ██║███████║   ██║   █████╗  ██████╔╝██╔████╔██║███████║██████╔╝███████║
██║███╗██║██╔══██║   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║██╔══██╗██╔══██║
╚███╔███╔╝██║  ██║   ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
                                                                                
]])

print("🔥 AMBONHUB🚯 PREMIUM FISHING BOT - BY OWNER")
print("🔥 VERSION: 2.0.0 | ANTI AFK PREMIUM | 6 TELEPORT LOCATIONS")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- In-Game Watermark
local function createWatermark()
    local gui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local text = Instance.new("TextLabel")
    local ownerText = Instance.new("TextLabel")
    
    gui.Name = "AmbonHubWatermark"
    gui.Parent = game.CoreGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 10, 1, -60)
    frame.Size = UDim2.new(0, 200, 0, 45)
    frame.Active = true
    frame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    text.Parent = frame
    text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    text.BackgroundTransparency = 1
    text.Position = UDim2.new(0, 5, 0, 5)
    text.Size = UDim2.new(1, -10, 0, 20)
    text.Font = Enum.Font.GothamBold
    text.Text = "AMBONHUB🚯"
    text.TextColor3 = Color3.fromRGB(255, 100, 0)
    text.TextSize = 16
    text.TextXAlignment = Enum.TextXAlignment.Left
    
    ownerText.Parent = frame
    ownerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ownerText.BackgroundTransparency = 1
    ownerText.Position = UDim2.new(0, 5, 0, 25)
    ownerText.Size = UDim2.new(1, -10, 0, 15)
    ownerText.Font = Enum.Font.Gotham
    ownerText.Text = "Owner: AmbonHub🚯"
    ownerText.TextColor3 = Color3.fromRGB(200, 200, 200)
    ownerText.TextSize = 12
    ownerText.TextXAlignment = Enum.TextXAlignment.Left
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 0))
    })
    gradient.Parent = frame
end

-- Create watermark
spawn(createWatermark)

-- ============= [ ANTI AFK PREMIUM ] =============

local function antiAfkVirtualClick()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function antiAfkMouseMove()
    pcall(function()
        local mouse = LocalPlayer:GetMouse()
        local currentPos = Vector2.new(mouse.X, mouse.Y)
        local newPos = currentPos + Vector2.new(10, 10)
        mouse:Move(newPos)
        task.wait(0.1)
        mouse:Move(currentPos)
    end)
end

local function antiAfkJump()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid.Jump = true
                task.wait(0.1)
                humanoid.Jump = false
            end
        end
    end)
end

local function antiAfkCameraRotate()
    pcall(function()
        local camera = workspace.CurrentCamera
        local originalCF = camera.CFrame
        camera.CFrame = originalCF * CFrame.Angles(0, math.rad(5), 0)
        task.wait(0.1)
        camera.CFrame = originalCF
    end)
end

local function startBhop()
    if bhopConnection then
        bhopConnection:Disconnect()
        bhopConnection = nil
    end
    
    bhopActive = true
    bhopConnection = RunService.Heartbeat:Connect(function()
        if bhopActive and antiAfkEnabled and bhopEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    
                    if humanoid and hrp and humanoid.Health > 0 then
                        if humanoid.FloorMaterial ~= Enum.Material.Air then
                            humanoid.Jump = true
                        end
                        
                        if humanoid.MoveDirection.Magnitude > 0 then
                            hrp.Velocity = hrp.Velocity + (humanoid.MoveDirection * bhopSpeed)
                        end
                    end
                end
            end)
        end
    end)
end

local function stopBhop()
    bhopActive = false
    if bhopConnection then
        bhopConnection:Disconnect()
        bhopConnection = nil
    end
end

local function runAntiAfk()
    if not antiAfkEnabled then return end
    
    pcall(function()
        if antiAfkMethod == "Virtual Click" then
            antiAfkVirtualClick()
        elseif antiAfkMethod == "Mouse Move" then
            antiAfkMouseMove()
        elseif antiAfkMethod == "Jump" then
            antiAfkJump()
        elseif antiAfkMethod == "Camera Rotate" then
            antiAfkCameraRotate()
        elseif antiAfkMethod == "BHOP (Premium)" then
            -- BHOP handled by heartbeat
        end
        
        if virtualClickEnabled then
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
end

task.spawn(function()
    while true do
        if antiAfkEnabled then
            runAntiAfk()
            lastMoveTime = tick()
        end
        task.wait(moveInterval)
    end
end)

-- ============= [ TELEPORT FUNCTIONS ] =============

local function teleportTo(pointName)
    local cframe = teleportPoints[pointName]
    if not cframe then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = cframe
                
                if pointName == "Sky Island" then
                    selectedZone = "sky"
                elseif pointName == "Candy Island" then
                    selectedZone = "candy"
                elseif pointName == "Ocean" then
                    selectedZone = "ocean"
                elseif pointName == "Glacier" then
                    selectedZone = "glacier"
                elseif pointName == "Stater Island" then
                    selectedZone = "stater"
                elseif pointName == "Volcano Island" then
                    selectedZone = "volcano"
                end
                
                Rayfield:Notify({
                    Title = "🌀 Teleport",
                    Content = "Teleported to " .. pointName,
                    Duration = 2
                })
            end
        end
    end)
end

-- ============= [ FIND REMOTES ] =============

local function findFishingSystem()
    local possibleNames = {
        "FishingSystem", "Fishing", "FishSystem", "FishingService", 
        "Fish", "Fisher", "FishingGame", "FishingRemote"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = ReplicatedStorage:FindFirstChild(name)
        if found then
            return found
        end
    end
    
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child.Name:lower():find("fish") or child.Name:lower():find("fishing") then
            return child
        end
    end
    
    return ReplicatedStorage:WaitForChild("FishingSystem")
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
            return found
        end
    end
    
    for _, child in ipairs(fishingSystem:GetChildren()) do
        if child.Name:lower():find("sell") or child.Name:lower():find("jual") then
            return child
        end
    end
    
    return fishingSystem:FindFirstChild("SellFish")
end

local function findEquipRemote(fishingSystem)
    if not fishingSystem then return nil end
    
    local possibleNames = {
        "EquipFish", "Equip", "FishEquip", "Inventory_EquipFish",
        "EquipRemote", "InventoryEvents"
    }
    
    for _, name in ipairs(possibleNames) do
        local found = fishingSystem:FindFirstChild(name)
        if found then
            return found
        end
    end
    
    local inventoryEvents = fishingSystem:FindFirstChild("InventoryEvents")
    if inventoryEvents then
        for _, name in ipairs({"Inventory_EquipFish", "EquipFish", "Equip"}) do
            local found = inventoryEvents:FindFirstChild(name)
            if found then
                return found
            end
        end
    end
    
    return nil
end

local function findFishingRemotes(fishingSystem)
    if not fishingSystem then return end
    
    CastReplication = fishingSystem:FindFirstChild("CastReplication")
    StartFishing = fishingSystem:FindFirstChild("StartFishing")
    RequestFishRoll = fishingSystem:FindFirstChild("RequestFishRoll")
    CleanupCast = fishingSystem:FindFirstChild("CleanupCast")
    FishGiver = fishingSystem:FindFirstChild("FishGiver")
    
    QuestRemotes = ReplicatedStorage:FindFirstChild("QuestRemotes")
end

-- ============= [ INIT REMOTES ] =============

FishingSystem = findFishingSystem()
SellRemote = findSellRemote(FishingSystem)
EquipRemote = findEquipRemote(FishingSystem)
findFishingRemotes(FishingSystem)

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
    
    if #tool.Name == 36 and tool.Name:match("%w%w%w%w%w%w%w%w%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w%w%w%w%w%w%w%w%w") then
        return tool.Name
    end
    
    return nil
end

local function getFishRarity(tool)
    if not tool then return "Common" end
    
    if tool:FindFirstChild("Rarity") then
        return tool.Rarity.Value
    elseif tool:FindFirstChild("rarity") then
        return tool.rarity.Value
    end
    
    return tool:GetAttribute("rarity") or "Common"
end

local function getCurrentEquippedFish()
    local success, result = pcall(function()
        local char = LocalPlayer.Character
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
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local fishId = getFishIdFromTool(child)
                    if fishId then
                        table.insert(fishList, {
                            fishId = fishId,
                            rarity = getFishRarity(child),
                            tool = child
                        })
                    end
                end
            end
        end
    end)
    return fishList
end

-- ============= [ FUNGSI SELL FISH MULTI FORMAT ] =============

local function sellFish(fishData)
    if not SellRemote then 
        return 
    end
    
    pcall(function()
        local bigWeight = 9999999999
        
        local formats = {
            function()
                return {
                    "SellSingle",
                    {
                        fishId = fishData.fishId,
                        rarity = fishData.rarity,
                        weight = bigWeight
                    }
                }
            end,
            
            function()
                return {
                    [1] = "SellSingle",
                    [2] = {
                        fishId = fishData.fishId,
                        rarity = fishData.rarity,
                        weight = bigWeight
                    }
                }
            end,
            
            function()
                return {
                    fishId = fishData.fishId,
                    rarity = fishData.rarity,
                    weight = bigWeight
                }
            end,
            
            function()
                return {
                    "Sell",
                    {
                        fishId = fishData.fishId,
                        rarity = fishData.rarity,
                        weight = bigWeight
                    }
                }
            end,
            
            function()
                return {
                    "SellAllBatch",
                    {
                        {
                            fishId = fishData.fishId
                        }
                    }
                }
            end,
            
            function()
                return {
                    fishData.fishId
                }
            end,
            
            function()
                return {
                    "SellFish",
                    fishData.fishId
                }
            end
        }
        
        local success = false
        
        if autoDetectFormat then
            for i, formatFunc in ipairs(formats) do
                if not success then
                    local args = formatFunc()
                    local worked = pcall(function()
                        SellRemote:FireServer(unpack(args))
                    end)
                    
                    if worked then
                        success = true
                        currentFormat = i
                    end
                end
            end
        else
            local formatFunc = formats[selectedFormat]
            if formatFunc then
                local args = formatFunc()
                pcall(function()
                    SellRemote:FireServer(unpack(args))
                    success = true
                    currentFormat = selectedFormat
                end)
            end
        end
        
        if success then
            soldCount = soldCount + 1
            
            if Rayfield and Rayfield.Notify then
                Rayfield:Notify({
                    Title = "💰 SOLD",
                    Content = "Ikan ke-" .. soldCount .. " terjual! (AmbonHub🚯)",
                    Duration = 1
                })
            end
        end
    end)
end

-- ============= [ FUNGSI AUTO SELL ] =============

local function shouldSell(fishData)
    local minLevel = rarityLevel[minRaritySell] or 1
    local fishLevel = rarityLevel[fishData.rarity] or 0
    return fishLevel >= minLevel
end

local function autoSellLoop()
    while autoSellEnabled do
        pcall(function()
            local equippedId = getCurrentEquippedFish()
            local inventory = getInventoryFish()
            local soldInSession = 0
            
            for _, fishData in ipairs(inventory) do
                if fishData.fishId ~= equippedId and shouldSell(fishData) then
                    sellFish(fishData)
                    soldInSession = soldInSession + 1
                    task.wait(0.3)
                end
            end
        end)
        
        task.wait(sellInterval)
    end
end

-- ============= [ FUNGSI FISHING ] =============

function manualCast()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if CastReplication then
        local args1 = {
            Vector3.new(124.21246337890625, 56.12351989746094, -833.2628173828125),
            Vector3.new(-0.8351137638092041, 23.980257034301758, 55.7108268737793),
            selectedRod,
            89.80257242918015
        }
        CastReplication:FireServer(unpack(args1))
    end
    
    if StartFishing then
        local args2 = {
            Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
        }
        StartFishing:FireServer(unpack(args2))
    end
    
    if QuestRemotes and QuestRemotes:FindFirstChild("CastRodEvent") then
        QuestRemotes.CastRodEvent:FireServer()
    end
    
    castsDone = castsDone + 1
end

function manualReel()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if RequestFishRoll then
        local args = {
            Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
        }
        local success = pcall(function()
            RequestFishRoll:InvokeServer(unpack(args))
        end)
        
        if success then
            fishCaught = fishCaught + 1
        end
    end
    
    task.wait(reelDelay)
    
    if CleanupCast then
        CleanupCast:FireServer()
    end
    
    if FishGiver then
        local args2 = {
            {
                hookPosition = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z),
                zone = selectedZone
            }
        }
        FishGiver:FireServer(unpack(args2))
    end
end

-- ============= [ CREATE WINDOW ] =============

local Window = Rayfield:CreateWindow({
    Name = "AMBONHUB🚯 FISHING BOT PREMIUM🔱",
    LoadingTitle = "Loading AmbonHub🚯 Premium Fishing...",
    LoadingSubtitle = "by Owner: AmbonHub🚯",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonHubFishingConfig",
        FileName = "Settings"
    },
    KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Auto Farm Settings - AmbonHub🚯")

MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        autoFarmEnabled = Value
        Rayfield:Notify({
            Title = "Auto Farm - AmbonHub🚯",
            Content = Value and "Started" or "Stopped",
            Duration = 2
        })
    end
})

MainTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        autoSellEnabled = Value
        if Value then
            task.spawn(autoSellLoop)
        end
        Rayfield:Notify({
            Title = "Auto Sell - AmbonHub🚯",
            Content = Value and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

MainTab:CreateDropdown({
    Name = "Select Rod",
    Options = {"Basic Rod", "Fiberglass Rod", "Carbon Rod", "Magnetic Rod"},
    CurrentOption = "Basic Rod",
    Flag = "RodSelector",
    Callback = function(Option)
        selectedRod = Option
    end
})

MainTab:CreateDropdown({
    Name = "Fishing Zone",
    Options = {"stater", "ocean", "deep", "mushgrove", "sky", "candy", "glacier", "volcano"},
    CurrentOption = "stater",
    Flag = "ZoneSelector",
    Callback = function(Option)
        selectedZone = Option
    end
})

-- Anti AFK Tab Premium
local AntiAfkTab = Window:CreateTab("Anti AFK Premium", 4483362458)
local AntiAfkSection = AntiAfkTab:CreateSection("Anti AFK Configuration - AmbonHub🚯")

AntiAfkTab:CreateToggle({
    Name = "Enable Anti AFK",
    CurrentValue = false,
    Flag = "AntiAfkToggle",
    Callback = function(Value)
        antiAfkEnabled = Value
        if not Value then
            stopBhop()
        elseif bhopEnabled and antiAfkMethod == "BHOP (Premium)" then
            startBhop()
        end
        Rayfield:Notify({
            Title = "Anti AFK - AmbonHub🚯",
            Content = Value and "Activated" or "Deactivated",
            Duration = 2
        })
    end
})

AntiAfkTab:CreateDropdown({
    Name = "Anti AFK Method",
    Options = {"Virtual Click", "Mouse Move", "Jump", "Camera Rotate", "BHOP (Premium)"},
    CurrentOption = "Mouse Move",
    Flag = "AntiAfkMethod",
    Callback = function(Option)
        antiAfkMethod = Option
        
        if Option == "BHOP (Premium)" then
            bhopEnabled = true
            if antiAfkEnabled then
                startBhop()
            end
        else
            bhopEnabled = false
            stopBhop()
        end
    end
})

AntiAfkTab:CreateSlider({
    Name = "Move Interval (Seconds)",
    Range = {5, 120},
    Increment = 5,
    Suffix = "Seconds",
    CurrentValue = 30,
    Flag = "MoveInterval",
    Callback = function(Value)
        moveInterval = Value
    end
})

AntiAfkTab:CreateToggle({
    Name = "Virtual Click (Additional)",
    CurrentValue = true,
    Flag = "VirtualClick",
    Callback = function(Value)
        virtualClickEnabled = Value
    end
})

AntiAfkTab:CreateToggle({
    Name = "BHOP Mode (Premium)",
    CurrentValue = false,
    Flag = "BhopToggle",
    Callback = function(Value)
        bhopEnabled = Value
        if Value and antiAfkEnabled and antiAfkMethod == "BHOP (Premium)" then
            startBhop()
        elseif not Value then
            stopBhop()
        end
    end
})

AntiAfkTab:CreateSlider({
    Name = "BHOP Speed",
    Range = {5, 50},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "BhopSpeed",
    Callback = function(Value)
        bhopSpeed = Value
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local TeleportSection = TeleportTab:CreateSection("Teleport Locations - AmbonHub🚯")

for locationName, _ in pairs(teleportPoints) do
    TeleportTab:CreateButton({
        Name = "Teleport to " .. locationName,
        Callback = function()
            teleportTo(locationName)
        end
    })
end

TeleportTab:CreateSection("Custom Teleport")

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
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(coords[1], coords[2], coords[3])
                        Rayfield:Notify({
                            Title = "📍 Custom Teleport - AmbonHub🚯",
                            Content = "Teleported to custom coordinates",
                            Duration = 2
                        })
                    end
                end
            end)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    local name = "Custom " .. os.date("%H:%M:%S")
                    teleportPoints[name] = CFrame.new(pos)
                    
                    TeleportTab:CreateButton({
                        Name = "Teleport to " .. name,
                        Callback = function()
                            teleportTo(name)
                        end
                    })
                    
                    Rayfield:Notify({
                        Title = "💾 Position Saved - AmbonHub🚯",
                        Content = "Position saved as: " .. name,
                        Duration = 3
                    })
                end
            end
        end)
    end
})

-- Sell Tab
local SellTab = Window:CreateTab("Sell Settings", 4483362458)
local SellSection = SellTab:CreateSection("Sell Configuration - AmbonHub🚯")

SellTab:CreateDropdown({
    Name = "Minimal Rarity",
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},
    CurrentOption = "Common",
    Flag = "RarityDropdown",
    Callback = function(Option)
        minRaritySell = Option
    end
})

SellTab:CreateSlider({
    Name = "Sell Interval",
    Range = {10, 300},
    Increment = 5,
    Suffix = "Seconds",
    CurrentValue = 60,
    Flag = "SellInterval",
    Callback = function(Value)
        sellInterval = Value
    end
})

SellTab:CreateToggle({
    Name = "Auto Detect Format",
    CurrentValue = true,
    Flag = "AutoDetect",
    Callback = function(Value)
        autoDetectFormat = Value
    end
})

SellTab:CreateDropdown({
    Name = "Manual Format (if Auto Detect off)",
    Options = {"Format 1 (SellSingle)", "Format 2 (Array)", "Format 3 (No String)", 
               "Format 4 (Sell)", "Format 5 (SellAllBatch)", "Format 6 (Simple)", "Format 7 (String ID)"},
    CurrentOption = "Format 1 (SellSingle)",
    Flag = "FormatDropdown",
    Callback = function(Option)
        local formatMap = {
            ["Format 1 (SellSingle)"] = 1,
            ["Format 2 (Array)"] = 2,
            ["Format 3 (No String)"] = 3,
            ["Format 4 (Sell)"] = 4,
            ["Format 5 (SellAllBatch)"] = 5,
            ["Format 6 (Simple)"] = 6,
            ["Format 7 (String ID)"] = 7
        }
        selectedFormat = formatMap[Option] or 1
        autoDetectFormat = false
    end
})

-- Manual Controls Tab
local ControlsTab = Window:CreateTab("Controls", 4483362458)
local ControlsSection = ControlsTab:CreateSection("Manual Actions - AmbonHub🚯")

ControlsTab:CreateButton({
    Name = "Cast Rod",
    Callback = function()
        manualCast()
    end
})

ControlsTab:CreateButton({
    Name = "Reel Fish",
    Callback = function()
        manualReel()
    end
})

ControlsTab:CreateButton({
    Name = "Scan Inventory",
    Callback = function()
        local inv = getInventoryFish()
        Rayfield:Notify({
            Title = "Inventory - AmbonHub🚯",
            Content = "Found " .. #inv .. " fish",
            Duration = 3
        })
    end
})

ControlsTab:CreateButton({
    Name = "Sell All Now",
    Callback = function()
        local equippedId = getCurrentEquippedFish()
        local inventory = getInventoryFish()
        local count = 0
        
        for _, fishData in ipairs(inventory) do
            if fishData.fishId ~= equippedId then
                sellFish(fishData)
                count = count + 1
                task.wait(0.3)
            end
        end
        
        Rayfield:Notify({
            Title = "Sell Complete - AmbonHub🚯",
            Content = "Sold " .. count .. " fish",
            Duration = 3
        })
    end
})

-- About Tab
local AboutTab = Window:CreateTab("About", 4483362458)
local AboutSection = AboutTab:CreateSection("Information")

AboutTab:CreateLabel("🔱 AMBONHUB🚯 PREMIUM FISHING BOT")
AboutTab:CreateLabel("👑 Owner: AmbonHub🚯")
AboutTab:CreateLabel("📅 Version: 2.0.0")
AboutTab:CreateLabel("🎣 Features:")
AboutTab:CreateLabel("  • Auto Farm + Auto Sell")
AboutTab:CreateLabel("  • Anti AFK Premium (5 Methods)")
AboutTab:CreateLabel("  • BHOP Mode (Premium)")
AboutTab:CreateLabel("  • Teleport (6 Locations)")
AboutTab:CreateLabel("  • Multi Format Sell (7 Formats)")
AboutTab:CreateLabel("  • Auto Detect Remote")
AboutTab:CreateLabel("")
AboutTab:CreateLabel("💎 Thanks for using AmbonHub🚯!")

-- ============= [ AUTO FARM LOOP ] =============

task.spawn(function()
    while true do
        if autoFarmEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                manualCast()
                task.wait(castDelay)
                manualReel()
            end
        end
        task.wait(loopDelay)
    end
end)

-- ============= [ START ] =============

Rayfield:Notify({
    Title = "AMBONHUB🚯 Script Loaded",
    Content = "Premium Fishing Bot Ready! (6 Locations + Anti AFK)",
    Duration = 5
})

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔥 AMBONHUB🚯 PREMIUM FISHING BOT - SUCCESSFULLY LOADED")
print("👑 OWNER: AmbonHub🚯")
print("📍 TELEPORT: 6 Locations Ready")
print("🎣 ANTI AFK: 5 Premium Methods + BHOP")
print("💰 AUTO SELL: 7 Format Detection")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Auto-start BHOP if enabled
if bhopEnabled and antiAfkEnabled then
    startBhop()
end