modifier_venomancer_poison_sting_passive = class({})

function modifier_venomancer_poison_sting_passive:IsHidden()
	return false
end

function modifier_venomancer_poison_sting_passive:IsPurgable()
	return false
end

function modifier_venomancer_poison_sting_passive:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_venomancer_poison_sting_passive:OnCreated()
end

function modifier_venomancer_poison_sting_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			local attacker = params.attacker
			local target = params.target
			
			local ability = self:GetAbility()

			local chance = ability:GetSpecialValueFor('chance')
			local max_stacks = ability:GetSpecialValueFor('max_stacks')
			local duration = ability:GetSpecialValueFor("duration")
			if RollPercentage(chance) then
				target:AddNewModifier(attacker,ability,"modifier_venomancer_poison_sting_debuff",{Duration = duration, StackCount = stack})
				local stack = target:GetModifierStackCount("modifier_venomancer_poison_sting_debuff",attacker) + 1
				if stack < max_stacks then
					target:SetModifierStackCount("modifier_venomancer_poison_sting_debuff",attacker,stack)
				end
			end
		end
	end
end

