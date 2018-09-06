"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

Object subclass:#RPCStubGenerator
	instanceVariableNames:'targetClass generatorTool definitions program programVersion'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-RPC'
!

!RPCStubGenerator class methodsFor:'documentation'!

documentation
"
    This is for Smalltalk, what rpcgen is for C; it takes an xdr and generates stub methods
    from it into a class.

    [author:]
        cg (cg@CG-VOSTRO)
"
!

example1
"
     |newClientClass newServerClass|

     Class withoutUpdatingChangesDo:[
         newClientClass := SunRPC::RPCClient 
                            subclass:#TestClient
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
         newServerClass := SunRPC::RPCServer 
                            subclass:#TestServer
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
     ].
     self 
        generateMethodFor:'null'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.
     self 
        generateMethodFor:'showOnTranscript'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.

     self 
        generateMethodFor:'null'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
     self 
        generateMethodFor:'showOnTranscript'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
"
!

example2
"
     |newClientClass newServerClass|

     Class withoutUpdatingChangesDo:[
         newClientClass := SunRPC::RPCClient 
                            subclass:#TestClient
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
         newServerClass := SunRPC::RPCServer 
                            subclass:#TestServer
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
     ].
     self 
        generateMethodsForProgramName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.

     self 
        generateMethodsForProgramName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
"
! !

!RPCStubGenerator class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!RPCStubGenerator class methodsFor:'code generation'!

generateMethodFor:procedureName programName:programName versionName:versionName fromXDR:xdrSpec inClass:aClass
    ^ self new
        generateMethodFor:procedureName 
        programName:programName 
        versionName:versionName 
        fromXDR:xdrSpec 
        inClass:aClass

    "
     |newClientClass newServerClass|

     Class withoutUpdatingChangesDo:[
         newClientClass := SunRPC::RPCClient 
                            subclass:#TestClient
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
         newServerClass := SunRPC::RPCServer 
                            subclass:#TestServer
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
     ].
     self 
        generateMethodFor:'null'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.
     self 
        generateMethodFor:'showOnTranscript'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.

     self 
        generateMethodFor:'null'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
     self 
        generateMethodFor:'showOnTranscript'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
    "
!

generateMethodsForProgramName:programName versionName:versionName fromXDR:xdrSpec inClass:aClass
    ^ self new
        generateMethodsForProgramName:programName 
        versionName:versionName 
        fromXDR:xdrSpec 
        inClass:aClass

    "
     |newClientClass newServerClass|

     Class withoutUpdatingChangesDo:[
         newClientClass := SunRPC::RPCClient 
                            subclass:#TestClient
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
         newServerClass := SunRPC::RPCServer 
                            subclass:#TestServer
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
     ].
     self 
        generateMethodsForProgramName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.

     self 
        generateMethodsForProgramName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
    "
! !

!RPCStubGenerator methodsFor:'code generation'!

generateMethodFor:procedureName programName:programName versionName:versionName fromXDR:xdrSpec inClass:aClass
    definitions := XDRParser parsePrograms:xdrSpec.
    program := definitions at:programName ifAbsent:[ self error:'no such program in spec' ].
    programVersion := program versions at:versionName ifAbsent:[ self error:'no such version in program' ].    
    ^ self generateMethodFor:procedureName from:programVersion inClass:aClass

    "
     |newClientClass newServerClass|

     Class withoutUpdatingChangesDo:[
         newClientClass := SunRPC::RPCClient 
                            subclass:#TestClient
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
         newServerClass := SunRPC::RPCServer 
                            subclass:#TestServer
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
     ].
     self 
        generateMethodFor:'null'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.
     self 
        generateMethodFor:'showOnTranscript'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.

     self 
        generateMethodFor:'null'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
     self 
        generateMethodFor:'showOnTranscript'
        programName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
    "
!

generateMethodsForProgramName:programName versionName:versionName fromXDR:xdrSpec inClass:aClass
    targetClass := aClass.
    definitions := XDRParser parsePrograms:xdrSpec.
    program := definitions at:programName ifAbsent:[ self error:'no such program in spec' ].
    programVersion := program versions at:versionName ifAbsent:[ self error:'no such version in program' ].    
    programVersion procedures do:[:eachProcedure |
        self generateMethodForProcedure:eachProcedure
    ].
    generatorTool executeCollectedChangesNamed:'generate stubs'.

    "
     |newClientClass newServerClass|

     Class withoutUpdatingChangesDo:[
         newClientClass := SunRPC::RPCClient 
                            subclass:#TestClient
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
         newServerClass := SunRPC::RPCServer 
                            subclass:#TestServer
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Net-Communication-RPC-Demos'.
     ].
     self 
        generateMethodsForProgramName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newClientClass.

     self 
        generateMethodsForProgramName:'DEMO'
        versionName:'DEMOVERS'
        fromXDR:(DemoClient xdr) 
        inClass:newServerClass.
    "
! !

!RPCStubGenerator methodsFor:'initialization'!

initialize
    generatorTool := CodeGeneratorTool new
! !

!RPCStubGenerator methodsFor:'private code generation'!

generateMethodFor:procedureName from:xdrProgramVersion inClass:aClass
    "xdrProgramVersion must be an instance of SunRPC::XDRProgramVersion"

    |procedure|

    targetClass := aClass.
    procedure := xdrProgramVersion procedures 
                    detect:[:proc | proc name = procedureName]
                    ifNone:[ self error:'no such procedure in programVersion' ].
    self
        generateMethodForProcedure:procedure.

    generatorTool executeCollectedChangesNamed:'generate stub'.
!

generateMethodForProcedure:xdrProcedure
    "xdrProcedure must be an instance of SunRPC::XDRProcedure"

    |args numArgs returnType procedureName methodSelector codeStream replyVarName replyValueString|

    procedureName := xdrProcedure name.
    args := xdrProcedure arguments.
    numArgs := args size.
    numArgs > 0 ifTrue:[
        methodSelector := (procedureName , ':') asSymbol.
    ] ifFalse:[
        methodSelector := procedureName asSymbol.
    ].

    (targetClass implements:methodSelector) ifTrue:[ ^ self ].

    returnType := xdrProcedure type.

    codeStream := WriteStream on:''.

    codeStream nextPutAll:methodSelector.
    numArgs > 0 ifTrue:[
        args keysAndValuesDo:[:idx :arg |
            idx ~~ 1 ifTrue:[
                codeStream nextPutAll:' _:'
            ].
            codeStream nextPutAll:(arg methodAgumentNameForTemplate:('arg%1' bindWith:idx)).
        ].
    ].
    codeStream cr.
    targetClass isRPCServerClass ifTrue:[
        codeStream nextPutLine:'    "called via RPC from remote clients.'.
    ] ifFalse:[
        codeStream nextPutLine:'    "performs an RPC-call to the corresponding remote server''s procedure.'.
    ].
    codeStream nextPutLine:('     returns: %1"' bindWith:(returnType idlString:'' indent:0)).
    codeStream cr.

    replyVarName := returnType methodAgumentNameForTemplate:'reply'.

    targetClass isRPCServerClass ifTrue:[
        returnType isXDRVoid ifFalse:[        
            codeStream nextPutLine:'    |',replyVarName,'|'.
            codeStream cr.
        ].
        codeStream nextPutLine:'    self halt:''unimplemented operation: %1''.'.
        returnType isXDRVoid ifFalse:[        
            replyValueString := returnType smalltalkDefaultValueString.
            codeStream nextPutLine:'    ',replyVarName,' := ',replyValueString,'.'.
            codeStream cr.
            codeStream nextPutLine:'    ^ ',replyVarName,'.'.
        ]
    ] ifFalse:[
        numArgs > 1 ifTrue:[
            codeStream nextPutLine:'    |',replyVarName,' argVector|'.
        ] ifFalse:[                     
            codeStream nextPutLine:'    |',replyVarName,'|'.
        ].
        codeStream cr.
        numArgs == 0 ifTrue:[
            codeStream nextPutLine:('    %2 := self callOperation:#%1 withData:nil.' bindWith:procedureName with:replyVarName).
        ] ifFalse:[
            numArgs == 1 ifTrue:[
                codeStream nextPutLine:('    %3 := self operation:#%1 argument:%2.' 
                                            bindWith:procedureName
                                            with:(args first methodAgumentNameForTemplate:'arg1')
                                            with:replyVarName).
            ] ifFalse:[
                codeStream nextPutLine:('    argVector := Array new:%1.' bindWith:numArgs size).
                args keysAndValuesDo:[:idx :arg |
                    codeStream nextPutLine:('    argVector at:%1 put:%2.' 
                                            bindWith:idx    
                                            with:(arg methodAgumentNameForTemplate:('arg%1' bindWith:idx))).
                ].
                codeStream nextPutLine:('    %3 := self operation:#%1 arguments:argVector.' bindWith:procedureName with:replyVarName).
            ].
            codeStream nextPutLine:'    ^ ',replyVarName,'.'.
        ].
        codeStream cr.
        codeStream nextPutLine:'    "'.
        numArgs == 0 ifTrue:[
            codeStream nextPutLine:'     |client ',replyVarName,'|'.
        ] ifFalse:[
            numArgs == 1 ifTrue:[
                codeStream nextPutLine:'     |client arg ',replyVarName,'|'.
            ] ifFalse:[
                codeStream nextPutLine:'     |client argVec ',replyVarName,'|'.
            ].
        ].
        codeStream cr.
        codeStream nextPutLine:('     client := %1 new host:''localhost''.' bindWith:targetClass name).
        numArgs == 0 ifTrue:[
            codeStream nextPutLine:'     ',replyVarName,' := client ',methodSelector,'.'.
        ] ifFalse:[
            numArgs == 1 ifTrue:[
                codeStream nextPutLine:'     arg := ''fooBar''.'.
                codeStream nextPutLine:'     ',replyVarName,' := client ',methodSelector,'arg.'.
            ] ifFalse:[
                codeStream nextPutLine:('     argVec := Array new:%1' bindWith:numArgs).
                codeStream nextPutLine:'     ',replyVarName,' := client ',methodSelector,'argVec.'.
            ]
        ].
        codeStream nextPutLine:'     client close.'.
        codeStream nextPutLine:'     ',replyVarName,'.'.
        codeStream nextPutLine:'    "'.
    ].
Transcript showCR:codeStream contents.
    generatorTool
        compile:(codeStream contents)
        forClass:targetClass 
        inCategory:'operations'.
! !

!RPCStubGenerator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC__RPCStubGenerator.st,v 1.1 2009-01-26 23:06:56 cg Exp $'
! !
