"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCCodeGen
	instanceVariableNames:'clazz options'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!

!PPCCodeGen class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self on: PPCCompilationOptions new

    "Modified: / 07-09-2015 / 10:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: aPPCArguments
    "return an initialized instance"

    ^ self basicNew
        initialize;
        options: aPPCArguments
! !

!PPCCodeGen methodsFor:'accessing'!

clazz
    ^ clazz
!

clazz: aPPCClass
    clazz := aPPCClass
!

currentMethod
    ^ clazz currentMethod 
!

idGen
    ^ clazz idGen
!

idGen: idGenerator
    ^ clazz idGen: idGenerator
!

ids
    ^ clazz idGen ids
!

methodCategory
    ^ 'generated'
!

options: args
    options := args
! !

!PPCCodeGen methodsFor:'caching'!

cacheMethod: method as: id
    ^ clazz store: method as: id
!

cachedMethod: id
    ^ clazz cachedMethod: id
!

cachedMethod: id ifPresent: aBlock
    ^ clazz cachedMethod: id ifPresent: aBlock
! !

!PPCCodeGen methodsFor:'code'!

code: aStringOrBlockOrRBParseNode
    clazz currentMethod code: aStringOrBlockOrRBParseNode

    "Created: / 01-06-2015 / 23:49:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAssert: aCode
    self code: 'self assert: (', aCode, ').'.
!

codeBlock: contents
    clazz currentMethod codeBlock: contents

    "Created: / 01-06-2015 / 22:35:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCall: aMethod
    self assert: (aMethod isKindOf: PPCMethod).
    self code: aMethod call.
!

codeCallOnLine: aMethod
    self assert: (aMethod isKindOf: PPCMethod).
    self codeOnLine: aMethod call.
!

codeDot
    self codeOnLine: '.'.

    "Created: / 16-06-2015 / 06:09:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeNl
    self code: ''.
!

codeOnLine:aStringOrBlockOrRBParseNode
    clazz currentMethod codeOnLine: aStringOrBlockOrRBParseNode

    "Created: / 01-06-2015 / 23:49:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeReturn
   clazz currentMethod isInline ifTrue: [
		"If inlined, the return variable already holds the value"
	] ifFalse: [
		options profile ifTrue:[ 
			self codeProfileStop.
		]. 
		self code: '^ ', clazz currentMethod returnVariable  
	].

		"Created: / 23-04-2015 / 18:01:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
		"Modified: / 01-06-2015 / 21:49:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeReturn: code
    " - returns whatever is in code OR
      - assigns whatever is in code into the returnVariable"
    clazz currentMethod isInline ifTrue:[
        self codeEvaluateAndAssign: code to: clazz currentMethod returnVariable. 
    ] ifFalse: [ 
        options profile ifTrue:[ 
            self codeProfileStop.
        ].   
        self code: '^ '.
        self codeOnLine: code            
    ]

    "Created: / 23-04-2015 / 18:01:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2015 / 21:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeReturnParsedValueOf: aBlock 
    |   method |

    method := clazz parsedValueOf: aBlock to: clazz currentReturnVariable.

    method isInline ifTrue:[
        self codeCallOnLine: method.
        self codeReturn: clazz currentReturnVariable.
    ] ifFalse:[
        self codeReturn: method call.
        
    ]

    "Created: / 23-04-2015 / 18:21:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGen methodsFor:'code assignment'!

codeAssign: stringOrBlock to: variable
    self assert: variable isNil not.
    
    stringOrBlock isString ifTrue: [ 
        ^ self codeAssignString: stringOrBlock to: variable
    ] ifFalse:[
        ^ self codeAssignParsedValueOf: stringOrBlock  to: variable
    ].
!

codeAssignParsedValueOf:aBlock to: variable 
    |   method |
    method := clazz parsedValueOf: aBlock to: variable	.
        
    method isInline ifTrue:[
        self codeCallOnLine:method
    ] ifFalse:[
        self codeAssignString: (method call) to: variable.
    ]

    "Created: / 23-04-2015 / 18:21:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAssignString: string to: variable
    self assert: variable isNil not.
    
    "TODO JK: Hack alert, whatever is magic constant!!"
    (variable == #whatever) ifFalse: [ 
        "Do not assign, if somebody does not care!!"
        self code: variable ,' := ', string.
    ]
!

codeEvaluate: selector argument: argument on: variable
    self assert: variable isNil not.
    
    "TODO JK: Hack alert, whatever is magic constant!!"
    (variable == #whatever) ifFalse: [ 
        "Do not assign, if somebody does not care!!"
        self code: variable, ' ', selector,' ', argument.
 	] ifTrue: [ 
        "In case argument has a side effect"
 		self code: argument	
    ]
!

codeEvaluateAndAssign: stringOrBlock to: variable
    "Contrary to codeAssign:to: I always put code onto the stream"
    stringOrBlock isString ifTrue: [ 
        self codeEvaluateAndAssignString: stringOrBlock to: variable
    ] ifFalse: [ 
        self codeEvaluateAndAssignParsedValueOf: stringOrBlock  to: variable 
    ]
!

codeEvaluateAndAssignParsedValueOf: aBlock to: variable
    | method |
    method := clazz parsedValueOf: aBlock to: variable	.


    method isInline ifFalse: [ 
        self codeEvaluateAndAssignString: method call to: variable.
    ] ifTrue: [ 
        "if inlined, the variable is already filled in, just call it"
        self code: method call
    ]
!

codeEvaluateAndAssignString: string to: variable
    "Contrary to codeAssign:to: I always put code onto the stream"
    self assert: string isString.
    self assert: variable isNil not.
    
    "TODO JK: Hack alert, whatever is magic constant!!"
    (variable == #whatever) ifFalse: [ 
        self codeAssignString: string to: variable
    ] ifTrue: [ 
        "In case code has a side effect"
        self code: string.	
    ]
! !

!PPCCodeGen methodsFor:'code debugging'!

codeComment: string
    self code: '"', string, '"'.
!

codeHalt
    self code: 'self halt. '
!

codeHaltIfShiftPressed
    options debug ifTrue: [
        ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifFalse:[  
            self code: 'Halt ifShiftPressed.'
        ]
    ]

    "Modified: / 10-05-2015 / 07:39:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeProfileStart
    self code: 'context methodInvoked: #', clazz currentMethod methodName, '.'

    "Created: / 01-06-2015 / 21:17:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeProfileStop
    self code: 'context methodFinished: #', clazz currentMethod methodName, '.'

    "Created: / 01-06-2015 / 21:19:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeTranscriptShow: text
    (options profile) ifTrue: [ 
        self code: 'Transcript show: ', text storeString, '; cr.'.
    ]
!

profileTokenRead: tokenName
    options profile ifTrue: [ 
        self code: 'context tokenRead: ', tokenName storeString, '.'
    ]
! !

!PPCCodeGen methodsFor:'code error handling'!

codeClearError
    self code: 'error := false.'.
!

codeError
    self code: 'self error: ''message notspecified''.'.
!

codeError: errorMessage
    self code: 'self error: ''', errorMessage, '''.'
!

codeError: errorMessage at: position
    self code: 'self error: ''', errorMessage, ''' at: ', position asString, '.'
!

codeIfErrorThen: then
    ^ self codeIf: 'error' then: then else: nil

    "Created: / 16-06-2015 / 06:06:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeIfErrorThen: then else: else
    ^ self codeIf: 'error' then: then else: else

    "Created: / 16-06-2015 / 06:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGen methodsFor:'code primitives'!

add: string
    self error: 'deprecated?'.
    clazz currentMethod add: string.
!

addConstant: value as: name    
    clazz addConstant: value as: name
!

addOnLine: string
    self error: 'deprecated'.
    clazz currentMethod addOnLine: string.
!

addVariable: name
    ^ clazz currentNonInlineMethod addVariable: name

    "Modified: / 23-04-2015 / 17:34:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

call: anotherMethod
    self error: 'deprecated?'.
    clazz currentMethod add: anotherMethod call.
!

callOnLine: anotherMethod
    self error: 'deprecated?'.
    clazz currentMethod addOnLine: anotherMethod call.
!

dedent
    clazz currentMethod dedent
!

indent
    clazz currentMethod indent
! !

!PPCCodeGen methodsFor:'code structures'!

codeIf: condition then: then 
    self codeIf: condition then: then else: nil

    "Created: / 16-06-2015 / 06:07:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeIf: condition then: then else: else
    self 
        code: '(';
        codeOnLine: condition;
        codeOnLine: ')'.
    then notNil ifTrue:[ 
        self 
            codeOnLine:' ifTrue: ';
            codeBlock: then.
    ].
    else notNil ifTrue:[ 
        self
            codeOnLine:' ifFalse: ';
            codeBlock: else.
    ].
    self codeDot.

    "Created: / 01-06-2015 / 22:43:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-06-2015 / 06:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGen methodsFor:'ids'!

idFor: anObject
    ^ clazz idFor: anObject
!

idFor: anObject defaultName: defaultName
    ^ clazz idFor: anObject defaultName: defaultName
!

numberIdFor: object
    ^ clazz numberIdFor: object
! !

!PPCCodeGen methodsFor:'initialization'!

initialize
    super initialize.

    clazz := PPCClass new.
! !

!PPCCodeGen methodsFor:'support'!

startInline
    ^ clazz startInline

    "Modified: / 01-06-2015 / 21:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startInline: id
    ^ clazz startInline: id

    "Modified: / 01-06-2015 / 21:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startMethod: id
    clazz startMethod: id category: self methodCategory.
    
    options profile ifTrue:[ 
        self codeProfileStart.
    ].
!

stopInline
    ^ clazz stopInline

    "Modified: / 01-06-2015 / 21:37:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopMethod
   ^ clazz stopInline 

	"Modified: / 01-06-2015 / 21:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGen methodsFor:'variables'!

allocateReturnVariable    
    ^ clazz allocateReturnVariableNamed: 'retval'

    "Created: / 23-04-2015 / 18:03:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-06-2015 / 17:52:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateReturnVariableNamed: name
    ^ clazz allocateReturnVariableNamed: name
!

allocateTemporaryVariableNamed: preferredName 
    "Allocate a new variable with (preferably) given name.
     Returns a real variable name that should be used."
    
    ^ clazz allocateTemporaryVariableNamed: preferredName

    "Created: / 23-04-2015 / 17:33:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentReturnVariable
    ^ clazz currentReturnVariable 
! !

