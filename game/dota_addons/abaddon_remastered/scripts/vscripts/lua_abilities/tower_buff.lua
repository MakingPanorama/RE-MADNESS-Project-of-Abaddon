tower_buff = class({})

LinkLuaModifier("modifier_tower_buff","lua_abilities/tower_buff",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_buff_recovery","lua_abilities/tower_buff",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_tower_buff_aura","lua_abilities/tower_buff",LUA_MODIFIER_MOTION_NONE)


function tower_buff:GetIntrinsicModifierName()

	return "modifier_tower_buff_aura"
end

modifier_tower_buff = class({})

function modifier_tower_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_tower_buff:IsHidden()
	return true
end

if IsServer() then

	function modifier_tower_buff:OnTakeDamage(params)
		local threshold = self:GetAbility():GetSpecialValueFor("threshold")

		local caster = self:GetParent()

		if params.unit ~= caster then return end

		local hp = caster:GetHealthPercent()

		local duration = self:GetAbility():GetSpecialValueFor("duration")

		if not caster:IsRealHero() then return end


		local cast_me = self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough()

		local mana_cost = self:GetAbility():GetManaCost(self:GetAbility():GetLevel())

		local cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel()-1)

		if hp < threshold then

			if cast_me then
				local duration = self:GetAbility():GetSpecialValueFor("duration")

				if mana_cost > 0 then
					caster:SpendMana(mana_cost, self:GetAbility())
				end

				caster:AddNewModifier(caster, self:GetAbility(), "modifier_tower_buff_recovery", {Duration=duration}) --[[Returns:void
				No Description Set
				]]
				caster:EmitSound("Erra.GraveGuard")

				
					self:GetAbility():StartCooldown(cooldown)
				
			end

		end
	end

end

modifier_tower_buff_aura = class({})

function modifier_tower_buff_aura:IsAura()
	return true
end



function modifier_tower_buff_aura:GetAuraSearchFlags()
	return 0
end

function modifier_tower_buff_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tower_buff_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_tower_buff_aura:GetModifierAura()
	return "modifier_tower_buff"
end

function modifier_tower_buff_aura:IsHidden()
	return true
end





modifier_tower_buff_recovery = class({})

function modifier_tower_buff_recovery:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_berserker_blood_hero_effect.vpcf"
end

function modifier_tower_buff_recovery:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
	return funcs
end

function modifier_tower_buff_recovery:GetModifierIncomingDamage_Percentage()
	
	return self:GetAbility():GetSpecialValueFor("hp_recovery")
end

function modifier_tower_buff_recovery:GetModifierBaseAttackTimeConstant()
	
	return self:GetAbility():GetSpecialValueFor("mp_recovery")
end