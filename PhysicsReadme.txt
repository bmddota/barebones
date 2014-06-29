BMD's Lua Unit Physics Library
--------------------------------

How to install:
- Drop physics.lua in with your vscripts
- Add require( 'physics' ) somewhere in your lua instatiation path

How to use:
- To turn any dota unit into a Physics unit, run
    Physics:Unit(unitEntity)
- This adds a bunch of new functions to the unit which allow for it to simulate physics
- All velocity/acceleration vectors are in hammer units per second or hammer units per second squared


=============================
PhysicsUnit Functions:
=============================
AddPhysicsAcceleration (accelerationVector)
    Adds a new acceleration vector to the current internal acceleration vector.
-----------------------------
AddPhysicsVelocity (velocityVector)
    Adds a new velocity vector to the current internal velocity vector.  This is effectively a force push on the unit.
-----------------------------
FollowNavMesh (boolean)
    Whether this unit should respect the NavMesh when moving and exhibit NavCollisionType behavior when interacting with a NavGrid block
-----------------------------
GetNavCollisionType ()
    Returns the current GridNav Collision Type (PHYSICS_NAV_NOTHING, PHYSICS_NAV_HALT, PHYSICS_NAV_SLIDE, or PHYSICS_NAV_BOUNCE)
-----------------------------
GetPhysicsAcceleration ()
    Returns the current acceleration vector.  Default is (0,0,0)
-----------------------------
GetPhysicsFriction ()
    Returns the current friction multiplier.  Default it .05
-----------------------------
GetPhysicsVelocity ()
    Returns the current velocity vector.  Default is (0,0,0)
-----------------------------
GetPhysicsVelocityMax ()
    Returns the maximum velocity.  Default is 0, representing an unlimited velocity
-----------------------------
GetSlideMultiplier ()
    Returns the slide multipler value. Default is 0.1
-----------------------------
GetVelocityClamp ()
    Returns the current velocity clamp in hammer units per second.  Default is 20 hammer units per second
-----------------------------
Hibernate (boolean)
    Whether this unit should Hibernate when there is no sliding/acceleration/velocity.  When hibernating the unit performs no physics calculation until new force/acceleration/sliding is applied.  Additionally, OnPhysicsFrame will not be called if this unit is hibernating
-----------------------------
IsFollowNavMesh ()
    Returns whether this unit will respect the navigation mesh when moving the unit around.
-----------------------------
IsHibernate ()
    Returns whether this unit should hibernate when there are no physics calculations to be performed
-----------------------------
IsLockToGround ()
    Returns whether this unit will lock the unit to the ground while performing position calculations. 
-----------------------------
IsPreventDI ()
    Returns whether this unit will be prevented from influencing the direction of the physics calculations.
-----------------------------
IsSlide ()
    Returns whether this unit is currently sliding
-----------------------------
LockToGround (boolean)
    Whether to lock this unit to the ground during calculations.  The default is true
-----------------------------
OnPhysicsFrame (function(unit))
    Set the callback function (with one parameter, the unit in question) to be exected every frame for this unit.  You can use this function to do additional calculations/collision detection/velocity modification.
-----------------------------
PreventDI (boolean)
    Whether to prevent this unit from influencing the direction of the simulation.  The default is false
-----------------------------
SetNavCollisionType (navCollisionType)
    Sets the behavior that the physics system will use when this unit collides with the GridNav mesh.  Possibilities are PHYSICS_NAV_NOTHING, PHYSICS_NAV_HALT, PHYSICS_NAV_SLIDE, or PHYSICS_NAV_BOUNCE.  Default is PHYSICS_NAV_SLIDE
        -PHYSICS_NAV_NOTHING: The unit will continue normal velocity/position calculations, potentially bumping up against the nav mesh multiple times
        -PHYSICS_NAV_HALT: The unit will halt its velocity immediately in all directions
        -PHYSICS_NAV_SLIDE: The unit will halt its velocity in only the x or y direction depending on the collision direction with the GridNav
        -PHYSICS_NAV_BOUNCE: The unit will bounce off of the GridNav mesh face it contacts with, continuing on in a different direction with the same velocity magnitude
-----------------------------
SetPhysicsAcceleration (accelerationVector)
    Sets the internal acceleration vector to the given vector, eliminating any existing acceleration
-----------------------------
SetPhysicsFriction (frictionMultiplier)
    Sets the friction multiplier.  The default is .05
-----------------------------
SetPhysicsVelocity (velocityVector)
    Sets the internal velocity vector to the given vector, eliminating any existing velocity
-----------------------------
SetPhysicsVelocityMax (maxVelocity)
    Sets the maximum velocity that the unit will clamp to during the simulation.  Default is 0, which in unlimited
-----------------------------
SetSlideMultiplier (slideMultiplier)
    Sets the slide multiplier.  The default is 0.1
-----------------------------
SetVelocityClamp (clamp)
    Sets the velocity magnitude clamp for stopping physics calculations/hibernating.  The default is 20 hammer units per second
-----------------------------
Slide (boolean)
    Whether this unit should be sliding or not.  Sliding units accelerate based on their direction of travel in addition to their normal movespeed motion.
-----------------------------
StartPhysicsSimulation ()
    Restart the physics simulation if it has been stopped by StopPhysicsSimulation
-----------------------------
StopPhysicsSimulation ()
    Stop the physics simulation from executing any more for this unit
    
    
=============================
Examples: (Note: you only run Physics:Unit() once on any given unit)
=============================
Give a unit sliding motion
-----------------------------
    Physics:Unit(hero)
    hero:Slide()

Push a unit to the left
-----------------------------
    Physics:Unit(hero)
    hero:AddPhysicsVelocity(Vector(-1000, 0, 0))

Start an accelerating "tractor beam" pulling one unit towards another without their influence
-----------------------------
    Physics:Unit(target)
    target:SetPhysicsVelocityMax(500)
    target:PreventDI()
    
    local direction = source:GetAbsOrigin() - target:GetAbsOrigin()
    direction = direction:Normalized()
    target:SetPhysicsAcceleration(direction * 50)
    
    target:OnPhysicsFrame(function(unit)
      -- Retarget acceleration vector
      local distance = source:GetAbsOrigin() - target:GetAbsOrigin()
      local direction = distance:Normalized()
      target:SetPhysicsAcceleration(direction * 50)
      
      -- Stop if reached the unit
      if distance:Length() < 100 then
        target:SetPhysicsAcceleration(Vector(0,0,0))
        target:SetPhysicsVelocity(Vector(0,0,0))
        target:OnPhysicsFrame(nil)
      end
    end)