getgenv().Config = {
    ["Place Eggs"] = {
        ["Enabled"] = true,
        ["Order By"] = {
            "Common Egg", "Common Summer Egg", "Uncommon Egg", "Rare Egg", "Rare Summer Egg", "Legendary Egg", "Night Egg", "Bee Egg", "Dinosaur Egg", "Oasis Egg", "Primal Egg", "Mythical Egg", "Paradise Egg", "Bug Egg"
        },
        ["Item"] = {
            ["Common Egg"] = true,
            ["Common Summer Egg"] = true,
            ["Uncommon Egg"] = true,
            ["Rare Egg"] = true,
            ["Rare Summer Egg"] = true,
            ["Legendary Egg"] = true,
            ["Night Egg"] = true,
            ["Bee Egg"] = true,
            ["Dinosaur Egg"] = true,
            ["Oasis Egg"] = true,
            ["Primal Egg"] = true,
            ["Mythical Egg"] = true,
            ["Paradise Egg"] = true,
            ["Bug Egg"] = true
        }
    },
    ["Sell Pets"] = {
        ["Enabled"] = true,
        ["Level"] = 45, -- Jual semua yang di bawah level
        ["Keep"] = { -- List pet yang tidak ingin di jual
            ["Type"] = {
                -- Mutation Type
                "Butterfly", "Dragonfly", "Disco Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus",
                -- Fruits
                "Moon Cat", "Blood Hedgehog", "Toucan",
                -- Eggs
                "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
                -- Target Pet
                "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk",
                -- Steal
                "Raccoon"
            },
            ["Mutation"] = {
                ["a"] = { -- Shocked
                    -- Mutation Type
                    "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus",
                    -- Fruits
                    "Moon Cat", "Cat", "Orange Tabby", "Pig", "Cow", "Sea Otter", "Turtle", "Caterpillar", "Praying Mantis", "Giant Ant", "Red Giant Ant", "Triceratops", "Raptor", "Blood Hedgehog", "Toucan",
                    -- Eggs
                    "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
                    -- Target Pet
                    "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk",
                    -- Steal
                    "Raccoon"
                },
                ["b"] = { -- Golden
                    -- Mutation Type
                    "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus",
                    -- Fruits
                    "Moon Cat", "Cat", "Orange Tabby", "Pig", "Cow", "Sea Otter", "Turtle", "Caterpillar", "Praying Mantis", "Giant Ant", "Red Giant Ant", "Triceratops", "Raptor", "Blood Hedgehog", "Toucan",
                    -- Eggs
                    "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
                    -- Target Pet
                    "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk",
                    -- Steal
                    "Raccoon"
                },
                ["c"] = { -- Rainbow
                    -- Mutation Type
                    "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus",
                    -- Fruits
                    "Moon Cat", "Cat", "Orange Tabby", "Pig", "Cow", "Sea Otter", "Turtle", "Caterpillar", "Praying Mantis", "Giant Ant", "Red Giant Ant", "Triceratops", "Raptor", "Blood Hedgehog", "Toucan",
                    -- Eggs
                    "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
                    -- Target Pet
                    "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk",
                    -- Steal
                    "Raccoon"
                },
                ["e"] = { -- Windy
                    -- Mutation Type
                    "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus",
                },
                ["f"] = { -- Frozen
                    -- Mutation Type
                    "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus",
                },
                ["i"] = { -- Mega
                    -- Mutation Type
                    "Butterfly", "Dragonfly", "Disco Bee", "Bee", "Honey Bee", "Petal Bee", "Queen Bee", "Bear Bee", "Sea Turtle", "Scarlet Macaw", "Hyacinth Macaw", "Pterodactyl", "Polar Bear", "Cooked Owl", "Chicken Zombie", "Fennec Fox", "T-Rex", "Spinosaurus",
                    -- Fruits
                    "Moon Cat", "Cat", "Orange Tabby", "Pig", "Cow", "Sea Otter", "Turtle", "Caterpillar", "Praying Mantis", "Giant Ant", "Red Giant Ant", "Triceratops", "Raptor", "Blood Hedgehog", "Toucan",
                    -- Eggs
                    "Blood Kiwi", "Ostrich", "Brontosaurus", "Bald Eagle",
                    -- Target Pet
                    "Capybara", "Blood Owl", "Cooked Owl", "Owl", "Night Owl", "Moth", "Iguanodon", "Tarantula Hawk",
                    -- Steal
                    "Raccoon"
                },
                ["n"] = { -- Ascended
                    "ALL"
                },
            }
        }
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/pets.lua"))()
