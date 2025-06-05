getgenv().Config = {
    ["Buy Seeds"] = {
        ["Enabled"] = true,
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
            ["Beanstalk"] = true
        }
    },
    ["Buy Tools"] = {
        ["Enabled"] = false,
        ["Item"] = {
            ["Watering Can"] = true,
            ["Trowel"] = true,
            ["Recall Wrench"] = true,
            ["Basic Sprinkler"] = true,
            ["Advanced Sprinkler"] = true,
            ["Godly Sprinkler"] = true,
            ["Lightning Rod"] = true,
            ["Master Sprinkler"] = true,
            ["Favorite Tool"] = true
        }
    },
    ["Buy Eggs"] = {
        ["Enabled"] = true,
        ["Item"] = {
            ["Common Egg"] = false,
            ["Uncommon Egg"] = false,
            ["Rare Egg"] = false,
            ["Legendary Egg"] = false,
            ["Mythical Egg"] = false,
            ["Bug Egg"] = true
        }
    },
    ["Buy Events"] = {
        ["Enabled"] = true,
        ["Item"] = {
            ["Flower Seed Pack"] = true,
            ["Nectarine Seed"] = true,
            ["Hive Fruit Seed"] = true,
            ["Honey Sprinkler"] = true,
            ["Bee Egg"] = true,
            ["Bee Crate"] = false,
            ["Honey Comb"] = false,
            ["Bee Chair"] = false,
            ["Honey Torch"] = false,
            ["Honey Walkway"] = false
        }
    },
    ["Dont Buy Seed"] = {
        ["If Money More Than"] = 1000000, -- If we have money more than this, will not buying from Seed Name List
        ["Seed Name"] = {
            "Strawberry",  "Blueberry", "Tomato", "Corn", "Apple", "Carrot"
        }
    },
    ["Delete Planted Seed"] = {
        ["Enabled"] = true,
        ["Slot"] = {
            {slot = 200, min = 0},        -- if money 0 then using this slot
            {slot = 100, min = 1000000},  -- if money 1.000.000 then using this slot
            {slot = 50,  min = 10000000}, -- if money 10.000.000 then using this slot
        },
        ["Name Seed Delete"] = {
            "Strawberry",  "Blueberry", "Tomato", "Corn", "Apple", "Rose", "Foxglove"
        }
    }
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/kaitun.lua"))()
