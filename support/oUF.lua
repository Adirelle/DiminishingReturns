--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

--<GLOBALS
local _G = _G
local GetAddOnInfo = _G.GetAddOnInfo
local GetAddOnMetadata = _G.GetAddOnMetadata
local GetNumAddOns = _G.GetNumAddOns
local gsub = _G.gsub
local pairs = _G.pairs
--GLOBALS>

local function InitializeOUF(parent, oUF)
	addon:Debug('InitializeOUF', parent, oUF)

	local db = addon.db:RegisterNamespace(parent, {profile={
		['*'] = {
			enabled = true,
			iconSize = 24,
			direction = 'RIGHT',
			spacing = 2,
			anchorPoint = 'TOPLEFT',
			relPoint = 'BOTTOMLEFT',
			xOffset = 0,
			yOffset = -4,
		}
	}})

	local getDatabaseFuncs = {}

	-- Frame checking code
	local function CheckFrame(frame)
		local unit = frame:GetAttribute('oUF-guessUnit') or frame.unit
		local refUnit = gsub(unit, "%d+$", "")
		if refUnit == "player" or refUnit == "target" or refUnit == "focus" or refUnit == "arena" or refUnit == "party" or refUnit == "raid" then
			local GetDatabase = getDatabaseFuncs[refUnit]
			if not GetDatabase then
				-- Avoid creating several time the same config
				GetDatabase = function() return db.profile[refUnit], db end
				addon:RegisterFrameConfig(parent..': '..addon.L[refUnit], GetDatabase)
				getDatabaseFuncs[refUnit] = GetDatabase
			end
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end
	end

	-- Check existing frames
	for i, frame in pairs(oUF.objects) do
		CheckFrame(frame)
	end

	-- Register check for future frames
	oUF:RegisterInitCallback(CheckFrame)

	return 'supported', oUF.version
end

-- This allow oUF addons to register themselves
function addon:DeclareOUF(parent, oUF)
	addon:Debug('DeclareOUF', parent, oUF)
	addon:RegisterAddonSupport(parent, function()
		return InitializeOUF(parent, oUF)
	end)
end

-- Scan for declared oUF
for index = 1, GetNumAddOns() do
	local global = GetAddOnMetadata(index, 'X-oUF')
	if global then
		local parent = GetAddOnInfo(index)
		addon:RegisterAddonSupport(parent, function()
			local oUF = _G[global]
			if oUF then
				return InitializeOUF(parent, oUF)
			end
		end)
	end
end

