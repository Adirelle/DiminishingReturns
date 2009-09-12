local addon = DiminishingReturns
if not addon then return end

local data = {
	gouge_polymorph_sap = {			
		49203, -- Hungering Cold (DK)
		28271, -- Polymorph (Mage)
		20066, -- Repentance (Paladin)
		 6770, -- Sap (Rogue)
		 1776, -- Gouge (Rogue)
	},
	cheap_shot_pounce = {
		 9005, -- Pounce (Druid)
		 1833, -- Cheap Shot (Rogue)
	},
	stun = {
		 5211, -- Bash (Druid)
		22570, -- Maim (Druid)
		19577, -- Intimidation (Hunter)
			853, -- Hammer of Justice (Paladin)
		 2812, -- Holy Wrath (Paladin)
			408, -- Kidney Shot (Rogue)
		30283, -- Shadowfury (Warlock)
			100, -- Charge (Warrior)
		20252, -- Intercept (Warrior)
		12809, -- Concussion Blow (Warrior)
		-- Pets:
		53568, -- Sonic Blast (Bat)
		53562, -- Ravage (Ravager)
		47481, -- Gnaw (Ghoul)
	},
	fear_charm_blind = {
		-- Charm
			605, -- Mind Control (Priest)
		 6358, -- Seduction (Warlock)
		-- Fear
		 8122, -- Psychic Scream (Priest)
		 5782, -- Fear (Warlock)
		 5484, -- Howl of Terror (Warlock)
		 5246, -- Intimidating Shout (Warrior)
		-- Blind
		 2094, -- Blind (Rogue)
	},
	sleep_freeze = {
		 2637, -- Hibernate (Druid)
		 1499, -- Freezing Trap (Hunter)
		60192, -- Freezing Arrow (Hunter)
		19386, -- Wyvern Sting (Hunter)
	},
	root = {
			339, -- Entangling Roots (Druid)
			122, -- Frost Nova (Mage)
		-- Hunter pets:
		53548, -- Pin (Crab)						
		 4167, -- Web (Spider)
		54706, -- Venom Web Spray (Silithid)		 
	},
	--[[
	stun_proc = {
		11103, -- Impact (Mage)
		 5730, -- Stoneclaw Totem (Shaman)
		20164, -- Seal of Justice (Paladin)
	},
	root_proc = {
		11071, -- Frostbite (Mage)
	},
	--]]
	horror = {
		6789,  -- Death Coil (Warlock)
		64044, -- Psychic Horror (Priest)
	},
	silence = {
		15487, -- Silence (Priest)
			703, -- Garrote (Rogue)
		 1766, -- Kick (Rogue)
		 2139, -- Counterspell (Mage)
		34490, -- Silencing Shot (Hunter)
			 72, -- Shield Bash (Warrior)
		57755, -- Heroic Throw (Warrior)
		32699, -- Avenger's Shield (Paladin)
		47476, -- Strangulate (DK)
		50613, -- Arcane Torrent (Blood Elfs)
		19821, -- Arcane Bomb (Engineers)
		19244, -- Spell Lock (Warlock)		
		-- Hunter pets:
		26090, -- Pummel (Gorilla)
		53589, -- Nether Shock (Nether Ray)
	},
	disarm = {
			676, -- Disarm (Warrior)
		53359, -- Chimera Shot - Scorpid (Hunter)
		51722, -- Dismantle (Rogue)
		64058, -- Psychic Horror (Priest)
		-- Hunter pets:
		53543, -- Snatch (Bird of Prey)		
	},
	-- Single DR
	cyclone     = { 33786 }, -- Cyclone (Druid)
	entrapment  = { 19184 }, -- Entrapment (Hunter)
	frost_shock = {  8056 }, -- Frost Shock (Shaman)
	earth_shock = {  8042 }, -- Earth Shock (Shaman)
	hamstring   = {  1715 }, -- Hamstring (Warrior)
	banish      = { 18647 }, -- Banish (Warlock)
}

function addon:LoadSpells()
	local categories = {}
	local watchedSpells = {}
	
	for cat, catData in pairs(data) do
		local spells, icon = {}
		for i, id in ipairs(catData) do
			local name = GetSpellInfo(id)
			spells[name] = true
			watchedSpells[name] = true
		end
		categories[cat] = spells
	end

	addon.Categories = categories
	addon.WatchedSpells = watchedSpells	
	
	self:UpdateCategories()
end

addon.AutoCategories = {}
addon.CatIcons = {}
	
function addon:UpdateCategories()
	local icons = addon.CatIcons
	local autoCategories = addon.AutoCategories
	wipe(icons)
	wipe(autoCategories)
	
	for cat, catData in pairs(data) do
		icons[cat] = select(3, GetSpellInfo(catData[1]))
		for i, id in ipairs(catData) do
			local known, _, texture = GetSpellInfo(GetSpellInfo(id))
			if known then
				icons[cat] = texture
				autoCategories[cat] = true
				break
			end
		end
	end
end

if IsLoggedIn() then
	addon:LoadSpells()
else
	addon:RegisterEvent('PLAYER_LOGIN', 'LoadSpells')
end
addon:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'UpdateCategories')

local petFamily = UnitCreatureFamily('pet')
addon:RegisterEvent('UNIT_PET', function(self, event, unit)
	if unit == 'player' then
		local newPetFamily = UnitCreatureFamily('pet')
		if newPetFamily and newPetFamily ~= petFamily then
			petFamily = newPetFamily
			self:UpdateCategories()
		end
	end
end)

