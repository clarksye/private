local Player = game:GetService("Players").LocalPlayer
local TrowelRemote = game:GetService("ReplicatedStorage").GameEvents.TrowelRemote
local Character = Player.Character or Player.CharacterAdded:Wait()
local Tool = Character:FindFirstChildOfClass("Tool")
if not Tool then return warn("Tool tidak ditemukan") end

for _, farm in ipairs(workspace.Farm:GetChildren()) do
    if farm.Important.Data.Owner.Value == Player.Name then
        local plantGroups = {}
        for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
            plantGroups[plant.Name] = plantGroups[plant.Name] or {}
            table.insert(plantGroups[plant.Name], plant)
        end

        local fields = {}
        for _, f in ipairs(farm.Important.Plant_Locations:GetChildren()) do
            if f.Name == "Can_Plant" then
                table.insert(fields, f)
            end
        end

        local groupNames = {}
        for name in pairs(plantGroups) do
            table.insert(groupNames, name)
        end

        for i, plantName in ipairs(groupNames) do
            local plants = plantGroups[plantName]
            local field = fields[((i - 1) % #fields) + 1] -- rotasi 2 ladang

            local sizeX, sizeZ = field.Size.X, field.Size.Z
            local base = field.CFrame
            local total = #plants

            local gridX = math.floor(math.sqrt(total))
            local gridZ = math.ceil(total / gridX)
            local spaceX = sizeX / gridX
            local spaceZ = sizeZ / gridZ

            for x = 1, gridX do
                for z = 1, gridZ do
                    local plant = table.remove(plants)
                    if not plant then break end

                    local offsetX = (x - 0.5) * spaceX - sizeX / 2
                    local offsetZ = (z - 0.5) * spaceZ - sizeZ / 2
                    local position = base.Position + base.RightVector * offsetX + base.LookVector * offsetZ
                    local finalCFrame = CFrame.new(position)

                    TrowelRemote:InvokeServer("Pickup", Tool, plant)
                    task.wait(0.1)
                    TrowelRemote:InvokeServer("Place", Tool, plant, finalCFrame)
                    task.wait(0.1)
                end
            end
        end

        break
    end
end
