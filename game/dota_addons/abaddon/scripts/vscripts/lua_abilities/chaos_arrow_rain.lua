function initial (keys)
    local ability = keys.ability
    ability.pos = ability:GetCursorPosition()
end

function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle_name = keys.particle_name
    local pos = ability.pos
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local debuff_duration = ability:GetLevelSpecialValueFor("interval", (ability:GetLevel() - 1))
    local debuff = keys.debuff
    for i=1, 12 do
        local random_pos = pos + Vector(RandomInt(-radius, radius),RandomInt(-radius, radius),0)
        local ability_unit = CreateUnitByName( "ability_usage_unit", random_pos, false, caster, caster, caster:GetTeamNumber() )
        ability_unit:AddNoDraw()
        local particleid = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, ability_unit)
        ParticleManager:SetParticleControl(particleid, 0, random_pos)   
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(particleid, false)
        end)  
        EmitSoundOn("Hero_LegionCommander.Overwhelming.Location", ability_unit )
        ability_unit:ForceKill( true )
    end
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local unit={}
    local count=0
    for _,v in ipairs(units) do
		unit[count] = v
		count = count + 1
        ability:ApplyDataDrivenModifier(caster, v, debuff, { Duration = debuff_duration + 1 })
	end
    local order =
    {			
        OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
    }
    if count>1 then 
        for i=0, count-1 do
            order.UnitIndex = unit[i]:entindex()
            if i~=count-1 then     
                order.TargetIndex = unit[i+1]:entindex()
                ExecuteOrderFromTable(order)            
            else
                order.TargetIndex = unit[0]:entindex()
                ExecuteOrderFromTable(order)  
            end
        end   
    end  
end

function gold (keys)
    local killer = keys.attacker
    if (killer:GetTeam()==DOTA_TEAM_BADGUYS) and killer:HasModifier(keys.modifier_name) then
        local unit = keys.unit
        local gold = unit:GetGoldBounty()
        local caster = keys.caster
        local gold_bag = CreateItem("item_bag_of_gold", caster, caster)
        gold_bag:SetCurrentCharges(gold)
        caster:AddItem(gold_bag) 
    end
end