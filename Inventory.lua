--[[
	Project			: Curator © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-06-29
	Purpose			: The hub for all inventory-related functions.
]]--

-- Addon Variables
local curator, curatorNS = ...;
local L = curatorNS.L;
local eventFrame = CreateFrame("Frame");

local function SetGlowOnContainerItem(bagID, slotID)
	local itemInContainer = nil;
	
	for i = 1, NUM_CONTAINER_FRAMES do
		local containerFrame = _G["ContainerFrame"..i];
		if containerFrame:GetID() == bagID and containerFrame:IsShown() then
			itemInContainer = _G["ContainerFrame"..i.."Item"..(GetContainerNumSlots(bagID) + 1 - slotID)];
		end
	end
	if itemInContainer then
		itemInContainer.NewItemTexture:SetAtlas("bags-glow-artifact");
		itemInContainer.NewItemTexture:Show();
		itemInContainer.flashAnim:Play();
		itemInContainer.newitemglowAnim:Play();
	end
end

local function ScanInventory()
	local bagID = 0;
	local slotID = 0;
	local recentPrice = nil; -- This represents the cheapest item in copper.
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemID = GetContainerItemID(bag, slot);
			if itemID then -- To account for items without an ID or empty slots.
				local _, itemCount = GetContainerItemInfo(bag, slot);
				local vendorPrice = select(11, GetItemInfo(itemID));
				if itemCount > 0 and vendorPrice > 0 then
					local sellPrice = itemCount * vendorPrice;
					if recentPrice == nil then -- This is the first time we're scanning and no cheapest item has been found.
						recentPrice = sellPrice; -- Set the recent price to the first sellPrice received.
						bagID = bag;
						slotID = slot;
					elseif recentPrice > sellPrice then -- A higher profit item was discovered.
						recentPrice = sellPrice;
						bagID = bag;
						slotID = slot;
					end
				end
			end
		end
	end
	if bagID and slotID then
		SetGlowOnContainerItem(bagID, slotID);
	end
end

eventFrame:RegisterEvent("MODIFIER_STATE_CHANGED");
eventFrame:SetScript("OnEvent", function(self, event, key, state)
	if key == "LALT" and state == 1 then
		local areBagsOpen = false;
		for bagID = 0, NUM_BAG_SLOTS do
			if IsBagOpen(bagID) then
				areBagsOpen = true;
				break;
			end
		end
		if areBagsOpen then
			ScanInventory();
		end
	end
end);