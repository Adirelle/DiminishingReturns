DiminishingReturns = CreateFrame("Frame")
local addon = DiminishingReturns

--------------------------------------------------------------------------------
-- Smart event handling
--------------------------------------------------------------------------------

local eventMeta = { __call = function(funcs, ...) for _, func in pairs(funcs) do func(...) end end}

local function OnEvent(self, event, ...)
	local handler = self[event]
	if handler then
		handler(self, event, ...)
	end
end

local function RegisterEvent(self, event, handler)
	assert(type(event) == "string", "RegisterEvent(event, handler): event must be a string")
	handler = handler or event
	if type(handler) ~= "function" then
		func = self[tostring(handler)]
	end
	assert(type(handler) == "function", "RegisterEvent(event, handler): handler must resolve to a function or a method name")
	local prevHandler = self[event]
	if not prevHandler then
		self[event] = handler
		self:__RegisterEvent( event)
	elseif type(prevHandler) == "function" and handler ~= prevHandler then
		self[event] = setmetatable({prevHandler, handler}, eventMeta)
	elseif type(prevHandler) == "table" then
		for i, func in pairs(prevHandler) do
			if func == handler then return end
		end
		if #prevHandler == 0 then
			self:__RegisterEvent( event)
		end
		tinsert(prevHandler, handler)
	end
end

local function UnregisterEvent(self, event, handler)
	assert(type(event) == "string", "UnregisterEvent(event, handler): event must be a string")
	handler = handler or event
	if type(handler) ~= "function" then
		func = self[tostring(handler)]
	end
	assert(type(handler) == "function", "UnregisterEvent(event, handler): handler must resolve to a function or a method name")
	local prevHandler = self[event]
	if type(prevHandler) == "function" and handler == prevHandler then
		self:__UnregisterEvent( event)
		self[event] = nil
	elseif type(prevHandler) == "table" then
		for i, func in pairs(prevHandler) do
			if func == handler then
				tremove(prevHandler, i)
				break
			end
		end
		if #prevHandler == 0 then
			self:__UnregisterEvent( event)
		end
	end
end

local embeds = {}

local function TriggerMessage(self, ...)
	for frame in pairs(embeds) do
		frame:TriggerEvent(...)
	end
end
	
function addon.EmbedEventHandler(target)
	if embeds[target] then return end
	embeds[target] = true
	target:SetScript('OnEvent', OnEvent)
	target.TriggerEvent = OnEvent
	target.__RegisterEvent = target.RegisterEvent
	target.__UnregisterEvent = target.UnregisterEvent
	target.RegisterEvent = RegisterEvent
	target.UnregisterEvent = UnregisterEvent
	target.TriggerMessage = TriggerMessage
end

addon:EmbedEventHandler()
