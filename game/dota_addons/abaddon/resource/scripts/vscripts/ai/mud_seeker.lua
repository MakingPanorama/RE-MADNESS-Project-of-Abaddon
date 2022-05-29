function Spawn( entityKeyValues )
    if not IsServer() then return end
	if thisEntity == nil then return end

    thisEntity.ThrowRock = thisEntity:FindAbilityByName('mud_seeker_throw_rock')
    if thisEntity:GetTeamNumber() == DOTA_TEAM_NEUTRALS then

        -- Close to normal neutral behavior
        thisEntity.Sleeping = false
        thisEntity.LastAttacked = 0
        thisEntity.GoingBackToHome = false
        thisEntity.ChasingTarget = nil
        thisEntity.ChaseTime = 0

        thisEntity:SetContextThink('NeutralAIThink', NeutralAIThink, 0.2)
        ListenToGameEvent('entity_hurt', NeutralAIHurt, nil)

        return
    else    
        thisEntity:SetContextThink('UnitThinkAI', AIThink, 0.2)
    end
end

function AIThink()
    if thisEntity:IsAlive() == false then
        return nil
    end

    attack()
    local weakestEnemy = AICore:WeakestEnemyHeroInRange( thisEntity, 450, false, false )
    if weakestEnemy ~= nil then
        ThrowRock( weakestEnemy )
        
        return 0.75
    end

    local randomHero = AICore:RandomEnemyHeroInRange( thisEntity, 450, true, true )
    if randomHero ~= nil then
        thisEntity:MoveToTargetToAttack( randomHero )

        return 0.75
    end
    return 0.2
end

-- Neutral AI Behavior
function NeutralAIThink()
    -- Try to release an original behavior of neutral creeps
    if thisEntity:IsAlive() == false then return nil end

    local dx = thisEntity.HomeOrigin.x - thisEntity:GetAbsOrigin().x
    local dy = thisEntity.HomeOrigin.y - thisEntity:GetAbsOrigin().y
    local distance = math.sqrt( dx * dx + dy * dy )
    local enemies = FindUnitsInRadius(
        thisEntity:GetTeamNumber(),
        thisEntity:GetOrigin(),
        thisEntity,
        150,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false )

    if distance > 450 then
        print( thisEntity.ChaseTime + 4, GameRules:GetGameTime() )

        thisEntity.GoingBackToHome = true
        thisEntity.ChaseTime = 0
        thisEntity.Chasing = nil
        ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = thisEntity.HomeOrigin
        })

        return 0.2
    end

    if thisEntity.LastAttacked ~= 0 and thisEntity.GoingBackToHome ~= true and thisEntity.Chasing == nil and thisEntity.LastAttacked + 4 < GameRules:GetGameTime() and GameRules:IsDaytime() == false then
        thisEntity.Sleeping = true

        print('Sleeping')
        return 0.45
    end

    if thisEntity.ChaseTime ~= 0 and thisEntity.ChaseTime + 3 <= GameRules:GetGameTime() then
        ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = thisEntity.HomeOrigin
        })
        
        thisEntity.Chasing = nil
        thisEntity.ChaseTime = 0
        thisEntity.GoingBackToHome = true

        print('Going back to home')
        return 0.45
    end

    if GameRules:IsDaytime() and thisEntity.GoingBackToHome ~= true and thisEntity.Chasing == nil then
        local closestEnemy = AICore:ClosestEnemyHeroInRange( 150, false, true, false )
        if closestEnemy then
            ExecuteOrderFromTable({
                UnitIndex = thisEntity:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                TargetIndex = closestEnemy:entindex(),
                Queue = true,
            })

            print('Chase time before: ', thisEntity.ChaseTime)
            thisEntity.ChaseTime = GameRules:GetGameTime()
            print('Chase time after:', thisEntity.ChaseTime)
            thisEntity.Chasing = closestEnemy
            thisEntity.Sleeping = false

        end
        return 0.75
    else
        if thisEntity.Chasing == nil and thisEntity.GoingBackToHome ~= true and thisEntity.LastAttacked == 0 and GameRules:IsDaytime() == false then
            thisEntity.LastAttacked = 0
            thisEntity.ChaseTime = 0
            thisEntity.Sleeping = true

            return 0.2
        end
    end

    if thisEntity:GetAggroTarget() and thisEntity:GetAggroTarget():GetUnitName() == "npc_dota_guardian_tower" then
        ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = thisEntity.HomeOrigin
        })

        thisEntity.Chasing = nil
        thisEntity.ChaseTime = 0
        thisEntity.GoingBackToHome = true

        return 0.45
    end

    return 0.2
end

function NeutralAIHurt( event )
    local attacker = EntIndexToHScript( event.entindex_attacker )
    local victim = EntIndexToHScript( event.entindex_killed )
    local damage = event.damage

    if victim == thisEntity and GameRules:IsDaytime() == false and thisEntity.GoingBackToHome ~= true then
        if not victim:IsInvisible() then
            ExecuteOrderFromTable({
                UnitIndex = thisEntity:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                TargetIndex = attacker:entindex(),
                Queue = true,
            })
            print('Attacked from non-invis')

            thisEntity.ChaseTime = GameRules:GetGameTime()
            thisEntity.Chasing = attacker

        else
            thisEntity.ChaseTime = GameRules:GetGameTime()
            thisEntity.Chasing = victim -- Not actually chasing victim, but it tries to find inflictor
            ExecuteOrderFromTable({
                UnitINdex = thisEntity:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                TargetIndex 
            })

            print('Attacked from invis')
        end
        
        thisEntity.LastAttacked = GameRules:GetGameTime()
        thisEntity.Sleeping = false
    end
end

-- Ability
function ThrowRock( hEnemy )
    if thisEntity.ThrowRock:IsCooldownReady() then
        thisEntity:CastAbilityOnTarget(hEnemy, thisEntity.ThrowRock, thisEntity:GetPlayerOwnerID())
    end
end

function attack()
    local caster = thisEntity
    local base_location=Entities:FindByName( nil, "defense_loc"):GetAbsOrigin()
    ExecuteOrderFromTable({
        UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
        Position  = base_location,
        Queue     = true,
    })  
end