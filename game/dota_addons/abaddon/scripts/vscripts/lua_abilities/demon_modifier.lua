demon_modifier = class ({})

--------------------------------------------------------------------------------

function demon_modifier:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function demon_modifier:OnCreated( kv )
	self.movement_speed_buff_amount = self:GetAbility():GetSpecialValueFor( "demon_movement_speed_buff_amount" )
	self.attack_damage_bonus_amount = self:GetAbility():GetSpecialValueFor( "demon_attack_damage_bonus_amount" )
	self.attack_speed_bonus_amount = self:GetAbility():GetSpecialValueFor( "demon_attack_speed_bonus_amount" )
	self.health_dmg_per = self:GetAbility():GetSpecialValueFor( "health_dmg_per" )
	self.health_interval = self:GetAbility():GetSpecialValueFor( "health_interval" )
	self.health_dmg_per_level = self:GetAbility():GetSpecialValueFor( "health_dmg_per_level" )
	
	self.num_to_spawn = 1
	self.nStacks = 0
	self.flSearchRadius = 0

	if IsServer() then
		self:SetStackCount( self.nStacks )
	end
	
	self:StartIntervalThink(self.health_interval)
end

--------------------------------------------------------------------------------

function demon_modifier:OnIntervalThink()
	local caster = self:GetCaster()
	local flDamagePerTick = (caster:GetLevel() /4) * (self:GetStackCount())


    if IsServer() then
        if not caster:IsAlive() then
            self:Destroy()
            return
        end
	end
	
	if GameRules:IsGamePaused() == true then
		return 5.0
	end

    for i=1,self.num_to_spawn do
			if not caster:IsAlive() then
				self:Destroy()
				return
			end
	self:IncreaseStats()
	end
	
	if IsServer() then
		if caster:IsAlive() then
			local damage = {
				victim = caster,
				attacker = caster,
				damage = flDamagePerTick,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage( damage )
		end
	end
	
	local hEnemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 0, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies > 0 then
		self.flSearchRadius = 0
		return 5.0
	else
		if self.flSearchRadius < 0 then
			self.flSearchRadius = self.flSearchRadius * 0
		end

		caster:SetAcquisitionRange( self.flSearchRadius )
	end

	return 5.0
end

--------------------------------------------------------------------------------

function demon_modifier:IncreaseStats()
	local caster = self:GetCaster()

    if caster:IsAlive() then
		self.nStacks = self.nStacks + 1
		self:SetStackCount( self.nStacks )
    end
end

--------------------------------------------------------------------------------

function demon_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

--------------------------------------------------------------------------------

function demon_modifier:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetStackCount() * self.movement_speed_buff_amount
end

--------------------------------------------------------------------------------

function demon_modifier:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.attack_speed_bonus_amount
end

--------------------------------------------------------------------------------

function demon_modifier:GetModifierBaseDamageOutgoing_Percentage( params )
	return self:GetStackCount() * self.attack_damage_bonus_amount
end

