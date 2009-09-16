local addon = DiminishingReturns
if not addon then return end

local db = addon.db:RegisterNamespace('Gladius', {profile={
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
	return addon:SpawnFrame(frame:GetParent(), frame, GetDatabase)
end

for i = 1,5 do
	addon:RegisterFrame('GladiusButton'..i, SetupFrame)
end

hooksecurefunc(Gladius, 'UpdateAttribute', function(gladius, unit)
	addon:CheckFrame(gladius.buttons[unit].secure)
end)
