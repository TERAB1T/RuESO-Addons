local function iterate(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

local function CrateDump()

	CrateDump_SavedVariables = {}
	local collectibleDump = {}
	
	for i = 1, 20000 do
		
		local rewardName, rewardTypeText, cardFaceImage, cardFaceFrameAccentImage, stackCount = GetMarketProductCrownCrateRewardInfo(i)
		rewardName = zo_strformat(SI_UNIT_NAME, rewardName)
		
		if cardFaceImage ~= "/esoui/art/icons/icon_missing.dds" then
			if not CrateDump_SavedVariables[rewardName] then
				CrateDump_SavedVariables[rewardName] = {}
			end
			
			CrateDump_SavedVariables[rewardName]["rewardTypeText"] = rewardTypeText
			CrateDump_SavedVariables[rewardName]["cardFaceImage"] = cardFaceImage
			CrateDump_SavedVariables[rewardName]["cardFaceFrameAccentImage"] = cardFaceFrameAccentImage
			
			if stackCount and stackCount > 1 then
				CrateDump_SavedVariables[rewardName]["count"] = stackCount
			end
		end
		
		local name, description, icon = GetCollectibleInfo(i)
		
		name = zo_strformat(SI_UNIT_NAME, name)
		
		if name ~= nil and name ~= "" then
			if not collectibleDump[name] then
				collectibleDump[name] = {}
			end
			
			collectibleDump[name]["description"] = description
			collectibleDump[name]["icon"] = icon
		end
		
		
	end
	
	for i,v in pairs(CrateDump_SavedVariables) do
		if collectibleDump[i] then
			CrateDump_SavedVariables[i]["description"] = collectibleDump[i]["description"]
			CrateDump_SavedVariables[i]["icon"] = collectibleDump[i]["icon"]
		end
	end
	
	for i = 1, 300000 do
		local contLink = string.format("|H1:item:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", i)
		local itemName = GetItemLinkName(contLink)
		
		if itemName and itemName ~= "" and not string.match(itemName, "_") then
			itemName = zo_strformat(SI_UNIT_NAME, itemName)
			if CrateDump_SavedVariables[itemName] and not CrateDump_SavedVariables[itemName]["description"] then
				local itemIcon = GetItemLinkIcon(contLink)
				local itemFlavor = GetItemLinkFlavorText(contLink)
				local hasAbility, _, abilityDescription, cooldown = GetItemLinkOnUseAbilityInfo(contLink)
				
				CrateDump_SavedVariables[itemName]["icon"] = itemIcon
				
				if itemFlavor ~= nil and itemFlavor ~= "" then
					CrateDump_SavedVariables[itemName]["flavor"] = itemFlavor
				end
				
				if hasAbility then
					CrateDump_SavedVariables[itemName]["description"] = abilityDescription
					
					if cooldown > 0 then
						CrateDump_SavedVariables[itemName]["cooldown"] = cooldown/100
					end
				end
			end
		end
	end
end

EVENT_MANAGER:RegisterForEvent("CrateDump", EVENT_PLAYER_ACTIVATED, CrateDump)