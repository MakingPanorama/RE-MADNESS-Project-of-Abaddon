

attacking_launches_arrow = class({})


function attacking_launches_arrow:GetIntrinsicModifierName()
    return "modifier_attacking_launches_arrow"
end



LinkLuaModifier("modifier_attacking_launches_arrow", "lua_abilities/attacking_launches_arrow.lua", LUA_MODIFIER_MOTION_NONE)


modifier_attacking_launches_arrow = class({})


function modifier_attacking_launches_arrow:IsHidden()
    return true
end


function modifier_attacking_launches_arrow:IsPurgable()
    return false
end


function modifier_attacking_launches_arrow:IsPermanent()
    return true
end


function modifier_attacking_launches_arrow:RemoveOnDeath()
    return false
end


function modifier_attacking_launches_arrow:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


if IsServer() then
    function modifier_attacking_launches_arrow:OnAttackLanded(keys)
        local ability = self:GetAbility()
        local parent = self:GetParent()
        local attacker = keys.attacker
        local target = keys.target

        if attacker
            and attacker == parent
            and attacker:IsRealHero()
            and target then

            local arrow = attacker:FindAbilityByName("windrunner_powershot")
            if not arrow then
                arrow = attacker:AddAbility("windrunner_powershot")
                arrow:SetHidden(true)
                arrow:SetStolen(true)
                arrow:SetLevel(1)
            end

            attacker:SetCursorPosition(attacker:GetAbsOrigin() + RandomVector(40))
            arrow:OnSpellStart()
		end
	end
end