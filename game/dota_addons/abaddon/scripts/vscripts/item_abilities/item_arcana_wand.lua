function damage (keys)
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local extra_magic_damage = ability:GetLevelSpecialValueFor("extra_magic_damage", (ability:GetLevel() - 1)) 
    local damageTable = {
        attacker = caster,
        ability = ability,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage = extra_magic_damage,
        victim = target
    }
    ApplyDamage(damageTable)
    SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_POISON_DAMAGE,target,extra_magic_damage,nil)
end