local function BooksDump(  )
	BooksDump_SavedVariables = {}
	local numLoreCategories = GetNumLoreCategories()
	
	for i = 1, numLoreCategories do
		local categoryName, numCollections, categoryId = GetLoreCategoryInfo(i)
		
		if BooksDump_SavedVariables[categoryId] == nil then
			BooksDump_SavedVariables[categoryId] = {}
			BooksDump_SavedVariables[categoryId]["name"] = categoryName
			BooksDump_SavedVariables[categoryId]["data"] = {}
		end
		
		local categoryData = BooksDump_SavedVariables[categoryId]["data"]
		
		for k = 1, numCollections do
			local collectionName, collectionDescription, _, totalBooks, _, collectionIcon, collectionId = GetLoreCollectionInfo(i, k)
			
			if categoryData[collectionId] == nil then
				categoryData[collectionId] = {}
				categoryData[collectionId]["name"] = collectionName
				categoryData[collectionId]["description"] = collectionDescription
				categoryData[collectionId]["icon"] = collectionIcon
				categoryData[collectionId]["data"] = {}
			end
			
			local collectionData = categoryData[collectionId]["data"]
		
			for l = 1, totalBooks do
				local bookTitle, bookIcon, _, bookId = GetLoreBookInfo(i, k, l)
				
				if collectionData[bookId] == nil then
					collectionData[bookId] = {}
					collectionData[bookId]["name"] = bookTitle
					collectionData[bookId]["icon"] = bookIcon
				end
			end
		end
	end
end

EVENT_MANAGER:RegisterForEvent("BooksDump", EVENT_PLAYER_ACTIVATED, BooksDump)