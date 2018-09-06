"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAElementDescription subclass:#MAClassDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAClassDescription comment:'I am a description of Smalltalk classes, possible values can be any of ==Smalltalk allClasses==.'
!



!MAClassDescription class methodsFor:'accessing'!

label
	^ 'Class'
! !

!MAClassDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAClassDescription methodsFor:'accessing'!

kind
	^ Class
! !

!MAClassDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitClassDescription: self
! !

!MAClassDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAClassDescription.st,v 1.3 2009-08-14 20:03:14 cg Exp $'
! !
