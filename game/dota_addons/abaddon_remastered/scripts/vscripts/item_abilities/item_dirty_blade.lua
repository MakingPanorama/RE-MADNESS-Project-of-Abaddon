function stun (keys)
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local chance = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel() - 1)) 
    local random = RandomInt(1, 100)
    if random <= chance and caster:IsRealHero() then
        local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1)) 
        ability:ApplyDataDrivenModifier( caster, target, keys.debuff, { Duration = stun_duration } )
        target:EmitSound(keys.sound_name)
        local extra_dmg = ability:GetLevelSpecialValueFor("extra_dmg", (ability:GetLevel() - 1)) 
        local dmg_table = {
            attacker = caster,
            victim = target,
            damage = extra_dmg,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = ability
        }
        ApplyDamage(dmg_table)
        SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_POISON_DAMAGE,target,extra_dmg,nil)
    end
end