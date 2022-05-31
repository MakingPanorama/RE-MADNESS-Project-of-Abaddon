local m = class({})

LinkLuaModifier('modifier_rot_bom_effect', "npc_abilities\modifier_rot_bom_effect", LUA_MODIFIER_MOTION_HORIZONTAL)

function m:GetIntrinsicModifierName()
	return 'modifier_rot_bom_effect'
end

pudge_rot_bom = m