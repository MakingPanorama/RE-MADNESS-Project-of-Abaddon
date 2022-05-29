runed_artifact_lua = class({})
LinkLuaModifier( "modifier_runed_artifact_lua_passive", "lua_abilities\runed_artifact_lua.lua" ,LUA_MODIFIER_MOTION_NONE )

function runed_artifact_lua:GetIntrinsicModifierName()
	return "modifier_runed_artifact_lua_passive"
end

modifier_runed_artifact_lua_passive = class

function modifier_runed_artifact_lua_passive:OnCreated()
	self.status_amp = self:GetSpecialValueFor("status_amp")
end

function modifier_runed_artifact_lua_passive:DeclareFunctions()
	return {}
end

function modifier_runed_artifact_lua_passive:GetModifierStatusAmplify_Percentage()
	return self.status_amp
end