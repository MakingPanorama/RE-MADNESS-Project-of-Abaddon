function vendetta_attack(keys) 
        -- Variables
        local caster = keys.caster
        local target = keys.target
        local ability = keys.ability
        local abilityDamage = ability:GetLevelSpecialValueFor( "bonus_damage", ability:GetLevel() - 1 )
        local abilityDamageType = ability:GetAbilityDamageType()
    
        if target:HasModifier("modifier_foe_target") then
            print("attacking foe")
            abilityDamage = abilityDamage * 2
        end

        -- Deal damage and show VFX
        local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
        ParticleManager:SetParticleControl( fxIndex, 1, target:GetAbsOrigin() )
        
        StartSoundEvent( "Hero_NyxAssassin.Vendetta.Crit", target )
        
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = abilityDamage,
            damage_type = abilityDamageType
        }
        ApplyDamage( damageTable )
end