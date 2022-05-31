LinkLuaModifier("modifier_t13_maim", "lua_abilities/t13_maim.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_t13_maim_debuff", "lua_abilities/t13_maim.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if t13_maim == nil then
	t13_maim = class({})
end
function t13_maim:GetIntrinsicModifierName()
	return "modifier_t13_maim"
end

function t13_maim:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_t13_maim == nil then
	modifier_t13_maim = class({})
end
function modifier_t13_maim:IsHidden()
	return true
end
function modifier_t13_maim:IsDebuff()
	return false
end
function modifier_t13_maim:IsPurgable()
	return false
end
function modifier_t13_maim:IsPurgeException()
	return false
end
function modifier_t13_maim:IsStunDebuff()
	return false
end
function modifier_t13_maim:AllowIllusionDuplicate()
	return false
end
function modifier_t13_maim:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.blood_duration = self:GetAbilitySpecialValueFor("blood_duration")
	self.blood_chance = self:GetAbilitySpecialValueFor("blood_chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.trigger_distance = self:GetAbilitySpecialValueFor("trigger_distance")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_t13_maim:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.blood_duration = self:GetAbilitySpecialValueFor("blood_duration")
	self.blood_chance = self:GetAbilitySpecialValueFor("blood_chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.trigger_distance = self:GetAbilitySpecialValueFor("trigger_distance")
	if IsServer() then
	end
end
function modifier_t13_maim:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_t13_maim:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_t13_maim:OnTakeDamage(params)
	if not self:GetAbility():IsActivated() then return end

	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() and not params.attacker:IsIllusion() then
		params.unit:AddNewModifier(params.attacker, self:GetAbility(), "modifier_t13_maim_debuff", {duration = self.duration * params.unit:GetStatusResistanceFactor()})
	end
end
function modifier_t13_maim:OnAttackLanded(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end

	if not self:GetAbility():IsActivated() then return end

	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() and not params.attacker:IsIllusion() then 
		if not params.target:IsAncient() then 
			if PRD(params.attacker, self.blood_chance, "modifier_t13_maim") then
				params.target:Bleeding(params.attacker, self:GetAbility(), function(hUnit)
					return hUnit:GetHealth() * self.damage * 0.01
				end, self:GetAbility():GetAbilityDamageType(), self.blood_duration*params.target:GetStatusResistanceFactor(), self.trigger_distance)
			end
		end
	end
end


---------------------------------------------------------------------
if modifier_t13_maim_debuff == nil then
	modifier_t13_maim_debuff = class({})
end
function modifier_t13_maim_debuff:IsHidden()
	return false
end
function modifier_t13_maim_debuff:IsDebuff()
	return true
end
function modifier_t13_maim_debuff:IsPurgable()
	return true
end
function modifier_t13_maim_debuff:IsPurgeException()
	return true
end
function modifier_t13_maim_debuff:IsStunDebuff()
	return false
end
function modifier_t13_maim_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_t13_maim_debuff:GetEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end
function modifier_t13_maim_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_t13_maim_debuff:OnCreated(params)
	self.incoming_damage_pct = self:GetAbilitySpecialValueFor("incoming_damage_pct")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_t13_maim_debuff:OnRefresh(params)
	self.incoming_damage_pct = self:GetAbilitySpecialValueFor("incoming_damage_pct")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_t13_maim_debuff:OnStackCountChanged(iOldStackCount)
	if IsServer() then
		if self:GetStackCount() > self.max_stack_count then
			self:SetStackCount(self.max_stack_count)
		end
	end
end
function modifier_t13_maim_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_t13_maim_debuff:GetModifierIncomingDamage_Percentage(params)
	if IsServer() then
		if params.attacker == self:GetCaster() then 
			return self.incoming_damage_pct*self:GetStackCount()
		end
	else
		return self.incoming_damage_pct*self:GetStackCount()
	end
end