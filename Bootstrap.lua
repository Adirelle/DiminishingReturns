local addon = DiminishingReturns
if not addon then return end

local frameHandlers = {}

local function HookFrame(frame)
	local name, unit = frame:GetName(), frame:GetAttribute('unit')
	local handler = name and frameHandlers[name]
	if handler then
		handler(frame, unit)
		frameHandlers[name] = nil
	end
end

-- Shadowed Unit Frames

local function Hook_SUF(frame, unit)
	return addon:SpawnFrame(frame, frame, 24, 'RIGHT', 2, 'TOPLEFT', 'BOTTOMLEFT', 0, -4)
end
frameHandlers.SUFUnitplayer = Hook_SUF
frameHandlers.SUFUnittarget = Hook_SUF

-- oUF_Adirelle

local function Hook_oUF_Adirelle(frame, unit)
	return addon:SpawnFrame(frame, frame, 16, 'RIGHT', 2, 'TOPLEFT', 'BOTTOMLEFT', 0, -4)
end
for i = 1,5 do
	frameHandlers['oUF_Raid1UnitButton'..i] = Hook_oUF_Adirelle
end

-- Gladius

local function Hook_Gladius(frame, unit)
	return addon:SpawnFrame(frame:GetParent(), frame, 32, 'LEFT', 2, 'TOPRIGHT', 'TOPLEFT', -10, 0)
end
for i = 1,5 do
	frameHandlers['GladiusButton'..i] = Hook_Gladius
end
if Gladius then
	hooksecurefunc(Gladius, 'UpdateAttribute', function(gladius, unit)
		HookFrame(gladius.buttons[unit].secure)
	end)
end

----

local function HookAllFrames()
	for name in pairs(frameHandlers) do
		if _G[name] then
			HookFrame(_G[name])
		end
	end
end

HookAllFrames()

if next(frameHandlers) then
	local knownAddons = {
		gladius = true,
		shadowunitfeames = true,
		ouf_adirelle = true,
	}

	local function HookOnLoad(self, event, name)
		if knownAddons[name:lower()] then
			HookAllFrames()
			knownAddons[name] = nil
			if not next(knownAddons) or not next(frameHandlers) then
				addon:UnregisterEvent('ADDON_LOADED', HookOnLoad)
			end
		end
	end
	addon:RegisterEvent('ADDON_LOADED', HookOnLoad)
	hooksecurefunc('RegisterUnitWatch', HookFrame)
end
