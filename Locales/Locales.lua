--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: The powerhouse of all of the addon's localization.
]]--

local curator, curatorNS = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

curatorNS.L = L;

local LOCALE = GetLocale();

if LOCALE == "enUS" or LOCALE == "enGB" then -- EU/US English
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. curator .. "|r: ";
	L["ADDED_ITEM"] = "Added ";
	L["REMOVED_ITEM"] = "Removed ";
	L["DELETED_ITEM"] = "Deleted ";
	-- ERRORS
	L["CANNOT_ADD_ITEM"] = " already exists in your account list!";
	L["NO_COMMANDS"] = "No available commands! Commands were deprecated in release 1.2.0.";
	-- INFO
	L["SOLD_ITEMS"] = "Sold all items with a net gain of ";
	L["REPAIRED_ITEMS"] = "Repaired all items at the following cost ";
	L["DELETED_ITEM_TEXT"] = " item(s) with no sell price.";
return end;

if LOCALE == "frFR"  then -- French
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. curator .. "|r: ";
	L["ADDED_ITEM"] = "Ajoutée ";
	L["REMOVED_ITEM"] = "Enlevée ";
	L["DELETED_ITEM"] = "Supprimé ";
	-- ERRORS
	L["CANNOT_ADD_ITEM"] = " existe déjà dans votre liste de compte!";
	L["NO_COMMANDS"] = "Aucune commande disponible! Les commandes étaient obsolètes dans la version 1.2.0.";
	-- INFO
	L["SOLD_ITEMS"] = "Vendu tous les articles avec un gain net de ";
	L["REPAIRED_ITEMS"] = "Réparé tous les articles au coût suivant ";
	L["DELETED_ITEM_TEXT"] = " article(s) sans prix de vente.";
return end;

if LOCALE == "deDE"  then -- German
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. curator .. "|r: ";
	L["ADDED_ITEM"] = "Hinzugefügt ";
	L["REMOVED_ITEM"] = "Entfernt ";
	L["DELETED_ITEM"] = "Gelöscht ";
	-- ERRORS
	L["CANNOT_ADD_ITEM"] = " ist bereits in Ihrer Kontoliste vorhanden!";
	L["NO_COMMANDS"] = "Keine verfügbaren Befehle! Befehle wurden in Version 1.2.0 verworfen.";
	-- INFO
	L["SOLD_ITEMS"] = "Verkauft alle Artikel mit einem Nettogewinn von ";
	L["REPAIRED_ITEMS"] = "Repariert alle Artikel zu folgenden Kosten ";
	L["DELETED_ITEM_TEXT"] = " Artikel ohne Verkaufspreis.";
return end;