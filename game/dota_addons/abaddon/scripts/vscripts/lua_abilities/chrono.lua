function Chronotower( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_stun = keys.sound_stun
	local modifier_stun = keys.modifier_stun

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local stun_radius = ability:GetLevelSpecialValueFor("stun_radius", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_stun)

		-- Stun enemies
		for _,enemy in pairs(creeps) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end
