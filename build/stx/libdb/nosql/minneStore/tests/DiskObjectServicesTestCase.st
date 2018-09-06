"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

nil subclass:#DiskObjectServicesTestCase
	instanceVariableNames:'service'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

DiskObjectServicesTestCase comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!DiskObjectServicesTestCase class methodsFor:'As yet unclassified'!

all



	^OrderedCollection new

		addAll: (self selector: #test1);

		addAll: (self selector: #test2);

		addAll: (self selector: #test3);

		addAll: (self selector: #test4);

		addAll: (self selector: #test5);

		addAll: (self selector: #test6);

		addAll: (self selector: #test7);

		addAll: (self selector: #test8);

		addAll: (self selector: #test9);

		yourself.
!

multiUser



	^self new

		service: (self serviceClass newMultiUserOn: self storageLocation)
!

multiUserMultiObjectsPerFile



	| testCase |

	testCase := self multiUser.

	testCase service objectsPerFile: 2.

	^testCase
!

selector: aSymbol

	"Answer a collection of instances of my subclasses."



	^OrderedCollection new

		add: (SingleObjectTestCase singleUser setTestSelector: aSymbol);

		add: (SingleObjectTestCase multiUser setTestSelector: aSymbol);

		add: (MultiObjectTestCase singleUser setTestSelector: aSymbol);

		add: (MultiObjectTestCase singleUserMultiObjectsPerFile setTestSelector: aSymbol);

		add: (MultiObjectTestCase multiUser setTestSelector: aSymbol);

		add: (MultiObjectTestCase multiUserMultiObjectsPerFile setTestSelector: aSymbol);

		yourself.
!

serviceClass



	^self subclassResponsibility
!

singleUser



	^self new

		service: (self serviceClass newSingleUserOn: self storageLocation).
!

singleUserMultiObjectsPerFile



	| testCase |

	testCase := self singleUser.

	testCase service objectsPerFile: 2.

	^testCase
!

storageLocation



	^self subclassResponsibility
!

testingDirectory
	OperatingSystem isMSDOSlike ifFalse:[^ '/tmp/DOTest' ].


	^'C:\DOTest\'
! !

!DiskObjectServicesTestCase methodsFor:'As yet unclassified'!

initializeStorageLocation



	FlavorCompatibility removeDirectoryNamed: self class testingDirectory ifAbsent: [].

	FlavorCompatibility createDirectoryNamed: self class testingDirectory.
!

printOn: aStream



    aStream

"        nextPutAll: 'Test case ';"

	nextPutAll: self class name;

	nextPut: $(;

	print: service userPolicy;

	nextPut: $);

	nextPutAll: '>>';

	nextPutAll: selector
!

service



	^service
!

service: aDOService



	service := aDOService
!

setup

    "Run whatever code you need to get ready for the test to run."



	self initializeStorageLocation.
!

stopOnCheckFailure



	^true
!

stopOnError



	^true
!

test1

	"Test that the object ids are set correctly and the versioning happens"
	"self basicNew setup test1"


	|  testObject testObjectClone |

	testObject := DOTestObject CSLewis.

	"store object.  Verify id and version."

	service store: testObject.

	self assertTrue: ((service versionFor: testObject) == 1) named: 'AT1'.

	self validateId: testObject.

	"read object just stored.  Verify id and version haven't changed."

	testObjectClone := service read: testObject.

	self assertTrue: ((service idFor: testObject) == (service idFor: testObjectClone)) named: 'AT2'.

	self assertTrue: ((service versionFor: testObject) == (service versionFor: testObjectClone)) named: 'AT3'.

	"change and store the clone, read it in and verify the change occurred."

	testObjectClone name: 'different name'.

	service store: testObjectClone.

	self assertTrue: ((service versionFor: testObjectClone) == 2) named: 'AT4'.

	testObjectClone := service read: testObjectClone.

	self assertTrue: (testObjectClone name = 'different name') named: 'AT5'.

	self assertTrue: ((service versionFor: testObjectClone) == 2) named: 'AT6'.

	"delete the object, when read an error should be signaled."
!

test2

	"Test the rollback mechanism."



	| testObject |

	testObject := DOTestObject CSLewis.

	service beginTransaction.

	service store: testObject.

	service rollbackTransaction.

	self assertTrue: ((service read: testObject) isNil) named: 'AT1'.

	self assertTrue: ((service versionFor: testObject) == 0) named: 'AT2'.
!

test3

	"Test the versioning mechanism."



	| testObject testObjectClone |

	testObject := DOTestObject CSLewis.

	service store: testObject.

	testObjectClone := service read: testObject.

	testObjectClone name: 'different name'.

	"store the clone"

	service store: testObjectClone.

	"store the original, an error should occur because the version is wrong"

	self expect: #DOInvalidVersionError during: [service store: testObject].
!

test4

	"Test that versions are rolled back when the service is rolled back."



	| testObject testObjectClone originalName |

	testObject := DOTestObject CSLewis.

	originalName := testObject name.

	service store: testObject.

	self assertTrue: ((service versionFor: testObject) == 1) named: 'AT1'.

	service beginTransaction.

	testObject name: 'different name 1'.

	service store: testObject.

	self assertTrue: ((service versionFor: testObject) == 2) named: 'AT2'.

	testObject name: 'different name 2'.

	service store: testObject.

	self assertTrue: ((service versionFor: testObject) == 3) named: 'AT3'.

	service rollbackTransaction.

	self assertTrue: ((service read: testObject) name = originalName) named: 'AT4'.

	self assertTrue: ((service versionFor: testObject) == 1) named: 'AT5'.
!

test5

	"Test reading all objects using the multiObject service.

	Deleted objects must not be returned"



	| testObject result instance2 |

	service class == DOSingleObjectService ifTrue: [^self].

	service store: DOTestObject CSLewis.

	service store: (instance2 := DOTestObject GrahamGreene).

	service store: DOTestObject GeorgeMacDonald.

	service store: DOTestObject JRRTolkien.

	service delete: instance2.

	result := service readAll.

	self assertTrue: (result size == 3).
!

test6

	"Test locking and unlocking using the singleObjectService.

	Lock testing (#isLocked:) only returns pertinent info when using the multi-user policy"



	| testObject result instance2 |

	service class == DOMultiObjectService ifTrue: [^self].

	service isSingleUser ifTrue: [^self].

	service store: DOTestObject CSLewis.

	testObject := service readForUpdate.

	self assertTrue: (service isLocked) named: 'locked'.

	service unlock: testObject.

	self assertFalse: (service isLocked) named: 'unlocked'.
!

test7

	"Test the basic deletion logic."



	| testObject deletedObject |

	service store: (testObject := DOTestObject CSLewis).

	self assertTrue: ((service versionFor: testObject) == 1).

	deletedObject := service delete: testObject.

	self assertTrue: ((service versionFor: testObject) == 1).

	self assertTrue: deletedObject isDODeletedObject named: 'isDO1'.

	deletedObject := service read: testObject.

	self assertTrue: deletedObject isDODeletedObject named: 'isDO2'.

	self expect: #DOInvalidVersionError during: [service store: testObject].

	"undo the delete with the replace:with: method"

	service replace: (service read: testObject) with: testObject.

	self assertFalse: (service read: testObject) isDODeletedObject named: 'isDO3'.


!

test8

	"Test the specialStore logic."



	| testObject deletedObject |

	service beginTransaction.

	service specialStore: (testObject := DOTestObject CSLewis).

	testObject name: 'a different name'.

	service commitTransaction.

	testObject := service read: testObject.

	self assertTrue: (testObject name = 'a different name').
!

test9

	"Test the readFileNumber: logic."



	| result |

	service class == DOSingleObjectService ifTrue: [^self].

	service store: DOTestObject CSLewis.

	service store: DOTestObject BlaisePascal.

	service store: DOTestObject FrederickBuechner.

	service store: DOTestObject GrahamGreene.

	service delete: (service readId: 2).

	result := service readFileNumber: 1.

	result do: [:each | self assertTrue: (each class == DOTestObject or: [each class == DODeletedObject])].

	result := service readFileNumber: 2.

	result do: [:each | self assertTrue: (each class == DOTestObject or: [each class == DODeletedObject])].






! !

!DiskObjectServicesTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/DiskObjectServicesTestCase.st,v 1.4 2014-02-17 21:41:52 cg Exp $'
! !
