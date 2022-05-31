function check (keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = caster:GetAbsOrigin()
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local units = Entities:FindAllInSphere(pos, radius)
    local flag = 0
    for _,unit in ipairs(units) do   
        if not unit:IsAlive() and unit:GetClassname()== "npc_dota_creature" then
            flag = 1
            break
        end
    end
    if flag == 0 then
        caster:Stop()
        local player = caster:GetPlayerOwner()
        local message = { message = "#dota_hud_error_no_corpses" }
        CustomGameEventManager:Send_ServerToPlayer(player, "Hud_Error_Message", message)
    end
end

function create (keys)
    local caster = keys.caster
	local ability = keys.ability
	local pos = caster:GetAbsOrigin()
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local level = ability:GetLevel()
    local units = Entities:FindAllInSphere(pos, radius)
    for _,unit in ipairs(units) do   
        if not unit:IsAlive() and unit:GetClassname()== "npc_dota_creature" then
            local point = unit:GetAbsOrigin()
            local ghost = CreateUnitByName("Shadow Ghost", point, true, caster, nil, caster:GetTeam())
            ghost:CreatureLevelUp(level-1)
            ghost:SetControllableByPlayer(caster:GetPlayerID(), true)
            ghost:SetOwner(caster)
            ghost:AddNewModifier(ward, nil, "modifier_kill", {duration = duration})
            ability:ApplyDataDrivenModifier( caster, ghost, keys.buff, {} )
        end
    end
end