--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

local function XPerlSupport(addonName)
	return function()
		--<GLOBALS
		local _G = _G
		local GetAddOnMetadata = _G.GetAddOnMetadata
		local gsub = _G.gsub
		local hooksecurefunc = _G.hooksecurefunc
		--GLOBALS>

		local db = addon.db:RegisterNamespace(addonName, {profile={
			['*'] = {
				enabled = true,
				iconSize = 24,
				direction = 'RIGHT',
				spacing = 2,
				anchorPoint = 'BOTTOMLEFT',
				relPoint = 'TOPLEFT',
				xOffset = 4,
				yOffset = 4,
			}
		}})

		local function ucfirst(s)
			return s:sub(1,1):upper()..s:sub(2)
		end

		addon:RegisterCommonFrames(function(unit)
			local refUnit = gsub(unit, "%d+$", "")
			local function GetDatabase() return db.profile[refUnit], db end
			addon:RegisterFrameConfig(addonName..': '..addon.L[refUnit], GetDatabase)
			return addon:RegisterFrame('XPerl_'..ucfirst(unit), function(frame)
				return addon:SpawnFrame(frame, frame, GetDatabase)
			end)
		end)

		hooksecurefunc('XPerl_SecureUnitButton_OnLoad', addon.CheckFrame)

		return 'unknown', GetAddOnMetadata(addonName, 'Version')
	end
end

addon:RegisterAddonSupport('XPerl', XPerlSupport('XPerl'))
addon:RegisterAddonSupport('ZPerl', XPerlSupport('ZPerl'))
