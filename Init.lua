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
local sellPrice = 0;
local sellProfit = 0;
local deletedItemCount = 0;
local doNotAdd = false;

-- Module Functions
local function Contains(itemID)
	for i = 1, #CuratorSellListPerCharacter do
		if tonumber(CuratorSellListPerCharacter[i]) == nil then -- The object at this index is an item link.
			local itemIDInList = GetItemInfoInstant(CuratorSellListPerCharacter[i]);
			if itemIDInList == itemID then
				return true;
			else
				i = i + 1;
			end
		else -- The object at this index is an itemID.
			if CuratorSellListPerCharacter[i] == itemID then
				return true;
			else
				i = i + 1;
			end
		end
	end
end

local function CalculateProfit(itemID, itemCount)
	sellPrice = itemCount * select(11, GetItemInfo(itemID));
	sellProfit = sellProfit + sellPrice;
end

local function ScanInventory()
	local _, _, _, quality, _, _, itemLink, _, _, itemID;
	
	for i = 0, (NUM_BAG_FRAMES + 1) do -- The constant is equal to 4.
		for j = 1, GetContainerNumSlots(i) do
			_, itemCount, _, quality, _, _, itemLink, _, _, itemID = GetContainerItemInfo(i, j);
			
			if itemID then -- This accounts for empty slots and items without an ID.
				if quality < 1 then -- This is a poor quality item.
					CalculateProfit(itemID, itemCount);
					UseContainerItem(i, j);
				else
					if Contains(itemID) then -- This is an item that the player added to the database.
						CalculateProfit(itemID, itemCount);
						if sellPrice == 0 then
							PickupContainerItem(i, j);
							DeleteCursorItem();
							deletedItemCount = deletedItemCount + 1;
						else
							local itemString = select(3, strfind(itemLink, "|H(.+)|h")); itemString = string.match(itemString, "(.*)%[");
							CalculateProfit(itemString, itemCount);
							UseContainerItem(i, j);
						end
					end
				end
			end
		end
	end
end

local function Add(arg)
	if tonumber(arg) ~= nil then -- We're dealing with some numbers.
		for i in string.gmatch(arg, "%S+") do
			for j = 1, #CuratorSellListPerCharacter do
				if tonumber(CuratorSellListPerCharacter[j]) ~= nil then -- The current index is an item ID.
					if tonumber(CuratorSellListPerCharacter[j]) == tonumber(i) then -- This is a comparison between two item IDs.
						doNotAdd = true;
						break;
					end
				else -- The current index is an item link.
					local itemID = GetItemInfoInstant(CuratorSellListPerCharacter[j]);
					if itemID == tonumber(i) then -- The system found a match, an item ID vs an item link.
						doNotAdd = true;
						break;
					end
				end
			end
			if not doNotAdd then
				CuratorSellListPerCharacter[#CuratorSellListPerCharacter + 1] = i;
				print("|cff00ccff" .. curator .. "|r: " .. "Added " .. i .. ".");
			else
				print("|cff00ccff" .. curator .. "|r: " .. "This character already added " .. CuratorSellListPerCharacter[j] .. "!");
				doNotAdd = false;
			end
		end
	else -- We're dealing with some item links.
		local itemLinks = { strsplit("] [", arg) };
		local index;

		for k, v in ipairs(itemLinks) do
			local _, itemLink = GetItemInfo(itemLinks[k]);
			if itemLink then
				local itemID = GetItemInfoInstant(itemLink);
				for j = 1, #CuratorSellListPerCharacter do -- Silently check if the item ID associated with this item link is already in the table.
					if tonumber(CuratorSellListPerCharacter[j]) ~= nil then -- This is an item ID.
						index = tonumber(CuratorSellListPerCharacter[j]);
						if index == itemID then
							doNotAdd = true;
							break;
						end
					else -- This is an item link.
						index = CuratorSellListPerCharacter[j];
						if index == itemLink then
							doNotAdd = true;
							break;
						end
					end
				end
				if not doNotAdd then -- This is when 'doNotAdd' is false and we should add the item to the table.
					CuratorSellListPerCharacter[#CuratorSellListPerCharacter + 1] = itemLink;
					print("|cff00ccff" .. curator .. "|r: " .. "Added " .. itemLink .. ".");
				else
					print("|cff00ccff" .. curator .. "|r: " .. "This character already added " .. itemLink .. "!");
					doNotAdd = false;
				end
			end
		end
	end
end

local function Remove(arg)
	for i in string.gmatch(arg, "%S+") do
		if tonumber(i) ~= nil then -- The player passed an item ID to the command.
			for j = 1, #CuratorSellListPerCharacter do
				if tonumber(CuratorSellListPerCharacter[j]) ~= nil then -- The current index is an item ID.
					if CuratorSellListPerCharacter[j] == i then -- The system found a match, an item ID vs an item ID.
						print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. CuratorSellListPerCharacter[j] .. ".");
						table.remove(CuratorSellListPerCharacter, j);
						break;
					end
				else -- The current index matches an item link.
					local itemID = GetItemInfoInstant(CuratorSellListPerCharacter[j]);
					if tonumber(itemID) == tonumber(i) then -- The passed item ID matches the item ID of the current item link.
						print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. CuratorSellListPerCharacter[j] .. ".");
						table.remove(CuratorSellListPerCharacter, j);
						break;
					end
				end
			end
		else
			break;
		end
	end
	
	local itemLinks = { strsplit("] [", arg) };
	
	for k, v in ipairs(itemLinks) do
		local _, itemLink = GetItemInfo(itemLinks[k]);
		if itemLink then
			for i = 1, #CuratorSellListPerCharacter do
				if tonumber(CuratorSellListPerCharacter[i]) ~= nil then -- The object at this index is an item ID.
					local itemID = GetItemInfoInstant(itemLink);
					if tonumber(CuratorSellListPerCharacter[i]) == itemID then -- The system found a match, an item ID vs an item link.
						print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. CuratorSellListPerCharacter[i] .. ".");
						table.remove(CuratorSellListPerCharacter, i);
						break;
					end
				else -- The object at this index is an item link.
					if CuratorSellListPerCharacter[i] == itemLink then -- The passed item link matches the item link of the current index.
						print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. CuratorSellListPerCharacter[i] .. ".");
						table.remove(CuratorSellListPerCharacter, i);
						break;
					end
				end
			end
		end
	end
	--print("|cff00ccff" .. curator .. "|r: " .. arg .. " isn't in the list!");
	return;
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
	elseif cmd == "remove" and args ~= "" then
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
		if sellProfit ~= 0 then
			print("|cff00ccff" .. curator .. "|r: " .. "Sold all items for the following profit: " .. GetCoinTextureString(sellProfit, 12));
			sellProfit = 0;
		end
		
		if deletedItemCount > 0 then
			print("|cff00ccff" .. curator .. "|r: " .. "Deleted " .. deletedItemCount .. " item(s) with no sell price.");
			deletedItemCount = 0;
		end
	end
end);