local addon = DiminishingReturns
if not addon then return end

local function SetupFrame(frame)
	return addon:SpawnFrame(frame, frame, 24, 'RIGHT', 2, 'TOPLEFT', 'BOTTOMLEFT', 0, -4)
end
--RegisterFrameSetup('SUFUnitplayer', SetupFrame)
RegisterFrameSetup('SUFUnittarget', SetupFrame)