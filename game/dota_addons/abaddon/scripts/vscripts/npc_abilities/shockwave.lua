function CourageMoment( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local cooldown = caster:GetBaseAttackTime()
	local chance = ability:GetSpecialValueFor("chance") + (100 - caster:GetHealthPercent()) * 0.4
	if HasExclusive(caster,4) then
		cooldown = cooldown * 0.5
	end
	local unitCount = #FindUnitsInRadius(teamNumber, caster_location, caster, 400, targetTeam, targetType, targetFlag, 0, false)
	chance = chance + unitCount
	if RollPercentage(chance) and ability:IsCooldownReady() then
		if caster:HasModifier("modifier_queen_curse") then
			cooldown = 0.5
			if HasExclusive(caster,4) then
				cooldown = cooldown * 0.5
			end
		end
		ability:StartCooldown(cooldown)
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_courage_moment_buff",nil)
	end
end
function CourageMomentHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = keys.DamageTaken
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()
	local refresh_chance = ability:GetSpecialValueFor("refresh_chance")
	local distance = 500
	if caster:HasModifier("modifier_war_god") then
		distance = 1000
		refresh_chance = refresh_chance * 2
	end
	local unitCount = #FindUnitsInRadius(teamNumber, caster_location, caster, 400, targetTeam, targetType, targetFlag, 0, false)
	refresh_chance = refresh_chance + unitCount
	if RollPercentage(refresh_chance) and not ability:IsCooldownReady() then
		ability:EndCooldown()
    	ability:ApplyDataDrivenModifier(caster,caster,"modifier_courage_moment_buff",nil)
    end	
	local startTime = GameRules:GetGameTime()
    local endTime = startTime + 1
    projVelocity = (target_location - caster_location):Normalized() * 1000
	local projID = ProjectileManager:CreateLinearProjectile( {
			Ability			 	= ability,
			EffectName		  	= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
			vSpawnOrigin		= caster_location,
			fDistance		   	= distance,
			fStartRadius		= 200,
			fEndRadius		  	= 200,
			Source			  	= caster,
			bHasFrontalCone	 	= false,
			bReplaceExisting	= false,
			iUnitTargetTeam	 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime		 	= endTime,
			bDeleteOnHit		= false,
			vVelocity		   	= projVelocity,
			bProvidesVision	 	= true,
			iVisionRadius	   	= 200,
			iVisionTeamNumber   = caster:GetTeamNumber(),
		} )
	Timers:CreateTimer(5,function (  )
        ProjectileManager:DestroyLinearProjectile(projID)
    end)
end
function CourageMomentDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("base_damage")
	if caster:HasModifier("modifier_war_god") then
		damage = damage * 2
	end
	local heal = keys.heal * 0.01 * damage
	local damageType = ability:GetAbilityDamageType()
	Heal( caster, heal)
	CauseDamage(caster, target, damage, damageType, ability)
end
function AbilityCoolDownSetting( keys )
	local ability = keys.ability
	ability.cooldown_reduce = false
end