package;

@:structAccess
@:include("Area.h")
@:native("Area")
extern class Area{
    public var width : Int;
    public var height : Int;

    //@:native("new Area")
    //public static function create():util.cpp.Pointer<Area>;
}