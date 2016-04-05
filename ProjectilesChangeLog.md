# projectiles.lua ChangeLog

### Version 1.00
- Added a bDestroyImmediate property to the projectile definition which determines whether the DestroyParticle call should perform an immediate destruction.
- Fixed a bug with changing velocity of certain projectiles.
- Fixed a bug with OnFinish on ground collision.
- Fixed an issue where projectile:Destroy() did not halt the particle simulation.
- Added projectile:GetCreationTime(), projectile:GetDistanceTraveled(), projectile:GetPosition(), projectile:GetVelocity()
- Projectiles now reports its thinker as "projectiles_lua_thinker" if the Entity System warns of the projectiles simulation running too long in console.

### Version 0.84
- Fixed 0-velocity projectiles producing a divide by 0 error

### Version 0.83
- Added additional guards to better handle 'script_reload' 

### Version 0.82
- Fixed a simulation-failure issue with tree-handling in when bCutTrees is false.

### Version 0.81
- Added new property to projectile tables, "fVisionTickTime" which controls how quickly the projectile vision updates while the projectile is in motion.

### Version 0.80
- Added global PROJECTILES_VERSION
- Started tracking version updates for projectiles.lua