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
player.HatchSpeedTier.Value = 9999

-- rarity yang boleh digabung (bisa bertambah nanti)
local allowed = {
    [1] = true, -- Common
    [2] = true, -- Uncommon
    [3] = true,
    [4] = true,
    [5] = true,
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
		local pets = getPets:Invoke()              -- semua pet dimiliki
		local shiny = getShiny:Invoke()            -- pet shiny: [nama] = jumlah
		local pool = {}
		local index = {}

		-- Kumpulkan pet berdasarkan rarity
		for name, count in pairs(pets) do
			local rarity = PetInfo[name] and PetInfo[name].Rarity
			if not allowed[rarity] then continue end

			local shinyCount = shiny[name] or 0
			local fuseCount = count - shinyCount

			-- hanya masukkan ke fuse jika ada pet non-shiny tersisa
			if fuseCount > 0 then
				index[name] = 0
				for i = 1, fuseCount do
					index[name] += 1
					pool[rarity] = pool[rarity] or {}
					table.insert(pool[rarity], { Pet = name, Index = index[name] })
				end
			end
		end

		-- Fuse jika jumlah cukup (>= 5)
		for rarity, _ in ipairs(allowed) do
			local list = pool[rarity]
			if list and #list >= 5 then
				local args = {{}}
				for i = 1, 5 do
					table.insert(args[1], list[i])
				end
				fuseRemote:FireServer(unpack(args))
				break -- lakukan satu kali per loop
			end
		end
	end
end)
