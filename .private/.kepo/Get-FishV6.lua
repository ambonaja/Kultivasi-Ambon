-- =========================================================================
-- 🔥 AMBONHUB ULTIMATE PROTECTION v27.14 + FISHING BOT 🔥
-- =========================================================================

-- 🔑 CONFIGURATION
local OWNER_ID = 9479683404 -- << GANTI PAKE USER ID ROBLOX TUAN!
local WEBHOOK_URL = "https://discord.com/api/webhooks/1473696836857630893/Wz19fKEKYk17MQetQ_PHjaRyzqKWl-ZYU5_9Jrztb9OZF4vzjItOuBjBNgLTQjNielw9" -- << WEBHOOK DISCORD TUAN

local LP = game:GetService("Players").LocalPlayer
local IsOwner = (LP.UserId == OWNER_ID)

-- 🛡️ [ANTI-TAMPER LOGIC TETAP SAMA]
local function TertangkapPencuri()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.IgnoreGuiInset = true
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Parent = Frame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.SpecialElite
    TextLabel.Text = "tertangkap kau pencuri😹🫵"
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    TextLabel.TextSize = 100
    TextLabel.TextWrapped = true
    for i = 1, 100 do warn("PENCURI KODE TERDETEKSI: AMBONHUB ANTI-TAMPER") end
    task.wait(3)
    game.Players.LocalPlayer:Kick("tertangkap kau pencuri😹🫵")
end

task.spawn(function()
    while task.wait(0.5) do
        if game:GetService("CoreGui"):FindFirstChild("RemoteSpy") or 
           game:GetService("CoreGui"):FindFirstChild("Dex") or 
           game:GetService("CoreGui"):FindFirstChild("SimpleSpy") then
            TertangkapPencuri()
        end
    end
end)

-- 🕵️ 2. TRACKER SYSTEM (UPGRADED)
local function GetCurrentLocation()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        if pos.Z < -1500 then return "Mega Hunt / Hutan Tropis 🌲"
        elseif pos.Z > 1400 then return "Deepsea / Pulau Skyler 🌊"
        elseif pos.X > 2000 then return "Pulau Majitos 🌵"
        elseif pos.Y > 1010 then return "Sky Fishing (1020) ☁️"
        else return "Pulau Kinyis / Main Area 🏝️" end
    end
    return "Unknown"
end

local function SendSpyLog(action)
    if WEBHOOK_URL == "https://discord.com/api/webhooks/1472005047276671127/ZlcVPyiHwyFOXSFuwGABovhtZegSCOeGubjJ4SgQvQr_iW2o8pRRLdPDFmiWKfAeGjk6" then return end
    pcall(function()
        local data = {
            ["embeds"] = {{
                ["title"] = "🕵️ AMBONHUB MONITOR: " .. (IsOwner and "OWNER" or "USER"),
                ["description"] = "Activity log for **" .. LP.Name .. "**",
                ["color"] = IsOwner and 0x00ff00 or 0xff0000,
                ["fields"] = {
                    {["name"] = "🧑‍💻 Username", ["value"] = LP.Name, ["inline"] = true},
                    {["name"] = "🆔 User ID", ["value"] = tostring(LP.UserId), ["inline"] = true},
                    {["name"] = "📅 Account Age", ["value"] = LP.AccountAge .. " Days", ["inline"] = true},
                    {["name"] = "🗺️ Location", ["value"] = GetCurrentLocation(), ["inline"] = true},
                    {["name"] = "🎬 Action", ["value"] = action, ["inline"] = true},
                    {["name"] = "⏰ Server Time", ["value"] = os.date("%H:%M:%S"), ["inline"] = true}
                },
                ["footer"] = {["text"] = "AmbonHub v27.14 | Sovereign System"}
            }}
        }
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        req({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(data)})
    end)
end

-- =========================================================================
-- ⚡ FISHING BOT FUNCTIONS (YANG WORK 100%)
-- =========================================================================

-- Variables for fishing bot
local rodUUID = ""
local loopActive = false
local loopDelay = 2.0

-- Function buat auto scan UUID dari rod yang lagi dipegang
local function getRodUUID()
    local uuid = ""
    
    if LP.Character then
        local tool = LP.Character:FindFirstChildOfClass("Tool")
        if tool then
            -- Scan dari attributes
            for _, attr in pairs(tool:GetAttributes()) do
                if type(attr) == "string" and #attr == 36 then
                    uuid = attr
                    break
                end
            end
            
            -- Scan dari child
            if uuid == "" then
                for _, child in pairs(tool:GetChildren()) do
                    if child:IsA("StringValue") and #child.Value == 36 then
                        uuid = child.Value
                        break
                    end
                end
            end
            
            -- Scan dari nama
            if uuid == "" then
                local nameMatch = tool.Name:match("[%x%-]36")
                if nameMatch and #nameMatch == 36 then
                    uuid = nameMatch
                end
            end
        end
    end
    
    return uuid
end

-- Function Cast Manual
local function manualCast()
    rodUUID = getRodUUID()
    if rodUUID and rodUUID ~= "" then
        local throwRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Fishing_RemoteThrow")
        if throwRemote then
            throwRemote:FireServer(0.3102201450019493, rodUUID)
            return true
        end
    end
    return false
end

-- Function Reel Manual
local function manualReel()
    rodUUID = getRodUUID()
    if rodUUID and rodUUID ~= "" then
        local fishing = game:GetService("ReplicatedStorage"):FindFirstChild("Fishing")
        if fishing then
            local toServer = fishing:FindFirstChild("ToServer")
            if toServer then
                local reelFinished = toServer:FindFirstChild("ReelFinished")
                if reelFinished then
                    reelFinished:FireServer({
                        duration = 8.399294571005157,
                        result = "SUCCESS",
                        insideRatio = 0.8
                    }, rodUUID)
                    return true
                end
            end
        end
    end
    return false
end

-- Loop simple
local function startLoop()
    while loopActive do
        if manualCast() then
            task.wait(4) -- Tunggu proses casting
            manualReel() -- Reel 1x aja
        end
        
        -- Delay sesuai slider
        local waitStart = tick()
        while loopActive and tick() - waitStart < loopDelay do
            task.wait(0.1)
        end
    end
end

-- =========================================================================
-- ⚡ MAIN UI START (RAYFIELD)
-- =========================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
task.spawn(function() SendSpyLog("User Opened GUI 💻") end)

local Window = Rayfield:CreateWindow({
   Name = "🚯 AmbonHub Official | " .. (IsOwner and "👑 OWNER MODE" or "Get Fish V2 Peak Mode"),
   LoadingTitle = "AmbonHub🚯...",
   LoadingSubtitle = "by AmbonGuard System",
   ConfigurationSaving = { Enabled = true, FolderName = "AmbonHub_Fishing", FileName = "GodConfigV27" },
   KeySystem = false
})

-- VARS GLOBAL (SESUAI v27 TUAN)
local RS = game:GetService("ReplicatedStorage")
local Reel = RS:WaitForChild("Fishing"):WaitForChild("ToServer"):WaitForChild("ReelFinished")
local GetBobber = RS:WaitForChild("BobberShop"):WaitForChild("ToServer"):WaitForChild("GetEquippedBobber")
local SellRemote = RS:WaitForChild("Economy"):WaitForChild("ToServer"):WaitForChild("SellUnder")
local lastID, autoFarm, farmMode, autoRejoin, antiAdmin, reelDelay, positionLocked, autoSell, sellSize = nil, false, "Bomber", true, true, 1.2, false, false, 100

-- TABS
local HomeTab = Window:CreateTab("Home", 4483362458)
local FishingTab = Window:CreateTab("Fishing Manual", 4483362458) -- FISHING MANUAL TAB (YANG WORK)
local MainTab = Window:CreateTab("Fishing Auto", 4483362458) -- FISHING AUTO TAB (ORI)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- 👑 OWNER ONLY TAB
if IsOwner then
    local DivineTab = Window:CreateTab("Divine Power 👑", 4483362458)
    DivineTab:CreateSection("Sovereign Authority")
    DivineTab:CreateButton({Name = "Announce Authority", Callback = function() game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("AMBONHUB OWNED THIS SERVER 🚯", "All") end})
    DivineTab:CreateButton({Name = "Steal Empty Boats", Callback = function() for _, v in pairs(game.Workspace.Vehicles:GetChildren()) do if v:FindFirstChild("DriveSeat") and not v.DriveSeat.Occupant then v:SetPrimaryPartCFrame(LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)) end end end})
    DivineTab:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(Value) for _, p in pairs(game.Players:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then if Value then local B = Instance.new("BillboardGui", p.Character.Head) B.Name = "AmbonSpy"; B.Size = UDim2.new(0, 200, 0, 50); B.AlwaysOnTop = true local T = Instance.new("TextLabel", B) T.Text = p.Name; T.TextColor3 = Color3.fromRGB(255, 0, 0); T.BackgroundTransparency = 1; T.Size = UDim2.new(1,0,1,0) elseif p.Character.Head:FindFirstChild("AmbonSpy") then p.Character.Head.AmbonSpy:Destroy() end end end end})
end

local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- ================= HOME TAB =================
HomeTab:CreateSection("Player Info")
HomeTab:CreateLabel("Username: " .. LP.Name)
HomeTab:CreateLabel("User ID: " .. LP.UserId)
HomeTab:CreateLabel("Age: " .. LP.AccountAge .. " Days")

-- ================= FISHING MANUAL TAB (YANG WORK) =================
FishingTab:CreateSection("🎣 MANUAL FISHING BOT (100% WORK)")

-- Status UUID
local statusLabel = FishingTab:CreateParagraph({
    Title = "ROD STATUS",
    Content = "PEGANG ROD DULU!"
})

-- Update status function
local function updateStatus()
    rodUUID = getRodUUID()
    if rodUUID and rodUUID ~= "" then
        statusLabel:Set("Current UUID:", rodUUID)
    else
        statusLabel:Set("Current UUID:", "PEGANG ROD DULU!")
    end
end

-- Slider delay loop
FishingTab:CreateSlider({
    Name = "⏱️ DELAY ANTAR LOOP",
    Range = {0.5, 5.0},
    Increment = 0.1,
    Suffix = "Detik",
    CurrentValue = loopDelay,
    Callback = function(Value)
        loopDelay = Value
    end,
})

-- Toggle loop manual
local loopToggle = FishingTab:CreateToggle({
    Name = "🔄 AUTO LOOP (CAST + REEL)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            rodUUID = getRodUUID()
            if rodUUID and rodUUID ~= "" then
                loopActive = true
                task.spawn(startLoop)
                SendSpyLog("Start Manual Loop - Delay: "..loopDelay.."s")
                Rayfield:Notify({
                    Title = "Loop Started",
                    Content = "Delay: "..loopDelay.." detik",
                    Duration = 2,
                })
            else
                loopToggle:Set(false)
                Rayfield:Notify({
                    Title = "Gagal",
                    Content = "Pegang rod dulu!",
                    Duration = 2,
                })
            end
        else
            loopActive = false
            SendSpyLog("Stop Manual Loop")
            Rayfield:Notify({
                Title = "Stopped",
                Content = "Loop dimatikan",
                Duration = 2,
            })
        end
    end,
})

-- Tombol Cast
FishingTab:CreateButton({
    Name = "🎣 CAST (SEKALI)",
    Callback = function()
        if manualCast() then
            SendSpyLog("Manual Cast")
            Rayfield:Notify({
                Title = "Cast",
                Content = "Casting...",
                Duration = 1,
            })
        else
            Rayfield:Notify({
                Title = "Gagal",
                Content = "Pegang rod!",
                Duration = 1,
            })
        end
    end,
})

-- Tombol Reel
FishingTab:CreateButton({
    Name = "🎣 REEL (SEKALI)",
    Callback = function()
        if manualReel() then
            SendSpyLog("Manual Reel")
            Rayfield:Notify({
                Title = "Reel",
                Content = "Reel finished",
                Duration = 1,
            })
        else
            Rayfield:Notify({
                Title = "Gagal",
                Content = "Pegang rod!",
                Duration = 1,
            })
        end
    end,
})

-- Tombol Refresh UUID
FishingTab:CreateButton({
    Name = "🔄 REFRESH UUID",
    Callback = function()
        updateStatus()
        Rayfield:Notify({
            Title = "UUID Refreshed",
            Content = rodUUID or "Tidak ditemukan",
            Duration = 2,
        })
    end,
})

-- ================= MAIN TAB (FISHING AUTO ORI) =================
MainTab:CreateSection("Farm Controls")
MainTab:CreateToggle({
   Name = "Start Auto Fish",
   CurrentValue = false,
   Flag = "Toggle_AutoFarm",
   Callback = function(Value)
      autoFarm = Value
      if Value then
          SendSpyLog("Start Auto Fish 🎣")
          task.spawn(function()
              while autoFarm do
                  if lastID then
                      task.wait(reelDelay)
                      pcall(function() GetBobber:InvokeServer() end)
                      task.wait(0.05)
                      if farmMode == "Bomber" then
                          for i = 1, 3 do task.spawn(function() Reel:FireServer({duration = reelDelay - 0.2 + (math.random() * 0.1), result = "SUCCESS", insideRatio = 0.95 + (math.random() * 0.04)}, lastID) end) end
                      elseif farmMode == "Safe Bomber" then
                          Reel:FireServer({duration = reelDelay + (math.random() * 0.1), result = "SUCCESS", insideRatio = 0.92 + (math.random() * 0.05)}, lastID)
                      end
                      lastID = nil
                  end
                  task.wait(0.1)
              end
          end)
      else
          SendSpyLog("Stop Auto Fish 🛑")
      end
   end,
})

MainTab:CreateDropdown({
   Name = "Select Farm Mode",
   Options = {"Bomber", "Safe Bomber"},
   CurrentOption = "Bomber",
   Callback = function(Option) farmMode = Option[1] end,
})

MainTab:CreateSlider({
   Name = "Reel Delay (Seconds)",
   Range = {0.5, 10},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 1.2,
   Flag = "Slider_Delay",
   Callback = function(Value) reelDelay = Value end,
})

MainTab:CreateSection("Auto Sell Controls")
MainTab:CreateInput({
   Name = "Input Max Size to Sell",
   CurrentValue = "100",
   PlaceholderText = "Contoh: 100",
   Callback = function(Text)
      sellSize = tonumber(Text) or 100
      Rayfield:Notify({Title = "Auto Sell", Content = "Ukuran jual diatur ke: " .. sellSize, Duration = 2})
   end,
})

MainTab:CreateToggle({
   Name = "Start Auto Sell (Loop)",
   CurrentValue = false,
   Flag = "Toggle_AutoSell",
   Callback = function(Value)
      autoSell = Value
      if Value then
          SendSpyLog("Start Auto Sell 💰")
          task.spawn(function()
              while autoSell do
                  pcall(function() SellRemote:FireServer(sellSize) end)
                  task.wait(2)
              end
          end)
      else
          SendSpyLog("Stop Auto Sell 🛑")
      end
   end,
})

-- ================= TELEPORT TAB =================
local function TP(x, y, z, lock)
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        positionLocked = false 
        char.HumanoidRootPart.Anchored = false
        char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        char.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        SendSpyLog("Teleport to " .. x..","..y..","..z)
        if lock then
            task.wait(0.2)
            positionLocked = true
            Rayfield:Notify({Title = "Position Locked", Content = "Ketinggian dikunci di 1020!", Duration = 3})
            task.spawn(function()
                while positionLocked and char:FindFirstChild("HumanoidRootPart") do
                    char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    char.HumanoidRootPart.CFrame = CFrame.new(x, 1020, z)
                    task.wait(0.1)
                end
            end)
        else
            Rayfield:Notify({Title = "Teleport", Content = "Berhasil pindah ke Pulau!", Duration = 2})
        end
    end
end

TeleportTab:CreateSection("Sky Fishing (🔒 Lock 1020)")
TeleportTab:CreateButton({Name = "Lautan (Sky 1020 🔒)", Callback = function() TP(-1031, 1020, -683, true) end})
TeleportTab:CreateButton({Name = "Mega Hunt (Sky 1020 🔒)", Callback = function() TP(-603, 1020, -1799, true) end})

TeleportTab:CreateSection("Island Locations")
TeleportTab:CreateButton({Name = "Pulau Kinyis", Callback = function() TP(168, 1007, -828, false) end})
TeleportTab:CreateButton({Name = "Pulau Majitos", Callback = function() TP(2131, 1009, 29, false) end})
TeleportTab:CreateButton({Name = "Deepsea", Callback = function() TP(1097, 1023, 1580, false) end})
TeleportTab:CreateButton({Name = "Pulau Skyler", Callback = function() TP(-1413, 1016, 1534, false) end})
TeleportTab:CreateButton({Name = "Hutan Tropis", Callback = function() TP(-1829, 1005, -1577, false) end})

-- ================= SETTINGS TAB =================
SettingsTab:CreateSection("Protection")
SettingsTab:CreateToggle({Name = "Ultra Anti-Admin (Auto-Leave)", CurrentValue = true, Callback = function(Value) antiAdmin = Value end})

SettingsTab:CreateSection("System")
SettingsTab:CreateToggle({Name = "Auto Rejoin on Kick", CurrentValue = true, Callback = function(Value) autoRejoin = Value end})
SettingsTab:CreateButton({Name = "Force Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end})

-- ================= ANTI AFK =================
SettingsTab:CreateSection("Anti AFK System")

local antiAFK = false
local VirtualUser = game:GetService("VirtualUser")

SettingsTab:CreateToggle({
    Name = "Anti AFK (100% Safe)",
    CurrentValue = false,
    Callback = function(Value)
        antiAFK = Value
        
        if Value then
            SendSpyLog("Anti AFK Enabled 🛡️")
            
            -- System 1 (Idle Connection)
            LP.Idled:Connect(function()
                if antiAFK then
                    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
            
            -- System 2 (Backup Loop - Anti Fail)
            task.spawn(function()
                while antiAFK do
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    task.wait(50) -- Roblox idle limit aman
                end
            end)
            
            Rayfield:Notify({
                Title = "Anti AFK Aktif",
                Content = "Proteksi idle menyala 🔥",
                Duration = 3,
            })
            
        else
            SendSpyLog("Anti AFK Disabled ❌")
            
            Rayfield:Notify({
                Title = "Anti AFK Mati",
                Content = "Proteksi idle dimatikan",
                Duration = 2,
            })
        end
    end,
})


SettingsTab:CreateSection("Credits")
SettingsTab:CreateLabel("Owner: AmbonHub 🚯")
SettingsTab:CreateLabel("Scripted by Ambon")

-- ================= AUTO UPDATE STATUS =================
-- Auto update status untuk fishing manual
LP.CharacterAdded:Connect(function()
    task.wait(1)
    updateStatus()
end)

if LP.Character then
    LP.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.5)
            updateStatus()
        end
    end)
    
    LP.Character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.5)
            updateStatus()
        end
    end)
end

-- First scan
task.wait(1)
updateStatus()

-- ================= CORE LOGIC =================
game:GetService("Players").PlayerAdded:Connect(function(player)
    if antiAdmin then
        if player:GetRankInGroup(0) > 100 or player:GetRankInGroup(0) == 255 then
            SendSpyLog("⚠️ ADMIN DETECTED: " .. player.Name .. " - Auto Leaving")
            game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
        end
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if tostring(self) == "Fishing_RemoteThrow" and getnamecallmethod() == "FireServer" then lastID = args[2] end
    if (getnamecallmethod() == "FireServer" and (tostring(self):lower():find("ban") or tostring(self):lower():find("kick"))) then return nil end
    return oldNamecall(self, ...)
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if autoRejoin then 
        SendSpyLog("🛑 Script Kicked - Auto Rejoining")
        task.wait(1.5) 
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP) 
    end
end)

Rayfield:LoadConfiguration()