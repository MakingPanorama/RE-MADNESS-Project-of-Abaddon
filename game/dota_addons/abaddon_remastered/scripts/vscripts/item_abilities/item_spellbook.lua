local imbaAbilityFirstAppearTime = 24 * 60

local courierSpecialRate = 25

local abilityWeightMap = {
	pangolier_swashbuckle = {10, 2, 2, 2},
	lina_fiery_soul = {10, 2, 2, 2},
	phantom_assassin_coup_de_grace = {60, 55, 50, 45},
	obsidian_destroyer_arcane_orb = {95, 95, 95, 95},
	slardar_bash = {98, 95, 95, 95},
	bloodseeker_thirst = {98, 95, 95, 95},
	alchemist_goblins_greed = {90, 85, 80, 75},
	elder_titan_natural_order = {90, 85, 80, 75},
	-- huskar_life_break = {90, 85, 80, 75},
	huskar_inner_fire = {90, 85, 80, 75},
	pangolier_lucky_shot = {90, 85, 80, 75},
	faceless_void_time_lock = {98, 95, 95, 95},
	dazzle_bad_juju = {98, 95, 95, 95},
	-- drow_ranger_marksmanship = {60, 50, 45, 40},
	oracle_false_promise = {40, 35, 30, 25}, -- 虚妄之诺
	abaddon_frostmourne = {30, 20, 10, 5},
	doom_bringer_infernal_blade = {30, 20, 10, 5},
	queenofpain_blink = {20, 10, 10, 5},
	antimage_blink = {20, 10, 10, 5},
	lion_voodoo = {10, 2, 2, 2},
	shadow_shaman_voodoo = {10, 2, 2, 2},
	lion_finger_of_death = {20, 10, 10, 5},
	centaur_return = {10, 2, 2, 2},
	spectre_dispersion = {10, 2, 2, 2},
	rubick_arcane_supremacy = {10, 2, 2, 2},
}

local function getImbaAbilityReplaceChance(abilityName)
	local specialWeight = abilityWeightMap[abilityName] or {}
	local imbaAbilityReplacePercentage = specialWeight[1] or 75
	if GameRules.nCountDownTimer < 13 * 60 then imbaAbilityReplacePercentage = specialWeight[2] or 70 end
	if GameRules.nCountDownTimer < 9 * 60 then imbaAbilityReplacePercentage = specialWeight[3] or 55 end
	if GameRules.nCountDownTimer < 5 * 60 then imbaAbilityReplacePercentage = specialWeight[4] or 50 end
	return imbaAbilityReplacePercentage
end

function OnAddUltimate(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
	local ability = keys.ability

	if not caster:HasAbility("empty_a6") then
		msg.bottom("#hud_error_only_one_ultimate", caster:GetPlayerID())
		return
	end

	local randomAbilities = table.random_some(GameRules.vUltimateAbilitiesPool, 3)

	if not GameRules.bFreeModeActivated == true then
		print("free mode is not activated, spell will be replaced")
		for k, ability in pairs(randomAbilities) do
			if table.contains(GameRules.vCourierAbilities_Ultimate, ability) then
				local imbaAbilityReplacePercentage = getImbaAbilityReplaceChance(ability)
				if RollPercentage(imbaAbilityReplacePercentage)
					or GameRules.nCountDownTimer > imbaAbilityFirstAppearTime
					then
					local randomAbility = table.random(GameRules.vUltimateAbilitiesPool)
					while (table.contains(randomAbilities, randomAbility) 
						or table.contains(GameRules.vCourierAbilities_Ultimate, randomAbility))
						do
						randomAbility = table.random(GameRules.vUltimateAbilitiesPool)
					end
					randomAbilities[k] = randomAbility
				end
			end
		end
	end

	-- 避免被没点的初始技能覆盖了
	caster.__playerHaveSelectedAbility__ = true

	GameRules.vSpellbookRecorder = GameRules.vSpellbookRecorder or {}
	local id = "spell_book_" .. DoUniqueString('')
	GameRules.vSpellbookRecorder[id] = randomAbilities

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "show_ability_selector",{
        ID = id,
        Abilities = randomAbilities,
        Type = "ultimate",
    })

    local charges = ability:GetCurrentCharges() - 1
	if charges <= 0 then
		ability:RemoveSelf()
	else
		ability:SetCurrentCharges(charges)
	end

	caster.__nNumUltimateBook__ = caster.__nNumUltimateBook__ or 0
	caster.__nNumUltimateBook__ = caster.__nNumUltimateBook__ + 1
end

function OnAddNormal(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
	local ability = keys.ability
	if not (
		caster:HasAbility("empty_a1") 
		or caster:HasAbility("empty_a2") 
		or caster:HasAbility("empty_a3")
		or (caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT and caster:HasAbility("empty_a4"))
		) then
		msg.bottom("#hud_error_ability_is_full", caster:GetPlayerID())
		return
	end

	local randomAbilities = table.random_some(GameRules.vNormalAbilitiesPool, 3)
	
	if not GameRules.bFreeModeActivated == true then
		for k, ability in pairs(randomAbilities) do
			if table.contains(GameRules.vCourierAbilities_Normal, ability) then
				local imbaAbilityReplacePercentage = getImbaAbilityReplaceChance(ability)
				if RollPercentage(imbaAbilityReplacePercentage) 
					or GameRules.nCountDownTimer > imbaAbilityFirstAppearTime
					then
					local randomAbility = table.random(GameRules.vNormalAbilitiesPool)
					while (table.contains(randomAbilities, randomAbility) 
						or table.contains(GameRules.vCourierAbilities_Normal, randomAbility))
						do
						randomAbility = table.random(GameRules.vNormalAbilitiesPool)
					end
					randomAbilities[k] = randomAbility
				end
			end
		end
	end

	-- 避免被没点的初始技能覆盖了
	caster.__playerHaveSelectedAbility__ = true

	GameRules.vSpellbookRecorder = GameRules.vSpellbookRecorder or {}
	local id = "spell_book_" .. DoUniqueString('')
	GameRules.vSpellbookRecorder[id] = randomAbilities

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()),"show_ability_selector",{
        ID = id,
        Abilities = randomAbilities,
        Type = "normal",
    })

    local charges = ability:GetCurrentCharges() - 1
	if charges <= 0 then
		ability:RemoveSelf()
	else
		ability:SetCurrentCharges(charges)
	end

	caster.__nNumNormalBook__ = caster.__nNumNormalBook__ or 0
	caster.__nNumNormalBook__ = caster.__nNumNormalBook__ + 1
end

function OnAddNormal_Courier(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
	local ability = keys.ability
	if not (
		caster:HasAbility("empty_a1") 
		or caster:HasAbility("empty_a2") 
		or caster:HasAbility("empty_a3")
		or (caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT and caster:HasAbility("empty_a4"))
		) then
		msg.bottom("#hud_error_ability_is_full", caster:GetPlayerID())
		return
	end

	local randomAbilities = table.random_some(GameRules.vNormalAbilitiesPool, 3)
	
	-- 如果没有包含有附加的特殊技能，那么有大概率给一个
	local didntHave = true
	for k, ability in pairs(randomAbilities) do
		if table.contains(GameRules.vCourierAbilities_Normal, ability) then
			didntHave = false
			break
		end
	end
	if didntHave then
		if RollPercentage(courierSpecialRate) then
			local ability = table.random(GameRules.vCourierAbilities_Normal)
			randomAbilities[RandomInt(1,3)] = ability
		end
	end

	-- 避免被没点的初始技能覆盖了
	caster.__playerHaveSelectedAbility__ = true

	GameRules.vSpellbookRecorder = GameRules.vSpellbookRecorder or {}
	local id = "spell_book_" .. DoUniqueString('')
	GameRules.vSpellbookRecorder[id] = randomAbilities

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()),"show_ability_selector",{
        ID = id,
        Abilities = randomAbilities,
        Type = "normal",
    })

    local charges = ability:GetCurrentCharges() - 1
	if charges <= 0 then
		ability:RemoveSelf()
	else
		ability:SetCurrentCharges(charges)
	end

	caster.__nNumNormalBook__ = caster.__nNumNormalBook__ or 0
	caster.__nNumNormalBook__ = caster.__nNumNormalBook__ + 1
end

function OnAddUltimate_Courier(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
	local ability = keys.ability

	if not caster:HasAbility("empty_a6") then
		msg.bottom("#hud_error_only_one_ultimate", caster:GetPlayerID())
		return
	end

	local randomAbilities = table.random_some(GameRules.vUltimateAbilitiesPool, 3)
	
	-- 如果没有包含有附加的特殊技能，那么有大概率给一个
	local didntHave = true
	for k, ability in pairs(randomAbilities) do
		if table.contains(GameRules.vCourierAbilities_Ultimate, ability) then
			didntHave = false
			break
			
		end
	end
	if didntHave then
		if RollPercentage(courierSpecialRate) then
			local ability = table.random(GameRules.vCourierAbilities_Ultimate)
			randomAbilities[RandomInt(1,3)] = ability
		end
	end

	-- 避免被没点的初始技能覆盖了
	caster.__playerHaveSelectedAbility__ = true

	GameRules.vSpellbookRecorder = GameRules.vSpellbookRecorder or {}
	local id = "spell_book_" .. DoUniqueString('')
	GameRules.vSpellbookRecorder[id] = randomAbilities

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()),"show_ability_selector",{
        ID = id,
        Abilities = randomAbilities,
        Type = "ultimate",
    })

    local charges = ability:GetCurrentCharges() - 1
	if charges <= 0 then
		ability:RemoveSelf()
	else
		ability:SetCurrentCharges(charges)
	end

	caster.__nNumUltimateBook__ = caster.__nNumUltimateBook__ or 0
	caster.__nNumUltimateBook__ = caster.__nNumUltimateBook__ + 1
end