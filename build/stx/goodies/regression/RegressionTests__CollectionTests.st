"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CollectionTests
	instanceVariableNames:'empty nonEmpty'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!

Object subclass:#SortTestData
	instanceVariableNames:'value order'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CollectionTests
!

!CollectionTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

coveredClasses
    ^ Collection withAllSubclasses
!

documentation
"
    documentation to be added.

    [author:]
	Claus Gittinger (cg@alan)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

history
    "Created: / 8.11.2001 / 08:17:09 / cg"
! !

!CollectionTests methodsFor:'helpers'!

checkSorted:aSortedCollection with:sortBlock against:anOriginalCollection
    |first|

    self assert:aSortedCollection size = anOriginalCollection size.

    "is it sorted?"
    first := true.
    aSortedCollection inject:nil into:[:last :each|
	    first ifTrue:[first := false]
		  ifFalse:[self assert:(sortBlock value:last value:each)]. each].

    "same elements as in original?"
    self assert:(aSortedCollection asBag = anOriginalCollection asBag).
!

collectedDoArgsOf:aCollection
    |collectedDoArgs|

    collectedDoArgs := OrderedCollection new.
    aCollection do:[:each | collectedDoArgs add:each].
    ^ collectedDoArgs
! !

!CollectionTests methodsFor:'initialize-release'!

setUp
	empty := Set new.
	nonEmpty := OrderedCollection with: #x.
! !

!CollectionTests methodsFor:'tests-byteArray'!

testByteArrayReverse
     1 to:1024 do:[:i|
	|bytes test rBytes|

	bytes := ((1 to:i) asArray collect:[:i | i bitAnd:255]) asByteArray.
	test := ((i to:1 by:-1) asArray collect:[:i | i bitAnd:255]) asByteArray.
	rBytes := bytes copy.
	self assert:(rBytes reverse = test).

	rBytes := bytes copy.
	self assert:(rBytes reverse reverse = bytes).
     ].
!

testByteArrayReversed
     1 to:1024 do:[:i|
	|bytes test rBytes|

	bytes := ((1 to:i) asArray collect:[:i | i bitAnd:255]) asByteArray.
	test := ((i to:1 by:-1) asArray collect:[:i | i bitAnd:255]) asByteArray.
	self assert:(bytes reversed = test).

	self assert:(bytes reversed reversed = bytes).
     ].
! !

!CollectionTests methodsFor:'tests-dictionary'!

testDictionary01
    |d v1 v2 v3 ret|

    d := Dictionary new.
    d at:1 put:(v1 := 'one').
    d at:2 put:(v2 := 'two').
    d at:3 put:(v3 := 'three').

    self assert: ( d size == 3 ).

    self assert:(ret := self collectedDoArgsOf:d) asSet = #('one' 'two' 'three') asSet.
    self assert:(ret := d collect:[:each | each]) = #('one' 'two' 'three') asBag.
    self assert:(ret := d select:[:each | true]) = (Dictionary withAssociations:(Array with:(1->'one') with:(2->'two') with:(3->'three'))).

    self assert: ( (d at:1) == v1 ).
    self assert: ( (d at:2) == v2 ).
    self assert: ( (d at:3) == v3 ).

    d at:3 put:(v3 := 'drei').

    self assert: ( d size == 3 ).

    self assert: ( (d at:1) == v1 ).
    self assert: ( (d at:2) == v2 ).
    self assert: ( (d at:3) == v3 ).

    self assert: ( (d keyAtValue:v1) = 1 ).

    "
     self basicNew testDictionary01
    "

    "Modified: / 04-07-2011 / 19:28:39 / cg"
! !

!CollectionTests methodsFor:'tests-general'!

doTestDictionaryLikeAddRemoveOperationsIn:aClass
    |coll|

    coll := aClass new.

    self assert: ( coll size == 0 ).
    self assert: ( coll isEmpty ).
    self assert: ( coll notEmpty not ).
    self assert: ( coll isEmptyOrNil ).
    self assert: ( coll notEmptyOrNil not ).

    coll at:1 put:'one'.

    self assert: ( coll size == 1 ).
    self assert: ( coll isEmpty not).
    self assert: ( coll notEmpty ).
    self assert: ( coll isEmptyOrNil not ).
    self assert: ( coll notEmptyOrNil ).

    coll at:2 put:'two'.

    self assert: ( coll size == 2 ).
    self assert: ( coll isEmpty not).
    self assert: ( coll notEmpty ).
    self assert: ( coll isEmptyOrNil not ).
    self assert: ( coll notEmptyOrNil ).

    coll removeKey:2.
    self assert: ( coll size == 1 ).
    self assert: ( coll isEmpty not).
    self assert: ( coll notEmpty ).
    self assert: ( coll isEmptyOrNil not ).
    self assert: ( coll notEmptyOrNil ).

    coll removeKey:1.
    self assert: ( coll size == 0 ).
    self assert: ( coll isEmpty ).
    self assert: ( coll notEmpty not ).
    self assert: ( coll isEmptyOrNil ).
    self assert: ( coll notEmptyOrNil not ).

    "
     self basicNew doTestDictionaryLikeAddRemoveOperations
    "

    "Created: / 08-08-2011 / 16:01:14 / cg"
!

doTestGeneralAddRemoveOperationsIn:aClass
    |coll|

    coll := aClass new.

    self assert: ( coll size == 0 ).
    self assert: ( coll isEmpty ).
    self assert: ( coll notEmpty not ).
    self assert: ( coll isEmptyOrNil ).
    self assert: ( coll notEmptyOrNil not ).

    coll add:1.

    self assert: ( coll size == 1 ).
    self assert: ( coll isEmpty not).
    self assert: ( coll notEmpty ).
    self assert: ( coll isEmptyOrNil not ).
    self assert: ( coll notEmptyOrNil ).

    coll add:2.

    self assert: ( coll size == 2 ).
    self assert: ( coll isEmpty not).
    self assert: ( coll notEmpty ).
    self assert: ( coll isEmptyOrNil not ).
    self assert: ( coll notEmptyOrNil ).

    coll remove:2.
    self assert: ( coll size == 1 ).
    self assert: ( coll isEmpty not).
    self assert: ( coll notEmpty ).
    self assert: ( coll isEmptyOrNil not ).
    self assert: ( coll notEmptyOrNil ).

    coll remove:1.
    self assert: ( coll size == 0 ).
    self assert: ( coll isEmpty ).
    self assert: ( coll notEmpty not ).
    self assert: ( coll isEmptyOrNil ).
    self assert: ( coll notEmptyOrNil not ).

    "
     self basicNew testGeneralOperations
    "

    "Created: / 08-08-2011 / 16:00:06 / cg"
!

doTestGeneralCollectionOperationsIn:aClass
    |coll|

    coll := aClass new.

    self assert: ( coll size == 0 ).
    self assert: ( coll isEmpty ).
    self assert: ( coll notEmpty not ).
    self assert: ( coll isEmptyOrNil ).
    self assert: ( coll notEmptyOrNil not ).

    self should: [ coll first ] raise:Error.
    self should: [ coll last ] raise:Error.
    self should: [ (coll at:1) ] raise:Error.

    self assert: ( (coll includes:0) not ).

    "
     self basicNew testGeneralOperations
    "
!

doTestSequentialCollectionOperationsIn:aClass
    |coll1 coll2|

    coll1 := self protoCollectionFor: aClass.

    self assert: ( coll1 size > 0 ).
    self assert: ( coll1 isEmpty not ).
    self assert: ( coll1 notEmpty ).
    self assert: ( coll1 isEmptyOrNil not ).
    self assert: ( coll1 notEmptyOrNil ).

    self assert: ( coll1 first = (coll1 at:1) ).
    self assert: ( coll1 last = (coll1 at:(coll1 size)) ).

    self assert: ( coll1 = coll1 ).
    self assert: ( coll1 ~= coll1 ) not.
    coll2 := coll1 copy.
    self assert: (coll1 size == coll2 size).
    1 to:coll1 size do:[:i |
	"/ coll1 at:10
	"/ coll2 at:10
	self assert:(coll1 at:i) = (coll2 at:i).
    ].
    self assert: ( coll2 = coll1 ).

    coll2 replaceFrom:1 to:coll2 size with:coll1 startingAt:1.
    self assert: ( coll2 = coll1 ).

    "overlapping copy"
    coll2 replaceFrom:2 to:coll2 size with:coll2 startingAt:1.
    coll2 replaceFrom:1 to:coll2 size-1 with:coll2 startingAt:2.
    coll2 at:(coll2 size) put:(coll1 at:coll1 size).
    self assert: ( coll2 = coll1 ).

    "
     self basicNew testSequentialCollectionOperations
    "

    "Created: / 08-05-2012 / 10:50:08 / cg"
!

protoCollectionFor: aClass
    aClass == BooleanArray ifTrue: [
	^ BooleanArray withAll:#(true false true true false false true false false true)
    ].
    aClass == BitArray ifTrue: [
	^ BitArray withAll:#(1 0 1 1 0 0 1 0 0 1)
    ].
    aClass == ByteArray ifTrue: [
	^ ByteArray withAll:#(1 2 3 4 16rFC 16rFD 16rFE 16rFF)
    ].
    aClass == String ifTrue: [
	^ 'abcdefghijklmnopqrstuvwxyz'
    ].
    (aClass includesBehavior:CharacterArray) ifTrue:[
	^ 'abcdefghijklmnopqrstuvwxyz' as: aClass
    ].
    (aClass includesBehavior:AbstractNumberVector) ifTrue:[
	(aClass includesBehavior:UnboxedIntegerArray) ifTrue:[
	    ^ #(1 2 3 4 5 6 7 8 9 10) as: aClass
	].
	^ #(1.0 2 3.0 4 5.0 6 7.0 8 9.0 10) as: aClass
    ].
    ^ #(1 true 2.0 false 3 nil 4.0 5 6.0 7 8.0 9 10.0) as: aClass

    "
     self basicNew testSequentialCollectionOperations
    "

    "Created: / 08-05-2012 / 10:50:50 / cg"
!

testDictionaryLikeAddRemoveOperations
    |classes|

    classes := OrderedCollection new.
    classes
	add:Dictionary;
	add:IdentityDictionary;
	add:OrderedDictionary;
	add:BTree.

    classes do:[:eachClass |
	self doTestDictionaryLikeAddRemoveOperationsIn:eachClass
    ].

    "
     self basicNew testDictionaryLikeAddRemoveOperations
    "

    "Created: / 08-08-2011 / 15:59:52 / cg"
!

testGeneralAddRemoveOperations
    |classes|

    classes := OrderedCollection new.
    classes
	"/ add:RunArray;
	add:Bag;
	add:Set;
	add:IdentitySet;
	"/add:Dictionary;
	"/add:IdentityDictionary;
	add:OrderedCollection;
	add:SortedCollection;
	"/add:Queue;
	"/add:Stack;
	add:SortedCollection;
	"/add:OrderedDictionary;
	add:OrderedSet.
	"/add:BTree.

    classes do:[:eachClass |
	self doTestGeneralAddRemoveOperationsIn:eachClass
    ].

    "
     self basicNew testGeneralAddRemoveOperations
    "

    "Created: / 08-08-2011 / 15:59:02 / cg"
!

testGeneralOperations
    |classes|

    classes := OrderedCollection new.
    classes
	add:RunArray;
	add:Bag;
	add:Set;
	add:IdentitySet;
	add:Dictionary;
	add:IdentityDictionary;
	add:OrderedCollection;
	add:SortedCollection;
	add:Queue;
	add:Stack;
	add:SortedCollection;
	add:OrderedDictionary;
	add:OrderedSet;
	add:BTree.

    classes do:[:eachClass |
	self doTestGeneralCollectionOperationsIn:eachClass
    ].

    "
     self basicNew testGeneralOperations
    "

    "Modified: / 08-08-2011 / 15:53:16 / cg"
!

testSequentialCollectionOperations
    |classes|

    classes := OrderedCollection new.
    classes
	add:OrderedCollection;
	add:Array;
	add:String;
	add:ByteArray;
	add:WordArray;
	add:IntegerArray;
	add:LongIntegerArray;
	add:SignedWordArray;
	add:SignedIntegerArray;
	add:SignedLongIntegerArray;
	add:FloatArray;
	add:DoubleArray;
	add:HalfFloatArray;
	add:TwoByteString;
	add:Unicode16String;
	add:Unicode32String;
	add:BooleanArray;
	add:BitArray.

    classes do:[:eachClass |
	self doTestSequentialCollectionOperationsIn:eachClass
    ].

    "
     self basicNew testSequentialCollectionOperations
    "

    "Created: / 08-05-2012 / 10:48:40 / cg"
!

testSpecialArrayClasses
    |a|

    a := #(1 2 3 4 5) asWordArray.
    self assert:(a at:1) == 1.
    self assert:(a at:a size) == 5.
    self assert:(a first) == 1.
    self assert:(a last) == 5.

    a := #(1 2 3 4 5) asIntegerArray.
    self assert:(a at:1) == 1.
    self assert:(a at:a size) == 5.
    self assert:(a first) == 1.
    self assert:(a last) == 5.

    a := #(1 2 3 4 5) asLongIntegerArray.
    self assert:(a at:1) == 1.
    self assert:(a at:a size) == 5.
    self assert:(a first) == 1.
    self assert:(a last) == 5.

    "
     self basicNew testSpecialArrayClasses
    "

    "Created: / 08-05-2012 / 10:48:40 / cg"
!

testSpecialArrayClasses2
    |a|

    a := #(1 2 3 4 5) asFloatArray.
    self assert:(a at:1) = 1.0.
    self assert:(a at:a size) = 5.0.
    self assert:(a first) = 1.0.
    self assert:(a last) = 5.0.

    a := #(1 2 3 4 5) asDoubleArray.
    self assert:(a at:1) = 1.0.
    self assert:(a at:a size) = 5.0.
    self assert:(a first) = 1.0.
    self assert:(a last) = 5.0.

    a := #(1 2 3 4 5) asHalfFloatArray.
    self assert:(a at:1) = 1.0.
    self assert:(a at:a size) = 5.0.
    self assert:(a first) = 1.0.
    self assert:(a last) = 5.0.

    "
     self basicNew testSpecialArrayClasses2
    "

    "Created: / 08-05-2012 / 10:48:40 / cg"
! !

!CollectionTests methodsFor:'tests-interval'!

testInterval01
    |i1 i2 enumeratedValues|

    i1 := 1 to:10.

    self assert: ( i1 size == 10 ).

    self assert: ( i1 includes:1 ).
    self assert: ( i1 includes:10 ).

    self assert: ( i1 min == 1 ).
    self assert: ( i1 max == 10 ).

    "cannot add/remove"
    self should:[i1 add:99] raise:Error.
    self should:[i1 remove:10] raise:Error.

    i2 := 2 to:20 by:2.
    self assert: ( i2 size == 10 ).

    self assert: ( i2 includes:0 ) not.
    self assert: ( i2 includes:1 ) not.
    self assert: ( i2 includes:2 ).
    self assert: ( i2 includes:3 ) not.
    self assert: ( i2 includes:10 ).
    self assert: ( i2 includes:19 ) not.
    self assert: ( i2 includes:20 ).
    self assert: ( i2 includes:21 ) not.
    self assert: ( i2 includes:22 ) not.

    self assert: ( i2 min == 2 ).
    self assert: ( i2 max == 20 ).

    self assert: ( i2 keys asArray = (1 to:10) asArray ).

    enumeratedValues := OrderedCollection new.
    i1 do:[:each | enumeratedValues add:each ].
    self assert:(enumeratedValues size == 10).
    self assert:(enumeratedValues asArray = #(1 2 3 4 5 6 7 8 9 10)).

    enumeratedValues := OrderedCollection new.
    i2 do:[:each | enumeratedValues add:each ].
    self assert:(enumeratedValues size == 10).
    self assert:(enumeratedValues asArray = #(2 4 6 8 10 12 14 16 18 20)).

    self assert: (i1 collect:[:el | el even]) asArray = #(false true false true false true false true false true).
    self assert: (i2 collect:[:el | el even]) asArray = #(true true true true true true true true true true).

    "
     self basicNew testInterval01
    "

    "Modified: / 03-05-2012 / 18:36:41 / cg"
! !

!CollectionTests methodsFor:'tests-orderedCollection'!

testMergeSortStability01
    "Verify that the sort is stable"

    | testData lastTestData errs  col|

    testData := OrderedCollection new.
    testData addAll: ((100 to: 1 by: -1) collect: [ :n | SortTestData new value: n ]).
    testData addAll: ((100 to: 1 by: -1) collect: [ :n | SortTestData new value: n ]).
    testData addAll: ((100 to: 1 by: -1) collect: [ :n | SortTestData new value: n ]).
    testData keysAndValuesDo:[:idx :each| each order: idx ].

    col := testData copy.
    col mergeSort:[:v1 :v2 | v1 value < v2 value ].
    self checkSorted:col with:[:v1 :v2 | v1 value <= v2 value ] against:testData.

    lastTestData := nil.

    errs := col inject: 0 into:
	    [ :totIn :aSortTestData | |totOut|
	    totOut := totIn.
	    lastTestData notNil ifTrue:
		    [ lastTestData value = aSortTestData value ifTrue:
			    [ lastTestData order > aSortTestData order ifTrue: [ totOut := totOut + 1 ] ] ].
	    lastTestData := aSortTestData.
	    totOut ].
    self should: [ errs = 0 ]

    "
     self basicNew testMergeSortStability01
    "
!

testOrderedCollection01_Sort1
    |col col2|

    col := #( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ) copy.
    col sort.
    self assert:( col sameContentsAs: (1 to:20)).

    col := #( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ) copy reverse.
    col sort.
    self assert:( col sameContentsAs: (1 to:20) ).

    col := #( 10 2 13 4 15 6 17 8 19 11 1 12 3 14 5 16 7 18 9 20 ) copy.
    col sort.
    self assert:( col sameContentsAs: (1 to:20) ).

    col := ( 1 to: 10000 ) asOrderedCollection.
    col sort.
    self assert:( col sameContentsAs: (1 to:10000) ).

    col := ( 1 to: 10000 ) asOrderedCollection.
    col2 := ( 1 to: 10000 ) asOrderedCollection.
    col sortWith:col2.
    self assert:( col sameContentsAs: (1 to:10000) ).
    self assert:( col2 sameContentsAs: (1 to:10000) ).

    col := ( 10000 to: 1 by:-1) asOrderedCollection.
    col2 := ( 10000 to: 1 by:-1) asOrderedCollection.
    col sortWith:col2.
    self assert:( col sameContentsAs: (1 to:10000) ).
    self assert:( col2 sameContentsAs: (1 to:10000) ).

    "
     self new testOrderedCollection01_Sort1
    "

    "Modified: / 04-07-2011 / 19:29:54 / cg"
!

testOrderedCollection02_SortBigCollection
    | size col sortBlock|

    size := 12500.
    col := OrderedCollection new.
    1 to:size do:[:el|
	col add:nil.
    ].
    sortBlock := [:entry1 :entry2 |
	((entry1 isNil) or:[entry2 isNil]) ifTrue:[
	    true
	] ifFalse:[
	    false
	]
    ].
    self shouldnt:[col sort:sortBlock] raise:RecursionInterruptSignal.

    "
     self new testOrderedCollection02_SortBigCollection
    "
!

testOrderedCollection03_SortBigCollection2
    | size col|

    size := 12500.
    col := OrderedCollection new.
    1 to:size do:[:el|
	col add:'abc'.
    ].
    self shouldnt:[col sort] raise:RecursionInterruptSignal.

    "
     self new testOrderedCollection03_SortBigCollection2
    "
!

testOrderedCollection04_SortNilsInCollection
    | size col sortBlock|

    size := 125.
    col := OrderedCollection new.
    1 to:size do:[:el|
	col add:nil.
    ].
    sortBlock := [:entry1 :entry2 |
	((entry1 isNil) or:[entry2 isNil]) ifTrue:[
	    true
	] ifFalse:[
	    false
	]
    ].
    "/ col sort:sortBlock.
    self shouldnt:[col sort:sortBlock] raise:RecursionInterruptSignal.

    "
     self new testOrderedCollection04_SortNilsInCollection
    "
!

testOrderedCollection05_SortRandomCollection
     |data sorted rg coData checkBlock|

     checkBlock := [:a :b| a <= b].
     rg := Random new.

     #(1 4 11 2000 20011 200000) do:[:eachSize|
	 data := Array new:eachSize.
	 1 to:data size do:[:i |
	    data at:i put:(rg nextIntegerBetween:1 and:100).
	 ].
	 sorted := data copy sort.
	 self checkSorted:sorted with:checkBlock against:data.
	 sorted := sorted sort.
	 self checkSorted:sorted with:checkBlock against:data.
	 sorted := sorted reverse sort.
	 self checkSorted:sorted with:checkBlock against:data.

	 coData := data copy.
	 sorted := data copy sortWith:coData.
	 self checkSorted:sorted with:checkBlock against:data.
	 self checkSorted:coData with:checkBlock against:data.

"/ Policy is not yet supported (without libcompat)
"/         sorted := data copy sort:[:policy :a :b| a < b].
"/         self checkSorted:sorted with:checkBlock against:data.

	 sorted := data copy sort:[:a :b| a < b].
	 self checkSorted:sorted with:checkBlock against:data.

	 coData := data copy.
	 sorted := data copy sort:[:a :b| a < b] with:coData.
	 self checkSorted:sorted with:checkBlock against:data.
	 self checkSorted:coData with:checkBlock against:data.
    ].
!

testOrderedCollection06_MergeSortRandomCollection
     |data sorted rg checkBlock|

     checkBlock := [:a :b| a <= b].
     rg := Random new.

     #(1 4 11 2000 20011 200000) do:[:eachSize|
	 data := Array new:eachSize.
	 1 to:data size do:[:i |
	    data at:i put:(rg nextIntegerBetween:1 and:100).
	 ].
	 sorted := data copy mergeSort.
	 self checkSorted:sorted with:checkBlock against:data.
	 sorted := sorted mergeSort.
	 self checkSorted:sorted with:checkBlock against:data.
	 sorted := sorted reverse mergeSort.
	 self checkSorted:sorted with:checkBlock against:data.

	 sorted := data copy mergeSort:[:a :b| a < b].
	 self checkSorted:sorted with:checkBlock against:data.
    ].
!

testOrderedCollection07_HeapSortRandomCollection
     |data sorted rg checkBlock|

     checkBlock := [:a :b| a <= b].
     rg := Random new.

     #(1 4 11 2000 20011 200000) do:[:eachSize|
	 data := Array new:eachSize.
	 1 to:data size do:[:i |
	    data at:i put:(rg nextIntegerBetween:1 and:100).
	 ].
	 sorted := data copy heapSort.
	 self checkSorted:sorted with:checkBlock against:data.
	 sorted := sorted heapSort.
	 self checkSorted:sorted with:checkBlock against:data.
	 sorted := sorted reverse heapSort.
	 self checkSorted:sorted with:checkBlock against:data.

	 sorted := data copy heapSort:[:a :b| a < b].
	 self checkSorted:sorted with:checkBlock against:data.
    ].
!

testOrderedCollection08_addBefore
    |col|

    col := #( 1 2 3 4 5 ) asOrderedCollection.
    col add:0 beforeIndex:1.
    self assert:(col asArray = #(0 1 2 3 4 5)).

    col := OrderedCollection new.
    col add:10.
    col add:0 beforeIndex:1.
    self assert:(col asArray = #(0 10)).

    col := OrderedCollection with:10.
    col add:0 beforeIndex:1.
    self assert:(col asArray = #(0 10)).

    col := OrderedCollection new:1.
    col add:10.
    self assert:(col size == 1).
    self assert:(col asArray = #(10)).
    self assert:(col instVarNamed:'firstIndex') == 1.
    self assert:(col instVarNamed:'lastIndex') == 1.

    col add:0 beforeIndex:1.
    self assert:(col size == 2).
    self assert:(col instVarNamed:'firstIndex') == 1.
    self assert:(col instVarNamed:'lastIndex') == 2.
    self assert:(col asArray = #(0 10)).
    "
     self new testOrderedCollection08_addBefore
    "
!

testOrderedCollection09_addAllBefore
    |col|

    col := #( 1 2 3 4 5 ) asOrderedCollection.
    col addAll:#(-2 -1 0) beforeIndex:1.
    self assert:(col asArray = #(-2 -1 0 1 2 3 4 5)).

    col := OrderedCollection new:1.
    col add:10.

    col addAll:#(-2 -1 0) beforeIndex:1.
    self assert:(col size == 4).
    self assert:(col instVarNamed:'firstIndex') == 1.
    self assert:(col instVarNamed:'lastIndex') == 4.
    self assert:(col asArray = #(-2 -1 0 10)).
    "
     self new testOrderedCollection09_addAllBefore
    "
! !

!CollectionTests methodsFor:'tests-orderedDictionary'!

testOrderedDictionary01
    |d ret|

    d := OrderedDictionary new.

    self assert: ( d size == 0 ).
    self assert: ( d isEmpty ).
    self assert: ( d notEmpty not ).

    d at:'one' put:1.
    d at:'two' put:2.
    d at:'three' put:3.

    self assert: ( d size == 3 ).
    self assert: ( d isEmpty not).
    self assert: ( d notEmpty ).

    self assert:((ret := self collectedDoArgsOf:d) sameContentsAs: #(1 2 3)).

    self assert: ( (d atIndex:1) == 1 ).
    self assert: ( (d atIndex:2) == 2 ).
    self assert: ( (d atIndex:3) == 3 ).

    self assert: ( (d first) = ('one'->1) ).
    self assert: ( (d last) = ('three'->3) ).

    self assert:((ret := d collect:[:each | each]) sameContentsAs: #(1 2 3)).
    self assert:((ret := d select:[:each | true]) sameContentsAs: (OrderedDictionary withAssociations:(Array with:('one'->1) with:('two'->2) with:('three'->3)))).

    self assert: ( d includes:1 ).
    self assert: ( d includes:2 ).
    self assert: ( d includes:3 ).

    self assert: ( d includesKey:'one' ).
    self assert: ( d includesKey:'two' ).
    self assert: ( d includesKey:'three' ).

    self assert: ((ret := d removeFirst) = 1).
    self assert: ( d size == 2 ).
    self assert: ((ret := d removeLast) = 3).
    self assert: ( d size == 1 ).
    self assert: ((ret := d removeLast) = 2).
    self assert: ( d size == 0 ).
    self assert: ( d isEmpty ).
    self assert: ( d notEmpty not ).

    "
     self basicNew testOrderedDictionary01
    "

    "Modified: / 04-07-2011 / 19:32:34 / cg"
! !

!CollectionTests methodsFor:'tests-orderedSet'!

testOrderedSet01
    |s v1 v2 v3|

    s := OrderedSet new.
    s add:(v1 := 'one').
    s add:(v2 := 'two').
    s add:(v3 := 'three').

    self assert: ( s size == 3 ).
    self assert: ( (s at:1) == v1 ).
    self assert: ( (s at:2) == v2 ).
    self assert: ( (s at:3) == v3 ).

    self assert: ( s includes:v1 ).
    self assert: ( s includes:v2 ).
    self assert: ( s includes:v3 ).

    self assert: ( s includes:v1 copy).
    self assert: ( s includes:v2 copy).
    self assert: ( s includes:v3 copy).

    "already in - adding again should not change things"
    s add:v1.
    self assert: ( s size == 3 ).

    self assert: ( (s at:1) == v1 ).
    self assert: ( (s at:2) == v2 ).
    self assert: ( (s at:3) == v3 ).

    "set i.e. not identitySet - adding copy should not change things"
    s add:v1 copy.
    self assert: ( s size == 3 ).

    self assert: ( (s at:1) == v1 ).
    self assert: ( (s at:2) == v2 ).
    self assert: ( (s at:3) == v3 ).

    s remove:v1.

    self assert: ( s size == 2 ).
    self assert: ( (s at:1) == v2 ).
    self assert: ( (s at:2) == v3 ).

    self assert: ( s includes:v1 ) not.
    self assert: ( s includes:v2 ).
    self assert: ( s includes:v3 ).

    self assert: ( s includes:v1 copy) not.
    self assert: ( s includes:v2 copy).
    self assert: ( s includes:v3 copy).

    s add:v1.

    self assert: ( s size == 3 ).
    self assert: ( (s at:1) == v2 ).
    self assert: ( (s at:2) == v3 ).
    self assert: ( (s at:3) == v1 ).

    self assert: ( s includes:v1 ).
    self assert: ( s includes:v2 ).
    self assert: ( s includes:v3 ).

    self assert: ( s includes:v1 copy).
    self assert: ( s includes:v2 copy).
    self assert: ( s includes:v3 copy).

    s removeLast.

    self assert: ( s size == 2 ).
    self assert: ( (s at:1) == v2 ).
    self assert: ( (s at:2) == v3 ).

    self assert: ( s includes:v1 ) not.
    self assert: ( s includes:v2 ).
    self assert: ( s includes:v3 ).

    self assert: ( s includes:v1 copy) not.
    self assert: ( s includes:v2 copy).
    self assert: ( s includes:v3 copy).

    "
     self basicNew testOrderedSet01
    "
!

testOrderedSet02
    |col|

    col := OrderedSet new.

    col add:'a'.
    col add:'b'.
    col add:'c'.
    self assert:( col size == 3 ).
    self assert:( Array streamContents:[:s |
			col do:[:each | s nextPut:each]
		  ]
		) = #('a' 'b' 'c' ).

    "
     self new testOrderedSet02
    "
!

testOrderedSet03
    |col|

    col := OrderedSet new.

    col add:'a'.
    col add:'b'.
    col add:'c'.
    col add:'a'.
    col add:'b'.
    self assert:( col size == 3 ).
    self assert:( Array streamContents:[:s |
			col do:[:each | s nextPut:each]
		  ]
		) = #('a' 'b' 'c' ).

    "
     self new testOrderedSet03
    "
!

testOrderedSet04
    |col|

    col := OrderedSet new.

    col add:'a'.
    col addFirst:'b'.
    col addFirst:'c'.
    self assert:( col size == 3 ).
    self assert:( Array streamContents:[:s |
			col do:[:each | s nextPut:each]
		  ]
		) = #('c' 'b' 'a' ).

    "
     self new testOrderedSet04
    "
!

testOrderedSet05
    |col|

    col := OrderedSet new.

    col add:'a'.
    col addFirst:'b'.
    col addFirst:'c'.
    col add:'a'.
    col add:'b'.
    col add:'c'.
    self assert:( col size == 3 ).
    self assert:( Array streamContents:[:s |
			col do:[:each | s nextPut:each]
		  ]
		) = #('c' 'b' 'a' ).

    "
     self new testOrderedSet05
    "
! !

!CollectionTests methodsFor:'tests-reindexedCollection'!

testReindexedCollection01
    |s c c2|

    s := OrderedCollection new.
    s addAll:#('one' 'two' 'three' 'four' 'five').

    c := s from:2.

    self assert: ( c size == (s size - 1) ).
    1 to:c size do:[:i |
	self assert: ( (c at:i) == (s at:i+1) ).
    ].

    c2 := c collect:[:el |el].
    self assert:(c2 size == c size).
    self assert:(c2 = c).

    c2 := c select:[:el |true].
    self assert:(c2 size == c size).
    self assert:(c2 = c).

    c2 := c select:[:el | el startsWith:'t'].
    self assert:(c2 size == (s count:[:el | el startsWith:'t' ])).

    c2 := c reject:[:el | el startsWith:'t'].
    self assert:(c2 size == ((s copyFrom:2) count:[:el | el startsWith:'t' ])).

    s := #(1 2 3 4 5 6 7 8).
    c := s from:2.

    self assert: ( c size == (s size - 1) ).
    1 to:c size do:[:i |
	self assert: ( (c at:i) == (s at:i+1) ).
    ].

    c2 := c collect:[:el |el].
    self assert:(c2 size == c size).
    self assert:(c2 = c).
    self assert:(c2 sameContentsAs:(s copyFrom:2)).

    c2 := c select:[:el |true].
    self assert:(c2 size == c size).
    self assert:(c2 = c).
    self assert:(c2 sameContentsAs:(s copyFrom:2)).

    c2 := c select:[:el |el even].
    self assert:(c2 size == ((s copyFrom:2) select:#even) size).
    self assert:(c2 sameContentsAs:((s copyFrom:2) select:#even)).

    c2 := c reject:[:el |el even].
    self assert:(c2 size == ((s copyFrom:2) reject:#even) size).
    self assert:(c2 sameContentsAs:((s copyFrom:2) reject:#even)).

    "
     self basicNew testReindexedCollection01
    "
! !

!CollectionTests methodsFor:'tests-replace'!

testEmptyReplace
    | array1 array2 |

    array1 := Array with: 1 with: 2 with: 3 with: 4.
    array2 := Array with: 5 with: 6 with: 7.

    array1 replaceFrom:1 to:0 with:array2 startingAt:1.

    self should: [ array1 = #(1 2 3 4) ].

    "
     self new testEmptyReplace
    "
!

testTransliterating
     self assert:( 'abcdefghijkl1234567890'  copyTransliterating:'b-g' to:'B-G'   ) = 'aBCDEFGhijkl1234567890'.
     self assert:( 'abcdefghij-kl1234567890' copyTransliterating:'b\-g' to:'B+G'  ) = 'aBcdefGhij+kl1234567890'.
     self assert:( 'abcdefghijkl1234567890'  copyTransliterating:'69' to:'96'     ) = 'abcdefghijkl1234597860'  .
     self assert:( 'abcdefghijkl1234567890'  copyTransliterating:'a' to:'b'       ) = 'bbcdefghijkl1234567890'   .
     self assert:( 'abcdefghijkl1234567890'  copyTransliterating:'aeiou' to:'AEIOU'    ) = 'AbcdEfghIjkl1234567890'.
     self assert:( 'abcdefghijkl1234567890'  copyTransliterating:'0-9' to:'QERTYUIOPX' ) = 'abcdefghijklERTYUIOPXQ' .

     self assert:( 'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'A' complement:false squashDuplicates:false )
		    = 'abcdefghijklAAAAAAAAAA'.

     self assert:( 'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'A' complement:false squashDuplicates:true )
		    = 'abcdefghijklA'.

     self assert:( 'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'*' complement:false squashDuplicates:false )
		    = 'abcdefghijkl**********'.

     self assert:( 'abcdefghijkl1234567890' copyTransliterating:'0-9' to:'*' complement:true squashDuplicates:false )
		    = '************1234567890'.

     self assert:( 'abcdefghijkl1234567890' copyTransliterating:'a-zA-Z' to:' ' complement:true squashDuplicates:false )
		    = 'abcdefghijkl          '.

     self assert:( 'abcdefghijkl1234567890' copyTransliterating:'a-zA-Z' to:' ' complement:false squashDuplicates:false )
		    = '            1234567890'.

     self assert:( 'abcdefghijkl1234567890abcdefghijkl' copyTransliterating:'a-zA-Z' to:'' complement:false squashDuplicates:false )
		    = '1234567890'.

     self assert:( 'abcdefghijkl1234567890abcdefghijkl' copyTransliterating:'a-zA-Z' to:'' complement:true squashDuplicates:false )
		    = 'abcdefghijklabcdefghijkl'.
! !

!CollectionTests methodsFor:'tests-searching'!

test_min_max
    |a|

    #(
	asArray
	asFloatArray
	asDoubleArray
	asHalfFloatArray
	asSignedWordArray
	asSignedIntegerArray
	asSignedLongIntegerArray
    ) do:[:converter |
	|empty|

	empty := #() perform:converter.
	self should:[ empty min ] raise:Error.
	self should:[ empty max ] raise:Error.
	self should:[ empty minMax ] raise:Error.

	#(
	    (0 0)
	    (1 1)
	    (-1 -1)
	    (0 1)
	    (1 2)
	    (-1 -0)
	    (-1 1)
	    (1 10000)
	    (1 20000)
	    (2 10000)
	    (2 20000)
	    (-1000 1000)
	    (-1000 999)
	) pairsDo:[:min :max |
	    a := (min to:max) perform:converter.
	    self assert:(a min) = min.
	    self assert:(a max) = max.
	    self assert:(a minMax) = { min. max }.

	    a := a reverse.
	    self assert:(a min) = min.
	    self assert:(a max) = max.
	    self assert:(a minMax) = { min. max }.

	    a := a randomShuffle.
	    self assert:(a min) = min.
	    self assert:(a max) = max.
	    self assert:(a minMax) = { min. max }.
	].
    ].

    #(
	asWordArray
	asIntegerArray
	asLongIntegerArray
    ) do:[:converter |
	|empty|

	empty := #() perform:converter.
	self should:[ empty min ] raise:Error.
	self should:[ empty max ] raise:Error.
	self should:[ empty minMax ] raise:Error.

	#(
	    (0 0)
	    (1 1)
	    (0 1)
	    (1 2)
	    (1 10000)
	    (1 10001)
	    (2 10000)
	    (2 10001)
	) pairsDo:[:min :max |
	    a := (min to:max) perform:converter.
	    self assert:(a min) = min.
	    self assert:(a max) = max.
	    self assert:(a minMax) = { min. max }.

	    a := a reverse.
	    self assert:(a min) = min.
	    self assert:(a max) = max.
	    self assert:(a minMax) = { min. max }.

	    a := a randomShuffle.
	    self assert:(a min) = min.
	    self assert:(a max) = max.
	    self assert:(a minMax) = { min. max }.
	].
    ].

    (Array with:Array with:OrderedCollection with:ByteArray with:WordArray with:IntegerArray)
    do:[:cls |
	a := cls withAll: #(10 20 30 40 50 60 70 80 90 100).

	self assert:(a indexOf:110) == 0.
	self assert:(a indexOf:10) == 1.
	self assert:(a indexOf:20) == 2.
	self assert:(a indexOf:30) == 3.
	self assert:(a indexOf:40) == 4.
	self assert:(a indexOf:50) == 5.
	self assert:(a indexOf:60) == 6.
	self assert:(a indexOf:70) == 7.
	self assert:(a indexOf:80) == 8.
	self assert:(a indexOf:90) == 9.
	self assert:(a indexOf:100) == 10.

	self assert:(a identityIndexOf:110) == 0.
	self assert:(a identityIndexOf:10) == 1.
	self assert:(a identityIndexOf:20) == 2.
	self assert:(a identityIndexOf:30) == 3.
	self assert:(a identityIndexOf:40) == 4.
	self assert:(a identityIndexOf:50) == 5.
	self assert:(a identityIndexOf:60) == 6.
	self assert:(a identityIndexOf:70) == 7.
	self assert:(a identityIndexOf:80) == 8.
	self assert:(a identityIndexOf:90) == 9.
	self assert:(a identityIndexOf:100) == 10.
    ].

    "Created: / 07-10-2011 / 13:11:36 / cg"
! !

!CollectionTests methodsFor:'tests-sequenceableCollection'!

testSequenceableCollection_01_splitByAnyForWhich
    
    |aString anArray stringCollection|
    aString := 'hello:world:isnt:this nice'.

    stringCollection := aString splitByAnyForWhich:[ :ch | ch = $: ].
    self assert:(stringCollection size = 4).
    self assert:(stringCollection first = 'hello').
    self assert:(stringCollection last = 'this nice').

    aString := 'h1e2l3l4o'.
    stringCollection := aString splitByAnyForWhich:[ :ch | ch isDigit ].

    self assert:(stringCollection size = 5).
    self assert:(stringCollection first = 'h').
    self assert:(stringCollection last = 'o').
    
    aString := String new.
    stringCollection do:[ :each | aString := aString, each ].
    self assert:(aString = 'hello').

    anArray := #[1 9 2 8 3 7 4 6 5 5 1 2 9] splitByAnyForWhich:[ :n | n odd ].
    self assert:(anArray size = 3 ).
    self assert:((anArray first) size = 2 ).
    self assert:((anArray last) size = 1 ).

    self assert:(((anArray first) first) even).

    "
     self new testSequenceableCollection_01_splitByAnyForWhich 
    "

    "Created: / 29-05-2018 / 12:53:31 / svestkap"
    "Modified (comment): / 29-05-2018 / 14:04:22 / svestkap"
    "Modified: / 15-07-2018 / 10:18:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CollectionTests methodsFor:'tests-sorting'!

testLargest
    | col |

    col := #(5 16 3 18 17 15 2 12 1 8 14 10 7 11 20 4 19 6 13 9).
    self assert:(col max == 20).
    self assert:(col largest:4) asArray = #(17 18 19 20).
    self assert:(col smallest:4) asArray = #(1 2 3 4).

    self assert:(col keysOfLargest:4) asArray = #(5 4 17 15).
    self assert:(col keysOfSmallest:4) asArray = #(9 7 3 16).

    "
     self basicNew testLargest
    "
!

testSort01
    | col errs last |

    col := SortedCollection new addAll: (100 to: 1 by: -1); yourself.
    last := nil.
    errs := col inject: 0 into:
	    [ :totIn :n | |totOut|

	    totOut := totIn.
	    last notNil ifTrue: [ last > n ifTrue: [ totOut := totOut + 1 ] ].
	    last := n.
	    totOut ].
    self should: [ errs = 0 ]

    "
     self basicNew testSort01
    "
!

testSortStability01
    "Verify that the sort is stable"

    | testData col lastTestData errs |

    testData := OrderedCollection new.
    testData addAll: ((111 to: 1 by: -1) collect: [ :n | SortTestData new value: n ]).
    testData addAll: ((111 to: 1 by: -1) collect: [ :n | SortTestData new value: n ]).
    testData addAll: ((111 to: 1 by: -1) collect: [ :n | SortTestData new value: n ]).
    1 to: testData size do: [ :i | (testData at: i) order: i ].

    col := SortedCollection new sortBlock:[ :v1 :v2 | v1 value < v2 value ].
    col addAll: testData.

    self checkSorted:col with:[:v1 :v2 | v1 value <= v2 value ] against:testData.

    lastTestData := nil.

    errs := col inject: 0 into:
	    [ :totIn :aSortTestData | |totOut|
	    totOut := totIn.
	    lastTestData notNil ifTrue:
		    [ lastTestData value = aSortTestData value ifTrue:
			    [ lastTestData order > aSortTestData order ifTrue: [ totOut := totOut + 1 ] ] ].
	    lastTestData := aSortTestData.
	    totOut ].
    self should: [ errs = 0 ]

    "
     self basicNew testSortStability01
    "
!

testSortStability02
    "Verify that the sort is stable"

    | testData col lastTestData errs |

    testData := OrderedCollection new.
    (25 to: 1 by: -1) do: [ :i | 1 to: 100 do: [ :j | testData add: (SortTestData new value: i ) ] ].
    1 to: testData size do: [ :i | (testData at: i) order: i ].

    col := SortedCollection new sortBlock: [ :v1 :v2 | v1 value < v2 value ].
    col addAll: testData.

    self checkSorted:col with:[:v1 :v2 | v1 value <= v2 value ] against:testData.

    lastTestData := nil.

    errs := col inject: 0 into:
	    [ :totIn :aSortTestData | |totOut|
	    totOut := totIn.
	    lastTestData notNil ifTrue:
		    [ lastTestData value = aSortTestData value ifTrue:
			    [ lastTestData order > aSortTestData order ifTrue: [ totOut := totOut + 1 ] ] ].
	    lastTestData := aSortTestData.
	    totOut ].
    self should: [ errs = 0 ]

"
 self basicNew testSortStability02
"
!

testSortedCollectionQueries
    "test a SortedCollection, where only a single attribute is used for sorting.
     #include: failed before 2015-06-24"

    |collection|

    collection := SortedCollection sortBlock:[:a :b | a key < b key ].
    $a to:$z do:[:l |
	1 to:100 do:[:i |
	    collection add:(Association key:l value:i)
	].
    ].

    "/ make startIndex > 1 and endIndex < size

    collection
	removeFirst;
	removeLast.
    collection
	keysAndValuesDo:[:eachIndex :eachElement |
	    self assert:(collection detect:[:el | el = eachElement ]) notNil.
	    self assert:(collection includes:eachElement).
	    self assert:(collection indexOf:eachElement) = eachIndex.
	    self assert:(collection occurrencesOf:eachElement) = 1.
	    self
		assert:(collection
			includes:(eachElement copy value:(eachElement value + 1000))) not.
	].
! !

!CollectionTests methodsFor:'tests-squeak'!

testIfEmptyifNotEmpty
	self assert: (empty ifEmpty: [true] ifNotEmpty: [false]).
	self assert: (nonEmpty ifEmpty: [false] ifNotEmpty: [true]).
	self assert: (nonEmpty ifEmpty: [false] ifNotEmpty: [:s | s first = #x])
!

testIfEmptyifNotEmptyDo
	self assert: (empty ifEmpty: [true] ifNotEmptyDo: [:s | false]).
	self assert: (nonEmpty ifEmpty: [false] ifNotEmptyDo: [:s | s first = #x])
!

testIfNotEmpty
	empty ifNotEmpty: [self assert: false].
	self assert: (nonEmpty ifNotEmpty: [self]) == self.
	self assert: (nonEmpty ifNotEmpty: [:s | s first]) = #x
!

testIfNotEmptyDo
	empty ifNotEmptyDo: [:s | self assert: false].
	self assert: (nonEmpty ifNotEmptyDo: [:s | s first]) = #x
!

testIfNotEmptyDoifNotEmpty
	self assert: (empty ifNotEmptyDo: [:s | false] ifEmpty: [true]).
	self assert: (nonEmpty ifNotEmptyDo: [:s | s first = #x] ifEmpty: [false])
!

testIfNotEmptyifEmpty
	self assert: (empty ifEmpty: [true] ifNotEmpty: [false]).
	self assert: (nonEmpty ifEmpty: [false] ifNotEmpty: [true]).
	self assert: (nonEmpty ifEmpty: [false] ifNotEmpty: [:s | s first = #x])
! !

!CollectionTests::SortTestData methodsFor:'accessing'!

value
	"Answer the value of the receiver's ''value'' instance variable."

	^value
!

value: anObject
	"Set the value of the receiver's ''value'' instance variable to the argument, anObject."

	value := anObject
! !

!CollectionTests::SortTestData methodsFor:'order'!

order
	"Answer the value of the receiver's ''order'' instance variable."

	^order
!

order: anObject
	"Set the value of the receiver's ''order'' instance variable to the argument, anObject."

	order := anObject
! !

!CollectionTests::SortTestData methodsFor:'printing & storing'!

printOn: aStream
	super printOn: aStream.
	aStream
		nextPutAll: '(value: ';
		nextPutAll: value printString;
		nextPutAll: ' order: ';
		nextPutAll: order printString;
		nextPut: $)
! !

!CollectionTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

