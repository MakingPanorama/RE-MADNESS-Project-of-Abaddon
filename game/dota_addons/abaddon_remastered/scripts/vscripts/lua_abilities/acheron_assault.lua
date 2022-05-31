function StunCheck (keys)
    local attacker = keys.attacker
    local ability = keys.ability
    local chance = ability:GetLevelSpecialValueFor("stun_chance", (ability:GetLevel() - 1))
    local random = RandomInt(1, 100)
    if random < chance and not attacker:IsMagicImmune() then
        local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
        ability:ApplyDataDrivenModifier(keys.caster, attacker, keys.modifier_name, { Duration = stun_duration })     
        attacker:EmitSound(keys.sound_name)
    end  
end