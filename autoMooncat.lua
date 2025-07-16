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

local function pickupPlants(trowel, plantName)
    local plants = {}
    local farm = getMyFarm()
    for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
        if plant.Name == plantName then
            trowelRemote:InvokeServer("Pickup", trowel, plant)
            task.wait(0.1)
            table.insert(plants, plant)
        end
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
    local farm = getMyFarm()
    local baseCF = farm.Important.Plant_Locations.Can_Plant.CFrame
    local cf = CFrame.new(position) * (baseCF - baseCF.Position)

    for _, plant in ipairs(plants) do
        trowelRemote:InvokeServer("Place", trowel, plant, cf)
    end
end

local function placeToCatsPosition(trowel, plantTable)
    local cats = getMoonCatPositions()
    for _, cPos in ipairs(cats) do
        local plants = pickupAllTargetPlants(trowel, plantTable)
        placePlants(trowel, plants, cPos)
        task.wait(0.2)
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

-- === Config
local targetPlants = {
    ["Candy Blossom"] = {
        ["min"] = 100
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

RunService.Heartbeat:Connect(function(dt)
    elapsed = elapsed + dt

    if step == 0 and not stepInProgress then
        stepInProgress = true
        print("STEP 0: Equip Triceratop")
        equipPets(backpack.pets["Triceratop"], triceratopCount)
        step = 1
        stepInProgress = false

    elseif step == 1 and elapsed >= 137 and not stepInProgress then
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

    elseif step == 3 and elapsed >= 193 and not stepInProgress then
        stepInProgress = true
        print("STEP 3: Destroy Buah Kurang Berat")
        destroyUnderweightFruits(targetPlants)
        Hum:EquipTool(backpack.trowel)
        step = 4
        stepInProgress = false

    elseif step == 4 and elapsed >= 205 and not stepInProgress then
        stepInProgress = true
        print("STEP 4: Tanam di Posisi Cats")
        placeToCatsPosition(backpack.trowel, targetPlants)
        step = 5
        stepInProgress = false

    elseif step == 5 and elapsed >= 230 and not stepInProgress then
        stepInProgress = true
        print("STEP 5: Pickup semua pet")
        unEquipPets(backpack.pets["Triceratop"])
        unEquipPets(backpack.pets["Moon Cat"])
        Hum:UnequipTools()
        elapsed = 0
        step = 0
        stepInProgress = false
    end
end)
