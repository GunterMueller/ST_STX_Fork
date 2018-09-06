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

Dictionary subclass:#PluggableDictionary
	instanceVariableNames:'hashFunction compareFunction'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!PluggableDictionary class methodsFor:'documentation'!

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
    a dictionary where the hash- and compare functions can be provided externally.

    [author:]
        Claus Gittinger
"
!

examples
"
    |s|

    s := PluggableDictionary
        hashWith:[:k | k asLowercase hash] 
        compareWith:[:a :b | a notNil and:[b notNil and:[a asLowercase = b asLowercase]]].
    s at:'hello' put:123.
    s at:'world' put:222.
    s at:'abc' put:333.
    s at:'Hello'.
    s at:'heLLo'.
    s at:'ABC'.
    s at:'WORLD'.
    s size.
    s includesKey:'heLlo'.
    s includesKey:'wOrLd'.
    s includesKey:'wOrLds'.
"
! !

!PluggableDictionary class methodsFor:'instance creation'!

hashWith:hashFunctionArg compareWith:compareFunctionArg
    ^ self new hashWith:hashFunctionArg compareWith:compareFunctionArg
! !

!PluggableDictionary methodsFor:'accessing'!

hashWith:hashFunctionArg compareWith:compareFunctionArg 
    hashFunction := hashFunctionArg.
    compareFunction := compareFunctionArg.
! !

!PluggableDictionary methodsFor:'private'!

compareSame:element1 with:element2
    "compare two elements for being the same. 
     Here, return the value from compareFunction"

    ^ compareFunction value:element1 value:element2
!

find:key ifAbsent:aBlock
    "Look for the key in the receiver.  If it is found, return
     the index of the association containing the key, otherwise
     return the value of evaluating aBlock.
     Redefined - since we inherit this code from Set-Dictionary
     (one of the seldom cases, where I could make use of multiple inheritance
     and inherit from IdentitySet ... sigh)"

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe|

    length := keyArray basicSize.

"/
"/    length < 10 ifTrue:[
"/      "assuming, that for small dictionaries the overhead of hashing
"/       is large ... maybe that proves wrong (if overhead of comparing
"/       is high)"
"/      ^ keyArray identityIndexOf:key ifAbsent:aBlock.
"/    ].
"/

    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        probe isNil ifTrue:[
            ^ aBlock value.
        ].

        (probe ~~ DeletedEntry 
         and:[compareFunction value:probe value:key]) ifTrue:[ "<<<< == is different from inherited"
            ^ index
         ].         

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[^ aBlock value]
    ] loop.
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
!

hashFor:aKey
    "return an initial index given a key."

    ^ hashFunction value:aKey
! !

!PluggableDictionary methodsFor:'testing'!

occurrencesOf:anObject
    "count & return how often anObject is stored in the dictionary.
     This counts values - not keys.
     Redefined to use #== (identity compare), NOT equality compare."

    |cnt|

    anObject isNil ifTrue:[^ super occurrencesOf:anObject].

    cnt := 0.
    valueArray do:[:element |
       (compareFunction value:element value:anObject) ifTrue:[cnt := cnt + 1]
    ].
    ^ cnt
! !

!PluggableDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

