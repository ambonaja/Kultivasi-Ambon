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
local TeleportService = game:GetService("TeleportService")
local NetworkClient = game:GetService("NetworkClient")

-- ===== VARIABEL GLOBAL =====
local savedWalkSpeed = 16
local savedJumpPower = 50
local isAutoFishing = false
local isKageFishing = false
local sessionStats = { caught = 0, failed = 0, sold = 0, totalEarned = 0 }
local catchSpeedDelay = 0.5
local throwPowerDelay = 1.6
local bobberDebounce = false
local throwCooldown = 0
local rDelays = { BobberToStart = 1.5, Reel = 1.5, Retract = 0.3, Throw = 0.5 }
local infJump = false
local noclipConn = nil
local antiAfkEnabled = false
local heartbeatConn = nil
local lastPosition = nil
local lastActivityTime = tick()
local afkMoveActive = false
local antiAfkMethod = "SIMPLE"
local lockPositionConn = nil
local isPositionLocked = false
local lockedPosition = nil

-- ===== VARIABEL AUTO SELL =====
local isAutoSellEnabled = false
local autoSellInterval = 60 -- Default 60 detik
local minFishSize = 100 -- Default ukuran minimal 100
local autoSellConnection = nil
local sellRemote = nil

-- ===== DAFTAR LOKASI TELEPORT =====
local TeleportLocations = {
    ["🏝️ Raja Ampat"] = { 
        pos = Vector3.new(-1781, 1003, -1381),
        desc = "Surga di ujung timur Indonesia"
    },
    ["🌊 Samudra"] = { 
        pos = Vector3.new(-700, 1011, -1676),
        desc = "⚠️ LOKASI KHUSUS - Posisi akan dikunci!",
        special = "lock"
    },
    ["🌴 Kinyis"] = { 
        pos = Vector3.new(28, 1006, -894),
        desc = "Pantai eksotis dengan pasir putih"
    },
    ["⛰️ Natuna Cavern"] = { 
        pos = Vector3.new(2106, 1003, -97),
        desc = "Gua misterius di Kepulauan Natuna"
    },
    ["🏖️ Bali Island"] = { 
        pos = Vector3.new(1050, 1034, 1621),
        desc = "Pulau Dewata yang menawan"
    },
    ["🐠 Wakatobi"] = { 
        pos = Vector3.new(-1344, 1025, 1423),
        desc = "Surga bawah laut Sulawesi"
    }
}

-- ===== FUNGSI AUTO SELL =====
local function getSellRemote()
    -- Cari remote SellUnder dengan berbagai kemungkinan path
    local possiblePaths = {
        ReplicatedStorage:FindFirstChild("Economy") and ReplicatedStorage.Economy:FindFirstChild("ToServer") and ReplicatedStorage.Economy.ToServer:FindFirstChild("SellUnder"),
        ReplicatedStorage:FindFirstChild("ToServer") and ReplicatedStorage.ToServer:FindFirstChild("SellUnder"),
        ReplicatedStorage:FindFirstChild("SellUnder", true),
        ReplicatedStorage:FindFirstChild("Economy", true) and ReplicatedStorage:FindFirstChild("Economy", true):FindFirstChild("SellUnder", true)
    }
    
    for _, remote in ipairs(possiblePaths) do
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    return nil
end

local function sellFish()
    if not isAutoSellEnabled then return end
    
    -- Cari remote jika belum ada
    if not sellRemote then
        sellRemote = getSellRemote()
    end
    
    if sellRemote then
        -- Fire server dengan ukuran minimal
        local success, error = pcall(function()
            sellRemote:FireServer(minFishSize)
        end)
        
        if success then
            sessionStats.sold = sessionStats.sold + 1
            -- Estimasi pendapatan (asumsi rata-rata 100 per ikan)
            sessionStats.totalEarned = sessionStats.totalEarned + (minFishSize * 0.8)
            
            -- Notifikasi sesekali (setiap 5 kali jualan)
            if sessionStats.sold % 5 == 0 then
                Rayfield:Notify({
                    Title = "💰 Auto Sell",
                    Content = string.format("Menjual ikan ukuran >= %d\nTotal terjual: %d", minFishSize, sessionStats.sold),
                    Duration = 3
                })
            end
        else
            -- Coba cari remote lagi jika error
            sellRemote = getSellRemote()
        end
    else
        -- Coba cari remote lagi
        sellRemote = getSellRemote()
    end
end

local function startAutoSell()
    if autoSellConnection then
        autoSellConnection:Disconnect()
    end
    
    -- Cari remote
    sellRemote = getSellRemote()
    
    if not sellRemote then
        Rayfield:Notify({
            Title = "⚠️ Auto Sell Error",
            Content = "Remote SellUnder tidak ditemukan!",
            Duration = 4
        })
        return
    end
    
    isAutoSellEnabled = true
    
    -- Loop auto sell
    autoSellConnection = RunService.Heartbeat:Connect(function()
        -- Gunakan task.wait yang lebih efisien
        task.wait(autoSellInterval)
        if isAutoSellEnabled then
            sellFish()
        end
    end)
    
    -- Jual langsung saat pertama kali diaktifkan
    task.wait(1)
    sellFish()
    
    Rayfield:Notify({
        Title = "💰 Auto Sell Active",
        Content = string.format("Menjual ikan ukuran >= %d setiap %d detik", minFishSize, autoSellInterval),
        Duration = 4
    })
end

local function stopAutoSell()
    isAutoSellEnabled = false
    if autoSellConnection then
        autoSellConnection:Disconnect()
        autoSellConnection = nil
    end
    Rayfield:Notify({
        Title = "💰 Auto Sell",
        Content = "Auto Sell dimatikan",
        Duration = 2
    })
end

-- ===== FUNGSI TELEPORT =====
local function teleportTo(locationName, locationData)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Rayfield:Notify({
            Title = "Error",
            Content = "Karakter tidak ditemukan!",
            Duration = 3
        })
        return
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local rootPart = LocalPlayer.Character.HumanoidRootPart
    
    -- Matikan posisi lock sebelumnya jika ada
    if lockPositionConn then
        lockPositionConn:Disconnect()
        lockPositionConn = nil
        isPositionLocked = false
    end
    
    -- Animasi teleport (efek visual)
    local originalCFrame = rootPart.CFrame
    local originalTransparency = {}
    
    -- Simpan transparency asli
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalTransparency[part] = part.Transparency
        end
    end
    
    -- Efek fade out
    for i = 0, 1, 0.1 do
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = i
            end
        end
        task.wait(0.03)
    end
    
    -- Teleport
    rootPart.CFrame = CFrame.new(locationData.pos)
    
    -- Efek fade in
    for i = 1, 0, -0.1 do
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and originalTransparency[part] then
                part.Transparency = originalTransparency[part]
            end
        end
        task.wait(0.03)
    end
    
    -- Notifikasi sukses
    Rayfield:Notify({
        Title = "✅ Teleport Berhasil",
        Content = string.format("Ke %s\n%s", locationName, locationData.desc),
        Duration = 4
    })
    
    -- Fitur khusus untuk Samudra (lock position)
    if locationData.special == "lock" then
        task.wait(0.5) -- Tunggu sebentar
        
        -- Aktifkan position lock
        isPositionLocked = true
        lockedPosition = locationData.pos
        
        lockPositionConn = RunService.Heartbeat:Connect(function()
            if isPositionLocked and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                -- Kunci posisi di koordinat Samudra
                root.CFrame = CFrame.new(lockedPosition)
            end
        end)
        
        Rayfield:Notify({
            Title = "🔒 Position Lock Active",
            Content = "Posisi di Samudra telah dikunci!\nGunakan tombol Unlock untuk melepas.",
            Duration = 5
        })
    end
end

-- Fungsi untuk unlock position
local function unlockPosition()
    if lockPositionConn then
        lockPositionConn:Disconnect()
        lockPositionConn = nil
        isPositionLocked = false
        lockedPosition = nil
        
        Rayfield:Notify({
            Title = "🔓 Position Unlocked",
            Content = "Posisi tidak lagi dikunci.",
            Duration = 3
        })
    end
end

-- ===== ANTI AFK FUNCTIONS =====
-- Method 1: Basic Anti AFK (Virtual User)
local function simpleAntiAFK()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    lastActivityTime = tick()
end

-- Method 2: Advanced Anti AFK (Movement + Camera)
local function advancedAntiAFK()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            -- Gerakan kecil acak
            local randomDir = Vector3.new(
                math.random(-5, 5) / 10,
                0,
                math.random(-5, 5) / 10
            )
            humanoid:Move(randomDir, true)
            
            -- Putar kamera sedikit
            local camera = workspace.CurrentCamera
            if camera then
                camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(math.random(-5, 5)), 0)
            end
        end
    end
    
    -- Simulasi input
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    lastActivityTime = tick()
end

-- Method 3: Stealth Anti AFK (Network Manipulation)
local function stealthAntiAFK()
    -- Simulasi heartbeat ke server
    pcall(function()
        if LocalPlayer.PlayerScripts and LocalPlayer.PlayerScripts:FindFirstChild("Heartbeat") then
            LocalPlayer.PlayerScripts.Heartbeat:FireServer()
        end
    end)
    
    -- Bypass anti-cheat dengan mengirim packet palsu
    pcall(function()
        local heartbeatRemote = ReplicatedStorage:FindFirstChild("Heartbeat") 
            or ReplicatedStorage:FindFirstChild("AntiAfk") 
            or ReplicatedStorage:FindFirstChild("Ping")
        
        if heartbeatRemote and heartbeatRemote:IsA("RemoteEvent") then
            heartbeatRemote:FireServer(tick())
        elseif heartbeatRemote and heartbeatRemote:IsA("RemoteFunction") then
            heartbeatRemote:InvokeServer(tick())
        end
    end)
    
    -- Method dasar sebagai backup
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    lastActivityTime = tick()
end

-- Heartbeat detector untuk mendeteksi koneksi ke server
local function setupHeartbeatDetector()
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if antiAfkEnabled then
            local currentTime = tick()
            
            -- Deteksi jika game melakukan ping ke client
            pcall(function()
                local stats = Stats:FindFirstChild("PerformanceStats")
                if stats then
                    local ping = stats:FindFirstChild("DataPing")
                    if ping and ping:IsA("NumberValue") and ping.Value > 1000 then
                        -- Ping tinggi, kemungkinan akan disconnect
                        if antiAfkMethod == "STEALTH" then
                            stealthAntiAFK()
                        elseif antiAfkMethod == "ADVANCED" then
                            advancedAntiAFK()
                        else
                            simpleAntiAFK()
                        end
                    end
                end
            end)
            
            -- Anti AFK periodik (setiap 3-5 menit)
            if currentTime - lastActivityTime > 180 + math.random(0, 120) then
                if antiAfkMethod == "STEALTH" then
                    stealthAntiAFK()
                elseif antiAfkMethod == "ADVANCED" then
                    advancedAntiAFK()
                else
                    simpleAntiAFK()
                end
                lastActivityTime = currentTime
            end
        end
    end)
end

-- Activity detector untuk mendeteksi input pemain
local function setupActivityDetector()
    -- Deteksi gerakan mouse
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            lastActivityTime = tick()
        end
    end)
    
    -- Deteksi input keyboard
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            lastActivityTime = tick()
        end
    end)
    
    -- Deteksi input gamepad
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Gamepad1 then
            lastActivityTime = tick()
        end
    end)
    
    -- Deteksi karakter bergerak
    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
            if lastPosition and (currentPos - lastPosition).Magnitude > 0.1 then
                lastActivityTime = tick()
            end
            lastPosition = currentPos
        end
    end)
end

-- Start Anti AFK dengan method yang dipilih
local function startAntiAFK(method)
    antiAfkMethod = method or "SIMPLE"
    antiAfkEnabled = true
    lastActivityTime = tick()
    
    -- Setup semua komponen
    setupHeartbeatDetector()
    setupActivityDetector()
    
    -- Loop utama anti AFK
    task.spawn(function()
        while antiAfkEnabled do
            task.wait(240 + math.random(0, 60)) -- 4-5 menit
            
            if antiAfkEnabled then
                if antiAfkMethod == "STEALTH" then
                    stealthAntiAFK()
                elseif antiAfkMethod == "ADVANCED" then
                    advancedAntiAFK()
                else
                    simpleAntiAFK()
                end
                
                -- Notifikasi setiap 15 menit (opsional)
                if math.random(1, 4) == 1 then
                    Rayfield:Notify({
                        Title = "Anti AFK",
                        Content = "Menjaga koneksi tetap aktif...",
                        Duration = 1.5
                    })
                end
            end
        end
    end)
    
    -- Simulasi aktivitas acak
    task.spawn(function()
        while antiAfkEnabled do
            task.wait(math.random(45, 120))
            
            if antiAfkEnabled and LocalPlayer.Character then
                -- Gerakan acak kecil
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    if math.random(1, 3) == 1 then
                        humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)), true)
                    end
                end
                
                -- Update waktu aktivitas
                lastActivityTime = tick()
            end
        end
    end)
end

-- Stop Anti AFK
local function stopAntiAFK()
    antiAfkEnabled = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
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

-- 5 TAB: Dashboard, Character, Teleport, Farming, Info
local Tabs = {
    Home = Window:CreateTab("Dashboard", "home"),
    Player = Window:CreateTab("Character", "user"),
    Teleport = Window:CreateTab("Teleport", "map-pin"),
    Farming = Window:CreateTab("Farming", "fish"),
    Info = Window:CreateTab("Info", "info"),
}

-- HOME TAB
Tabs.Home:CreateParagraph({
    Title = "AMBONHUB🚯 V16",
    Content = "Selamat datang, " .. LocalPlayer.Name .. "!\n\nStatistik Sesi:\n✅ Ikan Ditangkap: " .. sessionStats.caught .. "\n💰 Terjual: " .. sessionStats.sold .. "\n💵 Estimasi Pendapatan: $" .. string.format("%.0f", sessionStats.totalEarned)
})

-- Update statistik setiap 5 detik
task.spawn(function()
    while true do
        task.wait(5)
        if Tabs and Tabs.Home then
            Tabs.Home:CreateParagraph({
                Title = "AMBONHUB🚯 V16",
                Content = "Selamat datang, " .. LocalPlayer.Name .. "!\n\nStatistik Sesi:\n✅ Ikan Ditangkap: " .. sessionStats.caught .. "\n💰 Terjual: " .. sessionStats.sold .. "\n💵 Estimasi Pendapatan: $" .. string.format("%.0f", sessionStats.totalEarned)
            })
        end
    end
end)

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

Tabs.Player:CreateSection("ANTI AFK - PREMIUM")

Tabs.Player:CreateDropdown({
    Name = "Metode Anti AFK",
    Options = {"SIMPLE (Basic)", "ADVANCED (Gerak)", "STEALTH (Tersembunyi)"},
    CurrentOption = "SIMPLE (Basic)",
    Flag = "DropdownAntiAFKMethod",
    Callback = function(option)
        if option == "SIMPLE (Basic)" then
            antiAfkMethod = "SIMPLE"
        elseif option == "ADVANCED (Gerak)" then
            antiAfkMethod = "ADVANCED"
        elseif option == "STEALTH (Tersembunyi)" then
            antiAfkMethod = "STEALTH"
        end
    end
})

Tabs.Player:CreateToggle({
    Name = "🛡️ Aktifkan Anti AFK Premium",
    CurrentValue = false,
    Flag = "ToggleAntiAFK",
    Callback = function(Value)
        if Value then
            startAntiAFK(antiAfkMethod)
            Rayfield:Notify({ 
                Title = "Anti AFK Premium", 
                Content = "✅ Aktif! Menggunakan metode: " .. antiAfkMethod, 
                Duration = 3 
            })
        else
            stopAntiAFK()
            Rayfield:Notify({ 
                Title = "Anti AFK", 
                Content = "❌ Dimatikan.", 
                Duration = 2 
            })
        end
    end
})

Tabs.Player:CreateParagraph({
    Title = "Info Anti AFK",
    Content = [[
Metode Anti AFK Premium:
• SIMPLE: Menggunakan VirtualUser (Basic)
• ADVANCED: Gerakan kecil + putar kamera
• STEALTH: Manipulasi network + heartbeat

Anti AFK akan aktif secara otomatis setiap 4-5 menit.
Detektor aktivitas akan mendeteksi input pemain.]]
})

-- ===== TELEPORT TAB =====
Tabs.Teleport:CreateSection("📍 DAFTAR LOKASI")

-- Buat button untuk setiap lokasi
for locationName, locationData in pairs(TeleportLocations) do
    local buttonName = locationName
    if locationData.special == "lock" then
        buttonName = buttonName .. " 🔒"
    end
    
    Tabs.Teleport:CreateButton({
        Name = buttonName,
        Callback = function()
            teleportTo(locationName, locationData)
        end
    })
    
    -- Tambahkan deskripsi sebagai label kecil
    Tabs.Teleport:CreateParagraph({
        Title = "",
        Content = "  " .. locationData.desc .. "\n  📍 " .. string.format("%.0f, %.0f, %.0f", locationData.pos.X, locationData.pos.Y, locationData.pos.Z)
    })
end

Tabs.Teleport:CreateSection("🔧 KONTROL POSISI LOCK")

Tabs.Teleport:CreateButton({
    Name = "🔓 Unlock Position (Lepas Kunci)",
    Callback = function()
        unlockPosition()
    end
})

Tabs.Teleport:CreateToggle({
    Name = "🔒 Status Position Lock",
    CurrentValue = false,
    Flag = "TogglePositionLock",
    Callback = function(Value)
        if Value then
            -- Jika ingin mengunci di posisi saat ini
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
                
                if lockPositionConn then
                    lockPositionConn:Disconnect()
                end
                
                isPositionLocked = true
                lockedPosition = currentPos
                
                lockPositionConn = RunService.Heartbeat:Connect(function()
                    if isPositionLocked and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lockedPosition)
                    end
                end)
                
                Rayfield:Notify({
                    Title = "🔒 Position Locked",
                    Content = string.format("Posisi dikunci di:\n%.0f, %.0f, %.0f", currentPos.X, currentPos.Y, currentPos.Z),
                    Duration = 4
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Karakter tidak ditemukan!",
                    Duration = 3
                })
            end
        else
            unlockPosition()
        end
    end
})

Tabs.Teleport:CreateParagraph({
    Title = "ℹ️ Info Teleport",
    Content = [[
• Klik lokasi untuk teleport
• Samudra akan otomatis mengunci posisi
• Gunakan Unlock untuk melepas kunci
• Status lock bisa dicek di toggle di atas
• Efek fade in/out saat teleport]]
})

-- ===== FARMING TAB =====
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

-- ===== AUTO SELL SECTION =====
Tabs.Farming:CreateSection("💰 AUTO SELL IKAN")

Tabs.Farming:CreateToggle({
    Name = "💵 Nyalakan Auto Sell",
    CurrentValue = false,
    Flag = "ToggleAutoSell",
    Callback = function(Value)
        if Value then
            startAutoSell()
        else
            stopAutoSell()
        end
    end
})

Tabs.Farming:CreateSlider({
    Name = "Ukuran Minimal Ikan",
    Range = {1, 500},
    Increment = 1,
    Suffix = "cm",
    CurrentValue = 100,
    Flag = "SliderMinFishSize",
    Callback = function(Value)
        minFishSize = Value
        -- Update notifikasi jika auto sell sedang aktif
        if isAutoSellEnabled then
            Rayfield:Notify({
                Title = "📏 Ukuran Diubah",
                Content = string.format("Sekarang menjual ikan ukuran >= %d cm", minFishSize),
                Duration = 2
            })
        end
    end
})

Tabs.Farming:CreateSlider({
    Name = "Interval Auto Sell",
    Range = {10, 300},
    Increment = 5,
    Suffix = "Detik",
    CurrentValue = 60,
    Flag = "SliderSellInterval",
    Callback = function(Value)
        autoSellInterval = Value
        -- Restart auto sell jika sedang aktif
        if isAutoSellEnabled then
            stopAutoSell()
            task.wait(0.5)
            startAutoSell()
        end
    end
})

Tabs.Farming:CreateButton({
    Name = "💰 Jual Sekarang (Manual)",
    Callback = function()
        sellFish()
    end
})

Tabs.Farming:CreateParagraph({
    Title = "📊 Statistik Penjualan",
    Content = string.format("Ikan Terjual: %d\nEstimasi Pendapatan: $%.0f\nUkuran Minimal: %d cm", 
        sessionStats.sold, sessionStats.totalEarned, minFishSize)
})

-- Update statistik penjualan
task.spawn(function()
    while true do
        task.wait(3)
        if Tabs and Tabs.Farming then
            Tabs.Farming:CreateParagraph({
                Title = "📊 Statistik Penjualan",
                Content = string.format("Ikan Terjual: %d\nEstimasi Pendapatan: $%.0f\nUkuran Minimal: %d cm", 
                    sessionStats.sold, sessionStats.totalEarned, minFishSize)
            })
        end
    end
end)

-- INFO TAB
Tabs.Info:CreateParagraph({
    Title = "🙏 TERIMA KASIH",
    Content = [[
Kepada **Mizukage Official**,
Terima kasih atas antisipasi dan kontribusinya terhadap perkembangan script ini.

Script original dibuat oleh Mizukage, dan kami dari **AmbonHub🚯** hanya melakukan rebrand serta penyesuaian agar lebih ringan dan sesuai kebutuhan.

**FITUR LENGKAP:**
✅ Anti AFK Premium V2.0 - 3 metode berbeda
✅ Teleport System - 6 Lokasi eksotis
✅ Position Lock - Kunci posisi di Samudra
✅ Auto Fishing - Safe & Fast mode
✅ AUTO SELL - Jual otomatis ukuran minimal 100cm
✅ Real-time Statistics

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
        stopAntiAFK()
        stopAutoSell()
        if lockPositionConn then
            lockPositionConn:Disconnect()
        end
        Rayfield:Destroy()
    end
end)

-- Auto-save settings
game:BindToClose(function()
    stopAntiAFK()
    stopAutoSell()
    if lockPositionConn then
        lockPositionConn:Disconnect()
    end
end)
