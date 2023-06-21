local ssv

local function AchievDumpRu()
	ssv["data"] = {}
	local achievs = ssv["data"]
	
	--[[ for i = 1, GetNumAchievementCategories() do
		local nameCategory, numSubCategories, numAchievementsCategory = GetAchievementCategoryInfo(i)
		achievs[i] = {}
		achievs[i]["name"] = nameCategory
		achievs[i]["subcategories"] = {}
		
		for j = 0, numSubCategories do
			local nameSubCategory, numAchievementsSubcategory
			local subCategories = achievs[i]["subcategories"]
			
			if j == 0 then
				nameSubCategory = "Общее"
				numAchievementsSubcategory = numAchievementsCategory
			else				
				nameSubCategory, numAchievementsSubcategory = GetAchievementSubCategoryInfo(i, j)
			end
			
			subCategories[j] = {}
			subCategories[j]["name"] = nameSubCategory
			subCategories[j]["achievs"] = {}
			
			for k = 1, numAchievementsSubcategory do
				local achievementId
				local achievements = subCategories[j]["achievs"]
				
				if j == 0 then
					achievementId = GetAchievementId(i, nil, k)
				else				
					achievementId = GetAchievementId(i, j, k)
				end
				
				local nameAchiev, descriptionAchiev, _, iconAchiev = GetAchievementInfo(achievementId)
				
				achievements[k] = {}
				achievements[k]["id"] = achievementId
				achievements[k]["nameRu"] = nameAchiev
				achievements[k]["desc"] = descriptionAchiev
				achievements[k]["icon"] = iconAchiev
			end
		end
	end ]]
	
	for i = 1, 20000 do
		local nameAchiev, descriptionAchiev, _, iconAchiev = GetAchievementInfo(i)
		local topLevelIndex, categoryIndex = GetCategoryInfoFromAchievementId(i)
		local numCriteria = GetAchievementNumCriteria(i)
		local hasRewardOfTypeItem, itemName, iconTextureName, displayQuality = GetAchievementRewardItem(i)
		local hasRewardOfTypeTitle, titleName = GetAchievementRewardTitle(i)
		local hasRewardOfTypeDye, dyeId = GetAchievementRewardDye(i)
		local hasRewardOfTypeCollectible, collectibleId = GetAchievementRewardCollectible(i)
		
		if nameAchiev ~= nil and nameAchiev ~= "" then
			achievs[i] = {}
			achievs[i]["nameRu"] = nameAchiev
			achievs[i]["desc"] = descriptionAchiev
			achievs[i]["icon"] = iconAchiev
			achievs[i]["category"] = GetAchievementCategoryInfo(topLevelIndex)
			
			if categoryIndex ~= nil then
				achievs[i]["subategory"] = GetAchievementSubCategoryInfo(topLevelIndex, categoryIndex)
			else
				achievs[i]["subategory"] = "Общее"
			end
			
			if hasRewardOfTypeItem then
				achievs[i]["rewardItem"] = {}
				achievs[i]["rewardItem"]["name"] = itemName
				achievs[i]["rewardItem"]["icon"] = iconTextureName
				achievs[i]["rewardItem"]["quality"] = GetString("SI_ITEMDISPLAYQUALITY", displayQuality)
			end
			
			if hasRewardOfTypeTitle then
				achievs[i]["rewardTitle"] = titleName
			end
			
			if hasRewardOfTypeDye then
				local dyeName, _, _, _, _, r, g, b = GetDyeInfoById(dyeId)
				achievs[i]["rewardDye"] = {}
				achievs[i]["rewardDye"]["name"] = dyeName
				achievs[i]["rewardDye"]["r"] = zo_round(r * 255)
				achievs[i]["rewardDye"]["g"] = zo_round(g * 255)
				achievs[i]["rewardDye"]["b"] = zo_round(b * 255)
				achievs[i]["rewardDye"]["hex"] = string.format("%.2x%.2x%.2x", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255))
			end
			
			if hasRewardOfTypeCollectible then
				local nameCollect, _, iconCollect, _, _, _, _, categoryTypeCollect = GetCollectibleInfo(collectibleId)
			
				achievs[i]["rewardCollectible"] = {}
				achievs[i]["rewardCollectible"]["name"] = nameCollect
				achievs[i]["rewardCollectible"]["icon"] = iconCollect
				achievs[i]["rewardCollectible"]["category"] = GetString("SI_COLLECTIBLECATEGORYTYPE", categoryTypeCollect)
			end
			
			if numCriteria ~= 0 and numCriteria ~= 1 and numCriteria ~= nil then
				achievs[i]["criteria"] = {}
				
				for j = 1, numCriteria do
					achievs[i]["criteria"][j] = GetAchievementCriterion(i, j)
				end
			end
		end
	end
	
	ssv["enDump"] = true
	SetCVar("language.2", "en")
end

local function AchievDumpEn()
	local achievs = ssv["data"]
	
	for i = 1, 20000 do
		local nameAchiev, descriptionAchiev, _, iconAchiev = GetAchievementInfo(i)
		
		if nameAchiev ~= nil and nameAchiev ~= "" and achievs[i] then
			achievs[i]["nameEn"] = nameAchiev
		end
	end
	
	ssv["enDump"] = nil
	ssv["success"] = true
	SetCVar("language.2", "ru")
end

local function AchievCheck()

	if not AchievDump_SavedVariables then
		AchievDump_SavedVariables = {}
	end

	ssv = AchievDump_SavedVariables

	if GetCVar("language.2") == "en" and ssv["enDump"] ~= nil then
		AchievDumpEn()
	end
	
	if GetCVar("language.2") == "ru" and ssv["ruDump"] ~= nil then
		ssv["ruDump"] = nil
		AchievDumpRu()
	end
	
	if ssv["success"] ~= nil then
		d("Все достижения успешно собраны!")
		ssv["success"] = nil
	end
end

local function AchievDump()
	if GetCVar("language.2") == "ru" then
		AchievDumpRu()
	else
		ssv["ruDump"] = true
		SetCVar("language.2", "ru")
	end
end

EVENT_MANAGER:RegisterForEvent("AchievDump", EVENT_PLAYER_ACTIVATED, AchievCheck)

SLASH_COMMANDS["/achievdump"] = AchievDump