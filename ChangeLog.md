# Barebones ChangeLog

### Version 0.93
- Added animations.lua library
- Added USE_UNSEEN_FOG_OF_WAR to settings.lua to allow for turning on unseen fog of war behavior
- Updated notifications subsystem to support deleting notifications on-demand
- Added additional guards to better handle 'script_reload' for timers.lua
- Added additional guards to better handle 'script_reload' for projectiles.lua
- Added additional guards to better handle 'script_reload' for physics.lua

### Version 0.92c
- Updated notifications subsystem to support DOTAItemImage panel type.

### Version 0.92b
- Updated notifications subsystem to apply hittest="false" to all generated panels

### Version 0.92
- Updated notifications.lua to support DOTAAbilityImage and Image panel types.
- Updated notifications.lua to use a table-based function call **NOTE: Older multi-parameter calls to notifications.lua WILL FAIL.**
- Updated examples/notificationsExample.lua to reflect the new calls and table argument system.
- Fixed a simulation-failure issue with tree-handling in projectiles.lua when bCutTrees is false.
- Added changelog links for each library to Readme.md

### Version 0.91b
- Added new property to projectiles.lua projectile tables, "fVisionTickTime" which controls how quickly the projectile vision updates while the projectile is in motion.

### Version 0.91
- Began version tracking of all libraries.
- Fixed an issue where default projectiles.lua projectiles would not take on the correct velocity-oriented orientation automatically.
- Fixed an issue with the parameters for certain notifications.lua functions not accepting the "continue" parameter

### Version 0.90
- Started tracking version updates
- Updated projectiles.lua to allow for better orientation handling
- Updated projectiles.lua with new properties for projectile vision-related
- Updated ProjectilesReadme.md with new property information
- Updated examples/projectile.lua with new properties
- Fixed projectiles.lua tree detection to work with Reborn.