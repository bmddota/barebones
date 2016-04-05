"use strict";

function DismissMenu()
{
	$.DispatchEvent( "DismissAllContextMenus" )
}

function OnSell()
{
	Items.LocalPlayerSellItem( $.GetContextPanel().Item );

	GameEvents.SendCustomGameEventToServer( "Containers_OnSell", {unit:Players.GetLocalPlayerPortraitUnit(), 
		contID:$.GetContextPanel().Container, 
		itemID:$.GetContextPanel().Item, 
		slot:$.GetContextPanel().Slot
	});

	DismissMenu();
}

function OnDisassemble()
{
	Items.LocalPlayerDisassembleItem( $.GetContextPanel().Item );
	DismissMenu();
}

function OnShowInShop()
{
	var itemName = Abilities.GetAbilityName( $.GetContextPanel().Item );
	
	var itemClickedEvent = {
		"link": ( "dota.item." + itemName ),
		"shop": 0,
		"recipe": 0
	};
	GameEvents.SendEventClientSide( "dota_link_clicked", itemClickedEvent );
	DismissMenu();
}

function OnDropFromStash()
{
	Items.LocalPlayerDropItemFromStash( $.GetContextPanel().Item );
	DismissMenu();
}

function OnMoveToStash()
{
	Items.LocalPlayerMoveItemToStash( $.GetContextPanel().Item );
	DismissMenu();
}

function OnAlert()
{
	Items.LocalPlayerItemAlertAllies( $.GetContextPanel().Item );
	DismissMenu();
}
