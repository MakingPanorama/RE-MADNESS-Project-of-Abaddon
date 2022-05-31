LinkLuaModifier("modifier_item_khorn_sword", "item_abilities/item_khorn_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_khorn_sword_fire", "item_abilities/item_khorn_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_khorn_sword_twice", "item_abilities/item_khorn_sword", LUA_MODIFIER_MOTION_NONE)

item_khorn_sword = class({})

function item_khorn_sword:GetIntrinsicModifierName()		return "modifier_item_khorn_sword" end
modifier_item_khorn_sword = class({})

function modifier_item_khorn_sword:IsHidden() return true end
function modifier_item_khorn_sword:OnCreated()
	self.ability = self:GetAbility()

	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.guaranteed_damage = self.ability:GetSpecialValueFor("guaranteed_damage")
	self.duration_fire = self.ability:GetSpecialValueFor("duration")

end

function modifier_item_khorn_sword:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,

		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_item_khorn_sword:GetModifierProcAttack_BonusDamage_Pure(kv)
	if kv.attacker == self:GetParent() then
		if not self:GetParent():IsRangedAttacker() then
			if self.ability:IsCooldownReady() then
				if not kv.target:HasModifier("modifier_item_khorn_sword_fire") then
					self.ability:UseResources(false, false, true)
					kv.attacker:AddNewModifier(self:GetCaster(), self.ability, "modifier_item_khorn_sword_twice", { duration = 8 })
					kv.target:AddNewModifier(self:GetCaster(), self.ability, "modifier_item_khorn_sword_fire", { duration = self.duration_fire })
					return self.guaranteed_damage
				end
			end
		end
	end
	return nil
end

modifier_item_khorn_sword_twice = class({})

function modifier_item_khorn_sword_twice:IsHidden() return true end

function modifier_item_khorn_sword_twice:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_item_khorn_sword_twice:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return 700
	end
end

function modifier_item_khorn_sword_twice:OnAttack(kv)
	if kv.attacker == self:GetParent() then
		self:Destroy()
	end
end

modifier_item_khorn_sword_fire = class({})

function modifier_item_khorn_sword_fire:GetTexture() return "custom/khorn_currupted_attack" end

function modifier_item_khorn_sword_fire:OnCreated()
	self.fire_damage_per_second = self:GetAbility():GetSpecialValueFor("fire_damage_per_second")
	self:StartIntervalThink( 0.5 )
end
function modifier_item_khorn_sword_fire:OnIntervalThink()
	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		ability = self:GetAbility(),
		damage = self.fire_damage_per_second + self:GetParent():GetHealth() * 5 / 100 ,
		damage_type = DAMAGE_TYPE_PURE
	})
end
