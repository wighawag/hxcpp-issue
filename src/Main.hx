package;

import hxcpp.StaticStd;
import hxcpp.StaticZlib;
import hxcpp.StaticRegexp;


import cpp.ConstPointer;
import cpp.Pointer;

import engine.Include;

@:analyzer(no_simplification)
@:structAccess
@:unreflective
@:include("Rectangle.h")
@:native("Rectangle")
@:keep
extern class Rectangle{
    public function set_values(w : Int, h : Int) : Void;
    public function area() : Int;

    @:native("new Rectangle")
    public static function create():cpp.Pointer<Main.Rectangle>;
}


class Main
{

   public static function main() : Void{ 
      var rect = Main.Rectangle.create();
      rect.ref.set_values(20,21);
   		update(rect);
      rect.ref.area();
   }

   public static function update(rect : Pointer<Rectangle>) : Int{ 
   	 var actualRect : Main.Rectangle = rect.ref;
     actualRect.area();
   	 actualRect.set_values(4,200);
   	 actualRect.area();
   	 //rect.ref.set_values(4,200);

   	return 0;
   }
}