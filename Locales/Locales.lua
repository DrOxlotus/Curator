--[[
	Project			: Curator © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-06-28
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
	L["LOW_FUNDS"] = "Unable to repair. Lack of funds!";
	L["NO_COMMANDS"] = "No available commands! Commands were deprecated in release 1.2.0.";
	L["NO_ITEMS"] = "There are no items to sell or delete.";
	-- INFO
	L["SOLD_ITEMS"] = "Sold item(s) for a net gain of ";
	L["REPAIRED_ITEMS"] = "Repaired all items for ";
	L["DELETED_ITEM_TEXT"] = " item(s) with no sell price.";
	L["NET_LOSS_TEXT"] = "You had a net loss of -";
	L["REPAIR_COST_TEXT"] = "Repairs: ";
	L["PROFIT_TEXT"] = "Profit: ";
	-- TOOLTIPS
	L["ACCOUNT_LIST"] = "This item is a member of your Account list.";
	L["CHAR_LIST"] = "This item is a member of your Character list.";
	-- BINDINGS
	L["BINDING_CURATOR_ACCOUNT_LIST"] = "Account List";
	L["BINDING_CURATOR_CHARACTER_LIST"] = "Character List";
	L["BINDING_CURATOR_CHEAPEST_ITEM"] = "Identify Cheapest Item";
	L["BINDING_CURATOR_DISPLAY_INFO"] = "Disable Item Info";
return end;

if LOCALE == "frFR" then -- French
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
	-- TOOLTIPS
	L["ACCOUNT_LIST"] = "Cet élément est un membre de votre liste de compte.";
	L["CHAR_LIST"] = "Cet objet est un membre de votre liste de personnages.";
	-- BINDINGS
	L["BINDING_CURATOR_ACCOUNT_LIST"] = "Compte Liste";
	L["BINDING_CURATOR_CHARACTER_LIST"] = "Personnage Liste";
	L["BINDING_CURATOR_CHEAPEST_ITEM"] = "Identifier l'article le moins cher";
return end;

if LOCALE == "deDE" then -- German
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
	-- TOOLTIPS
	L["ACCOUNT_LIST"] = "Dieser Artikel ist ein Mitglied Ihrer Kontoliste.";
	L["CHAR_LIST"] = "Dieser Gegenstand ist ein Mitglied deiner Charakterliste.";
	-- BINDINGS
	L["BINDING_CURATOR_ACCOUNT_LIST"] = "Konto Liste";
	L["BINDING_CURATOR_CHARACTER_LIST"] = "Charakter Liste";
	L["BINDING_CURATOR_CHEAPEST_ITEM"] = "Identifizieren Sie den günstigsten Artikel";
return end;

if LOCALE == "ruRU" then -- Russian
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. curatorClassic .. "|r: ";
	L["ADDED_ITEM"] = "Добавить ";
	L["REMOVED_ITEM"] = "Удалены ";
	L["DELETED_ITEM"] = "Удалить ";
	-- ERRORS
	L["CANNOT_ADD_ITEM"] = " уже существует на вашем аккаунте!";
	L["NO_COMMANDS"] = "Нет доступных команд! Команды устарели в версии 1.2.0.";
	L["LOW_FUNDS"] = "Невозможно починить. Недостаток средств!";
	-- INFO
	L["SOLD_ITEMS"] = "Проданы все предметы с чистой прибылью ";
	L["REPAIRED_ITEMS"] = "Отремонтировал все предметы для ";
	L["DELETED_ITEM_TEXT"] = " Предметы без цены продажи.";
	L["NET_LOSS_TEXT"] = "У вас был чистый убыток -";
	L["REPAIR_COST_TEXT"] = "Ремонт: ";
	L["PROFIT_TEXT"] = "Прибыль: ";
	-- TOOLTIPS
	L["SELL_PRICE"] = "|cffffffffЦена Продажи:|r ";
	L["NO_SELL_PRICE"] = "|cffffffffНет продажной цены|r";
	L["ACCOUNT_LIST"] = "Этот предмет привязан к Списку Аккаунтов.";
	L["CHAR_LIST"] = "Этот предмет привязан к Списку Персонажей.";
	-- BINDINGS
	L["BINDING_CURATORCLASSIC_ACCOUNT_LIST"] = "Список аккаунтов";
	L["BINDING_CURATORCLASSIC_CHARACTER_LIST"] = "Список персонажей";
	L["BINDING_CURATORCLASSIC_CHEAPEST_ITEM"] = "Определить самый дешевый товар";
return end;