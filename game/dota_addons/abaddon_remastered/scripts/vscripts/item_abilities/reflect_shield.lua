function reflect(event)
local caster = event.caster
local target = event.unit
local gay = event.damage

	ApplyDamage({
		victim = event.attacker,
		attacker = caster,
		damage = gay,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
	})
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    --ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() - Vector(0, 0, 500))
    --ParticleManager:SetParticleControl(particle, 1, event.attacker:GetAbsOrigin())
end