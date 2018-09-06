"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGContainer subclass:#RGSlice
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Containers'
!

RGSlice comment:'A slice is an arbitrary container of elements (working unit)By inheritance it knows how to treat classes and methods'
!

!RGSlice methodsFor:'adding/removing'!

addElement: aRGDefinition in: aCollection

    aRGDefinition environment: self.
    super addElement: aRGDefinition in: aCollection
! !

!RGSlice methodsFor:'testing'!

isSlice

    ^true
! !

