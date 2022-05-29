function StalwartDefense( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_buff = keys.modifier_buff
	local sound_cast = keys.sound_cast
	local particle_hit = keys.particle_hit
	local particle_buff = keys.particle_buff

	
	

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)

	-- Find nearby allied heroes
	local nearby_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Do nothing if there are no other nearby heroes
	if #nearby_heroes > 0 then
		
		-- Play LOUD VUVUZELA SOUNDS
		caster:EmitSound(sound_cast)

		-- Iterate through nearby allies
		for _,hero in pairs(nearby_heroes) do

			-- Purge debuffs
			hero:Purge(false, true, false, true, false)	
			
			-- Apply the modifier
			ability:ApplyDataDrivenModifier(caster, hero, modifier_buff, {})

			-- Play the light particles
			if hero.stalwart_defense_light_pfx then
				ParticleManager:DestroyParticle(hero.stalwart_defense_light_pfx, true)
			end
			hero.stalwart_defense_light_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, hero)
			ParticleManager:SetParticleControl(hero.stalwart_defense_light_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(hero.stalwart_defense_light_pfx, 1, caster:GetAbsOrigin())

			-- Play the buff particles
			if not hero.stalwart_defense_buff_pfx then
				hero.stalwart_defense_buff_pfx = ParticleManager:CreateParticle(particle_buff, PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControlEnt(hero.stalwart_defense_buff_pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_attack1", hero:GetAbsOrigin(), true)
			end
		end
	end
end


function StalwartDefenseParticleEnd( keys )
	local unit = keys.target

	-- Destroy buff particles
	if unit.stalwart_defense_light_pfx then
		ParticleManager:DestroyParticle(unit.stalwart_defense_light_pfx, false)
		ParticleManager:ReleaseParticleIndex(unit.stalwart_defense_light_pfx)
		unit.stalwart_defense_light_pfx = nil
	end
	if unit.stalwart_defense_buff_pfx then
		ParticleManager:DestroyParticle(unit.stalwart_defense_buff_pfx, false)
		ParticleManager:ReleaseParticleIndex(unit.stalwart_defense_buff_pfx)
		unit.stalwart_defense_buff_pfx = nil
	end
end













