local addon = DiminishingReturns
if not addon then return end

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

	local db = addon.db:RegisterNamespace('ShadowedUnitFrames', {profile={
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
		local refUnit = gsub(unit, "%d+$", "")
		local function GetDatabase() return db.profile[refUnit], db end
		addon:RegisterFrameConfig('SUF: '..addon.L[refUnit], GetDatabase)
		addon:RegisterFrame('SUFUnit'..unit, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end)
		
	return state, version
end)

	
