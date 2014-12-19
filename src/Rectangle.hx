package;

@:structAccess
@:include("Rectangle.h")
@:native("Rectangle")
extern class Rectangle{
    public function setValues(w : Int, h : Int) : Void;
    public function area() : Int;

    @:native("new Rectangle")
    public static function create():util.cpp.Pointer<Rectangle>;
}