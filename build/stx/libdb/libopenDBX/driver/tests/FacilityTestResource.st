"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestResource subclass:#FacilityTestResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!FacilityTestResource methodsFor:'as yet unclassified'!

setUp
	| selectedBackendIndex backendsToChose |	
	DBXBaseTest facility ifNotNil: [ ^ self ].
	backendsToChose := (DBXBackendFacility allSubclasses collect: [ :each | each name ] ) asOrderedCollection.
	selectedBackendIndex := (UIManager default chooseFrom: backendsToChose).
	DBXBaseTest facility: (Smalltalk at: (backendsToChose at: selectedBackendIndex)) facilityForTest.
! !

!FacilityTestResource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/FacilityTestResource.st,v 1.2 2013-04-15 13:18:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/FacilityTestResource.st,v 1.2 2013-04-15 13:18:21 cg Exp $'
! !

