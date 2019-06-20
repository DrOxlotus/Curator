--[[
	Project			: Curator © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-06-12
	Purpose			: Main file of the addon.
]]--

-- Addon Variables
local curator, curatorNS = ...;

-- Module Variables
local frame = CreateFrame("Frame");
local mouseFrame = CreateFrame("Frame", "MouseFrame", UIParent);
local isAddonLoaded = IsAddOnLoaded("Curator");
local profit = 0;
local deletedItemCount = 0;
local addItem = true;
local itemExists = false;
local itemHasNoSellPrice = false;
local tooltipLink;
local repairCost;

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

local function CalculateProfit(item, itemCount)
	local itemProfit = (itemCount * select(11, GetItemInfo(item)));
	profit = (profit + itemProfit);
	
	return itemProfit;
end

local function ScanInventory()
	
	for i = 0, (NUM_BAG_FRAMES + 1) do -- The constant is equal to 4.
		for j = 1, GetContainerNumSlots(i) do
			local _, itemCount, _, quality, _, _, itemLink, _, _, itemID = GetContainerItemInfo(i, j);
			
			if itemID then -- This accounts for empty slots and items without an ID.
				if quality < 1 then -- This is a poor quality item.
					if CalculateProfit(itemID, itemCount) > 0 then
						UseContainerItem(i, j);
					else
						PickupContainerItem(i, j);
						DeleteCursorItem();
						deletedItemCount = deletedItemCount + 1;
					end
				else
					if Contains(itemID) then -- This is an item that the player added to the database.
						if itemHasNoSellPrice then
							PickupContainerItem(i, j);
							DeleteCursorItem();
							deletedItemCount = deletedItemCount + 1;
						else
							local itemString = string.match(select(3, strfind(itemLink, "|H(.+)|h")), "(.*)%[");
							CalculateProfit(itemString, itemCount);
							UseContainerItem(i, j);
						end
					end
				end
			end
		end
	end
end

local function Report(func, ret, val)
	if func == "Add" then
		if ret == "+" then
			print("|cff00ccff" .. curator .. "|r: " .. "Added " .. val .. ".");
		end
	else -- Remove
		if ret == "+" then
			print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. val .. ".");
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
			for index, id in ipairs(tbl) do
				if tbl[index] == i then
					addItem = false;
					Remove(itemID, tbl, index);
					Report("Remove", "+", i);
					break;
				end
			end
			if addItem then
				tbl[#tbl + 1] = tonumber(i);
				Report("Add", "+", i);
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
				if addItem then
					tbl[#tbl + 1] = tonumber(itemID);
					Report("Add", "+", itemLink);
					return true;
				else
					addItem = true;
					return false;
				end
			end
		end
	end
end

local function GetItemLinkFromTooltip(tooltip)
	local _, itemLink = tooltip:GetItem();
	if not itemLink then
		return
	else
		tooltipLink = itemLink;
	end
end

local function HandleKeyPress(self, key)
	if (key == "F5") then -- Add the item to the character list.
		GameTooltip:HookScript("OnTooltipSetItem", GetItemLinkFromTooltip);
		
		if tooltipLink then -- On the first key press after logon or reload the tooltip returns a 'nil' value.
			Add(tooltipLink, CuratorSellListPerCharacter);
		end
	end
	
	if (key == "F6") then -- Remove the item from the character list.
		GameTooltip:HookScript("OnTooltipSetItem", GetItemLinkFromTooltip);
		
		if tooltipLink then -- On the first key press after logon or reload the tooltip returns a 'nil' value.
			Add(tooltipLink, CuratorSellList);
		end
	end
end

-- Event Registrations
mouseFrame:RegisterEvent("MODIFIER_STATE_CHANGED");
frame:RegisterEvent("MERCHANT_SHOW");
frame:RegisterEvent("MERCHANT_CLOSED");
frame:RegisterEvent("PLAYER_LOGIN");

SLASH_curator1 = "/curator";
SlashCmdList["curator"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");
	
	if not cmd or cmd == "" then
		print("|cff00ccff" .. curator .. "|r: " .. "Please use the add or remove commands.");
	elseif cmd == "add" and args ~= "" then
		Add(args);
	elseif cmd == "remove" or cmd == "rm" and args ~= "" then
		Remove(args);
	else
		print("|cff00ccff" .. curator .. "|r: " .. "Not a valid command or the command used is missing operands.");
	end
end

frame:SetScript("OnEvent", function(self, event, ...)

	if event == "PLAYER_LOGIN" and isAddonLoaded then
		if CuratorSellListPerCharacter == nil then
			CuratorSellListPerCharacter = {};
		end
		
		if CuratorSellList == nil then
			CuratorSellList = {};
		end
	end

	if event == "MERCHANT_SHOW" then
		local canRepair = CanMerchantRepair();
		repairCost = GetRepairAllCost();
		if canRepair then -- The current merchant has the repair option.
			if repairCost > 0 then -- The player has items that need repaired.
				local playerMoney = GetMoney();
				if playerMoney > repairCost then -- The player has enough money to fund the repair.
					RepairAllItems();
				end
			end
		end
		ScanInventory();
	end
	
	if event == "MERCHANT_CLOSED" then
		if profit > 0 then -- The player sold some items.
			if repairCost > profit then -- The player didn't sell enough (or enough pricey items).
				print(repairCost);
				print(profit);
				--print("|cff00ccff" .. curator .. "|r: " .. "Net Loss: " .. GetCoinTextureString("-" .. (repairCost - profit), 12) .. 
				--" (Repair Cost: " .. GetCoinTextureString(repairCost, 8) .. ") " .. "(Profit: " .. GetCoinTextureString(profit, 8) .. ")");
			else -- The profit is higher than the cost of repairs.
				print("|cff00ccff" .. curator .. "|r: " .. "Sold all items with a net gain of " .. GetCoinTextureString((profit - repairCost), 12) .. 
				" (-" .. GetCoinTextureString(repairCost, 8) .. ")");
			end
		elseif repairCost > 0 then -- The player repaired, but sold nothing.
			print("|cff00ccff" .. curator .. "|r: " .. "Repaired all items at the following cost: " .. GetCoinTextureString(repairCost, 12));
		end
		
		if deletedItemCount > 0 then
			print("|cff00ccff" .. curator .. "|r: " .. "Deleted " .. deletedItemCount .. " item(s) with no sell price.");
			deletedItemCount = 0;
		end
		
		profit = 0;
		repairCost = 0;
	end
end);

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