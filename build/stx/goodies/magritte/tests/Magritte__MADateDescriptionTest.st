"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescriptionTest subclass:#MADateDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MADateDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADateDescriptionTest methodsFor:'private'!

actualClass
	^ MADateDescription
!

excludedInstance
	^ Date newDay: 1 month: (Date nameOfMonth: 6) year: 1980
!

includedInstance
	^ Date newDay: 11 month: (Date nameOfMonth: 6) year: 1980
!

maxInstance
	^ Date newDay: 12 month: (Date nameOfMonth: 6) year: 1980
!

minInstance
	^ Date newDay: 10 month: (Date nameOfMonth: 6) year: 1980
! !

!MADateDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MADateDescriptionTest.st,v 1.1 2009-07-29 15:25:05 cg Exp $'
! !
