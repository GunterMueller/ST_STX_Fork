"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescription subclass:#MADateDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MADateDescription comment:'I am a description of dates, possible values are instances of ==Date==. My visual representation could be a date-picker.'
!



!MADateDescription class methodsFor:'accessing'!

label
	^ 'Date'
! !

!MADateDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADateDescription methodsFor:'accessing'!

kind
	^ Date
! !

!MADateDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitDateDescription: self
! !

!MADateDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADateDescription.st,v 1.3 2009-08-14 20:03:39 cg Exp $'
! !
