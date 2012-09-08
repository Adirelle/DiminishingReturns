--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

--<GLOBALS
local _G = _G
local GetLocale = _G.GetLocale
local pairs = _G.pairs
local rawset = _G.rawset
local setmetatable = _G.setmetatable
local tostring = _G.tostring
--GLOBALS>

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

L["Always"] = true
L["Anchor to screen"] = true
L["Arena"] = true
L["Being PvP flagged"] = true
L["Big timer"] = true
L["Blizzard: arena enemies"] = true
L["Bottom"] = true
L["Bottom left"] = true
L["Bottom right"] = true
L["Center"] = true
L["Check this box to attach diminishing return icons to this/these frame/s."] = true
L["Check this box to display diminishing returns of mobs. Please remember that dimishing returns usually do not apply to mobs."] = true
L["Check this box to swap diminishing and timer texts."] = true
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = true
L["Direction"] = true
L["Enable test mode"] = true
L["Enabled"] = true
L["Entering arena only"] = true
L["Entering battleground or arena"] = true
L["Frame options"] = true
L["Frame side"] = true
L["Icon anchor"] = true
L["Icon size"] = true
L["Icon spacing"] = true
L["Learn categories to show"] = true
L["Left"] = true
L["No supported addon has been loaded yet."] = true
L["Postponed loading"] = true
L["PvE mode"] = true
L["Reset duration"] = true
L["Right"] = true
L["Select diminishing returns categories to display."] = true
L["Select in which direction the icons are layed out."] = true
L["Select to which side of the unit frame the icon bar is attached."] = true
L["Select which side of the icon bar is attached to the unit frame."] = true
L["Shown categories"] = true
L["This category is triggered by the following effects:\
%s"] = true
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = true
L["Top"] = true
L["Top left"] = true
L["Top right"] = true
L["Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.\
This option requires AddonLoader."] = true
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = true
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = true
L["Use this to set the icon size, in pixels."] = true
L["Use this to set the size of the gap between icons, in pixels."] = true
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = true
L["X offset"] = true
L["Y offset"] = true
--------------------------------------------------------------------------------
-- Locales from localization system
--------------------------------------------------------------------------------

-- %Localization: diminishingreturns
-- THE END OF THE FILE IS UPDATED BY A SCRIPT
-- ANY CHANGE BELOW THESES LINES WILL BE LOST
-- CHANGES SHOULD BE MADE USING http://www.wowace.com/addons/diminishingreturns/localization/

-- @noloc[[

------------------------ enUS ------------------------


-- Config.lua
L["Addon support"] = true
L["Always"] = true
L["Anchor to screen"] = true
L["Being PvP flagged"] = true
L["Big timer"] = true
L["Bottom left"] = true
L["Bottom right"] = true
L["Bottom"] = true
L["Center"] = true
L["Check this box to attach diminishing return icons to this/these frame/s."] = true
L["Check this box to display diminishing returns on mobs. Please remember that diminishing returns usually do not apply to mobs."] = true
L["Check this box to swap diminishing and timer texts."] = true
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = true
L["Check this to display an icon only when the unit is immune to the spells of a category."] = true
L["Check this to display bogus icons on every supported frames."] = true
L["Check this to play a sound when the diminishing return of a watched category is reset on any target."] = true
L["DRData-1.0 (DR categorization data)"] = true
L["DiminishingReturns"] = true
L["Direction"] = true
L["Enable test mode"] = true
L["Enabled"] = true
L["Entering arena only"] = true
L["Entering battleground or arena"] = true
L["Frame options"] = true
L["Frame side"] = true
L["Icon anchor"] = true
L["Icon size"] = true
L["Icon spacing"] = true
L["Internal version: %d"] = true
L["Learn categories to show"] = true
L["Left"] = true
L["No supported addon has been loaded yet."] = true
L["Play sound at reset"] = true
L["Postponed loading"] = true
L["PvE mode"] = true
L["Refresh"] = true
L["Reset duration"] = true
L["Right"] = true
L["Select diminishing returns categories to display."] = true
L["Select in which direction the icons are layed out."] = true
L["Select the sound to play at reset. See SharedMedia documentation to know how to add new sounds."] = true
L["Select to which side of the unit frame the icon bar is attached."] = true
L["Select which side of the icon bar is attached to the unit frame."] = true
L["Show only immunities"] = true
L["Shown categories"] = true
L["Support status"] = true
L["This category is triggered by the following effects:\n%s"] = true
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = true
L["Top left"] = true
L["Top right"] = true
L["Top"] = true
L["Track diminishing returns on group members."] = true
L["Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.\nThis option requires AddonLoader."] = true
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = true
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = true
L["Use this to set the icon size, in pixels."] = true
L["Use this to set the size of the gap between icons, in pixels."] = true
L["Watch friends"] = true
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = true
L["X offset"] = true
L["Y offset"] = true
L["\"Reset\" sound"] = true

-- FrameSetup.lua
L["error: "] = true
L["to be loaded"] = true


------------------------ frFR ------------------------
local locale = GetLocale()
if locale == 'frFR' then
L["Always"] = "Toujours"
L["Anchor to screen"] = "Positionné sur l'écran"
L["Arena"] = "Arène"
L["Being PvP flagged"] = "Avoir le marqueur JcJ"
L["Big timer"] = "Décompte en grand"
L["Blizzard: arena enemies"] = "Blizzard: ennemis d'arène"
L["Bottom"] = "Bas"
L["Bottom left"] = "Bas gauche"
L["Bottom right"] = "Bas droit"
L["Center"] = "Centre"
L["Check this box to attach diminishing return icons to this/these frame/s."] = "Cochez cette case pour activer l'affichage des rendements décroissant de cette unité."
L["Check this box to display diminishing returns of mobs. Please remember that dimishing returns usually do not apply to mobs."] = "Cochez cette case pour afficher les rendements décroissants sur les mobs. Pour mémoire, ils ne s'appliquent généralement pas aux mobs."
L["Check this box to swap diminishing and timer texts."] = "Cochez cette case pour afficher le décompte du délai à la place de la réduction de durée."
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = "Cochez cette case pour positionné les icônes par rapport à l'écran plutôt qu'à l'unité. Cela permet de les placer où vous voulez."
L["Direction"] = "Direction"
L["Enabled"] = "Activé"
L["Enable test mode"] = "Activer le mode de test"
L["Entering arena only"] = "Entrer dans une arène"
L["Entering battleground or arena"] = "Entrer dans un champ de bataille ou une arène"
L["Frame options"] = "Options d'affichage"
L["Frame side"] = "Côté de la barre"
L["Icon anchor"] = "Ancrage des icônes"
L["Icon size"] = "Taille des icônes"
L["Icon spacing"] = "Espacement des icônes"
L["Learn categories to show"] = "Apprendre les catégories à afficher"
L["Left"] = "Gauche"
L["No supported addon has been loaded yet."] = "Aucun addon supporté n'a été chargé pour l'instant."
L["Postponed loading"] = "Chargement reporté"
L["PvE mode"] = "Mode JcE"
L["Reset duration"] = "Délai de remise à zéro"
L["Right"] = "Droit"
L["Select diminishing returns categories to display."] = "Sélectionnez les catégories de rendement décroissant à afficher."
L["Select in which direction the icons are layed out."] = "Choisissez la direction dans laquelle s'étendent les icônes."
L["Select to which side of the unit frame the icon bar is attached."] = "Choisissez par rapport à quel point de l'unité sont positionnés les icônes."
L["Select which side of the icon bar is attached to the unit frame."] = "Choisissez quel côté des icônes est attaché à l'unité."
L["Shown categories"] = "Catégories affichées"
L[ [=[This category is triggered by the following effects:
%s]=] ] = [=[Cette catégorie est déclenchée par les effets suivants :
%s]=]
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = "Ceci est le délai entre la fin d'un effet et le moment où il peut être à nouveau appliqué pour toute sa durée. Ce délai est officiellement 15 secondes mais des valeurs supérieures ont déjà été constatées. Vous pouvez faire des tests et ajuster cette valeur en conséquence. (Cela n'affectera que les nouveaux rendements.)"
L["Top"] = "Haut"
L["Top left"] = "Haut gauche"
L["Top right"] = "Haut droit"
L[ [=[Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.
This option requires AddonLoader.]=] ] = "Utilisez cette option pour retarder le chargement de l'addon. Une fois chargé, DiminishingReturns est toujours actifs en dehors des instance PvE. Cette option ne fonctionne qu'avec AddonLoader."
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = "Définissez un décalage horizontal entre le premier icône et l'unité, en pixels."
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = "Définissez un décalage vertical entre le premier icône et l'unité, en pixels."
L["Use this to set the icon size, in pixels."] = "Définissez la taille des icônes, en pixels."
L["Use this to set the size of the gap between icons, in pixels."] = "Définissez l'écrart entre les icônes, en pixels."
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = "Si coché, DiminishingReturns détectera les catégories à afficher quand vous utilisez des sorts qui les déclenchent."
L["X offset"] = "Décalage en X"
L["Y offset"] = "Décalage en Y"

------------------------ deDE ------------------------
elseif locale == 'deDE' then
L["Addon support"] = "Addon-Unterstützung" -- Needs review
L["Always"] = "Immer"
L["Anchor to screen"] = "Am Bildschirm verankern"
L["Arena"] = "Arena"
L["Being PvP flagged"] = "Mit PvP gekennzeichnet"
L["Big timer"] = "Großer Zeitmesser"
L["Blizzard: arena enemies"] = "Blizzard: Arena-Gegner"
L["Bottom"] = "Unten"
L["Bottom left"] = "Unten links"
L["Bottom right"] = "Unten rechts"
L["Center"] = "Mitte"
L["Check this box to attach diminishing return icons to this/these frame/s."] = "Dieses Feld markieren, um die DiminishingReturns-Symbole an diesem/diesen Rahmen zu befestigen."
L["Check this box to display diminishing returns of mobs. Please remember that dimishing returns usually do not apply to mobs."] = "Markiere dieses Feld, um DiminishingReturns bei Mobs anzuzeigen. Bitte denke daran, dass DiminishingReturns normalerweise nicht bei Mobs angewendet wird."
L["Check this box to display diminishing returns on mobs. Please remember that diminishing returns usually do not apply to mobs."] = "Bei Aktivierung dieses Feldes werden auch Diminishing Returns von gegnerischen Kreaturen angezeigt. Vorsicht: Normalerweise gibt es im PvE keine DR-Mechanik." -- Needs review
L["Check this box to swap diminishing and timer texts."] = "Dieses Feld markieren, um die \"Diminishing\"- und Zeitmesser-Texte auszutauschen."
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = "Dies markieren, um die Symbolleiste am Bildschirm zu verankern, anstatt am Einheitenrahmen. Dies erlaubt dir, sie dort zu platzieren, wo auch immer du möchtest."
L["Check this to display an icon only when the unit is immune to the spells of a category."] = "Aktivieren, um Symbole nur anzuzeigen, wenn die Einheit immun gegen die Zauber der entsprechenden Kategorie sind." -- Needs review
L["Check this to display bogus icons on every supported frames."] = "Markieren, um Symbole an allen unterstützten Unit-Frames anzuzeigen." -- Needs review
L["Check this to play a sound when the diminishing return of a watched category is reset on any target."] = "Aktivieren, um einen Sound abzuspielen, wenn der DR von einer beobachteten Kategorie auf einem beliebigen Ziel zurückgesetzt wird." -- Needs review
L["DiminishingReturns"] = "DiminishingReturns" -- Needs review
L["Direction"] = "Richtung"
L["DRData-1.0 (DR categorization data)"] = "DRData-1.0 (DR-Kategoriedaten)" -- Needs review
L["Enabled"] = "Aktiviert"
L["Enable test mode"] = "Aktiviere Testmodus"
L["Entering arena only"] = "Nur beim Betreten einer Arena"
L["Entering battleground or arena"] = "Beim Betreten eines Schlachtfelds oder einer Arena"
L["error: "] = "Error:" -- Needs review
L["Frame options"] = "Anzeigeoptionen" -- Needs review
L["Frame side"] = "Orientierung" -- Needs review
L["Icon anchor"] = "Symbolanker"
L["Icon size"] = "Symbolgröße"
L["Icon spacing"] = "Symbolabstand"
L["Internal version: %d"] = "Interne version: %d" -- Needs review
L["Learn categories to show"] = "Lerne anzuzeigende Kategorien" -- Needs review
L["Left"] = "Links"
L["No supported addon has been loaded yet."] = "Es wurde bisher kein unterstütztes AddOn geladen."
L["Play sound at reset"] = "Sound bei Reset abspielen" -- Needs review
L["Postponed loading"] = "Laden verschoben"
L["PvE mode"] = "PvE-Modus"
L["Refresh"] = "Aktualisieren" -- Needs review
L["Reset duration"] = "Dauer zurücksetzen"
L["\"Reset\" sound"] = "\"Reset\"-Sound" -- Needs review
L["Right"] = "Rechts"
L["Select diminishing returns categories to display."] = "Wähle die DR-Kategorien, die angezeigt werden sollen." -- Needs review
L["Select in which direction the icons are layed out."] = "Wähle, in welche Richtung die Symbole angeordnet werden."
L["Select the sound to play at reset. See SharedMedia documentation to know how to add new sounds."] = "Wähle den Sound, der bei einem Reset abgespielt werden soll. Die SharedMedia-Dokumentation beschreibt, wie eigene Sounds hinzugefügt werden können." -- Needs review
L["Select to which side of the unit frame the icon bar is attached."] = "Wähle, auf welcher Seite des Einheitenrahmens das Symbol befestigt wird."
L["Select which side of the icon bar is attached to the unit frame."] = "Wähle, welche Seite der Symbolleiste am Einheitenrahmen befestigt wird."
L["Shown categories"] = "Angezeigte Kategorien"
L["Show only immunities"] = "Nur Immunitäten anzeigen" -- Needs review
L["Support status"] = "Kompatibilitätsstatus" -- Needs review
L[ [=[This category is triggered by the following effects:
%s]=] ] = [=[Diese Kategorie wird durch die folgenden Effekte ausgelöst:
%s]=]
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = "Dies ist die Verzögerung zwischen dem Beenden eines Effekts und dem Zeitpunkt, wenn dieser bei voller Länge erneut angewendet werden kann. Diese Verzögerung beträgt offiziell 15 Sekunden, aber es wurden höhere Werte aufgezeichnet. Du kannst einige Tests machen und diesen Wert entsprechend anpassen. Dies wird die Ausführung von DiminishingReturns nicht beeinflussen."
L["to be loaded"] = "Bereit, geladen zu werden" -- Needs review
L["Top"] = "Oben"
L["Top left"] = "Oben links"
L["Top right"] = "Oben rechts"
L["Track diminishing returns on group members."] = "Diminishing Returns von Gruppenmitgliedern beobachten." -- Needs review
L[ [=[Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.
This option requires AddonLoader.]=] ] = [=[Verwende diese  Option, um das Laden zu verschieben. Einmal geladen, ist DiminishingReturns außerhalb von PvE-Instanzen immer aktiv.
Diese Option benötigt AddonLoader.]=]
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = "Verwende dies, um den horizontalen Ausgleich zwischen dem Symbolanker und dem Befestigungspunkt am Einheitenrahmen in Pixel einzustellen."
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = "Verwende dies, um den vertikalen Ausgleich zwischen dem Symbolanker und dem Befestigungspunkt am Einheitenrahmen in Pixel einzustellen."
L["Use this to set the icon size, in pixels."] = "Verwende dies, um die Symbolgröße in Pixel einzustellen."
L["Use this to set the size of the gap between icons, in pixels."] = "Verwende dies, um die Größe des Abstands zwischen den Symbolen in Pixel einzustellen."
L["Watch friends"] = "Freunde beobachten" -- Needs review
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = "Wenn aktiviert, erkennt DiminishingReturns die anzuzeigenden Kategorien, wenn du Zauber benutzt, die diese auslösen."
L["X offset"] = "X-Ausgleich"
L["Y offset"] = "Y-Ausgleich"

------------------------ esMX ------------------------
-- no translation

------------------------ ruRU ------------------------
elseif locale == 'ruRU' then
L["Always"] = "Всегда"
L["Anchor to screen"] = "Закрепить на экране"
L["Arena"] = "Арена"
L["Being PvP flagged"] = "При метке PvP"
L["Big timer"] = "Большой таймер"
L["Blizzard: arena enemies"] = "Blizzard: враги на арене"
L["Bottom"] = "Внизу"
L["Bottom left"] = "Внизу слева"
L["Bottom right"] = "Внизу справа"
L["Center"] = "По центру"
L["Check this box to attach diminishing return icons to this/these frame/s."] = "Отметить, для прикрепления иконки диминишинга к этим/этому фрэйму/ам"
L["Check this box to display diminishing returns of mobs. Please remember that dimishing returns usually do not apply to mobs."] = "Отметить, для отображения диминишинга на мобах. Пожалуйста помните, что получение диминишинга обычно не применяется для мобов" -- Needs review
L["Check this box to swap diminishing and timer texts."] = "Отметить, для обмена текста диминишинга и таймера местами"
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = "Отметить, для закрепления панели иконок на экране вместо фрэйма. Это позволит расположить её в любом месте."
L["Direction"] = "Направление"
L["Enabled"] = "Включен"
L["Enable test mode"] = "Пробный режим"
L["Entering arena only"] = "Только при входе на арену"
L["Entering battleground or arena"] = "При входе на арену или поле боя"
L["Frame options"] = "Настройки окна"
L["Frame side"] = "Сторона окна"
L["Icon anchor"] = "Якорь иконки"
L["Icon size"] = "Размер иконки"
L["Icon spacing"] = "Промежуток иконки"
L["Learn categories to show"] = "Обучить категории для отображения"
L["Left"] = "Слева"
L["No supported addon has been loaded yet."] = "Поддерживаемый аддон не был загружен"
L["Postponed loading"] = "Отложенная загрузка" -- Needs review
L["PvE mode"] = "Режим PvE"
L["Reset duration"] = "Сброс длительности"
L["Right"] = "Справа"
L["Select diminishing returns categories to display."] = "Выбрать категорию диминишинга для отображения"
L["Select in which direction the icons are layed out."] = "Выберите направление роста иконок"
L["Select to which side of the unit frame the icon bar is attached."] = "Выберите, к какой стороне фрэйма будет прикреплена панель иконок"
L["Select which side of the icon bar is attached to the unit frame."] = "Выберите, какой стороной панель иконок будет прикреплена к фрэйму"
L["Shown categories"] = "Показать категории"
L[ [=[This category is triggered by the following effects:
%s]=] ] = [=[Эта категория была настроена на следующие эффекты:
%s]=]
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = "Это задержка между концом эффекта и временем когда он может быть применен снова на полную длинну.Эта задержка официально 15 секунд, но есть значения и выше. Вы можете провести несколько тестов и подобрать значение соответственно. Это не будет иметь эффект до получения диминишинга." -- Needs review
L["Top"] = "Вверху"
L["Top left"] = "Вверху слева"
L["Top right"] = "Вверху справа"
L[ [=[Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.
This option requires AddonLoader.]=] ] = [=[Используйте, для отложенной загрузки. Однажды загружен, аддон будет всегда активен вне ПвЕ подземелий.
Эта опция требует AddonLoader.]=] -- Needs review
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = "Используйте для выставления горизонтального смещения между якорем иконок и фрэймом, в пикселях"
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = "Используйте для выставления вертикального смещения между якорем иконок и фрэймом, в пикселях"
L["Use this to set the icon size, in pixels."] = "Используйте для указания размера иконок, в пикселях"
L["Use this to set the size of the gap between icons, in pixels."] = "Используйте для указания промежутка между иконками, в пикселях"
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = "Когда включено, аддон будет находить категории для отображения во время использования заклинаний" -- Needs review
L["X offset"] = "Смещение по X"
L["Y offset"] = "Смещение по Y"

------------------------ esES ------------------------
elseif locale == 'esES' then
L["Always"] = "Siempre"
L["Arena"] = "Arena"
L["Being PvP flagged"] = "Marcado con bandera PVP" -- Needs review
L["Blizzard: arena enemies"] = "Blizzard: enemigos de arena"
L["Bottom"] = "Abajo"
L["Bottom left"] = "Abajo a la izquierda"
L["Bottom right"] = "Abajo a la derecha"
L["Center"] = "Centrado"
L["Direction"] = "Dirección"
L["Left"] = "Izquierda"
L["Right"] = "Derecha"
L["Top"] = "Arriba"
L["Top left"] = "Arriba a la izquierda"
L["Top right"] = "Arriba a la derecha"

------------------------ zhTW ------------------------
elseif locale == 'zhTW' then
L["Addon support"] = "插件支持"
L["Always"] = "總是"
L["Anchor to screen"] = "置於螢幕內"
L["Arena"] = "競技場"
L["Being PvP flagged"] = "PvP 插旗"
L["Big timer"] = "大計時"
L["Blizzard: arena enemies"] = "暴雪：競技場敵人"
L["Bottom"] = "底部"
L["Bottom left"] = "底部左側"
L["Bottom right"] = "底部右側"
L["Center"] = "中間"
L["Check this box to attach diminishing return icons to this/these frame/s."] = "點選此框時附著遞減圖示到其所在框架。"
L["Check this box to display diminishing returns of mobs. Please remember that dimishing returns usually do not apply to mobs."] = "點選此框時顯示怪物的遞減。請注意遞減通常對怪物不起作用。"
L["Check this box to display diminishing returns on mobs. Please remember that diminishing returns usually do not apply to mobs."] = "點選此框時顯示怪物的遞減。請注意遞減通常對怪物不起作用。"
L["Check this box to swap diminishing and timer texts."] = "點選此框將互換遞減與計時的文本。"
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = "選中此圖示定位到螢幕而不是單位的框架。這允許你自由定位。"
L["Check this to display an icon only when the unit is immune to the spells of a category."] = "點選此框時單位免疫此法術類型時將只顯示一個圖示。"
L["Check this to display bogus icons on every supported frames."] = "點選此框時在每個已支持的框架將顯示測試圖示。"
L["Check this to play a sound when the diminishing return of a watched category is reset on any target."] = "點選此框時任一目標監視的類型遞減重置將播放音效。"
L["DiminishingReturns"] = "DiminishingReturns"
L["Direction"] = "方向"
L["DRData-1.0 (DR categorization data)"] = "DRData-1.0（遞減類型數據）"
L["Enabled"] = "啟用"
L["Enable test mode"] = "啟用測試模塊"
L["Entering arena only"] = "只用於競技場"
L["Entering battleground or arena"] = "只用於戰場與競技場"
L["error: "] = "錯誤："
L["Frame options"] = "框架選項"
L["Frame side"] = "框架邊緣"
L["Icon anchor"] = "圖示錨點"
L["Icon size"] = "圖示大小"
L["Icon spacing"] = "圖示間距"
L["Internal version: %d"] = "內部版本：%d"
L["Learn categories to show"] = "顯示學習類型"
L["Left"] = "左側"
L["No supported addon has been loaded yet."] = "已加載不兼容的插件。"
L["Play sound at reset"] = "重設時播放音效"
L["Postponed loading"] = "延遲加載"
L["PvE mode"] = "PvE 模式"
L["Refresh"] = "刷新"
L["Reset duration"] = "重置持續時間"
L["\"Reset\" sound"] = "“重設”音效"
L["Right"] = "右側"
L["Select diminishing returns categories to display."] = "選擇顯示收益遞減類型。"
L["Select in which direction the icons are layed out."] = "切換圖示排列方向佈局。"
L["Select the sound to play at reset. See SharedMedia documentation to know how to add new sounds."] = "選擇重設時播放的音效。查看 SharedMedia 文檔了解如何添加新的音效。"
L["Select to which side of the unit frame the icon bar is attached."] = "選擇圖示條附著到單位框架旁邊。"
L["Select which side of the icon bar is attached to the unit frame."] = "選擇圖示條附著到單位框架哪一邊。"
L["Shown categories"] = "顯示類型"
L["Show only immunities"] = "只在免疫時顯示"
L["Support status"] = "支持狀態"
L[ [=[This category is triggered by the following effects:
%s]=] ] = [=[此類觸發以下效果：
%s]=]
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = "這是在效果結束與未結束之間的時間延遲並可再次用於全長。此延遲為15秒但會記錄更高的值。可以進行些測試並調整此值。這不會影響到遞減的運行。"
L["to be loaded"] = "需要加載"
L["Top"] = "頂部"
L["Top left"] = "頂部左側"
L["Top right"] = "頂部右側"
L["Track diminishing returns on group members."] = "追踪小隊成員遞減。"
L[ [=[Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.
This option requires AddonLoader.]=] ] = [=[使用此選項推遲加載。加載一次後，DiminishingReturns 總是在 PvE 副本之外啟用。
此選項需要 AddonLoader 插件。]=]
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = "以像素為單位設置圖示錨點與單位框架附著點間的水平距離。"
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = "以像素為單位設置圖示錨點與單位框架附著點間的垂直距離。"
L["Use this to set the icon size, in pixels."] = "以像素為單位設置圖示大小。"
L["Use this to set the size of the gap between icons, in pixels."] = "以像素為單位設置圖示之間的距離大小。"
L["Watch friends"] = "監視隊友"
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = "當 DiminishingReturns 啟用時將查找顯示你使用觸發的技能類型。"
L["X offset"] = "X 偏移量"
L["Y offset"] = "Y 偏移量"

------------------------ zhCN ------------------------
elseif locale == 'zhCN' then
L["Addon support"] = "插件支持"
L["Always"] = "总是"
L["Anchor to screen"] = "置于屏幕内"
L["Arena"] = "竞技场"
L["Being PvP flagged"] = "PvP 插旗"
L["Big timer"] = "大计时"
L["Blizzard: arena enemies"] = "暴雪：竞技场敌人"
L["Bottom"] = "底部"
L["Bottom left"] = "底部左侧"
L["Bottom right"] = "底部右侧"
L["Center"] = "中间"
L["Check this box to attach diminishing return icons to this/these frame/s."] = "点选此框时附着递减图标到其所在框架。"
L["Check this box to display diminishing returns of mobs. Please remember that dimishing returns usually do not apply to mobs."] = "点选此框时显示怪物的递减。请注意递减通常对怪物不起作用。"
L["Check this box to display diminishing returns on mobs. Please remember that diminishing returns usually do not apply to mobs."] = "点选此框时显示怪物的递减。请注意递减通常对怪物不起作用。"
L["Check this box to swap diminishing and timer texts."] = "点选此框将互换递减与计时的文本。"
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = "选中此图标定位到屏幕而不是单位的框架。这允许你自由定位。"
L["Check this to display an icon only when the unit is immune to the spells of a category."] = "点选此框时单位免疫此法术类型时将只显示一个图标。"
L["Check this to display bogus icons on every supported frames."] = "点选此框时在每个已支持的框架将显示测试图标。"
L["Check this to play a sound when the diminishing return of a watched category is reset on any target."] = "点选此框时任一目标监视的类型递减重置将播放音效。"
L["DiminishingReturns"] = "DiminishingReturns"
L["Direction"] = "方向"
L["DRData-1.0 (DR categorization data)"] = "DRData-1.0（递减类型数据）"
L["Enabled"] = "启用"
L["Enable test mode"] = "启用测试模块"
L["Entering arena only"] = "只用于竞技场"
L["Entering battleground or arena"] = "只用于战场与竞技场"
L["error: "] = "错误："
L["Frame options"] = "框架选项"
L["Frame side"] = "框架边缘"
L["Icon anchor"] = "图标锚点"
L["Icon size"] = "图标大小"
L["Icon spacing"] = "图标间距"
L["Internal version: %d"] = "内部版本：%d"
L["Learn categories to show"] = "显示学习类型"
L["Left"] = "左侧"
L["No supported addon has been loaded yet."] = "已加载不兼容的插件。"
L["Play sound at reset"] = "重置时播放音效"
L["Postponed loading"] = "延迟加载"
L["PvE mode"] = "PvE 模式"
L["Refresh"] = "刷新"
L["Reset duration"] = "重置持续时间"
L["\"Reset\" sound"] = "“重置”音效"
L["Right"] = "右侧"
L["Select diminishing returns categories to display."] = "选择显示收益递减类型。"
L["Select in which direction the icons are layed out."] = "切换图标排列方向布局。"
L["Select the sound to play at reset. See SharedMedia documentation to know how to add new sounds."] = "选择重置时播放的音效。查看 SharedMedia 文档了解如何添加新的音效。"
L["Select to which side of the unit frame the icon bar is attached."] = "选择图标条附着到单位框架旁边。"
L["Select which side of the icon bar is attached to the unit frame."] = "选择图标条附着到单位框架哪一边。"
L["Shown categories"] = "显示类型"
L["Show only immunities"] = "只在免疫时显示"
L["Support status"] = "支持状态"
L[ [=[This category is triggered by the following effects:
%s]=] ] = [=[此类触发以下效果：
%s]=]
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = "这是在效果结束与未结束之间的时间延迟并可再次用于全长。此延迟为15秒但会记录更高的值。可以进行些测试并调整此值。这不会影响到递减的运行。"
L["to be loaded"] = "需要加载"
L["Top"] = "顶部"
L["Top left"] = "顶部左侧"
L["Top right"] = "顶部右侧"
L["Track diminishing returns on group members."] = "追踪小队成员递减。"
L[ [=[Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.
This option requires AddonLoader.]=] ] = [=[使用此选项推迟加载。加载一次后，DiminishingReturns 总是在 PvE 副本之外启用。
此选项需要 AddonLoader 插件。]=]
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = "以像素为单位设置图标锚点与单位框架附着点间的水平距离。"
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = "以像素为单位设置图标锚点与单位框架附着点间的垂直距离。"
L["Use this to set the icon size, in pixels."] = "以像素为单位设置图标大小。"
L["Use this to set the size of the gap between icons, in pixels."] = "以像素为单位设置图标之间的距离大小。"
L["Watch friends"] = "监视队友"
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = "当 DiminishingReturns 启用时将查找显示你使用触发的技能类型。"
L["X offset"] = "X 偏移量"
L["Y offset"] = "Y 偏移量"

------------------------ koKR ------------------------
elseif locale == 'koKR' then
L["Always"] = "항상"
L["Anchor to screen"] = "화면에 고정"
L["Arena"] = "투기장"
L["Being PvP flagged"] = "PvP 활성화되었을 때"
L["Big timer"] = "큰 시간 조절기"
L["Blizzard: arena enemies"] = "블리자드: 투기장 상대들"
L["Bottom"] = "아래"
L["Bottom left"] = "아래 왼쪽"
L["Bottom right"] = "아래 오른쪽"
L["Center"] = "가운데"
L["Check this box to attach diminishing return icons to this/these frame/s."] = "점감 효과 아이콘들을 이 틀에 붙이려면 체크하십시오/s."
L["Check this box to display diminishing returns of mobs. Please remember that dimishing returns usually do not apply to mobs."] = "몹들의 점감 효과들을 표시하려면 체크하십시오. 점감 효과들은 대개 몹들에 적용되지 않는 것을 기억하십시오."
L["Check this box to swap diminishing and timer texts."] = "점감과 시간 조절기 글자들을 바꾸려면 체크하십시오."
L["Check this to anchor the icon bar to the screen instead of the unit frame. This allows you to place it whereever you want."] = "아이콘 막대를 개체 틀 대신에 화면에 고정시키려면 체크하십시오. 원하는 곳이면 어디든지 놓을 수 있도록 합니다."
L["Direction"] = "방향"
L["Enabled"] = "활성화"
L["Enable test mode"] = "시험 상태 활성화"
L["Entering arena only"] = "투기장에 들어갈 떄만"
L["Entering battleground or arena"] = "전장이나 투기장에 들어갈 때"
L["Frame options"] = "틀 옵션"
L["Frame side"] = "틀 쪽"
L["Icon anchor"] = "아이콘 닻"
L["Icon size"] = "아이콘 크기"
L["Icon spacing"] = "아이콘 간격"
L["Learn categories to show"] = "보일 범주들을 익힘"
L["Left"] = "왼쪽"
L["No supported addon has been loaded yet."] = "어떤 지원 애드온도 아직 불러오지 않았습니다."
L["Postponed loading"] = "늦춰진 불러오기"
L["PvE mode"] = "PvE 방식"
L["Reset duration"] = "초기화 시간"
L["Right"] = "오른쪽"
L["Select diminishing returns categories to display."] = "표시할 점감 효과 범주들을 고르십시오."
L["Select in which direction the icons are layed out."] = "아이콘들이 어느 방향으로 늘어놓일지 고르십시오."
L["Select to which side of the unit frame the icon bar is attached."] = "개체 틀의 어느 쪽에 아이콘 막대를 붙일지 고르십시오."
L["Select which side of the icon bar is attached to the unit frame."] = "아이콘 막대의 어느 쪽을 개체 틀에 붙일지 고르십시오."
L["Shown categories"] = "보인 범주들"
L[ [=[This category is triggered by the following effects:
%s]=] ] = [=[이 범주는 다음의 효과들이 일으킴:
%s]=]
L["This is the delay between the end of an effect and the time it can be applied at full length again. This delay is officialy 15 seconds but higher values have been recorded. You can do some tests and adjust this value accordingly. This will not affect running diminishing returns."] = "이것은 효과의 끝과 다시 표준 길이로 적용될 수 있는 시간 사이의 지연 시간입니다. 이 지연 시간은 공식적으로 15초이지만 더 높은 값들이 기록되었습니다. 당신은 몇몇의 시험들을 하고 나서 그에 따라서 이 값을 조정할 수 있습니다. 이것은 DiminishingReturns|1을;를; 실행하는 데에 영향을 미치지 않을 것입니다."
L["Top"] = "위"
L["Top left"] = "위 왼쪽"
L["Top right"] = "위 오른쪽"
L[ [=[Use this option to postpone loading. Once loaded, DiminishingReturns is always active outside of PvE instances.
This option requires AddonLoader.]=] ] = [=[불러오기를 늦추려면 이 옵션을 쓰십시오. 불러오자마자 DiminishingReturns|1은;는; PvE 인스턴스들 밖에서 항상 활성화됩니다.
이 옵션은 AddonLoader가 필요합니다.]=]
L["Use this to set an horizontal offset between the icon anchor and the unit frame attach point, in pixels."] = "아이콘 닻과 개체 틀 붙는 지점 사이의 가로 단을 설정하려면 이것을 쓰십시오. 픽셀 단위"
L["Use this to set a vertical offset between the icon anchor and the unit frame attach point, in pixels."] = "아이콘 닻과 개체 틀 붙는 지점 사이의 세로 단을 설정하려면 이것을 쓰십시오. 픽셀 단위"
L["Use this to set the icon size, in pixels."] = "아이콘 크기를 설정하려면 이것을 쓰십시오. 픽셀 단위"
L["Use this to set the size of the gap between icons, in pixels."] = "아이콘들 사이의 틈 크기를 설정하려면 이것을 쓰십시오. 픽셀 단위"
L["When enabled, DiminishingReturns will discover the categories to display when you use spells that triggers them."] = "활성화되면 DiminishingReturns|1은;는; 범주들을 일으키는 주문들을 쓸 때 표시될 범주들을 알아챌 것입니다."
L["X offset"] = "X 단"
L["Y offset"] = "Y 단"

------------------------ ptBR ------------------------
elseif locale == 'ptBR' then
L["Always"] = "Sempre" -- Needs review
L["Arena"] = "Arena" -- Needs review
L["Blizzard: arena enemies"] = "Inimigos da arena" -- Needs review
L["Bottom"] = "Fundo" -- Needs review
L["Bottom left"] = "Canto Inferior Esquerdo" -- Needs review
L["Bottom right"] = "Canto Inferior Direito" -- Needs review
L["Center"] = "Centro" -- Needs review
L["Direction"] = "Direção" -- Needs review
L["Enable test mode"] = "Ativar Modo de Teste" -- Needs review
L["Frame options"] = "Opções de Quadro" -- Needs review
L["Icon size"] = "Tamanho de Ícone" -- Needs review
L["Icon spacing"] = "Espaçamento entre Ícone" -- Needs review
L["Learn categories to show"] = "Saiba/Aprenda categorias para mostrar" -- Needs review
L["Left"] = "Esquerda" -- Needs review
end

-- @noloc]]

-- Replace remaining true values by their key
for k,v in pairs(L) do if v == true then L[k] = k end end
