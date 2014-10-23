--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

--<GLOBALS
local _G = _G
local assert = _G.assert
local band = _G.bit.band
local bor = _G.bit.bor
local COMBATLOG_OBJECT_AFFILIATION_MINE = _G.COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_AFFILIATION_PARTY = _G.COMBATLOG_OBJECT_AFFILIATION_PARTY
local COMBATLOG_OBJECT_AFFILIATION_RAID = _G.COMBATLOG_OBJECT_AFFILIATION_RAID
local COMBATLOG_OBJECT_CONTROL_PLAYER = _G.COMBATLOG_OBJECT_CONTROL_PLAYER
local COMBATLOG_OBJECT_REACTION_FRIENDLY = _G.COMBATLOG_OBJECT_REACTION_FRIENDLY
local COMBATLOG_OBJECT_TYPE_PET = _G.COMBATLOG_OBJECT_TYPE_PET
local COMBATLOG_OBJECT_TYPE_PLAYER = _G.COMBATLOG_OBJECT_TYPE_PLAYER
local CreateFrame = _G.CreateFrame
local geterrorhandler = _G.geterrorhandler
local GetSpellInfo = _G.GetSpellInfo
local GetTime = _G.GetTime
local hooksecurefunc = _G.hooksecurefunc
local IsInInstance = _G.IsInInstance
local IsLoggedIn = _G.IsLoggedIn
local IsResting = _G.IsResting
local IsSpellKnown = _G.IsSpellKnown
local next = _G.next
local pairs = _G.pairs
local PlaySoundFile = _G.PlaySoundFile
local select = _G.select
local setmetatable = _G.setmetatable
local tremove = _G.tremove
local type = _G.type
local UnitCanAssist = _G.UnitCanAssist
local UnitClass = _G.UnitClass
local UnitGUID = _G.UnitGUID
local UnitIsPVP = _G.UnitIsPVP
local UnitIsUnit = _G.UnitIsUnit
local wipe = _G.wipe
--GLOBALS>

local DRData = LibStub('DRData-1.0')
local SharedMedia = LibStub('LibSharedMedia-3.0')

-- database upvalue
local prefs
addon.RegisterMessage('Tracker', 'OnProfileChanged', function() prefs = addon.db.profile end)

local CATEGORIES = DRData:GetCategories()
addon.CATEGORIES = CATEGORIES

local CL_EVENTS = {
	SPELL_AURA_APPLIED = 0,
	SPELL_AURA_REFRESH = 1,
	SPELL_AURA_REMOVED = 1,
}

local CLO_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local CLO_AFFILIATION_FRIEND = bor(CLO_AFFILIATION_MINE, COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)
local CLO_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local CLO_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local CLO_TYPE_PET_OR_PLAYER = bor(COMBATLOG_OBJECT_TYPE_PET, COMBATLOG_OBJECT_TYPE_PLAYER)

local ICONS = {}
addon.ICONS = ICONS

local SPELLS = {}
local SPELLS_BY_CATEGORY = {}
for id, category in pairs(DRData:GetSpells()) do
	if CATEGORIES[category] then
		SPELLS[id] = category
		if not SPELLS_BY_CATEGORY[category] then
			SPELLS_BY_CATEGORY[category] = { id }
		else
			tinsert(SPELLS_BY_CATEGORY[category], id)
		end
	--@debug@
	else
		geterrorhandler()('Spell '..id..' assigned to unknown category '..category)
	--@end-debug@
	end
end
addon.SPELLS = SPELLS
addon.SPELLS_BY_CATEGORY = SPELLS_BY_CATEGORY

-- Search icons on demand
setmetatable(ICONS, { __index = function(t, category)
	local icon
	if prefs.icons[category] then
		icon = prefs.icons[category]
	elseif SPELLS_BY_CATEGORY[category] then
		local score = 0
		for i, id in ipairs(SPELLS_BY_CATEGORY[category]) do
			local thisIcon = select(3, GetSpellInfo(id))
			if thisIcon then
				if score < 30 and IsSpellKnown(id) then
					-- Character spell
					icon, score = thisIcon, 30
				elseif score < 20 and IsSpellKnown(id, true) then
					-- Pet spell
					icon, score = thisIcon, 20
				elseif score < 10 then
					-- Any spell
					icon, score = thisIcon, 10
				end
			end
		end
	else
		icon = [[Interface\\Icons\\INV_Misc_QuestionMark]]
	end
	if icon then
		t[category] = icon
		return icon
	end
	return [[Interface\\Icons\\INV_Misc_QuestionMark]]
end})

function addon:ResolveSpells()
	if spellsResolved then return end
	for id, category in pairs(SPELLS) do
		if type(id) == "number" then
			local name = GetSpellInfo(id)
			if name then
				SPELLS[name] = category
				spellsResolved = true
			--@debug@
			else
				geterrorhandler()('Unknown spell '..id..' (category '..category..')')
			--@end-debug@
			end
		end
	end
	if spellsResolved then
		wipe(ICONS)
		self:Debug('Spells changed')
		self:CheckActivation('SpellsResolved')
		return true
	end
end

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

local function SpawnDR(guid, category, isFriend, increase, duration)
	local targetDR = runningDR[guid]
	if not targetDR then
		targetDR = new()
		runningDR[guid] = targetDR
	end
	local dr = targetDR[category]
	local now = GetTime()
	if not dr then
		dr = new()
		dr.isFriend = isFriend
		dr.texture = ICONS[category]
		dr.count = 0
		targetDR[category] = dr
	end
	dr.count = dr.count + increase
	dr.expireTime = now + duration
	if dr.count > 0 then
		assert(type(duration) == "number")
		addon:SendMessage('UpdateDR', guid, category, isFriend, dr.texture, dr.count, duration, dr.expireTime)
	end
	timerFrame:Show()
end

local function RemoveDR(guid, cat)
	local targetDR = runningDR[guid]
	local dr = targetDR and targetDR[cat]
	if dr then
		if dr.count > 0 then
			addon:SendMessage('RemoveDR', guid, cat)
		end
		targetDR[cat] = del(dr)
		if not next(targetDR) then
			runningDR[guid] = del(targetDR)
			if not next(runningDR) then
				timerFrame:Hide()
				if addon.testMode then
					addon:SetTestMode(false)
				end
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

local function ParseCLEU(self, _, timestamp, event, _, _, srcName, srcFlags, _, guid, name, flags, _, spellId, spell)
	-- Always process UNIT_DIED if we have information about the unit
	if event == 'UNIT_DIED' then
		if runningDR[guid] then
			RemoveAllDR(guid)
		end
		return
	end
	-- Ignore any spell or event we are not interested with
	local increase, category = CL_EVENTS[event], SPELLS[spellId] or SPELLS[spell]
	if not increase or not category then return end
	-- Ignore friends unless asked for
	local isFriend = false
	if band(flags, CLO_REACTION_FRIENDLY) ~= 0 then
		isFriend = band(flags, CLO_AFFILIATION_FRIEND) ~= 0
		if not isFriend then return end -- Ignore outsiders
	end
	-- Ignore mobs for non-PvE categories
	local isPlayer = band(flags, CLO_TYPE_PET_OR_PLAYER) ~= 0 or band(flags, CLO_CONTROL_PLAYER) ~= 0
	if not isPlayer and (not prefs.pveMode or not DRData:IsPVE(category)) then return end
	-- Category auto-learning
	if prefs.learnCategories and band(srcFlags, CLO_AFFILIATION_MINE) ~= 0 then
		prefs.categories[category] = true
	end
	-- Create or extend the DR
	return SpawnDR(guid, category, isFriend, increase, prefs.resetDelay)
end

local function SpawnTestDR(unit)
	local guid = UnitGUID(unit)
	if guid then
		local isFriend = UnitCanAssist("player", unit)
		local count = 1
		for cat in pairs(addon.CATEGORIES) do
			SpawnDR(guid, cat, isFriend, 1 + count % 3, 2*count+math.random(1,9))
			count = count % 3 + 1
		end
	end
end

function addon:SpawnTestDR()
	SpawnTestDR("player")
	SpawnTestDR("pet")
	if not UnitIsUnit("pet", "target") and not UnitIsUnit("player", "target") then
		SpawnTestDR("target")
	end
	if not UnitIsUnit("pet", "focus") and not UnitIsUnit("player", "focus") and not UnitIsUnit("target", "focus") then
		SpawnTestDR("focus")
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
	local watched = prefs.categories
	local playSound = false
	timer = 0.1
	for guid, drs in pairs(runningDR) do
		for cat, dr in pairs(drs) do
			if now >= dr.expireTime then
				if dr.count > 0 and not dr.isFriend and watched[cat] then
					playSound = true
				end
				RemoveDR(guid, cat)
			end
		end
	end
	if playSound and prefs.soundAtReset then
		local key = prefs.resetSound
		local media = SharedMedia:Fetch('sound', key)
		addon:Debug('PlaySound', key, media)
		PlaySoundFile(media, "SFX")
	end
end)

local function IterFunc(targetDR, cat)
	local dr
	cat, dr = next(targetDR, cat)
	if cat then
		return cat, dr.isFriend, dr.texture, dr.count, prefs.resetDelay, dr.expireTime
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

local inDuel = false

function addon:CheckActivation(event)
	local activate = false
	if spellsResolved then
		if prefs.pveMode then
			activate = not IsResting()
			self:Debug('CheckActivation(PvE)', event, activate, "<= IsResting=", IsResting())
		else
			local _, instanceType = IsInInstance()
			activate = inDuel or UnitIsPVP('player') or instanceType == "pvp" or instanceType == "arena"
			self:Debug('CheckActivation(PvP)', event, activate, "<= inDuel=", inDuel, "playerInPvP=", UnitIsPVP("player"), "instanceType=", instanceType)
		end
	end
	if activate then
		if not addon.active then
			addon:Debug('CheckActivation, pveMode=', prefs.pveMode, ', activating')
			addon:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ParseCLEU)
			addon.active = true
			addon:SendMessage('EnableDR')
		end
	elseif addon.active then
		addon:Debug('CheckActivation, pveMode=', prefs.pveMode, ', disactivating')
		addon:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		WipeAll()
		addon.active = false
		addon:SendMessage('DisableDR')
	end
end

local function BeginDuel()
	if not inDuel then
		inDuel = true
		addon:CheckActivation("BeginDuel")
	end
end
local function EndDuel()
	if inDuel then
		inDuel = false
		addon:CheckActivation("EndDuel")
	end
end

hooksecurefunc("AcceptDuel", BeginDuel)
hooksecurefunc("StartDuel", BeginDuel)
hooksecurefunc("CancelDuel", EndDuel)
addon:RegisterEvent('DUEL_FINISHED', EndDuel)

addon:RegisterEvent('PLAYER_ENTERING_WORLD', 'CheckActivation')
addon:RegisterEvent('PLAYER_LEAVING_WORLD', 'CheckActivation')
addon:RegisterEvent('PLAYER_UPDATE_RESTING', 'CheckActivation')
addon:RegisterEvent('UNIT_FACTION', function(self, event, unit)
	if unit == "player" then return addon:CheckActivation(event) end
end)
addon.RegisterMessage('Tracker', 'OnConfigChanged', function(self, event, name)
	if name == "pveMode" then return addon:CheckActivation(event) end
end)
