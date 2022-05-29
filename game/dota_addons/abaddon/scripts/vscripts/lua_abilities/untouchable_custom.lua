if untouchable_custom == nil then untouchable_custom = class({}) end

LinkLuaModifier("untouchable_custom_passive","lua_abilities/untouchable_custom.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("untouchable_custom_slow","lua_abilities/untouchable_custom.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("untouchable_custom_slow_scepter","lua_abilities/untouchable_custom.lua",LUA_MODIFIER_MOTION_NONE)


function untouchable_custom:GetIntrinsicModifierName(  )
	return "untouchable_custom_passive"
end

if untouchable_custom_passive == nil then untouchable_custom_passive = class({}) end

function untouchable_custom_passive:IsPurgable(  )
	return false
end

function untouchable_custom_passive:IsHidden(  )
	return true
end

function untouchable_custom_passive:RemoveOnDeath(  )
	return false
end

function untouchable_custom_passive:OnCreated(  )
	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("duration")
	print(self.duration)
end

function untouchable_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_START}
end

function untouchable_custom_passive:OnAttackStart( params )
	local caster = self:GetCaster()
	if params.target == caster then 
		local attacker = params.attacker
		if attacker and attacker:IsAlive() and caster:IsAlive() and IsServer() then
			if caster:HasScepter() then
				attacker:AddNewModifier(caster,self:GetAbility(),"untouchable_custom_slow_scepter",{duration = self:GetAbility():GetSpecialValueFor("duration")})
			else
				attacker:AddNewModifier(caster,self:GetAbility(),"untouchable_custom_slow",{duration = self:GetAbility():GetSpecialValueFor("duration")})
			end
		end
	end
end

if untouchable_custom_slow == nil then untouchable_custom_slow = class({}) end

function untouchable_custom_slow:IsPurgable(  )
	return true
end

function untouchable_custom_slow:GetTexture(  )
	return "untouchable_custom"
end

function untouchable_custom_slow:IsDebuff(  )
	return true
end

function untouchable_custom_slow:IsHidden(  )
	return false
end

function untouchable_custom_slow:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function untouchable_custom_slow:OnCreated(  )
	local parent = self:GetParent()
	if IsBoss(parent) then 
		self.slow = self:GetAbility():GetSpecialValueFor("boss_attack_speed")
	else
		self.slow = self:GetAbility():GetSpecialValueFor("attack_speed")	
	end
end

function untouchable_custom_slow:GetModifierAttackSpeedBonus_Constant(  )
	return -self.slow
end

if untouchable_custom_slow_scepter == nil then untouchable_custom_slow_scepter = class({}) end

function untouchable_custom_slow_scepter:IsPurgable(  )
	return true
end

function untouchable_custom_slow_scepter:GetTexture(  )
	return self:GetAbility():GetName()
end

function untouchable_custom_slow_scepter:IsDebuff(  )
	return true
end

function untouchable_custom_slow_scepter:IsHidden(  )
	return false
end

function untouchable_custom_slow_scepter:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,MODIFIER_PROPERTY_TOOLTIP}
end

function untouchable_custom_slow_scepter:OnCreated(  )
	local parent = self:GetParent()
	self.BAT = parent:GetBaseAttackTime()
	if IsBoss(parent) then 
		self.slow = self:GetAbility():GetSpecialValueFor("boss_attack_speed")
		self.slow_at = self:GetAbility():GetSpecialValueFor("scepter_boss_attack_speed")
	else
		self.slow = self:GetAbility():GetSpecialValueFor("attack_speed")
		self.slow_at = self:GetAbility():GetSpecialValueFor("scepter_attack_speed")		
	end
	self.BAT = self.BAT + self.slow_at
	print(self.BAT)
end

function untouchable_custom_slow_scepter:GetModifierAttackSpeedBonus_Constant(  )
	return -self.slow
end

function untouchable_custom_slow_scepter:GetModifierBaseAttackTimeConstant(  )
	return self.BAT
end

function untouchable_custom_slow_scepter:OnTooltip(  )
	return self.slow_at
end