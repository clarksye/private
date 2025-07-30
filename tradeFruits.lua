repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Task = loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/TaskController.luau"))()
local State = loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/StateController.luau"))()
local RateLimiter = loadstring(game:HttpGet("https://raw.githubusercontent.com/alienschub/alienhub/refs/heads/main/RateLimiter.luau"))()

Task.define("priority", "SeedPack", "high")

-- Modules
local PetListModule = require(game:GetService("ReplicatedStorage"):WaitForChild("Data").PetRegistry.PetList)
local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)

-- Global Shared Variables
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Hum = Character:WaitForChild("Humanoid")
local cachedPlayerData = nil

local settings = {
    ["Game"] = {
        ["Farm"] = {
            ["Self"] = nil,
            ["Can Plant"] = {},
            ["Eggs Point"] = {}
        },
        ["Player"] = {
            ["Backpack"] = {
                ["seedPack"] = {},
            },
            ["Data"] = {}
        }
    }
}

-- Function
local function getFarm()
    for _, farm in ipairs(workspace:WaitForChild("Farm"):GetChildren()) do
        local success, owner = pcall(function()
            return farm:WaitForChild("Important").Data.Owner.Value
        end)
        if success and owner == Player.Name then
            return farm
        end
    end
    return nil
end

local function getItemById(id)
    for _, container in ipairs({Player.Backpack, Player.Character}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    for key, value in pairs(tool:GetAttributes()) do
                        if value == id then
                            return tool
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function isAlreadyIn(lists, uuid)
    for _, list in ipairs(lists) do
        for _, v in ipairs(list) do
            if v.uuid == uuid then return true end
        end
    end
    return false
end

local function cleanToolFrom(t)
    for i = #t, 1, -1 do
        local tool = t[i].tool
        if not tool or not tool.Parent or (tool.Parent ~= Player.Backpack and not table.find(settings["Game"]["Player"]["Data"].equipedPets, t[i].uuid)) then
            table.remove(t, i)
        end
    end
end

-- Init
getgenv().loaded = true

-- Backpack
task.spawn(function()
    while task.wait(3) do
        local success, err = pcall(function()
            local data = DataService:GetData().InventoryData

            local backpack = settings["Game"]["Player"]["Backpack"]
            backpack.seedPack = {}
            for uuid, item in pairs(data) do
                local type = item.ItemType
                local data = item.ItemData
                local tool = getItemById(uuid)

                if type == "Seed Pack" then
                    table.insert(backpack.seedPack, {
                        tool = tool,
                        uuid = uuid,
                        name = data.Type,
                        amount = data.Uses
                    })
                end
            end
        end)
        if not success then
            warn("[Task Error: Backpack]", err)
        end
    end
end)

-- Open Seed Pack
task.spawn(function()
    while task.wait(2) do
        local success, err = pcall(function()
            local seedPack = settings["Game"]["Player"]["Backpack"].seedPack

            if #seedPack > 0 then
                Task.priority("SeedPack", function()
                    for _, pack in ipairs(seedPack) do
                        Hum:EquipTool(pack.tool)
                        task.wait(1)

                        for i = 1, pack.amount do
                            pack.tool:Activate()
                            task.wait(3)
                        end
                    end
                end, {})
            end
        end)
        if not success then
            warn("[Task Error: Open Seed Pack]", err)
        end
    end
end)
