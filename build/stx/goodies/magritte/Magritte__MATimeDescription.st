"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescription subclass:#MATimeDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MATimeDescription comment:'I am a description of times, possible values are instances of ==Time==. My visual representation could be a time-picker.'
!



!MATimeDescription class methodsFor:'accessing'!

label
	^ 'Time'
! !

!MATimeDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATimeDescription methodsFor:'accessing'!

kind
	^ Time
! !

!MATimeDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitTimeDescription: self
! !

!MATimeDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MATimeDescription.st,v 1.2 2009-08-14 20:05:26 cg Exp $'
! !
