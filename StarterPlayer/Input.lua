-- Author: Coronhaus
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

LocalPlayer.CharacterAdded:connect(function(c)
	Character = c
end)

UIS.InputBegan:connect(function(input, gp)
	
end)

UIS.InputEnded:connect(function(input, gp)
	
end)

UIS.JumpRequest:connect(function()
	
end)
