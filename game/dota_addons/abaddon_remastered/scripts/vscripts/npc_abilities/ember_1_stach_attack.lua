function StillNeedStack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local need_stack = ability:GetSpecialValueFor( "need_stacks" )
	local duration = ability:GetSpecialValueFor( "duration" )
	local modifierName = "modifier_on_attack_run_stack"

	if caster:HasModifier( modifierName ) then
		local current_stack = caster:GetModifierStackCount( modifierName, ability)

		if current_stack < need_stack then
			caster:SetModifierStackCount( modifierName, ability, current_stack +1)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_xunjiliehuo_applier", { duration = duration } )
			caster:RemoveModifierByName( modifierName )
		end
	end
end