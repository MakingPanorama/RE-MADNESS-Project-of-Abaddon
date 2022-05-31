function PercentDamage(keys)
	local ability = keys.ability
	local target = keys.target
	local damage = keys.Damage or 0
	if ability then
		if keys.MaxHealthPercent then damage = damage + (keys.MaxHealthPercent*0.01*target:GetMaxHealth()) end
		if keys.CurrnetHealthPercent then damage = damage + (keys.CurrnetHealthPercent*0.01*target:GetHealth()) end
		if keys.multiplier then damage = damage * keys.multiplier end
		ApplyDamage({
			victim = target,
			attacker = keys.caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = keys.CalculateSpellDamageTooltip == 0 and DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION or DOTA_DAMAGE_FLAG_NONE,
			ability = ability
		})
	end
end