-- getgenv().Config = {
--     ["Place Eggs"] = {
--         ["Enabled"] = true,
--         ["Order By"] = {
--             "Zen Egg", "Common Egg", "Common Summer Egg", "Uncommon Egg", "Rare Egg", "Rare Summer Egg", "Legendary Egg", "Night Egg", "Bee Egg", "Dinosaur Egg", "Oasis Egg", "Primal Egg", "Mythical Egg", "Paradise Egg", "Bug Egg"
--         },
--         ["Item"] = {
--             ["Common Egg"] = true,
--             ["Common Summer Egg"] = true,
--             ["Uncommon Egg"] = true,
--             ["Rare Egg"] = true,
--             ["Rare Summer Egg"] = true,
--             ["Legendary Egg"] = true,
--             ["Night Egg"] = true,
--             ["Bee Egg"] = true,
--             ["Dinosaur Egg"] = true,
--             ["Zen Egg"] = true,
--             ["Oasis Egg"] = true,
--             ["Primal Egg"] = true,
--             ["Mythical Egg"] = true,
--             ["Paradise Egg"] = true,
--             ["Bug Egg"] = true
--         }
--     },
--     ["Sell Pets"] = {
--         ["Enabled"] = true,
--         ["Level"] = 45, -- Jual semua yang di bawah level
--         ["Keep"] = { -- List pet yang tidak ingin di jual
--             ["Type"] = {
--                 -- Mutation Type
--                 "Butterfly", "Dragonfly", "Disco Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus", "Tanchozuru",
--                 -- Fruits
--                 "Moon Cat", "Blood Hedgehog", "Toucan",
--                 -- Eggs
--                 "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
--                 -- Target Pet
--                 "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk", "Mimic Octopus",
--                 -- Steal
--                 "Raccoon", "Kitsune", "Corrupted Kitsune", "Kodama", "Corrupted Kodama",
--                 -- Unknown
--                 "Kappa"
--             },
--             ["Mutation"] = {
--                 ["a"] = { -- Shocked
--                     -- Mutation Type
--                     "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus", "Tanchozuru",
--                     -- Fruits
--                     "Moon Cat", "Cat", "Orange Tabby", "Pig", "Cow", "Sea Otter", "Turtle", "Caterpillar", "Praying Mantis", "Giant Ant", "Red Giant Ant", "Triceratops", "Raptor", "Blood Hedgehog", "Toucan",
--                     -- Eggs
--                     "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
--                     -- Target Pet
--                     "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk", "Mimic Octopus",
--                     -- Steal
--                     "Raccoon", "Kitsune",
--                     -- Unknown
--                     "Kappa"
--                 },
--                 ["b"] = { -- Golden
--                     -- Mutation Type
--                     "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus", "Tanchozuru",
--                     -- Fruits
--                     "Moon Cat", "Cat", "Orange Tabby", "Pig", "Cow", "Sea Otter", "Turtle", "Caterpillar", "Praying Mantis", "Giant Ant", "Red Giant Ant", "Triceratops", "Raptor", "Blood Hedgehog", "Toucan",
--                     -- Eggs
--                     "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
--                     -- Target Pet
--                     "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk", "Mimic Octopus",
--                     -- Steal
--                     "Raccoon", "Kitsune",
--                     -- Unknown
--                     "Kappa"
--                 },
--                 ["c"] = { -- Rainbow
--                     -- Mutation Type
--                     "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus", "Tanchozuru",
--                     -- Fruits
--                     "Moon Cat", "Cat", "Orange Tabby", "Pig", "Cow", "Sea Otter", "Turtle", "Caterpillar", "Praying Mantis", "Giant Ant", "Red Giant Ant", "Triceratops", "Raptor", "Blood Hedgehog", "Toucan",
--                     -- Eggs
--                     "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
--                     -- Target Pet
--                     "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk", "Mimic Octopus",
--                     -- Steal
--                     "Raccoon", "Kitsune",
--                     -- Unknown
--                     "Kappa"
--                 },
--                 ["e"] = { -- Windy
--                     -- Mutation Type
--                      "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus", "Tanchozuru",
--                 },
--                 ["f"] = { -- Frozen
--                     -- Mutation Type
--                      "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus", "Tanchozuru",
--                 },
--                 ["i"] = { -- Mega
--                     "ALL"
--                 },
--                 ["n"] = { -- Ascended
--                     "ALL"
--                 },
--             }
--         }
--     }
-- }
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/pets.lua"))()

-- local Players = game:GetService("Players")
-- local Player = Players.LocalPlayer
-- local RS = game:GetService("ReplicatedStorage")
-- local Character = Player.Character or Player.CharacterAdded:Wait()
-- local Hum = Character:WaitForChild("Humanoid")
-- local HRP = Character:WaitForChild("HumanoidRootPart")

-- local DataService = require(RS.Modules.DataService)
-- local petGiftingServiceRemote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents").PetGiftingService

-- -- Functions
-- local function getFarm()
--     for _, farm in ipairs(workspace:WaitForChild("Farm"):GetChildren()) do
--         local success, owner = pcall(function()
--             return farm:WaitForChild("Important").Data.Owner.Value
--         end)
--         if success and owner == Player.Name then
--             return farm
--         end
--     end
--     return nil
-- end

-- local function getItemById(id)
--     for _, container in ipairs({Player.Backpack, Player.Character}) do
--         if container then
--             for _, tool in ipairs(container:GetChildren()) do
--                 if tool:IsA("Tool") then
--                     for key, value in pairs(tool:GetAttributes()) do
--                         if value == id then
--                             return tool
--                         end
--                     end
--                 end
--             end
--         end
--     end
--     return nil
-- end

-- local function findValidTarget(targets)
--     for _, name in ipairs(targets) do
--         local targetModel = workspace:FindFirstChild(name)
--         if targetModel then
--             return name, targetModel
--         end
--     end
--     return nil, nil
-- end

-- local function teleport(position)
--     local adjustedPos = position + Vector3.new(0, 0.5, 0)
--     HRP.CFrame = CFrame.new(adjustedPos)
-- end

-- -- Init
-- local data = DataService:GetData()
-- local targets = {"IchiroP6Mio", "ChikaV7Ren", "HarukaY1Nao", "AsahiP1Nene", "MisakiX6Shun", "TakaoP3Naka", "NanaR7Sota", "AyameV4Rui"}

-- local pets = {}
-- for uuid, pet in pairs(data.PetsData.PetInventory.Data or {}) do
--     local type = pet.PetType
--     local data = pet.PetData
--     local tool = getItemById(uuid)

--     if type then
--         table.insert(pets, {
--             tool = tool,
--             uuid = uuid,
--             favorite = data.IsFavorite,
--             name = type,
--             mutation = data.MutationType,
--             level = data.Level
--         })
--     end
-- end

-- -- Auto Place
-- task.spawn(function()
--     local targetName, targetModel = findValidTarget(targets)
--     teleport(targetModel:GetPivot().Position)
--     task.wait(1)

--     while task.wait(4) do
--         for i = #pets, 1, -1 do
--             pcall(function()
--                 local pet = pets[i]
--                 if pet.favorite then game.ReplicatedStorage.GameEvents.Favorite_Item:FireServer(pet.tool) end
--                 Hum:EquipTool(pet.tool)
--                 task.wait(0.5)
                
--                 petGiftingServiceRemote:FireServer("GivePet", game.Players[targetName])
--                 local startTime = os.clock()
--                 repeat
--                     task.wait(0.1)
--                 until not Character:FindFirstChildOfClass("Tool") or os.clock() - startTime > 15
--                 if os.clock() - startTime < 15 then table.remove(pets, i) end
--             end)
--         end
--     end
-- end)
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

task.spawn(function()
    while true do
        task.wait(4)
        local gui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if gui then
            local success, _ = pcall(function()
                local btn = gui.Gift_Notification.Frame.Gift_Notification.Holder.Frame.Accept
                if btn and btn.MouseButton1Click then
                    firesignal(btn.MouseButton1Click)
                    task.wait(0.1)
                end
            end)
        end
    end
end)


