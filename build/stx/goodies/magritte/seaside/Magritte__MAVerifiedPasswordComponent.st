"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MATextPasswordComponent subclass:#MAVerifiedPasswordComponent
	instanceVariableNames:'verificationValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAVerifiedPasswordComponent methodsFor:'accessing'!

verificationString
	^ self description obfuscated: self verificationValue
!

verificationString: aString
	| value |
	(self description isObfuscated: aString)
		ifTrue: [ ^ self ].
	value := [ self description fromString: aString ]
		ifError: [ aString ].
	self verificationValue: value
!

verificationValue
	^ verificationValue
!

verificationValue: anObject
	verificationValue := anObject
! !

!MAVerifiedPasswordComponent methodsFor:'initialization'!

setDescription: aDescription
	super setDescription: aDescription.
	self verificationValue: self value
! !

!MAVerifiedPasswordComponent methodsFor:'private'!

doValidate
	self value = verificationValue
		ifFalse: [ ^ MAConditionError description: self description signal: 'Your passwords do not match' ].
	super doValidate
! !

!MAVerifiedPasswordComponent methodsFor:'rendering'!

renderEditorOn: html
	super renderEditorOn: html.
	html break.
	html passwordInput
		class: 'verification';
		on: #verificationString of: self
! !

!MAVerifiedPasswordComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAVerifiedPasswordComponent.st,v 1.2 2009-08-14 20:26:53 cg Exp $'
! !
