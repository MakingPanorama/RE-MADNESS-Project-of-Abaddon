function xunjiliehuo_init( keys )
    -- 无法重复触发
    if keys.caster.xunjiliehuo_active ~= nil and keys.caster.xunjiliehuo_action == true then
        return nil
    end

    -- Inheritted variables
    local caster = keys.caster
    local targetPoint = keys.target:GetAbsOrigin()
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local max_target = ability:GetLevelSpecialValueFor("max_target", ability:GetLevel() - 1)
    local attack_interval = 0.1

    local casterModifierName = "modifier_xunjiliehuo_caster"
    local dummyModifierName = "modifier_xunjiliehuo_dummy"
    local particleSlashName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf"
    local particleTrailName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
    local particleCastName = "particles/units/heroes/hero_ember_spirit/ember_spirit_xunjiliehuo_cast.vpcf"
    local slashSound = "Hero_EmberSpirit.SleightOfFist.Damage"

    -- Targeting variables
    local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
    local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS
    local unitOrder = FIND_ANY_ORDER

    -- Necessary varaibles
    local counter = 0
    caster.xunjiliehuo_active = true
    local caster_origin = caster:GetAbsOrigin()
    -- local dummy = CreateUnitByName( caster:GetName(), caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber() )
    -- dummy.__isDummy = true
    -- ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )

    -- Casting particles
    local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )
    ParticleManager:SetParticleControl( castFxIndex, 0, targetPoint )
    ParticleManager:SetParticleControl( castFxIndex, 1, Vector( radius, 0, 0 ) )

    Timer( 0.1, function()
            ParticleManager:DestroyParticle( castFxIndex, false )
            ParticleManager:ReleaseParticleIndex( castFxIndex )
        end
    )

    -- Start function
    local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )
    local units = FindUnitsInRadius(
        caster:GetTeamNumber(), targetPoint, caster, radius, targetTeam,
        targetType, targetFlag, unitOrder, false
    )

    for _, target in pairs( units ) do
        counter = counter + 1
        if counter >= max_target then
            counter = max_target
            break
        end
        ability:ApplyDataDrivenModifier( caster, target, modifierTargetName, {} )
        Timer( counter * attack_interval, function()
                -- Only jump to it if it's alive
                if target:IsAlive() then
                    -- Create trail particles
                    local trailFxIndex = ParticleManager:CreateParticle( particleTrailName, PATTACH_CUSTOMORIGIN, target )
                    ParticleManager:SetParticleControl( trailFxIndex, 0, target:GetAbsOrigin() )
                    ParticleManager:SetParticleControl( trailFxIndex, 1, caster:GetAbsOrigin() )

                    Timer( 0.1, function()
                            ParticleManager:DestroyParticle( trailFxIndex, false )
                            ParticleManager:ReleaseParticleIndex( trailFxIndex )
                            return nil
                        end
                    )

                    -- Move hero there
                    -- FindClearSpaceForUnit( caster, target:GetAbsOrigin(), false )
                    caster:PerformAttack( target, true, true, true, false, true, false, true)

                    -- 造成当前攻击升级等级 * 敏捷系数的伤害
                    -- ？？？？

                    -- Slash particles
                    local slashFxIndex = ParticleManager:CreateParticle( particleSlashName, PATTACH_ABSORIGIN_FOLLOW, target )
                    StartSoundEvent( slashSound, caster )

                    Timer( 0.1, function()
                            ParticleManager:DestroyParticle( slashFxIndex, false )
                            ParticleManager:ReleaseParticleIndex( slashFxIndex )
                            StopSoundEvent( slashSound, caster )
                            return nil
                        end
                    )

                end
                return nil
            end
        )
    end

    -- Return caster to origin position
    Timer( ( counter + 1 ) * attack_interval, function()
            FindClearSpaceForUnit( caster, caster_origin, false )
            -- dummy:RemoveSelf()
            caster:RemoveModifierByName( casterModifierName )
            caster.xunjiliehuo_active = false
            return nil
        end
    )
end
