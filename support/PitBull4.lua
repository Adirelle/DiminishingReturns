--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('PitBull4', function()
	--<GLOBALS
	local _G = _G
	local GetAddOnMetadata = _G.GetAddOnMetadata
	--GLOBALS>

	local db = addon.db:RegisterNamespace('PitBull4', {profile={
		['*'] = {
			enabled = true,
			iconSize = 24,
			direction = 'RIGHT',
			spacing = 2,
			anchorPoint = 'TOPLEFT',
			relPoint = 'BOTTOMLEFT',
			xOffset = 0,
			yOffset = -4,
		}
	}})

	addon:RegisterCommonFrames(function(unit)
		local function GetDatabase() return db.profile[unit], db end
		addon:RegisterFrameConfig('PitBull4: '..addon.L[unit], GetDatabase)
		addon:RegisterFrame('PitBull4_Frames_'..unit, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end)

	return 'supported', GetAddOnMetadata("PitBull4", "Version")
end)

