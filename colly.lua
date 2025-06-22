-- getgenv().Config["Auto Collect"] = false
-- getgenv().Config["Auto Hatch"] = false
-- getgenv().Config["Auto Collect Hidden"] = false
-- getgenv().Config["Auto Quest"] = false
-- getgenv().Config["Quest Lock Area"] = 8
-- getgenv().Config["Auto Equip Best"] = false
-- getgenv().Config["Auto Fuse"] = false
-- getgenv().Config["Fuse Shiny"] = false
-- getgenv().Config["Auto Rebirth"] = false
-- getgenv().Config["Auto Exotics"] = false


if getgenv().Config then return end

getgenv().Config = {
    ["Auto Collect"] = true,
    ["Auto Hatch"] = true,
    ["Auto Collect Hidden"] = true,
    ["Auto Quest"] = true,
    ["Quest Lock Area"] = 6,
    ["Auto Equip Best"] = true,
    ["Auto Fuse"] = true,
    ["Fuse Shiny"] = true,
    ["Auto Rebirth"] = true,
    ["Auto Exotics"] = false,
}

-- Global Shared Variables
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local playerScripts = player:WaitForChild("PlayerScripts")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dropRemote = ReplicatedStorage:WaitForChild("Remotes").Drop
local onAreaButtonRemote = ReplicatedStorage:WaitForChild("Remotes").OnAreaButton
local equipBestRemote = ReplicatedStorage:WaitForChild("Remotes").EquipBest
local fuseRemote = ReplicatedStorage:WaitForChild("Remotes").FusePets
local selectPrimalPetRemote = ReplicatedStorage:WaitForChild("Remotes").SelectPrimalPet
local getPets = player:WaitForChild("GetPets")
local getShiny = player:WaitForChild("GetShinies")
local PetInfo = require(ReplicatedStorage:WaitForChild("DB").Pets)

local config = getgenv().Config

-- -- Destroy Hatch Egg
local hatcher = game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
if hatcher and hatcher:FindFirstChild("Hatcher") then
	hatcher.Hatcher:Destroy()
end

-- Init
player.Magnet.Value = 99999
player.Speed.Value = 100
player.HatchSpeedTier.Value = 999

-- rarity yang boleh digabung (bisa bertambah nanti)
local allowed = {
    [1] = true, -- Common
    [2] = true, -- Uncommon
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
}

task.spawn(function()
    while task.wait(10) do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimDailyEgg"):FireServer()
    end
end)

-- Task: Auto Collect Drops
task.spawn(function()
	while task.wait(3) do
        if not config["Auto Collect"] then continue end
		local dropIDs = {}

		for _, drop in ipairs(playerScripts:GetChildren()) do
			if drop:FindFirstChild("Gold") and drop:FindFirstChild("ID") then
				table.insert(dropIDs, drop.ID.Value)
			end
		end

		if #dropIDs > 0 then
			dropRemote:FireServer(dropIDs)
		end
	end
end)

-- Task: Auto Hatch Eggs
task.spawn(function()
    while task.wait(1) do
        if not config["Auto Hatch"] then continue end

        for _, checkmark in ipairs(player.PlayerGui.ScreenGui.Main.Left.Checklist:GetChildren()) do
            local name = tonumber(checkmark.Name)
            if name then
                while not checkmark.Checkmark.Check.Visible or name == 8 do
                    if not config["Auto Hatch"] then break end

                    local rarity = (name > 4 and 4 or name)
                    rarity = (rarity == 4 and player.Gold.Value < 2000000) and 3 or rarity

                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyEgg"):FireServer(rarity)
                    task.wait(0.5)
                end
            end
        end
    end
end)

-- Task: Auto Collect Hidden Eggs
task.spawn(function()
    local hiddenEggs = workspace:WaitForChild("HiddenEggs")
    local unlockedArea = player:WaitForChild("UnlockedArea")
    local lastUnlock = 0

    while task.wait(5) do
        if not config["Auto Collect Hidden"] then continue end

        if lastUnlock ~= unlockedArea.Value then
            lastUnlock = unlockedArea.Value
            for _, descendant in ipairs(hiddenEggs:GetDescendants()) do
                if descendant:IsA("TouchTransmitter") then
                    local part = descendant.Parent
                    if part and part:IsA("BasePart") then
                        firetouchinterest(rootPart, part, 0)
                        task.wait()
                        firetouchinterest(rootPart, part, 1)
                    end
                end
            end
        end
    end
end)

-- Task: Quest Auto Change Area When QuestArea Changes
task.spawn(function()
	local questArea = player:WaitForChild("QuestArea")
    local unlockedArea = player:WaitForChild("UnlockedArea")
	local lastValue = -1 -- Menyimpan area terakhir yang dikirim

	while task.wait(1) do
        if not config["Auto Quest"] or config["Auto Exotics"] then continue end
        
		-- Klaim quest reward setiap detik
        if player.QuestGoal.Value == player.QuestProgress.Value then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes").ClaimQuestReward:FireServer()
            task.wait(1)
        end

		local current = questArea.Value
		local target = current > 0 and current or 1 -- Jika current 0, fallback ke area 1

        local lockArea = config["Quest Lock Area"]
        if typeof(lockArea) == "number" then
			-- Jika sudah unlocked dan pet belum berada di area itu
			if lockArea <= unlockedArea.Value and current ~= lockArea then
				target = lockArea
			end
		end
        
		-- Hanya kirim jika berbeda dari sebelumnya
		if target ~= lastValue then
			lastValue = target
			onAreaButtonRemote:FireServer(target)
		end
	end
end)

-- Task: Auto EquipBest pet
task.spawn(function()
    while task.wait(3) do
        if not config["Auto Equip Best"] then continue end

        local petEquipped = player.NumEquipped.Value
        local petSlot = player.PetSlotsUnlocked.Value
        local petCount = player.TotalPets.Value
        if petSlot > petEquipped and petCount >= petSlot then
            equipBestRemote:FireServer()
            task.wait(1)
        end
    end
end)

-- Task: Auto Fuse Pets (hindari shiny jika tidak diizinkan)
task.spawn(function()
	while task.wait(1) do
		if not config["Auto Fuse"] then continue end

		local pets = getPets:Invoke()
		local shiny = getShiny:Invoke()
		local allowShiny = config["Fuse Shiny"]

		local pool, nameMap, index = {}, {}, {}

		for name, count in pairs(pets) do
			local rarity = PetInfo[name] and PetInfo[name].Rarity
			if not allowed[rarity] then continue end

			-- Kurangi shiny jika tidak diizinkan
			local fuseCount = allowShiny and count or (count - (shiny[name] or 0))
			if fuseCount <= 0 then continue end

			index[name] = 0
			for i = 1, fuseCount do
				index[name] += 1
				local entry = { Pet = name, Index = index[name] }

				-- Simpan pet berdasarkan rarity
				pool[rarity] = pool[rarity] or {}
				table.insert(pool[rarity], entry)

				-- Simpan juga berdasarkan nama pet (khusus rarity 6+)
				nameMap[rarity] = nameMap[rarity] or {}
				nameMap[rarity][name] = nameMap[rarity][name] or {}
				table.insert(nameMap[rarity][name], entry)
			end
		end

		-- Urutkan rarity secara ascending
		local sorted = {}
		for rarity in pairs(allowed) do
			table.insert(sorted, rarity)
		end
		table.sort(sorted)

		for _, rarity in ipairs(sorted) do
			if rarity >= 6 then
				-- Rarity tinggi: hanya gabungkan pet dengan nama yang sama, butuh 3
				for name, list in pairs(nameMap[rarity] or {}) do
					if #list >= 3 then
						fuseRemote:FireServer({ unpack(list, 1, 3) })
						break
					end
				end
			else
				-- Rarity rendah: cukup 5 pet dari rarity sama
				local list = pool[rarity]
				if list and #list >= 5 then
					fuseRemote:FireServer({ unpack(list, 1, 5) })
					break
				end
			end
		end
	end
end)

-- Task: Auto Rebirth
task.spawn(function()
    while task.wait(5) do
        if not config["Auto Rebirth"] then continue end

        if player.NumDiscovered.Value ~= 240 then continue end
        -- Fire semua proximityprompt di dalam Fires
        for _, fire in ipairs(workspace.Environment.Cave.Alter.Fires:GetChildren()) do
            local prompt = fire:FindFirstChild("ProxPart") and fire.ProxPart:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
                task.wait(0.4)
            end
        end

        -- Fire proximityprompt utama untuk rebirth
        local mainPrompt = workspace.Environment.Cave.Alter:FindFirstChild("ProxPart") and workspace.Environment.Cave.Alter.ProxPart:FindFirstChildWhichIsA("ProximityPrompt")
        if mainPrompt then
            fireproximityprompt(mainPrompt)
            task.wait(3)
        end

        -- Select pet (param 2 is index pet from that rarity)
        selectPrimalPetRemote:FireServer("Primal_Prodigious", 2)
        task.wait(1)
        selectPrimalPetRemote:FireServer("Primal_Ascended", 1)
        task.wait(1)
    end
end)

-- Task: Auto Exotics crystal
task.spawn(function()
    local Crystals = workspace:WaitForChild("Crystals")

	while task.wait(1) do
        if not config["Auto Exotics"] then continue end

		for _, area in pairs(Crystals:GetChildren()) do
			if not area:IsA("Folder") then continue end
            local current = tonumber(area.Name:match("%d+"))
            local unlocked = player.UnlockedArea.Value
            if not current or current > unlocked then continue end

			for _, model in pairs(area:GetChildren()) do
				if model:IsA("Model") then
					-- Teleport ke posisi pivot dari model
					rootPart.CFrame = model:GetPivot() + Vector3.new(0, 5, 0)
					onAreaButtonRemote:FireServer(current)
                    task.wait(0.3)
					equipBestRemote:FireServer()
			        repeat task.wait(0.1) until not model:IsDescendantOf(area)
				end
			end
		end
	end
end)
