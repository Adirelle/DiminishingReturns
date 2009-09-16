-- Addon creation and initialization

DiminishingReturns = CreateFrame("Frame")
local addon = DiminishingReturns
LibStub('LibAdiEvent-1.0').Embed(addon)

local DEFAULT_CONFIG = {
	autoCategories = true,
	categories = { ['*'] = true },
}
addon.DEFAULT_CONFIG = DEFAULT_CONFIG

local function OnLoad(self, event, name)
	if name:lower() ~= "diminishingreturns" then return end
	self:UnregisterEvent('ADDON_LOADED', OnLoad)
	OnLoad = nil
	
	local db = LibStub('AceDB-3.0'):New("DiminishingReturnsDB", {profile=DEFAULT_CONFIG})
	--db.RegisterCallback(self, 'OnProfileChanged', 'RequireUpdate')
	--db.RegisterCallback(self, 'OnProfileCopied', 'RequireUpdate')
	--db.RegisterCallback(self, 'OnProfileReset', 'RequireUpdate')
	self.db = db
	
	-- Optional LibDualSpec-1.0 support
	local lds = LibStub('LibDualSpec-1.0', true)
	if lds then
		self.LibDualSpec = lds
		lds:EnhanceDatabase(db, "Diminishing Returns")
	end

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
