"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

ParseNode subclass:#JavaScriptFunctionNode
	instanceVariableNames:'functionName arguments locals statements environment
		isReturnedFrom'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptFunctionNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    ATTENTION: for protocol compatibility with JavaScriptEnvironment.
    many messages are implemented with an initial underscore.
    These are required as JavaScriptEnvironment catches doesNotUnderstand and
    does some kludgy fiddling there.
"
! !

!JavaScriptFunctionNode methodsFor:'accessing'!

_argVariables
    ^ arguments
!

_argVariables:aDictionary
    arguments := aDictionary
!

_localVariables
    ^ locals
!

_localVariables:aDictionary
    locals := aDictionary
!

_outerEnvironment
    ^ environment

    "Created: / 17.5.1998 / 00:41:00 / cg"
!

_outerEnvironment:anEnvironment
    environment := anEnvironment

    "Created: / 17.5.1998 / 00:41:11 / cg"
!

_topEnvironment
    ^ environment isNil ifTrue:self ifFalse:[environment _topEnvironment]
!

addLocalVariable:aVariable
    locals isNil ifTrue:[
	locals := OrderedCollection new.
    ].
    locals add:aVariable

    "Created: / 14.5.1998 / 21:56:19 / cg"
!

argumentCount
    ^ arguments argumentCount

    "Created: / 17.5.1998 / 00:36:04 / cg"
!

arguments
    "return the value of the instance variable 'arguments' (automatically generated)"

    ^ arguments

    "Created: / 14.5.1998 / 21:26:20 / cg"
!

arguments:something
    "set the value of the instance variable 'arguments' (automatically generated)"

    arguments := something.

    "Created: / 14.5.1998 / 21:26:20 / cg"
!

functionName
    "return the value of the instance variable 'functionName' (automatically generated)"

    ^ functionName

    "Created: / 14.5.1998 / 21:26:18 / cg"
!

functionName:something
    "set the value of the instance variable 'functionName' (automatically generated)"

    functionName := something.

    "Created: / 14.5.1998 / 21:26:18 / cg"
!

isReturnedFrom
    ^ isReturnedFrom
!

isReturnedFrom:something
    isReturnedFrom := something.
!

localVariableNames
    locals isNil ifTrue:[^ #() ].
    ^ (locals asSortedCollection:[:a :b | a index < b index]) collect:[:v | v name].
!

localVariables
    ^ locals ? #()
!

numArgs
    ^ arguments size

    "Created: / 17.5.1998 / 00:36:04 / cg"
!

numVars
    "return the number of local variables."

    ^ locals size
!

statements
    "return the value of the instance variable 'statements' (automatically generated)"

    ^ statements

    "Created: / 14.5.1998 / 21:26:22 / cg"
!

statements:aStatementNode
    "set the value of the instance variable 'statements' (automatically generated)"

    statements := aStatementNode.
    statements notNil ifTrue:[
        statements parent: self.
    ]

    "Created: / 14-05-1998 / 21:26:22 / cg"
    "Modified: / 20-09-2013 / 17:17:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableValue
    "that is a bad kludge to fix the interpreter, which gets functionNodes as value"

    ^  self
!

xxxx_variables
    |list|

    list := IdentityDictionary new.
    arguments notNil ifTrue:[
	arguments do:[:arg |
	    list at:arg name put:arg
	].
    ].
    locals notNil ifTrue:[
	locals do:[:var |
	    list at:var name put:var
	].
    ].
    ^ list

    "Created: / 17.5.1998 / 00:38:15 / cg"
    "Modified: / 17.5.1998 / 00:40:18 / cg"
! !

!JavaScriptFunctionNode methodsFor:'code generation'!

codeVariableSetupOn:codeStream for:aCompiler
    locals isNil ifTrue:[^ self].

    locals do:[:eachVar |
        "/ generate code to set it up.

        |varNode initExpression setupExpr|

        initExpression := eachVar expressionForSetup.
        initExpression notNil ifTrue:[
            self isInnerFunction ifTrue:[
                varNode := JavaScriptVariableNode
                                type:#BlockVariable
                                name:eachVar name
                                token:eachVar
                                index:eachVar index
                                block:self 
                                from:self    
            ] ifFalse:[
                varNode := JavaScriptVariableNode 
                                type:#MethodVariable
                                name:eachVar name
                                token:eachVar
                                index:eachVar index.
            ].
            setupExpr := AssignmentNode variable:varNode expression:initExpression.
            setupExpr codeForSideEffectOn:codeStream inBlock:(self isInnerFunction ifTrue:[self] ifFalse:[nil]) for:aCompiler.
        ]
    ]

    "Modified: / 12-07-2006 / 15:07:00 / cg"
! !

!JavaScriptFunctionNode methodsFor:'enumeration'!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnode"

    statements allNodesDo:aBlock
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    statements messageSelectorsDo:aBlock

    "Created: / 24-07-2010 / 21:42:25 / cg"
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    statements notNil ifTrue:[
        statements messagesDo:aBlock
    ].

    "Created: / 24-07-2010 / 21:42:25 / cg"
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    statements variableNodesDo:aBlock

    "Created: / 24-07-2010 / 21:42:25 / cg"
! !

!JavaScriptFunctionNode methodsFor:'evaluation'!

value
    ^ self valueWithReceiver:nil arguments:#()
!

value:arg
    <context: #return>

    ^ self valueWithReceiver:nil arguments:{ arg }
!

value:arg1 value:arg2
    ^ self valueWithReceiver:environment "nil" arguments:{ arg1 . arg2 }
!

value:arg1 value:arg2 value:arg3  
    ^ self valueWithReceiver:nil arguments:{ arg1 . arg2 . arg3 }
!

value:arg1 value:arg2 value:arg3 value:arg4    
    ^ self valueWithReceiver:nil arguments:{ arg1 . arg2 . arg3 . arg4 }
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5     
    ^ self valueWithReceiver:nil arguments:{ arg1 . arg2 . arg3 . arg4 . arg5 }
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6      
    ^ self valueWithReceiver:nil arguments:{ arg1 . arg2 . arg3 . arg4 . arg5 . arg6 }
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7      
    ^ self valueWithReceiver:nil arguments:{ arg1 . arg2 . arg3 . arg4 . arg5 . arg6 . arg7 }
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7 value:arg8     
    ^ self valueWithReceiver:nil arguments:{ arg1 . arg2 . arg3 . arg4 . arg5 . arg6 . arg7 . arg8 }
!

valueWithArguments:args    
    ^ self valueWithReceiver:nil arguments:args
!

valueWithReceiver:rec arguments:args
    |oldValues val this|

    (args size ~~ arguments size) ifTrue:[
        ^ self wrongNumberOfArguments:args size
    ].
    statements isNil ifTrue:[^ nil].

    oldValues := Array new:(arguments size).
    1 to:arguments size do:[:i |
        oldValues at:i put:(arguments at:i) value.
        (arguments at:i) value:(args at:i).
    ].
"/    exitBlock := [:v | 
"/        1 to:argArray size do:[:i |
"/           ( blockArgs at:i) value:(oldValues at:i)
"/        ].
"/        ^ v
"/    ].

    (rec isNil and:[environment notNil]) ifTrue:[ 
        "/ another hack
        this := environment _theReceiver.  
    ] ifFalse:[ 
        this := rec.
    ].
    val := statements evaluateAllIn:(Context new receiver:this).

    1 to:arguments size do:[:i |
        (arguments at:i) value:(oldValues at:i)
    ].
    ^ val

    "Modified: / 17-05-1998 / 00:53:45 / cg"
    "Modified: / 14-07-2018 / 09:34:41 / Claus Gittinger"
!

wrongNumberOfArguments:numArgsGiven
    "report that the number of arguments given does not match the number expected"

    WrongNumberOfArgumentsError
        raiseRequestWith:self
        errorString:('function got %1 arg(s) where %2 expected' 
                        bindWith:numArgsGiven
                        with:arguments size)
! !

!JavaScriptFunctionNode methodsFor:'printing'!

printOn:aStream indent:i
    |first stat|

    aStream nextPutAll:'function '.
    functionName notNil ifTrue:[ aStream nextPutAll:functionName ].
    aStream nextPutAll:'('.

    first := true.
    arguments notNil ifTrue:[
        arguments do:[:anArgVar |
            first ifFalse:[aStream nextPutAll:', ' ].
            first := false.

            aStream nextPutAll:anArgVar name.
        ].
    ].
    aStream nextPutAll:')'.
    "/ aStream cr.
    aStream space.
    aStream nextPutAll:'{'.
    locals size > 0 ifTrue:[
        locals do:[:v |
            aStream cr; spaces:i+4.
            aStream nextPutAll:'var '; nextPutAll:v name; nextPutAll:';'" ; cr"
        ].
        aStream cr.
    ].
    aStream cr; spaces:i+4.
    (stat := statements) notNil ifTrue:[
        [stat notNil] whileTrue:[
            stat printOn:aStream indent:i+4.
            stat := stat nextStatement.
            stat notNil ifTrue:[aStream cr; spaces:i+4.]
        ].
    ].
    aStream cr; spaces:i; nextPutAll:'}'.

    "Created: / 14.5.1998 / 21:29:02 / cg"
    "Modified: / 15.5.1998 / 15:06:40 / cg"
! !

!JavaScriptFunctionNode methodsFor:'queries'!

_isFunctionEnvironment
    ^ true
!

_isHTMLEnvironment
    ^ false
!

home
    ^ nil
! !

!JavaScriptFunctionNode methodsFor:'testing'!

isInlineBlock
    ^ false
! !

!JavaScriptFunctionNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptFunctionNode:self 
! !

!JavaScriptFunctionNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptFunctionNode.st,v 1.40 2018-07-16 07:54:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptFunctionNode.st,v 1.40 2018-07-16 07:54:18 cg Exp $'
! !

