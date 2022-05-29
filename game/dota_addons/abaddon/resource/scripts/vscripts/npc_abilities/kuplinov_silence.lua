--[My First Lua Expirience]
function SpendResources(keys)
	local caster = keys.caster
	local ability = keys.ability
	-- Spend Resources[Cooldown and Manacost]
	if caster:IsIllusion() == false then
		ability:UseResources(true,true,true)
	end	
end
	
function SilenceCooldown(keys)
	local caster = keys.caster
	local ability = keys.ability
	local dur = inf
	if ability:GetCooldownTimeRemaining() == 0 and caster:IsSilenced() == false and caster:IsHexed() == false and caster:IsIllusion() == false then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_kuplinov_silence_seeker", { duration = dur})
	end
end
