-- ⚡ AUTO FISHING MOBILE - HYPER TURBO MODE
-- 🎣 By: Fishing Master

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local SecureFishingAction = FishingSystem:WaitForChild("SecureFishingAction")
local FishingCatchSuccess = ReplicatedStorage:WaitForChild("FishingCatchSuccess")
local UserInputService = game:GetService("UserInputService")

-- 🎮 TUNGGU PLAYERGUI SIAP
repeat wait() until Player:FindFirstChild("PlayerGui")

-- 🗑️ HAPUS GUI LAMA JIKA ADA
if Player.PlayerGui:FindFirstChild("AutoFishHyper") then
    Player.PlayerGui.AutoFishHyper:Destroy()
end

-- 🖼️ BUAT GUI BARU
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishHyper"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player.PlayerGui

-- 🎨 MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 270)
MainFrame.Position = UDim2.new(0.5, -170, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- 🔵 ROUND CORNERS
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- 🎯 HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15, 0, 0)
HeaderCorner.Parent = Header

-- ICON
local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Size = UDim2.new(0, 30, 0, 30)
Icon.Position = UDim2.new(0.02, 0, 0.5, -15)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://7072725349" -- Fishing icon
Icon.Parent = Header

-- TITLE
local Title = Instance.new("TextLabel")
Title.Text = "AMBON EWE JULE🥴🤤"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.15, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- MINIMIZE BUTTON
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Text = "_"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = Header

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Header

-- CONTENT AREA
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -40)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- 🟢 MAIN TOGGLE BUTTON
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Text = "▶ START EWE"
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 60)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.05, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.Parent = Content

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = ToggleBtn

-- ⚡ SPEED MODE SELECTOR
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0.85, 0, 0, 120)
SpeedFrame.Position = UDim2.new(0.075, 0, 0.35, 0)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = Content

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 10)
SpeedCorner.Parent = SpeedFrame

-- SPEED TITLE
local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Text = "⚡ SPEED MODE:"
SpeedTitle.Size = UDim2.new(1, 0, 0, 30)
SpeedTitle.Position = UDim2.new(0, 0, 0, 0)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 150)
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextSize = 16
SpeedTitle.Parent = SpeedFrame

-- SPEED BUTTONS
local NormalSpeed = Instance.new("TextButton")
NormalSpeed.Name = "NormalSpeed"
NormalSpeed.Text = "NORMAL"
NormalSpeed.Size = UDim2.new(0.28, 0, 0, 30)
NormalSpeed.Position = UDim2.new(0.05, 0, 0.35, 0)
NormalSpeed.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
NormalSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
NormalSpeed.Font = Enum.Font.GothamBold
NormalSpeed.TextSize = 12
NormalSpeed.Parent = SpeedFrame

local FastSpeed = Instance.new("TextButton")
FastSpeed.Name = "FastSpeed"
FastSpeed.Text = "FAST"
FastSpeed.Size = UDim2.new(0.28, 0, 0, 30)
FastSpeed.Position = UDim2.new(0.36, 0, 0.35, 0)
FastSpeed.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FastSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
FastSpeed.Font = Enum.Font.GothamBold
FastSpeed.TextSize = 12
FastSpeed.Parent = SpeedFrame

-- SPEED INDICATOR
local SpeedIndicator = Instance.new("TextLabel")
SpeedIndicator.Name = "SpeedIndicator"
SpeedIndicator.Text = "Selected: HYPER ⚡"
SpeedIndicator.Size = UDim2.new(1, 0, 0, 20)
SpeedIndicator.Position = UDim2.new(0, 0, 0.95, -20)
SpeedIndicator.BackgroundTransparency = 1
SpeedIndicator.TextColor3 = Color3.fromRGB(255, 50, 50)
SpeedIndicator.Font = Enum.Font.GothamBold
SpeedIndicator.TextSize = 13
SpeedIndicator.Parent = SpeedFrame

-- 📊 STATS DISPLAY
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(0.85, 0, 0, 60)
StatsFrame.Position = UDim2.new(0.075, 0, 0.8, 0)
StatsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
StatsFrame.BorderSizePixel = 0
StatsFrame.Parent = Content

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 10)
StatsCorner.Parent = StatsFrame

-- TOTAL FISH
local TotalLabel = Instance.new("TextLabel")
TotalLabel.Name = "TotalLabel"
TotalLabel.Text = "🐟 Total: 0"
TotalLabel.Size = UDim2.new(0.9, 0, 0, 25)
TotalLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
TotalLabel.BackgroundTransparency = 1
TotalLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
TotalLabel.Font = Enum.Font.Gotham
TotalLabel.TextSize = 14
TotalLabel.TextXAlignment = Enum.TextXAlignment.Left
TotalLabel.Parent = StatsFrame

-- SECRET FISH
local SecretLabel = Instance.new("TextLabel")
SecretLabel.Name = "SecretLabel"
SecretLabel.Text = "⭐ Secret: 0 (0%)"
SecretLabel.Size = UDim2.new(0.9, 0, 0, 25)
SecretLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
SecretLabel.BackgroundTransparency = 1
SecretLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
SecretLabel.Font = Enum.Font.Gotham
SecretLabel.TextSize = 14
SecretLabel.TextXAlignment = Enum.TextXAlignment.Left
SecretLabel.Parent = StatsFrame

-- 🎣 FLOATING ICON (Minimized Mode)
local FloatingIcon = Instance.new("ImageButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Size = UDim2.new(0, 60, 0, 60)
FloatingIcon.Position = UDim2.new(1, -70, 0.5, -30)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
FloatingIcon.Image = "rbxassetid://7072725349" -- Same fishing icon
FloatingIcon.Visible = false
FloatingIcon.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 15)
FloatingCorner.Parent = FloatingIcon

local FloatingTitle = Instance.new("TextLabel")
FloatingTitle.Name = "FloatingTitle"
FloatingTitle.Text = "FISHING"
FloatingTitle.Size = UDim2.new(1, 0, 0, 15)
FloatingTitle.Position = UDim2.new(0, 0, 1, -15)
FloatingTitle.BackgroundTransparency = 1
FloatingTitle.TextColor3 = Color3.fromRGB(255, 100, 255)
FloatingTitle.Font = Enum.Font.GothamBold
FloatingTitle.TextSize = 10
FloatingTitle.Parent = FloatingIcon

-- 📈 VARIABLES
local fishingActive = false
local character = Player.Character or Player.CharacterAdded:Wait()
local isMinimized = false
local stats = {
    total = 0,
    secret = 0
}

-- ⚡ SPEED CONFIGURATION - SUPER FAST!
local speedConfig = {
    NORMAL = {
        castDelay = 2.5,
        catchDelay = 0.8,
        waitDelay = 1.5,
        secretChance = 5,
        color = Color3.fromRGB(0, 100, 200)
    },
    FAST = {
        castDelay = 1.5,
        catchDelay = 0.5,
        waitDelay = 0.3,
        secretChance = 999999,
        color = Color3.fromRGB(255, 0, 0)
    }
}

local currentSpeed = "HYPER"

-- 🔄 TOGGLE MINIMIZE
function toggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimize to icon
        MainFrame.Visible = false
        FloatingIcon.Visible = true
        MinimizeBtn.Text = "□"
        
        -- Save position for floating icon
        FloatingIcon.Position = MainFrame.Position
        
        -- Notification
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fishing Minimized",
            Text = "Click icon to restore",
            Duration = 2
        })
        
        print("[Auto Fishing] GUI minimized to icon")
    else
        -- Restore from icon
        MainFrame.Visible = true
        FloatingIcon.Visible = false
        MinimizeBtn.Text = "_"
        
        print("[Auto Fishing] GUI restored")
    end
end

-- 🎣 GET BEST ROD
function getBestRod()
    local backpack = Player.Backpack
    local characterTools = character:GetChildren()
    
    local rodPriority = {
        "Dead Mist Crythe",
        "Basic Rod"
    }
    
    for _, tool in ipairs(characterTools) do
        if tool:IsA("Tool") then
            for _, rodName in ipairs(rodPriority) do
                if string.find(tool.Name:upper(), rodName:upper():gsub(" ", "")) then
                    return rodName
                end
            end
        end
    end
    
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for _, rodName in ipairs(rodPriority) do
                if string.find(tool.Name:upper(), rodName:upper():gsub(" ", "")) then
                    return rodName
                end
            end
        end
    end
    
    return "Basic Rod"
end

-- 🎯 GET PLAYER POSITION
function getPlayerPosition()
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart.Position
    end
    return Vector3.new(228.20892333984375, 142.8692169189453, 506.9288635253906)
end

-- 🚀 HYPER FISHING FUNCTION
function hyperFishing()
    if not fishingActive then return false end
    
    local config = speedConfig[currentSpeed]
    local rod = getBestRod()
    
    -- CAST FISHING
    local args = {
        "Cast",
        getPlayerPosition(),
        Vector3.new(-22.094337463378906, 5, 11.697874069213867),
        rod,
        93
    }
    
    SecureFishingAction:FireServer(unpack(args))
    wait(config.castDelay)
    
    -- CATCH SUCCESS
    FishingCatchSuccess:FireServer()
    wait(config.catchDelay)
    
    -- CATCH FISH
    local catchArgs = {
        "Catch",
        0
    }
    SecureFishingAction:FireServer(unpack(catchArgs))
    
    -- UPDATE STATS
    stats.total = stats.total + 1
    TotalLabel.Text = string.format("🐟 Total: %d", stats.total)
    
    -- UPDATE FLOATING ICON TITLE
    FloatingTitle.Text = string.format("FISH: %d", stats.total)
    
    -- CHECK FOR SECRET FISH
    if math.random(1, 100) <= config.secretChance then
        stats.secret = stats.secret + 1
        local percentage = stats.total > 0 and math.floor((stats.secret / stats.total) * 100) or 0
        SecretLabel.Text = string.format("⭐ Secret: %d (%d%%)", stats.secret, percentage)
        
        -- UPDATE FLOATING ICON FOR SECRET
        FloatingIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)
        wait(0.3)
        FloatingIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        
        -- CELEBRATION FOR SECRET FISH
        for i = 1, 2 do
            wait(0.05)
            local bonusArgs = {"Bonus", "Secret"}
            SecureFishingAction:FireServer(unpack(bonusArgs))
        end
    else
        local percentage = stats.total > 0 and math.floor((stats.secret / stats.total) * 100) or 0
        SecretLabel.Text = string.format("⭐ Secret: %d (%d%%)", stats.secret, percentage)
    end
    
    return true
end

-- 🔄 MAIN FISHING LOOP
function startFishingLoop()
    while fishingActive do
        local success = hyperFishing()
        
        if success then
            local config = speedConfig[currentSpeed]
            wait(config.waitDelay)
            
            -- PERFORMANCE OPTIMIZATION
            if stats.total % 50 == 0 then
                wait(0.05)
            end
        else
            wait(0.2)
        end
    end
end

-- ⚡ CHANGE SPEED MODE
function changeSpeedMode(mode)
    currentSpeed = mode
    SpeedIndicator.Text = "Selected: " .. mode .. " ⚡"
    SpeedIndicator.TextColor3 = speedConfig[mode].color
    
    -- RESET ALL BUTTON COLORS
    for _, modeName in pairs({"NORMAL", "FAST"}) do
        local btn = SpeedFrame:FindFirstChild(modeName .. "Speed")
        if btn then
            btn.BackgroundColor3 = speedConfig[modeName].color
        end
    end
    
    -- HIGHLIGHT SELECTED
    local selectedBtn = SpeedFrame:FindFirstChild(mode .. "Speed")
    if selectedBtn then
        selectedBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        selectedBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    
    -- UPDATE TITLE COLOR
    local colors = {
        NORMAL = Color3.fromRGB(0, 150, 255),
        FAST = Color3.fromRGB(255, 0, 0)
    }
    Title.TextColor3 = colors[mode] or Color3.fromRGB(255, 100, 255)
    
    -- UPDATE FLOATING ICON COLOR
    FloatingIcon.BackgroundColor3 = colors[mode] or Color3.fromRGB(25, 25, 40)
    
    -- NOTIFICATION
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ " .. mode .. " MODE",
        Text = "Speed activated!",
        Duration = 2
    })
    
    print("[Auto Fishing] Speed mode changed to: " .. mode)
end

-- 🔘 TOGGLE FISHING FUNCTION
function toggleFishing()
    fishingActive = not fishingActive
    
    if fishingActive then
        -- START FISHING
        ToggleBtn.Text = "⏸ STOP EWE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        -- UPDATE FLOATING ICON
        FloatingIcon.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        FloatingTitle.Text = "FISHING..."
        
        -- START LOOP
        spawn(function()
            startFishingLoop()
        end)
        
        -- NOTIFICATION
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⚡ " .. currentSpeed .. " MODE",
            Text = "Fishing at MAX speed!",
            Duration = 3
        })
        
        print("[Auto Fishing] Fishing STARTED - Mode: " .. currentSpeed)
    else
        -- STOP FISHING
        ToggleBtn.Text = "▶ START EWE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- UPDATE FLOATING ICON
        local colors = {
            NORMAL = Color3.fromRGB(0, 150, 255),
            FAST = Color3.fromRGB(255, 0, 0)
        }
        FloatingIcon.BackgroundColor3 = colors[currentSpeed] or Color3.fromRGB(25, 25, 40)
        FloatingTitle.Text = string.format("FISH: %d", stats.total)
        
        -- NOTIFICATION
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🎣 FISHING STOPPED",
            Text = string.format("Total: %d | Secret: %d", stats.total, stats.secret),
            Duration = 3
        })
        
        print("[Auto Fishing] Fishing STOPPED")
    end
end

-- 🎮 EVENT LISTENERS
ToggleBtn.MouseButton1Click:Connect(toggleFishing)

MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)

FloatingIcon.MouseButton1Click:Connect(function()
    toggleMinimize()
end)

NormalSpeed.MouseButton1Click:Connect(function()
    changeSpeedMode("NORMAL")
end)

FastSpeed.MouseButton1Click:Connect(function()
    changeSpeedMode("FAST")
end)

CloseBtn.MouseButton1Click:Connect(function()
    fishingActive = false
    ScreenGui:Destroy()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Fishing",
        Text = "Script closed",
        Duration = 2
    })
end)

-- 🏃 HANDLE CHARACTER CHANGES
Player.CharacterAdded:Connect(function(newChar)
    character = newChar
    wait(0.3)
    print("[Auto Fishing] Character updated")
end)

-- 🎯 MAKE UI DRAGGABLE
local dragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = Vector2.new(0, 0)

local funct