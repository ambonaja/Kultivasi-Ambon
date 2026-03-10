-- AMBONHUB V16 - RAYFIELD EDITION (FINAL)
-- By AmbonHub🚯

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

-- ===== VARIABEL GLOBAL =====
local savedWalkSpeed = 16
local savedJumpPower = 50
local isAutoFishing = false
local isKageFishing = false
local sessionStats = { caught = 0, failed = 0 }
local catchSpeedDelay = 0.5
local throwPowerDelay = 1.6
local bobberDebounce = false
local throwCooldown = 0
local rDelays = { BobberToStart = 1.5, Reel = 1.5, Retract = 0.3, Throw = 0.5 }
local infJump = false
local noclipConn = nil
local antiAfkEnabled = false

-- ===== ANTI AFK FUNCTION =====
local function startAntiAFK()
    task.spawn(function()
        while antiAfkEnabled do
            task.wait(300) -- 5 menit
            if antiAfkEnabled then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end
    end)
end

-- ===== UTILITY FUNCTIONS =====
local function getHumanFloat(min, max)
    return min + (math.random() * (max - min))
end

local function holdAndReleaseButton(guiButton, holdDuration)
    if not guiButton or type(getconnections) ~= "function" then return end
    local mockTouch = { UserInputType = Enum.UserInputType.Touch, UserInputState = Enum.UserInputState.Begin, Position = Vector3.new(guiButton.AbsolutePosition.X, guiButton.AbsolutePosition.Y, 0) }
    for _, conn in ipairs(getconnections(guiButton.InputBegan)) do pcall(function() conn.Function(mockTouch) end) end
    for _, conn in ipairs(getconnections(guiButton.MouseButton1Down)) do pcall(function() conn.Function() end) end
    task.wait(holdDuration)
    mockTouch.UserInputState = Enum.UserInputState.End
    for _, conn in ipairs(getconnections(guiButton.InputEnded)) do pcall(function() conn.Function(mockTouch) end) end
    for _, conn in ipairs(getconnections(guiButton.MouseButton1Up)) do pcall(function() conn.Function() end) end
    for _, conn in ipairs(getconnections(guiButton.Activated)) do pcall(function() conn.Function() end) end
    for _, conn in ipairs(getconnections(guiButton.MouseButton1Click)) do pcall(function() conn.Function() end) end
end

-- ===== METATABLE HOOKS =====
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local name = tostring(self.Name)
    
    if isKageFishing and method == "InvokeServer" and name == "GetEquippedBobber" then
        if not bobberDebounce then
            bobberDebounce = true
            task.spawn(function()
                task.wait(rDelays.BobberToStart + getHumanFloat(0.01, 0.15))
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                local toolId = tool and tool:GetAttribute("ToolUniqueId")
                if not toolId then bobberDebounce = false return end
                
                local toServerFolder = ReplicatedStorage:FindFirstChild("Fishing") and ReplicatedStorage.Fishing:FindFirstChild("ToServer")
                if toServerFolder and toServerFolder:FindFirstChild("MinigameStarted") then 
                    toServerFolder.MinigameStarted:FireServer(toolId) 
                end
                
                task.wait(rDelays.Reel + getHumanFloat(0.05, 0.15))
                if toServerFolder and toServerFolder:FindFirstChild("ReelFinished") then
                    toServerFolder.ReelFinished:FireServer({ duration = rDelays.Reel + getHumanFloat(1.5, 3.5), result = "SUCCESS", perfect = true, insideRatio = getHumanFloat(0.85, 0.98) }, toolId)
                    sessionStats.caught = sessionStats.caught + 1
                end
                
                task.wait(rDelays.Retract + getHumanFloat(0.02, 0.1))
                if ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract") then 
                    ReplicatedStorage.Fishing_RemoteRetract:FireServer(toolId) 
                end
                
                throwCooldown = tick() + rDelays.Throw + getHumanFloat(0.1, 0.4)
                bobberDebounce = false
            end)
        end
        return oldNamecall(self, unpack(args))
    end

    if (isAutoFishing or isKageFishing) and method == "FireServer" and name == "ReelFinished" then
        if args[1] and type(args[1]) == "table" then
            args[1].result = "SUCCESS"
            args[1].insideRatio = isKageFishing and getHumanFloat(0.85, 0.98) or (math.random(95, 100) / 100.0)
            if not isKageFishing and args[1].duration and args[1].duration < 2 then 
                args[1].duration = math.random(250, 450) / 100.0 
            end
        end
        return oldNamecall(self, unpack(args))
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- ===== AUTO FISHING THREADS =====
task.spawn(function()
    while true do
        task.wait(0.3)
        if not isAutoFishing or isKageFishing then continue end 
        if LocalPlayer.Character then
            if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then 
                for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do 
                    if item:IsA("Tool") and (item.Name:lower():find("rod") or item:GetAttribute("ToolUniqueId")) then 
                        LocalPlayer.Character.Humanoid:EquipTool(item) 
                        task.wait(1) 
                        break 
                    end 
                end 
            end
            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            if not pGui then continue end
            local minigameGui = pGui:FindFirstChild("FishingMinigameGUI")
            if minigameGui and minigameGui.Enabled then
                minigameGui.Enabled = false 
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                local toolId = tool and tool:GetAttribute("ToolUniqueId")
                if toolId then
                    task.wait(catchSpeedDelay)
                    local reelFinished = ReplicatedStorage:FindFirstChild("ReelFinished", true)
                    if reelFinished then 
                        reelFinished:FireServer({["duration"] = catchSpeedDelay + 1.2, ["result"] = "SUCCESS", ["insideRatio"] = math.random(90, 100) / 100.0 }, toolId) 
                        sessionStats.caught = sessionStats.caught + 1
                    end
                    task.wait(2.5) 
                end
                continue
            end
            local fishingGui = pGui:FindFirstChild("FishingMobileButton")
            if fishingGui and fishingGui.Enabled then
                local throwBtn = fishingGui:FindFirstChild("Container") and fishingGui.Container:FindFirstChild("ThrowButton")
                if throwBtn and throwBtn.Visible then
                    local cooldown = throwBtn:FindFirstChild("CooldownLabel")
                    if not (cooldown and cooldown.Visible) then
                        local bgColor = throwBtn.BackgroundColor3
                        local r, g, b = math.floor(bgColor.R * 255), math.floor(bgColor.G * 255), math.floor(bgColor.B * 255)
                        if (r < 50 and g > 100) or (r > 200 and g > 150) then 
                            holdAndReleaseButton(throwBtn, throwPowerDelay) 
                            task.wait(3) 
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2) 
        if not isKageFishing or isAutoFishing then continue end 
        if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") and (item.Name:lower():find("rod") or item:GetAttribute("ToolUniqueId")) then 
                    LocalPlayer.Character.Humanoid:EquipTool(item) 
                    task.wait(1) 
                    break 
                end
            end
        end
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not pGui then continue end
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local toolId = tool and tool:GetAttribute("ToolUniqueId")
        if toolId and not bobberDebounce then
            local fishingGui = pGui:FindFirstChild("FishingMobileButton")
            local throwBtnVisible = fishingGui and fishingGui:FindFirstChild("Container") and fishingGui.Container:FindFirstChild("ThrowButton") and fishingGui.Container.ThrowButton.Visible
            if throwBtnVisible and tick() > throwCooldown then
                local throwRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
                if throwRemote then 
                    throwRemote:FireServer(getHumanFloat(0.25, 0.85), toolId) 
                    throwCooldown = tick() + 6.0 
                end
            end
        end
    end
end)

-- ===== INFINITE JUMP =====
UIS.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ===== RAYFIELD UI =====
local Window = Rayfield:CreateWindow({
    Name = "AMBONHUB🚯 V16",
    Icon = 0,
    LoadingTitle = "AmbonHub🚯 Loading...",
    LoadingSubtitle = "by AmbonHub🚯",
    Theme = "DarkBlue",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonHub",
        FileName = "AmbonHubV16"
    },
})

-- HANYA 4 TAB: Dashboard, Character, Farming, Info
local Tabs = {
    Home = Window:CreateTab("Dashboard", "home"),
    Player = Window:CreateTab("Character", "user"),
    Farming = Window:CreateTab("Farming", "fish"),
    Info = Window:CreateTab("Info", "info"),
}

-- HOME TAB
Tabs.Home:CreateParagraph({
    Title = "AMBONHUB🚯 V16",
    Content = "Selamat datang, " .. LocalPlayer.Name .. "!\n\nStatistik Sesi Memancing:\n✅ Ikan Ditangkap: " .. sessionStats.caught
})

-- PLAYER TAB
Tabs.Player:CreateSection("PENGATURAN STATUS")

Tabs.Player:CreateInput({
    Name = "Set WalkSpeed",
    PlaceholderText = tostring(savedWalkSpeed),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local val = tonumber(Text)
        if val then savedWalkSpeed = val end
    end
})

Tabs.Player:CreateInput({
    Name = "Set JumpPower",
    PlaceholderText = tostring(savedJumpPower),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local val = tonumber(Text)
        if val then savedJumpPower = val end
    end
})

Tabs.Player:CreateButton({
    Name = "⚡ Inject Status",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = savedWalkSpeed
            LocalPlayer.Character.Humanoid.JumpPower = savedJumpPower
            Rayfield:Notify({ Title = "Sukses", Content = "Status Di-inject!", Duration = 2 })
        end
    end
})

Tabs.Player:CreateSection("KEMAMPUAN SUPER")

Tabs.Player:CreateToggle({
    Name = "🚀 Infinite Jump",
    CurrentValue = false,
    Flag = "ToggleInfJump",
    Callback = function(Value)
        infJump = Value
    end
})

Tabs.Player:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = false,
    Flag = "ToggleNoclip",
    Callback = function(Value)
        if Value then
            noclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
        end
    end
})

Tabs.Player:CreateSection("ANTI AFK")

Tabs.Player:CreateToggle({
    Name = "🛡️ Aktifkan Anti AFK",
    CurrentValue = false,
    Flag = "ToggleAntiAFK",
    Callback = function(Value)
        antiAfkEnabled = Value
        if antiAfkEnabled then
            startAntiAFK()
            Rayfield:Notify({ Title = "Anti AFK", Content = "Aktif! Kamu gak bakal di-kick.", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Anti AFK", Content = "Dimatikan.", Duration = 2 })
        end
    end
})

-- FARMING TAB
Tabs.Farming:CreateSection("MODE 1: SAFE FARMING")

Tabs.Farming:CreateToggle({
    Name = "🎣 Nyalakan Safe Farming",
    CurrentValue = false,
    Flag = "ToggleSafeFarming",
    Callback = function(Value)
        isAutoFishing = Value
    end
})

Tabs.Farming:CreateSlider({
    Name = "Catch Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "Detik",
    CurrentValue = 0.5,
    Flag = "SliderCatchDelay",
    Callback = function(Value)
        catchSpeedDelay = Value
    end
})

Tabs.Farming:CreateSlider({
    Name = "Throw Power",
    Range = {0.1, 3},
    Increment = 0.1,
    Suffix = "Detik",
    CurrentValue = 1.6,
    Flag = "SliderThrowPower",
    Callback = function(Value)
        throwPowerDelay = Value
    end
})

Tabs.Farming:CreateSection("MODE 2: FAST FARMING")

Tabs.Farming:CreateToggle({
    Name = "⚡ Nyalakan Fast Farming",
    CurrentValue = false,
    Flag = "ToggleFastFarming",
    Callback = function(Value)
        isKageFishing = Value
    end
})

Tabs.Farming:CreateSlider({
    Name = "Bobber ke Minigame",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "Detik",
    CurrentValue = 1.5,
    Flag = "SliderBobberToMinigame",
    Callback = function(Value)
        rDelays.BobberToStart = Value
    end
})

Tabs.Farming:CreateSlider({
    Name = "Minigame ke Reel",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "Detik",
    CurrentValue = 1.5,
    Flag = "SliderMinigameToReel",
    Callback = function(Value)
        rDelays.Reel = Value
    end
})

-- INFO TAB
Tabs.Info:CreateParagraph({
    Title = "🙏 TERIMA KASIH",
    Content = [[
Kepada **Mizukage Official**,
Terima kasih atas antisipasi dan kontribusinya terhadap perkembangan script ini.

Script original dibuat oleh Mizukage, dan kami dari **AmbonHub🚯** hanya melakukan rebrand serta penyesuaian agar lebih ringan dan sesuai kebutuhan.

Semoga komunitas tetap solid dan berkembang! 🌊

**- AmbonHub🚯 Team**]]
})

Rayfield:Notify({
    Title = "AmbonHub🚯 V16 Loaded",
    Content = "Welcome " .. LocalPlayer.Name .. "! By AmbonHub🚯",
    Duration = 5
})

-- Destroy Rayfield interface on game leave
LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        Rayfield:Destroy()
    end
end)