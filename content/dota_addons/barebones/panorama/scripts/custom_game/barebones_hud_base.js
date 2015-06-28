function TopNotification( msg ) {
  AddNotification(msg, $('#TopNotifications'));
}

function BottomNotification(msg) {
  AddNotification(msg, $('#BottomNotifications'));
}

function TopNotificationHeroImage( msg ) {
  AddNotificationHeroImage(msg, $('#TopNotifications'));
}

function BottomNotificationHeroImage(msg) {
  AddNotificationHeroImage(msg, $('#BottomNotifications'));
}

function AddNotification(msg, panel) {
  var newNotification = true;
  var lastNotification = panel.GetChild(panel.GetChildCount() - 1)
  $.Msg(msg)

  msg.continue = msg.continue || false;
  //msg.continue = true;

  if (lastNotification != null && msg.continue) 
    newNotification = false;

  if (newNotification){
    lastNotification = $.CreatePanel('Panel', panel, '');
    lastNotification.AddClass('NotificationLine')
    lastNotification.hittest = false;
  }

  var notification = $.CreatePanel('Label', lastNotification, '');

  if (typeof(msg.duration) != "number"){
    $.Msg("[Notifications] Notification Duration is not a number!");
    msg.duration = 3
  }
  
  if (newNotification){
    $.Schedule(msg.duration, function(){
      $.Msg('callback')
      lastNotification.DeleteAsync(0);
    });
  }

  notification.html = true;
  var text = msg.text || "No Text provided";
  notification.text = $.Localize(text)
  notification.hittest = false;
  notification.AddClass('TitleText');
  if (msg.class)
    notification.AddClass(msg.class);
  else
    notification.AddClass('NotificationMessage');

  if (msg.style){
    for (var key in msg.style){
      var value = msg.style[key]
      notification.style[key] = value;
    }
  }
}

function AddNotificationHeroImage(msg, panel) {
  var newNotification = true;
  $.Msg(msg)
  var lastNotification = panel.GetChild(panel.GetChildCount() - 1)
  msg.continue = msg.continue || false;
  //msg.continue = true;

  if (lastNotification != null && msg.continue) 
    newNotification = false;

  if (newNotification){
    lastNotification = $.CreatePanel('Panel', panel, '');
    lastNotification.AddClass('NotificationLine')
    lastNotification.hittest = false;
  }

  var notification = $.CreatePanel('DOTAHeroImage', lastNotification, '');

  if (typeof(msg.duration) != "number"){
    $.Msg("[Notifications] Notification Duration is not a number!");
    msg.duration = 3
  }
  
  if (newNotification){
    $.Schedule(msg.duration, function(){
      $.Msg('callback')
      lastNotification.DeleteAsync(0);
    });
  }

  notification.heroimagestyle = msg.imagestyle || "icon";
  notification.heroname = msg.hero
  notification.hittest = false;
  
  if (msg.class)
    notification.AddClass(msg.class);
  else
    notification.AddClass('HeroImage');

  if (msg.style){
    for (var key in msg.style){
      var value = msg.style[key]
      notification.style[key] = value;
    }
  }
}


(function () {
  GameEvents.Subscribe( "top_notification", TopNotification );
  GameEvents.Subscribe( "top_notification_heroimage", TopNotificationHeroImage );
  GameEvents.Subscribe( "bottom_notification", BottomNotification );
  GameEvents.Subscribe( "bottom_notification_heroimage", BottomNotificationHeroImage );
})();


