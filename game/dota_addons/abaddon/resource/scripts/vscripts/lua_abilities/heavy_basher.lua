function stun (keys)
    local ability = keys.ability;
    local chance = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel() - 1))
    local random = RandomInt(1, 100)
    if random <= chance then
        local caster = keys.caster
        local target = keys.target
        local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
        local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
        local bonus_duration = ability:GetLevelSpecialValueFor("bonus_duration", (ability:GetLevel() - 1))
        ability:ApplyDataDrivenModifier( caster, target, "Heavy_Basher_Debuff", { Duration = stun_duration } )
        ability:ApplyDataDrivenModifier( caster, caster, "Heavy_Basher_Buff", { Duration = bonus_duration } )
        local damage_table =
        {
            victim   = target,
	        attacker = caster,
            ability = ability,
	        damage = damage,
	        damage_type = ability:GetAbilityDamageType(),
        }
        ApplyDamage(damage_table)
        SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_POISON_DAMAGE,target,damage,nil)
    end
end