function CastSpirits( event )
	local caster	= event.caster
	local ability	= event.ability
    if caster:IsRangedAttacker() then
    if caster:IsRealHero() then
    if caster.spirit ~= nil then
        if caster.spirit[event.lvl] ~= nil then
            if not caster.spirit[event.lvl]:IsNull() then
                caster.spirit[event.lvl]:ForceKill( true )
                caster.spirit[event.lvl] = nil
            end
        end
    end
	ability.spirits_startTime		= GameRules:GetGameTime()
	ability.spirits_numSpirits		= 0		-- Use this rather than "#spirits_spiritsSpawned"
	ability.spirits_spiritsSpawned	= {}
	caster.spirits_radius			= 100
	caster.spirits_movementFactor	= 0		-- Changed by the toggle abilities
	local casterOrigin	= caster:GetAbsOrigin()
	local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
    -- Spawn a new spirit
		local newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
		-- Create particle FX
        local pfx = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
        
        if caster.spirit == nil then
            caster.spirit = {}
        end

        caster.spirit[event.lvl] = newSpirit
        caster.spirit[event.lvl].pfx = pfx
		-- Apply the spirit modifier
		ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )
    end
    end
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Update spirits.
]]
function ThinkSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability
	local spiritModifier	= event.spirit_modifier
	local casterOrigin	= caster:GetAbsOrigin()
    
    if caster:IsRangedAttacker() then
        if caster:IsRealHero() then
            if caster.spirit ~= nil then
                if caster.spirit[event.lvl] ~= nil then
                    --------------------------------------------------------------------------------
                    -- Validate the number of spirits summoned
                    
                        
                    --------------------------------------------------------------------------------
                    -- Update the radius
                    --
                    local currentRadius	= caster.spirits_radius
                    local deltaRadius = caster.spirits_movementFactor * event.spirit_movement_rate * event.think_interval
                    currentRadius = currentRadius + deltaRadius
                    currentRadius = math.min( math.max( currentRadius, event.min_range ), event.max_range )
                    
                    currentRadius = 100
                    caster.spirits_radius = currentRadius

                    --------------------------------------------------------------------------------
                    -- Update the spirits' positions
                    --
                    local currentRotationAngle	= 0

                    local rotationAngle = currentRotationAngle - 270
                    local relPos = Vector( 0, currentRadius, 0 )
                    relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
                    
                    local absPos = GetGroundPosition( relPos + casterOrigin, caster.spirit[event.lvl] )

                    caster.spirit[event.lvl]:SetAbsOrigin( absPos )
                    caster.spirit[event.lvl]:SetBaseDamageMin(caster:GetAttackDamage())
                    caster.spirit[event.lvl]:SetBaseDamageMax(caster:GetAttackDamage())

                    -- Update particle
                    ParticleManager:SetParticleControl( caster.spirit[event.lvl].pfx, 1, Vector( currentRadius, 0, 0 ) )
                else
                    if caster.spirit[event.lvl] ~= nil then
                        if not caster.spirit[event.lvl]:IsNull() then
                            caster.spirit[event.lvl]:ForceKill( true )
                            caster.spirit[event.lvl] = nil
                        end
                    end
                    ability.spirits_startTime		= GameRules:GetGameTime()
                    ability.spirits_numSpirits		= 0		-- Use this rather than "#spirits_spiritsSpawned"
                    ability.spirits_spiritsSpawned	= {}
                    caster.spirits_radius			= 100
                    caster.spirits_movementFactor	= 0		-- Changed by the toggle abilities
                    local casterOrigin	= caster:GetAbsOrigin()
                    local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
                    -- Spawn a new spirit
                    local newSpirit = CreateUnitByName( "npc_dota_spirit", casterOrigin, false, caster, nil, caster:GetTeam() )
                    -- Create particle FX
                    local pfx = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
                    caster.spirit[event.lvl] = newSpirit
                    caster.spirit[event.lvl].pfx = pfx
                    -- Apply the spirit modifier
                    ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )
                end
            else
                caster.spirit = {}
            end
        end
    else
        if caster.spirit ~= nil then
            if caster.spirit[event.lvl] ~= nil then
                if not caster.spirit[event.lvl]:IsNull() then
                    caster.spirit[event.lvl]:RemoveModifierByName( spiritModifier )
                end
            end
        end
    end
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy all spirits and swap the abilities back to the original states.
]]
function EndSpirits( event )
	local caster	= event.caster
	local ability	= event.ability
	local spiritModifier	= event.spirit_modifier
    
    if caster.spirit ~= nil then
        if caster.spirit[event.lvl] ~= nil then
            if not caster.spirit[event.lvl]:IsNull() then
                caster.spirit[event.lvl]:RemoveModifierByName( spiritModifier )
            end
        end
    end
end
--[[
	Author: Ractidous
	Date: 09.02.2015.
	Apply a modifier which detects collision with a hero.
]]
function OnCreatedSpirit( event )
	
	local spiritt = event.target
	local ability = event.ability
    
	ability:ApplyDataDrivenModifier( spiritt, spiritt, event.additionalModifier, {} )
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy a spirit.
]]
function OnDestroySpirit( event )
	local ability	= event.ability
	local caster	= event.caster
    
	ParticleManager:DestroyParticle( caster.spirit[event.lvl].pfx, false )

	-- Create vision
	--ability:CreateVisibilityNode( caster.spirit[event.lvl]:GetAbsOrigin(), event.vision_radius, event.vision_duration )

	-- Kill
	caster.spirit[event.lvl]:ForceKill( true )
    caster.spirit[event.lvl] = nil
end