local addon = DiminishingReturns
if not addon then return end

local L = setmetatable({}, {
	__index = function(self, key)
		if key ~= nil then
			self[key] = tostring(key)
		end
		return tostring(key)
	end,
	__newindex = function(self, key, value)
		if value == true then value = key end
		rawset(self, tostring(key), tostring(value))
	end
})
addon.L = L

L['Always'] = true
L["Arena"] = true
L['Being PvP flagged'] = true
L['Blizzard: arena enemies'] = true
L['Bottom left'] = true
L['Bottom right'] = true
L['Bottom'] = true
L['Center'] = true
L['DiminishingReturns loading condition'] = true
L['Direction'] = true
L['Enable test mode'] = true
L['Entering arena only'] = true
L['Entering battleground or arena'] = true
L['Frame options'] = true
L['Frame side'] = true
L['Icon anchor'] = true
L['Icon size'] = true
L['Icon spacing'] = true
L['Learn categories to show'] = true
L['Left'] = true
L['No supported addon has been loaded yet.'] = true
L['Right'] = true
L['Select diminishing returns categories to display.'] = true
L['Shown categories'] = true
L['Thanks to AddonLoader, DiminishingReturns loading can be postponed until you really need it.'] = true
L['This category is triggered by the following effects:\n%s'] = true
L['Top left'] = true
L['Top right'] = true
L['Top'] = true
L['When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them.'] = true
L['X offset'] = true
L['Y offset'] = true

--------------------------------------------------------------------------------
-- Locales from localization system
--------------------------------------------------------------------------------

-- %Localization: diminishingreturns
-- AUTOMATICALLY GENERATED BY UpdateLocalization.lua
-- ANY CHANGE BELOW THIS LINE WILL BE LOST ON NEXT UPDATE
-- CHANGES SHOULD BE MADE USING http://www.wowace.com/addons/diminishingreturns/localization/

local locale = GetLocale()
if locale == "frFR" then
L["Always"] = "Toujours"
L["Arena"] = "Arène"
L["Being PvP flagged"] = "Avoir le marqueur JcJ"
L["Blizzard: arena enemies"] = "Blizzard: ennemis d'arène"
L["Bottom"] = "Bas"
L["Bottom left"] = "Bas gauche"
L["Bottom right"] = "Bas droit"
L["Center"] = "Centre"
L["DiminishingReturns loading condition"] = "Condition de chargement de DiminishingReturns"
L["Direction"] = "Direction"
L["Enable test mode"] = "Activer le mode de test"
L["Entering arena only"] = "Uniquement entrer dans une arène"
L["Entering battleground or arena"] = "Entrer dans un champ de bataille ou une arène"
L["Frame options"] = "Options d'affichage"
L["Frame side"] = "Côté de la barre"
L["Icon anchor"] = "Ancrage des icônes"
L["Icon size"] = "Taille des icônes"
L["Icon spacing"] = "Espacement des icônes"
L["Learn categories to show"] = "Apprendre les catégories à afficher"
L["Left"] = "Gauche"
L["No supported addon has been loaded yet."] = "Aucun addon supporté n'a été chargé pour l'instant."
L["Right"] = "Droit"
L["Select diminishing returns categories to display."] = "Sélectionnez les catégories de rendement décroissant à afficher."
L["Shown categories"] = "Catégories affichées"
L["Thanks to AddonLoader, DiminishingReturns loading can be postponed until you really need it."] = "Grâce à AddonLoader, le chargement DiminishingReturns peut être repoussé jusqu'au ce que vous en ayez vraiment besoin."
L[ [=[This category is triggered by the following effects:
%s]=] ] = [=[Cette catégorie est déclenchée par les effets suivants :
%s]=]
L["Top"] = "Haut"
L["Top left"] = "Haut gauche"
L["Top right"] = "Haut droit"
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = "Si coché, DiminishingReturns détectera les catégories à afficher quand vous utilisez des sorts qui les déclenchent."
L["X offset"] = "Décalage en X"
L["Y offset"] = "Décalage en Y"
end
