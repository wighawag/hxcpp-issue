 "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat"
 
 cl  /Fo.\Rectangle.obj  -c src\Rectangle.cpp -I include
 
 Lib.exe /out:Rectangle.lib Rectangle.obj
 
