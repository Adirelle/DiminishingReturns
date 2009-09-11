local addon = DiminishingReturns
if not addon then return end

local FONT_NAME, FONT_SIZE, FONT_FLAGS = GameFontNormal:GetFont(), 24, "OUTLINE"

local ANCHORING = {
	LEFT   = { "RIGHT",  "LEFT",   -1,  0 },
	RIGHT  = { "LEFT",   "RIGHT",   1,  0 },
	TOP    = { "BOTTOM", "TOP",     0,  1 },
	BOTTOM = { "TOP",    "BOTTOM",  0, -1 },
}

local TEXTS = {
	{ "50%", 1.0, 1.0, 0.0 },
	{ "25%", 1.0, 0.5, 0.0 },
	{ "IMM", 1.0, 0.0, 0.0 }
}

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
	cooldown:SetReverse(true)
	cooldown.noCooldownCount = true
	icon.cooldown = cooldown
	
	local text = icon:CreateFontString(nil, "OVERLAY")
	text:SetFont(FONT_NAME, FONT_SIZE, FONT_FLAGS)
	text:SetTextColor(1, 1, 1, 1)	
	text:SetAllPoints(icon)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("CENTER")
	icon.text = text
	
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

	local text = icon.text
	text:SetText(txt)
	text:SetTextColor(r, g, b)
	text:SetFont(FONT_NAME, FONT_SIZE, FONT_FLAGS)
	local sizeRatio = text:GetStringWidth() / (icon:GetWidth()-4)
	if sizeRatio > 1 then
		text:SetFont(FONT_NAME, FONT_SIZE / sizeRatio, FONT_FLAGS)
	end
end

function UpdateDR(self, event, guid, cat, texture, count, duration, expireTime)
	if guid ~= self.guid then return end
	local activeIcons = self.activeIcons
	for i, icon in ipairs(activeIcons) do
		if icon.category == cat then
			return UpdateIcon(icon, texture, count, duration, expireTime)
		end
	end
	local previous = #activeIcons
	icon = tremove(self.iconHeap) or self:SpawnIcon()
	icon.category = cat
	tinsert(activeIcons, icon)
	SetAnchor(icon, activeIcons[previous], self.direction, self.spacing, self.anchorPoint, self)
	icon:Show()
	UpdateIcon(icon, texture, count, duration, expireTime)
end

local function UpdateGUID(self)
	local guid = self.unit and UnitGUID(self.unit)
	if guid == self.guid then return end
	self.guid = guid
	local activeIcons = self.activeIcons
	for i, icon in ipairs(activeIcons) do
		icon:Hide()
		self.iconHeap[icon] = true
	end
	wipe(activeIcons)
	if guid then
		for cat, texture, count, duration, expireTime in addon:IterateDR(guid) do
			UpdateDR(self, "UpdateGUID", guid, cat, texture, count, duration, expireTime)
		end
		self:Show()
	else
		self:Hide()
	end
end

local guidCheckEvents = {
	PLAYER_TARGET_CHANGED = '^target$',
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

local function Enable(self)
	UpdateUnit(self)
end

local function Disable(self)
	self.unit = nil
	UnregisterGUIDEvents(self)
	self:Hide()
end

local lae = LibStub('LibAdiEvent-1.0')

function addon:SpawnFrame(anchor, secure, iconSize, direction, spacing, anchorPoint, relPoint, x, y)
	local frame = CreateFrame("Frame", nil, anchor)
	frame:Hide()

	frame.secure = secure
	frame.activeIcons = {}
	frame.iconHeap = {}
	frame.iconSize = iconSize or 16
	frame.direction = direction or "LEFT"
	frame.spacing = spacing or 2
	
	if not anchorPoint then
		anchorPoint, relPoint, x, y = unpack(ANCHORING[direction])
	end
	frame.anchorPoint = anchorPoint
	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:SetPoint(anchorPoint, anchor, relPoint, x, y)	
	
	lae.Embed(frame)
	
	frame:RegisterEvent('UpdateDR', UpdateDR)
	frame:RegisterEvent('RemoveDR', RemoveDR)
	frame:RegisterEvent('EnableDR', Enable)
	frame:RegisterEvent('DisableDR', Disable)

	secure:HookScript('OnAttributeChanged', function(self, name, unit)
		if name == "unit" and addon.active then
			UpdateUnit(frame, unit)
		end
	end)

	if addon.active then
		Enable(frame)
	end

	return frame
end
