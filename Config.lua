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

local L = setmetatable({}, {__index = function(t,k) t[k] = tostring(k) return tostring(k) end})

local options

local function GetOptions()
	if options then return options end
	
	local handler = {
		GetDatabase = function() return addon.db.profile end,
	
		ResolveDBPath = function(self, info)
			local db = self:GetDatabase()
			local path = info.arg or info[#info]
			if type(path) == "table" then				
				for i = 1, #path-1 do
					db = db[path[i]]
				end
				return db, path[#path], table.concat(path, ',')
			else
				return db, tostring(path), tostring(path)
			end
		end,

		Get = function(self, info, arg)
			local db, key = self:ResolveDBPath(info)
			if info.type == 'color' then
				return unpack(db[key])
			elseif info.type == 'multiselect' then
				return type(db[key]) == "table" and db[key][arg]
			else
				return db[key]
			end
		end,
		
		Set = function(self, info, value, ...)
			local db, key, path = self:ResolveDBPath(info)
			if info.type == 'color' then
				local color = db[key]
				if type(color) == "table" then
					color[1], color[2], color[3], color[4] = ...
				else
					db[key] = { ... }
				end
			elseif info.type == 'multiselect' then
				if type(db[key]) == "table" then
					db[key][value] = ...
				else
					db[key] = { [value] = ... }
				end
			else
				db[key] = value
			end
			addon:TriggerMessage('OnConfigChanged', path, value, ...)
		end
	}
	
	local categoryGroup = {}
	local tmp = {}
	for cat, spells in pairs(addon.Categories) do
		wipe(tmp)
		for spellName in pairs(spells) do
			tinsert(tmp, spellName)
		end
		local key = cat
		categoryGroup[key] = {
			name = L[key],
			desc = table.concat(tmp, '\n'),
			type = 'toggle',
			arg = { 'categories', key },
			get = function(info)
				if addon.db.profile.autoCategories then
					return addon.AutoCategories[key]
				else
					return addon.db.profile.categories[key]
				end
			end,
		}
	end

	options = {
		name = OPTION_CATEGORY,
		type = 'group',
		handler = handler,
		get = "Get",
		set = "Set",
		args = {
			autoCategories = {
				name = L['Automatic category selection'],
				type = 'toggle',
				width = 'double',
				order = 10,
			},
			categories = {
				name = L['Manual category selection'],
				type = 'group',
				inline = true,
				args = categoryGroup,
				disabled = function() return addon.db.profile.autoCategories end,
				order = 20,
			},
			testMode = {
				name = L['Enable test mode'],
				type = 'toggle',
				get = function() return addon.testMode end,
				set = function(info, value) addon:SetTestMode(value) end,
				order = 30,
			}
		}
	}
	
	return options
end

-----------------------------------------------------------------------------
-- Setup
-----------------------------------------------------------------------------

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Main options
AceConfig:RegisterOptionsTable('DimRet-main', GetOptions)
AceConfigDialog:AddToBlizOptions('DimRet-main', OPTION_CATEGORY)

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

