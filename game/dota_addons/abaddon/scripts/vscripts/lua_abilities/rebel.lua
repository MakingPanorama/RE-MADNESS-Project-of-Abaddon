LinkLuaModifier("modifier_rebel_magic_armor_passive", "lua_abilities/rebel.lua", LUA_MODIFIER_MOTION_NONE)
rebel_magic_armor = class({})

function rebel_magic_armor:GetIntrinsicModifierName()
	return "modifier_rebel_magic_armor_passive"
end

modifier_rebel_magic_armor_passive = class({})

function modifier_rebel_magic_armor_passive:IsHidden()			return true end
function modifier_rebel_magic_armor_passive:IsPassive()			return true end

function modifier_rebel_magic_armor_passive:OnCreated()
	self.reflect_damage = self:GetAbility():GetSpecialValueFor("reflect_percentage")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end
function modifier_rebel_magic_armor_passive:OnRefresh()
	self:OnCreated()
	print(self.chance)
end
function modifier_rebel_magic_armor_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_rebel_magic_armor_passive:GetModifierTotal_ConstantBlock(kv)
	if RollPercentage( self.chance ) then
		return kv.damage * self.reflect_damage / 100
	end
	return kv.damage
end
function modifier_rebel_magic_armor_passive:OnTakeDamage( kv )
	local attacker = kv.attacker
	local victim = kv.target
	local damage = kv.damage
	local damage_type = kv.damage_type
	local damage_flags = kv.damage_flags

	if victim ~= self:GetParent() then return end

	if RollPercentage( self.chance ) then
		ApplyDamage({
			victim = attacker,
			attacker = victim, 
			damage = damage * self.reflect_damage / 100,
			damage_type = damage_type,
			damage_flags = damage_flags + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR
		})
	end

	local reflect = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(reflect, 0, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", victim:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(reflect, 1, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", attacker:GetAbsOrigin(), false)
end
