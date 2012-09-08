--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

--<GLOBALS
local _G = _G
local GetAddOnInfo = _G.GetAddOnInfo
local GetAddOnMetadata = _G.GetAddOnMetadata
local geterrorhandler = _G.geterrorhandler
local GetNumAddOns = _G.GetNumAddOns
local loadstring = _G.loadstring
--GLOBALS>

for index = 1, GetNumAddOns() do
	local callback = GetAddOnMetadata(index, 'X-DiminishingReturns-Callback')
	if callback then
		local parent, version = GetAddOnInfo(index), GetAddOnMetadata(index, 'Version')
		local func, msg = loadstring(callback, parent.." X-DiminishingReturns-Callback")
		addon:Debug('X-DiminishingReturns-Callback for', parent, ' : ', callback)
		if func then
			addon:RegisterAddonSupport(parent, function()
				func()
				return 'supported', version
			end)
		else
			geterrorhandler()(msg)
		end
	end
end
