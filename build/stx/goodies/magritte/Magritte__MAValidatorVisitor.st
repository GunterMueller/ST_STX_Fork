"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAGraphVisitor subclass:#MAValidatorVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!


!MAValidatorVisitor class methodsFor:'instance-creation'!

on: anObject description: aDescription
	^ self new on: anObject description: aDescription
! !

!MAValidatorVisitor methodsFor:'initialization'!

on: anObject description: aDescription
	self use: anObject during: [ self visit: aDescription ]
! !

!MAValidatorVisitor methodsFor:'private'!

validate: anObject using: aDescription
	aDescription validateRequired: anObject.
	anObject ifNil: [ ^ self ].
	aDescription
		validateKind: anObject;
		validateSpecific: anObject;
		validateConditions: anObject
! !

!MAValidatorVisitor methodsFor:'visiting'!

visit: aDescription
	(aDescription isVisible and: [ aDescription isReadonly not ])
		ifTrue: [ super visit: aDescription ]
! !

!MAValidatorVisitor methodsFor:'visiting-descriptions'!

visitContainer: aDescription
	super visitContainer: aDescription.
	self object ifNil: [ ^ self ].
	aDescription do: [ :each |
		self
			use: (object readUsing: each)
			during: [ self visit: each ] ]
!

visitDescription: aDescription
	"Validate the current object using aDescription within an exception handler to avoid running further tests that might cause error-cascades."

	[ self validate: self object using: aDescription ]
		on: MAValidationError
		do: [ :err | 
			err isResumable
				ifFalse: [ err beResumable ].
			err pass ]
!

visitTableDescription: aDescription
	super visitTableDescription: aDescription.
	self object ifNil: [ ^ self ].
	self object contents do: [ :each |
		self use: each during: [
			self visit: aDescription reference ] ]
! !

!MAValidatorVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAValidatorVisitor.st,v 1.1 2009-07-29 14:50:27 cg Exp $'
! !
