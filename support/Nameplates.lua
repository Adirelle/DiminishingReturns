--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

--<GLOBALS
local _G = _G
local hooksecurefunc = _G.hooksecurefunc
--GLOBALS>

addon:RegisterAddonSupport('LibNameplateRegistry-1.0', function()
	local lib, version = LibStub('LibNameplateRegistry-1.0', true)

	local db = addon.db:RegisterNamespace('Nameplates', {profile={
		enabled = true,
		iconSize = 16,
		direction = 'RIGHT',
		spacing = 2,
		anchorPoint = 'TOP',
		relPoint = 'BOTTOM',
		xOffset = 0,
		yOffset = 0,
	}})

	local function GetDatabase()
		return db.profile, db
	end

	local function GetNameplateGUID(self)
		return lib:GetPlateGUID(self.anchor) or nil
	end

	local function OnNameplateEnable(self)
		lib.LNR_RegisterCallback(self, "LNR_ON_GUID_FOUND", "UpdateGUID")
		lib.LNR_RegisterCallback(self, "LNR_ON_RECYCLE_PLATE", "UpdateGUID")
	end

	local function OnNameplateDisable(self)
		lib.LNR_UnregisterAllCallbacks(self)
	end

	addon:RegisterFrameConfig('Nameplates', GetDatabase)

	local seen = {}
	lib.LNR_RegisterCallback(addon, 'LNR_ON_NEW_PLATE', function(_ , nameplate)
		if seen[nameplate] or seen[nameplate:GetParent()] then return end
		seen[nameplate] = true
		addon:Debug("Detected new nameplate", nameplate:GetName() or "anonymous")
		return addon:SpawnGenericFrame(nameplate, GetDatabase, GetNameplateGUID, OnNameplateEnable, OnNameplateDisable, 'noCooldown', true)
	end)

	return 'supported', version
end)
