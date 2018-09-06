"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MATimeInputComponent subclass:#MATimeSelectorComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MATimeSelectorComponent class methodsFor:'testing'!

isAbstract
	^false
! !

!MATimeSelectorComponent methodsFor:'rendering'!

renderInputOn: html
	html timeInput
		withSeconds;
		value: self value;
		callback: [ :value | self value: value ]
! !

!MATimeSelectorComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATimeSelectorComponent.st,v 1.2 2009-08-14 20:26:21 cg Exp $'
! !
