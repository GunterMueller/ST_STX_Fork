"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

DiskObjectServicesTestCase subclass:#SingleObjectTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

SingleObjectTestCase comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!SingleObjectTestCase class methodsFor:'As yet unclassified'!

serviceClass



	^DOSingleObjectService
!

storageLocation



	^self testingDirectory, 'Test.obj'
! !

!SingleObjectTestCase methodsFor:'As yet unclassified'!

delete: anObject



	^service delete
!

validateId: anObject



	self assertTrue: ((service idFor: anObject) isNil) named: 'Invalid Id'.
! !

!SingleObjectTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/SingleObjectTestCase.st,v 1.4 2014-02-17 21:41:59 cg Exp $'
! !
