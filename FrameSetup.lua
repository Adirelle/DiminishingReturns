local addon = DiminishingReturns
if not addon then return end

local frames = {}
local frameCallbacks = {}
local addonCallbacks = {}

local safecall
do
	local function pcall_result(success, ...)
		if success then
			return ...
		else
			addon:Debug('Callback error:', ...)
			geterrorhandler()(...)
		end
	end

	function safecall(func, ...)
		return pcall_result(pcall(func, ...))
	end
end

function addon.CheckFrame(frame)
	local name = frame and frame:GetName()
	local callback = name and frameCallbacks[name]
	if callback then
		addon:Debug('Calling callback for frame', name)
		frameCallbacks[name] = nil
		safecall(callback, frame)
		return true
	end
end

function addon:RegisterFrame(name, callback)
	frameCallbacks[name] = callback
	if not addon.CheckFrame(_G[name]) then
		addon:Debug('Registered callback for frame', name)
	end
end

hooksecurefunc('RegisterUnitWatch', addon.CheckFrame)

function addon:RegisterFrameConfig(label, getDatabaseCallback)
	if not addon.pendingFrameConfig then
		addon.pendingFrameConfig = {}
	end
	addon.pendingFrameConfig[label] = getDatabaseCallback
end

local addonSupportInitialized

local function CheckAddonSupport()
	if not addonSupportInitialized then return end
	if addonCallbacks.framexml and IsLoggedIn() then
		addon:Debug('Calling addon support for FrameXML')
		safecall(addonCallbacks.framexml)
		addonCallbacks.framexml = nil
	end
	for name, callback in pairs(addonCallbacks) do
		if IsAddOnLoaded(name) then
			addon:Debug('Calling addon support for', name)
			safecall(callback)
			addonCallbacks[name] = nil
		end
	end
end

function addon:RegisterAddonSupport(name, callback)
	name = tostring(name):lower()
	if name ~= "framexml" and not IsAddOnLoaded(name) then
		local loadable, reason = select(5, GetAddOnInfo(name))
		if not loadable then
			self:Debug('Not registering addon support for', name, ':', _G["ADDON_"..reason], '[', reason, ']')
			return
		end
	end
	addonCallbacks[name] = callback
	CheckAddonSupport()
	if addonCallbacks[name] then
		self:Debug('Registered addon support for', name)
	end
end

function addon:LoadAddonSupport()
	addonSupportInitialized = true
	CheckAddonSupport()
	if addonCallbacks.framexml then
		addon:RegisterEvent('PLAYER_LOGIN', CheckAddonSupport)
	end
	addon:RegisterEvent('ADDON_LOADED', CheckAddonSupport)
end
