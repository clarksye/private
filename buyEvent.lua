local DataService = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules").DataService)

-- Auto Buy Stock
task.spawn(function()
    while task.wait(2) do
        local success, err = pcall(function()
            local data = DataService:GetData()
            if not data or not data.PetEggStock or not data.GearStock or not data.SeedStock then return end

             -- Auto Buy Event
            if data.eventShopStock and data.eventShopStock.Stocks then
                for itemName, info in pairs(data.eventShopStock.Stocks) do
                    if table.find({"Zen Egg", "Zenflare", "Zen Seed Pack", "Sakura Bush"}, itemName) then
                        if info and info.Stock > 0 then
                            for i = 1, info.Stock do
                                buyEventShopStockRemote:FireServer(itemName)
                                task.wait()
                            end
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
