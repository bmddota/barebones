PHYSICS_NAV_NOTHING = 0
PHYSICS_NAV_HALT = 1
PHYSICS_NAV_SLIDE = 2
PHYSICS_NAV_BOUNCE = 3

PHYSICS_GROUND_NOTHING = 0
PHYSICS_GROUND_ABOVE = 1
PHYSICS_GROUND_LOCK = 2

PHYSICS_THINK = 0.01

if Physics == nil then
  print ( '[PHYSICS] creating Physics' )
  Physics = {}
  Physics.__index = Physics
end

function Physics:new( o )
  o = o or {}
  setmetatable( o, Physics )
  return o
end

function Physics:start()
  Physics = self
  self.timers = {}
  self.reflectGroups = {}
  self.blockGroups = {}
  self.projectiles = {}
  self.anggrid = nil
  self.offsetX = nil
  self.offsetY = nil
  
  local wspawn = Entities:CreateByClassname("info_target") -- Entities:FindByClassname(nil, 'CWorld')
  --wspawn:SetContextThink("PhysicsThink", Dynamic_Wrap( Physics, 'Think' ), PHYSICS_THINK )
  wspawn:SetThink("Think", self, "physics", PHYSICS_THINK)

  Convars:RegisterCommand( "phystest", Dynamic_Wrap(Physics, 'PhysicsTestCommand'), "Test different Physics library commands", FCVAR_CHEAT )
end

function Physics:Think()
  if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return
  end

  -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
  local now = GameRules:GetGameTime()
  --print("now: " .. now)
  if Physics.t0 == nil then
    Physics.t0 = now
  end
  local dt = now - Physics.t0
  Physics.t0 = now

  -- Process timers
  for k,v in pairs(Physics.timers) do
    local bUseGameTime = false
    if v.useGameTime and v.useGameTime == true then
      bUseGameTime = true;
    end
    -- Check if the timer has finished
    if (bUseGameTime and GameRules:GetGameTime() > v.endTime) or (not bUseGameTime and Time() > v.endTime) then
      -- Remove from timers list
      Physics.timers[k] = nil
      
      -- Run the callback
      local status, nextCall = pcall(v.callback, Physics, v)

      -- Make sure it worked
      if status then
        -- Check if it needs to loop
        if nextCall then
          -- Change it's end time
          v.endTime = nextCall
          Physics.timers[k] = v
        end

        -- Update timer data
        --self:UpdateTimerData()
      else
        -- Nope, handle the error
        Physics:HandleEventError('Timer', k, nextCall)
      end
    end
  end

  return PHYSICS_THINK
end

function Physics:HandleEventError(name, event, err)
  print(err)

  -- Ensure we have data
  name = tostring(name or 'unknown')
  event = tostring(event or 'unknown')
  err = tostring(err or 'unknown')

  -- Tell everyone there was an error
  --Say(nil, name .. ' threw an error on event '..event, false)
  --Say(nil, err, false)

  -- Prevent loop arounds
  if not self.errorHandled then
    -- Store that we handled an error
    self.errorHandled = true
  end
end

function Physics:CreateTimer(name, args)
  if not args.endTime or not args.callback then
    print("Invalid timer created: "..name)
    return
  end

  Physics.timers[name] = args
end

function Physics:RemoveTimer(name)
  Physics.timers[name] = nil
end

function Physics:RemoveTimers(killAll)
  local timers = {}

  if not killAll then
    for k,v in pairs(Physics.timers) do
      if v.persist then
        timers[k] = v
      end
    end
  end

  Physics.timers = timers
end

--[[
  sequence:
     {"type",  Physics_LINEAR, Physics_CURVED, Physics_SPLIT
      LINEAR
      "distance" or "time" or "to"
      "toward" or "angle" or "to"
      "from" or nothing
      "speed" or nothing
      CURVED
      "toward" or "angle"
        "angleTick"
        "tick"
        "ticks"
      "around"
      "speed" or nothing
      SPLIT
      "TBD"
]]

function Physics:AngleGrid( anggrid, angoffsets )
  self.anggrid = anggrid
  print('[PHYSICS] Angle Grid Set')
  local worldMin = Vector(GetWorldMinX(), GetWorldMinY(), 0)
  local worldMax = Vector(GetWorldMaxX(), GetWorldMaxY(), 0)
  local boundX1 = GridNav:WorldToGridPosX(worldMin.x)
  local boundX2 = GridNav:WorldToGridPosX(worldMax.x)
  local boundY1 = GridNav:WorldToGridPosX(worldMin.y)
  local boundY2 = GridNav:WorldToGridPosX(worldMax.y)
  local offsetX = boundX1 * -1 + 1
  local offsetY = boundY1 * -1 + 1
  self.offsetX = offsetX
  self.offsetY = offsetY

  if angoffsets ~= nil then
    self.offsetX = math.abs(angoffsets.x) + 1
    self.offsetY = math.abs(angoffsets.y) + 1
  end
end

function Physics:Unit(unit)
  function unit:StopPhysicsSimulation ()
    Physics.timers[unit.PhysicsTimerName] = nil
    unit.bStarted = false
  end
  function unit:StartPhysicsSimulation ()
    Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
    unit.PhysicsTimer.endTime = GameRules:GetGameTime()
    unit.PhysicsLastPosition = unit:GetAbsOrigin()
    unit.PhysicsLastTime = GameRules:GetGameTime()
    unit.vLastVelocity = Vector(0,0,0)
    unit.vSlideVelocity = Vector(0,0,0)
    unit.bStarted = true
  end
  
  function unit:SetPhysicsVelocity (velocity)
    unit.vVelocity = velocity / 30
    if unit.nVelocityMax > 0 and unit.vVelocity:Length() > unit.nVelocityMax then
      unit.vVelocity = unit.vVelocity:Normalized() * unit.nVelocityMax
    end
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  function unit:AddPhysicsVelocity (velocity)
    unit.vVelocity = unit.vVelocity + velocity / 30
    if unit.nVelocityMax > 0 and unit.vVelocity:Length() > unit.nVelocityMax then
      unit.vVelocity = unit.vVelocity:Normalized() * unit.nVelocityMax
    end
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  
  function unit:SetPhysicsVelocityMax (velocityMax)
    unit.nVelocityMax = velocityMax / 30
  end
  function unit:GetPhysicsVelocityMax ()
    return unit.vVelocity * 30
  end
  
  function unit:SetPhysicsAcceleration (acceleration)
    unit.vAcceleration = acceleration / 30
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  function unit:AddPhysicsAcceleration (acceleration)
    unit.vAcceleration = unit.vAcceleration + acceleration / 30
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  
  function unit:SetPhysicsFriction (friction)
    unit.fFriction = friction
  end
  
  function unit:GetPhysicsVelocity ()
    return unit.vVelocity  * 30
  end
  function unit:GetPhysicsAcceleration ()
    return unit.vAcceleration * 30
  end
  function unit:GetPhysicsFriction ()
    return unit.fFriction
  end
  
  function unit:FollowNavMesh (follow)
    unit.bFollowNavMesh = follow
  end
  function unit:IsFollowNavMesh ()
    return unit.bFollowNavMesh
  end
  
  function unit:SetGroundBehavior (ground)
    unit.nLockToGround = ground
  end
  function unit:GetGroundBehavior ()
    return unit.nLockToGround
  end
  
  function unit:SetSlideMultiplier (slideMultiplier)
    unit.fSlideMultiplier = slideMultiplier
  end
  function unit:GetSlideMultiplier ()
    return unit.fSlideMultiplier
  end
  
  function unit:Slide (slide)
    unit.bSlide = slide
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  function unit:IsSlide ()
    return unit.bSlide
  end
  
  function unit:PreventDI (prevent)
    unit.bPreventDI = prevent
    if not prevent and unit:HasModifier("modifier_rooted") then
      unit:RemoveModifierByName("modifier_rooted")
    end
  end
  function unit:IsPreventDI ()
    return unit.bPreventDI
  end
  
  function unit:SetNavCollisionType (collisionType)
    unit.nNavCollision = collisionType
  end
  function unit:GetNavCollisionType ()
    return unit.nNavCollision
  end
  
  function unit:OnPhysicsFrame(fun)
    unit.PhysicsFrameCallback = fun
  end
  
  function unit:SetVelocityClamp (clamp)
    unit.fVelocityClamp = clamp / 30
  end
  
  function unit:GetVelocityClamp ()
    return unit.fVelocityClamp * 30
  end
  
  function unit:Hibernate (hibernate)
    unit.bHibernate = hibernate
  end
  
  function unit:IsHibernate ()
    return unit.bHibernate
  end
  
  function unit:DoHibernate ()
    Physics.timers[unit.PhysicsTimerName] = nil
    unit.bHibernating = true
  end
  
  function unit:OnHibernate(fun)
    unit.PhysicsHibernateCallback = fun
  end
  
  function unit:SetNavGridLookahead (lookahead)
    unit.nNavGridLookahead = lookahead
  end
  
  function unit:GetNavGridLookahead ()
    return unit.nNavGridLookahead
  end
  
  function unit:SkipSlide (frames)
    unit.nSkipSlide = frames or 1
  end
  
  function unit:SetRebounceFrames ( rebounce )
    unit.nMaxRebounce = rebounce
    unit.nRebounceFrames = 0
  end
  
  function unit:GetRebounceFrames ()
    unit.nRebounceFrames = 0
    return unit.nMaxRebounce
  end
  
  function unit:GetLastGoodPosition ()
    return unit.vLastGoodPosition
  end
  
  function unit:SetStuckTimeout (timeout)
    unit.nStuckTimeout = timeout / 30
    unit.nStuckFrames = 0
  end
  function unit:GetStuckTimeout ()
    unit.nStuckFrames = 0
    return unit.nStuckTimeout * 30
  end
  
  function unit:SetAutoUnstuck (unstuck)
    unit.bAutoUnstuck = unstuck
  end
  function unit:GetAutoUnstuck ()
    return unit.bAutoUnstuck
  end

  function unit:SetBounceMultiplier (bounce)
    unit.fBounceMultiplier = bounce
  end
  function unit:GetBounceMultiplier ()
    return unit.fBounceMultiplier
  end
  
  unit.PhysicsTimerName = DoUniqueString('phys')
  Physics:CreateTimer(unit.PhysicsTimerName, {
    endTime = GameRules:GetGameTime(),
    useGameTime = true,
    callback = function(reflex, args)
      local prevTime = unit.PhysicsLastTime
      if not IsValidEntity(unit) then
        return
      end
      local curTime = GameRules:GetGameTime()
      local prevPosition = unit.PhysicsLastPosition
      local position = unit:GetAbsOrigin()
      local slideVelocity = Vector(0,0,0)
      local lastVelocity = unit.vLastVelocity
      unit.vLastVelocity = unit.vVelocity
      unit.PhysicsLastTime = curTime
      unit.PhysicsLastPosition = position
      
      if unit.bPreventDI and not unit:HasModifier("modifier_rooted") then
        unit:AddNewModifier(unit, nil, "modifier_rooted", {})
      end
      
      if unit.bSlide and unit.nSkipSlide <= 0 then
        slideVelocity = ((position - prevPosition) - lastVelocity + unit.vSlideVelocity) * unit.fSlideMultiplier
      else
        --print(unit.nSkipSlide)
        unit.vSlideVelocity = Vector(0,0,0)
      end
      
      unit.nSkipSlide = unit.nSkipSlide - 1
      
      -- Adjust velocity
      local newVelocity = unit.vVelocity + unit.vAcceleration + (-1 * unit.fFriction * unit.vVelocity) + slideVelocity
      
      --print('vel: ' .. tostring(unit.vVelocity:Length()) .. ' -- svel: ' .. tostring(slideVelocity:Length()) .. " -- nvel: " .. tostring(newVelocity:Length()))
      
      -- Calculate new position
      local newPos = position + unit.vVelocity
      if unit.nLockToGround == PHYSICS_GROUND_LOCK then
        local groundPos = GetGroundPosition(newPos, unit)
        newPos = groundPos
        newVelocity.z = 0
      elseif unit.nLockToGround == PHYSICS_GROUND_ABOVE then
        local groundPos = GetGroundPosition(newPos, unit)
        if groundPos.z > newPos.z then
          newPos = groundPos
          newVelocity.z = 0
        end
      end
      
      local newVelLength = newVelocity:Length()
      
      local blockedPos = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position)
      if not blockedPos then
        unit.vLastGoodPosition = position
        unit.nStuckFrames = 0
      else
        unit.nStuckFrames = unit.nStuckFrames + 1
      end
      
      if unit.nVelocityMax > 0 and newVelLength > unit.nVelocityMax then
        newVelocity = newVelocity:Normalized() * unit.nVelocityMax
      end
      if unit.vAcceleration.x == 0 and unit.vAcceleration.y == 0 and newVelLength < unit.fVelocityClamp then
        --print('clamp')
        newVelocity = Vector(0,0,newVelocity.z)
        if unit:HasModifier("modifier_rooted") then
          unit:RemoveModifierByName("modifier_rooted")
        end
        if unit.bHibernate then
          unit:DoHibernate()
          local ent = Entities:FindInSphere(nil, position, 35)
          local blocked = false
          while ent ~= nil and not blocked do
            if ent.IsHero ~= nil and ent ~= unit then
              blocked = true
            end
            --print(ent:GetClassname() .. " -- " .. ent:GetName() .. " -- " .. tostring(ent.IsHero))
            ent = Entities:FindInSphere(ent, position, 35)
          end
          if blocked or blockedPos or GridNav:IsNearbyTree(position, 30, true) then
            FindClearSpaceForUnit(unit, position, true)
            unit.nSkipSlide = 1
            --print('FCS hib')
          end
          if unit.PhysicsHibernateCallback ~= nil then
            local status, nextCall = pcall(unit.PhysicsHibernateCallback, unit)
            if not status then
              print('[PHYSICS] Failed HibernateCallback: ' .. nextCall)
            end
          end
          return
        end
        
        local ent = Entities:FindInSphere(nil, position, 35)
        local blocked = false
        while ent ~= nil and not blocked do
          if ent.IsHero ~= nil and ent ~= unit then
            blocked = true
          end
          --print(ent:GetClassname() .. " -- " .. ent:GetName() .. " -- " .. tostring(ent.IsHero))
          ent = Entities:FindInSphere(ent, position, 35)
        end
        if blocked or not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) or GridNav:IsNearbyTree(position, 30, true) then
          FindClearSpaceForUnit(unit, position, true)
          unit.nSkipSlide = 1
          --print('FCS nothib lowv + blocked')
        end
        --return curTime
      end
      
      
      if unit.vVelocity ~= Vector(0,0,0) or slideVelocity ~= Vector(0,0,0) then
        if unit.bFollowNavMesh then
          local diff = unit.vVelocity:Normalized()
          --FindClearSpaceForUnit(unit, newPos, true)
          unit:SetAbsOrigin(newPos)
          
          local navConnect = not GridNav:IsTraversable(newPos) or GridNav:IsBlocked(newPos) 
          local tot = unit.nNavGridLookahead + 1
          local div = 1 / tot
          local index = 1
          local connect = newPos
          while not navConnect and index < tot do
            connect = newPos + unit.vVelocity * div * index
            navConnect = not GridNav:IsTraversable(newPos) or GridNav:IsBlocked(newPos) 
            index = index + 1
          end
          --or not GridNav:IsTraversable(newPos + unit.vVelocity * .5) -- diff * unit.nNavGridLookahead
            --or  or GridNav:IsBlocked(newPos + unit.vVelocity * .5)
          if unit.nNavCollision == PHYSICS_NAV_HALT and navConnect then
            newVelocity = Vector(0,0,0)
            FindClearSpaceForUnit(unit, newPos, true)
            unit.nSkipSlide = 1
          elseif unit.nNavCollision == PHYSICS_NAV_SLIDE and navConnect then        
            local navPos = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(connect.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(connect.y)), 0)
            
            local face = navPos - position
            --print("face: " .. tostring(face))
            if math.abs(face.x) > math.abs(face.y) then
              newVelocity = newVelocity - Vector(newVelocity.x, 0, 0)
            else
              newVelocity = newVelocity - Vector(0, newVelocity.y, 0)
            end
            --FindClearSpaceForUnit(unit, newPos, true)
            
            --newVelocity = Vector(0,0,0)
            --
          elseif unit.nRebounceFrames <= 0 and unit.nNavCollision == PHYSICS_NAV_BOUNCE and navConnect then
            local navX = GridNav:WorldToGridPosX(connect.x)
            local navY = GridNav:WorldToGridPosY(connect.y)
            local navPos = Vector(GridNav:GridPosToWorldCenterX(navX), GridNav:GridPosToWorldCenterY(navY), 0)
            unit.nRebounceFrames = unit.nMaxRebounce
            
            local normal = nil
            local anggrid = self.anggrid
            local offX = self.offsetX
            local offY = self.offsetY
            if anggrid then
              local angSize = #anggrid
              local angX = navX + offX
              local angY = navY + offY

              --print(offX .. ' -- ' .. angX .. ' == ' .. angY .. ' -- ' .. offY)
              
              local angle = anggrid[angX][angY]
              if angle ~= -1 then
                angle = angle
                normal = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), Vector(1,0,0))
                --print(normal)
                --print('----------')
              end
            end
            
            if normal == nil then
              --local face = navPos - position
              --print("face: " .. tostring(face)) 
              local dir = navPos - position
              dir.z = 0
              dir = dir:Normalized()
              -- Nav bounce checks
              --local angx = (math.acos(dir.x)/ math.pi * 180)
              --local angy = (math.acos(dir.y)/ math.pi * 180)
              --print(tostring(dir:Length()) .. " -- " .. tostring(dir))
              --print(dir:Dot(Vector(1,0,0)))
              --print(dir:Dot(Vector(-1,0,0)))
              --print(dir:Dot(Vector(0,1,0)))
              --print(dir:Dot(Vector(0,-1,0)))
              --print('---------------')
              local vVelocity = unit.vVelocity
              if dir:Dot(Vector(1,0,0)) > .707 then
                normal = Vector(1,0,0)
                local navPos2 = navPos + Vector(-64,0,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vVelocity.y > 0 then
                    normal = Vector(0,1,0)
                    navPos2 = navPos + Vector(0,-64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(0,64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(-1,0,0)) > .707 then
                normal = Vector(-1,0,0)
                local navPos2 = navPos + Vector(64,0,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vVelocity.y > 0 then
                    normal = Vector(0,1,0)
                    navPos2 = navPos + Vector(0,-64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(0,64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(0,1,0)) > .707 then
                normal = Vector(0,1,0)
                local navPos2 = navPos + Vector(0,-64,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vVelocity.x > 0 then
                    normal = Vector(1,0,0)
                    navPos2 = navPos + Vector(-64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(-1,0,0)
                    navPos2 = navPos + Vector(64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(0,-1,0)) > .707 then
                normal = Vector(0,-1,0)
                local navPos2 = navPos + Vector(0,64,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vVelocity.x > 0 then
                    normal = Vector(-1,0,0)
                    navPos2 = navPos + Vector(-64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              end
              --FindClearSpaceForUnit(unit, newPos, true)
              --print(tostring(unit:GetAbsOrigin()) .. " -- " .. tostring(navPos))
            end
            newVelocity = ((-2 * newVelocity:Dot(normal) * normal) + newVelocity) * unit.fBounceMultiplier
          end
        else
          unit:SetAbsOrigin(newPos)
        end
      end
      
      unit.nRebounceFrames = unit.nRebounceFrames - 1
      unit.vVelocity = newVelocity
      
      if unit.PhysicsFrameCallback ~= nil then
        local status, nextCall = pcall(unit.PhysicsFrameCallback, unit)
        if not status then
          print('[PHYSICS] Failed FrameCallback: ' .. nextCall)
        end
      end
      
      if unit.bAutoUnstuck and unit.nStuckFrames >= unit.nStuckTimeout then
        unit.nStuckFrames = 0
        unit.nSkipSlide = 1

        local navX = GridNav:WorldToGridPosX(position.x)
        local navY = GridNav:WorldToGridPosY(position.y)

        local anggrid = self.anggrid
        local offX = self.offsetX
        local offY = self.offsetY
        if anggrid then
          local angSize = #anggrid
          local angX = navX + offX
          local angY = navY + offY

          --print(offX .. ' -- ' .. angX .. ' == ' .. angY .. ' -- ' .. offY)
          
          local angle = anggrid[angX][angY]
          if angle ~= -1 then
            local normal = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), Vector(1,0,0))
            --print(normal)
            --print('----------')

            unit:SetAbsOrigin(position + normal * 64)
          else
            unit:SetAbsOrigin(unit.vLastGoodPosition)
          end
        else
          unit:SetAbsOrigin(unit.vLastGoodPosition)
        end
      end
      
      return curTime
    end
  })
  
  unit.PhysicsTimer = Physics.timers[unit.PhysicsTimerName]
  unit.vVelocity = Vector(0,0,0)
  unit.vLastVelocity = Vector(0,0,0)
  unit.vAcceleration = Vector(0,0,0)
  unit.fFriction = .05
  unit.PhysicsLastPosition = unit:GetAbsOrigin()
  unit.PhysicsLastTime = GameRules:GetGameTime()
  unit.bFollowNavMesh = true
  unit.nLockToGround = PHYSICS_GROUND_ABOVE
  unit.bPreventDI = false
  unit.bSlide = false
  unit.nNavCollision = PHYSICS_NAV_SLIDE
  unit.fSlideMultiplier = 0.1
  unit.nVelocityMax = 0
  unit.PhysicsFrameCallback = nil
  unit.fVelocityClamp = 20.0 / 30.0
  unit.bHibernate = true
  unit.bHibernating = false
  unit.bStarted = true
  unit.vSlideVelocity = Vector(0,0,0)
  unit.nNavGridLookahead = 1
  unit.nSkipSlide = 0
  unit.nMaxRebounce = 5
  unit.nRebounceFrames = 0
  unit.vLastGoodPosition = unit:GetAbsOrigin()
  unit.bAutoUnstuck = true
  unit.nStuckTimeout = 5
  unit.nStuckFrames = 0
  unit.fBounceMultiplier = 1.0
end



-- Physics Testing commands
function Physics:PhysicsTestCommand(...)

  local args = {...}
  PrintTable(args)
  local text = table.concat (args, " ")
  print(text)
  local ply = Convars:GetCommandClient()
  local plyID = ply:GetPlayerID()

  local hero = ply:GetAssignedHero()

  if string.find(text, "^regrow") then
    GridNav:RegrowAllTrees()
  end

  if string.find(text, "^spider") then
    local mapGnv = {}
    local worldMin = Vector(GetWorldMinX(), GetWorldMinY(), 0)
    local worldMax = Vector(GetWorldMaxX(), GetWorldMaxY(), 0)

    print(worldMin)
    print(worldMax)

    local boundX1 = GridNav:WorldToGridPosX(worldMin.x)
    local boundX2 = GridNav:WorldToGridPosX(worldMax.x)
    local boundY1 = GridNav:WorldToGridPosX(worldMin.y)
    local boundY2 = GridNav:WorldToGridPosX(worldMax.y)

    print(boundX1 .. " -- " .. boundX2)
    print(boundY1 .. " -- " .. boundY2)

    print('----------------------')

    InitLogFile("addons/dotadash/spider.txt", "")
    AppendToLogFile("addons/dotadash/spider.txt", "P1")
    AppendToLogFile("addons/dotadash/spider.txt", "#spider created pbm")
    AppendToLogFile("addons/dotadash/spider.txt", tostring(boundX2 - boundX1 + 1) .. " " .. tostring(boundY2 - boundY1 + 1))

    local pseudoGNV = {}
    local WALLS = self.WALLS
    for i=1,#WALLS do
      local from = WALLS[i].from
      local to = WALLS[i].to
      local cur = from
      local dist = to - from
      dist.z = 0
      local dir = dist:Normalized()
      dist = dist:Length()
      local norm = RotatePosition(Vector(0,0,0), QAngle(0,90,0), dir)

      for j=1,math.floor(dist/30) do
        local pos = cur + norm * 64
        local pos2 = cur - norm * 64
        local x = GridNav:WorldToGridPosX(pos.x)
        local y = GridNav:WorldToGridPosY(pos.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true

        x = GridNav:WorldToGridPosX(pos2.x)
        y = GridNav:WorldToGridPosY(pos2.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true

        x = GridNav:WorldToGridPosX(cur.x)
        y = GridNav:WorldToGridPosY(cur.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true

        cur = from + dir*j*30
      end

      cur = to
      local pos = cur + norm * 64
      local pos2 = cur - norm * 64
      local blocked = not GridNav:IsTraversable(pos) or GridNav:IsBlocked(pos)
      if blocked then
        local x = GridNav:WorldToGridPosX(pos.x)
        local y = GridNav:WorldToGridPosY(pos.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true
      end

      blocked = not GridNav:IsTraversable(pos2) or GridNav:IsBlocked(pos2)
      if blocked then
        local x = GridNav:WorldToGridPosX(pos2.x)
        local y = GridNav:WorldToGridPosY(pos2.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true
      end

      blocked = not GridNav:IsTraversable(cur) or GridNav:IsBlocked(cur)
      if blocked then
        local x = GridNav:WorldToGridPosX(cur.x)
        local y = GridNav:WorldToGridPosY(cur.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true
      end
    end

    --PrintTable(pseudoGNV)
    --print('---------------')

    local s = ""

    for i=boundY2,boundY1,-1 do
      for j=boundX1,boundX2 do
        local position = Vector(GridNav:GridPosToWorldCenterX(j), GridNav:GridPosToWorldCenterY(i), 0)
        local blocked = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) or (pseudoGNV[j] ~= nil and pseudoGNV[j][i])

        if blocked then
          s = s .. "1"
        else
          s = s .. "0"
        end

        if j == boundX2 then
          AppendToLogFile("addons/dotadash/spider.txt", s)
          s = ""
        else
          s = s .. " "
        end
      end
    end
  end

  if string.find(text, "^anggrid") then
    local timestamp = GetSystemDate() .. " " .. GetSystemTime()
    timestamp = timestamp:gsub(":","_"):gsub(" ","_")
    local fileName = "log/" .. GetMapName() .. timestamp .. ".txt"
    print(fileName)

    local anggrid = {}
    local worldMin = Vector(GetWorldMinX(), GetWorldMinY(), 0)
    local worldMax = Vector(GetWorldMaxX(), GetWorldMaxY(), 0)

    print(worldMin)
    print(worldMax)

    local boundX1 = GridNav:WorldToGridPosX(worldMin.x)
    local boundX2 = GridNav:WorldToGridPosX(worldMax.x)
    local boundY1 = GridNav:WorldToGridPosX(worldMin.y)
    local boundY2 = GridNav:WorldToGridPosX(worldMax.y)
    local offsetX = boundX1 * -1 + 1
    local offsetY = boundY1 * -1 + 1

    print(boundX1 .. " -- " .. boundX2)
    print(boundY1 .. " -- " .. boundY2)
    print(offsetX)
    print(offsetY)

    local vecs = {
      {vec = Vector(0,1,0):Normalized(), x=0,y=1},-- N
      {vec = Vector(1,1,0):Normalized(), x=1,y=1}, -- NE
      {vec = Vector(1,0,0):Normalized(), x=1,y=0}, -- E
      {vec = Vector(1,-1,0):Normalized(), x=1,y=-1}, -- SE
      {vec = Vector(0,-1,0):Normalized(), x=0,y=-1}, -- S
      {vec = Vector(-1,-1,0):Normalized(), x=-1,y=-1}, -- SW
      {vec = Vector(-1,0,0):Normalized(), x=-1,y=0}, -- W
      {vec = Vector(-1,1,0):Normalized(), x=-1,y=1} -- NW
    }

    print('----------------------')

    anggrid[1] = {}
    for j=boundY1,boundY2 do
      anggrid[1][j + offsetY] = -1
    end
    anggrid[1][boundY2 + offsetY] = -1

    for i=boundX1+1,boundX2-1 do
      anggrid[i+offsetX] = {}
      anggrid[i+offsetX][1] = -1
      for j=(boundY1+1),boundY2-1 do
        local position = Vector(GridNav:GridPosToWorldCenterX(i), GridNav:GridPosToWorldCenterY(j), 0)
        local blocked = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) --or (pseudoGNV[i] ~= nil and pseudoGNV[i][j])
        local seg = 0
        local sum = Vector(0,0,0)
        local count = 0
        local inseg = false

        if blocked then
          for k=1,#vecs do
            local vec = vecs[k].vec
            local xoff = vecs[k].x
            local yoff = vecs[k].y
            local pos = Vector(GridNav:GridPosToWorldCenterX(i+xoff), GridNav:GridPosToWorldCenterY(j+yoff), 0)
            local blo = not GridNav:IsTraversable(pos) or GridNav:IsBlocked(pos) --or (pseudoGNV[i+xoff] ~= nil and pseudoGNV[i+xoff][j+yoff])

            if not blo then
              count = count + 1
              inseg = true
              sum = sum + vec
            else
              if inseg then
                inseg = false
                seg = seg + 1
              end
            end
          end

          if seg > 1 then
            print ('OVERSEG x=' .. i .. ' y=' .. j)
            anggrid[i+offsetX][j+offsetY] = -1
          elseif count > 5 then
            print ('PROTRUDE x=' .. i .. ' y=' .. j)
            anggrid[i+offsetX][j+offsetY] = -1
          elseif count == 0 then
            anggrid[i+offsetX][j+offsetY] = -1
          else
            local sum = sum:Normalized()
            local angle = math.floor((math.acos(Vector(1,0,0):Dot(sum:Normalized()))/ math.pi * 180))
            if sum.y < 0 then
              angle = -1 * angle
            end
            anggrid[i+offsetX][j+offsetY] = angle
          end
        else
          anggrid[i+offsetX][j+offsetY] = -1
        end
      end
      anggrid[i+offsetX][boundY2+offsetY] = -1
    end

    anggrid[boundX2+offsetX] = {}
    for j=boundY1,boundY2 do
      anggrid[boundX2+offsetX][j+offsetY] = -1
    end
    anggrid[boundX2+offsetX][boundY2+offsetY] = -1

    print('--------------')
    print(#anggrid)
    print(#anggrid[1])
    print(#anggrid[2])
    print(#anggrid[3])

    MAP_DATA.anggrid = anggrid
    Physics:AngleGrid(anggrid)
  end
  
  local ap = abilPoints

  local fname = string.match(text, "^angsave%s+(.+)")
  if fname ~= nil then
    -- Process map
    local addString = function (stack, s)
        table.insert(stack, s)    -- push 's' into the the stack
        for i=table.getn(stack)-1, 1, -1 do
          if string.len(stack[i]) > string.len(stack[i+1]) then
            break
          end
          stack[i] = stack[i] .. table.remove(stack)
        end
      end

    local s = {""}
    addString(s, "{")
    local anggrid = Physics.anggrid
    for x=1,#anggrid do
      addString(s, "{")
      for y=1,#anggrid[x] do
        addString(s, tostring(anggrid[x][y]))
        if y < #anggrid[x] then
          addString(s, ",")
        end
      end
      addString(s, "}")
      if x < #anggrid then
        addString(s, ",")
      end
    end
    addString(s, "}")

    s = table.concat(s)
    print('------------')
    print(fname)
    print(s)

    InitLogFile("addons/dotadash/" .. fname .. ".txt", s)
  end

  if string.find(text, "^units") then
    local m = string.match(text, "(%d+)")
    if m ~= nil then
      unitNum = unitNum + m
      print (unitNum)
      for i=1,m do 
        local unit = CreateUnitByName('npc_dummy_blank', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
        unit:AddNewModifier(unit, nil, "modifier_phased", {})
        unit:SetModel('models/heroes/lycan/lycan_wolf.mdl')
        unit:SetOriginalModel('models/heroes/lycan/lycan_wolf.mdl')
        
        Physics:Unit(unit)
        unit:SetPhysicsFriction(0)
        unit:SetPhysicsVelocity(RandomVector(2000))
        unit:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
      end
    end
  end
  
  
  if string.find(text, "^hibtest") then
    local m = string.match(text, "(%d+)")
    if m ~= nil and m == "0" then
      self:CreateTimer('units2',{
        useGameTime = true,
        endTime = GameRules:GetGameTime(),
        callback = function(reflex, args)
          local pushNum = math.floor(#units / 10) + 1
          for i=1,pushNum do
            local unit = units[RandomInt(1, #units)]
            unit:AddPhysicsVelocity(RandomVector(RandomInt(1000,2000)))
          end
          
          return GameRules:GetGameTime() + 1
        end
      })
    elseif m ~= nil then
      unitNum = unitNum + m
      print (unitNum)
      for i=1,m do 
        local unit = CreateUnitByName('npc_dummy_blank', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
        unit:AddNewModifier(unit, nil, "modifier_phased", {})
        unit:SetModel('models/heroes/lycan/lycan_wolf.mdl')
        unit:SetOriginalModel('models/heroes/lycan/lycan_wolf.mdl')
        
        Physics:Unit(unit)
        unit:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
        
        units[#units + 1] = unit
      end
    end
  end
  
  local vel1,vel2,vel3 = string.match(text, "^vel%s+(-?%d+)%s+(-?%d+)%s+(-?%d+)")
  if vel1 ~= nil and vel2 ~= nil and vel3 ~= nil then
    hero:AddPhysicsVelocity(Vector(tonumber(vel1), tonumber(vel2), tonumber(vel3)))
  end
  
  local velmax1 = string.match(text, "^velmax%s+(%d+)")
  if velmax1 ~= nil then
    hero:SetPhysicsVelocityMax(tonumber(velmax1))
    print('-velmax' .. tonumber(velmax1))
  end
  
  local acc1,acc2,acc3 = string.match(text, "^acc%s+(-?%d+)%s+(-?%d+)%s+(-?%d+)")
  if acc1 ~= nil and acc2 ~= nil and acc3 ~= nil then
    hero:SetPhysicsAcceleration(Vector(tonumber(acc1), tonumber(acc2), tonumber(acc3)))
  end
  
  local fric1 = string.match(text, "^fric%s+(-?%d+)")
  if fric1 ~= nil then
    hero:SetPhysicsFriction(tonumber(fric1) / 100 )
  end
  
  local slide1 = string.match(text, "^slidemult%s+(-?%d+)")
  if slide1 ~= nil then
    hero:SetSlideMultiplier(tonumber(slide1) / 100 )
  end
  
  if string.find(text, "^prevent") then
    hero:PreventDI(not hero:IsPreventDI())
  end

  if string.find(text, "^phys") and hero.IsSlide == nil then
    Physics:Unit(hero)
  end
  
  if string.find(text, "^onframe") then
    hero:OnPhysicsFrame(function(unit)
      --PrintTable(unit)
      --print('----------------')
    end)
  end
  
  if string.find(text, "^slide$") then
    hero:Slide(not hero:IsSlide())
    print(hero:IsSlide())
  end
  
  if string.find(text, "^nav$") then
    hero:FollowNavMesh(not hero:IsFollowNavMesh())
  end
  
  local clamp1 = string.match(text, "^clamp%s+(%d+)")
  if clamp1 ~= nil then
    hero:SetVelocityClamp( tonumber(clamp1))
  end
  
  if string.find(text, "^hibernate") then
    hero:Hibernate(not hero:IsHibernate())
    print(hero:IsHibernate())
  end
  
  if string.find(text, "^navtype") then
      local navType = hero:GetNavCollisionType()
      navType = (navType + 1) % 4
      print('navtype: ' .. tostring(navType))
      hero:SetNavCollisionType(navType)
  end
  
  if string.find(text, "^ground") then
    local ground = hero:GetGroundBehavior()
    ground = (ground + 1) % 3
    print('ground: ' .. tostring(ground))
    hero:SetGroundBehavior(ground)
  end
end

Physics:start()
