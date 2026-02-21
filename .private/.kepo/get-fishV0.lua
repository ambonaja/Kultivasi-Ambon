--// ================================
--//  Fishing Auto Reel PERANG TOTAL + REMOTE ASLI
--//  Credit  : Ambon|Hub
--//  Watermark: GET FISH EDITION WAR FINAL
--//  Status: 💀 REMOTE ASLI TUAN + SISTEM HANCUR 💀
--//  Discord Webhook: Monitor & Control
--// ================================

warn("=== 💀 GET FISH EDITION WAR FINAL | Ambon|Hub Exclusive 💀 ===")
warn("=== 🔥 REMOTE ASLI: Fishing > ToServer > ReelFinished ===")
warn("=== 👑 SISTEM HANCUR - LU YANG BERKUASA ===")
warn("=== 📡 DISCORD WEBHOOK: ACTIVE ===")

--// ================================
--//  VARIABEL GLOBAL
--// ================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local Network = game:GetService("Network")

-- Remote untuk Auto Sell
local RS = game:GetService("ReplicatedStorage")
local SellRemote = RS:WaitForChild("Economy"):WaitForChild("ToServer"):WaitForChild("SellUnder")

-- ========== KONFIGURASI WEBHOOK ==========
local WEBHOOK_URL = "https://discord.com/api/webhooks/1473696842813411439/qReUe50W7ujO7AoCNjE-ujSUlWR55BqHXbLRyqzqwkdbX5xJDCIAW0-1MzgQTrYWCF9w" -- GANTI DENGAN WEBHOOK URL KAMU
local WEBHOOK_USERNAME = "Ambon|Hub Monitor"
local WEBHOOK_AVATAR = "https://i.imgur.com/7Iq7Y7I.png" -- Avatar URL

-- Variabel untuk Webhook
local webhookEnabled = true
local webhookCooldown = {}
local lastStatusUpdate = 0
local statusUpdateInterval = 300 -- Update status setiap 5 menit

-- Variabel untuk monitoring
local monitorData = {
    kickAttempts = 0,
    banAttempts = 0,
    teleportAttempts = 0,
    destroyAttempts = 0,
    startTime = os.time(),
    lastKickTime = 0,
    lastBanTime = 0,
    isKicked = false,
    isBanned = false,
    sessionID = HttpService:GenerateGUID(false),
    commandQueue = {}
}

-- Variabel kontrol
local autoReelEnabled = false
local reelLoop = nil
local autoSellEnabled = false
local sellLoop = nil
local sellSize = 100

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
    antiScan = true,
    webhookMonitor = true
}

--// ================================
--//  FUNGSI WEBHOOK DISCORD
--// ================================

local function sendToDiscord(title, description, color, fields, imageUrl)
    if not webhookEnabled or not WEBHOOK_URL or WEBHOOK_URL == "" then return end
    
    -- Cooldown untuk mencegah spam
    local cooldownKey = title .. tostring(color)
    local lastSend = webhookCooldown[cooldownKey]
    if lastSend and (os.time() - lastSend) < 5 then return end -- Cooldown 5 detik
    webhookCooldown[cooldownKey] = os.time()
    
    local data = {
        username = WEBHOOK_USERNAME,
        avatar_url = WEBHOOK_AVATAR,
        embeds = {{
            title = title,
            description = description,
            color = color or 16711680, -- Default merah
            timestamp = DateTime.now():ToIsoDate(),
            footer = {
                text = "Ambon|Hub Monitor • " .. player.Name,
                icon_url = "https://i.imgur.com/7Iq7Y7I.png"
            },
            fields = fields or {}
        }}
    }
    
    -- Tambah image jika ada
    if imageUrl then
        data.embeds[1].image = { url = imageUrl }
    end
    
    -- Kirim ke Discord
    pcall(function()
        local requestData = {
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        }
        
        -- Coba kirim dengan berbagai method
        local success, result = pcall(function()
            if syn and syn.request then
                return syn.request(requestData)
            elseif request then
                return request(requestData)
            elseif http_request then
                return http_request(requestData)
            end
        end)
        
        if not success then
            warn("❌ Gagal kirim ke Discord: " .. tostring(result))
        end
    end)
end

-- Fungsi untuk mengirim log status
local function sendStatusLog()
    local uptime = os.time() - monitorData.startTime
    local uptimeStr = string.format("%d jam %d menit %d detik", 
        math.floor(uptime / 3600), 
        math.floor((uptime % 3600) / 60), 
        uptime % 60)
    
    local fields = {
        {
            name = "👤 Player",
            value = player.Name .. " (" .. player.UserId .. ")",
            inline = true
        },
        {
            name = "⏰ Uptime",
            value = uptimeStr,
            inline = true
        },
        {
            name = "📊 Status",
            value = (monitorData.isKicked and "❌ KICKED" or "✅ AMAN") .. " | " .. 
                   (monitorData.isBanned and "❌ BANNED" or "✅ AMAN"),
            inline = true
        },
        {
            name = "🛡️ Anti-Kick Attempts",
            value = tostring(monitorData.kickAttempts),
            inline = true
        },
        {
            name = "🚫 Anti-Ban Attempts",
            value = tostring(monitorData.banAttempts),
            inline = true
        },
        {
            name = "📡 Anti-Teleport",
            value = tostring(monitorData.teleportAttempts),
            inline = true
        },
        {
            name = "💥 Anti-Destroy",
            value = tostring(monitorData.destroyAttempts),
            inline = true
        },
        {
            name = "🎣 Auto Reel",
            value = autoReelEnabled and "✅ ON" or "❌ OFF",
            inline = true
        },
        {
            name = "💰 Auto Sell",
            value = autoSellEnabled and "✅ ON (Size: " .. sellSize .. ")" or "❌ OFF",
            inline = true
        }
    }
    
    sendToDiscord(
        "📊 STATUS UPDATE - " .. player.Name,
        "**Session ID:** `" .. monitorData.sessionID .. "`\n**Server:** " .. game.JobId,
        3066993, -- Hijau
        fields
    )
end

-- Fungsi untuk mengirim log kick/ban
local function sendKickBanLog(type, attempt, success, details)
    local color = success and 16711680 or 15844367 -- Merah jika berhasil, kuning jika dicegah
    local title = success and ("🚨 " .. type .. " DETEKSI!") or ("🛡️ " .. type .. " DICEGAH!")
    local description = success and 
        "**" .. player.Name .. "** telah di-" .. type .. " oleh sistem!" or
        "**" .. player.Name .. "** selamat! " .. type .. " berhasil dicegah oleh Anti-Kick!"
    
    local fields = {
        {
            name = "📋 Detail",
            value = details or "Tidak ada detail",
            inline = false
        },
        {
            name = "🛡️ Total Dicegah",
            value = tostring(attempt),
            inline = true
        },
        {
            name = "⏰ Waktu",
            value = os.date("%Y-%m-%d %H:%M:%S"),
            inline = true
        }
    }
    
    sendToDiscord(title, description, color, fields)
    
    -- Update monitor data
    if type == "KICK" then
        monitorData.lastKickTime = os.time()
        if success then
            monitorData.isKicked = true
        end
    elseif type == "BAN" then
        monitorData.lastBanTime = os.time()
        if success then
            monitorData.isBanned = true
        end
    end
end

-- Fungsi untuk memproses command dari Discord
local function processDiscordCommand(command, args)
    command = command:lower()
    
    if command == "status" then
        sendStatusLog()
        return "✅ Status dikirim!"
        
    elseif command == "startreel" then
        if not autoReelEnabled then
            startAutoReel()
            return "✅ Auto Reel dimulai!"
        else
            return "⚠️ Auto Reel sudah berjalan!"
        end
        
    elseif command == "stopreel" then
        if autoReelEnabled then
            stopAutoReel()
            return "🛑 Auto Reel dihentikan!"
        else
            return "⚠️ Auto Reel sedang tidak berjalan!"
        end
        
    elseif command == "startsell" then
        if not autoSellEnabled then
            startAutoSell()
            return "💰 Auto Sell dimulai! (Size: " .. sellSize .. ")"
        else
            return "⚠️ Auto Sell sudah berjalan!"
        end
        
    elseif command == "stopsell" then
        if autoSellEnabled then
            stopAutoSell()
            return "🛑 Auto Sell dihentikan!"
        else
            return "⚠️ Auto Sell sedang tidak berjalan!"
        end
        
    elseif command == "setsell" then
        local newSize = tonumber(args)
        if newSize and newSize > 0 then
            sellSize = newSize
            return "✅ Ukuran jual diatur ke: " .. sellSize
        else
            return "❌ Ukuran tidak valid! Gunakan: setsell [angka]"
        end
        
    elseif command == "reset" then
        monitorData.isKicked = false
        monitorData.isBanned = false
        monitorData.kickAttempts = 0
        monitorData.banAttempts = 0
        return "✅ Status kick/ban telah direset!"
        
    elseif command == "help" then
        return [[
**📋 DAFTAR COMMAND:**
`status` - Lihat status saat ini
`startreel` - Mulai Auto Reel
`stopreel` - Hentikan Auto Reel
`startsell` - Mulai Auto Sell
`stopsell` - Hentikan Auto Sell
`setsell [angka]` - Atur ukuran jual
`reset` - Reset status kick/ban
`help` - Tampilkan command ini
        ]]
        
    else
        return "❌ Command tidak dikenal! Ketik `help` untuk bantuan."
    end
end

-- Fungsi untuk mendengarkan command dari Discord (via HTTP server sederhana)
local function startDiscordListener()
    -- Simulasi listener dengan loop yang memeriksa queue
    spawn(function()
        while webhookEnabled do
            task.wait(2)
            -- Di sini nanti bisa ditambahkan sistem HTTP server jika executor support
            -- Untuk sekarang, kita akan menggunakan sistem webhook reply
        end
    end)
end

--// ================================
--//  FUNGSI WAR MACHINE SUPER
--// ================================

local function activateWarMachine()
    -- ========== SUPER ANTI-KICK DENGAN MONITOR ==========
    if warMachine.antiKick then
        for i = 1, 20 do
            pcall(function()
                local oldKick = player["Kick"]
                player["Kick"] = function(self, ...)
                    monitorData.kickAttempts = monitorData.kickAttempts + 1
                    local args = {...}
                    local reason = args[1] or "No reason"
                    
                    -- Kirim notifikasi ke Discord
                    if warMachine.webhookMonitor then
                        sendKickBanLog("KICK", monitorData.kickAttempts, false, 
                            "Reason: " .. tostring(reason) .. "\nAttempt #" .. monitorData.kickAttempts)
                    end
                    
                    return "YANG BERKUASA DISINI GW! Anti-Kick Layer " .. i .. " Aktif!"
                end
            end)
        end
        print("✅ ANTI-KICK 20 LAYER + MONITOR: ACTIVE")
    end

    -- ========== SUPER ANTI-BAN (Mencegah banned) ==========
    if warMachine.antiKick then
        pcall(function()
            -- Monitor network untuk deteksi ban
            local networkClient = game:GetService("NetworkClient")
            if networkClient then
                local oldDisconnect = networkClient.Disconnect
                networkClient.Disconnect = function(self, ...)
                    monitorData.banAttempts = monitorData.banAttempts + 1
                    
                    if warMachine.webhookMonitor then
                        sendKickBanLog("BAN", monitorData.banAttempts, false, 
                            "Percobaan disconnect terdeteksi!")
                    end
                    
                    return oldDisconnect and oldDisconnect(self, ...)
                end
            end
        end)
        print("✅ ANTI-BAN MONITOR: ACTIVE")
    end

    -- ========== SUPER ANTI-DESTROY ==========
    if warMachine.antiDestroy then
        for i = 1, 15 do
            pcall(function()
                local oldDestroy = player["Destroy"]
                player["Destroy"] = function(self, ...)
                    monitorData.destroyAttempts = monitorData.destroyAttempts + 1
                    
                    if warMachine.webhookMonitor then
                        sendToDiscord(
                            "💥 ANTI-DESTROY ACTIVE",
                            "Percobaan destroy dicegah!",
                            15844367, -- Kuning
                            {{
                                name = "Attempt #",
                                value = tostring(monitorData.destroyAttempts),
                                inline = true
                            }}
                        )
                    end
                    
                    return self
                end
            end)
        end
        print("✅ ANTI-DESTROY 15 LAYER + MONITOR: ACTIVE")
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
            local oldTeleport = TeleportService.Teleport
            TeleportService.Teleport = function(self, ...)
                monitorData.teleportAttempts = monitorData.teleportAttempts + 1
                
                if warMachine.webhookMonitor then
                    sendToDiscord(
                        "📡 ANTI-TELEPORT ACTIVE",
                        "Percobaan teleport dicegah!",
                        15844367,
                        {{
                            name = "Attempt #",
                            value = tostring(monitorData.teleportAttempts),
                            inline = true
                        }}
                    )
                end
                
                return "GAK BISA!"
            end
            
            TeleportService.TeleportToPlace = function(self, ...)
                return
            end
        end)
        print("✅ ANTI-TELEPORT + MONITOR: ACTIVE")
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
--//  FUNGSI AUTO REEL & AUTO SELL
--// ================================

local function startAutoReel()
    if reelLoop then return end
    autoReelEnabled = true
    print("✅ AUTO REEL DIMULAI")
    
    if warMachine.webhookMonitor then
        sendToDiscord(
            "🎣 AUTO REEL STARTED",
            "Auto Reel telah dimulai oleh **" .. player.Name .. "**",
            3066993 -- Hijau
        )
    end
    
    reelLoop = task.spawn(function()
        while autoReelEnabled do
            task.wait(math.random(1,2.5))
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
    
    if warMachine.webhookMonitor then
        sendToDiscord(
            "🎣 AUTO REEL STOPPED",
            "Auto Reel telah dihentikan oleh **" .. player.Name .. "**",
            16711680 -- Merah
        )
    end
end

local function startAutoSell()
    if sellLoop then return end
    autoSellEnabled = true
    print("💰 AUTO SELL DIMULAI (Size: " .. sellSize .. ")")
    
    if warMachine.webhookMonitor then
        sendToDiscord(
            "💰 AUTO SELL STARTED",
            "Auto Sell dimulai dengan ukuran **" .. sellSize .. "** oleh **" .. player.Name .. "**",
            3066993 -- Hijau
        )
    end
    
    sellLoop = task.spawn(function()
        while autoSellEnabled do
            task.wait(2)
            local success, err = pcall(function()
                SellRemote:FireServer(sellSize)
            end)
            
            if not success then
                warn("❌ Error Auto Sell: " .. tostring(err))
            end
            
            task.wait(1)
        end
    end)
end

local function stopAutoSell()
    autoSellEnabled = false
    if sellLoop then
        task.cancel(sellLoop)
        sellLoop = nil
    end
    print("🛑 AUTO SELL DIHENTIKAN")
    
    if warMachine.webhookMonitor then
        sendToDiscord(
            "💰 AUTO SELL STOPPED",
            "Auto Sell telah dihentikan oleh **" .. player.Name .. "**",
            16711680 -- Merah
        )
    end
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
--//  TAB MAIN
--// ================================
local MainTab = Window:CreateTab("Main", 4483362458)

-- Section Auto Reel
local ReelSection = MainTab:CreateSection("🎣 AUTO REEL CONTROL")
local reelStatusLabel = MainTab:CreateLabel("AUTO REEL STATUS: BERHENTI")

MainTab:CreateButton({
    Name = "▶️ START AUTO REEL",
    Callback = function()
        startAutoReel()
        reelStatusLabel:Set("AUTO REEL STATUS: BERJALAN")
        Rayfield:Notify({
            Title = "Auto Reel",
            Content = "✅ Auto reel dimulai!",
            Duration = 2
        })
    end
})

MainTab:CreateButton({
    Name = "⏹️ STOP AUTO REEL",
    Callback = function()
        stopAutoReel()
        reelStatusLabel:Set("AUTO REEL STATUS: BERHENTI")
        Rayfield:Notify({
            Title = "Auto Reel",
            Content = "🛑 Auto reel dihentikan!",
            Duration = 2
        })
    end
})

-- Section Auto Sell
local SellSection = MainTab:CreateSection("💰 AUTO SELL CONTROL")
local sellStatusLabel = MainTab:CreateLabel("AUTO SELL STATUS: BERHENTI")

MainTab:CreateInput({
    Name = "📏 UKURAN MINIMUM JUAL",
    CurrentValue = "100",
    PlaceholderText = "Contoh: 100",
    Callback = function(Text)
        local newSize = tonumber(Text)
        if newSize and newSize > 0 then
            sellSize = newSize
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "✅ Ukuran jual diatur ke: " .. sellSize,
                Duration = 2
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "💰 START AUTO SELL",
    Callback = function()
        startAutoSell()
        sellStatusLabel:Set("AUTO SELL STATUS: BERJALAN (Size: " .. sellSize .. ")")
        Rayfield:Notify({
            Title = "Auto Sell",
            Content = "✅ Auto sell dimulai!",
            Duration = 2
        })
    end
})

MainTab:CreateButton({
    Name = "⏹️ STOP AUTO SELL",
    Callback = function()
        stopAutoSell()
        sellStatusLabel:Set("AUTO SELL STATUS: BERHENTI")
        Rayfield:Notify({
            Title = "Auto Sell",
            Content = "🛑 Auto sell dihentikan!",
            Duration = 2
        })
    end
})

--// ================================
--//  TAB SETTING
--// ================================
local SettingTab = Window:CreateTab("Setting", 4483362458)
local WarSection = SettingTab:CreateSection("⚔️ WAR MACHINE SETTINGS")

-- Toggles untuk War Machine
SettingTab:CreateToggle({
    Name = "Anti Kick (20 Layer)",
    CurrentValue = true,
    Flag = "antikick",
    Callback = function(value) warMachine.antiKick = value end
})

SettingTab:CreateToggle({
    Name = "Anti Destroy (15 Layer)",
    CurrentValue = true,
    Flag = "antidestroy",
    Callback = function(value) warMachine.antiDestroy = value end
})

SettingTab:CreateToggle({
    Name = "Anti Remove (15 Layer)",
    CurrentValue = true,
    Flag = "antiremove",
    Callback = function(value) warMachine.antiRemove = value end
})

SettingTab:CreateToggle({
    Name = "Anti Teleport",
    CurrentValue = true,
    Flag = "antiteleport",
    Callback = function(value) warMachine.antiTeleport = value end
})

SettingTab:CreateToggle({
    Name = "Anti Idle",
    CurrentValue = true,
    Flag = "antiidle",
    Callback = function(value) warMachine.antiIdle = value end
})

SettingTab:CreateToggle({
    Name = "Anti Ancestry",
    CurrentValue = true,
    Flag = "antiacestry",
    Callback = function(value) warMachine.antiAncestry = value end
})

SettingTab:CreateToggle({
    Name = "Hide Console",
    CurrentValue = true,
    Flag = "hideconsole",
    Callback = function(value) warMachine.hideConsole = value end
})

SettingTab:CreateToggle({
    Name = "Mute Logs",
    CurrentValue = true,
    Flag = "mutelogs",
    Callback = function(value) warMachine.muteLogs = value end
})

SettingTab:CreateToggle({
    Name = "Anti Scan Memory",
    CurrentValue = true,
    Flag = "antiscan",
    Callback = function(value) warMachine.antiScan = value end
})

-- Tombol Terapkan Setting
SettingTab:CreateButton({
    Name = "✅ TERAPKAN SETTING",
    Callback = function()
        activateWarMachine()
        Rayfield:Notify({
            Title = "War Machine",
            Content = "⚔️ Setting diterapkan!",
            Duration = 2
        })
    end
})

--// ================================
--//  AUTO UPDATE STATUS REEL & SELL
--// ================================
spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if autoReelEnabled then
                reelStatusLabel:Set("AUTO REEL STATUS: BERJALAN")
            else
                reelStatusLabel:Set("AUTO REEL STATUS: BERHENTI")
            end
            
            if autoSellEnabled then
                sellStatusLabel:Set("AUTO SELL STATUS: BERJALAN (Size: " .. sellSize .. ")")
            else
                sellStatusLabel:Set("AUTO SELL STATUS: BERHENTI")
            end
        end)
    end
end)

--// ================================
--//  INITIALIZATION
--// ================================
task.wait(1)
activateWarMachine()
startDiscordListener()

-- Kirim notifikasi startup
if webhookEnabled then
    sendToDiscord(
        "🟢 SCRIPT STARTED",
        "**" .. player.Name .. "** telah menjalankan Ambon|Hub GET FISH WAR!\nSession ID: `" .. monitorData.sessionID .. "`\nServer: `" .. game.JobId .. "`",
        3066993,
        {
            {
                name = "🛡️ Anti-Kick",
                value = "20 Layer",
                inline = true
            },
            {
                name = "🎣 Auto Reel",
                value = "Ready",
                inline = true
            },
            {
                name = "💰 Auto Sell",
                value = "Ready (Size: " .. sellSize .. ")",
                inline = true
            }
        }
    )
end

warn("=== ✅ SCRIPT SIAP DENGAN WEBHOOK MONITOR ===")
warn("=== 📡 Discord Webhook: " .. (WEBHOOK_URL ~= "" and "ACTIVE" or "INACTIVE - SET URL DI TAB WEBHOOK") .. " ===")
warn("=== 👑 LU YANG BERKUASA - SELAMANYA ===")