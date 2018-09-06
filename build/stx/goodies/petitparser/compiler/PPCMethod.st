"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCMethod
	instanceVariableNames:'selector source category variableForReturn'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!


!PPCMethod class methodsFor:'as yet unclassified'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCMethod methodsFor:'accessing'!

body
    self halt: '???'.
"	^ buffer contents"
!

bridge
    ^ PPCBridge on: self methodName.
!

category
    ^ category isNil 
        ifTrue: [ category := 'generated' ]
        ifFalse: [ category ]
                          
!

category: value
    category := value
!

code
    ^ String streamContents: [ :s |
        s nextPutAll: self methodName; cr.
        source codeOn: s.    
    ]

    "Modified: / 01-06-2015 / 21:24:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

id: value
    selector := value
!

indentationLevel
    ^ source indentationLevel

    "Created: / 01-06-2015 / 21:38:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indentationLevel: anInteger
    source indentationLevel: anInteger

    "Created: / 01-06-2015 / 21:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodName
    ^ selector
!

source
    ^ source isString ifTrue:[ 
        source
    ] ifFalse:[ 
        String streamContents: [ :s |
            s nextPutAll: self methodName; cr.
            source sourceOn:s.    
        ]
    ].

    "Created: / 24-07-2015 / 19:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source: aString
    source := aString

    "Created: / 24-07-2015 / 19:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMethod methodsFor:'as yet unclassified'!

add: string
    source add: string

    "Modified: / 01-06-2015 / 21:09:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addOnLine: string
    source addOnLine: string

    "Modified: / 01-06-2015 / 21:09:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

call
    ^ 'self ', self methodName, '.'.
!

callOn: receiver
    ^ receiver, ' ', self methodName.
!

profilingBegin
    self profile ifTrue: [ 
 																^ '  context methodInvoked: #', selector, '.'	
    ].
    ^ ''
!

profilingEnd
    self profile ifTrue: [ 
 																^ '  context methodFinished: #', selector, '.'	
    ].
    ^ ''
! !

!PPCMethod methodsFor:'code generation'!

code: aStringOrBlockOrRBParseNode
    source code: aStringOrBlockOrRBParseNode.

    "Created: / 01-06-2015 / 22:31:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 01-06-2015 / 23:50:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeBlock: contents
    | outerBlock innerBlock |

    outerBlock := source.
    innerBlock := PPCCodeBlock new.
    innerBlock indentationLevel: outerBlock indentationLevel + 1.  
    [ 
        outerBlock addOnLine: '['.
        source := innerBlock.
        self codeOnLine: contents.
    ] ensure:[
        outerBlock 
            codeOnLine: (String streamContents:[:s | innerBlock sourceOn:s]);
            add: ']'.
        source := outerBlock.
    ]

    "Created: / 01-06-2015 / 22:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2015 / 06:11:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeOnLine: aStringOrBlockOrRBParseNode
    source codeOnLine: aStringOrBlockOrRBParseNode.

    "Created: / 01-06-2015 / 22:31:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 01-06-2015 / 23:50:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMethod methodsFor:'code generation - indenting'!

dedent
    source dedent

    "Created: / 01-06-2015 / 21:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indent
    source indent

    "Created: / 01-06-2015 / 21:32:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nl

    source nl

    "Created: / 01-06-2015 / 21:52:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMethod methodsFor:'code generation - variables'!

addVariable: name
    self halt: 'deprecated'.
"	(variables includes: name) ifTrue:[ 
        self error:'Duplicate variable name, must rename'.
    ].
    variables add: name.
"
    "Modified: / 23-04-2015 / 12:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateReturnVariable
    
	^ variableForReturn isNil ifTrue:[ 
		variableForReturn := self allocateTemporaryVariableNamed: 'retval'  
	] ifFalse:[ 
		variableForReturn
	].

    "Created: / 23-04-2015 / 18:03:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateReturnVariableNamed: name    
    "Allocate temporary variable used for storing a parser's return value (the parsed object)"

    variableForReturn notNil ifTrue:[ 
        self error: 'Return variable already allocated!!'.
        ^ self.
    ]. 
    variableForReturn := self allocateTemporaryVariableNamed: name.
    ^ variableForReturn

    "Created: / 15-06-2015 / 17:52:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateTemporaryVariableNamed:preferredName 
    "Allocate a new variable with (preferably) given name.
     Returns a real variable name that should be used."

    ^ source allocateTemporaryVariableNamed: preferredName

    "Created: / 23-04-2015 / 17:37:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2015 / 21:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnVariable    
    ^ variableForReturn

    "Created: / 23-04-2015 / 20:50:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-06-2015 / 18:12:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnVariable: aString
    (variableForReturn notNil and:[variableForReturn ~= aString]) ifTrue:[ 
         self error: 'Return variable already allocated with different name (''', variableForReturn , ''' vs ''', aString,''')'.
    ].
    variableForReturn := aString

    "Created: / 23-04-2015 / 18:23:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-06-2015 / 18:14:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMethod methodsFor:'initialization'!

initialize
    source := PPCCodeBlock new.

    "Modified: / 01-06-2015 / 21:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMethod methodsFor:'printing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:' id: '.
    selector printOn:aStream.

    "Modified: / 23-04-2015 / 12:32:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMethod methodsFor:'testing'!

isInline
    ^ false
!

isMethod
    ^ true
! !

!PPCMethod class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

