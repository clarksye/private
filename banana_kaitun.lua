repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "0c35250991e58f6cd19192bc" -- key
getgenv().Config = {
    ["Buy Egg"] = {
        ["Select Egg"] = {
            ["Night Egg"] = true,
            ["Bug Egg"] = true,
            ["Mythical Egg"] = true,
            ["Legendary Egg"] = false,
        }
    },
    ["Delete Pet"] = {
        ["Enabled"] = false,
        ["Pet Dont Delete"] = {""}
    },
    ["dont Buy Seed low Price"] = {
        ["Enabled"] = true, 
        ["Money"] = 3000,
    },
    ["Auto Delete Seed Planted"] = {
        ["Enabled"] = false,
        ["Auto Delete Seed Low Price"] = true,
        ["Slot"] = 500,
        ["Name Seed Delete"] = {
            "",
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
            ["Enabled"] = true,
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
