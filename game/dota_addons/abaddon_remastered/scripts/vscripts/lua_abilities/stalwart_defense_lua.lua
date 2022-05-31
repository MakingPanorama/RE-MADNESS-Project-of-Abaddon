modifier_defense = modifier_defense or class({})

LinkLuaModifier("modifier_interval","lua_abilities/modifiers/modifier_stalwart_defense_lua.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_defense:GetIntrinsicModifierName()
	return "modifier_interval"
end

function modifier_defense:CreateProjectile(spParticleName, hSource, hTarget, bDodgeable)
	local info = {
		Target = hTarget,
		Source = hSource,
		Ability = self,

		EffectName = spParticleName,
		iMoveSpeed = 450,
		bDodgeable = bDodgeable
	}
	ProjectileManager:CreateTrackingProjectile( info )
end

function modifier_defense:OnSpellStart()
	local heal_percent = self:GetSpecialValueFor("hp_regen")
	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),	
		nil,	
		1000,	
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	
		DOTA_UNIT_TARGET_HERO,	
		0,	
		0,	
		false
	)
	if #units == 0 then
		self:EndCooldown()
	end

	for _,unit in ipairs(units) do
		self:CreateProjectile("particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf", self:GetCaster(), unit, false)
	end
end

function modifier_defense:OnProjectileHit(hTarget, vLocation)
	local heal_percent = self:GetSpecialValueFor("hp_regen")
	hTarget:Heal(hTarget:GetMaxHealth() * heal_percent / 100, self)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hTarget, hTarget:GetMaxHealth() * heal_percent / 100, nil)
	hTarget:GiveMana( hTarget:GetMaxMana() * 0.2 )
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, hTarget, hTarget:GetMaxMana() * 0.2 , nil)
end
