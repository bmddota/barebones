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