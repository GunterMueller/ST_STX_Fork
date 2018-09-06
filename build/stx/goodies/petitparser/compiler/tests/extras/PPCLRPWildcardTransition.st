"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPTransition subclass:#PPCLRPWildcardTransition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPWildcardTransition class methodsFor:'instance creation'!

on: anEvent from: startState to: endState name: aString

    self error: 'Wildcard transitions have no from state. Use on:to:name: instead.'
!

on: anEvent to: endState name: aString
    |retval|
    retval := self new.
    retval eventname: anEvent.
    retval from: '*'.
    retval to: endState.
    retval name: aString.
    ^ retval.
! !

!PPCLRPWildcardTransition methodsFor:'printing'!

printOn: aStream

    aStream nextPutAll: 'PPCLRPWildcardTransition '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : *->'.
    aStream nextPutAll: self to.
    aStream nextPutAll: ' on '.
    aStream nextPutAll: self eventname.
    
! !

!PPCLRPWildcardTransition class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

