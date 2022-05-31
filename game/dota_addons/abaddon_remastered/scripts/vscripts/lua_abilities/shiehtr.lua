if shiehtr == nil then shiehtr = class({}) end

LinkLuaModifier("modifier_shiehtr_passive","lua_abilities/shiehtr.lua",LUA_MODIFIER_MOTION_NONE)

function shiehtr:GetIntrinsicModifierName(  )
	return "modifier_shiehtr_passive"
end

if modifier_shiehtr_passive == nil then modifier_shiehtr_passive = class({}) end

function modifier_shiehtr_passive:IsHidden(  )
	return true
end

function modifier_shiehtr_passive:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_shiehtr_passive:IsPurgable(  )
	return false
end

function modifier_shiehtr_passive:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_shiehtr_passive:OnAttackLanded( params )
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

function modifier_shiehtr_passive:GetModifierHealthBonus(  )
	return self:GetAbility():GetSpecialValueFor("hp")
end

function modifier_shiehtr_passive:GetModifierPhysicalArmorBonus (  )
	return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_shiehtr_passive:GetModifierBonusStats_Strength (  )
	return self:GetAbility():GetSpecialValueFor("str")
end