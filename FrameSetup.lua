local addon = DiminishingReturns
if not addon then return end

local framesToWatch

function addon.CheckFrame(frame)
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
		setupFunc(frame)
		return true
	else
		if not framesToWatch then
			framesToWatch = {}
			hooksecurefunc('RegisterUnitWatch', addon.CheckFrame)
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
		 	addon:UnregisterEvent('ADDON_LOADED', CheckAddonSupport)
		 	CheckAddonSupport = nil
		 	addonSupportCallbacks = nil
		end
		addon:Debug('Loading', name, 'support')
		local success, msg = pcall(callback)
		if not success then
			geterrorhandler()(msg)
		end
	end
end

function addon:RegisterAddonSupport(name, callback)
	local enabled, loadable = select(4, GetAddOnInfo(name))
	if name == "FrameXML" or (enabled and (loadable or IsAddOnLoaded(name))) then
		addonSupportCallbacks[tostring(name):lower()] = callback
		return true
	end
end

function addon:LoadAddonSupport()
	for name, callback in pairs(addonSupportCallbacks) do
		if IsAddOnLoaded(name) or name == "framexml" then
			addonSupportCallbacks[name] = nil
			addon:Debug('Loading', name, 'support')
			local success, msg = pcall(callback)
			if not success then
				geterrorhandler()(msg)
			end
		end
	end
	if next(addonSupportCallbacks) then
		addon:RegisterEvent('ADDON_LOADED', CheckAddonSupport)
	else
		CheckAddonSupport = nil
		addonSupportCallbacks = nil
	end
end

