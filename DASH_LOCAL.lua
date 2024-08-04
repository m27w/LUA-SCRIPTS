local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local dashEvent = ReplicatedStorage:WaitForChild("DashEvent")
local player = Players.LocalPlayer

local dashCooldown = 5
local canDash = true
local directionPressed = {}

-- Direction mapping
local directionMap = {
	[Enum.KeyCode.W] = Vector3.new(0, 0, -1), -- Forward
	[Enum.KeyCode.A] = Vector3.new(-1, 0, 0), -- Left
	[Enum.KeyCode.S] = Vector3.new(0, 0, 1),  -- Backward
	[Enum.KeyCode.D] = Vector3.new(1, 0, 0)   -- Right
}

-- Determine the dash direction based on key input
local function getDashDirection()
	local direction = Vector3.new(0, 0, 0)

	for keyCode, dir in pairs(directionMap) do
		if directionPressed[keyCode] then
			direction = direction + dir
		end
	end

	if direction.Magnitude > 0 then
		direction = direction.Unit -- Normalize to ensure consistent speed
	end

	return direction
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.Q then
		if canDash then
			local direction = getDashDirection()
			if direction.Magnitude > 0 then
				canDash = false
				dashEvent:FireServer(direction)

				-- Cooldown
				task.delay(dashCooldown, function()
					canDash = true
				end)
			end
		end
	elseif directionMap[input.KeyCode] then
		directionPressed[input.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if directionMap[input.KeyCode] then
		directionPressed[input.KeyCode] = nil
	end
end)
