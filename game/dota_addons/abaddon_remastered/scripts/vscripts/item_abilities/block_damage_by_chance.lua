function block (keys)   
    local ability = keys.ability
    local chance = ability:GetLevelSpecialValueFor("chance", ability:GetLevel() - 1)
    local random = RandomInt(1, 100)
    local caster = keys.caster
    if random <= chance and caster:IsRealHero() then
        local damage = keys.damage
        local block = ability:GetLevelSpecialValueFor("block", ability:GetLevel() - 1)
        local heal = math.min(damage, block)
        caster:Heal(heal, caster) 
    end 
end

