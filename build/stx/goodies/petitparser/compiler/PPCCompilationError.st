"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Error subclass:#PPCCompilationError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Exceptions'
!


!PPCCompilationError class methodsFor:'error signalling'!

signalWith: message
    ^ self signal: message
! !

!PPCCompilationError class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

