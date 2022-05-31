function Effect (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local effect_duration = ability:GetLevelSpecialValueFor("effect_duration", ability:GetLevel() - 1)
    ability:ApplyDataDrivenModifier(caster, target, "veno_saber_debuff", { Duration = effect_duration })
    local particalid=ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)  
    Timers:CreateTimer(1,function()
        ParticleManager:DestroyParticle(particalid,true) 
    end
    )
end