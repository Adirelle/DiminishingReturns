local addon = DiminishingReturns
if not addon then return end

-- oUF can be embedded like a library so look for it
local parent, global
for index = 1, GetNumAddOns() do 
	global = GetAddOnMetadata(index, 'X-oUF')
	if global then
		parent = GetAddOnInfo(index)
		break
	end
end

-- No addon embeds oUF
if not global then return end

addon:RegisterAddonSupport(parent, function()
	local oUF = _G[global]

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

	db = addon.db:RegisterNamespace('oUF', {profile={
		target = defaults,
		focus = defaults,
	}})
	
	local getDatabaseFuncs = {}
	
	-- Frame checking code
	local function CheckFrame(frame)
		local unit = frame.unit
		if unit ~= 'target' and unit ~= 'focus' then return end
		local GetDatabase = getDatabaseFuncs[unit]
		if not GetDatabase then
			-- Avoid creating several time the same config
			GetDatabase = function() return db.profile[unit], db end
			addon:RegisterFrameConfig('oUF: '..addon.L[unit], GetDatabase)
			getDatabaseFuncs[unit] = GetDatabase
		end
		return addon:SpawnFrame(frame, frame, GetDatabase)
	end

	-- Check existing frames	
	for i, frame in pairs(oUF.objects) do
		CheckFrame(frame)
	end	
	
	-- Register check for future frames
	oUF:RegisterInitCallback(CheckFrame)

end)

