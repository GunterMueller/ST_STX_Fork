"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescriptionTest subclass:#MADurationDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MADurationDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADurationDescriptionTest methodsFor:'private'!

actualClass
	^ MADurationDescription
!

excludedInstance
        ^ TimeDuration days: 0 hours: 0 minutes: 0 seconds: 2
!

includedInstance
        ^ TimeDuration days: 1 hours: 2 minutes: 3 seconds: 4
!

maxInstance
        ^ TimeDuration days: 2 hours: 2 minutes: 3 seconds: 4
!

minInstance
        ^ TimeDuration days: 0 hours: 2 minutes: 3 seconds: 4
! !

!MADurationDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MADurationDescriptionTest.st,v 1.3 2014-09-23 20:30:10 vrany Exp $'
!

version_CVS
    ^ '$Path: stx/goodies/magritte/tests/Magritte__MADurationDescriptionTest.st, Version: 1.0, User: jv, Time: 2014-09-23T21:30:30.489$'
! !

