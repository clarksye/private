repeat wait() until game:IsLoaded()

if getgenv().kaitun and getgenv().kaitun.loaded then return end

local TaskManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/TaskManagerV3.luau"))()

local manager = TaskManager.new()
manager:register(true, "BalancerPlant", "high")
manager:register(false, "GivePollinateFruit", 80)
manager:register(false, "GiveSummerFruit", 80)
manager:register(false, "AutoPlaceEgg", 75)
manager:register(false, "DestroyPlant", 74)
manager:register(false, "PlaceSprinkler", 73)
manager:register(false, "AutoPlanting", 72)
manager:register(false, "OpenSeedPack", 71)
manager:register(false, "FeedPet", 69)
manager:register(false, "AutoSelling", 68)
manager:register(false, "AutoHarvesting", 65)

------------------------ ANTI AFK -------------------------------
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
------------------------ END ANTI AFK ---------------------------


------------------------ VARIABLES ------------------------------
local Player = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local Humanoid = Player.Character:WaitForChild("Humanoid")
-- local HttpService = game:GetService("HttpService")
-- local TeleportService = game:GetService("TeleportService")
-- local UserInputService = game:GetService("UserInputService")

-- Modules
local PetInfo = require(game:GetService("ReplicatedStorage"):WaitForChild("Data"):WaitForChild("PetRegistry"):WaitForChild("PetList"))

local config = getgenv().Config
local cachedPlayerData = nil
local IS_LOADED = false

local settings = {
    ["game"] = {
        ["npcs"] = {
            Eloise = Workspace.NPCS:FindFirstChild("Eloise") and Workspace.NPCS.Eloise:FindFirstChild("HumanoidRootPart") and Workspace.NPCS.Eloise.HumanoidRootPart.Position or nil,
            Raphael = Workspace.NPCS:FindFirstChild("Raphael") and Workspace.NPCS.Raphael:FindFirstChild("HumanoidRootPart") and Workspace.NPCS.Raphael.HumanoidRootPart.Position or nil,
            Sam = Workspace.NPCS:FindFirstChild("Sam") and Workspace.NPCS.Sam:FindFirstChild("HumanoidRootPart") and Workspace.NPCS.Sam.HumanoidRootPart.Position or nil,
            Steven = Workspace.NPCS:FindFirstChild("Steven") and Workspace.NPCS.Steven:FindFirstChild("HumanoidRootPart") and Workspace.NPCS.Steven.HumanoidRootPart.Position or nil,
        },
        ["seeds"] = {
            ["normal"] = {
                "Carrot", "Strawberry",
                "Blueberry", "Orange Tulip",
                "Tomato", "Corn", "Cauliflower",
                "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Green Apple", "Avocado", "Banana",
                "Coconut", "Cactus", "Dragon Fruit", "Mango", "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear",
                "Grape", "Mushroom", "Pepper", "Cacao", "Loquat", "Feijoa",
                "Beanstalk", "Ember Lily", "Sugar Apple"
            },
            ["event"] = {
                "Flower Seed Pack", "Nectarine", "Hive Fruit", "Lavender", "Nectarshade"
            }
        },
        ["tools"] = {
            ["normal"] = {
                "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Tanning Mirror", "Lightning Rod", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Favorite Tool", "Harvest Tool", "Friendship Pot"
            },
            ["event"] = {
                "Honey Sprinkler", "Pollen Radar", "Nectar Staff"
            }
        },
        ["eggs"] = {
            ["normal"] = {
                "Common Egg", "Common Summer Egg", "Uncommon Egg", "Rare Egg", "Rare Summer Egg", "Legendary Egg", "Mythical Egg", "Paradise Egg", "Bug Egg"
            },
            ["event"] = {
                "Bee Egg"
            }
        },
        ["cosmetic"] = {
            ["normal"] = {},
            ["event"] = {
                "Honey Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway"
            }
        },
        ["mutations"] = {
            "Gold", "Rainbow", "Shocked", "Wet", "Frozen"
        },
        ["event"] = {
            ["summer"] = {
                "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Cauliflower", "Watermelon", "Green Apple", "Avocado", "Banana", "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear", "Loquat", "Feijoa", "Sugar Apple"
            }
        }
    },
    ["player"] = {
        ["Data"] = {},
        ["Sheckles"] = nil,
        ["Farm"] = nil,
        ["Place Egg"] = {},
        ["Favorite Fruit"] = {},
        ["Trigger"] = {
            isBuySeeds = false,
            isBuyTools = false,
            isBuyEggs = false
        },
        ["Set"] = {
            ["Textures"] = false,
            ["Audio"] = false,
            ["VisualEffects"] = false
        },
        isSelling = false
    }
}

------------------------ END VARIABLES --------------------------


-------------------------- START FUNCTION -----------------------
local function teleport(position)
    local Char = Player.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local adjustedPos = position + Vector3.new(0, 0.5, 0)
        Char.HumanoidRootPart.CFrame = CFrame.new(adjustedPos)
    end
end

local function getFarm()
    for _, farm in ipairs(workspace:WaitForChild("Farm"):GetChildren()) do
        local success, owner = pcall(function()
            return farm:WaitForChild("Important").Data.Owner.Value
        end)
        if success and owner == Player.Name then
            return farm
        end
    end
    return nil
end

local function collectInventory()
    local all = {}
    for _, container in ipairs({Player.Backpack, Player.Character}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(all, tool)
                end
            end
        end
    end
    return all
end

local function getItemById(id)
    for _, container in ipairs({Player.Backpack, Player.Character}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    for key, value in pairs(tool:GetAttributes()) do
                        if value == id then
                            return tool
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function searchInventorySeed(item)
    local pattern = "%[x%d+%]$"
    local itemName = item:lower()
    for _, tool in ipairs(collectInventory()) do
        local name = tool.Name:lower()
        if name:find("^" .. itemName) and name:find(pattern) then
            return tool
        end
    end
end

local function removeFirstPlantByName(fruitName)
    local farm = getFarm()

    local plants = farm:WaitForChild("Important"):FindFirstChild("Plants_Physical")
    if plants then
        for _, plant in ipairs(plants:GetChildren()) do
            if plant.Name == fruitName then
                local fruitPart = plant:FindFirstChildWhichIsA("BasePart")
                if fruitPart then
                    game.ReplicatedStorage.GameEvents.Remove_Item:FireServer(fruitPart)
                    return true
                end
            end
        end
    end
    return false
end

local function removeExtraPlants(fruitName, maxAmount)
    local fruits = {}

    local farm = getFarm()
    for _, fruit in ipairs(farm.Important.Plants_Physical:GetChildren()) do
        if fruit.Name == fruitName then
            local weight = fruit:FindFirstChild("Weight")
            if weight then
                table.insert(fruits, {instance = fruit, weight = weight.Value})
            end
        end
    end

    if #fruits > maxAmount then
        table.sort(fruits, function(a, b) return a.weight < b.weight end)
        for i = 1, #fruits - maxAmount do
            local fruit = fruits[i].instance
            local part = fruit:FindFirstChildWhichIsA("BasePart")
            if part then
                game.ReplicatedStorage.GameEvents.Remove_Item:FireServer(part)
                task.wait()
            end
        end
    end
end

local function getPlantsCount()
    local counts = {}

    local farm = getFarm()
    local plants = farm:WaitForChild("Important"):FindFirstChild("Plants_Physical")
	for _, plant in ipairs(plants:GetChildren()) do
		local name = plant.Name
		counts[name] = (counts[name] or 0) + 1
	end

    return counts
end

local function isHungry(hunger, petType, hungerThreshold)
    hungerThreshold = hungerThreshold or 0.50 -- default 25% (0.25)
    
    local maxHunger = PetInfo[petType].DefaultHunger

    if not hunger or not maxHunger then
        return false -- data tidak valid
    end

    return (hunger / maxHunger) < hungerThreshold
end

local function isPetEquipped(tbl, uuid)
    for _, v in pairs(tbl) do
        if v == uuid then
            return true
        end
    end
    return false
end

local function rarityAllowed(rarityList, rarity)
    for _, r in ipairs(rarityList) do
        for k,v in pairs(r) do
            if k == rarity and v == true then return true end
        end
    end
    return false
end

local function petNameInList(petNameList, petName)
    for _, v in ipairs(petNameList or {}) do
        if v == petName then return true end
    end
    return false
end

local function filterByConfig(category, subcategory)
    local list = settings.game[category]
    local configKey = "Buy " .. category:sub(1,1):upper() .. category:sub(2)
    local configItems = config[configKey] and config[configKey].Item
    if not configItems or type(list) ~= "table" then return end

    local newList = {}
    for _, item in ipairs(list[subcategory]) do
        if configItems[item] then
            newList[#newList+1] = item
        end
    end
    list[subcategory] = newList
end

-- Fungsi khusus untuk memfilter semua item event dari setiap kategori
local function filterEventItems()
    local eventConfig = config["Buy Events"] and config["Buy Events"]["Item"]
    if not eventConfig then return end  -- Jika tidak ada config item event, keluar

    for category, data in pairs(settings.game) do
        -- Cek apakah kategori memiliki subkategori "event" dan isinya tabel
        if type(data) == "table" and type(data["event"]) == "table" then
            local newList = {}
            for _, item in ipairs(data["event"]) do
                if eventConfig[item] == true then  -- Cek apakah item ini diaktifkan di config
                    table.insert(newList, item)  -- Masukkan ke list baru
                end
            end
            settings.game[category]["event"] = newList  -- Gantikan list event lama dengan hasil filter
        end
    end
end

local function ApplyLowGraphicsMode()
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    local Player = Players.LocalPlayer

    -- Fungsi cari farm milik kita
    local function getMyFarm()
        for _, farm in ipairs(Workspace:WaitForChild("Farm"):GetChildren()) do
            local success, owner = pcall(function()
                return farm:WaitForChild("Important").Data.Owner.Value
            end)
            if success and owner == Player.Name then
                return farm
            end
        end
        return nil
    end

    -- Destroy semua farm yang bukan milik kita
    local function destroyOtherFarms()
        local myFarm = getMyFarm()
        for _, farm in ipairs(Workspace:WaitForChild("Farm"):GetChildren()) do
            if farm ~= myFarm then
                farm:Destroy()
            end
        end
    end

    -- Optimasi Lighting
    pcall(function()
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
    end)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    Lighting.ClockTime = 14
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end

    -- Optimasi Terrain
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
    end

    -- Optimasi seluruh object
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceGui") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj:Destroy()
        elseif obj:IsA("Sound") then
            obj.Volume = 0
        end
    end

    -- Hapus pakaian dan aksesoris pemain
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            for _, item in ipairs(p.Character:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("CharacterMesh") then
                    item:Destroy()
                end
            end
        end
    end

    -- Kamera
    local cam = Workspace:FindFirstChildOfClass("Camera")
    if cam then
        cam.FieldOfView = 50
    end

    -- Rendering settings
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level02
        settings().Rendering.EagerBulkExecution = false
        game:GetService("UserSettings"):GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)

    -- GUI Cleanup
    local playerGui = Player:WaitForChild("PlayerGui")
    for _, gui in ipairs(playerGui:GetChildren()) do
        if not gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end

    -- -- Cleanup objek baru (tanpa listener pada workspace)
    -- Workspace.DescendantAdded:Connect(function(obj)
    --     if obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceGui") then
    --         obj:Destroy()
    --     elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Trail") then
    --         obj:Destroy()
    --     elseif obj:IsA("Sound") then
    --         obj.Volume = 0
    --     elseif obj:IsA("BasePart") then
    --         obj.Material = Enum.Material.SmoothPlastic
    --         obj.Reflectance = 0
    --         obj.CastShadow = false
    --     end
    -- end)

    -- Optimasi untuk player baru yang join
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(char)
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("CharacterMesh") then
                    item:Destroy()
                end
            end
        end)

        -- Coba destroy farm milik player baru setelah delay
        task.delay(2, function()
            for _, farm in ipairs(Workspace:WaitForChild("Farm"):GetChildren()) do
                local success, owner = pcall(function()
                    return farm:WaitForChild("Important").Data.Owner.Value
                end)
                if success and owner ~= Player.Name then
                    farm:Destroy()
                end
            end
        end)
    end)

    -- Inisialisasi awal: destroy farm milik orang lain
    task.spawn(destroyOtherFarms)
end

local function optimizeMyFarm()
    local farm = settings["player"]["Farm"]

    -- Terapkan pada semua anak sekarang
    for _, obj in ipairs(farm:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = false
            obj.CastShadow = false
            obj.Reflectance = 0
            obj.Material = Enum.Material.SmoothPlastic
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj:Destroy()
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceGui") then
            obj:Destroy()
        elseif obj:IsA("Sound") then
            obj.Volume = 0
        end
    end

    -- Dengarkan semua objek baru di farm
    farm.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if obj:IsA("BasePart") then
                obj.CanCollide = false
                obj.CastShadow = false
                obj.Reflectance = 0
                obj.Material = Enum.Material.SmoothPlastic
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceGui") then
                obj:Destroy()
            elseif obj:IsA("Sound") then
                obj.Volume = 0
            end
        end)
    end)
end
-------------------------- END FUNCTION -------------------------


-------------------------- START INIT ---------------------------
getgenv().kaitun = {loaded = true}

task.delay(5, function()
    ApplyLowGraphicsMode()
    optimizeMyFarm()
    IS_LOADED = true
end)

task.spawn(function()
    while task.wait(1) do
        settings['player']["Sheckles"] = Player:WaitForChild("leaderstats").Sheckles.Value
        settings["player"]["Farm"] = getFarm()
    end
end)

-- Jalankan untuk kategori yang kamu ingin bersihkan berdasarkan config
filterByConfig("seeds", "normal")
filterByConfig("eggs", "normal")
filterByConfig("tools", "normal")
filterEventItems()

repeat
    task.wait()
until(typeof(settings["player"]["Farm"]) == "Instance" and settings["player"]["Farm"].GetDescendants)

repeat
    task.wait()
until(typeof(settings["player"]["Sheckles"]) == "number")

for set, is in pairs(settings["player"]["Set"]) do
    if not is then
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SettingsService"):FireServer("SetSetting", set, false)
        task.wait(0.05)
    end
end

for _, obj in ipairs(settings["player"]["Farm"]:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.CanCollide = false
    end
end

local base = settings["player"]["Farm"]:WaitForChild("Important").Plant_Locations.Can_Plant.Position
local points = {}

-- Baris pertama: 5 titik di z - 15
for i = -2, 2 do
    table.insert(points, {
        Used = false,
        Position = Vector3.new(base.X + (i * 4), base.Y, base.Z - 15)
    })
end

-- Baris kedua: 3 titik di z - 19
for i = -1, 1 do
    table.insert(points, {
        Used = false,
        Position = Vector3.new(base.X + (i * 4), base.Y, base.Z - 19)
    })
end

settings.player["Place Egg"] = points

-- Hook GetData
task.spawn(function()
    local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
    if typeof(DataService.GetData) == "function" then
        local oldGetData = DataService.GetData

        DataService.GetData = function(self, ...)
            local data = oldGetData(self, ...)
            cachedPlayerData = data
            return data
        end
    else
        warn("DataService.GetData bukan fungsi atau belum tersedia.")
    end
end)

-- Auto Buy Seeds
task.spawn(function()
    while task.wait(1) do
        local success, err = pcall(function()
            if not IS_LOADED then return end
            if not settings["player"]["Trigger"].isBuySeeds then return end

            local data = cachedPlayerData
            if not data or not data.SeedStock or not data.SeedStock.Stocks then return end

            local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):FindFirstChild("BuySeedStock")

            for _, itemName in ipairs(settings.game.seeds.normal) do
                local stockData = data.SeedStock.Stocks[itemName]
                if stockData and stockData.Stock > 0 then
                    for _ = 1, stockData.Stock do
                        remote:FireServer(itemName)
                        task.wait()
                    end
                end
            end
        end)
        if not success then
            warn("[Task Error: Auto Buy Seeds]", err)
        end
    end
end)

-- Auto Buy Tools
task.spawn(function()
    while task.wait(5) do
        local success, err = pcall(function()
            if not IS_LOADED then return end
            if not settings["player"]["Trigger"].isBuyTools then return end

            local data = cachedPlayerData
            if not data or not data.GearStock or not data.GearStock.Stocks then return end

            local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):FindFirstChild("BuyGearStock")

            for _, itemName in ipairs(settings.game.tools.normal) do
                local stockData = data.GearStock.Stocks[itemName]
                if stockData and stockData.Stock > 0 then
                    for _ = 1, stockData.Stock do
                        remote:FireServer(itemName)
                        task.wait()
                    end
                end
            end
        end)
        if not success then
            warn("[Task Error: Auto Buy Tools]", err)
        end
    end
end)

-- Auto Buy Eggs
task.spawn(function()
    while task.wait(5) do
        local success, err = pcall(function()
            if not IS_LOADED then return end
            if not settings["player"]["Trigger"].isBuyEggs then return end

            local data = cachedPlayerData
            if not data or not data.PetEggStock or not data.PetEggStock.Stocks then return end

            local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")

            for index, eggData in pairs(data.PetEggStock.Stocks) do
                if eggData and eggData.Stock > 0 then
                    for _, name in ipairs(settings.game.eggs.normal) do
                        if eggData.EggName == name then
                            remote:FireServer(index)
                            break
                        end
                    end
                end
            end
        end)
        if not success then
            warn("[Task Error: Auto Buy Eggs]", err)
        end
    end
end)

-- Auto Buy Event
task.spawn(function()
    while task.wait(5) do
        local success, err = pcall(function()
            if not IS_LOADED then return end
            if not config["Buy Events"]["Enabled"] then return end

            local data = cachedPlayerData
            if not data or not data.EventShopStock or not data.EventShopStock.Stocks then return end

            local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):FindFirstChild("BuyEventShopStock")

            local items = {}
            for _, v in ipairs(settings.game.seeds.event) do table.insert(items, v) end
            for _, v in ipairs(settings.game.tools.event) do table.insert(items, v) end
            for _, v in ipairs(settings.game.eggs.event) do table.insert(items, v) end
            for _, v in ipairs(settings.game.cosmetic.event) do table.insert(items, v) end

            for _, itemName in ipairs(items) do
                local stockData = data.EventShopStock.Stocks[itemName]
                if stockData and stockData.Stock > 0 then
                    for _ = 1, stockData.Stock do
                        remote:FireServer(itemName)
                        task.wait()
                    end
                end
            end
        end)
        if not success then
            warn("[Task Error: Auto Buy Event]", err)
        end
    end
end)

-- Auto Hatch Eggs
task.spawn(function()
    while task.wait(5) and config["Misc"]["Hatch Egg"] do
        local success, err = pcall(function()
            if not IS_LOADED then return end

            local farm = settings["player"]["Farm"]
            if not farm then return end

            for _, egg in ipairs(farm:WaitForChild("Important").Objects_Physical:GetChildren()) do
                if egg.Name ~= "PetEgg" then continue end
                local time = egg:GetAttribute("TimeToHatch")
                if time == 0 then
                    local args = {"HatchPet", egg}
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("PetEggService"):FireServer(unpack(args))
                end
            end
        end)
        if not success then
            warn("[Task Error: Auto Hatch Eggs]", err)
        end
    end
end)

-- Watch Sheckles
task.spawn(function()
    while task.wait(5) do 
        local success, err = pcall(function()
            if not IS_LOADED then return end

            local sheckles = settings["player"]["Sheckles"]
            local dontBuyThreshold = config["Dont Buy Seed"]["If Money More Than"]

            -- Matikan seed tertentu jika uang > batas
            if sheckles > dontBuyThreshold then
                for name, _ in pairs(config["Buy Seeds"]["Item"]) do
                    for _, dont in ipairs(config["Dont Buy Seed"]["Seed Name"]) do
                        if name == dont then
                            config["Buy Seeds"]["Item"][name] = false
                        end
                    end
                end
            else
                -- Aktifkan kembali seed yang sebelumnya dinonaktifkan
                for name, _ in pairs(config["Buy Seeds"]["Item"]) do
                    for _, dont in ipairs(config["Dont Buy Seed"]["Seed Name"]) do
                        if name == dont then
                            config["Buy Seeds"]["Item"][name] = true
                        end
                    end
                end
            end

            filterByConfig("seeds", "normal")

            -- Buy Seeds
            if sheckles > config["Buy Seeds"]["Threshold"] then
                settings["player"]["Trigger"].isBuySeeds = config["Buy Seeds"]["Enabled"]
            else
                settings["player"]["Trigger"].isBuySeeds = false
            end

            -- Buy Tools
            if sheckles > config["Buy Tools"]["Threshold"] then
                settings["player"]["Trigger"].isBuyTools = config["Buy Tools"]["Enabled"]
            else
                settings["player"]["Trigger"].isBuyTools = false
            end

            -- Buy Eggs
            if sheckles > config["Buy Eggs"]["Threshold"] then
                settings["player"]["Trigger"].isBuyEggs = config["Buy Eggs"]["Enabled"]
            else
                settings["player"]["Trigger"].isBuyEggs = false
            end
        end)
        if not success then
            warn("[Task Error: Watch Sheckles]", err)
        end
    end
end)

-- Check Inventory
task.spawn(function()
    while task.wait(1) do
        local success, err = pcall(function()
            if not IS_LOADED then return end
            if not cachedPlayerData or not cachedPlayerData.InventoryData then return end

            local farm = settings["player"]["Farm"]

            local inventories = cachedPlayerData.InventoryData
            settings["player"]["Data"].pollinated = {}
            settings["player"]["Data"].seeds = {}
            settings["player"]["Data"].fruits = {}
            settings["player"]["Data"].eggs = {}
            settings["player"]["Data"].seedPack = {}
            settings["player"]["Data"].sprinklers = {}
            settings["player"]["Data"].summerFruit = {}

            if #settings.player["Favorite Fruit"] > 200 then
                table.remove(settings.player["Favorite Fruit"], 1)
            end

            local plantsCount = getPlantsCount()

            for uuid, item in pairs(inventories) do
                local itemType = item.ItemType
                local itemData = item.ItemData
                local tool = getItemById(uuid)

                if itemType == "Seed" then
                    local itemName = itemData.ItemName

                    if not (config["Dont Plant Inventory Seed"]["Enabled"] and table.find(config["Dont Plant Inventory Seed"]["Seed Name"], itemName)) then
                        local max = config["Max Plant"]
                        local count = plantsCount[itemName]
                        local limit = max[itemName]

                        if not count or not limit or count < limit then
                            table.insert(settings["player"]["Data"].seeds, {name = itemName, tool = tool})
                        end
                    end


                elseif itemType == "Holdable" then
                    local itemName = itemData.ItemName
                    local isFavorite = itemData.IsFavorite
                    local isPollinated = tool:GetAttribute("Pollinated")
                    tool:SetAttribute("isFavorite", isFavorite)

                    if farm:WaitForChild("Important").Plants_Physical:FindFirstChild(itemName) then
                        if workspace:GetAttribute("SummerHarvest") and table.find(settings["game"]["event"]["summer"], itemName) then
                            table.insert(settings["player"]["Data"].summerFruit, {name = itemName, tool = tool})
                        else
                            table.insert(settings["player"]["Data"].fruits, tool)
                        end
                    end

                    if isPollinated then
                        if not isFavorite then
                            if not table.find(settings.player["Favorite Fruit"], uuid) then
                                table.insert(settings.player["Favorite Fruit"], uuid)
                                game.ReplicatedStorage.GameEvents.Favorite_Item:FireServer(tool)
                                task.wait(0.05)
                            end
                        end

                        table.insert(settings["player"]["Data"].pollinated, tool)
                    end

                elseif itemType == "PetEgg" then
                    table.insert(settings["player"]["Data"].eggs, tool)

                elseif itemType == "Seed Pack" then
                    table.insert(settings["player"]["Data"].seedPack, tool)

                elseif itemType == "Sprinkler" then
                    local itemName = itemData.ItemName
                    table.insert(settings["player"]["Data"].sprinklers, {name = itemName, tool = tool})
                end
            end

            if #settings["player"]["Data"].pollinated > 0 then
                local data = cachedPlayerData

                if data.HoneyMachine.TimeLeft == 0 then
                    manager:normal("GivePollinateFruit", function(cachedPlayerData)
                        local data = cachedPlayerData
                        if not data or not data.HoneyMachine then return end

                        for _, tool in ipairs(settings["player"]["Data"].pollinated) do
                            if data.HoneyMachine.TimeLeft ~= 0 then return end
                            
                            game.ReplicatedStorage.GameEvents.Favorite_Item:FireServer(tool)
                            task.wait(0.05)

                            local currentTool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                            if currentTool ~= tool then
                                Player.Character.Humanoid:EquipTool(tool)
                                task.wait(0.5)
                            end

                            -- Submit fruit
                            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE"):FireServer("MachineInteract")
                            task.wait(0.3)
                            
                        end
                    end, {cachedPlayerData}, function() return true end)
                end
            end

            if #settings["player"]["Data"].summerFruit > 0 then
                local summerFruits = settings["player"]["Data"].summerFruit
                settings["player"]["Data"].summerFruit = {} -- kosongkan langsung setelah referensi diambil

                manager:normal("GiveSummerFruit", function(summerFruits)
                    for i = #summerFruits, 1, -1 do
                        local fruit = summerFruits[i]
                        Player.Character.Humanoid:EquipTool(fruit.tool)
                        task.wait(0.5)
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SummerHarvestRemoteEvent"):FireServer("SubmitHeldPlant")
                        task.wait(0.05)
                    end
                end, {summerFruits}, function() return true end)
            end

            if #settings["player"]["Data"].seeds > 0 and config["Misc"]["Plant Seed"] then
                local plants = farm:WaitForChild("Important").Objects_Physical:GetChildren()
                if #plants < 800 then
                    manager:normal("AutoPlanting", function()
                        -- Teleport to CenterPoint
                        teleport(farm.Center_Point.Position)
                        task.wait(1)

                        for _, seed in ipairs(settings["player"]["Data"].seeds) do
                            local currentTool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                            if currentTool ~= seed.tool then
                                Player.Character.Humanoid:EquipTool(seed.tool)
                                task.wait(2)
                            end

                            for i = 1, seed.tool:GetAttribute("Quantity") do
                                local pos = farm:WaitForChild("Important").Plant_Locations.Can_Plant.Position

                                local offsetX = math.random(-2000, 2000) / 1000  -- -2.000 s/d 2.000 (presisi 0.001)
                                local offsetZ = math.random(-2000, 2000) / 1000

                                local args = {
                                    [1] = Vector3.new(pos.X + offsetX, pos.Y, pos.Z + offsetZ),
                                    [2] = seed.name
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(unpack(args))
                                task.wait(0.2)
                            end
                        end
                    end, {}, function() return true end)
                end
            end

            if #settings["player"]["Data"].fruits > 100 then
                settings.player.isSelling = true

                manager:normal("AutoSelling", function(settings)
                    -- Teleport to Shop
                    teleport(settings.game.npcs.Steven)
                    task.wait(1)

                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
                    task.wait(1)

                    settings.player.isSelling = false
                end, {settings}, function() return true end)
            end

            if #settings["player"]["Data"].eggs > 0 then
                local eggPlaced = 0

                -- Reset semua lokasi jadi tidak digunakan
                for _, entry in ipairs(settings.player["Place Egg"]) do
                    entry.Used = false
                end

                -- Hitung jumlah egg yang sudah ditempatkan
                for _, egg in ipairs(farm:WaitForChild("Important").Objects_Physical:GetChildren()) do
                    if egg.Name == "PetEgg" then
                        eggPlaced = eggPlaced + 1

                        -- Tandai titik Place Egg sebagai Used jika posisi mirip
                        local pos = egg.PetEgg.Position
                        for _, entry in ipairs(settings.player["Place Egg"]) do
                            if not entry.Used then
                                local diffX = math.abs(entry.Position.X - pos.X)
                                local diffZ = math.abs(entry.Position.Z - pos.Z)
                                if diffX <= 1 and diffZ <= 1 then
                                    entry.Used = true
                                    break
                                end
                            end
                        end
                    end
                end

                -- Validasi data dan max egg
                local data = cachedPlayerData

                local maxEggs = data.PetsData.MutableStats.MaxEggsInFarm
                if eggPlaced < maxEggs then
                    -- Jalankan penempatan egg
                    manager:normal("AutoPlaceEgg", function()
                        for _, egg in ipairs(settings["player"]["Data"].eggs) do
                            local currentTool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                            if currentTool ~= egg then
                                Player.Character.Humanoid:EquipTool(egg)
                                task.wait(2)
                            end

                            for i = 1, egg:GetAttribute("LocalUses") do
                                -- Cari posisi yang belum digunakan
                                local targetPos = nil
                                for _, entry in ipairs(settings.player["Place Egg"]) do
                                    if not entry.Used then
                                        targetPos = entry
                                        break
                                    end
                                end

                                if not targetPos then return end

                                -- FireServer untuk letakkan egg
                                local args = {
                                    [1] = "CreateEgg",
                                    [2] = targetPos.Position
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("PetEggService"):FireServer(unpack(args))

                                -- Tandai sebagai digunakan
                                targetPos.Used = true

                                eggPlaced = eggPlaced + 1
                                task.wait(1)

                                if eggPlaced >= maxEggs then return end
                            end
                        end
                    end, {}, function() return true end)
                end
            end

            if #settings["player"]["Data"].seedPack > 0 and config["Misc"]["Open Seed Pack"] then
                manager:normal("OpenSeedPack", function()
                    for _, pack in ipairs(settings["player"]["Data"].seedPack) do
                        local currentTool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                        if currentTool ~= pack then
                            Player.Character.Humanoid:EquipTool(pack)
                            task.wait(2)
                        end

                        for i = 1, pack:GetAttribute("Uses") do
                            pack:Activate()
                            task.wait(1)
                        end
                    end
                end, {}, function() return true end)
            end

            if #settings["player"]["Data"].sprinklers > 0 and config["Use Sprinklers"]["Enabled"] then
                local point = farm:WaitForChild("Important").Plant_Locations.Can_Plant
                local uses = {}
                local planted = {} -- sprinkler yang sudah tertanam di field

                -- Cek sprinkler yang sudah tertanam
                for _, obj in ipairs(farm:WaitForChild("Important").Objects_Physical:GetChildren()) do
                    if config["Use Sprinklers"]["Sprinkler"][obj.Name] and obj:FindFirstChild("Root") then
                        local dist = (obj.Root.Position - point.Position).Magnitude
                        if dist <= 2 then
                            planted[obj.Name] = true
                        end
                    end
                end

                -- Ambil sprinkler dari inventory yang belum tertanam
                for _, sprinkler in ipairs(settings["player"]["Data"].sprinklers) do
                    local name = sprinkler.name
                    if config["Use Sprinklers"]["Sprinkler"][name] and not planted[name] then
                        uses[name] = sprinkler
                    end
                end

                -- Cek apakah mode stack aktif
                local stack = config["Use Sprinklers"]["Stack"]
                local requireStack = false
                local allStackReady = true

                for name, state in pairs(stack) do
                    if state then
                        requireStack = true
                        if not (uses[name] or planted[name]) then
                            allStackReady = false
                            break
                        end
                    end
                end

                if not requireStack or allStackReady then
                    manager:normal("PlaceSprinkler", function(config)
                        for name, toolData in pairs(uses) do
                            if config["Use Sprinklers"]["Sprinkler"][name] then
                                local currentTool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                                if currentTool ~= toolData.tool then
                                    Player.Character.Humanoid:EquipTool(toolData.tool)
                                    task.wait(2)
                                end

                                local cf = point.CFrame * CFrame.new(0, 0.5, 0)
                                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SprinklerService"):FireServer("Create", cf)
                                task.wait(1)
                            end
                        end
                    end, {config}, function() return true end)
                end
            end
        end)
        if not success then
            warn("[Task Error: Check Inventory]", err)
        end
    end
end)


-------------------------- END INIT -----------------------------


-------------------------- MAIN ---------------------------------

-- Auto Harvesting
task.spawn(function()
    while task.wait(1) do
        local success, err = pcall(function()
            if not IS_LOADED then return end

            local skip = false
            if config["Dont Collect On Weather"]["Enabled"] then
                local workspaceAttr = workspace:GetAttributes()
                for weather, active in pairs(config["Dont Collect On Weather"]["Weather"]) do
                    if workspaceAttr[weather] and active then
                        skip = true
                        break
                    end
                end
            end

            if skip then return end

            local isHarvesting = false

            local farm = settings["player"]["Farm"]

            for _, plant in ipairs(farm:WaitForChild("Important").Plants_Physical:GetChildren()) do
                if isHarvesting then break end
                
                for _, descendant in ipairs(plant:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                        isHarvesting = true
                        break
                    end
                end
            end

            if isHarvesting then
                manager:normal("AutoHarvesting", function(settings)
                    for _, plant in ipairs(settings["player"]["Farm"]:WaitForChild("Important").Plants_Physical:GetChildren()) do
                        for _, descendant in ipairs(plant:GetDescendants()) do
                            if settings.player.isSelling then return end

                            if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                                local part = descendant.Parent
                                if part and part:IsA("BasePart") then
                                    teleport(part.Position)
                                    task.wait(0.05)
                                    fireproximityprompt(descendant)
                                    task.wait()
                                end
                            end
                        end
                    end

                    settings.player.isSelling = true
                end, {settings}, function() return true end)
            end
        end)
        if not success then
            warn("[Task Error: Auto Harvesting]", err)
        end
    end
end)

-- Auto Selling
task.spawn(function()
    while task.wait(1) do
        local success, err = pcall(function()
            if not IS_LOADED then return end
            if not settings.player.isSelling then return end

            manager:normal("AutoSelling", function(settings)
                -- Teleport to Shop
                teleport(settings.game.npcs.Steven)
                task.wait(0.5)

                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
                task.wait(2)

                settings.player.isSelling = false
            end, {settings}, function() return true end)
        end)
        if not success then
            warn("[Task Error: Auto Selling]", err)
        end
    end
end)

-- Auto Remove Plants
task.spawn(function()
    while task.wait(5) and config["Delete Planted Seed"]["Enabled"] do
        local success, err = pcall(function()
            if not IS_LOADED then return end

            local farm = settings["player"]["Farm"]
            local plants = farm and farm:WaitForChild("Important").Plants_Physical:GetChildren() or {}

            local isPlanted = false

            for _, name in ipairs(config["Delete Planted Seed"]["Name Seed Delete"]) do
                if farm:WaitForChild("Important").Plants_Physical:FindFirstChild(name) then
                    isPlanted = true
                    break
                end
            end

            if isPlanted then
                local shekles = settings["player"]["Sheckles"]
                local selectedSlot = nil
                local maxMin = -math.huge

                for _, slot in ipairs(config["Delete Planted Seed"]["Slot"]) do
                    if shekles >= slot.min and slot.min > maxMin then
                        selectedSlot = slot.slot
                        maxMin = slot.min
                    end
                end

                local overCount = #plants - selectedSlot

                if overCount > 0 then
                    manager:normal("DestroyPlant", function(overCount)
                        local shovel = Player.Backpack:FindFirstChild("Shovel [Destroy Plants]") or Player.Character:FindFirstChild("Shovel [Destroy Plants]")
                        if shovel then Player.Character.Humanoid:EquipTool(shovel) task.wait(1) end

                        for _, name in ipairs(config["Delete Planted Seed"]["Name Seed Delete"]) do
                            if overCount < 1 then break end
                            for i = 1, overCount do 
                                local isDeleted = removeFirstPlantByName(name)
                                if not isDeleted then break end
                                task.wait(0.1)
                                overCount = overCount - 1
                            end
                        end
                    end, {overCount}, function() return true end)
                end
            end
        end)
        if not success then
            warn("[Task Error: Auto Remove Plants]", err)
        end
    end
end)

-- Balancer Plant
task.spawn(function()
    while task.wait(5) and config["Delete Planted Seed"]["Enabled"] do
        local success, err = pcall(function()
            if not IS_LOADED then return end

            local farm = settings["player"]["Farm"]
            local max = config["Max Plant"]
            local removeList = {}

            -- Hitung tanaman berlebih dibanding batas max
            for name, count in pairs(getPlantsCount()) do
                if max[name] and count > max[name] then
                    table.insert(removeList, name)
                end
            end

            -- Hapus tanaman yang melebihi batas max
            if #removeList > 0 then
                manager:priority("BalancerPlant", function(removeList, max)
                    local shovel = Player.Backpack:FindFirstChild("Shovel [Destroy Plants]") or Player.Character:FindFirstChild("Shovel [Destroy Plants]")
                    if shovel then Player.Character.Humanoid:EquipTool(shovel) task.wait(1) end

                    for _, name in ipairs(removeList) do
                        removeExtraPlants(name, max[name])
                    end
                end, {removeList, max}, function() return true end)
            end

            -- Jika tanaman terlalu banyak (>=750), lakukan jual paksa + bersihkan
            local plants = farm and farm:WaitForChild("Important").Plants_Physical:GetChildren() or {}
            if #plants > 750 and #removeList == 0 then
                manager:priority("BalancerPlant", function(settings, config)
                    local shovel = Player.Backpack:FindFirstChild("Shovel [Destroy Plants]") or Player.Character:FindFirstChild("Shovel [Destroy Plants]")
                    if shovel then Player.Character.Humanoid:EquipTool(shovel) task.wait(1) end

                    -- Panen semua tanaman melalui ProximityPrompt
                    for _, plant in ipairs(plants) do
                        for _, desc in ipairs(plant:GetDescendants()) do
                            if settings.player.isSelling then return end
                            
                            if desc:IsA("ProximityPrompt") and desc.Enabled then
                                local part = desc.Parent
                                if part and part:IsA("BasePart") then
                                    teleport(part.Position)
                                    task.wait(0.05)
                                    fireproximityprompt(desc)
                                    task.wait()
                                end
                            end
                        end
                    end

                    -- Jual ke NPC Steven
                    teleport(settings.game.npcs.Steven)
                    task.wait(1)
                    game.ReplicatedStorage.GameEvents.Sell_Inventory:FireServer()
                    task.wait(1)

                    local plants = settings["player"]["Farm"].Important.Plants_Physical:GetChildren() or {}
                    if #plants > 750 then
                        -- Hitung jumlah masing-masing tanaman
                        local plantCounts = {}
                        for _, plant in ipairs(plants) do
                            plantCounts[plant.Name] = (plantCounts[plant.Name] or 0) + 1
                        end

                        -- Hapus tanaman berdasarkan daftar nama yang diatur
                        for _, name in ipairs(config["Delete Planted Seed"]["Name Seed Delete"]) do
                            for i = 1, (plantCounts[name] or 0) do
                                if not removeFirstPlantByName(name) then break end
                                task.wait(0.1)
                            end
                        end
                    end
                end, {settings, config}, function() return true end)
            end
        end)
        if not success then
            warn("[Task Error: Balancer Plant]", err)
        end
    end
end)

-- Feed Pet
task.spawn(function()
    while task.wait(5) do
        local success, err = pcall(function()
            if not IS_LOADED then return end
            if not config["Use Pets"]["Enabled"] then return end

            local data = cachedPlayerData
            if not data or not data.PetsData or not data.PetsData.PetInventory or not data.PetsData.PetInventory.Data then return end
            if next(data.PetsData.PetInventory.Data) == nil then return end

            local equipped = data.PetsData.EquippedPets
            local usePets = config["Use Pets"]
            local placed = #equipped
            local maxEquipped = data.PetsData.MutableStats.MaxEquippedPets
            local maxEggs = data.PetsData.MutableStats.MaxEggsInFarm

            local inventory = data.PetsData.PetInventory.Data
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("UnlockSlotFromPet")

            local hungries = {}

            -- Daftar Level Unlock untuk masing-masing slot
            local slotUnlockLevels = {
                ["Slot 4"] = 20,
                ["Slot 5"] = 30,
                ["Slot 6"] = 45,
                ["Slot 7"] = 75,
                ["Slot 8"] = 100,
            }

            -- Rarity yang boleh dikorbankan (config-based)
            local rarityToTrade = usePets["Slot Unlock"]["Rarity To Trade"] or {}

            -- Daftar pet allowed & belum equip & level < limit dari config
            local availableAllowedPets = {}
            for uuid, pet in pairs(inventory) do
                local petRarity = PetInfo[pet.PetType].Rarity
                local petLevel = pet.PetData.Level
                local allowedByName = petNameInList(usePets["Pet Name"], pet.PetType)
                local allowedByRarity = rarityAllowed(usePets["Pet Rarity"], petRarity)
                local allowed = allowedByName or allowedByRarity

                if allowed and not isPetEquipped(equipped, uuid) and petLevel < usePets.Level then
                    table.insert(availableAllowedPets, {uuid = uuid, pet = pet})
                end
            end

            for uuid, pet in pairs(inventory) do
                local isEquipped = isPetEquipped(equipped, uuid)
                local petRarity = PetInfo[pet.PetType].Rarity
                local petLevel = pet.PetData.Level
                local allowedByName = petNameInList(usePets["Pet Name"], pet.PetType)
                local allowedByRarity = rarityAllowed(usePets["Pet Rarity"], petRarity)
                local allowed = allowedByName or allowedByRarity

                -- Coba unlock slot jika level mencukupi dan config mengizinkan
                for slotName, minLevel in pairs(slotUnlockLevels) do
                    if petLevel >= minLevel and rarityToTrade[petRarity] then
                        local unlockType = nil
                        if usePets["Slot Unlock"]["Pet"][slotName] and maxEquipped < tonumber(slotName:match("%d+")) then
                            unlockType = "Pet"
                        elseif usePets["Slot Unlock"]["Egg"][slotName] and maxEggs < tonumber(slotName:match("%d+")) then
                            unlockType = "Egg"
                        end

                        if unlockType then
                            if isEquipped then
                                game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("UnequipPet", uuid)
                                placed = placed - 1
                                task.wait(0.1)
                            end
                            remote:FireServer(uuid, unlockType)
                            task.wait(0.1)
                            continue
                        end
                    end
                end

                -- Tetap cek hunger
                local hungry = isHungry(pet.PetData.Hunger, pet.PetType)
                if hungry then table.insert(hungries, uuid) end

                -- UNEQUIP jika level >= batas dan ada pet pengganti
                if isEquipped and petLevel >= usePets.Level then
                    local foundReplacement = false
                    for _, entry in ipairs(availableAllowedPets) do
                        if not isPetEquipped(equipped, entry.uuid) then
                            foundReplacement = true
                            break
                        end
                    end
                    if foundReplacement then
                        game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("UnequipPet", uuid)
                        placed = placed - 1
                        task.wait(0.1)
                        continue
                    end
                end

                -- UNEQUIP jika tidak allowed
                if isEquipped and not allowed then
                    game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("UnequipPet", uuid)
                    placed = placed - 1
                    task.wait(0.05)

                -- EQUIP jika allowed & belum equip & slot tersedia
                elseif not isEquipped and allowed and placed < maxEquipped then
                    game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", uuid)
                    placed = placed + 1
                    task.wait(0.05)
                end
            end


            if #hungries > 0 then
                manager:normal("FeedPet", function(player, collectInventory, isHungry, cachedPlayerData)
                    local data = cachedPlayerData
                    if not data then return end

                    local fruits = player["Data"].fruits

                    for i = #fruits, 1, -1 do
                        local fruit = fruits[i]
                        if fruit:GetAttribute("isFavorite") then
                            table.remove(fruits, i)
                        end
                    end

                    if #fruits == 0 then return end

                    for _, pet in ipairs(hungries) do
                        for i = #fruits, 1, -1 do
                            Player.Character.Humanoid:EquipTool(fruits[i])
                            task.wait(1)

                            game:GetService("ReplicatedStorage").GameEvents.ActivePetService:FireServer("Feed", pet)
                            task.wait(0.3)

                            table.remove(fruits, i)

                            local hungry = isHungry(data.PetsData.PetInventory.Data[pet]["PetData"].Hunger, data.PetsData.PetInventory.Data[pet]["PetType"])
                            if not hungry then break end
                        end
                    end

                end, {settings["player"], collectInventory, isHungry, cachedPlayerData}, function() return true end)
            end
        end)
        if not success then
            warn("[Task Error: Feed Pet]", err)
        end
    end
end)
-------------------------- END MAIN -----------------------------
