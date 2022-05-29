function DamageMagical( keys )
	local caster = keys.caster 
	local target = keys.target 

	local damage_pct = (keys.Damage or 0 ) / 100

	if not caster or not target or caster == target then return end
	
	local damage = (caster:GetAverageTrueAttackDamage(target) or 0 ) * damage_pct 

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE , target, damage, nil)

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function DamagePHYSICAL( keys )
	local caster = keys.caster 
	local target = keys.target 

	local damage_pct = (keys.Damage or 0 ) / 100

	if not caster or not target or caster == target then return end
	
	local damage = (caster:GetAverageTrueAttackDamage(target) or 0 ) * damage_pct 

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE , target, damage, nil)

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function DamagePURE( keys )
	local caster = keys.caster 
	local target = keys.target 

	local damage_pct = (keys.Damage or 0 ) / 100

	if not caster or not target or caster == target then return end
	
	local damage = (caster:GetAverageTrueAttackDamage(target) or 0 ) * damage_pct 

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL , target, damage, nil)

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})
end