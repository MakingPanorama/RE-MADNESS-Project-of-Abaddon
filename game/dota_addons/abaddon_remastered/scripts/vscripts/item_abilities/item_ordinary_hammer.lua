function stun (keys)
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local chance = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel() - 1)) 
    local random = RandomInt(1, 100)
    if random <= chance and caster:IsRealHero() then
        local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1)) 
        ability:ApplyDataDrivenModifier( caster, target, keys.debuff, { Duration = stun_duration } )
        target:EmitSound(keys.sound_name)
    end
end