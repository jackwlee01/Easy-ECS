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
		
	
	public class ComponentCollection{
	
		internal var componentType:Class;
		internal var components:Vector.<IComponent> = new Vector.<IComponent>();
		private var subscribers:Vector.<IComponentCollection> = new Vector.<IComponentCollection>();
		
		
		public function ComponentCollection(componentType:Class){
			this.componentType = componentType;
		}
		
		
		internal function subscribe(subscriber:IComponentCollection):void{
			if(subscribers.indexOf(subscriber) != -1) throw(new Error("Already subscribed: " + subscriber + " to " + this));
			subscribers.push(subscriber);
		}
		

		
		internal function unsubscribe(subscriber:IComponentCollection):void{
			if(subscribers.indexOf(subscriber) == -1) throw(new Error("Cannot unsubscribe: " + subscriber + " to " + this));
			subscribers.splice(subscribers.indexOf(subscriber), 1);
		}
		
		
		
		public function exists(component:IComponent):Boolean{
			return components.indexOf(component) > -1
		}

		
		
		public function belongs(component:IComponent):Boolean{
			return component is componentType;
		}
		
		
		
		public function add(component:IComponent):void{
			if(component is componentType){
				if(exists(component)) throw(new Error("Component " + component + " already exists in component collection: " + this));
				components.push(component);
				for each(var subscriber:IComponentCollection in subscribers) subscriber.onComponentAdded(component);
			}else{
				throw(new Error("Cannot add component: " + component + " to ComponentCollection: " + this));
			}
		}

		
		
		public function remove(component:IComponent):void{
			if(component is componentType){
				if(exists(component) == false) throw( new Error("Component " + component + "cannot be removed as it does not exists in collection: " + this ));
				var index:int = components.indexOf(component);
				components.splice(index, 1);
				for each(var subscriber:IComponentCollection in subscribers) subscriber.onComponentRemoved(component);
			}else{
				throw(new Error("Cannot remove component: " + component + " from ComponentCollection: " + this));
			}
		}
		
		
	}
	
}
