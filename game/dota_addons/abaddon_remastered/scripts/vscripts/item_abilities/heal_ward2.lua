function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local particle = keys.particle_name
    local pos = ability:GetCursorPosition()
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local ward = CreateUnitByName("Team_barrier_Ward", pos, true, caster, nil, caster:GetTeam())
end


