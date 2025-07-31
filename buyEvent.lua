local DataService = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules").DataService)

-- Auto Buy Stock
task.spawn(function()
    while task.wait(10) do
        local success, err = pcall(function()
            local data = DataService:GetData()
            if not data or not data.PetEggStock or not data.GearStock or not data.SeedStock then return end

            -- Auto Buy Eggs
            if data.PetEggStock and data.PetEggStock.Stocks then
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")
                for index, info in ipairs(data.PetEggStock.Stocks) do
                    if info and info.Stock > 0 then
                        for i = 1, info.Stock do
                            remote:FireServer(index)
                            task.wait()
                        end
                    end
                end
            end

            -- Auto Buy Tools
            if data.GearStock and data.GearStock.Stocks then
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
                for itemName, info in pairs(data.GearStock.Stocks) do
                    if info and info.Stock > 0 then
                        for _ = 1, info.Stock do
                            remote:FireServer(itemName)
                            task.wait()
                        end
                    end
                end
            end

            -- Auto Buy Seeds
            if data.SeedStock and data.SeedStock.Stocks then
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):FindFirstChild("BuySeedStock")
                for itemName, info in pairs(data.SeedStock.Stocks) do
                    if info and info.Stock > 0 then
                        for _ = 1, info.Stock do
                            remote:FireServer(itemName)
                            task.wait()
                        end
                    end
                end
            end

        end)
        if not success then
            warn("[Task Error: Auto Buy Stock]", err)
        end
    end
end)
