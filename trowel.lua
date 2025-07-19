local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Hum = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local DataService = require(RS.Modules.DataService)
local trowelRemote = RS.GameEvents.TrowelRemote

local function getMyFarm()
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local sign = farm:FindFirstChild("Sign")
        if sign and sign:GetAttribute("_owner") == Player.Name then
            return farm
        end
    end
end

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

local function getCarrots()
    local pos = {}
    local farm = getMyFarm()
    for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
        if plant.Name == "Carrot" then
            print(plant.Name)
            table.insert(pos, plant:GetPivot().Position)
        end
    end

    return pos
end

local function pickupPlants(trowel, plantName)
    local plants = {}
    local farm = getMyFarm()
    for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
        if plant.Name == plantName then
            print("pickup")
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
        print("Place")
        trowelRemote:InvokeServer("Place", trowel, plant, cf)
    end
end

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

local trowel = getToolById("{59548424-37b8-4746-8bd0-8f6d646b2b3e}")
print("Trowel : ", trowel.Name)
Hum:EquipTool(trowel)
task.wait(1)

for _, pos in ipairs(getCarrots()) do
    local plants = pickupAllTargetPlants(trowel, targetPlants)
    placePlants(trowel, plants, pos)
    task.wait(3)
end
