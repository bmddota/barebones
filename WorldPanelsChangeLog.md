# worldpanels.lua ChangeLog

### Version 0.81
- Added "data" object which can be added in the world panel configuration table to send arbitrary primitive data to the created worldpanel in javascript, accessible as $.GetContextPanel().Data
- Fixed an issue with completely client-unknown entities immideately deleting their world panels on create.

### Version 0.80
- Added worldpanels.lua library