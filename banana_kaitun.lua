repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "0c35250991e58f6cd19192bc" -- key
getgenv().Config = {
    ["Buy Egg"] = {
        ["Select Egg"] = {
            ["Bee Egg"] = true,
            ["Bug Egg"] = true,
            ["Mythical Egg"] = true,
            ["Legendary Egg"] = false,
        }
    },
    ["Delete Pet"] = {
        ["Enabled"] = false,
        ["Pet Dont Delete"] = {"Raccoon", "Dragon Fly", "Queen Bee"}
    },
    ["dont Buy Seed low Price"] = {
        ["Enabled"] = true, 
        ["Money"] = 1000000,
    },
    ["Auto Delete Seed Planted"] = {
        ["Enabled"] = true,
        ["Auto Delete Seed Low Price"] = false,
        ["Slot"] = 50,
        ["Name Seed Delete"] = {
            "Strawberry", "Blueberry", "Tomato", "Corn", "Apple"
        }
    },
    ["Dont collect during weather events"] = {
        ["Enabled"] = false,
        ["Weather"] = {
            ["Rain"] = false,
            ["Frost"] = false,
            ["Thunderstorm"] = true,
        }
    },
    ["Gear"]  = {
        ["Buy Gear"] = {
            ["Enabled"] = false,
            ["Select Gear"] = {
                ["Basic Sprinkler"] = true, 
                ["Advanced Sprinkler"] = true,
                ["Godly Sprinkler"] = true,
                ["Master Sprinkler"] = true,
            }
        },
        ["Use Gear"] = {
            ["Enabled"] = false, 
            ["Select Gear"] = {
                ["Basic Sprinkler"] = true, 
                ["Advanced Sprinkler"] = true,
                ["Godly Sprinkler"] = true,
                ["Master Sprinkler"] = true,
            },
            ["Stack Gear"] = { -- 🇺🇸 It will wait until you have all the gears you've enabled in the stack before using them.For example, 
                ["Enabled"] = false, --if you enable both Basic Sprinkler and Advanced Sprinkler, it will only start using them once both are in your inventory.
                ["Select Gear"] = { 
                    ["Basic Sprinkler"] = false, 
                    ["Advanced Sprinkler"] = false,
                    ["Godly Sprinkler"] = false,
                    ["Master Sprinkler"] = false,
                }
            }
        }
    },
    ["Webhook"] = {
        ["Enabled"] = false,
        ["Url"] = "",
        ["Webhook Profile"] = true,
        ["Webhook Collect Egg"] = true,
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/KaitunGAG.lua"))()

local cachedPlayerData = nil

-- HOOK PlayerData
task.spawn(function()
    local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
    if typeof(DataService.GetData) == "function" then
        local oldGetData = DataService.GetData

        DataService.GetData = function(self, ...)
            local data = oldGetData(self, ...)
            cachedPlayerData = data
            return data
        end
    else
        warn("DataService.GetData bukan fungsi atau belum tersedia.")
    end
end)

spawn(function()
    wait(5)
    local function buyEventShopItems()
        local data = cachedPlayerData
        if not data or not data.EventShopStock or not data.EventShopStock.Stocks then return end

        local allHoneyShopItems = {
            "Flower Seed Pack",
            "Hive Fruit Seed",
            "Nectarine Seed",
            "Bee Egg"
        }

        local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):FindFirstChild("BuyEventShopStock")

        for _, itemName in ipairs(allHoneyShopItems) do
            local stockData = data.EventShopStock.Stocks[itemName]
            if stockData and stockData.Stock > 0 then
                remote:FireServer(itemName)
                task.wait()
            end
        end
    end

    while task.wait(1) do
        buyEventShopItems()
    end
end)
