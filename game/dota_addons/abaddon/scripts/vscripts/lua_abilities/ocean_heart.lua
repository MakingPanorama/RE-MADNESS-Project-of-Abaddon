function damage (keys)
    local attacker = keys.attacker
    local unit = keys.unit
    local damage_taken = keys.damage
    local ability = keys.ability
    local percentage = ability:GetLevelSpecialValueFor( "percentage", ability:GetLevel() - 1 )
    local reflect_damage = percentage * damage_taken / 100
    local damage_table=
    {
        attacker = unit,
        victim = attacker,
        ability = ability,
        damage = reflect_damage,
        damage_type = ability:GetAbilityDamageType()
    }
    ApplyDamage(damage_table)
    unit:SetHealth(unit:GetHealth() + reflect_damage)
end