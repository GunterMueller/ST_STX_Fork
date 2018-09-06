"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCCodeGen subclass:#PPCUniversalCodeGen
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!

!PPCUniversalCodeGen methodsFor:'code generation'!

remember: parser to: variableName 
    parser isContextFree ifTrue: [ 
        self 	codeAssign: 'context lwRemember.' 
                to: variableName.
    ] ifFalse: [ 
        self  codeAssign: 'context remember.'
                to: variableName.
    ]
!

restore: parser from: mementoName
    parser isContextFree ifTrue: [ 
        self code: 'context lwRestore: ', mementoName, '.'.
    ] ifFalse: [ 
        self code: 'context restore: ', mementoName, '.'.
    ]
! !

