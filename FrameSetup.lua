local addon = DiminishingReturns
if not addon then return end

local pendingSetup

function addon:CheckPendingSetup(frame)
	local name = frame and frame:GetName()
	local setup = name and pendingSetup[name]
	if setup then
		pendingSetup[name] = nil
		return setup(frame)
	end
end
local function CheckPendingSetup(...) 
	return addon:CheckPendingSetup(...)
end

function addon:RegisterFrameSetup(frameName, setupFunc)
	local frame = _G[frameName]
	if frame then
		return setupFunc(frame)
	else
		if not pendingSetup then
			pendingSetup = {}
			hooksecurefunc('RegisterUnitWatch', CheckPendingSetup)
		end
		pendingSetup[frameName] = setupFunc
	end
end
