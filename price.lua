local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local guiLabel = player:WaitForChild("PlayerGui"):WaitForChild("BackpackGui").Backpack.Inventory.CategoryTemplate
local getFruitPrice = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("CalculatePlantValue"))

local function formatNumber(num)
	return tostring(math.floor(num)):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
end

local function updateLabel()
	local tool = character:FindFirstChildOfClass("Tool")
	local show = "Price : -"
	if tool then
		local ok, val = pcall(getFruitPrice, tool)
		if ok and typeof(val) == "number" then
			show = "Price : " .. formatNumber(val)
		else
			show = "Price : Error"
		end
	end
	guiLabel.Text = show
end

character.ChildAdded:Connect(function(child) if child:IsA("Tool") then task.defer(updateLabel) end end)
character.ChildRemoved:Connect(function(child) if child:IsA("Tool") then task.defer(updateLabel) end end)

updateLabel()
