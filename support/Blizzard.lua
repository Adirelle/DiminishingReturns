--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

-- FrameXML is a internal fake to have this working like other support
addon:RegisterAddonSupport('FrameXML', function()
	--<GLOBALS
	local _G = _G
	local GetBuildInfo = _G.GetBuildInfo
	local gsub = _G.gsub
	--GLOBALS>

	local defaults = {
		profile = {
			['**'] = {
				enabled = true,
				iconSize = 16,
				spacing = 2,
			},
			player = {
				direction = 'RIGHT',
				anchorPoint = 'BOTTOMLEFT',
				relPoint = 'TOPLEFT',
				xOffset = 110,
				yOffset = -20,
			},
			target = {
				direction = 'RIGHT',
				anchorPoint = 'BOTTOMLEFT',
				relPoint = 'TOPLEFT',
				xOffset = 8,
				yOffset = -20,
			},
			party = {
				direction = 'RIGHT',
				anchorPoint = 'TOPLEFT',
				relPoint = 'TOPRIGHT',
				xOffset = -8,
				yOffset = -28,
			}
		}
	}
	defaults.profile.focus = defaults.profile.target
	defaults.profile.party = defaults.profile.target

	local db = addon.db:RegisterNamespace('Blizzard', defaults)

	local function RegisterFrame(name, unit)
		local refUnit = gsub(unit, "%d+$", "")
		local function GetDatabase() return db.profile[refUnit], db end
		addon:RegisterFrameConfig('Blizzard: '..addon.L[refUnit], GetDatabase)
		addon:RegisterFrame(name, function(frame)
			return addon:SpawnFrame(frame, frame, GetDatabase)
		end)
	end

	RegisterFrame('TargetFrame', 'target')
	RegisterFrame('FocusFrame', 'focus')
	RegisterFrame('PlayerFrame', 'player')
	RegisterFrame('FocusFrame', 'focus')
	for i = 1, 4 do
		RegisterFrame('PartyMemberFrame'..i, 'party'..i)
	end

	return 'supported', GetBuildInfo()
end)

