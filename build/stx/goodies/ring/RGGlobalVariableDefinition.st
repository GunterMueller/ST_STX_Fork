"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGGlobalDefinition subclass:#RGGlobalVariableDefinition
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGGlobalVariableDefinition comment:'A global variable definition'
!

!RGGlobalVariableDefinition methodsFor:'accessing'!

value
    "Retrieves the current value of the global variable"

    ^ value
!

value: anObject

    value := anObject
! !

!RGGlobalVariableDefinition methodsFor:'managing container'!

addInContainer: aRGContainer

    aRGContainer addGlobalVariable: self
!

isIncludedInContainer: aRGContainer

    ^aRGContainer includesGlobalVariable: self
!

removeFromContainer: aRGContainer

    aRGContainer removeGlobalVariable: self
! !

!RGGlobalVariableDefinition methodsFor:'testing'!

isGlobalVariable

    ^true
!

isVariable

    ^true
! !

