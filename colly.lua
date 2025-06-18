-- Global Shared Variables
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dropRemote = ReplicatedStorage:WaitForChild("Remotes").Drop
local onAreaButtonRemote = ReplicatedStorage:WaitForChild("Remotes").OnAreaButton
local fuseRemote = ReplicatedStorage:WaitForChild("Remotes").FusePets
local getPets = player:WaitForChild("GetPets")
local getShiny = player:WaitForChild("GetShinies")
local PetInfo = require(ReplicatedStorage:WaitForChild("DB").Pets)

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
    [7] = false,
}

task.spawn(function()
    while task.wait(10) do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimDailyEgg"):FireServer()
    end
end)

-- Task: Auto Collect Drops
task.spawn(function()
	while task.wait(1) do
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

-- Task: Auto Change Area When QuestArea Changes
task.spawn(function()
	local questArea = player:WaitForChild("QuestArea")
	local lastValue = -1 -- Menyimpan area terakhir yang dikirim

	while task.wait(1) do
		-- Klaim quest reward setiap detik
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes").ClaimQuestReward:FireServer()

		local current = questArea.Value
		local target = current > 0 and current or 1 -- Jika current 0, fallback ke area 1

		-- Hanya kirim jika berbeda dari sebelumnya
		if target ~= lastValue then
			lastValue = target
			onAreaButtonRemote:FireServer(target)
		end
	end
end)

-- Task: Auto Fuse Pets (hindari shiny)
task.spawn(function()
	while task.wait(0.2) do
		local pets = getPets:Invoke()
		local shiny = getShiny:Invoke()

		local pool, nameMap, index = {}, {}, {}

		for name, count in pairs(pets) do
			local rarity = PetInfo[name] and PetInfo[name].Rarity
			if not allowed[rarity] then continue end

			local fuseCount = count - (shiny[name] or 0)
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
