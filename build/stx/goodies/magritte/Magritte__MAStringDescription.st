"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAElementDescription subclass:#MAStringDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAStringDescription comment:'I am a description of strings, possible values are instances of ==String==. My visual representation could be a single line text-field. Use ==*MAMemoDescription*== for multi-line strings.'
!



!MAStringDescription class methodsFor:'accessing'!

label
	^ 'String'
! !

!MAStringDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAStringDescription methodsFor:'accessing'!

kind
	^ String
! !

!MAStringDescription methodsFor:'testing'!

isSortable
	^ true
! !

!MAStringDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitStringDescription: self
! !

!MAStringDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAStringDescription.st,v 1.2 2009-08-14 20:04:46 cg Exp $'
! !
