local addon = DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('Stuf', function()

	local db = addon.db:RegisterNamespace('StellarUF', {profile={
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
		addon:RegisterFrameConfig('STUF: '..addon.L[unit], GetDatabase)
		addon:RegisterFrame('Stuf.units.'..unit, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end)
	
	return 'unknown', GetAddonMetaData('Stuf', 'Version')

end)

