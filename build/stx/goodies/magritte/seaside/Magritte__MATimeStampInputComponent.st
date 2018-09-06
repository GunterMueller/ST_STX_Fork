"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MATextInputComponent subclass:#MATimeStampInputComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MATimeStampInputComponent methodsFor:'actions'!

current
        self value: Timestamp current
! !

!MATimeStampInputComponent methodsFor:'rendering'!

renderButtonOn: html
	html submitButton on: #current of: self
! !

!MATimeStampInputComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATimeStampInputComponent.st,v 1.3 2009-08-14 21:24:28 cg Exp $'
! !
