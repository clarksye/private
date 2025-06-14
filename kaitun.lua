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
            ["Daffodil"] = true,
            ["Watermelon"] = true,
            ["Pumpkin"] = true,
            ["Apple"] = true,
            ["Bamboo"] = true,
            ["Coconut"] = true,
            ["Cactus"] = true,
            ["Dragon Fruit"] = true,
            ["Mango"] = true,
            ["Grape"] = true,
            ["Mushroom"] = true,
            ["Pepper"] = true,
            ["Cacao"] = true,
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
            ["Trowel"] = true,
            ["Recall Wrench"] = true,
            ["Basic Sprinkler"] = true,
            ["Advanced Sprinkler"] = true,
            ["Godly Sprinkler"] = true,
            ["Lightning Rod"] = true,
            ["Master Sprinkler"] = true,
            ["Cleaning Spray"] = true,
            ["Favorite Tool"] = false,
            ["Harvest Tool"] = false,
            ["Friendship Pot"] = true
        }
    },
    ["Buy Eggs"] = {
        ["Enabled"] = true,
        ["Threshold"] = 10000000,
        ["Item"] = {
            ["Common Egg"] = false,
            ["Uncommon Egg"] = false,
            ["Rare Egg"] = false,
            ["Legendary Egg"] = true,
            ["Mythical Egg"] = true,
            ["Bug Egg"] = true
        }
    },
    ["Buy Events"] = {
        ["Enabled"] = true,
        ["Item"] = {
            ["Flower Seed Pack"] = true,
            ["Nectarine"] = true,
            ["Hive Fruit"] = true,
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
        ["Enabled"] = false,
        ["Seed Name"] = {
            "Strawberry",  "Blueberry", "Tomato", "Corn", "Apple", "Carrot", "Rose"
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
    }
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/kaitun.lua"))()
