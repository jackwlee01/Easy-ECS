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


package ecs  {
	
	import flash.utils.describeType;
	import ecs.World;

	
	public class ComponentSystem extends System implements IComponentCollection{

		public var componentType:Class;
		
		
		public function ComponentSystem(componentType:Class){
			enforceType(componentType);
			
			this.componentType = componentType;
			World.instance.collection(componentType).subscribe(this);
		}
		
		
		private function enforceType(componentType:Class){
			var meta:Metadata = ecs.ClassUtil.getMetadata(componentType);
			if(meta.isSubtypeOf(ISystem) == false) throw("Component " + componentType + " must be an ISystem to make into a ComponentSystem");
		}
		
		
		public function onComponentAdded(component:IComponent):void{
			if(component is ISystem){
				var system:ISystem = component as ISystem;
				system.onAdded();
			}
		}
		
		
		public function onComponentRemoved(component:IComponent):void{
			if(component is ISystem){
				var system:ISystem = component as ISystem;
				system.onRemoved();
			}
		}
		
		
		
		override public function update():void{
			for each(var component:IComponent in World.instance.collection(componentType).components){
				var system:ISystem = component as ISystem;
				system.onUpdate();
				if(debug) system.onDebug();
			}
		}
		
		
		
		override public function render():void{
			for each(var component:IComponent in World.instance.collection(componentType).components){
				var system:ISystem = component as ISystem;
				system.onRender();
			}
		}

	}
	
}
