local addon = DiminishingReturns
if not addon then return end

local FONT_NAME, FONT_SIZE, FONT_FLAGS = GameFontNormal:GetFont(), 16, "OUTLINE"

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

local borderBackdrop = {
	edgeFile = [[Interface\Addons\DiminishingReturns\white16x16]],
	edgeSize = 1, 	
	insets = {left = 1, right = 1, top = 1, bottom = 1},
}

local function FitTextSize(text, width, height)
	local name, _, flags = text:GetFont()
	text:SetFont(name, text.fontSize, flags)
	local ratio = text:GetStringWidth() / (width-2)
	if height then
		ratio = math.max(ratio, text:GetStringHeight() / (height-2))
	end
	if ratio > 1 then
		text:SetFont(name, text.fontSize / ratio, flags)
	end
end

local ceil, GetTime, strformat = math.ceil, GetTime, string.format

local function UpdateTimer(self)
	local timer = self.timer
	if not timer.expireTime then return end	
	local timeLeft = timer.expireTime - GetTime()
	if timeLeft <= 0 then
		timer.expireTimer, timer.timeLeft = nil, nil
		return timer:Hide()
	elseif timeLeft < 3 and addon.db.profile.bigTimer then
		timeLeft = strformat("%.1f", ceil(timeLeft * 10) / 10)
	else
		timeLeft = tostring(ceil(timeLeft))
	end
	if timeLeft ~= timer.timeLeft then
		timer.timeLeft = timeLeft
		timer:SetText(tostring(timeLeft))
		FitTextSize(timer, self:GetWidth())
	end
end

local function SpawnIcon(self)
	local icon = CreateFrame("Frame", nil, self)
	icon:SetWidth(self.iconSize)
	icon:SetHeight(self.iconSize)
	
	local texture = icon:CreateTexture(nil, "ARTWORK")
	texture:SetAllPoints(icon)
	texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	texture:SetTexture(1,1,1,1)
	icon.texture = texture
	
	local cooldown = CreateFrame("Cooldown", nil, icon)
	cooldown:SetAllPoints(icon)
	cooldown:SetDrawEdge(true)
	cooldown.noCooldownCount = true
	icon.cooldown = cooldown
	
	local border = CreateFrame("Frame", nil, icon)
	border:SetPoint("CENTER", icon)
	border:SetWidth(self.iconSize + 2)
	border:SetHeight(self.iconSize + 2)
	border:SetBackdrop(borderBackdrop)
	border:SetBackdropColor(0, 0, 0, 0)
	border:SetBackdropBorderColor(1, 1, 1, 1)
	icon.border = border

	local textFrame = CreateFrame("Frame", nil, icon)
	textFrame:SetAllPoints(icon)
	textFrame:SetFrameLevel(cooldown:GetFrameLevel()+2)
	
	local bigText = textFrame:CreateFontString(nil, "OVERLAY")
	bigText.fontSize = FONT_SIZE
	bigText:SetFont(FONT_NAME, bigText.fontSize, FONT_FLAGS)
	bigText:SetTextColor(1, 1, 1, 1)	
	bigText:SetAllPoints(icon)
	bigText:SetJustifyH("CENTER")
	bigText:SetJustifyV("MIDDLE")
	icon.bigText = bigText
	
	local smallText = textFrame:CreateFontString(nil, "OVERLAY")
	smallText.fontSize = 10
	smallText:SetFont(FONT_NAME, smallText.fontSize, FONT_FLAGS)
	smallText:SetTextColor(1, 1, 1, 1)	
	smallText:SetAllPoints(icon)
	smallText:SetJustifyH("CENTER")
	smallText:SetJustifyV("BOTTOM")
	icon.smallText = smallText
	
	icon:SetScript('OnUpdate', UpdateTimer)
	
	return icon
end

function SetAnchor(self, to, direction, spacing, defaultAnchor, defaultTo)
	self:ClearAllPoints()
	if to then
		local anchor, relPoint, xOffset, yOffset = unpack(ANCHORING[direction])
		self:SetPoint(anchor, to, relPoint, spacing * xOffset, spacing * yOffset)
	else
		self:SetPoint(defaultAnchor, defaultTo)
	end
end

function RemoveDR(self, event, guid, cat)
	if guid ~= self.guid then return end
	local activeIcons = self.activeIcons
	local index
	for i, icon in ipairs(activeIcons) do
		if icon.category == cat then
			tremove(activeIcons, i)
			self.iconHeap[icon] = true
			icon:Hide()
			index = i
			break
		end
	end
	if not index or not activeIcons[index] then return end
	SetAnchor(activeIcons[index], activeIcons[index-1], self.direction, self.spacing, self.anchorPoint, self)
end

function UpdateIcon(icon, texture, count, duration, expireTime)
	local txt, r, g, b = tostring(count), 1, 1, 1
	if TEXTS[count] then
		txt, r, g, b = unpack(TEXTS[count])
	end
	icon.texture:SetTexture(texture)
	icon.cooldown:SetCooldown(expireTime-duration, duration)
	icon.bigText:SetTextColor(r, g, b)
	icon.border:SetBackdropBorderColor(r, g, b, 1)
	
	local timer
	if addon.db.profile.bigTimer then
		timer = icon.bigText
		icon.smallText:Hide()
	else
		timer = icon.smallText		
		local text = icon.bigText
		text:SetText(txt)
		FitTextSize(text, icon:GetWidth())
		text:Show()	
	end	
	
	icon.timer, timer.expireTime, timer.timeLeft = timer, expireTime
	timer:Show()
	UpdateTimer(icon)
end

function UpdateDR(self, event, guid, cat, texture, count, duration, expireTime)
	if guid ~= self.guid or not addon.db.profile.categories[cat] then 
		return
	end
	local activeIcons = self.activeIcons
	for i, icon in ipairs(activeIcons) do
		if icon.category == cat then
			return UpdateIcon(icon, texture, count, duration, expireTime)
		end
	end
	local previous = #activeIcons
	icon = tremove(self.iconHeap) or SpawnIcon(self)
	icon.category = cat
	tinsert(activeIcons, icon)
	SetAnchor(icon, activeIcons[previous], self.direction, self.spacing, self.anchorPoint, self)
	icon:Show()
	UpdateIcon(icon, texture, count, duration, expireTime)
end

local function HideAllIcons(self)
	local activeIcons = self.activeIcons
	for i, icon in ipairs(activeIcons) do
		icon:Hide()
		self.iconHeap[icon] = true
	end
	wipe(activeIcons)
end

local function RefreshAllIcons(self)
	HideAllIcons(self)
	if self.testMode then
		local count = 1
		for cat in pairs(addon.CATEGORIES) do
			UpdateDR(self, "ToggleTestMode", self.guid, cat, addon.ICONS[cat], count, 15, GetTime()-2*count+15)
			count = (count == 3) and 1 or (count+1)
		end
		self:Show()	
	elseif self.guid then
		local guid = self.guid
		for cat, texture, count, duration, expireTime in addon:IterateDR(guid) do
			UpdateDR(self, "UpdateGUID", guid, cat, texture, count, duration, expireTime)
		end
		self:Show()
	else
		self:Hide()
	end
end

local function UpdateGUID(self)
	local guid = self.unit and UnitGUID(self.unit)
	if guid == self.guid then return end
	self.guid = guid
	RefreshAllIcons(self)
end

local guidCheckEvents = {
	PLAYER_TARGET_CHANGED = '^target$',
	PLAYER_FOCUS_CHANGED = '^focus$',
	ARENA_OPPONENT_UPDATE = '^arena',
	PARTY_MEMBERS_CHANGED = '^party',
	RAID_ROSTER_UPDATE = '^raid',
}

local function UnregisterGUIDEvents(self)
	for event in pairs(guidCheckEvents) do
		self:UnregisterEvent(event, UpdateGUID)
	end
end

local function RegisterGUIDEvents(self)
	local unit = self.unit
	for event, pattern in pairs(guidCheckEvents) do
		if unit:match(pattern) then
			self:RegisterEvent(event, UpdateGUID)
		end
	end
end

local function UpdateUnit(self, unit)
	unit = unit or self.secure:GetAttribute('unit')
	local oldUnit = self.unit
	if unit == oldUnit then return end
	UnregisterGUIDEvents(self)
	self.unit = unit
	RegisterGUIDEvents(self)
	UpdateGUID(self)
end

local function UpdateStatus(self)
	local enabled = (addon.active or self.testMode) and self:GetDatabase().enabled
	if enabled then
		if self.enabled then
			RefreshAllIcons(self)
		else
			self.enabled = true
			UpdateUnit(self)
		end
	elseif self.enabled then
		self.unit, self.guid, self.enabled = nil, nil, false
		UnregisterGUIDEvents(self)
		self:Hide()
	end
end

local function SetTestMode(self, event, value)
	self.testMode = value
	UpdateStatus(self)
end

local function OnFrameConfigChanged(self)
	local db = self:GetDatabase()
	local anchorPoint, iconSize, direction, spacing = db.anchorPoint, db.iconSize, db.direction, db.spacing
	self:ClearAllPoints()
	self:SetPoint(anchorPoint, self.anchor, db.relPoint, db.xOffset, db.yOffset)		
	if self.anchorPoint ~= anchorPoint or self.iconSize ~= iconSize or self.direction ~= direction or self.spacing ~= spacing then
		self.anchorPoint = anchorPoint
		self.iconSize = iconSize
		self.direction = direction
		self.spacing = spacing
		local activeIcons = self.activeIcons
		for i, icon in ipairs(activeIcons) do
			icon:SetWidth(iconSize)
			icon:SetHeight(iconSize)
		end
	end
	UpdateStatus(self)
end

local lae = LibStub('LibAdiEvent-1.0')

function addon:SpawnFrame(anchor, secure, GetDatabase) -- iconSize, direction, spacing, anchorPoint, relPoint, x, y)
	local frame = CreateFrame("Frame", nil, anchor)
	frame:Hide()
	
	frame.secure = secure
	frame.activeIcons = {}
	frame.iconHeap = {}
	
	frame.GetDatabase = GetDatabase
	
	frame.anchor = anchor
	frame:SetWidth(1)
	frame:SetHeight(1)

	lae.Embed(frame)
	frame:SetMessageChannel(addon)

	frame:RegisterEvent('UpdateDR', UpdateDR)
	frame:RegisterEvent('RemoveDR', RemoveDR)
	frame:RegisterEvent('EnableDR', UpdateStatus)
	frame:RegisterEvent('DisableDR', UpdateStatus)
	frame:RegisterEvent('SetTestMode', SetTestMode)
	frame:RegisterEvent('OnConfigChanged', UpdateStatus)
	frame:RegisterEvent('OnFrameConfigChanged', OnFrameConfigChanged)
	frame:RegisterEvent('OnProfileChanged', OnFrameConfigChanged)
	
	secure:HookScript('OnAttributeChanged', function(self, name, unit)
		if name == "unit" and addon.active and frame.enabled then
			UpdateUnit(frame, unit)
		end
	end)

	OnFrameConfigChanged(frame)

	return frame
end
