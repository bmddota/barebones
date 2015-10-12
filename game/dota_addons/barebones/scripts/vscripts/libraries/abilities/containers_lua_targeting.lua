containers_lua_targeting = class({})

--------------------------------------------------------------------------------
function containers_lua_targeting:GetBehavior()
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))

  if result then 
    if bit.band(result.behavior, DOTA_ABILITY_BEHAVIOR_CHANNELLED) ~= 0 then return result.behavior - DOTA_ABILITY_BEHAVIOR_CHANNELLED end
    print('not channeled')
    return result.behavior 
  else
    return self.BaseClass.GetBehavior(self)
  end
end

function containers_lua_targeting:GetAOERadius()
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))

  if result then
    return result.aoe
  else
    return self.BaseClass.GetAOERadius(self)
  end
end

function containers_lua_targeting:GetCastRange(vLocation, hTarget)
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))
  
  if result then
    return result.range
  else
    return self.BaseClass.GetCastRange(self, vLocation, hTarget)
  end
end

function containers_lua_targeting:GetChannelTime()
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))

  if result then
    return result.channelTime
  else
    return self.BaseClass.GetChannelTime(self)
  end
end

function containers_lua_targeting:GetChannelledManaCostPerSecond(iLevel)
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))
  
  if result then
    return result.channelCost
  else
    return self.BaseClass.GetChannelledManaCostPerSecond(self, iLevel)
  end
end

--------------------------------------------------------------------------------

function containers_lua_targeting:CastFilterResultTarget( hTarget )
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))
  print(result.targetTeam, result.targetType, result.targetFlags)
  if not result then
    return UF_SUCCESS
  end
 
  local nResult = UnitFilter( hTarget, result.targetTeam, result.targetType, result.targetFlags, self:GetCaster():GetTeamNumber() )
  if nResult ~= UF_SUCCESS then
    return nResult
  end
 
  return UF_SUCCESS
end
 
--------------------------------------------------------------------------------
 
function containers_lua_targeting:GetCustomCastErrorTarget( hTarget )
  return ""
end

--------------------------------------------------------------------------------

function containers_lua_targeting:OnChannelThink(flInterval)
  local item = self.proxyItem
  self.proxyItem:OnChannelThink(flInterval)
end

function containers_lua_targeting:OnChannelFinish(bInterrupted)
  local item = self.proxyItem
  self.proxyItem:OnChannelFinish(bInterrupted)
end

function containers_lua_targeting:OnSpellStart()
  print("Onspellstart")
  if IsServer() then
    print("server:")
  else
    print("client:")
  end

  local target = self:GetCursorTarget()
  local pos = self:GetCursorPosition()

  local item = self.proxyItem
  local owner = item:GetOwner()

  local behavior =     item:GetBehavior()
  local channelled =   bit.band(behavior, DOTA_ABILITY_BEHAVIOR_CHANNELLED) ~= 0

  item:PayGoldCost()
  item:PayManaCost()
  item:StartCooldown(item:GetCooldown(item:GetLevel()))
  owner:SetCursorPosition(pos)
  owner:SetCursorCastTarget(target)

  item:OnSpellStart()

  --[[local hCaster = self:GetCaster()
  local hTarget = self:GetCursorTarget()

  if hCaster == nil or hTarget == nil or hTarget:TriggerSpellAbsorb( this ) then
    return
  end

  local vPos1 = hCaster:GetOrigin()
  local vPos2 = hTarget:GetOrigin()

  GridNav:DestroyTreesAroundPoint( vPos1, 300, false )
  GridNav:DestroyTreesAroundPoint( vPos2, 300, false )

  hCaster:SetOrigin( vPos2 )
  hTarget:SetOrigin( vPos1 )

  FindClearSpaceForUnit( hCaster, vPos2, true )
  FindClearSpaceForUnit( hTarget, vPos1, true )
  
  hTarget:Interrupt()

  local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
  ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
  ParticleManager:ReleaseParticleIndex( nCasterFX )

  local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
  ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
  ParticleManager:ReleaseParticleIndex( nTargetFX )

  EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hCaster )
  EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )

  hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )]]
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
