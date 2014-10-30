--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end
local L = addon.L

--<GLOBALS
local _G = _G
local format = _G.format
local GetAddOnInfo = _G.GetAddOnInfo
local geterrorhandler = _G.geterrorhandler
local hooksecurefunc = _G.hooksecurefunc
local IsAddOnLoaded = _G.IsAddOnLoaded
local IsLoggedIn = _G.IsLoggedIn
local pairs = _G.pairs
local pcall = _G.pcall
local select = _G.select
--GLOBALS>

local supportState = {}

local frames = {}
local frameCallbacks = {}
local addonCallbacks = {}

local safecall
do
	local function pcall_result(success, ...)
		if not success then
			addon:Debug('Callback error:', ...)
			geterrorhandler()(...)
		end
		return ...
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

local function IsLoaded(name)
	if name == "FrameXML" then
		return IsLoggedIn()
	else
		return IsAddOnLoaded(name)
	end
end

local function CanBeLoaded(name)
	if name == "FrameXML" then
		return true
	else
		local loadable, reason = select(4, GetAddOnInfo(name))
		if not loadable and reason == "DEMAND_LOADED" then
			return true
		end
		return loadable, reason
	end
end

function addon:CheckAddonSupport()
	if not self.db then
		return -- Not yet initialized
	end
	for name, callback in pairs(addonCallbacks) do
		if IsLoaded(name) then
			self:Debug('Calling addon support for', name)
			addonCallbacks[name] = nil
			local success, state, version = pcall(callback)
			if success then
				local color
				if state == 'supported' then
					color = '00ff00'
				elseif state == "unsupported" then
					color = 'ff0000'
				else
					state, color = 'unknown', 'ffff00'
				end
				supportState[name] = format('|cff%s%s, version %s|r', color, L[state], version or "unknown")
			else
				supportState[name] = '|cffff0000'..L["error: "]..state..'|r'
			end
		end
	end
end

function addon:RegisterAddonSupport(name, callback)
	if not IsLoaded(name) then
		local loadable, reason = CanBeLoaded(name)
		if not loadable then
			self:Debug('Not registering addon support for', name, ':', _G["ADDON_"..reason], '['..reason..']')
			if reason == 'MISSING' then
				supportState[name] = '|cffbbbbbbnot installed|r'
			else
				supportState[name] = '|cffff0000cannot be loaded: '.._G["ADDON_"..reason]..'|r'
			end
			return
		end
	end
	supportState[name] = '|cff00ffff'..L["to be loaded"]..'|r'
	addonCallbacks[name] = callback
	self:CheckAddonSupport()
	if addonCallbacks[name] then
		self:Debug('Registered addon support for', name)
	end
end

function addon:IterateSupportStatus()
	return pairs(supportState)
end

local commonUnits = { target = true, player = true, focus = true }
for i = 1, 5 do
	commonUnits["party"..i] = true
	commonUnits["raid"..i] = true
	commonUnits["arena"..i] = true
end

function addon:RegisterCommonFrames(func)
	for unit in pairs(commonUnits) do
		local ok, message = pcall(func, unit)
		if not ok then
			geterrorhandler()(message)
		end
	end
end
