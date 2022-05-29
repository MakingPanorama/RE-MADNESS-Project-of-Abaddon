--[My First Lua Expirience]
function DealDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	caster:PerformAttack(target, true, true, true, true, false, false, false)
end

