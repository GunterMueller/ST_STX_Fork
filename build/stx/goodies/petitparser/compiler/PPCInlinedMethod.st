"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCMethod subclass:#PPCInlinedMethod
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!


!PPCInlinedMethod methodsFor:'as yet unclassified'!

call
    ^ self source

    "Modified: / 24-07-2015 / 19:45:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

callOn: receiver
    self error: 'are you sure you want to inline code from different receiver? If so, remove me!!'.
    ^ self code
!

isInline
    ^ true
!

source
    ^ source isString ifTrue:[ 
        source
    ] ifFalse:[ 
        (String streamContents:[:s | source sourceOn:s ]) trimRight
    ].

    "Created: / 24-07-2015 / 19:46:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCInlinedMethod methodsFor:'code generation - variables'!

allocateReturnVariable
    self error: 'return variable must be assigned by the non-inlined method....'

   "Created: / 23-04-2015 / 21:06:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateReturnVariableNamed: name
    self error: 'return variable must be assigned by the non-inlined method....'

    "Created: / 15-06-2015 / 17:52:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateTemporaryVariableNamed:aString
    self error: 'sorry, I can''t allocate variables....'

   "Created: / 23-04-2015 / 21:06:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCInlinedMethod class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

