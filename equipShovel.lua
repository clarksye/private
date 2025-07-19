local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local function getTool(name)
	for _, container in ipairs({Player.Backpack, Character}) do
		for _, tool in ipairs(container:GetChildren()) do
			if tool:IsA("Tool") and tool.Name == name then
				return tool
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(5)
		local current = Character:FindFirstChildOfClass("Tool")
		if not current or current.Name ~= "Shovel [Destroy Plants]" then
			local shovel = getTool("Shovel [Destroy Plants]")
			if shovel then
				Humanoid:EquipTool(shovel)
			end
		end
	end
end)
