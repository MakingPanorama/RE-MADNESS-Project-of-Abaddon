  -- PLACE TOWER 

    -- Константа
PLACED_BUILDING_RADIUS = 0;

function placeSingleBuilding(keys)
    -- Нам потребуется несколько переменных
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_speed_tower", keys.target_points[1], false, nil, nil, keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
        else 
            keys.caster:ModifyGold(5,true,0)
    end
end 

function placehealBuilding(keys)
    -- Нам потребуется несколько переменных
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_heal_tower", keys.target_points[1], false, nil, nil, keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
        else 
            keys.caster:ModifyGold(5,true,0)
    end
end


function placeGOLDBuilding(keys)
    -- Нам потребуется несколько переменных
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_dota_gold_mine", keys.target_points[1], false, nil, nil, keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
        else 
            keys.caster:ModifyGold(5,true,0)
    end
end


function placespeedBuilding(keys)
    -- Нам потребуется несколько переменных
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_speed_tower", keys.target_points[1], false, nil, nil, keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
        else 
            keys.caster:ModifyGold(5,true,0)
    end
end 

 

function placeShotBuilding(keys)
    -- Нам потребуется несколько переменных
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_shot_tower", keys.target_points[1], false, nil, nil, keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
        else 
            keys.caster:ModifyGold(20,true,0)
    end
end 

function placeAoeBuilding(keys)
    -- Нам потребуется несколько переменных, они должны быть понятны
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_aoe_tower", keys.target_points[1], false, nil, nil,keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
    else 
        keys.caster:ModifyGold(15,true,0)
    end
end 

function placeSlowBuilding(keys)
    -- Нам потребуется несколько переменных, они должны быть понятны
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_slow_tower", keys.target_points[1], false, nil, nil,keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
        else 
            keys.caster:ModifyGold(35,true,0)
    end
end 

function placeAuraBuilding(keys)
    -- Нам потребуется несколько переменных, они должны быть понятны
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- В основном, эта строка находит все объекты внутри PLACED_BUILDING_RADIUS от того, где мы хотим поставить башню
    -- Цикл для подсчета
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        blocking_counter = blocking_counter + 1
    end
    print(blocking_counter .. " blockers")

    -- Если есть объекты, которые мешают размещению башни, тогда не строим здесь, иначе - размещаем
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_aura_tower", keys.target_points[1], false, nil, nil,keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetOwner(keys.caster)
        print(keys.caster:GetPlayerOwnerID())
        tower:SetControllableByPlayer( keys.caster:GetPlayerOwnerID(), true )
        else 
            keys.caster:ModifyGold(150,true,0)
    end
end 

-- SELL TOWER

function SellTower( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    --ShowMessage("Let the game begin.")
    --Say(hero_1,"I'm back.",false)
    --Say(thisEntity,"I'm back.",false)
    --hero_1:AddItem("item_rapier")
    hero:ModifyGold(tower:GetLevel()/2,true,0)
    destroy_Unit(tower)
end

function destroy_Unit(unit)
    position = GetGroundPosition(unit:GetCenter(),nil)
    local unit_radius_good = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, position, nil, 0.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
    for k,v in ipairs(unit_radius_good) do -- key и val. На каждом шаге цикла переменная key получает ключ очередного поля таблицы unit_radius_good, а переменная val — соответствующее ключу значение поля. В список выражений входит только один элемент — вызов функции-фабрики итераторов pairs.
        v:ForceKill(true) -- Немедленно уничтожить 
    end
end

-- UPGRADE

function refund_upgrade_tower( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    local ability = entityKeyValues.ability
    --ShowMessage("Let the game begin.")
    --Say(hero_1,"I'm back.",false)
    --Say(thisEntity,"I'm back.",false)
    --hero_1:AddItem("item_rapier")
    --local ability = hero:FindAbilityByName("templar_create_tower_air")
    hero:ModifyGold(ability:GetGoldCost(ability:GetLevel()-1),true,0)
end

function UpgradeTowerSingle( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    local ability = entityKeyValues.ability
    if ability:GetAbilityName() == "tower_upgrade_single_tower_1" then
        local creature = CreateUnitByName( "npc_single_tower_1" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_single_tower_2" then
        local creature = CreateUnitByName( "npc_single_tower_2" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_single_tower_3" then
        local creature = CreateUnitByName( "npc_single_tower_3" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_single_tower_4" then
        local creature = CreateUnitByName( "npc_single_tower_4" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_single_tower_5" then
        local creature = CreateUnitByName( "npc_single_tower_5" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_single_tower_6" then
        local creature = CreateUnitByName( "npc_single_tower_6" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_single_tower_7" then
        local creature = CreateUnitByName( "npc_single_tower_7" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_rebuild_single_tower_7" then
        local creature = CreateUnitByName( "npc_single_tower_7" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    end
end

function UpgradeTowerAOE( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    local ability = entityKeyValues.ability
    if ability:GetAbilityName() == "tower_upgrade_aoe_tower_1" then
        local creature = CreateUnitByName( "npc_aoe_tower_1" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_aoe_tower_2" then
        local creature = CreateUnitByName( "npc_aoe_tower_2" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_aoe_tower_3" then
        local creature = CreateUnitByName( "npc_aoe_tower_3" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_aoe_tower_4" then
        local creature = CreateUnitByName( "npc_aoe_tower_4" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_aoe_tower_5" then
        local creature = CreateUnitByName( "npc_aoe_tower_5" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_rebuild_aoe_tower_5" then
        local creature = CreateUnitByName( "npc_aoe_tower_5" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    end
end

function UpgradeTowerShot( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    local ability = entityKeyValues.ability
    if ability:GetAbilityName() == "tower_upgrade_shot_tower_1" then
        local creature = CreateUnitByName( "npc_shot_tower_1" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_shot_tower_2" then
        local creature = CreateUnitByName( "npc_shot_tower_2" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_shot_tower_3" then
        local creature = CreateUnitByName( "npc_shot_tower_3" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_rebuild_shot_tower_3" then
        local creature = CreateUnitByName( "npc_shot_tower_3" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    end
end

function UpgradeTowerSlow( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    local ability = entityKeyValues.ability
    if ability:GetAbilityName() == "tower_upgrade_slow_tower_1" then
        local creature = CreateUnitByName( "npc_slow_tower_1" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_slow_tower_2" then
        local creature = CreateUnitByName( "npc_slow_tower_2" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_rebuild_slow_tower_2" then
        local creature = CreateUnitByName( "npc_slow_tower_2" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    end
end

function UpgradeTowerSpeedAura( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    local ability = entityKeyValues.ability
    if ability:GetAbilityName() == "tower_upgrade_speed_aura" then
        local creature = CreateUnitByName( "npc_speed_aura_tower" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_speed_aura_1" then
        local creature = CreateUnitByName( "npc_speed_aura_tower_1" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_speed_aura_2" then
        local creature = CreateUnitByName( "npc_speed_aura_tower_2" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    end
end

function UpgradeTowerDmgAura( entityKeyValues )
    local tower = entityKeyValues.caster
    local hero = PlayerResource:GetSelectedHeroEntity(tower:GetPlayerOwnerID())
    local ability = entityKeyValues.ability
    if ability:GetAbilityName() == "tower_upgrade_dmg_aura" then
        local creature = CreateUnitByName( "npc_dmg_aura_tower" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_dmg_aura_1" then
        local creature = CreateUnitByName( "npc_dmg_aura_tower_1" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    elseif ability:GetAbilityName() == "tower_upgrade_dmg_aura_2" then
        local creature = CreateUnitByName( "npc_dmg_aura_tower_2" , GetGroundPosition(tower:GetCenter(),nil), false, nil, nil, DOTA_TEAM_GOODGUYS )
        creature:SetOwner(hero)
        creature:SetControllableByPlayer(hero:GetPlayerID(), true)
        creature:SetAngles(0,90,0)
        tower:ForceKill(true)
    end
end