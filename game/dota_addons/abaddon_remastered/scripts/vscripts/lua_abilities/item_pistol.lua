item_pistol = class({})

function FirePistol( keys )
	local caster = keys.caster
	local target = keys.target
	local point = keys.target_points[ 1 ]
	local range = keys.range
	local speed = keys.speed
	local weapontype = keys.weapontype
	local firesound = ""
	local playerimpactsound = ""
	local treeimpactsound = ""
	local frameTime = 0.02
	if weapontype == "pistol" then
		firesound = "Hero_Sniper.attack"
		playerimpactsound = "Hero_Sniper.AssassinateDamage"
		treeimpactsound = "Hero_Sniper.ProjectileImpact"
	elseif weapontype == "rifle" then
		firesound = "Hero_Sniper.MKG_attack"
		playerimpactsound = "Hero_Sniper.AssassinateDamage"
		treeimpactsound = "Hero_Sniper.ProjectileImpact"
	elseif weapontype == "deagle" then
		firesound = "Ability.Assassinate"
		playerimpactsound = "Hero_Sniper.AssassinateDamage"
		treeimpactsound = "Hero_Sniper.MKG_impact"
	end
	local dmg = keys.damage
	
	local currPos = caster:GetAbsOrigin()
	local startPos = caster:GetAbsOrigin()

	vDirection = point - caster:GetAbsOrigin()
	vDirection = Vector(vDirection.x, vDirection.y, 0) --LIMIT MOTION TO ONLY ONE PLANE
	vDirection = vDirection:Normalized()
	local info = {
		EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(), 
		vVelocity = vDirection * speed * 0.7, -- EFFECT TRAVELS TOO FUCKING FAST
		fStartRadius = 50,
		fEndRadius = 50,
		fDistance = 999999,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		bDeleteOnHit = true,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iVisionRadius = 65
	}
	nProjID = ProjectileManager:CreateLinearProjectile( info )
	StartSoundEvent(firesound, caster)
	
	Timers:CreateTimer( function()
		currPos = currPos + (vDirection * speed * frameTime)
		local diff = currPos - startPos
		local distance = (diff.x * diff.x) + (diff.y * diff.y)
		local units = FindUnitsInRadius( caster:GetTeamNumber(), currPos, caster, 50,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if distance > (range * range) then --STOP IF GOING TOO FAR
			--print(nProjID .. " went too far")
			ProjectileManager:DestroyLinearProjectile( nProjID )
			return nil
		elseif units[ 1 ] then  --DAMAGE UNIT
			local damage = {
				victim = units[ 1 ],
				attacker = caster,
				damage = dmg,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = this,
			}
			ApplyDamage( damage )
			StartSoundEvent(playerimpactsound, units[ 1 ])
			ProjectileManager:DestroyLinearProjectile( nProjID )
			--print(nProjID .. " hit a unit")
			--print(range - math.sqrt(distance) .. " units away from max range")
			--print(speed * 0.02 .. " units travelled per frame")
			return nil
		elseif GridNav:IsNearbyTree( currPos, 50, true ) then --DESTROY TREES
			GridNav:DestroyTreesAroundPoint( currPos, 55, true)
			StartSoundEventFromPosition(treeimpactsound, currPos)
			ProjectileManager:DestroyLinearProjectile( nProjID )
			--print(nProjID .. " hit a tree")
			--print(range - math.sqrt(distance) .. " units away from max range")
			--print(speed * 0.02 .. " units travelled per frame")
			return nil
		else --NOTHING HAPPENS
			return frameTime
		end
		end
	)
end

