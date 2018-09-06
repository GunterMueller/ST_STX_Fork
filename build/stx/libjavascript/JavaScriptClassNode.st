"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

ParseNode subclass:#JavaScriptClassNode
	instanceVariableNames:'className superClassName privateVariables environment
		staticVariables'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptClassNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptClassNode methodsFor:'accessing'!

_argVariables
    ^ nil
!

_localVariables
    ^ self _variables
!

_localVariables:aCollection
    self _variables:aCollection
!

_outerEnvironment
    ^ environment

    "Created: / 17.5.1998 / 00:41:00 / cg"
!

_outerEnvironment:anEnvironment
    environment := anEnvironment

    "Created: / 17.5.1998 / 00:41:11 / cg"
!

_variables
    ^ privateVariables
!

_variables:aVariablesEnvironment
    privateVariables := aVariablesEnvironment
!

className
    "return the value of the instance variable 'className' (automatically generated)"

    ^ className
!

className:something
    "set the value of the instance variable 'className' (automatically generated)"

    className := something.
!

staticVariables
    ^ staticVariables
!

staticVariables:something
    staticVariables := something.
!

superClassName
    "return the value of the instance variable 'superClassName' (automatically generated)"

    ^ superClassName
!

superClassName:something
    "set the value of the instance variable 'superClassName' (automatically generated)"

    superClassName := something.
! !

!JavaScriptClassNode methodsFor:'evaluation'!

evaluate
    "evaluate (i.e. install) a class definition"

    |superClass oldClass newClass instVars instVarNames classVarNames category environment
     firstInitStatement lastInitStatement|

    superClass := Smalltalk at:superClassName asSymbol.
    instVars := OrderedCollection new.
    privateVariables size > 0 ifTrue:[
        privateVariables keysAndValuesDo:[:varName :var |
            instVars add:varName.
        ]
    ].
    instVarNames := instVars asStringWith:' '.
    classVarNames := ''.
    staticVariables size > 0 ifTrue:[
        staticVariables keysAndValuesDo:[:varName :var |
            classVarNames size ~= 0 ifTrue:[
                classVarNames := classVarNames , ' '
            ].
            classVarNames := classVarNames , varName
        ]
    ].
    environment := Class nameSpaceQuerySignal query.
    oldClass := environment classNamed:className.

    category := Class classCategoryQuerySignal query.
"/    oldClass notNil ifTrue:[
"/        category := oldClass category.   
"/    ] ifFalse:[
"/        category := superClass category
"/    ].
    newClass := JavaScriptMetaclass new
            name:(className asSymbol)  
            inEnvironment:environment
            subclassOf:superClass
            instanceVariableNames:instVarNames
            variable:false
            words:false
            pointers:false
            classVariableNames:classVarNames
            poolDictionaries:''
            category:category
            comment:nil
            changed:true. 

    "initialize static variables..."
    staticVariables notNil ifTrue:[
        staticVariables keysAndValuesDo:[:varName :var |
            var expressionForSetup notNil ifTrue:[
                newClass classVarAt: varName put: (var expressionForSetup evaluate).
            ]
        ].
    ].

    "/ if any var has an init-expression, generate an initializer method 
    firstInitStatement := lastInitStatement := nil.
    (privateVariables ? #()) keysAndValuesDo:[:varName :var |
        |varNode initStatement|

        var expressionForSetup notNil ifTrue:[
            varNode := JavaScriptVariableNode 
                            type:#InstanceVariable
                            name:var name
                            token:var
                            index:(instVars indexOf:var name).
            initStatement := JavaScriptParser::JavaScriptStatementNode new
                                expression:(JavaScriptParser::JavaScriptAssignmentNode variable:varNode expression:var expressionForSetup).
            firstInitStatement isNil ifTrue:[
                firstInitStatement := initStatement
            ] ifFalse:[
                lastInitStatement nextStatement:initStatement
            ].
            lastInitStatement := initStatement
        ]
    ].
    firstInitStatement notNil ifTrue:[
        |stat1 stat2 fn|

        fn := JavaScriptFunctionNode new.
        fn functionName:'__initialize__'.
        superClass == Object ifTrue:[
            stat1 := firstInitStatement.
        ] ifFalse:[
            stat1 := JavaScriptParser::JavaScriptStatementNode new
                        expression:((JavaScriptParser::FunctionCallNode
                                        receiver:(SuperNode new)
                                        selector:'__initialize__')
                                        javaScriptSelector:'__initialize__').
            stat1 nextStatement:firstInitStatement.
        ].
        stat2 := JavaScriptParser::JavaScriptReturnNode new
                    expression:(JavaScriptParser::ThisNode new).
        lastInitStatement nextStatement:stat2.
        fn statements:stat1.

        JavaScriptCompiler new
             compileTree:fn source:(fn printString) forClass:newClass inCategory:'initialization' notifying:nil
                 install:true skipIfSame:false silent:true foldConstants:true
                 ifFail:[ self halt ].

        JavaScriptCompiler new
             compile:'function new() {
    return (this.basicNew().__initialize__().initialize());
}'
                 forClass:newClass class inCategory:'instance creation' notifying:nil
                 install:true skipIfSame:false silent:true foldConstants:true
                 ifFail:[ self halt ].
    ].

    ^ newClass

    "Modified: / 17-07-2012 / 12:41:13 / cg"
! !

!JavaScriptClassNode methodsFor:'testing'!

_isFunctionEnvironment
    ^ false

    "Created: / 30-01-2011 / 17:11:10 / cg"
!

isInnerFunction
    ^ false
!

isJavaScriptClassNode
    ^ true
! !

!JavaScriptClassNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptClassNode:self 
! !

!JavaScriptClassNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptClassNode.st,v 1.15 2014-05-12 20:29:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptClassNode.st,v 1.15 2014-05-12 20:29:42 cg Exp $'
! !

