# physics.lua ChangeLog

### Version 1.01
- Fixed visual issue in physics.lua box drawing + CreateBox bug

### Version 1.00
- Updated to a new order of operations within the simulation.  If your existing code breaks, use physics_old.lua to maintain the old operation order.
- Fixed an issue where unit:StopPhysicsSimulation() did not halt the physics simulation.
- Calling Physics:Unit again now reinitializes the simulation in tools mode, but is ignored in live game mode.
- Added a flat friction in addition to the percentage friction already existing.
- Added static velocity setting/getting to manipulate individual force components separate from the combined force.
- Added the ability to have a physics unit cut trees as it moves.
- Added the ability for a unit to navigate according to the slope of the terrain itself for non-GNV navigation.
- Physics now reports its thinker as "physics_lua_thinker" if the Entity System warns of the physics simulation running too long in console.

### Version 0.91
- Added additional guards to better handle 'script_reload' 

### Version 0.90
- Added global PHYSICS_VERSION
- Started tracking version updates for physics.lua