"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAElementDescriptionTest subclass:#MAStringDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAStringDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAStringDescriptionTest methodsFor:'private'!

actualClass
	^ MAStringDescription
!

includedInstance
	^ 'Lukas Renggli'
! !

!MAStringDescriptionTest methodsFor:'testing-strings'!

testFromStringInvalid
	"There is no invalid string input."
! !

!MAStringDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAStringDescriptionTest.st,v 1.1 2009-07-29 15:21:14 cg Exp $'
! !
