local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local removeRemote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Remove_Item")

for _, farm in ipairs(workspace.Farm:GetChildren()) do
    local sign = farm:FindFirstChild("Sign")
    if sign and sign:GetAttribute("_owner") == Player.Name then
        for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
            if not table.find({"Candy Blossom", "Moon Blossom", "Sugar Apple", "Sunflower", "Beanstalk", "Giant Pinecone"}, plant.Name) then
                removeRemote:FireServer(plant:FindFirstChildWhichIsA("BasePart"))
                task.wait(0.05)
            end
        end
        break
    end
end
