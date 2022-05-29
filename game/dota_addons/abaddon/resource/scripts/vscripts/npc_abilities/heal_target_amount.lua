function PinkBlossomThink(keys)
	local caster = keys.caster
	local ability = keys.ability
    local heal_pct = ability:GetLevelSpecialValueFor("heal_pct", ability:GetLevel() - 1)
	local allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, ability:GetLevelSpecialValueFor("heal_range", ability:GetLevel() - 1), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
   else
	for i = 1, ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel() - 1) do
		if allies[i] then
			local amount =    allies *(0.01* heal_pct )
			SafeHeal(allies[i], amount, caster)
			ParticleManager:CreateParticle("particles/neutral_fx/troll_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, allies[i])
			SendOverheadEventMessage(allies[i]:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, allies[i], amount, caster:GetPlayerOwner())
		end
	end
end