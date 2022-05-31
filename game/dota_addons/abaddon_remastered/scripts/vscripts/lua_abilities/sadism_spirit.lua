function effect (keys)
    local caster = keys.caster
    local particle = keys.particle_name
    local particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
    Timers:CreateTimer(keys.duration, function()
        ParticleManager:DestroyParticle(particle, false)
    end)
end

function inital (keys)
    local caster = keys.caster
    local ability = keys.ability
    local threshold = ability:GetLevelSpecialValueFor("threshold", (ability:GetLevel() - 1))
    if ability.store == nil then
        ability.store = 0
    end
    local point = math.floor(ability.store/threshold)
    ability:ApplyDataDrivenModifier( caster, caster, keys.buff, { } )
    caster:SetModifierStackCount( keys.buff, ability, point) 
end

function store (keys)
    local caster = keys.caster
    local ability = keys.ability
    local flag = ability:IsCooldownReady()
    if flag then
        local threshold = ability:GetLevelSpecialValueFor("threshold", (ability:GetLevel() - 1))
        ability.store = ability.store + keys.damage
        local point = math.floor(ability.store/threshold)
        caster:SetModifierStackCount( keys.buff, ability, point) 
    end
end

function release (keys)
    local caster = keys.caster
    local pos = caster:GetAbsOrigin()
    local ability = keys.ability
    local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
    ability.deal_damage = caster:GetModifierStackCount( keys.buff, ability ) * damage 
    if ability.deal_damage == 0 then
        caster:Stop()
        local player = caster:GetPlayerOwner()
        local message = { message = "No Points Now (Mana Wasted...)" }
        CustomGameEventManager:Send_ServerToPlayer(player, "Hud_Error_Message", message)  
    else
        ability.store = 0
        caster:SetModifierStackCount( keys.buff, ability, 0) 
        local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
        local projectile_info = 
        {
				EffectName = keys.particle_name,
				Ability = ability,
				vSpawnOrigin = pos,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = speed,
				bReplaceExisting = false,
				bProvidesVision = true
        }
        for _,unit in pairs(units) do
            projectile_info.Target = unit
            ProjectileManager:CreateTrackingProjectile(projectile_info)
	    end  
    end
end

function damage (keys)
    local ability = keys.ability
    local damage = ability.deal_damage
    local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local damage_table = {
        attacker = caster,
        victim = target,
        ability = ability,
        damage_type = ability:GetAbilityDamageType(),
        damage = damage   
    }
	ApplyDamage(damage_table)
end