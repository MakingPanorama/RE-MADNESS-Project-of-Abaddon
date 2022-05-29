function StillNeedStack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local need_stack = ability:GetSpecialValueFor( "need_stacks" )
	local max_attacks = ability:GetSpecialValueFor( "max_attack" )
	local modifierName = "modifier_4_attack_bonus"

	if caster:HasModifier( modifierName ) then
		local current_stack = caster:GetModifierStackCount( modifierName, ability)

		if current_stack < need_stack then
			caster:SetModifierStackCount( modifierName, ability, current_stack +1)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_1crit_lifesteal_bonus", { duration = -1 } )
			caster:RemoveModifierByName( modifierName )
		end
	end
end
function SpawnStacks( keys )
	local caster = keys.caster
	local ability = keys.ability
	local max_attacks = ability:GetSpecialValueFor( "max_attack" )

	caster:SetModifierStackCount(  "modifier_1crit_lifesteal_bonus", ability, max_attacks)

end

function DecreaseStack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local max_attacks = ability:GetSpecialValueFor( "max_attack" )
	local current_stack = caster:GetModifierStackCount( "modifier_1crit_lifesteal_bonus" , ability)

	if current_stack > 1 then
		caster:SetModifierStackCount( "modifier_1crit_lifesteal_bonus",ability, current_stack - 1)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_4_attack_bonus", { duration = -1 })
		caster:RemoveModifierByName( "modifier_1crit_lifesteal_bonus" )
	end
end
