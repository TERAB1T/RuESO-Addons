local ssv

local function SetsDumpRu()
	ssv["data"] = {}
	local sets = ssv["data"]
	
	for i = 1, 300000 do
		local hasSet, setName, numBonuses, _, _, setId = GetItemLinkSetInfo("|H1:item:" .. i .. ":364:50:0:0:0:0:0:0:0:0:0:0:0:0:8:0:0:0:10000:0|h|h")
		
		if hasSet and not sets[setId] then
			sets[setId] = {}
			sets[setId]["nameRu"] = setName
			sets[setId]["bonuses"] = {}
			
			for j = 1, numBonuses do
				local numRequired, bonusDescription = GetItemLinkSetBonusInfo("|H1:item:" .. i .. ":364:50:0:0:0:0:0:0:0:0:0:0:0:0:8:0:0:0:10000:0|h|h", true, j)
				sets[setId]["bonuses"][j] = bonusDescription
			end
		end
	end
	
	ssv["enDump"] = true
	SetCVar("language.2", "en")
end

local function SetsDumpEn()
	local sets = ssv["data"]
	
	for i = 1, 300000 do
		local hasSet, setName, _, _, _, setId = GetItemLinkSetInfo("|H1:item:" .. i .. ":364:50:0:0:0:0:0:0:0:0:0:0:0:0:8:0:0:0:10000:0|h|h")
		
		if hasSet and sets[setId] then
			sets[setId]["nameEn"] = setName
		end
	end
	
	ssv["enDump"] = nil
	ssv["success"] = true
	SetCVar("language.2", "ru")
end

local function SetsCheck()

	if not SetsDump_SavedVariables then
		SetsDump_SavedVariables = {}
	end

	ssv = SetsDump_SavedVariables

	if GetCVar("language.2") == "en" and ssv["enDump"] ~= nil then
		SetsDumpEn()
	end
	
	if GetCVar("language.2") == "ru" and ssv["ruDump"] ~= nil then
		ssv["ruDump"] = nil
		SetsDumpRu()
	end
	
	if ssv["success"] ~= nil then
		d("Все наборы успешно собраны!")
		ssv["success"] = nil
	end
end

local function SetsDump()
	if GetCVar("language.2") == "ru" then
		SetsDumpRu()
	else
		ssv["ruDump"] = true
		SetCVar("language.2", "ru")
	end
end

EVENT_MANAGER:RegisterForEvent("SetsDump", EVENT_PLAYER_ACTIVATED, SetsCheck)

SLASH_COMMANDS["/setsdump"] = SetsDump