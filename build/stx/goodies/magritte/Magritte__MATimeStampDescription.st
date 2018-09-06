"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescription subclass:#MATimeStampDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MATimeStampDescription comment:'I am a description of timestamps, possible values are instances of ==TimeStamp==. My visual representation could be a date- and time-picker.'
!



!MATimeStampDescription class methodsFor:'accessing'!

label
	^ 'Timestamp'
! !

!MATimeStampDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATimeStampDescription methodsFor:'accessing'!

kind
        ^ Timestamp
! !

!MATimeStampDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitTimeStampDescription: self
! !

!MATimeStampDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MATimeStampDescription.st,v 1.3 2009-08-14 21:23:44 cg Exp $'
! !
