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

