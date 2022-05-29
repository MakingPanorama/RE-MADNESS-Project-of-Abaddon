earth_golem_passive = class({})
LinkLuaModifier( "modifier_item_craggy_coat", "lua_abilities/modifier_item_craggy_coat", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function earth_golem_passive:GetIntrinsicModifierName()
	return "modifier_item_craggy_coat"
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function earth_golem_passive:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
			local damageinfo =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = 250,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damageinfo )
			EmitSoundOn( "n_mud_golem.Boulder.Target", hTarget )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 1.25 } )
		end
	end

	return true
end
