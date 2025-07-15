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
            "Dragonfly", "Disco Bee", "Raccoon", "Queen Bee", "Cooked Owl", "T-Rex", "Toucan", "Ostrich", "Triceratops", "Brontosaurus", "Capybara", "Starfish", "Blood Owl",
            "Bald Eagle","Moon Cat", "Scarlet Macaw", "Blood Hedgehog", "Blood Kiwi", "Butterfly", "Pterodactyl"
        }
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/pets.lua"))()
