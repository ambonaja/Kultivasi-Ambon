-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Buat Window
local Window = Rayfield:CreateWindow({
    Name = "AmbonHub🚯",
    LoadingTitle = "Fishing Island",
    LoadingSubtitle = "AmbonHub🚯",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishingScript",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- Daftar lengkap ikan Secret
local secretFishList = {
    "1x1x1x1 Shark",
    "Albino King Crab",
    "Albino Mega Hunt",
    "Ancient Lochness Monster",
    "Ancient Lochness Monster Blue",
    "Ancient Lochness Monster Pink",
    "Ancient Lochness Monster Red",
    "Ancient Magma Whale",
    "Ancient Relic Crocodile",
    "Ancient Whale",
    "ArapaimaFish",
    "Barracuda Fish",
    "Black Kraken",
    "Blackcap Basslet",
    "Blob Fish",
    "Blob Shark",
    "Bloodmoon Whale",
    "Blossom Jelly",
    "Blue Crystal Crab",
    "Blue Fish",
    "Blue Lochness Monster",
    "Blue Orca",
    "Blue Sea Dragon",
    "Boar Fish",
    "Bone Fish",
    "Bone Whale",
    "Broken Heart Nessie",
    "Buaya Hutan",
    "Cavern Dweller",
    "Chines Blue Fish",
    "Chines Fish",
    "Chines Green Fish",
    "Cleo Fish",
    "Cobia",
    "Cosmic Mutant Shark",
    "Crimsom Ray",
    "Crocodile",
    "Cryoshade Glider",
    "Crystal Crab",
    "Cupid Octopus",
    "Cursed Kraken",
    "Cute Octopus",
    "Dead Scary Clownfish",
    "Dead Spooky Koi Fish",
    "Deep Fish",
    "El Maja",
    "ElRetro Gran Maja",
    "Elpirate Gran Maja",
    "Emerald Winter Whale",
    "Fangtooth",
    "Fish Black",
    "Fish Lake",
    "Fish Tipis",
    "Fish benrtol",
    "Fish gead",
    "Flatheaded Whale Shark",
    "Flying Manta",
    "Fossilized Shark",
    "Freshwater Piranha",
    "Frostborn Shark",
    "Genetik Fish",
    "Geo Fish",
    "Ghost Fish",
    "Ghost Ray",
    "Ghost Worm Fish",
    "Giant Squid",
    "Gladiator Shark",
    "Golden Giant Squid",
    "Golden Kraken",
    "GoldenTrout",
    "Goldfish",
    "Great Christmas Whale",
    "Great Whale",
    "Green Crystal Crab",
    "Green El Maja",
    "Green Fish",
    "Green Frostborn Shark",
    "Green Kraken",
    "Green Monster Shark",
    "Hammerhead Mummy",
    "Heart Dolphin",
    "Heart Octopus",
    "Heart Walrus",
    "Hermit Crab",
    "Hybodus Shark",
    "Jellyfish",
    "King Crab",
    "KingJally Strong",
    "Kraken",
    "Leviathan",
    "Light Dolphin",
    "Lion Fish",
    "Lochness Monster",
    "Loggerhead Turtle",
    "Love Nessie",
    "Loving Shark",
    "Lovtopus",
    "Luminous Fish",
    "Magma Shark",
    "Mammoth Appafish",
    "Manoai Statue Fish",
    "Mega Frostborn Shark",
    "Mega Hunt",
    "Monster Shark",
    "Morning Star",
    "Mosasaur Shark",
    "Naga",
    "Nemo",
    "Nila Fish",
    "Orange Flatheaded Whale Shark",
    "Orca",
    "Panther Eel",
    "Pink Bloodmoon Whale",
    "Pink Crystal Crab",
    "Pink Dolphin",
    "Pink El Maja",
    "Pink Flatheaded Whale Shark",
    "Pink Frostborn Shark",
    "Pink Giant Squid",
    "Pink King Crab",
    "Pink Kraken",
    "Pink Lochness Monster",
    "Pink Monster Shark",
    "Pink Orca",
    "Pirate Megalodon",
    "Plasma Shark",
    "Prismy Seahorse",
    "Puffy Blowhog",
    "Pumpkin Carved Shark",
    "Purple Bloodmoon Whale",
    "Queen Crab",
    "Rainbow Comet Shark",
    "Red El Maja",
    "Red Frostborn Shark",
    "Red Kraken",
    "Red Lochness Monster",
    "Red Monster Shark",
    "Red Orca",
    "Red Rose",
    "Rock Fish",
    "Rose Bouquet",
    "Rose Swordfish",
    "Roster Fish",
    "Ruby",
    "Ruby Gamestone",
    "Runic Sea Crustacean",
    "Sacred Guardian Squid",
    "Sapphyra",
    "Sea Eater",
    "Shark",
    "Shark Bone",
    "Sharp One",
    "Skeleton Narwhal",
    "Strawberry Choc Megalodon",
    "Thin Armor Shark",
    "Totol",
    "Traffic Cone Fish",
    "Udang",
    "Ular kadut",
    "Walrus Bride",
    "Wild Serpent",
    "Worm Fish",
    "Wraithfin Abyssal",
    "Yellow Bloodmoon Whale",
    "Yellow Crystal Crab",
    "Yellow El Maja",
    "Yellow Fish",
    "Yellow Monster Shark",
    "Zombie Megalodon",
    "Zombie Shark"
}

-- Sort daftar ikan secara alfabet
table.sort(secretFishList)

-- Variabel untuk kontrol
local fishingLoop = false
local selectedFish = "Frostborn Shark" -- Default fish
local selectedRarity = "Secret" -- Default rarity
local currentFishOptions = secretFishList -- Untuk menyimpan opsi yang sedang ditampilkan

-- Function utama untuk auto fishing
local function startFishing()
    while fishingLoop and task.wait() do
        -- Cast replication
        local args = {
            vector.create(-329.60302734375, 247.99327087402344, 44.38180160522461),
            vector.create(-1.9528772830963135, 30, 48.160423278808594),
            "Basic Rod",
            94
        }
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CastReplication"):FireServer(unpack(args))

        -- Get multipliers
        local args = {
            10637953878
        }
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("GetAdminMultipliers"):InvokeServer(unpack(args))

        -- Cleanup
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CleanupCast"):FireServer()

        -- Catch success
        game:GetService("ReplicatedStorage"):WaitForChild("FishingCatchSuccess"):FireServer()

        -- Fish giver dengan ikan yang dipilih
        local weight = _G.randomWeight and math.random(_G.minWeight or 770, _G.maxWeight or 999) or 885
        local args = {
            {
                hookPosition = vector.create(-330.8089599609375, 231.04058837890625, 74.08071899414062),
                name = selectedFish,
                weight = weight,
                rarity = selectedRarity,
                metadata = {}
            }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("FishGiver"):FireServer(unpack(args))

        task.wait(_G.fishingDelay or 0.5)
    end
end

-- Buat Tab Utama
local MainTab = Window:CreateTab("Main", 4483362458)

-- Variable untuk menyimpan dropdown
local FishDropdown

-- Fungsi untuk update dropdown
local function updateDropdownOptions(options)
    if FishDropdown then
        FishDropdown:SetOptions(options)
    end
end

-- Dropdown untuk memilih ikan
FishDropdown = MainTab:CreateDropdown({
    Name = "Pilih Ikan Secret",
    Options = secretFishList,
    CurrentOption = {"Frostborn Shark"}, -- Harus dalam format table untuk MultipleOptions=false
    MultipleOptions = false,
    Flag = "FishSelector",
    Callback = function(selected)
        -- selected adalah table karena MultipleOptions=false tapi Rayfield mengembalikan table
        if type(selected) == "table" and #selected > 0 then
            selectedFish = selected[1]
        elseif type(selected) == "string" then
            selectedFish = selected
        end
        
        Rayfield:Notify({
            Title = "Ikan Dipilih",
            Content = "Sekarang memancing: " .. selectedFish,
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Toggle untuk auto fishing
local Toggle = MainTab:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFishing",
    Callback = function(Value)
        fishingLoop = Value
        if fishingLoop then
            task.spawn(startFishing)
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Dimulai! Target: " .. selectedFish,
                Duration = 2.5,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Dihentikan!",
                Duration = 2.5,
                Image = 4483362458
            })
        end
    end
})

-- Slider untuk delay
local Slider = MainTab:CreateSlider({
    Name = "Delay (detik)",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "DelaySlider",
    Callback = function(Value)
        _G.fishingDelay = Value
    end
})

-- Tombol test cast
local TestButton = MainTab:CreateButton({
    Name = "Test Cast Manual",
    Callback = function()
        local args = {
            vector.create(-329.60302734375, 247.99327087402344, 44.38180160522461),
            vector.create(-1.9528772830963135, 30, 48.160423278808594),
            "Basic Rod",
            94
        }
        game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("CastReplication"):FireServer(unpack(args))
        
        Rayfield:Notify({
            Title = "Manual Cast",
            Content = "Cast dilakukan!",
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Buat Tab Daftar Ikan
local FishTab = Window:CreateTab("Daftar Ikan", 4483362458)

-- Search bar untuk mencari ikan
local SearchBox = FishTab:CreateInput({
    Name = "Cari Ikan",
    PlaceholderText = "Ketik nama ikan...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        -- Filter ikan berdasarkan pencarian
        if text and text ~= "" then
            local filtered = {}
            for _, fish in ipairs(secretFishList) do
                if string.lower(fish):find(string.lower(text)) then
                    table.insert(filtered, fish)
                end
            end
            -- Update dropdown dengan hasil filter
            if #filtered > 0 then
                pcall(function()
                    FishDropdown:SetOptions(filtered)
                end)
                currentFishOptions = filtered
            else
                -- Jika tidak ada hasil, tampilkan pesan
                Rayfield:Notify({
                    Title = "Pencarian",
                    Content = "Ikan '" .. text .. "' tidak ditemukan",
                    Duration = 2,
                    Image = 4483362458
                })
            end
        else
            -- Kembalikan ke semua opsi jika pencarian kosong
            pcall(function()
                FishDropdown:SetOptions(secretFishList)
            end)
            currentFishOptions = secretFishList
        end
    end
})

-- Tombol reset pencarian
local ResetButton = FishTab:CreateButton({
    Name = "Reset Pencarian",
    Callback = function()
        pcall(function()
            FishDropdown:SetOptions(secretFishList)
        end)
        currentFishOptions = secretFishList
        Rayfield:Notify({
            Title = "Pencarian Direset",
            Content = "Menampilkan semua ikan",
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Tampilkan jumlah total ikan
FishTab:CreateLabel("Total Ikan Secret: " .. #secretFishList)

-- Buat section untuk statistik
FishTab:CreateParagraph({
    Title = "Statistik Ikan",
    Content = string.format("Total Ikan: %d\nIkan Langka: Semua Secret", #secretFishList)
})

-- Buat Tab Settings
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateLabel("Pengaturan Weight")

-- Toggle untuk random weight
local RandomWeightToggle = SettingsTab:CreateToggle({
    Name = "Random Weight",
    CurrentValue = true,
    Flag = "RandomWeight",
    Callback = function(Value)
        _G.randomWeight = Value
    end
})

-- Input untuk weight min
local MinWeightInput = SettingsTab:CreateInput({
    Name = "Weight Minimum",
    PlaceholderText = "770",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        local num = tonumber(text)
        if num then
            _G.minWeight = num
        else
            _G.minWeight = 770
        end
    end
})

-- Input untuk weight max
local MaxWeightInput = SettingsTab:CreateInput({
    Name = "Weight Maximum",
    PlaceholderText = "999",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        local num = tonumber(text)
        if num then
            _G.maxWeight = num
        else
            _G.maxWeight = 999
        end
    end
})

SettingsTab:CreateLabel("Pengaturan Umum")

-- Toggle untuk notifikasi
local NotifToggle = SettingsTab:CreateToggle({
    Name = "Notifikasi",
    CurrentValue = true,
    Flag = "Notifikasi",
    Callback = function(Value)
        _G.notifications = Value
    end
})

-- Keybind untuk toggle cepat
local Keybind = Rayfield:CreateKeybind({
    Name = "Toggle Auto Fishing",
    CurrentKeybind = "F",
    HoldToInteract = false,
    Flag = "ToggleKeybind",
    Callback = function()
        if Toggle then
            Toggle:SetValue(not fishingLoop)
        end
    end
})

-- Notifikasi siap
Rayfield:Notify({
    Title = "Script Loaded",
    Content = string.format("%d ikan Secret tersedia! Tekan F untuk toggle", #secretFishList),
    Duration = 3,
    Image = 4483362458
})

-- Informasi tambahan di console
print("=== Fishing Script Loaded ===")
print("Total Ikan Secret: " .. #secretFishList)
print("Gunakan F untuk toggle auto fishing")
print("==============================")