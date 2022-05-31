--[[Author: Pizzalol
	Date: 09.02.2015.
	Triggers when the unit attacks
	Checks if the attack target is the same as the caster
	If true then trigger the counter helix if its not on cooldown]]
function CounterStomp( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local trigger_chance = ability:GetSpecialValueFor("trigger_chance")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local radius = ability:GetSpecialValueFor("radius")
	local base_dmg = ability:GetSpecialValueFor("base_dmg")
	local str_dmg = ability:GetSpecialValueFor("str_dmg")/100

	local damage = base_dmg + str_dmg* caster:GetStrength()
	
	if not ability:IsCooldownReady() then
	return end
	
--	if not RollPercentage(trigger_chance) then
--	return end
	
	ability:UseResources(false, false, true)
	EmitSoundOn("Hero_Centaur.HoofStomp",caster)
	
	local effect = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius)) -- Destination

	local enemies = FindUnitsInRadius(caster:GetTeam(), 
									caster:GetAbsOrigin(), 
									nil, 
									radius, 
									DOTA_UNIT_TARGET_TEAM_ENEMY, 
									DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_NONE, 
									FIND_ANY_ORDER, false)
	
	for i=1,#enemies do
		local enemy = enemies[i]
		DealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, nil, ability)
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
	end
end