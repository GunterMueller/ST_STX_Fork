"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

Collection subclass:#Set
	instanceVariableNames:'tally keyArray'
	classVariableNames:'DeletedEntry NilEntry'
	poolDictionaries:''
	category:'Collections-Unordered'
!

Object subclass:#EmptySlot
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Set
!

Object subclass:#NilKey
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	privateIn:Set
!

!Set class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    a Set is a collection where each element occurs at most once.
    The inclusion test is done using equality (=) for comparison; 
    see IdentitySet for sets using identity compare.
    Keep in mind, that a regular Set therefore treats 3.0 and 3 as equal
    and therefore:
        (Set with:3.0) includes:3
    will return true (since 3.0 and 3 are equal).
    In contrast, an IdentitySet will return false, because 3.0 and 3 are not
    identical.

    Sets use hashing for fast access, this access is considerably faster,
    if a good hash-number is returned by the elements.

    Notice that the default hash (Object>>hash) is not perfect; due to
    the implementation of hash-keys in ST/X, increased hash collisions
    are to be expected for large sets (say: > 20000 element). 
    If your objects are heavyly used in sets or dictionaries, and you need
    big collections, your instances may provide a better hash values.

    Performance hints: 
      If only symbols or smallIntegers are used as keys, 
      use an instance of IdentitySet for slightly better performance, 
      since both hashing and comparison is faster.

      If you have a rough idea how big the set is going to grow,
      create it using #new: instead of #new. Even if the size given is a
      poor guess (say half of the real size), there is some 20-30% performance
      win to expect, since many resizing operations of the set are avoided
      (resizing is expensive, as the set does a rehash).

    Examples:

        |s|
        s := Set new.
        s add:'hello'.
        s add:'world'.
        s add:#foo.
        s add:1.2345678.
        s add:'hello'.

        s printCR.
        's size -> ' print. s size printCR.
        '(s includes:''hello'') -> ' print. (s includes:'hello') printCR.
        '(s includes:#foo)    -> ' print. (s includes:#foo) printCR.
        '(s includes:''foo'')   -> ' print. (s includes:'foo') printCR.
        '(s includes:#bar)    -> ' print. (s includes:#bar) printCR.

    [author:]
        Claus Gittinger
"
! !

!Set class methodsFor:'initialization'!

initialize
    "initialize the Set class"

    DeletedEntry isNil ifTrue:[
        DeletedEntry := EmptySlot new.
        NilEntry := NilKey new.
    ].

    "
        Set initialize
    "

    "Modified: 24.1.1997 / 21:09:00 / cg"
! !

!Set class methodsFor:'instance creation'!

decodeFromLiteralArray:anArray
    "create & return a new instance from information encoded in anArray."

    |set 
     sz "{ Class: SmallInteger }"|

    sz := anArray size.
    set := self new:sz-1.
    2 to:sz do:[:idx| set add:(anArray at:idx) decodeAsLiteralArray].
    ^ set

    "
     (Set with:1234
          with:(1 @ 2)
          with:'hello'
     ) literalArrayEncoding decodeAsLiteralArray    
    "
!

new
    "return a new empty Set"

    ^ self new:7
!

new:anInteger
    "return a new empty Set with space for anInteger elements"

    "
     make it somewhat bigger; hashing works better if fill grade is
     below 10% (make it 75% here ..)
    "
    ^ self basicNew initializeForCapacity:(anInteger * 4 // 3)
! !

!Set class methodsFor:'queries'!

goodSizeFrom:arg 
    "return a good array size for the given argument.
     Returns the next prime after arg, since prime sizes are good for hashing."

    |n|

    "/ arg <= 11 ifTrue:[^ 11].
    "/ n := arg * 3 // 2.

    arg <= 7 ifTrue:[^ 7].
    n := arg.

    "
     mhmh - this returns good numbers for collections with up-to about
     500k elements; if you have bigger ones, add some more primes here ...
    "
    n <= 524288 ifTrue:[
           "2  4  8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288"
        ^ #(7  7 11 17 37 67 131 257 521 1031 2053 4099 8209 16411 32771 65537 131101 262147 524309) at:(n highBit)
    ].

    ^ n nextPrime
! !

!Set class methodsFor:'utilities'!

rehashAllSubInstances
    "rehash all sets & dictionaries.
     Useful utility if hash/identityHash method was changed
     of some object which is known to be kept in a set"

     self allSubInstances do:[:s | s rehash]

    "
     Set rehashAllSubInstances
    "

    "Created: / 24.10.1997 / 23:13:44 / cg"
! !

!Set methodsFor:'Compatibility-ST80'!

initialIndexFor:hashKey boundedBy:length
    "for ST-80 compatibility only; it is (currently) not used in this
     implementation of sets. Therefore, in ST/X it does not make sense
     to redefine it. (which may be a bad design decision, but slightly
     improves performance, by avoiding an extra message send ...)"

    |index "{ Class:SmallInteger }"|

    index := hashKey bitAnd:16r3FFFFFFF.
    index < 16r1FFFFFFF ifTrue:[
	index := index * 2
    ].
    index := index \\ length + 1.
    ^ index.

    "Modified: 1.3.1997 / 01:01:13 / cg"
! !

!Set methodsFor:'Compatibility-Squeak'!

copyWithout:elementToSkip
    "return a new collection consisting of a copy of the receiver, with
     ALL elements equal to elementToSkip are left out.
     No error is reported, if elementToSkip is not in the collection."

    ^ self select:[:each | each ~= elementToSkip]

    "
     #(1 2 3 4 5 6 7) asSet copyWithout:5
    "
!

copyWithoutAll:elementsToSkip
    "return a new collection consisting of a copy of the receiver, with
     ALL elements equal to elementToSkip are left out.
     No error is reported, if elementsToSkip is not in the collection."

    elementsToSkip size * self size > 10000 ifTrue:[
        "speed up everything"
        ^ self \ (elementsToSkip asSet).
    ].
    ^ self \ elementsToSkip

    "
     #(1 2 3 4 5 6 7) asSet copyWithoutAll:#(3 5 7 9)
     #(a b c d e f) asIdentitySet copyWithoutAll:#(d e f)
     #('a' 'b' 'c' 'd' 'e' 'f') asIdentitySet copyWithoutAll:#('d' 'e' 'f')
     #('a' 'b' 'c' 'd' 'e' 'f') asSet copyWithoutAll:#('d' 'e' 'f')
    "
!

like:anObject
    "Answer an object in the receiver that is equal to anObject,
     nil if no such object is found. 
     Relies heavily on hash properties (i.e. that two object's hashes are equal
     if the two object compare equal)"

    ^ self elementAt:anObject ifAbsent:[ nil ]

    "
     (Set withAll:#(10.0 20.0 30.0 40.0)) like:20
    "
! !

!Set methodsFor:'accessing'!

addFirst:anObject
    "add the argument, anObject to the receiver.
     If the receiver is ordered, the new element will be added at the beginning.
     An error is raised here - it does not make sense for unordered collections"

    ^ self shouldNotImplement
!

at:index
    "report an error: at: is not allowed for Sets"

    ^ self errorNotKeyed
!

at:index put:anObject
    "report an error: at:put: is not allowed for Sets"

    ^ self errorNotKeyed
!

elementAt:anObject
    "return the element, if contained in the set.
     If there is none, report an error.
     This may seem confusing at first - however, it is useful with
     non-identitysets, to find an existing element, for a 
     given equal (but not identical) object.
     This is the same functionality as provided by the goodies/KeyedSet goody."

    ^ self elementAt:anObject ifAbsent:[^ self errorNotFound].

    "Modified: 20.3.1997 / 20:35:24 / cg"
!

elementAt:anObject ifAbsent:exceptionBlock
    "return the element, if contained in the set.
     If there is none, return the result from evaluating exceptionBlock.
     This may seem confusing at first - however, it is useful with
     non-identitysets, to find an existing element, for a 
     given equal (but not identical) object.
     This is the same functionality as provided by the goodies/KeyedSet
     goody."

    |index "{ Class: SmallInteger }"  ret|

    index := self find:(anObject ? NilEntry)ifAbsent:0.
    index == 0 ifTrue:[
        ^ exceptionBlock value
    ].
    ret := keyArray basicAt:index.
    ret == NilEntry ifTrue:[
        ret := nil.
    ].
    ^ ret.

    "Created: 20.3.1997 / 20:34:07 / cg"
    "Modified: 20.3.1997 / 20:35:49 / cg"
!

removeLast
    "remove the last element from the receiver.
     Return the removed element.
     An error is raised here - it does not make sense for unordered collections"

    ^ self shouldNotImplement
!

reverseDo:aBlock
    "evaluate the argument, aBlock for each element in reverse order.
     An error is raised here - it does not make sense for unordered collections"

    ^ self shouldNotImplement
! !

!Set methodsFor:'adding & removing'!

add:keyArg
    "add the argument, anObject to the receiver.
     Return the added element.

     WARNING: do not add elements while iterating over the receiver.
              Iterate over a copy to do this."

    |key index "{ Class: SmallInteger }"|

    keyArg isNil ifTrue:[
        key := NilEntry.
    ] ifFalse:[
        key := keyArg.
    ].

    index := self findKeyOrNil:key.
    (keyArray basicAt:index) isNil ifTrue:[
        "/ not already there
        keyArray basicAt:index put:key.
        tally := tally + 1.

        self possiblyGrow.
    ].
    ^ keyArg

    "Modified: 30.1.1997 / 14:58:08 / cg"
!

clearContents
    "remove all elements from the receiver, but do not resize.
     Returns the receiver."

    keyArray atAllPut:nil.
    tally := 0.
!

remove:oldObjectArg ifAbsent:exceptionBlock
    "remove the first occurrence of oldObject from the collection and return it.
     If it was not in the collection return the value of exceptionBlock.
     Notice, that the returned object could be non-identical to the argument
     (although it will always be equal).

     WARNING: do not remove elements while iterating over the receiver.
              See #saveRemove: to do this."

    |oldObject index next removedObject|

    oldObjectArg isNil ifTrue:[
        oldObject := NilEntry.
    ] ifFalse:[
        oldObject := oldObjectArg.
    ].

    index := self find:oldObject ifAbsent:0.
    index == 0 ifTrue:[^ exceptionBlock value].

    removedObject := keyArray basicAt:index.
    keyArray basicAt:index put:nil.
    tally := tally - 1.
    tally == 0 ifTrue:[
        keyArray := self keyContainerOfSize:(self class goodSizeFrom:0). 
    ] ifFalse:[
        index == keyArray basicSize ifTrue:[
            next := 1
        ] ifFalse:[
            next := index + 1.
        ].
        (keyArray basicAt:next) notNil ifTrue:[
            keyArray basicAt:index put:DeletedEntry.
        ].
        self possiblyShrink
    ].
    removedObject == NilEntry ifTrue:[
        removedObject := nil.
    ].
    ^ removedObject

    "Modified: / 16.11.2001 / 10:14:24 / cg"
!

removeAll
    "remove all elements from the receiver. Returns the receiver."

    self initializeForCapacity:7.

    "Modified: 12.4.1996 / 13:35:06 / cg"
!

removeIdentical:oldObjectArg ifAbsent:exceptionBlock
    "remove oldObject from the collection and return it.
     If it was not in the collection return the value of exceptionBlock.
     Uses identity compare (==) to search for an occurrence.

     WARNING: do not remove elements while iterating over the receiver.
              See #saveRemove: to do this."

    |oldObject index next|

    oldObjectArg isNil ifTrue:[
        oldObject := NilEntry.
    ] ifFalse:[
        oldObject := oldObjectArg.
    ].

    "first a quick check. 
     There is a high possibility that objects, which are
     equal are also identical"
    index := self find:oldObject ifAbsent:0.
    index ~~ 0 ifTrue:[
        oldObject ~~ (keyArray basicAt:index) ifTrue:[
            index := 0.
        ]
    ].
    index == 0 ifTrue:[
        "have to go the long and hard path..."
        index := self findIdentical:oldObject ifAbsent:0.
        index == 0 ifTrue:[^ exceptionBlock value].
    ].

    keyArray basicAt:index put:nil.
    tally := tally - 1.
    tally == 0 ifTrue:[
        keyArray := self keyContainerOfSize:(self class goodSizeFrom:0). 
    ] ifFalse:[
        index == keyArray basicSize ifTrue:[
            next := 1
        ] ifFalse:[
            next := index + 1.
        ].
        (keyArray basicAt:next) notNil ifTrue:[
            keyArray basicAt:index put:DeletedEntry.
        ].
        self possiblyShrink
    ].
    ^ oldObjectArg
!

safeRemove:oldObject 
    "remove the element, oldObject from the collection.
     Return the element 
     (could be non-identical to oldObject, since I hash on equality, not on identity).
     If it was not in the collection return nil.

     In contrast to #remove:, this does not resize the underlying collection
     and therefore does NOT rehash & change the elements order.
     Therefor this can be used while enumerating the receiver,
     which is not possible if #remove: is used.

     WARNING: since no resizing is done, the physical amount of memory used
              by the container remains the same, although the logical size shrinks.
              You may want to manually resize the receiver using #emptyCheck.
              (after the loop)"

    ^ self safeRemove:oldObject ifAbsent:[].

    "Created: / 16.11.2001 / 10:23:48 / cg"
    "Modified: / 16.11.2001 / 10:24:03 / cg"
!

safeRemove:oldObjectArg ifAbsent:exceptionValueProvider
    "remove the element, oldObject from the collection.
     Return the element 
     (could be non-identical to oldObject, since I hash on equality, not on identity).
     If it was not in the collection return the value of exceptionValueProvider.

     In contrast to #remove:, this does not resize the underlying collection
     and therefore does NOT rehash & change the elements order.
     Therefore this can be used while enumerating the receiver,
     which is not possible if #remove: is used.

     WARNING: since no resizing is done, the physical amount of memory used
              by the container remains the same, although the logical size shrinks.
              You may want to manually resize the receiver using #emptyCheck.
              (after the loop)"

    |oldObject
     index "{ Class:SmallInteger }"
     next  "{ Class:SmallInteger }"
     removedObject|

    oldObjectArg isNil ifTrue:[
        oldObject := NilEntry.
    ] ifFalse:[
        oldObject := oldObjectArg.
    ].

    index := self find:oldObject ifAbsent:0.
    index == 0 ifTrue:[^ exceptionValueProvider value].

    removedObject := keyArray basicAt:index.
    keyArray basicAt:index put:nil.

    tally := tally - 1.
    tally ~~ 0 ifTrue:[
        index == keyArray basicSize ifTrue:[
            next := 1
        ] ifFalse:[
            next := index + 1.
        ].
        (keyArray basicAt:next) notNil ifTrue:[
            keyArray basicAt:index put:DeletedEntry
        ].
    ].
    removedObject == NilEntry ifTrue:[
        removedObject := nil.
    ].
    ^ removedObject

    "does NOT work:

        |s|

        s := Set new.
        s add:1.
        s add:2.
        s add:3.
        s add:4.
        s add:5.
        s add:6.
        s add:7.
        s add:8.
        s add:9.
        s do:[:v |
            v odd ifTrue:[
                s remove:v 
            ]
        ].
        s inspect
    "

    "DOES work:

        |s|

        s := Set new.
        s add:1.
        s add:2.
        s add:3.
        s add:4.
        s add:5.
        s add:6.
        s add:7.
        s add:8.
        s add:9.
        s do:[:v |
            v odd ifTrue:[
                s safeRemove:v 
            ]
        ].
        s inspect
    "

    "Created: / 1.3.1996 / 21:14:26 / cg"
    "Modified: / 16.11.2001 / 10:22:59 / cg"
!

saveRemove:oldObject 
    <resource: #obsolete>
    "bad spelling - kept for backward compatibility (2014-06-04)"

    ^ self safeRemove:oldObject.
!

saveRemove:oldObjectArg ifAbsent:exceptionValueProvider
    <resource: #obsolete>
    "bad spelling - kept for backward compatibility (2014-06-04)"

    ^ self safeRemove:oldObjectArg ifAbsent:exceptionValueProvider.
!

testAndAdd:keyArg
    "add the argument, anObject to the receiver.
     Answer true, if the element did already exist in the collection,
     false otherwise.

     WARNING: do not add elements while iterating over the receiver.
              Iterate over a copy to do this."

    |key index "{ Class: SmallInteger }"|

    keyArg isNil ifTrue:[
        key := NilEntry.
    ] ifFalse:[
        key := keyArg.
    ].

    index := self findKeyOrNil:key.
    (keyArray basicAt:index) isNil ifTrue:[
        "/ not already there
        keyArray basicAt:index put:key.
        tally := tally + 1.

        self possiblyGrow.
        ^ false.
    ].
    ^ true.

    "Modified: 30.1.1997 / 14:58:08 / cg"
! !


!Set methodsFor:'comparing'!

= aCollection
    "return true, if the argument is a Set containing the same elements
     as I do"

    aCollection species ~~ self species ifTrue:[^ false].
    aCollection size ~~ self size ifTrue:[^ false].
    "/ same number of elements; since I am a Set, all of
    "/ of my elements must be in the other collection ...
    self do:[:eachElement | (aCollection includes:eachElement) ifFalse:[^ false]].
    ^ true.

    "
     #(1 2 3 4 5) asSet = #(2 3 4 5 1) asSet
     #(nil 1 2 3 4 5) asSet = #(2 3 4 5 1) asSet
     #(1 2 3 4 5) asSet = #(2 3 4 5 1.0) asSet 
     #(1 2 3 4 5) asSet = #(2 3 4 5 'one') asSet 
    "
    "
     |d1 d2|

     d1 := Dictionary new.
     d2 := Dictionary new.
     d1 at:1 put:'one'.
     d1 at:'one' put:1.
     d1 at:2 put:#two.
     d1 at:1 put:'one'.
     d1 at:'one' put:1.
     d1 at:2 put:#two.

     d2 at:1 put:'one'.
     d2 at:'one' put:1.
     d2 at:2 put:#two.
     d2 at:1 put:'one'.
     d2 at:'one' put:1.
     d2 at:2 put:#two.
     d1 = d2     
    "

    "
     |d1 d2|

     d1 := Dictionary new.
     d2 := Dictionary new.
     d1 at:1 put:'uno'.
     d1 at:'one' put:1.
     d1 at:2 put:#two.
     d1 at:1 put:'one'.
     d1 at:'one' put:1.
     d1 at:2 put:#two.

     d2 at:1 put:'one'.
     d2 at:'one' put:1.
     d2 at:2 put:#two.
     d2 at:1 put:'one'.
     d2 at:'one' put:1.
     d2 at:2 put:#two.
     d1 = d2     
    "

    "Modified: / 13-10-2006 / 12:58:43 / cg"
!

hash
    "return a hash key for the receiver"

    "this hash is stupid - but for larger collections, the hashing
     time can become much bigger than the time lost in added probing.
     Time will show ...
     Notice & warning:
        if the #= method is ever changed to compare non-dictionaries equal,
        the code below must be changed to assert that the same hash-value is 
        still returned.
        (which may be hard to acomplish)
    "

    |mySize|

    mySize := self size.
    mySize == 0 ifTrue:[^ 0].
    ^ (self anElement hash times:mySize) bitAnd:16r3FFFFFFF

    "
     |d|

     d := Dictionary new.
     d at:1 put:'one'.
     d at:'one' put:1.
     d at:2 put:#two.
     d at:'two' put:2.
     d hash     
    "

    "
     |d|

     d := Dictionary new.
     d at:1 put:'uno'.
     d at:'one' put:1.
     d at:2 put:#two.
     d at:'two' put:2.
     d hash     
    "
! !

!Set methodsFor:'converting'!

asNewSet
    "make sure to return a unique new set"

    "could be an instance of a subclass..."
    self class == Set ifTrue:[
        ^ self copy
    ].
    ^ super asSet

    " 
        |s|
        s := #(1 2 3 4) asSet.
        self assert:(s ~~ s asNewSet).
        self assert:(s = s asNewSet).
     "
!

asSet 
    "return the receiver as a Set"

    "could be an instance of a subclass..."
    self class == Set ifTrue:[
        ^ self
    ].
    ^ super asSet
! !

!Set methodsFor:'copying'!

postCopy
    "have to copy the keyArray too"

    keyArray := keyArray shallowCopy
! !

!Set methodsFor:'enumerating'!

do:aBlock
    "perform the block for all members in the collection.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    |sz "{ Class: SmallInteger }"
     element|

    sz := keyArray size.
    1 to:sz do:[:index |
        element := keyArray at:index.
        (element notNil and:[element ~~ DeletedEntry]) ifTrue:[
            element == NilEntry ifTrue:[
                element := nil.
            ].
            aBlock value:element
        ]
    ]

    "Modified: 1.3.1996 / 21:41:13 / cg"
! !



!Set methodsFor:'obsolete set operations'!

+ aCollection
    "Kept for backward compatibility. 
     Use #union: instead, to isolate arithmethic and set operations"

    <resource: #obsolete>

    ^ self union:aCollection.
!

- aCollection
    "Kept for backward compatibility. 
     Use #\ instead, to isolate arithmethic and set operations"

    <resource: #obsolete>

    ^ self \ aCollection
! !

!Set methodsFor:'private'!

find:key ifAbsent:aBlock
    "Look for the key in the receiver.  If it is found, return
     the index of the slot containing the key, otherwise
     return the value of evaluating aBlock."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe|

    length := keyArray basicSize.

"/
"/  length < 10 ifTrue:[
"/      "assuming, that for small collections the overhead of hashing
"/       is larger ... maybe that proves wrong 
"/       (if overhead of comparing is higher)"
"/      ^ keyArray indexOf:key ifAbsent:aBlock
"/  ].

    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        probe isNil ifTrue:[^ aBlock value].
        (probe ~~ DeletedEntry and:[key = probe]) ifTrue:[^ index].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[^ aBlock value].
    ] loop.

    "Modified: / 03-02-2011 / 13:53:18 / sr"
!

findIdentical:key ifAbsent:aBlock
    "Look for the key in the receiver.  If it is found, return
     the index of the slot containing the key, otherwise
     return the value of evaluating aBlock."

    ^ keyArray identityIndexOf:key ifAbsent:aBlock
!

findKeyOrNil:key
    "Look for the key in the receiver.  
     If it is found, return the index of the first unused slot. 
     Grow the receiver, if key was not found, and no unused slots were present

     Warning: an empty slot MUST be filled by the sender - it is only to be sent
              by at:put: / add: - like methods."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe 
     delIndex "{ Class:SmallInteger }"|

    delIndex := 0.

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].
            keyArray basicAt:delIndex put:nil.
            ^ delIndex
        ].
        probe == DeletedEntry ifTrue:[
            delIndex == 0 ifTrue:[
                delIndex := index
            ]
        ] ifFalse:[
            key = probe ifTrue:[^ index]
        ].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[
            delIndex ~~ 0 ifTrue:[
                keyArray basicAt:delIndex put:nil.
                ^ delIndex
            ].
            self grow.
            length := keyArray basicSize.
            startIndex := index := self initialIndexForKey:key.
        ].
    ] loop.

    "Modified: / 27-02-2011 / 15:30:42 / cg"
!

findKeyOrNilOrDeletedEntry:key
    "Look for the key in the receiver.  
     If it is found, return the index of the first unused slot. 
     Grow the receiver, if key was not found, and no unused slots were present.
     The answer is the index into the keyArray where the (keyArray at:index)
     may contain:
        nil             -   an empty slot
        DeletedEntry    -   an empty slot, but preceeded and followed by non-empty
                            slots with keys hashing to the same value (hash collisions)
        key             -   key is laready present in the slot."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe 
     delIndex "{ Class:SmallInteger }"|

    delIndex := 0.

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].
            ^ delIndex
        ].
        probe == DeletedEntry ifTrue:[
            delIndex == 0 ifTrue:[
                delIndex := index
            ]
        ] ifFalse:[
            key = probe ifTrue:[^ index]
        ].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[
            delIndex ~~ 0 ifTrue:[
                ^ delIndex
            ].
            self grow.
            length := keyArray basicSize.
            startIndex := index := self initialIndexForKey:key.
        ].
    ] loop.

    "Modified: / 27-02-2011 / 15:30:42 / cg"
!

findNil:key
    "Look for the next slot usable for key.  
     WARNING:
        This method assumes that key is not already in the receiver 
        AND that keyArray does not have previously removed entries 
        AND that there is an empty slot.
     To be used ONLY while growing/rehashing to enter elements into a fresh
     collection - if any of the above conditions is not met, the method
     loops forever."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"|

    length := keyArray basicSize.
    index := self initialIndexForKey:key.

"/    index := keyArray identityIndexOf:nil startingAt:index.
"/    index == 0 ifTrue:[
"/        index := keyArray identityIndexOf:nil startingAt:1 endingAt:index.
"/    ].
    "/ that code is completely inlined by stc ...
    [(keyArray basicAt:index) notNil] whileTrue:[
        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        "notice: no check for no nil found - we must find one since
         this is only called after growing"
    ].
    ^ index

    "Modified: 21.3.1997 / 10:32:58 / cg"
!

hashFor:aKey
    "return the arguments hash value.
     Redefined in subclasses, which use a different comparison (i.e. identity compare)"

    ^ aKey hash

    "Created: 19.3.1997 / 15:03:03 / cg"
!

initialIndexForKey:aKey
    "return an initial index given a key."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"|

    length := keyArray basicSize.
    index := (self hashFor:aKey) bitAnd:16r3FFFFFFF.

    "multiply by a large prime to spread the keys over the whole range.
     This causes maxChainLength to reduce from about 2000 to 6 for an
     IdentitySet of 9000 Smalltalk classes"
    index := index times:31415821.
    index := index \\ length + 1.
    ^ index.

    "
        Smalltalk allClasses maxChainLength
    "

    "Modified: 1.3.1997 / 01:01:13 / cg"
    "Created: 19.3.1997 / 15:02:41 / cg"
!

initializeForCapacity:minSize
    "initialize the contents array (for at least minSize slots) 
     and set tally to zero.
     The size is increased to the next prime for better hashing behavior."

    |n|

    n := self class goodSizeFrom:minSize.
    n == keyArray size ifTrue:[
        keyArray atAllPut:nil.
    ] ifFalse:[
        keyArray := self keyContainerOfSize:n. 
    ].
    tally := 0

    "Modified: / 4.8.1998 / 22:07:25 / cg"
!

invalidElementError
    "this is send when a nil is used with a Set.
     For now this is just an info-Message. Will become an error sometimes."

    "/ self elementBoundError.

    InfoPrinting ifTrue:[
        'Set [warning]: nil is not a valid element - will be an error in later versions' errorPrintCR.
        Context showWhereWeCameFrom.
    ].
!

keyArray
    ^ keyArray

    "Created: / 2.2.1998 / 14:50:55 / cg"
!

keyContainerOfSize:n
    "return a container for keys of size n.
     Extracted to make life of weak subclasses easier ..."

    ^ Array basicNew:n
!

rehash
    "rehash is done by re-adding all elements to a new empty set.
     Rehash is needed after a binaryRead, for example."

    |element oldKeyArray newKeyArray newIdx
     n "{ Class:SmallInteger }"|

    oldKeyArray := keyArray.
    n := oldKeyArray size.
    keyArray := newKeyArray := self keyContainerOfSize:n.

    1 to:n do:[:index |
	element := oldKeyArray at:index.
	(element notNil and:[element ~~ DeletedEntry]) ifTrue:[
	    "cannot be already there"
	    newIdx := self findNil:element.
	    newKeyArray basicAt:newIdx put:element
	].
    ]

    "Modified: / 30.10.1997 / 16:04:46 / cg"
!

rehashFrom:startIndex
    "rehash elements starting at index - after a remove.
     Notice: due to the new implementation of remove, 
	     this is no longer needed"

    |element i "{ Class:SmallInteger }"
     length
     index "{ Class:SmallInteger }" |

    length := keyArray basicSize.
    index := startIndex.
    element := keyArray basicAt:index.
    [element notNil] whileTrue:[
	i := self findNil:element.
	i == index ifTrue:[
	    ^ self
	].
	keyArray basicAt:i put:element.
	keyArray basicAt:index put:nil.

	index == length ifTrue:[
	    index := 1
	] ifFalse:[
	    index := index + 1.
	].
	element := keyArray basicAt:index.
    ]
! !

!Set methodsFor:'private-grow & shrink'!

grow
    "change the number of element slots of the collection to a useful
     new size"

    self grow:(keyArray basicSize * 2)
!

grow:newSize
    "change the number of element slots of the collection - to do this,
     we have to rehash (which is done by re-adding all elements to a new
     empty set)."

    |elem oldKeyArray newKeyArray deletedEntry
     containerSize oldSize "{ Class:SmallInteger }"|

    oldKeyArray := keyArray.
    oldSize := oldKeyArray size.
    containerSize := (self class goodSizeFrom:newSize).
    containerSize == oldSize ifTrue:[^ self].

    keyArray := newKeyArray := self keyContainerOfSize:containerSize. 

    deletedEntry := DeletedEntry.
    1 to:oldSize do:[:srcIndex |
	elem := oldKeyArray basicAt:srcIndex.
	(elem notNil and:[elem ~~ deletedEntry]) ifTrue:[
	    "cannot be already there"
	    newKeyArray basicAt:(self findNil:elem) put:elem
	].
    ].
!

possiblyGrow
    "check if collection is full (after an add); grow if so.
     Definition of 'full' is currently: 'filled more than 75% (i.e. 3/4th)'"

    |sz "{Class: SmallInteger}" |

    "
     grow if filled more than 75% 
    "
    sz := keyArray basicSize.
    tally > (sz * 3 // 4) ifTrue:[
       self grow
    ]
!

possiblyShrink
    "check if the receiver has become too empty (after a remove)
     and shrink if it makes sense.
     Definition of 'too empty' is: 'filled less than 12.5% (i.e. 1/8th)'"

    |sz      "{Class: SmallInteger}"
     newSize "{Class: SmallInteger}" |

    sz := keyArray basicSize.
    sz > 56 ifTrue:[
        "
         shrink if too empty
        "
        tally < (sz // 8) ifTrue:[
            newSize := sz // 4.
            self grow:newSize
        ]
    ]

    "Modified: 19.3.1997 / 16:02:55 / cg"
! !

!Set methodsFor:'queries'!

collisionCount
    "return the number of key collisions in the set.
     There is a collision if two keys hash to the same value."

    |count|

    count := 0.

    keyArray do:[:eachKey|
        (eachKey notNil and:[eachKey ~~ DeletedEntry]) ifTrue:[
            count := count + (self collisionsFor:eachKey).
        ]
    ].

    ^ count

    "
      self allSubInstances 
          collect:[:each| each collisionCount -> each] 
          thenSelect:[:each| each key > 0]
    "
!

collisionsFor:key
    "Return the number of searches - 1 required for key"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }" startIndex probe count|

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    count := 0.
    [
        probe := keyArray basicAt:index.
        (probe notNil and:[key = probe]) ifTrue:[^ count].
        probe isNil ifTrue:[self error:'non existing key'].

        index == length ifTrue:[
            index := 1.
        ] ifFalse:[
            index := index + 1.
        ].
        count := count + 1.
        index == startIndex ifTrue:[self error:'non existing key'].
    ] loop.
!

maxChainLength
    "return the number of the maximum chain length in the set.
     This is the worst case overhead when accessing a key."

    |chainLength key|

    chainLength := 0.

    keyArray do:[:eachKey| |t|
        (eachKey notNil and:[eachKey ~~ DeletedEntry]) ifTrue:[
            t := self collisionsFor:eachKey.
            chainLength < t ifTrue:[chainLength := t. key := eachKey].
        ]
    ].

    ^ (key -> chainLength)
!

size
    "return the number of set elements"

    ^ tally
! !


!Set methodsFor:'searching'!

findFirst:aBlock ifNone:exceptionValue
    "find the index of the first element, for which evaluation of the argument, aBlock returns true; 
     return its index or the value from exceptionValue if none detected.
     This is much like #detect:ifNone:, however, here an INDEX is returned,
     while #detect:ifNone: returns the element.

     Sets do not have indices."

    ^ self shouldNotImplement
! !

!Set methodsFor:'testing'!

capacity 
    "return the number of elements, that the receiver is prepared to take w.o. resizing.
     Notice, that Sets do automatically resize as required, 
     so knowing the capacity is of no real use.
     Not used by the system; added for ST-80 compatibility."

    ^ keyArray size
!

includes:anObject
    "return true if the argument anObject is in the receiver"

    tally == 0 ifTrue:[^ false]. "/ quick reject if empty
    ^ (self find:(anObject ? NilEntry) ifAbsent:0) ~~ 0
!

isEmpty
    "return true if the receiver is empty"

    ^ tally == 0
!

isFixedSize
    "return true if the receiver cannot grow - this will vanish once
     Arrays and Strings learn how to grow ..."

    ^ false
!

isOrdered
    "return true, if the receiver's elements are ordered.
     Redefined to return false here, because the order of keys (and values in dictionaries)
     may change due to rehashing, when elements are added/removed"

    ^ false
!

notEmpty
    "return true if the receiver is not empty"

    ^ tally ~~ 0

    "Created: 12.2.1997 / 12:39:02 / cg"
!

occurrencesOf:anObject
    "return the number of occurrences of anObject in the receiver.
     As I am a Set, this can only return 0 or 1."

    tally == 0 ifTrue:[^ 0]. 
    (self find:(anObject ? NilEntry) ifAbsent:0) == 0 ifTrue:[^ 0].
    ^ 1

    "Modified: / 16.11.2001 / 10:30:14 / cg"
! !

!Set methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitSet:with: to aVisitor."

    ^ aVisitor visitSet:self with:aParameter
! !

!Set::EmptySlot class methodsFor:'instance creation'!

basicNew
    TheOneAndOnlyInstance isNil ifTrue:[
	TheOneAndOnlyInstance := super basicNew
    ].
    ^ TheOneAndOnlyInstance

! !

!Set::NilKey class methodsFor:'instance creation'!

basicNew
    TheOneAndOnlyInstance isNil ifTrue:[
        TheOneAndOnlyInstance := super basicNew
    ].
    ^ TheOneAndOnlyInstance


! !

!Set class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Set initialize!
