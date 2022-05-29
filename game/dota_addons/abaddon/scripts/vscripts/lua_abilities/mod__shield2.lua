mod__shield2 = class({})


function mod__shield2:OnCreated()
    if not IsServer() then
        return nil
    end

    self:StartIntervalThink(FrameTime())
end

function mod__shield2:OnIntervalThink()
    if not IsServer() then
        return nil
    end

    self:GetParent().prior_health = self:GetParent():GetHealth()
end

function mod__shield2:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function mod__shield2:OnTakeDamage(event)
    local parent = self:GetParent()
    if not IsServer() or event.unit ~= parent or event.attacker == parent.prop_form then
        return nil
    end

    local ability = self:GetAbility()
    local mana_per_damage = ability:GetSpecialValueFor("mana_per_damage")
    local mana_burn = mana_per_damage * event.damage
    local mana_diff = parent:GetMana() - mana_burn

    if mana_diff >= 0 then
        parent:SetHealth(parent.prior_health)
    else
        parent:SetHealth(parent.prior_health + mana_diff / mana_per_damage)
    end

    parent:SpendMana(mana_burn, ability)
    local burn_index = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:ReleaseParticleIndex(burn_index)
    ParticleManager:SetParticleControl(burn_index, 0, parent:GetOrigin())
    ParticleManager:SetParticleControl(burn_index, 1, Vector(mana_burn, 0, 0))
    local number_index = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
    ParticleManager:SetParticleControl(number_index, 1, Vector(1, mana_burn, 0))
    ParticleManager:SetParticleControl(number_index, 2, Vector(2, string.len(math.floor(mana_burn)) + 1, 0))
end