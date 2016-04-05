# attachments.lua ChangeLog

### Version 1.00
- Ensured that created attachment props have unique entity names.
- Fixed a bug related to the "Particles" section of the attachment database breaking on AttachProp
- Made it so that you don't have to enter the addon name when doing "attachment_configure"
- Fixed GetCurrentAttachment not working in normal non-gui use

### Version 0.85
- Added the ability to attach multiple particles to a given prop.

### Version 0.84
- Added handling of Particle attachments to props via the attachments.txt database.
- Added Particle example to example attachments.txt database.
- Fixed the Attachments Configuration system being able to override extra keys placed in individual attachment definitions.  Extra key/values will not stick through saves/loads.
- Added optional "Animation" key to attachment properties in the attachments.txt database which will spawn the prop in question and force it into the given animation string.

### Version 0.83
- Fixed debug spheres appearing when using AttachProp from in game.
- Fixed attachments.txt database scale not being used when scale is omitted from AttachProp call.

### Version 0.82
- Added the ability to press Enter in any TextEntry to submit changes in the Attachment Configuration GUI
- Added the ability to scale the value of the + and - buttons for coarse and fine refinement
- Added the ability to toggle on/off the Debug Spheres showing the attachment point and prop point
- Removed the dependency on an external lua_modifier by internalizing the modifier definition to attachments.lua
- Removed the stun particle effect when Freezing a unit


### Version 0.81
- Added the ability to set a prop to attach to "attach_origin" point, even if this attach string does not directly exist
- Removed extra "model" and "attach" properties from being saved to the attachment database
- Fixed up the model scale settings so that changing the scale of a model after attaching a prop will maintain prop proportions
- Added Attachments:GetAttachmentDatabase() function
- Adjusted the default scripts/attachments.txt database to contain correct values for a couple demonstration prop attaches

### Version 0.80
- Added attachments.lua library