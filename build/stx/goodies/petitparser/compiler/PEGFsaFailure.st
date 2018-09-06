"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaFailure
	instanceVariableNames:'retval'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

PEGFsaFailure class instanceVariableNames:'Instance'

"
 No other class instance variables are inherited by this class.
"
!

!PEGFsaFailure class methodsFor:'as yet unclassified'!

on: retval
    ^ (self new)
        retval: retval;
        yourself
! !

!PEGFsaFailure methodsFor:'accessing'!

retval
    ^ retval
!

retval: anObject
    retval := anObject
!

value
    ^ retval
! !

!PEGFsaFailure methodsFor:'comparing'!

= anotherFailure
    (self == anotherFailure) ifTrue: [ ^ true ].
    self class == anotherFailure class ifFalse: [ ^ false ].
    
    ^ (self retval == anotherFailure retval)
!

hash
    ^ self retval hash
! !

!PEGFsaFailure methodsFor:'printing'!

printOn: aStream
    super printOn: aStream.
    aStream nextPut: $(.
    retval printOn: aStream.
    aStream nextPut: $).
! !

!PEGFsaFailure methodsFor:'testing'!

isFsaFailure
    ^ true
! !

