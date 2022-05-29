function SpawnBoar(event)
	local caster = event.caster
	local duration = event.ability:GetSpecialValueFor("duration")


    
    unit = CreateUnitByName("npc_dota_warlock_golem_7", front_position, true, caster, caster, caster:GetTeam())

    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
end