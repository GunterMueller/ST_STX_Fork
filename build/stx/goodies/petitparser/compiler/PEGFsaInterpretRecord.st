"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaInterpretRecord
	instanceVariableNames:'maxPriority position'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaInterpretRecord methodsFor:'accessing'!

maxPriority
    ^ maxPriority
!

maxPriority: anObject
    maxPriority := anObject
!

position
    ^ position
!

position: anObject
    position := anObject
! !

!PEGFsaInterpretRecord methodsFor:'initialize'!

initialize
    super initialize.
    maxPriority := SmallInteger minVal.
! !

