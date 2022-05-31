function Multiple_Image(event)
    local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local images_count = ability:GetLevelSpecialValueFor( "images_count", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local suffer = ability:GetLevelSpecialValueFor( "suffer", ability:GetLevel() - 1 )
	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()
    
    -- Stop any actions of the caster otherwise its obvious which unit is real
	caster:Stop()
    
	-- Start a clean illusion table
	caster.mirror_image_illusions = {}
    
    -- Setup a table of potential spawn positions
	local vRandomSpawnPos = {
        Vector( -200, 0, 0 ), Vector( 200, 0, 0 ), Vector( 0, -200, 0 ), Vector( 0, 200, 0 )   
	}
    
    for i=#vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
		local j = RandomInt( 1, i )
		vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
	end
    
    -- Insert the center position and make sure that at least one of the units will be spawned on there.
	table.insert( vRandomSpawnPos, RandomInt( 1, images_count+1 ), Vector( 0, 0, 0 ) )

	-- At first, move the main hero to one of the random spawn positions.
	FindClearSpaceForUnit( caster, caster:GetAbsOrigin() + RandomVector(200), true )
    
    -- Spawn illusions
	for i=1, images_count do
		local origin = casterOrigin + table.remove( vRandomSpawnPos, 1 )

		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
		illusion:SetPlayerID(caster:GetPlayerID())

		illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		
		-- Level Up the unit to the casters level
		local casterLevel = caster:GetLevel()
		for i=1,casterLevel-1 do
			illusion:HeroLevelUp(false)
		end

		-- Set the skill points to 0 and learn the skills of the caster
		illusion:SetAbilityPoints(0)
		for abilitySlot=0,15 do
			local ability = caster:GetAbilityByIndex(abilitySlot)
			if ability ~= nil then 
				local abilityLevel = ability:GetLevel()
				local abilityName = ability:GetAbilityName()
				local illusionAbility = illusion:FindAbilityByName(abilityName)
				illusionAbility:SetLevel(abilityLevel)
			end
		end

		-- Recreate the items of the caster
		for itemSlot=0,5 do
			local item = caster:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, illusion, illusion)
				illusion:AddItem(newItem)
			end
		end

		-- Set the unit as an illusion
		-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = 100, incoming_damage = 100 })	
		-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
		illusion:MakeIllusion()
		-- Set the illusion hp to be the same as the caster
		illusion:SetHealth(caster:GetHealth())
		illusion:SetBaseMoveSpeed(1110)
		illusion:SetRenderColor(255, 153, 51)
		ability:ApplyDataDrivenModifier(illusion, illusion, "modifier_attack_speed_masters", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_igoout", {duration = duration})
		if caster:HasModifier("modifier_igoout") then
			caster:AddNoDraw()
		end
	end
end

function vRemoveDraw( event )
	local caster = event.caster

	caster:RemoveNoDraw()
end