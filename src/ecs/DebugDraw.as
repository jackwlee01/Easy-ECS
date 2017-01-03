/*
**   MIT License
** 
**   Copyright (c) 2017 Jack Lee
** 
**   Permission is hereby granted, free of charge, to any person obtaining a copy
**   of this software and associated documentation files (the "Software"), to deal
**   in the Software without restriction, including without limitation the rights
**   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
**   copies of the Software, and to permit persons to whom the Software is
**   furnished to do so, subject to the following conditions:
** 
**   The above copyright notice and this permission notice shall be included in all
**   copies or substantial portions of the Software.
** 
**   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
**   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
**   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
**   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
**   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
**   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
**   SOFTWARE.
*/


package ecs {
	
	import flash.display.Graphics;
	import flash.display.Sprite;

	
	public class DebugDraw extends System{

		public var graphics:Graphics;
			

		public function init():DebugDraw{
			var debugSprite:Sprite = new Sprite();
			this.graphics = debugSprite.graphics;
			Globals.instance.nativeRoot.addChild(debugSprite);

			debugSprite.scaleX = Globals.instance.resolution;
			debugSprite.scaleY = Globals.instance.resolution;
			
			return this;
		}
		
		
		override public function newFrame():void{
			graphics.clear();
		}
		
		
		/*
		public function drawPath(path:PathSegment){
			var TEMP_VEC_1:Vector2 = Vector2Pool.__GET__(); 	// GET VECTOR2
			var totalLength = path.head.lengthGoingForward;
			
			for(var i:Number = path.head.segmentStartDistance; i < totalLength; i += 5){
				path.positionAtDistance(i, TEMP_VEC_1);
				graphics.drawCircle(TEMP_VEC_1.x, TEMP_VEC_1.y, 0.5);
			}
			
			Vector2Pool.__RELEASE__(TEMP_VEC_1); 				// RELEASE VECTOR2
		}
		
		
		
		public function drawAngle(angle:Number, position:Vector2, length:Number){
			var TEMP_VEC1:Vector2 = Vector2Pool.__GET__();			// GET VECTOR2
			
			var endOffset:Vector2 = TEMP_VEC1;
			endOffset.x = length;
			endOffset.y = 0;
			endOffset.angle = angle;
			
			graphics.moveTo(position.x, position.y);
			graphics.lineTo(position.x + endOffset.x, position.y + endOffset.y);
			
			Vector2Pool.__RELEASE__(TEMP_VEC1);						// RELEASE VECTOR2
		}
		
		
		
		private function getArcAlpha(arc:Arc):Number{
			var s:Number = 200;
			var alpha:Number = arc.radius;
			if(alpha > s) alpha = s;
			alpha = s - alpha;
			alpha /= s;
			return alpha;
		}
		
		
		
		public function drawArcNode(arcNode:ArcNode):void{
			var TEMP_VEC:Vector2 = Vector2Pool.__GET__();							// GET VECTOR2
			var pos:Vector2;
			var tail:ArcNode = arcNode.tail;
			var len:Number = tail.startDistance;
			if(tail.arc.length >= tail.arc.circumference){
				len += tail.arc.circumference;
			}else{
				len += tail.arc.length;
			}
			
			var stepSize:Number =  (len-arcNode.startDistance)/120

			
			graphics.lineStyle(1, 0xffffff, 0.1);
			pos = arcNode.positionAtDistance(arcNode.startDistance, TEMP_VEC);
			graphics.moveTo(pos.x, pos.y);
			graphics.lineStyle(1, 0xffffff, 0.1);
			
			for(var i:Number = arcNode.startDistance; i < len; i += stepSize){
				var alphaValue:Number =  0.2 * (1-((i-arcNode.startDistance) / (len-arcNode.startDistance)));
				pos = arcNode.positionAtDistance(i, TEMP_VEC);
				graphics.lineTo(pos.x, pos.y);
				//graphics.drawCircle(pos.x, pos.y, 1);
			}
			Vector2Pool.__RELEASE__(TEMP_VEC);										// RELEASE VECTOR2
		}

		
		
		public function drawArc(arc:Arc, debug:Boolean = false):void{
			var TEMP_VEC:Vector2 = Vector2Pool.__GET__();							// GET VECTOR2

			var pos:Vector2;
			var len:Number = arc.length >= arc.circumference ? arc.circumference: arc.length;
			for(var i:Number = 0; i < len; i += 10){
				pos = arc.positionAtDistance(i, TEMP_VEC);
				graphics.drawCircle(pos.x, pos.y, 1);
			}
				
			
			Vector2Pool.__RELEASE__(TEMP_VEC);										// RELEASE VECTOR2
		}
		*/
		
		
		/*
		private function drawArcs(entity:Entity){
			var orbit:Orbit = entity.getComponent(Orbit) as Orbit;
			var node:ArcNode = orbit.headArcNode;
			
			graphics.lineStyle(1, 0x009900, 1);
			while(node){
				drawArc(node.arc);
				node = node.next;
			}
		}
		*/
		
			
			
		//
		// Singelton
		//
		private static var _instance:DebugDraw;
	
		public static function get instance():DebugDraw{
			if(_instance == null) _instance = new DebugDraw();
			return _instance;
		}
		
	

	}
	
}
