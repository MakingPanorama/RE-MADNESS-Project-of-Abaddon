fountain_buff = class{}
LinkLuaModifier( 'modifier_fountain_buff', 'lua_abilities//fountain_buff.lua', 0 )
LinkLuaModifier( 'modifier_fountain_buff_aura', 'lua_abilities//fountain_buff.lua', 0 )

function fountain_buff:GetIntrinsicModifierName()
	return 'modifier_fountain_buff'
end

modifier_fountain_buff = class{}

function modifier_fountain_buff:IsHidden()
	return true
end

function modifier_fountain_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_fountain_buff:GetModifierAttackSpeedBaseOverride()
	return self:GetAbility():GetSpecialValueFor('attackspeed')
end

function modifier_fountain_buff:OnAttackLanded( kv )
	if not Exist(kv.target) then return end
	if kv.attacker == self:GetParent() then
		if RollPercentage(8) then
			ApplyDamage{
				victim = kv.target,
				attacker = kv.attacker,
				damage = kv.target:GetMaxHealth() * RandomFloat(0.2,1),
				damage_type = DAMAGE_TYPE_PURE,
				ability = self:GetAbility()
			}
		end
		kv.target:AddNewModifier( kv.attacker, self:GetAbility(), 'modifier_stunned', { duration = 0.02 } )
	end
end

function modifier_fountain_buff:IsAura()
	return true
end
function modifier_fountain_buff:GetModifierAura()
	return 'modifier_fountain_buff_aura'
end
function modifier_fountain_buff:GetAuraRadius()
	return 1500
end
function modifier_fountain_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_fountain_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
function modifier_fountain_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end



modifier_fountain_buff_aura = class{}

function modifier_fountain_buff_aura:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end

function modifier_fountain_buff_aura:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.05)
		self.tick = 0
		self.oldpos = self:GetParent():GetOrigin()
	end
end

function modifier_fountain_buff_aura:OnIntervalThink()
	self:GetParent():Purge( true, false, false, false, true )
	self.tick = self.tick + 1
	
	local newpos = self:GetParent():GetOrigin()
	if newpos ~= self.oldpos then
		self.tick = 0
		self.oldpos = newpos
	end
	self.tick = self.tick + 1
	if self.tick > 900 then
		FindClearSpaceForUnit( self:GetParent(), RandomVectorG(), false )
	end
end