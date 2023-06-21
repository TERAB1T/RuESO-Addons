local function magicReplace(str, what, with)
    what = zo_strgsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    with = zo_strgsub(with, "[%%]", "%%%%")
    return zo_strgsub(str, what, with)
end

local function tableContains(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end

local byte    = string.byte
local char    = string.char
local dump    = string.dump
local find    = string.find
local format  = string.format
local gmatch  = string.gmatch
local gsub    = string.gsub
local len     = string.len
local lower   = string.lower
local match   = string.match
local rep     = string.rep
local reverse = string.reverse
local sub     = string.sub
local upper   = string.upper

-- returns the number of bytes used by the UTF-8 character at byte i in s
-- also doubles as a UTF-8 character validator
local function utf8charbytes (s, i)
	-- argument defaults
	i = i or 1

	-- argument checking
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8charbytes' (string expected, got ".. type(s).. ")")
	end
	if type(i) ~= "number" then
		error("bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")")
	end

	local c = byte(s, i)

	-- determine bytes needed for character, based on RFC 3629
	-- validate byte 1
	if c > 0 and c <= 127 then
		-- UTF8-1
		return 1

	elseif c >= 194 and c <= 223 then
		-- UTF8-2
		local c2 = byte(s, i + 1)

		if not c2 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		return 2

	elseif c >= 224 and c <= 239 then
		-- UTF8-3
		local c2 = byte(s, i + 1)
		local c3 = byte(s, i + 2)

		if not c2 or not c3 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c == 224 and (c2 < 160 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 237 and (c2 < 128 or c2 > 159) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		return 3

	elseif c >= 240 and c <= 244 then
		-- UTF8-4
		local c2 = byte(s, i + 1)
		local c3 = byte(s, i + 2)
		local c4 = byte(s, i + 3)

		if not c2 or not c3 or not c4 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c == 240 and (c2 < 144 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 244 and (c2 < 128 or c2 > 143) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end
		
		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 4
		if c4 < 128 or c4 > 191 then
			error("Invalid UTF-8 character")
		end

		return 4

	else
		error("Invalid UTF-8 character")
	end
end

-- returns the number of characters in a UTF-8 string
local function utf8len (s)
	-- argument checking
	if type(s) ~= "string" then
		for k,v in pairs(s) do print('"',tostring(k),'"',tostring(v),'"') end
		error("bad argument #1 to 'utf8len' (string expected, got ".. type(s).. ")")
	end

	local pos = 1
	local bytes = len(s)
	local len = 0

	while pos <= bytes do
		len = len + 1
		pos = pos + utf8charbytes(s, pos)
	end

	return len
end

-- functions identically to string.sub except that i and j are UTF-8 characters
-- instead of bytes
local function utf8sub (s, i, j)
	-- argument defaults
	j = j or -1

	local pos = 1
	local bytes = len(s)
	local len = 0

	-- only set l if i or j is negative
	local l = (i >= 0 and j >= 0) or utf8len(s)
	local startChar = (i >= 0) and i or l + i + 1
	local endChar   = (j >= 0) and j or l + j + 1

	-- can't have start before end!
	if startChar > endChar then
		return ""
	end

	-- byte offsets to pass to string.sub
	local startByte,endByte = 1,bytes
	
	while pos <= bytes do
		len = len + 1

		if len == startChar then
			startByte = pos
		end

		pos = pos + utf8charbytes(s, pos)

		if len == endChar then
			endByte = pos - 1
			break
		end
	end
	
	if startChar > len then startByte = bytes+1   end
	if endChar   < 1   then endByte   = 0         end
	
	return sub(s, startByte, endByte)
end

local function BooksDumpAntiqs()
	BooksDump_SavedVariables[100] = {}
	local bsv = BooksDump_SavedVariables[100]
	bsv["sets"] = {}
	bsv["antiqs"] = {}	
	
	for i = 1, 1000 do
		local setId = GetAntiquitySetId(i)
		local antiqName = GetAntiquityName(i)
		local numAntiquities = GetNumAntiquitySetAntiquities(i)
		local rewardId = GetAntiquitySetRewardId(i)
		
		if numAntiquities and numAntiquities > 0 and GetAntiquitySetIcon(i) ~= "/esoui/art/icons/icon_missing.dds" then
			bsv["sets"][i] = {}
			bsv["sets"][i]["name"] = GetAntiquitySetName(i)
			bsv["sets"][i]["flavor"] = ""
			bsv["sets"][i]["icon"] = GetAntiquitySetIcon(i)
			bsv["sets"][i]["parts"] = {}
			for j = 1, numAntiquities do
				bsv["sets"][i]["parts"][j] = {}
				bsv["sets"][i]["parts"][j]["id"] = GetAntiquitySetAntiquityId(i, j)
				bsv["sets"][i]["parts"][j]["name"] = GetAntiquityName(GetAntiquitySetAntiquityId(i, j))
				bsv["sets"][i]["parts"][j]["icon"] = GetAntiquityIcon(GetAntiquitySetAntiquityId(i, j))
			end
			
			if GetRewardType(rewardId) == REWARD_ENTRY_TYPE_COLLECTIBLE then
				local rewardCollectibleId = GetCollectibleRewardCollectibleId(rewardId)
				local collectibleDescription = GetCollectibleDescription(rewardCollectibleId)
				
				if collectibleDescription then
					bsv["sets"][i]["flavor"] = collectibleDescription
				end
				
			elseif GetRewardType(rewardId) == REWARD_ENTRY_TYPE_ITEM then
				local rewardItemLink = GetItemRewardItemLink(rewardId)
				local itemDescription = GetItemLinkFlavorText(rewardItemLink)
				
				if itemDescription then
					bsv["sets"][i]["flavor"] = itemDescription
				end
			end
		end
	end
	
	for i = 1, 10000 do
		local setId = GetAntiquitySetId(i)
		local antiqName = GetAntiquityName(i)
		local rewardId = GetAntiquityRewardId(i)
		
		if setId == 0 and antiqName and antiqName ~= "" and GetAntiquityIcon(i) ~= "/esoui/art/icons/icon_missing.dds" then
			bsv["antiqs"][i] = {}
			bsv["antiqs"][i]["name"] = antiqName
			bsv["antiqs"][i]["icon"] = GetAntiquityIcon(i)
			bsv["antiqs"][i]["flavor"] = ""
			
			if GetRewardType(rewardId) == REWARD_ENTRY_TYPE_COLLECTIBLE then
				local rewardCollectibleId = GetCollectibleRewardCollectibleId(rewardId)
				local collectibleDescription = GetCollectibleDescription(rewardCollectibleId)
				
				if collectibleDescription then
					bsv["antiqs"][i]["flavor"] = collectibleDescription
				end
				
			elseif GetRewardType(rewardId) == REWARD_ENTRY_TYPE_ITEM then
				local rewardItemLink = GetItemRewardItemLink(rewardId)
				local itemDescription = GetItemLinkFlavorText(rewardItemLink)
				
				if itemDescription then
					bsv["antiqs"][i]["flavor"] = itemDescription
				end
			end
		end
	end
end

local function BooksDump()
	BooksDump_SavedVariables = {}
	local numLoreCategories = GetNumLoreCategories()
	local hasVariables = {69, 129, 438, 451, 466, 496, 498, 593, 594, 598, 664, 665, 666, 720, 757, 758, 947, 949, 950, 951, 963, 965, 966, 987, 988, 1064, 1065, 1066, 1068, 1069, 1070, 1097, 1193, 1194, 1195, 1196, 1197, 1200, 1226, 1227, 1228, 1261, 1320, 1324, 1349, 1364, 1367, 1368, 1385, 1402, 1404, 1412, 1461, 1462, 1516, 1559, 1560, 1564, 1565, 1566, 1567, 1572, 1576, 1577, 1578, 1579, 1580, 1581, 1584, 1585, 1586, 1589, 1597, 1607, 1626, 1627, 1628, 1739, 1740, 1741, 1750, 1758, 1786, 1794, 1795, 1796, 1797, 1799, 1807, 1830, 1831, 1837, 1843, 1878, 1914, 1917, 1918, 1924, 1928, 1946, 1947, 1981, 1999, 2000, 2001, 2010, 2024, 2040, 2044, 2068, 2076, 2081, 2089, 2102, 2105, 2121, 2146, 2150, 2151, 2152, 2159, 2162, 2247, 2539, 2548, 2551, 2552, 2553, 2554, 2556, 2620, 2631, 2632, 2701, 2703, 2747, 2834, 2836, 2931, 2979, 2999, 3047, 3053, 3061, 3084, 3138, 3157, 3158, 3159, 3163, 3223, 3224, 3231, 3239, 3243, 3248, 3258, 3260, 3282, 3283, 3319, 3420, 3434, 3435, 3436, 3437, 3438, 3439, 3440, 3443, 3446, 3447, 3535, 3589, 3590, 3702, 3704, 3970, 4065, 4435, 4576, 4806, 4893, 4896, 4923, 5173, 5190, 5193, 5196, 5404, 5435, 5697, 5704, 5708, 6110, 6113, 6114, 6115}
	
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
			
			if collectionName ~= "" and collectionName ~= nil then
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
					local bookText = ReadLoreBook(i, k, l)
					
					if collectionData[bookId] == nil then
						collectionData[bookId] = {}
						collectionData[bookId]["name"] = bookTitle
						collectionData[bookId]["icon"] = bookIcon
						
						if tableContains(hasVariables, bookId) then
							local bookTextUpdated = magicReplace(bookText, ZO_CachedStrFormat("<<1>>", GetUnitName("player")), "<em><Имя персонажа игрока></em>")
							
							if bookTextUpdated and bookTextUpdated ~= "" then
								collectionData[bookId]["text"] = {}
								
								while utf8len(bookTextUpdated) > 1000 do
									table.insert(collectionData[bookId]["text"], utf8sub(bookTextUpdated, 0, 1000))
									bookTextUpdated = utf8sub(bookTextUpdated, 1001)
								end
								table.insert(collectionData[bookId]["text"], bookTextUpdated)
							end
						end
					end
				end
			end
		end
	end
	
	BooksDumpAntiqs()
end

SLASH_COMMANDS["/booksdump"] = BooksDump