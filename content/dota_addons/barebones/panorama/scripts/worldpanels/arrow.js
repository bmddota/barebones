$.Msg("arrow");

function ArrowCheck()
{
  var wp = $.GetContextPanel().WorldPanel
  var onEdge = $.GetContextPanel().OnEdge;

  if (wp){
    if (onEdge){
      var sw = GameUI.CustomUIConfig().screenwidth;
      var sh = GameUI.CustomUIConfig().screenheight;

      var ang = -1 * Math.atan2($.GetContextPanel().actualxoffset - sw/2, $.GetContextPanel().actualyoffset - sh/2) * 180 / Math.PI;

      //$.Msg($.GetContextPanel().actualxoffset, $.GetContextPanel().actualyoffset);
      $("#arrow").style.transform = "rotateZ(" + ang.toFixed(1) + "deg);"; // 
    }
    else{
      $("#arrow").style.transform = "rotateZ(0deg);"; // 
    }
  }

  $.Schedule(1/30, ArrowCheck);
}

(function()
{ 
  ArrowCheck();

})();