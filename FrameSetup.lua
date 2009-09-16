local addon = DiminishingReturns
if not addon then return end

local framesToWatch

function addon:CheckFrame(frame)
	local name = frame and frame:GetName()
	local setup = name and framesToWatch[name]
	if setup then
		framesToWatch[name] = nil
		return setup(frame)
	end
end
local function CheckFrame(...) 
	return addon:CheckFrame(...)
end

function addon:RegisterFrame(frameName, setupFunc)
	local frame = _G[frameName]
	if frame then
		return setupFunc(frame)
	else
		if not framesToWatch then
			framesToWatch = {}
			hooksecurefunc('RegisterUnitWatch', CheckFrame)
		end
		framesToWatch[frameName] = setupFunc
	end
end

function addon:RegisterFrameConfig(label, getDatabaseCallback)
	if not addon.pendingFrameConfig then
		addon.pendingFrameConfig = {}
	end
	addon.pendingFrameConfig[label] = getDatabaseCallback
end
