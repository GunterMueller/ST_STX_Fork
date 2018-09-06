"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

Set subclass:#IdentitySet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!IdentitySet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    same as a Set but compares elements using == 
    (i.e. they must be identical - not just equal in structure).
    Since compare is on identity (using ==), hashing is also done via
    #identityHash instead of #hash.

    [author:]
        Claus Gittinger
"
! !

!IdentitySet methodsFor:'Compatibility-Squeak'!

copyWithout:anElement
    "return a new collection consisting of a copy of the receiver, with
     ALL elements equal to elementToSkip are left out.
     No error is reported, if elementToSkip is not in the collection."

    ^ self select:[:each | each ~~ anElement]

    "
     #(1 2 3 4 5 6 7) asSet copyWithout:5
    "
! !

!IdentitySet methodsFor:'adding & removing'!

removeIdentical:oldObject ifAbsent:exceptionBlock
    "remove oldObject from the collection and return it.
     If it was not in the collection return the value of exceptionBlock.
     Uses identity compare (==) to search for an occurrence.

     WARNING: do not remove elements while iterating over the receiver."

    ^ self remove:oldObject ifAbsent:exceptionBlock
! !

!IdentitySet methodsFor:'converting'!

asIdentitySet 
    "return the receiver as an IdentitySet"

    "could be an instance of a subclass..."
    self class == IdentitySet ifTrue:[
        ^ self
    ].
    ^ super asIdentitySet
!

asNewIdentitySet
    "make sure to return myself as a unique new IdentitySet"

    "could be an instance of a subclass..."
    self class == IdentitySet ifTrue:[
        ^ self copy
    ].
    ^ super asIdentitySet

    "
        |s|
        s := #(1 2 3 4) asIdentitySet.
        self assert:(s ~~ s asNewIdentitySet).
        self assert:(s = s asNewIdentitySet).
    "
! !

!IdentitySet methodsFor:'private'!

collisionsFor:key
    "Return the number of searches - 1 required for key"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }" startIndex probe count|

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    count := 0.
    [
        probe := keyArray basicAt:index.
        probe isNil ifTrue:[self error:'non existing key'].
        key == probe ifTrue:[^ count].

        index == length ifTrue:[
            index := 1.
        ] ifFalse:[
            index := index + 1.
        ].
        count := count + 1.
        index == startIndex ifTrue:[self error:'non existing key'].
    ] loop.
!

find:key ifAbsent:aBlock
    "Look for the key in the receiver.  If it is found, return
     the index of the slot containing the key, otherwise
     return the value of evaluating aBlock.
     Redefined to compare for identity instead of equality"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe |

    length := keyArray basicSize.

"/
"/  length < 10 ifTrue:[
"/      "assuming, that for small sets the overhead of hashing
"/       is large ..."
"/      ^ keyArray identityIndexOf:key ifAbsent:aBlock.
"/  ].
"/

    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        probe == key ifTrue:[^ index].        "<<<< == is different from inherited"
        probe isNil ifTrue:[^ aBlock value].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[
            ^ aBlock value
        ]
    ] loop.
!

findIdentical:key ifAbsent:aBlock
    "IdentitySet does identity compare anyway..."

    ^ self find:key ifAbsent:aBlock
!

findKeyOrNil:key
    "Look for the key in the receiver.  
     If it is found, return return the index of the first unused slot. 
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
        key == probe ifTrue:[^ index].
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].
            keyArray basicAt:delIndex put:nil.
            ^ delIndex
        ].

        probe == DeletedEntry ifTrue:[
            delIndex == 0 ifTrue:[
                delIndex := index
            ]
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

    "Modified: 26.3.1996 / 20:00:42 / cg"
!

findKeyOrNilOrDeletedEntry:key
    "Look for the key in the receiver.  
     If it is found, return return the index of the first unused slot. 
     Grow the receiver, if key was not found, and no unused slots were present"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe 
     delIndex "{ Class:SmallInteger }"|

    delIndex := 0.

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        key == probe ifTrue:[^ index].
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].
            ^ delIndex
        ].

        probe == DeletedEntry ifTrue:[
            delIndex == 0 ifTrue:[
                delIndex := index
            ]
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

    "Modified: 26.3.1996 / 20:00:42 / cg"
!

hashFor:aKey
    "return an initial index given a key."

    ^ aKey identityHash

    "Created: 19.3.1997 / 15:18:59 / cg"
! !

!IdentitySet methodsFor:'set operations'!

\ aCollection
    "return a new set containing all elements of the receiver, 
     which are NOT also contained in the aCollection
     For large collections you better use a Set for aCollection.
     Redefined here to do identity comparison."

    |newCollection|

    newCollection := self speciesForAdding new.
    self do:[:element |
        (aCollection includesIdentical:element) ifFalse:[
            newCollection add:element
        ]
    ].
    ^ newCollection

    "
     #(0 1 2 3 4 5 6 7 8 9) asIdentitySet \ #(1 2 3) asSet  
     #(0 1 2 3 4 5 6 7 8 9) asIdentitySet \ #(1 2 3)
    "
! !

!IdentitySet methodsFor:'testing'!

identicalContentsAs:aCollection
    "return true if the receiver and aCollection represent collections
     with identical contents (but not caring for order)."

    aCollection size == self size ifFalse:[^ false].
    ^ aCollection conform:[:eachElement | (self includesIdentical:eachElement)].

    "
     |col|

     col := #('aaa' 'bbb' 'ccc' 'ddd').
     col identicalContentsAs:(col asIdentitySet).  
     col identicalContentsAs:(col copy asIdentitySet).  
     col identicalContentsAs:(col deepCopy asIdentitySet).  
   "

    "Modified: / 13-10-2006 / 12:55:43 / cg"
!

includesIdentical:anObject
    "for identitySet, the #includes: test already tests for identity"

    ^ self includes:anObject

    "Created: / 11.12.1998 / 20:01:12 / cg"
! !

!IdentitySet class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

