# Barebones ChangeLog

### Version 1.01c
- Added example "REMOVE" lines to npc_abilities_override.txt for the new 6.87 items.

### Version 1.01b
- [physics.lua] Fixed visual issue in physics.lua box drawing + CreateBox bug

### Version 1.01a
- [worldpanels.lua] Added "data" object which can be added in the world panel configuration table to send arbitrary primitive data to the created worldpanel in javascript, accessible as $.GetContextPanel().Data
- [worldpanels.lua] Fixed an issue with completely client-unknown entities immideately deleting their world panels on create.

### Version 1.01
- New Library: WorldPanels  --  Containers allows for creating panorama layout panels that track the world position of an entity (or fixed world coordinate).

### Version 1.00
- New Library: Containers  --  Containers allows for additional inventory/item containing objects and shops
- New Library: (by Noya): Selection API.
- New Library: PathGraph  --  Constructs a full-edge graph of all "path_corner" objects.
- New Library: Modmaker  --  Offers a searchable version of the lua server vscript API through the "modmaker_api" console command (in tools mode)
- Fixed HideWearables utility function.
- Fixed OnItemPickedUp to work if a non-hero unit picks up an item.
- Fixed a minor potential deficiency in the randomseed selection
- Removed the need to call internal Barebones functions from the implementation events.lua
- Re-enabled "barebones_spew" cvar to allow for adjusting the visibility of barebones debugging messages
- Added new dota items to the commented out removal lines in npc_abilities_override.txt
- Added several new settings to settings.lua.
- Added an "animation_example" folder containing a demonstration of lua-scripted animation adjustments for models.
- [attachments.lua] Ensured that created attachment props have unique entity names.
- [attachments.lua] Fixed a bug related to the "Particles" section of the attachment database breaking on AttachProp
- [attachments.lua] Made it so that you don't have to enter the addon name when doing "attachment_configure"
- [attachments.lua] Fixed GetCurrentAttachment not working in normal non-gui use
- [projectiles.lua] Added a bDestroyImmediate property to the projectile definition which determines whether the DestroyParticle call should perform an immediate destruction.
- [projectiles.lua] Fixed a bug with changing velocity of certain projectiles.
- [projectiles.lua] Fixed a bug with OnFinish on ground collision.
- [projectiles.lua] Fixed an issue where projectile:Destroy() did not halt the particle simulation.
- [projectiles.lua] Added projectile:GetCreationTime(), projectile:GetDistanceTraveled(), projectile:GetPosition(), projectile:GetVelocity()
- [projectiles.lua] Projectiles now reports its thinker as "projectiles_lua_thinker" if the Entity System warns of the projectiles simulation running too long in console.
- [physics.lua] Updated to a new order of operations within the simulation.  If your existing code breaks, use physics_old.lua to maintain the old operation order.
- [physics.lua] Fixed an issue where unit:StopPhysicsSimulation() did not halt the physics simulation.
- [physics.lua] Calling Physics:Unit again now reinitializes the simulation in tools mode, but is ignored in live game mode.
- [physics.lua] Added a flat friction in addition to the percentage friction already existing.
- [physics.lua] Added static velocity setting/getting to manipulate individual force components separate from the combined force.
- [physics.lua] Added the ability to have a physics unit cut trees as it moves.
- [physics.lua] Added the ability for a unit to navigate according to the slope of the terrain itself for non-GNV navigation.
- [physics.lua] Physics now reports its thinker as "physics_lua_thinker" if the Entity System warns of the physics simulation running too long in console.
- [timers.lua] Added a shorthand for Timers:CreateTimer(...) as Timers(...)
- [timers.lua] Timers now continue to run after the game ends for post-game timing execution.
- [timers.lua] Timers library is now accessible as GameRules.Timers for instances where the Timers global is out of scope (triggers, etc)
- [timers.lua] Timers now allows a timer to successfully call Timers:RemoveTimer on itself from within the execution callback of the timer
- [timers.lua] Timers now reports its thinker as "timers_lua_thinker" if the Entity System warns of timers running too long in console.

### Version 0.95c
- Removed the RegisterConvar call from internal/gamemode.lua since Valve broke it and has yet to fix it.

### Version 0.95b
- [attachments.lua] Added the ability to attach multiple particles to a given prop.

### Version 0.95
- [notifications.lua] Changed the names of the panorama files from barebones_hud_base.* to barebones_notifications.*
- [projectiles.lua] Fixed 0-velocity projectiles producing a divide by 0 error

### Version 0.94d
- Added HideWearables and ShowWearables global utility functions.
- [attachments.lua] Added handling of Particle attachments to props via the attachments.txt database.
- [attachments.lua] Added Particle example to example attachments.txt database.
- [attachments.lua] Fixed the Attachments Configuration system being able to override extra keys placed in individual attachment definitions.  Extra key/values will not stick through saves/loads.
- [attachments.lua] Added optional "Animation" key to attachment properties in the attachments.txt database which will spawn the prop in question and force it into the given animation string.

### Version 0.94c
- [attachments.lua] Fixed debug spheres appearing when using AttachProp from in game.
- [attachments.lua] Fixed attachments.txt database scale not being used when scale is omitted from AttachProp call.

### Version 0.94b
- [attachments.lua] Added the ability to press Enter in any TextEntry to submit changes in the Attachment Configuration GUI
- [attachments.lua] Added the ability to scale the value of the + and - buttons for coarse and fine refinement
- [attachments.lua] Added the ability to toggle on/off the Debug Spheres showing the attachment point and prop point
- [attachments.lua] Removed the dependency on an external lua_modifier by internalizing the modifier definition to attachments.lua
- [attachments.lua] Removed the stun particle effect when Freezing a unit

### Version 0.94a
- [attachments.lua] Added the ability to set a prop to attach to "attach_origin" point, even if this attach string does not directly exist
- [attachments.lua] Removed extra "model" and "attach" properties from being saved to the attachment database
- [attachments.lua] Fixed up the model scale settings so that changing the scale of a model after attaching a prop will maintain prop proportions
- [attachments.lua] Added Attachments:GetAttachmentDatabase() function
- [attachments.lua] Adjusted the default scripts/attachments.txt database to contain correct values for a couple demonstration prop attaches

### Version 0.94
- Fixed the issue introduced due to Valve removing PlayerResource:HaveAllPlayersJoined()
- Added attachments.lua library and associated panorama GUI for creating attachment profiles
- Added missing hero references to herolist.txt
- Added handling for 'player_chat' event and userID->Player Entity tracking to the events.lua and internal/events.lua files
- [timers.lua] Added the ability to call a function with a table context
- [timers.lua] Added the use of the lua 'xpcall' function to give full stack traces if a timer errors out during execution.
- [animations.lua] Added FreezeAnimation function to allow for animations to be paused at any time
- [animations.lua] Added UnfreezeAnimation function to allow animations to be unpaused at any time

### Version 0.93c
- Added ability/item inflictor entity retrieval to OnEntityHurt and OnEntityKilled in events.lua

### Version 0.93b
- [animations.lua] Fixed an issue where perfectly sequential animations would not play
- [animations.lua] Added several missing translate activity modifiers
- [animations.lua] Added AddAnimationTranslate and RemoveAnimationTranslate commands to allow for easily adding/removing permanent translates like "injured"/"haste", etc

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