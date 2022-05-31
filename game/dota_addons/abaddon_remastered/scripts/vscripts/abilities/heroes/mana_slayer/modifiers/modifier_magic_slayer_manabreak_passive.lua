modifier_magic_slayer_manabreak_passive = class({})

function modifier_magic_slayer_manabreak_passive:IsHidden() return true end
function modifier_magic_slayer_manabreak_passive:IsPassive() return true end
function modifier_magic_slayer_manabreak_passive:DeclareFunctions()
    local declares = {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }

    return declares
end

function modifier_magic_slayer_manabreak_passive:GetModifierProcAttack_Feedback( tData )
    local attacker = tData.attacker
    local victim = tData.target

    local base_manaburn = self:GetAbility():GetSpecialValueFor('base_burnt')
    local max_manaburn_percent = self:GetAbility():GetSpecialValueFor('max_manaburn_percent')
    victim:ReduceMana( base_manaburn )

    ApplyDamage({
        victim = victim,
        attacker = attacker,
        ability = self:GetAbility(),
        damage = base_manaburn + victim:GetMaxMana() % max_manaburn_percent,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
    })

    for _, unit in pairs( FindUnitsInRadius(attacker:GetTeamNumber(), victim:GetAbsOrigin(), nil, 270, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 0, false) ) do
        ApplyDamage({
            victim = unit,
            attacker = attacker,
            ability = self:GetAbility(),
            damage = (base_manaburn + unit:GetMaxMana() % max_manaburn_percent) / 2,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
        })
    end
end