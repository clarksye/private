local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Hum = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local DataService = require(RS.Modules.DataService)
local removeRemote = RS.GameEvents.Remove_Item
local trowelRemote = RS.GameEvents.TrowelRemote
local equipPetRemote = RS.GameEvents.PetsService
local sprinklerRemote = RS.GameEvents.SprinklerService

-- Helper: Tools & Inventory
local function getToolByName(name)
    for _, container in ipairs({Player.Backpack, Player.Character}) do
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == name then
                return tool
            end
        end
    end
end

local function getToolById(id)
    for _, container in ipairs({Player.Backpack, Player.Character}) do
        for _, tool in ipairs(container:GetChildren()) do
            for _, val in pairs(tool:GetAttributes()) do
                if val == id then return tool end
            end
        end
    end
end

local function getMyFarm()
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local sign = farm:FindFirstChild("Sign")
        if sign and sign:GetAttribute("_owner") == Player.Name then
            return farm
        end
    end
end

local function getMoonCatPositions()
    local positions = {}
    for _, pet in ipairs(workspace.PetsPhysical:GetChildren()) do
        if pet:GetAttribute("OWNER") == Player.Name then
            local uuid = pet:GetAttribute("UUID")
            local model = pet:FindFirstChild(uuid)
            if model and model:GetAttribute("CurrentSkin") == "Moon Cat" then
                table.insert(positions, pet.Position)
            end
        end
    end
    return positions
end

local function getBestOverlapPoint(field, petPositions, radius, step)
    local center = field.Position
    local size = field.Size
    local best = {point = nil, count = 0}

    for x = center.X - size.X / 2, center.X + size.X / 2, step do
        for z = center.Z - size.Z / 2, center.Z + size.Z / 2, step do
            local testPoint = Vector3.new(x, center.Y, z)
            local count = 0
            for _, petPos in ipairs(petPositions) do
                if (Vector3.new(petPos.X, 0, petPos.Z) - Vector3.new(x, 0, z)).Magnitude <= radius then
                    count = count + 1
                end
            end
            if count > best.count then
                best = {point = testPoint, count = count}
            end
        end
    end

    return best
end

local function getBestPlantingSpot()
    local farm = getMyFarm()
    local fields = farm.Important.Plant_Locations:GetChildren()
    local moonCats = getMoonCatPositions()
    local best = {point = nil, count = -1}

    for _, field in ipairs(fields) do
        if field.Name == "Can_Plant" then
            local result = getBestOverlapPoint(field, moonCats, 9, 1)
            if result.count > best.count then
                best = result
            end
        end
    end

    return best.point
end

local function pickupPlants(trowel, plantName)
    local farm = getMyFarm()
    local plants, threads = {}, {}

    for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
        if plant.Name == plantName then
            local co = coroutine.create(function()
                trowelRemote:InvokeServer("Pickup", trowel, plant)
            end)
            coroutine.resume(co)
            table.insert(plants, plant)
            table.insert(threads, co)
        end
    end

    for _, co in ipairs(threads) do
        while coroutine.status(co) ~= "dead" do task.wait() end
    end

    return plants
end

local function pickupAllTargetPlants(trowel, plantTable)
    local collected = {}
    for plantName in pairs(plantTable) do
        local result = pickupPlants(trowel, plantName)
        for _, p in ipairs(result) do
            table.insert(collected, p)
        end
    end
    return collected
end

local function placePlants(trowel, plants, position)
    local baseCF = getMyFarm().Important.Plant_Locations.Can_Plant.CFrame
    local cf = CFrame.new(position) * (baseCF - baseCF.Position)
    local threads = {}

    for _, plant in ipairs(plants) do
        local co = coroutine.create(function()
            trowelRemote:InvokeServer("Place", trowel, plant, cf)
        end)
        coroutine.resume(co)
        table.insert(threads, co)
    end

    for _, co in ipairs(threads) do
        while coroutine.status(co) ~= "dead" do task.wait() end
    end
end

local function destroyUnderweightFruits(plantTable)
    local farm = getMyFarm()
    for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
        local config = plantTable[plant.Name]
        if config then
            for _, fruit in ipairs(plant.Fruits:GetChildren()) do
                for _, obj in ipairs(fruit:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and fruit.Weight.Value < config.min then
                        removeRemote:FireServer(obj.Parent)
                        task.wait(0.05)
                        break
                    end
                end
            end
        end
    end
    task.wait(1)
end

local function equipPets(pets, max)
    for i = 1, math.min(max, #pets) do
        equipPetRemote:FireServer("EquipPet", pets[i].uuid)
        task.wait(0.1)
    end
end

local function unEquipPets(pets)
    for _, pet in ipairs(pets) do
        equipPetRemote:FireServer("UnequipPet", pet.uuid)
        task.wait(0.1)
    end
end

local function equipSprinklers(sprinklers, plantTable)
    local farm = getMyFarm()
    local cfB = farm.Important.Plant_Locations.Can_Plant.CFrame
    local planted = {}

    -- Cek sprinkler yang sudah tertanam
    for _, obj in ipairs(farm:WaitForChild("Important").Objects_Physical:GetChildren()) do
        if table.find({"Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler"}, obj.Name) then
            planted[obj.Name] = true
        end
    end

    for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
        local config = plantTable[plant.Name]
        if config then
            cfB = CFrame.new(plant:GetPivot().Position) * (cfB - cfB.Position)
            break
        end
    end

    local cfA = cfB * CFrame.new(0, 0.5, 0)
    for sprinkler, info in pairs(sprinklers) do
        if not planted[sprinkler] then
            if info.uses > 0 then
                sprinklers[sprinkler].uses = sprinklers[sprinkler].uses - 1
                Hum:EquipTool(info.tool)
                task.wait(0.3)
                sprinklerRemote:FireServer("Create", cfA)
                task.wait(0.2)
            end
        end
    end
end

-- Auto Buy Stock
task.spawn(function()
    while task.wait(10) do
        local success, err = pcall(function()
            local data = DataService:GetData()
            if not data or not data.PetEggStock or not data.GearStock or not data.SeedStock then return end

            -- Auto Buy Eggs
            if data.PetEggStock and data.PetEggStock.Stocks then
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")
                for index, info in ipairs(data.PetEggStock.Stocks) do
                    if info and info.Stock > 0 then
                        for i = 1, info.Stock do
                            remote:FireServer(index)
                            task.wait()
                        end
                    end
                end
            end

            -- Auto Buy Tools
            if data.GearStock and data.GearStock.Stocks then
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
                for itemName, info in pairs(data.GearStock.Stocks) do
                    if info and info.Stock > 0 then
                        for _ = 1, info.Stock do
                            remote:FireServer(itemName)
                            task.wait()
                        end
                    end
                end
            end

            -- Auto Buy Seeds
            if data.SeedStock and data.SeedStock.Stocks then
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):FindFirstChild("BuySeedStock")
                for itemName, info in pairs(data.SeedStock.Stocks) do
                    if info and info.Stock > 0 then
                        for _ = 1, info.Stock do
                            remote:FireServer(itemName)
                            task.wait()
                        end
                    end
                end
            end

        end)
        if not success then
            warn("[Task Error: Auto Buy Stock]", err)
        end
    end
end)

-- === Config
local targetPlants = {
    ["Candy Blossom"] = {
        ["min"] = 150
    },
    ["Moon Blossom"] = {
        ["min"] = 50
    },
    ["Bone Blossom"] = {
        ["min"] = 100
    },
    ["Honeysuckle"] = {
        ["min"] = 50
    },
    ["Burning Bud"] = {
        ["min"] = 50
    }
}
local triceratopCount = 2
local mooncatCount = 6

-- === Setup
local data = DataService:GetData()
local backpack = {
    shovel = getToolByName("Shovel [Destroy Plants]"),
    trowel = nil,
    sprinklers = {},
    pets = {
        ["Moon Cat"] = {},
        ["Triceratop"] = {}
    }
}

for uuid, item in pairs(data.InventoryData) do
    if item.ItemType == "Trowel" then
        backpack.trowel = getToolById(uuid)
    end
    if item.ItemType == "Sprinkler" then
        if table.find({"Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler"}, item.ItemData.ItemName) then
            backpack.sprinklers[item.ItemData.ItemName] = {tool = getToolById(uuid), uses = item.ItemData.Uses}
        end
    end
end

for uuid, pet in pairs(data.PetsData.PetInventory.Data or {}) do
    local type = pet.PetType
    if type == "Moon Cat" or type == "Triceratops" then
        table.insert(backpack.pets[type == "Triceratops" and "Triceratop" or "Moon Cat"], {
            uuid = uuid,
            level = pet.PetData.Level
        })
    end
end

-- === Heartbeat Loop
local step = 0
local elapsed = 0
local stepInProgress = false
local currentPlants = nil

RunService.Heartbeat:Connect(function(dt)
    elapsed = elapsed + dt

    if step == 0 and not stepInProgress then
        stepInProgress = true
        print("STEP 0: Equip Triceratop")
        equipPets(backpack.pets["Triceratop"], triceratopCount)
        step = 1
        stepInProgress = false

    elseif step == 1 and elapsed >= 140 and not stepInProgress then
        stepInProgress = true
        print("STEP 1: Equip Moon Cat")
        equipPets(backpack.pets["Moon Cat"], mooncatCount)
        step = 2
        stepInProgress = false

    elseif step == 2 and elapsed >= 180 and not stepInProgress then
        stepInProgress = true
        print("STEP 2: Equip Sprinkler")
        equipSprinklers(backpack.sprinklers, targetPlants)
        Hum:EquipTool(backpack.shovel)
        step = 3
        stepInProgress = false

    elseif step == 3 and elapsed >= 200 and not stepInProgress then
        stepInProgress = true
        print("STEP 3: Destroy Buah Kurang Berat")
        destroyUnderweightFruits(targetPlants)
        Hum:EquipTool(backpack.trowel)
        step = 4
        stepInProgress = false

    elseif step == 4 and elapsed >= 205 and not stepInProgress then
        stepInProgress = true
        print("STEP 4: Pickup Tanaman")
        currentPlants = pickupAllTargetPlants(backpack.trowel, targetPlants)
        step = 5
        stepInProgress = false

    elseif step == 5 and elapsed >= 211 and not stepInProgress then
        stepInProgress = true
        print("STEP 5: Tanam di Posisi Terbaik")
        local bestPos = getBestPlantingSpot()
        placePlants(backpack.trowel, currentPlants, bestPos)
        step = 6
        stepInProgress = false

    elseif step == 6 and elapsed >= 235 and not stepInProgress then
        stepInProgress = true
        print("STEP 6: Pickup semua pet")
        unEquipPets(backpack.pets["Triceratop"])
        unEquipPets(backpack.pets["Moon Cat"])
        Hum:UnequipTools()
        elapsed = 0
        step = 0
        stepInProgress = false
    end
end)
