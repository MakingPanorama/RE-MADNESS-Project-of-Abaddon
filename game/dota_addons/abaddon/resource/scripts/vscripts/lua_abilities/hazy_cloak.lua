function TakenDamage(event)
    local damage = event.damage
	local caster = event.caster
	local ability = event.ability
    local heal_chance = ability:GetLevelSpecialValueFor("heal_chance", ability:GetLevel() - 1)
    local random = RandomFloat(1, 100)
    if random <= heal_chance then
        caster:Heal(damage, caster)
        ability:ApplyDataDrivenModifier( caster, caster, "hazy_cloak_heal_buff", { duration = 0.5 })
    end       
end