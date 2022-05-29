

function PUTAbility( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	print("SPELLBOOK")
	print(keys)
	if IsValidEntity(caster) and not caster:HasAbility("boosted_reap_midas") then
		caster:AddAbility("boosted_reap_midas")
		caster:FindAbilityByName("boosted_reap_midas"):SetLevel(1)
		caster:RemoveAbility("dat")
    end
end	
