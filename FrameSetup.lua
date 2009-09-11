local addon = DiminishingReturns
if not addon then return end

local function RegisterAddonSetup(addonName, setupFunc)
	addonName = addonName:lower()
	if IsAddOnLoaded(addonName) then
		return setupFunc()
	else
		local enabled, loadable = select(4, GetAddOnInfo(addonName))
		if enabled and loadable then
			local loader = function(_, _, name)
				if name:lower() == addonName then
					addon:UnregisterEvent('ADDON_LOADED', loader)
					return setupFunc()
				end
			end
			addon:RegisterEvent('ADDON_LOADED',loader)
		end
	end
end

local pendingSetup

local function CheckPendingSetup(frame)
	local name = frame and frame:GetName()
	local setup = name and pendingSetup[name]
	if setup then
		pendingSetup[name] = nil
		return setup(frame)
	end
end

local function RegisterFrameSetup(frameName, setupFunc)
	local frame = _G[frameName]
	if frame then
		return setupFunc(frame)
	else
		if not pendingSetup then
			pendingSetup = {}
			hooksecurefunc('RegisterUnitWatch', CheckPendingSetup)
		end
		pendingSetup[frameName] = setupFunc
	end
end

------------------

-- Shadowed Unit Frames
RegisterAddonSetup('ShadowedUnitFrames', function()
	local function SetupFrame(frame)
		return addon:SpawnFrame(frame, frame, 24, 'RIGHT', 2, 'TOPLEFT', 'BOTTOMLEFT', 0, -4)
	end
	--RegisterFrameSetup('SUFUnitplayer', SetupFrame)
	RegisterFrameSetup('SUFUnittarget', SetupFrame)
end)

--[[ oUF_Adirelle
RegisterAddonSetup('oUF_Adirelle', function()
	local function SetupFrame(frame)
		return addon:SpawnFrame(frame, frame, 16, 'RIGHT', 2, 'TOPLEFT', 'BOTTOMLEFT', 0, -4)
	end
	for i = 1,5 do
		RegisterFrameSetup('oUF_Raid1UnitButton'..i, SetupFrame)
	end
end)]]

-- Gladius
RegisterAddonSetup('Gladius', function()
	local function SetupFrame(frame)
		return addon:SpawnFrame(frame:GetParent(), frame, 32, 'LEFT', 2, 'TOPRIGHT', 'TOPLEFT', -10, 0)
	end
	for i = 1,5 do
		RegisterFrameSetup('GladiusButton'..i, SetupFrame)
	end
	hooksecurefunc(Gladius, 'UpdateAttribute', function(gladius, unit)
		CheckPendingSetup(gladius.buttons[unit].secure)
	end)
end)

