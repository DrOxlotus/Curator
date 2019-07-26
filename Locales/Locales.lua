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
	L["LOW_FUNDS"] = "Unable to repair. Lack of funds!";
	-- INFO
	L["SOLD_ITEMS"] = "Sold all items with a net gain of ";
	L["REPAIRED_ITEMS"] = "Repaired all items for ";
	L["DELETED_ITEM_TEXT"] = " item(s) with no sell price.";
	L["NET_LOSS_TEXT"] = "You had a net loss of -";
	L["REPAIR_COST_TEXT"] = "Repairs: ";
	L["PROFIT_TEXT"] = "Profit: ";
	L["ACCOUNT_LIST"] = "|cffe6cc80" .. "Account" .. "|r";
	L["CHAR_LIST"] = "|cff1eff00" .. GetUnitName("player", false) .. "|r";
	-- BINDINGS
	L["BINDING_CURATOR_ACCOUNT_LIST"] = "Account List";
	L["BINDING_CURATOR_CHARACTER_LIST"] = "Character List";
	L["BINDING_CURATOR_CHEAPEST_ITEM"] = "Identify Cheapest Item";
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
	L["LOW_FUNDS"] = "Impossible de réparer. Manque de fonds!";
	-- INFO
	L["SOLD_ITEMS"] = "Vendu tous les articles avec un gain net de ";
	L["REPAIRED_ITEMS"] = "Réparé tous les articles pour ";
	L["DELETED_ITEM_TEXT"] = " article(s) sans prix de vente.";
	L["NET_LOSS_TEXT"] = "Vous avez eu une perte nette de -";
	L["REPAIR_COST_TEXT"] = "Réparations: ";
	L["PROFIT_TEXT"] = "Profit: ";
	L["ACCOUNT_LIST"] = "|cffe6cc80" .. "Compte" .. "|r";
	L["CHAR_LIST"] = "|cff1eff00" .. GetUnitName("player", false) .. "|r";
	-- BINDINGS
	L["BINDING_CURATOR_ACCOUNT_LIST"] = "Compte Liste";
	L["BINDING_CURATOR_CHARACTER_LIST"] = "Personnage Liste";
	L["BINDING_CURATOR_CHEAPEST_ITEM"] = "Identifier l'article le moins cher";
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
	L["LOW_FUNDS"] = "Reparatur nicht möglich. Geldmangel!";
	-- INFO
	L["SOLD_ITEMS"] = "Verkauft alle Artikel mit einem Nettogewinn von ";
	L["REPAIRED_ITEMS"] = "Reparierte alle Einzelteile für ";
	L["DELETED_ITEM_TEXT"] = " Artikel ohne Verkaufspreis.";
	L["NET_LOSS_TEXT"] = "Sie hatten einen Nettoverlust von -";
	L["REPAIR_COST_TEXT"] = "Reparaturen: ";
	L["PROFIT_TEXT"] = "Profitieren: ";
	L["ACCOUNT_LIST"] = "|cffe6cc80" .. "Konto" .. "|r";
	L["CHAR_LIST"] = "|cff1eff00" .. GetUnitName("player", false) .. "|r";
	-- BINDINGS
	L["BINDING_CURATOR_ACCOUNT_LIST"] = "Konto Liste";
	L["BINDING_CURATOR_CHARACTER_LIST"] = "Charakter Liste";
	L["BINDING_CURATOR_CHEAPEST_ITEM"] = "Identifizieren Sie den günstigsten Artikel";
return end;