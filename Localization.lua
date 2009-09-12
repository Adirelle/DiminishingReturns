local addon = DiminishingReturns
if not addon then return end

local locale = GetLocale()
local L = setmetatable({}, {__index = function(self, key)
	if key ~= nil then
		self[key] = tostring(key)
	end
	return tostring(key)
end})
addon.L = L

-- Category localization

local function SpellNames(...)
	local t = {}
	for i = 1, select('#', ...) do
		local v = select(i, ...)
		if type(v) == "number" then
			v = GetSpellInfo(v)
		end
		tinsert(t, tostring(v))
	end
	return table.concat(t, "/")
end

L["gouge_polymorph_sap"] = SpellNames(1776, 28271, 6770)
L["cheap_shot_pounce"] = SpellNames(1833, 9005)
L["silence"] = SpellNames(15487)
L["disarm"] = SpellNames(676)
L["cyclone"] = SpellNames(33786)
L["entrapment"] = SpellNames(19184)
L["frost_shock"] = SpellNames(8056)
L["earth_shock"] = SpellNames(8042)
L["hamstring"] = SpellNames(1715)
L["banish"] = SpellNames(18647)

L["stun"] = "Stun"
L["fear_charm_blind"] = "Fear/Charm/Blind"
L["sleep_freeze"] = "Sleep/Freeze"
L["root"] = "Root"
L["horror"] = "Horror"

