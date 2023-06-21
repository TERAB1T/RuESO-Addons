local function iterate(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

local function CollectibleDumpExt()

	CollectibleDumpExt_SavedVariables = {}
	local marketProductDump = {}
	local collectDump = {}
	
	for i = 1, 10000 do
		
		local rewardName, rewardTypeText, cardFaceImage = GetMarketProductCrownCrateRewardInfo(i)
		rewardName = zo_strformat(SI_UNIT_NAME, rewardName)
		
		if cardFaceImage ~= "/esoui/art/icons/icon_missing.dds" then
			marketProductDump[rewardName] = cardFaceImage
		end
		
		local name, _, icon, _, _, _, _, categoryType, _ = GetCollectibleInfo(i)
		
		name = zo_strformat(SI_UNIT_NAME, name)
		
		if name ~= nil and name ~= "" then
			if not CollectibleDumpExt_SavedVariables[i] then
				CollectibleDumpExt_SavedVariables[i] = {}
			end
			
			collectDump[i] = name
			
			CollectibleDumpExt_SavedVariables[i]["icon"] = icon
			CollectibleDumpExt_SavedVariables[i]["categoryType"] = categoryType
		end


	end
	
	for i,v in pairs(CollectibleDumpExt_SavedVariables) do
		if marketProductDump[collectDump[i]] then
			CollectibleDumpExt_SavedVariables[i]["cardFaceImage"] = marketProductDump[collectDump[i]]
		else
			CollectibleDumpExt_SavedVariables[i]["cardFaceImage"] = ""
		end
	end
end

EVENT_MANAGER:RegisterForEvent("CollectibleDumpExt", EVENT_PLAYER_ACTIVATED, CollectibleDumpExt)