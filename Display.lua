--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addonName, ns = ...

local addon = _G.DiminishingReturns
if not addon then return end

local templateFrame = CreateFrame("Frame")
templateFrame.Debug = addon.Debug

--<GLOBALS
local _G = _G
local ceil = _G.ceil
local CreateFrame = _G.CreateFrame
local format = _G.format
local GetTime = _G.GetTime
local ipairs = _G.ipairs
local max = _G.max
local SecureButton_GetModifiedUnit = _G.SecureButton_GetModifiedUnit
local select = _G.select
local strsub = _G.strsub
local tinsert = _G.tinsert
local tostring = _G.tostring
local tremove = _G.tremove
local UnitGUID = _G.UnitGUID
local unpack = _G.unpack
local wipe = _G.wipe
--GLOBALS>

local FONT_NAME, FONT_SIZE, FONT_FLAGS = _G.GameFontNormal:GetFont(), 16, "OUTLINE"

local ANCHORING = {
	LEFT   = { "RIGHT",  "LEFT",   -1,  0 },
	RIGHT  = { "LEFT",   "RIGHT",   1,  0 },
	TOP    = { "BOTTOM", "TOP",     0,  1 },
	BOTTOM = { "TOP",    "BOTTOM",  0, -1 },
}

local TEXTS = {
	{ "\194\189", 0.0, 1.0, 0.0 }, -- 1/2
	{ "\194\188", 1.0, 1.0, 0.0 }, -- 1/4
	{         "0", 1.0, 0.0, 0.0 }
}

local function FitTextSize(text, width, height)
	local name, _, flags = text:GetFont()
	text:SetFont(name, text.fontSize, flags)
	local ratio = text:GetStringWidth() / (width-4)
	if height then
		ratio = max(ratio, text:GetStringHeight() / (height-4))
	end
	if ratio > 1 then
		text:SetFont(name, floor(text.fontSize / ratio), flags)
	end
end

local iconProto = setmetatable({}, { __index = templateFrame })
local iconMeta = { __index = iconProto }

function iconProto:UpdateTimer()
	local timer = self.timer
	if not timer.expireTime then return end
	local timeLeft = timer.expireTime - GetTime()
	if timeLeft <= 0 then
		timer.expireTimer, timer.timeLeft = nil, nil
		return timer:Hide()
	elseif timeLeft < 3 and addon.db.profile.bigTimer then
		timeLeft = format("%.1f", ceil(timeLeft * 10) / 10)
	else
		timeLeft = tostring(ceil(timeLeft))
	end
	if timeLeft ~= timer.timeLeft then
		timer.timeLeft = timeLeft
		timer:SetText(tostring(timeLeft))
		FitTextSize(timer, self:GetWidth())
	end
end

local LBF = LibStub('LibButtonFacade', true)
if LBF then
	local group = LBF:Group("DiminishingReturns")
	addon.DEFAULT_CONFIG.ButtonFacade = { skinID = "Blizzard" }

	LBF:RegisterSkinCallback("DiminishingReturns", function(_, skinID, gloss, backdrop, _, _, colors)
		local skin = addon.db.profile.ButtonFacade
		skin.skinID, skin.gloss, skin.backdrop, skin.colors = skinID, gloss, backdrop, colors
	end, addon)

	addon.RegisterMessage('Display-LBF', 'OnProfileChanged', function()
		local skin = addon.db.profile.ButtonFacade
		group:Skin(skin.skinID, skin.gloss, skin.backdrop, skin.colors)
	end)

	function iconProto:Skin()
		-- Extract existing data
		local data = {
			Icon = self.texture,
			Cooldown = self.cooldown,
			Border = self.border,
			Count = self.smallText,
		}

		-- Create a bunch of texture to skin
		data.Backdrop = self:CreateTexture(nil, "BACKGROUND")
		data.Backdrop:SetAllPoints(self)
		data.Normal = self:CreateTexture(nil, "ARTWORK")
		data.Normal:SetAllPoints(self)
		self.SetNormalTexture = function(_, ...) return data.Normal:SetTexture(...) end

		-- Register the icon
		group:AddButton(self, data)
	end

else
	 -- NOOP
	function iconProto:Skin() end
end

function iconProto:Update(texture, count, duration, expireTime)
	local txt, r, g, b = tostring(count), 1, 1, 1
	if TEXTS[count] then
		txt, r, g, b = unpack(TEXTS[count])
	end
	self.texture:SetTexture(texture)
	if self.cooldown then
		self.cooldown:SetCooldown(expireTime-duration, duration)
	end
	self.bigText:SetTextColor(r, g, b)
	self.border:SetVertexColor(r, g, b, 1)

	local timer
	if addon.db.profile.bigTimer or addon.db.profile.immunityOnly then
		timer = self.bigText
		self.smallText:Hide()
	else
		timer = self.smallText
		local text = self.bigText
		text:SetText(txt)
		FitTextSize(text, self:GetWidth())
		text:Show()
	end

	self.timer, timer.expireTime, timer.timeLeft = timer, expireTime
	timer:Show()
	self:UpdateTimer()
end

function iconProto:SetAnchor(to, direction, spacing)
	self:ClearAllPoints()
	local anchor, relPoint, xOffset, yOffset = unpack(ANCHORING[direction])
	if to then
		self:SetPoint(anchor, to, relPoint, spacing * xOffset, spacing * yOffset)
	else
		self:SetPoint(anchor)
	end
end

function iconProto:Initialize(iconSize, noCooldown)
	self:SetSize(iconSize, iconSize)

	local texture = self:CreateTexture(nil, "ARTWORK")
	texture:SetAllPoints(self)
	texture:SetTexCoord(4/64, 60/64, 4/64, 60/64)
	texture:SetTexture(1,1,1,1)
	self.texture = texture

	local border = self:CreateTexture(nil, "OVERLAY")
	border:SetAllPoints(self)
	border:SetTexture([[Interface\AddOns\DiminishingReturns\icon_border]])
	self.border = border

	local textFrame = CreateFrame("Frame", nil, self)
	textFrame:SetAllPoints(self)

	if not noCooldown then
		local cooldown = CreateFrame("Cooldown", nil, self)
		cooldown:SetAllPoints(self)
		cooldown.noCooldownCount = true
		self.cooldown = cooldown

		textFrame:SetFrameLevel(cooldown:GetFrameLevel()+2)
	end

	local bigText = textFrame:CreateFontString(nil, "OVERLAY")
	bigText.fontSize = FONT_SIZE
	bigText:SetFont(FONT_NAME, bigText.fontSize, FONT_FLAGS)
	bigText:SetTextColor(1, 1, 1, 1)
	bigText:SetAllPoints(self)
	bigText:SetJustifyH("CENTER")
	bigText:SetJustifyV("MIDDLE")
	self.bigText = bigText

	local smallText = textFrame:CreateFontString(nil, "OVERLAY")
	smallText.fontSize = 10
	smallText:SetFont(FONT_NAME, smallText.fontSize, FONT_FLAGS)
	smallText:SetTextColor(1, 1, 1, 1)
	smallText:SetAllPoints(self)
	smallText:SetJustifyH("CENTER")
	smallText:SetJustifyV("BOTTOM")
	self.smallText = smallText

	self:SetScript('OnUpdate', self.UpdateTimer)

	self:Skin()
end

local frameProto = setmetatable({}, { __index = templateFrame })
local frameMeta = { __index = frameProto }

addon:EmbedEventDispatcher(frameProto)

function frameProto:GetIcon()
	local icon = next(self.iconHeap)
	if not icon then
		icon = setmetatable(CreateFrame("Frame", nil, self), iconMeta)
		icon:Initialize(self.iconSize, self.noCooldown)
		icon.Release = function()
			self.iconHeap[icon] = true
			icon:Hide()
		end
	else
		self.iconHeap[icon] = nil
	end
	return icon
end

function frameProto:UpdateSize()
	local iconSize, spacing = self.iconSize, self.spacing
	local barSize = iconSize + max((iconSize + spacing) * (#(self.activeIcons) - 1), 0)
	if ANCHORING[self.direction][3] ~= 0 then
		self:SetSize(barSize, iconSize)
	else
		self:SetSize(iconSize, barSize)
	end
end

function frameProto:RemoveDR(event, guid, cat)
	if guid ~= self.guid then return end
	local activeIcons = self.activeIcons
	local index
	for i, icon in ipairs(activeIcons) do
		if icon.category == cat then
			tremove(activeIcons, i)
			icon:Release()
			self:UpdateSize()
			index = i
			break
		end
	end
	if not index or not activeIcons[index] then return end
	activeIcons[index]:SetAnchor(activeIcons[index-1], self.direction, self.spacing)
end

function frameProto:UpdateDR(event, guid, cat, isFriend, texture, count, duration, expireTime)
	if guid ~= self.guid or not addon.db.profile.categories[cat] or (isFriend and not addon.db.profile.friendly) then
		return
	end
	if count == 0 or (count < 3 and addon.db.profile.immunityOnly) then
		self:RemoveDR(event, guid, cat)
		return true
	end
	local activeIcons = self.activeIcons
	for i, icon in ipairs(activeIcons) do
		if icon.category == cat then
			icon:Update(texture, count, duration, expireTime)
			return true
		end
	end
	local previous = #activeIcons
	local icon = self:GetIcon()
	icon.category = cat
	tinsert(activeIcons, icon)
	icon:SetAnchor(activeIcons[previous], self.direction, self.spacing)
	icon:Show()
	icon:Update(texture, count, duration, expireTime)
	self:UpdateSize()
	return true
end

function frameProto:RefreshAllIcons()
	local activeIcons = self.activeIcons
	for i, icon in ipairs(activeIcons) do
		icon:Release()
	end
	wipe(activeIcons)
	if self.guid then
		local guid = self.guid
		for cat, isFriend, texture, count, duration, expireTime in addon:IterateDR(guid) do
			self:UpdateDR("UpdateGUID", guid, cat, isFriend, texture, count, duration, expireTime)
		end
	else
		return self:Hide()
	end
	return self:Show()
end

function frameProto:UpdateGUID()
	local guid = self:GetGUID()
	if guid == self.guid then return end
	self.guid = guid
	self:RefreshAllIcons()
	return true
end

function frameProto:UpdateStatus()
	local enabled = (addon.active or self.testMode) and self.anchor:IsVisible() and self:GetDatabase().enabled
	if enabled then
		if not self.enabled then
			self.enabled = true
			self:RegisterMessage('UpdateDR')
			self:RegisterMessage('RemoveDR')
			self:OnEnable()
		end
		if not self:UpdateGUID() then
			self:RefreshAllIcons()
		end
	elseif self.enabled then
		self.guid, self.enabled = nil, false
		self:UnregisterMessage('UpdateDR')
		self:UnregisterMessage('RemoveDR')
		self:OnDisable()
		self:Hide()
	end
end

function frameProto:OnEnable() end
function frameProto:OnDisable() end
function frameProto:GetGUID() end

function frameProto:SetTestMode(event, value)
	self.testMode = value
	self:UpdateStatus()
end

function frameProto:OnFrameConfigChanged(event, key)
	local db = self:GetDatabase()
	local anchorPoint, iconSize, direction, spacing = db.anchorPoint, db.iconSize, db.direction, db.spacing
	self:ClearAllPoints()
	self:SetPoint(anchorPoint, db.screenAnchor and _G.UIParent or self.anchor, db.relPoint, db.xOffset, db.yOffset)
	if self.anchorPoint ~= anchorPoint or self.iconSize ~= iconSize or self.direction ~= direction or self.spacing ~= spacing then
		self.anchorPoint = anchorPoint
		self.iconSize = iconSize
		self.direction = direction
		self.spacing = spacing
		local activeIcons = self.activeIcons
		for i, icon in ipairs(activeIcons) do
			icon:SetSize(iconSize, iconSize)
		end
	end
	self:UpdateStatus()
end

function frameProto:Initialize(anchor)
	self:Hide()

	self.activeIcons = {}
	self.iconHeap = {}

	self.anchor = anchor
	self:SetSize(1, 1)

	local anchorWatch = function() return self:UpdateStatus() end
	anchor:HookScript('OnShow', anchorWatch)
	anchor:HookScript('OnHide', anchorWatch)

	self:RegisterMessage('EnableDR', 'UpdateStatus')
	self:RegisterMessage('DisableDR', 'UpdateStatus')
	self:RegisterMessage('SetTestMode')
	self:RegisterMessage('OnConfigChanged', 'UpdateStatus')
	self:RegisterMessage('OnFrameConfigChanged')
	self:RegisterMessage('OnProfileChanged', 'OnFrameConfigChanged')

	self:OnFrameConfigChanged('Initialize')
end

function addon:SpawnGenericFrame(anchor, GetDatabase, GetGUID, OnEnable, OnDisable, ...)
	addon:Debug('Attaching to frame', anchor:GetName())

	local frame = setmetatable(CreateFrame("Frame", anchor:GetName().."DR", anchor), frameMeta)

	frame.GetDatabase = GetDatabase
	frame.GetGUID = GetGUID
	frame.OnEnable = OnEnable
	frame.OnDisable = OnDisable

	-- Setup arbitrary values
	for i = 1, select('#', ...), 2 do
		local k, v = select(i, ...)
		frame[k] = v
	end

	frame:Initialize(anchor)

	return frame
end

-- SecureUnitButtonTemplate specific handling

local function OnSecureEnable(self)
	local unit = self:GetUnit()
	if unit == "target" then
		self:RegisterEvent('PLAYER_TARGET_CHANGED', 'UpdateGUID')
	elseif unit == "focus" then
		self:RegisterEvent('PLAYER_FOCUS_CHANGED', 'UpdateGUID')
	elseif strsub(unit, 1, 5) == "arena" then
		self:RegisterEvent('ARENA_OPPONENT_UPDATE', 'UpdateGUID')
	elseif strsub(unit, 1, 5) == "party" or strsub(unit, 1, 4) == "raid" then
		self:RegisterEvent('GROUP_ROSTER_UPDATE', 'UpdateGUID')
	end
end

local function OnSecureDisable(self)
	self:UnregisterEvent('PLAYER_TARGET_CHANGED')
	self:UnregisterEvent('PLAYER_FOCUS_CHANGED')
	self:UnregisterEvent('ARENA_OPPONENT_UPDATE')
	self:UnregisterEvent('GROUP_ROSTER_UPDATE')
end

local function GetSecureGUID(self)
	return UnitGUID(self:GetUnit())
end

function addon:SpawnFrame(anchor, secure, GetDatabase)
	local frame = addon:SpawnGenericFrame(anchor, GetDatabase, GetSecureGUID, OnSecureEnable, OnSecureDisable,
		'GetUnit', function() return SecureButton_GetModifiedUnit(secure) or "" end
	)
	secure:HookScript('OnAttributeChanged', function(_, name)
		if name == "unit" and addon.active and frame.enabled then
			frame:OnDisable()
			frame:OnEnable()
			frame:UpdateGUID()
		end
	end)
	return frame
end
