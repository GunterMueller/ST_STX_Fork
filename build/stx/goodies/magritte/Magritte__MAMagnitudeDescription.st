"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAElementDescription subclass:#MAMagnitudeDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAMagnitudeDescription comment:'I am an abstract description for subclasses of ==Magnitude==. The range of accepted values can be limited using the accessors ==min:== and ==max:==.'
!


!MAMagnitudeDescription class methodsFor:'accessing-defaults'!

defaultMax
	^ nil
!

defaultMin
	^ nil
! !

!MAMagnitudeDescription class methodsFor:'accessing-description'!

descriptionMax
	^ self new
		accessor: #max;
		label: 'Maximum';
		priority: 410;
		yourself
!

descriptionMin
	^ self new
		accessor: #min;
		label: 'Min';
		priority: 400;
		yourself
! !

!MAMagnitudeDescription methodsFor:'accessing'!

max
	^ self propertyAt: #max ifAbsent: [ self class defaultMax ]
!

max: aMagnitudeOrNil
	"Set the maximum for accepted values, or ==nil== if open."

	self propertyAt: #max put: aMagnitudeOrNil
!

min
	^ self propertyAt: #min ifAbsent: [ self class defaultMin ]
!

min: aMagnitudeOrNil
	"Set the minimum for accepted values, or ==nil== if open."

	self propertyAt: #min put: aMagnitudeOrNil
! !

!MAMagnitudeDescription methodsFor:'accessing-messages'!

rangeErrorMessage
	| min max |
	^ self propertyAt: #rangeErrorMessage ifAbsent: [
		min := self toString: self min. max := self toString: self max.
		(self min notNil and: [ self max notNil ])
			ifTrue: [ ^ 'Input must be between ' , min , ' and ' , max ].
		(self min notNil and: [ self max isNil ])
			ifTrue: [ ^ 'Input must be above or equeal to ' , min ].
		(self min isNil and: [ self max notNil ])
			ifTrue: [ ^ 'Input must be below or equal to ' , max ] ]
!

rangeErrorMessage: aString
	self propertyAt: #rangeErrorMessage put: aString
! !

!MAMagnitudeDescription methodsFor:'conveniance'!

min: aMinimumObject max: aMaximumObject
	"Set the minimum and maximum of accepted values, or ==nil== if open."

	self min: aMinimumObject; max: aMaximumObject
! !

!MAMagnitudeDescription methodsFor:'testing'!

isSortable
	^ true
!

isWithinRange: anObject
	^ (self min isNil or: [ self min <= anObject ])
		and: [ self max isNil or: [ self max >= anObject ] ]
! !

!MAMagnitudeDescription methodsFor:'validation-private'!

validateSpecific: anObject
	super validateSpecific: anObject.
	(self isWithinRange: anObject)
		ifFalse: [ MARangeError description: self signal: self rangeErrorMessage ]
! !

!MAMagnitudeDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitMagnitudeDescription: self
! !

!MAMagnitudeDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAMagnitudeDescription.st,v 1.1 2009-07-29 14:54:38 cg Exp $'
! !
