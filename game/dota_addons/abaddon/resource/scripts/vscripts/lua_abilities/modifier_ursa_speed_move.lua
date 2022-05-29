modifier_ursa_speed_move = class({})

function modifier_ursa_speed_move:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
 
	return funcs
end

function modifier_ursa_speed_move:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_ursa_speed_move:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end


function modifier_ursa_speed_move:IsHidden()
	--print(self:GetStackCount())
	if self:GetStackCount() == 0 then
		return true
	end
	return false
end

function modifier_ursa_speed_move:OnCreated(event)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.bonus_all = 0
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_ursa_speed_move:IsPurgable()
	return false
end

function modifier_ursa_speed_move:RemoveOnDeath()
	return false
end

function modifier_ursa_speed_move:OnIntervalThink(event)
	if IsServer() and self:GetParent():IsAlive() then
		if self:GetParent():PassivesDisabled() then
			self:SetStackCount(0)
			return
		end
		local previous_bonus_all = self.bonus_all

		local units = FindUnitsInRadius(self:GetParent():GetTeam(), 
										self:GetParent():GetAbsOrigin(), 
										nil, self:GetAbility():GetSpecialValueFor("radius"), 
										DOTA_UNIT_TARGET_TEAM_BOTH, 
										DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
										FIND_ANY_ORDER, 
										false)

		self.bonus_all_per_unit = self:GetAbility():GetSpecialValueFor("bonus_speed_move")
		self.bonus_all = self.bonus_all_per_unit * (#units-1) -- отнимаем 1 чтобы исключить самого героя	

		self:SetStackCount(self.bonus_all)

		return 0.2
	end
end