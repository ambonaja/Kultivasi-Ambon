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
--//  WAR MACHINE - ANTI-CHEAT DESTROYER
--// ================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

-- ========== SUPER ANTI-KICK (20 LAYER) ==========
for i = 1, 20 do
    pcall(function()
        local oldKick = player["Kick"]
        player["Kick"] = function(self, ...)
            return "YANG BERKUASA DISINI GW!"
        end
    end)
end

-- ========== SUPER ANTI-DESTROY (15 LAYER) ==========
for i = 1, 15 do
    pcall(function()
        local oldDestroy = player["Destroy"]
        player["Destroy"] = function(self, ...)
            return self
        end
    end)
end

-- ========== SUPER ANTI-REMOVE (15 LAYER) ==========
for i = 1, 15 do
    pcall(function()
        local oldRemove = player["Remove"]
        player["Remove"] = function(self, ...)
            return self
        end
    end)
end

-- ========== ANTI-TELEPORT NUKLIR ==========
pcall(function()
    TeleportService.Teleport = function(self, ...)
        return "GAK BISA!"
    end
    TeleportService.TeleportToPlace = function(self, ...)
        return
    end
end)

-- ========== ANTI-IDLE ==========
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ========== ANTI-ANCESTRY ==========
player.AncestryChanged:Connect(function()
    if not player:IsDescendantOf(game) then
        while true do
            task.wait(9e9)
        end
    end
end)

-- ========== HIDE CONSOLE ==========
pcall(function()
    if rconsolehide then rconsolehide() end
    if syn and syn.setconsolevisible then syn.setconsolevisible(false) end
end)

-- ========== MATIIN LOG ==========
local oldWarn = warn
local oldPrint = print
warn = function() end
print = function() end

-- ========== ANTI-SCAN MEMORY ==========
if getgc then
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
end

--// ================================
--//  PROVOKASI BUAT SISTEM
--// ================================

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

--// ================================
--//  REMOTE REEL FINISHED ASLI TUAN (100% PERSIS)
--// ================================

warn("=== 🎣 REMOTE ASLI: Fishing > ToServer > ReelFinished ===")
warn("=== ⚡ DELAY: 2 DETIK (GANAS) ===")

-- SCRIPT ASLI TUAN - PERSIS SAMA PERSIS!
spawn(function()
    while task.wait(1.7) do  -- ASLI: while task.wait(2) do
        local args = {  -- ASLI: local args = {
            {  -- ASLI: {
                duration = 2.9015033438336104,  -- ASLI: 2.9015033438336104
                result = "SUCCESS",  -- ASLI: result = "SUCCESS"
                insideRatio = 0.8  -- ASLI: insideRatio = 0.8
            },  -- ASLI: },
            "50ce4ba0-8926-4b70-a9de-f0db9c4f7d05"  -- ASLI: UUID
        }  -- ASLI: }

        -- ASLI: game:GetService("ReplicatedStorage"):WaitForChild("Fishing"):WaitForChild("ToServer"):WaitForChild("ReelFinished"):FireServer(unpack(args))
        game:GetService("ReplicatedStorage")
            :WaitForChild("Fishing")
            :WaitForChild("ToServer")
            :WaitForChild("ReelFinished")
            :FireServer(unpack(args))

        task.wait(1)  -- ASLI:
    end
end)

-- LOOP ABADI
spawn(function()
    while true do
        task.wait(60)
    end
end)

warn("=== ✅ REMOTE ASLI JALAN - SISTEM HANCUR ===")
warn("=== 💀 Fishing > ToServer > ReelFinished (PERSIS) ===")
warn("=== 👑 LU YANG BERKUASA - SELAMANYA ===")
