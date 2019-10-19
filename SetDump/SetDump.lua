local function SetDumpNames(  )
	--if addonName ~= "ItemDump" then
	--	return
	--end

	SetDump_SavedVariables = {}
	
	--ItemDump_SavedVariables["test"] = "test"
	
	for i,v in pairs(setsForDump) do
		local itemName = GetItemLinkName("|H1:item:" .. i ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		local hasSet, setName = GetItemLinkSetInfo("|H1:item:" .. i ..":3:1:0:0:0:0:0:0:0:0:0:0:0:17:0:0:1:1:0:0|h|h")
		
		if hasSet and not SetDumpNames_SavedVariables[itemName] then
			SetDumpNames_SavedVariables[itemName] = setName
		end
	end
end

EVENT_MANAGER:RegisterForEvent("SetDumpNames", EVENT_PLAYER_ACTIVATED, SetDumpNames)

--for i,v in ipairs(itemsForDump) do
--	print(v)
--end