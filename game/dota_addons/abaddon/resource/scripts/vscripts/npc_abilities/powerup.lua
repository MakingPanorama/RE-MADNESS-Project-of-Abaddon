LinkLuaModifier( "wisp_powerup_dmg_counter", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "wisp_powerup_armor_counter", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "wisp_powerup_hp_counter", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "wisp_powerup_as_counter", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff
LinkLuaModifier( "wisp_powerup_ms_counter", "heroes/hero_wisp/powerup.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff

wisp_powerup_dmg = class({})

function wisp_powerup_dmg:GetIntrinsicModifierName()
	return "wisp_powerup_dmg_counter"
end

function wisp_powerup_dmg:GetManaCost()
	local modifier_stacks = self:GetCaster():GetModifierStackCount("wisp_powerup_dmg_counter", nil)
	local gold_per_upgrade = self:GetSpecialValueFor("gold_per_upgrade")
	local max_manacost = self:GetSpecialValueFor("max_gold_upgrade")
	local manacost = (modifier_stacks + 1) * gold_per_upgrade
	if max_manacost < manacost then
		return max_manacost
	else
		return manacost
	end
end

function wisp_powerup_dmg:OnSpellStart()
	local caster = self:GetCaster()
	local player = caster:GetPlayerID()
	local stack_count = caster:GetModifierStackCount("wisp_powerup_dmg_counter", nil)
	local gold_cost = self:GetManaCost()
	local player_gold = PlayerResource:GetGold(player)
	local player_reliable_gold = PlayerResource:GetReliableGold(player)
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")			
	if stack_count >= max_upgrade then
		return
	end
			
	if player_gold < gold_cost then
		return
	end
	
	caster:SetModifierStackCount("wisp_powerup_dmg_counter", caster, stack_count + 1)
	if player_reliable_gold< gold_cost then
		PlayerResource:ModifyGold(player, -player_reliable_gold, true, 0)
		PlayerResource:ModifyGold(player, player_reliable_gold - gold_cost, false, 0)
	else
		PlayerResource:ModifyGold(player, -gold_cost, true, 0)
	end
	
end

--------------------------------------------------------------------------------

wisp_powerup_dmg_counter = class({})

function wisp_powerup_dmg_counter:IsPurgable() return false 
end

function wisp_powerup_dmg_counter:IsHidden() return false
end

function wisp_powerup_dmg_counter:IsBuff() return true
end

--------------------------------------------------------------------------------
wisp_powerup_armor = class({})

function wisp_powerup_armor:GetIntrinsicModifierName()
	return "wisp_powerup_armor_counter"
end

function wisp_powerup_armor:GetManaCost()
	local modifier_stacks = self:GetCaster():GetModifierStackCount("wisp_powerup_armor_counter", nil)
	local gold_per_upgrade = self:GetSpecialValueFor("gold_per_upgrade")
	local max_manacost = self:GetSpecialValueFor("max_gold_upgrade")
	local manacost = (modifier_stacks + 1) * gold_per_upgrade
	if max_manacost < manacost then
		return max_manacost
	else
		return manacost
	end
end

function wisp_powerup_armor:OnSpellStart()
	local caster = self:GetCaster()
	local player = caster:GetPlayerID()
	local stack_count = caster:GetModifierStackCount("wisp_powerup_armor_counter", nil)
	local gold_cost = self:GetManaCost()
	local player_gold = PlayerResource:GetGold(player)
	local player_reliable_gold = PlayerResource:GetReliableGold(player)
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")			
	if stack_count >= max_upgrade then
		return
	end
			
	if player_gold < gold_cost then
		return
	end
	
	caster:SetModifierStackCount("wisp_powerup_armor_counter", caster, stack_count + 1)
	if player_reliable_gold< gold_cost then
		PlayerResource:ModifyGold(player, -player_reliable_gold, true, 0)
		PlayerResource:ModifyGold(player, player_reliable_gold - gold_cost, false, 0)
	else
		PlayerResource:ModifyGold(player, -gold_cost, true, 0)
	end
	
end

--------------------------------------------------------------------------------

wisp_powerup_armor_counter = class({})

function wisp_powerup_armor_counter:IsPurgable() return false 
end

function wisp_powerup_armor_counter:IsHidden() return false
end

function wisp_powerup_armor_counter:IsBuff() return true
end

--------------------------------------------------------------------------------
wisp_powerup_hp = class({})

function wisp_powerup_hp:GetIntrinsicModifierName()
	return "wisp_powerup_hp_counter"
end

function wisp_powerup_hp:GetManaCost()
	local modifier_stacks = self:GetCaster():GetModifierStackCount("wisp_powerup_hp_counter", nil)
	local gold_per_upgrade = self:GetSpecialValueFor("gold_per_upgrade")
	local max_manacost = self:GetSpecialValueFor("max_gold_upgrade")
	local manacost = (modifier_stacks + 1) * gold_per_upgrade
	if max_manacost < manacost then
		return max_manacost
	else
		return manacost
	end
end

function wisp_powerup_hp:OnSpellStart()
	local caster = self:GetCaster()
	local player = caster:GetPlayerID()
	local stack_count = caster:GetModifierStackCount("wisp_powerup_hp_counter", nil)
	local gold_cost = self:GetManaCost()
	local player_gold = PlayerResource:GetGold(player)
	local player_reliable_gold = PlayerResource:GetReliableGold(player)
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")			
	if stack_count >= max_upgrade then
		return
	end
			
	if player_gold < gold_cost then
		return
	end
	
	caster:SetModifierStackCount("wisp_powerup_hp_counter", caster, stack_count + 1)
	if player_reliable_gold< gold_cost then
		PlayerResource:ModifyGold(player, -player_reliable_gold, true, 0)
		PlayerResource:ModifyGold(player, player_reliable_gold - gold_cost, false, 0)
	else
		PlayerResource:ModifyGold(player, -gold_cost, true, 0)
	end
	
end

--------------------------------------------------------------------------------

wisp_powerup_hp_counter = class({})

function wisp_powerup_hp_counter:IsPurgable() return false 
end

function wisp_powerup_hp_counter:IsHidden() return false
end

function wisp_powerup_hp_counter:IsBuff() return true
end

--------------------------------------------------------------------------------
wisp_powerup_as = class({})

function wisp_powerup_as:GetIntrinsicModifierName()
	return "wisp_powerup_as_counter"
end

function wisp_powerup_as:GetManaCost()
	local modifier_stacks = self:GetCaster():GetModifierStackCount("wisp_powerup_as_counter", nil)
	local gold_per_upgrade = self:GetSpecialValueFor("gold_per_upgrade")
	local max_manacost = self:GetSpecialValueFor("max_gold_upgrade")
	local manacost = (modifier_stacks + 1) * gold_per_upgrade
	if max_manacost < manacost then
		return max_manacost
	else
		return manacost
	end
end

function wisp_powerup_as:OnSpellStart()
	local caster = self:GetCaster()
	local player = caster:GetPlayerID()
	local stack_count = caster:GetModifierStackCount("wisp_powerup_as_counter", nil)
	local gold_cost = self:GetManaCost()
	local player_gold = PlayerResource:GetGold(player)
	local player_reliable_gold = PlayerResource:GetReliableGold(player)
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")			
	if stack_count >= max_upgrade then
		return
	end
			
	if player_gold < gold_cost then
		return
	end
	
	caster:SetModifierStackCount("wisp_powerup_as_counter", caster, stack_count + 1)
	if player_reliable_gold< gold_cost then
		PlayerResource:ModifyGold(player, -player_reliable_gold, true, 0)
		PlayerResource:ModifyGold(player, player_reliable_gold - gold_cost, false, 0)
	else
		PlayerResource:ModifyGold(player, -gold_cost, true, 0)
	end
	
end

--------------------------------------------------------------------------------

wisp_powerup_as_counter = class({})

function wisp_powerup_as_counter:IsPurgable() return false 
end

function wisp_powerup_as_counter:IsHidden() return false
end

function wisp_powerup_as_counter:IsBuff() return true
end

--------------------------------------------------------------------------------
wisp_powerup_ms = class({})

function wisp_powerup_ms:GetIntrinsicModifierName()
	return "wisp_powerup_ms_counter"
end

function wisp_powerup_ms:GetManaCost()
	local modifier_stacks = self:GetCaster():GetModifierStackCount("wisp_powerup_ms_counter", nil)
	local gold_per_upgrade = self:GetSpecialValueFor("gold_per_upgrade")
	local max_manacost = self:GetSpecialValueFor("max_gold_upgrade")
	local manacost = (modifier_stacks + 1) * gold_per_upgrade
	if max_manacost < manacost then
		return max_manacost
	else
		return manacost
	end
end

function wisp_powerup_ms:OnSpellStart()
	local caster = self:GetCaster()
	local player = caster:GetPlayerID()
	local stack_count = caster:GetModifierStackCount("wisp_powerup_ms_counter", nil)
	local gold_cost = self:GetManaCost()
	local player_gold = PlayerResource:GetGold(player)
	local player_reliable_gold = PlayerResource:GetReliableGold(player)
	local max_upgrade = self:GetSpecialValueFor("max_upgrade")			
	if stack_count >= max_upgrade then
		return
	end
	
	if player_gold < gold_cost then
		return
	end
	
	caster:SetModifierStackCount("wisp_powerup_ms_counter", caster, stack_count + 1)
	if player_reliable_gold< gold_cost then
		PlayerResource:ModifyGold(player, -player_reliable_gold, true, 0)
		PlayerResource:ModifyGold(player, player_reliable_gold - gold_cost, false, 0)
	else
		PlayerResource:ModifyGold(player, -gold_cost, true, 0)
	end
	
end

--------------------------------------------------------------------------------

wisp_powerup_ms_counter = class({})

function wisp_powerup_ms_counter:IsPurgable() return false 
end

function wisp_powerup_ms_counter:IsHidden() return false
end

function wisp_powerup_ms_counter:IsBuff() return true
end

--------------------------------------------------------------------------------

modifier_wisp_powerup_dmg_buff = class({})

function modifier_wisp_powerup_dmg_buff:IsPurgable() return false 
end

function modifier_wisp_powerup_dmg_buff:IsHidden() return false
end

function modifier_wisp_powerup_dmg_buff:IsBuff() return true
end

function modifier_wisp_powerup_dmg_buff:DeclareFunctions()
    return {   
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE ,
--        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
       }
end

function modifier_wisp_powerup_dmg_buff:GetModifierPreAttack_BonusDamage()		-- Static + stacks	
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("upgrade_value")--self:GetStackCount()*2
end

function modifier_wisp_powerup_dmg_buff:GetModifierBaseAttack_BonusDamage()			-- Static + stacks
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("upgrade_value")--self:GetStackCount()*2
end

modifier_wisp_powerup_hp_buff = class({})

function modifier_wisp_powerup_hp_buff:IsPurgable() return false 
end

function modifier_wisp_powerup_hp_buff:IsHidden() return false
end

function modifier_wisp_powerup_hp_buff:IsBuff() return true
end

function modifier_wisp_powerup_hp_buff:DeclareFunctions()
    return {   
--        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
       }
end


function modifier_wisp_powerup_hp_buff:GetModifierExtraHealthPercentage()	
	return self:GetStackCount()*0.1--self:GetStackCount()*2
end

function modifier_wisp_powerup_hp_buff:GetModifierHealthBonus()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("upgrade_value")--self:GetStackCount()*2
end

modifier_wisp_powerup_armor_buff = class({})

function modifier_wisp_powerup_armor_buff:IsPurgable() return false 
end

function modifier_wisp_powerup_armor_buff:IsHidden() return false
end

function modifier_wisp_powerup_armor_buff:IsBuff() return true
end

function modifier_wisp_powerup_armor_buff:DeclareFunctions()
    return {   
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        }
end

function modifier_wisp_powerup_armor_buff:GetModifierPhysicalArmorBonus()			-- Static + stacks
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("upgrade_value")--self:GetStackCount()*2
end

modifier_wisp_powerup_as_buff = class({})

function modifier_wisp_powerup_as_buff:IsPurgable() return false 
end

function modifier_wisp_powerup_as_buff:IsHidden() return false
end

function modifier_wisp_powerup_as_buff:IsBuff() return true
end

function modifier_wisp_powerup_as_buff:DeclareFunctions()
    return {   
       MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        }
end

function modifier_wisp_powerup_as_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("upgrade_value")--self:GetStackCount()*2
end
 

modifier_wisp_powerup_ms_buff = class({})

function modifier_wisp_powerup_ms_buff:IsPurgable() return false 
end

function modifier_wisp_powerup_ms_buff:IsHidden() return false
end

function modifier_wisp_powerup_ms_buff:IsBuff() return true
end

function modifier_wisp_powerup_ms_buff:DeclareFunctions()
    return {   
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        }
end

function modifier_wisp_powerup_ms_buff:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("upgrade_value")--self:GetStackCount()*2
end


 

