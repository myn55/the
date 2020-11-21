-- Author: Coronhaus
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RemoteEvents = ReplicatedStorage:WaitForChild('Remotes')
local StarterGui = RemoteEvents:WaitForChild('StarterGui')

local SetCore 			= StarterGui:WaitForChild('SetCore')
local SetCoreGuiEnabled	= StarterGui:WaitForChild('SetCoreGuiEnabled')

SetCore.OnClientEvent:connect(function(core, ...)
	local tuple = {...}
	game:GetService('StarterGui'):SetCore(core, unpack(tuple))
end)

SetCoreGuiEnabled.OnClientEvent:connect(function(core, bool)
	game:GetService('StarterGui'):SetCoreGuiEnabled(core, bool)
end)
