-- AUTO FISHING FARM - GUI SIMPLE
-- Versi simple, tanpa Rayfield, pasti work!

-- Bersihin koneksi lama
if getgenv().FishingHB and getgenv().FishingHB.Connection then
    getgenv().FishingHB.Connection:Disconnect()
end

-- Inisialisasi
getgenv().FishingHB = getgenv().FishingHB or {}
getgenv().FishingHB.Enabled = false

local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Setup net
local net = RS
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

-- Fungsi fishing
local function Fishing()
    pcall(function()
        net:WaitForChild("RF/ChargeFishingRod"):InvokeServer()
        net:WaitForChild("RF/RequestFishingMinigameStarted"):InvokeServer(-1.233184814453125, 0.5, 1770664767.08607)
        net:WaitForChild("RE/FishingCompleted"):FireServer()
    end)
end

-- Fungsi toggle auto farm
local function ToggleAutoFarm()
    getgenv().FishingHB.Enabled = not getgenv().FishingHB.Enabled
    
    if getgenv().FishingHB.Enabled then
        -- Start auto farm
        if getgenv().FishingHB.Connection then
            getgenv().FishingHB.Connection:Disconnect()
        end
        
        getgenv().FishingHB.Connection = RunService.Heartbeat:Connect(function()
            if getgenv().FishingHB.Enabled then
                Fishing()
            end
        end)
    else
        -- Stop auto farm
        if getgenv().FishingHB.Connection then
            getgenv().FishingHB.Connection:Disconnect()
            getgenv().FishingHB.Connection = nil
        end
    end
end

-- ================ BUAT GUI ================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishingGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

-- Shadow/Stroke
local Stroke = Instance.new("UICorner")
Stroke.CornerRadius = UDim.new(0, 8)
Stroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 35)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "🐟 Ambon Hub | Fishing"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundTransparency = 1
CloseButton.Size = UDim2.new(0, 35, 1, 0)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.ZIndex = 2

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if getgenv().FishingHB and getgenv().FishingHB.Connection then
        getgenv().FishingHB.Connection:Disconnect()
    end
end)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 45)
ContentFrame.Size = UDim2.new(1, 0, 1, -50)

-- !!! INI TOMBOL AUTO FARMNYA !!!
local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Name = "AutoFarmButton"
AutoFarmButton.Parent = ContentFrame
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
AutoFarmButton.BorderSizePixel = 0
AutoFarmButton.Position = UDim2.new(0, 20, 0, 10)
AutoFarmButton.Size = UDim2.new(0, 210, 0, 45)
AutoFarmButton.Text = "🎣 BLAR²: OFF"
AutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmButton.TextSize = 18
AutoFarmButton.Font = Enum.Font.GothamBold

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = AutoFarmButton

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = ContentFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StatusLabel.BorderSizePixel = 0
StatusLabel.Position = UDim2.new(0, 20, 0, 70)
StatusLabel.Size = UDim2.new(0, 210, 0, 35)
StatusLabel.Text = "⏹️ Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.GothamSemibold

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusLabel

-- Manual Fish Button
local ManualButton = Instance.new("TextButton")
ManualButton.Name = "ManualButton"
ManualButton.Parent = ContentFrame
ManualButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ManualButton.BorderSizePixel = 0
ManualButton.Position = UDim2.new(0, 20, 0, 120)
ManualButton.Size = UDim2.new(0, 100, 0, 35)
ManualButton.Text = "🎯 Manual"
ManualButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ManualButton.TextSize = 16
ManualButton.Font = Enum.Font.GothamSemibold

local ManualCorner = Instance.new("UICorner")
ManualCorner.CornerRadius = UDim.new(0, 6)
ManualCorner.Parent = ManualButton

-- Stop Button
local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Parent = ContentFrame
StopButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
StopButton.BorderSizePixel = 0
StopButton.Position = UDim2.new(0, 130, 0, 120)
StopButton.Size = UDim2.new(0, 100, 0, 35)
StopButton.Text = "🛑 Stop"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 16
StopButton.Font = Enum.Font.GothamSemibold

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopButton

-- ================ FUNGSI TOMBOL ================

-- Update tampilan
local function UpdateUI()
    if getgenv().FishingHB.Enabled then
        AutoFarmButton.Text = "🎣 BLAR-BLAR: ON"
        AutoFarmButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50) -- Hijau
        StatusLabel.Text = "✅ Status: ON (Nyawittt...)"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        AutoFarmButton.Text = "🎣 BLAR-BLAR: OFF"
        AutoFarmButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225) -- Biru
        StatusLabel.Text = "⏹️ Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
end

-- Tombol Auto Farm
AutoFarmButton.MouseButton1Click:Connect(function()
    ToggleAutoFarm()
    UpdateUI()
end)

-- Tombol Manual
ManualButton.MouseButton1Click:Connect(function()
    Fishing()
    AutoFarmButton.Text = "🎣 Manual Fishing..."
    task.wait(0.5)
    UpdateUI()
end)

-- Tombol Stop
StopButton.MouseButton1Click:Connect(function()
    if getgenv().FishingHB.Enabled then
        ToggleAutoFarm()
        UpdateUI()
    end
end)

-- Update UI setiap detik
spawn(function()
    while ScreenGui and ScreenGui.Parent do
        UpdateUI()
        wait(0.5)
    end
end)

-- Notifikasi
local Notification = Instance.new("TextLabel")
Notification.Parent = MainFrame
Notification.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Notification.BackgroundTransparency = 0.2
Notification.Position = UDim2.new(0, 100, 1, -165)
Notification.Size = UDim2.new(0, 210, 0, 30)
Notification.Text = "✅ Siap Nyawittt🌴 Wokk"
Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
Notification.TextSize = 14
Notification.Font = Enum.Font.Gotham

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 6)
NotifCorner.Parent = Notification

task.wait(3)
Notification:Destroy()

print("✅ Auto Fishing Farm siap! GUI udah muncul")
