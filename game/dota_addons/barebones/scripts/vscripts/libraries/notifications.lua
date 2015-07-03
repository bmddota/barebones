NOTIFICATIONS_VERSION = "0.87"

--[[
  Sample Panorama Notifications Library by BMD

  Installation
  -"require" this function inside your code in order to gain access to the Notifications class for sending notifications to players, teams, or all clients.
  -Additionally, ensure that you have the barebones_hud_base.xml, barebones_hud_base.js, and barebones_hud_base.css files in your panorama content folder.

  Usage
  -Notifications can be sent to the Top or Bottom notification panel of an individual player, a whole team, or all clients at once.
  -Notifications can be sent in pieces consisting of Labels, Images, HeroImages, and AbilityImages.
  -Notifications are specified by a table which has 4 potential parameters:
    -duration: The duration to display the notification for on screen.  Ignored for a notification which "continues" a previous notification line.
    -class: An optional (leave as nil for default) string which will be used as the class to add to the notification piece.
    -style: An optional (leave as nil for default) table of css properties to add to this notification, such as {["font-size"]="60px", color="green"}.
    -continue: An optional (leave as nil for false) boolean which tells the notification system to add this notification to the current notification line if 'true'.  
      This lets you place multiple individual notification pieces on the same overall notification.
  -For Labels, there is one additional mandatory parameter:
    -text:  The text to display in the notification.  Can provide localization tokens ("#addonname") or non-localized text.
  -For HeroImages, there is two additional parameters:
    -hero:  (Mandatory) The hero name, e.g. "npc_dota_hero_axe".
    -imagestyle:  (Optional)  The image style to display for this hero image.  Default when 'nil' is 'icon'.  'portrait' and 'landscape' are two other options.
  -For AboilityImages, there is one additional mandatory parameter:
    -ability:  The ability name, e.g. "lina_fiery_soul".
  -For Images, there is one additional mandatory parameter:
    -image:  The image src string, e.g. "file://{images}/status_icons/dota_generic.psd".
  -For ItemImages, there is one additional mandatory parameter:
    -item:  The item name, e.g. "item_force_staff".

  -Call the Notifications:Top, Notifications:TopToAll, or Notifications:TopToTeam to send a top-area notification to the appropriate players 
  -Call the Notifications:Bottom, Notifications:BottomToAll, or Notifications:BottomToTeam to send a bottom-area notifications to the appropriate players 
  
  Examples:

  -- Send a notification to all players that displays up top for 5 seconds
  Notifications:TopToAll({text="Top Notification for 5 seconds ", duration=5.0})
  -- Send a notification to playerID 0 which will display up top for 9 seconds and be green, on the same line as the previous notification
  Notifications:Top(0, {text="GREEEENNNN", duration=9, style={color="green"}, continue=true})

  -- Display 3 styles of hero icons on the same line for 5 seconds.
  Notifications:TopToAll({hero="npc_dota_hero_axe", duration=5.0})
  Notifications:TopToAll({hero="npc_dota_hero_axe", imagestyle="landscape", continue=true})
  Notifications:TopToAll({hero="npc_dota_hero_axe", imagestyle="portrait", continue=true})

  -- Display a generic image and then 2 ability icons and 1 item icon on the same line for 5 seconds
  Notifications:TopToAll({image="file://{images}/status_icons/dota_generic.psd", duration=5.0})
  Notifications:TopToAll({ability="nyx_assassin_mana_burn", continue=true})
  Notifications:TopToAll({ability="lina_fiery_soul", continue=true})
  Notifications:TopToAll({item="item_force_staff", continue=true})


  -- Send a notification to all players on radiant (GOODGUYS) that displays near the bottom of the screen for 10 seconds to be displayed with the NotificationMessage class added
  Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="AAAAAAAAAAAAAA", duration=10, class="NotificationMessage"})
  -- Send a notification to player 0 which will display near the bottom a large red notification with a solid blue border for 5 seconds
  Notifications:Bottom(PlayerResource:GetPlayer(0), {text="Super Size Red", duration=5, style={color="red", ["font-size"]="110px", border="10px solid blue"}})



]]

if Notifications == nil then
  Notifications = class({})
end

function Notifications:Top(player, table)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end

  if table.text ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.hero ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.image ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.ability ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.item ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  else
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  end
end

function Notifications:TopToAll(table)
  if table.text ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("top_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.hero ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("top_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.image ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("top_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.ability ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("top_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.item ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("top_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  else
    CustomGameEventManager:Send_ServerToAllClients("top_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  end
end

function Notifications:TopToTeam(team, table)
  if table.text ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.hero ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.image ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.ability ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.item ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  else
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  end
end


function Notifications:Bottom(player, table)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end

  if table.text ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.hero ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.image ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.ability ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.item ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  else
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  end
end

function Notifications:BottomToAll(table)
  if table.text ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.hero ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.image ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.ability ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.item ~= nil then
    CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  else
    CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  end
end

function Notifications:BottomToTeam(team, table)
  if table.text ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.hero ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.image ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.ability ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  elseif table.item ~= nil then
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  else
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
  end
end