local function ItemDumpExt(  )
	--if addonName ~= "ItemDump" then
	--	return
	--end

	ItemDumpExt_SavedVariables = {}
	
	if not ItemDumpExt_SavedVariables["Items"] then
		ItemDumpExt_SavedVariables["Items"] = {}
	end
	
	SV_Items = ItemDumpExt_SavedVariables["Items"]
	
	if not ItemDumpExt_SavedVariables["QuestItems"] then
		ItemDumpExt_SavedVariables["QuestItems"] = {}
	end
	
	SV_QuestItems = ItemDumpExt_SavedVariables["QuestItems"]
	
	--ItemDump_SavedVariables["test"] = "test"
	
	for v,i in pairs(itemsForDump) do
		if not SV_Items[v] then
			SV_Items[v] = {}
		end
		
		SV_Items[v][0] = {}
		SV_Items[v][0][0], SV_Items[v][0][1] = GetItemLinkItemType("|H1:item:" .. v ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		SV_Items[v][1] = GetItemLinkIcon("|H1:item:" .. v ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		
		if SV_Items[v][0][0] == 1 then
			SV_Items[v][0][1] = GetItemLinkWeaponType("|H1:item:" .. v ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		end
		
		if SV_Items[v][0][0] == 2 then
			SV_Items[v][0][1] = GetItemLinkEquipType("|H1:item:" .. v ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
			SV_Items[v][0][2] = GetItemLinkArmorType("|H1:item:" .. v ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		end
		
		if SV_Items[v][0][0] == 61 then
			SV_Items[v][0][2], SV_Items[v][0][3] = GetFurnitureDataInfo(GetItemLinkFurnitureDataId("|H1:item:" .. v ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h"))
		end
		
		local hasSet, setName = GetItemLinkSetInfo("|H1:item:" .. v ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		
		if hasSet then
			SV_Items[v][2] = setName
		end
	end
	
	for v,i in pairs(questItemsForDump) do
		if not SV_QuestItems[v] then
			SV_QuestItems[v] = {}
		end
		
		SV_QuestItems[v][0] = {}
		SV_QuestItems[v][0][0] = 999
		SV_QuestItems[v][0][1] = 0
		
		--ZO_PopupTooltip_SetLink("|H0:quest_item:" .. v .. "|h|h")		
		SV_QuestItems[v][1] = GetQuestItemIcon(v) --PopupTooltipIcon:GetTextureFileName()
	end
end

EVENT_MANAGER:RegisterForEvent("ItemDump", EVENT_PLAYER_ACTIVATED, ItemDumpExt)

--for i,v in ipairs(itemsForDump) do
--	print(v)
--end