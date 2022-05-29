--[My First Lua Expirience] HARD!!!
function DealDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local attacker = keys.attacker
	caster:PerformAttack(target, true, true, true, true, false, false, true)

end

