modifier_huskar_poison_milk = class({})

function modifier_huskar_poison_milk:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_huskar_poison_milk:IsPurgable()
	return false
end

function modifier_huskar_poison_milk:IsHidden()
	return true
end

function modifier_huskar_poison_milk:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_huskar_poison_milk:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			local target = params.target
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			local chance = self:GetAbility():GetSpecialValueFor("chance")
			if RollPercentage(chance) then
				if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
					target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_huskar_poison_milk_buff",{Duration = duration})
				end
			end

			if not self:GetParent():HasModifier("modifier_huskar_poison_milk_buff") then
				self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_huskar_poison_milk_buff",{})
			end
		end
	end
end