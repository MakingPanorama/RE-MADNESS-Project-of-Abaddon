require('libraries/util')

-- A build ability is used (not yet confirmed)
function Build( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local building_name = ability:GetAbilityKeyValues()['UnitName']
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
    local playerID = hero:GetPlayerOwnerID()
    local gold_cost = ability:GetSpecialValueFor("gold_cost")
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

    -- Makes a building dummy and starts panorama ghosting
    BuildingHelper:AddBuilding(event)

    -- Additional checks to confirm a valid building position can be performed here
    event:OnPreConstruction(function(vPos)

        -- Check for minimum height if defined
        if not BuildingHelper:MeetsHeightCondition(vPos) then
            SendErrorMessage(playerID, "#error_invalid_build_position")
            return false
        end

        -- If not enough resources to queue, stop
        if PlayerResource:GetGold(playerID) < gold_cost then
            SendErrorMessage(playerID, "#error_not_enough_gold")
            return false
        end
        if PlayerResource:GetLumber(playerID) < lumber_cost then
            SendErrorMessage(playerID, "#error_not_enough_lumber")
            return false
        end

        return true
    end)

    -- Position for a building was confirmed and valid
    event:OnBuildingPosChosen(function(vPos)
        PlayerResource:ModifyGold(hero,-gold_cost)
        PlayerResource:ModifyLumber(hero,-lumber_cost)
        EmitSoundOnClient("DOTA_Item.ObserverWard.Activate", PlayerResource:GetPlayer(playerID))
    end)

    -- The construction failed and was never confirmed due to the gridnav being blocked in the attempted area
    event:OnConstructionFailed(function()
        --local playerTable = BuildingHelper:GetPlayerTable(playerID)
        --local name = playerTable.activeBuilding or " "
        --BuildingHelper:print("Failed placement of " .. name)
    end)

    -- Cancelled due to ClearQueue
    event:OnConstructionCancelled(function(work)
        local name = work.name
        BuildingHelper:print("Cancelled construction of " .. name)
        -- Refund resources for this cancelled work
        if work.refund and work.refund == true and not work.repair then
            PlayerResource:ModifyGold(hero,gold_cost,true)
            PlayerResource:ModifyLumber(hero,lumber_cost,true)
        end
    end)

    -- A building unit was created
    event:OnConstructionStarted(function(unit)
        BuildingHelper:print("Started construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
        unit.gold_cost = gold_cost
        unit.lumber_cost = lumber_cost
        unit:AddNewModifier(unit,nil,"modifier_phased",{}) 
        -- If it's an item-ability and has charges, remove a charge or remove the item if no charges left
        if ability.GetCurrentCharges and not ability:IsPermanent() then
            local charges = ability:GetCurrentCharges()
            charges = charges-1
            if charges == 0 then
                ability:RemoveSelf()
            else
                ability:SetCurrentCharges(charges)
            end
        end
        --unit:RemoveModifierByName("modifier_invulnerable")
        unit:AddNewModifier(nil, nil, "modifier_stunned", {})
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
        caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})

        local unitName = unit:GetUnitName()
        ModifyStartedConstructionBuildingCount(hero, unitName, 1)
        table.insert(hero.units, unit)
        AddUpgradeAbilities(unit)
        UpdateSpells(hero)

        local item = CreateItem("item_building_cancel", unit, unit)
        unit:AddItem(item)

        for i=0, unit:GetAbilityCount()-1 do
            local ability = unit:GetAbilityByIndex(i)
            if ability then
                local constructionStartModifiers = GetAbilityKV(ability:GetAbilityName(), "ConstructionStartModifiers")
                if constructionStartModifiers then
                    for k,modifier in pairs(constructionStartModifiers) do
                        ability:ApplyDataDrivenModifier(unit, unit, modifier, {})
                    end
                end
            end
        end
    end)

    -- A building finished construction
    event:OnConstructionCompleted(function(unit)
        BuildingHelper:print("Completed construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex() .. " " .. tostring(unit))
        unit.state = "complete"
        unit.ancestors = {}
        local item = unit:GetItemInSlot(0)
        if item then
            UTIL_Remove(item)
        end

        local unitName = unit:GetUnitName()
        ModifyCompletedConstructionBuildingCount(hero, unitName, 1)

        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end

        -- Give the unit their original attack capability
        unit:RemoveModifierByName("modifier_stunned")
        local itemBuildingDestroy = CreateItem("item_building_destroy", nil, nil)
        unit:AddItem(itemBuildingDestroy)
        unit.attackers = {}

        for i=0, unit:GetAbilityCount()-1 do
            local buildingAbility = unit:GetAbilityByIndex(i)
            if buildingAbility then
                local constructionCompleteModifiers = GetAbilityKV(buildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
                if constructionCompleteModifiers then
                    for k,modifier in pairs(constructionCompleteModifiers) do
                        buildingAbility:ApplyDataDrivenModifier(unit, unit, modifier, {})
                    end
                end
            end
        end

        local player = unit:GetPlayerOwner()
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "unit_upgrade_complete", { })
        end

    end)

    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't fire multiple times unnecessarily.
    event:OnBelowHalfHealth(function(unit)
        --BuildingHelper:print("" .. unit:GetUnitName() .. " is below half health.")
    end)

    event:OnAboveHalfHealth(function(unit)
        --BuildingHelper:print("" ..unit:GetUnitName().. " is above half health.")        
    end)
end

-- Called when the Cancel ability-item is used
function CancelBuilding( keys )
    DebugPrint("Trying to cancel!")
    local building = keys.unit
    local hero = building:GetOwner()

    BuildingHelper:print("CancelBuilding "..building:GetUnitName().." "..building:GetEntityIndex())

    -- Refund here
    PlayerResource:ModifyGold(hero,building.gold_cost,true)
    PlayerResource:ModifyLumber(hero,building.lumber_cost,true)

    -- Eject builder
    local builder = building.builder_inside
    if builder then
        BuildingHelper:ShowBuilder(builder)
    end

    building:ForceKill(true)
    Timers:CreateTimer(5,function()
        UTIL_Remove(building)    
    end)
end

function DestroyBuilding( keys )
    local building = keys.unit
    local units = FindUnitsInRadius(building:GetTeamNumber() , building:GetAbsOrigin() , nil , 1500 , DOTA_UNIT_TARGET_TEAM_ENEMY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    local playerID = building:GetMainControllingPlayer()
    if #units > 0 then
        SendErrorMessage(playerID, "#error_enemy_nearby")
    else
        building:ForceKill(false)
    end
end

function UpgradeBuilding( event )
    local building = event.caster
    local NewBuildingName = event.NewName
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local upgrades = GetUnitKV(building:GetUnitName(),"Upgrades")
    local buildTime = GetUnitKV(NewBuildingName,"BuildTime")
    local gold_cost
    local lumber_cost
    -- I do it like this so you are able to have two buildings upgrade into the same upgraded building with different prices and only having one ability
    local count = tonumber(upgrades.Count)
    for i = 1, count, 1 do
        local upgrade = upgrades[tostring(i)]
        local upgraded_unit_name = upgrade.unit_name
        if upgraded_unit_name == NewBuildingName then
            gold_cost = upgrade.gold_cost
            lumber_cost = upgrade.lumber_cost
        end
    end
    if gold_cost > PlayerResource:GetGold(playerID) then
        SendErrorMessage(playerID, "#error_not_enough_gold")
        return false
    end
    if lumber_cost > PlayerResource:GetLumber(playerID) then
        SendErrorMessage(playerID, "#error_not_enough_lumber")
        return false
    end
    local newBuilding = BuildingHelper:UpgradeBuilding(building,NewBuildingName)
    local newBuildingName = newBuilding:GetUnitName()
    newBuilding.state = "complete"

    newBuilding.ancestors = building.ancestors
    table.insert(newBuilding.ancestors,building:GetUnitName())
    for _, ancestorUnitName in pairs(newBuilding.ancestors) do
        ModifyStartedConstructionBuildingCount(hero, ancestorUnitName, 1)
        ModifyCompletedConstructionBuildingCount(hero, ancestorUnitName, 1)
    end
    table.insert(hero.units, newBuilding)
    ModifyStartedConstructionBuildingCount(hero, newBuildingName, 1)

    local ability = event.ability
    local skips = GetAbilityKV(ability:GetAbilityName(),"SkipRequirements")
    if skips then
        for _, skipUnitName in pairs(skips) do
            ModifyStartedConstructionBuildingCount(hero, skipUnitName, 1)
            ModifyCompletedConstructionBuildingCount(hero, skipUnitName, 1)
        end
    end
    
    PlayerResource:ModifyGold(hero,-gold_cost)
    PlayerResource:ModifyLumber(hero,-lumber_cost)
    AddUpgradeAbilities(newBuilding)
    for i=0, newBuilding:GetAbilityCount()-1 do
        local newBuildingAbility = newBuilding:GetAbilityByIndex(i)
        if newBuildingAbility then
            local constructionCompleteModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
            if constructionCompleteModifiers then
                for _, modifier in pairs(constructionCompleteModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
            local constructionStartModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionStartModifiers")
            if constructionStartModifiers then
                for _, modifier in pairs(constructionStartModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
        end
    end
    building:ForceKill(true) --This will call RemoveBuilding
    Timers:CreateTimer(buildTime,function()
        if newBuilding:IsNull() or not newBuilding:IsAlive() then
            return
        end
        newBuilding:RemoveModifierByName("modifier_stunned")
        if not string.match(newBuildingName,"troll_hut") then
            local item = CreateItem("item_building_destroy", nil, nil)
            newBuilding:AddItem(item)
        end
        ModifyCompletedConstructionBuildingCount(hero, newBuildingName, 1)
        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end
    end)
end
