musketeer_flurry = class( {} )

LinkLuaModifier( "modifier_musketeer_flurry", "lua_abilities/musketeer_flurry.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function musketeer_flurry:OnSpellStart()
	local caster = self:GetCaster()
	
	caster:AddNewModifier( caster, self, "modifier_musketeer_flurry", {
		duration = self:GetSpecialValueFor( "duration" ),
	} )
	
	local attackTimer = caster:TimeUntilNextAttack()
	
	caster:AttackNoEarlierThan( 0 )
	
	if caster:IsAttacking() and attackTimer > 0 then
		local target = caster:GetAttackTarget()
		caster:Stop()
		caster:SetAttacking( target )
	end
	
	caster:EmitSound( "Hero_Pangolier.Swashbuckle.Cast" )
end

-------------------------------------------------------------------------------- 

modifier_musketeer_flurry = class({})

--------------------------------------------------------------------------------

function modifier_musketeer_flurry:IsHidden()
	return false
end

function modifier_musketeer_flurry:IsDebuff()
	return false
end

function modifier_musketeer_flurry:IsPurgable()
	return true
end

function modifier_musketeer_flurry:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_musketeer_flurry:GetEffectName()
	return "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_images.vpcf"
end

--------------------------------------------------------------------------------

function modifier_musketeer_flurry:OnCreated( event )
	self:OnRefresh( event )
end

--------------------------------------------------------------------------------

function modifier_musketeer_flurry:OnRefresh( event )
	local spell = self:GetAbility()
	
	self.attackSpeed = spell:GetSpecialValueFor( "bonus_attack_speed" )
	
	if IsServer() then
		self.radius = spell:GetSpecialValueFor( "radius" )
		self.distance = spell:GetSpecialValueFor( "line_distance" )
		self.damage = spell:GetSpecialValueFor( "damage" )
		self.damageType = spell:GetAbilityDamageType()
		
		self.targetTeam = spell:GetAbilityTargetTeam()
		self.targetType = spell:GetAbilityTargetType()
		self.targetFlags = spell:GetAbilityTargetFlags()
		
		self:SetStackCount( spell:GetSpecialValueFor( "attack_count" ) )
		
		spell:EndCooldown()
		spell:SetActivated( false )
	end

--------------------------------------------------------------------------------

	function modifier_musketeer_flurry:OnRemoved()
		if IsServer() then
			local spell = self:GetAbility()
			
			spell:UseResources( false, false, true )
			spell:SetActivated( true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_musketeer_flurry:OnStackCountChanged( oldStacks )
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_musketeer_flurry:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_EVENT_ON_ATTACK,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_musketeer_flurry:GetModifierAttackSpeedBonus_Constant( event )
	return self.attackSpeed
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_musketeer_flurry:OnAttack( event )
		local parent = self:GetParent()
		
		if parent == event.attacker then
			local spell = self:GetAbility()
			local target = event.target
			local originParent = parent:GetOrigin()
			local fwdParent = parent:GetForwardVector()
			
			local units = FindUnitsInLine(
				parent:GetTeamNumber(),
				originParent,
				originParent + ( fwdParent * self.distance ),
				nil,
				self.radius,
				spell:GetAbilityTargetTeam(),
				spell:GetAbilityTargetType(),
				spell:GetAbilityTargetFlags()
			)
			
			for _, unit in pairs( units ) do
				ApplyDamage( {
					victim = unit,
					attacker = parent,
					damage = self.damage,
					damage_type = self.damageType,
					damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
					ability = spell,
				} )
				
				unit:EmitSound( "Hero_Pangolier.Swashbuckle.Attack" )
			end
			
			local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_images.vpcf", PATTACH_WORLDORIGIN, parent )
			ParticleManager:SetParticleControl( part, 0, originParent + ( fwdParent * 80.0 ) )
			ParticleManager:SetParticleControlForward( part, 3, fwdParent )
			
			parent:EmitSound( "Hero_Pangolier.Swashbuckle" )
			
			self:DecrementStackCount()
		end
	end
end