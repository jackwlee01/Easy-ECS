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
import flash.utils.describeType;
import flash.utils.getDefinitionByName;

class Metadata
{
    public function Metadata (forClass :Class) {
        const typeInfo :XMLList = describeType(forClass).child("factory");

        var name :String;

        // See which classes we extend.
        for each (name in typeInfo.child("extendsClass").attribute("type")) {
            addSupertype(name);
        }

        // See which interfaces we implement.
        for each (name in typeInfo.child("implementsInterface").attribute("type")) {
            addSupertype(name);
        }
    }

    protected function addSupertype (name :String) :void {
        var supertype :Class;
        try {
            supertype = getDefinitionByName(name) as Class;
        } catch (e :ReferenceError) {
            // Reference errors will be thrown for internal classes/interfaces.
        }

        if (supertype != null) {
            _supertypes[supertype] = null;
        }
    }

    public function isSubtypeOf (asClass :Class) :Boolean {
        return (asClass in _supertypes);
    }

    public const _supertypes :Dictionary = new Dictionary();
}
	
	
}
