package util.cpp.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

class PointerMacro{

	static var pointerTypes : Map<String,ComplexType> = new Map();

	macro static public function apply(pointerTypeName : String) : ComplexType{

        var pos = Context.currentPos();
		

		var currentType = Context.getLocalType(); // Pointer<Something>
		
        var classType = //Something
		switch (currentType) {
			case TInst(_,[t]):
				switch(t){
					case TInst(ref,params):
						 ref.get();				 
					//case TMono(_): Context.error("need to specify the program type explicitely, no type inference",pos); null; 	
					default: null;
				}
			default: null;
		}

        if(classType == null){
        	trace("skip");
            return null;
        }


        var id = classType.pack.join(".") + "." + classType.name;

        if (pointerTypes.exists(id)){
            trace("already generated Pointer for " + id);
            return pointerTypes[id];
        }


        var complexType = TPath({pack:classType.pack,name:classType.name});
        var pointerClassPath = {
        	pack : ["cpp"],
        	name : pointerTypeName,
        	params: [TPType(complexType)]
        }
        var pointerComplexType = TPath(pointerClassPath);


        var generatedFields = []; 
        for (field in classType.fields.get()){
            if(field.isPublic){
                trace("FIELD: " + field.name);
                if (field.name == "_destroy"){ //TODO  for copy method
                    trace("Cannot forward _destroy method as this is reserved for the Pointer own destroy method");
                }else{  
                    var funcArgs = [];
                    switch(field.type){
                        case TFun(args,ret):
                            var retPath = switch(ret){
                                case TInst(ref,params):
                                    var retType = ref.get();
                                    //trace(retType);
                                    {pack:retType.pack, name:retType.name} //TODO return Type Parameters
                                case TAbstract(ref,params):
                                    var retType = ref.get();
                                    //trace(retType);
                                    {pack:retType.pack, name:retType.name} //TODO return Type Parameters
                                default: 
                                    trace("Not supporting return of type ", ret);
                                    null;
                            }
                            
                            
                            for (arg in args){
                                var funcArg = switch(arg.t){
                                    case TInst(ref,params):
                                        var argType = ref.get();
                                        //trace(argType);
                                        //TODO Type Parameters params // this will do a recusrive genericBuild call ?
                                        var paramsToAdd = [];
                                        for (param in params){
                                            switch(param){
                                                case TInst(paramRef,_): //TODO recursiove Type Parameters
                                                    var paramType = paramRef.get();    
                                                    paramsToAdd.push(TPType(TPath( {pack:paramType.pack, name:paramType.name})));
                                                 default: 
                                                    trace("Not supporting Type parameters of type ", ret);   
                                            }       
                                        }

                                        var tPath = TPath({pack:argType.pack, name:argType.name, params:paramsToAdd});
                                        // if(arg.opt){
                                        //     tPath = TOptional(tPath);
                                        // }   
                                        {
                                          value:null, //TODO default value ?
                                          type : tPath,
                                          //opt :arg.opt, //TODO
                                          name : arg.name
                                        }
                                    case TAbstract(ref,params):
                                        var argType = ref.get();
                                        //trace(argType);
                                        //TODO Type Parameters params // this will do a recusrive genericBuild call ?
                                        var paramsToAdd = [];
                                        for (param in params){
                                            switch(param){
                                                case TInst(paramRef,_): //TODO recursiove Type Parameters
                                                    var paramType = paramRef.get();    
                                                    paramsToAdd.push(TPType(TPath( {pack:paramType.pack, name:paramType.name})));
                                                 default: 
                                                    trace("Not supporting Type parameters of type ", ret);   
                                            }       
                                        }

                                        var tPath = TPath({pack:argType.pack, name:argType.name, params:paramsToAdd});
                                        // if(arg.opt){
                                        //     tPath = TOptional(tPath);
                                        // }   
                                        {
                                          value:null, //TODO default value ?
                                          type : tPath,
                                          //opt :arg.opt, //TODO
                                          name : arg.name
                                        }
                                    default: 
                                        trace("Not supporting argument of type ", arg.t);
                                        null;
                                }
                                if(funcArg == null){
                                    //TODO error
                                }
                                funcArgs.push(funcArg);

                            }
                            
                            var fieldName = field.name;

                            var callArguments = [];
                            for (funcArg in funcArgs){
                                callArguments.push({pos:pos, expr:EConst(CIdent(funcArg.name))});
                            }
                            var callExpr = {pos:pos,expr: EBlock([
                                            {pos:pos,expr:EReturn(
                                                {pos:pos,expr:ECall(
                                                    {pos:pos, expr:EField(
                                                        {pos:pos, expr:EField(
                                                            {pos:pos, expr: EConst(CIdent("this"))}
                                                        ,"ref")
                                                        }
                                                    , fieldName)
                                                    }
                                                ,callArguments)
                                                }
                                                )
                                            }
                                        ])};

                            trace("***********************************");
                            trace(callExpr);
                            trace("***********************************");


                            
                              generatedFields.push({
                                pos:pos,
                                name:field.name,                    
                                meta:null,
                                kind:FFun({
                                    ret:TPath(retPath),
                                    params:null,
                                    expr:callExpr,
                                    args:funcArgs
                                    }),
                                doc:null,
                                access:[APublic]
                                });
                            
                        default : trace("do not forward non function");
                    }
                }
            }
        }

        generatedFields.push({
                        pos:pos,
                        name:"_destroy",                    
                        meta:null,
                        kind:FFun({
                            ret:null,
                            params:null,
                            expr:macro {this.destroy();},
                            args:[]
                            }),
                        doc:null,
                        access:[APublic]
                        });

        // var forwardExprs = [];
        // for (fieldName in fieldsToForward){
        // 	forwardExprs.push(macro $v{fieldName});
        // }

        //TODO @:forward(push, pop)

        var typeDefinition : TypeDefinition = {
            pos : pos,
            pack : ["util", "cpp", "pointer"],
            name : classType.name + pointerTypeName,
            kind :TDAbstract(pointerComplexType, [],[pointerComplexType]),
            fields:generatedFields,
            meta : [{
        		pos : pos,
        		params : [],
        		name:":structAccess"
        		}
                ,
                {
                pos : pos,
                params : [],
                name:":unreflective"
                }
                ,
                {
                pos : pos,
                params : [],
                name:"test"
                }
                ]
        }
        Context.defineType(typeDefinition);

        var pointerType = TPath({pack:typeDefinition.pack, name : typeDefinition.name});
        pointerTypes[id] = pointerType;
        return pointerType;

    }
}
