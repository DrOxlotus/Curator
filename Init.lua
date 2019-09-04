--[[
	Project			: Curator © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-06-12
	Purpose			: Main file of the addon.
]]--

-- Addon Variables
local curator, curatorNS = ...;
local L = curatorNS.L;

-- Module Variables
local frame = CreateFrame("Frame");
local mouseFrame = CreateFrame("Frame", "MouseFrame", UIParent);
local isAddonLoaded = IsAddOnLoaded("Curator");
local deletedItemCount = 0;
local itemProfit = 0;
local addItem = true;
local doNotDisplayItemInfo = false;
local itemExists = false;
local itemHasNoSellPrice = false;
local tooltipLink;
local repairCost;
local sellIndices = {};

-- Bindings
BINDING_HEADER_CURATOR = string.upper(L["ADDON_NAME"]);
BINDING_NAME_CURATOR_ACCOUNT_LIST = L["BINDING_CURATOR_ACCOUNT_LIST"];
BINDING_NAME_CURATOR_CHARACTER_LIST = L["BINDING_CURATOR_CHARACTER_LIST"];
BINDING_NAME_CURATOR_CHEAPEST_ITEM = L["BINDING_CURATOR_CHEAPEST_ITEM"];
BINDING_NAME_CURATOR_DISABLE_DISPLAY_INFO = L["BINDING_CURATOR_DISPLAY_INFO"];

-- Module Functions
local function Contains(itemID)
	for i = 1, #CuratorSellListPerCharacter do
		if CuratorSellListPerCharacter[i] == itemID then
			if select(11, GetItemInfo(itemID)) == 0 then
				itemHasNoSellPrice = true;
			else
				itemHasNoSellPrice = false;
			end
			
			return true;
		end
	end
	
	for i = 1, #CuratorSellList do
		if CuratorSellList[i] == itemID then
			if select(11, GetItemInfo(itemID)) == 0 then
				itemHasNoSellPrice = true;
			else
				itemHasNoSellPrice = false;
			end
			
			return true;
		end
	end
end

-- Module Init
local scanner = CreateFrame("GameTooltip", "CuratorScanner", UIParent, "GameTooltipTemplate"); scanner:SetOwner(UIParent,"ANCHOR_NONE");

local function DoesItemHaveSellPrice(itemLink)
	local sellPrice = select(11, GetItemInfo(itemLink));
	if sellPrice > 0 then return true else return false end;
end

local function CalculateProfit(item)
	if item then
		local itemCount = GetItemCount(item, false); local sellPrice = itemCount * select(11, GetItemInfo(item));
		
		print(item .. "x" .. itemCount .. " " .. GetCoinTextureString(sellPrice));
		
		return sellPrice;
	end
end

local function SellItems(tbl)
	local i = 1;
	if (next(tbl) ~= nil) then
		for itemID, itemInfo in pairs(tbl) do
			while i <= 8 do
				if tbl[itemID]["hasSellPrice"] then
					itemProfit = itemProfit + CalculateProfit(tbl[itemID]["itemLink"]);
					UseContainerItem(tbl[itemID]["bag"], tbl[itemID]["slot"]);
				else
					PickupContainerItem(tbl[itemID]["bag"], tbl[itemID]["slot"]);
					DeleteCursorItem();
					deletedItemCount = deletedItemCount + 1;
				end
				tbl[itemID] = nil;
				i = i + 1; break;
			end
		end
		print(L["ADDON_NAME"] .. L["SOLD_ITEMS"] .. GetCoinTextureString(itemProfit, 12));
	else
		print(L["ADDON_NAME"] .. L["NO_ITEMS"]);
	end
	
	if deletedItemCount > 0 then
		print(L["ADDON_NAME"] .. L["DELETED_ITEM"] .. deletedItemCount .. L["DELETED_ITEM_TEXT"]);
		deletedItemCount = 0;
	end
	
	itemProfit = 0;
end

local function ScanInventory()
	for i = 0, (NUM_BAG_FRAMES + 1) do -- The constant is equal to 4.
		for j = 1, GetContainerNumSlots(i) do
			local _, itemCount, _, quality, _, _, itemLink, _, _, itemID = GetContainerItemInfo(i, j);
			
			if itemID then -- This accounts for empty slots and items without an ID.
				if itemCount then
					if (quality < 1) then -- This is a poor quality item.
						if DoesItemHaveSellPrice(itemLink) then
							sellIndices[itemID] = {bag = i, slot = j, hasSellPrice = true, itemLink = itemLink};
						else
							sellIndices[itemID] = {bag = i, slot = j, hasSellPrice = false};
						end
					else
						if (Contains(itemID)) then -- This is an item that the player added to the database.
							if itemHasNoSellPrice then
								sellIndices[itemID] = {bag = i, slot = j, hasSellPrice = false};
							else
								local itemString = string.match(select(3, strfind(itemLink, "|H(.+)|h")), "(.*)%[");
								sellIndices[itemID] = {bag = i, slot = j, hasSellPrice = true, itemLink = itemLink};
							end
						end
					end
				end
			end
		end
	end
	SellItems(sellIndices);
end

local function Report(func, ret, val)
	if func == "Add" then
		if ret == "+" then
			--print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. val .. ".");
		end
	elseif func == "Remove" then
		if ret == "+" then
			--print(L["ADDON_NAME"] .. L["REMOVED_ITEM"] .. val .. ".");
		end
	else
		if ret == "+" then
			print(L["ADDON_NAME"] .. val .. L["CANNOT_ADD_ITEM"]);
		end
	end
end

local function Remove(arg, tbl, index)
	table.remove(tbl, index);
	Report("Remove", "+", arg);
end

local function Add(arg, tbl)
	if tonumber(arg) ~= nil then -- We're dealing with some numbers.
		for i in string.gmatch(arg, "%S+") do
			i = tonumber(i);
			for index, id in ipairs(tbl) do
				if tbl[index] == i then
					addItem = false;
					Remove(i, tbl, index);
					--Report("Remove", "+", i);
					break;
				end
			end
			if tbl == CuratorSellListPerCharacter then -- Check if the item is in the account list.
				for k, v in ipairs(CuratorSellList) do
					if v == i then
						Report("", "+", i);
						return;
					end
				end
			else -- Check if the item exists in the character list.
				for k, v in ipairs(CuratorSellListPerCharacter) do
					if v == i then
						table.remove(CuratorSellListPerCharacter, k);
					end
				end
			end
			if addItem then
				tbl[#tbl + 1] = tonumber(i);
				--Report("Add", "+", i);
				return true;
			else
				addItem = true;
				return false;
			end
		end
	else -- We're dealing with some item links.
		local itemLinks = { strsplit("][", arg) };

		for k, v in ipairs(itemLinks) do
			local _, itemLink = GetItemInfo(itemLinks[k]);
			if itemLink then
				local itemID = GetItemInfoInstant(itemLink);
				for index, id in ipairs(tbl) do
					if tbl[index] == itemID then
						addItem = false;
						Remove(itemID, tbl, index);
					end
				end
				if tbl == CuratorSellListPerCharacter then
					for k, v in ipairs(CuratorSellList) do
						if v == itemID then
							Report("", "+", itemID);
							return;
						end
					end
				else -- Check if the item exists in the character list.
					for k, v in ipairs(CuratorSellListPerCharacter) do
						if v == itemID then
							table.remove(CuratorSellListPerCharacter, k);
						end
					end
				end
				if addItem then
					tbl[#tbl + 1] = tonumber(itemID);
					--Report("Add", "+", itemLink);
					return true;
				else
					addItem = true;
					return false;
				end
			end
		end
	end
end

local function DisplayItemInfo(tooltip)
	if (CuratorSettings["disableDisplayInfo"] == false) then
		local _, itemLink = tooltip:GetItem();
		
		if (itemLink) then
			local itemID = (GetItemInfoInstant(itemLink));
			local _, _, _, _, _, _, _, maxStackCount = GetItemInfo(itemLink);
			
			if itemID then
					tooltip:AddDoubleLine("Item ID\n" .. "Stack\n" .. "Count", itemID .. "\n" .. maxStackCount .. "\n" .. 
					GetItemCount(itemID, true) .. " (" .. GetItemCount(itemID, true) .. ")", 1, 1, 0, 1, 1, 1);
					tooltip:Show();
				--[[if (CuratorItemInfo[itemID]) then -- Update Item Info
					CuratorItemInfo[itemID]["count"] = CuratorItemInfo[itemID]["count"] + GetItemCount(itemID, true);
					CuratorItemInfoPerCharacter[itemID]["count"] = GetItemCount(itemID, true);
					
					tooltip:AddDoubleLine("Item ID\n" .. "Stack\n" .. "Count", itemID .. "\n" .. CuratorItemInfo[itemID]["maxStackCount"] .. "\n" .. 
					CuratorItemInfoPerCharacter[itemID]["count"] .. " (" .. CuratorItemInfo[itemID]["count"] .. ")", 1, 1, 0, 1, 1, 1);
					tooltip:Show();
				else -- Add Item Info
					CuratorItemInfo[itemID] = {maxStackCount = select(8, GetItemInfo(itemID)), count = GetItemCount(itemID, true)};
					CuratorItemInfoPerCharacter[itemID] = {count = GetItemCount(itemID, true)};
					
					tooltip:AddDoubleLine("Item ID\n" .. "Stack\n" .. "Count", itemID .. "\n" .. CuratorItemInfo[itemID]["maxStackCount"] .. "\n" .. 
					CuratorItemInfoPerCharacter[itemID]["count"] .. " (" .. CuratorItemInfo[itemID]["count"] .. ")", 1, 1, 0, 1, 1, 1);
					tooltip:Show();
				end]]--
			end
		end
	end
end

local function GetItemLinkFromTooltip(tooltip)
	local itemName, itemLink = tooltip:GetItem();
	
	if itemName and itemLink then
		tooltipLink = itemLink;
	end
end

-- The first tooltip after login returns 'nil'. Ask Blizzard; I have no idea...
function CuratorHandleKeyPress(key)
	if (key == GetBindingKey("CURATOR_CHARACTER_LIST")) then -- Character List
		GameTooltip:HookScript("OnTooltipSetItem", GetItemLinkFromTooltip);
		
		if tooltipLink then
			Add(tooltipLink, CuratorSellListPerCharacter);
		end
	elseif (key == GetBindingKey("CURATOR_ACCOUNT_LIST")) then -- Account List
		GameTooltip:HookScript("OnTooltipSetItem", GetItemLinkFromTooltip);
		
		if tooltipLink then
			Add(tooltipLink, CuratorSellList);
		end
	elseif (key == GetBindingKey("CURATOR_CHEAPEST_ITEM")) then -- Identify Cheapest Item
		curatorNS.ScanInventory();
	elseif (key == GetBindingKey("CURATOR_DISABLE_DISPLAY_INFO")) then -- Disable Display Item Info
		if (CuratorSettings["disableDisplayInfo"] == true) then
			CuratorSettings["disableDisplayInfo"] = false;
		else
			CuratorSettings["disableDisplayInfo"] = true;
		end
	end
end

-- Event Registrations
frame:RegisterEvent("MERCHANT_SHOW");
frame:RegisterEvent("MERCHANT_CLOSED");
frame:RegisterEvent("PLAYER_LOGIN");

SLASH_curator1 = "/curator";
SlashCmdList["curator"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");
	
	if not cmd or cmd == "" then
		print(L["ADDON_NAME"] .. L["NO_COMMANDS"]);
	end
end

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and isAddonLoaded then
		if CuratorSettings == nil then
			CuratorSettings = {};
			CuratorSettings["disableDisplayInfo"] = false;
		end
		
		if CuratorSellListPerCharacter == nil then
			CuratorSellListPerCharacter = {};
		end
		
		if CuratorSellList == nil then
			CuratorSellList = {};
		end
		
		if (CuratorItemInfo == nil) then
			CuratorItemInfo = {};
		end
		
		if (CuratorItemInfoPerCharacter == nil) then
			CuratorItemInfoPerCharacter = {};
		end
		
		for i, j in ipairs(CuratorSellList) do
			for k, v in ipairs(CuratorSellListPerCharacter) do
				if v == j then
					table.remove(CuratorSellListPerCharacter, k);
				end
			end
		end
		
		GameTooltip:HookScript("OnTooltipSetItem", DisplayItemInfo);
	end

	if event == "MERCHANT_SHOW" then
		local playerMoney = GetMoney();
		local canRepair = CanMerchantRepair();
		local canGuildBankRepair = CanGuildBankRepair();
		local canWithdrawGuildBankMoney = CanWithdrawGuildBankMoney();
		repairCost = GetRepairAllCost();
		if canRepair then -- The current merchant has the repair option.
			if canGuildBankRepair then -- The player can use guild repairs.
				if canWithdrawGuildBankMoney then
					if repairCost > 0 then -- The player has items that need repaired.
						RepairAllItems(1); -- Uses guild bank money to fund the repairs.
					end
				else
					if playerMoney > repairCost then
						if repairCost > 0 then
							RepairAllItems();
						end
					end
				end
			else
				if repairCost > 0 then -- The player has items that need repaired.
					if playerMoney > repairCost then -- The player has enough money to fund the repair.
						RepairAllItems();
					else
						print(L["ADDON_NAME"] .. L["LOW_FUNDS"]);
					end
				end
			end
		end
		ScanInventory();
	end
	
	--[[if event == "MERCHANT_CLOSED" then
		if (curatorNS.totalProfit > 0) then -- The player sold some items.
			if (repairCost > curatorNS.totalProfit) then -- The player didn't sell enough (or enough pricey items).
				print(L["ADDON_NAME"] .. L["NET_LOSS_TEXT"] .. GetCoinTextureString((repairCost - curatorNS.totalProfit), 12)); 
				print(L["ADDON_NAME"] .. L["REPAIR_COST_TEXT"] .. GetCoinTextureString(repairCost, 8));
				print(L["ADDON_NAME"] .. L["PROFIT_TEXT"] .. GetCoinTextureString(curatorNS.totalProfit, 8));
			else -- The profit is higher than the cost of repairs.
				print(L["ADDON_NAME"] .. L["SOLD_ITEMS"] .. GetCoinTextureString((curatorNS.totalProfit - repairCost), 12) .. 
				" (-" .. GetCoinTextureString(repairCost, 8) .. ")");
			end
		elseif repairCost > 0 then -- The player repaired, but sold nothing.
			print(L["ADDON_NAME"] .. L["REPAIRED_ITEMS"] .. GetCoinTextureString(repairCost, 12));
		end
		repairCost = 0;
	end]]--
end);

local function DoesItemExist(tooltip)
	local frame, text;
	local _, itemLink = tooltip:GetItem();
	
	if not itemLink then return end;
	
	local itemID = GetItemInfoInstant(itemLink);
	
	if not itemID then return end;
	
	for i = 1, #CuratorSellList do
		if CuratorSellList[i] == itemID then
			tooltip:AddLine(L["ADDON_NAME"] .. L["ACCOUNT_LIST"]);
			tooltip:Show();
			break;
		end
	end
	
	for j = 1, #CuratorSellListPerCharacter do
		if CuratorSellListPerCharacter[j] == itemID then
			tooltip:AddLine(L["ADDON_NAME"] .. L["CHAR_LIST"]);
			tooltip:Show();
			break;
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", DoesItemExist);
mouseFrame:SetScript("OnKeyDown", HandleKeyPress);
mouseFrame:SetPropagateKeyboardInput(true);

--[[function ConvertAllRecords()
	for i = 1, #CuratorSellListPerCharacter do
		if tonumber(CuratorSellListPerCharacter[i]) == nil then -- It's not a number.
			local itemID = GetItemInfoInstant(CuratorSellListPerCharacter[i]);
			CuratorSellListPerCharacter[i] = itemID;
		elseif type(CuratorSellListPerCharacter[i]) ~= "number" then -- It's not a number.
			local itemID = GetItemInfoInstant(CuratorSellListPerCharacter[i]);
			CuratorSellListPerCharacter[i] = itemID;
		end
	end
end]]--