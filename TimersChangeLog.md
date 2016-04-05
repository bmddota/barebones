# timers.lua ChangeLog

### Version 1.05
- Added a shorthand for Timers:CreateTimer(...) as Timers(...)
- Timers now continue to run after the game ends for post-game timing execution.
- Timers library is now accessible as GameRules.Timers for instances where the Timers global is out of scope (triggers, etc)
- Timers now allows a timer to successfully call Timers:RemoveTimer on itself from within the execution callback of the timer
- Timers now reports its thinker as "timers_lua_thinker" if the Entity System warns of timers running too long in console.

### Version 1.03
- Added the ability to call a function with a table context
- Added the use of the lua 'xpcall' function to give full stack traces if a timer errors out during execution.

### Version 1.01
- Added additional guards to better handle 'script_reload' 

### Version 1.00
- Added global TIMERS_VERSION
- Started tracking version updates for timers.lua