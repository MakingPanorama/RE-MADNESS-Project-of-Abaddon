if(IsClient() == false) then
    return
  end
  C_DOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
      if(not self or self:IsNull() == true) then
          return 0
      end
      local caster = self:GetCaster()
      if(not caster or caster:IsNull() == true) then
          return 0
      end
      return caster:GetCastRangeBonus()
  end
   
  C_DOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
      if(not self or self:IsNull() == true) then
          return 0
      end
      local caster = self:GetCaster()
      if(not caster or caster:IsNull() == true) then
          return 0
      end
      return caster:GetCastRangeBonus()
  end