local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local removeRemote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Remove_Item")

for _, farm in ipairs(workspace.Farm:GetChildren()) do
    local sign = farm:FindFirstChild("Sign")
    if sign and sign:GetAttribute("_owner") == Player.Name then
        for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
            if table.find({"Zenflare", "Zen Rocks", "Monoblooma"}, plant.Name) then
                removeRemote:FireServer(plant:FindFirstChildWhichIsA("BasePart"))
                task.wait(0.1) 
            end
        end
        break
    end
end
