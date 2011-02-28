local addon = DiminishingReturns
if not addon then return end

local	db
	
addon:RegisterAddonSupport('ShadowedUnitFrames', function()

	local state, version = 'unknown', GetAddonMetaData('ShadowedUnitFrames', 'Version')
	local major = tonumber(strmatch(version, '^v?(%d+%.?%d*)'))
	if major then
		if major >= 2 then
			state = 'supported'
		else
			return 'unsupported', version
		end
	end

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

	db = addon.db:RegisterNamespace('ShadowedUnitFrames', {profile={
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
	for index = 1, 5 do
		RegisterFrame('arena'..index)
	end
		
	return state, version
end)

	
