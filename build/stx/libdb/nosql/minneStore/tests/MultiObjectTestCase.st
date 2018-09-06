"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

DiskObjectServicesTestCase subclass:#MultiObjectTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

MultiObjectTestCase comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!MultiObjectTestCase class methodsFor:'As yet unclassified'!

serviceClass



	^DOMultiObjectService
!

storageLocation



	^self testingDirectory
! !

!MultiObjectTestCase methodsFor:'As yet unclassified'!

validateId: anObject



	self assertFalse: ((service idFor: anObject) isNil) named: 'Invalid Id'.



! !

!MultiObjectTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/MultiObjectTestCase.st,v 1.4 2014-02-17 21:41:58 cg Exp $'
! !
