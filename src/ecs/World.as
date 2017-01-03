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
	
	import flash.utils.Dictionary;
	
	
	public class World {

		private var entities:ComponentCollection = new ComponentCollection(Entity);
		internal var collections:Dictionary = new Dictionary();
		
		
		public function add(entity:Entity):Entity{
			if(entities.exists(entity)) throw(new Error("Already added entity to world: " + entity));
			
			entity.generateDescription();

			for each(var collection:ComponentCollection in collections){
				if(entity.hasComponent(collection.componentType)){
					DependencyInjection.injectDependancies(entity);
					collection.add(entity.getComponent(collection.componentType));
				}
			}
			
			entities.add(entity);
			
			return entity;
		}
		
		
		public function remove(entity:Entity):Entity{
			if(entities.exists(entity) == false) throw(new Error("Cannot remove non-existent entity from world: " + entity));
			
			
			for each(var collection:ComponentCollection in collections){
				if(entity.hasComponent(collection.componentType)){
					var component:IComponent = entity.getComponent(collection.componentType);
					collection.remove(component);
					if(component is IDestroy){
						(component as IDestroy).destroy();
					}
				}
			}
			
			entities.remove(entity); 
			
			return entity;
		}
		
		
		public function exists(entity:Entity):Boolean{
			return entities.exists(entity);
		}
		

		internal function collection(componentType:Class):ComponentCollection{
			if(collections[componentType] == undefined){
				var collection:ComponentCollection = collections[componentType] = new ComponentCollection(componentType);
				
				// Add all component that already exist
				for each(var component:IComponent in entities.components){
					var entity:Entity = component as Entity;
					if(entity.hasComponent(collection.componentType)){
						collection.add(entity.getComponent(collection.componentType));
					}
				}
			}
			
			return collections[componentType];
		}
		
		
		public function components(componentType:Class):Vector.<IComponent>{
			return collection(componentType).components;
		}
		
		
		//
		// Singelton
		//
		private static var _instance:World;
	
		public static function get instance():World{
			if(_instance == null) _instance = new World();
			return _instance;
		}
		
		
		
	}
	
}
