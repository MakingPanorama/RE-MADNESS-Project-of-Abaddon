function create (keys)
    local target = keys.target
    if target:IsRangedAttacker() then
        target.projectile = target:GetRangedProjectileName()
        target:SetRangedProjectileName(keys.projectile_name)   
    end
end


function destory (keys)
    local target = keys.target
    if target:IsRangedAttacker() then
        target:SetRangedProjectileName(target.projectile)
    end
end

function damage (keys)
    local caster = keys.caster
    local target = keys.target
	local ability = keys.ability
    local base_damage_per_second = ability:GetLevelSpecialValueFor("base_damage_per_second", ability:GetLevel() - 1)
    local bonus_damage_percent_per_second = ability:GetLevelSpecialValueFor("bonus_damage_percent_per_second", ability:GetLevel() - 1)
    local damage = base_damage_per_second + (caster:GetMana() * bonus_damage_percent_per_second / 100)
    print (damage)
    local damage_table={
            attacker = caster,
	        ability = ability,
	        damage_type = ability:GetAbilityDamageType(),
            damage = damage,
            victim = target
    } 
    ApplyDamage(damage_table)   
end