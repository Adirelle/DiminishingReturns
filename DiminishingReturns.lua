--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2011 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

-- Addon creation and initialization

_G.DiminishingReturns = CreateFrame("Frame")
local addon = _G.DiminishingReturns
LibStub('LibAdiEvent-1.0').Embed(addon)
addon:SetMessageChannel(addon)

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
}
addon.DEFAULT_CONFIG = DEFAULT_CONFIG

function addon:OnProfileChanged(self, ...)
	addon:TriggerMessage('OnProfileChanged')
end

local function OnLoad(self, event, name, ...)
	if name:lower() ~= "diminishingreturns" then return end
	self:UnregisterEvent('ADDON_LOADED', OnLoad)
	OnLoad = nil

	local db = LibStub('AceDB-3.0'):New("DiminishingReturnsDB", {profile=DEFAULT_CONFIG})
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

	addon:TriggerMessage('OnProfileChanged')

	addon:LoadAddonSupport()

	if IsLoggedIn() then
		self:CheckActivation('OnLoad')
	end
end

addon:RegisterEvent('ADDON_LOADED', OnLoad)

-- Test mode
function addon:SetTestMode(mode)
	self.testMode = mode
	addon:TriggerMessage('SetTestMode', self.testMode)
end

-- GLOBALS: SLASH_DRTEST1
SLASH_DRTEST1 = "/drtest"
SlashCmdList.DRTEST = function()
	addon:SetTestMode(not addon.testMode)
end
