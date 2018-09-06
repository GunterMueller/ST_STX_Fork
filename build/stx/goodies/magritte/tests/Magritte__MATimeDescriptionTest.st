"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescriptionTest subclass:#MATimeDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MATimeDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATimeDescriptionTest methodsFor:'private'!

actualClass
	^ MATimeDescription
!

excludedInstance
	^ Time hour: 9 minute: 33 second: 12
!

includedInstance
	^ Time hour: 11 minute: 33 second: 12
!

maxInstance
	^ Time hour: 12 minute: 33 second: 12
!

minInstance
	^ Time hour: 10 minute: 33 second: 12
! !

!MATimeDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MATimeDescriptionTest.st,v 1.1 2009-07-29 15:18:25 cg Exp $'
! !
