"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

DiskObjectServices subclass:#DOTestObject
	instanceVariableNames:'name age propertyTable'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!


!DOTestObject class methodsFor:'As yet unclassified'!

BlaisePascal



    ^self new

	name: 'Blaise Pascal';

	age: 63;

	yourself.
!

CSLewis



    ^self new

	name: 'C.S. Lewis';

	age: 63;

	yourself.
!

CharlesWilliams



    ^self new

	name: 'Charles Williams';

	age: 55;

	yourself.
!

DietrichBonhoeffer



    ^self new

	name: 'Dietrich Bonhoeffer';

	age: 41;

	yourself.
!

FrederickBuechner



    ^self new

	name: 'Frederick Buechner';

	age: 57;

	yourself.
!

GeorgeMacDonald



    ^self new

	name: 'George MacDonald';

	age: nil;

	yourself.
!

GrahamGreene



    ^self new

	name: 'Graham Greene';

	age: 80;

	yourself.
!

JRRTolkien



    ^self new

	name: 'J.R.R. Tolkien';

	age: 72;

	yourself.
!

JohnSteinbeck



    ^self new

	name: 'John Steinbeck';

	age: 66;

	yourself.
!

name: aString age: anInteger



	^self new

		name: aString;

		age: anInteger.
! !

!DOTestObject methodsFor:'As yet unclassified'!

= anObject



    self class == anObject class

	ifFalse: [^false].

    self name = anObject name

	ifFalse: [^false].

    self age = anObject age

	ifFalse: [^false].

    (FlavorCompatibility propertyNamed: #DOId for: self) == (FlavorCompatibility propertyNamed: #DOId for: anObject)

		ifFalse: [^false].

    (FlavorCompatibility propertyNamed: #DOVersion for: self) == (FlavorCompatibility propertyNamed: #DOVersion for: anObject)

		ifFalse: [^false].

    ^true.
!

age



    ^age
!

age: anInteger



    age := anInteger
!

name



    ^name
!

name: aString



    name := aString
!

printOn: aStream



	super printOn: aStream.

	aStream

		nextPut: $(;

		nextPutAll: 'name: ';

		print: name;

		nextPutAll: ' age: ';

		print: age;

		nextPutAll: ' id: ';

		print: (FlavorCompatibility propertyNamed: #DOId for: self);

		nextPutAll: ' version: ';

		print: (FlavorCompatibility propertyNamed: #DOVersion for: self);

		nextPut: $);

		yourself


!

propertyTable

    "This is needed for Smalltalk Express and other

    flavors that do not natively support 'properties'."



    ^propertyTable
!

propertyTable: aDictionary

    "This is needed for Smalltalk Express and other

    flavors that do not natively support 'properties'."



    propertyTable := aDictionary
! !

!DOTestObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/DOTestObject.st,v 1.4 2014-02-17 21:41:51 cg Exp $'
! !
