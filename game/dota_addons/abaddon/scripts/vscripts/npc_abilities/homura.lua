LinkLuaModifier("modifier_chronosphere_speed_lua", "npc_abilities\modifiers\modifier_chronosphere_speed_lua.lua", LUA_MODIFIER_MOTION_NONE)

--[[Author: Pizzalol
	Date: 26.09.2015.
	Creates a dummy at the target location that acts as the Chronosphere]]
function Chronosphere( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local target_point = caster:GetOrigin()
    -- 
    caster.point = target_point
	-- Special Variables
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", (ability:GetLevel() - 1))

	-- Dummy
	local dummy_modifier = keys.dummy_aura
	local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeam())
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {duration = duration})

	-- Vision
	AddFOWViewer(caster:GetTeamNumber(), target_point, vision_radius, duration, false)

	-- Timer to remove the dummy
    Timers:CreateTimer(duration, function() dummy:RemoveSelf() end)
    
end

--[[Author: Pizzalol
	Date: 26.09.2015.
	Checks if the target is a unit owned by the player that cast the Chronosphere
	If it is then it applies the no collision and extra movementspeed modifier
	otherwise it applies the stun modifier]]
function ChronosphereAura( keys )
	local caster = keys.caster
	local target = caster
	local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local world_attack = FindAbilityByName
    
	-- Ability variables
	local aura_modifier = "modifier_chronosphere_datadriven"
	local ignore_void = ability:GetLevelSpecialValueFor("ignore_void", ability_level)
    local duration = ability:GetLevelSpecialValueFor("aura_interval", ability_level)
    -- Targeting variables
    local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local target_teams = ability:GetAbilityTargetTeam() 
	local target_types = ability:GetAbilityTargetType() 
	local target_flags = ability:GetAbilityTargetFlags() 
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster.point, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
    for _,unit in ipairs(units) do

        if caster:GetPlayerOwner() ~= unit:GetPlayerOwner()then
               if not unit:HasAbility("world_attack") then
                 -- See whether this unit has an ability by name.
                -- Everyone else gets immobilized and stunned
                  unit:InterruptMotionControllers(false)
                  ability:ApplyDataDrivenModifier(caster, unit, aura_modifier, {duration = duration}) 
               end
            end

	end
	if ignore_void == 0 then ignore_void = false
	else ignore_void = true end

	-- Check if it is a caster controlled unit or not
	-- Caster controlled units get the phasing and movement speed modifier
end

function TimeLapseSave( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage_taken = keys.DamageTaken
	local backtrack_time = keys.BacktrackTime
	local remember_interval = keys.Interval
	
	-- Temporary damage array and index
	if not ability.tempList then  ability.tempList = {} end
    if not ability.tempList[caster:GetUnitName()] then ability.tempList[caster:GetUnitName()] = {} end
    
	local casterTable = {}
	casterTable["health"] = caster:GetHealth()
	casterTable["mana"] = caster:GetMana()
    casterTable["position"] = caster:GetAbsOrigin()
    for abilitySlot=0,15 do
        local cruability = caster:GetAbilityByIndex(abilitySlot)
        if abilitySlot == 1 then 
            casterTable["ability"] = cruability:GetAbilityName()				 
        end
    end
    table.insert(ability.tempList[caster:GetUnitName()],casterTable)
    
  
	
	local maxindex = backtrack_time/remember_interval
	if #ability.tempList[caster:GetUnitName()] > maxindex then
		table.remove(ability.tempList[caster:GetUnitName()],1)
	end
end

function TimeLapseRewind( keys )

    
	local target = keys.caster
	local ability = keys.ability
	local caster = keys.caster
	 
      local health = ability.tempList[target:GetUnitName()][1]["health"]
      local mana = ability.tempList[target:GetUnitName()][1]["mana"]
      local position = ability.tempList[target:GetUnitName()][1]["position"]
      local oldability = ability.tempList[target:GetUnitName()][1]["ability"]
      local ability_level = ability:GetLevel() - 1
      local split_XP = ability:GetLevelSpecialValueFor("split_XP", ability_level)
      target:Interrupt()
      
      -- Adds damage to caster's current health
      particle_ground = ParticleManager:CreateParticle("particles/units/heroes/homura/weaver_timelapse.vpcf", PATTACH_ABSORIGIN  , target)
      ParticleManager:SetParticleControl(particle_ground, 0, target:GetAbsOrigin())
      ParticleManager:SetParticleControl(particle_ground, 1, position) --radius
      ParticleManager:SetParticleControl(particle_ground, 2, position) --ammount of particle
      print("oldability",oldability)
      target:SetHealth(health)
      target:SetMana(mana)
      target:Purge(false,true,false,true,false)
      ProjectileManager:ProjectileDodge(target)
      for abilitySlot=0,15 do
        local cruability = caster:GetAbilityByIndex(abilitySlot)
        newability = cruability:GetAbilityName()
        if abilitySlot == 1 and newability ~= oldability then 
            caster:SwapAbilities( oldability, newability,true, false)
        end
    end
      FindClearSpaceForUnit(target, position, true)

      	enemies = FindUnitsInRadius(caster:GetTeam(),
                                    caster:GetAbsOrigin(),
                                    nil,
                                    9999,
                                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                                    DOTA_UNIT_TARGET_HERO,
                                    DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                                    FIND_ANY_ORDER,
                                    false)
  	for _,enemy in pairs(enemies) do
        enemy:AddExperience(split_XP, false, false)
  	end


end



--[[
	Author: Noya
	Date: April 5, 2015
	Adds to the modified stacks when a unit is killed, limited by a max_souls.
	TODO: Confirm that SetModifierStackCount adds the damage instances without the need to apply shit
]]
function homuraSoul( keys )
	local caster = keys.caster
	local ability = keys.ability
    local maxStack = ability:GetLevelSpecialValueFor("homura_max_souls", (ability:GetLevel() - 1))
    local cd = ability:GetLevelSpecialValueFor("cd", (ability:GetLevel() - 1))
    local addmana = ability:GetLevelSpecialValueFor("rage", (ability:GetLevel() - 1))
    local modifierCount = caster:GetModifierCount()
    local casterMana = caster:GetMana()
    local mana = casterMana + addmana
	local currentStack = 0
	local modifierBuffName = "modifier_homura_buff"
	local modifierStackName = "modifier_homura_stack"
	local modifierName
    
    if caster.soulstack == nil  then 
        caster.soulstack = 0 
    else
        
    end
    print("cd =",cd)
    print("caster.soulstack =",caster.soulstack)
  if caster.soulstack >= cd and caster:HasItemInInventory("item_refresher") then
    -- Does this unit have an inventory.
    -- Reset cooldown for abilities that is not rearm
    print("refresher")
	for i = 0, caster:GetAbilityCount() - 1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability and ability ~= keys.ability then
			ability:EndCooldown()
		end
	end
	
	-- Put item exemption in here
	
	-- Reset cooldown for items
	for i = 0, 5 do
		local item = caster:GetItemInSlot( i )
		if item and not item:GetAbilityName() ~= "item_refresher" then
			item:EndCooldown()
		end
    end
    caster.soulstack = 0
else
        caster.soulstack = caster.soulstack + 1
   end
	-- Always remove the stack modifier
	caster:RemoveModifierByName(modifierStackName) 

	-- Counts the current stacks
	for i = 0, modifierCount do
		modifierName = caster:GetModifierNameByIndex(i)

		if modifierName == modifierBuffName then
            currentStack = currentStack + 1
            
        end
        caster:SetMana(mana)
end
	-- Remove all the old buff modifiers
	for i = 0, currentStack do
		print("Removing modifiers")
		caster:RemoveModifierByName(modifierBuffName)
	end

	-- Always apply the stack modifier 
	ability:ApplyDataDrivenModifier(caster, caster, modifierStackName, {})

	-- Reapply the maximum number of stacks
	if currentStack >= maxStack then
		caster:SetModifierStackCount(modifierStackName, ability, maxStack)

		-- Apply the new refreshed stack
		for i = 1, maxStack do
			ability:ApplyDataDrivenModifier(caster, caster, modifierBuffName, {})
		end
	else
		-- Increase the number of stacks
		currentStack = currentStack + 1

		caster:SetModifierStackCount(modifierStackName, ability, currentStack)

		-- Apply the new increased stack
		for i = 1, currentStack do
			ability:ApplyDataDrivenModifier(caster, caster, modifierBuffName, {})
		end
	end
end

function homuradeath( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierCount = caster:GetModifierCount()
	local modifierBuffName = "modifier_madokami_buff"
	local modifierStackName = "modifier_madokami_stack"
	local current_stack = caster:GetModifierStackCount( modifierStackName, ability )
	local soul_release = ability:GetLevelSpecialValueFor( "soul_release", ability:GetLevel() - 1 )
	local currentStack = 0
	local modifierName


		-- 减半
	   current_stack = math.floor(current_stack * soul_release)
       print("current_stack",current_stack)
		caster:SetModifierStackCount(modifierStackName, ability, current_stack)

		for i = 1, current_stack do
		print("Removing modifiers")
		caster:RemoveModifierByName(modifierBuffName)
	end
   for i = 0, modifierCount do
		modifierName = caster:GetModifierNameByIndex(i)

		if modifierName == modifierBuffName then
			currentStack = currentStack + 1
		end
    end
	print("currentstack",currentStack)
    caster:SetModifierStackCount(modifierStackName, ability, currentStack)

end

--[[Author: Pizzalol
	Date: 24.03.2015.
	Creates the land mine and keeps track of it]]
    function LandMinesPlant( keys )
        local caster = keys.caster
        local target_point = keys.target_points[1]
        local ability = keys.ability
        local ability_level = ability:GetLevel() - 1
    
        -- Initialize the count and table
        caster.land_mine_count = caster.land_mine_count or 0
        caster.land_mine_table = caster.land_mine_table or {}
    
        -- Modifiers
        local modifier_land_mine = keys.modifier_land_mine
        local modifier_tracker = keys.modifier_tracker
        local modifier_caster = keys.modifier_caster
        local modifier_land_mine_invisibility = keys.modifier_land_mine_invisibility
    
        -- Ability variables
        local activation_time = ability:GetLevelSpecialValueFor("activation_time", ability_level) 
        local max_mines = ability:GetLevelSpecialValueFor("max_mines", ability_level) 
        local fade_time = ability:GetLevelSpecialValueFor("fade_time", ability_level)
    
        -- Create the land mine and apply the land mine modifier
        local land_mine = CreateUnitByName("npc_dota_techies_land_mine", target_point, false, nil, nil, caster:GetTeamNumber())
        ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine, {})
    
        -- Update the count and table
        caster.land_mine_count = caster.land_mine_count + 1
        table.insert(caster.land_mine_table, land_mine)
    
        -- If we exceeded the maximum number of mines then kill the oldest one
        if caster.land_mine_count > max_mines then
            caster.land_mine_table[1]:ForceKill(true)
        end
    
        -- Increase caster stack count of the caster modifier and add it to the caster if it doesnt exist
        if not caster:HasModifier(modifier_caster) then
            ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
        end
    
        caster:SetModifierStackCount(modifier_caster, ability, caster.land_mine_count)
    
        -- Apply the tracker after the activation time
        Timers:CreateTimer(activation_time, function()
            ability:ApplyDataDrivenModifier(caster, land_mine, modifier_tracker, {})
        end)
    
        -- Apply the invisibility after the fade time
        Timers:CreateTimer(fade_time, function()
            ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine_invisibility, {})
        end)
    end
    
    --[[Author: Pizzalol
        Date: 24.03.2015.
        Stop tracking the mine and create vision on the mine area]]
    function LandMinesDeath( keys )
        local caster = keys.caster
        local unit = keys.unit
        local ability = keys.ability
        local ability_level = ability:GetLevel() - 1
    
        -- Ability variables
        local modifier_caster = keys.modifier_caster
        local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
        local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
    
        -- Find the mine and remove it from the table
        for i = 1, #caster.land_mine_table do
            if caster.land_mine_table[i] == unit then
                table.remove(caster.land_mine_table, i)
                caster.land_mine_count = caster.land_mine_count - 1
                break
            end
        end
    
        -- Create vision on the mine position
        ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)
    
        -- Update the stack count
        caster:SetModifierStackCount(modifier_caster, ability, caster.land_mine_count)
        if caster.land_mine_count < 1 then
            caster:RemoveModifierByNameAndCaster(modifier_caster, caster) 
        end
    end
    
    --[[Author: Pizzalol
        Date: 24.03.2015.
        Tracks if any enemy units are within the mine radius]]
    function LandMinesTracker( keys )
        local target = keys.target
        local ability = keys.ability
        local ability_level = ability:GetLevel() - 1
    
        -- Ability variables
        local trigger_radius = ability:GetLevelSpecialValueFor("small_radius", ability_level) 
        local explode_delay = ability:GetLevelSpecialValueFor("explode_delay", ability_level) 
    
        -- Target variables
        local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
        local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    
        -- Find the valid units in the trigger radius
        local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, trigger_radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 
    
        -- If there is a valid unit in range then explode the mine
        if #units > 0 then
            Timers:CreateTimer(explode_delay, function()
                if target:IsAlive() then
                    target:ForceKill(true) 
                end
            end)
        end
    end

    function tank( event )
        local caster = event.caster
        local player = caster:GetPlayerID()
        local ability = event.ability
        local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1 )
        local levelup = ability:GetLevel() - 1
        local unit_name = "homura_tank"
        local forwardV	= caster:GetForwardVector()
    
        local origin = event.target_points[1]
    
        if caster.Tank ~= nil then
            caster.Tank:RemoveSelf()
        end
    
        -- Start a clean illusion table

        -- Create the units
        caster.Tank = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
       -- caster.Tank:SetPlayerID(caster:GetPlayerID())
       caster.Tank:SetOwner(caster)
        -- Make them controllable
        caster.Tank:SetControllableByPlayer(player, true)
    
        -- Set all of them looking at the same point as the caster
        caster.Tank:SetForwardVector(forwardV)
    
    
            

            --red_eye:AddNewModifier(caster, ability, "modifier_arc_warden_tempest_double", nil)
            ability:ApplyDataDrivenModifier(caster, caster.Tank, "modifier_houmura_tank", {})
    
    end

    function TankEnd( event )
        local caster = event.caster
        caster.Tank:RemoveSelf()
        caster.Tank = nil
    end

    function sub( event )
        local caster = event.caster
        local player = caster:GetPlayerID()
        local ability = event.ability
        local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1 )
        local levelup = ability:GetLevel() - 1
        local unit_name = "homura_sub"
        local forwardV	= caster:GetForwardVector()
    
        local origin = event.target_points[1]
    
        if caster.sub ~= nil then
            caster.sub:RemoveSelf()
        end
    
        -- Start a clean illusion table

        -- Create the units
        caster.sub = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
        --caster.sub:SetPlayerID(caster:GetPlayerID())
        caster.sub:SetOwner(caster)
        -- Make them controllable
        caster.sub:SetControllableByPlayer(player, true)
    
        -- Set all of them looking at the same point as the caster
        caster.sub:SetForwardVector(forwardV)
    
    

            --red_eye:AddNewModifier(caster, ability, "modifier_arc_warden_tempest_double", nil)
            ability:ApplyDataDrivenModifier(caster, caster.sub, "modifier_houmura_sub", {})
    
    end

    function SubEnd( event )
        local caster = event.caster
        caster.sub:RemoveSelf()
        caster.sub = nil
    end

    function fly( event )
        local caster = event.caster
        local player = caster:GetPlayerID()
        local ability = event.ability
        local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1 )
        local levelup = ability:GetLevel() - 1
        local unit_name = "homura_fly"
        local forwardV	= caster:GetForwardVector()
    
        local origin = event.target_points[1]
    
        if caster.fly ~= nil then
            caster.fly:RemoveSelf()
        end
    
        -- Start a clean illusion table

        -- Create the units
        caster.fly = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
        --caster.fly:SetPlayerID(caster:GetPlayerID())
        caster.fly:SetOwner(caster)
        -- Make them controllable
        caster.fly:SetControllableByPlayer(player, true)
    
        -- Set all of them looking at the same point as the caster
        caster.fly:SetForwardVector(forwardV)
    
    

            --red_eye:AddNewModifier(caster, ability, "modifier_arc_warden_tempest_double", nil)
            ability:ApplyDataDrivenModifier(caster, caster.fly, "modifier_houmura_fly", {})
    
    end

    function FlyEnd( event )
        local caster = event.caster
        caster.fly:RemoveSelf()
        caster.fly = nil
    end

    function switch( keys )
        local caster = keys.caster
        local ability = keys.ability
        local ability_level = ability:GetLevel() - 1
       
        for abilitySlot=0,15 do
			local cruability = caster:GetAbilityByIndex(abilitySlot)
            if abilitySlot == 1 then 
            caster.abilityName = cruability:GetAbilityName()				 
			end
		end
    print("curability",caster.abilityName)
    if caster.abilityName == "homura_rpg" then
        caster:SwapAbilities("landmine", "homura_rpg", true, false) 
    end
    if caster.abilityName == "landmine" then
        caster:SwapAbilities("houmura_tank", "landmine", true, false) 
    end
	if caster.abilityName == "houmura_tank" then
        caster:SwapAbilities("houmura_fly", "houmura_tank", true, false) 
    end
	if caster.abilityName == "houmura_fly" then
        caster:SwapAbilities("Flash_bomb", "houmura_fly", true, false) 
    end
	if caster.abilityName == "Flash_bomb" then
        caster:SwapAbilities("houmura_gun", "Flash_bomb", true, false) 
    end
	if caster.abilityName == "houmura_gun" then
        caster:SwapAbilities("homura_rpg", "houmura_gun", true, false) 
    end
  end


function LevelUpAbilityhomura( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	local ability_handle_1 = caster:FindAbilityByName("homura_rpg")	
	local ability_handle_2 = caster:FindAbilityByName("landmine")	
	local ability_handle_3 = caster:FindAbilityByName("houmura_gun")	
    local ability_handle_4 = caster:FindAbilityByName("Flash_bomb")	
    local ability_handle_5 = caster:FindAbilityByName("houmura_tank")	
    local ability_handle_6 = caster:FindAbilityByName("houmura_fly")	
    local ability_handle_7 = caster:FindAbilityByName("houmura_sub")
    local ability_handle_8 = caster:FindAbilityByName("trans_arm")	
	local ability_level_1 = ability_handle_1:GetLevel()
	local ability_level_2 = ability_handle_2:GetLevel()
	local ability_level_3 = ability_handle_3:GetLevel()
    local ability_level_4 = ability_handle_4:GetLevel()
    local ability_level_5 = ability_handle_5:GetLevel()
	local ability_level_6 = ability_handle_6:GetLevel()
	local ability_level_7 = ability_handle_7:GetLevel()
	local ability_level_8 = ability_handle_8:GetLevel()
	


	-- Check to not enter a level up loop
	if ability_level_1 ~= this_abilityLevel then
		ability_handle_1:SetLevel(this_abilityLevel)
	end
	if ability_level_2 ~= this_abilityLevel then
		ability_handle_2:SetLevel(this_abilityLevel)
	end
	if ability_level_3 ~= this_abilityLevel then
		ability_handle_3:SetLevel(this_abilityLevel)
	end
	if ability_level_4 ~= this_abilityLevel then
		ability_handle_4:SetLevel(this_abilityLevel)
    end
    if ability_level_5 ~= this_abilityLevel then
		ability_handle_5:SetLevel(this_abilityLevel)
	end
	if ability_level_6 ~= this_abilityLevel then
		ability_handle_6:SetLevel(this_abilityLevel)
	end
	if ability_level_7 ~= this_abilityLevel then
		ability_handle_7:SetLevel(this_abilityLevel)
	end
	if ability_level_8 ~= this_abilityLevel then
		ability_handle_8:SetLevel(this_abilityLevel)
	end
end