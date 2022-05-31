mud_seeker_throw_rock = class({})

function mud_seeker_throw_rock:OnSpellStart()
    ProjectileManager:CreateTrackingProjectile({
        EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
        Ability = self,
        iMoveSpeed = 600,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iVisionTeamNumber = self:GetCaster():GetTeamNumber()
    })
end

function mud_seeker_throw_rock:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil then
        hTarget:AddNewModifier(self:GetCaster(), self, 'modifier_stunned', { duration = self:GetSpecialValueFor('stun_duration') })
        ApplyDamage({
            victim = hTarget,
            attacker = self:GetCaster(),
            ability = self,
            damage = self:GetSpecialValueFor('damage'),
            damage_type = self:GetAbilityDamageType()
        })
    end
end