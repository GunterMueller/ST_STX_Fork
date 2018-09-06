"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Collection
	instanceVariableNames:''
	classVariableNames:'EmptyCollectionSignal InvalidKeySignal NotEnoughElementsSignal
		ValueNotFoundSignal'
	poolDictionaries:''
	category:'Collections-Abstract'
!

!Collection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Abstract superclass for all collections.
    This abstract class provides functionality common to all collections,
    without knowing how the concrete class implements things.
    Thus, all methods found here depend on some basic mechanisms
    to be defined in the concrete class.
    These basic methods are usually defined as #subclassResponsibility here.
    Some methods are also redefined for better performance.

    Subclasses should at least implement:
        do:     - enumerate elements

    they should implement one of the following set of access messages:
    For keyed collections:
        at:ifAbsent:            - fetching an element
        at:                     - fetching an element
        at:put:                 - storing an element

    For unkeyed collections:
        add:                    - add an element
        remove:ifAbsent:        - remove an element

    Given that the above is implemented in a concrete subclass,
    Collection provides protocol for enumeration, searching and others.
    However, for performance reasons, many of them are also redefined in
    concrete subclasses, as some can be implemented much faster if implementation
    details are known (for example, searching can be done faster if it is known that
    elements are sorted or accessible by a key).

    [author:]
        Claus Gittinger
"
! !

!Collection class methodsFor:'initialization'!

initialize
    "setup the signal"

    InvalidKeySignal isNil ifTrue:[
        InvalidKeySignal := Error newSignalMayProceed:true.
        InvalidKeySignal nameClass:self message:#invalidKeySignal.
        InvalidKeySignal notifierString:'invalid key:'.

        ValueNotFoundSignal := NotFoundError newSignalMayProceed:true.
        ValueNotFoundSignal nameClass:self message:#valueNotFoundSignal.
        ValueNotFoundSignal notifierString:'value not found:'.

        NotEnoughElementsSignal := NotFoundError newSignalMayProceed:true.
        NotEnoughElementsSignal nameClass:self message:#notEnoughElementsSignal.
        NotEnoughElementsSignal notifierString:'not enough elements in collection'.

        EmptyCollectionSignal := NotEnoughElementsSignal newSignalMayProceed:true.
        EmptyCollectionSignal nameClass:self message:#emptyCollectionSignal.
        EmptyCollectionSignal notifierString:'operation not allowed for empty collections'.
    ]

    "Modified: / 8.11.1997 / 19:18:17 / cg"
! !

!Collection class methodsFor:'instance creation'!

combiningEach:collection1 withEach:collection2 using:aTwoArgBlock
    "evaluate aTwoArgBlock for each combination of elements from collection1
     and collection2 and return an instance of the receiver containing all those elements"

    |newColl idx useIndex newEl|

    newColl := self new:(collection1 size * collection2 size).
    useIndex := newColl isFixedSize.
    idx := 1.
    collection1 do:[:e1 |
        collection2 do:[:e2 |
            newEl := aTwoArgBlock value:e1 value:e2.

            useIndex ifTrue:[
                newColl at:idx put:(aTwoArgBlock value:e1 value:e2).
                idx := idx + 1.
            ] ifFalse:[
                newColl add:(aTwoArgBlock value:e1 value:e2)
            ].
        ]
    ].
    ^ newColl

    "
     Set combiningEach:#(1 2 3 4 5) withEach:(10 to:100 by:10) using:[:a :b | a * b] 
     Set combiningEach:#(1 2 3 4 5) withEach:#(1 2 3 4 5) using:[:a :b | a * b] 
    "

    "Created: / 25-08-2010 / 17:21:47 / cg"
!

new:size withAll:element
    "return a new Collection of size, where all elements are
     initialized to element"

    |newCollection|

    newCollection := self new:size.
    size timesRepeat:[newCollection add:element]
!

newFrom:aCollection 
    "Return an instance of me containing the same elements as aCollection."

    ^ self withAll:aCollection

    "
     Bag newFrom:#(1 2 3 4 4 5 6 7 7 7 )  
     Set newFrom:#(1 2 3 4 4 5 6 7 7 7 ) 
    "
!

newWithSize:n
    "return a new collection which really provides space for n elements.
     Kludges around the stupid definition of OrderedCollection>>new:"

    ^ self new:n
!

with:anObject
    "return a new Collection with one element:anObject"

    |newCollection|

    newCollection := self new.
    newCollection add:anObject.
    ^ newCollection
!

with:firstObject with:secondObject
    "return a new Collection with two elements:firstObject and secondObject"

    |newCollection|

    newCollection := self new.
    newCollection add:firstObject; add:secondObject.
    ^ newCollection
!

with:firstObject with:secondObject with:thirdObject
    "return a new Collection with three elements"

    |newCollection|

    newCollection := self new.
    newCollection add:firstObject; add:secondObject; add:thirdObject.
    ^ newCollection
!

with:firstObject with:secondObject with:thirdObject with:fourthObject
    "return a new Collection with four elements"

    |newCollection|

    newCollection := self new.
    newCollection add:firstObject; add:secondObject; add:thirdObject; add:fourthObject.
    ^ newCollection
!

with:a1 with:a2 with:a3 with:a4 with:a5
    "return a new Collection with five elements"

    |newCollection|

    newCollection := self new.
    newCollection add:a1; add:a2; add:a3; add:a4; add:a5.
    ^ newCollection

    "Modified: 22.1.1997 / 19:34:01 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5 with:a6
    "return a new Collection with size elements"

    |newCollection|

    newCollection := self new.
    newCollection add:a1; add:a2; add:a3; add:a4; add:a5; add:a6.
    ^ newCollection

    "Created: 22.1.1997 / 19:34:14 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5 with:a6 with:a7
    "return a new Collection with seven elements"

    |newCollection|

    newCollection := self new.
    newCollection add:a1; add:a2; add:a3; add:a4; add:a5; add:a6; add:a7.
    ^ newCollection

    "Created: 22.1.1997 / 19:34:24 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5 with:a6 with:a7 with:a8
    "return a new Collection with eight elements"

    |newCollection|

    newCollection := self new.
    newCollection add:a1; add:a2; add:a3; add:a4; add:a5; add:a6; add:a7; add:a8.
    ^ newCollection

    "Created: 22.1.1997 / 19:34:34 / cg"
!

withAll:aCollection
    "return a new Collection with all elements taken from the argument,
     aCollection"

    ^ self new
        addAll:aCollection;
        yourself.
!

withSize:n
    "obsolete: please use newWithSize:, for its better name"

    <resource: #obsolete>

    ^ self newWithSize:n
! !

!Collection class methodsFor:'Compatibility-Squeak'!

ofSize:n
    "return a new collection which really provides space for n elements.
     Kludges around the stupid definition of OrderedCollection>>new:"

    ^ self newWithSize:n
! !


!Collection class methodsFor:'Signal constants'!

emptyCollectionSignal
    "return the signal used to report non-allowed operation on empty collections"

    ^ EmptyCollectionSignal
!

invalidKeySignal
    "return the signal used to report bad key usage"

    ^ InvalidKeySignal
!

notEnoughElementsSignal
    "return the signal used to report attempts for an operation, for which
     there are not enough elements in the collection"

    ^ NotEnoughElementsSignal
!

valueNotFoundSignal
    "return the signal used to report a nonexisting element."

    ^ ValueNotFoundSignal
! !

!Collection class methodsFor:'instance creation-streaming'!

writeStreamClass
    "the type of stream used in writeStream"

    ^ WriteStream

    "
     OrderedCollection writeStreamClass
    "

    "Created: / 09-01-2011 / 10:37:15 / cg"
! !


!Collection class methodsFor:'queries'!

growIsCheap
    "return true, if this collection can easily grow
     (i.e. without a need for become:).
     Returns true here; this method is redefined in fix-size
     collections"

    ^ true
!

isAbstract
    "Return if this class is an abstract class.
     True is returned for Collection here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == Collection
!

mutableClass
    "Return a version of me with mutable instances.
     Only redefined in the immutable collections (of which instances are
     created by the compiler)"

    ^ self
! !

!Collection methodsFor:'Compatibility-ANSI'!

identityIncludes:anObject
    "return true, if the argument, anObject is in the collection.
     Same as #includesIdentical for Dolphin/ANSI compatibility."

    ^ self includesIdentical:anObject.
! !

!Collection methodsFor:'Compatibility-Dolphin'!

includesAnyOf:aCollection
    "same as #includesAny for Dolphin compatibility."

    ^ self includesAny:aCollection

    "
     #(1 2 3 4 5 6 7) includesAny:#(1 2 3)
     #('hello' 'there' 'world') includesAny:#('hello' 'world')
     #(1 2 3 4 5 6 7) includesAny:#(7 8 9)
     #(1 2 3 4 5 6 7) includesAny:#(8 9 10)
    "
!

symmetricDifference:aCollection
    "return a new set containing all elements, 
     which are contained in either the receiver or aCollection, but not in both.
     Same as xor: - for compatibility"

    ^ self xor:aCollection

    "
     |c1 c2|

     c1 := #( foo bar baz baloo ).
     c2 := #( foe bar banana baloo ).
     c1 symmetricDifference:c2.         
     self assert:(c1 symmetricDifference:c2) asSet = (c2 symmetricDifference:c1) asSet
    "
! !

!Collection methodsFor:'Compatibility-Squeak'!

, aCollection
    "return a new collection formed from concatenating the receiver with the argument"

    ^ self copy addAll: aCollection; yourself

    "Created: / 14-09-2011 / 16:32:06 / cg"
!

addIfNotPresent:anObject
    "Include anObject as one of the receiver's elements, but only if there
    is no such element already. Anwser anObject."

    (self includes: anObject) ifFalse: [self add: anObject].
    ^ anObject
!

anyOne
    "return any element from the collection.
     Report an error if there is none.
     Same as #anElement - for Squeak compatibility"

    ^ self anElement
!

associationsDo: aBlock
    "cg: I think this is bad, but - well..."

    self do: aBlock

    "Created: / 12-09-2011 / 09:21:58 / cg"
!

contents
    ^ self
!

difference: aCollection
    "Answer the set-theoretic difference of two collections."

    ^ self \ aCollection

    "
     #(0 2 4 6 8) difference:#(2 4)   
    "

    "Modified: / 20-01-2017 / 19:21:35 / stefan"
!

gather:aBlock
    "return an Array,
     containing all elements as returned from applying aBlock to each element of the receiver,
     where the block returns a collection of to-be-added elements.
     This could also be called: collectAllAsArray:"

    ^ self gather:aBlock as:Array

    "
     (Set withAll:#(10 20 30 10 20 40)) gather:[:el | Array with:el with:el * 2]
    "
!

gather:aBlock as:aClass
    "return an instance of the collection-class aClass,
     containing all elements as returned from applying aBlock to each element of the receiver.
     where the block returns a collection of to-be-added elements.
     This could also be called: collectAll:as:"

    ^ aClass streamContents:[:s |
        self do: [:ea | s nextPutAll: (aBlock value: ea)]
    ]

    "
     (Set withAll:#(10 20 30 10 20 40)) gather:[:el | Array with:el with:el * 2] as:OrderedCollection
     (Set withAll:#(10 20 30 10 20 40)) collectAll:[:el | Array with:el with:el * 2]
    "
!

groupBy:keyBlock having:selectBlock 
    "Like in SQL operation - Split the receiver's contents into collections of 
     elements for which keyBlock returns the same results, and return those 
     collections allowed by selectBlock. "

    |result key|

    result := OrderedDictionary new.
    self do:[:e | 
        key := keyBlock value: e.
        (result includesKey: key) ifFalse: [
            result at: key put: OrderedCollection new
        ].
        (result at: key) add: e
    ].
    ^ result := result select: selectBlock

    "
     #(1 2 3 4 5 6 7 8 9) groupBy:[:e | e odd] having:[:a |true]  
    "
!

ifEmpty:alternativeValue
    "return the receiver if not empty, alternativeValue otherwise"

    ^ self size ~~ 0 ifTrue:[self] ifFalse:[alternativeValue value]

    "
     'foo' ifEmpty: 'bar'
     '' ifEmpty: 'bar'
     '' ifEmpty: [ Time now printString ]
    "
!

ifEmpty:ifEmptyValue ifNotEmpty:ifNotEmptyValue
    "return ifNotEmptyValue if not empty, ifEmptyValue otherwise"
    
    |action|

    action := self isEmpty ifTrue:[ ifEmptyValue ] ifFalse:[ ifNotEmptyValue ].

    action isBlock ifTrue:[
        action numArgs == 1 ifTrue:[
            ^ action value:self 
        ]
    ].
    ^ action value 
!

ifEmpty:ifEmptyValue ifNotEmptyDo:ifNotEmptyValue
    "return ifNotEmptyValue if not empty, ifEmptyValue otherwise"

    ^ self ifEmpty:ifEmptyValue ifNotEmpty:ifNotEmptyValue
!

ifEmptyDo:ifEmptyValue ifNotEmpty:ifNotEmptyValue
    "return ifNotEmptyValue if not empty, ifEmptyValue otherwise"

    ^ self ifEmpty:ifEmptyValue ifNotEmpty:ifNotEmptyValue
!

ifNotEmpty:ifNotEmptyValue
    "return ifNotEmptyValue if not empty, nil otherwise"

    ^ self ifEmpty:nil ifNotEmpty:ifNotEmptyValue
!

ifNotEmptyDo:ifNotEmptyValue
    "return ifNotEmptyValue if not empty, nil otherwise"

    ^ self ifEmpty:nil ifNotEmpty:ifNotEmptyValue
!

ifNotEmptyDo:ifNotEmptyValue ifEmpty:ifEmptyValue
    "return ifNotEmptyValue if not empty, ifEmptyValue otherwise"

    ^ self ifEmpty:ifEmptyValue ifNotEmpty:ifNotEmptyValue
!

intersection:aCollection
    "same as intersect: for Squeak compatibility"
    
    ^ self intersect:aCollection

    "Created: / 22-10-2008 / 21:29:27 / cg"
! !


!Collection methodsFor:'accessing'!

anElement
    "return any element from the collection, 
     report an error if there is none.
     Use this to fetch the some element from a collection which is non-indexed or which
     has a non-numeric index. I.e. if someone gets an arbitrary collection which might be either indexable
     or not, anElement is a save way to access some element without a need to check for a proper key."

    self do: [:each | ^ each].
    self emptyCollectionError.

    "
     #() anElement             -> Error
     #(1 2 3) anElement        -> 1
     #(1 2 3) asSet anElement  -> one of them (undefined, which one)
    "
!

at:aKey ifNilOrAbsentPut:valueBlock
    "try to fetch the element at aKey. If either the key is invalid (as in a Dictionary)
     or there is no element stored under that key (as in an Array), set the element 
     from the valueBlock and return it.
     Useful for lazy initialization of collections."

    |val|

    val := self at:aKey ifAbsent:[ self at:aKey put:valueBlock value ].
    val isNil ifTrue:[
        self at:aKey put:(val := valueBlock value).
    ].
    ^ val

    "
     |d|

     d := Dictionary new.
     d at:#foo ifNilOrAbsentPut:[ 'hello' ]. 
     d     
    "

    "
     |a|

     a := Array new:10.
     a at:1 ifNilOrAbsentPut:[ 'hello' ].  
     a    
    "

    "Created: / 24-08-2010 / 17:07:21 / cg"
!

atAll:indexCollection put:anObject
    "put anObject into all indexes from indexCollection in the receiver.
     This abstract implementation requires that the receiver supports
     access via a key (and indexCollection contains valid keys).

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

    indexCollection do:[:index | self at:index put:anObject]

    "
     args:    indexCollection : <Collection of keys<object> >
     returns: self
    "

    "
     (Array new:10) atAll:(1 to:5) put:0
     (Array new:10) atAll:#(1 5 6 9) put:0
     (Dictionary new) atAll:#(foo bar baz) put:'hello' 

    raises an error:
     (Set new) atAll:#(foo bar baz) put:'hello' 
    "

    "Modified: / 20.5.1998 / 14:50:46 / cg"
!

decrementAt:aKey 
    "remove 1 from the count stored under aKey.
     If not yet present, assume 0 as initial counter value."

    self incrementAt:aKey by:-1
!

fifth
    "return the fifth element of the collection.
     For unordered collections, this simply returns the fifth
     element when enumerating them.
     This should be redefined in subclasses."

    ^ self nth:5

    "
     #(1 2 3 4 5) fifth
    "
!

first
    "return the first element of the collection.
     For unordered collections, this simply returns the first
     element when enumerating them.
     This should be redefined in subclasses."

    self do:[:e | ^ e].

    "error if collection is empty"
    ^ self emptyCollectionError
!

first:n
    "return the n first elements of the collection.
     No longer raises an error if there are not enough elements;
     instead, returns what is there.

     For unordered collections, this simply returns the first
     n elements when enumerating them.
     (Warning: the contents of the returned collection is not deterministic in this case).
     This should be redefined in subclasses."

    |coll remain|

    n < 0 ifTrue:[self error:'bad (negative) argument'].

    coll := OrderedCollection new.
    remain := n.
    self do:[:e |
        coll add:e.
        remain := remain - 1.
        remain == 0 ifTrue:[
            ^ coll
        ].
    ].
    "/ OLD:
    "/ "error if collection has not enough elements"
    "/ ^ self notEnoughElementsError
    "/ NEW:
    "/ return what we have - no error if not enough elements
    ^ coll.

    "
     #(1 2 3 4 5) first:3
     #(1 2 3 4 5) asSet first:3
     #(1 2 3) first:5
     #(1 2 3) asSet first:5
    "

    "Modified (format): / 29-09-2011 / 10:16:49 / cg"
!

firstIfEmpty:exceptionValue
    "return the first element of the collection.
     If its empty, return the exceptionValue.
     (i.e. don't trigger an error as done in #first)"

    self isEmpty ifTrue:[^ exceptionValue value].
    ^ self first

    "Modified: / 04-06-2007 / 22:36:14 / cg"
!

firstOrNil
    "return the first element of the collection.
     If its empty, return nil.
     (i.e. don't trigger an error as done in #first)"

    ^ self firstIfEmpty:nil

    "Created: / 04-06-2007 / 22:36:07 / cg"
!

fourth
    "return the fourth element of the collection.
     For unordered collections, this simply returns the fourth
     element when enumerating them.
     This should be redefined in subclasses."

    ^ self nth:4

    "
     #(1 2 3 4) fourth
    "
!

incrementAt:aKey 
    "add 1 to the count stored under aKey.
     If not yet present, assume 0 as initial counter value."

    self incrementAt:aKey by:1
!

incrementAt:aKey by:count
    "add count to the count stored under aKey.
     If not yet present, assume 0 as initial counter value."
    
    self at:aKey put:(self at:aKey ifAbsent:[0])+count.
!

keysSorted
    "return the keys as a sorted sequenceable collection.
     Some collections (which keep their keys already sorted) may
     redefine this method to return the keys as they are kept internally.
     The fallback here sorts them into an OrderedCollection"

    ^ self keys asNewOrderedCollection sort
!

keysSorted:aBlock
    "return the keys as a sorted sequenceable collection.
     Some collections (which keep their keys already sorted) may
     redefine this method to return the keys as they are kept internally.
     The fallback here sorts them into an OrderedCollection"

    ^ self keys asNewOrderedCollection sort:aBlock
!

last
    "return the last element of the collection.
     This is a slow fallback implementation,    
     and should be redefined in subclasses which can do indexed accesses."

    |theLastOne any|

    any := false.
    self do:[:e | any := true. theLastOne := e].
    any ifTrue:[
        ^ theLastOne
    ].

    "error if collection is empty"
    ^ self emptyCollectionError
!

last:n
    "return the n last elements of the collection.
     No longer raises an error if there are not enough elements;
     instead, returns what is there.
     For unordered collections, this simply returns the last
     n elements when enumerating them
     (Warning: the contents of the returned collection is not deterministic in this case).
     This should be redefined in subclasses since the implementation here is VERY inefficient."

    |coll remain|

    n < 0 ifTrue:[self error:'bad (negative) argument'].

    coll := OrderedCollection new:n.
    remain := n.
    self do:[:e |
        remain > 0 ifTrue:[
            remain := remain - 1.
        ] ifFalse:[
            coll removeFirst.
        ].
        coll add:e.
    ].

    "/ OLD:
    "/ remain ~~ 0 ifTrue:[
    "/     "error if collection has not enough elements"
    "/     ^ self notEnoughElementsError
    "/ ].
    ^ coll

    "
     #(1 2 3 4 5) last:3
     #(1 2 3 4 5 6 7 8 9 0) asSet last:3
     'hello world' last:5
     'hello' last:10
     'hello' asSet last:10
    "

    "Modified (format): / 29-09-2011 / 10:16:22 / cg"
!

lastIfEmpty:exceptionValue
    "return the last element of the collection.
     If it is empty, return the exceptionValue.
     (i.e. don't trigger an error as done in #last)"

    self isEmpty ifTrue:[^ exceptionValue value].
    ^ self last

    "Modified: 6.2.1996 / 15:27:17 / cg"
    "Created: 6.2.1996 / 15:27:49 / cg"
!

nth:n
    "return the nth element of the collection.
     For unordered collections, this simply returns the nth
     element when enumerating them.
     This should be redefined in subclasses which can accecss fast by numeric index (aka Array-like things)."

    |count|

    count := 1.
    self do:[:e | 
        count == n ifTrue:[^ e].
        count := count + 1
    ].

    "error if collection is smaller"
    ^ self notEnoughElementsError

    "
     #(1 2 3 4) nth:3
     #(1 2 3 4) nth:5

     #(1 2 3 4) asSet nth:3  
     #(1 2 3 4) asSet nth:5
    "
!

order
    "report an error that only OrderedXXX's have an order"

    self shouldNotImplement
!

second
    "return the second element of the collection.
     For unordered collections, this simply returns the second
     element when enumerating them.
     This should be redefined in subclasses."

    ^ self nth:2

    "
     #(1 2 3) second
    "
!

secondLast
    "return the second last element of the collection.
     This is a slow fallback implementation,    
     and should be redefined in subclasses which can do indexed accesses."

    |theSecondLastOne theLastOne cnt|

    cnt := 0.
    
    self do:[:e | cnt := cnt+1. theSecondLastOne := theLastOne. theLastOne := e].
    cnt > 1 ifTrue:[
        ^ theSecondLastOne
    ].

    "error if collection did not enumerate at least 2 elements"
    ^ self notEnoughElementsError
!

seventh
    "return the seventh element of the collection.
     For unordered collections, this simply returns the sixth
     element when enumerating them.
     This should be redefined in subclasses."

    ^ self nth:7

    "
     #(1 2 3 4 5 6 7) seventh
    "

    "Created: / 1.11.2001 / 16:43:29 / cg"
!

sixth
    "return the sixth element of the collection.
     For unordered collections, this simply returns the sixth
     element when enumerating them.
     This should be redefined in subclasses."

    ^ self nth:6

    "
     #(1 2 3 4 5 6 7) sixth
    "
!

third
    "return the third element of the collection.
     For unordered collections, this simply returns the third
     element when enumerating them.
     This should be redefined in subclasses."

    ^ self nth:3

    "
     #(1 2 3) third
    "

    "Modified (format): / 29-09-2011 / 10:17:25 / cg"
!

values
    "return a collection containing all values of the receiver.
     This is to make value access to an OrderedDictionary compatible with any-Collection"

    ^ OrderedCollection new
        addAll:self;
        yourself.

    "
        #(1 2 3 4 5) values
        #(1 2 3 4 5) asSet values
        #(1 2 3 4 5) asOrderedSet values
    "
! !

!Collection methodsFor:'adding & removing'!

add:anObject
    "add the argument, anObject to the receiver.
     If the receiver is ordered, the position of the new element is undefined
     (i.e. don't depend on where it will be put).
     An error is raised here - it is to be implemented by a concrete subclass."

    ^ self subclassResponsibility

    "Modified: 1.2.1997 / 11:57:08 / cg"
!

add:newObject withOccurrences:anInteger
    "add the argument, anObject anInteger times to the receiver.
     Returns the object."

    anInteger timesRepeat:[self add:newObject].
    ^ newObject

    "Created: 11.5.1996 / 12:13:48 / cg"
!

addAll:aCollection
    "add all elements of the argument, aCollection to the receiver.
     Returns the argument, aCollection (sigh)."

    aCollection do:[:element |
        self add:element
    ].
    ^ aCollection

    "
     #(1 2 3 4) copy addAll:#(5 6 7 8)
     #(1 2 3 4) asOrderedCollection addAll:#(5 6 7 8)
    "

    "Modified: 12.4.1996 / 13:29:20 / cg"
!

addAll:aCollectionOfObjects withOccurrences:anInteger
    "add each element from aCollection, anInteger times to the receiver.
     Returns the argument, aCollection (sigh)."

    aCollectionOfObjects do:[:each |
        self add:each withOccurrences:anInteger.
    ].
    ^ aCollectionOfObjects

    "Created: 11.5.1996 / 12:13:48 / cg"
!

addAllFirst:aCollection
    "insert all elements of the argument, aCollection at the beginning
     of the receiver. Returns the argument, aCollection."

    aCollection reverseDo:[:element | 
        self addFirst:element 
    ].
    ^ aCollection

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c addAllFirst:#(9 8 7 6 5).
     c   
    "

    "Modified: 12.4.1996 / 13:30:10 / cg"
!

addAllLast:aCollection
    "add all elements of the argument, aCollection to the receiver.
     Returns the argument, aCollection."

    aCollection do:[:element | 
        self addLast:element 
    ].
    ^ aCollection

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c addAllLast:#(9 8 7 6 5)
    "

    "Modified: 12.4.1996 / 13:30:54 / cg"
!

addAllNonNilElements:aCollection
    "add all non-nil elements of the argument, aCollection to the receiver.
     Use this, when operating on a Set, that should not hold nil.
     Answer the argument, aCollection."

    aCollection do:[:eachElement |
        eachElement notNil ifTrue:[
            self add:eachElement
        ].
    ].
    ^ aCollection

    "
     #(1 2 3 4) asSet addAllNonNilElements:#(5 nil 6 7 8); yourself
    "
!

addFirst:anObject
    "add the argument, anObject to the receiver.
     If the receiver is ordered, the new element will be added at the beginning.
     An error is raised here - it is to be implemented by a concrete subclass."

    ^ self subclassResponsibility

    "Modified: 1.2.1997 / 11:57:19 / cg"
!

addLast:anObject
    "add the argument, anObject to the receiver. 
     If the receiver is ordered, the new element will be added at the end.
     Return the argument, anObject.

     This usually has the same semantics as #add:. 
     OrderedSet and OrderedDictionary redefine this, to move anObject to
     the end, even if it is already present in the collection."

    ^ self add:anObject

    "Modified: 12.4.1996 / 13:31:12 / cg"
!

clearContents
    "remove all elements from the receiver. Returns the receiver.
     Subclasses may redefine this to keep the container."

    self removeAll.
!

contents:aCollection
    "set my contents from aCollection
     - this may be redefined in a concrete subclass for more performance"

    aCollection == self ifTrue:[
        "/ self error:'should not happen'.
        ^ self
    ].

    self removeAll.
    aCollection notNil ifTrue:[
        self addAll:aCollection
    ]

    "Modified: / 17.8.1998 / 10:18:43 / cg"
!

remove:anObject
    "search for the first element, which is equal to anObject;
     if found, remove and return it.
     If not found, report a 'value not found'-error.
     Uses equality compare (=) to search for the occurrence."

    ^ self remove:anObject ifAbsent:[self errorValueNotFound:anObject]

    "Modified: 1.2.1997 / 11:58:48 / cg"
!

remove:anObject ifAbsent:exceptionBlock
    "search for the first element, which is equal to anObject;
     if found, remove and return it.
     If not found, return the value of the exceptionBlock.
     Uses equality compare (=) to search for the occurrence.
     An error is raised here - it is to be implemented by a concrete subclass."

    ^ self subclassResponsibility

    "Modified: 1.2.1997 / 11:56:53 / cg"
!

removeAll
    "remove all elements from the receiver. Returns the receiver.
     This should be reimplemented in subclasses for better
     performance."

    [self isEmpty] whileFalse:[
        self removeFirst
    ].

    "Modified: 12.2.1997 / 12:40:29 / cg"
!

removeAll:aCollection
    "remove all elements from the receiver which are equal to any in aCollection.
     Return the argument, aCollection.
     Raises an error, if some element-to-remove is not in the receiver.
     (see also: #removeAllFoundIn:, which does not raise an error).

     Notice: for some collections (those not tuned for
             resizing themself) this may be very slow.
             If the number of removed elements is big compared to
             the receiver's size, it may be better to copy the
             ones which are not to be removed into a new collection."

    aCollection do:[:element | self remove:element].
    ^ aCollection

    "
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAll:#(4 5 6).
     coll
    "

    "raises an error:
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAll:#(4 5 6 7 8).
     coll
    "

    "no error raised:
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAllFoundIn:#(4 5 6 7 8).
     coll
    "

    "Modified: / 05-08-2010 / 13:50:33 / cg"
!

removeAllFoundIn:aCollection 
    "remove all elements from the receiver which are equal to any in aCollection.
     No error is raised, if some element-to-remove is not in the receiver.
     (see also: #removeAll:, which does raise an error)."

    aCollection do:[:each | self remove:each ifAbsent:[]].
    ^ aCollection

    "
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAllFoundIn:#(4 5 6 7 8).
     coll
    "

    "raises an error:
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAll:#(4 5 6 7 8).
     coll
    "

    "Modified: / 05-08-2010 / 13:51:05 / cg"
!

removeAllIdentical:aCollection
    "remove all elements from the receiver which are in aCollection.
     Return the argument, aCollection.
     Raises an error, if some element-to-remove is not in the receiver.
     (see also: #removeAllFoundIn:, which does not raise an error).

     Notice: for some collections (those not tuned for
             resizing themself) this may be very slow.
             If the number of removed elements is big compared to
             the receiver's size, it may be better to copy the
             ones which are not to be removed into a new collection."

    aCollection do:[:element | self removeIdentical:element].
    ^ aCollection

    "
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAll:#(4 5 6).
     coll
    "

    "raises an error:
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAll:#(4 5 6 7 8).
     coll
    "

    "no error raised:
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAllFoundIn:#(4 5 6 7 8).
     coll
    "

    "Created: / 05-08-2010 / 13:51:51 / cg"
!

removeAllIdenticalFoundIn:aCollection 
    "remove all elements from the receiver which are in aCollection.
     No error is raised, if some element-to-remove is not in the receiver.
     (see also: #removeAll:, which does raise an error)."

    aCollection do:[:each | self removeIdentical:each ifAbsent:[]].
    ^ aCollection

    "
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAllFoundIn:#(4 5 6 7 8).
     coll
    "

    "raises an error:
     |coll|

     coll := #(1 2 3 4 5 6) asSet.
     coll removeAll:#(4 5 6 7 8).
     coll
    "

    "Created: / 05-08-2010 / 13:52:21 / cg"
!

removeAllKeys:aCollection
    "remove all keys of the argument, aCollection from the receiver.
     Raises an error, if some element-to-remove is not in the receiver.
     Notice: only works for keyed collections, such as dictionaries."

    aCollection do:[:element | self removeKey:element].
!

removeAllSuchThat:aBlock
    "Apply the condition to each element and remove it if the condition is true.  
     Return a collection of removed elements.
     First elements-to-remove are collected, then removed in one operation."

    |removedElements|

    removedElements := OrderedCollection new.
    self do:[:eachElement |
        (aBlock value:eachElement) ifTrue: [
            removedElements add:eachElement
        ]
    ].
    self removeAllIdenticalFoundIn:removedElements.
    ^ removedElements

    "
     |coll|

     coll := #(1 2 2 3 4 5 6 7 8 9 10) asOrderedCollection.
     coll removeAllSuchThat:[:el | el even].
     coll     
    "

    "
     |coll bla|

     bla := 'bla' copy.
     coll := #(1 'bla' 3 4 5 6 7 8 9 10) asOrderedCollection.
     coll add:bla.
     coll removeAllSuchThat:[:el | el == bla].
     coll     
    "

    "
     |coll|

     coll := #(1 2 3 4 5 6 7 8 9 10) asSet.
     coll removeAllSuchThat:[:el | el even].
     coll     
    "
!

removeFirst
    "remove the first element from the receiver.
     Return the removed element."

    self do:[:element |
        self remove:element.
        ^ element.
    ].
    ^ self emptyCollectionError

    "
     (Set with:3 with:2 with:1) removeFirst 
    "

    "Modified: 28.6.1996 / 18:55:33 / cg"
!

removeFirst:n
    "remove the first n elements from the receiver.
     Return a collection of removed elements.
     Notice: for some collections (those not tuned for
             resizing themself) this may be very slow."

    |ret|

    self size < n ifTrue:[
        ^ self notEnoughElementsError
    ].
    ret := Array new:n.
    1 to:n do:[:i |
        ret at:i put:(self removeFirst).
    ].
    ^ ret
!

removeIdentical:anObject
    "search for the first element, which is identical to anObject;
     if found, remove and return it.
     If not found, report a 'value not found'-error.
     Uses identity compare (==) to search for the occurrence."

    ^ self removeIdentical:anObject ifAbsent:[self errorValueNotFound:anObject]

    "Modified: 12.4.1996 / 13:33:30 / cg"
    "Created: 1.2.1997 / 11:59:10 / cg"
!

removeIdentical:anObject ifAbsent:exceptionBlock
    "search for the first element, which is identical to anObject;
     if found, remove and return it.
     If not found, return the value of the exceptionBlock.
     Uses identity compare (==) to search for the occurrence.
     An error is raised here - it is to be implemented by a concrete subclass."

    ^ self subclassResponsibility

    "Created: 1.2.1997 / 11:56:01 / cg"
    "Modified: 1.2.1997 / 11:56:59 / cg"
!

removeLast
    "remove the last element from the receiver.
     Return the removed element.
     An error is raised here - it is to be implemented by a concrete subclass."

    ^ self subclassResponsibility

    "Modified: 1.2.1997 / 11:57:53 / cg"
!

removeLast:n
    "remove the last n elements from the receiver collection.
     Return a collection of removed elements.
     Notice: for some collections this may be very slow
             (those not tuned for resizing themself)."

    |ret|

    self size < n ifTrue:[
        ^ self notEnoughElementsError
    ].
    ret := Array new:n.
    n to:1 by:-1 do:[:i |
        ret at:i put:(self removeLast).
    ].
    ^ ret
! !

!Collection methodsFor:'bulk operations'!

abs
    "absolute value of all elements in the collection.
     Elements are supposed to be numeric"

    ^ self collect:[:a | a abs]

    "
     TestCase assert:( #(1 -2 -3 4) abs = #(1 2 3 4)).
    "

    "Modified: / 18-03-2011 / 10:33:50 / cg"
!

negated
    "negated value of all elements in the collection.
     Elements are supposed to be numeric"

    ^ self collect:[:a | a negated]

    "
     TestCase assert:( #(1 -2 -3 4) negated = #(-1 2 3 -4)).
    "

    "Modified: / 18-03-2011 / 10:33:53 / cg"
!

product
    "return the product of all elements which are supposed to be numeric.
     Raises an error for an empty receiver."

    ^ self 
        fold:[:accum :each | accum * each].

    "
     TestCase should:[ Array new product ] raise:Error.

     TestCase assert:( #(1) product == 1).
     TestCase assert:( #(6) product == 6).
     TestCase assert:( #(1 2 3 4 5) product = 5 factorial )
    "
!

sum
    "return the sum of all elements which are supposed to be numeric.
     Returns 0 for an empty receiver."

    self isEmpty ifTrue:[^ 0].

    ^ self 
        fold:[:accum :each | accum + each].

    "
     TestCase assert: ( #() sum = 0 ).
     TestCase assert: ( #(1) sum = 1 ).
     TestCase assert: ( #(1 2 3 4) sum = 10 ).
     TestCase assert: ( (1 to:10) sum = 55 ).
     TestCase assert: ( 'abc' asByteArray sum = 294 ).
     TestCase assert: ( { 10 +/- 2.
                          20 +/- 4.
                         100 +/- 10 } sum = (130 +/- 16) ).

     TestCase assert: ( { (1 / 9).
                          (1 / 7).
                        } sum = (16 / 63) ).
    "
!

sum:aBlock
    "for each element in the receiver, evaluate the argument, aBlock and sum up the results. 
     Return the total sum or 0 for an empty collection.
     Similar to (self collect...) sum, but avoids creation of an intermediate collection."

    |sum|

    self do:[:element |
        |thisValue|

        thisValue := aBlock value:element.
        sum isNil ifTrue:[
            sum := thisValue
        ] ifFalse:[
            sum := sum + thisValue
        ].
    ].
    ^ sum ? 0

    "
     TestCase assert:(
        ((1 to:10) collect:[:n | n squared]) sum = ((1 to:10) sum:[:n | n squared])
     )
    "

    "Modified: / 23-08-2010 / 18:19:42 / cg"
! !

!Collection methodsFor:'comparing'!

identicalContentsAs:aCollection
    "return true if the receiver and aCollection represent collections
     with identical contents. This is much like #sameContentsAs:, but compares
     elements using #== instead of #=."

    aCollection size ~~ self size ifTrue:[
        ^ false
    ].

    ^ aCollection conform:[:e | (self includesIdentical:e)]

    "
     #(1 2 3 4 5) = #(1 2 3 4 5)
     #(1 2 3 4 5) = #(1.0 2 3 4.0 5)
     #($1 $2 $3 $4 $5) = '12345'

     #(1 2 3 4 5) identicalContentsAs:#(1 2 3 4 5)
     #(1 2 3 4 5) identicalContentsAs: #(1.0 2 3 4.0 5)
     #($1 $2 $3 $4 $5) identicalContentsAs: '12345'
    "

    "Modified: / 31.10.2001 / 11:30:18 / cg"
!

sameContentsAs:aCollection
    "answer true, if all the elements in self and aCollection
     are common. This is not defined as #=, since we cannot redefine #hash
     for aCollection."

    aCollection size ~~ self size ifTrue:[
        ^ false
    ].

    ^ aCollection conform:[:e | (self includes:e)]

    "
      #(1 2 3) asSet sameContentsAs: #(1 2 3)
      #(1 2 3 4) asSet sameContentsAs: #(1 2 3)
      #(1 2 3) asSet sameContentsAs: #(1 2 3 3)
      #(1 2 3 'aa') asSet sameContentsAs: #(1 2 3 'aa')
      #(1 2 3 'aa') asIdentitySet sameContentsAs: #(1 2 3 'aa')
      #(1 2 3 #aa) asIdentitySet sameContentsAs: #(1 2 3 #aa)
    "
!

sameContentsAs:aCollection whenComparedWith:compareBlock
    "answer true, if all the elements in self and aCollection
     are common. This is not defined as #=, since we cannot redefine #hash
     for aCollection."

    aCollection size ~~ self size ifTrue:[
        ^ false
    ].

    ^ aCollection conform:[:otherElement | 
            self contains:[:myElement | 
                compareBlock value:myElement value:otherElement
            ].
        ].

   "
     #(1 2 3 4 5) asSet sameContentsAs: #(1 2 3 4 5) whenComparedWith:[:a :b | a = b]
     #(1 2 3 4 5) sameContentsAs: #(1 2 3 4 5) asSet whenComparedWith:[:a :b | a = b]
     #(1 2 3 4 5) asSet sameContentsAs: #(1 2 3 4 5)     whenComparedWith:[:a :b | a == b]
     #(1 2 3 4 5) asSet sameContentsAs: #(1.0 2 3 4.0 5) whenComparedWith:[:a :b | a = b]
     #(1 2 3 4 5) asSet sameContentsAs: #(1.0 2 3 4.0 5) whenComparedWith:[:a :b | a == b]

     #('Hello' 'ABC' 'worlD') asSet sameContentsAs: #('Hello' 'ABC' 'worlD') whenComparedWith:[:a :b | a sameAs:b]
   "
! !

!Collection methodsFor:'converting'!

asArray
    "return an Array with the collection's elements.
     Notice: this is redefined in Array, where it returns the receiver. 
     Use asNewArray, if you intent to modify the returned collection."

    |anArray 
     index "{ Class: SmallInteger }" |

    anArray := Array new:(self size).
    index := 1.
    self do:[:each |
        anArray at:index put:each.
        index := index + 1
    ].
    ^ anArray
!

asArrayOfType:arrayClass
    "return a new instance of arrayClass with the collection's elements"

    |anArrayInstance 
     index "{ Class: SmallInteger }" |

    anArrayInstance := arrayClass new:(self size).
    index := 1.
    self do:[:each |
        anArrayInstance at:index put:each.
        index := index + 1
    ].
    ^ anArrayInstance
!

asBag
    "return a new Bag with the receiver collection's elements"

    ^ self addAllTo:(Bag new)
!

asByteArray
    "return a new ByteArray with the collection's elements
     (which must convert to 8bit integers in the range 0..255)."

    ^ self asIntegerArray:ByteArray
!

asCollection
    "return myself as a Collection.
     I am already a Collection."

    ^ self


!

asCollectionDo:aBlock
    "enumerate myself"

    self do:aBlock
!

asDictionary
    "return a Dictionary with the receiver collection's elements,
     using the original keys of the receiver as dictionary key.
     Notice: this is redefined in Dictionary, where it returns the receiver. 
     Use asNewDictionary, if you intend to modify the returned collection.
     See associationsAsDictionary if you already have a collection of associations"

    |d|

    d := Dictionary new:self size.
    self keysAndValuesDo:[:k :v | d at:k put:v].
    ^ d

    "
     #(10 20 30 40 50 60 70 80 90) asDictionary 
    "
!

asDoubleArray
    "return a new DoubleArray with the collection's elements
     (which must convert to 64bit floats)."

    ^ self asArrayOfType:DoubleArray
!

asFlatOrderedCollection
    "return a new ordered collection containing all elements of the receiver
     and recursively of all collectionelements from the receiver"

    |coll|

    coll := OrderedCollection new.
    self flatDo:[:el | coll add:el].
    ^ coll.

    "
     #(
        (1 2 3)
        4 5
        (6)
        7
        (8 (9 10) 11 12 (13 (14 (15) 16)))
     ) asFlatOrderedCollection
    "

    "Modified: / 20-03-2011 / 22:02:36 / cg"
!

asFloatArray
    "return a new FloatArray with the collection's elements
     (which must convert to 32bit floats)."

    ^ self asArrayOfType:FloatArray
!

asHalfFloatArray
    "return a new HalfFloatArray with the collection's elements
     (which must convert to 16bit half-floats)."

    ^ self asArrayOfType:HalfFloatArray
!

asIdentitySet
    "return a new IdentitySet with the receiver collection's elements"

    ^ self addAllTo:(IdentitySet new:self size)
!

asIntegerArray
    "return a new IntegerArray with the collection's elements
     (which must convert to 32bit integers in the range 0..16rFFFFFFFF)."

    ^ self asIntegerArray:IntegerArray
!

asIntegerArray:arrayClass
    "return a new Array with the collection's elements"

    |anIntegerArray 
     index "{ Class: SmallInteger }" |

    anIntegerArray := arrayClass new:(self size).
    index := 1.
    self do:[:each |
        anIntegerArray at:index put:each asInteger.
        index := index + 1
    ].
    ^ anIntegerArray
!

asKeysAndValues
    "return a Dictionary with the receiver's associations as key->value pairs
     using each element's key as dictionary key and value as dictionary value."

    ^ Dictionary withAssociations:self

    "
     { 10->'ten' . 20->'twenty' . 30->'thirty'} asKeysAndValues 
    "
!

asList
    "return a new List with the receiver collection's elements"

    ^ self addAllTo:(List new:self size)

    "Created: 14.2.1997 / 16:25:23 / cg"
!

asLongIntegerArray
    "return a new LongIntegerArray with the collection's elements
     (which must convert to 64bit integers in the range 0..16rFFFFFFFFFFFFFFFF)."

    ^ self asIntegerArray:LongIntegerArray
!

asMutableCollection
    "return myself"

    ^ self 
!

asNewArray
    "return a new Array with the receiver collection's elements.
     This method ensures that the returned collection is a new one, not
     the same or shared with the original receiver"

    ^ self asArray
!

asNewDictionary
    "return a new Dictionary with the receiver collection's elements.
     This method ensures that the returned collection is a new one, not
     the same or shared with the original receiver"

    ^ self asDictionary
!

asNewIdentitySet
    "return a new IdentitySet with the receiver collection's elements.
     This method ensures that the returned collection is a new one, not
     the same or shared with the original receiver"

    ^ self asIdentitySet
!

asNewOrderedCollection
    "return a new OrderedCollection with the receiver collection's elements.
     This method ensures that the returned collection is a new one, not
     the same or shared with the original receiver"

    ^ self asOrderedCollection
!

asNewOrderedSet
    "return a new OrderedSet with the receiver collection's elements.
     This method ensures that the returned collection is a new one, not
     the same or shared with the original receiver"

    ^ self asOrderedSet
!

asNewSet
    "return a new Set with the receiver collection's elements.
     This method ensures that the returned collection is a new one, not
     the same or shared with the original receiver"

    ^ self asSet
!

asNilIfEmpty
    "return mySelf, or nil if I am empty"

    self isEmpty ifTrue:[^ nil].
    ^ self.
!

asOrderedCollection
    "return an OrderedCollection with the receiver collection's elements.
     Notice: this is redefined in OrderedCollection, where it returns the receiver. 
     Use asNewOrderedCollection, if you intent to modify the returned collection."

    ^ self addAllTo:(OrderedCollection new:self size)
!

asOrderedSet
    "return a new OrderedSet with the receiver collection's elements.
     Notice: this is redefined in OrderedSet, where it returns the receiver. 
     Use asNewOrderedSet, if you intent to modify the returned collection."

    ^ self addAllTo:(OrderedSet new:self size)
!

asRunArray
    "return a new RunArray with the collection's elements"

    ^ RunArray from:self.

"/    |runs lastElement occurrences|
"/
"/    runs := RunArray new.
"/    occurrences := 0.
"/    self do:[:each |
"/        each == lastElement ifTrue:[
"/            occurrences := occurrences + 1
"/        ] ifFalse:[
"/            runs add:lastElement withOccurrences:occurrences.
"/            occurrences := 1.
"/            lastElement := each
"/        ].
"/    ].
"/    occurrences ~~ 0 ifTrue:[
"/        runs add:lastElement withOccurrences:occurrences
"/    ].
"/    ^ runs

    "
     #(1 2 3 3 3 4 4 4 4 5 6 7) asRunArray 
    "

    "Modified: / 7.4.1998 / 09:50:54 / cg"
!

asSequenceableCollection
    "return myself as a SequenceableCollection.
     I am already a Collection, but not sequenceable."

    ^ self asArray


!

asSet
    "return a Set with the receiver collection's elements.
     Notice: this is redefined in Set, where it returns the receiver. 
     Use asNewSet, if you intent to modify the returned collection."

    ^ self addAllTo:(Set new:self size)
!

asSharedCollection
    "return a shared collection on the receiver.
     This implements synchronized (i.e. mutually excluded) access to me.
     Use this for safe access when multiple processes access me concurrently.
     Notice that this is a general (possibly suboptimal) mechanism, which should
     work with all collections. Look for specialized collections (SharedQueue), which are
     tuned for this kind of operation."

    ^ SharedCollection for:self.
!

asSignedByteArray
    "return a new ByteArray with the collection's elements
     (which must convert to 8bit integers in the range -128..127)."

    ^ self asIntegerArray:SignedByteArray

    "
        #( 1 2 3 4 -128 -5 -6) asSignedByteArray
    "
!

asSignedIntegerArray
    "return a new SignedIntegerArray with the collection's elements
     (which must convert to 32bit signed integers in the range -16r80000000..16r7FFFFFFF)."

    ^ self asIntegerArray:SignedIntegerArray

    "Created: / 07-10-2011 / 13:14:01 / cg"
!

asSignedLongIntegerArray
    "return a new LongIntegerArray with the collection's elements
     (which must convert to 64bit integers in the range -16r8000000000000000..16r7FFFFFFFFFFFFFFF)."

    ^ self asIntegerArray:SignedLongIntegerArray
!

asSignedWordArray
    "return a new WordArray with the collection's elements
     (which must convert to 16bit integers in the range -0x8000..16r7FFF)."

    ^ self asIntegerArray:SignedWordArray
!

asSortedCollection
    "return a new SortedCollection with the receiver collection's elements"

    |aSortedCollection|

    aSortedCollection := SortedCollection new:self size.
    aSortedCollection addAll:self.
    ^ aSortedCollection
!

asSortedCollection:sortBlock
    "return a new SortedCollection with the receiver collection's elements,
     using sortBlock for comparing"

    |aSortedCollection|

    aSortedCollection := SortedCollection sortBlock:sortBlock.
    aSortedCollection addAll:self.
    ^ aSortedCollection
!

asSortedStrings
    "Create & return a SortedCollection that sorts the receiver's
     elements according to the locales collating policy.
     This is currently not really supported - strings are sorted
     without caring for the locale."

    |aSortedCollection|

    aSortedCollection := SortedCollection forStrings:self size.
    aSortedCollection addAll:self.
    ^ aSortedCollection

    "Created: 13.9.1997 / 09:36:22 / cg"
    "Modified: 13.9.1997 / 09:43:00 / cg"
!

asSortedStrings:sortBlock
    "Create & return a SortedCollection that sorts the receiver's
     elements using sortBlock and according to the locales collating policy,
     which is passed as first arg to sortBlock.
     This is currently not really supported - strings are sorted
     without caring for the locale."

    |aSortedCollection|

    aSortedCollection := SortedCollection forStrings:self size.
    aSortedCollection sortBlock:sortBlock.
    aSortedCollection addAll:self.
    ^ aSortedCollection

    "Created: / 13.9.1997 / 09:36:45 / cg"
    "Modified: / 27.10.1997 / 16:39:48 / cg"
!

asSortedStrings:sortBlock with:aCollationPolicy
    "Create & return a SortedCollection that sorts the receiver's
     elements using sortBlock and according to the specified locales collating policy.
     This is currently not really supported - strings are sorted
     without caring for the locale."

    |aSortedCollection|

    aSortedCollection := SortedCollection forStrings:self size collatedBy:aCollationPolicy.
    aSortedCollection sortBlock:sortBlock.
    aSortedCollection addAll:self.
    ^ aSortedCollection

    "Created: 13.9.1997 / 09:37:21 / cg"
    "Modified: 13.9.1997 / 09:45:27 / cg"
!

asSortedStringsWith: aCollationPolicy
    "Create & return a SortedCollection that sorts the receiver's
     elements according to the specified locales collating policy.
     This is currently not really supported - strings are sorted
     without caring for the locale."

    |aSortedCollection|

    aSortedCollection := SortedCollection forStrings:self size collatedBy:aCollationPolicy.
    aSortedCollection addAll:self.
    ^ aSortedCollection

    "Created: 13.9.1997 / 09:37:50 / cg"
    "Modified: 13.9.1997 / 09:44:08 / cg"
!

asString
    "return a String with the collection's elements 
     (which must convert to characters)"

    |string 
     index "{ Class: SmallInteger }" 
     char 
     stringBitsPerCharacter "{ Class: SmallInteger }" 
     charBitsPerCharacter "{ Class: SmallInteger }" 
     |

    string := String new:(self size).
    stringBitsPerCharacter := string bitsPerCharacter.

    index := 1.
    self do:[:each |
        char := each asCharacter.
        charBitsPerCharacter := char bitsPerCharacter.
        charBitsPerCharacter > stringBitsPerCharacter ifTrue:[
            charBitsPerCharacter == 16 ifTrue:[
                string := Unicode16String fromString:string.
                stringBitsPerCharacter := 16.
            ] ifFalse:[
                string := Unicode32String fromString:string.
                stringBitsPerCharacter := 32.
            ].
        ].
        string at:index put:char.
        index := index + 1
    ].
    ^ string

    "
     #(80 81 82) asString
     #(16r8000 16r8001 16r8002) asString
     #(16r800000 16r800001 16r800002) asString
    "
!

asStringCollection
    "return a new string collection containing the elements;
     these ought to be strings. (i.e. String or Text instances)"

    ^ self addAllTo:(StringCollection new)

    "Modified: 18.5.1996 / 13:54:34 / cg"
!

asUnicodeString
    "return a String with the collection's elements 
     (which must convert to characters)"

    |aString 
     index "{ Class: SmallInteger }" |

    aString := UnicodeString uninitializedNew:self size.
    index := 1.
    self do:[:each |
        aString at:index put:each asCharacter.
        index := index + 1
    ].
    ^ aString

    "
      #(16r440 16r443 16r441 16r441 16r43A 16r438 16r439 16r20 16r44F 16r437 16r44B 16r43A) asUnicodeString
    "
!

asUnsignedByteArray
    "return a new ByteArray with the collection's elements
     (which must convert to 8bit integers in the range 0..255)."

    ^ self asIntegerArray:ByteArray
!

asWordArray
    "return a new WordArray with the collection's elements
     (which must convert to integers in the range 0..16rFFFF)."

    ^ self asIntegerArray:WordArray 
!

associationsAsDictionary
    "return a new Dictionary with the receiver collection's elements,
     which must be associations"

    ^  Dictionary withAssociations:self.

    "
     { 'ten' -> 10 . 'twenty' -> 20 . 'thirty' -> 30 } associationsAsDictionary 
    "
!

copyAs:collectionClass
    "return a new instance of collectionClass with the receiver collection's elements.
     This is similar to copy as:collectionClass, to ensure that we get a new
     (unshared) collection, but avoids the copy if the receiver is not already an   
     instance of collectionClass."

    |newColl|

    newColl := self as:collectionClass.
    newColl == self ifTrue:[
        ^ self copy
    ].
    ^ newColl.

    "
     |coll1 coll2|

     coll1 := #(1 2 3 4 5). 
     coll2 := coll1 copyAs:Array.                   '-- will generate a copy'.
     self assert:(coll1 ~~ coll2).
     self assert:(coll1 = coll2).

     coll1 := #(1 2 3 4 5). 
     coll2 := coll1 copyAs:OrderedCollection.       '-- will generate an OC'.
     self assert:(coll1 ~~ coll2).
     self assert:(coll1 isSameSequenceAs: coll2).

     coll1 := #(1 2 3 4 5) asOrderedCollection.
     coll2 := coll1 copyAs:OrderedCollection.       '-- will generate a copy'.
     self assert:(coll1 ~~ coll2).
     self assert:(coll1 = coll2).
    "
!

copyAsOrderedCollection
    "return a new OrderedCollection with the receiver collection's elements.
     This is similar to copy asOrderedCollection, to ensure that we get a new
     (unshared) collection, but avoids the copy if the receiver is not already an   
     OrderedCollection."

    |newColl|

    newColl := self asOrderedCollection.
    newColl == self ifTrue:[
        ^ self copy
    ].
    ^ newColl.
!

keysAndValues
    |assocs|

    assocs := OrderedCollection new.
    self keysAndValuesDo:[:k :v |
        assocs add:(k -> v).
    ].
    ^ assocs.

    "
     #(10 20 30 40 50 60) keysAndValues
    "
!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    |encoding idx|

    encoding := Array new:self size + 1.
    encoding at:1 put:self class name.
    idx := 2.
    self do:[:element|
        encoding at:idx put:element literalArrayEncoding.
        idx := idx + 1.
    ].
    ^ encoding


    "
     (Array with:(Color red:50 green:50 blue:50)
            with:(1 @ 2)
     ) literalArrayEncoding decodeAsLiteralArray
    "

    "Modified: 22.4.1996 / 13:00:56 / cg"
!

readStream
    "return a stream for reading from the receiver"

    ^ ReadStream on:self

    "
     |s|

     s := 'hello world' readStream.
     s next:5.
     s next.
     (s next:5) inspect
    "
!

readStreamOrNil
    "return a stream for reading from the receiver.
     This has been defined for protocol compatibility with FileName,
     but nil is never returned here"

    ^ self readStream
!

readWriteStream
    "return a stream for reading and writing from/to the receiver"

    ^ ReadWriteStream with:self

    "
     'hello world' readWriteStream
        nextPutAll:'+Foo';
        contents

     'hello world' readWriteStream
        setToEnd;
        nextPutAll:'+Foo';
        contents
    "
!

writeStream
    "return a stream for writing onto the receiver"

    ^ self class writeStreamClass on:self

    "
     |s|

     s := #() writeStream.
     s nextPut:1.
     s nextPut:2.
     s nextPut:3.
     s contents inspect
    "

    "
     |s|

     s := OrderedCollection new writeStream.
     s nextPut:1.
     s nextPut:2.
     s nextPut:3.
     s contents inspect
    "
!

writeStreamOrNil
    "return a stream for writing onto the receiver.
     This has been defined for protocol compatibility with FileName,
     but nil is never returned here"

    ^ self writeStream
! !

!Collection methodsFor:'copying'!

copy
    "return a copy of the receiver.
     Redefined to pass the original as argument to the postCopyFrom method."

    ^ self shallowCopy postCopyFrom:self

    "Created: / 19.4.1998 / 20:02:53 / cg"
!

copyEmpty
    "return a copy of the receiver with no elements.
     This is used by copying and enumeration methods
     to get a new instance which is similar to the receiver."

    ^ self species new
!

copyEmpty:size
    "return a copy of the receiver with no elements, but space for
     size elements. This is used by copying and enumeration methods
     to get a new instance which is similar to the receiver.
     This method should be redefined in subclasses with instance
     variables, which should be put into the copy too.
     For example, SortedCollection has to copy its sortBlock into the
     new collection."

    ^ self species new:size
!

copyEmptyAndGrow:size
    "return a copy of the receiver with size nil elements.
     This is used by copying and enumeration methods
     to get a new instance which is similar to the receiver."

    ^ (self copyEmpty:size) grow:size
!

copyWith: additionalElement 
    "Return a copy of the dictionary that is 1 bigger than the receiver and 
     includes the argument, additionalElement, at the end."

    | newColl |

    newColl := self copy.
    newColl add: additionalElement.
    ^ newColl
!

postCopyFrom:original
    "sent to a freshly copied object to give it a chance to adjust things.
     Notice, that for Sets/Dicts etc. a rehash is not needed, since the copy
     will have the same hash key as the receiver (as long as ST/X provides the 
     setHash: functionality)."

    "for ST-80 compatibility, we try postCopy here ..."
    ^ self postCopy

    "Created: / 19.4.1998 / 19:59:42 / cg"
    "Modified: / 19.4.1998 / 20:03:57 / cg"
! !

!Collection methodsFor:'enumerating'!

addAllNonNilElementsTo:aCollection
    "add all nonNil elements of the receiver to aCollection.
     Return aCollection."

    self do:[:each | each notNil ifTrue:[aCollection add:each]].
    ^ aCollection

    "
     #(1 2 3 4 5 1 2 3 4 5 nil) asOrderedCollection addAllNonNilElementsTo:Set new
    "
!

addAllTo:aCollection
    "add all elements of the receiver, to aCollection.
     Return aCollection."

    self do:[:each | aCollection add:each].
    ^ aCollection

    "
     #(1 2 3 4 5 1 2 3 4 5) addAllTo:Set new
    "

    "Modified: / 11.2.2000 / 11:22:14 / cg"
!

collect:aBlock
    "for each element in the receiver, evaluate the argument, aBlock
     and return a new collection with the results"

    |newCollection|

    newCollection := self speciesForCollecting new:self size.
    self do:[:element | newCollection add:(aBlock value:element)].
    ^ newCollection

    "
     #(1 2 3 4) asSet collect:[:n | n * 2]
    "
!

collect:aBlock as:aClass
    "like collect, but use an instance of aClass to collect the results.
     Also avoids the need for an extra intermediate collection which is created with
     the standard coding: 'self asXXXX collect:[...]"

    |newCollection
     idx  "{ Class:SmallInteger }"
     sz  "{ Class:SmallInteger }"|

    sz := self size.
    newCollection := (aClass new:sz) grow:sz.
    newCollection isSequenceable ifTrue:[
        idx := 1.
        self do:[:el |
            newCollection at:idx put:(aBlock value:el).
            idx := idx + 1.
        ].
    ] ifFalse:[
        self do:[:el |
            newCollection add:(aBlock value:el).
        ].
    ].
    ^ newCollection

    "
     #(one two three four five six) collect:[:element | element asUppercase] as:OrderedCollection
     'abcdef' collect:[:char | char digitValue] as:ByteArray
    "
!

collect:collectBlock thenDetect:detectBlock ifNone:exceptionalValue
    "first apply collectBlock to each element, then pass the result to
     detectBlock. 
     Return the first element from collectBlock for which detectBlock evaluates to true.
     If none does, return the value of exceptionalValue, which is usually a block.
     Returns the same as if two separate collect:+detect:ifNone: messages were sent,
     but avoids the creation of intermediate collections, so this is nicer for
     big collections."

    self do:[:each |
        |rslt|

        rslt := collectBlock value:each.
        (detectBlock value:rslt) ifTrue:[^ rslt].
    ].
    ^ exceptionalValue value

    "
     ( #(1 2 3 4) collect:[:e | e squared] ) detect:[:e| e odd] ifNone:0
     #(1 2 3 4) collect:[:e | e squared] thenDetect:[:e| e odd] ifNone:0
    "
!

collect:collectBlock thenDo:aBlock
    "combination of collect followed by do.
     Avoids the creation of intermediate garbage"

    self do:[:each | aBlock value:(collectBlock value:each)]

    "
     #(1 2 3 4 5 6 7) collect:[:i | i * 2] thenDo:[:i | Transcript showCR:i ]
    "

    "Created: / 28-02-2012 / 21:05:16 / cg"
!

collect:collectBlock thenReject:rejectBlock
    "combination of collect followed by reject.
     May be redefined by some subclasses for optimal performance
     (avoiding the creation of intermediate garbage)"

    ^ self collect:collectBlock thenSelect:[:el | (rejectBlock value:el) not]

    "
     #(1 2 3 4 5 6 7) collect:[:i | i * 2] thenReject:[:i | i > 10]
    "

    "Modified: / 11-07-2010 / 17:03:16 / cg"
!

collect:collectBlock thenSelect:selectBlock
    "combination of collect followed by select.
     May be redefined by some subclasses for optimal performance
     (avoiding the creation of intermediate garbage)"

    ^ (self collect:collectBlock) select:selectBlock

    "
     #(1 2 3 4 5 6 7) collect:[:i | i * 2] thenSelect:[:i | i < 10]
    "
!

collect:collectBlock thenSelect:selectBlock as:aCollectionClass
    "first apply collectBlock to each element, then pass the result to
     selectBlock. 
     Return a new collection with all elements from the receiver, 
     for which the selectBlock evaluates to true.
     Returns the same as if three separate collect+select+as messages were sent,
     but avoids the creation of intermediate collections, so this is nicer for
     big collections."

    |newCollection|

    newCollection := aCollectionClass new.
    self do:[:each |
        |rslt|

        rslt := collectBlock value:each.
        (selectBlock value:rslt) ifTrue:[newCollection add:rslt].
    ].
    ^ newCollection

    "
     #(1 2 3 4) select:[:e | e odd] thenCollect:[:e| e*e] as:OrderedCollection  
     (1 to:10) select:[:e | e even] thenCollect:[:e| e*e] as:IdentitySet       
    "

    "Created: / 29-08-2013 / 09:56:20 / cg"
!

collectAll:aBlock
    "for each element in the receiver, evaluate the argument, aBlock.
     The block is supposed to return a collection, whose elements are collected.
     The species of the returned collection is that of the first returned
     partial result."

    |result|

    self do:[:element | 
        |individualResult|

        individualResult := aBlock value:element.
        result isNil ifTrue:[
            result := individualResult speciesForCollecting new.
        ].
        result addAll:individualResult.
    ].

    "do not answer an empty - possibly immutable - Array"
    ^ result ? self speciesForCollecting new.

    "
     #(1 2 3 4) collectAll:[:n | Array new:n withAll:n ]  
     #(1 2 3 4) collectAll:[:n | Array with:n with:n squared ]   
     #(1 2 3 4) collectAll:[:n | 1 to:n ]      
     (Array with:Point with:Rectangle) collectAll:[:c | c instVarNames ]      
    "
!

collectAll:aBlock as:collectionClass
    "for each element in the receiver, evaluate the argument, aBlock.
     The block is supposed to return a collection, whose elements are collected.
     The returned collection will be an instance of collectionClass"

    |result|

    result := collectionClass new.
    self do:[:element | 
        result addAll:(aBlock value:element).
    ].

    ^ result

    "
     #(1 2 3 4) collectAll:[:n | Array new:n withAll:n ] as:OrderedCollection  
     #(1 2 3 4) collectAll:[:n | Array new:n withAll:n ] as:Bag  
     #(1 2 3 4) collectAll:[:n | Array with:n with:n squared ] as: OrderedCollection  
     #(1 2 3 4) collectAll:[:n | 1 to:n ] as: Set     
     (Array with:Point with:Rectangle) collectAll:[:c | c instVarNames ] as:StringCollection     
    "
!

collectWithIndex:aTwoArgBlock
    "for each element in the receiver and a running index, 
     evaluate the argument, aTwoArgBlock.
     Return a new collection with the results"

    |newCollection runIndex|

    newCollection := self speciesForCollecting new:self size.
    runIndex := 1.
    self do:[:element | 
        newCollection add:(aTwoArgBlock value:element value:runIndex).
        runIndex := runIndex + 1.
    ].
    ^ newCollection

    "
     #(1 2 3 4) collectWithIndex:[:n :i | n * 2 + i]  
     #(1 2 3 4) collectWithIndex:[:n :i | i -> (n * 2)]  
    "
!

count:aBlock
    "count elements, for which aBlock returns true.
     Return the sum."

    |count|

    count := 0.
    self do:[:element |
        (aBlock value:element) ifTrue:[count := count + 1]
    ].
    ^ count

    "
     #(1 2 3 4 6 8 10) count:[:a | a even]     
     #(1 nil nil nil 2 3 nil 4 5) count:[:a | a isNil]   
    "
!

detect:aBlock
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation.
     If none of the evaluations returns true, report an error"

    ^ self detect:aBlock ifNone:[self errorNotFound]

    "
     #(1 2 3 4) detect:[:n | n odd]   
     #(2 4 6 8) detect:[:n | n odd]  

     #(1 2 3 4) detect: #odd     
     #(2 4 6 8) detect: #odd  
    "
!

detect:generatorBlock forWhich:testBlock ifNone:exceptionValue
    "evaluate generatorBlock for each element in the receiver until
     testBlock returns true for it; 
     in this case return the value from generatorBlock, which caused the true evaluation.
     If none of the test evaluations returns true, return the value from exceptionValue"

    self do:[:each |
        |val|

        val := generatorBlock value:each.
        (testBlock value:val) ifTrue:[^ val].
    ].
    ^ exceptionValue value

    "
     #(2 3 4) detect:[:n | n squared] forWhich:[:nsq | nsq odd] ifNone:['sorry']    
     #( 2 4 ) detect:[:n | n squared] forWhich:[:nsq | nsq odd] ifNone:['sorry']    

     #( 'st' 'c' 'java' ) 
        detect:[:ext | 'Foo' asFilename withSuffix:ext]
        forWhich:[:fn | fn exists]
        ifNone:nil    
    "
!

detect:aOneArgBlock ifNone:exceptionValue
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation.
     If none of the evaluations returns true, return the value from exceptionValue"

    self do:[:each | 
        (aOneArgBlock value:each) ifTrue:[^ each].
    ].
    ^ exceptionValue value

    "
     #(1 2 3 4) detect:[:n | n odd] ifNone:['sorry']    
     #(2 4 6 8) detect:[:n | n odd] ifNone:['sorry']     
    "

    "Modified: / 13-09-2006 / 11:17:42 / cg"
!

detect:checkBlock thenCompute:evalBlock 
    "evaluate the argument, aBlock for each element in the receiver until
     checkBck returns true; in this case return the value from evalBlock
     applied to the element which caused the true evaluation.
     If none of the evaluations returns true, report an error"

    ^ self detect:checkBlock thenCompute:evalBlock ifNone:[self errorNotFound]

    "
     #((1 'one') (2 'two') (3 'three') (4 'four')) 
        detect:[:pair | pair first odd] thenCompute:[:pair | pair second]  

     #( (2 'two') (4 'four')) 
        detect:[:pair | pair first odd] thenCompute:[:pair | pair second]  
    "
!

detect:checkBlock thenCompute:evalBlock ifNone:exceptionValue
    "evaluate the argument, aBlock for each element in the receiver until
     checkBck returns true; in this case return the value from evalBlock
     applied to the element which caused the true evaluation.
     If none of the evaluations returns true, return the value from exceptionValue."

    |foundElement|
    
    foundElement := self detect:checkBlock ifNone:[^ exceptionValue value].
    ^ evalBlock value:foundElement.

    "
     #((1 'one') (2 'two') (3 'three') (4 'four')) 
        detect:[:pair | pair first odd] thenCompute:[:pair | pair second]
        ifNone:[ nil ].     
    "
    "
     #( (2 'two')  (4 'four')) 
        detect:[:pair | pair first odd] thenCompute:[:pair | pair second]
        ifNone:[ nil ].
    "
!

detectLast:aBlock
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation. The elements are processed in reverse order.
     If none of the evaluations returns true, report an error"

    ^ self detectLast:aBlock ifNone:[self errorNotFound]

    "
     #(1 2 3 4) detectLast:[:n | n odd]   
     #(2 4 6 8) detectLast:[:n | n odd]  
    "
!

detectLast:aBlock ifNone:exceptionValue
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation. The elements are processed in reverse order.
     If none of the evaluations returns true, return the value from exceptionValue"

    self reverseDo:[:each | 
        (aBlock value:each) ifTrue:[^ each].
    ].
    ^ exceptionValue value

    "
     #(1 2 3 4) detectLast:[:n | n odd] ifNone:['sorry']    
     #(2 4 6 8) detectLast:[:n | n odd] ifNone:['sorry']     
    "
!

detectMax: aBlock
    "Evaluate aBlock with each of the receiver's elements as argument. 
     Answer the element for which aBlock evaluates to the highest magnitude.
     If the receiver collection is empty, return nil.  
     This method might also be called elect:."

    | maxElement maxValue |

    self do: [:each | 
        | val |

        val := aBlock value: each.
        "Note that there is no way to get the first element 
         which works for all kinds of Collections.  
         Must therefore test every one (maxValue is nil for the first element)."
        (maxValue isNil or:[val > maxValue]) ifTrue: [
           maxElement := each.
           maxValue := val
        ]
    ].
    ^ maxElement

    "
     #(1 -1 5 -17 10 -8 5) detectMax: #abs
    "

    "Created: / 20-08-2011 / 21:34:49 / cg"
!

detectMin: aBlock
    "Evaluate aBlock with each of the receiver's elements as argument. 
     Answer the element for which aBlock evaluates to the lowest number.
     If the receiver collection is empty, return nil."

    | minElement minValue |

    self do: [:each | 
        | val |

        val := aBlock value: each.
        "Note that there is no way to get the first element 
         which works for all kinds of Collections.  
         Must therefore test every one (minValue is nil for the first element)."
        (minValue isNil or:[val < minValue]) ifTrue: [
           minElement := each.
           minValue := val
        ]
    ].
    ^ minElement

    "
     #(1 -1 5 -17 10 -8 5) detectMin: #abs   
    "

    "Created: / 20-08-2011 / 21:35:13 / cg"
!

do:aBlock
    "evaluate the argument, aBlock for each element"

    ^ self subclassResponsibility
!

do:aBlock inBetweenDo:betweenBlock
    "evaluate the argument, aBlock for each element.
     Between elements (i.e. after each except for the last),
     evaluate betweenBlock.
     This is a utility helper for collection printers
     (for example, to print a space between elements)."

    <resource: #obsolete>
    self obsoleteMethodWarning:'use #do:separatedBy:'.
    ^ self do:aBlock separatedBy:betweenBlock

    "Modified: / 11.2.2000 / 11:23:15 / cg"
!

do:aBlock separatedBy:betweenBlock
    "evaluate the argument, aBlock for each element.
     Between elements (i.e. after each except for the last),
     evaluate betweenBlock.
     This is a utility helper for collection printers
     (for example, to print a space between elements)."

"/ could do the more hackish:
"/
"/    |b|
"/
"/    b := [ b := betweenBlock ].
"/    self do:[:element |
"/        b value.
"/        aBlock value:element
"/    ].
"/
"/ but that creates a block, whereas the following does not.

    |first|

    first := true.
    self do:[:element |
        first ifTrue:[
            first := false
        ] ifFalse:[
            betweenBlock value.
        ].
        aBlock value:element
    ].

    "
     #(1 2 3 4) do:[:el | Transcript show:el]
                separatedBy:[ Transcript show:'-']

     (Dictionary with:(1->'one') with:(2->'two'))
         do:[:el | Transcript showCR:el printString]
         separatedBy:[ Transcript showCR:'----']

     (Dictionary with:(1->'one') with:(2->'two'))
        associations
         do:[:el | Transcript showCR:el printString]
         separatedBy:[ Transcript showCR:'----']

    "

    "Modified: / 11.2.2000 / 11:23:15 / cg"
!

do:aBlock whileTrue:whileBlock
    "evaluate the argument, aBlock for each element until whileBlock
     evaluates to false.
     Answer the last result from evaluating aBlock."

    |result|

    self do:[:el |
        result := aBlock value:el.
        (whileBlock value:el) ifFalse:[
            ^ result.
        ]
    ].
    ^ result

    "Example:
     search for the first element which is >= 99; return it.
     remaining elements are not processed:

     #(1 2 3 4 999 5 6 7 8 9) 
        do:[:element|
            Transcript showCR:element.
            element
        ] whileTrue:[:element| element < 99]    
    "
!

do:aBlock without:anItem
    "enumerate all elements except those equal to anItem into aBlock."

    self do:[:el |
        anItem ~= el ifTrue:[ aBlock value:el ]
    ].
    ^ self

    "
     #(1 2 3 4 999 5 6 7 8 9) 
        do:[:el | Transcript showCR:el ]
        without:5
    "

    "Created: / 28-02-2012 / 21:11:41 / cg"
!

doWhileTrue:aBlock
    "evaluate the argument, aBlock for each element,
     until the block evaluates to false.
     Answer true, if all the elements have been processed,
     false otherwise."

    self do:[:el |
        (aBlock value:el) ifFalse:[
            ^ false.
        ]
    ].
    ^ true

    "Example:
     search for the first element which is >= 99; return it.
     remaining elements are not processed:

     |lastElement|

     #(1 2 3 4 999 5 6 7 8 9) 
        doWhileTrue:[:element|
            Transcript showCR:element.
            lastElement := element.
            element < 99
        ].
     lastElement
    "
!

doWithExit:aBlock
    "evaluate the argument, aBlock for each element.
     Passes an additional exit object, which can be used to leave
     the loop early, by sending it a #value: message.
     Returns nil or the value passed to the exit>>value: message.

     Notice, that this is different to a return statement in the block, 
     which returns from the enclosed method, NOT only from the block."

    |exit|

    exit := [:exitValue | ^exitValue].

    self do:[:el |
        aBlock value:el value:exit
    ].
    ^ nil

    "Example:
     search for the first element which is >= 99; return it.
     remaining elements are not processed:

     #(1 2 3 4 999 5 6 7 8 9) 
        doWithExit:[:element :exit |
            Transcript showCR:element.
            element >= 99 ifTrue:[exit value:element]]    

     #(1 2 3 4 5 6 7 8 9) 
        doWithExit:[:element :exit |
            Transcript showCR:element.
            element >= 99 ifTrue:[exit value:element]]
    "

    "to demonstrate the difference to returning from the block:
     this works:

     |el|

     el := #(1 2 3 4 999 5 6 7 8 9) 
        doWithExit:[:element :exit |
            element >= 99 ifTrue:[exit value:element]].
     Transcript showCR:el.


     this does NOT work as expected by a newComer ;-) (the showCR is not reached):

     |el|

     el := #(1 2 3 4 999 5 6 7 8 9) 
        do:[:element |
            element >= 99 ifTrue:[^ element]].
     Transcript showCR:el.
    "

    "Modified: / 18-04-1996 / 14:16:59 / cg"
    "Modified (format): / 29-02-2012 / 11:50:02 / cg"
!

doWithIndex:aBlock
    "Squeak/V'Age compatibility; 
     like keysAndValuesDo:, but passes the index as second argument.
     Same as withIndexDo:, due to parallel evolution of different Smalltalk dialects"

    self keysAndValuesDo:[:index :el | aBlock value:el value:index].

    "Created: / 17-10-1997 / 12:33:10 / cg"
!

flatDetect:aBlock 
    "for each element of the collection, if it's a scalar, evaluate aBlock for it;
     otherwise, recursively invoke flatDetect: on the collection.
     Return the first element for which aBlock evaluates to true.
     Thus implementing a depth-first search.
     Raises an error, if no element is found"

    ^ self flatDetect:aBlock ifNone:[self errorNotFound]

    "
     #(
        (1 2 3)
        4 5
        (6)
        7
        (8 (9 10) 11 12 (13 (14 (15) 16)))) flatDetect:[:el | el>5]
    "
!

flatDetect:aBlock ifNone:exceptionValue
    "for each element of the collection, if it's a scalar, evaluate aBlock for it;
     otherwise, recursively invoke flatDetect: on the collection.
     Return the first element for which aBlock evaluates to true.
     Thus implementing a depth-first search.
     Return the value from exceptionValue if none found"

    self do:[:each |
        |result|

        (each isNonByteCollection) ifTrue:[
            each flatDo:[:el | (aBlock value:el) ifTrue:[^ el]].
        ] ifFalse:[
            (aBlock value:each) ifTrue:[^ each]. 
        ].
    ].
    ^ exceptionValue value.

    "
     #(
        (1 2 3)
        4 5
        (6)
        7
        (  8 
          (9 10) 
          11 
          12 
          ( 13
           ( 14 
            (15) 
            16)
           )
          )
      ) flatDetect:[:el | el<0] ifNone:#none       
    "
    "
     #(
        (1 2 3)
        4 5
        (6)
        7
        (  8 
          (9 10) 
          11 
          12 
          ( 13
           ( 14 
            (15) 
            16)
           )
          )
      ) flatDetect:[:el | el>15] ifNone:#none       
    "
!

flatDo:aBlock
    "for each element of the collection, if it's a scalar, evaluate aBlock for it;
     otherwise, recursively invoke flatDo: on the collection.
     Thus implementing a depth-first enumeration"

    self do:[:each |
        (each isNonByteCollection) ifTrue:[
            each flatDo:aBlock
        ] ifFalse:[
            aBlock value:each
        ].
    ].

    "
     #(
        (1 2 3)
        4 5
        (6)
        7
        (8 (9 10) 11 12 (13 (14 (15) 16)))
     ) flatDo:[:el | Transcript showCR:el]
    "

    "Modified: / 22-01-2011 / 09:12:22 / cg"
!

fold: binaryBlock
    "Evaluate the block with the first two elements of the receiver,
     then with the result of the first evaluation and the next element,
     and so on.  Answer the result of the final evaluation. If the receiver
     is empty, raise an error. If the receiver has a single element, answer
     that element.

     Here the reduction is done from left to right.

     See also: #inject:into: #reduce:"

    | first nextValue |

    first := true.
    self do:[:each |
        first 
            ifTrue: [first := false. nextValue := each]
            ifFalse: [nextValue := binaryBlock value:nextValue value:each]
    ].
    first ifTrue:[
        ^ self emptyCollectionError.
    ].
    ^ nextValue

    "
     (1 to:10) fold:[:sum :el| sum + el]
     (1 to:15) fold:[:x :y| '(', x printString, '+', y printString, ')']
     (1 to:15) reduce:[:x :y| '(', x printString, '+', y printString, ')']
     #('if' 'it' 'is' 'to' 'be' 'it' 'is' 'up' 'to' 'me') fold: [:a :b | a, ' ', b]
     #('if' 'it' 'is' 'to' 'be' 'it' 'is' 'up' 'to' 'me') reduce: [:a :b | a, ' ', b]
     #() fold: [:a :b | a, ' ', b] -- raises an error
    "

    "Created: / 14-09-2011 / 16:29:53 / cg"
!

inject:thisValue into:binaryBlock
    "starting with thisValue for value, pass this value and each element
     to binaryBlock, replacing value with the result returned from the block
     in the next iteration.

     See also: #fold: #reduce:"

    |nextValue|

    nextValue := thisValue.
    self do: [:each | nextValue := binaryBlock value:nextValue value:each].
    ^ nextValue

    "sum up the elements of a collection:

     #(1 2 3 4) inject:0 into:[:accu :element | accu + element]   
     (1 to:10) inject:0 into:[:accu :element | accu + element]     

     find the minimum:

     |coll|
     coll := #(1 99 -15 20 100).
     coll inject:(coll first) into:[:minSoFar :element | minSoFar min:element]
    "

    "Modified: 23.4.1996 / 13:47:06 / cg"
!

injectAndCollect:thisValue into:binaryBlock
    "starting with thisValue for value, pass this value and each element
     to binaryBlock, replacing value with the result returned from the block
     in the next iteration. 
     Collect all results and return them all.

     See also: #fold: #reduce:"

    |coll nextValue|

    coll := self species new.
    nextValue := thisValue.
    self do: [:each | nextValue := binaryBlock value:nextValue value:each. coll add:nextValue].
    ^ coll

    "sum up the elements of a collection:

     #(1 2 3 4) inject:0 into:[:accu :element | accu + element]     
     (1 to:10) inject:0 into:[:accu :element | accu + element]      

     same, getting all partial sums:
     (1 to:10)  injectAndCollect:0 into:[:accu :element | accu + element] 
    "
!

keysAndValuesCollect:aBlock
    "for each key-value pair in the receiver, evaluate the argument, aBlock
     and return a collection with the results.

     See also:
        #associationsCollect:  (which passes keys->value pairs)
        #collect:              (which only passes values)

     This is much like #associationsCollect:, but aBlock gets the
     key and value as two separate arguments.
     #associationsCollect: is a bit slower.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    |newCollection|

    newCollection := OrderedCollection new.
    self keysAndValuesDo:[:key :value |
        newCollection add:(aBlock value:key value:value)
    ].
    ^ newCollection

    "
     |ages|

     ages := Dictionary new.
     ages at:'cg' put:37.
     ages at:'ca' put:33.
     ages at:'sv' put:36.
     ages at:'tk' put:28.
     ages keysAndValuesCollect:[:name :age | 
                name , '''s age is ' , age printString]
    "

    "Modified: 20.4.1996 / 11:33:50 / cg"
!

keysAndValuesDetect:aBlock ifNone:exceptionalValue
    "for each key-value pair in the receiver, evaluate the argument, aBlock
     and return the value for which aBlock returns true the very first time.
     If none of the evaluations returns true, return the result of the
     evaluation of the exceptionBlock"
     
    self keysAndValuesDo:[:key :value |
        (aBlock value:key value:value) ifTrue:[^ value].
    ].
    ^ exceptionalValue value

    "
     |ages|

     ages := Dictionary new.
     ages at:'cg' put:37.
     ages at:'ca' put:33.
     ages at:'sv' put:36.
     ages at:'tk' put:28.
     ages keysAndValuesDetect:[:name :age | age = 33].
    "
!

keysAndValuesDetectKey:aBlock ifNone:exceptionalValue
    "for each key-value pair in the receiver, evaluate the argument, aBlock
     and return the key/index for which aBlock returns true the very first time.
     If none of the evaluations returns true, return the result of the
     evaluation of the exceptionBlock"
     
    self keysAndValuesDo:[:key :value |
        (aBlock value:key value:value) ifTrue:[^ key].
    ].
    ^ exceptionalValue value

    "
     |ages|

     ages := Dictionary new.
     ages at:'cg' put:37.
     ages at:'ca' put:33.
     ages at:'sv' put:36.
     ages at:'tk' put:28.
     ages keysAndValuesDetectKey:[:name :age | age = 33] ifNone:nil.
    "
!

keysAndValuesDo:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both index and element as arguments.
     Blocked here - must be redefined in subclasses which have keyed elements"

    ^ self errorNotKeyed
!

keysAndValuesReverseDo:aTwoArgBlock
    "evaluate the argument, aBlock in reverse order for every element in the collection,
     passing both index and element as arguments.
     Blocked here - must be redefined in subclasses which have keyed elements"

    ^ self errorNotKeyed

    "Created: 9.5.1996 / 00:58:24 / cg"
!

keysAndValuesSelect:selectBlockWith2Args thenCollect:collectBlockWith2Args
    "first call the selectBlockWith2Args, passsing it each key and element,
     if that returns true, call the collectBlockWith2Args, also with key and element,
     and collect the resulting values in an OrderedCollection."
    
    |collected|

    collected := OrderedCollection new.
    self keysAndValuesDo:[:eachKey :eachValue |
        (selectBlockWith2Args value:eachKey value:eachValue) ifTrue:[
            collected add:(collectBlockWith2Args value:eachKey value:eachValue)
        ].
    ].
    ^ collected

    "
     #(10 20 30 40) 
        keysAndValuesSelect:[:idx :val | idx > 2] 
        thenCollect:[:idx :val | idx->val]
    "
!

keysDo:aBlock
    "evaluate the argument, aBlock for every key in the collection."

    self keysAndValuesDo:[:k :v | aBlock value:k]

    "Created: / 24-08-2010 / 10:12:14 / cg"
!

map:selectorOrBlock
    "for lisp fans (and also for Javascript) - similar to collect:"

    selectorOrBlock isSymbol ifTrue:[
        ^ self collect:[:eachElement | eachElement perform:selectorOrBlock].
    ].
    ^ self collect:selectorOrBlock.
    
    "
     #(1 2 3 4) map:#negated  
     #(1 2 3 4) collect:#negated   
    "

    "Modified (comment): / 29-02-2012 / 11:53:51 / cg"
!

map:selectorOrBlock with:arg
    "for lisp fans - similar to collect:"

    selectorOrBlock isSymbol ifTrue:[
        ^ self collect:[:eachElement | eachElement perform:selectorOrBlock with:arg].
    ].
    ^ self collect:[:each | selectorOrBlock value:each value:arg].

    "
     #(1 2 3 4) map:#+ with:1  
     #(1 2 3 4) map:[:a :b | a + b] with:1  
    "

    "Modified (comment): / 29-02-2012 / 11:53:57 / cg"
!

nonNilElementsDo:aBlock
    "evaluate the argument, aBlock for every non-nil element in the collection."

    self do:[:each |
        each notNil ifTrue:[
            aBlock value:each.
        ]
    ]

    "
     #(1 nil 3 nil nil 6 7 nil)
        nonNilElementsDo:[:el | Transcript showCR:el]
    "

    "Modified (comment): / 21-12-2011 / 15:51:39 / cg"
!

pairsDo:aTwoArgBlock
    "evaluate the argument, aTwoArgBlock for every element in the collection,
     which is supposed to consist of 2-element collections.
     The block is called with 2 arguments for each collection in the receiver.
     CONFUSION ATTACK: 
        this is different from pairWiseDo:.
        but the Squeak-pairsDo: does the same as our pairWiseDo: 
        (sigh: but we were first, so they should have adapted...)"

    self do:[:aPair |
        aTwoArgBlock value:(aPair at:1) value:(aPair at:2).
    ]

    "
     #( 
        (1 one) 
        (2 two) 
        (3 three) 
        (4 four) 
        (5 five) 
        (6 six)
      ) pairsDo:
        [:num :sym | 
            Transcript show:num; show:' is: '; showCR:sym]

     #( (1 1)  (1 2)  (1 3)  (1 4)  (1 5)) 
     pairsDo:[:x :y | Transcript showCR:x@y]
    "

    "Modified: / 20-10-2007 / 17:17:50 / cg"
!

partition:check as:species into:aTwoArgBlock
    "enumerate the receiver's elements and partition them into two collections, 
     depending on the outcome of a check block.
     The type of result collection is passed in via the species argument. 
     Evaluate aTwoArgBlock on the two selected and rejected value collections. 
     Also return the selected values as return value"

    |selected rejected|

    selected := species new.
    rejected := species new. 
    self do:[:each | ((check value:each) ifTrue:[selected] ifFalse:[rejected]) add:each].
    aTwoArgBlock value:selected value:rejected.
    ^ selected

    "
     #(1 2 3 4 5 6 7 8)
        partition:[:el | el even]
        as:Set    
        into:[:evenElements :oddElements |
            Transcript show:'even: '; showCR:evenElements.
            Transcript show:' odd: '; showCR:oddElements.
        ].
    "
!

partition:check into:aTwoArgBlock
    "enumerate the receiver's elements and partition them into two collections, 
     depending on the outcome of a check block. 
     Evaluate aTwoArgBlock on the two selected and rejected value collections. 
     Also return the selected values as return value"

    ^ self partition:check as:OrderedCollection into:aTwoArgBlock

    "
     #(1 2 3 4 5 6 7 8)
        partition:[:el | el even]
        into:[:evenElements :oddElements |
            Transcript show:'even: '; showCR:evenElements.
            Transcript show:' odd: '; showCR:oddElements.
        ].
    "

    "Created: / 20-07-2011 / 00:54:41 / cg"
!

reduce:binaryBlock
    "Evaluate the block with the first two elements of the receiver,
     then with the result of the first evaluation and the next element,
     and so on.  Answer the result of the final evaluation. If the receiver
     is empty, raise an error. If the receiver has a single element, answer
     that element.

     Here the reduction is done from right to left.

     See also: #inject:into: #fold:"

    | first nextValue |

    first := true.
    self do:[:each |
        first 
            ifTrue: [first := false. nextValue := each]
            ifFalse: [nextValue := binaryBlock value:each value:nextValue]
    ].
    first ifTrue:[
        ^ self emptyCollectionError.
    ].
    ^ nextValue

    "
     (1 to:15) reduce:[:x :y| '(', x printString, '+', y printString, ')']
     (1 to:15) fold:[:x :y| '(', x printString, '+', y printString, ')']
     #('if' 'it' 'is' 'to' 'be' 'it' 'is' 'up' 'to' 'me') reduce: [:a :b | a, ' ', b]
     #('if' 'it' 'is' 'to' 'be' 'it' 'is' 'up' 'to' 'me') fold: [:a :b | a, ' ', b]
     #(10 1 2 3) reduce:[:el :diff | diff - el] 
     #(10 1 2 3) reduce:[:el :diff | diff + el] 
    "

    "Created: / 28-02-2012 / 21:16:33 / cg"
!

reduceLeft:aTwoArgBlock
    ^ self fold:aTwoArgBlock

    "
     #(1 2 3 4 5) reduceLeft:[:sum :el | sum + el] 
    "

    "Created: / 20-07-2011 / 01:01:03 / cg"
!

reject:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to false"

    ^ self select:[:element | (aBlock value:element) not]

    "
     #(1 2 3 4) reject:[:e | e odd]   
     (1 to:10) reject:[:e | e even]     
    "
!

reject:rejectBlock thenCollect:collectBlock
    "combination of reject followed by collect.
     May be redefined by some subclasses for optimal performance
     (avoiding the creation of intermediate garbage)"

    ^ self select:[:el | (rejectBlock value:el) not] thenCollect:collectBlock

    "
     #(1 2 3 4 5 6 7) reject:[:i | i even] thenCollect:[:i | i * 2]
    "

    "Modified: / 11-07-2010 / 17:04:07 / cg"
!

reject:selectBlock thenDo:doBlock
    "combination of reject followed by do
     Avoids the creation of intermediate garbage"

    self do:[:eachElement |
        (selectBlock value:eachElement) ifFalse:[
            doBlock value:eachElement
        ]
    ].

    "
     #(1 2 3 4 5 6 7) reject:[:i | i even] thenDo:[:i | Transcript showCR:i]
    "
!

reverseDo:aBlock
    "evaluate the argument, aBlock for each element in reverse order."

    "it could be defined in terms of do: - but very inefficient.
     Better force programmer to define a better version ..."

    ^ self subclassResponsibility
!

select:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     See also: #removeAllFoundIn: and #removeAllSuchThat:"

    |newCollection|

    newCollection := self speciesForAdding new.
    self do:[:each |
        (aBlock value:each) ifTrue:[newCollection add:each].
    ].
    ^ newCollection

    "
     #(1 2 3 4) select:[:e | e odd]
     (1 to:10) select:[:e | e even]
    "

    "Modified: / 07-08-2010 / 16:26:40 / cg"
    "Modified: / 20-01-2017 / 17:42:33 / stefan"
!

select:aBlock as:aCollectionClass
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     See also: #removeAllFoundIn: and #removeAllSuchThat:"

    |newCollection idx|

    aCollectionClass growIsCheap ifTrue:[
        newCollection := aCollectionClass new.
        self do:[:each |
            (aBlock value:each) ifTrue:[newCollection add:each].
        ].
    ] ifFalse:[
        newCollection := aCollectionClass new:self size.
        idx := 1.
        self do:[:eachElement |
            (aBlock value:eachElement) ifTrue:[
                newCollection at:idx put:eachElement.
                idx := idx + 1.
            ].
        ].
        newCollection := newCollection copyFrom:1 to:idx-1.
    ].
    ^ newCollection

    "
     #(1 2 3 4) select:[:e | e odd] as:OrderedCollection.
     (1 to:10) select:[:e | e even] as:OrderedCollection.

     #(1 2 3 4) select:[:e | e odd] as:Set.
     (1 to:10) select:[:e | e even] as:Set.

     #(1 2 3 4) select:[:e | e odd] as:ByteArray.
     (1 to:10) select:[:e | e even] as:ByteArray.
    "

    "Created: / 07-08-2010 / 16:26:15 / cg"
!

select:aBlock ifNone:exceptionValue
    "try a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true. If none of the elements passes
     the check of aBlock, return the value from exceptionValue.
     See also: #removeAllFoundIn: and #removeAllSuchThat:"

    |newCollection|

    newCollection := self select:aBlock.
    newCollection isEmpty ifTrue:[^ exceptionValue value].
    ^ newCollection

    "
     #(1 2 3 4) select:[:e | e > 10] ifNone:['sorry']  
     #(1 2 3 4) select:[:e | e > 10] 
    "
!

select:selectBlock thenCollect:collectBlock
    "combination of select followed by collect.
     May be redefined by some subclasses for optimal performance
     (avoiding the creation of intermediate garbage)"

"/  We do not do this now, since some classes reimplement select or collect....
"/    ^ self select:selectBlock thenCollect:collectBlock as:self species
    ^ (self select:selectBlock) collect:collectBlock

    "
     #(1 2 3 4 5 6 7) select:[:i | i even] thenCollect:[:i | i * 2]
    "
!

select:selectBlock thenCollect:collectBlock as:aCollectionClass
    "return a new collection with all elements from the receiver, 
     for which the argument selectBlock evaluates to true.
     Process the elements through collectBlock before adding.
     Returns the same as if three separate collect+select+as: messages were sent,
     but avoids the creation of intermediate collections, 
     so this is nicer for big collections."

    |newCollection|

    newCollection := aCollectionClass new.
    self do:[:each |
        (selectBlock value:each) ifTrue:[newCollection add:(collectBlock value:each)].
    ].
    ^ newCollection

    "
     #(1 2 3 4) select:[:e | e odd] thenCollect:[:e| e*e] as:OrderedCollection  
     (1 to:10) select:[:e | e even] thenCollect:[:e| e*e] as:IdentitySet       
    "

    "Created: / 07-08-2010 / 16:26:15 / cg"
!

select:selectBlock thenDo:doBlock
    "combination of select followed by do.
     The same as if two separate select:+do: messages were sent,
     but avoids the creation of intermediate collections,
     so this is nicer for big collections."

    self do:[:eachElement |
        (selectBlock value:eachElement) ifTrue:[
            doBlock value:eachElement
        ]
    ].

    "
     #(1 2 3 4 5 6 7) select:[:i | i even] thenDo:[:i | Transcript showCR:i]
    "
!

selectWithIndex:aTwoArgBlock
    "return a new collection with all elements from the receiver,
     for which the argument aBlock evaluates to true.
     aTwoArgBlock is called with value and index as arguments."

    |newCollection|

    newCollection := self species new.
    self doWithIndex:[:eachValue :eachKey |
        (aTwoArgBlock value:eachValue value:eachKey) ifTrue:[newCollection add:eachValue].
    ].
    ^ newCollection

    "
     #(10 20 30 40) selectWithIndex:[:e :i | i odd]
     #(10 20 30 40) selectWithIndex:[:e :i | i even]
    "
!

triplesDo:aThreeArgBlock
    "evaluate the argument, aThreeArgBlock for every element in the collection,
     which is supposed to consist of 3-element collections.
     The block is called with 3 arguments for each collection in the receiver."

    self do:[:aTriple |
        aThreeArgBlock value:(aTriple at:1) value:(aTriple at:2) value:(aTriple at:3).
    ]
    "
     #(
        (1 one eins)
        (2 two zwei)
        (3 three drei)
        (4 four vier)
        (5 five #'fuenf')
        (6 six sechs)
     )
     triplesDo:[:num :sym1 :sym2 |
                    Transcript show:num; space; show:sym1; space; showCR:sym2
               ]
    "

    "Modified: 10.5.1997 / 14:15:43 / cg"
!

tuplesDo:anNArgBlock
    "evaluate the argument, anNArgBlock for every element in the collection,
     which is supposed to consist of N-element collections.
     The block is called with N arguments for each collection in the receiver."

    self do:[:aTuple |
        anNArgBlock valueWithArguments:aTuple
    ]
    "
     #(
        (1 one eins uno)
        (2 two zwei due)
        (3 three drei tre)
        (4 four vier quattro)
        (5 five #'fuenf' cinque)
     )
     tuplesDo:[:num :sym1 :sym2 :sym3 |
                    Transcript show:num; space; show:sym1; space; show:sym2; space; showCR:sym3
               ]
    "

    "Modified: 10.5.1997 / 14:15:43 / cg"
!

with:aCollection andDefault:defaultElement collect:aTwoArgBlock
    "like with:collect:, but use defaultElement for missing elements in aCollection
     (i.e. if the receiver is longer)
     The third argument, aBlock must be a two-argument block, which is
     evaluated for each element-pair.
     Collect the results and return a collection containing them.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access).
     Can be used like zip/zipAll in other languages."

    |newCollection|

    newCollection := self speciesForAdding new.
    self with:aCollection andDefault:defaultElement do:[:el1 :el2 |
        newCollection add:(aTwoArgBlock value:el1 value:el2).
    ].
    ^ newCollection as:self species

    "
     (1 to:3) with:#(one two) andDefault:'xxx' collect:[:num :sym | (num->sym)]
     #(1 2 3) with:#(10 20) andDefault:99 collect:[:x :y | (x@y)]
    "
!

with:aCollection andDefault:defaultElement do:aTwoArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aSequenceableCollection.
     If the receiver has more elements than the argument, use defaultElement 
     for remaining evaluations.
     The third argument, aBlock must be a two-argument block.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access)"

    |index  "{ Class: SmallInteger }"|

    index := 1.
    aCollection isSequenceable ifFalse:[
        self isSequenceable ifFalse:[
            ^ self error:'neither collection is sequenceable'.
        ].
        aCollection do:[:element |
            aTwoArgBlock value:(self at:index ifAbsent:defaultElement) value:element.
            index := index + 1
        ]
    ] ifTrue:[
        self do:[:element |
            aTwoArgBlock value:element value:(aCollection at:index ifAbsent:defaultElement).
            index := index + 1
        ]
    ]

    "
     (1 to:3) with:#(one two) andDefault:99 do:[:num :sym |
        Transcript showCR:(num->sym)
     ]
    "
!

with:aCollection collect:aTwoArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aSequenceableCollection;
     The second argument, aBlock must be a two-argument block, which is
     evaluated for each element-pair.
     Collect the results and return a collection containing them.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access).
     Can be used like zip/zipAll in other languages."

    |newCollection|

    newCollection := self speciesForAdding new.
    self with:aCollection do:[:el1 :el2 |
        newCollection add:(aTwoArgBlock value:el1 value:el2).
    ].
    ^ newCollection as:self species

    "
     (1 to:3) with:#(one two three) collect:[:num :sym | (num->sym)]
     #(1 2 3) with:#(10 20 30) collect:[:x :y | (x@y)]
    "
!

with:aCollection conform:aTwoArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aCollection.
     Return true, if the block returns true for all of these pairs.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access)."

    self with:aCollection do:[:a :b |
        (aTwoArgBlock value:a value:b) ifFalse:[^ false].
    ].
    ^ true.

    "
     (1 to:3) with:#(1 2 3 4) conform:[:a :b | a = b]   --- raises an error
     (1 to:3) with:#(1 22 3) conform:[:a :b | a = b]
     (1 to:3) with:#(1 2 3) conform:[:a :b | a = b]
    "
!

with:aCollection contains:aTwoArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aCollection.
     Return true, if the block returns true for any of these pairs.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access)."

    self with:aCollection do:[:a :b |
        (aTwoArgBlock value:a value:b) ifTrue:[^ true].
    ].
    ^ false.

    "
     (1 to:3) with:#(1 2 3 4) contains:[:a :b | a ~= b]   --- raises an error
     (1 to:3) with:#(1 22 3) contains:[:a :b | a ~= b]  
     (1 to:3) with:#(1 2 3) contains:[:a :b | a ~= b]  
    "

    "Created: / 30-06-2011 / 12:37:41 / cg"
    "Modified (Format): / 30-06-2011 / 12:40:38 / cg"
!

with:aCollection count:aTwoArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aSequenceableCollection.
     Count, how often the second argument, aTwoArgBlock returns true.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access)."

    |count  "{ Class: SmallInteger }"|

    count := 0.
    self with:aCollection do:[:el1 :el2 |
        (aTwoArgBlock value:el1 value:el2) ifTrue:[
            count := count + 1
        ]
    ].
    ^ count

    "
     (1 to:3) with:#(1 3 3) count:[:n1 :n2 | n1 = n2]
    "
!

with:aCollection do:aTwoArgBlock
    "evaluate the argument, aBlock for successive elements from
     each the receiver and the argument, aSequenceableCollection.
     The second argument, aBlock must be a two-argument block.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access) 
     or (new!!) if the sizes are different."

    |index  "{ Class: SmallInteger }"|

    aCollection size == self size ifFalse:[
        NotEnoughElementsSignal raiseRequestErrorString:'collections must be of the same size'.
    ].

    index := 1.
    aCollection isSequenceable ifFalse:[
        self isSequenceable ifFalse:[
            ^ self error:'neither collection is sequenceable'.
        ].
        aCollection do:[:element |
            aTwoArgBlock value:(self at:index) value:element.
            index := index + 1
        ]
    ] ifTrue:[
        self do:[:element |
            aTwoArgBlock value:element value:(aCollection at:index).
            index := index + 1
        ]
    ]

    "
     (1 to:3) with:#(one two three) do:[:num :sym |
        Transcript showCR:(num->sym)
     ]

     the following fail because sets do not have ordered elements

     (1 to:3) with:#(one two three) asSet do:[:num :sym |
        Transcript showCR:(num->sym)
     ].
     (1 to:3) asSet with:#(one two three) do:[:num :sym |
        Transcript showCR:(num->sym)
     ]
    "

    "Modified: / 30-06-2011 / 17:39:47 / cg"
    "Modified (comment): / 18-03-2012 / 15:16:50 / cg"
!

with:aCollection reverseDo:aTwoArgBlock
    "evaluate the argument, aBlock in reverse order for successive elements from
     each the receiver and the argument, aSequenceableCollection.
     The second argument, aBlock must be a two-argument block.
     This method fails if neither the receiver nor aCollection is
     a sequenceable collection (i.e. implements numeric key access) 
     or (new!!) if the sizes are different."

    |index  "{ Class: SmallInteger }"|

    aCollection size == self size ifFalse:[
        NotEnoughElementsSignal raiseRequestErrorString:'collections must be of the same size'.
    ].

    index := self size.
    aCollection isSequenceable ifFalse:[
        self isSequenceable ifFalse:[
            ^ self error:'neither collection is sequenceable'.
        ].
        aCollection reverseDo:[:element |
            aTwoArgBlock value:(self at:index) value:element.
            index := index - 1
        ]
    ] ifTrue:[
        self reverseDo:[:element |
            aTwoArgBlock value:element value:(aCollection at:index).
            index := index - 1
        ]
    ]

    "
     (1 to:3) with:#(one two three) reverseDo:[:num :sym |
        Transcript showCR:(num->sym)
     ]

     the following fail because sets do not have ordered elements

     (1 to:3) with:#(one two three) asSet reverseDo:[:num :sym |
        Transcript showCR:(num->sym)
     ].
     (1 to:3) asSet with:#(one two three) reverseDo:[:num :sym |
        Transcript showCR:(num->sym)
     ]
    "

    "Modified: / 30-06-2011 / 17:39:47 / cg"
    "Created: / 18-03-2012 / 15:15:04 / cg"
!

withIndexCollect:aTwoArgBlock
    "same as keysAndValuesCollect:, but with argument order reversed"

    |newCollection|

    newCollection := self speciesForCollecting new.
    self keysAndValuesDo:[:key :value |
        newCollection add:(aTwoArgBlock value:value value:key)
    ].
    ^ newCollection

    "
     #(one two three) withIndexCollect:[:sym :num | (num->sym)] 
     #(10 20 30) withIndexCollect:[:n :i | n*i ]  
    "
!

withIndexDo:aTwoArgBlock 
    "evaluate the argument, aBlock for every element in the collection,
     passing both element and index as arguments.
     Same as doWithIndex:, due to parallel evolution of different Smalltalk dialects"

    ^ self keysAndValuesDo:[:key :index |
        aTwoArgBlock value:index value:key
    ].
! !

!Collection methodsFor:'enumerating-tests'!

allSatisfy:aBlock 
    "evaluate aBlock for each of the receiver's elements. 
     Return true, if aBlock returns true for all elements, false otherwise
     (i.e. false if any element fails to satisfy the block-condition).
     This is an ANSI renomer of #conform:"

    ^ self conform:aBlock.

    "
     #(1 2 3 4 5) allSatisfy:[:el | el odd]   
     #(2 4 6 8 10) allSatisfy:[:el | el odd]  
     #(2 4 6 8 10) allSatisfy:[:el | el even]  
    "

!

anySatisfy:aBlock 
    "evaluate aBlock for each of the receiver's elements. 
     Return true, if aBlock ever returns true, false otherwise
     (i.e. if any element satisfies the block-condition).
     This is an ANSI renomer of #contains:
     (which is a better name, because #contains: is often misread as #includes by beginners)"

    ^ self contains:aBlock.

    "
     #(1 2 3 4 5) anySatisfy:[:el | el odd]   
     #(2 4 6 8 10) anySatisfy:[:el | el odd]  
    "
!

conform:aOneArgBlock
    "return true, if every element conforms to some condition.
     I.e. return false, if aBlock returns false for any element;
     true otherwise. Returns true for empty receivers."

    self do:[:element | 
        (aOneArgBlock value:element) ifFalse:[^ false]
    ].
    ^ true

    "
     #(1 2 3 4 5) conform:[:el | el even]     
     #(2 4 6 8 10) conform:[:el | el even]    
     #() conform:[:el | el even]    
    "

    "Modified: / 13-09-2006 / 11:19:03 / cg"
!

contains:aOneArgBlock 
    "evaluate aOneArgBlock for each of the receiver's elements
     Return true and skip remaining elements, if aBlock ever returns true, 
     otherwise return false.
     (#anySatisfy: is a better name, because #contains: is often misread as #includes by beginners)"

    self do:[:element | 
        (aOneArgBlock value:element) ifTrue:[^ true]
    ].
    ^ false

    "
     #(1 2 3 4 5) contains:[:el | el odd]  
     #(2 4 6 8 10) contains:[:el | el odd]  
    "

    "Modified: / 13-09-2006 / 11:18:36 / cg"
!

noneSatisfy:aBlock 
    "evaluate aBlock for each of the receiver's elements.
     Return true, if aBlock returns false for all elements, false otherwise
     (i.e. false if any element satisfies the block-condition)."

    ^ (self contains:aBlock) not

    "
     #(1 2 3 4 5) noneSatisfy:[:el | el odd]
     #(2 4 6 8 10) noneSatisfy:[:el | el odd]
     #(2 4 6 8 10) noneSatisfy:[:el | el even]
    "

    "Modified: / 13-09-2006 / 11:19:57 / cg"
! !

!Collection methodsFor:'error handling'!

emptyCheck
    "check if the receiver is empty; report an error if so"

    self isEmpty ifTrue:[
        ^ self emptyCollectionError.
    ].
!

emptyCollectionError
    "report an error that the operation is not allowed for empty collections"

    <resource: #skipInDebuggersWalkBack>

    ^ EmptyCollectionSignal raise
!

errorInvalidKey:aKey
    "report an error that the given key was invalid"

    <resource: #skipInDebuggersWalkBack>

    ^ InvalidKeySignal raiseRequestWith:aKey
!

errorNotKeyed
    "report an error that keyed access methods are not allowed"

    <resource: #skipInDebuggersWalkBack>

    ^ self error:(self class name, 's do not respond to keyed accessing messages')
!

errorValueNotFound:anObject
    "report an error that an object was not found in the collection"

    <resource: #skipInDebuggersWalkBack>

    ^ ValueNotFoundSignal raiseRequestWith:anObject

    "Modified: / 30.10.1997 / 15:52:18 / cg"
!

noModificationError
    "a store is attempted into an immutable collection (typically: a literal).
     For our convenience, find the method that contains me, for a nicer error message"

    |creator msg context|

    creator := Method allSubInstances
                detect:[:aMethod | (aMethod referencesGlobal:self)]
                ifNone:nil.
    creator isNil ifTrue:[
        creator := Method allSubInstances
                detect:[:aMethod | (aMethod literalsDetect:[:l | l == self] ifNone:nil) notNil]
                ifNone:nil.
    ].
    creator notNil ifTrue:[
        msg := ' (' , creator whoString , ')'
    ].
    context := thisContext sender.
     "
     this error is reported on an attempt to store into an immutable collection (typically: a literal).
     The literal was created in creator.
     If you press continue in the debugger, the store will be performed.
     If you do not want this, press abort and check your code.
     Storing into literals is VERY VERY bad coding style.
    "
    NoModificationError
        raiseRequestWith:self
        errorString:msg
        in:context.

    "Created: / 03-08-1998 / 14:47:45 / cg"
!

notEnoughElementsError
    "report an error that the operation is not allowed,
     since not enough elements are in the collection"

    <resource: #skipInDebuggersWalkBack>

    ^ NotEnoughElementsSignal raise
! !

!Collection methodsFor:'growing'!

changeCapacityTo:newSize
    newSize > self capacity ifTrue:[
        self grow:newSize
    ].

    "Created: / 30.10.2001 / 17:56:50 / cg"
!

grow
    "make the receiver larger"

    self grow:(self size + self growSize)
!

grow:howBig
    "change the receiver's size"

    ^ self subclassResponsibility
!

growSize
    "return a suitable size increment for growing.
     The default returned here may be (and is) redefined in subclasses."

    ^ self size max:2
! !


!Collection methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "print a representation of the receiver on aGCOrStream for display in inspectors etc."

    |noneYet total limit|

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream nextPutAll:self displayStringName; nextPut:$(.

    thisContext isRecursive ifTrue:[
        'Collection [error]: displayString of self referencing collection.' errorPrintCR.
        aGCOrStream nextPutAll:'"recursive")'.
        ^ self.
    ].

    noneYet := true.
    total := 0.
    limit := self maxPrint.

    self printElementsDo: [:element |
        noneYet ifTrue:[
            noneYet := false.
        ] ifFalse:[
            aGCOrStream space
        ].
        element displayOn:aGCOrStream.
        total := total + 1.
        (total > limit) ifTrue:[
            aGCOrStream nextPutAll:'... )'.
            ^ self
        ]
    ].
    aGCOrStream nextPutAll:')'.

    "
     #(1 2 3 'hello' $a) asOrderedCollection displayString

     (Dictionary new at:#hello put:'world';
                     at:#foo put:'bar'; yourself) displayString
    "

    "Modified: / 20.1.1998 / 14:11:03 / stefan"
    "Modified: / 2.2.1999 / 22:39:44 / cg"
!

displayStringName
    "redefinable helper for displayString"

    ^ self class name

    "Created: / 2.2.1999 / 22:39:33 / cg"
!

maxPrint
    "the print-limit; printOn: will try to not produce more output
     than the limit defined here."

    ^ 5000
!

printElementsDo:aBlock
    "perform aBlock (1 arg) for all elements.
     Used in #printOn:.
     Subclasses (e.g. Dictionary) may redefine this."

    ^ self do:aBlock

    "Created: / 20.1.1998 / 14:11:02 / stefan"
!

printElementsOn:aStream
    "append a user readable representation of the receiver to aStream.
     The text appended is not meant to be read back for reconstruction of
     the receiver. Also, this method limits the size of generated string.
    "

    |limit firstOne s|

    thisContext isRecursive ifTrue:[
        'Collection [error]: printOn: of self referencing collection.' errorPrintCR.
        aStream nextPutAll:'#("recursive")'.
        ^ self
    ].

    aStream nextPut:$(.
    firstOne := true.

    "
     if aStream is not positionable, create an temporary positionable stream
     (needed for limit calculation)
    "
    limit := self maxPrint.
    aStream isPositionable ifTrue:[
        s := aStream.
        limit := s position + limit.
    ] ifFalse:[
        s := CharacterWriteStream new:50.
    ].

    self printElementsDo:[:element |
        firstOne ifFalse:[
            s space
        ] ifTrue:[
            firstOne := false
        ].
        (s position >= limit) ifTrue:[
            s ~~ aStream ifTrue:[
                aStream nextPutAll:(s contents).
            ].
            aStream nextPutAll:'...etc...)'.
            ^ self
        ] ifFalse:[
            element printOn:s.
        ].
    ].
    s ~~ aStream ifTrue:[
        aStream nextPutAll:(s contents).
    ].
    aStream nextPut:$)

    "
     #(1 2 3 'hello' $a $ü) printOn:Transcript
     (Array new:100000) printOn:Transcript
     (Array new:100000) printOn:Stdout
     (Array new:100000) printString size
     (Dictionary new at:#hello put:'world';
                     at:#foo put:'bar'; yourself) printOn:Transcript
    "
    "
     |a| 
     a := Array new:3.
     a at:2 put:a.
     a printOn:Transcript
    "

    "Modified: / 28.1.1997 / 00:39:17 / cg"
    "Modified: / 20.1.1998 / 14:11:03 / stefan"
!

printOn:aStream
    "append a user readable representation of the receiver to aStream.
     The text appended is not meant to be read back for reconstruction of
     the receiver. Also, this method limits the size of generated string.
    "

    thisContext isRecursive ifTrue:[
        'Collection [error]: printOn: of self referencing collection.' errorPrintCR.
        aStream nextPutAll:'#("recursive")'.
        ^ self
    ].

    aStream nextPutAll:self class name.
    self printElementsOn:aStream.

    "
     #(1 2 3 'hello' $a) printOn:Transcript
     (Array new:100000) printOn:Transcript
     (Array new:100000) printOn:Stdout
     (Array new:100000) printString size
     (Dictionary new at:#hello put:'world';
                     at:#foo put:'bar'; yourself) printOn:Transcript
    "
    "
     |a|
     a := Array new:3.
     a at:2 put:a.
     a printOn:Transcript
    "

    "Modified: / 28.1.1997 / 00:39:17 / cg"
    "Modified: / 20.1.1998 / 14:11:03 / stefan"
!

storeOn:aStream
    "output a printed representation onto the argument, aStream.
     The text can be re-read to reconstruct (a copy of) the receiver.
     Recursive (i.e. cyclic) collections cannot be stored correctly
     (use storeBinaryOn: to handle those)."

    |notEmpty|

    thisContext isRecursive ifTrue:[
        RecursiveStoreError raiseRequestWith:self.
        'Collection [error]: storeOn: of self referencing collection.' errorPrintCR.
        aStream nextPutAll:'#recursive'.
        ^ self
    ].

    aStream nextPutAll:'('.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' new'.
    notEmpty := false.
    self do:[:element |
        aStream nextPutAll:' add:'.
        element storeOn:aStream.
        aStream nextPutAll:';'.
        notEmpty := true
    ].
    notEmpty ifTrue:[aStream nextPutAll:' yourself'].
    aStream nextPut:$)

    "
     OrderedCollection new storeOn:Transcript
     (1 to:10) storeOn:Transcript
     (Set new add:1; add:'hello'; yourself) storeOn:Transcript
    "
    "
     |s|

     s := Set new.
     s add:1; add:'hello'; add:s.
     s storeOn:Transcript
    "

    "Modified: / 11.2.2000 / 11:24:56 / cg"
! !

!Collection methodsFor:'queries'!

defaultElement
    ^  nil
!

isReadOnly
    "true if this is a readOnly (immutable) collection.
     Q1: should this be called isImmutable?
     Q2: who uses this?"
    
    ^ false
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    "/ here, true is returned for any.
    "/ nust be redefined in subclasses which do nt allow some (i.e. ByteArray)
    ^ true
!

isWritable
    "true if this is not a readOnly (immutable) collection.
     Q1: should this be called isMutable?
     Q2: who uses this?"

    ^ self isReadOnly not
!

size
    "return the number of elements in the receiver.
     This is usually redefined in subclasses for more performance."

    |count "{ Class: SmallInteger }" |

    count := 0.
    self do:[:element |
        count := count + 1
    ].
    ^ count
!

speciesForAdding
     "like species, but redefined for collections which cannot grow easily.
      Used by functions which create a growing collection (see collect:with:, for example)"

    ^ self species
!

speciesForCollecting
     "like species, but used when doing collect operations.
      Redefined for collections which return a different classes object when doing collect."

    ^ self speciesForAdding
! !

!Collection methodsFor:'searching'!

findFirst:aBlock
    "find the index of the first element, for which evaluation of the argument, aBlock
     returns true; return its index or 0 if none detected.
     This is much like #detect, however, here an INDEX is returned,
     while #detect returns the element."

    ^ self findFirst:aBlock ifNone:0

    "
     #(1 2 3 4 5 6) findFirst:[:x | (x >= 3)]
     #(1 2 3 4 5 6) findFirst:[:x | (x >= 3) and:[x even]]
     #(1 2 3 4 5 6) findFirst:[:x | (x >= 8)]
     'one.two.three' findFirst:[:c | (c == $.)]
     '__one.two.three' findFirst:[:c | (c ~= $_)]
     'one.two.three' findFirst:[:c | (c ~= $_)]
    "

    "Modified: / 21.10.1998 / 18:48:10 / cg"
!

findFirst:aBlock ifNone:exceptionValue
    "find the index of the first element, for which evaluation of the argument, aBlock returns true; 
     return its index or the value from exceptionValue if none detected.
     This is much like #detect:ifNone:, however, here an INDEX is returned,
     while #detect:ifNone: returns the element."

    self subclassResponsibility

    "
     #(1 2 3 4 5 6) findFirst:[:x | (x >= 3)] ifNone:99
     #(1 2 3 4 5 6) findFirst:[:x | (x >= 9)] ifNone:99
    "
!

findLast:aBlock
    "find the last element, for which evaluation of the argument, aBlock returns true.
     Return its index or 0 if none detected."

    ^ self findLast:aBlock ifNone:0

    "
     #(1 99 3 99 5 6) findLast:[:x | (x == 99)]
     'one.two.three' findLast:[:c | (c == $.)]
    "
!

findLast:aBlock ifNone:exceptionValue
    "find the index of the last element, for which evaluation of the argument, aBlock returns true.
     Return its index or the value from exceptionValue if none detected."

    self subclassResponsibility

    "
     #(1 2 3 4 5 6) findLast:[:x | (x >= 3)] ifNone:99
     #(1 2 3 4 5 6) findLast:[:x | (x >= 9)] ifNone:99
    "
!

keysOfLargest:n
    "return the keys (aka indices) of the n largest elements, key of largest last.
     Raises an exception, if the receiver does not contain at least n elements"

    |mySize loopAction actionForFirstN nLargest minInLargest |

    mySize := self size.
    n > mySize ifTrue:[
        self notEnoughElementsError
    ].

    "/ for big collections, it seems to be better to sort only once
    "/ (many individual insert operations into a sortedCollection are expensive)
    "/ Consider using a tree-oriented collection if this becomes a problem
    (n < 50) ifTrue:[
        n == 1 ifTrue:[ 
            |max kMax|

            loopAction := [:k :el | 
                             max := el. kMax := k.
                             loopAction := 
                                [:k :el | 
                                    el > max ifTrue:[
                                        max := el. kMax := k
                                    ].
                                ]
                          ].
            self keysAndValuesDo:[:k :el | loopAction value:k value:el ].
            kMax isNil ifTrue:[ self notEnoughElementsError ].
            ^ Array with:kMax.
        ].
        n == 2 ifTrue:[
            |max1 kMax1 max2 kMax2|

            loopAction := [:k :el | 
                             max1 := el. kMax1 := k.
                             loopAction := 
                                [:k :el | 
                                    el > max1 ifTrue:[
                                        max2 := max1. kMax2 := kMax1.
                                        max1 := el. kMax1 := k
                                    ] ifFalse:[
                                        max2 := el. kMax2 := k
                                    ].
                                    loopAction := 
                                        [:k :el | 
                                            el > max2 ifTrue:[
                                                el > max1 ifTrue:[
                                                    max2 := max1. max1 := el.
                                                    kMax2 := kMax1. kMax1 := k.
                                                ] ifFalse:[
                                                    max2 := el.
                                                    kMax2 := k.
                                                ].
                                            ].
                                        ]
                                ]
                          ].

            self keysAndValuesDo:[:k :el | loopAction value:k value:el ].
            kMax2 isNil ifTrue:[ self notEnoughElementsError ].
            ^ Array with:kMax2 with:kMax1
        ].

        nLargest := SortedCollection new:n.
        nLargest setSortBlock:[:a :b | a key < b key].

        actionForFirstN := 
            [:k :el | 
                nLargest add:(el -> k).
                nLargest size == n ifTrue:[
                    minInLargest := nLargest min key.
                    loopAction := 
                        [:k :el |
                            el > minInLargest ifTrue:[
                                nLargest removeFirst.
                                nLargest add:(el -> k).
                                minInLargest := nLargest min key
                            ].
                        ]
                ].
            ].

        loopAction := actionForFirstN.
        self keysAndValuesDo:[:k :el | loopAction value:k value:el ].
        ^ nLargest collect:[:a | a value].
    ].

    ^ (self keys asNewOrderedCollection 
        sortWith:self asNewOrderedCollection)
            copyFrom:(self size-n+1)

    "
     #(10 35 20 45 30 5) keysOfLargest:1    
     #(10 35 20 45 30 5) keysOfLargest:2    
     #(10 35 20 45 30 5) largest:2          
     #(10 35 20 45 30 5) keysOfLargest:3   
     #(10 35 20 45 30 5) keysOfLargest:5   
     #(10 35 20 45 30 5) keysOfLargest:6   
     #(10 35 20 45 30 5) keysOfLargest:8
      (1 to: 1000) asArray shuffled keysOfLargest:51
    "

    "
     |t1 t2 data|

     data := (1 to:10000) collect:[:i | Random nextInteger ].
     t1 := Time millisecondsToRun:[
        40 timesRepeat:[
            data asSortedCollection at:3 
        ]
     ].
     t2 := Time millisecondsToRun:[
        40 timesRepeat:[
            data keysOfLargest:3
        ].
     ].
     Transcript show:'asSorted-at -> '; show:t1; showCR:'ms'.
     Transcript show:'largest     -> '; show:t2; showCR:'ms'.
    "
!

keysOfSmallest:n
    "return the keys (aka indices) of the n smallest elements, key of largest last.
     Raises an exception, if the receiver does not contain at least n elements"

    |mySize loopAction actionForFirstN nSmallest maxInSmallest |

    mySize := self size.
    n > mySize ifTrue:[
        self notEnoughElementsError
    ].

    "/ for big collections, it seems to be better to sort only once
    "/ (many individual insert operations into a sortedCollection are expensive)
    "/ Consider using a tree-oriented collection if this becomes a problem
    (n < 50) ifTrue:[
        n == 1 ifTrue:[ 
            |min kMin|

            loopAction := [:k :el | 
                             min := el. kMin := k.
                             loopAction := 
                                [:k :el | 
                                    el < min ifTrue:[
                                        min := el. kMin := k
                                    ].
                                ]
                          ].
            self keysAndValuesDo:[:k :el | loopAction value:k value:el ].
            kMin isNil ifTrue:[ self notEnoughElementsError ].
            ^ Array with:kMin.
        ].
        n == 2 ifTrue:[
            |min1 kMin1 min2 kMin2|

            loopAction := [:k :el | 
                             min1 := el. kMin1 := k.
                             loopAction := 
                                [:k :el | 
                                    el < min1 ifTrue:[
                                        min2 := min1. kMin2 := kMin1.
                                        min1 := el. kMin1 := k
                                    ] ifFalse:[
                                        min2 := el. kMin2 := k
                                    ].
                                    loopAction := 
                                        [:k :el | 
                                            el < min2 ifTrue:[
                                                el < min1 ifTrue:[
                                                    min2 := min1. min1 := el.
                                                    kMin2 := kMin1. kMin1 := k.
                                                ] ifFalse:[
                                                    min2 := el.
                                                    kMin2 := k.
                                                ].
                                            ].
                                        ]
                                ]
                          ].

            self keysAndValuesDo:[:k :el | loopAction value:k value:el ].
            kMin2 isNil ifTrue:[ self notEnoughElementsError ].
            ^ Array with:kMin1 with:kMin2
        ].

        nSmallest := SortedCollection new:n.
        nSmallest setSortBlock:[:a :b | a key < b key].

        actionForFirstN := 
            [:k :el | 
                nSmallest add:(el -> k).
                nSmallest size == n ifTrue:[
                    maxInSmallest := nSmallest max key.
                    loopAction := 
                        [:k :el |
                            el < maxInSmallest ifTrue:[
                                nSmallest removeLast.
                                nSmallest add:(el -> k).
                                maxInSmallest := nSmallest max key
                            ].
                        ]
                ].
            ].

        loopAction := actionForFirstN.
        self keysAndValuesDo:[:k :el | loopAction value:k value:el ].
        ^ nSmallest collect:[:a | a value].
    ].

    ^ (self keys asNewOrderedCollection 
        sortWith:self asNewOrderedCollection)
            copyTo:n

    "
     #(10 35 20 45 30 5) keysOfSmallest:1    
     #(10 35 20 45 30 5) keysOfSmallest:2    
     #(10 35 20 45 30 5) smallest:2          
     #(10 35 20 45 30 5) keysOfSmallest:3   
     #(10 35 20 45 30 5) keysOfSmallest:5   
     #(10 35 20 45 30 5) keysOfSmallest:6   
     #(10 35 20 45 30 5) keysOfSmallest:8
      (1 to: 1000) asArray shuffled keysOfSmallest:51 
    "

    "
     |t1 t2 data|

     data := (1 to:10000) collect:[:i | Random nextInteger ].
     t1 := Time millisecondsToRun:[
        40 timesRepeat:[
            data asSortedCollection at:3 
        ]
     ].
     t2 := Time millisecondsToRun:[
        40 timesRepeat:[
            data keysOfSmallest:3
        ].
     ].
     Transcript show:'asSorted-at -> '; show:t1; showCR:'ms'.
     Transcript show:'largest     -> '; show:t2; showCR:'ms'.
    "
!

largest:n
    "return a collection containing the n largest elements, largest last.
     Raises an exception, if the receiver does not contain at least n elements"

    |mySize loopAction nLargest sz_nLargest minInLargest|

    mySize := self size.
    n > mySize ifTrue:[
        self notEnoughElementsError
    ].

    "/ for big collections, it seems to be better to sort only once
    "/ (many individual insert operations into a sortedCollection are expensive)
    "/ Consider using a tree-oriented collection if this becomes a problem
    (n < 50) ifTrue:[
        n == 1 ifTrue:[ ^ Array with:self max ].
        n == 2 ifTrue:[
            |l1 l2|

            loopAction := [:el | 
                            l1 := el. 
                            loopAction := 
                                [:el | 
                                    el > l1 ifTrue:[
                                        l2 := l1. l1 := el
                                    ] ifFalse:[
                                        l2 := el
                                    ].
                                    loopAction := 
                                        [:el | 
                                            el > l2 ifTrue:[
                                                el > l1 ifTrue:[
                                                    l2 := l1. l1 := el
                                                ] ifFalse:[
                                                    l2 := el
                                                ].
                                            ].
                                         ].
                                ]
                          ].

            self do:[:el | loopAction value:el ].
            ^ Array with:l2 with:l1
        ].

        nLargest := SortedCollection new:n.
        sz_nLargest := 0.
        loopAction := 
            [:el | 
                nLargest add:el.
                sz_nLargest := sz_nLargest + 1.
                sz_nLargest == n ifTrue:[
                    loopAction := 
                        [:el |
                            el > minInLargest ifTrue:[
                                nLargest removeFirst.
                                nLargest add:el.
                                minInLargest := nLargest min
                            ].
                        ].
                    minInLargest := nLargest min.
                ].
            ].

        self do:[:el | loopAction value:el ].
        ^ nLargest
    ].

    ^ self asSortedCollection copyTo:n 

    "
     #(10 35 20 45 30 5) largest:1   
     #(10 35 20 45 30 5) largest:2   
     #(10 35 20 45 30 5) largest:3   
     #(10 35 20 45 30 5) largest:5    
     #(10 35 20 45 30 5) largest:6    
     #(10 35 20 45 30 5) largest:8
    "

    "
     |t1 t2 data|

     data := (1 to:100000) collect:[:i | Random nextInteger ].
     t1 := Time millisecondsToRun:[
        40 timesRepeat:[
            data asSortedCollection copyLast:2 
        ]
     ].
     t2 := Time millisecondsToRun:[
        40 timesRepeat:[
            data largest:2
        ].
     ].
     Transcript show:'asSorted -> '; show:t1; showCR:'ms'.
     Transcript show:'largest  -> '; show:t2; showCR:'ms'.
    "
!

longestCommonPrefix
    "return the longest common prefix of my elements.
     Typically used with string collections."

    ^ self longestCommonPrefixCaseSensitive:true

    "
     #('Array' 'ArrayedCollection' 'ArrayOfFoo') longestCommonPrefix 
     #('Arra' 'ArrayedCollection' 'ArrayOfFoo') longestCommonPrefix 
     #('Arra' 'b' 'c') longestCommonPrefix 
     #( (1 2 3 4) (1 2 3) (1 2 3 7) (1 2 3 9 10 11)) longestCommonPrefix
    "

    "Modified: 2.3.1997 / 00:21:41 / cg"
!

longestCommonPrefixCaseSensitive:caseSensitive
    "return the longest common prefix of all of my elements (which must be sequenceable collections).
     Typically used with string collections, 
     especially with completion of selectors or filenames."

    |longest|

    self do:[:eachCollection |
        longest isNil ifTrue:[
            longest := eachCollection
        ] ifFalse:[
            longest := longest commonPrefixWith:eachCollection caseSensitive:caseSensitive
        ]
    ].
    ^ longest.

    "
     #('Array' 'arrayedCollection' 'ARRAYOfFoo') longestCommonPrefixCaseSensitive:false 
     #('Array' 'arrayedCollection' 'ARRAYOfFoo') longestCommonPrefixCaseSensitive:true 
     #('Array' 'ArayedCollection' 'ARRAYOfFoo') longestCommonPrefixCaseSensitive:true   
     #('AAA' 'A11' 'AA2') longestCommonPrefixCaseSensitive:true   
     #('AAA' 'BBB' 'CCC') longestCommonPrefixCaseSensitive:true   
    "
!

longestCommonPrefixIgnoreCase:ignoreCase
    <resource: #obsolete>
    "return the longest common prefix of my elements (which must be sequenceableCollections).
     Typically used with string collections, 
     especially with completion of selectors or filenames."

    ^ self longestCommonPrefixCaseSensitive:ignoreCase not
!

longestCommonSuffix
    "return the longest common suffix (tail) of my elements.
     Typically used with string collections."

    ^ self longestCommonSuffixCaseSensitive:true

    "
     #('abcdefg' '1234cdefg' 'aaaaaadefg') longestCommonSuffix    
    "

    "Modified (comment): / 24-07-2011 / 10:32:15 / cg"
!

longestCommonSuffixCaseSensitive:caseSensitive
    "return the longest common suffix (tail) of my elements
     (which must be sequenceableCollections)."

    |longest|

    self do:[:eachCollection |
        longest isNil ifTrue:[
            longest := eachCollection
        ] ifFalse:[
            longest := longest commonSuffixWith:eachCollection caseSensitive:caseSensitive
        ]
    ].
    ^ longest.

    "
     #('Array' 'ByteArray' 'BigArray') longestCommonSuffixCaseSensitive:false
     #('AAA' 'BBBAA' 'CCCAAAA') longestCommonSuffixCaseSensitive:true
     #('AAA' 'BBB' 'CCC') longestCommonSuffixCaseSensitive:true
    "
!

longestCommonSuffixIgnoreCase:ignoreCase
    <resource: #obsolete>
    "return the longest common suffix (tail) of my elements
     (which must be sequenceableCollections)."

    ^ self longestCommonSuffixCaseSensitive:ignoreCase not
!

max
    "return the maximum value in the receiver collection,
     using #< to compare elements.
     Raises an error, if the receiver is empty."

    ^ self 
        fold:[:maxSoFar :each | 
            maxSoFar < each
                ifTrue:[each]
                ifFalse:[maxSoFar]
        ]

    "
     #(15 1 -9 10 5) max  
     (1 to:15) max  
     (-1 to:-15 by:-1) max  
     (-1 to:-15 by:-4) max  
     (0 to:15 by:4) max     
    "

    "Modified: / 11-07-2010 / 17:05:25 / cg"
!

maxApplying:aBlock
    "return the maximum value from applying aBlock to each element in the receiver collection,
     using aBlock to compare elements.
     Raises an error, if the receiver is empty."

    |ret|

    ret := self 
        inject:nil
        into:[:maxSoFar :this | 
            |v|

            v := aBlock value:this.
            (maxSoFar isNil or:[maxSoFar < v]) 
                ifTrue:[v]
                ifFalse:[maxSoFar]
        ].

    ret isNil ifTrue:[
        ^ self emptyCollectionError.
    ].
    ^ ret.

    "
     #() max                                        -> Error
     #(15 1 -9 -20 10 5) max                        -> 15
     #(15 1 -9 -20 10 5) maxApplying:[:el | el abs] -> 20
    "

    "Created: / 23-08-2010 / 11:02:50 / cg"
    "Modified: / 18-03-2011 / 10:32:29 / cg"
!

min
    "return the minimum value in the receiver collection,
     using < to compare elements.
     Raises an error if the receiver is empty."

    ^ self
        fold:[:minSoFar :each |
            each < minSoFar
                ifTrue:[each]
                ifFalse:[minSoFar]
        ]

    "
     #(15 1 -9 10 5) min
     (1 to:15) min
     (-1 to:-15 by:-1) min
     (-1 to:-15 by:-4) min
    "

    "Modified: / 11-07-2010 / 17:06:38 / cg"
!

minApplying:aBlock
    "return the minimum value from applying aBlock to each element in the receiver collection,
     using aBlock to compare elements.
     Raises an error, if the receiver is empty."

    |ret|

    ret := self 
        inject:nil
        into:[:minSoFar :this |
            |v|

            v := aBlock value:this.
            (minSoFar isNil or:[v < minSoFar]) 
                ifTrue:[v]
                ifFalse:[minSoFar]
        ].
    ret isNil ifTrue:[
        ^ self emptyCollectionError.
    ].
    ^ ret.

    "
     #(15 -1 -9 10 5) min                        -> -9
     #(15 -1 -9 10 5) minApplying:[:el | el abs] -> 1
    "

    "Created: / 23-08-2010 / 11:01:42 / cg"
    "Modified: / 18-03-2011 / 10:32:33 / cg"
!

minMax
    "return the minimum and maximum values in the receiver collection
     as a two element array, using #< to compare elements.
     Raises an error, if the receiver is empty."

    |min max|

    min := max := nil.
    self do:[:each |
        min isNil ifTrue:[
            min := max := each
        ] ifFalse:[
            max < each ifTrue:[
                max := each
            ] ifFalse:[
                each < min ifTrue:[
                    min := each
                ]
            ]
        ]
    ].
    min isNil ifTrue:[
        ^ self emptyCollectionError.
    ].

    ^ Array with:min with:max

    "
     #(15 1 -9 10 5) minMax  
     (1 to:15) minMax  
     (-1 to:-15 by:-1) minMax  
     (-1 to:-15 by:-4) minMax  
     (0 to:15 by:4) minMax     
    "
!

nthLargest:n
    "return the n-largest element"

    ^ (self largest:n) first

    "
     #(10 35 20 45 30 5) nthLargest:1
     #(10 35 20 45 30 5) nthLargest:2
     #(10 35 20 45 30 5) nthLargest:3
     #(10 35 20 45 30 5) nthLargest:5
     #(10 35 20 45 30 5) nthLargest:6 
     #(10 35 20 45 30 5) nthLargest:8
    "

    "
     |t1 t2 data|

     data := (1 to:10000) collect:[:i | Random nextInteger ].
     t1 := Time millisecondsToRun:[
        40 timesRepeat:[
            data asSortedCollection at:6 
        ]
     ].
     t2 := Time millisecondsToRun:[
        40 timesRepeat:[
            data nthLargest:6 
        ].
     ].
     Transcript show:'asSorted-at -> '; show:t1; showCR:'ms'.
     Transcript show:'nthMost     -> '; show:t2; showCR:'ms'.
    "
!

smallest:n
    "return the n smallest elements"

    |mySize loopAction actionForFirstN actionForRest
     nSmallest sz_nSmallest maxInSmallest|

    mySize := self size.
    n > mySize ifTrue:[
        self notEnoughElementsError
    ].

    "/ for big collections, it seems to be better to sort only once
    "/ (many individual insert operations into a sortedCollection are expensive)
    "/ Consider using a tree-oriented collection if this becomes a problem
    (n < 50) ifTrue:[
        n == 1 ifTrue:[ ^ Array with:self min ].
        n == 2 ifTrue:[
            |l1 l2|

            loopAction := [:el | l1 := el.
                                 loopAction :=
                                        [:el |
                                            el < l1 ifTrue:[
                                                l2 := l1. l1 := el
                                            ] ifFalse:[
                                                l2 := el
                                            ].
                                            loopAction := actionForRest
                                        ]
                          ].
            actionForRest := [:el |
                                el < l2 ifTrue:[
                                    el < l1 ifTrue:[
                                        l2 := l1. l1 := el
                                    ] ifFalse:[
                                        l2 := el
                                    ].
                                ].
                             ].

            self do:[:el | loopAction value:el ].
            ^ Array with:l1 with:l2
        ].

        nSmallest := SortedCollection new:n.
        sz_nSmallest := 0.
        actionForFirstN :=
            [:el |
                nSmallest add:el.
                sz_nSmallest := sz_nSmallest + 1.
                sz_nSmallest == n ifTrue:[
                    loopAction := actionForRest.
                    maxInSmallest := nSmallest max.
                ].
            ].
        actionForRest :=
            [:el |
                el < maxInSmallest ifTrue:[
                    nSmallest removeLast.
                    nSmallest add:el.
                    maxInSmallest := nSmallest max
                ].
            ].

        loopAction := actionForFirstN.
        self do:[:el | loopAction value:el ].
        ^ nSmallest
    ].

    ^ self asSortedCollection copyFrom:(self size - n + 1)

    "
     #(10 35 20 45 30 5) smallest:1
     #(10 35 20 45 30 5) smallest:2
     #(10 35 20 45 30 5) smallest:3
     #(10 35 20 45 30 5) smallest:5
     #(10 35 20 45 30 5) smallest:6
      (1 to:10000) asArray shuffled smallest:10
      (1 to:10000) asArray shuffled largest:10
     #(10 35 20 45 30 5) smallest:8
    "

    "
     |t1 t2 data|

     data := (1 to:10000) collect:[:i | Random nextInteger ].
     t1 := Time millisecondsToRun:[
        40 timesRepeat:[
            data asSortedCollection at:3
        ]
     ].
     t2 := Time millisecondsToRun:[
        40 timesRepeat:[
            data smallest:3
        ].
     ].
     Transcript show:'asSorted-at -> '; show:t1; showCR:'ms'.
     Transcript show:'smallest     -> '; show:t2; showCR:'ms'.
    "
! !

!Collection methodsFor:'set operations'!

\ aCollection
    "return a new set containing all elements of the receiver,
     which are NOT also contained in the aCollection
     For large collections you better use a Set for aCollection"

    ^ self select:[:eachElement | (aCollection includes:eachElement) not].

    "
     #(0 1 2 3 4 5 6 7 8 9) \ #(1 2 3) asSet
     #(0 1 2 3 4 5 6 7 8 9) \ #(1 2 3)
     ('hello' \ 'l')

     (Dictionary withKeysAndValues:#(1 'uno' 2 'due' 3 'tre' 4 'quatro'))
        \ (Dictionary withKeysAndValues:#(1 'uno'  4 'quatro'))
    "

    "Modified (comment): / 20-01-2017 / 19:28:00 / stefan"
!

intersect:aCollection
    "return a new set containing all elements of the receiver,
     which are also contained in the argument collection.
     For large collections you better use a Set for aCollection"

    ^ aCollection select:[:eachElement | self includes:eachElement].

    "
     #(0 1 2 3 4 5 6 7 8 9) asSet intersect:#(1 2 3 11)
     #(0 1 2 3 4 5 6 7 8 9) intersect:#(1 2 3 11)

     (Dictionary withKeysAndValues:#(1 'uno' 2 'due' 3 'tre' 4 'quatro'))
        intersect:(Dictionary withKeysAndValues:#(1 'uno'  4 'quatro' 5 'cinque'))
    "

    "Modified: / 20-01-2017 / 19:33:14 / stefan"
!

union:aCollection
    "return a new set containing all elements of the receiver
     plus those of the aCollection"

    |newCollection|

    newCollection := self speciesForAdding new.
    newCollection addAll:self.
    newCollection addAll:aCollection.
    ^ newCollection

    "
     #(0 2 4 6 8) union:#(1 3 5 7)
     #(0 2 4 6 8) union:#(0 1 3 5 7)

     (Dictionary withKeysAndValues:#(1 'uno' 2 'due' 3 'tre' 4 'quatro'))
        union:(Dictionary withKeysAndValues:#(1 'uno'  4 'quatro' 5 'cinque'))
    "

    "Modified (comment): / 20-01-2017 / 19:35:23 / stefan"
!

xor:aCollection
    "return a new set containing all elements,
     which are contained in either the receiver or aCollection, but not in both.

     For large collections you better use Sets for both self and aCollection"

    |newCollection|

    newCollection := self speciesForAdding new.
    aCollection do:[:element |
        (self includes:element) ifFalse:[
            newCollection add:element
        ]
    ].
    self do:[:element|
        (aCollection includes:element) ifFalse:[
            newCollection add:element.
        ].
    ].

    ^ newCollection

    "
     #(0 1 2 3 4 5 6 7 8 9) xor:#(1 2 3 11)
     (Dictionary withKeysAndValues:#(1 'uno' 2 'due' 3 'tre' 4 'quatro'))
        xor:(Dictionary withKeysAndValues:#(1 'uno'  4 'quatro' 5 'cinque'))

    "

    "
     |c1 c2|

     c1 := #( foo bar baz baloo ).
     c2 := #( foe bar banana baloo ).
     c1 symmetricDifference:c2.
     self assert:(c1 symmetricDifference:c2) asSet = (c2 symmetricDifference:c1) asSet
    "

    "Modified (comment): / 20-01-2017 / 19:37:58 / stefan"
! !

!Collection methodsFor:'sorting & reordering'!

sortedBy:aTwoArgBlock
    "Create a copy that is sorted.  Sort criteria is the block that accepts two arguments.
     When the block returns true, the first arg goes first ([:a :b | a > b] sorts in descending order)."

    |newCollection|

    newCollection := self speciesForAdding new:self size.
    self addAllTo:newCollection.
    newCollection sort:aTwoArgBlock.

    ^ newCollection
!

sortedBySelector:aSelector
    "return a new collection containing my elements sorted based on the value of what aSelector returns when sent to my
     elements. Sorting by a selector is so common, that it's worth a separate utility"

    ^ self sortedBy:[:a :b | (a perform:aSelector) < (b perform:aSelector)]

    "
     |a b|

     a := #(123 25235 12 13423423 234234).
     b := a sortedBySelector:#abs
    "
!

topologicalSort
    "Sort a partial ordered collection.
     The receiver consists of tupels defining a partial order.
     Use the algorithm by R. E. Tarjan from 1972.
     Answer an OrderedCollection containing the sorted items"

    ^ self topologicalSortStable: false

    "Modified: / 05-06-2014 / 12:22:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

topologicalSortStable: sortStable
    "Sort a partial ordered collection.
     The receiver consists of tupels defining a partial order.
     Use the algorithm by R. E. Tarjan from 1972.
     Answer an OrderedCollection containing the sorted items.

     If sortStable is true, try to make order stable among
     multiple invocations. If false, stability is not guaranteed.
     "

    |graph roots sorted count|

    "create a graph.
     For each node there is an entry containing the number of references
     and a list of arcs to other nodes"

    graph := sortStable ifTrue:[ OrderedDictionary new ] ifFalse:[ Dictionary new ].

    self do:[:eachTuple|
        |node1|
        node1 := eachTuple first.
        graph at:node1 ifAbsentPut:[OrderedCollection with:0].
        2 to:(eachTuple size) do:[:i|
            |node2 n2|

            node2 := eachTuple at:i.
            "add an arc from node1 to node2"
            (graph at:node1) add:node2.
            "add the node"
            n2 := graph at:node2 ifAbsentPut:[OrderedCollection with:0].
            "increment count on incoming arcs of node2"
            n2 at:1 put:(n2 first + 1).
            node1 := node2.
        ].
    ].

    "now find the root nodes (having zero incoming arcs)"
    roots := OrderedCollection new.
    graph keysAndValuesDo:[:eachKey :eachValue|
        eachValue first = 0 ifTrue:[
            roots add:eachKey
        ].
    ].

    "for each root, out it to the sorted list and remove it from the graph.
     This may cause referenced nodes to be moved to the root"

    sorted := OrderedCollection new:graph size.
    [roots notEmpty] whileTrue:[
        |root eachEntry|

        root := roots removeFirst.
        sorted add:root.
        eachEntry := graph removeKey:root.
        2 to:eachEntry size do:[:i|
            |eachChild eachChildGraph|
            eachChild := eachEntry at:i.
            eachChildGraph := graph at:eachChild.
            count := (eachChildGraph at:1) - 1.
            eachChildGraph at:1 put:count.
            count = 0 ifTrue:[
                roots add:eachChild.
            ].
        ].
    ].

    "if graph is empty, we are done. Otherwise there is a cycle"
    graph notEmpty ifTrue:[
        "search for cycle"
        |checkBlock|

        checkBlock := [:graphEntry :backTrace|
            2 to:graphEntry size do:[:i|
                |eachChild eachChildGraph|
                eachChild := graphEntry at:i.
                (backTrace includesIdentical:eachChild) ifTrue:[
                    backTrace add:eachChild.
                    ProceedableError
                        raiseRequestWith:backTrace reversed
                        errorString:('cycle in ordering: %1' bindWith:(backTrace reversed printStringWithSeparator:' -> ')).
                ].
                eachChildGraph := graph at:eachChild.
                checkBlock value:eachChildGraph value:(backTrace copyWith:eachChild).
            ].
        ].
        graph keysAndValuesDo:[:eachNode :eachGraph|
            checkBlock value:eachGraph value:(OrderedCollection with:eachNode).
        ].
        "should not be reached"
        self error:'cycle in ordering' mayProceed:true.
    ].

    ^ sorted

    "
     #((1 2) (1 3) (3 2)) topologicalSort
     #((1 2) (1 3) (3 2) (4)) topologicalSort

    with cycles:
     #((1 2) (1 3) (3 1)) topologicalSort
     #((1 2) (2 3) (3 1)) topologicalSort
     #((1 2) (2 3) (3 4) (4 1)) topologicalSort
     #((1 1) (1 2) (1 3) (3 2) (4)) topologicalSort

     (Smalltalk allClasses collect:[:eachClass|
        Array with:eachClass superclass with:eachClass
     ]) topologicalSort.

     ((Smalltalk allClasses asSortedCollection:[:a :b| a name < b name])collect:[:eachClass|
        Array with:eachClass superclass with:eachClass
     ]) topologicalSort
    "

    "Modified: / 05-06-2014 / 12:21:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Collection methodsFor:'statistical functions'!

arithmeticMean
    "arithmetic mean value of all elements in the collection"

    ^ self sum / self size

    "
     TestCase assert:( { 1. 2. 3. 4 } arithmeticMean = 2.5).
     TestCase assert:( { 13. 23. 12. 44. 55 } arithmeticMean closeTo: 29.4).
     TestCase assert:( { 13. 23. 12. 44. 55 } standardDeviation closeTo: 19.2431).
    "

    "Created: / 13-04-2011 / 16:52:32 / cg"
!

average
    "average value of all elements in the collection"

    ^ self arithmeticMean

    "
     TestCase assert:( { 1. 2. 3. 4 } average = 2.5).
    "

    "Created: / 18-03-2011 / 10:31:04 / cg"
    "Modified: / 13-04-2011 / 17:09:21 / cg"
!

geometricMean
    "geometric mean value of all elements in the collection"

    ^ self product raisedTo:(1/self size)

    "
     TestCase assert:( { 1. 2. 3. 4. } geometricMean closeTo: 2.21336).
     TestCase assert:( { 1. 2. 3. 4. 5 } geometricMean closeTo: 2.60517).
     TestCase assert:( { 13. 23. 12. 44. 55 } geometricMean closeTo: 24.41932).
    "

    "Created: / 13-04-2011 / 16:53:44 / cg"
!

median
    "Return the middle element, or as close as we can get."

    ^ self asSortedCollection median

    "
     #(10 35 20 45 30 5) median
    "
!

standardDeviation
    "standard deviation value of all elements in the collection,
     which is the complete set and not a sample."

    ^ self variance sqrt

    "
     TestCase assert:( #( 1 2 3 4) arithmeticMean = 2.5).
     TestCase assert:( #(13 23 12 44 55) arithmeticMean closeTo: 29.4).
     TestCase assert:( #(13 23 12 44 55) standardDeviation closeTo: 17.2116).
     TestCase assert:( (1 to: 100) arithmeticMean = ((100 + 1)/2)).
     TestCase assert:( (1 to: 100) standardDeviation = ((100 squared - 1)/12) sqrt).
     TestCase assert:( (1 to: 6) standardDeviation = ((6 squared - 1)/12) sqrt).
    "
!

variance
    "compute the variance over a complete data set (and not of a sample)"

    |mean sumDeltaSquares|

    mean := self arithmeticMean.
    sumDeltaSquares := 0.
    self do:[:each|
        sumDeltaSquares := sumDeltaSquares + ((each - mean) squared).
    ].
    ^ sumDeltaSquares / self size.

    "
        #(1 1 1 1 1 1 1 1 1 1) variance
        #(1 2 3 4 5 6 7 8 9 0) variance
    "
! !

!Collection methodsFor:'testing'!

allElementsHaveTheIdenticalValue
    "true if all elements of the receiver have the same value"

    ^ self identicalValuesComputedBy:[:el | el]

    "
     #(1 2 3 5 6 7 8 9) allElementsHaveTheIdenticalValue
     #(1 1 1 1 1 1) allElementsHaveTheIdenticalValue
     #(1 1 1.0 1.0 1) allElementsHaveTheIdenticalValue
     #(1 1 1.0 1.0 1) allElementsHaveTheSameValue
    "
!

allElementsHaveTheSameValue
    "true if all elements of the receiver have the same value"

    ^ self sameValuesComputedBy:[:el | el]

    "
     #(1 2 3 5 6 7 8 9) allElementsHaveTheSameValue
     #(1 1 1 1 1 1) allElementsHaveTheSameValue
     #(1 1 1.0 1.0 1) allElementsHaveTheSameValue
    "

    "Created: / 21-12-2011 / 15:54:08 / cg"
!

capacity
    "return the number of elements, that the receiver is prepared to take. 
     For most collections, this is the actual size. 
     However, some have more space preallocated to allow
     for faster adding of elements (i.e. there are logical vs. physical sizes).
     Not used by the system; added for ST-80 compatibility."

    ^ self size
!

identicalValuesComputedBy:aBlock
    "true if aBlock answers identical values for all elements of the receiver"

    |first valueForFirstElement|

    first := true.
    self do:[:each |
        first ifTrue:[
            first := false.
            valueForFirstElement := aBlock value:each.
        ] ifFalse:[
            valueForFirstElement == (aBlock value:each) ifFalse:[
                ^ false.
            ].
        ].
    ].
    ^ true

    "
     #(1 2 3 5 6 7 8 9) sameValuesComputedBy:[:el | el even]
     #(1 1 1 1 1 1) sameValuesComputedBy:[:el | el even]
     #(1 1 1.0 1.0 1) sameValuesComputedBy:[:el | el even]
     #(1 3 3 15 1) sameValuesComputedBy:[:el | el even]
    "

    "Created: / 21-12-2011 / 15:59:19 / cg"
!

includes:searchedElement
    "return true, if an element equal to the argument, searchedElement is in the collection.
     This compares using #= (i.e. it does not look for the object itself,
     instead, one that compares equal).
     See #includesIdentical: when identity is asked for.
     This is a *very* slow fallback - many subclasses redefine this for performance."

    self do:[:eachElement |
        (searchedElement = eachElement) ifTrue:[^ true].
    ].
    ^ false

    "Modified (format): / 30-04-2016 / 17:10:22 / cg"
!

includesAll:aCollection
    "return true if the receiver includes all elements of
     the argument, aCollection; false if any is missing.
     Notice: this method has O² runtime behavior and may be
             slow for big receivers/args.
             Think about using a Set, or Dictionary."

    ^ aCollection conform:[:element | (self includes:element)]

    "
     #(1 2 3 4 5 6 7) includesAll:#(1 2 3)
     #('hello' 'there' 'world') includesAll:#('hello' 'world')
     #(1 2 3 4 5 6 7) includesAll:#(7 8 9)
    "

    "Modified: / 13-10-2006 / 12:54:50 / cg"
!

includesAny:searchedElementsCollection
    "return true if the receiver includes any from the argument, aCollection.
     Return false if it includes none.
     Uses #= (value compare)
     Notice:
        this method has O² runtime behavior for some subclasses and may be slow for big receivers/args.
        Think about using a Set or Dictionary.
        Some speedup is also possible, by arranging highly
        probable elements towards the beginning of aCollection, to avoid useless searches.

        Also: I am not sure, if (and if so, at which breakeven),
        it is better to reverse the loops, and walk over the receiver's
        elements once, walking over the searched elements in the inner loop.
        If the receiver is large, caching effects will definitely favour this.
    "

    |mySize searchedSize|

    mySize := self size.
    searchedSize := searchedElementsCollection size.
    "/ avoid this only for big receivers, due to caching effects
    (mySize < searchedSize) ifTrue:[
        self do:[:existingElement |
            (searchedElementsCollection includes:existingElement) ifTrue:[^ true].
        ].
    ] ifFalse:[
        searchedElementsCollection do:[:searchedElement |
            (self includes:searchedElement) ifTrue:[^ true].
        ].
    ].
    ^ false

    "
     #(1 2 3 4 5 6 7) includesAny:#(1 2 3)
     #('hello' 'there' 'world') includesAny:#('hello' 'world')
     #(1 2 3 4 5 6 7) includesAny:#(7 8 9)
     #(1 2 3 4 5 6 7) includesAny:#(8 9 10)

     |coll|
     coll := (1 to:10000) asOrderedCollection.
     Time millisecondsToRun:[
        1000000 timesRepeat:[ coll includesAny:#(500 600) ]
     ].

     |coll|
     coll := (1 to:10000) asOrderedCollection.
     Time millisecondsToRun:[
        100000 timesRepeat:[ coll includesAny:#(-1 -10) ]
     ].

     Notice: it is redefined for string search in a subclass:

     |coll|
     coll := String new:10000 withAll:$a.
     coll at:500 put:$b.
     Time millisecondsToRun:[
        100000 timesRepeat:[ coll includesAny:'bc' ]
     ].

     |coll|
     coll := String new:10000 withAll:$a.
     Time millisecondsToRun:[
        100000 timesRepeat:[ coll includesAny:'bc' ]
     ].

    "

    "Modified (comment): / 30-04-2016 / 17:13:33 / cg"
!

includesAnyIdentical:searchedElementsCollection
    "return true, if the receiver includes any from the argument, aCollection.
     Return false if it includes none.
     Use identity compare for comparing.
     Notice:
        this method has O² runtime behavior for some subclasses and may be slow for big receivers/args.
        Think about using a Set or Dictionary.
        Some speedup is also possible, by arranging highly
        probable elements towards the beginning of aCollection, to avoid useless searches."

    searchedElementsCollection do:[:element |
        (self includesIdentical:element) ifTrue:[^ true].
    ].
    ^ false

    "
     #(1 2 3 4 5 6 7) includesAnyIdentical:#(1 2 3)
     #('hello' 'there' 'world') includesAnyIdentical:#('hello' 'world')
     #(1 2 3 4 5 6 7) includesAnyIdentical:#(7 8 9)
     #(1 2 3 4 5 6 7) includesAnyIdentical:#(8 9 10)
    "

    "Modified (comment): / 30-04-2016 / 17:13:38 / cg"
!

includesIdentical:searchedElement
    "return true, if the argument, searchedElement is in the collection.
     This compares using #== (i.e. object identity).
     See #includes: when equality is asked for.
     This is a *very* slow fallback - many subclasses redefine this for performance."

    self do:[:eachElement |
        (searchedElement == eachElement) ifTrue:[^ true].
    ].
    ^ false

    "Modified (comment): / 30-04-2016 / 17:10:34 / cg"
!

isCollection
    "return true, if the receiver is some kind of collection;
     true is returned here - the method is redefined from Object."

    ^ true
!

isEmpty
    "return true, if the receiver is empty"

    ^ self size == 0
!

isEmptyOrNil
    "return true if I am nil or an empty collection - true here, if the receiver's size is 0,
     (from Squeak)"

    ^ self isEmpty

    "Created: / 13.11.2001 / 13:17:12 / cg"
    "Modified: / 13.11.2001 / 13:28:35 / cg"
!

isNilOrEmptyCollection
    "return true if I am nil or an empty collection - false here.
     Obsolete, use isEmptyOrNil."

    <resource:#obsolete>

    ^ self isEmpty

    "Modified: / 13.11.2001 / 13:27:55 / cg"
!

isNonByteCollection
    "return true, if the receiver is some kind of collection, but not a String, ByteArray etc.;
     true is returned here - the method is redefined from Object."

    ^ true
!

isOrdered
    "return true, if the receiver's elements are ordered.
     This defaults to true here, and is to be redefined by collections which use
     hashing, and the order of keys and values is therefore not guaranteed to remain
     the same, as objects are added.
     Notice, that this query might be useless/false for some collections;
     for example, a file directory may change its order even though smalltalk does not touch it;
     or a collection which is based on computed block values may return completely differently
     ordered elements (also random value collections, etc.).
     Therefore, use this only as a hint
     (e.g. when showing values, to avoid sorting and destroying
      any previous order in the visual representation)"

    ^ true
!

isSorted
    "return true, if the receiver is sorted.
     Collections which hold their elements in sorted order
     should return true. Some algorithms (quicksort) degenerate when
     operating on sorted collections and can be avoided if this information
     is given. The default returned here (false) should not hurt.
     I.e. you should NEVER depend on that in your application."

    ^ false

    "Created: 13.4.1996 / 12:35:55 / cg"
!

isSortedBy:aBlock
    "return true, if my elements are sorted (already) by the given criterion (sortBlock).
     Collections which hold their elements in sorted order
     should return true. Some algorithms (quicksort) degenerate when
     operating on sorted collections and can be avoided if this information
     is given. The default returned here (false) should not hurt.
     I.e. you should NEVER depend on that in your application."

    ^ false
!

isSortedCollection
    "return true, if the receiver is a sortedCollection."

    ^ false

!

notEmpty
    "return true, if the receiver is not empty"

    ^ self isEmpty not
!

notEmptyOrNil
    "Squeak compatibility:
     return true if I am neither nil nor an empty collection."

    ^ self notEmpty
!

occurrencesOf:anElement
    "return the number of occurrences of the argument, anElement in
     the receiver. Uses #= (i.e. equality) compare."

    |count "{ Class: SmallInteger }" |

    count := 0.
    self do:[:element |
        (anElement = element) ifTrue:[
            count := count + 1
        ].
    ].
    ^ count
!

occurrencesOfAny:aCollectionOfElements
    "return the number of occurrences of any in aCollectionOfElements in the receiver.
     Uses #= (i.e. equality) compare.
     Should be redefined in subclass(es) if ever used heavily."

    |count "{ Class: SmallInteger }" |

    count := 0.
    aCollectionOfElements do:[:element |
        count := count + (self occurrencesOf:element)
    ].
    ^ count

    "
     #(1 4 6 8 4 1) occurrencesOfAny:#(1 4)
     #(1 4 6 8 4 1) occurrencesOfAny:#(2 5)
     'hello world' occurrencesOfAny:'hel'
    "
!

sameValuesComputedBy:aBlock
    "true if aBlock answers equal values for all elements of the receiver"

    |first valueForFirstElement|

    first := true.
    self do:[:each |
        first ifTrue:[
            first := false.
            valueForFirstElement := aBlock value:each.
        ] ifFalse:[
            valueForFirstElement = (aBlock value:each) ifFalse:[
                ^ false.
            ].
        ].
    ].
    ^ true

    "
     #(1 2 3 5 6 7 8 9) sameValuesComputedBy:[:el | el even]
     #(1 1 1 1 1 1) sameValuesComputedBy:[:el | el even]
     #(1 1 1.0 1.0 1) sameValuesComputedBy:[:el | el even]
     #(1 3 3 15 1) sameValuesComputedBy:[:el | el even]
    "

    "Created: / 21-12-2011 / 15:59:19 / cg"
! !

!Collection methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceCollection:self level:level from:referrer


! !

!Collection methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitCollection:with: to aVisitor"

    ^ aVisitor visitCollection:self with:aParameter
! !


!Collection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Collection initialize!
