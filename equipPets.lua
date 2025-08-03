local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Hum = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local DataService = require(RS.Modules.DataService)

-- Functions
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

-- Init
local data = DataService:GetData()

local pets = {}
for uuid, pet in pairs(data.PetsData.PetInventory.Data or {}) do
    local type = pet.PetType
    local data = pet.PetData
    local tool = getItemById(uuid)

    if type then
        table.insert(pets, {
            tool = tool,
            uuid = uuid,
            name = type,
            mutation = data.MutationType,
            level = data.Level
        })
    end
end

-- Auto Pet
task.spawn(function()
    while task.wait(2) do
        local success, err = pcall(function()
            local equipped = data.PetsData.EquippedPets
            local maxEquipped = data.PetsData.MutableStats.MaxEquippedPets
            local placed = #equipped
            local inventory = data.PetsData.PetInventory.Data

            for uuid, pet in pairs(inventory) do
                if table.find(equipped, uuid) and pet.PetType ~= "Ostrich" then
                    game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("UnequipPet", uuid)
                    placed = placed - 1
                    task.wait(0.2)
                end

                if placed < maxEquipped and pet.PetType == "Ostrich" then
                    game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", uuid)
                    placed = placed + 1
                    task.wait(0.2)
                end
            end
        end)
        if not success then
            warn("[Task Error: Auto Pet]", err)
        end
    end
end)
