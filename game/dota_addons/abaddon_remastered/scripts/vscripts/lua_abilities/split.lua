function Split( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	
	if caster:PassivesDisabled() then return end

	if not caster:IsRealHero() and not caster:IsBuilding() then return nil end
	

	-- Parameters
	local split_chance = ability:GetLevelSpecialValueFor("split_chance", ability_level)
	local split_radius = ability:GetLevelSpecialValueFor("split_radius", ability_level)
	local split_amount = ability:GetLevelSpecialValueFor("split_amount", ability_level)
	local target_pos = target:GetAbsOrigin()
	
	-- Roll for splinter chance
	if RandomInt(1, 100) <= split_chance then

		-- Choose the correct particle for this tower
		local attack_projectile = "particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf"
		if caster:GetTeam() == DOTA_TEAM_BADGUYS then
			attack_projectile = "particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf"
		elseif caster:GetTeam() == DOTA_TEAM_GOODGUYS then
			attack_projectile = "particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf"
		end

		-- Find enemies near the target
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, split_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #nearby_enemies > 1 then

			-- Initialize the target table
			local split_targets = {}

			-- Add enemies to the target table until it's full
			for _,enemy in pairs(nearby_enemies) do
				
				-- Do not add the original target
				if enemy ~= target then
					split_targets[#split_targets + 1] = enemy

					-- If the target table is full, stop looking for more
					if #split_targets >= split_amount then
						break
					end
				end
			end

			-- Split projectile base parameters
			local split_projectile = {
				Target = "",
				Source = target,
				Ability = ability,
			--	EffectName =
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = 750,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the projectiles
			for _,split_target in pairs(split_targets) do
				split_projectile.Target = split_target
				ProjectileManager:CreateTrackingProjectile(split_projectile)
			end
		end
	end
end

function SplitHit( keys )
	local caster = keys.caster
	local target = keys.target

	caster:PerformAttack(target, true, true, true, true, true, false, true)
end