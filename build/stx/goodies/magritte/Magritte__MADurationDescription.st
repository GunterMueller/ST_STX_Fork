"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescription subclass:#MADurationDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MADurationDescription comment:'I am a description of durations, possible values are instances of ==Duration==.'
!



!MADurationDescription class methodsFor:'accessing'!

label
	^ 'Duration'
! !

!MADurationDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADurationDescription methodsFor:'accessing'!

kind
        ^ TimeDuration
! !

!MADurationDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitDurationDescription: self
! !

!MADurationDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADurationDescription.st,v 1.4 2009-08-14 21:23:27 cg Exp $'
! !
