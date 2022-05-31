function reduce (keys)
    local target = keys.attacker
    local caster = keys.caster
    if caster:IsRealHero() then
        local ability = keys.ability
        local damage = keys.damage
        local reflect_percent = ability:GetLevelSpecialValueFor("reflect_percent", (ability:GetLevel() - 1)) 
        local reflect = damage * reflect_percent / 100
        if caster:GetHealth() > damage then
            caster:Heal(reflect,caster)
        end
        local damageTable = {
            attacker = caster,
            ability = ability,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage = reflect,
            victim = target
        }
        ApplyDamage(damageTable) 
    end
end