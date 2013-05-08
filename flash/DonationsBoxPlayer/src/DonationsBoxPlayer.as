package
{
	import com.pnwrain.flashsocket.FlashSocket;
	import com.pnwrain.flashsocket.events.FlashSocketEvent;
	
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	[SWF(width=1080,height=480,backgroundColor=0xff0000)]
	public class DonationsBoxPlayer extends Sprite
	{
		public function DonationsBoxPlayer()
		{
			if(stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(evt:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//configure
			try{
				_videoDir = stage.loaderInfo.parameters["videoDir"] || "";
			}catch(err:Error){
			
			}
			
			trace(_videoDir);
			
			//create player
			_player = new FLVPlayback();
			addChild(_player);
			
			//make player full size
			_player.width = stage.stageWidth;
			_player.height = stage.stageHeight;
			
			_player.addEventListener("complete", function():void{
				trace("Ended");
				_player.visible = false;
				_player.play("null.mp4");
			});
			
			_player.addEventListener(VideoEvent.READY, function():void{
				trace("Started");
				_player.visible = true;
			});
			
			
			_player.visible = false;
			
			//connect the socket
			playVideo("video1");
			reconnect();
		}
		
		private function reconnect():void{
			if(_socket){
				//disconnect the old socket
				bindToSocketEvents(false);
			}
			
			_socket = new FlashSocket("scala-messager.jimib.co.uk");
			
			//reconnect the socket
			bindToSocketEvents();
		}
		
		private function playVideo(video:String):void{
			_player.visible = false;
			_player.play(_videoDir + video+".mp4");
		}
		
		private function bindToSocketEvents(boolBind:Boolean = true):void{
			var eventsSocket:Array = [
				FlashSocketEvent.CONNECT, 
				FlashSocketEvent.DISCONNECT,
				FlashSocketEvent.IO_ERROR,
				FlashSocketEvent.CONNECT_ERROR,
				FlashSocketEvent.CLOSE,
				FlashSocketEvent.MESSAGE
			];
			
			eventsSocket.forEach(function(evt:*, index:int, arr:Array):void{
				if(boolBind){
					_socket.addEventListener(evt, onSocketEventHandler);	
				}else{
					_socket.removeEventListener(evt, onSocketEventHandler);
				}
			});
			
			var eventsScreen:Array = ["play"];
			
			eventsScreen.forEach(function(evt:*, index:int, arr:Array):void{
				if(boolBind){
					_socket.addEventListener(evt, onScreenEventHandler);	
				}else{
					_socket.removeEventListener(evt, onScreenEventHandler);
				}
			});
			
		}
		
		private function onSocketEventHandler(evt:FlashSocketEvent):void{
			switch(evt.type){
				case FlashSocketEvent.CONNECT:
					//create the game on the server
					trace("READY!");
					break;
				case FlashSocketEvent.DISCONNECT:
					setTimeout(reconnect, 10000);
					break;
				case FlashSocketEvent.IO_ERROR:
					setTimeout(reconnect, 10000);
					break;
				case FlashSocketEvent.CONNECT_ERROR:
					setTimeout(reconnect, 10000);
					break;
				case FlashSocketEvent.CLOSE:
					setTimeout(reconnect, 10000);
					break;
				case FlashSocketEvent.MESSAGE:
					
					break;
				default:
					trace("unhandled onSocketEventHandler '"+evt+"'");
					break;
			}
		}
		
		private function onScreenEventHandler(evt:FlashSocketEvent):void{
			switch(evt.type){
				case "play":
					//what were we asked to play
					try{
						playVideo(evt.data[0].srcVideo);
					}catch(err:Error){
						trace("Error playing video");
					}
				break;	
			}
		}
		
		private var _videoDir:String = "";
		private var _player:FLVPlayback;
		private var _socket:FlashSocket;
	}
}