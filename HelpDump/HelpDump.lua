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

local function HelpDump()

	HelpDump_SavedVariables = {}
	local sv = HelpDump_SavedVariables
	
	local numHelpCategories = GetNumHelpCategories()
	
	for i = 1, numHelpCategories do
		
		sv[i] = {}
		
		local nameCategory, descriptionCategory, upIconCategory = GetHelpCategoryInfo(i)
		
		sv[i]["name"] = nameCategory
		sv[i]["description"] = descriptionCategory
		sv[i]["icon"] = upIconCategory
		sv[i]["subcategories"] = {}
		
		local svs = sv[i]["subcategories"]
		local numHelpEntries = GetNumHelpEntriesWithinCategory(i)
		
		for j = 1, numHelpEntries do
			svs[j] = {}
			
			local name, description, description2, image = GetHelpInfo(i, j)
			
			svs[j]["name"] = name
			
			svs[j]["description"] = {}
			while utf8len(description) > 1000 do
				table.insert(svs[j]["description"], utf8sub(description, 0, 1000))
				description = utf8sub(description, 1001)
			end
			table.insert(svs[j]["description"], description)
			
			svs[j]["description2"] = {}
			while utf8len(description2) > 1000 do
				table.insert(svs[j]["description2"], utf8sub(description2, 0, 1000))
				description2 = utf8sub(description2, 1001)
			end
			table.insert(svs[j]["description2"], description2)
			
			svs[j]["image"] = image
		end
	end
end

EVENT_MANAGER:RegisterForEvent("HelpDump", EVENT_PLAYER_ACTIVATED, HelpDump)