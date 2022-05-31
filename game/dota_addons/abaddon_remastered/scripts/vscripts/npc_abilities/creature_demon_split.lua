--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Checks if Riki is behind his target
	Borrows heavily from bristleback.lua]]
	
function CheckStackCount(params)
	
	local ability = params.ability
	local attack_count = ability:GetLevelSpecialValueFor("attack_count", ability:GetLevel() - 1)
	local previous_stack_count = 0
	-- The y value of the angles vector contains the angle we actually want: where units are directionally facing in the world.
		--For Slark, update his visible counter modifier's stack count and duration, and raise his Agility.  The full amount of Agility is gained
		--even if the target does not have any more attributes to steal.
		previous_stack_count = 0
		if params.caster:HasModifier("modifier_creature_demon_split_counter") then
			previous_stack_count = params.caster:GetModifierStackCount("modifier_creature_demon_split_counter", params.caster)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			params.caster:RemoveModifierByNameAndCaster("modifier_creature_demon_split_counter", params.caster)
		end
		params.ability:ApplyDataDrivenModifier(params.caster, params.caster, "modifier_creature_demon_split_counter", nil)
		params.caster:SetModifierStackCount("modifier_creature_demon_split_counter", params.caster, previous_stack_count + 1)
		--EmitSoundOn(params.sound2, params.target)
		-- uncomment this if regular (non-backstab) attack has no sound
		if params.caster:GetModifierStackCount("modifier_creature_demon_split_counter", params.caster) >= attack_count then
			local team = params.caster:GetTeam()
			local waypoint = Entities:FindByName( nil, "d_waypoint19") -- Записываем в переменную 'waypoint' координаты первого бокса way1
			local point = params.caster:GetAbsOrigin()
			local unit = CreateUnitByName( "creature_leech", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, team )
			unit:SetInitialGoalEntity( waypoint )
			params.caster:RemoveModifierByNameAndCaster("modifier_creature_demon_split_counter", params.caster)
			
		end
end

