function projectile (keys)
    local caster = keys.caster
	local ability = keys.ability
    local projectile_distance = ability:GetLevelSpecialValueFor("projectile_distance", (ability:GetLevel() - 1))
    local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", (ability:GetLevel() - 1))
    local projectile_width = ability:GetLevelSpecialValueFor("projectile_width", (ability:GetLevel() - 1)) 
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1)) 
    local info={     
            Ability = ability,
            EffectName = keys.particle_name,
            vSpawnOrigin = caster:GetAbsOrigin(),
            fDistance = projectile_distance,
            fStartRadius = projectile_width,
            fEndRadius = projectile_width,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = ability:GetAbilityTargetTeam(),
            iUnitTargetFlags = ability:GetAbilityTargetFlags(),
            iUnitTargetType = ability:GetAbilityTargetType(),
		    bDeleteOnHit = false,
		    vVelocity = caster:GetForwardVector() * projectile_speed,
		    bProvidesVision = true,
		    iVisionRadius = 600,
		    iVisionTeamNumber = caster:GetTeamNumber()
        }
    local projectiles=ProjectileManager:CreateLinearProjectile(info)
    local modifier_name = keys.modifier_name
    if caster:HasModifier( modifier_name )then
        local current_stack = caster:GetModifierStackCount( modifier_name, ability )     
        ability:ApplyDataDrivenModifier( caster, caster, modifier_name, { Duration = duration } )
        caster:SetModifierStackCount( modifier_name, ability, current_stack + 1 )
    else  
        ability:ApplyDataDrivenModifier( caster, caster, modifier_name, { Duration = duration } )
        caster:SetModifierStackCount( modifier_name, ability, 1 ) 
    end
end


function damage (keys)
    local caster = keys.caster
    local target = keys.target
	local ability = keys.ability
    local base_damage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))
    local bonus_Int_percent = ability:GetLevelSpecialValueFor("bonus_Int_percent", (ability:GetLevel() - 1))
    local bonus_percent_per_buff = ability:GetLevelSpecialValueFor("bonus_percent_per_buff", (ability:GetLevel() - 1))
    local modifier_name = keys.modifier_name
    local stackcount = caster:GetModifierStackCount( modifier_name, ability ) 
    local damage = base_damage + ( caster:GetIntellect() * bonus_Int_percent / 100 )
    local coefficient = stackcount * (bonus_percent_per_buff/100)
    damage = damage * (1+coefficient)
    local damageTable = {}
    damageTable.attacker = caster
    damageTable.ability = ability
    damageTable.victim = target
    damageTable.damage_type = ability:GetAbilityDamageType()
    damageTable.damage = damage
    ApplyDamage(damageTable)   
end