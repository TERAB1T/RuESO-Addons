local function ItemDumpNames(  )
	--if addonName ~= "ItemDump" then
	--	return
	--end

	ItemDump_SavedVariables = {}
	
	--ItemDump_SavedVariables["test"] = "test"
	
	for i,v in pairs(itemsForDump) do
		local huy, pizda = GetItemLinkItemType("|H1:item:" .. i ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		
		if huy == 61 then
	
			if not ItemDumpNames_SavedVariables[v] and v ~= GetItemLinkName("|H1:item:" .. i ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h") then
				ItemDumpNames_SavedVariables[v] = GetItemLinkName("|H1:item:" .. i ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
			end
		end
	end
end

EVENT_MANAGER:RegisterForEvent("ItemDumpNames", EVENT_PLAYER_ACTIVATED, ItemDumpNames)

--for i,v in ipairs(itemsForDump) do
--	print(v)
--end