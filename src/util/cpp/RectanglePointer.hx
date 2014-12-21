package util.cpp;


@:unreflective
@:structAccess
abstract RectanglePointer(cpp.Pointer<Rectangle>) to cpp.Pointer<Rectangle>{

	public function area() : Area{
		return this.ref.area();
	}
	public function setValues(w : Int, h : Int) : Void{
		this.ref.setValues(w,h);
	}

	public function _destroy():Void{
		this.destroy();
	}
	
}