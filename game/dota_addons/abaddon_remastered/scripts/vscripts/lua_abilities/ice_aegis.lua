function frost (keys)  
    local ability = keys.ability
    local attacker = keys.attacker
    local chance = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel() - 1))
    local random = RandomInt(1, 100)
    if random < chance and attacker:IsAncient() == false and attacker:IsMagicImmune() == false then
        local caster = keys.caster
        local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
        local frost_duration = ability:GetLevelSpecialValueFor("frost_duration", (ability:GetLevel() - 1))
        local debuff = keys.debuff
        local sound = keys.sound_name
        ability:ApplyDataDrivenModifier( caster, attacker, debuff, {Duration = frost_duration} )
        attacker:EmitSound(sound)
        local damage_table={
            attacker = caster,
	        ability = ability,
	        damage_type = ability:GetAbilityDamageType(),
            damage = damage,
            victim = attacker
        } 
        ApplyDamage(damage_table)     
    end
end