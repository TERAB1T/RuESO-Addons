local function AbilityDump_Get(morphs, skillType, skillIndex, abilityIndex, morphChoice)
	if morphs[morphChoice] == nil then
		morphs[morphChoice] = {}
	end
	
	local ability = morphs[morphChoice]
	local abilityId = GetSpecificSkillAbilityInfo(skillType, skillIndex, abilityIndex, morphChoice, 3)
	
	ability["name"] = GetAbilityName(abilityId)
	ability["icon"] = GetAbilityIcon(abilityId)
	ability["description"] = GetAbilityDescription(abilityId)
	ability["newEffect"] = GetAbilityNewEffectLines(abilityId)
end

local function AbilitiesDump()
	AbilitiesDump_SavedVariables = {}
	local numSkillTypes = GetNumSkillTypes()
	
	for i = 1, numSkillTypes do
		local numSkillLines = GetNumSkillLines(i)
		
		if AbilitiesDump_SavedVariables[i] == nil then
			AbilitiesDump_SavedVariables[i] = {}
			AbilitiesDump_SavedVariables[i]["skills"] = {}
		end
		
		local skills = AbilitiesDump_SavedVariables[i]["skills"]
		
		for j = 1, numSkillLines do
			local skillLineName, _, _, skillLineId = GetSkillLineInfo(i, j)
			local numSkillAbilities = GetNumSkillAbilities(i, j)
			
			if skills[skillLineId] == nil then
				skills[skillLineId] = {}
				skills[skillLineId]["name"] = skillLineName
				skills[skillLineId]["abilities"] = {}
			end
			
			local abilities = skills[skillLineId]["abilities"]
			
			for k = 1, numSkillAbilities do
				local _, _, _, passive, ultimate = GetSkillAbilityInfo(i, j, k)
				
				if abilities[k] == nil then
					abilities[k] = {}
					abilities[k]["passive"] = passive
					abilities[k]["ultimate"] = ultimate
					abilities[k]["morphs"] = {}
				end
				
				local morphs = abilities[k]["morphs"]
				
				if passive == false then
					AbilityDump_Get(morphs, i, j, k, 0)
					AbilityDump_Get(morphs, i, j, k, 1)
					AbilityDump_Get(morphs, i, j, k, 2)
				else
					if morphs[0] == nil then
						morphs[0] = {}
					end
					
					local abilityId = GetSkillAbilityId(i, j, k)
	
					morphs[0]["name"] = GetAbilityName(abilityId)
					morphs[0]["icon"] = GetAbilityIcon(abilityId)
					morphs[0]["description"] = GetAbilityDescription(abilityId)
				end
			end
		end
	end
end

EVENT_MANAGER:RegisterForEvent("AbilitiesDump", EVENT_PLAYER_ACTIVATED, AbilitiesDump)