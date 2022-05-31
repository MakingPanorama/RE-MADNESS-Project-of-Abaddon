--[[Give ability to hero via book
	Author: Tetravortex
	Date: 08.08.2018.
	]]

function AbilityCheck( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	print("SPELLBOOK")
	print(keys)
	if IsValidEntity(caster) and not caster:HasAbility("creature_spawn_undying_minion") then
		caster:AddAbility("creature_spawn_undying_minion")
		caster:FindAbilityByName("creature_spawn_undying_minion"):SetLevel(1)
	end
end