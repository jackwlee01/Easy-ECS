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

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	
	public class Entity implements IComponent{
	
		private static const qualifiedIComponentName:String = getQualifiedClassName(IComponent);
		private static const typeLookup:Dictionary = new Dictionary();
		private static const componentOrder:Dictionary = new Dictionary();
		
		private var componentLookup:Dictionary = new Dictionary();
		
		
		public var klass:Class;
		
		
		public function get components():Dictionary{
			return componentLookup;
		}
		
		
		internal function generateDescription(){
			var entityKlassName:String = getQualifiedClassName(this);
			var entityClass:Class = getDefinitionByName(entityKlassName) as Class;
			klass = entityClass;
			
			if(typeLookup[entityKlassName] == undefined){
				trace("Registered Entity: " + entityClass);
				
				var dict:Dictionary = new Dictionary();
				typeLookup[entityKlassName] = dict;
				
				// Register the subclass to self
				dict[entityClass] = "self";
				
				var description:XML = describeType(this);
				
				// Register the components
				for each(var v:XML in description.variable){
					var typeString:String = v.@type;
				
					var componentklass:Class = getDefinitionByName(typeString) as Class;
					var varDescription:XML = describeType(componentklass);
					
					
					if(varDescription.@name.indexOf("components::") != -1){
						for each(var interfaceImp:XML in varDescription.factory.implementsInterface){
							if(interfaceImp.@type == qualifiedIComponentName){
								dict[componentklass] = v.@name;
							}
						}
					}
				}
				
				// Register superclasses, but not IComponent and ISystem
				var supers:Dictionary = ClassUtil.getMetadata(entityClass)._supertypes;
				for(var key in supers){
					if(dict[key] == undefined){
						if(key != Object && key != IComponent && key != ISystem){
							if(dict[key]) throw("Component Register inheritence problem!");
							dict[key] = "self";
						}
					}
				}
				
				componentOrder[entityClass] = new Vector.<Class>();
				
				
				// Reorder the components by order of ComponentSystems
				for each(var system:System in Systems.instance.all){
					if(system is ComponentSystem){
						var cSystem:ComponentSystem = system as ComponentSystem;
						if(dict[cSystem.componentType]){
							componentOrder[entityClass].push(cSystem.componentType);
						}
					}
				}
				
	
				for (var key in dict){
					if(componentOrder[entityClass].indexOf(key) == -1){
						componentOrder[entityClass].unshift(key);
					}
				}
				
				// Trace out the order they were added
				for each(var componentClass:Class in componentOrder[entityClass]){
					trace("     " + componentClass);
				}
				
			}
			
			componentLookup = typeLookup[entityKlassName];
			
			/*
			// Reorder component system order
			for each(var system:System in Systems.instance.all){
				if(system is ComponentSystem){
					var cSystem:ComponentSystem = system as ComponentSystem;
					if(dict[cSystem.componentType]){
						componentLookup[cSystem.componentType] = dict[cSystem.componentType];
						delete dict[cSystem.componentType];
					}
				}
			}

			for (var key in dict){
				componentLookup[key] = dict[key];
			}
			
			for(var key in componentLookup){
				trace("Registered component: " + key);
			}
			*/
			
		}
		
		
		private function get self():Entity{
			return this;
		}
		
		
		
		public function hasComponent(klass:Class):Boolean{
			return componentLookup[klass] != undefined;// || this.klass == klass;
		}
		
		
		
		public function getComponent(klass:Class):IComponent{
			return this[componentLookup[klass]];
		}
		
		
	}
	
}




