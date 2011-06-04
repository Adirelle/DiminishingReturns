local addon = DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('ag_UnitFrames', function()

	local db = addon.db:RegisterNamespace('ag_UnitFrames', {profile={
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
		addon:RegisterFrameConfig('aUF: '..addon.L[refUnit], GetDatabase)
		addon:RegisterFrame('aUF'..unit, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end)

	return 'unknown', GetAddonMetaData('ag_UnitFrames', 'Version')	
end)

