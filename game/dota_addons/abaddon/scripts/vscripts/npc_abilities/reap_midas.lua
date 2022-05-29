function AddGold(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local gold = keys.ability:GetLevelSpecialValueFor( "gold", keys.ability:GetLevel() - 1 )
	if(not attacker:IsIllusion()) then
		PlayerResource:ModifyGold(attacker:GetPlayerOwnerID(), gold, false, 1)
	end
end