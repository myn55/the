-- Author: Coronhaus
local RunService = game:GetService('RunService')

local ServerAge = script.Parent
local age = ServerAge:WaitForChild('Age')

RunService.Heartbeat:connect(function()
	local seconds = workspace.DistributedGameTime
	age.Text = (seconds-(seconds%1))..' seconds'
end)
