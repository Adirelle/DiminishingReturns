--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('Blizzard_ArenaUI', function()
	--<GLOBALS
	local _G = _G
	local GetBuildInfo = _G.GetBuildInfo
	--GLOBALS>

	local db = addon.db:RegisterNamespace('Blizzard_ArenaUI', {profile={
		enabled = true,
		iconSize = 16,
		direction = 'LEFT',
		spacing = 2,
		anchorPoint = 'RIGHT',
		relPoint = 'LEFT',
		xOffset = -4,
		yOffset = -2,
	}})

	local function GetDatabase()
		return db.profile, db
	end

	addon:RegisterFrameConfig(addon.L['Blizzard: arena enemies'], GetDatabase)

	local function SetupFrame(frame)
		return addon:SpawnFrame(frame, frame, GetDatabase)
	end

	for i = 1,5 do
		addon:RegisterFrame('ArenaEnemyFrame'..i, SetupFrame)
	end

	return 'supported', GetBuildInfo()
end)

