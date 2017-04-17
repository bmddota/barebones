# Barebones Starter Mod Kit

### Version 1.01c
### [Change Log](https://github.com/bmddota/barebones/blob/source2/ChangeLog.md)

## Introduction
Barebones is meant to be a jumping off point for creating a mod with all (or nearly all) of the boilerplate taken care of for you.
Barebones sets up the necessary files to create a basic mod (from a scripting persective), allowing you to simply find the places to put your Lua logic in order for you mod to operate.
Barebones currently provides limited examples for performing different tasks, and limited examples for unit/ability/item creation.
Barebones divides scripts up into several sections: Core Files, Libraries, Examples and Internals.

## Installation
Barebones can be installed by downloading this git repository and ensuring that you merge the "content" and "game" folder from this repo with your own "content" and "game" folders.  These should be located in your "<SteamLibraryDirectory>\SteamApps\common\dota 2 beta\" folder.  **Be sure you don't use the "dota_ugc" folder!**

## Core Files
Core Files are the primary files which you should modify in order to get your basic game mode up and running.  There are 4 major files:

#### settings.lua
This file contains many special settings/properties created for barebones that allows you to define the high-level behavior of your game mode.
You can define things like respawn times, number of teams on the map, rune spawn times, etc.  Each property is commented to help you understand it.

#### gamemode.lua
This is the primary barebones gamemode script and should be used to assist in initializing your game mode.
This file contains helpful pseudo-event functions prepared for you for frequently needed initialization actions.

#### events.lua
This file contains a hooked version of almost every event that is currently known to fire in the DotA 2 Lua vscript code.
You can drop your event handler functions in there to have your game mode react to events.

#### addon_game_mode.lua
This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc.

## Libraries
I've included some helpful libraries with barebones that may prove useful in your game mode.

#### timers.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/TimersChangeLog.md)
This library allow for easily delayed/timed actions without the messiness of thinkers and dealing with pauses.

#### physics.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/PhysicsChangeLog.md)
This library can be used for advancted physics/motion/collision of units.  
See [PhysicsReadme.md](https://github.com/bmddota/barebones/blob/source2/PhysicsReadme.md) and [CollidersReadme.md](https://github.com/bmddota/barebones/blob/source2/CollidersReadme.md) for more information.

#### projectiles.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/ProjectilesChangeLog.md)
This library can be used for advanced 3D projectile systems.  
See [ProjectilesReadme.md](https://github.com/bmddota/barebones/blob/source2/ProjectilesReadme.md) for more information.

#### notifications.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/NotificationsChangeLog.md)
This library can be used to send panorama notifications to individuals/teams/everyone in your game.  
See [libraries/notifications.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/notifications.lua) for usage details and examples.

#### animations.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/AnimationsChangeLog.md)
This library can be used to start animations with customized animation rates, activities, and translations.  
See [libraries/animations.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/animations.lua) for usage details and examples.

#### attachments.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/AttachmentsChangeLog.md)
This library can be used to set up and put in place 'Frankenstein' attachments for attaching props to units.  
See [libraries/attachments.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/attachments.lua) for usage details and examples.

#### playertables.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/PlayerTablesChangeLog.md)
This library sets up tables that are shared between server (lua) and client (javascript) between specific (but changeable) clients.  Similar to nettables.
See [libraries/playertables.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/playertables.lua) for usage details and examples.  

#### containers.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/ContainersChangeLog.md)
This library allows for additional inventory/item containing objects and shops to be used in your game mode.
See [libraries/containers.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/containers.lua) for usage details.  
See [examples/playground.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/examples/playground.lua) for detailed examples.

#### worldpanels.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/WorldPanelsChangeLog.md)
This library allows for creating panorama layout panels that track the world position of an entity (or fixed world coordinate).
See [libraries/worldpanels.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/worldpanels.lua) for usage details and examples.  

#### selection.lua  [By Noya](https://github.com/MNoya)
This library allows for querying and managing the selection status of players from the server-side lua script.  It also allows for automatic redirection and selection event handling.
See [libraries/selection.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/selection.lua) for usage details and examples.  

#### pathgraph.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/PathGraphChangeLog.md)
This library constructs a full-edge graph of all "path_corner" objects, allowing for the use of the path links via lua script.
See [libraries/pathgraph.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/pathgraph.lua) for usage details and examples.  

#### modmaker.lua  [Change Log](https://github.com/bmddota/barebones/blob/source2/ModmakerChangeLog.md)
This library offers a searchable version of the lua server vscript API through the "modmaker_api" console command (in tools mode)
See [libraries/modmaker.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/modmaker.lua) for usage details and examples.  



## Internals
Barebones uses a few internal lua files in order to put together and handle the properties and pseudo-events systems.  You will likely not have to adjust these files at all.
These files are found in the internal directory.

## Debugging
Barebones now only prints out (spams) debugging information when told to by setting the BAREBONES_DEBUG_SPEW value in gamemode.lua to true.
Previously there was a 'barebones_spew' cvar that could be used to change the debug printing state at any time from the console, but Valve broke RegisterConvar for some reason, so this has been disabled.


## Additional Information
- Barebones also comes with a sample loading screen implementation in panorama which you can view and edit via the content panorama directory.
- You can change the name of the multiteams used at the Game Setup screen by editing the game/barebones/panorama/localization/addon_english.txt file.
- You can adjust the number of players allowed on each of your maps by editing addoninfo.txt.

If you have any questions or concerns, leave an issue or mail me (bmddota@gmail.com).