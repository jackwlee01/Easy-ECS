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
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	public class DependencyInjection {

		private static const lookups:Dictionary = new Dictionary();
		
		
		public static function injectDependancies(entity:Entity):void{
			var desc:XML;
			
			for(var key in entity.components){
				var component:IComponent = entity.getComponent(key);
				var desc:XML;
				if(!lookups[key]){
					lookups[key] = describeType(key);
				}
				desc = lookups[key];
				
				for each(var vari:XML in desc.factory.variable){
					for each(var meta:XML in vari.metadata){
						if(meta.@name == "required" || meta.@name == "optional" ){
							var componentType:Class = flash.utils.getDefinitionByName(vari.@type) as Class;
							if(meta.@name == "required" && entity.hasComponent(componentType) == false) throw(getQualifiedClassName(component) + " requires that " + getQualifiedClassName(entity) + " has component " + getQualifiedClassName(componentType));
							if(entity.hasComponent(componentType)) component[vari.@name] = entity.getComponent(componentType);
						}else if(meta.@name == "Required"){
							throw(new Error("required meta tag must be lowercase in " + component));
						}else if(meta.@name == "Optional"){
							throw(new Error("optional meta tag must be lowercase in " + component));
						}else if(meta.@name == "Require" || meta.@name == "require"){
							throw(new Error("Misspelt required in " + component));
						}
					}
				}
				
			}
			
		}
		

	}
	
}
