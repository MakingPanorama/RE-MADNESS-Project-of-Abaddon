function HailTower:OnAttack(keys)
    local target = keys.target
    local caster = keys.caster

    self.current_attacks = self.current_attacks + 1
    if self.current_attacks >= self.attacks_required then
        self.current_attacks = 0
        self.tower:EmitSound("Hail.Cast")
        local damage = self.tower:GetAverageTrueAttackDamage(target)

        local creeps = GetCreepsInArea(self.tower:GetAbsOrigin(), self.findRadius)
        for _, creep in pairs(creeps) do
            if creep:IsAlive() and creep:entindex() ~= target:entindex() then
                local info = 
                {
                    creep = event.creep,
                    caster = event.caster,
                    Ability = keys.ability,
                    EffectName = "particles/custom/towers/hail/attack.vpcf",
                    iMoveSpeed = self.tower:GetProjectileSpeed(),
                    vSourceLoc= caster:GetAbsOrigin(),
                    bReplaceExisting = false,
                    flExpireTime = GameRules:GetGameTime() + 10,
                }
                projectile = ProjectileManager:CreateTrackingProjectile(info)
            end
        end
    end 

    self.tower:SetModifierStackCount("modifier_storm_passive", self.tower, self.attacks_required - self.current_attacks)
end

function HailTower:OnAttackLanded(keys)
    local target = keys.target
    local damage = self.tower:GetAverageTrueAttackDamage(target)

    local crit = false
    if RollPercentage(self.crit_chance) then
        damage = damage * self.damageMultiplier
        crit = true
    end

    local damage_done = DamageEntity(target, self.tower, damage)

    -- Show popup on critz
    if crit and damage_done then
        PopupLightDamage(target, math.floor(damage_done))
    end
end

function HailTower:OnProjectileHit(keys)
    self:OnAttackLanded({target = keys.target})
end

function HailTower:ApplyUpgradeData(data)
    if data.current_attacks then
        self.current_attacks = data.current_attacks
        self.tower:SetModifierStackCount("modifier_storm_passive", self.tower, self.attacks_required - self.current_attacks)
    end
end

function HailTower:GetUpgradeData()
    return {
        current_attacks = self.current_attacks
    }
end

function HailTower:OnCreated()
    self.ability = AddAbility(self.tower, "hail_tower_storm", self.tower:GetLevel())
    self.attacks_required = self.ability:GetLevelSpecialValueFor("attacks_required", self.ability:GetLevel()-1)
    self.current_attacks = 0
    self.findRadius = self.ability:GetSpecialValueFor("hail_radius") + self.tower:GetHullRadius()
    self.tower:SetModifierStackCount("modifier_storm_passive", self.tower, self.attacks_required)
    self.crit_chance = self.ability:GetLevelSpecialValueFor("crit_chance", self.ability:GetLevel()-1)
    self.damageMultiplier = self.ability:GetSpecialValueFor("damage_mult") / 100 
end