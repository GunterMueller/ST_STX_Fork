"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MATextInputComponent subclass:#MATimeInputComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MATimeInputComponent methodsFor:'actions'!

now
	self value: Time now
! !

!MATimeInputComponent methodsFor:'rendering'!

renderButtonOn: html
	html submitButton on: #now of: self
! !

!MATimeInputComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATimeInputComponent.st,v 1.2 2009-08-14 20:26:17 cg Exp $'
! !
