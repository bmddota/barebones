-- Generated from template

require('util')
require('physics')
require('multiteam')
require('barebones')

--[[if ReflexGameMode == nil then
    print ( '[REFLEX] creating reflex game mode' )
	  ReflexGameMode = class({})
end]]

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
		PrecacheUnitByNameSync('npc_dota_hero_axe', context)
    	PrecacheResource( "soundfile", "*.vsndevts", context )
    	PrecacheResource( "particle_folder", "particles/frostivus_gameplay", context )
		PrecacheUnitByNameSync('npc_precache_everything', context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = BareBonesGameMode()
	GameRules.AddonTemplate:InitGameMode()
end