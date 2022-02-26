function Spawn( entityKeyValues )
    if not IsServer() then return end
	if thisEntity == nil then return end

    thisEntity.ThrowRock = thisEntity:FindAbilityByName('mud_seeker_throw_rock')
    thisEntity:SetContextThink('UnitThinkAI', AIThink, 0.2)
end

function AIThink()
    if thisEntity:IsAlive() == false then
        return nil
    end

    attack()
    local weakestEnemy = AICore:WeakestEnemyHeroInRange( thisEntity, 450, true, false )
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