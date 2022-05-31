function StillNeedStack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local need_stack = ability:GetSpecialValueFor( "need_stacks" )
	local max_attacks = ability:GetSpecialValueFor( "max_attack" )
	local modifierName = "modifier_passive_attack_damage_count"

	if caster:HasModifier( modifierName ) then
		local current_stack = caster:GetModifierStackCount( modifierName, ability)

		if current_stack < need_stack then
			caster:SetModifierStackCount( modifierName, ability, current_stack +1)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_reduction_dmg_bonus", { duration = -1 } )
			caster:RemoveModifierByName( modifierName )
		end
	end
end
function SpawnStacks( keys )
	local caster = keys.caster
	local ability = keys.ability
	local max_attacks = ability:GetSpecialValueFor( "max_attack" )

	caster:SetModifierStackCount(  "modifier_reduction_dmg_bonus", ability, max_attacks)

end

function DecreaseStack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local max_attacks = ability:GetSpecialValueFor( "max_attack" )
	local current_stack = caster:GetModifierStackCount( "modifier_reduction_dmg_bonus" , ability)

	if current_stack > 1 then
		caster:SetModifierStackCount( "modifier_reduction_dmg_bonus",ability, current_stack - 1)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_passive_attack_damage_count", { duration = -1 })
		caster:RemoveModifierByName( "modifier_reduction_dmg_bonus" )
	end
end
