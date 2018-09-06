"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPTransition subclass:#PPCLRPEpsilonTransition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPEpsilonTransition class methodsFor:'instance creation'!

from: startState to: endState name: aString
    |retval|
    retval := self new.
    retval from: startState.
    retval to: endState.
    retval name: aString.
    ^ retval.
!

on: anEvent from: startState to: endState name: aString

    self error: 'Epsilon Transitions have no events. Use from:to:name: instead.'
! !

!PPCLRPEpsilonTransition methodsFor:'printing'!

printOn: aStream

    aStream nextPutAll: 'PPCLRPEpsilonTransition '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self from.
    aStream nextPutAll: '->'.
    aStream nextPutAll: self to.
! !

