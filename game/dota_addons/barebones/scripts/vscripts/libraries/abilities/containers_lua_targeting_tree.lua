containers_lua_targeting_tree = class({})

--------------------------------------------------------------------------------
function containers_lua_targeting_tree:GetBehavior()
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))

  if result then 
    return result.behavior 
  else
    return self.BaseClass.GetBehavior(self)
  end
end

function containers_lua_targeting_tree:GetAOERadius()
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))

  if result then
    return result.aoe
  else
    return self.BaseClass.GetAOERadius(self)
  end
end

function containers_lua_targeting_tree:GetCastRange(vLocation, hTarget)
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))
  
  if result then
    return result.range
  else
    return self.BaseClass.GetCastRange(self, vLocation, hTarget)
  end
end

function containers_lua_targeting_tree:GetChannelTime()
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))

  if result then
    return result.channelTime
  else
    return self.BaseClass.GetChannelTime(self)
  end
end

function containers_lua_targeting_tree:GetChannelledManaCostPerSecond(iLevel)
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))
  
  if result then
    return result.channelCost
  else
    return self.BaseClass.GetChannelledManaCostPerSecond(self, iLevel)
  end
end

--------------------------------------------------------------------------------

function containers_lua_targeting_tree:CastFilterResultTarget( hTarget )
  local result = CustomNetTables:GetTableValue("containers_lua", tostring(self:entindex()))
  print(result.targetTeam, result.targetType, result.targetFlags)
  if not result then
    return UF_SUCCESS
  end

  local targetType = result.targetType
  local treeTarget =   bit.band(targetType, DOTA_UNIT_TARGET_TREE) ~= 0
  local customTarget =   bit.band(targetType, DOTA_UNIT_TARGET_CUSTOM) ~= 0

  if treeTarget and customTarget and hTarget.GetUnitName and (hTarget:GetUnitName() == "npc_dota_sentry_wards" or hTarget:GetUnitName() == "npc_dota_observer_wards") then
    return UF_SUCCESS
  end
 
  local nResult = UnitFilter( hTarget, result.targetTeam, result.targetType, result.targetFlags, self:GetCaster():GetTeamNumber() )
  if nResult ~= UF_SUCCESS then
    return nResult
  end
 
  return UF_SUCCESS
end
 
--------------------------------------------------------------------------------
 
function containers_lua_targeting_tree:GetCustomCastErrorTarget( hTarget )
  return ""
end

--------------------------------------------------------------------------------

function containers_lua_targeting_tree:OnChannelThink(flInterval)
  local item = self.proxyItem
  self.proxyItem:OnChannelThink(flInterval)
end

function containers_lua_targeting_tree:OnChannelFinish(bInterrupted)
  local item = self.proxyItem
  self.proxyItem:OnChannelFinish(bInterrupted)
end

function containers_lua_targeting_tree:OnSpellStart()
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

  --[[print(target, pos)
  if target and target.CutDown then 
    PrintTable(getmetatable(target)) 
    target:CutDown(self:GetCaster():GetTeamNumber())
  end]]
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
