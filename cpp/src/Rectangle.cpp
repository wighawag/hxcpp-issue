#include "Rectangle.h"
#include <iostream>

void Rectangle::setValues (int x, int y) {
	
	std::cout << "cpp set_values(" << x << ", " << y << ")" << std::endl;
	std::cout << "before width: " << width << ", height: " << height << std::endl;
  width = x;
  height = y;
  std::cout << "after width: " << width << ", height: " << height << std::endl;
}

Area Rectangle::area(void){
	std::cout << "cpp area()" << std::endl;
	std::cout << "cpp width: " << width << ", height: " << height << std::endl;
	auto _area = Area();
	_area.width = width;
	_area.height = height;
	return _area;
}