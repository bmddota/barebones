function TopNotification( msg ) {
  AddNotification(msg, $('#TopNotifications'));
}

function BottomNotification(msg) {
  AddNotification(msg, $('#BottomNotifications'));
}

function AddNotification(msg, panel) {

  $.Msg(msg)
  var notification = $.CreatePanel('Label', panel, '');

  if (typeof(msg.duration) != "number"){
    $.Msg("[Notifications] Notification Duration is not a number!");
    msg.duration = 3
  }
  
  $.Schedule(msg.duration, function(){
    $.Msg('callback')
    notification.DeleteAsync(0);
  });

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


(function () {
  GameEvents.Subscribe( "top_notification", TopNotification );
  GameEvents.Subscribe( "bottom_notification", BottomNotification );
})();


