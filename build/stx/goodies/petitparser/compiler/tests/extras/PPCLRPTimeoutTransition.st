"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPTransition subclass:#PPCLRPTimeoutTransition
	instanceVariableNames:'maxTime'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPTimeoutTransition methodsFor:'printing'!

printOn: aStream

    aStream nextPutAll: 'PPCLRPTimeoutTransition '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self from.
    aStream nextPutAll: '->'.
    aStream nextPutAll: self to.
    aStream nextPutAll: ' on '.
    aStream nextPutAll: self eventname asString.
! !

!PPCLRPTimeoutTransition class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

