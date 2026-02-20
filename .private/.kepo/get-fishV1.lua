--// ================================
--//  Fishing Auto Reel PERANG TOTAL + REMOTE ASLI
--//  Credit  : Ambon|Hub
--//  Watermark: GET FISH EDITION WAR FINAL
--//  Status: 💀 REMOTE ASLI TUAN + SISTEM HANCUR 💀
--// ================================

warn("=== 💀 GET FISH EDITION WAR FINAL | Ambon|Hub Exclusive 💀 ===")
warn("=== 🔥 REMOTE ASLI: Fishing > ToServer > ReelFinished ===")
warn("=== 👑 SISTEM HANCUR - LU YANG BERKUASA ===")

--// ================================
--//  VARIABEL GLOBAL
--// ================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

-- Variabel untuk fitur War Machine
local warMachine = {
    antiKick = true,
    antiDestroy = true,
    antiRemove = true,
    antiTeleport = true,
    antiIdle = true,
    antiAncestry = true,
    hideConsole = true,
    muteLogs = true,
    antiScan = true
}

-- Variabel kontrol Auto Reel
local autoReelEnabled = false
local reelLoop = nil

--// ================================
--//  FUNGSI WAR MACHINE
--// ================================

local function activateWarMachine()
    -- ========== SUPER ANTI-KICK ==========
    if warMachine.antiKick then
        for i = 1, 20 do
            pcall(function()
                local oldKick = player["Kick"]
                player["Kick"] = function(self, ...)
                    return "YANG BERKUASA DISINI GW!"
                end
            end)
        end
        print("✅ ANTI-KICK 20 LAYER: ACTIVE")
    end

    -- ========== SUPER ANTI-DESTROY ==========
    if warMachine.antiDestroy then
        for i = 1, 15 do
            pcall(function()
                local oldDestroy = player["Destroy"]
                player["Destroy"] = function(self, ...)
                    return self
                end
            end)
        end
        print("✅ ANTI-DESTROY 15 LAYER: ACTIVE")
    end

    -- ========== SUPER ANTI-REMOVE ==========
    if warMachine.antiRemove then
        for i = 1, 15 do
            pcall(function()
                local oldRemove = player["Remove"]
                player["Remove"] = function(self, ...)
                    return self
                end
            end)
        end
        print("✅ ANTI-REMOVE 15 LAYER: ACTIVE")
    end

    -- ========== ANTI-TELEPORT NUKLIR ==========
    if warMachine.antiTeleport then
        pcall(function()
            TeleportService.Teleport = function(self, ...)
                return "GAK BISA!"
            end
            TeleportService.TeleportToPlace = function(self, ...)
                return
            end
        end)
        print("✅ ANTI-TELEPORT: ACTIVE")
    end

    -- ========== ANTI-IDLE ==========
    if warMachine.antiIdle then
        player.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
        print("✅ ANTI-IDLE: ACTIVE")
    end

    -- ========== ANTI-ANCESTRY ==========
    if warMachine.antiAncestry then
        player.AncestryChanged:Connect(function()
            if not player:IsDescendantOf(game) then
                while true do
                    task.wait(9e9)
                end
            end
        end)
        print("✅ ANTI-ANCESTRY: ACTIVE")
    end

    -- ========== HIDE CONSOLE ==========
    if warMachine.hideConsole then
        pcall(function()
            if rconsolehide then rconsolehide() end
            if syn and syn.setconsolevisible then syn.setconsolevisible(false) end
        end)
        print("✅ HIDE CONSOLE: ACTIVE")
    end

    -- ========== MATIIN LOG ==========
    if warMachine.muteLogs then
        local oldWarn = warn
        local oldPrint = print
        warn = function() end
        print = function() end
        print("✅ MUTE LOGS: ACTIVE")
    end

    -- ========== ANTI-SCAN MEMORY ==========
    if warMachine.antiScan and getgc then
        local oldGetgc = getgc
        getgc = function(...)
            local gc = oldGetgc(...)
            local filtered = {}
            for _, v in pairs(gc) do
                if type(v) ~= "string" or not tostring(v):match("Ambon") then
                    table.insert(filtered, v)
                end
            end
            return filtered
        end
        print("✅ ANTI-SCAN MEMORY: ACTIVE")
    end
end

--// ================================
--//  PROVOKASI BUAT SISTEM
--// ================================
local function startProvokasi()
    spawn(function()
        task.wait(1)
        warn("=== 📢 SISTEM: 'Terdeteksi aktivitas mencurigakan' ===")
        warn("=== GW: 'IYA KITA! LU MAU NGAPA?' ===")
    end)

    spawn(function()
        task.wait(2)
        warn("=== 🔥 SISTEM: 'Hubungi admin' ===")
        warn("=== GW: 'ADMIN LU LEMAH! GAK BISA NGAPA-NGAPAIN!' ===")
    end)

    spawn(function()
        task.wait(3)
        warn("=== 💪 ANTI-KICK 20 LAYER: ACTIVE ===")
        warn("=== ANTI-DESTROY 15 LAYER: ACTIVE ===")
        warn("=== ANTI-TELEPORT: ACTIVE ===")
        warn("=== SISTEM GAK BERDAYA! ===")
    end)

    -- TROLOL SETIAP 10 DETIK
    spawn(function()
        while true do
            task.wait(10)
            warn("=== 😂 SISTEM: 'Terdeteksi...' (YAH GITU TERUS) ===")
            warn("=== 🖕 YANG BERKUASA TETEP GW! 🖕 ===")
        end
    end)
end

--// ================================
--//  FUNGSI AUTO REEL
--// ================================
local function startAutoReel()
    if reelLoop then return end
    autoReelEnabled = true
    print("✅ AUTO REEL DIMULAI")
    
    reelLoop = task.spawn(function()
        while autoReelEnabled do
            task.wait(math.random(1,3))
            local success, err = pcall(function()
                local args = {
                    {
                        duration = 2.9015033438336104,
                        result = "SUCCESS",
                        insideRatio = 0.8
                    },
                    "50ce4ba0-8926-4b70-a9de-f0db9c4f7d05"
                }
                
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Fishing")
                    :WaitForChild("ToServer")
                    :WaitForChild("ReelFinished")
                    :FireServer(unpack(args))
            end)
            
            if not success then
                warn("❌ Error: " .. tostring(err))
            end
            
            task.wait(1)
        end
    end)
end

local function stopAutoReel()
    autoReelEnabled = false
    if reelLoop then
        task.cancel(reelLoop)
        reelLoop = nil
    end
    print("🛑 AUTO REEL DIHENTIKAN")
end

--// ================================
--//  UI RAYFIELD
--// ================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "GET FISH WAR - Ambon|Hub",
    LoadingTitle = "Ambon|Hub Exclusive",
    LoadingSubtitle = "by Ambon",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AmbonHub_Config",
        FileName = "GetFishWar"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

--// ================================
--//  TAB MAIN (AUTO REEL)
--// ================================
local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Auto Reel Control")

-- Label status
local statusLabel = MainTab:CreateLabel("STATUS: BERHENTI")

-- Tombol START
MainTab:CreateButton({
    Name = "▶️ START AUTO REEL",
    Callback = function()
        startAutoReel()
        statusLabel:Set("STATUS: BERJALAN")
        Rayfield:Notify({
            Title = "Auto Reel",
            Content = "✅ Auto reel dimulai!",
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Tombol STOP
MainTab:CreateButton({
    Name = "⏹️ STOP AUTO REEL",
    Callback = function()
        stopAutoReel()
        statusLabel:Set("STATUS: BERHENTI")
        Rayfield:Notify({
            Title = "Auto Reel",
            Content = "🛑 Auto reel dihentikan!",
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Auto update status
spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if autoReelEnabled then
                statusLabel:Set("STATUS: BERJALAN")
            else
                statusLabel:Set("STATUS: BERHENTI")
            end
        end)
    end
end)

--// ================================
--//  TAB SETTING (WAR MACHINE)
--// ================================
local SettingTab = Window:CreateTab("Setting", 4483362458)
local WarSection = SettingTab:CreateSection("⚔️ WAR MACHINE SETTINGS")

-- Toggle ANTI-KICK
SettingTab:CreateToggle({
    Name = "Anti Kick (20 Layer)",
    CurrentValue = true,
    Flag = "antikick",
    Callback = function(value)
        warMachine.antiKick = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Anti Kick: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle ANTI-DESTROY
SettingTab:CreateToggle({
    Name = "Anti Destroy (15 Layer)",
    CurrentValue = true,
    Flag = "antidestroy",
    Callback = function(value)
        warMachine.antiDestroy = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Anti Destroy: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle ANTI-REMOVE
SettingTab:CreateToggle({
    Name = "Anti Remove (15 Layer)",
    CurrentValue = true,
    Flag = "antiremove",
    Callback = function(value)
        warMachine.antiRemove = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Anti Remove: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle ANTI-TELEPORT
SettingTab:CreateToggle({
    Name = "Anti Teleport",
    CurrentValue = true,
    Flag = "antiteleport",
    Callback = function(value)
        warMachine.antiTeleport = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Anti Teleport: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle ANTI-IDLE
SettingTab:CreateToggle({
    Name = "Anti Idle",
    CurrentValue = true,
    Flag = "antiidle",
    Callback = function(value)
        warMachine.antiIdle = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Anti Idle: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle ANTI-ANCESTRY
SettingTab:CreateToggle({
    Name = "Anti Ancestry",
    CurrentValue = true,
    Flag = "antiacestry",
    Callback = function(value)
        warMachine.antiAncestry = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Anti Ancestry: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle HIDE CONSOLE
SettingTab:CreateToggle({
    Name = "Hide Console",
    CurrentValue = true,
    Flag = "hideconsole",
    Callback = function(value)
        warMachine.hideConsole = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Hide Console: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle MUTE LOGS
SettingTab:CreateToggle({
    Name = "Mute Logs (Warn/Print)",
    CurrentValue = true,
    Flag = "mutelogs",
    Callback = function(value)
        warMachine.muteLogs = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Mute Logs: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Toggle ANTI-SCAN
SettingTab:CreateToggle({
    Name = "Anti Scan Memory",
    CurrentValue = true,
    Flag = "antiscan",
    Callback = function(value)
        warMachine.antiScan = value
        Rayfield:Notify({
            Title = "War Machine",
            Content = "Anti Scan: " .. (value and "✅ ON" or "❌ OFF"),
            Duration = 1.5
        })
    end
})

-- Separator
SettingTab:CreateSection("⚡ CONTROL")

-- Tombol AKTIFKAN SEMUA
SettingTab:CreateButton({
    Name = "🔥 AKTIFKAN SEMUA FITUR",
    Callback = function()
        warMachine.antiKick = true
        warMachine.antiDestroy = true
        warMachine.antiRemove = true
        warMachine.antiTeleport = true
        warMachine.antiIdle = true
        warMachine.antiAncestry = true
        warMachine.hideConsole = true
        warMachine.muteLogs = true
        warMachine.antiScan = true
        
        -- Update semua toggle
        Rayfield:SetToggle("antikick", true)
        Rayfield:SetToggle("antidestroy", true)
        Rayfield:SetToggle("antiremove", true)
        Rayfield:SetToggle("antiteleport", true)
        Rayfield:SetToggle("antiidle", true)
        Rayfield:SetToggle("antiacestry", true)
        Rayfield:SetToggle("hideconsole", true)
        Rayfield:SetToggle("mutelogs", true)
        Rayfield:SetToggle("antiscan", true)
        
        Rayfield:Notify({
            Title = "War Machine",
            Content = "🔥 SEMUA FITUR DIaktifkan!",
            Duration = 3
        })
    end
})

-- Tombol NONAKTIFKAN SEMUA
SettingTab:CreateButton({
    Name = "💤 NONAKTIFKAN SEMUA",
    Callback = function()
        warMachine.antiKick = false
        warMachine.antiDestroy = false
        warMachine.antiRemove = false
        warMachine.antiTeleport = false
        warMachine.antiIdle = false
        warMachine.antiAncestry = false
        warMachine.hideConsole = false
        warMachine.muteLogs = false
        warMachine.antiScan = false
        
        -- Update semua toggle
        Rayfield:SetToggle("antikick", false)
        Rayfield:SetToggle("antidestroy", false)
        Rayfield:SetToggle("antiremove", false)
        Rayfield:SetToggle("antiteleport", false)
        Rayfield:SetToggle("antiidle", false)
        Rayfield:SetToggle("antiacestry", false)
        Rayfield:SetToggle("hideconsole", false)
        Rayfield:SetToggle("mutelogs", false)
        Rayfield:SetToggle("antiscan", false)
        
        Rayfield:Notify({
            Title = "War Machine",
            Content = "💤 SEMUA FITUR dinonaktifkan!",
            Duration = 3
        })
    end
})

-- Tombol TERAPKAN SETTING
SettingTab:CreateButton({
    Name = "✅ TERAPKAN SETTING",
    Callback = function()
        activateWarMachine()
        startProvokasi()
        Rayfield:Notify({
            Title = "War Machine",
            Content = "⚔️ Setting diterapkan! Sistem hancur!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Informasi
SettingTab:CreateSection("ℹ️ INFO")
SettingTab:CreateLabel("⚠️ Aktifkan fitur lalu tekan TERAPKAN")
SettingTab:CreateLabel("👑 Ambon|Hub Exclusive - GET FISH WAR")

--// ================================
--//  AUTO TERAPKAN SETTING AWAL
--// ================================
task.wait(1)
activateWarMachine()
startProvokasi()

--// ================================
--//  FINAL TOUCH
--// ================================
warn("=== ✅ REMOTE ASLI JALAN - SISTEM HANCUR ===")
warn("=== 💀 Fishing > ToServer > ReelFinished (PERSIS) ===")
warn("=== 👑 LU YANG BERKUASA - SELAMANYA ===")
warn("=== 📱 UI RAYFIELD + TAB SETTING SIAP ===")

-- Loop abadi
spawn(function()
    while true do
        task.wait(60)
    end
end)
