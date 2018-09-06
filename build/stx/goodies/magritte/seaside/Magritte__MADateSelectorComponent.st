"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MADateInputComponent subclass:#MADateSelectorComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MADateSelectorComponent class methodsFor:'testing'!

isAbstract
	^false
! !

!MADateSelectorComponent methodsFor:'rendering'!

renderButtonOn: html
!

renderInputOn: html
	html dateInput
		value: self value;
		callback: [ :value | self value: value ]
! !

!MADateSelectorComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MADateSelectorComponent.st,v 1.2 2009-08-14 20:25:17 cg Exp $'
! !
