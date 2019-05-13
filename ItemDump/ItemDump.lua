local function ItemDump(  )
	--if addonName ~= "ItemDump" then
	--	return
	--end

	ItemDump_SavedVariables = {}
	
	--ItemDump_SavedVariables["test"] = "test"
	
	for i,v in pairs(itemsForDump) do
		if not ItemDump_SavedVariables[v] then
			ItemDump_SavedVariables[v] = {}
		end
		
		ItemDump_SavedVariables[v][0] = {}
		ItemDump_SavedVariables[v][0][0], ItemDump_SavedVariables[v][0][1] = GetItemLinkItemType("|H1:item:" .. i ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		ItemDump_SavedVariables[v][1] = GetItemLinkIcon("|H1:item:" .. i ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
	end
	
	for i,v in pairs(questItemsForDump) do
		if not ItemDump_SavedVariables[v] then
			ItemDump_SavedVariables[v] = {}
		end
		
		ItemDump_SavedVariables[v][0] = {}
		ItemDump_SavedVariables[v][0][0] = 999
		ItemDump_SavedVariables[v][0][1] = 0
		
		ZO_PopupTooltip_SetLink("|H0:quest_item:" .. i .. "|h|h")		
		ItemDump_SavedVariables[v][1] = PopupTooltipIcon:GetTextureFileName()
	end
end

EVENT_MANAGER:RegisterForEvent("ItemDump", EVENT_PLAYER_ACTIVATED, ItemDump)

--for i,v in ipairs(itemsForDump) do
--	print(v)
--end