"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAElementDescriptionTest subclass:#MAClassDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAClassDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAClassDescriptionTest methodsFor:'private'!

actualClass
	^ MAClassDescription
!

includedInstance
	^ String
!

shouldSkipStringTests
	^ true
! !

!MAClassDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAClassDescriptionTest.st,v 1.1 2009-07-29 15:17:55 cg Exp $'
! !
