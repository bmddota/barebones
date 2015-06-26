--[[
  Sample Panorama Notifications Library by BMD

  Installation
  -"require" this function inside your code in order to gain access to the Notifications class for sending notifications to players, teams, or all clients.
  -Additionally, ensure that you have the barebones_hud_base.xml, barebones_hud_base.js, and barebones_hud_base.css files in your panorama content folder.

  Usage
  -Notifications can be sent to the Top or Bottom notification panel of an individual player, a whole team, or all clients at once.
  -Notifications are specified by 4 potential parameters:
    -text:  The text to display in the notification.  Can provide localization tokens ("#addonname") or non-localized text.
    -duration: The duration to display the notification for on screen.
    -class: An optional (leave as nil for default) string which will be used as the class to add to the notification Label.
    -style: An optional (leave as nil for default) table of css properties to add to this notification, such as {["font-size"]="60px", color="green"}.
  -Call the Notifications:Top, Notifications:TopToAll, or Notifications:TopToTeam to send a top-area notifications to the appropriate players 
  -Call the Notifications:Bottom, Notifications:BottomToAll, or Notifications:BottomToTeam to send a bottom-area notifications to the appropriate players 
  
  Examples:

  -- Send a notification to all players that displays up top for 5 seconds
  Notifications:TopToAll("Top Notification for 5 seconds", 5.0)

  -- Send a notification to all players on radiant (GOODGUYS) that displays near the bottom of the screen for 10 seconds to be displayed with the NotificationMessage class added
  Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, "AAAAAAAAAAAAAA", 10, "NotificationMessage")

  -- Send a notification to playerID 0 which will display up top for 9 seconds and be green
  Notifications:Top(0, "GREEEENNNN", 9, nil, {color="green"})

  -- Send a notification to player 0 which will display near the bottom a large red notification with a solid blue border for 5 seconds
  Notifications:Bottom(PlayerResource:GetPlayer(0), "Super Size Red", 5, nil, {color="red", ["font-size"]="110px", border="10px solid blue"})

]]

if Notifications == nil then
  Notifications = class({})
end

function Notifications:Top(player, text, duration, class, style)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end
  CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text=text, duration=duration, class=class, style=style} )
end

function Notifications:TopToAll(text, duration, class, style)
  CustomGameEventManager:Send_ServerToAllClients( "top_notification", {text=text, duration=duration, class=class, style=style} )
end

function Notifications:TopToTeam(team, text, duration, class, style)
  CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {text=text, duration=duration, class=class, style=style} )
end

function Notifications:Bottom(player, text, duration, class, style)
  if type(player) == "number" then
    player = PlayerResource:GetPlayer(player)
  end
  CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {text=text, duration=duration, class=class, style=style} )
end

function Notifications:BottomToAll(text, duration, class, style)
    CustomGameEventManager:Send_ServerToAllClients( "bottom_notification", {text=text, duration=duration, class=class, style=style} )
end

function Notifications:BottomToTeam(team, text, duration, class, style)
  CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {text=text, duration=duration, class=class, style=style} )
end