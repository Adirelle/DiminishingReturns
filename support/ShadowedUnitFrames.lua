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

local db = ShadowUF.db:RegisterNamespace('DiminishingReturns', {profile={
	target = defaults,
	focus = defaults,
	arena = defaults, -- should find better one
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

-- ShadowedUF_Arena support
if IsAddonLoaded('ShadowedUF_Arena') then
	local function GetDatabase() return db.profile.arena, db end
	local function SpawnFrame(frame)
		return addon:SpawnFrame(frame, frame, GetDatabase)
	end
	addon:RegisterFrameConfig('SUF: '..L["Arena"], GetDatabase)
	for index = 1, 5 do
		addon:RegisterFrame('SUFHeaderarenaUnitButton'..index, SpawnFrame)
	end
end

