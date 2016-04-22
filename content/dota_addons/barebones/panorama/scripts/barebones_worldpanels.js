var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
var subscription = null; 

const HA_CENTER = 0;
const HA_LEFT   = 1; 
const HA_RIGHT  = 2; 
const VA_BOTTOM = 0; 
const VA_CENTER = 1; 
const VA_TOP    = 2; 


$.Msg("barebones_worldpanels.js");
var panels = {};
var entities = [];
//{panel, position, entity, offsetX, offsetY, hAlign, vAlign, entityHeight, edge}

// panel deletion call?
// Delete call to server for cleanup

function WorldPanelChange(id, changes, dels)
{
  //$.Msg("change ", id, ' -- ', changes, ' -- ', dels);
  for (var k in changes){
    var wp = panels[k];
    if (!wp){
      wp = {};
      panels[k] = wp;
    }

    if (changes[k].layout !== wp.layout){
      if (wp.panel)
        wp.panel.DeleteAsync(0);

      wp.panel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
      wp.panel.BLoadLayout(changes[k].layout, false, false);
      wp.panel.WorldPanel = wp;
      wp.panel.OnEdge = false;
      wp.panel.OffScreen = false;
      wp.panel.Data = wp.data;
      wp.panel.DeleteWorldPanel = function(pan){ 
        return function(){
          pan.DeleteAsync(0);
          delete panels[k];
        }
      }(wp.panel);

    }

    for (j in changes[k]){
      if (j == "position"){
        wp[j] = changes[k][j].split(' ');
        wp[j] = [parseFloat(wp[j][0]), parseFloat(wp[j][1]), parseFloat(wp[j][2])]
      }
      else if (j == "data"){
        wp.panel.Data = changes[k][j];
        wp[j] = changes[k][j];
      }
      else
        wp[j] = changes[k][j];
    }
    
    //wp.dirty = true;
    wp.offsetX = wp.offsetX || 0;
    wp.offsetY = wp.offsetY || 0;
    wp.entityHeight = wp.entityHeight || 0;
    wp.hAlign = wp.hAlign || HA_CENTER;
    wp.vAlign = wp.vAlign || VA_BOTTOM;
    wp.edge = wp.edge || -1;
    wp.seen = wp.entity ? Entities.IsValidEntity(wp.entity) : null;

  }

  for (var k in dels){
    panels[k].panel.DeleteAsync(0);
    delete panels[k];
  }
}

function PositionPanels()
{
  //$.Msg(Object.keys(panels).length);
  for (var k in panels){
    var wp = panels[k];
    var pos = wp.position;
    if (!pos){
      if (!Entities.IsValidEntity(wp.entity)){
        if (wp.seen){
          panels[k].panel.DeleteAsync(0);
          delete panels[k];
          continue;
        }
        else{
          continue;
        }
      }


      wp.seen = true;

      pos = Entities.GetAbsOrigin(wp.entity);
      if (entities.indexOf(wp.entity) === -1){
        wp.panel.visible = false;
        continue;
      }
      wp.panel.visible = true;

      pos[2] += wp.entityHeight || 0;
    }
 
    var wx = Game.WorldToScreenX(pos[0], pos[1], pos[2]);
    var wy = Game.WorldToScreenY(pos[0], pos[1], pos[2]);
    var sw = GameUI.CustomUIConfig().screenwidth;
    var sh = GameUI.CustomUIConfig().screenheight;
    var scale = 1080 / sh;

    var x = scale * wx + wp.offsetX;
    wx = wx + wp.offsetX
    var y = scale * wy + wp.offsetY;
    wy = wy + wp.offsetY

    var pw = wp.panel.actuallayoutwidth;
    var ph = wp.panel.actuallayoutheight;

    switch(wp.hAlign){
      case HA_LEFT:
        break;
      case HA_RIGHT:
        x-= pw;
        break;
      case HA_CENTER:
      default:
        x-= pw/2;
        break;
    };
    switch(wp.vAlign){
      case VA_TOP:
        break;
      case VA_CENTER:
        y-= ph/2;
        break;
      case VA_BOTTOM:
      default:
        y-= ph;
        break;
    };

    if (wp.edge !== -1){
      var padx = sw * wp.edge / 100;
      var pady = sh * wp.edge / 100;

      var oldx = x;
      var oldy = y;

      x = Math.max(padx,Math.min((sw-pw-padx)*scale, x));
      y = Math.max(pady,Math.min((sh-ph-pady)*scale, y));

      //$.Msg(oldx, ' -- ', oldy, '          ', wx, ' -- ', wy, '          ', x, ' -- ', y)

      if (x !== oldx || y !== oldy){
        wp.panel.OnEdge = true;

        var center =  Game.ScreenXYToWorld(sw/2, sh/2)
        var center2 = GameUI.GetScreenWorldPosition(sw/2, sh/2 + 1)
        if (center && center2){
          var diff = [center2[0]-center[0], center2[1]-center[1]]
          var diff2 = [pos[0]-center[0], pos[1]-center[1]]

          var ang = Math.atan2(diff2[1], diff2[0]) - Math.atan2(diff[1], diff[0]) - Math.PI/2
          x = Math.cos(ang)
          y = -1*Math.sin(ang)
          var xscale = ((sw-2*padx)/2 / x)
          var yscale = ((sh-2*pady)/2 / y)
          var minscale = Math.min(Math.abs(xscale), Math.abs(yscale));
          x = x * minscale + sw/2
          y = y * minscale + sh/2

          x = x - pw * (x/(sw-pw));
          y = y - ph * (y/(sh-ph));

          x *= scale;
          y *= scale;

          x = x.toFixed(1)
          y = y.toFixed(1)

        }
        else{
          x = NaN;
          y = NaN;
        }
        
      }
      else
        wp.panel.OnEdge = false;

    }
    else{
      if (x < pw || x > sw || y < ph || y > sh)
        wp.panel.OffScreen = true;
      else
        wp.panel.OffScreen = false;
    }

    if (!isFinite(x) || isNaN(x) || !isFinite(y) || isNaN(y))
    {
      x = -1000;
      y = -1000;
      wp.panel.visible = false;
    }
    else
    {
      wp.panel.visible = true;  
    }

    
    wp.panel.style.position = x + "px " + y + "px 0px;";

    //$.Msg(k, ' -- ', pw, ' -- ', ph);
    //var x = scale * Math.min(sw - panel.desiredlayoutwidth,Math.max(0, wx - panel.desiredlayoutwidth/2));
    //var y = scale * Math.min(sh - panel.desiredlayoutheight,Math.max(0, wy - panel.desiredlayoutheight - 50));
  }

  $.Schedule(1/200, PositionPanels);
}

function ScreenHeightWidth()
{
  var panel = $.GetContextPanel();

  GameUI.CustomUIConfig().screenwidth = panel.actuallayoutwidth;
  GameUI.CustomUIConfig().screenheight = panel.actuallayoutheight;  

  $.Schedule(1/2, ScreenHeightWidth);
}

function UpdateEntities()
{
  if (Object.keys(panels).length > 0)
    entities = Entities.GetAllEntities();

  $.Schedule(1/10, UpdateEntities);
}

(function()
{ 
  var pt = "worldpanels_" +  Game.GetLocalPlayerID()
  ScreenHeightWidth(); 
  PositionPanels();
  UpdateEntities();

  entities = Entities.GetAllEntities();

  if ($.GetContextPanel().subscription !== undefined){
    PlayerTables.UnsubscribeNetTableListener($.GetContextPanel().subscription);
  }

  subscription = PlayerTables.SubscribeNetTableListener(pt, WorldPanelChange);

  var tab = PlayerTables.GetAllTableValues(pt);
  for (var k in tab){
    var change = {};
    change[k] = tab[k];
    WorldPanelChange(pt, change, {}); 
  } 

  $.GetContextPanel().subscription = subscription;
})();