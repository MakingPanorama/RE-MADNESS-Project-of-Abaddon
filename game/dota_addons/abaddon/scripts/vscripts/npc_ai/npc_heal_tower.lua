function Spawn( entityKeyValues )
    thisEntity:AddNewModifier(thisEntity,nil,"general_low_attack_priority",{}) 
    local ability = thisEntity:FindAbilityByName("BONUS_LIFE_AND_DMG")
    ability:SetLevel(1)
	Timers:CreateTimer(function()
        if not thisEntity:IsAlive() then return
        else ability_usage ()  return 1                --Repeat
        end
    end
    )
     
end

function ability_usage ()
    local ability = thisEntity:FindAbilityByName("BONUS_LIFE_AND_DMG")
    local manacost = ability:GetManaCost(ability:GetLevel())
    local current_mana = thisEntity:GetMana()
    if ability:IsCooldownReady() and current_mana >= manacost then
        local caster = thisEntity
        local pos =  caster:GetAbsOrigin()
        local range = ability:GetCastRange()
        local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, range, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
        for _,unit in pairs(units) do
            local loss = unit:GetMaxHealth() - unit:GetHealth()
            if loss >= 450 then
                caster:CastAbilityOnTarget(unit, ability, caster:GetPlayerOwnerID())
                break     
            end 
        end  
    end
end

function SetLevelAbility(hHero)
   local ability = hHero:GetAbilityByIndex("place_heal_tower")
   ability:SetLevel(hHero:GetLevel(1))
end