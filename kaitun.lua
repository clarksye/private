local Player = game:GetService("Players").LocalPlayer
local TrowelRemote = game:GetService("ReplicatedStorage").GameEvents.TrowelRemote
local Character = Player.Character or Player.CharacterAdded:Wait()
local Tool = Character:FindFirstChildOfClass("Tool")
if not Tool then return warn("Tool tidak ditemukan") end

local function movePlantsByName(plantName, offsetStuds)
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        if farm.Important.Data.Owner.Value == Player.Name then
            local baseCFrame = farm.Important.Plant_Locations.Can_Plant.CFrame
            local targetCFrame = CFrame.new(baseCFrame.Position + baseCFrame.LookVector * offsetStuds)

            for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
                if plant.Name == plantName then
                    TrowelRemote:InvokeServer("Pickup", Tool, plant)
                    task.wait(0.3)
                    TrowelRemote:InvokeServer("Place", Tool, plant, targetCFrame)
                    task.wait(0.3)
                end
            end

            break
        end
    end
end

movePlantsByName("Sunflower", 25)
