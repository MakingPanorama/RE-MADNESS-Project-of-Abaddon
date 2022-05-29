function get (keys)
    local caster = keys.caster
    caster:RemoveAbility("NPC_Tower_upgrade_fire")
    caster:RemoveAbility("NPC_Tower_upgrade_frost")
    local ability = caster:AddAbility("NPC_Tower_ability_2_frost")
    ability:SetLevel(1)
end