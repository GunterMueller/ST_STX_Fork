"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescriptionTest subclass:#MATimeStampDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MATimeStampDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATimeStampDescriptionTest methodsFor:'private'!

actualClass
	^ MATimeStampDescription
!

excludedInstance
        ^ Timestamp year: 1980 month: 1 day: 11 hour: 11 minute: 38 second: 12
!

includedInstance
        ^ Timestamp year: 1980 month: 6 day: 11 hour: 11 minute: 38 second: 12
!

maxInstance
        ^ Timestamp year: 1980 month: 6 day: 12 hour: 11 minute: 38 second: 12
!

minInstance
        ^ Timestamp year: 1980 month: 6 day: 10 hour: 11 minute: 38 second: 12
! !

!MATimeStampDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MATimeStampDescriptionTest.st,v 1.3 2014-09-23 20:29:49 vrany Exp $'
!

version_CVS
    ^ '$Path: stx/goodies/magritte/tests/Magritte__MATimeStampDescriptionTest.st, Version: 1.0, User: jv, Time: 2014-09-23T21:30:02.928$'
! !

