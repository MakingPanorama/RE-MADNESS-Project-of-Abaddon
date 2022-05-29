-- Well tower's Spring Forward ability

well_tower_spring_forward = class({})
LinkLuaModifier("modifier_spring_forward", "lua_abilities/modifier_spring_forward", LUA_MODIFIER_MOTION_NONE)

function well_tower_spring_forward:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local playerID = caster:GetPlayerOwnerID()

    -- Apply flag to prevent buffing twice on the same short period of time
    if target.well_buffed then
        self:EndCooldown()
        return
    end
    target.well_buffed = true
    Timers:CreateTimer(1, function() 
        if IsValidEntity(target) then target.well_buffed = false end
    end)

    caster:EmitSound("Well.Cast")

    local particle1 = ParticleManager:CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())

    local particle2 = ParticleManager:CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN, target)
    ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())

    if target:HasModifier("modifier_spring_forward") then
        target:RemoveModifierByName("modifier_spring_forward")
    end

    target:AddNewModifier(caster, self, "modifier_spring_forward", {
        duration = self:GetSpecialValueFor("duration")
    })

	-- No cooldown sandbox option
	if GetPlayerData(playerID).noCD then
        self:EndCooldown()
    end
end

function well_tower_spring_forward:CastFilterResultTarget(target)
	local result = UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, self:GetCaster():GetTeamNumber())
end
