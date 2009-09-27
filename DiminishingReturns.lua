-- Addon creation and initialization

DiminishingReturns = CreateFrame("Frame")
local addon = DiminishingReturns
LibStub('LibAdiEvent-1.0').Embed(addon)
addon:SetMessageChannel(addon)

local DEFAULT_CONFIG = {
	learnCategories = true,
	categories = { ['*'] = false },
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
	local lds = LibStub('LibDualSpec-1.0', true)
	if lds then
		self.LibDualSpec = lds
		lds:EnhanceDatabase(db, "Diminishing Returns")
	end

	addon:LoadAddonSupport()
end
addon:RegisterEvent('ADDON_LOADED', OnLoad)

-- Test mode
function addon:SetTestMode(mode)
	self.testMode = mode
	addon:TriggerMessage('SetTestMode', self.testMode)
end

SLASH_DRTEST1 = "/drtest"
SlashCmdList.DRTEST = function()
	addon:SetTestMode(not addon.testMode)
end
