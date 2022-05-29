item_shotgun = class({})

function FireShotgun( keys )
	local bullets = keys.bullets
	local castey = keys.caster
	local firesound = "Hero_Sniper.MKG_ShrapnelShoot"
	local playerimpactsound = "Hero_Sniper.MKG_impact"
	local treeimpactsound = "Hero_Sniper.ProjectileImpact"
	local frameTime = 0.02
	StartSoundEvent(firesound, castey)
	for i = 1, bullets, 1 do
		local caster = keys.caster
		local target = keys.target
		local point = keys.target_points[ 1 ]
		local range = keys.range
		local speed = keys.speed
		local spread = keys.spread
		spread = spread * math.pi / 180 --convert from degrees to radians
		
		local dmg = keys.damage
		
		local currPos = caster:GetAbsOrigin()
		local startPos = caster:GetAbsOrigin()
		
		local vDir = {}
		vDir[i] = Vector(0, 0, 0)

		vDirection = point - caster:GetAbsOrigin()
		vDirection = Vector(vDirection.x, vDirection.y, 0) --Limits motion to only one plane
		math.randomseed(GameRules:GetGameTime() + math.random())
		vDirection = vDirection:Normalized()
		
		local radians = math.asin(vDirection.y)
		if vDirection.x < 0 then --Because arcsin only goes from -90 to 90 deg, we have to make it be able to do things on the left side
			if radians > 0 then
				radians = math.pi - radians
			else
				radians = math.pi - radians
			end
		end
		local t = math.random() - 0.5
		radians = radians + (spread * -0.5) + (spread * (i - 0.5) / bullets)
		
		vDir[i].x = math.cos(radians)
		vDir[i].y = math.sin(radians)
		
		local info = {
			EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
			Ability = self,
			vSpawnOrigin = caster:GetAbsOrigin(), 
			vVelocity = vDir[i] * speed * 0.7, -- EFFECT TRAVELS TOO FUCKING FAST
			fStartRadius = 50,
			fEndRadius = 50,
			fDistance = 99999, -- WILL DESTROY PROJECTILE MANUALLY
			Source = caster,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			bProvidesVision = true,
			bDeleteOnHit = true,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iVisionRadius = 65
		}
		local nProjID = {}
		nProjID[i] = ProjectileManager:CreateLinearProjectile( info )
		
		Timers:CreateTimer( function()
			currPos = currPos + (vDir[i] * speed * frameTime)
			local diff = currPos - startPos
			local distance = (diff.x * diff.x) + (diff.y * diff.y)
			local units = FindUnitsInRadius( caster:GetTeamNumber(), currPos, caster, 50,
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			if distance > (range * range) then --STOP IF GOING TOO FAR
				--print(nProjID[i] .. " went too far")
				ProjectileManager:DestroyLinearProjectile( nProjID[i] )
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
				ProjectileManager:DestroyLinearProjectile( nProjID[i] )
				--print(nProjID[i] .. " hit a unit")
				--print(range - math.sqrt(distance) .. " units away from max range")
				--print(speed * 0.02 .. " units travelled per frame")
				return nil
			elseif GridNav:IsNearbyTree( currPos, 50, true ) then --DESTROY TREES
				GridNav:DestroyTreesAroundPoint( currPos, 55, true)
				StartSoundEventFromPosition(treeimpactsound, currPos)
				ProjectileManager:DestroyLinearProjectile( nProjID[i] )
				--print(nProjID[i] .. " hit a tree")
				--print(range - math.sqrt(distance) .. " units away from max range")
				--print(speed * 0.02 .. " units travelled per frame")
				return nil
			else --NOTHING HAPPENS
				return frameTime
			end
			end
		)
	end
end

