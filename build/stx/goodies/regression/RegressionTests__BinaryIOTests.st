"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#BinaryIOTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!

!BinaryIOTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 09-09-2004 / 13:13:39 / cg"
! !

!BinaryIOTests class methodsFor:'queries'!

coveredPackageNames
    ^ #( 'stx:libboss' )
! !

!BinaryIOTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!BinaryIOTests methodsFor:'tests'!

test1
    |test test2 loaders bytes outStream inStream|

    loaders := OrderedCollection new.

    outStream := ByteArray new writeStream.

    test := [:objWritten |
		objWritten storeBinaryOn:outStream.
		loaders add:[
				    |objRead expected|

				    expected := objWritten.
				    objRead := inStream nextObject.
				    self assert:( objRead = expected )
				 ]
	      ].

    test2 := [:val | test value:val. test value:  val negated].

    test value:(1 to:99).
    test value:(1 to:99) asArray.
    test value:(1 to:99) asArray beImmutable.

    bytes := outStream contents.
    inStream := BinaryInputManager on:bytes readStream.

    loaders do:[:action | action value ].

    "
     self run:#test1
     self new test1
    "
!

testArrays1
    |objs outStream inStream|

    outStream := ByteArray new writeStream.

    objs := #(
	()
	(1)
	(1 2)
	(1 2 3)
	(nil true false 1 1.0)
    ).

    objs do:[:written |
	written storeBinaryOn:outStream.
    ].


    inStream := BinaryInputManager on:(outStream contents readStream).

    objs do:[:expected | |read|
	read := inStream nextObject.
	self assert:( read = expected).
    ].

    "
     self run:#testArrays1
     self new testArrays1
    "
!

testBehavior
    |clsOut clsIn outStream boss inStream|

    Class withoutUpdatingChangesDo:[
	clsOut := Object
		subclass:#BinarioTestClass
		instanceVariableNames:'a b c'
		classVariableNames:''
		poolDictionaries:''
		category:'tests'
		inEnvironment:nil.
    ].

    outStream := ByteArray new writeStream.
    boss := BinaryOutputManager new.
    clsOut storeBinaryClassOn:outStream manager:boss.

    inStream := BinaryInputManager on:(outStream contents readStream).
    BinaryIOManager nonexistingClassSignal handle:[:ex |
	ex proceedWith:ex parameter
    ] do:[
	clsIn := inStream nextObject.
    ].
    self assert:( clsIn name = clsOut name ).
    self assert:( clsIn superclass == clsOut superclass ).
    self assert:( clsIn instVarNames = clsOut instVarNames ).
    self assert:( clsIn category = clsOut category ).
    self assert:( clsIn poolDictionaries = clsOut poolDictionaries ).
    self assert:( clsIn methodDictionary sameContentsAs: clsOut methodDictionary ).

    "
     self run:#testBehavior
     self new testBehavior
    "
!

testByteArrays1
    |objs outStream inStream|

    outStream := ByteArray new writeStream.

    objs := #(
	[]
	[1]
	[1 2]
	[1 2 3]
	[1 2 3 4]
	[1 2 3 4 5]
	[1 2 3 4 5 6]
	[1 2 3 4 5 6 7]
	[1 2 3 4 5 6 7 8]
	[1 2 3 4 5 6 7 8 9]
    ).

    objs do:[:written |
	written storeBinaryOn:outStream.
    ].


    inStream := BinaryInputManager on:(outStream contents readStream).

    objs do:[:expected | |read|
	read := inStream nextObject.
	self assert:( read = expected).
    ].

    "
     self run:#testByteArrays1
     self new testByteArrays1
    "
!

testByteArrays2
    |outStream inStream test|

    test := [:obj |
	|written read|

	outStream := ByteArray new writeStream.
	written := obj.
	written storeBinaryOn:outStream.

	inStream := BinaryInputManager on:(outStream contents readStream).

	read := inStream nextObject.
	self assert:( read = written).
    ].

    test value:(1 to:254) asByteArray.
    test value:(1 to:255) asByteArray.
    test value:(0 to:255) asByteArray.

    test value:(ByteArray new:100).
    test value:(ByteArray new:127).
    test value:(ByteArray new:128).
    test value:(ByteArray new:129).
    test value:(ByteArray new:254).
    test value:(ByteArray new:255).
    test value:(ByteArray new:256).
    test value:(ByteArray new:257).
    test value:(ByteArray new:1000).
    test value:(ByteArray new:10000).
    test value:(ByteArray new:100000).
    test value:(ByteArray new:1000000).
    test value:(ByteArray new:10000000).

    test value:(ByteArray new:1000) beImmutable.


    "
     self run:#testByteArrays2
     self new testByteArrays2
    "
!

testCharacters
    |objs outStream inStream|

    outStream := ByteArray new writeStream.

    objs :=
	{
	    $a .
	    (Character value:0) .
	    (Character value:255) .
	    (Character value:256) .
	    (Character value:16rFFFF) .
	    (Character value:16r10000) .
	    (Character value:16rFFFFFF) .
	}.

    objs do:[:written |
	written storeBinaryOn:outStream.
    ].


    inStream := BinaryInputManager on:(outStream contents readStream).

    objs do:[:expected | |read|
	read := inStream nextObject.
	self assert:( read = expected).
    ].

    "
     self run:#testCharacters
     self new testCharacters
    "
!

testIntegers1
    |nums outStream bytes inStream verbose|

    verbose := false.
    "/ verbose := true.

    outStream := ByteArray new writeStream.

    nums := #(
	0
	1
	15
	16
	30
	31
	32
	62
	63
	64
	127
	128
	129
	254
	255
	256
	16r0FFF
	16r1000
	16r1001
	16r1FFF
	16r2000
	16r2001
	16r3FFF
	16r4000
	16r4001
	16r7FFF
	16r8000
	16r8001
	16rFFFF
	16r10000
	16r10001

	16r3FFFFF
	16r400000
	16r400001
	16r7FFFFF
	16r800000
	16r800001
	16rFFFFFF
	16r1000000
	16r1000001

	16r3FFFFFFF     "/ largest SmallInt on 32bit machines
	16r40000000
	16r40000001
	16r7FFFFFFF     "/ largest FullInt on 32bit machines
	16r80000000
	16r80000001
	16rFFFFFFFF     "/ largest unsigned FullInt on 32bit machines
	16r100000000
	16r100000001

	16r3FFFFFFFFF
	16r4000000000
	16r4000000001
	16r7FFFFFFFFF
	16r8000000000
	16r8000000001
	16rFFFFFFFFFF
	16r10000000000
	16r10000000001

	16r3FFFFFFFFFFF
	16r400000000000
	16r400000000001
	16r7FFFFFFFFFFF
	16r800000000000
	16r800000000001
	16rFFFFFFFFFFFF
	16r1000000000000
	16r1000000000001

	16r3FFFFFFFFFFFFF
	16r40000000000000
	16r40000000000001
	16r7FFFFFFFFFFFFF
	16r80000000000000
	16r80000000000001
	16rFFFFFFFFFFFFFF
	16r100000000000000
	16r100000000000001

	16r3FFFFFFFFFFFFFFF
	16r4000000000000000
	16r4000000000000001
	16r7FFFFFFFFFFFFFFF
	16r8000000000000000
	16r8000000000000001
	16rFFFFFFFFFFFFFFFF
	16r10000000000000000
	16r10000000000000001

	16r3FFFFFFFFFFFFFFFFF
	16r400000000000000000
	16r400000000000000001
	16r7FFFFFFFFFFFFFFFFF
	16r800000000000000000
	16r800000000000000001
	16rFFFFFFFFFFFFFFFFFF
	16r1000000000000000000
	16r1000000000000000001

	16r3FFFFFFFFFFFFFFFFFFF     "/ largest SmallInt on 64bit machines
	16r40000000000000000000     "/ smallest SmallInt on 64bit machines
	16r40000000000000000001
	16r7FFFFFFFFFFFFFFFFFFF     "/ largest FullInt on 64bit machines
	16r80000000000000000000
	16r80000000000000000001
	16rFFFFFFFFFFFFFFFFFFFF     "/ largest unsigned FullInt on 64bit machines
	16r100000000000000000000
	16r100000000000000000001

	16r3FFFFFFFFFFFFFFFFFFFF
	16r400000000000000000000
	16r400000000000000000001
	16r7FFFFFFFFFFFFFFFFFFFF
	16r800000000000000000000
	16r800000000000000000001
	16rFFFFFFFFFFFFFFFFFFFFF
	16r1000000000000000000000
	16r1000000000000000000001

	16r7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	16r80000000000000000000000000000000000000
	16rFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    ).

    nums do:[:written |
	|bytes read|

	bytes := written binaryStoreBytes.
	verbose ifTrue:[
	    Transcript show:written.
	    Transcript show:' -> '.
	    Transcript showCR:bytes.
	].
	read := Object fromBinaryStoreBytes:bytes.
	self assert:(read = written).
    ].

    nums do:[:written |
	|bytes read|

	bytes := written negated binaryStoreBytes.
	verbose ifTrue:[
	    Transcript show:written.
	    Transcript show:' -> '.
	    Transcript showCR:bytes.
	].
	read := Object fromBinaryStoreBytes:bytes.
	self assert:(read = written negated).
    ].

    nums do:[:written |
	written storeBinaryOn:outStream.
	written negated storeBinaryOn:outStream.
    ].

    bytes := outStream contents.
    inStream := BinaryInputManager on:(bytes readStream).

    nums do:[:expected | |read|
	read := inStream nextObject.
	self assert:( read = expected).

	read := inStream nextObject.
	self assert:( read = expected negated).

    ].

    "/ some very big numbers...
    #( 10 20 30 50 100) do:[:n |
	|written read|

	bytes := (written := n factorial) binaryStoreBytes.
	verbose ifTrue:[
	    Transcript show:written.
	    Transcript show:' -> '.
	    Transcript showCR:bytes.
	].
	read := Object fromBinaryStoreBytes:bytes.
	self assert:(read = written).

	bytes := (written := n factorial negated) binaryStoreBytes.
	verbose ifTrue:[
	    Transcript show:written.
	    Transcript show:' -> '.
	    Transcript showCR:bytes.
	].
	read := Object fromBinaryStoreBytes:bytes.
	self assert:(read = written).
    ].

    "
     self run:#testIntegers1
     self new testIntegers1
    "

    "Modified: / 10-01-2012 / 19:23:44 / cg"
!

testNumbers1
    |floats fractions nums outStream bytes inStream verbose|

    verbose := false.

    outStream := ByteArray new writeStream.

    floats := #(
	0.0
	1.0
	2.0
	1.23456
	1e17
    ).
    fractions := {
	(1/2) .
	(3/17) .
	(1234567890123456789/17) .
	(12345678901234567890123456789/17) .
	(17/1234567890123456789) .
	(17/12345678901234567890123456789) .
	(1234567890123456788/1234567890123456789) .
	(12345678901234567890123456788/12345678901234567890123456789) .
    }.
    nums := floats , fractions.

    nums do:[:written |
	|bytes read|

	bytes := written binaryStoreBytes.
	verbose ifTrue:[
	    Transcript show:written.
	    Transcript show:' -> '.
	    Transcript showCR:bytes.
	].
	read := Object fromBinaryStoreBytes:bytes.
	self assert:(read = written).
    ].

    nums do:[:written |
	|bytes read|

	bytes := written negated binaryStoreBytes.
	verbose ifTrue:[
	    Transcript show:written.
	    Transcript show:' -> '.
	    Transcript showCR:bytes.
	].
	read := Object fromBinaryStoreBytes:bytes.
	self assert:(read = written negated).
    ].

    nums do:[:written |
	written storeBinaryOn:outStream.
	written negated storeBinaryOn:outStream.
    ].

    bytes := outStream contents.
    inStream := BinaryInputManager on:(bytes readStream).

    nums do:[:expected | |read|
	read := inStream nextObject.
	self assert:( read = expected).

	read := inStream nextObject.
	self assert:( read = expected negated).

    ].

    "
     self run:#testNumbers1
     self new testNumbers1
    "
!

testNumbers1_differentFormat
    "BOSS, formatVersion2 had a bug in always storing floats & doubles in
     native byte order.
     This has been changed in formatVersion3, to MSB (which is the expected behavior).
     To read old-style BOSS objects, the usedFormat an be explicitly set..."

    |manager outStream bytes objectInStream verbose written read tmpBytes|

    verbose := false.
    outStream := ByteArray new writeStream.

    "/ write in old format
    manager := BinaryOutputManager new.
    manager usedFormat:2.
    manager store:(written := 1.2345) on:outStream.

    bytes := outStream contents.

    "/ read in old format
    objectInStream := BinaryInputManager on:(bytes readStream).
    objectInStream usedFormat:2.
    read := objectInStream nextObject.

    self assert:(read = written).

    "/ write in old format
    manager := BinaryOutputManager new.
    manager usedFormat:2.
    manager store:(written := 1.2345) on:outStream.

    bytes := outStream contents.

    "/ read in new format
    objectInStream := BinaryInputManager on:(bytes readStream).
    objectInStream usedFormat:3.
    read := objectInStream nextObject.

    UninterpretedBytes isBigEndian ifTrue:[
	self assert:(read = written).
    ] ifFalse:[
	"/ expect wrong values!!
	self assert:(read ~= written).
	"/ in wrong byte order
	tmpBytes := ByteArray new:8.
	tmpBytes doubleAt:1 put:read.
	tmpBytes reverse.
	self assert:(tmpBytes doubleAt:1) = written.
    ].

    "
     self run:#testNumbers1_differentFormat
     self new testNumbers1_differentFormat
    "
!

testOrderedCollection1
    |o rw|

    rw := [:obj |
	|read outStream inStream|

	outStream := ByteArray new writeStream.

	obj storeBinaryOn:outStream.

	inStream := BinaryInputManager on:(outStream contents readStream).
	read := inStream nextObject.
	self assert:( read = obj).
    ].

    o := OrderedCollection new.
    rw value:o.

    o add:1.
    rw value:o.

    o add:2.
    rw value:o.

    o add:#().
    rw value:o.

    o add:#(1 2 3).
    rw value:o.

    "
     self run:#testOrderedCollection1
     self new testOrderedCollection1
    "
!

testSaveReadBOS

    |objStored childStored childrenStored objLoaded childrenLoaded childLoaded
     fn bos privateClass didConvert verbose|

    verbose := false.
    "/ verbose := true.

    Class withoutUpdatingChangesDo:[
	HierarchicalItem subclass:#XHierarchicalItem
	    instanceVariableNames:''
	    classVariableNames:''
	    poolDictionaries:''
	    category:'Views-Support'.

	privateClass := Smalltalk at:#XHierarchicalItem.
    ].

    objStored := privateClass  new.
    childStored := privateClass new.
    objStored add: childStored.
    childStored instVarNamed:#width put:privateClass.

    self assert:(objStored hasChildren).
    self assert:(objStored children size == 1).
    self assert:(objStored children first == childStored).

    "/ fn := '/tmp/HI' asFilename.
    fn := Filename newTemporary.
    bos :=  BinaryObjectStorage onNew: (fn writeStream).
    bos nextPut: objStored.

    verbose ifTrue:[
	Transcript showCR:'object saved:'.
	"/ obj inspect.
	ObjectMemory dumpObject:objStored.
    ].
    bos close.

    didConvert := false.

    "/ now, change the class (stored object is old)
    Class withoutUpdatingChangesDo:[
	verbose ifTrue:[
	    Transcript showCR:'changing the class (add a slot)...'.
	].
	privateClass addInstVarName:'foo'.
	verbose ifTrue:[
	    Transcript showCR:'done.'.
	].
    ].

    bos := BinaryObjectStorage onOld: fn readStream.
    BinaryIOManager requestConversionSignal handle:[:ex|
	| oldObject newClass |

	newClass := ex parameter key.
	oldObject := ex parameter value.
	verbose ifTrue:[
	    Transcript showCR: 'converting...'.
	].
	didConvert := true.
	ex proceedWith: (newClass cloneFrom: oldObject).
    ] do:[
	BinaryIOManager invalidClassSignal handle:[:ex2|
	    | oldClass newClass proceedClass |

	    newClass := Smalltalk at: ex2 parameter name asSymbol.
	    oldClass := ex2 parameter.

	    verbose ifTrue:[
		Transcript showCR: 'will convert instance of ',oldClass name.
	    ].
	    proceedClass :=(((newClass isSubclassOf: HierarchicalItem) or:[newClass == HierarchicalItem]) ifTrue:[newClass] ifFalse:[oldClass]).
	    ex2 proceedWith: proceedClass.
	] do:[
	    objLoaded := bos next.
	    verbose ifTrue:[
		"/ obj inspect.
		Transcript showCR:'object restored (new class):'.
		ObjectMemory dumpObject:objLoaded.
	    ].
	].
    ].

    self assert:(didConvert).
    self assert:(objLoaded class instSize == (HierarchicalItem instSize + 1)).

    self assert:(objLoaded hasChildren).
    self assert:(objLoaded children size == 1).
    self assert:(objLoaded children == (objLoaded instVarNamed:#children) ).

    "Created: / 26-09-2007 / 18:21:11 / cg"
    "Modified: / 07-08-2011 / 15:29:35 / cg"
!

testStrings1
    |objs outStream inStream|

    outStream := ByteArray new writeStream.

    objs := #(
	''
	'1'
	'12'
	'123'
	"/        1         2         3         4         5         6         7         8         9         0         1         2
	'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678'

	"/        1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
	'123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345'

	"/        1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
	'1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456'

	"/        1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
	'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567'
    ).

    objs do:[:written |
	written storeBinaryOn:outStream.
    ].


    inStream := BinaryInputManager on:(outStream contents readStream).

    objs do:[:expected | |read|
	read := inStream nextObject.
	self assert:( read = expected).
    ].

    "
     self run:#testStrings1
     self new testStrings1
    "
!

testStrings2
    |outStream inStream test|

    test := [:obj |
	|written read|

	outStream := ByteArray new writeStream.
	written := obj.
	written storeBinaryOn:outStream.

	inStream := BinaryInputManager on:(outStream contents readStream).

	read := inStream nextObject.
	self assert:( read = written).
    ].

    test value:(String new:14).
    test value:(String new:15).
    test value:(String new:16).
    test value:(String new:30).
    test value:(String new:31).
    test value:(String new:32).
    test value:(String new:62).
    test value:(String new:63).
    test value:(String new:64).
    test value:(String new:65).
    test value:(String new:100).
    test value:(String new:127).
    test value:(String new:128).
    test value:(String new:129).
    test value:(String new:254).
    test value:(String new:255).
    test value:(String new:256).
    test value:(String new:257).
    test value:(String new:1000).
    test value:(String new:10000).
    test value:(String new:100000).
    test value:(String new:1000000).
    test value:(String new:10000000).

    test value:(ImmutableString new:1000).


    "
     self run:#testStrings2
     self new testStrings2
    "
!

test_store_retrieve_string_and_array_01
    |original retrieved hello inStream outStream|

    hello := 'hello'.
    original := Array with:hello with:hello.

    [
	outStream := 'data.bos' asFilename writeStream binary.
	original storeBinaryOn:outStream.
	outStream close.

	inStream := 'data.bos' asFilename readStream binary.
	retrieved := Object readBinaryFrom:inStream.
	inStream close.
    ] ensure:[
	'data.bos' asFilename delete
    ].

    self assert:( (original at:1) == (original at:2) ).         "must be identical"
    self assert:( (retrieved at:1) == (retrieved at:2) ).       "must be identical"

    "
     self new test01_store_retrieve_string_and_array_01
    "
! !

!BinaryIOTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

