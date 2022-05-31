function blade_array(keys)
    local caster = keys.caster
	local ability = keys.ability
    local width = ability:GetLevelSpecialValueFor("width", (ability:GetLevel() - 1))
    local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
    local distance = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1)) 
    local point = caster:GetCursorPosition()
    local projectiles={}
    local info={}
    local numberOfProjectiles = 10
    for i=0,numberOfProjectiles-1 do
        local angle = 35*i
        info[i]={     
            Ability = ability,
            EffectName = keys.particle_name,
            vSpawnOrigin = ability:GetCursorPosition(),
            fDistance = distance,
            fStartRadius = width,
            fEndRadius = width,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = ability:GetAbilityTargetTeam(),
            iUnitTargetFlags = ability:GetAbilityTargetFlags(),
            iUnitTargetType = ability:GetAbilityTargetType(),
		    bDeleteOnHit = false,
		    vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), caster:GetForwardVector()) * speed,
		    bProvidesVision = true,
		    iVisionRadius = 600,
		    iVisionTeamNumber = caster:GetTeamNumber()
        }
    end
    for i=0,numberOfProjectiles-1 do
        projectiles[i]=ProjectileManager:CreateLinearProjectile(info[i])
    end
end

function blade_array_damage(keys)
    local target = keys.target
    if not target:HasModifier( "blade_array_debuff" ) then
        local ability = keys.ability
        local caster = keys.caster
        local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
        ability:ApplyDataDrivenModifier( caster, target, "blade_array_debuff", { Duration = duration } )
        local base_damage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))
	    local bonus_coefficient = ability:GetLevelSpecialValueFor("bonus_coefficient", (ability:GetLevel() - 1))   
        local total_damage=base_damage + ( bonus_coefficient * caster:GetMaxHealth() / 100 )
        local damageTable = {}
        damageTable.attacker = caster
        damageTable.ability = ability
        damageTable.victim = target
        damageTable.damage_type = ability:GetAbilityDamageType()
        damageTable.damage = total_damage
        ApplyDamage(damageTable) 
    end
end