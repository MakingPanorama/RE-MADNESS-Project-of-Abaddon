local DemonLord = nil
function DemonLordCreated(keys)
	local caster = keys.caster
	if caster:GetUnitName() == "npc_dota_demon_lord" then
		DemonLord = caster
	end
end

function CheckStackCount(params)
	
	local ability = params.ability
	local attack_count = ability:GetLevelSpecialValueFor("attack_count", ability:GetLevel() - 1)
	local previous_stack_count = 0
	previous_stack_count = 0
	if DemonLord == nil then
	return end
	
	if params.caster:HasModifier("modifier_creature_demon_split_counter") then
		previous_stack_count = params.caster:GetModifierStackCount("modifier_creature_demon_split_counter", params.caster)
		
		--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
		params.caster:RemoveModifierByNameAndCaster("modifier_creature_demon_split_counter", params.caster)
	end
	params.ability:ApplyDataDrivenModifier(params.caster, params.caster, "modifier_creature_demon_split_counter", nil)
	params.caster:SetModifierStackCount("modifier_creature_demon_split_counter", params.caster, previous_stack_count + 1)

	if params.caster:GetModifierStackCount("modifier_creature_demon_split_counter", params.caster) >= attack_count then
		local team = params.caster:GetTeam()
		local waypoint = Entities:FindByName( nil, "d_waypoint18") -- Записываем в переменную 'waypoint' координаты первого бокса way1
		local point = params.caster:GetAbsOrigin()
		local unit = CreateUnitByName( "npc_dota_spirit", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, team )
		unit:SetHealth(DemonLord:GetHealth())
		print("DemonLordHealth ="..DemonLord:GetHealth())
		unit:SetInitialGoalEntity( waypoint )
		params.caster:RemoveModifierByNameAndCaster("modifier_creature_demon_split_counter", params.caster)
		
	end
end

