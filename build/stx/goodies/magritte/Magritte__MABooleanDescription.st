"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAElementDescription subclass:#MABooleanDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MABooleanDescription comment:'I am a description of the Boolean values ==true== and ==false==. My visual representation could be a check-box.'
!




!MABooleanDescription class methodsFor:'accessing'!

label
	^ 'Boolean'
! !

!MABooleanDescription class methodsFor:'accessing-defaults'!

defaultFalseString
	^ self defaultFalseStrings first
!

defaultFalseStrings
	^ #( 'false' 'f' 'no' 'n' '0' 'off' )
!

defaultTrueString
	^ self defaultTrueStrings first
!

defaultTrueStrings
	^ #( 'true' 't' 'yes' 'y' '1' 'on' )
! !

!MABooleanDescription class methodsFor:'accessing-descriptions'!

descriptionFalseString
	^ MAStringDescription new
		accessor: #falseString;
		default: self defaultFalseString;
		label: 'False String';
		priority: 410;
		yourself
!

descriptionRequired
	^ nil
!

descriptionTrueString
	^ MAStringDescription new
		accessor: #trueString;
		default: self defaultTrueString;
		label: 'True String';
		priority: 400;
		yourself
! !

!MABooleanDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MABooleanDescription methodsFor:'accessing'!

kind
	^ Boolean
! !

!MABooleanDescription methodsFor:'accessing-properties'!

falseString
	^ self propertyAt: #falseString ifAbsent: [ self class defaultFalseString ]
!

falseString: aString
	self propertyAt: #falseString put: aString
!

trueString
	^ self propertyAt: #trueString ifAbsent: [ self class defaultTrueString ]
!

trueString: aString
	self propertyAt: #trueString put: aString
! !

!MABooleanDescription methodsFor:'accessing-readonly'!

falseStrings
	^ self class defaultFalseStrings
!

trueStrings
	^ self class defaultTrueStrings
! !

!MABooleanDescription methodsFor:'accessing-selection'!

allOptions
	^ self options
!

allOptionsWith: anObject
	^ self options
!

isExtensible
	^ false
!

options
	^ Array with: false with: true
!

reference
	^ self
! !

!MABooleanDescription methodsFor:'private'!

labelForOption: anObject
	anObject == true
		ifTrue: [ ^ self trueString ].
	anObject == false
		ifTrue: [ ^ self falseString ].
	^ self undefined
! !

!MABooleanDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitBooleanDescription: self
! !

!MABooleanDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MABooleanDescription.st,v 1.5 2009-08-14 20:08:40 cg Exp $'
! !
