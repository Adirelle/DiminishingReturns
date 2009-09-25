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

local db = PitBull4.db:RegisterNamespace('DiminishingReturns', {profile={
	target = defaults,
	focus = defaults,
}})

local function RegisterSingletonFrame(unit)
	local function GetDatabase() return db.profile[unit], db end
	addon:RegisterFrameConfig('PitBull4: '..addon.L[unit], GetDatabase)
	addon:RegisterFrame('PitBull4_Frames_'..unit, function(frame)
		return addon:SpawnFrame(frame, frame, GetDatabase)
	end)
end

RegisterSingletonFrame('target')
RegisterSingletonFrame('focus')

