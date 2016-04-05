var Containers = GameUI.CustomUIConfig().Containers;

// Events can be registered in any javascript file you have through GameUI.CustomUIConfig().Containers
// Events should return true to allow for any additional built-in effects to occur
// This includes sending an event to the server and triggering server/lua actions

Containers.RegisterEventHandler("ExampleLeftClick", function(evt){
  $.Msg("ExampleLeftClick CALLBACK ACTION in JS");
  $.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","itemID","slot","containerPanel","itemPanel"]
  return true;
});

Containers.RegisterEventHandler("ExampleRightClick", function(evt){
  $.Msg("RIGHT CLICK CALLBACK ACTION in JS");
  $.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","itemID","slot","containerPanel","itemPanel"]
  return true;
});

Containers.RegisterEventHandler("ExampleDoubleClick", function(evt){
  $.Msg("ExampleDoubleClick CALLBACK ACTION in JS");
  $.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","itemID","slot","containerPanel","itemPanel","leftClick"]
  return true;
});

Containers.RegisterEventHandler("ExampleMouseOver", function(evt){
  $.Msg("ExampleMouseOver CALLBACK ACTION in JS");
  $.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","itemID","slot","containerPanel","itemPanel"]
  return false;
});

Containers.RegisterEventHandler("ExampleMouseOut", function(evt){
  $.Msg("ExampleMouseOut CALLBACK ACTION in JS");
  $.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","itemID","slot","containerPanel","itemPanel"]
  return true;
});

Containers.RegisterEventHandler("ExampleCloseClicked", function(evt){
  $.Msg("ExampleCloseClicked CALLBACK ACTION in JS");
  $.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","containerPanel"]
  return true;
});

Containers.RegisterEventHandler("ExampleButtonPressed", function(evt){
  $.Msg("ExampleButtonPressed CALLBACK ACTION in JS");
  $.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","containerPanel","itemPanel","buttonID","buttonName"]
  return true;
});






Containers.RegisterEventHandler("DefaultContextMenu", function(evt){
  //$.Msg(Object.keys(evt));                      //[   PanoramaScript         ]: ["unit","containerID","itemID","slot","containerPanel","itemPanel"]

  var m_Item = evt.itemID;
  $.DispatchEvent( "DOTAHideAbilityTooltip", evt.itemPanel );

  var bControllable = Entities.IsControllableByPlayer( evt.unit, Game.GetLocalPlayerID() );
  var bSellable = Items.IsSellable( m_Item ) && Items.CanBeSoldByLocalPlayer( m_Item );
  var bDisassemble = Items.IsDisassemblable( m_Item ) && bControllable;
  var bAlertable = Items.IsAlertableItem( m_Item ); 
  var bShowInShop = Items.IsPurchasable( m_Item );

  if (!bSellable && !bDisassemble && !bShowInShop && !bAlertable && !bMoveToStash )
  {
    return true;
  }

  var contextMenu = $.CreatePanel( "ContextMenuScript", evt.itemPanel, "" );
  contextMenu.AddClass( "ContextMenu_NoArrow" );
  contextMenu.AddClass( "ContextMenu_NoBorder" );
  contextMenu.GetContentsPanel().Item = m_Item;
  contextMenu.GetContentsPanel().SetHasClass( "bSellable", bSellable );
  contextMenu.GetContentsPanel().SetHasClass( "bDisassemble", bDisassemble );
  contextMenu.GetContentsPanel().SetHasClass( "bShowInShop", bShowInShop );
  contextMenu.GetContentsPanel().SetHasClass( "bAlertable", bAlertable );
  contextMenu.GetContentsPanel().SetHasClass( "bMoveToStash", false ); // TODO
  contextMenu.GetContentsPanel().BLoadLayout( "file://{resources}/layout/custom_game/containers/inventory_context_menu.xml", false, false );

  return true;
});



Containers.RegisterEventHandler("SpecialContextMenu", function(evt){
  $.DispatchEvent( "DOTAHideAbilityTooltip", evt.itemPanel );

  var noMenu = ["item_blade_mail", "item_chainmail", "item_helm_of_iron_will", "item_veil_of_discord",
                "item_boots", "item_phase_boots"]


  var m_Item = evt.itemID;
  

  var bControllable = Entities.IsControllableByPlayer( evt.unit, Game.GetLocalPlayerID() );
  var bSellable = Items.IsSellable( m_Item ) && Items.CanBeSoldByLocalPlayer( m_Item );
  var bDisassemble = Items.IsDisassemblable( m_Item ) && bControllable;
  var bAlertable = Items.IsAlertableItem( m_Item ); 
  var bShowInShop = Items.IsPurchasable( m_Item );
  var name = Abilities.GetAbilityName(m_Item);

  if (noMenu.indexOf(name) >= 0 || (!bSellable && !bDisassemble && !bShowInShop && !bAlertable && !bMoveToStash ))
  {
    return true;
  }

  var contextMenu = $.CreatePanel( "ContextMenuScript", evt.itemPanel, "" );
  contextMenu.AddClass( "ContextMenu_NoArrow" );
  contextMenu.AddClass( "ContextMenu_NoBorder" );
  contextMenu.GetContentsPanel().Item = m_Item;
  contextMenu.GetContentsPanel().Slot = evt.slot;
  contextMenu.GetContentsPanel().Container = evt.containerID;
  contextMenu.GetContentsPanel().SetHasClass( "bSellable", bSellable );
  contextMenu.GetContentsPanel().SetHasClass( "bDisassemble", bDisassemble );
  contextMenu.GetContentsPanel().SetHasClass( "bShowInShop", bShowInShop );
  contextMenu.GetContentsPanel().SetHasClass( "bAlertable", bAlertable );
  contextMenu.GetContentsPanel().SetHasClass( "bMoveToStash", false ); // TODO
  contextMenu.GetContentsPanel().BLoadLayout( "file://{resources}/layout/custom_game/containers/inventory_context_menu.xml", false, false );

  return true;
});