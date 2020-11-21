-- Author: Coronhaus
_G.Enums = {}

function load(g, t)
	for k, v in next, t do
		_G.Enums[k] = v
	end
end

load(_G.Enums, {
	DamageTypes = {
		Normal = {};
		Burn = {};
		Bleed = {};
		Cripple = {};
		Stun = {};
		Blind = {};
	};
})

setmetatable(_G.Enums, {__index = _G.Enums})
