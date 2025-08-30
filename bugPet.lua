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

            if getgenv().start then
                local placed = 0
                local petType = getgenv().pet or nil
                for uuid, pet in pairs(inventory) do
                    if not petType and table.find({"Seal", "Koi"}, pet.PetType) then
                        petType = pet.PetType
                    end
                    
                    if pet.PetType == petType then
                        game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", uuid)
                        placed = placed + 1
                        task.wait(0.2)
                    end
                end
                task.wait(1)

                local lastEquipped = table.clone(equipped)
                local lastSlot = data.PetsData.SelectedPetLoadout
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("PetsService"):FireServer("SwapPetLoadout", 1)
                task.wait(3)
                for _, uuid in pairs(lastEquipped) do
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("TradeEvents"):WaitForChild("AddItem"):FireServer("Pet", uuid)
                    task.wait(0.5)
                end

                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("PetsService"):FireServer("SwapPetLoadout", lastSlot)
                task.wait(3)

                if petType == "Ostrich" then
                    repeat task.wait(0.1) until game:GetService("Players").LocalPlayer.PlayerGui.TradingUI.Main.GroupTransparency == 1
                    task.wait(2)

                    for uuid, pet in pairs(inventory) do
                        if pet.PetType == "Ostrich" then
                            game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", uuid)
                            task.wait(0.2)
                        end
                    end
                    task.wait(1)
                end

                getgenv().pet = nil
                getgenv().start = false
            end
        end)
        if not success then
            warn("[Task Error: Auto Pet]", err)
        end
    end
end)

-- getgenv().pet = "Ostrich"
-- getgenv().start = true
