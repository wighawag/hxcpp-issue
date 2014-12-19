package;

import hxcpp.StaticStd;
import hxcpp.StaticZlib;
import hxcpp.StaticRegexp;

import engine.Include;


class Main
{

   public static function main() : Void{ 
      var rect = Rectangle.create();
      rect.setValues(20,21);
   		update(rect);
      rect.area();
   }

   public static function update(rect : util.cpp.Pointer<Rectangle>) : Int{ 
     rect.area();
   	 rect.setValues(4,200);
   	 rect.area();
   	 return 0;
   }
}