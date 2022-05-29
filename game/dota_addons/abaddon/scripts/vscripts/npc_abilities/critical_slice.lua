--[My First Lua Expirience]
function SpendResources(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:IsIllusion() == false then
		ability:UseResources(true,true,true)
	end
end

function CheckCooldown(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = "modifier_critical_slice"
	local dur = inf
	if ability:IsCooldownReady() == true and caster:IsIllusion() == false then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = dur})
	end
end