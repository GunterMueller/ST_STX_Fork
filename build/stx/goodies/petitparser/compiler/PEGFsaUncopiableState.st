"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaState subclass:#PEGFsaUncopiableState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaUncopiableState methodsFor:'as yet unclassified'!

addTransition: t
    self error: 'should not happen'
!

copy
    ^ self
!

final: value
    self error: 'should not happen'
!

priority: anObject
    self error: 'should not happen'
! !

!PEGFsaUncopiableState methodsFor:'testing'!

isStub
    ^ true
! !

