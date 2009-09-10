local addon = DiminishingReturns
if not addon then return end

local function SpawnIcon(self)
	local icon = CreateFrame("Frame", nil, self)
	icon:SetWidth(self.iconSize)
	icon:SetHeight(self.iconSize)
	
	local texture = icon:CreateTexture(nil, "ARTWORK")
	texture:SetAllPoints(icon)
	--texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	texture:SetTexture(1,1,1,1)
	icon.texture = texture
	
	local cooldown = CreateFrame("Cooldown", nil, icon)
	cooldown:SetAllPoints(icon)
	cooldown:SetReverse(true)
	cooldown.noCooldownCount = true
	icon.cooldown = cooldown
	
	local text = icon:CreateFontString(nil, "ARTWORK")
	text:SetFont(GameFontNormal:GetFont(), 10, "OUTLINE")
	text:SetTextColor(1, 1, 1, 1)	
	text:SetAllPoints(icon)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("CENTER")
	icon.text = text
	
	return icon
end

local anchoring = {
	LEFT   = { "RIGHT",  "LEFT",   -1,  0 },
	RIGHT  = { "LEFT",   "RIGHT",   1,  0 },
	TOP    = { "BOTTOM", "TOP",     0,  1 },
	BOTTOM = { "TOP",    "BOTTOM",  0, -1 },
}

function SetAnchor(self, to, direction, spacing, defaultAnchor, defaultTo)
	self:ClearAllPoints()
	if to then
		local anchor, relPoint, xOffset, yOffset = unpack(anchoring[direction])
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

local textDisplay = {
	{ "50%", 1.0, 1.0, 0.0 },
	{ "25%", 1.0, 0.5, 0.0 },
	{ "IMM", 1.0, 0.0, 0.0 }
}

function UpdateIcon(icon, texture, count, duration, expireTime)
	local txt, r, g, b = tostring(count), 1, 1, 1
	if textDisplay[count] then
		txt, r, g, b = unpack(textDisplay[count])
	end
	icon.text:SetText(txt)
	icon.text:SetTextColor(r, g, b)
	icon.texture:SetTexture(texture)
	--icon.texture:SetVertexColor(r, g, b, a)
	icon.cooldown:SetCooldown(expireTime-duration, duration)
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
	UpdateIcon(icon, texture, count, duration, expireTime)
	icon:Show()
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

local function UpdateGUIDListening(self, event, pattern, oldUnit, newUnit)
	if oldUnit and oldUnit:match(pattern) then
		self:UnregisterEvent(event, UpdateGUID)
	end
	if newUnit and newUnit:match(pattern) then
		self:RegisterEvent(event, UpdateGUID)
	end
end

local function UpdateUnit(self, unit)
	unit = unit or self.secure:GetAttribute('unit')
	local oldUnit = self.unit
	if unit == oldUnit then return end
	self.unit = unit
	UpdateGUIDListening(self, 'PLAYER_TARGET_CHANGED', '^target$', oldUnit, unit)
	UpdateGUIDListening(self, 'ARENA_OPPONENT_UPDATE', '^arena', oldUnit, unit)
	UpdateGUIDListening(self, 'PARTY_MEMBERS_CHANGED', '^party', oldUnit, unit)
	UpdateGUIDListening(self, 'RAID_ROSTER_UPDATE', '^raid', oldUnit, unit)
	UpdateGUID(self)
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
		anchorPoint, relPoint, x, y = unpack(anchoring[direction])
	end
	frame.anchorPoint = anchorPoint
	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:SetPoint(anchorPoint, anchor, relPoint, x, y)	
	
	lae.Embed(frame)
	
	frame:RegisterEvent('UpdateDR', UpdateDR)
	frame:RegisterEvent('RemoveDR', RemoveDR)
	
	frame.SpawnIcon = SpawnIcon
	frame.UpdateGUID = UpdateGUID
	frame.UpdateUnit = UpdateUnit
	
	secure:HookScript('OnAttributeChanged', function(self, name, unit)
		if name == "unit" then
			UpdateUnit(frame, unit)
		end
	end)

	frame:UpdateUnit()

	return frame
end
