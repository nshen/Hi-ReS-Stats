/**
 * Stats in Flixel game engine :)
 * 
 * Stats.as
 * http://github.com/mrdoob/stats.as
 * 
 * Flixel
 * https://github.com/AdamAtomic/flixel
 *
 * How to use:
 * 
 * in subclass of FlxStats use :
 * this.add(new FlxStats());
 **/
package net.hires.debug
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class FlxStats extends FlxObject
	{
		//Stats
		protected const WIDTH : uint = 70;
		protected const HEIGHT : uint = 100;
		protected var xml : XML;
		protected var text : TextField; 
		protected var style : StyleSheet; 
		protected var timer : uint;
		protected var fps : uint;
		protected var ms : uint;
		protected var ms_prev : uint;
		protected var mem : Number;
		protected var mem_max : Number;
		
		protected var graph : BitmapData; 
		protected var rectangle : Rectangle;
		
		protected var fps_graph : uint;
		protected var mem_graph : uint;
		protected var mem_max_graph : uint;
		
		protected var colors : Colors = new Colors();
		//-----------------------------------
		 
		protected var statsSprite:Sprite = new Sprite()
			
		public function FlxStats()
		{
			super()
			 
			this.scrollFactor.x = this.scrollFactor.y = 0
				
			mem_max = 0;
			
			xml = <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>;
			
			style = new StyleSheet();
			style.setStyle('xml', {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
			style.setStyle('fps', {color: hex2css(colors.fps)});
			style.setStyle('ms', {color: hex2css(colors.ms)});
			style.setStyle('mem', {color: hex2css(colors.mem)});
			style.setStyle('memMax', {color: hex2css(colors.memmax)});
			
			text = new TextField();
			text.width = WIDTH;
			text.height = 50;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			
			rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - 50);	
			
			init();
			
		}
		
		private function init() : void {
			
			statsSprite.graphics.beginFill(colors.bg);
			statsSprite.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			statsSprite.graphics.endFill();
			
			statsSprite.addChild(text);
			
			graph = new BitmapData(WIDTH, HEIGHT - 50, false, colors.bg);
			statsSprite.graphics.beginBitmapFill(graph, new Matrix(1, 0, 0, 1, 0, 50));
			statsSprite.graphics.drawRect(0, 50, WIDTH, HEIGHT - 50);
			
	
		}
		
		
		
		override public function destroy():void
		{			
			statsSprite.graphics.clear();			
			while(statsSprite.numChildren > 0)
				statsSprite.removeChildAt(0);						
			graph.dispose();		
			statsSprite= null
			super.destroy();
		}
		
		
		override public function update():void
		{
			super.update()
			 
			timer = getTimer();
			
			if( timer - 1000 > ms_prev ) {
				
				ms_prev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;
				
				fps_graph = Math.min(graph.height, ( fps / FlxG.framerate ) * graph.height);
				mem_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
				mem_max_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem_max * 5000))) - 2;
				
				graph.scroll(-1, 0);
				
				graph.fillRect(rectangle, colors.bg);
				graph.setPixel(graph.width - 1, graph.height - fps_graph, colors.fps);
				graph.setPixel(graph.width - 1, graph.height - ( ( timer - ms ) >> 1 ), colors.ms);
				graph.setPixel(graph.width - 1, graph.height - mem_graph, colors.mem);
				graph.setPixel(graph.width - 1, graph.height - mem_max_graph, colors.memmax);
				
				xml.fps = "FPS: " + fps + " / " + FlxG.framerate; 
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;			
				
				fps = 0;
				
			}
			
			fps++;
			
			xml.ms = "MS: " + (timer - ms);
			ms = timer;
			
			text.htmlText = xml;
		}

		override public function render():void
		{
			super.render()
			 var b:BitmapData = new BitmapData(WIDTH,HEIGHT,false)
			 b.draw(this.statsSprite)
			FlxG.buffer.copyPixels(b, new Rectangle(0,0,WIDTH,HEIGHT) ,this._flashPoint, null, null, true);
		}
		
		// .. Utils
		
		private function hex2css( color : int ) : String {
			
			return "#" + color.toString(16);
			
		}
	}
}

class Colors {
	
	public var bg : uint = 0x000033;
	public var fps : uint = 0xffff00;
	public var ms : uint = 0x00ff00;
	public var mem : uint = 0x00ffff;
	public var memmax : uint = 0xff0070;
	
}