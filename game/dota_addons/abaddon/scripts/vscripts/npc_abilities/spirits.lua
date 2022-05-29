--[[
	Author: Ractidous
	Date: 09.02.2015.
	Cast spirits.
]]
spirit_speed = 0
col_spirits = 0
start_razgon = false
max_sp = 8
if _G.hardmode then
	max_sp = 16
end
function CastSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	ability.spirits_startTime		= GameRules:GetGameTime()
	ability.spirits_numSpirits		= 0		-- Use this rather than "#spirits_spiritsSpawned"
	ability.spirits_spiritsSpawned	= {}
	caster.spirits_radius			= event.default_radius
	caster.spirits_movementFactor	= 0		-- Changed by the toggle abilities

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Update spirits.
]]
wtfparams = true
function ThinkSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	local casterOrigin	= caster:GetAbsOrigin()

	local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime

	--------------------------------------------------------------------------------
	-- Validate the number of spirits summoned
	--
	local idealNumSpiritsSpawned = elapsedTime / event.spirit_summon_interval
	idealNumSpiritsSpawned = math.min( idealNumSpiritsSpawned, max_sp )
    
	if col_spirits < max_sp then
		-- Spawn a new spirit
		local newSpirit = CreateUnitByName( "npc_dota_wisp_spirit", casterOrigin, false, caster, caster, caster:GetTeam() )

		-- Create particle FX
		local pfx = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
		newSpirit.spirit_pfx = pfx

		-- Update the state
		local spiritIndex = ability.spirits_numSpirits + 1
		newSpirit.spirit_index = spiritIndex
		ability.spirits_numSpirits = spiritIndex
		ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

		-- Apply the spirit modifier
		ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )
        
        col_spirits = col_spirits + 1
	end

	--------------------------------------------------------------------------------
	-- Update the radius
	--
	local currentRadius	= caster.spirits_radius
	local deltaRadius = caster.spirits_movementFactor * event.spirit_movement_rate * event.think_interval
	currentRadius = currentRadius + deltaRadius
	currentRadius = math.min( math.max( currentRadius, event.min_range ), event.max_range )
    
    if wtfparams == true then
    currentRadius = currentRadius - 3
    if currentRadius < 100 then
    wtfparams = false
    end
    else
    currentRadius = currentRadius + 3
    if currentRadius > 600 then
    wtfparams = true
    end
    end
	caster.spirits_radius = currentRadius

	--------------------------------------------------------------------------------
	-- Update the spirits' positions
	--
    local currentRotationAngle	= 0
    if col_spirits == max_sp and start_razgon == false then
        spirit_speed = spirit_speed + 0.3
        if spirit_speed >= 50 then
            spirit_speed = 200
            start_razgon = true
        end
    end
    currentRotationAngle = elapsedTime * spirit_speed
	local rotationAngleOffset	= 360 / max_sp

	local numSpiritsAlive = 0

	for k,v in pairs( ability.spirits_spiritsSpawned ) do

		numSpiritsAlive = numSpiritsAlive + 1

		-- Rotate
		local rotationAngle = currentRotationAngle - rotationAngleOffset * ( k - 1 )
		local relPos = Vector( 0, currentRadius, 0 )
		relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

		local absPos = GetGroundPosition( relPos + casterOrigin, v )

		v:SetAbsOrigin( absPos )

		-- Update particle
		ParticleManager:SetParticleControl( v.spirit_pfx, 1, Vector( currentRadius, 0, 0 ) )

	end

	if ability.spirits_numSpirits == max_sp and numSpiritsAlive == 0 then
		-- All spirits have been exploded.
		caster:RemoveModifierByName( event.caster_modifier )
		return
	end

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy all spirits and swap the abilities back to the original states.
]]
function EndSpirits( event )
	col_spirits = 0
	local caster	= event.caster
	local ability	= event.ability

	local spiritModifier	= event.spirit_modifier

	-- Destroy all spirits
	for k,v in pairs( ability.spirits_spiritsSpawned ) do
		v:RemoveModifierByName( spiritModifier )
	end
end
--[[
	Author: Ractidous
	Date: 09.02.2015.
	Apply a modifier which detects collision with a hero.
]]
function OnCreatedSpirit( event )
	
	local spirit = event.target
	local ability = event.ability

	-- Set the spirit to caster
    Timers:CreateTimer(0.01, function()
	ability:ApplyDataDrivenModifier( spirit, spirit, event.additionalModifier, {} )
    end)
    
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy a spirit.
]]
function OnDestroySpirit( event )
    
    Timers:CreateTimer(1, function()
    col_spirits = col_spirits - 1
    end)
    
    local spirit	= event.target
	local ability	= event.ability
    
	ParticleManager:DestroyParticle( spirit.spirit_pfx, false )

	-- Create vision
	ability:CreateVisibilityNode( spirit:GetAbsOrigin(), event.vision_radius, event.vision_duration )

	-- Kill
    spirit:SetTeam(2)
	spirit:ForceKill( true )

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Explode the spirit due to collision with an enemy hero.
]]
function ExplodeSpirit( event )
	local spirit	= event.caster		-- We have set the spirit to the caster
	local ability	= event.ability

	if not spirit.spirit_isExploded then

		spirit.spirit_isExploded = true

		-- Remove from the list of spirits
		ability.spirits_spiritsSpawned[spirit.spirit_index] = nil

		-- Remove the spirit modifier
		spirit:RemoveModifierByName( event.spirit_modifier )

		-- Fire the hit sound
		StartSoundEvent( event.explosion_sound, spirit )

	end
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Stop a sound.
]]
function StopSound( event )
	StopSoundEvent( event.sound_name, event.caster )
end