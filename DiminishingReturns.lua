--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addonName, ns = ...

-- Addon creation and initialization

local addon = CreateFrame("Frame", addonName)

--<GLOBALS
local _G = _G
local CreateFrame = _G.CreateFrame
local IsLoggedIn = _G.IsLoggedIn
local SlashCmdList = _G.SlashCmdList
--GLOBALS>

-- Debugging code
if AdiDebug then
	addon.Debug = AdiDebug:GetSink("DiminishingReturns")
else
	function addon.Debug() end
end

do
	local mixins = { Debug = addon.Debug }

	-- Events
	local __RegisterEvent = addon.RegisterEvent
	local __UnregisterEvent = addon.UnregisterEvent

	local dispatcher = LibStub('CallbackHandler-1.0'):New(mixins, "RegisterEvent", "UnregisterEvent", "UnregisterEvents")

	function dispatcher:OnUsed(_, event) return __RegisterEvent(addon, event) end
	function dispatcher:OnUnused(_, event) return  __UnregisterEvent(addon, event) end
	addon:SetScript('OnEvent', dispatcher.Fire)

	-- Messages
	local messagging = LibStub('CallbackHandler-1.0'):New(mixins, "RegisterMessage", "UnregisterMessage", "UnregisterAllMessages")
	mixins.SendMessage = messagging.Fire

	-- Embedding event dispatcher and messaging
	function addon:EmbedEventDispatcher(target)
		for name, methods in pairs(mixins) do
			target[name] = methods
		end
	end
end

addon:EmbedEventDispatcher(addon)

local DEFAULT_CONFIG = {
	learnCategories = true,
	categories = { ['*'] = false },
	resetDelay = LibStub('DRData-1.0'):GetResetTime(),
	pveMode = false,
	soundAtReset = false,
	resetSound = LibStub('LibSharedMedia-3.0'):GetDefault('sound'),
	bigTimer = false,
	immunityOnly = false,
	pveMode = false,
	icons = {},
	friendly = false,
}
addon.DEFAULT_CONFIG = DEFAULT_CONFIG

function addon:OnProfileChanged(self, ...)
	addon:SendMessage('OnProfileChanged')
end

function addon:ADDON_LOADED(event, name, ...)
	if name ~= addonName then return end

	-- Future events will only call CheckAddonSupport
	self.ADDON_LOADED = self.CheckAddonSupport

	-- Initialize the database
	local db = LibStub('AceDB-3.0'):New("DiminishingReturnsDB", { profile = DEFAULT_CONFIG })
	db.RegisterCallback(self, 'OnProfileChanged')
	db.RegisterCallback(self, 'OnProfileCopied', 'OnProfileChanged')
	db.RegisterCallback(self, 'OnProfileReset', 'OnProfileChanged')
	self.db = db

	-- Optional LibDualSpec-1.0 support
	local LibDualSpec = LibStub('LibDualSpec-1.0', true)
	if LibDualSpec then
		self.LibDualSpec = LibDualSpec
		LibDualSpec:EnhanceDatabase(db, "Diminishing Returns")
	end

	-- Propagate settings
	self:SendMessage('OnProfileChanged')

	self:RegisterEvent('SPELLS_CHANGED', 'ResolveSpells')

	if IsLoggedIn() then
		self:PLAYER_LOGIN()
	else
		self:RegisterEvent('PLAYER_LOGIN')
	end
end
addon:RegisterEvent('ADDON_LOADED')

function addon:PLAYER_LOGIN()
	self:CheckAddonSupport()
	if not self:ResolveSpells() then
		self:CheckActivation('OnLoad')
	end
end

-- Test mode
function addon:SetTestMode(mode)
	self.testMode = mode
	self:SendMessage('SetTestMode', self.testMode)
	if mode then
		self:SpawnTestDR()
	end
end

-- GLOBALS: SLASH_DRTEST1
SLASH_DRTEST1 = "/drtest"
SlashCmdList.DRTEST = function()
	addon:SetTestMode(not addon.testMode)
end
