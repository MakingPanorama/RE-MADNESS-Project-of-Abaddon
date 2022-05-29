

function DemonPower( keys )

	local ability = keys.ability
	local caster = keys.caster
	local modifier = keys.modifier
	local pct_hp_per_stack = ability:GetSpecialValueFor( "pct_hp_per_stack" )
	local missing_health_pct = (1 - caster:GetHealth()/caster:GetMaxHealth())*100
	local stacks = missing_health_pct / pct_hp_per_stack

	caster:SetModifierStackCount(modifier, ability, stacks)
end
