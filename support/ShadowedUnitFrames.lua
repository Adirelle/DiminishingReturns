local addon = DiminishingReturns
if not addon then return end

local db = addon.db:RegisterNamespace('ShadowedUnitFrames', {profile={
	iconSize = 24,
	direction = 'RIGHT',
	spacing = 2,
	anchorPoint = 'TOPLEFT',
	relPoint = 'BOTTOMLEFT',
	xOffset = 0,
	yOffset = -4,
}})

local function GetDatabase() 
	return db.profile, db
end

addon:RegisterFrameConfig('Shadowed Unit Frames', GetDatabase)

addon:RegisterFrame('SUFUnittarget', function(frame)
	return addon:SpawnFrame(frame, frame, GetDatabase)
end)
