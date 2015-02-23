package {
	import flash.display.MovieClip;

	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	public class CustomUI extends MovieClip{
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		public var screenWidth:int;
		
		//constructor, you usually will use onLoaded() instead
		public function CustomUI() : void {
	
		}
		
		//this function is called when the UI is loaded
		public function onLoaded() : void {		
			//make this UI visible
			visible = true;
			
			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);

			// BMD player_say event.
			var oldChatSay:Function = globals.Loader_hud_chat.movieClip.gameAPI.ChatSay;
			globals.Loader_hud_chat.movieClip.gameAPI.ChatSay = function(obj:Object, bool:Boolean) {
				var type:int = globals.Loader_hud_chat.movieClip.m_nLastMessageMode
				if (bool)
					type = 4
				
				gameAPI.SendServerCommand( "player_say " + type + " " + obj.toString());
				oldChatSay(obj, bool);
			};

			//this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
			trace("Custom UI loaded!");
		}
		
		
		//this handles the resizes - credits to Nullscope & Perry
		public function onResize(re:ResizeManager) : * {
			
			// calculate by what ratio the stage is scaling
			var scaleRatioY:Number = re.ScreenHeight/900;
					
			if (re.ScreenHeight > 900) {
				scaleRatioY = 1;
			}
					
			screenWidth = re.ScreenWidth;
					
			//pass the resize event to our module, we pass the width and height of the screen, as well as the INVERSE of the stage scaling ratios.
		}
	}
}