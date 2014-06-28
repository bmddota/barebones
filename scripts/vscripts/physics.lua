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
  end
  function unit:StartPhysicsSimulation ()
    Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
    unit.PhysicsLastPosition = unit:GetAbsOrigin()
    unit.PhysicsLastTime = GameRules:GetGameTime()
  end
  
  function unit:SetPhysicsVelocity (velocity)
    unit.vVelocity = velocity / 30
    if unit.nVelocityMax > 0 and unit.vVelocity:Length() > unit.nVelocityMax then
      unit.vVelocity = unit.vVelocity:Normalized() * unit.nVelocityMax
    end
  end
  function unit:AddPhysicsVelocity (velocity)
    unit.vVelocity = unit.vVelocity + velocity / 30
    if unit.nVelocityMax > 0 and unit.vVelocity:Length() > unit.nVelocityMax then
      unit.vVelocity = unit.vVelocity:Normalized() * unit.nVelocityMax
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
  end
  function unit:AddPhysicsAcceleration (acceleration)
    unit.vAcceleration = unit.vAcceleration + acceleration / 30
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
  
  unit.PhysicsTimerName = DoUniqueString('phys')
  Physics:CreateTimer(unit.PhysicsTimerName, {
    endTime = GameRules:GetGameTime(),
    useGameTime = true,
    callback = function(reflex, args)
      local prevTime = unit.PhysicsLastTime
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
      
      --[[if unit.vVelocity ~= Vector(0,0,0) then
        print ('----------------')
        print ('pos: ' .. tostring(position))
        print ('vel: ' .. tostring(unit.vVelocity))
        print ('acc: ' .. tostring(unit.vAcceleration))
        --print ('fric: ' .. tostring(unit.fFriction))
      end]]
      
      --[[if slideVelocity ~= Vector(0,0,0) then
        print ('tickVel: ' .. tostring(slideVelocity))
        print ('tickLen: ' .. tostring(slideVelocity:Length()))
        print ('tickTime: ' .. tostring((curTime - prevTime)))
      end]]
      
      -- Calculate new position
      local newPos = unit:GetAbsOrigin() + unit.vVelocity
      if unit.bLockToGround then
        local groundPos = GetGroundPosition(newPos, unit)
        local groundPosDiff = groundPos - newPos
        newPos = groundPos
      end
      
      
      
      -- Adjust velocity
      local newVelocity = unit.vVelocity + unit.vAcceleration + (-1 * unit.fFriction * unit.vVelocity) + slideVelocity
      if unit.nVelocityMax > 0 and newVelocity:Length() > unit.nVelocityMax then
        --print ('maxvel hit')
        --print ('velLen: ' .. tostring(newVelocity:Length()))
        newVelocity = newVelocity:Normalized() * unit.nVelocityMax
        --print ('newvelLen: ' .. tostring(newVelocity:Length()))
      end
      if unit.vAcceleration == Vector(0,0,0) and newVelocity:Length() < 20 / 30 then
        newVelocity = Vector(0,0,0)
        if unit:HasModifier("modifier_rooted") then
          unit:RemoveModifierByName("modifier_rooted")
        end
      end
      
      
      
      if unit.vVelocity ~= Vector(0,0,0) or slideVelocity ~= Vector(0,0,0) then
        --print ('newpos: ' .. tostring(newPos))
        --print ('groundpos: ' .. tostring(groundPos))
        --print ('newvel: ' .. tostring(newVelocity))
        if unit.bFollowNavMesh then
          local diff = unit.vVelocity:Normalized()
          --print(tostring(GridNav:IsBlocked(newPos)) .. " -- " .. tostring(GridNav:IsTraversable(newPos)))
          --local d1 = newPos + diff * 50
          --local d2 = newPos + diff * 100
          --local d3 = newPos + diff * 150
          --print(tostring(GridNav:IsBlocked(d1)) .. " -- " .. tostring(GridNav:IsTraversable(d1)))
          --print(tostring(GridNav:IsBlocked(d2)) .. " -- " .. tostring(GridNav:IsTraversable(d2)))
          --print(tostring(GridNav:IsBlocked(d3)) .. " -- " .. tostring(GridNav:IsTraversable(d3)))
          --print(newPos)
          FindClearSpaceForUnit(unit, newPos, true)
          
          local navConnect = (not GridNav:IsTraversable(newPos) or not GridNav:IsTraversable(newPos + diff * 50))
          if unit.nNavCollision == PHYSICS_NAV_HALT and navConnect then
            --print(tostring(unit:GetAbsOrigin()) .. " -- " .. tostring(navPos))
            newVelocity = Vector(0,0,0)
          elseif unit.nNavCollision == PHYSICS_NAV_SLIDE and navConnect then
            --print(tostring(unit:GetAbsOrigin()) .. " -- " .. tostring(navPos))
            
            local blocked = not GridNav:IsTraversable(newPos)
            local navPos = nil
            if blocked then
              navPos = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(newPos.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(newPos.y)), 0)
            else
              local d1 = newPos + diff * 50
              navPos = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(d1.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(d1.y)), 0)
            end
            
            local face = navPos - unit:GetAbsOrigin()
            print("face: " .. tostring(face))
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
            
            local face = navPos - unit:GetAbsOrigin()
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
            newVelocity = dir * newVelocity:Length()
          end
        else
          unit:SetAbsOrigin(newPos)
        end
      end
      
      unit.vVelocity = newVelocity
      unit.vSlideVelocity = slideVelocity
      
      if unit.PhysicsFrameCallback ~= nil and type(unit.PhysicsFrameCallback) == "function" then
        pcall(unit.PhysicsFrameCallback, unit)
      end
      
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = position
      
      return GameRules:GetGameTime()
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
end

Physics:start()
