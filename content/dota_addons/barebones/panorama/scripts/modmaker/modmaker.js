var files = {}
var lua = null;
var luaCategories = null;
var properties = {}
var categoryPanels = {}

function DumpObjectIndented(obj, indent)
{
  var result = "";
  if (indent == null) indent = "";

  for (var property in obj)
  {
    var value = obj[property];
    if (typeof value == 'string')
      value = "'" + value + "'";
    else if (typeof value == 'object')
    {
      if (value instanceof Array)
      {
        // Just let JS convert the Array to a string!
        value = "[ " + value + " ]";
      }
      else
      {
        // Recursive dump
        // (replace "  " by "\t" or something else if you prefer)
        var od = DumpObjectIndented(value, indent + "  ");
        // If you like { on the same line as the key
        //value = "{\n" + od + "\n" + indent + "}";
        // If you prefer { and } to be aligned
        value = "\n" + indent + "{\n" + od + "\n" + indent + "}";
      }
    }
    result += indent + "'" + property + "' : " + value + ",\n";
  }
  return result.replace(/,\n$/, "");
}

//var a = DumpObjectIndented(this).split('\n')
//for (var i=0; i<a.length; i++)
  //$.Msg(a[i]);

function LuaAPI(msg)
{
  if (!msg.api){
    $("#APIWindow").visible = !$("#APIWindow").visible;
    return;
  }
  lua = msg.api;
  luaCategories = Object.keys(lua).sort();
  for (var i in luaCategories){
    var s = luaCategories[i];
    if (s == "__GLOBAL__"){
      break;
    }
  }

  luaCategories.splice(i, 1);
  luaCategories.unshift(s);

  var panel = $("#API");
  panel.RemoveAndDeleteChildren();

  for (var i in luaCategories){
    var s = luaCategories[i];
    var cat = lua[s];
    var categoryPanel = $.CreatePanel( "Panel", panel, s);
    categoryPanel.BLoadLayout("file://{resources}/layout/custom_game/modmaker/modmaker_api_category.xml", false, false);
    categoryPanels[s] = categoryPanel;

    properties[s] = Object.keys(cat).sort();

    if (s == "__GLOBAL__")
      categoryPanel.New("GLOBAL", cat, properties[s]);
    else
      categoryPanel.New(s, cat, properties[s]);
    //label.SetAcceptsFocus(true);
  }

  $("#APIWindow").visible = true;
}

function SearchAPI()
{
  $.Msg("SearchAPI ", $("#Search").text);
  var text = $("#Search").text;
  //text = "(" + text.replace(/^\s+/g, "").replace(/\s+$/g, "").replace(/\s+/g, ")|(") + ")";
  var search = new RegExp(text, 'gi');

  for (var category in categoryPanels)
  {
    categoryPanels[category].Filter(search, $("#Search").text == "");
  }
}

function SendFile(msg)
{
  /*$.Msg("Test: name=", msg.name, " -- m=", msg.max, ' -- c=', msg.count);
  var s = ""
  var total = 0;
  for (var i in msg.t){
    $.Msg(i, ' ', msg.t[i].length);
    total += msg.t[i].length;
    s += msg.t[i];
  }  

  files[msg.name] = files[msg.name] || "";
  files[msg.name] += s;

  $.Msg(total);

  if (msg.max == msg.count){
    var panel = $("#FileWindow");
    panel.RemoveAndDeleteChildren();

    var a = files[msg.name].split("\n");
    for (i in a){
      //break;
      //$.Msg(a[i]);
      //label.BLoadLayoutFromString('<root><Panel><Label class="FileLine" text="' + a[i] + '" selectionpos="auto"/></Panel></root>', false, false)
      var label = $.CreatePanel( "Label", panel, "test");
      label.AddClass("FileLine");
      label.text = a[i];
      label.SetAcceptsFocus(true);
      $.Msg(Object.keys(label).toString().replace(/,/g, "\n"));
      $.Msg(label.inputnamespace);
      break;
    }

    //var label = $.CreatePanel( "Label", panel, "");
    //label.AddClass("FileLine");
    //label.style.width = "100%";
    //label.style.height = "fit-children";
    //$.Msg(Object.keys(label));
    //label.text = files[msg.name];
  }*/

  var panel = $("#FileWindow");
  panel.RemoveAndDeleteChildren();

  var keys = Object.keys(msg.t).sort();
  for (var i in keys){
    var s = keys[i];
    //$.Msg(i);
    var t = msg.t[s];
    var label = $.CreatePanel( "Label", panel, "test");
    label.AddClass("FileLine");
    label.text = s;
    label.SetAcceptsFocus(true);

    //$.Msg(t);

    var keys2 = Object.keys(t).sort();
    for (j in keys2){
      var s2 = keys2[j];
      label = $.CreatePanel( "Label", panel, "test");
      label.AddClass("FileLine");
      label.text = '        ' + s2 + ':';
      label.SetAcceptsFocus(true);

      label = $.CreatePanel( "Label", panel, "test");
      label.AddClass("FileLine");
      label.text = '                ' + t[s2].f;
      label.SetAcceptsFocus(true);

      label = $.CreatePanel( "Label", panel, "test");
      label.AddClass("FileLine");
      label.text = '                ' + t[s2].d + '\n';
      label.SetAcceptsFocus(true);
    }

    label = $.CreatePanel( "Label", panel, "test");
    label.AddClass("FileLine");
    label.text = '\n';
    label.SetAcceptsFocus(true);
  }
}


function CloseClicked()
{
  $("#APIWindow").visible = false;
}

(function(){
  GameEvents.Subscribe( "modmaker_lua_api", LuaAPI);
  GameEvents.Subscribe( "modmaker_send_file", SendFile);

  var api = $("#APIWindow");
  var close = $("#CloseButton");
})();