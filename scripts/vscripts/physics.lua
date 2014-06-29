PHYSICS_NAV_NOTHING = 0
PHYSICS_NAV_HALT = 1
PHYSICS_NAV_SLIDE = 2
PHYSICS_NAV_BOUNCE = 3

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
  self.timers = {}
  self.reflectGroups = {}
  self.blockGroups = {}
  self.projectiles = {}
  
  local wspawn = Entities:FindByClassname(nil, 'worldspawn')
  wspawn:SetContextThink("PhysicsThink", Dynamic_Wrap( Physics, 'Think' ), PHYSICS_THINK )
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

  self.timers[name] = args
end

function Physics:RemoveTimer(name)
  self.timers[name] = nil
end

function Physics:RemoveTimers(killAll)
  local timers = {}

  if not killAll then
    for k,v in pairs(self.timers) do
      if v.persist then
        timers[k] = v
      end
    end
  end

  self.timers = timers
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
  
  function unit:LockToGround (lock)
    unit.bLockToGround = lock
  end
  function unit:IsLockToGround ()
    return unit.bLockToGround
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
      unit.bHibernating = false
    end
  end
  function unit:IsSlide ()
    return unit.bSlide
  end
  
  function unit:PreventDI (prevent)
    unit.bPreventDI = prevent
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
  
  unit.PhysicsTimerName = DoUniqueString('phys')
  Physics:CreateTimer(unit.PhysicsTimerName, {
    endTime = GameRules:GetGameTime(),
    useGameTime = true,
    callback = function(reflex, args)
      --local prevTime = unit.PhysicsLastTime
      local curTime = GameRules:GetGameTime()
      local prevPosition = unit.PhysicsLastPosition
      local position = unit:GetAbsOrigin()
      local slideVelocity = Vector(0,0,0)
      local lastVelocity = unit.vLastVelocity
      unit.vLastVelocity = unit.vVelocity
      
      if unit.bPreventDI and not unit:HasModifier("modifier_rooted") then
        unit:AddNewModifier(unit, nil, "modifier_rooted", {})
      end
      
      if unit.bSlide then
        slideVelocity = ((position - prevPosition) - lastVelocity + unit.vSlideVelocity) * unit.fSlideMultiplier
      end
      
      -- Adjust velocity
      local newVelocity = unit.vVelocity + unit.vAcceleration + (-1 * unit.fFriction * unit.vVelocity) + slideVelocity
      local newVelLength = newVelocity:Length()
      if unit.nVelocityMax > 0 and newVelLength > unit.nVelocityMax then
        newVelocity = newVelocity:Normalized() * unit.nVelocityMax
      end
      if unit.vAcceleration == Vector(0,0,0) and newVelLength < unit.fVelocityClamp then
        newVelocity = Vector(0,0,0)
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
          if blocked or not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) then
            FindClearSpaceForUnit(unit, position, true)
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
        if blocked or not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) then
          FindClearSpaceForUnit(unit, position, true)
        end
        return curTime
      end
      
      -- Calculate new position
      local newPos = position + unit.vVelocity
      if unit.bLockToGround then
        local groundPos = GetGroundPosition(newPos, unit)
        local groundPosDiff = groundPos - newPos
        newPos = groundPos
      end
      
      
      if unit.vVelocity ~= Vector(0,0,0) or slideVelocity ~= Vector(0,0,0) then
        if unit.bFollowNavMesh then
          local diff = unit.vVelocity:Normalized()
          --FindClearSpaceForUnit(unit, newPos, true)
          unit:SetAbsOrigin(newPos)
          
          local navConnect = (not GridNav:IsTraversable(newPos) or not GridNav:IsTraversable(newPos + diff * 50))
          if unit.nNavCollision == PHYSICS_NAV_HALT and navConnect then
            newVelocity = Vector(0,0,0)
          elseif unit.nNavCollision == PHYSICS_NAV_SLIDE and navConnect then        
            local blocked = not GridNav:IsTraversable(newPos)
            local navPos = nil
            if blocked then
              navPos = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(newPos.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(newPos.y)), 0)
            else
              local d1 = newPos + diff * 50
              navPos = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(d1.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(d1.y)), 0)
            end
            
            local face = navPos - position
            --print("face: " .. tostring(face))
            if math.abs(face.x) > math.abs(face.y) then
              newVelocity = Vector(0, newVelocity.y, 0)
            else
              newVelocity = Vector(newVelocity.x, 0, 0)
            end
            
            --newVelocity = Vector(0,0,0)
          elseif unit.nNavCollision == PHYSICS_NAV_BOUNCE and navConnect then
            local blocked = not GridNav:IsTraversable(newPos)
            local navPos = nil
            if blocked then
              navPos = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(newPos.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(newPos.y)), 0)
            else
              local d1 = newPos + diff * 50
              navPos = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(d1.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(d1.y)), 0)
            end
            
            local face = navPos - position
            --print("face: " .. tostring(face)) 
            local dir = diff
            -- Nav bounce checks
            local angx = (math.acos(dir.x)/ math.pi * 180)
            local angy = (math.acos(dir.y)/ math.pi * 180)
            if face.x > 0 and math.abs(face.x) > math.abs(face.y) then
              local rotAngle = 180 - angx * 2
              if angy > 90 then
                rotAngle = 360 - rotAngle
              end
              dir = RotatePosition(Vector(0,0,0), QAngle(0,rotAngle,0), dir)
            elseif face.x < 0 and math.abs(face.x) > math.abs(face.y) then
              local rotAngle =  angx * 2 - 180
              if angy < 90 then
                rotAngle = 360 - rotAngle
              end
              dir = RotatePosition(Vector(0,0,0), QAngle(0,rotAngle,0), dir)
            elseif face.y > 0 and math.abs(face.y) > math.abs(face.x) then
              local rotAngle =  180 - angy * 2
              if angx < 90 then
                rotAngle = 360 - rotAngle
              end
              dir = RotatePosition(Vector(0,0,0), QAngle(0,rotAngle,0), dir)
            elseif face.y < 0 and math.abs(face.y) > math.abs(face.x) then
              local rotAngle =  angy * 2 - 180
              if angx > 90 then
                rotAngle = 360 - rotAngle
              end
              dir = RotatePosition(Vector(0,0,0), QAngle(0,rotAngle,0), dir)
            end
            
            --print(tostring(unit:GetAbsOrigin()) .. " -- " .. tostring(navPos))
            newVelocity = dir * newVelLength
          end
        else
          unit:SetAbsOrigin(newPos)
        end
      end
      
      unit.vVelocity = newVelocity
      unit.vSlideVelocity = slideVelocity
      
      if unit.PhysicsFrameCallback ~= nil then
        pcall(unit.PhysicsFrameCallback, unit)
      end
      
      unit.PhysicsLastTime = curTime
      unit.PhysicsLastPosition = position
      
      return curTime
    end
  })
  
  unit.PhysicsTimer = self.timers[unit.PhysicsTimerName]
  unit.vVelocity = Vector(0,0,0)
  unit.vAcceleration = Vector(0,0,0)
  unit.fFriction = .05
  unit.PhysicsLastPosition = unit:GetAbsOrigin()
  unit.PhysicsLastTime = GameRules:GetGameTime()
  unit.bFollowNavMesh = true
  unit.bLockToGround = true
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
end

Physics:start()
