local addon = DiminishingReturns
if not addon then return end

addon:RegisterAddonSupport('XPerl', function()

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

	local db = addon.db:RegisterNamespace('XPerl', {profile={
		target = defaults,
		focus = defaults,
	}})
	
	local function RegisterFrame(unit)
		local function GetDatabase() return db.profile[unit], db end
		addon:RegisterFrameConfig('XPerl: '..addon.L[unit], GetDatabase)
		return addon:RegisterFrame('XPerl'..unit, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end

	if not RegisterFrame('target') or not RegisterFrame('focus') then
		hooksecurefunc('XPerl_SecureUnitButton_OnLoad', addon.CheckFrame)
	end
	
end)

