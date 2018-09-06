"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGVariableDefinition subclass:#RGClassInstanceVariableDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGClassInstanceVariableDefinition comment:'A class instance variable definition'
!

!RGClassInstanceVariableDefinition methodsFor:'initialization'!

initialize 

    super initialize.
    self isMetaSide: true.
! !

!RGClassInstanceVariableDefinition methodsFor:'testing'!

isClassInstanceVariable

    ^true
! !

