local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create a remote event for the dash action if it doesn't already exist
local dashEvent = ReplicatedStorage:FindFirstChild("DashEvent")
if not dashEvent then
	dashEvent = Instance.new("RemoteEvent")
	dashEvent.Name = "DashEvent"
	dashEvent.Parent = ReplicatedStorage
end

-- Function to handle dashing
local function onDashFired(player, direction)
	local character = player.Character
	if character then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChild("Humanoid")

		if humanoidRootPart and humanoid then
			-- Ensure direction is relative to the world
			local velocityDirection = direction
			local dashSpeed = 75
			local dashDuration = 0.2

			-- Create and configure BodyVelocity
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = humanoidRootPart.CFrame:VectorToWorldSpace(velocityDirection * dashSpeed)
			bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
			bodyVelocity.Parent = humanoidRootPart

			-- Create and configure BodyGyro to maintain orientation
			local bodyGyro = Instance.new("BodyGyro")
			bodyGyro.CFrame = humanoidRootPart.CFrame
			bodyGyro.P = 3000
			bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
			bodyGyro.Parent = humanoidRootPart

			-- Remove BodyVelocity and BodyGyro after the dash duration
			game:GetService("Debris"):AddItem(bodyVelocity, dashDuration)
			game:GetService("Debris"):AddItem(bodyGyro, dashDuration)
		end
	end
end

-- Connect the dash event to the function
dashEvent.OnServerEvent:Connect(onDashFired)
