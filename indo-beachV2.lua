-- GUI Auto Farm untuk Fishing Simulator
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Buat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0, 20, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner untuk frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Judul
local Title = Instance.new("Frame")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Auto Farm Fishing"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = Title

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = Title

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 15)
MinimizeCorner.Parent = MinimizeButton

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 15)
CloseCorner.Parent = CloseButton

-- Content Frame (semua konten di sini agar bisa di hide/show)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Status Auto Farm
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 16
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = ContentFrame

-- Stats Counter
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "StatsLabel"
StatsLabel.Size = UDim2.new(1, -20, 0, 30)
StatsLabel.Position = UDim2.new(0, 10, 0, 40)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Cycle: 0 | Success: 0"
StatsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextSize = 14
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = ContentFrame

-- Cast Distance Settings
local DistanceFrame = Instance.new("Frame")
DistanceFrame.Name = "DistanceFrame"
DistanceFrame.Size = UDim2.new(1, -20, 0, 40)
DistanceFrame.Position = UDim2.new(0, 10, 0, 70)
DistanceFrame.BackgroundTransparency = 1
DistanceFrame.Parent = ContentFrame

local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Name = "DistanceLabel"
DistanceLabel.Size = UDim2.new(0.5, 0, 1, 0)
DistanceLabel.Position = UDim2.new(0, 0, 0, 0)
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.Text = "Jarak Cast:"
DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceLabel.Font = Enum.Font.Gotham
DistanceLabel.TextSize = 14
DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
DistanceLabel.Parent = DistanceFrame

local DistanceBox = Instance.new("TextBox")
DistanceBox.Name = "DistanceBox"
DistanceBox.Size = UDim2.new(0.3, 0, 0.7, 0)
DistanceBox.Position = UDim2.new(0.5, 0, 0.15, 0)
DistanceBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DistanceBox.Text = "50"
DistanceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceBox.Font = Enum.Font.Gotham
DistanceBox.TextSize = 14
DistanceBox.Parent = DistanceFrame

local DistanceCorner = Instance.new("UICorner")
DistanceCorner.CornerRadius = UDim.new(0, 4)
DistanceCorner.Parent = DistanceBox

-- Cast Height Settings
local HeightFrame = Instance.new("Frame")
HeightFrame.Name = "HeightFrame"
HeightFrame.Size = UDim2.new(1, -20, 0, 40)
HeightFrame.Position = UDim2.new(0, 10, 0, 110)
HeightFrame.BackgroundTransparency = 1
HeightFrame.Parent = ContentFrame

local HeightLabel = Instance.new("TextLabel")
HeightLabel.Name = "HeightLabel"
HeightLabel.Size = UDim2.new(0.5, 0, 1, 0)
HeightLabel.Position = UDim2.new(0, 0, 0, 0)
HeightLabel.BackgroundTransparency = 1
HeightLabel.Text = "Tinggi Cast:"
HeightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightLabel.Font = Enum.Font.Gotham
HeightLabel.TextSize = 14
HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
HeightLabel.Parent = HeightFrame

local HeightBox = Instance.new("TextBox")
HeightBox.Name = "HeightBox"
HeightBox.Size = UDim2.new(0.3, 0, 0.7, 0)
HeightBox.Position = UDim2.new(0.5, 0, 0.15, 0)
HeightBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HeightBox.Text = "30"
HeightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightBox.Font = Enum.Font.Gotham
HeightBox.TextSize = 14
HeightBox.Parent = HeightFrame

local HeightCorner = Instance.new("UICorner")
HeightCorner.CornerRadius = UDim.new(0, 4)
HeightCorner.Parent = HeightBox

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 140, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -70, 0, 160)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.Text = "START FARM"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = ContentFrame

-- Corner untuk button
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- Delay Settings
local DelayFrame = Instance.new("Frame")
DelayFrame.Name = "DelayFrame"
DelayFrame.Size = UDim2.new(1, -20, 0, 40)
DelayFrame.Position = UDim2.new(0, 10, 0, 205)
DelayFrame.BackgroundTransparency = 1
DelayFrame.Parent = ContentFrame

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Name = "DelayLabel"
DelayLabel.Size = UDim2.new(0.5, 0, 1, 0)
DelayLabel.Position = UDim2.new(0, 0, 0, 0)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay (detik):"
DelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.TextSize = 14
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = DelayFrame

local DelayBox = Instance.new("TextBox")
DelayBox.Name = "DelayBox"
DelayBox.Size = UDim2.new(0.3, 0, 0.7, 0)
DelayBox.Position = UDim2.new(0.5, 0, 0.15, 0)
DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DelayBox.Text = "3"
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Font = Enum.Font.Gotham
DelayBox.TextSize = 14
DelayBox.Parent = DelayFrame

local DelayCorner = Instance.new("UICorner")
DelayCorner.CornerRadius = UDim.new(0, 4)
DelayCorner.Parent = DelayBox

-- Button untuk reset counter
local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(0, 120, 0, 30)
ResetButton.Position = UDim2.new(0.5, -60, 0, 250)
ResetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ResetButton.Text = "Reset Counter"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.Font = Enum.Font.Gotham
ResetButton.TextSize = 14
ResetButton.Parent = ContentFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 6)
ResetCorner.Parent = ResetButton

-- Info hotkey
local HotkeyLabel = Instance.new("TextLabel")
HotkeyLabel.Name = "HotkeyLabel"
HotkeyLabel.Size = UDim2.new(1, -20, 0, 20)
HotkeyLabel.Position = UDim2.new(0, 10, 0, 285)
HotkeyLabel.BackgroundTransparency = 1
HotkeyLabel.Text = "F9: Toggle | F10: Reset"
HotkeyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
HotkeyLabel.Font = Enum.Font.Gotham
HotkeyLabel.TextSize = 12
HotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
HotkeyLabel.Parent = ContentFrame

-- Auto update position display
local PositionLabel = Instance.new("TextLabel")
PositionLabel.Name = "PositionLabel"
PositionLabel.Size = UDim2.new(1, -20, 0, 20)
PositionLabel.Position = UDim2.new(0, 10, 0, 305)
PositionLabel.BackgroundTransparency = 1
PositionLabel.Text = "Pos: Calculating..."
PositionLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
PositionLabel.Font = Enum.Font.Gotham
PositionLabel.TextSize = 12
PositionLabel.TextXAlignment = Enum.TextXAlignment.Left
PositionLabel.Parent = ContentFrame

-- Drag functionality
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Auto Farm Variables
local AutoFarmEnabled = false
local Delay = 3 -- Default delay
local CastDistance = 50 -- Default jarak cast
local CastHeight = 30 -- Default tinggi cast
local CycleCount = 0
local SuccessCount = 0
local AutoFarmThread = nil
local IsMinimized = false

-- Minimize Toggle Function
MinimizeButton.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    
    if IsMinimized then
        -- Minimize: hanya tampilkan title bar
        MainFrame.Size = UDim2.new(0, 320, 0, 40)
        MinimizeButton.Text = "+"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    else
        -- Restore: tampilkan semua
        MainFrame.Size = UDim2.new(0, 320, 0, 280)
        MinimizeButton.Text = "-"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

-- Function untuk update settings
DistanceBox.FocusLost:Connect(function(enterPressed)
    local newDistance = tonumber(DistanceBox.Text)
    if newDistance and newDistance > 0 then
        CastDistance = newDistance
        DistanceBox.Text = tostring(CastDistance)
    else
        DistanceBox.Text = tostring(CastDistance)
    end
end)

HeightBox.FocusLost:Connect(function(enterPressed)
    local newHeight = tonumber(HeightBox.Text)
    if newHeight and newHeight > 0 then
        CastHeight = newHeight
        HeightBox.Text = tostring(CastHeight)
    else
        HeightBox.Text = tostring(CastHeight)
    end
end)

DelayBox.FocusLost:Connect(function(enterPressed)
    local newDelay = tonumber(DelayBox.Text)
    if newDelay and newDelay > 0 then
        Delay = newDelay
        DelayBox.Text = tostring(Delay)
    else
        DelayBox.Text = tostring(Delay)
    end
end)

-- Function untuk mendapatkan kordinat cast berdasarkan posisi player
local function GetCastPosition()
    if not LocalPlayer.Character then return nil end
    
    local character = LocalPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then return nil end
    
    -- Dapatkan posisi player saat ini
    local playerPosition = humanoidRootPart.Position
    
    -- Dapatkan arah hadap player
    local playerCFrame = humanoidRootPart.CFrame
    local lookVector = playerCFrame.LookVector
    
    -- Hitung posisi target (depan player)
    local targetPosition = playerPosition + (lookVector * CastDistance)
    
    -- Buat CFrame untuk cast (menggunakan rotasi player)
    local targetCFrame = CFrame.new(
        playerPosition.X + (lookVector.X * 10),  -- Sedikit di depan player untuk lempar
        playerPosition.Y + CastHeight,           -- Tinggi cast
        playerPosition.Z + (lookVector.Z * 10)
    ) * CFrame.Angles(math.rad(-45), 0, 0)       -- Sudut lempar 45 derajat ke bawah
    
    -- Return position dan CFrame untuk RemoteThrow
    return {
        Position = targetPosition,
        CFrame = targetCFrame
    }
end

-- Function untuk menjalankan fishing cycle sekali
local function RunFishingCycle()
    -- Dapatkan posisi cast berdasarkan posisi player saat ini
    local castData = GetCastPosition()
    
    if not castData then
        warn("Tidak bisa mendapatkan posisi player!")
        return false
    end
    
    -- Cycle 1: Lempar kail
    local args = {
        castData.Position,  -- Vector3 target position
        castData.CFrame,    -- CFrame untuk lempar
        CastDistance,       -- Jarak cast
        CastHeight,         -- Tinggi cast
        LocalPlayer         -- Player yang melempar
    }
    
    local success = pcall(function()
        ReplicatedStorage:WaitForChild("RemoteThrow"):FireServer(unpack(args))
    end)
    
    if not success then
        warn("Gagal memanggil RemoteThrow!")
        return false
    end
    
    wait(1.5) -- Tunggu kail masuk air
    
    -- Cycle 2: Ambil ikan
    local fishSuccess = pcall(function()
        ReplicatedStorage:WaitForChild("GiveFishFunction"):InvokeServer()
    end)
    
    if fishSuccess then
        SuccessCount = SuccessCount + 1
    end
    
    wait(1) -- Tunggu proses ambil ikan
    
    -- Cycle 3: Tarik kail
    pcall(function()
        ReplicatedStorage:WaitForChild("RemoteRetract"):FireServer()
    end)
    
    -- Update cycle counter
    CycleCount = CycleCount + 1
    StatsLabel.Text = string.format("Cycle: %d | Success: %d", CycleCount, SuccessCount)
    
    return true
end

-- Function untuk auto farm loop
local function StartAutoFarm()
    AutoFarmThread = task.spawn(function()
        while AutoFarmEnabled do
            -- Cek apakah player masih ada
            if not LocalPlayer.Character then
                wait(1)
                continue
            end
            
            -- Jalankan satu cycle fishing
            RunFishingCycle()
            
            -- Tunggu delay sebelum cycle berikutnya
            local waitTime = Delay
            local startTime = tick()
            
            -- Selama delay, cek apakah auto farm masih enabled
            while tick() - startTime < waitTime do
                if not AutoFarmEnabled then
                    break
                end
                wait(0.1)
            end
        end
    end)
end

-- Function untuk stop auto farm
local function StopAutoFarm()
    if AutoFarmThread then
        task.cancel(AutoFarmThread)
        AutoFarmThread = nil
    end
end

-- Toggle Auto Farm
ToggleButton.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    
    if AutoFarmEnabled then
        ToggleButton.Text = "STOP FARM"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "Status: RUNNING"
        StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Update settings sebelum start
        CastDistance = tonumber(DistanceBox.Text) or CastDistance
        CastHeight = tonumber(HeightBox.Text) or CastHeight
        Delay = tonumber(DelayBox.Text) or Delay
        
        -- Start auto farm
        StartAutoFarm()
        
        -- Notifikasi
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Farm Started",
            Text = string.format("Jarak: %d | Tinggi: %d | Delay: %ds", CastDistance, CastHeight, Delay),
            Duration = 3
        })
    else
        ToggleButton.Text = "START FARM"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Stop auto farm
        StopAutoFarm()
        
        -- Notifikasi
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Farm Stopped",
            Text = string.format("Completed %d cycles (%d success)", CycleCount, SuccessCount),
            Duration = 3
        })
    end
end)

-- Reset counter button
ResetButton.MouseButton1Click:Connect(function()
    CycleCount = 0
    SuccessCount = 0
    StatsLabel.Text = "Cycle: 0 | Success: 0"
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    -- Stop auto farm sebelum close
    if AutoFarmEnabled then
        StopAutoFarm()
    end
    ScreenGui:Destroy()
end)

-- Hotkey untuk toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F9 then
            ToggleButton:MouseButton1Click()
        elseif input.KeyCode == Enum.KeyCode.F10 then
            ResetButton:MouseButton1Click()
        elseif input.KeyCode == Enum.KeyCode.F11 then
            MinimizeButton:MouseButton1Click() -- Hotkey untuk minimize
        end
    end
end)

-- Update hotkey label dengan hotkey minimize
HotkeyLabel.Text = "F9: Toggle | F10: Reset | F11: Min/Max"

-- Update position display setiap 0.5 detik
local PositionUpdateThread = task.spawn(function()
    while ScreenGui.Parent do
        if not IsMinimized then -- Hanya update posisi jika tidak minimized
            if LocalPlayer.Character then
                local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local pos = humanoidRootPart.Position
                    PositionLabel.Text = string.format("Pos: X:%.1f Y:%.1f Z:%.1f", pos.X, pos.Y, pos.Z)
                end
            end
        end
        wait(0.5)
    end
end)

-- Notification untuk minimize
MinimizeButton.MouseEnter:Connect(function()
    if not IsMinimized then
        MinimizeButton.Text = "-"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    else
        MinimizeButton.Text = "+"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

MinimizeButton.MouseLeave:Connect(function()
    if not IsMinimized then
        MinimizeButton.Text = "-"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    else
        MinimizeButton.Text = "+"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Clean up ketika GUI di destroy
ScreenGui.Destroying:Connect(function()
    if PositionUpdateThread then
        task.cancel(PositionUpdateThread)
    end
    if AutoFarmThread then
        StopAutoFarm()
    end
end)

print("Auto Farm GUI Loaded! - Made by Human Bro")
print("Press F9 to toggle auto farm | F10 to reset counter | F11 to minimize")
print("Cast position will follow player's current position!")