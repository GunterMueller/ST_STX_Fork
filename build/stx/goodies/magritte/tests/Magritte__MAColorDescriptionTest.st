"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAElementDescriptionTest subclass:#MAColorDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAColorDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAColorDescriptionTest methodsFor:'private'!

actualClass
	^ MAColorDescription
!

includedInstance
	^ Color blue
! !

!MAColorDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAColorDescriptionTest.st,v 1.1 2009-07-29 15:21:30 cg Exp $'
! !
