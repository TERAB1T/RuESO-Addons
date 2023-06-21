local function FurnitureDump()
	
	FurnitureDump_SavedVariables = {}
	
	for i = 1, 300000 do
		
		local itemType, specItemType = GetItemLinkItemType("|H1:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
		
		if itemType == ITEMTYPE_FURNISHING then
			if not FurnitureDump_SavedVariables[i] then
				FurnitureDump_SavedVariables[i] = {}
			end
			
			local furnitureDataId = GetItemLinkFurnitureDataId("|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			
			FurnitureDump_SavedVariables[i]["icon"] = GetItemLinkIcon("|H1:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			FurnitureDump_SavedVariables[i]["link"] = "|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
			FurnitureDump_SavedVariables[i]["quality"] = GetItemLinkQuality("|H1:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			FurnitureDump_SavedVariables[i]["categoryId"], FurnitureDump_SavedVariables[i]["subcategoryId"], FurnitureDump_SavedVariables[i]["furnitureTheme"] = GetFurnitureDataInfo(furnitureDataId)
		end

		
		if specItemType == SPECIALIZED_ITEMTYPE_RECIPE_BLACKSMITHING_DIAGRAM_FURNISHING or specItemType == SPECIALIZED_ITEMTYPE_RECIPE_CLOTHIER_PATTERN_FURNISHING or specItemType == SPECIALIZED_ITEMTYPE_RECIPE_ENCHANTING_SCHEMATIC_FURNISHING or specItemType == SPECIALIZED_ITEMTYPE_RECIPE_ALCHEMY_FORMULA_FURNISHING or specItemType == SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_DESIGN_FURNISHING or specItemType == SPECIALIZED_ITEMTYPE_RECIPE_WOODWORKING_BLUEPRINT_FURNISHING or specItemType == SPECIALIZED_ITEMTYPE_RECIPE_JEWELRYCRAFTING_SKETCH_FURNISHING then
			local recipeListIndex, recipeIndex = GetItemLinkGrantedRecipeIndices("|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			local _, _, _, resultId = ZO_LinkHandler_ParseLink(GetItemLinkRecipeResultItemLink("|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"))
			local numIngredients = GetItemLinkRecipeNumIngredients("|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
			
			if resultId ~= nil then
				resultId = tonumber(resultId)
				
				if not FurnitureDump_SavedVariables[resultId] then
					FurnitureDump_SavedVariables[resultId] = {}
				end
				
				FurnitureDump_SavedVariables[resultId]["recipe"] = {}
				FurnitureDump_SavedVariables[resultId]["recipe"]["id"] = i
				FurnitureDump_SavedVariables[resultId]["recipe"]["link"] = "|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
				FurnitureDump_SavedVariables[resultId]["recipe"]["icon"] = GetItemLinkIcon("|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
				FurnitureDump_SavedVariables[resultId]["recipe"]["ingredients"] = {}
				
				for j=1,numIngredients,1 do 
					local _, _, amountRequired = GetItemLinkRecipeIngredientInfo("|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", j)
					local _, _, _, ingredientId = ZO_LinkHandler_ParseLink(GetItemLinkRecipeIngredientItemLink("|H0:item:" .. i .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", j))
				
					FurnitureDump_SavedVariables[resultId]["recipe"]["ingredients"][j] = {}
					FurnitureDump_SavedVariables[resultId]["recipe"]["ingredients"][j]["amountRequired"] = amountRequired
					FurnitureDump_SavedVariables[resultId]["recipe"]["ingredients"][j]["id"] = tonumber(ingredientId)
				end
			end
		end
	end
	d("Завершено. Перезагрузите интерфейс, чтобы сохранить собранные данные.")
end

SLASH_COMMANDS["/furndump"] = FurnitureDump