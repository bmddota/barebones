BMD's Lua Unit Physics Library
--------------------------------
See CollidersReadme.txt for documentation and examples on using Colliders.

How to install:
- Drop physics.lua in with your vscripts
- Add require( 'physics' ) somewhere in your lua instatiation path

How to use:
- To turn any dota unit into a Physics unit, run
    Physics:Unit(unitEntity)
- This adds a bunch of new functions to the unit which allow for it to simulate physics
- All velocity/acceleration vectors are in hammer units per second or hammer units per second squared

=================================
IMPORTANT CHANGES FOR UPGRADING
=================================
-Accelerations were previously configured incorrectly and were expecting a hammer units per second per frame acceleration.
	This has been corrected and accelerations should now be specified correctly as hammer units per second squared.
-SetStuckTimeout was previously configured to expect a miscalculated timeout.
	This has been corrected and SetStuckTimeout now accepts the number of frames (1/30 seconds) to wait before engaging
	the AutoUnStuck system.
	
=============================
Physics Library Functions
=============================
Physics:Unit (unit)
	Makes a unit into a "physics" unit which can be manipulated using the PhysicsUnit functions
-----------------------------	
Physics:AngleGrid (anggrid, angoffsets)
	This function is an advanced means of setting a normal map for GridNav collisions so as to yield better bounces for PHYSICS_NAV_BOUNCE collisions.
-----------------------------
IsPhysicsUnit (unit)
	This global function returns true if the unit in question has been converted to a "physics" unit.
-----------------------------

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
GetAutoUnstuck ()
	Whether this unit will be returned to its last known good position in the event that it is determined to be stuck in unpathable terrain.  Default is true.
-----------------------------
GetBounceMultiplier ()
	Returns the float representing the multiplier to apply to a unit's velocity's magnitude in the event that they bounce via PHYSICS_NAV_BOUNCE.  Default is 1.0 (aka no velocity magnitude change)
-----------------------------
GetLastGoodPosition ()
	Returns the vector position which was the last known position that the unit was in that was unblocked/pathable.
-----------------------------
GetNavCollisionType ()
    Returns the current GridNav Collision Type (PHYSICS_NAV_NOTHING, PHYSICS_NAV_HALT, PHYSICS_NAV_SLIDE, or PHYSICS_NAV_BOUNCE)
-----------------------------
GetNavGridLookahead ()
	Returns the current number of Navigation Grid lookahead points.  See SetNavGridLookahead for more details. Default is 1
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
GetRebounceFrames ()
	Returns the number of rebounce frames to wait between PHYSICS_NAV_BOUNCE collisions.  Default is 5.
-----------------------------
SetStuckTimeout ()
	Returns the number of frames necessary to determine if a unit is stuck in unpathable terrain and to activate AutoUnstuck
-----------------------------
GetSlideMultiplier ()
    Returns the slide multipler value. Default is 0.1
-----------------------------
GetTotalVelocity ()
	Returns the unit's total velocity (i.e. Physics velocity + slide velocity + standard right-click movement).  This is nonfunctional while
	a unit is hibernating, and will return Vector(0,0,0) on the first frame that a Physics unit is created, but a correct value thereafter.
-----------------------------
GetVelocityClamp ()
    Returns the current velocity clamp in hammer units per second.  Default is 20 hammer units per second
-----------------------------
Hibernate (boolean)
    Whether this unit should Hibernate when there is no sliding/acceleration/velocity.  
	When hibernating the unit performs no physics calculation until new force/acceleration/sliding is applied.  
	Additionally, OnPhysicsFrame will not be called if this unit is hibernating.
	Default is that a unit will hibernate.
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
OnBounce (function(unit, normal))
    Set the callback function to be executed when a PHYSICS_NAV_BOUNCE is occuring, but after the velocity rebound calculation has been
    performed and applied.  The function passed in has two parameters given to it, the unit in question and the normal vector of the surface
    that the unit is bouncing off of.
-----------------------------
OnHibernate (function(unit))
	Set the callback function (with one parameter, the unit in question) to be executed in the event that this unit begins hibernating.
-----------------------------
OnPreBounce (function(unit, normal))
    Set the callback function to be executed when a PHYSICS_NAV_BOUNCE is occuring, but before the velocity rebound calculation has been
    performed and applied.  The function passed in has two parameters given to it, the unit in question and the normal vector of the surface
    that the unit is bouncing off of.
-----------------------------
OnPhysicsFrame (function(unit))
    Set the callback function (with one parameter, the unit in question) to be executed every frame for this unit so long as it is not hibernating.  
	You can use this function to do additional calculations/collision detection/velocity modification.
-----------------------------
PreventDI (boolean)
    Whether to prevent this unit from influencing the direction of the simulation.  The default is false
-----------------------------
SetAutoUnstuck (boolean)
	Whether to return this unit to its last known good position in the event that the library determines them to be "stuck" for enough frames in an unpathable area.  Default is true.
-----------------------------
SetBounceMultiplier (bounceMultipler)
	Sets the magnitude to adjust the velocity of a unit in the event of a PHYSICS_NAV_BOUNCE bounce.  .5 would halve the total velocity of the unit, while 2.0 would double it on bounce. Default is 1.0. 
-----------------------------
SetGroundBehavior (groundBehavior)
	Sets the behavior that the physics system will use for a unit with respect to the ground's position.  Possibilities are PHYSICS_GROUND_NOTHING, PHYSICS_GROUND_ABOVE, or PHYSICS_GROUND_LOCK.  Default is PHYSICS_GROUND_ABOVE
        -PHYSICS_GROUND_NOTHING: The unit will be able to pass through terrain and will not change its z-coordinate in any way concerning terrain
        -PHYSICS_GROUND_ABOVE: The unit will follow the ground so long as the ground is "above" the unit.  If the unit is above the ground, it will not lock to the ground.
        -PHYSICS_GROUND_LOCK: The unit will remain attached to the ground regardless of z-coordinate position/velocity/acceleration
-----------------------------
SetNavCollisionType (navCollisionType)
    Sets the behavior that the physics system will use when this unit collides with the GridNav mesh.  Possibilities are PHYSICS_NAV_NOTHING, PHYSICS_NAV_HALT, PHYSICS_NAV_SLIDE, or PHYSICS_NAV_BOUNCE.  Default is PHYSICS_NAV_SLIDE
        -PHYSICS_NAV_NOTHING: The unit will continue normal velocity/position calculations, potentially bumping up against the nav mesh multiple times
        -PHYSICS_NAV_HALT: The unit will halt its velocity immediately in all directions
        -PHYSICS_NAV_SLIDE: The unit will halt its velocity in only the x or y direction depending on the collision direction with the GridNav
        -PHYSICS_NAV_BOUNCE: The unit will bounce off of the GridNav mesh face it contacts with, continuing on in a different direction with the same velocity magnitude
-----------------------------
SetNavGridLookahead (lookaheadPoints)
	Sets the number of navigation grid lookahead points to use when determining a navigation grid collision for PHYSICS_NAV_HALT/NOTHING/SLIDE/BOUCE.
	The physics system will lookahead to the 1..lookaheadPoints-1 / lookaheadPoints the distance to the next position in order to determine if the unit will pass into an
	unwalkable location during the next frame. Increasing this number allows for higher speed collisions with the navigation grid and helps to prevent units from
	slipping through the grid by using speed.  Default is 1.  Note: This adds a lot of calculations even at 3 or 4, so be careful with this value for performance reasons.
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
SetRebounceFrames (rebounceFrames)
	Sets the number of frames to wait between PHYSICS_NAV_BOUNCE gridnav collisions before allowing for another collision to take place.  Default is 5 (aka 1/6 of a second)
-----------------------------
SetSlideMultiplier (slideMultiplier)
    Sets the slide multiplier.  The default is 0.1
-----------------------------
SetStuckTimeout (stuckFrames)
	Sets the number of frames to wait before determining that the player is "stuck" in an unpathable area before returning them via AutoUnstuck to their last known
	good position.  The default is 3 frames (aka .1 seconds).
-----------------------------
SetVelocityClamp (clamp)
    Sets the velocity magnitude clamp for stopping physics calculations/hibernating.  The default is 20 hammer units per second
-----------------------------
SkipSlide (frames)
	Sets the number of frames for which to skip the slide calculation for this unit.  This is useful when you need to reposition a unit (respawn/blink/etc) but don'target
	want the Physics library slide calculation to add in a massive sliding velocity due to that teleport.  In the same frame as the respawn/blink you should issue a 
	unit:SkipSlide(2).  Slide calculations will resume when all SkipSlide frames are counted out.
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
    hero:Slide(true)

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