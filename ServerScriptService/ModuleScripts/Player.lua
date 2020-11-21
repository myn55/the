-- Author: Coronhaus
local DataStore = game:GetService('DataStoreService')
local PlayerMoney = DataStore:GetDataStore('PlayerMoney')
local PlayerAbility = DataStore:GetDataStore('PlayerAbility')

local ServerStorage = game:GetService('ServerStorage')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RemoteEvents = ReplicatedStorage:WaitForChild('Remotes')

local ChatCommands 	= RemoteEvents:WaitForChild('ChatCommands')
local ActivateCommand 	= ChatCommands:WaitForChild('ActivateCommand')

local StarterGui	= RemoteEvents:WaitForChild('StarterGui')
local SetCore			= StarterGui:WaitForChild('SetCore')
local SetCoreGuiEnabled	= StarterGui:WaitForChild('SetCoreGuiEnabled')

local players = game:GetService('Players')
local banned = {}

local module = {__init = false}

local function DataStoreSave(ds, k, v)
	local s = pcall(function()
		ds:SetAsync(k, v)
	end)
	
	if s then
		print('$datastore success at saving', ds, '('..k..', '..v..')')
	else
		print('$datastore failure at saving', ds, '('..k..', '..v..')')
	end
end
--------------------------------------------------------------------------------

function playerAdded(p)
	print('$player added:', p.Name, p.UserId)
	SetCore:FireAllClients('ChatMakeSystemMessage', {
		Text = p.Name..' has joined the game.';
		Color = Color3.fromRGB(249, 255, 124);
	})
	SetCoreGuiEnabled:FireClient(p, Enum.CoreGuiType.Health, false)
	SetCoreGuiEnabled:FireClient(p, Enum.CoreGuiType.EmotesMenu, false)
	
	-- Kick players in the ban list
	for _, v in pairs(banned) do
		if p.UserId == v or p.Name == v then
			p:Kick('You are on the blacklist')
			return
		end
	end
	
	-- Set leaderboard stats
	local md = Instance.new('Folder', p)
	md.Name = 'leaderstats'
	
	local moneyTag = Instance.new('IntValue')
	moneyTag.Name = 'Money'
	moneyTag.Value = PlayerMoney:GetAsync(p.UserId) or 200
	moneyTag.Parent = md
	
	-- Listen to each stat value and save the new value to the datastore
	for _, v in pairs(md:GetChildren()) do
		v.Changed:connect(function()
			print('$playerstats', v, 'value changed to', v.Value)
			print('$playerstats saving...')
			DataStoreSave(DataStore:GetDataStore('Player'..v.Name), p.UserId, v.Value)
		end)
	end
end

function characterAdded(c)
	print('$character loaded:', c)
	
	local ability = ServerStorage.Abilities.Ability
	ability = ability:Clone()
	ability.Parent = c; ability.Disabled = false
end

function playerChatted(p, msg, r)
	print('$player chatted:', p, msg, r)
	
	-- Check if player message is a command
	if not r and msg:match('^!%a+') then
		print('$chatcommand:', p, msg)
		msg = msg:sub(2, #msg)
		local args = msg:split(' ')
		ActivateCommand:Fire(p, args)
	end
end

function playerRemoved(p)
	print('$player removed:', p.Name, p.UserId)
	SetCore:FireAllClients('ChatMakeSystemMessage', {
		Text = p.Name..' has left the game.';
		Color = Color3.fromRGB(249, 255, 124);
	})
	
	-- Save stats on leave
	print('$playerstats saving...')
	local leaderstats = p.leaderstats
	local _stats = leaderstats:GetChildren()
	for _, v in pairs(_stats) do
		DataStoreSave('Player'..v.Name, p.UserId, v.Value)
	end
end

function module.init()
	module.__init = true
	players.PlayerAdded:connect(function(p)
		playerAdded(p)
		p.CharacterAdded:connect(characterAdded)
		p.Chatted:connect(function(msg ,r)
			playerChatted(p, msg, r)
		end)
	end)
	players.PlayerRemoving:connect(playerRemoved)
end

return module
