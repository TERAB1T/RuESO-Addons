local function StolenDump()
	StolenDump_SavedVariables = {}

	local ssv = StolenDump_SavedVariables
	
	for i = 1, 300000 do
		local itemType = GetItemLinkItemType("|H1:item:" .. i .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
		
		if itemType == ITEMTYPE_TREASURE then

			local icon, sellPrice = GetItemLinkInfo("|H1:item:" .. i .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			local name = GetItemLinkName("|H1:item:" .. i .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			local displayQuality = GetItemLinkDisplayQuality("|H1:item:" .. i .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			local numItemTags = GetItemLinkNumItemTags("|H1:item:" .. i .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			
			if displayQuality < 5 and numItemTags and numItemTags > 0 then
				ssv[i] = {}
				ssv[i]["icon"] = icon
				ssv[i]["sellPrice"] = sellPrice
				ssv[i]["name"] = name
				ssv[i]["displayQuality"] = displayQuality
				
				if numItemTags and numItemTags > 0 then
					ssv[i]["tags"] = {}
					
					for j = 1, numItemTags do
						local tag = GetItemLinkItemTagInfo("|H1:item:" .. i .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", j)
						if tag and tag ~= "" then
							ssv[i]["tags"][j] = tag
						end
					end
				end
			end
		end
	end
	
	ReloadUI()
end

SLASH_COMMANDS["/stolendump"] = StolenDump