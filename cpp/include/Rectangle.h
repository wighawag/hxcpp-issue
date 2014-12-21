#ifndef RECTANGLE_H
#define RECTANGLE_H

#include "Area.h"

class Rectangle {
    int width, height;
  public:
    void setValues (int,int);
	Area area(void);
};

#endif