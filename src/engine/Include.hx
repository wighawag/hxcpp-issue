package engine;


@:buildXml("
<files id='haxe'>
  <compilerflag value='-I../cpp/include'/>
</files>
<files id='__main__'>
  <compilerflag value='-I../cpp/include'/>
</files>
<target id='haxe'>
  <lib name='../cpp/Rectangle'/>
</target>
")
@:keep class Include{

}
