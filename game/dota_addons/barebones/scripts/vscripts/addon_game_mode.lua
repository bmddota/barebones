-- Generated from template

require('util')
require('timers')
require('physics')
require('multiteam')
require('barebones')

function Precache( context )
	--[[
		Precache things here at your own peril.  They will very likely not be precached on clients.
		See GameMode:ActuallyPrecache() in barebones.lua for more information
		]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end