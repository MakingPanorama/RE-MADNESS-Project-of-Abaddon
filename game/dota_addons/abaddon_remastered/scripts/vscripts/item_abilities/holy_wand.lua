function create (keys)
    local caster = keys.caster
    local ability = keys.ability
    local absorb_dmg_per_int = ability:GetLevelSpecialValueFor("absorb_dmg_per_int", (ability:GetLevel() - 1)) 
    ability.absorb_threshold = caster:GetIntellect() * absorb_dmg_per_int
    ability.absorbed = 0
end

function absorb (keys)
    local caster = keys.caster
    local ability = keys.ability
    local damage = keys.damage
    local remain_absorb = ability.absorb_threshold - ability.absorbed
    local heal = math.min (damage, remain_absorb)
    ability.absorbed = ability.absorbed + heal
    caster:Heal(heal, caster)
    if ability.absorbed >= ability.absorb_threshold then
        caster:RemoveModifierByName(keys.buff)
    end
end