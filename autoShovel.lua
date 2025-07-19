loadstring(game:HttpGet("https://raw.githubusercontent.com/clarksye/private/refs/heads/main/buyShop.lua"))()

local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local removeRemote = RS.GameEvents.Remove_Item

local function getMyFarm()
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local sign = farm:FindFirstChild("Sign")
        if sign and sign:GetAttribute("_owner") == Player.Name then
            return farm
        end
    end
end

local targetPlants = {
    ["Candy Blossom"] = 100,
    ["Moon Blossom"] = 50,
    ["Bone Blossom"] = 100,
    ["Honeysuckle"] = 50,
    ["Burning Bud"] = 50
}

local farm = getMyFarm()
if farm then
    while true do
        for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
            local cfg = targetPlants[plant.Name]
            if cfg then
                for _, fruit in ipairs(plant.Fruits:GetChildren()) do
                    if fruit.Weight.Value < cfg then
                        for _, obj in ipairs(fruit:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") then
                                removeRemote:FireServer(obj.Parent)
                                task.wait(0.05)
                                break
                            end
                        end
                    end
                end
            end
        end
        task.wait(5)
    end
end
