

function Shotgun_Shoot( args )
        local caster = args.caster

        local projectile = {
          EffectName = "particles/sniper_bullet_mg.vpcf",
          vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
          fDistance = args.FixedDistance,
          fStartRadius = 30,
          fEndRadius = 40,
          Source = caster,
          fExpireTime = 8.0,
          vVelocity = caster:GetForwardVector() * args.MoveSpeed, -- RandomVector(1000),
          UnitBehavior = PROJECTILES_DESTROY,
          bMultipleHits = false,
          bIgnoreSource = true,
          TreeBehavior = PROJECTILES_DESTROY,
          bCutTrees = true,
          WallBehavior = PROJECTILES_NOTHING,
          GroundBehavior = PROJECTILES_NOTHING,
          fGroundOffset = 80,
          nChangeMax = 1,
          bRecreateOnChange = true,
          bZCheck = false,
          bGroundLock = true,
          draw = bDEBUGDRAW,
          bProvidesVision = true,
          iVisionRadius = args.VisionRadius,
          UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() or unit:GetUnitName() == "npc_sniper_barricade" end,
          OnUnitHit = function(self, unit)
                local totalDamage = args.Damage
                local target = unit
                local damageTable = {
                                victim = target,
                                attacker = caster,
                                damage = totalDamage,
                                damage_type = DAMAGE_TYPE_PHYSICAL,
                        }
                ApplyDamage(damageTable)

                if unit:GetUnitName() == "npc_dota_hero_drow_ranger" then
                        ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                elseif unit:GetUnitName() == "npc_sniper_barricade" then
                        ParticleManager:CreateParticle("particles/newplayer_fx/npx_wood_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                        unit:EmitSound("Item_Sniper.WoodBreak")            
                end
          end
        }

        for i=-25,25,10 do
                local shotgun = shallowcopy(projectile)
                shotgun.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * args.MoveSpeed
                Projectiles:CreateProjectile(shotgun)
        end
end

