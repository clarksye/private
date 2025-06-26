local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local PlayerGui = player:WaitForChild("PlayerGui")
local guiLabel = PlayerGui:WaitForChild("BackpackGui").Backpack.Inventory.CategoryTemplate
local searchBox = PlayerGui.BackpackGui.Backpack.Inventory.Search.TextBox
local getFruitPrice = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("CalculatePlantValue"))

local function formatNumber(num)
	return tostring(math.floor(num)):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
end

-- === Menampilkan harga tool yang sedang dipegang ===
local function updateEquippedLabel()
	local tool = character:FindFirstChildOfClass("Tool")
	local show = "Price : -"
	if tool and tool:GetAttribute("d") and not tool:GetAttribute("PetType") then
		local ok, val = pcall(getFruitPrice, tool)
		if ok and typeof(val) == "number" then
			show = "Price : " .. formatNumber(val)
		else
			show = "Price : Error"
		end
	end
	guiLabel.Text = show
end

character.ChildAdded:Connect(function(child)
	if child:IsA("Tool") then task.defer(updateEquippedLabel) end
end)
character.ChildRemoved:Connect(function(child)
	if child:IsA("Tool") then task.defer(updateEquippedLabel) end
end)

updateEquippedLabel()

-- === Update total value semua buah setiap 3 detik ===
task.spawn(function()
	while true do
		local total = 0
		for _, container in ipairs({player.Backpack, player.Character}) do
			for _, tool in ipairs(container:GetChildren()) do
				if tool:IsA("Tool") and tool:GetAttribute("d") and not tool:GetAttribute("PetType") then
					local ok, val = pcall(getFruitPrice, tool)
					if ok and typeof(val) == "number" then
						total += val
					end
				end
			end
		end
		searchBox.PlaceholderText = "Total Fruit Value: " .. formatNumber(total)
		task.wait(3)
	end
end)
