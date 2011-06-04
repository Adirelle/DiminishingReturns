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
		local refUnit = gsub(unit, "%d+$", "")
		local function GetDatabase() return db.profile[refUnit], db end
		addon:RegisterFrameConfig('Blizzard: '..addon.L[refUnit], GetDatabase)
		addon:RegisterFrame(name, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end

	RegisterFrame('TargetFrame', 'target')
	RegisterFrame('FocusFrame', 'focus')
	RegisterFrame('PlayerFrame', 'player')
	RegisterFrame('FocusFrame', 'focus')
	for i = 1, 4 do
		RegisterFrame('PartyMemberFrame'..i, 'party'..i)
	end

	return 'supported', GetBuildInfo()
end)

