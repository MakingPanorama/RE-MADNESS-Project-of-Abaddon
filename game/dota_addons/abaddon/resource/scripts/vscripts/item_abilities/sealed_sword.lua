function damage (keys)
    local ability = keys.ability
    local buff_chance = ability:GetLevelSpecialValueFor("buff_chance", (ability:GetLevel() - 1)) 
    local random = RandomInt(1, 100)
    if random <= buff_chance then
        local buff_pure_percent = ability:GetLevelSpecialValueFor("buff_pure_percent", (ability:GetLevel() - 1))
        local caster = keys.caster
        local target = keys.target
        local damage = caster:GetAttackDamage()
        damage = damage * buff_pure_percent / 100
        local damageTable = {
            attacker = caster,
            ability = ability,
            damage_type = DAMAGE_TYPE_PURE,
            damage = damage,
            victim = target
        }
        ApplyDamage(damageTable) 
        target:EmitSound(keys.sound_name)
        SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,target,damage,nil)
    end  
end