"use strict";

var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
var containers = {};
var eventHandlers = {};
var lastUnit = null;

/*var fun = function(tableName, changes, delete)
{
  $.Msg("fun callback -- ", tableName, " -- " , changes); 
};*/

$.Msg("[containers_base.js] Loaded");

function DisableFocus(panel)
{
  panel.SetDisableFocusOnMouseDown(true);
  //panel.SetAcceptsFocus(false);
  
  for (var i=0; i<panel.GetChildCount(); i++){
    DisableFocus(panel.GetChild(i));
  }
}

function OpenContainer(msg)
{
  //$.Msg("OpenContainer -- ", msg);
  var panel = $.GetContextPanel();
  var id = msg.id; 
  var containerPanel = containers[id];



  if (!containerPanel){
    var idString = "cont_" + id;
    var layoutFile = PlayerTables.GetTableValue(idString, "layoutFile") || "file://{resources}/layout/custom_game/containers/container.xml";

    containerPanel = $.CreatePanel( "Panel", panel, "" );
    containerPanel.BLoadLayout(layoutFile, false, false);
    containers[id] = containerPanel;

    containerPanel.NewContainer(id);


    DisableFocus(panel);
  }
  else{
    containerPanel.OpenContainer();
  }
}

function CloseContainer(msg)
{
  //$.Msg("CloseContainer -- ", msg);
  var id = msg.id;
  var containerPanel = containers[id];

  if (containerPanel){
    containerPanel.CloseContainer();
  }
  else{
    $.Msg("[container_base.js] Close container for id '" + id + "' unable to find existing container.");
  }
}

function DeleteContainer(msg)
{
 //$.Msg("DeleteContainer -- ", msg); 
 var id = msg.id;
 var containerPanel = containers[id];
 if (containerPanel){
  containerPanel.DeleteContainer();
  containerPanel.DeleteAsync(1);
  delete containers[id];
 }
 else{
  //$.Msg("[container_base.js] Delete container for id '" + id + "' unable to find existing container.")
 } 
}
 

function ExecuteProxy(msg)
{
  //$.Msg("ExecuteProxy");
  var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer());
  var abil = Entities.GetAbilityByName( localHeroIndex , "containers_lua_targeting" );
  if (abil === -1)
     abil = Entities.GetAbilityByName( localHeroIndex , "containers_lua_targeting_tree" );
  
  if (abil !== -1){
    Abilities.ExecuteAbility( abil, localHeroIndex, false );

    var fun = function(){
      var behaviors = GameUI.GetClickBehaviors();
      if (behaviors != CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_CAST){
        GameEvents.SendCustomGameEventToServer( "Containers_HideProxy", {abilID:abil} );
        return;
      }
      $.Schedule(1/60, fun);
    };

    $.Schedule(1/60, fun);    
  }
  else{
    $.Msg("'containers_lua_targeting' ability not found.");
  }
}

var EntityShops = {};
var lastSel = null; 

function CheckShop()
{
  var sel = Players.GetLocalPlayerPortraitUnit();
  if (sel !== lastSel){
    GameEvents.SendCustomGameEventToServer( "Containers_Select", {entity:sel} );
    lastSel = sel;
    //$.Msg("CheckShop ", sel, ' -- ', lastSel);
  }

  if (sel >= 1 && (Entities.IsCreepHero(sel) || Entities.IsRealHero(sel))) {
    var shop = 0;
    shop += Entities.IsInRangeOfShop( sel, 0, true) ? 1 : 0;
    shop += Entities.IsInRangeOfShop( sel, 1, true) ? 2 : 0;
    shop += Entities.IsInRangeOfShop( sel, 2, true) ? 4 : 0;

    var oldShop = EntityShops[sel];
    if (oldShop !== shop){
      GameEvents.SendCustomGameEventToServer( "Containers_EntityShopRange", {unit:sel, shop:shop} );
    }

    EntityShops[sel] = shop;
  }
}

function CheckShopSchedule()
{
  CheckShop();
  $.Schedule(1/10, CheckShopSchedule);
}

function CheckCouriers()
{
  var cours = Entities.GetAllEntitiesByClassname("npc_dota_courier");
  var info = Game.GetLocalPlayerInfo();

  for (var i=0; i<cours.length; i++){
    var cour = cours[i];
    if (info.player_team_id == Entities.GetTeamNumber(cour)){

      var shop = 0;
      shop += Entities.IsInRangeOfShop( cour, 0, true) ? 1 : 0;
      shop += Entities.IsInRangeOfShop( cour, 1, true) ? 2 : 0; 
      shop += Entities.IsInRangeOfShop( cour, 2, true) ? 4 : 0;

      var oldShop = EntityShops[cour];
      if (oldShop !== shop){
        GameEvents.SendCustomGameEventToServer( "Containers_EntityShopRange", {unit:cour, shop:shop} );
      }

      EntityShops[cour] = shop;
    }
  }

  $.Schedule(1/10, CheckCouriers);
}

function CreateErrorMessage(msg)
{
  var reason = msg.reason || 80;
  if (msg.message){
    GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":reason ,"message":msg.message} );
  }
  else{
    GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":reason} );
  }
}

function EmitClientSound(msg)
{
  if (msg.sound){
    Game.EmitSound(msg.sound);
  }
}

function UsePanoramaInventory(msg)
{
  var use = msg.use;
  var panInv = $("#PanoramaInventory");
  if (use === 0){
    panInv.visible = false;
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, true );
  }
  else{
    panInv.visible = true;
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, false );
  }
}

function ScreenHeightWidth()
{
  var panel = $.GetContextPanel();

  GameUI.CustomUIConfig().screenwidth = panel.actuallayoutwidth;
  GameUI.CustomUIConfig().screenheight = panel.actuallayoutheight;

  $.Schedule(1/4, ScreenHeightWidth);
}

function RegisterEventHandler(name, func)
{
  eventHandlers[name] = func;
}

(function(){
  var panel = $.GetContextPanel();

  ScreenHeightWidth();

  //containerPanel = $.CreatePanel( "Panel", panel, "" );
  //containerPanel.BLoadLayout("file://{resources}/layout/custom_game/containers/container.xml", false, false);

  GameEvents.Subscribe( "cont_open_container", OpenContainer); 
  GameEvents.Subscribe( "cont_close_container", CloseContainer);
  GameEvents.Subscribe( "cont_delete_container", DeleteContainer);

  GameEvents.Subscribe( "cont_execute_proxy", ExecuteProxy);
  GameEvents.Subscribe( "cont_create_error_message", CreateErrorMessage);
  GameEvents.Subscribe( "cont_emit_client_sound", EmitClientSound);
  GameEvents.Subscribe( "cont_use_panorama_inventory", UsePanoramaInventory);

  GameEvents.Subscribe( "dota_player_update_selected_unit", CheckShop );
  GameEvents.Subscribe( "dota_player_update_query_unit", CheckShop );

  var use = CustomNetTables.GetTableValue( "containers_lua", "use_panorama_inventory" );
  if (use)
    UsePanoramaInventory({use:use.value});
  else
    UsePanoramaInventory({use:false});

  CheckShopSchedule();
  CheckCouriers();

  //$.Msg("container_base: ", panel); 

  if (panel.initialized){
    containers = panel.containers || {};
    for (var key in containers){
      containers[key].DeleteContainer();
      //containers[keys[key]].DeleteAsync(1);
      delete containers[key]; 
    }
    return;  
  }

  GameUI.CustomUIConfig().Containers = {}
  GameUI.CustomUIConfig().Containers.containers = containers;
  GameUI.CustomUIConfig().Containers.eventHandlers = eventHandlers;
  GameUI.CustomUIConfig().Containers.RegisterEventHandler = RegisterEventHandler;

  panel.containers = containers;
  panel.initialized = true; 
})()

