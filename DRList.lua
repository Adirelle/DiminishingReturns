local addon = DiminishingReturns
if not addon then return end

local cats = {
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
			  853, -- Hammer of Justice (Paladin)
			 2812, -- Holy Wrath (Paladin)
			  408, -- Kidney Shot (Rogue)
			30283, -- Shadowfury (Warlock)
			  100, -- Charge (Warrior)
			20252, -- Intercept (Warrior)
			12809, -- Concussion Blow (Warrior)
		},
		charm = {
			  605, -- Mind Control (Priest)
			 6358, -- Seduction (Warlock)
		},
		fear = {
			 8122, -- Psychic Scream (Priest)
			 5782, -- Fear (Warlock)
			----- Fear/Blind :
			 2094, -- Blind (Rogue)
			 5484, -- Howl of Terror (Warlock)
			 5246, -- Intimidating Shout (Warrior)
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
		},
		stun_proc = {
			11103, -- Impact (Mage)
			 5730, -- Stoneclaw Totem (Shaman)
			20164, -- Seal of Justice (Paladin)
		},
		root_proc = {
			11071, -- Frostbite (Mage)
		},
		blind = {
			 2094, -- Blind (Rogue)
			 5484, -- Howl of Terror (Warlock)
			 5246, -- Intimidating Shout (Warrior)
		},
		horror = {
			6789, -- Death Coil (Warlock)
		},

}

local single =  {
	33786, -- Cyclone (Druid)
	19184, -- Entrapment (Hunter)
	 8056, -- Frost Shock (Shaman)
	 8042, -- Earth Shock (Shaman)
	 1715, -- Hamstring (Warrior)
}

for i, id in pairs(single) do
	cats[GetSpellInfo(id)] = { id }
end

local icons = {}
local watchedSpells = {}
for cat, spells in pairs(cats) do
	for i, id in ipairs(spells) do
		local name, texture = GetSpellInfo(id)
		spells[i] = nil
		spells[name] = true
		watchedSpells[name] = true
	end
end

addon.Categories, addon.WatchedSpells = cats, watchedSpells

