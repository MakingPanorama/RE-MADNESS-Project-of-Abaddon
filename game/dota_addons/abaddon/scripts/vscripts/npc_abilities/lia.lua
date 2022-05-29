function BuffStackIncrement(params)
	local caster = params.caster
	local ability = params.ability
	local modifier_buff = params.modifier_buff
	local previous_stack_count = 0
		if caster:HasModifier(modifier_buff) then
			previous_stack_count = caster:GetModifierStackCount(modifier_buff, nil)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			caster:RemoveModifierByName(modifier_buff)
		end
		ability:ApplyDataDrivenModifier(caster, caster, modifier_buff, nil)
		caster:SetModifierStackCount(modifier_buff, nil, previous_stack_count + 1)

end

function BuffStackOnDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier_buff

	if caster:HasModifier(modifier) then
		local previous_stack_count = caster:GetModifierStackCount(modifier, nil)
		if previous_stack_count > 1 then
			caster:SetModifierStackCount(modifier, nil, previous_stack_count - 1)
		else
			caster:RemoveModifierByName(modifier)
		end
	end
end

function DebuffStackIncrement(params)
	local caster = params.caster
	local target = params.target
	local ability = params.ability
	local modifier = params.modifier_debuff
	local previous_stack_count = 0
	
		if target:HasModifier(modifier) then
			previous_stack_count = target:GetModifierStackCount(modifier, nil)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			target:RemoveModifierByName(modifier)
		end
		ability:ApplyDataDrivenModifier(caster, target, modifier, nil)
		target:SetModifierStackCount(modifier, nil, previous_stack_count + 1)

end

function DebuffStackOnDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier_debuff

	if target:HasModifier(modifier) then
		local previous_stack_count = target:GetModifierStackCount(modifier, nil)
--		print("stack count = "..previous_stack_count)
		if previous_stack_count > 1 then
			target:SetModifierStackCount(modifier, nil, previous_stack_count - 1)
		else
			target:RemoveModifierByName(modifier)
		end
	end
end