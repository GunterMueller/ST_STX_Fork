"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAStringDescription subclass:#MASymbolDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MASymbolDescription comment:'I am a description of symbols, possible values are instances of ==Symbol==.'
!


!MASymbolDescription class methodsFor:'accessing'!

label
	^ 'Symbol'
! !

!MASymbolDescription methodsFor:'accessing'!

kind
	^ Symbol
! !

!MASymbolDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitSymbolDescription: self
! !

!MASymbolDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MASymbolDescription.st,v 1.1 2009-07-29 14:49:42 cg Exp $'
! !
