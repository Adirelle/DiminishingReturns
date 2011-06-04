local addon = DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('XPerl', function()

	local db = addon.db:RegisterNamespace('XPerl', {profile={
		['*'] = {
			enabled = true,
			iconSize = 24,
			direction = 'RIGHT',
			spacing = 2,
			anchorPoint = 'BOTTOMLEFT',
			relPoint = 'TOPLEFT',
			xOffset = 4,
			yOffset = 4,
		}
	}})

	local function ucfirst(s)
		return s:sub(1,1):upper()..s:sub(2)
	end

	addon:RegisterCommonFrames(function(unit)
		local refUnit = gsub(unit, "%d+$", "")
		local function GetDatabase() return db.profile[refUnit], db end
		addon:RegisterFrameConfig('XPerl: '..addon.L[refUnit], GetDatabase)
		return addon:RegisterFrame('XPerl_'..ucfirst(unit), function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end)

	hooksecurefunc('XPerl_SecureUnitButton_OnLoad', addon.CheckFrame)

	return 'unknown', GetAddonMetaData('XPerl', 'Version')
end)

