--[[
Usage:

You firstly need to include the module like so:

require('lib.statcollection')

You can then begin to collect stats like this:

statcollection.addStats({
    modID = 'YourUniqueModID',
    someStat = 'someOtherValue'
})

You can call statcollection.addStats() with a table at any stage to add new stats,
old stats will still remain, if you provide new values, the new values will override
the old values.

Note: Stats will be automatically sent to the server when the game is detected as completed!

You can turn the auto sending off by calling

statcollection.disableAutoSend()

Then when you're ready to store the stats (only call this once!)

statcollection.sendStats({
    anyExtraStats = 'WhatEver'
})

The statcollection.sendStats() can either be called blank, or with a table of extra
stats, if you've already added all the stats using addStats, then you can simply
call this function with no arguments.

Readers beware: You are REQUIRED to set AT LEAST modID to your mods unique ID
]]

-- Begin statcollection module
module('statcollection', package.seeall)

-- This is the version of stat collection -- do not touch!
local STAT_COLLECTION_VERSION = '4'

-- Require libs
local libpath = (...):match('(.-)[^%.]+$')
local JSON = require(libpath .. 'json')
local md5 = require(libpath .. 'md5')

-- Max number of players
local maxPlayers = 10

-- A table of stats we have collected
local collectedStats = {}

-- Makes sure we don't call the stat collection multiple times
local alreadySubmitted = false

-- Should we auto send stats?
local autoSendStats = true

-- A store of player names
local storedNames = {}

-- For the following functions, setting safe to true will STOP the function from override old stats
-- If you leave safe out, or set it to false, it will override old stats (if any exist)

-- This function should be called with a table of stats to add
function addStats(stats, safe)
    -- Ensure args were passed
    local toAdd = stats or {}

    -- Store the fields
    for k, v in pairs(toAdd) do
        if not safe or collectedStats[k] == nil then
            collectedStats[k] = v
        end
    end
end

-- This function should be called with a table of flags to add
function addFlags(flags, safe)
    -- Ensure args were passed
    local toAdd = flags or {}

    -- Ensure flags exist
    collectedStats.flags = collectedStats.flags or {}

    -- Store the fields
    for k, v in pairs(toAdd) do
        if not safe or collectedStats.flags[k] == nil then
            collectedStats.flags[k] = v
        end
    end
end

-- This function sets the stats adds the stats for a given module
function addModuleStats(module, stats, safe)
    -- Ensure args were passed
    local toAdd = stats or {}

    -- Ensure flags exist
    collectedStats.modules = collectedStats.modules or {}
    collectedStats.modules[module] = collectedStats.modules[module] or {}

    -- Store the fields
    for k, v in pairs(toAdd) do
        if not safe or collectedStats.modules[module][k] == nil then
            collectedStats.modules[module][k] = v
        end
    end
end

-- This function RELIABLY gets a player's name
-- Note: PlayerResource needs to be loaded (aka, after Activated has been called)
--       This method is safe for all of our internal uses
function GetPlayerNameReliable(playerID)
    -- Ensure player resource is ready
    if not PlayerResource then
        return 'PlayerResource not loaded!'
    end

    -- Grab their steamID
    local steamID = tostring(PlayerResource:GetSteamAccountID(playerID) or -1)

    -- Return the name we have set, or call the normal function
    return storedNames[steamID] or PlayerResource:GetPlayerName(playerID)
end

-- This function returns a snapshop of a given player
function getPlayerSnapshot(playerID)
    -- Ensure we have a valid player in this slot
    if PlayerResource:IsValidPlayer(playerID) then
        -- Attempt to find hero data
        local heroData, itemData, abilityData
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        if IsValidEntity(hero) then
            -- Build ability data
            abilityData = {}
            local abilityCount = 0
            while abilityCount < 16 do
                -- Grab an ability
                local ab = hero:GetAbilityByIndex(abilityCount)

                -- Check if it is valid
                if IsValidEntity(ab) then
                    -- Check if the ability is hidden
                    -- We do it this way, so if it is not hidden
                    -- It wont appear in the schema at all
                    local hidden
                    if ab:IsHidden() then
                        hidden = true
                    end

                    -- Store ability
                    table.insert(abilityData, {
                        index = ab:GetAbilityIndex(),
                        abilityName = ab:GetAbilityName(),
                        level = ab:GetLevel(),
                        hidden = hidden
                    })
                end

                -- Move onto the next ability slot
                abilityCount = abilityCount + 1
            end

            -- Build item data
            itemData = {}
            local itemCount = 0
            while itemCount < 12 do
                -- Grab an item
                local item = hero:GetItemInSlot(itemCount)

                -- Check if the item is valid
                if IsValidEntity(item) then
                    -- Store the item
                    table.insert(itemData, {
                        index = itemCount,
                        itemName = item:GetAbilityName(),
                        itemStartTime = item:GetPurchaseTime()
                    })
                end

                -- Move onto the next item
                itemCount = itemCount + 1
            end

            -- Store hero info
            heroData = {
                -- The ID of the hero
                heroID = PlayerResource:GetSelectedHeroID(playerID),

                -- The current level of the hero
                level = PlayerResource:GetLevel(playerID),

                -- The amount of structure damage this player has
                --structureDamage = NO METHOD YET

                -- The amount of hero damage this player has
                --heroDamage = PlayerResource:GetRawPlayerDamage(playerID),

                -- The amount of kills this player has
                kills = PlayerResource:GetKills(playerID),

                -- The total assists this player has
                assists = PlayerResource:GetAssists(playerID),

                -- The total deaths this player has
                deaths = PlayerResource:GetDeaths(playerID),

                -- The total gold this player has (reliable + unreliable together)
                gold = PlayerResource:GetGold(playerID),

                -- The total denies this player has
                denies = PlayerResource:GetDenies(playerID),

                -- The total last hits this player has
                lastHits = PlayerResource:GetLastHits(playerID),



				stunAmount = PlayerResource:GetStuns(playerID),

				goldSpentBuyBack = PlayerResource:GetGoldSpentOnBuybacks(playerID),
				goldSpentConsumables = PlayerResource:GetGoldSpentOnConsumables(playerID),
				goldSpentItems = PlayerResource:GetGoldSpentOnItems(playerID),
				goldSpentSupport = PlayerResource:GetGoldSpentOnSupport(playerID),
				numPurchasedConsumables = PlayerResource:GetNumConsumablesPurchased(playerID),
				numPurchasedItems = PlayerResource:GetNumItemsPurchased(playerID),
				totalEarnedGold = PlayerResource:GetTotalEarnedGold(playerID),
				totalEarnedXP = PlayerResource:GetTotalEarnedXP(playerID)
            }
        end

        -- Grab their teamID
        local teamID = PlayerResource:GetTeam(playerID)

        -- Attempt to find their slotID
        local slotID
        for i = 0, maxPlayers-1 do
            if PlayerResource:GetNthPlayerIDOnTeam(teamID, i) == playerID then
                slotID = i
                break
            end
        end

        -- Return the data
        return {
            teamID = teamID,
            slotID = slotID,
            playerName = GetPlayerNameReliable(playerID),
            steamID32 = PlayerResource:GetSteamAccountID(playerID),
            hero = heroData,
            items = itemData,
            abilities = abilityData,
            connectionStatus = PlayerResource:GetConnectionState(playerID),
        }
    end

    -- Not a valid player
    return nil
end

-- Function to send stats
function sendStats(extraFields)
    -- Ensure it is only called once
    if alreadySubmitted then
        print('ERROR: You have already called statcollection.sendStats()')
        return
    end

    -- Ensure some stats were passed
    extraFields = extraFields or {}

    -- Copy in the extra fields
    for k, v in pairs(extraFields) do
        -- Ensure the field doesn't already exist
        if not collectedStats[k] then
            collectedStats[k] = v
        end
    end

    -- Check if the modID has been set
    if not collectedStats.modID then
        print('ERROR: Please call statcollection.addStats() with modID!')
        return
    end

    -- Build player array
    local playersData = {}
    for i = 0, maxPlayers - 1 do
        -- Try and grab info on this player
        local data = getPlayerSnapshot(i)
        if data then
            -- Store the data
            table.insert(playersData, data)
        end
    end

    -- Tell the user the stats are being sent
    print('Sending stats...')

    -- Stop this function from being called again
    alreadySubmitted = true

    -- Grab useful info to make a 'unique' hash
    local currentTime = GetSystemTime()
    local ip = intToIP(Convars:GetStr('hostip'))
    local port = Convars:GetStr('hostport')
    local randomness = RandomFloat(0, 1) .. '/' .. RandomFloat(0, 1) .. '/' .. RandomFloat(0, 1) .. '/' .. RandomFloat(0, 1) .. '/' .. RandomFloat(0, 1)

    -- Add common stats if they aren't already added
    addStats({
        -- The version of the module
        version = STAT_COLLECTION_VERSION,

        -- The local address of this server
        serverAddress = ip..':'..port,

        -- The round data
        rounds = {
            players = playersData
        },

        -- The current map
        map = GetMapName(),

        -- The winner (if they are using forts)
        winner = findWinnerUsingForts(),

        -- The duration of the match
        duration = GameRules:GetGameTime()
    }, true)

    -- Add flags if they aren't already added
    addFlags({
        -- Is this a dedi server or not?
        dedicated = IsDedicatedServer()
    }, true)

    -- Setup the string to be hashed
    local toHash = ip .. ':' .. port .. ' @ ' .. currentTime .. ' + ' .. randomness .. ' + '

    -- Add all the fields into the toHash
    for k, v in pairs(collectedStats) do
        toHash = toHash .. tostring(k) .. '=' .. tostring(v) .. ','
    end

    -- Store the unique match ID
    collectedStats.matchID = md5.sumhexa(toHash)

    -- Encode the data
    local json = JSON:encode(collectedStats)

    -- Log to the server
    print(json)

    -- We are going to break the string into small chunks
    local chunkSize = 500

    local totalMessages = math.ceil(json:len() / chunkSize)
    for i = 0, totalMessages - 1 do
        -- Send the message
        FireGameEvent("stat_collection_part", {
            data = json:sub(i * chunkSize + 1, (i + 1) * chunkSize)
        })
    end

    -- Tell the client the message is over
    FireGameEvent("stat_collection_send", {})
end

-- Sexy function to convert an integer to an IP
function intToIP(int)
    local ip

    for j=0,3 do
        local useful = bit.rshift(int, j*8)

        local ipPart = 0
        for i=0,7 do
            ipPart = ipPart + bit.band(useful, bit.lshift(1, i))
        end

        if not ip then
            ip = ipPart
        else
            ip = ipPart..'.'..ip
        end
    end

    return ip
end

-- This function is called to prevent stats from being auto sent
function disableAutoSend()
    autoSendStats = false
end

-- Returns the current version of stat collection
function getVersion()
    return STAT_COLLECTION_VERSION
end

-- This function attempts to detect the winner based on the status for forts
-- If no forts are found, 0 is returned, if more than one fort is found, -1 is returned
function findWinnerUsingForts()
    local winners = 0

    local forts = Entities:FindAllByClassname('npc_dota_fort')
    for k,v in pairs(forts) do
        -- Check it's HP level
        if v:GetHealth() > 0 then
            local team = v:GetTeam()

            if winners == 0 then
                winners = team
            else
                winners = -1
            end
        end
    end

    -- Return our estimate
    return winners
end

-- Auto hook sending stats
local states = {}
local autoSent = false
ListenToGameEvent('game_rules_state_change', function(keys)
    local state = GameRules:State_Get()

    -- Add to our states
    table.insert(states, {
        state = state,
        time = Time()
    })

    -- Update our stats
    addStats({
        states = states
    })

    -- Check if the game is over
    if autoSendStats and state >= DOTA_GAMERULES_STATE_POST_GAME and not autoSent then
        -- We have now auto sent stats
        autoSent = true

        -- Send the stats
        sendStats()
    end
end, nil)

-- Store player names
ListenToGameEvent('player_connect', function(keys)
    -- Grab their steamID
    local steamID64 = tostring(keys.xuid)
    local steamIDPart = tonumber(steamID64:sub(4))
    if not steamIDPart then return end
    local steamID = tostring(steamIDPart - 61197960265728)

    -- Store their name
    storedNames[steamID] = keys.name
end, nil)

-- Hook winner function
local oldSetGameWinner = GameRules.SetGameWinner
GameRules.SetGameWinner = function(gameRules, team)
    -- Store the stats
    addStats({
        winner = team
    }, true)

    -- Run the rael setGameWinner function
    oldSetGameWinner(gameRules, team)

    -- Report stats if the user wants us to
    if autoSendStats and not autoSent then
        -- We have now auto sent stats
        autoSent = true

        -- Send the stats
        sendStats()
    end
end
