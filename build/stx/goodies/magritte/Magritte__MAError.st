"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Error subclass:#MAError
	instanceVariableNames:'tag'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Exception'
!

MAError comment:'I represent a generic Magritte error.'
!


!MAError methodsFor:'accessing'!

tag
    ^ tag
!

tag:something
    tag := something.
! !

!MAError methodsFor:'printing'!

displayString
	^ self printString
! !

!MAError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAError.st,v 1.2 2009-07-30 08:01:53 cg Exp $'
! !
