LinkLuaModifier("modifier_deep_water", "lua_abilities/ocean_guardian.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deep_water_aura", "lua_abilities/ocean_guardian.lua", LUA_MODIFIER_MOTION_NONE)
deep_water = class({})

function deep_water:OnSpellStart()
	self.duration = self:GetSpecialValueFor("duration")
	self.damage = self:GetSpecialValueFor("damage")
	self.radius = self:GetSpecialValueFor("radius")


	-- This line create a dummy on location
	CreateModifierThinker(self:GetCaster(), self, "modifier_deep_water", { duration = self.duration * 2 }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL,
		0,
		0,
		false
	)
	-- Do something...
	for _,unit in pairs(units) do
		-- just stun
		unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self.duration })


		-- Deal damage
		ApplyDamage({
			victim = unit,
			attacker = self:GetCaster(),
			ability = self,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_PHYSICAL
		})
	end

	EmitSoundOn("Hero_Slardar.Slithereen_Crush", self:GetCaster())
end

modifier_deep_water = class({})

function modifier_deep_water:OnCreated()
	-- Create puddle
	local water = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_water_puddle.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	ParticleManager:SetParticleControl(water, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(water, 1, Vector(self.radius,self.radius,0))
	ParticleManager:SetParticleControl(water, 2, Vector(self.radius,self.radius,0))
	self:AddParticle(water, false, false, -1, false, false)
	EmitSoundOn("n_mud_golem.Boulder.Cast", self:GetParent())
end

function modifier_deep_water:OnDestroy()
	self:GetParent():RemoveSelf()
end

function modifier_deep_water:IsAura() 					return true end
function modifier_deep_water:GetAuraRadius()			return self.radius end
function modifier_deep_water:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_deep_water:GetAuraSearchType()		return DOTA_UNIT_TARGET_ALL end
function modifier_deep_water:GetAuraDuration() 			return 0.1 end
function modifier_deep_water:GetModifierAura()			return "modifier_deep_water_aura" end

modifier_deep_water_aura = class({})

function modifier_deep_water_aura:IsHidden() return true end
function modifier_deep_water_aura:DeclareFunctions() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_deep_water_aura:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * ( -1 ) -- Returns negative number
end
function modifier_deep_water_aura:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	end
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed") * ( -1 ) -- Returns negative number
end
function modifier_deep_water_aura:GetModifierPhysicalArmorBonusIllusions()	
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
	return self:GetAbility():GetSpecialValueFor("bonus_armor") * ( -1 ) -- Returns negative number
end

function modifier_deep_water_aura:GetEffectName()
	return "particles/units/heroes/hero_slardar/slardar_sprint_river.vpcf"
end

function modifier_deep_water:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end