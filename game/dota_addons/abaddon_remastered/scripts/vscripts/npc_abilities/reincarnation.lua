function Reincarnation( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
	local casterHP = caster:GetHealth()
	if casterHP == 0 and ability:IsCooldownReady() then
		local reincarnate_time = ability:GetLevelSpecialValueFor( "reincarnate_time", ability:GetLevel() - 1 )
		local slow_radius = ability:GetLevelSpecialValueFor( "slow_radius", ability:GetLevel() - 1 )
		local respawnPosition = caster:GetAbsOrigin()
		ability:StartCooldown(cooldown)

		-- Kill, counts as death for the player but doesn't count the kill for the killer unit
		caster:SetHealth(1)
		caster:Kill(caster, nil)
        
        caster:SetUnitCanRespawn(true)
		Timers:CreateTimer(reincarnate_time, function()
            caster:RespawnUnit()
        end) 

		-- Particle
		local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
		caster.ReincarnateParticle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(caster.ReincarnateParticle, 0, respawnPosition)
		ParticleManager:SetParticleControl(caster.ReincarnateParticle, 1, Vector(slow_radius,0,0))

		-- End Particle after reincarnating
		Timers:CreateTimer(reincarnate_time, function() 
			ParticleManager:DestroyParticle(caster.ReincarnateParticle, false)
		end)

		-- Grave and rock particles
		-- The parent "particles/units/heroes/hero_skeletonking/skeleton_king_death.vpcf" misses the grave model
		local model = "models/props_gameplay/tombstoneb01.vmdl"
		local grave = Entities:CreateByClassname("prop_dynamic")
    	grave:SetModel(model)
    	grave:SetAbsOrigin(respawnPosition)

    	local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_bits.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl(particle1, 0, respawnPosition)

		local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust.vpcf"
		local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(particle2, 0, respawnPosition)

		local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust_reincarnate.vpcf"
		local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(particle3 , 0, respawnPosition)

    	-- End grave after reincarnating
    	Timers:CreateTimer(reincarnate_time, function() grave:RemoveSelf() end)		

		-- Sounds
		caster:EmitSound("Hero_SkeletonKing.Reincarnate")
		caster:EmitSound("Hero_SkeletonKing.Death")
		Timers:CreateTimer(reincarnate_time, function()
			caster:EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")
		end)

		-- Slow
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), respawnPosition, nil, slow_radius, 
									DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
									DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
		for _,unit in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_reincarnation_slow", {duration = duration})
		end
	end	
end
