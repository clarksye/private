getgenv().Config = {
    ["Buy Seeds"] = {
        ["Enabled"] = true,
        ["Threshold"] = 10,
        ["Item"] = {
            ["Carrot"] = true,
            ["Strawberry"] = true,
            ["Blueberry"] = true,
            ["Orange Tulip"] = true,
            ["Tomato"] = true,
            ["Corn"] = true,
            ["Cauliflower"] = true,       -- ✅ baru
            ["Daffodil"] = true,
            ["Watermelon"] = true,
            ["Pumpkin"] = true,
            ["Apple"] = true,
            ["Bamboo"] = true,
            ["Green Apple"] = true,       -- ✅ baru
            ["Avocado"] = true,           -- ✅ baru
            ["Banana"] = true,            -- ✅ baru
            ["Coconut"] = true,
            ["Cactus"] = true,
            ["Dragon Fruit"] = true,
            ["Mango"] = true,
            ["Pineapple"] = true,         -- ✅ baru
            ["Kiwi"] = true,              -- ✅ baru
            ["Bell Pepper"] = true,       -- ✅ baru
            ["Prickly Pear"] = true,      -- ✅ baru
            ["Grape"] = true,
            ["Mushroom"] = true,
            ["Pepper"] = true,
            ["Cacao"] = true,
            ["Loquat"] = true,            -- ✅ baru
            ["Feijoa"] = true,            -- ✅ baru
            ["Beanstalk"] = true,
            ["Ember Lily"] = true,
            ["Sugar Apple"] = true
        }
    },
    ["Buy Tools"] = {
        ["Enabled"] = true,
        ["Threshold"] = 10000000, -- if enable, will only buy if shekless more than 10.000.000
        ["Item"] = {
            ["Watering Can"] = true,
            ["Trowel"] = false,
            ["Recall Wrench"] = false,
            ["Basic Sprinkler"] = true,
            ["Advanced Sprinkler"] = true,
            ["Godly Sprinkler"] = true,
            ["Tanning Mirror"] = false,
            ["Lightning Rod"] = false,
            ["Master Sprinkler"] = true,
            ["Cleaning Spray"] = false,
            ["Favorite Tool"] = false,
            ["Harvest Tool"] = false,
            ["Friendship Pot"] = false
        }
    },
    ["Buy Eggs"] = {
        ["Enabled"] = true,
        ["Threshold"] = 10000000,
        ["Item"] = {
            ["Common Egg"] = false,
            ["Common Summer Egg"] = true,  -- ✅ baru
            ["Uncommon Egg"] = false,
            ["Rare Egg"] = true,
            ["Rare Summer Egg"] = true,     -- ✅ baru
            ["Legendary Egg"] = true,
            ["Mythical Egg"] = true,
            ["Paradise"] = true,            -- ✅ baru
            ["Bug Egg"] = true
        }
    },
    ["Buy Events"] = {
        ["Enabled"] = true,
        ["Item"] = {
            ["Flower Seed Pack"] = true,
            ["Nectarine"] = true,
            ["Hive Fruit"] = true,
            ["Lavender"] = true,
            ["Nectarshade"] = true,
            ["Pollen Radar"] = false,
            ["Nectar Staff"] = false,
            ["Honey Sprinkler"] = true,
            ["Bee Egg"] = true,
            ["Bee Crate"] = false,
            ["Honey Comb"] = false,
            ["Bee Chair"] = false,
            ["Honey Torch"] = false,
            ["Honey Walkway"] = false
        }
    },
    ["Use Sprinklers"] = {
        ["Enabled"] = true,
        ["Sprinkler"] = {
            ["Basic Sprinkler"] = true,
            ["Advanced Sprinkler"] = true,
            ["Godly Sprinkler"] = true,
            ["Master Sprinkler"] = true,
        },
        ["Stack"] = { -- When stack true, will only place after have "all the true (enabled)" so will stake
            ["Basic Sprinkler"] = false,
            ["Advanced Sprinkler"] = false,
            ["Godly Sprinkler"] = false,
            ["Master Sprinkler"] = false,
        }
    },
    ["Use Pets"] = {
        ["Enabled"] = true,
        ["Level"] = 20, -- Will change to another pet if level more than this (if have another pet)
        ["Slot Unlock"] = { -- Trade pet for increase slot
            ["Rarity To Trade"] = {
                ["Common"] = true,
                ["Uncommon"] = true,
                ["Rare"] = true,
                ["Legendary"] = false,
                ["Mythical"] = false,
                ["Divine"] = false
            },
            ["Pet"] = {
                ["Slot 4"] = true, -- 4 slot
                ["Slot 5"] = false, -- 5 slot
                ["Slot 6"] = false, -- 6 slot
                ["Slot 7"] = false, -- 7 slot
                ["Slot 8"] = false, -- 8 slot
            },
            ["Egg"] = {
                ["Slot 4"] = true, -- 4 slot
                ["Slot 5"] = false, -- 5 slot
                ["Slot 6"] = false, -- 6 slot
                ["Slot 7"] = false, -- 7 slot
                ["Slot 8"] = false, -- 8 slot
            }
        },
        ["Pet Name"] = { -- If dont have pet with name then will use by rarity
            "Golden Lab"
        },
        ["Pet Rarity"] = { -- Will choose use pet by rariry, from common..divine if this all active
            {["Common"] = true},
            {["Uncommon"] = true},
            {["Rare"] = true},
            {["Legendary"] = true},
            {["Mythical"] = true},
            {["Divine"] = true}
        }
    },
    ["Dont Collect On Weather"] = {
        ["Enabled"] = true,
        ["Weather"] = {
            ["RainEvent"] = false, -- Rain
            ["FrostEvent"] = true, -- Frost
            ["Thunderstorm"] = true, -- Thunderstorm
            ["BeeSwarm"] = false -- Bee
        }
    },
    ["Dont Buy Seed"] = {
        ["If Money More Than"] = 1000000, -- If we have money more than this, will not buying from Seed Name List
        ["Seed Name"] = {
            "Strawberry",  "Blueberry", "Tomato", "Corn", "Apple", "Carrot"
        }
    },
    ["Dont Plant Inventory Seed"] = {
        ["Enabled"] = true,
        ["Seed Name"] = {
            "Rose", "Foxglove", "Lilac", "Pink Lily", "Purple Dahlia", "Sunflower",
            "Crocus", "Succulent", "Violet Corn", "Bendboo", "Cocovine", "Dragon Pepper",
            "Lavender", "Nectarshade",
            "Daffodil", "Orange Tulip", "Cactus", "Pumpkin"
        }
    },
    ["Delete Planted Seed"] = {
        ["Enabled"] = true,
        ["Slot"] = {
            {slot = 300, min = 0},        -- if money 0 then using this slot
            {slot = 200, min = 1000000},  -- if money 1.000.000 then using this slot
            {slot = 150, min = 10000000}, -- if money 10.000.000 then using this slot
            {slot = 100, min = 20000000}, -- if money 20.000.000 then using this slot
            {slot = 50,  min = 100000000}, -- if money 100.000.000 then using this slot
        },
        ["Name Seed Delete"] = {
            "Strawberry",  "Blueberry", "Tomato", "Corn", "Apple", "Rose", "Foxglove", "Orange Tulip"
        }
    },
    ["Max Plant"] = { -- CAUTION if plant in plot more than max will be deleted!
        ["Daffodil"] = 30,
        ["Bamboo"] = 30,
        ["Coconut"] = 15,
        ["Cactus"] = 15,
        ["Dragon Fruit"] = 15,
        ["Mango"] = 15,
        ["Grape"] = 15,
    },
    ["Misc"] = {
        ["Open Seed Pack"] = true,
        ["Plant Seed"] = true,
        ["Hatch Egg"] = true
    }
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/kaitun.lua"))()
