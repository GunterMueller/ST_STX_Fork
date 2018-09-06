"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

Dictionary subclass:#IdentityDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!IdentityDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    Same as a Dictionary, but key must be identical - not just equal.
    Since compare is on identical keys (using ==), hashing is also done via
    #identityHash instead of #hash.
    IdentityDictionaries are especially useful when symbols are used as keys.

    [author:]
        Claus Gittinger
"
! !


!IdentityDictionary methodsFor:'private'!

compareSame:element1 with:element2
    "compare two elements for being the same. Here, return true if the
     elements are identical (i.e. using #==)."

    ^ element1 == element2

    "Modified: 22.4.1996 / 17:34:48 / cg"
!

emptyCollectionForKeys
    "return an empty collection used for keys.
     Here, an IdentitySet is returned.
     Made a separate method to allow redefinition for different kind of
     containers in subclasses."

    ^ IdentitySet new:(self size)

    "Modified: 22.4.1996 / 17:35:40 / cg"
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
        probe == key ifTrue:[^ index].         "<--- == is different from inherited"
        probe isNil ifTrue:[^ aBlock value].

        index == length ifTrue:[
            index := 1
        ] ifFalse:[
            index := index + 1
        ].
        index == startIndex ifTrue:[^ aBlock value]
    ] loop.
!

findIdentical:key ifAbsent:aBlock
    "IdentityDictionary does identity compare anyway..."

    ^ self find:key ifAbsent:aBlock
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
        key == probe ifTrue:[^ index].              "<--- == is different from inherited"   
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].
            keyArray basicAt:delIndex put:nil.
            ^ delIndex
        ].

        (delIndex == 0 and:[probe == DeletedEntry]) ifTrue:[
            delIndex := index
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

    "Modified: 26.3.1996 / 20:00:44 / cg"
!

findKeyOrNilOrDeletedEntry:key
    "Look for the key in the receiver.  
     If it is found, return the index of the first unused slot. 
     Grow the receiver, if key was not found, and no unused slots were present."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe 
     delIndex "{ Class:SmallInteger }"|

    delIndex := 0.

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        key == probe ifTrue:[^ index].              "<--- == is different from inherited"   
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].
            ^ delIndex
        ].

        (delIndex == 0 and:[probe == DeletedEntry]) ifTrue:[
            delIndex := index
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

    "Modified: 26.3.1996 / 20:00:44 / cg"
!

hashFor:aKey
    "return an initial index given a key."

    ^ aKey identityHash

    "Created: 19.3.1997 / 15:03:36 / cg"
! !


!IdentityDictionary methodsFor:'testing'!

includesValue:aValue
    "return true, if the argument, aValue is stored in the dictionary,
     Redefined to use identity compare, NOT equality compare"

    ^ self includesIdenticalValue:aValue
!

occurrencesOf:anObject
    "count & return how often anObject is stored in the dictionary.
     This counts values - not keys.
     Redefined to use #== (identity compare), NOT equality compare."

    |cnt|

    anObject isNil ifTrue:[^ super occurrencesOf:anObject].

    cnt := 0.
    valueArray do:[:element |
       element == anObject ifTrue:[cnt := cnt + 1]
    ].
    ^ cnt
! !

!IdentityDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

