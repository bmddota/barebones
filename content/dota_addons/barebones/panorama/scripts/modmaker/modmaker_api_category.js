var loaded = false;
var name = null;
var cat = null;
var properties = null;

var propertyPanels = {}

var showing = false;

function Show()
{
  showing = true;
  $("#PlusMinus").text = "-";
  $("#Properties").visible = true;
  if (!loaded){
    // load properties
    var panel = $("#Properties");


    for (var i in properties){
      var s = properties[i];
      var prop = cat[s];
      var propertyPanel = $.CreatePanel( "Panel", panel, s);
      propertyPanel.BLoadLayout("file://{resources}/layout/custom_game/modmaker/modmaker_api_property.xml", false, false);
      propertyPanels[s] = propertyPanel;
      propertyPanel.New(s, prop);
    }
    loaded = true;
  }
}

function Hide()
{
  showing = false;
  $("#PlusMinus").text = "+";
  $("#Properties").visible = false;
}

function Clicked()
{
  if (showing)
    Hide();
  else
    Show();
}

function Filter(search, clear)
{
  $.GetContextPanel().visible = true;
  if (clear){
    Hide();
    for (var prop in propertyPanels){
      var panel = propertyPanels[prop];
      panel.Show();
    }
    return;
  }

  if (search.test(name)){
    Show();
  }
  else{
    var show = {};
    for (var prop in properties){
      var p = properties[prop]
      if (search.test(p) || search.test(cat[p].d) || search.test(cat[p].f)){
        show[p] = true;
      }
    }

    if (Object.keys(show).length !== 0){
      Show();

      for (var prop in properties){
        var p = properties[prop]
        if (show[p])
          propertyPanels[p].Show();
        else
          propertyPanels[p].Hide();
      }
    }
    else{
      $.GetContextPanel().visible = false;
    } 
  }

}

function New(n, t, p)
{
  $("#PlusMinus").text = "+";
  $("#CategoryName").text = n;
  
  name = n;
  cat = t;
  properties = p;
}


(function(){
  $.GetContextPanel().Show = Show;
  $.GetContextPanel().Hide = Hide;
  $.GetContextPanel().New = New;
  $.GetContextPanel().Filter = Filter;

  $("#Properties").visible = false;
})();