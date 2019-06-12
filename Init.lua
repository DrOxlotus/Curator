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

local function Add(arg)
	if tonumber(arg) ~= nil then
		arg = tonumber(arg);
	end
	
	for i = 1, #CuratorSellListPerCharacter do
		if CuratorSellListPerCharacter[i] == arg then
			print("|cff00ccff" .. curator .. "|r: " .. "This character already added " .. arg .. "!");
			return;
		end
	end
	
	CuratorSellListPerCharacter[#CuratorSellListPerCharacter + 1] = arg;
	print("|cff00ccff" .. curator .. "|r: " .. "Added " .. arg .. ".");
	return;
end

local function Remove(arg)
	if tonumber(arg) ~= nil then
		arg = tonumber(arg);
	end
	
	for i = 1, #CuratorSellListPerCharacter do
		if tonumber(CuratorSellListPerCharacter[i]) == nil then -- The object at this index is an item link.
			local itemIDInList = GetItemInfoInstant(CuratorSellListPerCharacter[i]);
			if tonumber(arg) ~= nil then -- The player passed an item ID to the command.
				if itemIDInList then
					if itemIDInList == arg then -- The player passed an item ID for an object that is in the table as an item link.
						table.remove(CuratorSellListPerCharacter, i);
						print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. arg .. ".");
						return;
					end
				end
			else -- The player passed an item link to the command.
				local argItemID = GetItemInfoInstant(arg);
				if itemIDInList == argItemID then
					table.remove(CuratorSellListPerCharacter, i);
					print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. arg .. ".");
					return;
				end
			end
		else -- The object at this index is an item ID.
			if CuratorSellListPerCharacter[i] == arg then -- The player passed an item ID to the command.
				table.remove(CuratorSellListPerCharacter, i);
				print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. arg .. ".");
				return;
			else -- The player passed an item link to the command.
				local argItemID = GetItemInfoInstant(arg);
				if CuratorSellListPerCharacter[i] == argItemID then
					table.remove(CuratorSellListPerCharacter, i);
					print("|cff00ccff" .. curator .. "|r: " .. "Removed " .. arg .. ".");
					return;
				end
			end
		end
	end
	
	print("|cff00ccff" .. curator .. "|r: " .. arg .. " isn't in the list!");
	return;
end

-- Event Registrations
frame:RegisterEvent("MERCHANT_SHOW");
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
		local _, _, _, quality, _, _, itemLink, _, _, itemID;
		for i = 0, (NUM_BAG_FRAMES + 1) do -- The constant is equal to 4.
			for j = 1, GetContainerNumSlots(i) do
				_, _, _, quality, _, _, itemLink, _, _, itemID = GetContainerItemInfo(i, j);
				
				if quality then -- This accounts for empty slots.
					if quality < 1 then -- This is a poor quality item.
						UseContainerItem(i, j);
					else
						if Contains(itemID) then
							UseContainerItem(i, j);
						end
					end
				end
			end
		end
	end
end);