function track (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local speed = ability:GetLevelSpecialValueFor("speed", ability:GetLevel() - 1)
    local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local info = 
    {
           Source = caster,
	       Ability = ability,	
	       EffectName = "particles/custom/fatal_dagger.vpcf",
           iMoveSpeed = speed,
	       vSourceLoc= caster:GetAbsOrigin(),                
	       bDrawsOnMinimap = false,                          
           bDodgeable = false,                                
           bIsAttack = false,                                
           bVisibleToEnemies = true,                        
           bReplaceExisting = false,                         
           flExpireTime = GameRules:GetGameTime() + 5.0,      -- Optional but recommended
	       bProvidesVision = true,                           
	       iVisionRadius = 650,                              
	       iVisionTeamNumber = caster:GetTeamNumber()  
    }
    for _,unit in ipairs(units) do
		info.Target = unit
        ProjectileManager:CreateTrackingProjectile(info)
	end
end

function damage (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1)
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local damagetable=
    {
        attacker = caster,
        victim = target,
        ability = ability,
        damage_type = ability:GetAbilityDamageType(),
        damage = base_damage
    }
    caster:PerformAttack(target, false, true, true, false, false, false, true) 
    ApplyDamage(damagetable)
    ability:ApplyDataDrivenModifier(caster, target, "fatal_dagger_debuff", { Duration = duration } )
end