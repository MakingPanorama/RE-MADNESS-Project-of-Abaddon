function LaunShe(keys)
	local caster = keys.caster
	local targets = keys.target_entities
	for _, target in pairs(targets) do
		caster:PerformAttack(target,true,false,true,false,true,false,false)
	end
end


