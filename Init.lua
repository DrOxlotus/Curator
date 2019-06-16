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
local isAddonLoaded = IsAddOnLoaded("Curator");
local profit = 0;
local deletedItemCount = 0;
local doNotAddItem = false;
local itemExists = false;
local itemHasNoSellPrice = false;

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
end

local function CalculateProfit(item, itemCount)
	profit = (profit) + (itemCount * select(11, GetItemInfo(item)));
	print(profit);
end

local function ScanInventory()
	
	for i = 0, (NUM_BAG_FRAMES + 1) do -- The constant is equal to 4.
		for j = 1, GetContainerNumSlots(i) do
			local _, itemCount, _, quality, _, _, itemLink, _, _, itemID = GetContainerItemInfo(i, j);
			
			if itemID then -- This accounts for empty slots and items without an ID.
				if quality < 1 then -- This is a poor quality item.
					CalculateProfit(itemID, itemCount);
					UseContainerItem(i, j);
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

local function Add(arg)
	if tonumber(arg) ~= nil then -- We're dealing with some numbers.
		for i in string.gmatch(arg, "%S+") do
			doNotAddItem = false;
			for j = 1, #CuratorSellListPerCharacter do
				if CuratorSellListPerCharacter[j] == tonumber(i) then
					doNotAddItem = true;
					break;
				end
			end
			if not doNotAddItem then
				CuratorSellListPerCharacter[#CuratorSellListPerCharacter + 1] = tonumber(i);
				Report("Add", "+", i);
			end
		end
	else -- We're dealing with some item links.
		local itemLinks = { strsplit("][", arg) };

		for k, v in ipairs(itemLinks) do
			doNotAddItem = false;
			local _, itemLink = GetItemInfo(itemLinks[k]);
			if itemLink then
				local itemID = GetItemInfoInstant(itemLink);
				for j = 1, #CuratorSellListPerCharacter do
					if CuratorSellListPerCharacter[j] == itemID then
						doNotAddItem = true;
						break;
					end
				end
				if not doNotAddItem then
					--outputCount = outputCount + 1;
					CuratorSellListPerCharacter[#CuratorSellListPerCharacter + 1] = itemID;
					Report("Add", "+", itemLink);
				end
			end
		end
	end
end

local function Remove(arg)
	if tonumber(arg) ~= nil then -- We're dealing with numbers.
		for i in string.gmatch(arg, "%S+") do
			itemExists = false;
			for j = 1, #CuratorSellListPerCharacter do
				if CuratorSellListPerCharacter[j] == tonumber(i) then
					table.remove(CuratorSellListPerCharacter, j);
					itemExists = true;
					break;
				end
			end
			if itemExists then
				Report("Remove", "+", i);
			end
		end
	else -- We're dealing with item links.
		local itemLinks = { strsplit("][", arg) };
	
		for k, v in ipairs(itemLinks) do
			itemExists = false;
			local _, itemLink = GetItemInfo(itemLinks[k]);
			if itemLink then
				local itemID = GetItemInfoInstant(itemLink);
				for i = 1, #CuratorSellListPerCharacter do
					if CuratorSellListPerCharacter[i] == itemID then
						table.remove(CuratorSellListPerCharacter, i);
						itemExists = true;
						break;
					end
				end
				if itemExists then
					Report("Remove", "+", itemLink);
				end
			end
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
	end

	if event == "MERCHANT_SHOW" then
		ScanInventory();
	end
	
	if event == "MERCHANT_CLOSED" then
		if profit ~= 0 then
			print("|cff00ccff" .. curator .. "|r: " .. "Sold all items for the following profit: " .. GetCoinTextureString(profit, 12));
		end
		
		if deletedItemCount > 0 then
			print("|cff00ccff" .. curator .. "|r: " .. "Deleted " .. deletedItemCount .. " item(s) with no sell price.");
			deletedItemCount = 0;
		end
		
		profit = 0;
	end
end);

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