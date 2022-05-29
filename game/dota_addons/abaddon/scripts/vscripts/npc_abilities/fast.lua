function CastHasteSpell(keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("creep_ability_fast")
	if ability and caster:IsAlive() then
		caster:AddNewModifier(caster,ability,"creep_haste_modifier",{duration=ability:GetSpecialValueFor("duration")})
		ability:ApplyDataDrivenModifier(caster,caster,"creep_haste_delay",{duration=ability:GetSpecialValueFor("duration")})
	end
end

