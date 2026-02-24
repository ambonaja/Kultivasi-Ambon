--// ================================
--// Fishing Exploit - BIG TARGET SIZE
--// Credit : Ambon|Hub (RAJA EXPLOIT)
--// ================================

-- Cari MinigameSystem
local FishingSystem = game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem")
local MinigameSystem = require(FishingSystem:WaitForChild("FishingModules"):WaitForChild("MinigameSystem"))

-- Simpen fungsi asli
local oldStart = MinigameSystem.Start
local oldUpdate = MinigameSystem.UpdateVisuals
local oldIsInside = MinigameSystem.IsInsideTarget

--[================================[ BYPASS ANTI CHEAT ]================================]
local mt = getrawmetatable(game)
local old_namecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and tostring(self):find("AntiCheat") then
        return nil -- Blok anti cheat
    end
    return old_namecall(self, ...)
end)
--[================================[ BYPASS ANTI CHEAT ]================================]

--[============[ MAIN EXPLOIT - TARGET SIZE GEDE ]============]
MinigameSystem.Start = function(self, ...)
    print("🔥 [AMBON] Fishing exploit AKTIF!")
    
    -- Panggil fungsi asli
    oldStart(self, ...)
    
    -- GEDEIN TARGET SIZE SAMPE 90% LAYAR!
    local v_u_4 = debug.getupvalue(oldUpdate, 2) -- Ambil table v_u_4
    
    if v_u_4 then
        -- INI DIA YANG TUAN MAU: TARGET SIZE GEDE!
        v_u_4.targetSize = 0.95  -- <-- GEDE BANGET (bisa diatur 0.5 - 0.95)
        
        -- BONUS: SETTING LAIN BIAR MUDAH
        v_u_4.gravity = 0.01     -- Target jatuhnya lambet
        v_u_4.clickPower = 0.1   -- Klik sekali langsung naik banyak
        v_u_4.catchSpeed = 0.9   -- Cepet dapet ikan
        v_u_4.loseSpeed = 0.01   -- Susah ilang progress
        
        print("✅ [AMBON] Target size: " .. v_u_4.targetSize)
        print("✅ [AMBON] Gravity: " .. v_u_4.gravity)
        print("✅ [AMBON] Click power: " .. v_u_4.clickPower)
    end
    
    -- Auto click biar makin gampang
    task.spawn(function()
        while MinigameSystem.IsActive() do
            pcall(function()
                -- Auto click tiap 0.1 detik
                local args = {
                    [1] = {
                        ["Play"] = function() end
                    },
                    [2] = {
                        ["AnimateImageTap"] = function() end
                    }
                }
                MinigameSystem.HandleClick(unpack(args))
            end)
            task.wait(0.01)
        end
    end)
end

-- Update visuals biar keliatan
MinigameSystem.UpdateVisuals = function(self, ...)
    local v_u_4 = debug.getupvalue(oldUpdate, 2)
    if v_u_4 then
        v_u_4.targetSize = 0.95 -- Tetap gede tiap update
    end
    return oldUpdate(self, ...)
end

-- Ubah fungsi IsInsideTarget biar selalu true
MinigameSystem.IsInsideTarget = function(self)
    return true -- SELALU DI DALEM TARGET!
end

print("🔥🔥🔥 AMBON FISHING EXPLOIT LOADED 🔥🔥🔥")
print("✅ Target Size: 0.9 (GEDE BANGET)")
print("✅ Gravity: 0.01 (Lambat jatuh)")
print("✅ Auto Click: AKTIF")
print("✅ Anti Cheat: BYPASS")
print("✅ Credit: Ambon|Hub - No.1")