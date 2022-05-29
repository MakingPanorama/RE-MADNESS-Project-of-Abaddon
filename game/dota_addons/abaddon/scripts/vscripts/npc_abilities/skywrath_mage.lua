--[[
    CHANGELIST:
    09.01.2015 - Standardized variables
]]

--[[
    Author: kritth
    Date: 09.01.2015.
    Deal constant interval damage shared in the radius
]]

function OnTiannuAttacked(keys)

    local caster = keys.caster
    local damage = keys.Damage
    local ability = keys.ability
    local hero_attack_count = ability:GetSpecialValueFor("hero_attack_count")
    local attacker = keys.attacker

    if caster:HasModifier("modifier_mystic_flare_invulnerable") then
        return
    end

    if attacker:IsRealHero() then
        caster.__damage_taken_from_hero_count = caster.__damage_taken_from_hero_count or 0
        caster.__damage_taken_from_hero_count = caster.__damage_taken_from_hero_count + 1
        if not caster:HasModifier("modifier_trigger_count_hero_stacker") then
            ability:ApplyDataDrivenModifier(caster,caster,"modifier_trigger_count_hero_stacker",{})
        end

        caster:SetModifierStackCount("modifier_trigger_count_hero_stacker",caster,hero_attack_count - caster.__damage_taken_from_hero_count)
        if caster.__damage_taken_from_hero_count >= hero_attack_count then
            caster.__damage_taken_from_hero_count = 0
            caster:RemoveModifierByName("modifier_trigger_count_hero_stacker")
            mystic_flare_start(keys)
            StartSoundEvent("Hero_SkywrathMage.MysticFlare.Cast",caster)
            ability:ApplyDataDrivenModifier(caster,caster,"modifier_mystic_flare_invulnerable",{})
        end
    end
end

function OnTiannuTakeDamage(keys)
    local caster = keys.caster
    local damage = keys.Damage
    local ability = keys.ability
    local attacker = keys.attacker

    if caster:HasModifier("modifier_mystic_flare_invulnerable") then
        return
    end

    local hp = caster:GetMaxHealth()

    local trigger_threshold = ability:GetSpecialValueFor("trigger_threshold")

    caster.__damage_taken = caster.__damage_taken or 0
    caster.__damage_taken = caster.__damage_taken + damage
    if caster.__damage_taken >= hp * trigger_threshold / 100 then
        caster.__damage_taken = 0
        mystic_flare_start(keys)
        StartSoundEvent("Hero_SkywrathMage.MysticFlare.Cast",caster)

        ability:ApplyDataDrivenModifier(caster,caster,"modifier_mystic_flare_invulnerable",{})
    end
end

function mystic_flare_start( keys )
    -- Variables
    local ability = keys.ability
    local caster = keys.caster
    local dummyModifierName = "modifier_mystic_flare_dummy_vfx_datadriven"
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local interval = ability:GetLevelSpecialValueFor( "damage_interval", ability:GetLevel() - 1 )
    local max_instances = math.floor( duration / interval )
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local heal_pct = ability:GetSpecialValueFor("heal_pct")
    -- local target = keys.target_points[1]
    local random_radius = ability:GetSpecialValueFor("random_radius")
    local random_count = ability:GetSpecialValueFor("random_count")
    local total_damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
    local soundTarget = "Hero_SkywrathMage.MysticFlare.Target"

    local target_positions = {}
    for i = 1, random_count do
        local target = caster:GetAbsOrigin() + RandomVector(RandomFloat(0, random_radius))
        table.insert(target_positions, target)
        local enemy_heroes = FindUnitsInRadius(
                    caster:GetTeamNumber(), target, caster, random_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false
                )
        if #enemy_heroes > 0 then
            for _, hero in pairs(enemy_heroes) do
                table.insert(target_positions, hero:GetAbsOrigin())
            end
        end
    end

    for _, target in pairs(target_positions) do
        local current_instance = 0

        -- Create for VFX particles on ground
        local dummy = CreateUnitByName( "npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber() )
        ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )

        -- Referencing total damage done per interval
        local damage_per_interval = total_damage / max_instances

        -- Deal damage per interval equally
        Timer( function()
                local units = FindUnitsInRadius(
                    caster:GetTeamNumber(), target, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false
                )
                if #units > 0 then
                    local damage_per_hero = damage_per_interval / #units
                    for k, v in pairs( units ) do
                        -- Apply damage
                        local damageTable = {
                            victim = v,
                            attacker = caster,
                            damage = damage_per_hero,
                            damage_type = DAMAGE_TYPE_MAGICAL
                        }
                        ApplyDamage( damageTable )

                        caster:Heal(damage_per_hero * heal_pct / 100,ability)

                        -- Fire sound
                        StartSoundEvent( soundTarget, v )
                    end
                end

                current_instance = current_instance + 1

                -- Check if maximum instances reached
                if current_instance >= max_instances then
                    dummy:Destroy()
                    return nil
                else
                    return interval
                end
            end
        )

    end
end
