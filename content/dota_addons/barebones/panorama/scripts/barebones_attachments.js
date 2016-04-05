var lastUnit = null;
var activated = false;
var showing = false;
var pmscale = 1;

function OnDragStart( panelId, dragCallbacks )
{
  var panel = $('#' + panelId);
  var toDragId = panel.toDragId;

  //$.Msg('OnDragStart -- ', toDragId, ' -- ', panelId, ' -- ', dragCallbacks);
  // hook up the display panel, and specify the panel offset from the cursor
  /*$.Msg('#' + panelId);
  var p = $('#' + panelId);
  $.Msg(p);
  $.Msg($.GetContextPanel());

  if (panel === null && $('#' + panelId))
    panel = $('#' + panelId); */

  panel = $('#' + toDragId);

  dragCallbacks.displayPanel = panel;//panel;

  var cursor = GameUI.GetCursorPosition();

  dragCallbacks.offsetX = cursor[0] - panel.actualxoffset;//250;
  dragCallbacks.offsetY = cursor[1] - panel.actualyoffset;//20;
  dragCallbacks.removePositionBeforeDrop = false;
  return false;
} 

function OnDragEnd( panelId, draggedPanel )
{
  //$.Msg('OnDragEnd -- ', panelId, ' -- ', draggedPanel);
  draggedPanel.SetParent($.GetContextPanel());
  return false;
}

function ValueChange(panel, amount)
{
  //$.Msg(panel)
  var panel = $(panel);
  var defText = panel.GetChild(0);
  if (defText !== null && defText !== undefined){
    defText = defText.text;
    defText = parseFloat(defText);
  }
  else{
    defText = 0.0;
  }

  var text = panel.text;
  if (text === "")
    text = defText;
  else
    text = parseFloat(text);

  if (text === NaN)
    text = defText;

  text += amount * pmscale;
  if (panel.id == "Scale")
    panel.text = text.toFixed(2);
  else
    panel.text = text.toFixed(1);

  UpdateAttachment();
}

function GetAttachmentTable()
{
  var table = {};
  table['model'] = $('#Model').text;
  table['attach'] =$('#Attach').text;
  table['scale'] = parseFloat($('#Scale').text) || 1.0;
  table['pitch'] = parseFloat($('#Pitch').text) || 0.0;
  table['yaw'] =   parseFloat($('#Yaw').text) || 0.0;
  table['roll'] =  parseFloat($('#Roll').text) || 0.0;
  table['XPos'] =  parseFloat($('#XPos').text) || 0.0;
  table['YPos'] =  parseFloat($('#YPos').text) || 0.0;
  table['ZPos'] =  parseFloat($('#ZPos').text) || 0.0;

  return table;
}

function UpdateAttachment(a)
{
  //$.Msg("UpdateAttachment ");
  var table = GetAttachmentTable();

  GameEvents.SendCustomGameEventToServer( "Attachment_UpdateAttach", {index: lastUnit, properties:table} );
  
}

function Freeze()
{
  //$.Msg("Freeze");

  var panel = $('#Freeze');
  var label = panel.GetChild(0);
  var text = label.text;
  if (text === "Freeze")
  {
    label.text = "Unfreeze";
    label.style.color = "#ffaaaa";
    GameEvents.SendCustomGameEventToServer( "Attachment_Freeze", {index: lastUnit, freeze:true} );
  }
  else
  {
    label.text = "Freeze";
    label.style.color = "#aaaaff";
    GameEvents.SendCustomGameEventToServer( "Attachment_Freeze", {index: lastUnit, freeze:false} )
  }
}

function Save()
{
  var table = GetAttachmentTable();
  GameEvents.SendCustomGameEventToServer( "Attachment_SaveAttach", {index: lastUnit, properties:table} )
}

function Load()
{
  var table = GetAttachmentTable();
  GameEvents.SendCustomGameEventToServer( "Attachment_LoadAttach", {index: lastUnit, properties:table} )
}

function Hide()
{
  var table = GetAttachmentTable();
  GameEvents.SendCustomGameEventToServer( "Attachment_HideAttach", {index: lastUnit, properties:table} )
}

function AttachCheckbox()
{
  var panel = $('#AttachCheckbox');
  var table = GetAttachmentTable();
  GameEvents.SendCustomGameEventToServer( "Attachment_DoAttach", {index: lastUnit, properties:table, doAttach: panel.checked} )
}

function SphereCheckbox()
{
  var panel = $('#SphereCheckbox');
  var table = GetAttachmentTable();
  GameEvents.SendCustomGameEventToServer( "Attachment_DoSphere", {index: lastUnit, properties:table, doSphere: panel.checked} )
}

function HideCosmetics()
{
  var panel = $('#CosmeticsPanel');
  if (panel.visible)
    panel.visible = false;
  else
    panel.visible = true;
}

function CloseCosmetics()
{
  var panel = $('#CosmeticsPanel');
  panel.visible = false;
}

function TopCamera()
{
  GameUI.SetCameraPitchMax( 90 );
  GameUI.SetCameraPitchMin( 90 );
  GameUI.SetCameraYaw( 0 );
}

function SideXCamera()
{
  GameUI.SetCameraPitchMax( 1 );
  GameUI.SetCameraPitchMin( 1 );
  GameUI.SetCameraYaw( 0 );
}

function SideYCamera()
{
  GameUI.SetCameraPitchMax( 1 );
  GameUI.SetCameraPitchMin( 1 );
  GameUI.SetCameraYaw( 90 );
}

function NormalCamera()
{
  GameUI.SetCameraPitchMax( 60 );
  GameUI.SetCameraPitchMin( 38 );
  GameUI.SetCameraYaw( 0 );
}

function SelectUnitUpdated()
{
  //$.Msg('SelectUnitUpdated ', lastUnit, ' -- ', Players.GetLocalPlayerPortraitUnit());

  var newUnit = Players.GetLocalPlayerPortraitUnit();
 
  if (newUnit !== lastUnit)
  {
    $.Msg("new");
    GameEvents.SendCustomGameEventToServer( "Attachment_UpdateUnit", {index: newUnit} );
  } 

  lastUnit = newUnit;
}

function PlusMinusScale()
{
  $.Msg("PlusMinusScale");
  var dropdown = $("#PlusMinusScale");
  pmscale = parseFloat(dropdown.GetSelected().text);
}

function CosmeticListUpdated(msg)
{
  //$.Msg("CosmeticListUpdated ", msg);

  // Remove old children
  var panel = $('#CosmeticsBody');
  for (i=0;i<panel.GetChildCount(); i++){
    var lastPanel = panel.GetChild(i);
    lastPanel.DeleteAsync(0);
  }

  for (var key in msg){
    var row = $.CreatePanel('Panel', panel, '');
    row.AddClass('CosmeticRow');

    var label = $.CreatePanel('Label', row, '');
    label.AddClass('CosmeticLabel');
    label.text = msg[key];

    var button = $.CreatePanel('Button', row, '');
    button.AddClass('CosmeticButton');
    button.AddClass('SplashButton');
    button.SetPanelEvent('onactivate', (function(model){
      return function(){
        GameEvents.SendCustomGameEventToServer( "Attachment_HideCosmetic", {index: lastUnit, model: model} );
      };
    })(msg[key]));

    var buttonLabel = $.CreatePanel('Label', button, '');
    buttonLabel.text = "Toggle";
  }
  
}

function UpdateFields(msg)
{
  //$.Msg("UpdateFields ", msg);

  $('#Model').text = msg['model'] || "";
  $('#Attach').text = msg['attach'] || "";
  $('#Scale').text = msg['scale'].toFixed(2);
  $('#Pitch').text = msg['pitch'].toFixed(1);//table['pitch'] = parseFloat($('#Pitch').text) || 0.0;
  $('#Yaw').text = msg['yaw'].toFixed(1);//table['yaw'] =   parseFloat($('#Yaw').text) || 0.0;
  $('#Roll').text = msg['roll'].toFixed(1);//table['roll'] =  parseFloat($('#Roll').text) || 0.0;
  $('#XPos').text = msg['XPos'].toFixed(1);//table['XPos'] =  parseFloat($('#XPos').text) || 0.0;
  $('#YPos').text = msg['YPos'].toFixed(1);//table['YPos'] =  parseFloat($('#YPos').text) || 0.0;
  $('#ZPos').text = msg['ZPos'].toFixed(1);//table['ZPos'] =  parseFloat($('#ZPos').text) || 0.0;

  UpdateAttachment();
}

function ActivateAttachmentConfiguration(msg)
{
  if (showing){
    $("#AttachmentsPanel").visible = false;
    $("#CosmeticsPanel").visible = false;
    showing = false;
  }
  else{
    if (!activated){
      GameEvents.Subscribe( "dota_player_update_selected_unit", SelectUnitUpdated );

      GameEvents.Subscribe( "attachment_cosmetic_list", CosmeticListUpdated );
      GameEvents.Subscribe( "attachment_update_fields", UpdateFields ); 
      //GameUI.SetMouseCallback(HandleMouseEvent);

      activated = true; 
    }

    lastUnit = Players.GetLocalPlayerPortraitUnit();
    $("#PlusMinusScale").SetSelected($("#DD2"));
    if (lastUnit){
      GameEvents.SendCustomGameEventToServer( "Attachment_UpdateUnit", {index: lastUnit} );
    }
    $("#AttachmentsPanel").visible = true;
    showing = true;
  } 
}


var IsMouseControlledAngles = false;
var IsMouseControlledOffsets = false;
var lastMousePos;
var mouseUpdateInterval = 2.0;
function MouseControlAngles()
{
  if(IsMouseControlledAngles == false) {
    IsMouseControlledAngles = true;
    MouseControlAnglesLoop();
  }
  else {
    IsMouseControlledAngles = false;
  }
}

function MouseControlOffsets()
{
  if(IsMouseControlledOffsets == false) {
    IsMouseControlledOffsets = true;
    MouseControlOffsetsLoop();
  }
  else {
    IsMouseControlledOffsets = false;
  }
}

function MouseControlAnglesLoop()
{
  var mousePos = GameUI.GetCursorPosition();
  var difX = lastMousePos[0] - mousePos[0];
  var difY = lastMousePos[1] - mousePos[1];
  
  if(GameUI.IsMouseDown(0) == false) {
    var yaw = MouseCalc($('#Yaw'), difX, pmscale/8);
    var pitch = MouseCalc($('#Pitch'), difY, pmscale/8);
    var roll = MouseCalc($("#Roll"), g_MouseYaw, pmscale*10);

    $("#Yaw").text = yaw;
    $("#Pitch").text = pitch;
    $("#Roll").text = roll;
    UpdateAttachment();
  }

  g_MouseYaw = 0;
  lastMousePos = mousePos;
  if(IsMouseControlledAngles == true) {
    $.Schedule(1.0/mouseUpdateInterval, MouseControlAnglesLoop);
  }
}

function MouseCalc(panel, dif, scale)
{
  var num = parseFloat(panel.text);
  if(isNaN(num)) {
    panel.text = num.toString();
    num = 0;
  }
  var angle = num + (scale * dif);
  angle = Math.round(angle * 100) / 100;
  return angle.toString();
}

function MouseControlOffsetsLoop()
{
  var mousePos = GameUI.GetCursorPosition();
  var difX = mousePos[0] - lastMousePos[0];
  var difY = lastMousePos[1] - mousePos[1];
  
  if(GameUI.IsMouseDown(0) == false) {
    var x = MouseCalc($('#XPos'), difX, pmscale/8);
    var y = MouseCalc($('#YPos'), difY, pmscale/8);
    var z = MouseCalc($("#ZPos"), g_MouseYaw, pmscale*10);
    
    $('#XPos').text = x.toString();
    $('#YPos').text = y.toString();
    $('#ZPos').text = z.toString();
    
    if(IsMouseControlledAngles == false)
    {
      UpdateAttachment();
    }
  }
  
  if(IsMouseControlledAngles == false) {
    lastMousePos = mousePos;
    g_MouseYaw = 0;
  }
  if(IsMouseControlledOffsets == true)
  {
    $.Schedule(1.0/mouseUpdateInterval, MouseControlOffsetsLoop);
  }
}

function MouseUpdateScale()
{
  var dropdown = $("#MouseUpdateScale");
  mouseUpdateInterval = parseFloat(dropdown.GetSelected().text);
}

function ShowMouseHelpTooltip()
{
  $.DispatchEvent("DOTAShowTextTooltip", "Holding the left mouse button down disables updating. Scale affects the rate at which items are oriented or moved. Vertical mouse movement affects the Y offset and pitch. Horizontal mouse movement affects the  X offset and yaw. Mouse wheel movement affects the Z offset and roll.");
}

function HideMouseHelpTooltip()
{
  $.DispatchEvent("DOTAHideTextTooltip");
}

var g_MouseYaw = 0;

function HandleMouseEvent(eventName, arg)
{
  if ( eventName === "wheeled" ) {
    g_MouseYaw += arg * pmscale;
    if(IsMouseControlledAngles == true || IsMouseControlledOffsets == true) {
      return true;
    }
  }
  return false;
}

(function()
{ 
  lastMousePos = GameUI.GetCursorPosition();

  var panel = $("#AttachmentsPanel");
  $("#AttachmentsHeader").toDragId = "AttachmentsPanel";
  $("#CosmeticsHeader").toDragId = "CosmeticsPanel";
  $("#AttachCheckbox").checked = true; 
  $("#SphereCheckbox").checked = true; 

  GameEvents.Subscribe( "activate_attachment_configuration", ActivateAttachmentConfiguration );
 
  //$.Msg(panel.firstLoadDone);
  if (panel.firstLoadDone)
    return;

  panel.firstLoadDone = true;

  var options = [.1,.5,1,5,10,25]; 
  var dropdown = $("#PlusMinusScale");
  for (var i=0; i<options.length; i++){ 
    var label = $.CreatePanel('Label', dropdown, 'DD' + i);
    label.text = options[i];
    dropdown.AddOption(label); 
  } 

  dropdown.SetSelected("DD2");

  options = [2, 5, 10, 15, 20, 25, 30]; 
  dropdown = $("#MouseUpdateScale");
  for (var i=0; i<options.length; i++){ 
    var label = $.CreatePanel('Label', dropdown, 'mDD' + i);
    label.text = Math.ceil(options[i] * 100) / 100;
    dropdown.AddOption(label); 
  } 

  dropdown.SetSelected("mDD3");

  $.RegisterEventHandler( 'DragStart', $('#AttachmentsHeader'), OnDragStart );
  $.RegisterEventHandler( 'DragEnd', $('#AttachmentsHeader'), OnDragEnd );

  $.RegisterEventHandler( 'DragStart', $('#CosmeticsHeader'), OnDragStart );
  $.RegisterEventHandler( 'DragEnd', $('#CosmeticsHeader'), OnDragEnd );
  
})();