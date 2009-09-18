local OPTION_CATEGORY = 'Diminishing Returns'

-- AddonLoader support
if AddonLoader and AddonLoader.RemoveInterfaceOptions then
	AddonLoader:RemoveInterfaceOptions(OPTION_CATEGORY)
end

local addon = DiminishingReturns
if not addon then return end

-----------------------------------------------------------------------------
-- Option table
-----------------------------------------------------------------------------

local L = addon.L

local options, frameOptions

local function CreateOptions()
	local drdata = LibStub('DRData-1.0')
	local categoryGroup = {}
	local tmp = {}
	for cat, name in pairs(addon.CATEGORIES) do
		wipe(tmp)
		for spellName, spellCat in pairs(addon.SPELLS) do
			if spellCat == cat then
				tinsert(tmp, spellName)
			end
		end
		local key = cat
		categoryGroup[key] = {
			name = name,
			desc = string.format(L['This catogery is triggered by the following effects:\n- %s'], table.concat(tmp, '\n- ')),
			type = 'toggle',
			get = function()
				return addon.db.profile.categories[key]
			end,
			set = function(_, value)
				addon.db.profile.categories[key] = value
				addon:TriggerMessage('OnConfigChanged', 'categories,'..key, value)
			end
		}
	end

	options = {
		name = OPTION_CATEGORY,
		type = 'group',
		args = {
			learnCategories = {
				name = L['Learn categories to show'],
				desc = L['When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them.'],
				type = 'toggle',
				width = 'double',
				get = function() return addon.db.profile.learnCategories end,
				set = function(_, value) 
					addon.db.profile.learnCategories = value 
					addon:TriggerMessage('OnConfigChanged', 'learnCategories', value)
				end,
				order = 10,
			},
			categories = {
				name = L['Shown categories'],
				desc = L['Select diminishing returns categories to display.'],
				type = 'group',
				inline = true,
				args = categoryGroup,
				order = 20,
			},
			testMode = {
				name = L['Enable test mode'],
				type = 'toggle',
				get = function() return addon.testMode end,
				set = function(_, value) addon:SetTestMode(value) end,
				order = 30,
			}
		}
	}
	
	if AddonLoader and AddonLoaderSV and AddonLoaderSV.overrides then
		local DEFAULT_VALUE = "DEFAULT"
		local loadOnSlash = "X-LoadOn-Slash: /drtest\n"
		local addonName = 'DiminishingReturns'
		options.args.addonLoader = {
			name = L['DiminishingReturns loading condition'],
			desc = L['Thanks to AddonLoader, DiminishingReturns loading can be postponed until you really need it.'],
			type = 'select',
			get = function() 
				return AddonLoaderSV.overrides[addonName] or DEFAULT_VALUE 
			end,
			set = function(_, value)
				AddonLoaderSV.overrides[addonName] = (value ~= DEFAULT_VALUE) and value or nil
			end,
			values = {
				[DEFAULT_VALUE] = L['Always'],
				["X-LoadOn-PvPFlagged: yes\n"..loadOnSlash] = L['Being PvP flagged'],
				["X-LoadOn-Arena: yes\nX-LoadOn-Battleground: yes\n"..loadOnSlash] = L['Entering battleground or arena'],
				["X-LoadOn-Arena: yes\n"..loadOnSlash] = L['Entering arena only'],
			},
			order = 40,
		}
	end
	
	local pointValues = {
		TOPLEFT = L['Top left'],
		TOP = L['Top'],
		TOPRIGHT = L['Top right'],
		LEFT = L['Left'],
		CENTER = L['Center'],
		RIGHT = L['Right'],
		BOTTOMLEFT = L['Bottom left'],
		BOTTOM = L['Bottom'],
		BOTTOMRIGHT = L['Bottom right'],
	}
	
	local frameOptionProto = {
		type = 'group',
		get = function(info)
			local db, key = info.handler:GetDatabase(), info[#info]
			return db[key]
		end,
		set = function(info, value)
			local key = info[#info]
			local db, dbObject = info.handler:GetDatabase()
			db[key] = value
			if dbObject then
				dbObject.callbacks:Fire('OnConfigChanged', key, value)
			end
		end,
		args = {
			iconSize = {
				name = L['Icon size'],
				type = 'range',
				min = 8,
				max = 64,
				step = 1,
				order = 10,
			},
			direction = {
				name = L['Direction'],
				type = 'select',
				values = {
					LEFT = L['Left'],
					RIGHT = L['Right'],
					TOP = L['Top'],
					BOTTOM = L['Bottom'],
				},
				order = 20,
			},
			spacing = {
				name = L['Icon spacing'],
				type = 'range',
				min = 0,
				max = 20,				
				step = 1,
				order = 30,
			},
			anchorPoint = {
				name = L['Icon anchor'],
				type = 'select',
				values = pointValues,
				order = 40,
			},
			relPoint = {
				name = L['Frame side'],
				type = 'select',
				values = pointValues,
				order = 50,
			},
			xOffset = {
				name = L['X offset'],
				type = 'range',
				min = 0,
				max = 500,
				step = 1,
				order = 60,
			},
			yOffset = {
				name = L['Y offset'],
				type = 'range',
				min = 0,
				max = 500,
				step = 1,
				order = 70,
			},
		},
	}

	frameOptions = {
		name = L['Frame options'],
		type = 'group',
		childGroups = 'select',
		args = {
			empty = {
				name = L['No supported addon has been loaded yet.'],
				type = 'description',
			},
		}
	}
	
	-- Replace registry function
	function addon:RegisterFrameConfig(label, getDatabaseCallback)
		local key = label:gsub('[^%w]', '_')
		local opts = {
			name = label,
			handler = handler,
			handler = { GetDatabase = getDatabaseCallback },
		}
		for k, v in pairs(frameOptionProto) do
			opts[k] = v
		end
		frameOptions.args.empty = nil
		frameOptions.args[key] = opts
	end
	
	-- Register existing config
	if addon.pendingFrameConfig then
		for label, getDatabaseCallback in pairs(addon.pendingFrameConfig) do
			addon:RegisterFrameConfig(label, getDatabaseCallback)
		end
		addon.pendingFrameConfig = nil
	end
end

-----------------------------------------------------------------------------
-- Setup
-----------------------------------------------------------------------------

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Main options
AceConfig:RegisterOptionsTable('DimRet-main', function() if not options then CreateOptions() end return options end)
AceConfigDialog:AddToBlizOptions('DimRet-main', OPTION_CATEGORY)

-- Frame options
AceConfig:RegisterOptionsTable('DimRet-frames', function() if not frameOptions then CreateOptions() end return frameOptions end)
AceConfigDialog:AddToBlizOptions('DimRet-frames', L['Frame options'], OPTION_CATEGORY)

-- Profile options
local dbOptions = LibStub('AceDBOptions-3.0'):GetOptionsTable(addon.db)
if addon.LibDualSpec then
	addon.LibDualSpec:EnhanceOptions(dbOptions, addon.db)
end
AceConfig:RegisterOptionsTable('DimRet-profiles', dbOptions)
AceConfigDialog:AddToBlizOptions('DimRet-profiles', dbOptions.name, OPTION_CATEGORY)

-- Slash command
_G['SLASH_DIMRET1'] = '/dimret'
SlashCmdList.DIMRET = function() InterfaceOptionsFrame_OpenToCategory(OPTION_CATEGORY) end

