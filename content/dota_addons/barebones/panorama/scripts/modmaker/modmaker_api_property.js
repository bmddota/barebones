var name = null;
var prop = null;

function Show()
{
  $.GetContextPanel().visible = true;
}

function Hide()
{
  $.GetContextPanel().visible = false;
}

function OpenGitHub()
{
  $.Msg("OpenGitHub");

  GameEvents.SendCustomGameEventToServer( "ModMaker_OpenGithub", {search:name, language:"lua"});
}

function FuncClicked()
{
  var panel = $.GetContextPanel();
  $("#PropertyFunction").visible = false;
  var textEntry = $.CreatePanel( "TextEntry", panel, "");
  panel.MoveChildBefore(textEntry, $("#PropertyDescription"));

  textEntry.text = $("#PropertyFunction").text
  textEntry.style.marginLeft = "40px;";
  textEntry.style.width = "700px";
  textEntry.SetPanelEvent('onblur', function(){
    $("#PropertyFunction").visible = true;
    textEntry.DeleteAsync(0);
  });

  textEntry.SetPanelEvent('oncancel', function(){
    $("#PropertyFunction").visible = true;
    textEntry.DeleteAsync(0);
  });
  textEntry.SelectAll();
  textEntry.SetFocus(true);
}


function New(n, p)
{
  $("#PropertyName").text = n;
  //$("#PropertyName").SetAcceptsFocus(true);
  $("#PropertyFunction").text = p.f;
  //$("#PropertyFunction").SetAcceptsFocus(true);
  $("#PropertyDescription").text = p.d;
  $("#PropertyDescription").SetAcceptsFocus(true);

  $("#PropertyDescription").visible = p.d !== "";
  name = n;
  prop = p;
}


(function(){
  $.GetContextPanel().Show = Show;
  $.GetContextPanel().Hide = Hide;
  $.GetContextPanel().New = New;
})();