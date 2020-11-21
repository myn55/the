-- Author: Coronhaus
local shared = require(script.Parent:WaitForChild('shared'))
local ChatCommands = shared.RemoteEvents:WaitForChild('ChatCommands')

local ActivateCommand = ChatCommands:WaitForChild('ActivateCommand')

local commands = {
	-- Gives equipped tool to specified player
	giveitem = function(player, args)
		local char = player.Character
		local tool = char:FindFirstChildWhichIsA('Tool')
		if tool then
			local p2 = args[1]
			if p2 and game:GetService('Players'):FindFirstChild(p2) then
				tool.Parent = game:GetService('Players')[p2].Backpack
			end
		end
	end;
	
	-- Pays certain amount of money to a player
	pay = function(player, args)
		local stats = player.leaderstats
		local money = stats.Money
		local amount = args[2]; amount = tonumber(amount)
		if amount and amount <= money.Value then
			local p2 = args[1]
			if game:GetService('Players'):FindFirstChild(p2) then
				money.Value = money.Value - amount
				money = game:GetService('Players')[p2].leaderstats.Money
				money.Value = money.Value + amount
			end
		end
	end;
}

ActivateCommand.Event:Connect(function(player, args)
	print('$chatcommand processing... (', player, args[1], ')')
	local command = args[1]
	table.remove(args, 1)
	commands[command](player, args)
end)
