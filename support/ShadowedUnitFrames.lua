--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('ShadowedUnitFrames', function()
	--<GLOBALS
	local _G = _G
	local format = _G.format
	local GetAddOnMetadata = _G.GetAddOnMetadata
	local strmatch = _G.strmatch
	local tonumber = _G.tonumber
	--GLOBALS>

	local state, version = 'unknown', GetAddOnMetadata('ShadowedUnitFrames', 'Version')
	local major = tonumber(strmatch(version, '^v?(%d+%.?%d*)'))
	if major then
		if major >= 2 then
			state = 'supported'
		else
			return 'unsupported', version
		end
	end

	local db = addon.db:RegisterNamespace('ShadowedUnitFrames', {profile={
		['*'] = {
			enabled = true,
			iconSize = 16,
			direction = 'RIGHT',
			spacing = 2,
			anchorPoint = 'TOPLEFT',
			relPoint = 'TOPRIGHT',
			xOffset = 4,
			yOffset = -4,
		}
	}})

	addon:RegisterCommonFrames(function(unit)
		local refUnit, index = strmatch(unit, "^(%w-)(%d*)$")
		local name = index ~= "" and format("SUFHeader%sUnitButton%s", refUnit, index) or format("SUFUnit%s", refUnit)
		local function GetDatabase() return db.profile[refUnit], db end
		addon:RegisterFrameConfig('SUF: '..addon.L[refUnit], GetDatabase)
		addon:RegisterFrame(name, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end)

	return state, version
end)


