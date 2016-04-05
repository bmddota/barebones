"use strict";

var m_Item = -1;
var m_ItemSlot = -1;
var m_QueryUnit = -1;

function UpdateItem()
{
	var panel = $.GetContextPanel();
	var itemName = Abilities.GetAbilityName( m_Item );
	var hotkey = Abilities.GetKeybind( m_Item, m_QueryUnit );
	var isPassive = Abilities.IsPassive( m_Item );
	var chargeCount = 0;
	var hasCharges = false;
	var altChargeCount = 0; 
	var hasAltCharges = false;

	if (IsInStash()){
		panel = panel.GetParent();
	}else{
		panel = panel.GetParent().GetParent();
	}

	if (m_ItemSlot === 6 && panel.id === "stash_row"){
		var show = false;
		for (var i=6; i<12; i++){
			if (Entities.GetItemInSlot( m_QueryUnit, i ) !== -1){
				show = true;
				break;
			}
		}

		panel.visible = show;
	} 

	if (!panel.visible){
		$.Schedule( 0.1, UpdateItem );
		return;
	}
	
	if ( Items.ShowSecondaryCharges( m_Item ) )
	{
		// Ward stacks display charges differently depending on their toggle state
		hasCharges = true;
		hasAltCharges = true;
		if ( Abilities.GetToggleState( m_Item ) )
		{
			chargeCount = Items.GetCurrentCharges( m_Item );
			altChargeCount = Items.GetSecondaryCharges( m_Item );
		}
		else
		{
			altChargeCount = Items.GetCurrentCharges( m_Item );
			chargeCount = Items.GetSecondaryCharges( m_Item );
		}
	}
	else if ( Items.ShouldDisplayCharges( m_Item ) )
	{
		hasCharges = true;
		chargeCount = Items.GetCurrentCharges( m_Item );
	}

	$.GetContextPanel().SetHasClass( "no_item", (m_Item == -1) );
	$.GetContextPanel().SetHasClass( "show_charges", hasCharges );
	$.GetContextPanel().SetHasClass( "show_alt_charges", hasAltCharges );
	$.GetContextPanel().SetHasClass( "is_passive", isPassive );
	$.GetContextPanel().SetHasClass( "low_mana", ((m_QueryUnit !== -1) && Abilities.GetManaCost( m_Item ) > Entities.GetMana(m_QueryUnit)));

	//$.GetContextPanel().SetHasClass( "is_active", (Abilities.GetLocalPlayerActiveAbility() == m_Item));
	
	$( "#HotkeyText" ).text = hotkey;
	$( "#ItemImage" ).itemname = itemName;
	$( "#ItemImage" ).contextEntityIndex = m_Item;
	$( "#ChargeCount" ).text = chargeCount;
	$( "#AltChargeCount" ).text = altChargeCount;
	
	if ( m_Item == -1 || Abilities.IsCooldownReady( m_Item ) )
	{
		$.GetContextPanel().SetHasClass( "cooldown_ready", true );
		$.GetContextPanel().SetHasClass( "in_cooldown", false );
	}
	else
	{
		$.GetContextPanel().SetHasClass( "cooldown_ready", false );
		$.GetContextPanel().SetHasClass( "in_cooldown", true );
		var cooldownLength = Abilities.GetCooldownLength( m_Item );
		var cooldownRemaining = Abilities.GetCooldownTimeRemaining( m_Item );
		var cooldownPercent = Math.ceil( 100 * cooldownRemaining / cooldownLength );
		$( "#CooldownTimer" ).text = Math.ceil( cooldownRemaining );
		$( "#CooldownOverlay" ).style.width = cooldownPercent+"%";
	}
	
	$.Schedule( 0.1, UpdateItem );
}

function ItemShowTooltip()
{
	if ( m_Item == -1 )
		return;

	var itemName = Abilities.GetAbilityName( m_Item );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, m_QueryUnit );
}

function ItemHideTooltip()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
}

var lastClick = 1; // 1 right, 0 left

function ActivateItem()
{
	lastClick = 0;
	if ( m_Item == -1 )
		return;

	// Items are abilities - just execute the ability
	Abilities.ExecuteAbility( m_Item, m_QueryUnit, false );
}

function DoubleClickItem()
{
	if (lastClick === 0)
		ActivateItem();
}

var DOTA_ITEM_STASH_MIN = 6;

function IsInStash()
{
	return ( m_ItemSlot >= DOTA_ITEM_STASH_MIN );
}

function RightClickItem()
{
	lastClick = 1;
	ItemHideTooltip();

	var bSlotInStash = IsInStash();
	var bControllable = Entities.IsControllableByPlayer( m_QueryUnit, Game.GetLocalPlayerID() );
	var bSellable = Items.IsSellable( m_Item ) && Items.CanBeSoldByLocalPlayer( m_Item );
	var bDisassemble = Items.IsDisassemblable( m_Item ) && bControllable && !bSlotInStash;
	var bAlertable = Items.IsAlertableItem( m_Item );
	var bShowInShop = Items.IsPurchasable( m_Item );
	var bDropFromStash = bSlotInStash && bControllable;
	var bMoveToStash = Entities.IsInRangeOfShop(m_QueryUnit, 0, true);

	if ( !bSellable && !bDisassemble && !bShowInShop && !bDropFromStash && !bAlertable && !bMoveToStash )
	{
		// don't show a menu if there's nothing to do
		return;
	}

	var contextMenu = $.CreatePanel( "ContextMenuScript", $.GetContextPanel(), "" );
	contextMenu.AddClass( "ContextMenu_NoArrow" );
	contextMenu.AddClass( "ContextMenu_NoBorder" );
	contextMenu.GetContentsPanel().Item = m_Item;
	contextMenu.GetContentsPanel().SetHasClass( "bSellable", bSellable );
	contextMenu.GetContentsPanel().SetHasClass( "bDisassemble", bDisassemble );
	contextMenu.GetContentsPanel().SetHasClass( "bShowInShop", bShowInShop );
	contextMenu.GetContentsPanel().SetHasClass( "bDropFromStash", bDropFromStash );
	contextMenu.GetContentsPanel().SetHasClass( "bAlertable", bAlertable );
	contextMenu.GetContentsPanel().SetHasClass( "bMoveToStash", bMoveToStash ); // TODO
	contextMenu.GetContentsPanel().BLoadLayout( "file://{resources}/layout/custom_game/containers/dota_inventory_context_menu.xml", false, false );
}

function OnDragEnter( a, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;

	// only care about dragged items other than us
	if ( draggedItem === null || draggedItem == m_Item )
		return true;

	// highlight this panel as a drop target
	$.GetContextPanel().AddClass( "potential_drop_target" );
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;

	var dropTarget = $.GetContextPanel();
	$.GetContextPanel().RemoveClass( "potential_drop_target" );

	// executing a slot swap - don't drop on the world
	draggedPanel.m_DragCompleted = true;
	
	// item dropped on itself? don't acutally do the swap (but consider the drag completed)
	if ( draggedItem == m_Item )
		return true;

	var fromCont = draggedPanel.m_contID;

	if (fromCont == -1){
		// create the order
		var moveItemOrder =
		{
			OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_ITEM,
			TargetIndex: m_ItemSlot,
			AbilityIndex: draggedItem
		};
		Game.PrepareUnitOrders( moveItemOrder );
	}
	else{
		GameEvents.SendCustomGameEventToServer( "Containers_OnDragFrom", {unit:Players.GetLocalPlayerPortraitUnit(), contID:fromCont, itemID:draggedItem, 
			fromSlot:draggedPanel.m_OriginalPanel.GetSlot(), toContID:-1, toSlot:m_ItemSlot} );
	}

	return true;
}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	// un-highlight this panel
	$.GetContextPanel().RemoveClass( "potential_drop_target" );
	return true;
}

function OnDragStart( panelId, dragCallbacks )
{
	if ( m_Item == -1 )
	{
		return true;
	}

	var itemName = Abilities.GetAbilityName( m_Item );

	ItemHideTooltip(); // tooltip gets in the way

	// create a temp panel that will be dragged around
	var displayPanel = $.CreatePanel( "DOTAItemImage", $.GetContextPanel(), "dragImage" );
	displayPanel.itemname = itemName;
	displayPanel.contextEntityIndex = m_Item;
	displayPanel.m_DragItem = m_Item;
	displayPanel.m_contID = -1;
	displayPanel.m_DragCompleted = false; // whether the drag was successful
	displayPanel.m_OriginalPanel = $.GetContextPanel();
	displayPanel.m_QueryUnit = m_QueryUnit;

	// hook up the display panel, and specify the panel offset from the cursor
	dragCallbacks.displayPanel = displayPanel;
	dragCallbacks.offsetX = 0;
	dragCallbacks.offsetY = 0;
	
	// grey out the source panel while dragging
	$.GetContextPanel().AddClass( "dragging_from" );
	return true;
}

function OnDragEnd( panelId, draggedPanel )
{

	if (!IsInStash() && !draggedPanel.m_DragCompleted){
		var position = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
		var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
		var entity = null;

		if (mouseEntities.length !== 0){
			for ( var e of mouseEntities )
			{
				if ( e.accurateCollision ){
					entity = e.entityIndex;
					break;
				}
			}
		}
		GameEvents.SendCustomGameEventToServer( "Containers_OnDragWorld", {unit:Players.GetLocalPlayerPortraitUnit(), contID:-1, itemID:m_Item, slot:m_ItemSlot, position:position, entity:entity} );
	}

	// if the drag didn't already complete, then try dropping in the world
		//Game.DropItemAtCursor( m_QueryUnit, m_Item );

	// kill the display panel
	draggedPanel.DeleteAsync( 0 );

	// restore our look
	$.GetContextPanel().RemoveClass( "dragging_from" );
	return true;
}

function SetItemSlot( itemSlot )
{
	m_ItemSlot = itemSlot;
}

function SetItem( queryUnit, iItem )
{
	m_Item = iItem;
	m_QueryUnit = queryUnit;
}

function GetSlot()
{
	return m_ItemSlot;
}

(function()
{
	$.GetContextPanel().SetItem = SetItem;
	$.GetContextPanel().SetItemSlot = SetItemSlot;
	$.GetContextPanel().GetSlot = GetSlot;

	// Drag and drop handlers ( also requires 'draggable="true"' in your XML, or calling panel.SetDraggable(true) )
	$.RegisterEventHandler( 'DragEnter', $.GetContextPanel(), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $.GetContextPanel(), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $.GetContextPanel(), OnDragLeave );
	$.RegisterEventHandler( 'DragStart', $.GetContextPanel(), OnDragStart );
	$.RegisterEventHandler( 'DragEnd', $.GetContextPanel(), OnDragEnd );

	UpdateItem(); // initial update of dynamic state
})();
