--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('Gladius', function()
	--<GLOBALS
	local _G = _G
	local GetAddOnMetadata = _G.GetAddOnMetadata
	local hooksecurefunc = _G.hooksecurefunc
	local strmatch = _G.strmatch
	--GLOBALS>

	local version = GetAddOnMetadata("Gladius", "Version")
	local state = 'unknwon'
	if strmatch(version, '^r(%d+)$') then
		if version >= 'r20101214230855' then
			-- First 2.0 release
			state = 'supported'
		end
	elseif strmatch(version, '^v1%.%d') then
		-- 1.x is not supported anymore
		return 'unsupported', version
	end

	local db = addon.db:RegisterNamespace('Gladius', {profile={
		enabled = true,
		iconSize = 32,
		direction = 'LEFT',
		spacing = 2,
		anchorPoint = 'TOPRIGHT',
		relPoint = 'TOPLEFT',
		xOffset = -10,
		yOffset = 0,
	}})

	local function GetDatabase()
		return db.profile, db
	end

	addon:RegisterFrameConfig('Gladius', GetDatabase)

	local function SetupFrame(frame)
		addon:Debug('Gladius:SetupFrame', frame)
		return addon:SpawnFrame(frame:GetParent(), frame, GetDatabase)
	end

	local needHook = false
	for i = 1,5 do
		if not addon:RegisterFrame('GladiusButtonarena'..i, SetupFrame) then
			needHook = true
		end
	end

	if needHook then
		-- GLOBALS: Gladius
		hooksecurefunc(Gladius, 'CreateButton', function(gladius, unit)
			addon:Debug('Gladius:CreateButton', unit)
			addon.CheckFrame(gladius.buttons[unit].secure)
		end)
	end

	return state, version
end)

