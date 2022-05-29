if item_reflect_shield == nil then item_reflect_shield = class({}) end

LinkLuaModifier("modifier_reflect_shield_passive","item_abilities\item_reflect_shield.lua",LUA_MODIFIER_MOTION_NONE)

function item_reflect_shield:GetIntrinsicModifierName(  )
	return "modifier_reflect_shield_passive"
end

if modifier_reflect_shield_passive == nil then modifier_reflect_shield_passive = class({}) end

function modifier_reflect_shield_passive:IsHidden(  )
	return true
end

function modifier_reflect_shield_passive:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_reflect_shield_passive:IsPurgable(  )
	return false
end

function modifier_reflect_shield_passive:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_reflect_shield_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local damagetype = params.damage_type
	local damage_type = DAMAGE_TYPE_PURE
	local point = PATTACH_ROOTBONE_FOLLOW
	if params.target == caster then 
		local target = params.target
		if RollPercentage(ability:GetSpecialValueFor("chance")) then 
			local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf",point, caster)
			ParticleManager:SetParticleControlEnt(id0, 0, caster, point, "attach_hitloc", caster:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(id0, 1, params.attacker, point, "attach_hitloc", params.attacker:GetAbsOrigin(), false)
			ApplyDamage({victim = params.attacker, attacker = caster, damage = params.damage, damage_type = damage_type, ability = ability})
		end
	end
end

function modifier_reflect_shield_passive:GetModifierHealthBonus(  )
	return self:GetAbility():GetSpecialValueFor("hp")
end

function modifier_reflect_shield_passive:GetModifierPhysicalArmorBonus (  )
	return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_reflect_shield_passive:GetModifierBonusStats_Strength (  )
	return self:GetAbility():GetSpecialValueFor("str")
end