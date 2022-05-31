if WaveManager == nil then
    WaveManager = {}
end

-- Current state
_G.WaveManager.State = -1

-- States
_G.MADNESS_WAVE_STATE_DISABLED = -1
_G.MADNESS_WAVE_STATE_PRE_GAME = 0
_G.MADNESS_WAVE_STATE_PRE_ROUND_TIME = 1
_G.MADNESS_WAVE_STATE_WAITING_FOR_NEXT_ROUND = 3
_G.MADNESS_WAVE_STATE_ROUND_IN_PROGRESS = 4
_G.MADNESS_WAVE_STATE_POST_GAME = 5

_G.MADNESS_WAVE_STATE_FREEZED = 123


-- I'm too lazy... don't worry I'll do it later
SpawnTable = {
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_mud_seeker" },
        display_name = "Mud Seekers",
        wave_count=            8,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }   
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_wild_devourer" },
        display_name = "Wild Devourers",
        wave_count=            8,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_ultra_golem" },
        display_name = "[Boss] Mega Golem",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_jungle_hunter" },
        display_name = "Jungle Hunters",
        wave_count=            8,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_ogre_beast" },
        display_name = "Ogre Beasts",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_windrunner" },
        display_name = "[Boss] Windrunner",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_centaur_master" },
        display_name = "Centaur Master",
        wave_count=            12,
        interval=              8,
        each_min=              { 2, 5 },
        each_max=              { 5, 8 } 
    },  
    {
        unit_type_count=       2,
        units_name=            { "npc_dota_war_beast", "npc_dota_leader_war_beast" },
        display_name = "Leader War Beast and War Beast",
        wave_count=            12,
        interval=              8,
        each_min=              { 5, 2 },
        each_max=              { 8, 2 } 
    },
{
        unit_type_count=       1,
        units_name=            { "npc_dota_boss_lich" },
        display_name = "[Boss] Lich",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_evil_bat" },
        display_name = "Evil Bats",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_magic_killer" },
        display_name = "Magic killers",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_blooder" },
        display_name = "Blooders",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_axe_lord" },
        display_name = "[Boss] Axe Lord",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_wraith_caster"},
        display_name = "Wraith Casters",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_skeleton_warriors"},
        display_name = "Skeleton Warriors",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "npc_dota_sniper_proffesional"},
        display_name = "Snipers",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            {"npc_dota_madness_master"},
        display_name = "[Final Boss] Madness Master",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    }
}

-- Initalization
_G.defenseLoc = nil
_G.currentRound = 0
_G.roundTimerIsFinished = true
_G.roundEnded = true

_G.currentWaveCount = 0
_G.unitRemains = 0
_G.Boss = nil

-- KV Files
_G.DropList = LoadKeyValues('scripts/kv/drop_list.kv')
_G.ItemProperties = LoadKeyValues('scripts/npc/npc_items_custom.txt')


function WaveManager:Init()
    defenseLoc = Entities:FindByName( nil, 'defense_loc'):GetAbsOrigin()
    WaveManager.State = MADNESS_WAVE_STATE_PRE_GAME
    print('[WAVE MANAGER] State has changed to MADNESS_WAVE_STATE_PRE_GAME')

    SetBossNPC('npc_dota_ancient_guardian')
    ListenToGameEvent('entity_killed', Dynamic_Wrap(WaveManager, 'OnWaveEntityKilled'), self)

    -- Register Listener
    CustomGameEventManager:RegisterListener('Upgrade', Dynamic_Wrap(WaveManager, 'OnClickUpgrade'))

    -- Start think about "what's going on now"
    GameRules:GetGameModeEntity():SetThink( 'WaveThink', Abaddon, 0.3 )
end

function WaveManager:OnWaveEntityKilled( tData )
    local victim = EntIndexToHScript( tData.entindex_killed )
    local attacker = EntIndexToHScript( tData.entindex_attacker )

    if victim == Boss then
        GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )

        print('Boss died')
    end

    if victim.IsWaveUnit == true then
        if unitRemains > 1 then
            unitRemains = unitRemains - 1
        else -- To avoid unitRemains less than 0
            unitRemains = 0 
        end

        if roundTimerIsFinished and unitRemains < 1 then
            roundEnded = true
        end
        DropSystem:DropItem( victim, DropList, attacker )
    end
end

-- Do think every .3s to check state of wave
function Abaddon:WaveThink()
    if roundTimerIsFinished and roundEnded and WaveManager.State ~= MADNESS_WAVE_STATE_FREEZED then
        
        -- Reset some settings
        roundEnded = false
        currentWaveCount = 0
        unitRemains = 0
        
        -- Adjust points
        local points = CustomNetTables:GetTableValue('game_info', 'points')["point"]
        CustomNetTables:SetTableValue('game_info', 'points', {
            point = points + 1,
        })
        
        -- Start timer to start next round
        WaveManager.State = MADNESS_STATE_PRE_ROUND_TIME
        print('[WAVE MANAGER] State has changed to MADNESS_WAVE_STATE_PRE_ROUND_TIME')
        PopupTimer( 180 )

        if currentRound ~= 0 then
            local reward = {
                base = currentRound * 100,
                threshold = currentRound * 500
            }
            WaveManager:Reward( reward )
        end
    end

    return 1
end

function PopupTimer( iTime )
    timeStart = GameRules:GetDOTATime(false, false)
    timeEnd = GameRules:GetDOTATime(false, false) + iTime

    WaveManager.State = MADNESS_WAVE_STATE_WAITING_FOR_NEXT_ROUND
    print('[WAVE MANAGER] State has changed to MADNESS_WAVE_STATE_WAITING_FOR_NEXT_ROUND')

    CustomNetTables:SetTableValue('player_table', 'timer', {
      startTime = timeStart,
      endTime = timeEnd
    })
end

function SetTimeLeft( iNewTime )
  timeEnd = GameRules:GetDOTATime(false, false) + iNewTime
  CustomNetTables:SetTableValue('player_table', 'timer', {
    endTime = timeEnd
  })
end 

-- Start next round
function WaveManager:StartNextRound()
    if currentRound ~= 0 then
        Boss:CreatureLevelUp(1)
    elseif WaveManager.State == MADNESS_WAVE_STATE_FREEZED then
        return
    end

    roundTimerIsFinished = false
    currentRound = currentRound + 1

    local spawnInfo = SpawnTable[currentRound]
    if not spawnInfo then
        GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
        roundTimerIsFinished = true
    else
        local interval = spawnInfo["interval"]
        local wave_count = spawnInfo["wave_count"]
        local currentWaveCount = 0
        local countdown = interval

        WaveManager.State = MADNESS_WAVE_STATE_ROUND_IN_PROGRESS
        print('Wave state changed to MADNESS_WAVE_STATE_ROUND_IN_PROGRESS')

        Timers:CreateTimer(function()
            if not roundTimerIsFinished and currentWaveCount < wave_count then
                if countdown == 0 then
                   currentWaveCount = currentWaveCount + 1
                   self:SpawnUnits(spawnInfo, currentWaveCount)
                
                end
                if countdown == -1 then
                   countdown = interval
                end
                countdown = countdown - 1
                return 1
            else
                roundTimerIsFinished = true
                return
            end
        end)
    end
    
    if IsInToolsMode() then
        print('Debug info: ')
        print('Current Round: ', currentRound)
        print('Round Timer Is Finished: ', roundTimerIsFinished)
        print('Round Ended: ', roundEnded)
        print('Unit Remains: ', unitRemains)
        print('Boss Name: ', Boss:GetUnitName())
    end
end

-- Spawn Units
function WaveManager:SpawnUnits( tSpawnInfo, currentWaveCount )
    local unit_type_count = tSpawnInfo["unit_type_count"]
    local player_count = PlayerResource:GetNumConnectedHumanPlayers() + 1
    local creep_level = currentWaveCount
    local ability_level = creep_level

    if IsInToolsMode() then
        print('Unit type count', unit_type_count)
        print('Player Count', player_count)
        print('Creep level', creep_level)
        print('Ability Level', ability_level)
    end

    for i = 1, unit_type_count do
        local min = tSpawnInfo["each_min"]
        local max = tSpawnInfo["each_max"]
        local count_each_wave_road = RandomInt(min[i], max[i])   
        local unit_name = tSpawnInfo["units_name"]
        unit_name = unit_name[i]

        print('Min max values: ', min, max)
        print('Count each wave road: ', count_each_wave_road)
        print('Unit Name: ', unit_name)

        for j=1, player_count do
            local SpawnPoint = Vector(RandomInt(-150, 250), RandomInt(-150, 250)) + Entities:FindByName(nil, 'spawn_location_'..j):GetAbsOrigin()
            for k=1, count_each_wave_road do
                local SpawnUnit = CreateUnitByName(unit_name, SpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS)
                SpawnUnit.IsWaveUnit = true
                SpawnUnit:CreatureLevelUp(creep_level-1)         --Level Up
                print('Unit Handle: ', SpawnUnit)
                print('Unit Name: ', SpawnUnit:GetUnitName())
                print('Unit location:', SpawnUnit:GetAbsOrigin())
                MinimapEvent(DOTA_TEAM_GOODGUYS, nil, SpawnPoint.x, SpawnPoint.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10)

                for r=0, SpawnUnit:GetAbilityCount()-1 do
                    local ability = SpawnUnit:GetAbilityByIndex(r)
                    if ability ~= nil then
                        ability:SetLevel(ability_level)
                    end
                end 
                ExecuteOrderFromTable({
                    UnitIndex = SpawnUnit:entindex(),
                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                    Position  = defenseLoc,
                    Queue     = true 
                })

                print('Spawned')
            end 
        end
        unitRemains = unitRemains + (count_each_wave_road * player_count)
        print('Changed', unitRemains)
    end

    if IsInToolsMode() then
        print('[DEBUGGER] Current Round: ', currentRound)
        print('[DEBUGGER] Round Timer Is Finished: ', roundTimerIsFinished)
        print('[DEBUGGER] Round Ended: ', roundEnded)
        print('[DEBUGGER] Unit Remains: ', unitRemains)
        print('[DEBUGGER] Boss Name: ', Boss:GetUnitName())
    end
end

-- Click
function WaveManager:OnClickUpgrade( data )
    local abilityName = data.abilityName
    local keyValues = LoadKeyValues('scripts/npc/ancient/ancient_upgrades.txt')
    local pointsAbility = keyValues[abilityName]["NeedPoints"]
    local needPointsToLearn = {}
    for needPoints in string.gmatch(pointsAbility, "[^%s]+") do
        table.insert(needPointsToLearn, needPoints) -- Put it in table
    end
    

    local points = CustomNetTables:GetTableValue('game_info', 'points')["point"]
    if Boss:HasAbility(abilityName) then
        local ability = Boss:FindAbilityByName(abilityName)
        if tonumber(needPointsToLearn[ability:GetLevel()]) and points >= tonumber(needPointsToLearn[ability:GetLevel()]) and ability:GetLevel() ~= ability:GetMaxLevel() then
            ability:SetLevel( ability:GetLevel() + 1 )

            -- Adjust num of points
            CustomNetTables:SetTableValue('game_info', 'points', {
                point = points - tonumber(needPointsToLearn[ability:GetLevel()])
            })

            -- Feedback to Panorama UI
            CustomGameEventManager:Send_ServerToAllClients('UpdatePanel', {
                abilityName = data.abilityName,
                abilityLevel = ability:GetLevel(),
                abilityMaxLevel = ability:GetMaxLevel(),

                needPointsToNext = tonumber(needPointsToLearn[ability:GetLevel() + 1]),
                points = points,
                bUpgradeFailed = false
            })
            print('Upgraded')
        end
    else
        if points >= tonumber(needPointsToLearn[1]) then
            -- Create ability and set level
            local ability = Boss:AddAbility(abilityName)
            ability:SetLevel( ability:GetLevel() + 1 )

            -- Adjust num of points
            CustomNetTables:SetTableValue('game_info', 'points', {
                point = points - tonumber(needPointsToLearn[ability:GetLevel()]),
            })

            -- Feedback to Panorama UI
            CustomGameEventManager:Send_ServerToAllClients('UpdatePanel', {
                abilityName = data.abilityName,
                abilityLevel = ability:GetLevel(),
                abilityMaxLevel = ability:GetMaxLevel(),

                needPointsToNext = tonumber(needPointsToLearn[ability:GetLevel() + 1]),
                bUpgradeFailed = false,
            })

            print('Learned')
        end
    end
end

-- Reward all players
function WaveManager:Reward( tReward )
    for i=0, DOTA_MAX_PLAYER_TEAMS do   
        if PlayerResource:IsValidPlayer(i) then
            local gained = PlayerResource:GetTotalEarnedGold(i)
            local support = math.max(0, tReward.threshold - gained)
            local total = tReward.base + support
            Timers:CreateTimer(1.5, function()
                PlayerResource:ModifyGold(i, total, true, 0)
            end)
        end
    end
end

-- Additional functions

-- Get State of Wave
function WaveManager:StateGet()
    return WaveManager.State
end

-- Change num of points
function WaveManager:SetNumOfPoints( iPoints )
    CustomNetTables:SetTableValue('game_info', 'points', {
        points = iPoints
    })
end

-- Set new boss npc
function SetBossNPC( sName )
    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, defenseLoc, nil, 600,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,0,false)
    for _,unit in pairs(units) do
        if unit:GetUnitName() == sName then
            Boss = unit
            break
        end
    end
end

-- Is Round finished?
function WaveManager:IsRoundFinished()
    return roundEnded
end

-- Is Round timer is finished?
function WaveManager:IsRoundTimerFinished()
    return roundTimerIsFinished
end

-- Debug functions
-- Skips wave
function WaveManager:SkipWave()
    roundTimerIsFinished = true
    roundEnded = true
    unitRemains = 0

    self:KillAllWaveUnits()
end

-- Freezes the wave cycle
function WaveManager:FreezeWaveManager()
    WaveManager.State = MADNESS_WAVE_STATE_FREEZED
    
    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, defenseLoc, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    for _, unit in pairs( units ) do
        if unit.IsWaveUnit and not unit:IsRealHero() then
            unit:AddNewModifier(unit, nil, "modifier_stunned", {})
        end
    end

    print('[DEBUGGER] Wave manager freezed')
end

-- Unfreezes the wave cycle
function WaveManager:UnfreezeWaveManager()
    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, defenseLoc, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    for _, unit in pairs( units ) do
        if unit.IsWaveUnit and not unit:IsRealHero() then
            unit:RemoveModifierByName('modifier_stunned')
        end
    end

    if unitRemains > 1 then
        WaveManager.State = MADNESS_WAVE_STATE_ROUND_IN_PROGRESS
    elseif self:IsRoundFinished() and self:IsRoundTimerFinished() then
        WaveManager.State = MADNESS_WAVE_STATE_PRE_ROUND_TIME
    end

    print('[DEBUGGER] Wave manager freezed')
end

-- Set round to num
function WaveManager:SetWave( iRound )
    currentRound = iRound
    roundEnded = true
    roundTimerIsFinished = true
    unitRemains = 0

    self:KillAllWaveUnits()
end

function WaveManager:KillAllWaveUnits()
    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    for _, unit in pairs( units ) do
        if unit.IsWaveUnit then
            unit:ForceKill( false )
        end
    end
end