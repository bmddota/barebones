# Barebones ChangeLog

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