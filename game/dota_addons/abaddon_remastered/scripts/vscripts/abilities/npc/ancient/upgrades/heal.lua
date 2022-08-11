LinkLuaModifier( "modifier_ancient_heal_ability", "abilities/npc/ancient/upgrades/heal.lua", LUA_MODIFIER_MOTION_NONE )
ancient_heal_ability = class({})

function ancient_heal_ability:GetIntrinsicModifierName()
	return 'modifier_ancient_heal_ability'
end

function ancient_heal_ability:OnSpellStart()
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor('radius'), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
	
	for _, unit in pairs( units ) do
		local particle = ParticleManager:CreateParticle('particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf', PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, 'attach_attack1', self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, 'attach_hitloc', unit:GetAbsOrigin(), true)

		unit:Heal(unit:GetMaxHealth() % self:GetSpecialValueFor('health_heal_percent'), self:GetCaster())
	end
end

modifier_ancient_heal_ability = class({})

function modifier_ancient_bonus_attack_damage:IsHidden()
    return true
end

function modifier_ancient_heal_ability:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink( 0 )
end

function modifier_ancient_heal_ability:OnIntervalThink()
	self:StartIntervalThink( 0 )

	if self:GetAbility():IsCooldownReady() then
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor('radius'), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		if not units or #units < 1 then return end
		
		self:GetAbility():OnSpellStart()
		self:GetAbility():UseResources(false, false, true)
		self:StartIntervalThink( self:GetAbility():GetCooldown( self:GetAbility():GetLevel() ) )
	end
end