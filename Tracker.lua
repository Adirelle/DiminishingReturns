local addon = DiminishingReturns
if not addon then return end

local drdata = LibStub('DRData-1.0')
local band = bit.band

local CATEGORIES = drdata:GetCategories()
addon.CATEGORIES = CATEGORIES

local CL_EVENTS = {
	SPELL_AURA_APPLIED = 0,
	SPELL_AURA_REFRESH = 1,
	SPELL_AURA_REMOVED = 1,
}

local SPELLS = {}
for id, category in pairs(drdata:GetSpells()) do
	if CATEGORIES[category] then
		local name = GetSpellInfo(id)
		if name then
			SPELLS[name] = category
		--@debug@
		else
			print('Unknown spell', id, 'for', category)
		--@end-debug@
		end
	end
end
addon.SPELLS = SPELLS

local RESET_DELAY = drdata:GetResetTime()

local CLO_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local CLO_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local CLO_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local CLO_TYPE_PET_OR_PLAYER = bit.bor(COMBATLOG_OBJECT_TYPE_PET, COMBATLOG_OBJECT_TYPE_PLAYER)

local ICONS
do
	local function GetSpellIcon(id) return select(3, GetSpellInfo(id)) end
	ICONS = {
		["banish"] = GetSpellIcon(18647), -- Banish
		["charge"] = GetSpellIcon(100), -- Charge
		["cheapshot"] = GetSpellIcon(1833), -- Cheap Shot
		["ctrlstun"] = [[Interface\Icons\Spell_Frost_FrozenCore]],
		["cyclone"] = GetSpellIcon(33786), -- Cyclone
		["disarm"] = GetSpellIcon(676), -- Disarm
		["disorient"] = GetSpellIcon(1776), -- Gouge
		["entrapment"] = GetSpellIcon(19184), -- Entrapment
		["fear"] = GetSpellIcon(5782), -- Fear
		["horror"] = GetSpellIcon(6789), -- Death Coil
		["mc"] = GetSpellIcon(605), -- Mind Control
		["rndroot"] = [[Interface\Icons\Ability_ShockWave]],
		["rndstun"] = [[Interface\Icons\INV_Mace_02]],
		["ctrlroot"] = [[Interface\Icons\Spell_Frost_FrostNova]],
		["scatters"] = GetSpellIcon(19503), -- Scatter Shot
		["silence"] =  GetSpellIcon(2139), -- Counterspell
		["sleep"] = GetSpellIcon(2637), -- Hibernate	
	}
end
addon.ICONS = ICONS

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

local function ParseCLEU(self, _, timestamp, event, _, srcName, srcFlags, guid, name, flags, spellId, spell)	
	if band(flags, CLO_TYPE_PET_OR_PLAYER) == 0 or band(flags, CLO_CONTROL_PLAYER) == 0 or band(flags, CLO_REACTION_FRIENDLY) ~= 0 then
		return
	end
	local increase = CL_EVENTS[event]
	local category = SPELLS[spell]
	if increase and category then
		if addon.db.profile.learnCategories and band(srcFlags, CLO_AFFILIATION_MINE) ~= 0 and not addon.db.profile.categories[category] then
			addon.db.profile.categories[category] = true
		end
		local targetDR = runningDR[guid]
		if not targetDR then
			targetDR = new()
			runningDR[guid] = targetDR
		end
		local dr = targetDR[category]
		local now = GetTime()
		if not dr then
			dr = new()
			dr.texture = ICONS[category]
			dr.count = 0
			targetDR[category] = dr
		end
		dr.count = dr.count + increase
		dr.expireTime = now + RESET_DELAY
		if dr.count > 0 then
			self:TriggerMessage('UpdateDR', guid, category, dr.texture, dr.count, RESET_DELAY, dr.expireTime)
		end
		timerFrame:Show()
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
		return cat, dr.texture, dr.count, RESET_DELAY, dr.expireTime
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

