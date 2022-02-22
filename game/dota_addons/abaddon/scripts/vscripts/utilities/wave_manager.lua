-- You can get full version only if you ask about that to author

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


-- Spawn list
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
        units_name=            { "ULTRA GOLEM" },
        display_name = "[Boss] Mega Golem",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "Jungle Hunter" },
        display_name = "Jungle Hunters",
        wave_count=            8,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "Ogre Beast" },
        display_name = "Ogre Beasts",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "windrunner" },
        display_name = "[Boss]Windrunner",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       2,
        units_name=            { "Centaur Master", "Centaur_Suicide" },
        display_name = "Centaur Master and Centraur Suicide",
        wave_count=            12,
        interval=              8,
        each_min=              { 2, 5 },
        each_max=              { 5, 8 } 
    },  
    {
        unit_type_count=       2,
        units_name=            { "War Beast", "Leader_War_Beast" },
        display_name = "Leader War Beast and War Beast",
        wave_count=            12,
        interval=              8,
        each_min=              { 5, 2 },
        each_max=              { 8, 2 } 
    },
{
        unit_type_count=       1,
        units_name=            { "boss_lich" },
        display_name = "[Boss] Lich",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "Evil Bat" },
        display_name = "Evil Bats",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "Magical Killer" },
        display_name = "Magic killers",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "blooder" },
        display_name = "Blooders",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "Axe Lord" },
        display_name = "[Boss] Axe Lord",
        wave_count=            1,
        interval=              10,
        each_min=              { 1 },
        each_max=              { 1 } 
    },
    {
        unit_type_count=       1,
        units_name=            { "Wraith Caster"},
        display_name = "Wraith Casters",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "Skeleton Warrior"},
        display_name = "Skeleton Warriors",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            { "Professional Sniper"},
        display_name = "Snipers",
        wave_count=            12,
        interval=              8,
        each_min=              { 5 },
        each_max=              { 8 }
    },
    {
        unit_type_count=       1,
        units_name=            {"MADNESSMaster"},
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
_G.roundEnded = false

_G.currentWaveCount = 0
_G.unitRemains = 0
_G.Boss = nil

function WaveManager:Init()
    defenseLoc = Entities:FindByName( nil, 'defense_loc'):GetAbsOrigin()
    WaveManager.State = MADNESS_WAVE_STATE_PRE_GAME
    print('Wave state changed to MADNESS_WAVE_STATE_PRE_GAME')

    SetBossNPC('npc_dota_ancient_guardian')
    ListenToGameEvent('entity_killed', Dynamic_Wrap(WaveManager, 'OnWaveEntityKilled'), self)
    if IsInToolsMode() then
        print('Debug info: ')
        print('Current Round: ', currentRound)
        print('Round Timer Is Finished: ', roundTimerIsFinished)
        print('Round Ended: ', roundEnded)
        print('Unit Remains: ', unitRemains)
        print('Boss Name: ', Boss:GetUnitName())
    end

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

    if victim:IsWaveUnit() then
        if unitRemains > 1 then
            unitRemains = unitRemains - 1
        else -- To avoid unitRemains less than 0
            unitRemains = 0 
        end
        DropSystem:DropItem( victim )

        print('Victim is a wave unit')
    end

    if unitRemains < 1 then
        local wave_count = spawnInfo["wave_count"]

        -- We're need to make sure it's last wave otherwise a new round will begin, which shouldn't have happened.
        if currentWaveCount == wave_count then
            roundEnded = true
            roundTimerIsFinished = true

            print('Round ended')
        end
    end
end

-- Do think every .3s to check state of wave
function Abaddon:WaveThink()
    if roundTimerIsFinished and roundEnded then
        
        -- Reset some settings
        roundEnded = false
        currentWaveCount = 0
        unitRemains = 0

        WaveManager.State = MADNESS_STATE_PRE_ROUND_TIME
        print('Wave state changed to MADNESS_WAVE_STATE_PRE_ROUND_TIME')
        self:PopupTimer( 30 )

        if currentRound ~= 0 then
            local reward = {
                base = current_round * 100,
                threshold = current_round * 500
            }
            WaveManager:Reward( reward )
        end
    end

    return 1
end

function WaveManager:PopupTimer( iTime )
    timeStart = GameRules:GetDOTATime(false, false)
    timeEnd = GameRules:GetDOTATime(false, false) + iTime

    WaveManager.State = MADNESS_WAVE_STATE_WAITING_FOR_NEXT_ROUND

    CustomNetTables:SetTableValue('player_table', 'timer', {
      startTime = timeStart,
      endTime = timeEnd
    })
end

function WaveManager:SetTimeLeft( iNewTime )
  timeStart = GameRules:GetDOTATime(false, false)
  timeEnd = GameRules:GetDOTATime(false, false) + iNewTime
  CustomNetTables:SetTableValue('player_table', 'timer', {
    startTime = timeStart,
    endTime = timeEnd
  })
end 

-- Start next round
function WaveManager:StartNextRound()
    if currentRound ~= 0 then
        AncientBase:CreatureLevelUp(1)
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
            if not current_round_timer_finished and currentWaveCount < wave_count then
                if countdown == 0 then
                   currentWaveCount = currentWaveCount + 1
                   self:SpawnWave(spawnInfo, currentWaveCount)
                
                end
                if countdown == -1 then
                   countdown = interval
                end
                countdown = countdown - 1
                return 1
            else
                current_round_timer_finished = true
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
function WaveManager:SpawnUnits( tSpawnInfo, currentWaveCount)
    local unit_type_count = Spawn_Info["unit_type_count"]
    local player_count = PlayerResource:GetTeamPlayerCount()
    local creep_level = currentWaveCount
    local ability_level = creep_level
    for i = 1, unit_type_count do
        local min = Spawn_Info["each_min"]
        local max = Spawn_Info["each_max"]
        local count_each_wave_road = RandomInt(min[i], max[i])   
        local unit_name = Spawn_Info["units_name"]
        unit_name = unit_name[i]
        for j=1, player_count do
            local SpawnPoint = Vector(RandomInt(-350, 350), RandomInt(-350, 350)) + Entities:FindAllByName('spawn_location_'..j)
            for k=1, count_each_wave_road do
                local SpawnUnit = CreateUnitByName(unit_name, SpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS)
                SpawnUnit.IsWaveUnit = true
                SpawnUnit:CreatureLevelUp(creep_level-1)         --Level Up 
                for r=0, SpawnUnit:GetAbilityCount()-1 do
                    local ability = SpawnUnit:GetAbilityByIndex(r)
                    if ability ~= nil then
                        ability:SetLevel(ability_level)
                    end
                end 
                ExecuteOrderFromTable({
                    UnitIndex = SpawnUnit:entindex(),
                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                    Position  = base_location,
                    Queue     = true 
                })
            end 
        end
        remains = remains + (count_each_wave_road * player_count)
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

-- Reward all players
function WaveManager:Reward( tReward )
    for i=0, DOTA_MAX_PLAYER_TEAMS do   
        if PlayerResource:IsValidPlayer(i) then
            local gained = PlayerResource:GetTotalEarnedGold(i)
            local support = math.max(0, reward.threshold - gained)
            local total = reward.base + support
            Timers:CreateTimer(1.5, function()
                PlayerResource:ModifyGold(i, total, true, 0)
            end)
        end
    end
end

-- Additional functions

-- Is it wave unit?
function CDOTA_BaseNPC:IsWaveUnit()
    if self.IsWaveUnit then
        return true
    else
        return false
    end
end

-- Get State of Wave
function WaveManager:StateGet()
    return WaveManager.State
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
-- P.S: Not tested
function WaveManager:SkipWave()
    roundTimerIsFinished = true
    roundEnded = true
    unitRemains = 0
end
