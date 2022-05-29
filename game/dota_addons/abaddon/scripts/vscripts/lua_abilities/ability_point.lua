function AddAbilityPoint(keys)
	local caster = keys.caster

	caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)

	local ability = keys.ability
	local charges = ability:GetCurrentCharges() - 1
    if charges <= 0 then
        ability:RemoveSelf()
    else
        ability:SetCurrentCharges(charges)
    end
end