package engine;


@:buildXml("
<files id='haxe'>
  <compilerflag value='-I../cpp/include'/>
</files>
<files id='__main__'>
  <compilerflag value='-I../cpp/include'/>
</files>
<files id='__lib__'>
  <compilerflag value='-I../cpp/include'/>
</files>
")
@:keep class Include{

}
