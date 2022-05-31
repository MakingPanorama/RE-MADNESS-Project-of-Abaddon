--  Author: Firetoad
--  Date:       19.07.2016
--  Last Update:  26.03.2017
--  Maelstrom and Mjollnir

-- Edited Version from dota imba.

item_ability_mjolnir3 = class({})
item_ability_mjolnir3_op = class({})
LinkLuaModifier( "modifier_item_ability_mjolnir3", "item_abilities/item_ability_mjolnir3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ability_mjolnir3_op", "item_abilities/item_ability_mjolnir3.lua", LUA_MODIFIER_MOTION_NONE )

function item_ability_mjolnir3:GetIntrinsicModifierName()
  return "modifier_item_ability_mjolnir3" end

function item_ability_mjolnir3_op:GetIntrinsicModifierName()
  return "modifier_item_ability_mjolnir3_op" end


-----------------------------------------------------------------------------------------------------------
--  Maelstrom passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

modifier_item_ability_mjolnir3 = class({}) 
function modifier_item_ability_mjolnir3:IsHidden() return true end
function modifier_item_ability_mjolnir3:IsDebuff() return false end
function modifier_item_ability_mjolnir3:IsPurgable() return false end
function modifier_item_ability_mjolnir3:IsPermanent() return true end


-- Declare modifier events/properties
function modifier_item_ability_mjolnir3:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED,
  }
  return funcs
end

-- On attack landed, roll for proc and apply stacks
function modifier_item_ability_mjolnir3:OnAttackLanded( keys )
  if IsServer() then
    local attacker = self:GetParent()
    if attacker:PassivesDisabled() then return end
    -- If this attack is irrelevant, do nothing
    if attacker ~= keys.attacker then
      return end

    -- If this is an illusion, do nothing either
    if attacker:IsIllusion() then
      return end

    -- If the target is invalid, still do nothing
    local target = keys.target
    if (not target:IsHero() and not target:IsCreep())   or attacker:GetTeam() == target:GetTeam() then
      return end

    -- All conditions met, stack the proc counter up
    local ability = self:GetAbility()   

    -- zap the target's ass
    local proc_chance = ability:GetSpecialValueFor("chain_chance")
    if RollPercentage(proc_chance) then
      LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("chain_damage"), ability:GetSpecialValueFor("chain_radius"))
    end
  end
end


modifier_item_ability_mjolnir3_op = class({}) 
function modifier_item_ability_mjolnir3_op:IsHidden() return true end
function modifier_item_ability_mjolnir3_op:IsDebuff() return false end
function modifier_item_ability_mjolnir3_op:IsPurgable() return false end
function modifier_item_ability_mjolnir3_op:IsPermanent() return true end


-- Declare modifier events/properties
function modifier_item_ability_mjolnir3_op:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED,
  }
  return funcs
end

-- On attack landed, roll for proc and apply stacks
function modifier_item_ability_mjolnir3_op:OnAttackLanded( keys )
  if IsServer() then
    local attacker = self:GetParent()

    -- If this attack is irrelevant, do nothing
    if attacker ~= keys.attacker then
      return end
    if attacker:PassivesDisabled() then return end
    -- If this is an illusion, do nothing either
    if attacker:IsIllusion() then
      return end

    -- If the target is invalid, still do nothing
    local target = keys.target
    if (not target:IsHero() and not target:IsCreep())   or attacker:GetTeam() == target:GetTeam() then
      return end

    -- All conditions met, stack the proc counter up
    local ability = self:GetAbility()   

    -- zap the target's ass
    local proc_chance = ability:GetSpecialValueFor("chain_chance")
    if RollPercentage(proc_chance) then
      LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("chain_damage"), ability:GetSpecialValueFor("chain_radius"))
    end
  end
end


function LaunchLightning(caster, target, ability, damage, bounce_radius)

  -- Parameters
  local targets_hit = { target }
  local search_sources = { target }

  -- Play initial sound
  caster:EmitSound("Item.Maelstrom.Chain_Lightning")

  -- Play first bounce sound
  target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

  -- Zap initial target
  ZapThem(caster, ability, caster, target, damage)

  -- While there are potential sources, keep looping
  while #search_sources > 0 and #targets_hit < ability:GetSpecialValueFor("chain_strikes") do

    -- Loop through every potential source this iteration
    for potential_source_index, potential_source in pairs(search_sources) do

      -- Iterate through potential targets near this source
      local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), potential_source:GetAbsOrigin(), nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
      for _, potential_target in pairs(nearby_enemies) do
        
        -- Check if this target was already hit
        local already_hit = false
        for _, hit_target in pairs(targets_hit) do
          if potential_target == hit_target then
            already_hit = true
            break
          end
        end

        -- If not, zap it from this source, and mark it as a hit target and potential future source
        if not already_hit then
          ZapThem(caster, ability, potential_source, potential_target, damage)
          targets_hit[#targets_hit+1] = potential_target
          search_sources[#search_sources+1] = potential_target
        end
      end

      -- Remove this potential source
      table.remove(search_sources, potential_source_index)
    end
  end
end

-- One bounce. Particle + damage
function ZapThem(caster, ability, source, target, damage)

  -- Draw particle
  local bounce_pfx = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, source)
  ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(bounce_pfx, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
  ParticleManager:ReleaseParticleIndex(bounce_pfx)

  -- Damage target
  ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end