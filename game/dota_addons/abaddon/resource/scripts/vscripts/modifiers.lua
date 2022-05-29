-- The below is for creating a transparent modifier effect (anyone, any ability can use it)
transparency = {
    DeclareFunctions = function () return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
    GetModifierInvisibilityLevel = function () return 1 end,
    IsHidden = function () return true end,
    IsPurgable = function () return false end
}


-- The below is for creating a move_speed max/limit modifier effect (anyone, any ability can use it)
move_speed_max = {
    DeclareFunctions = function () return {MODIFIER_PROPERTY_MOVESPEED_MAX, MODIFIER_PROPERTY_MOVESPEED_LIMIT} end,
    GetModifierMoveSpeed_Max = function () return 2000 end,
    GetModifierMoveSpeed_Limit = function () return 2000 end,
    IsHidden = function () return true end,
    IsPurgable = function () return false end,
    IsPermanent = function () return true end
}

-- The below is for spell lifesteal of Nightmare

nightmare_spell_lifesteal ={
    DeclareFunctions = function () return {MODIFIER_EVENT_ON_TAKEDAMAGE} end,
    IsHidden = function () return true end,
    IsPurgable = function () return false end,
    IsDebuff = function () return false end,
} 

function nightmare_spell_lifesteal:OnTakeDamage(event)
    local ability = event.inflictor
    local hero = event.attacker
    if ability ~= nil and hero:GetUnitName() == "npc_dota_hero_queenofpain" then
        local passive_ability = hero:GetAbilityByIndex(1)           -- This may be changed
        local percent = passive_ability:GetLevelSpecialValueFor("spell_life_steal_percent", (passive_ability:GetLevel() - 1))
        local heal = event.damage * percent / 100
        hero:Heal(heal,hero) 
        local particle_id = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
        Timers:CreateTimer(0.6, function()
            ParticleManager:DestroyParticle(particle_id, false)
        end)
    end
end

-- The below is for low-attack priority----

general_low_attack_priority ={
    IsHidden = function () return true end,
    IsPurgable = function () return false end,
    IsDebuff = function () return false end,
} 

function general_low_attack_priority:CheckState()
	local state = {
	   [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
	return state
end