local addon = DiminishingReturns
if not addon then return end

local function SetupFrame(frame)
	return addon:SpawnFrame(frame:GetParent(), frame, 32, 'LEFT', 2, 'TOPRIGHT', 'TOPLEFT', -10, 0)
end

for i = 1,5 do
	addon:RegisterFrameSetup('GladiusButton'..i, SetupFrame)
end

hooksecurefunc(Gladius, 'UpdateAttribute', function(gladius, unit)
	addon:CheckPendingSetup(gladius.buttons[unit].secure)
end)
	