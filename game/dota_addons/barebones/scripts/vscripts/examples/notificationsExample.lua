-- Send a notification to all players that displays up top for 5 seconds
Notifications:TopToAll("Top Notification for 5 seconds", 5.0)
-- Send a notification to all players on radiant (GOODGUYS) that displays near the bottom of the screen for 10 seconds to be displayed with the NotificationMessage class added
Notifications:BottomToTeam(DOTA_TEAM_GOODGUYS, "AAAAAAAAAAAAAA", 10, "NotificationMessage")

-- Send a notification to playerID 0 which will display up top for 9 seconds and be green
Notifications:Top(0, "GREEEENNNN", 9, nil, {color="green"})

-- Send a notification to player 0 which will display near the bottom a large red notification with a solid blue border for 5 seconds
Notifications:Bottom(PlayerResource:GetPlayer(0), "Super Size Red", 5, nil, {color="red", ["font-size"]="110px", border="10px solid blue"})