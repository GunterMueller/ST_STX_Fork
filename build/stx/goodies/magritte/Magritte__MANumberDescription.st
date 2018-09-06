"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescription subclass:#MANumberDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MANumberDescription comment:'I am a description of numbers, possible values are instances of ==Number== and all its subclasses, including ==Integer== and ==Float==. My visual representation could be a number input-box or even a slider-control.'
!



!MANumberDescription class methodsFor:'accessing'!

label
	^ 'Number'
! !

!MANumberDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MANumberDescription methodsFor:'accessing'!

kind
	^ Number
! !

!MANumberDescription methodsFor:'convenience'!

beInteger
	self addCondition: (MACondition selector: #isInteger) labelled: 'No integer was entered'
!

beNegative
	self addCondition: (MACondition selector: #negative) labelled: 'No negative number was entered'
!

bePositive
	self addCondition: (MACondition selector: #positive) labelled: 'No positive number was entered'
! !

!MANumberDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitNumberDescription: self
! !

!MANumberDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MANumberDescription.st,v 1.3 2009-08-14 20:03:51 cg Exp $'
! !
