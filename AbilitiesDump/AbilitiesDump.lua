local function AbilityDump_Get(morphs, skillType, skillIndex, abilityIndex, morphChoice)
	if morphs[morphChoice] == nil then
		morphs[morphChoice] = {}
	end

	local ability = morphs[morphChoice]
	local abilityId = GetSpecificSkillAbilityInfo(skillType, skillIndex, abilityIndex, morphChoice, 3)

	local channeled, castTime, channelTime = GetAbilityCastInfo(abilityId)
	local targetDescription = GetAbilityTargetDescription(abilityId)
	local minRangeCM, maxRangeCM = GetAbilityRange(abilityId, nil, "player")
	local radius = GetAbilityRadius(abilityId)
	local angleDistance = GetAbilityAngleDistance(abilityId)
	local isAbilityDurationToggled = IsAbilityDurationToggled(abilityId)
	local durationMs = GetAbilityDuration(abilityId)
	local cooldownMs = GetAbilityCooldown(abilityId)
	local cost = GetAbilityCost(abilityId, GetNextAbilityMechanicFlag(abilityId))
	local costMechanic = GetNextAbilityMechanicFlag(abilityId)
	local costDOT, chargeFrequencyMS = GetAbilityCostOverTime(abilityId, GetNextAbilityMechanicFlag(abilityId))
	local isTankRoleAbility, isHealerRoleAbility, isDamageRoleAbility = GetAbilityRoles(abilityId)

	local RuESO = RuEsoVariables["Default"]["@TERAB1T"]["$AccountWide"]["Data"]["Abilities"]

	if RuESO[abilityId] ~= nil then
		ability["nameEnglish"] = RuESO[abilityId]
	end

	ability["name"] = GetAbilityName(abilityId)
	ability["icon"] = GetAbilityIcon(abilityId)
	ability["description"] = GetAbilityDescription(abilityId)
	if GetAbilityDescriptionHeader(abilityId) ~= nil and GetAbilityDescriptionHeader(abilityId) ~= "" then
		ability["header"] = GetAbilityDescriptionHeader(abilityId)
	end
	ability["newEffect"] = GetAbilityNewEffectLines(abilityId)

	ability["channeled"] = channeled
	ability["castTime"] = castTime
	ability["channelTime"] = channelTime
	ability["targetDescription"] = targetDescription
	ability["minRangeCM"] = minRangeCM
	ability["maxRangeCM"] = maxRangeCM
	ability["radius"] = radius
	ability["angleDistance"] = angleDistance
	ability["isAbilityDurationToggled"] = isAbilityDurationToggled
	ability["durationMs"] = durationMs
	ability["cooldownMs"] = cooldownMs
	ability["cost"] = cost
	ability["costMechanic"] = costMechanic
	ability["costDOT"] = costDOT
	ability["chargeFrequencyMS"] = chargeFrequencyMS
	ability["isTankRoleAbility"] = isTankRoleAbility
	ability["isHealerRoleAbility"] = isHealerRoleAbility
	ability["isDamageRoleAbility"] = isDamageRoleAbility
end

local function AbilitiesDump()
	AbilitiesDump_SavedVariables = {}
	local numSkillTypes = GetNumSkillTypes()

	local RuESO = RuEsoVariables["Default"]["@TERAB1T"]["$AccountWide"]["Data"]["Abilities"]



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
					local numRanks = GetNumPassiveSkillRanks(i, j, k)

					for l = 1, numRanks do
						if morphs[l] == nil then
							morphs[l] = {}
						end

						local abilityId = GetSpecificSkillAbilityInfo(i, j, k, 0, l)

						morphs[l]["name"] = GetAbilityName(abilityId)
						morphs[l]["icon"] = GetAbilityIcon(abilityId)
						morphs[l]["description"] = GetAbilityDescription(abilityId)
						if GetAbilityDescriptionHeader(abilityId) ~= nil and GetAbilityDescriptionHeader(abilityId) ~= "" then
							morphs[l]["header"] = GetAbilityDescriptionHeader(abilityId)
						end

						if RuESO[abilityId] ~= nil then
							morphs[l]["nameEnglish"] = RuESO[abilityId]
						end
					end
				end
			end
		end
	end
end

EVENT_MANAGER:RegisterForEvent("AbilitiesDump", EVENT_PLAYER_ACTIVATED, AbilitiesDump)