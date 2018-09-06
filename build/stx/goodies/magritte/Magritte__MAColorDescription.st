"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAElementDescription subclass:#MAColorDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAColorDescription comment:'I am a description of colors, possible values are instances of ==Color==. My visual representation could be a color-chooser.'
!



!MAColorDescription class methodsFor:'accessing'!

label
	^ 'Color'
! !

!MAColorDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAColorDescription methodsFor:'accessing'!

kind
	^ Color
! !

!MAColorDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitColorDescription: self
! !

!MAColorDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAColorDescription.st,v 1.3 2009-08-14 20:03:12 cg Exp $'
! !
