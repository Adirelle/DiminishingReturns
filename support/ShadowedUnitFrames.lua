local addon = DiminishingReturns
if not addon then return end

local defaults = {
	enabled = true,
	iconSize = 24,
	direction = 'RIGHT',
	spacing = 2,
	anchorPoint = 'TOPLEFT',
	relPoint = 'BOTTOMLEFT',
	xOffset = 0,
	yOffset = -4,
}

local db = addon.db:RegisterNamespace('ShadowedUnitFrames', {profile={
	target = defaults,
	focus = defaults,
}})

local function RegisterFrame(unit)
	local function GetDatabase() return db.profile[unit], db end
	addon:RegisterFrameConfig('SUF: '..addon.L[unit], GetDatabase)
	addon:RegisterFrame('SUFUnit'..unit, function(frame)
		return addon:SpawnFrame(frame, frame, GetDatabase)
	end)
end

RegisterFrame('target')
RegisterFrame('focus')

