-- Author: Coronhaus
-- Master server script

-- Load modules
local modules = {}
for _, v in pairs(script.Parent.ModuleScripts:GetChildren()) do
	if v:IsA("ModuleScript") then
		print('$serve require', v.Name)
		modules[v.Name] = require(v)
	end
end

-- Initialize modules
for name, module in pairs(modules) do
	if not module.__init then
		module.init()
		print('$server init', name)
	end
end

print('$server all modules initialized in queue')
