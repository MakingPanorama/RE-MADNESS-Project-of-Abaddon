
function BuildGoldenMine( event )
	local point = event.target_points[1]
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()

	local base_hp = ability:GetSpecialValueFor("base_hp")
	local base_armor = ability:GetSpecialValueFor("base_armor")
	
	-- Set the unit name, concatenated with the level number
	local unit_name = "npc_dota_gold_mine"
	
	-- Check if the bear is alive, heals and spawns them near the caster if it is
	-- Create the unit and make it controllable
	tower = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
	tower:SetControllableByPlayer(player, true)

	local new_hp = base_hp

	tower:SetPhysicalArmorBaseValue(base_armor )
	tower:SetMaxHealth( new_hp )
	tower:SetBaseMaxHealth( new_hp )
	tower:SetHealth( new_hp )
	
--	SetLevelForSubAbility(ability, "greevil_lord_upgrade_towers", tower, 1, 1)
	ability:ApplyDataDrivenModifier(caster, tower, "modifier_greevil_egg_golden_mine_passive", nil)

end

function GiveGoldPerTick( event )
	local target = event.target
	local ability = event.ability	
	local gold_per_tick = ability:GetSpecialValueFor("gold_per_tick")

	PlayerResource:ModifyGold( target:GetPlayerOwnerID(), gold_per_tick, true, 0 )
	
    pidx = ParticleManager:CreateParticleForTeam("particles/msg_fx/msg_xp.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, target:GetTeamNumber())
    ParticleManager:SetParticleControl(pidx, 1, Vector(0, gold_per_tick, 0))
    ParticleManager:SetParticleControl(pidx, 2, Vector(3, 3, 0))
    ParticleManager:SetParticleControl(pidx, 3, Vector(255,255,20))
	
--	SendOverheadEventMessage( target, OVERHEAD_ALERT_GOLD, target, gold_per_tick, nil )

end


