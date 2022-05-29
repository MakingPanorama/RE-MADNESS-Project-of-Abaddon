function OnAbilitiesUp( keys )
	local caster = keys.caster

	if not caster:FindAbilityByName(caster.ab2) then
		caster.ab2 = "techies_explosive_barrel_detonate"
	end

	if not caster:FindAbilityByName(caster.ab3) then
		caster.ab3 = "grappling_hook_blink"
	end

	if not caster:FindAbilityByName(caster.ab4) then
		caster.ab4 = "earthshaker_totem_fissure"
	end

	caster:SwapAbilities("pudge_wars_custom_hook", "pudge_wars_upgrade_hook_damage", false, true)
	caster:SwapAbilities(caster.ab2, "pudge_wars_upgrade_hook_range", false, true)
	caster:SwapAbilities(caster.ab3, "pudge_wars_upgrade_hook_speed", false, true)
	caster:SwapAbilities(caster.ab4, "pudge_wars_upgrade_hook_size", false, true)
	caster:SwapAbilities("pudge_wars_abilities_up", "pudge_wars_abilities_down", false, true)
end

function OnAbilitiesDown( keys )
	local caster = keys.caster

	caster:SwapAbilities("pudge_wars_custom_hook", "pudge_wars_upgrade_hook_damage", true, false)
	caster:SwapAbilities(caster.ab2, "pudge_wars_upgrade_hook_range", true, false)
	caster:SwapAbilities(caster.ab3, "pudge_wars_upgrade_hook_speed", true, false)
	caster:SwapAbilities(caster.ab4, "pudge_wars_upgrade_hook_size", true, false)
	caster:SwapAbilities("pudge_wars_abilities_up", "pudge_wars_abilities_down", true, false)
end