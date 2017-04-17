# **BMD's Lua Advanced Projectiles Library**
--------------------------------

#### **How to install:**
- Drop projectiles.lua in with your vscripts
- Add require( 'projectiles' ) somewhere in your lua instantiation path

#### **How to use:**
- The projectiles library can be used to generate projectiles which are a combination of mathematical simulation and particle control.
- Projectiles.lua projectiles do not use a unit or entity as part of the projectile simulation, and as such are lighter weight than unit-based projectiles.
- Due to not using a unit, the projectile simulation can potentially get out of synch with the particle representation if there a large number of high-velocity changes.  Because of this, a projectile which needs highly complex motion is better off implemented as a Physics:Unit().
- Projectiles.lua projectiles have more advanced capabilities than default LinearProjectiles, including the ability to dynamically change direction/speed, operate in 3 dimentions, bounce off of walls/ground, be tracked easily by instance, affect trees, etc.


**Projectiles Library Functions**
=============================
#### **Projectiles:CreateProjectile(projectile)**
  This function is used to create ane release the projectile defined by the projectile table passed to the function.  The function returns an updated reference to the projectile table on which the Proejctile Table Functions can be called.  See the Projectiles Table Format section for more detail on what properties can be used with the projectile table.


#### **Projectiles:CalcSlope(pos, unit, dir)**
  This function can be used to get the estimated slope of the ground in the given Vector direction 'dir' at the world point Vector 'pos'.  The 'unit' parameter is used to specify what unit should be used with GetGroundPosition() in order to handle the ground collision sizing.  This function can return odd values when used around sheer vertical edges.

#### **Projectiles:CalcNormal(pos, unit, scale)**
  This function can be used to get the estimated normal Vector of the ground at the world point Vector 'pos'.  The 'unit' parameter is used to specify what unit should be used with GetGroundPosition() in order to handle the ground collision sizing.  This function can return odd values when used around sheer vertical edges.


**Projectile Table Functions**
=============================
A projectile table which has been fed to CreateProjectile will have the following functions:

#### **projectile:GetVelocity()**
  This function can be called to get the current velocity vector of this projectile.

#### **projectile:Destroy()**
  This function can be called to immediately destroy this projectile, triggering its OnFinish callback function if present.

#### **projectile:SetVelocity(newVel[, newPos])**
  This function can be called to adjust the current velocity of the projectile, as well as the current simulated position of the unit (if specified).  The projectile simulation and particle will only update if the projectile is within its nMaxChanges velocity change limit.

#### **projectile:GetCreationTime()**
  This function reutnrs the creation time in GameTime of this projectile.

#### **projectile:GetDistanceTraveled()**
  This function returns the total distance traveled by this projectile in hammer units per second.  Only counts distance moved due to velocity and not by setting a new position with SetVelocity.

#### **projectile:GetPosition()**
  This function returns the current world position of the projectile.




**Projectiles Table Format**
=============================
Projectiles are effectively a formatted lua table which is registered with the Projectiles API for processing and action.  All projectiles tables can have the following properties and functions:

| Property  | Default | Description |
| :------------ | :--------| :-----|
| bProvidesVision | false | If set to true, this projectile will provide vision around it as it travels. |
| bCutTrees | false | If set to true, this projectile will cut any trees that it comes in contact with. |
| bFlyingVision | true | If set to true and, this projectile will provide flying vision as it travels (if bProvidesVision is enabled) |
| bGroundLock | false | If set to true, the simulation will lock its height to the ground position + fGroundOffset.  This setting is useful for simulating Dota-like LinearProjectiles that effectively operate in 2D. |
| bIgnoreSource | true | If set to true, this projectile will not affect source. |
| bMultipleHits | false | If set to true, this projectile can hit units multiple times after a timeout specified by fRehitDelay. |
| bRecreateOnChange | true | If set to true, the particle representing the projectile will be Destroyed and recreated whenever a velocity/position change is forced.  If false, only the control points for the existing particle will be changed. |
| bTreeFullCollision | false | If set to true, this projectile will use the full collision radius of trees in determining tree collision, effectively hitting trees further out from the natural radius. |
| bZCheck | true | If set to true, this particle will check the height/z-coordinate in order to determine if there is a collision in 3D.  If set to false, it will not care about z-coordinate and will use dota-like 2D collision.  |
| ControlPoints | {} | A table of additional control points to set when creating/recreating the particle for this projectile.  Use this to set additional particle properties. Ex: {[5]=Vector(2,0,0)} |
| ControlPointForwards | {} | A table of control points for which to set Forward orientations when creating/recreating the particle for this projectile.  Ex: {[5]=unit:GetForwardVector()} |
| ControlPointOrientations | {} | A table of control points for which to set Orientations triplets when creating/recreating the particle for this projectile. Ex: {[5]={unit:GetForwardVector(), unit:GetForwardVector(), unit:GetForwardVector()}} |
| ControlPointEntityAttaches | {} | A table of Entity/ControlPoint attachments to set when creating/recreating the particle for this projectile. Ex: {[0]={unit = hero, pattach = PATTACH_ABSORIGIN_FOLLOW, attachPoint = "attach_attack1", -- nil origin = Vector(0,0,0)}} |
| draw | false | If set to true, will draw a DebugDrawSphere showing the simulation in space as it travels/changes for debugging.  Can be also specified by a table like {color=Vector(200,0,0), alpha=5} for differntiation. |
| EffectName | &lt;none&gt; | The particle path+file to use for the projectile particle, or "" for no particle. |
| fChangeDelay | .1 | A minimum delay in GameTime to wait between velocity/position changes. |
| fDistance | 1000 | The maximum travel distance of this projectile at which point it will expire and call OnFinish if present. |
| fEndRadius | 100 | The projectile collision radius to scale to at the end of this projectiles distance/expiration time. |
| fExpireTime | 10.0 | The time in seconds of GameTime for this projectile to live.  Will call OnFinish when the expiration time is reached if present. |
| fGroundOffset | 40 | The z-offset/height to use in Ground-based calculations or ground-locking |
| fRadiusStep | &lt;computed&gt; | If specified, the radius step is the amount of increase/decrease to happen to the radius every second  |
| fRehitDelay | 1 | The multiple hit delay in seconds to use for each unit hit by this projectile (i.e. 1.0 means don't rehit the same unit unless struck again after 1.0 seconds from the previous strike) |
| fStartRadius | 100 | The projectile collision radius to start the projectile at |
| fVisionTickTime | .1 | The time in seconds between projectile vision updates while in flight.  Rounds up to the nearest frame-boundary (.0333,.06666,.1, etc) |
| fVisionLingerDuration | .1 | The time in seconds that the vision should linger as the projectile moves.  Defaults to the same value as fVisionTickTime. |
| GroundBehavior | PROJECTILES_DESTROY | The behavior that the particle should exhibit when colliding with the ground.  PROJECTILES_NOTHING means to do nothing to the projectile.  PROJECTILES_DESTROY means to destroy this projectile.  PROJECTILES_BOUNCE means to bounce off the ground.  PROJECTILES_FOLLOW means to follow the slope of the ground when colliding. |
| iPositionCP | 0 | The control point to use for the position of the particle. |
| iVelocityCP | 1 | The control point to use for the velocity of the particle. |
| iVisionRadius | 200 | The vision radius for this projectile if enabled. |
| iVisionTeamNumber | &lt;Source unit's team&gt; | The team for which to display this projectile's vision if enabled.|
| nChangeMax | 1 | The maximum number of velocity/position changes this particle can undergo before it stops allowing changing position/velocity. |
| Source | &lt;none&gt; | The source unit of this projectile |
| TreeBehavior | PROJECTILES_DESTROY | The behavior that the particle should exhibit when colliding with a tree.  PROJECTILES_NOTHING means to do nothing to the projectile.  PROJECTILES_DESTROY means to destroy this projectile.|
| UnitBehavior | PROJECTILES_DESTROY | The behavior that the particle should exhibit when colliding with a unit which passes the UnitTest function.  PROJECTILES_NOTHING means to do nothing to the projectile.  PROJECTILES_DESTROY means to destroy this projectile.|
| vSpawnOrigin | Vector(0,0,0) | The initial spawn world position of this projectile. Can be specified in a table form to fire from the attachment point of a unit. Ex: {unit=unitHandle, attach="attach_attack1"[, offset=Vector(0,0,80)]}|
| vVelocity | Vector(0,0,0) | The initial velocity of this projectile |
| WallBehavior | PROJECTILES_DESTROY | The behavior that the particle should exhibit when colliding with a wall created by terrain.  PROJECTILES_NOTHING means to do nothing to the projectile.  PROJECTILES_DESTROY means to destroy this projectile.  PROJECTILES_BOUNCE means to bounce off the wall. |


| Functions  | Parameters | Description |
| :------------ | :---------| :-----|
| OnFinish      | projectileTable, position | This function is called when the projectile is destroyed or expires for any reason other than Destroy() being called manually. |
| OnGroundHit      | projectileTable, groundPosition | This function is called whenever the projectile hits the ground. |
| OnTreeHit      | projectileTable, treeEntity | This function is called whenever the projectile hits a tree. |
| OnUnitHit      | projectileTable, unit | This function is called whenever the projectile hits a unit that passes the UnitTest function. |
| OnWallHit      | projectileTable, wallPosition | This function is called whenever the projectile hits a wall. |
| UnitTest      | projectileTable, unit | This function is called whenever the projectile comes in contact with a unit to test whether this unit should be hit by this projectile.  This function should return true if the unit should be hit, or false if the unit shouldn't be hit. |


**Examples:** 
=============================
See [examples/projectile.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/examples/projectile.lua) for a projectile example.