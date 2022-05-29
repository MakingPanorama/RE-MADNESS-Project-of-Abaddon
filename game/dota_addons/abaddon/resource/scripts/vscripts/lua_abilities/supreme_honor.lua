function TakenDamage (keys)
	local target = keys.unit
    local flag1 = keys.attacker == target
    local flag2 = target:IsHero()
    if (not flag1) or (flag2) then
        local caster = keys.caster
        local ability = keys.ability
        local damage = keys.damage
        local heal_percent = ability:GetLevelSpecialValueFor("heal_percent", (ability:GetLevel() - 1))
        local heal = damage * ( 1 + heal_percent / 100 )
        target:Heal(heal,caster)
    end
end