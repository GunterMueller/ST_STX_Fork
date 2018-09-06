"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MAAdaptiveModel
	instanceVariableNames:'description values'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Models'
!

MAAdaptiveModel comment:'I am an adaptive model referencing a dynamic description of myself and a dictionary mapping those descriptions to actual values.'
!


!MAAdaptiveModel class methodsFor:'instance creation'!

description: aDescription
	^ self new
		description: aDescription;
		yourself
!

new
	^ self basicNew initialize
! !

!MAAdaptiveModel methodsFor:'accessing'!

description
	"Answer the description of the receiver."

	^ description
!

description: aDescription
	description := aDescription
!

values
	"Answer a dictionary mapping description to actual values."

	^ values
!

values: aDictionary
	values := aDictionary
! !

!MAAdaptiveModel methodsFor:'accessing-configuration'!

defaultDescription
	^ MAContainer new
!

defaultDictionary
	^ Dictionary new
! !

!MAAdaptiveModel methodsFor:'initialization'!

initialize
	self description: self defaultDescription.
	self values: self defaultDictionary
! !

!MAAdaptiveModel methodsFor:'model'!

readUsing: aDescription
	"Answer the actual value of ==aDescription== within the receiver, ==nil== if not present."

	^ self values at: aDescription ifAbsent: [ nil ]
!

write: anObject using: aDescription
	"Set ==anObject== to be that actual value of the receiver for ==aDescription==."

	self values at: aDescription put: anObject
! !

!MAAdaptiveModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAAdaptiveModel.st,v 1.1 2009-07-29 14:48:11 cg Exp $'
! !
