local addon = DiminishingReturns
if not addon then return end

-- FrameXML is a internal fake to have this working like other support
addon:RegisterAddonSupport('FrameXML', function()

	local topFrameDefaults = {
		direction = 'BOTTOM',
		anchorPoint = 'TOPLEFT',
		relPoint = 'TOPRIGHT',
		xOffset = -25,
		yOffset = -20,
	}
	
	local leftFrameDefaults = {
		direction = 'RIGHT',
		anchorPoint = 'TOPLEFT',
		relPoint = 'BOTTOMLEFT',
		xOffset = 14,
		yOffset = 28,
	}
	
	local db = addon.db:RegisterNamespace('Blizzard', {profile={
		['**'] = {
			enabled = true,
			iconSize = 16,
			spacing = 2,
		},
		target = topFrameDefaults,
		player = topFrameDefaults,
		focus = leftFrameDefaults,
		party = leftFrameDefaults,
	}})
	
	local function RegisterFrame(name, unit)
		local function GetDatabase() return db.profile[unit], db end
		addon:RegisterFrameConfig('Blizzard: '..addon.L[unit], GetDatabase)
		addon:RegisterFrame(name, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end

	RegisterFrame('TargetFrame', 'target')
	RegisterFrame('FocusFrame', 'focus')
	
	return 'supported', GetBuildInfo()
end)

