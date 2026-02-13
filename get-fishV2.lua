-- =========================================================================
-- 🔥 AMBONHUB ULTIMATE PROTECTION v27 🔥
-- =========================================================================

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

    for i = 1, 100 do
        warn("PENCURI KODE TERDETEKSI: AMBONHUB ANTI-TAMPER")
    end

    task.wait(3)
    game.Players.LocalPlayer:Kick("tertangkap kau pencuri😹🫵")
end

-- 1. DETEKSI DEBUGGER/SPY/DEX
task.spawn(function()
    while task.wait(0.5) do
        if game:GetService("CoreGui"):FindFirstChild("RemoteSpy") or 
           game:GetService("CoreGui"):FindFirstChild("Dex") or 
           game:GetService("CoreGui"):FindFirstChild("SimpleSpy") then
            TertangkapPencuri()
        end
    end
end)

-- 2. INTEGRITY CHECK
local owner_val = "AmbonHub 🚯"
if owner_val ~= "AmbonHub 🚯" then
    TertangkapPencuri()
    return
end

-- =========================================================================
-- ⚡ MAIN SCRIPT START ⚡
-- =========================================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local LP = game:GetService("Players").LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "🚯 AmbonHub Official | Get Fish V2 Peak Mode",
   LoadingTitle = "AmbonHub🚯...",
   LoadingSubtitle = "by AmbonGuard System",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AmbonHub_Fishing",
      FileName = "GodConfigV27"
   },
   KeySystem = false
})

-- Variabel Global
local RS = game:GetService("ReplicatedStorage")
local Reel = RS:WaitForChild("Fishing"):WaitForChild("ToServer"):WaitForChild("ReelFinished")
local GetBobber = RS:WaitForChild("BobberShop"):WaitForChild("ToServer"):WaitForChild("GetEquippedBobber")
local SellRemote = RS:WaitForChild("Economy"):WaitForChild("ToServer"):WaitForChild("SellUnder")

local lastID = nil
local autoFarm = false
local farmMode = "Bomber"
local autoRejoin = true
local antiAdmin = true
local reelDelay = 1.2 
local positionLocked = false
local autoSell = false
local sellSize = 100 -- Default size

-- TABS
local HomeTab = Window:CreateTab("Home", 4483362458)
local MainTab = Window:CreateTab("Fishing", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- ================= HOME TAB =================
HomeTab:CreateSection("Player Info")
HomeTab:CreateLabel("Username: " .. LP.Name)
HomeTab:CreateLabel("User ID: " .. LP.UserId)
HomeTab:CreateLabel("Account Age: " .. LP.AccountAge .. " Days")

-- ================= MAIN TAB =================
MainTab:CreateSection("Farm Controls")

MainTab:CreateToggle({
   Name = "Start Auto Fish",
   CurrentValue = false,
   Flag = "Toggle_AutoFarm",
   Callback = function(Value)
      autoFarm = Value
      if Value then
          task.spawn(function()
              while autoFarm do
                  if lastID then
                      task.wait(reelDelay)
                      pcall(function() GetBobber:InvokeServer() end)
                      task.wait(0.05)
                      
                      if farmMode == "Bomber" then
                          for i = 1, 3 do
                              task.spawn(function()
                                  Reel:FireServer({
                                      duration = reelDelay - 0.2 + (math.random() * 0.1), 
                                      result = "SUCCESS",
                                      insideRatio = 0.95 + (math.random() * 0.04)
                                  }, lastID)
                              end)
                          end
                      elseif farmMode == "Safe Bomber" then
                          Reel:FireServer({
                              duration = reelDelay + (math.random() * 0.1), 
                              result = "SUCCESS",
                              insideRatio = 0.92 + (math.random() * 0.05)
                          }, lastID)
                      end
                      lastID = nil
                  end
                  task.wait(0.1)
              end
          end)
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

-- AUTO SELL SECTION
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
          task.spawn(function()
              while autoSell do
                  pcall(function()
                      SellRemote:FireServer(sellSize)
                  end)
                  task.wait(2) -- Jual tiap 2 detik biar ga spam
              end
          end)
      end
   end,
})

-- ================= TELEPORT TAB =================
TeleportTab:CreateSection("Sky Fishing (🔒 Lock 1020)")

local function TP(x, y, z, lock)
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        positionLocked = false 
        char.HumanoidRootPart.Anchored = false
        char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        char.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        
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
SettingsTab:CreateToggle({
   Name = "Ultra Anti-Admin (Auto-Leave)",
   CurrentValue = true,
   Callback = function(Value) antiAdmin = Value end,
})

SettingsTab:CreateSection("System")
SettingsTab:CreateToggle({
   Name = "Auto Rejoin on Kick",
   CurrentValue = true,
   Callback = function(Value) autoRejoin = Value end,
})

SettingsTab:CreateButton({
   Name = "Force Rejoin Server",
   Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end
})

SettingsTab:CreateSection("Credits")
SettingsTab:CreateLabel("Owner: AmbonHub 🚯")
SettingsTab:CreateLabel("Scripted by Ambon")

-- ================= CORE LOGIC =================
game:GetService("Players").PlayerAdded:Connect(function(player)
    if antiAdmin then
        if player:GetRankInGroup(0) > 100 or player.Name:lower():find("admin") or player.Name:lower():find("mod") then
            game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
        end
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if tostring(self) == "Fishing_RemoteThrow" and getnamecallmethod() == "FireServer" then
        lastID = args[2]
    end
    return oldNamecall(self, ...)
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if autoRejoin then task.wait(1.5) game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end
end)

Rayfield:LoadConfiguration()
