local MAJOR, MINOR = 'LibAdiEvent-1.0', 2
local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

lib.eventMeta = lib.eventMeta or {}
lib.embeds = lib.embeds or {}
lib.handlers = lib.handlers or {}

local eventMeta, embeds, handlers = lib.eventMeta, lib.embeds, lib.handlers

function eventMeta.__call(funcs, ...) 
	for _, func in pairs(funcs) do 
		func(...) 
	end 
end

local function OnEvent(self, event, ...)
	local handler = handlers[self][event]
	if handler then
		handler(self, event, ...)
	end
end

local function RegisterEvent(self, event, handler)
	assert(type(event) == "string", "RegisterEvent(event, handler): event must be a string")
	handler = handler or event
	if type(handler) == "string" then
		handler = self[handler]
	end
	assert(type(handler) == "function", "RegisterEvent(event, handler): handler must resolve to a function or a method name")	
	local prevHandler = handlers[self][event]
	if not prevHandler then
		self:__RegisterEvent(event)	
		handlers[self][event] = handler
	elseif type(prevHandler) == "function" and handler ~= prevHandler then
		handlers[self][event] = setmetatable({prevHandler, handler}, lib.eventMeta)
	elseif type(prevHandler) == "table" then
		for i, func in pairs(prevHandler) do
			if func == handler then return end
		end
		tinsert(prevHandler, handler)
	end
end

local function UnregisterEvent(self, event, handler)
	assert(type(event) == "string", "UnregisterEvent(event, handler): event must be a string")
	handler = handler or event
	if type(handler) == "string" then
		handler = self[handler]
	end	
	assert(type(handler) == "function", "UnregisterEvent(event, handler): handler must resolve to a function or a method name")
	local prevHandler = handlers[self][event]
	if type(prevHandler) == "function" and handler == prevHandler then
		self:__UnregisterEvent(event)
		handlers[self][event] = nil
	elseif type(prevHandler) == "table" then
		for i, func in pairs(prevHandler) do
			if func == handler then
				tremove(prevHandler, i)
				break
			end
		end
		if #prevHandler == 0 then
			self:__UnregisterEvent(event)
		end
	end
end

local function TriggerMessage(self, ...)
	for target in pairs(embeds) do
		target:TriggerEvent(...)
	end
end

function lib.Embed(target)
	embeds[target] = true
	handlers[target] = {}
	target.__RegisterEvent = target.__RegisterEvent or target.RegisterEvent
	target.__UnregisterEvent = target.__UnregisterEvent or target.UnregisterEvent
	target:SetScript('OnEvent', OnEvent)
	target.TriggerEvent = OnEvent
	target.RegisterEvent = RegisterEvent
	target.UnregisterEvent = UnregisterEvent
	target.TriggerMessage = TriggerMessage
end

for target in pairs(embeds) do
	lib.Embed(target)
end

