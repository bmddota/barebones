--[[
  Sample Panorama Notifications Library by BMD

  Installation
  -"require" this function inside your code in order to gain access to the Notifications class for sending notifications to players, teams, or all clients.
  -Additionally, ensure that you have the barebones_hud_base.xml, barebones_hud_base.js, and barebones_hud_base.css files in your panorama content folder.

  Usage
  -Notifications can be sent to the Top or Bottom notification panel of an individual player, a whole team, or all clients at once.
  -Notifications can be sent in pieces consisting of Labels and HeroImages.
  -Both types of notifications have 4 potential parameters:
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
  -Call the Notifications:Top, Notifications:TopToAll, or Notifications:TopToTeam to send a top-area notifications to the appropriate players 
  -Call the Notifications:TopHeroImage, Notifications:TopHeroImageToAll, or Notifications:TopHeroImageToTeam to send a top-area heroimage notifications to the appropriate players 
  -Call the Notifications:Bottom, Notifications:BottomToAll, or Notifications:BottomToTeam to send a bottom-area notifications to the appropriate players 
  -Call the Notifications:BottomHeroImage, Notifications:BottomHeroImageToAll, or Notifications:BottomHeroImageToTeam to send a top-area heroimage notifications to the appropriate players 

  --Notifications can be given in function parameter form or as a table of values
  
  Examples:

  -- Send a notification to all players that displays up top for 5 seconds
  Notifications:TopToAll("Top Notification for 5 seconds", 5.0)

  -- Send a notification to all players on radiant (GOODGUYS) that displays near the bottom of the screen for 10 seconds to be displayed with the NotificationMessage class added
  Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, "AAAAAAAAAAAAAA", 10, "NotificationMessage")

  -- Table-based version of the above:
  Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="AAAAAAAAAAAAAA", duration=10, class="NotificationMessage"})

  -- Send a notification to playerID 0 which will display up top for 9 seconds and be green
  Notifications:Top(0, "GREEEENNNN", 9, nil, {color="green"})

  -- Send a notification to player 0 which will display near the bottom a large red notification with a solid blue border for 5 seconds
  Notifications:Bottom(PlayerResource:GetPlayer(0), "Super Size Red", 5, nil, {color="red", ["font-size"]="110px", border="10px solid blue"})

  -- Table-based version of the above:
  Notifications:Bottom(PlayerResource:GetPlayer(0), 
    {text="Super Size Red", duration=5, style={color="red", ["font-size"]="110px", border="10px solid blue"}}
  )

  -- Send a 4-part notification consisting of a HeroImage icon, a small text piece, a large localized text piece, and a HeroImage portrait
  Notifications:TopHeroImage(PlayerResource:GetPlayer(0), "npc_dota_hero_axe", nil, 30, nil, {width="64px", height="64px"}, false)
  Notifications:Top(PlayerResource:GetPlayer(0), "1234 ASDF FAFF ", 3, nil, {["font-size"]="72px"}, true)
  Notifications:Top(PlayerResource:GetPlayer(0), " asdf !@#$", 3, nil, {["font-size"]="42px", color="red"}, true)
  Notifications:TopHeroImage(PlayerResource:GetPlayer(0), "npc_dota_hero_axe", "portrait", 30, nil, nil, true)

]]

if Notifications == nil then
  Notifications = class({})
end

function Notifications:Top(player, text, duration, class, style, continue)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end

  if type(text) == "table" then
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text=text.text, duration=text.duration, class=text.class, style=text.style, continue=text.continue} )
  else
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text=text, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:TopToAll(text, duration, class, style)
  if type(text) == "table" then
    CustomGameEventManager:Send_ServerToAllClients( "top_notification", {text=text.text, duration=text.duration, class=text.class, style=text.style, continue=text.continue} )
  else
    CustomGameEventManager:Send_ServerToAllClients( "top_notification", {text=text, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:TopToTeam(team, text, duration, class, style)
  if type(text) == "table" then
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {text=text.text, duration=text.duration, class=text.class, style=text.style, continue=text.continue} )
  else
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {text=text, duration=duration, class=class, style=style, continue=continue} )
  end
end


function Notifications:TopHeroImage(player, hero, imagestyle, duration, class, style, continue)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end

  if type(hero) == "table" then
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification_heroimage", {hero=hero.hero, imagestyle=hero.imagestyle, duration=hero.duration, class=hero.class, style=hero.style, continue=hero.continue} )
  else
    CustomGameEventManager:Send_ServerToPlayer(player, "top_notification_heroimage", {hero=hero, imagestyle=imagestyle, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:TopHeroImageToAll(hero, imagestyle, duration, class, style)
  if type(hero) == "table" then
    CustomGameEventManager:Send_ServerToAllClients( "top_notification_heroimage", {hero=hero.hero, imagestyle=hero.imagestyle, duration=hero.duration, class=hero.class, style=hero.style, continue=hero.continue} )
  else
    CustomGameEventManager:Send_ServerToAllClients( "top_notification_heroimage", {hero=hero, imagestyle=imagestyle, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:TopHeroImageToTeam(team, hero, imagestyle,  duration, class, style)
  if type(hero) == "table" then
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification_heroimage", {hero=hero.hero, imagestyle=hero.imagestyle, duration=hero.duration, class=hero.class, style=hero.style, continue=hero.continue} )
  else
    CustomGameEventManager:Send_ServerToTeam(team, "top_notification_heroimage", {hero=hero, imagestyle=imagestyle, duration=duration, class=class, style=style, continue=continue} )
  end
end





function Notifications:Bottom(player, text, duration, class, style, continue)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end

  if type(text) == "table" then
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {text=text.text, duration=text.duration, class=text.class, style=text.style, continue=text.continue} )
  else
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {text=text, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:BottomToAll(text, duration, class, style, continue)
  if type(text) == "table" then
    CustomGameEventManager:Send_ServerToAllClients( "bottom_notification", {text=text.text, duration=text.duration, class=text.class, style=text.style, continue=text.continue} )
  else
    CustomGameEventManager:Send_ServerToAllClients( "bottom_notification", {text=text, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:BottomToTeam(team, text, duration, class, style, continue)
  if type(text) == "table" then
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {text=text.text, duration=text.duration, class=text.class, style=text.style, continue=text.continue} )
  else
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {text=text, duration=duration, class=class, style=style, continue=continue} )
  end
end


function Notifications:BottomHeroImage(player, hero, imagestyle, duration, class, style, continue)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end

  if type(hero) == "table" then
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification_heroimage", {hero=hero.hero, imagestyle=hero.imagestyle, duration=hero.duration, class=hero.class, style=hero.style, continue=hero.continue} )
  else
    CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification_heroimage", {hero=hero, imagestyle=imagestyle, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:BottomHeroImageToAll(hero, imagestyle, duration, class, style)
  if type(hero) == "table" then
    CustomGameEventManager:Send_ServerToAllClients( "bottom_notification_heroimage", {hero=hero.hero, imagestyle=hero.imagestyle, duration=hero.duration, class=hero.class, style=hero.style, continue=hero.continue} )
  else
    CustomGameEventManager:Send_ServerToAllClients( "bottom_notification_heroimage", {hero=hero, imagestyle=imagestyle, duration=duration, class=class, style=style, continue=continue} )
  end
end

function Notifications:BottomHeroImageToTeam(team, hero, imagestyle,  duration, class, style)
  if type(hero) == "table" then
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification_heroimage", {hero=hero.hero, imagestyle=hero.imagestyle, duration=hero.duration, class=hero.class, style=hero.style, continue=hero.continue} )
  else
    CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification_heroimage", {hero=hero, imagestyle=imagestyle, duration=duration, class=class, style=style, continue=continue} )
  end
end