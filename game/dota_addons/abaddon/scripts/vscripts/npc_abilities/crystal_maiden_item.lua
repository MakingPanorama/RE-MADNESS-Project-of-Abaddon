local function freeze(cm, target, ability)
    target:RemoveModifierByName("modifier_hanshuanglingyu_stacker")
    ability:ApplyDataDrivenModifier(cm,target,"modifier_hanshuanglingyu_frozen",{})
end

function OnHanshuanglingyuAttacked(args)
    local attacker = args.attacker
    if not attacker:IsRealHero() then return end
    local caster = args.caster
    local ability = args.ability

    if not attacker:HasModifier("modifier_hanshuanglingyu_stacker") then
        ability:ApplyDataDrivenModifier(caster,attacker,"modifier_hanshuanglingyu_stacker",{})
    end
    local count = attacker:GetModifierStackCount("modifier_hanshuanglingyu_stacker",caster)
    attacker:SetModifierStackCount("modifier_hanshuanglingyu_stacker",caster,count + 1)

    if count + 1 >= 2 then
        freeze(caster, attacker, ability)
    end
end

function OnHanshuanglingyuAttackLanded(args)
    local target = args.target
    local caster = args.caster
    local ability = args.ability

    if not target:HasModifier("modifier_hanshuanglingyu_stacker") then
        ability:ApplyDataDrivenModifier(caster,target,"modifier_hanshuanglingyu_stacker",{})
    end
    local count = target:GetModifierStackCount("modifier_hanshuanglingyu_stacker",caster)

    local inc = 1
    if not target:IsRealHero() then
        inc = 2
    end
    target:SetModifierStackCount("modifier_hanshuanglingyu_stacker",caster,count + inc)

    if count + 1 >= 2 then
        freeze(caster, target, ability)
    end

end

function OnHanshuanglingyuSlowedTargetAttacked(args)
    local target = args.target
    local ability = args.ability
    local caster = args.caster

    if not target:HasModifier("modifier_hanshuanglingyu_stun_cooldown_hidden_counter") then
        ability:ApplyDataDrivenModifier(caster,target,"modifier_hanshuanglingyu_stun",{})
    end

    target:RemoveModifierByName("modifier_hanshuanglingyu_stun_cooldown_hidden_counter")
    ability:ApplyDataDrivenModifier(caster,target,"modifier_hanshuanglingyu_stun_cooldown_hidden_counter",{})

end

function OnHanshuanglingyuExplosion(args)
    local caster = args.caster
    local target = args.target
    local ability = args.ability
    local radius = ability:GetSpecialValueFor("explode_radius")
    local int_amp = ability:GetSpecialValueFor("int_amp")
    local int = caster:GetIntellect()
    local dmg = int * int_amp

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)

    for _, enemy in pairs(enemies) do
        ApplyDamage({
            attacker = caster,
            victim = enemy,
            damage = dmg,
            damage_type = ability:GetAbilityDamageType(),
        })
    end
end
