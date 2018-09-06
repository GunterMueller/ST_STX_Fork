"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAStringDescriptionTest subclass:#MASymbolDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MASymbolDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MASymbolDescriptionTest methodsFor:'private'!

actualClass
	^ MASymbolDescription
!

includedInstance
	^ #magritte
! !

!MASymbolDescriptionTest methodsFor:'testing-validation'!

testValidateConditions
! !

!MASymbolDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MASymbolDescriptionTest.st,v 1.1 2009-07-29 15:22:41 cg Exp $'
! !
