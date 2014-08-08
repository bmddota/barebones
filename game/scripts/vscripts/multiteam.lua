DEFAULT_TEAM_COLORS = {
    Vector(255,0,0),
    Vector(0,255,0)
  }

if MultiTeam == nil then
  print ( '[MULTITEAM] creating MultiTeam' )
  MultiTeam = {}
  MultiTeam.__index = MultiTeam
end

function MultiTeam:new( o )
  o = o or {}
  setmetatable( o, MultiTeam )
  return o
end

function MultiTeam:start()
  self.Players = {}
  --{color=Vector(0,0,0), allies={1,2,3}}
  self.Teams = {}
  self.TeamNames = {}
  
  --ListenToGameEvent('player_connect_full', Dynamic_Wrap(MultiTeam, 'FullConnect'), self)
  --ListenToGameEvent('player_say', Dynamic_Wrap(MultiTeam, 'PlayerSay'), self)
  --ListenToGameEvent('player_connect', Dynamic_Wrap(MultiTeam, 'PlayerConnect'), self)
  
  --local wspawn = Entities:FindByClassname(nil, 'worldspawn')
  --wspawn:SetContextThink("PhysicsThink", Dynamic_Wrap( MultiTeam, 'Think' ), PHYSICS_THINK )
end

function MultiTeam:CreateTeam(team)
  local nextTeamID = #self.Teams + 1
  local name = "team" .. nextTeamID
  local table = {color = DEFAULT_TEAM_COLORS[nextTeamID], allies = {}, players = {}}
  if type(team) == "string" then
    name = team
  elseif type(team) == "table" then
    if team.color == nil then
      team.color = table.color
    end
    if team.allies == nil then
      team.allies = table.allies
    end
    if team.players == nil then
      team.players = table.players
    end

    table = team
  end

  table.name = name

  self.Teams[nextTeamID] = table
  self.TeamNames[name] = nextTeamID
end

function MultiTeam:GetPlayerTeam(player)
  player = self:GetPlayerID(player)

  return self.Players[player]
end

function MultiTeam:GetPlayerTeamName(player)
  player = self:GetPlayerID(player)

  return self.Teams[self.Players[player]].name
end

function MultiTeam:GetTeamColor(team)
  team = self:GetTeamID(team)

  return self.Teams[team].color
end

function MultiTeam:GetTeamAllies(team)
  team = self:GetTeamID(team)

  return self.Teams[team].allies
end

function MultiTeam:GetTeamName(team)
  team = self:GetTeamID(team)

  return self.Teams[team].name
end

function MultiTeam:SetPlayerTeam(player, team)
  player = self:GetPlayerID(player)
  team = self:GetTeamID(team)

  local prevTeamID = self.Players[player]
  local prevTeam = self.Teams[prevTeamID]

  if prevTeam ~= nil then
    prevTeam.players[player] = nil
  end

  self.Players[player] = team
  self.Teams[team].players[player] = 1
end

function MultiTeam:SetTeamColor(team, color)
  team = self:GetTeamID(team)
  if team ~= nil then
    self.Teams[team].color = color
  end
end

function MultiTeam:StartAllies(team1, team2)
  team1 = self:GetTeamID(team1)
  team2 = self:GetTeamID(team2)

  self.Teams[team1].allies[team2] = 1
  self.Teams[team2].allies[team1] = 1
end

function MultiTeam:EndAllies(team1, team2)
  team1 = self:GetTeamID(team1)
  team2 = self:GetTeamID(team2)

  self.Teams[team1].allies[team2] = nil
  self.Teams[team2].allies[team1] = nil
end

function MultiTeam:IsSelf(p1, p2)
  p1 = self:GetPlayerID(p1)
  p2 = self:GetPlayerID(p2)

  return self:IsSelf2(p1, p2)
end

function MultiTeam:IsTeam(p1, p2)
  p1 = self:GetPlayerID(p1)
  p2 = self:GetPlayerID(p2)

  return self:IsTeam2(p1, p2)
end

function MultiTeam:IsAlly(p1, p2)
  p1 = self:GetPlayerID(p1)
  p2 = self:GetPlayerID(p2)

  return self:IsAlly2(p1, p2)
end

function MultiTeam:IsEnemy(p1, p2)
  p1 = self:GetPlayerID(p1)
  p2 = self:GetPlayerID(p2)

  return self:IsEnemy2(p1, p2)
end

function MultiTeam:IsSelf2(p1, p2)
  return p1 == p2
end

function MultiTeam:IsTeam2(p1, p2)
  local p1Team = self.Players[p1]
  local p2Team = self.Players[p2]

  return p1Team == p2Team
end

function MultiTeam:IsAlly2(p1, p2)
  local p1Team = self.Players[p1]
  local p2Team = self.Players[p2]

  if p1Team == p2Team then
    return true
  end

  local team1 = self.Teams[p1Team]
  if team1.allies[p2Team] ~= nil then
    return true
  end

  return false
end

function MultiTeam:IsEnemy2(p1, p2)
  return not self:IsAlly2(p1,p2)
end

function MultiTeam:GetTeamID(t)
  if type(t) == "number" then
    return t
  elseif self.TeamNames[t] ~= nil then
    return self.TeamNames[t]
  end

  return nil
end

function MultiTeam:GetPlayerID(p)
  if type(p) == "number" then
    return p
  elseif IsValidEntity(p) and p.GetPlayerID ~= nil then
    return p:GetPlayerID()
  elseif IsValidEntity(p) and p.GetPlayerOwner ~= nil then
    return p:GetPlayerOwner():GetPlayerID()
  end

  return nil
end

function MultiTeam:FullConnect(keys)
  print('[MULTITEAM] FullConnect')
  PrintTable(keys)
end

function MultiTeam:PlayerSay(keys)
  print('[MULTITEAM] PlayerSay')
  PrintTable(keys)
end

function MultiTeam:PlayerConnect(keys)
  print('[MULTITEAM] PlayerConnect')
  PrintTable(keys)
end

--[[
  "RunScript"
  {  
    "ScriptFile"      "scripts/vscripts/multiteam.lua"
    "Function"        "MTAction"
    "Target"          "TARGET"
    "Team"            "ENEMY|NOSELF"  // DEFAULT
    //  OPTIONS
    //  "ENEMY", ALLY", "TEAM", "NOTEAM", "SELF", "NOSELF"
    "KVCallback"      "OnChannelFinish" // DEFAULT
  }

]]

function MTPrint(keys)
  print('-------')
  print('[MULTITEAM] MTPrint')
  PrintTable(keys)

  print(keys.ability:GetLevel())
  print('-------')
end

function MTAction(keys)
  print('[MULTITEAM] MTAction')
  --PrintTable(keys)

  local caster = keys.caster
  local ability = keys.ability
  local team = keys.Team or "ENEMY|NOSELF"
  local kvcallback = keys.KVCallback or "OnChannelFinish"
  local modcallback = keys.ModifierCallback
  if modcallback ~= nil and modcallback == "" then
    modcallback = ability:GetAbilityName()
  end

  local target = keys.target

  local test = false

  print('p1: ' .. tostring(MultiTeam:GetPlayerID(caster)) .. " -- p2: " .. tostring(MultiTeam:GetPlayerID(target)))
  print('p1team: ' .. tostring(MultiTeam:GetPlayerTeam(caster)) .. " -- p2team: " .. tostring(MultiTeam:GetPlayerTeam(target)))

  print ("ally: " .. tostring(MultiTeam:IsAlly(caster, target)))
  print ("team: " .. tostring(MultiTeam:IsTeam(caster, target)))
  print ("self: " .. tostring(MultiTeam:IsSelf(caster, target)))
  print ("enemy: " .. tostring(MultiTeam:IsEnemy(caster, target)))
  print(test)

  if string.find(team, "NOTEAM") then
    if MultiTeam:IsTeam(caster, target) then
      ability:RefundManaCost()
      ability:EndCooldown()
      return
    end
  elseif string.find(team, "TEAM") then
    if MultiTeam:IsTeam(caster, target) then
      test = true
    end
  end

  print(test)

  if string.find(team, "NOSELF") then
    if MultiTeam:IsSelf(caster, target) then
      ability:RefundManaCost()
      ability:EndCooldown()
      return
    end
  elseif string.find(team, "SELF") then
    if MultiTeam:IsSelf(caster, target) then
      test = true
    end
  end

  print(test)

  if string.find(team, "ENEMY") ~= nil then
    if MultiTeam:IsEnemy(caster, target) then
      test = true
    end
  end

  print(test)

  if string.find(team, "ALLY") ~= nil then
    if MultiTeam:IsAlly(caster, target) then
      test = true
    end
  end

  print(test)

  if test then
    print('----------------------')
    --PrintTable(getmetatable(caster))
    print('----------------------')
    --caster:SetCursorCastTarget(target)
    --print(target:GetAbsOrigin())
    --print(ability:GetCursorPosition())
    --caster:SetCursorPosition(target:GetAbsOrigin())
    --print(ability:GetCursorPosition())
    if modcallback ~= nil then
      local item = CreateItem( "item_multiteam_action", caster, caster)
      print('level: ' .. ability:GetLevel())
      print('level: ' .. item:GetLevel())
      print('maxlevel: ' .. item:GetMaxLevel())
      print('damage: ' .. item:GetSpecialValueFor("damage"))
      --item:SetLevel(ability:GetLevel())
      print('level: ' .. item:GetLevel())
      print('damage: ' .. item:GetSpecialValueFor("damage"))
      item:ApplyDataDrivenModifier( caster, target, modcallback, {} )
      --UTIL_RemoveImmediate(item)
    else
      if kvcallback == "OnChannelFinish" then
        ability:OnChannelFinish(false)
      elseif kvcallback == "OnChannelSucceeded" then
        ability:OnChannelFinish(true)
      end
    end
  else
    ability:RefundManaCost()
    ability:EndCooldown()
  end
end