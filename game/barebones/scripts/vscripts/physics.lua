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
  
  local wspawn = Entities:First() -- Entities:FindByClassname(nil, 'CWorld')
  --wspawn:SetContextThink("PhysicsThink", Dynamic_Wrap( Physics, 'Think' ), PHYSICS_THINK )
  wspawn:SetThink("Think", self, "physics", PHYSICS_THINK)
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

Physics:start()
