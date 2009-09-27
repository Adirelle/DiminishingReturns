local addon = DiminishingReturns
if not addon then return end

local framesToWatch

function addon:CheckFrame(frame)
	if not framesToWatch then return end
	local name = frame and frame:GetName()
	local setup = name and framesToWatch[name]
	if setup then
		framesToWatch[name] = nil
		if not next(framesToWatch) then
			framesToWatch = nil
		end
		return setup(frame)
	end
end

function addon:RegisterFrame(frameName, setupFunc)
	local frame = _G[frameName]
	if frame then
		return setupFunc(frame)
	else
		if not framesToWatch then
			framesToWatch = {}
			hooksecurefunc('RegisterUnitWatch', function(frame) return addon:CheckFrame(frame) end)
		end
		framesToWatch[frameName] = setupFunc
	end
end

function addon:RegisterFrameConfig(label, getDatabaseCallback)
	if not addon.pendingFrameConfig then
		addon.pendingFrameConfig = {}
	end
	addon.pendingFrameConfig[label] = getDatabaseCallback
end

local addonSupportCallbacks = {}

local function CheckAddonSupport(_, _, loaded)
	local name = tostring(loaded):lower()
	local callback = addonSupportCallbacks[name]
	if callback then
		addonSupportCallbacks[name] = nil
		if not next(addonSupportCallbacks) then
		 	addon:UnregisterEvent('ADDON_LOADED', CheckAddonLoaded)
		 	CheckAddonSupport = nil
		 	addonSupportCallbacks = nil
		end
		callback()
	end
end

function addon:RegisterAddonSupport(name, callback)
	local enabled, loadable = select(4, GetAddOnInfo(name))
	if name == "FrameXML" or (enabled and (loadable or IsAddOnLoaded(name))) then
		addonSupportCallbacks[tostring(name):lower()] = callback
	end
end

function addon:LoadAddonSupport()
	for name, callback in pairs(addonSupportCallbacks) do
		if IsAddOnLoaded(name) or name == "framexml" then
			addonSupportCallbacks[name] = nil
			callback()
		end
	end
	if next(addonSupportCallbacks) then
		addon:RegisterEvent('ADDON_LOADED', CheckAddonSupport)
	else
		CheckAddonSupport = nil
		addonSupportCallbacks = nil
	end
end

