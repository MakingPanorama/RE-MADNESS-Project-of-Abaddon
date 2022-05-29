function SharpnessAxe(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)

	target:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( nFXIndex, 1, caster:GetForwardVector() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 10, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

function SharpnessAxeModifier(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local proc_chance = ability:GetSpecialValueFor("chance")
	local chance = RandomInt(1, 100)
	
	local	caster:IsIllusion() 
		
	local  chance <= proc_chance then
	
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_yuno_sharpness_axe_attack", {})
	end
end