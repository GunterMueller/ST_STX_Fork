"
 COPYRIGHT (c) 2014 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Set subclass:#PluggableSet
	instanceVariableNames:'hashFunction compareFunction'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!PluggableSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by Claus Gittinger
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
    a set where the hash- and compare functions can be provided externally.

    [author:]
        Claus Gittinger
"
!

examples
"
    |s|

    s := PluggableSet 
        hashWith:[:k | k size] 
        compareWith:[:a :b | a notNil and:[b notNil and:[a asLowercase = b asLowercase]]].
    s add:'hello'.
    s add:'world'.
    s add:'abc'.
    s add:'Hello'.
    s add:'heLLo'.
    s add:'ABC'.
    s add:'WORLD'.
    s size.
    s includes:'heLlo'.
    s includes:'wOrLd'.
    s includes:'wOrLds'.
"
! !

!PluggableSet class methodsFor:'instance creation'!

hashWith:hashFunctionArg compareWith:compareFunctionArg
    ^ self new hashWith:hashFunctionArg compareWith:compareFunctionArg
! !

!PluggableSet methodsFor:'Compatibility-Squeak'!

copyWithout:anElement
    "return a new collection consisting of a copy of the receiver, with
     ALL elements equal to elementToSkip are left out.
     No error is reported, if elementToSkip is not in the collection."

    ^ self reject:[:each | compareFunction value:each value:anElement]

    "
     #(1 2 3 4 5 6 7) asSet copyWithout:5
    "
! !

!PluggableSet methodsFor:'accessing'!

hashWith:hashFunctionArg compareWith:compareFunctionArg 
    hashFunction := hashFunctionArg.
    compareFunction := compareFunctionArg.
! !

!PluggableSet methodsFor:'converting'!

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

!PluggableSet methodsFor:'private'!

collisionsFor:key
    "Return the number of searches - 1 required for key"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }" startIndex probe count|

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    count := 0.
    [true] whileTrue:[
        probe := keyArray basicAt:index.
        (probe notNil and:[compareFunction value:key value:probe]) ifTrue:[^ count].
        (self slotIsEmpty:probe) ifTrue:[self error:'non existing key'].

        index == length ifTrue:[
            index := 1.
        ] ifFalse:[
            index := index + 1.
        ].
        count := count + 1.
        index == startIndex ifTrue:[self error:'non existing key'].
    ]
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

    [true] whileTrue:[
        probe := keyArray basicAt:index.
        probe isNil ifTrue:[
            ^ aBlock value.
        ].

        (probe ~~ DeletedEntry 
         and:[compareFunction value:probe value:key]) ifTrue:[ " <<<< == is different from inherited"
            ^ index
        ].         

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[
            ^ aBlock value
        ]
    ]
!

findKeyOrNil:key
    "Look for the key in the receiver.  
     If it is found, return return the index of the first unused slot. 
     Grow the receiver, if key was not found, and no unused slots were present"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe 
     delIndex "{ Class:SmallInteger }" |

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
        (probe == DeletedEntry and:[delIndex == 0]) ifTrue:[
            delIndex := index.
        ] ifFalse:[
            (compareFunction value:probe value:key) ifTrue:[^ index]
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
     delIndex "{ Class:SmallInteger }" |

    delIndex := 0.

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].
            ^ delIndex
        ].
        (probe == DeletedEntry and:[delIndex == 0]) ifTrue:[
            delIndex := index.
        ] ifFalse:[
            (compareFunction value:probe value:key) ifTrue:[^ index]
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

    ^ hashFunction value:aKey
! !

!PluggableSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

