"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

nil subclass:#CompatibilityTesting
	instanceVariableNames:'propertyTable'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

CompatibilityTesting comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!CompatibilityTesting class methodsFor:'As yet unclassified'!

CompatibilityTesting

    "This is a dummy method for file-out purposes."
!

all



	^OrderedCollection new

		add: (self new selector: #testMethodExistence);

		add: (self new selector: #testFileProtocol);

		add: (self new selector: #testDirectoryProtocol);

		add: (self new selector: #testObjectFilerProtocol);

		add: (self new selector: #testPropertyProtocol);

		add: (self new selector: #testResume);

		add: (self new selector: #testReturn);

		add: (self new selector: #testPass);

		add: (self new selector: #testEnsure);

		yourself.
! !

!CompatibilityTesting methodsFor:'As yet unclassified'!

flavorCompatibilitySelectors

	"Make sure the correct methods have been coded before we do any more testing."



	^OrderedCollection new

		add: #assert:;

		add: #atPropertyNamed:for:put:;

		add: #clone:;

		add: #createDirectoryNamed:;

		add: #createFileNamed:;

		add: #doesFileExist:;

		add: #doesDirectoryExist:;

		add: #dumpObject:on:;

		add: #dumpObject:toNewFile:;

		add: #exceptionDetails:;

		add: #exceptionReceiver:;

		add: #filedSizeOf:;

		add: #fileNameLike:;

		add: #indexOfCollection:in:;

		add: #isCollection:;

		add: #isDictionary:;

		add: #isStream:;

		add: #isString:;

		add: #issue;

		add: #isSymbol:;

		add: #loadObjectFrom:;

		add: #loadObjectFromFileNamed:;

		add: #lockNameForFile:;

		add: #MinneStore;

		add: #needsWork;

		add: #propertyNamed:for:;

		add: #propertyNamed:for:ifAbsent:;

		add: #propertyNamed:for:ifAbsentPut:;

		add: #removeDirectoryNamed:;

		add: #removeDirectoryNamed:ifAbsent:;

		add: #removeFileNamed:;

		add: #removeFileNamed:ifAbsent:;

		add: #replaceAll:in:with:;

		add: #testing;

		add: #triggerEvent:for:;

		add: #triggerEvent:for:with:;

		add: #triggerEvent:for:with:with:;

		add: #wait;

		add: #waitFor:;

		yourself.
!

propertyDict
    "This method needed to use the property feature in the FlavorCompatibility class."

    ^propertyDict
!

propertyDict: aDictionary
    "This method needed to use the property feature in the FlavorCompatibility class."

    propertyDict := aDictionary
!

propertyTable

    "This method needed to use the property feature in the FlavorCompatibility class."



    ^propertyTable
!

propertyTable: aDictionary

    "This method needed to use the property feature in the FlavorCompatibility class."



    propertyTable := aDictionary
!

stopOnCheckFailure



	^true
!

stopOnError



	^true
!

testDirectoryProtocol

	"Test these methods

		#createDirectoryNamed:

		#removeDirectoryNamed:

		#removeDirectoryNamed:ifAbsent:

		#doesDirectoryExist:

	"



	| dir |

	OperatingSystem isMSDOSlike ifTrue:[
	    dir := 'c:\junk145\'.
	] ifFalse:[
	    dir := '/tmp/junk145'.
	].
	self assert: (FlavorCompatibility removeDirectoryNamed: dir ifAbsent: [false]) == false.

	FlavorCompatibility createDirectoryNamed: dir.

	self assert: (FlavorCompatibility doesDirectoryExist: dir).

	FlavorCompatibility removeDirectoryNamed: dir.

	self assert: (FlavorCompatibility doesDirectoryExist: dir) not.
!

testEnsure

    "Check Transcript to make sure this test completed successfully."



    ExceptionCompatibility

	during:

	    [Transcript cr; show: 'testEnsure...'.

	    self error: ' Close this window']

	ensure: [Transcript show: 'completed successfully'].
!

testFileProtocol

	"Test these methods

		#removeFileNamed:ifAbsent:

		#createFileNamed:

		#createLockFile:ifExists:

		#doesFileExist:

		#createLockFile:ifExists:

		#removeFileNamed:

		#fileNameLike:

	"



    | fileName file |

    fileName := 'c:\test5.txt'.

    FlavorCompatibility removeFileNamed: fileName ifAbsent: [].  "It may still be there"

    FlavorCompatibility removeFileNamed: fileName ifAbsent: [].  "Remove something not there."

    (FlavorCompatibility createFileNamed: fileName) close.  "create a file we know isn't there."

    (FlavorCompatibility createFileNamed: fileName) close.  "create file over another w/o complaining."

    FlavorCompatibility removeFileNamed: fileName ifAbsent: [].

    self assert: ((file := FlavorCompatibility createLockFile: fileName ifExists: ['okay']) == file).

    Smalltalk isSmalltalkX ifFalse:[ file close ].

    self assert: (FlavorCompatibility doesFileExist: fileName).

    self assert: ((FlavorCompatibility createLockFile: fileName ifExists: ['okay']) = 'okay').

    FlavorCompatibility removeFileNamed: fileName.



    self assert: ((FlavorCompatibility fileNameLike: 'HappyBirthday') includes: $. ) not.
!

testMethodExistence

	"Make sure the correct methods have been coded before we do any more testing."



	self assert: (ExceptionCompatibility respondsTo: #anyError).

	self assert: (ExceptionCompatibility respondsTo: #DOInvalidVersionError).

	self assert: (ExceptionCompatibility respondsTo: #DOLockStuckError).

	self assert: (ExceptionCompatibility respondsTo: #MessageNotUnderstood).

	self assert: (ExceptionCompatibility respondsTo: #MSBranchAboutToMorph).

	self assert: (ExceptionCompatibility respondsTo: #MSDeletedLeafException).

	self flavorCompatibilitySelectors

		do: [:each | self assert: (FlavorCompatibility respondsTo: each)].

	"/ self log: 'testMethodExistence completed successfully'.
!

testNextWord

	| stream oc word |
	oc := OrderedCollection new.
	stream := ReadStream on: '*)Now-is the
time for...'.
	[(word := FlavorCompatibility nextWordOf: stream) notNil]
		whileTrue: [oc add: word].
	self assert: (oc asArray = #('Now' 'is' 'the' 'time' 'for')).
!

testObjectFilerProtocol



    | stream object1 object2 |

    stream := ReadWriteStream on: (ByteArray new: 50).

    object1 := Array with: 1 with: 2.

    FlavorCompatibility dumpObject: object1 on: stream.

    object2 := FlavorCompatibility loadObjectFrom: stream.

    self assert: object1 = object2.

    self assert: object1 ~~ object2.



    FlavorCompatibility dumpObject: object1 toNewFile: 'c:\test.obj'.

    object2 := FlavorCompatibility loadObjectFromFileNamed: 'c:\test.obj'.

    self assert: object1 = object2.

    self assert: object1 ~~ object2.
!

testPass

    "Check Transcript to make sure this test completed successfully."



    ExceptionCompatibility

    on: #testException

    during:

	[Transcript cr; show: 'testPass...'.

	ExceptionCompatibility

	on: #testException

	during:

	    [ExceptionCompatibility signal: #testException.

	    Transcript show: 'Test failed.']

	do: [:ex | ExceptionCompatibility pass: ex]

	]

    do:

	[:excp |

	Transcript show: 'completed OK if nothing follows on this line.'.

	ExceptionCompatibility return: excp].
!

testPropertyProtocol

    "This method tests the property methods on FlavorCompatibility."



    | obj |

    obj := self class new.



    self assert: ((FlavorCompatibility propertyNamed: #test1 for: obj) isNil).

    self assert: ((FlavorCompatibility atPropertyNamed: #test1 for: obj put: 10) == obj).

    self assert: ((FlavorCompatibility propertyNamed: #test1 for: obj) == 10).



    self assert: ((FlavorCompatibility propertyNamed: #test2 for: obj ifAbsent: [3]) == 3).

    self assert: ((FlavorCompatibility propertyNamed: #test2 for: obj ifAbsentPut: [4]) == 4).

    self assert: ((FlavorCompatibility propertyNamed: #test2 for: obj) == 4).



    self assert: ((FlavorCompatibility propertyNamed: #test3 for: obj ifAbsentPut: [7+7]) == 14).

    self assert: ((FlavorCompatibility propertyNamed: #test3 for: obj) == 14).
!

testResume

    "Check Transcript to make sure this test completed successfully."



    ExceptionCompatibility

	on: #testException

	during:

	    [Transcript cr; show: 'testResume...'.

	    ExceptionCompatibility signal: #testException.

	    Transcript show: 'completed successfully']

	do: [:excp| ExceptionCompatibility resume: excp].
!

testReturn

    "Check Transcript to make sure this test completed successfully."



    ExceptionCompatibility

	on: #testException

	during:

	    [Transcript cr; show: 'testReturn...'.

	    ExceptionCompatibility signal: #testException.

	    Transcript show: 'Did not complete successfully']

	do: [:excp|

	    Transcript show: 'completed OK if nothing follows on this line.'.

	    ExceptionCompatibility return: excp].
! !

!CompatibilityTesting class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/CompatibilityTesting.st,v 1.4 2014-02-17 21:41:50 cg Exp $'
! !
