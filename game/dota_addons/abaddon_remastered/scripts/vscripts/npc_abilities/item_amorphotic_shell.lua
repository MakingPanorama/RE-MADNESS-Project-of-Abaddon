item_amorphotic_shell = class({})
LinkLuaModifier( "modifier_item_amorphotic_shell", "npc_abilities\modifier_item_amorphotic_shell.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_amorphotic_shell_effect", "npc_abilities\modifier_item_amorphotic_shell_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_amorphotic_shell:GetIntrinsicModifierName()
	return "modifier_item_amorphotic_shell"
end
