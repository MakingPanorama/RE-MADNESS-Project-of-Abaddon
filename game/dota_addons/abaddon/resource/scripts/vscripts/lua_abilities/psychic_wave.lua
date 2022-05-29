function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local startpoint = caster:GetAbsOrigin()
    local direction = (caster:GetCursorPosition() - startpoint):Normalized()
    local distance = ability:GetLevelSpecialValueFor("projectile_distance", ability:GetLevel() - 1)
    local speed = ability:GetLevelSpecialValueFor("projectile_speed", ability:GetLevel() - 1)
    local radius_start = ability:GetLevelSpecialValueFor("radius_start", ability:GetLevel() - 1)
    local radius_end = ability:GetLevelSpecialValueFor("radius_end", ability:GetLevel() - 1)
    local info = {     
        Ability = ability,
        EffectName = keys.projectile_name,
        vSpawnOrigin = startpoint,
        fDistance = distance,
        fStartRadius = radius_start,
        fEndRadius = radius_end,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        bDeleteOnHit = false,
        vVelocity = direction * speed,
        bProvidesVision = true,
        iVisionRadius = 450,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    local projectile_id=ProjectileManager:CreateLinearProjectile(info)
end

function damage ( keys )
    local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))
    local bonus_damage_coefficient = ability:GetLevelSpecialValueFor("bonus_damage_coefficient", (ability:GetLevel() - 1))
    local damage = base_damage + (caster:GetAgility() * bonus_damage_coefficient)
    local damageTable = {
        attacker = caster,
        ability = ability,
        victim = target,
        damage_type = ability:GetAbilityDamageType(),
        damage = damage  
    }
    ApplyDamage(damageTable)
    local stun_duration=ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
    local reduce_duration=ability:GetLevelSpecialValueFor("armor_reduce_duration", (ability:GetLevel() - 1))
    ability:ApplyDataDrivenModifier( caster, target, "trauma_psychic", { Duration = reduce_duration } )
    ability:ApplyDataDrivenModifier( caster, target, "psychic_shock", { Duration = stun_duration } )
end