"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCCodeBlock
	instanceVariableNames:'buffer indentation temporaries'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!

!PPCCodeBlock class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCCodeBlock methodsFor:'as yet unclassified'!

add: string
    self nl.
    self codeIndent.
    self addOnLine: string.

    "Modified: / 01-06-2015 / 22:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addOnLine: string
    buffer nextPutAll: string.
!

nl
    ^ buffer nextPut: Character cr
! !

!PPCCodeBlock methodsFor:'code generation'!

code: aStringOrBlockOrRBParseNode
    self codeNl.
    self codeOnLine: aStringOrBlockOrRBParseNode
    
    "Created: / 01-06-2015 / 21:07:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2015 / 05:52:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeIndent
    self codeIndent:indentation

    "Created: / 01-06-2015 / 22:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeIndent: level
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[ 
        level * 4 timesRepeat: [ buffer nextPut: Character space  ].
    ] ifFalse:[ 
        level timesRepeat: [ buffer nextPut: Character tab  ].
    ].

    "Created: / 01-06-2015 / 22:58:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeNl
    self add: ''.
!

codeOnLine: aStringOrBlockOrRBParseNode
    aStringOrBlockOrRBParseNode isString ifTrue:[ 
        self emitCodeAsString: aStringOrBlockOrRBParseNode
    ] ifFalse:[
        (aStringOrBlockOrRBParseNode isKindOf: RBProgramNode) ifTrue:[ 
            self emitCodeAsRBNode: aStringOrBlockOrRBParseNode.
        ] ifFalse:[  
            self emitCodeAsBlock: aStringOrBlockOrRBParseNode
        ].
    ].
! !

!PPCCodeBlock methodsFor:'code generation - variables'!

allocateTemporaryVariableNamed:preferredName 
    "Allocate a new variable with (preferably) given name.
     Returns a real variable name that should be used."
    
    (temporaries includes:preferredName) ifFalse:[
        temporaries add:preferredName.
        ^ preferredName
    ] ifTrue:[
        | name |

        name := preferredName , '_' , (temporaries size + 1) printString.
        temporaries add:name.
        ^ name
    ].

    "Created: / 23-04-2015 / 17:37:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2015 / 21:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeBlock methodsFor:'indentation'!

dedent
    indentation := indentation - 1
!

indent 
    indentation := indentation + 1
!

indentationLevel
    ^ indentation
!

indentationLevel: value
    indentation := value
! !

!PPCCodeBlock methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    buffer := String new writeStream.
    indentation := 1.
    temporaries := OrderedCollection new.

    "Modified: / 01-06-2015 / 20:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-06-2015 / 06:04:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeBlock methodsFor:'printing and storing'!

sourceOn:aStream 
    "Dumps generated code on given stream"
    
    temporaries notEmpty ifTrue:[
        ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[
            indentation * 4 timesRepeat:[
                aStream nextPut:Character space
            ].
        ] ifFalse:[
            indentation timesRepeat:[
                aStream nextPut:Character tab
            ].
        ].
        aStream nextPut:$|.
        temporaries do:[:e | 
            aStream
                space;
                nextPutAll:e
        ].
        aStream space.
        aStream nextPut:$|.
        self nl.
         "In Smalltalk/X, there should be a blank line after temporaries"
        ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[
            self nl.
        ].
    ].
    aStream nextPutAll:buffer contents

    "Created: / 01-06-2015 / 21:26:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeBlock methodsFor:'private'!

emitCodeAsBlock: aBlock
    aBlock value
!

emitCodeAsRBNode: anRBNode
    anRBNode isSequence ifTrue:[
        anRBNode temporaries do:[:e |  
            (temporaries includes: e name) ifFalse:[ 
                temporaries add: e name
            ].
        ].
        anRBNode statements do:[:e|
            self 	add: (self formatRBNode: e); 
                    addOnLine: '.'.
        ].
    ] ifFalse:[  
        buffer nextPutAll: anRBNode formattedCode.  
    ].

!

emitCodeAsString: aString
    self addOnLine: aString
!

formatRBNode: anRBNode
    | formatter |
    formatter := anRBNode formatterClass new.
    formatter indent: indentation.
    ^ formatter format: anRBNode 
! !

