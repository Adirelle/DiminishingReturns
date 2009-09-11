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

-- DR tracking

local new, del
do
	local heap = setmetatable({},{__mode='k'})
	function new()
		local t = tremove(heap) or {}
		heap[t] = nil
		return t
	end
	function del(t)
		wipe(t)
		heap[t] = true
	end
end

local runningDR = {}

local timerFrame = CreateFrame("Frame")

local function RemoveDR(guid, cat)
	local targetDR = runningDR[guid]
	local dr = targetDR and targetDR[cat]
	if dr then
		if dr.count > 0 then
			addon:TriggerMessage('RemoveDR', guid, cat)
		end
		targetDR[cat] = del(dr)
		if not next(targetDR) then
			runningDR[guid] = del(targetDR)
			if not next(runningDR) then
				timerFrame:Hide()
			end
		end
	end
end

local function RemoveAllDR(guid)
	if runningDR[guid] then
		for cat in pairs(runningDR[guid]) do
			RemoveDR(guid, cat)
		end
	end
end

local drEvents = {
	SPELL_AURA_APPLIED = 0,
	SPELL_AURA_REFRESH = 1,
	SPELL_AURA_REMOVED = 1,
}

local function ParseCLEU(self, _, timestamp, event, ...)	
	local guid, name, flags, spellId, spell = select(4, ...)
	if bit.band(flags, COMBATLOG_OBJECT_CONTROL_MASK) ~= COMBATLOG_OBJECT_CONTROL_PLAYER then return end
	local increase = drEvents[event]
	if increase and addon.WatchedSpells[spell] then 
		local targetDR = runningDR[guid]
		if not targetDR then
			targetDR = new()
			runningDR[guid] = targetDR
		end
		for category, spells in pairs(self.Categories) do
			if spells[spell] then
				local dr = targetDR[category]
				local now = GetTime()
				if not dr then
					dr = new()
					dr.name = name
					dr.texture = self.CatIcons[category] or select(3, GetSpellInfo(spellId))
					dr.count = 0
					targetDR[category] = dr
				end
				dr.count = dr.count + increase
				dr.expireTime = now + 16
				if dr.count > 0 then
					self:TriggerMessage('UpdateDR', guid, category, dr.texture, dr.count, 15, dr.expireTime)
				end
				timerFrame:Show()
			end
		end
	elseif event == 'UNIT_DIED' and runningDR[guid] then
		RemoveAllDR(guid)
	end	
end

local function WipeAll(self)
	for guid, drs in pairs(runningDR) do
		for category in pairs(drs) do
			RemoveDR(guid, category)
		end
	end
end

local timer = 0
timerFrame:Hide()
timerFrame:SetScript('OnShow', function() timer = 0 end)
timerFrame:SetScript('OnUpdate', function(self, elapsed)
	if timer > 0 then
		timer = timer - elapsed
		return
	end
	local now = GetTime()
	timer = 0.1
	for guid, drs in pairs(runningDR) do
		for cat, dr in pairs(drs) do
			if now >= dr.expireTime then
				RemoveDR(guid, cat)
			end
		end
	end
end)

local function IterFunc(targetDR, cat)
	local dr
	cat, dr = next(targetDR, cat)
	if cat then
		return cat, dr.texture, dr.count, 15, dr.count, dr.expireTime
	end
end

local function noop() end

function addon:IterateDR(guid)
	if runningDR[guid] then
		return IterFunc, runningDR[guid]
	else
		return noop
	end
end

local function CheckActivation()	
	local _, instanceType = IsInInstance()
	if instanceType == "raid" or instanceType == "party" then
		addon:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ParseCLEU)
		addon:UnregisterEvent('PLAYER_LEAVING_WORLD', WipeAll)
		WipeAll()
		addon.active = false
		addon:TriggerMessage('DisableDR')
	else
		addon:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ParseCLEU)
		addon:RegisterEvent('PLAYER_LEAVING_WORLD', WipeAll)
		addon.active = true
		addon:TriggerMessage('EnableDR')
	end
end

addon:RegisterEvent('PLAYER_ENTERING_WORLD', CheckActivation)
if IsLoggedIn() then
	CheckActivation()
end

