function duel (keys)
    local caster = keys.caster
	local caster_origin = caster:GetAbsOrigin()
	local target = keys.target
	local target_origin = target:GetAbsOrigin()
	local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local modifier = keys.modifier_name
    local sound = keys.sound_name
    local particle = keys.particle_name
	caster:EmitSound(sound)
    caster.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	local center_point = (caster_origin + target_origin) / 2
	ParticleManager:SetParticleControl(caster.particle, 0, center_point)  --The center position.
	ParticleManager:SetParticleControl(caster.particle, 7, center_point)  --The flag's position (also centered).
	local order_target = 
	{
		UnitIndex = target:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = caster:entindex()
	}
	local order_caster =
	{
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = target:entindex()
	}
	target:Stop()
	ExecuteOrderFromTable(order_target)
	ExecuteOrderFromTable(order_caster)
	caster:SetForceAttackTarget(target)
	target:SetForceAttackTarget(caster)
	ability:ApplyDataDrivenModifier(caster, caster, modifier, {Duration = duration})
	ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = duration})
    caster.opponent = target
end

function death (keys)
    local caster = keys.caster
	local caster_team = caster:GetTeam()
	local unit = keys.unit
	local ability = keys.ability
	local buff = keys.buff
    local sound = keys.sound_name
    local particle = keys.particle_name
    local modifier = keys.modifier_name
	if unit == caster.opponent then  
        ability:ApplyDataDrivenModifier(caster, caster, buff, {})
        local reward_damage = ability:GetLevelSpecialValueFor( "reward_damage", ability:GetLevel() - 1 )
        local stack = caster:GetModifierStackCount(buff, ability) + reward_damage
        caster:SetModifierStackCount(buff, ability, stack)
        caster:RemoveModifierByName(modifier)
        caster.opponent:RemoveModifierByName(modifier)
        caster:EmitSound(sound)
        local particleid = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
        local pos = caster:GetAbsOrigin()
        local victory_flag = Vector (pos.x, pos.y, pos.z + 400)
        ParticleManager:SetParticleControl(particleid, 3, victory_flag)
    end
end

function finish (keys)
    local caster = keys.caster
	local target = keys.target
	caster:StopSound(keys.sound_name)	
	if caster.particle ~= nil then
		ParticleManager:DestroyParticle(caster.particle, false)
	end
	target:SetForceAttackTarget(nil)
	caster:SetForceAttackTarget(nil)
end