# attachments.lua ChangeLog

### Version 0.81
- Added the ability to set a prop to attach to "attach_origin" point, even if this attach string does not directly exist
- Removed extra "model" and "attach" properties from being saved to the attachment database
- Fixed up the model scale settings so that changing the scale of a model after attaching a prop will maintain prop proportions
- Added Attachments:GetAttachmentDatabase() function
- Adjusted the default scripts/attachments.txt database to contain correct values for a couple demonstration prop attaches

### Version 0.80
- Added attachments.lua library