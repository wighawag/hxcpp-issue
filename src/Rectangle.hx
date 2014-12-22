package;

@:structAccess
@:include("Rectangle.h")
@:native("Rectangle")
@:unreflective
extern class Rectangle{
    public function setValues(w : Int, h : Int) : Void;
    
    @:unreflective
    public function area() : Area;

    @:native("new Rectangle")
    public static function create():util.cpp.Pointer<Rectangle>;
}