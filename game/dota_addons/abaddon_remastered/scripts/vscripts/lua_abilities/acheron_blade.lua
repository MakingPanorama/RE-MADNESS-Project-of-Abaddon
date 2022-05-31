function Fire(keys)
    local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetCooldown(ability:GetLevel()-1)
	if ability:IsCooldownReady() then
		ability.cooldown_flag = 1
		EmitSoundOn(keys.sound, caster)
		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, caster) 
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	    Timers:CreateTimer(3,function()
            ParticleManager:DestroyParticle(particle,false) 
        end
        )
    end
end


function Impact(keys)
    local caster = keys.caster
    local target = keys.target
	local ability = keys.ability
    local debuff = keys.debuff
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1)
    local bonus_percentage = ability:GetLevelSpecialValueFor("bonus_percentage", ability:GetLevel() - 1)
    local cooldown = ability:GetCooldown(ability:GetLevel()-1)
    if ability.cooldown_flag == 1 then
        ability:StartCooldown(cooldown)
        ability:ApplyDataDrivenModifier(caster, target, debuff, {Duration = duration})
        local damage = base_damage + ( target:GetHealth() * bonus_percentage / 100 )
        local damage_table={
            attacker = caster,
            victim = target,
            ability = ability,
            damage = damage,
            damage_type = ability:GetAbilityDamageType() 
        }
        ApplyDamage(damage_table)
        ability.cooldown_flag = 0
        SendOverheadEventMessage(nil,OVERHEAD_ALERT_BLOCK,target,damage,nil)
    end

end



