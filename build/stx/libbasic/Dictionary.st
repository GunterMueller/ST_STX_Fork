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

Set subclass:#Dictionary
	instanceVariableNames:'valueArray'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!Dictionary class methodsFor:'documentation'!

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
    a Dictionary is (conceptionally) a set of Associations storing key-value pairs.
    (The implementation uses two arrays to store the keys and values separately.)
    Searching for an element is done using a hash into the key array.
    Another way of looking at a dictionary is as an array that uses
    arbitrary access keys (i.e. not just integers as arrays do).

    Since the keys are unordered, no internal element order is defined
    (i.e. enumerating them may return elements in any order - even changing
     over time).

    Many methods for searching and hashing are inherited from Set.

    [Instance variables:]

        keyArray        <Array>         (from Set) the keys

        valueArray      <Array>         the values ('valueArray at:index' corresponds
                                        to the value stored under 'keyArray at:index')

    Performance hints:
      since the dictionary does not really store associations internally,
      it is less efficient, to store/retrieve associations. The reason is
      that these assocs are created temporarily in some extract methods.
      I.e. 'at:key put:value' is faster than 'add:anAssoc'
      and 'keysAndValuesDo:' is faster than 'associationsDo:' etc.

      If only symbols or smallIntegers are used as keys, use IdentityDictionaries
      for slightly better performance, since both hashing and comparison is faster.

      If you have a rough idea how big the dictionary is going to grow,
      create it using #new: instead of #new. Even if the size given is a
      poor guess (say half of the real size), there is some 20-30% performance
      win to expect, since many resizing operations are avoided when associations
      are added.

    Special note:
      in previous versions, nil was not allowed as valid key
      This has been changed; internally, a special nil-key is used,
      which is converted back to nil whenever keys are accessed.

    [See also:]
        Set, IdentityDictionary, IdentitySet, WeakIdentitySet and
        WeakIdentityDictionary

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                        [exBegin]
    |d|

    d := Dictionary new.
    d at:'1' put:'one'.
    d at:2 put:'two'.
    d at:2
                                                                        [exEnd]

                                                                        [exBegin]
    |d|

    d := Dictionary new.
    d at:'1' put:'one'.
    d at:2   put:nil.
    d.
    d at:2
                                                                        [exEnd]

                                                                        [exBegin]
    |d|

    d := Dictionary new.
    d at:'1' put:'one'.
    d at:2   put:nil.
    d includes:nil.
                                                                        [exEnd]

                                                                        [exBegin]
    |d|

    d := Dictionary new.
    d at:'1' put:'one'.
    d includes:nil.
                                                                        [exEnd]
                                                                        [exBegin]
    |d1 d2|

    d1 := Dictionary withKeys:#(a b c) andValues:#( 1 2 3).
    d2 := Dictionary newFrom:d1.
    d2.
                                                                        [exEnd]

"
! !

!Dictionary class methodsFor:'instance creation'!

decodeFromLiteralArray:anArray
    "create & return a new instance from information encoded in anArray."

    |dictionary
     sz "{ Class: SmallInteger }"|

    sz := anArray size.
    dictionary := self new:sz//2.
    2 to:sz by:2 do:[:idx | |key val|
	key := (anArray at:idx) decodeAsLiteralArray.
	val := (anArray at:idx+1) decodeAsLiteralArray.
	dictionary at:key put:val
    ].
    ^ dictionary

    "
     (Dictionary new
	 at:1 put:'one';
	 at:2 put:'two';
	 yourself
     ) literalArrayEncoding decodeAsLiteralArray
    "
!

withAssociations:aCollectionOfAssociations
    "return a new instance where associations are taken from the argument"

    |newDict sz "{ Class: SmallInteger }"|

    sz := aCollectionOfAssociations size.
    newDict := self new:sz.
    aCollectionOfAssociations do:[:assoc |
        newDict at:assoc key put:assoc value
    ].
    ^ newDict

    "
     Dictionary withAssociations:{ #'one'->1 .
                                   #'two'->2 .
                                   #'three'->3 .
                                   #'four'->4 }
    "

    "Created: / 11.2.2000 / 10:05:54 / cg"
!

withKeys:keyArray andValues:valueArray
    "return a new instance where keys and values are taken from
     the argumentArrays."

    |newDict sz "{ Class: SmallInteger }"|

    sz := keyArray size.
    newDict := self new:sz.
    1 to:sz do:[:index |
        newDict at:(keyArray at:index) put:(valueArray at:index).
    ].
    ^ newDict

    "
     Dictionary withKeys:#('one' 'two' 'three' 'four')
               andValues:#(1 2 3 4)
    "
!

withKeys:aCollection valueBlock:aOneArgBlock
    "return a Dictionary with keys from aCollection's elements,
     using aOneArgBlock to generate the values from aCollection's elements."

    |d|

    d := self new:aCollection size.
    aCollection do:[:each|
        d at:each put:(aOneArgBlock value:each).
    ].
    ^ d

    "
     Dictionary withKeys:#(10 20 30 40 50 60 70 80 90) valueBlock:[:e| e asString]
    "
!

withKeysAndValues:anArray
    "return a new instance where keys and values are taken from alternating
     elements of anArray"

    |newDict sz "{ Class: SmallInteger }"|

    sz := anArray size.
    newDict := self new:(sz // 2).
    1 to:sz by:2 do:[:i |
	newDict at:(anArray at:i) put:(anArray at:i+1)
    ].
    ^ newDict

    "
     Dictionary withKeysAndValues:#('one' 1 'two' 2 'three' 3 'four' 4)
    "
!

withValues:aCollection keyBlock:aOneArgBlock
    "return a Dictionary with values from aCollection's elements,
     using aOneArgBlock to generate the keys from aCollection's elements."

    |d|

    d := self new:aCollection size.
    aCollection do:[:each|
        d at:(aOneArgBlock value:each) put:each.
    ].
    ^ d

    "
     Dictionary withValues:#(10 20 30 40 50 60 70 80 90) keyBlock:[:e| e asString]
    "
! !

!Dictionary class methodsFor:'Compatibility-Squeak'!

newFrom:aCollectionOfAssociations
    "return a new instance where associations are taken from the argument"

    aCollectionOfAssociations isDictionary ifTrue:[
        ^ (self new:aCollectionOfAssociations size)
                declareAllFrom:aCollectionOfAssociations.
    ].    
    ^ self withAssociations:aCollectionOfAssociations

    "
     Dictionary newFrom:{#foo -> #Foo. #bar -> #Bar}

     Dictionary
        newFrom:(Dictionary withKeysAndValues:#('one' 1 'two' 2 'three' 3 'four' 4))
    "
! !

!Dictionary methodsFor:'Compatibility-Dolphin'!

equals:aDictionary
    ^ self = aDictionary
! !

!Dictionary methodsFor:'Compatibility-VW5.4'!

contentsEquals: aDictionary
    "Anwer true if  the receiver and aDictionary contain the same key/values.
     (ignoring the classes)"

    self size == aDictionary size ifFalse: [ ^false ].

    self keysAndValuesDo: [ :key :value |
        ( aDictionary at: key ifAbsent: [ ^false ] ) = value
        ifFalse: [ ^false ]
    ].
    ^ true
! !



!Dictionary methodsFor:'accessing'!

associationAt:aKey
    "return an association consisting of aKey and the element indexed
     by aKey -
     report an error, if no element is stored under aKey"

    ^ self associationAt:aKey ifAbsent:[self errorKeyNotFound:aKey]
!

associationAt:aKey ifAbsent:exceptionBlock
    "return an association consisting of aKey and the element indexed by aKey -
     return result of exceptionBlock if no element is stored under aKey.
     Warning: this is a comatibility interface only, with a different semantic as
              the original ST80 implementation. The returned assoc is created on the fly,
              and not the one stored in the receiver (there are not assocs there)"

    |index|

    "/ must return the real key in the assoc - not aKey, which might be equal but not identical
    index := self find:aKey ifAbsent:0.
    index ~~ 0 ifTrue:[
        ^ Association key:(keyArray basicAt:index) value:(valueArray basicAt:index)
    ].
    ^ exceptionBlock value
!

associations
    "return an ordered collection containing the receiver's associations."

    |coll|

    coll := OrderedCollection new:(keyArray size).
    self associationsDo:[:assoc | coll add:assoc].
    ^ coll
!

at:aKey
    "return the element indexed by aKey - report an error if none found"

    ^ self at:aKey ifAbsent:[self errorKeyNotFound:aKey]
!

at:aKey ifAbsent:exceptionBlock
    "return the element indexed by aKey -
     return result of exceptionBlock if no element is stored under aKey"

    |index k|

    (k := aKey) isNil ifTrue:[
	"/ nil is not allowed as key
	"/
	"/ previous versions of ST/X raised an error
	"/ here. However, there seem to exist applications
	"/ which depend on getting the exceptionBlocks value
	"/ in this case ... well ...
	"/ ^ self errorInvalidKey:aKey
"/ no longer invalid.
"/      ^ exceptionBlock value
	k := NilEntry
    ].

    "/ I could have written:
    "/ index := self find:aKey ifAbsent:[^ exceptionBlock value]
    "/ but the code below is slighlty more efficient, since it avoids
    "/ a block creation - thus speeding up the good case.

    index := self find:k ifAbsent:0.
    index ~~ 0 ifTrue:[
	^ valueArray basicAt:index
    ].
    ^ exceptionBlock value.
!

at:aKey ifAbsent:default update:aBlock
    "update the element stored under aKey with the result from
     evaluating aBlock with the previous stored value as argument, or with default,
     if there was no such key initially.
     I.e. this is the same as self at:aKey put:(aBlock value:(self at:aKey ifAbsent:default)).
     Return the new value stored.
     This is an optimized accessor, which only computes the hash value once."

    |k index "{ Class: SmallInteger }"
     newValue oldKeyArray oldKey|

    (k := aKey) isNil ifTrue:[
        k := NilEntry
    ].

    oldKeyArray := keyArray.
    index := self findKeyOrNilOrDeletedEntry:k.
    oldKey := keyArray basicAt:index.
    (oldKey notNil and:[oldKey ~~ DeletedEntry]) ifTrue:[
        "/ key is present
        newValue := aBlock value:(valueArray basicAt:index).
    ] ifFalse:[
        "/ a new key
        newValue := aBlock value:default.
    ].
    (keyArray ~~ oldKeyArray or:[(keyArray basicAt:index) ~~ oldKey]) ifTrue:[
        "I have been changed while performing aBlock.
         have to find the key again."
        index := self findKeyOrNil:k.
    ].

    valueArray basicAt:index put:newValue.
    oldKey := keyArray basicAt:index.
    (oldKey isNil or:[oldKey == DeletedEntry]) ifTrue:[
        "key is not or no longer present"
        keyArray basicAt:index put:k.
        tally := tally + 1.
        self possiblyGrow.
    ].

    ^ newValue

    "
     |d|

     d := Dictionary new.
     d at:'one'  ifAbsent:0 update:[:val | val + 1].
     d at:'two'  ifAbsent:0 update:[:val | val + 1].
     d at:'three' ifAbsent:0  update:[:val | val + 1].
     d at:'two' ifAbsent:0  update:[:val | val + 1].
     d at:'three' ifAbsent:0  update:[:val | val + 1].
     d at:'three' ifAbsent:0  update:[:val | val + 1].
     d
    "

    "
     |d|

     d := Dictionary new.
     d at:'two'  ifAbsent:0 update:[:val | val + 1].
     d at:'two'  ifAbsent:0 update:[:val | 1 to:30 do:[:idx| d at:idx printString put:idx]. val + 1].
     d
    "

    "
     |d|

     d := Dictionary new.
     d at:'two'  ifAbsent:0 update:[:val | val + 1].
     d at:'two'  ifAbsent:0 update:[:val | d removeKey:'two'. val + 1].
     d
    "
!

at:aKey ifAbsentPut:valueBlock
    "return the element indexed by aKey if present,
     if not present, store the result of evaluating valueBlock
     under aKey and return it.
     WARNING: do not add elements while iterating over the receiver.
              Iterate over a copy to do this."

    |index "{ Class: SmallInteger }"
     k newValue oldKeyArray probeKey|

    (k := aKey) isNil ifTrue:[
        k := NilEntry
    ].

    index := self findKeyOrNilOrDeletedEntry:k.
    probeKey := keyArray basicAt:index.
    (probeKey notNil and:[probeKey ~~ DeletedEntry]) ifTrue:[
        "/ key is already present
        ^ valueArray at:index.
    ].

    "/ a new key
    oldKeyArray := keyArray.
    newValue := valueBlock value.
    (keyArray ~~ oldKeyArray or:[(keyArray basicAt:index) ~~ probeKey]) ifTrue:[
        "I have been changed while performing the valueBlock.
         have to find the key again."
        index := self findKeyOrNil:k.
        (keyArray basicAt:index) notNil ifTrue:[
            "/ key was not, but is now present.
            "/ since we executed the valueBlock, overwrite the value in the Dictionary
            valueArray at:index put:newValue.
            ^ newValue
        ].
    ].
    "/ a new key...
    keyArray basicAt:index put:k.
    valueArray basicAt:index put:newValue.
    tally := tally + 1.
    self possiblyGrow.

    ^ newValue

    "
     |d|

     d := Dictionary new.
     Transcript showCR:(d at:'foo' ifAbsentPut:'bar').
     Transcript showCR:(d at:'foo2' ifAbsentPut:'bar2').
     Transcript showCR:(d at:'foo' ifAbsentPut:'barX').
     Transcript showCR:(d at:'foo2' ifAbsentPut:'bar2X').
    "

    "
     |d|

     d := Dictionary new.
     d at:'one' ifAbsentPut:[d at:'one' put:1. 33333].
     d
    "

    "
     |d|

     d := Dictionary new.
     d at:'two'  ifAbsentPut:[1 to:30 do:[:idx| d at:idx printString put:idx]. 2].
     d
    "


    "Created: / 23.1.1998 / 18:28:26 / cg"
    "Modified: / 26.2.1998 / 19:10:09 / stefan"
!

at:aKey ifPresent:aBlock
    "try to retrieve the value stored at aKey.
     If there is nothing stored under this key, do nothing.
     Otherwise, evaluate aBlock, passing the retrieved value as argument."

    |v|

    v := self at:aKey ifAbsent:[^ nil].
    ^ aBlock value:v.

    "
     |d|
     d := Dictionary new.
     d at:#foo put:'yes this is foo'.

     d at:#foo ifPresent:[:val | Transcript showCR:'the value of foo is: ',val].
     d at:#bar ifPresent:[:val | Transcript showCR:'the value of bar is: ',val].
    "
!

at:aKey put:anObject
    "add the argument anObject under key, aKey to the receiver.
     Return anObject (sigh).
     WARNING: do not add elements while iterating over the receiver.
              Iterate over a copy to do this."

    |k index "{ Class: SmallInteger }"|

    (k := aKey) isNil ifTrue:[
        k := NilEntry
    ].

    index := self findKeyOrNil:k.
    valueArray basicAt:index put:anObject.
    (keyArray basicAt:index) isNil ifTrue:[
        "/ a new key
        keyArray basicAt:index put:k.
        tally := tally + 1.
        self possiblyGrow.
    ].
    ^ anObject

    "Modified: 30.1.1997 / 14:59:10 / cg"
!

at:aKey put:anObject ifPresent:aBlock
    "if the receiver contains an element stored under aKey,
     retrieve it and evaluate aBlock passing the element as argument,
     return the blocks value.
     If not, store aValue under the key.
     Use this with an error-reporting block, to ensure that no keys are reused"

    |k index "{ Class: SmallInteger }"|

    (k := aKey) isNil ifTrue:[
        k := NilEntry
    ].

    index := self findKeyOrNil:k.
    (keyArray basicAt:index) notNil ifTrue:[
        "/ key already present
        ^ aBlock value:(valueArray basicAt:index).
    ].
    "/ a new key
    keyArray basicAt:index put:k.
    valueArray basicAt:index put:anObject.
    tally := tally + 1.

    self possiblyGrow.
    ^ anObject

    "
     |d|

     d := Dictionary new.
     d at:'foo' put:1234 ifPresent:[:v| self error: 'duplicate: ', v printString ].
     d at:'foo' put:1234 ifPresent:[:v| self halt:'duplicate: ', v printString. 5555 ].
    "
!

at:aKey update:aBlock
    "update the element stored under aKey with the result from
     evaluating aBlock with the previous stored value as argument.
     Report an error if there was no such key initially.
     I.e. this is the same as self at:aKey put:(aBlock value:(self at:aKey)).
     Return the new value stored.
     This is an optimized accessor, which only computes the hash value once."

    |k index "{ Class: SmallInteger }"
     newValue oldKey oldKeyArray|

    (k := aKey) isNil ifTrue:[
        k := NilEntry
    ].

    index := self find:k ifAbsent:0.
    index == 0 ifTrue:[
        "/ a new key
        ^ self errorKeyNotFound:k.
    ].

    "/ key present
    oldKey := keyArray basicAt:index.
    oldKeyArray := keyArray.
    newValue := aBlock value:(valueArray basicAt:index).
    (keyArray ~~ oldKeyArray or:[(keyArray basicAt:index) ~~ oldKey]) ifTrue:[
        "I have been changed while performing aBlock.
         have to find the key again."
        index := self find:k ifAbsent:0.
        index == 0 ifTrue:[
            "/ the key is gone while performing the block.
            ^ self errorKeyNotFound:k.
        ].
    ].

    valueArray basicAt:index put:newValue.
    ^ newValue

    "
     |d|

     d := Dictionary new.
     d at:'one'  update:[:val | val + 1].
    "

    "
     |d|

     d := Dictionary new.
     d at:'one' put:0.
     d at:'one'  update:[:val | d removeKey:'one'. val + 1].
    "

    "
     |d|
     d := Dictionary new.
     d at:'one' put:0.
     d at:'two' put:0.
     d at:'three' put:0.

     d at:'one'    update:[:val | val + 1].
     d at:'two'    update:[:val | val + 1].
     d at:'three'  update:[:val | val + 1].
     d at:'two'    update:[:val | val + 1].
     d at:'three'  update:[:val | val + 1].
     d at:'three'  update:[:val | val + 1].
     d
    "
!

keyAtEqualValue:aValue
    "return the key whose value is equal (i.e. using #= for compare)
     to the argument, nil if none found.
     This is a slow access, since there is no fast reverse mapping.
     NOTICE:
	The value is searched using equality compare;
	use #keyAtValue: to compare for identity."

    ^ self keyAtEqualValue:aValue ifAbsent:[nil]
!

keyAtEqualValue:aValue ifAbsent:exceptionBlock
    "return the key whose value is equal (i.e. using #= for compare)
     to the argument, if not found, return the value of exceptionBlock.
     This is a slow access, since there is no fast reverse mapping.
     NOTICE:
	The value is searched using equality compare;
	use #keyAtValue:ifAbsent: to compare for identity."

    |idx k|

    idx := 0.
    [true] whileTrue:[
	idx := valueArray indexOf:aValue startingAt:idx+1.
	idx == 0 ifTrue:[
	    ^ exceptionBlock value
	].
	(k := keyArray at:idx) notNil ifTrue:[
	    k ~~ DeletedEntry ifTrue:[
		k == NilEntry ifTrue:[
		    ^ nil
		].
		^ k
	    ].
	].
    ].
    "/ NOT REACHED
!

keyAtIdentityValue:aValue
    "return the key whose value is identical (i.e. using #== for compare)
     to the argument, nil if none found.
     This is a slow access, since there is no fast reverse mapping.
     NOTICE:
	The value is searched using identity compare;
	use #keyAtEqualValue: to compare for equality."

    ^ self keyAtIdentityValue:aValue ifAbsent:[nil]
!

keyAtIdentityValue:aValue ifAbsent:exceptionBlock
    "return the key whose value is identical (i.e. using #== for compare)
     to the argument, if not found, return the value of exceptionBlock.
     This is a slow access, since there is no fast reverse mapping.
     NOTICE:
	The value is searched using identity compare;
	use #keyAtEqualValue:ifAbsent: to compare for equality."

    |idx k|

    idx := 0.
    [true] whileTrue:[
	idx := valueArray identityIndexOf:aValue startingAt:idx+1.
	idx == 0 ifTrue:[
	    ^ exceptionBlock value
	].
	(k := keyArray at:idx) notNil ifTrue:[
	    k ~~ DeletedEntry ifTrue:[
		k == NilEntry ifTrue:[
		    ^ nil
		].
		^ k
	    ].
	].
    ].
    "/ NOT REACHED
!

keyAtValue:aValue
    "return the key whose value is identical (i.e. using #== for compare)
     to the argument, nil if none found.
     This is a slow access, since there is no fast reverse mapping.
     NOTICE:
	The value is searched using identity compare;
	use #keyAtEqualValue: to compare for equality."

    ^ self keyAtIdentityValue:aValue ifAbsent:[nil]
!

keyAtValue:aValue ifAbsent:exceptionBlock
    "return the key whose value is identical (i.e. using #== for compare)
     to the argument, if not found, return the value of exceptionBlock.
     This is a slow access, since there is no fast reverse mapping.
     NOTICE:
	The value is searched using identity compare;
	use #keyAtEqualValue:ifAbsent: to compare for equality."

    ^ self keyAtIdentityValue:aValue ifAbsent:exceptionBlock
!

keys
    "return a collection containing all keys of the receiver"

    |keySet|

    keySet := self emptyCollectionForKeys.
    keyArray do:[:key |
        (key notNil and:[key ~~ DeletedEntry]) ifTrue:[
            key == NilEntry ifTrue:[
                keySet add:nil
            ] ifFalse:[
                keySet add:key
            ]
        ]
    ].
    ^ keySet
! !

!Dictionary methodsFor:'adding & removing'!

add:anAssociation
    "add the argument, anAssociation to the receiver.
     Returns the argument, anAssociation.

     WARNING: do not add elements while iterating over the receiver.
              Iterate over a copy to do this."

    self at:(anAssociation key) put:(anAssociation value).
    ^ anAssociation

    "Modified: 1.3.1996 / 21:23:53 / cg"
!

addAll:aCollection
    "ANSI 5.7.2.1:
     Message:  addAll: dictionary
      Synopsis
	Store the elements of dictionary in the receiver at the
	corresponding keys from dictionary.
      Definition: <abstractDictionary>
	This message is equivalent to repeatedly sending the #at:put:
	message to the receiver with each of the keys and elements in
	dictionary in turn.  If a key in dictionary is key equivalent
	to a key in the receiver, the associated element in dictionary
	replaces the element in the receiver.

     Returns the argument, aCollection (sigh).

     WARNING: do not add elements while iterating over the receiver.
	      Iterate over a copy to do this."


    self ~~ aCollection ifTrue:[
	aCollection isSequenceable ifTrue:[
	    aCollection do:[:eachPair |
		self at:eachPair key put:eachPair value.
	    ].
	] ifFalse:[
	    aCollection keysAndValuesDo:[:eachKey :eachValue |
		self at:eachKey put:eachValue.
	    ]
	].
    ].
    ^ aCollection

    "
     |d1 d2|

     d1 := Dictionary new.
     d1 at:1 put:'one'.
     d1 at:2 put:'two'.
     d2 := Dictionary new.
     d2 at:3 put:'three'.
     d2 at:4 put:'four'.
     d1 addAll:d2.
     d1.
    "
!

addPairsFrom:aSequenceableCollection
    "merge consecutive key-value pairs from aSequenceableCollection into the receiver."

    aSequenceableCollection pairWiseDo:[:key :value |
	self at:key put:value.
    ]

    "
     |d1 arr|

     d1 := Dictionary new.
     d1 at:1 put:'one'.
     d1 at:2 put:'two'.
     arr := #(3 'three'  4 'four').
     d1 addPairsFrom:arr.
     d1.
    "

    "Modified: 1.3.1996 / 21:24:03 / cg"
!

clearContents
    "remove all elements from the receiver, but do not resize.
     Returns the receiver."

    keyArray atAllPut:nil.
    valueArray atAllPut:nil.
    tally := 0.
!

declare:key from:aDictionary
    "if the receiver does not include an association for key,
     take the association from aDictionary and add it to the receiver.
     If aDictionary does not contain such an association, use nil
     as the value of the new dictionary.

     Stubidity Notice:
	 Incompatibility with #declareAllFrom:, where the other values are
	 defined unconditionally.

     WARNING: do not add elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |value|

    (self includesKey:key) ifFalse:[
	value := aDictionary at:key ifAbsent:nil.
	self at:key put:value.
    ]

    "Modified: 1.3.1996 / 21:24:03 / cg"
!

declareAll:keys from:aCollectionOrDictionary
    "declare all keys in the first argument, keys
     from values taken from the second argument, aCollectionOrDictionary.
     If aCollectionOrDictionary is a dictionary, access via the key;
     if it is a sequencable collection, add corresponding values pairwise."

    aCollectionOrDictionary isDictionary ifTrue:[
        keys do:[:k | self at:k put:(aCollectionOrDictionary at:k) ]
    ] ifFalse:[
        keys with:aCollectionOrDictionary do:[:k :v | self at:k put:v ]
    ].

    "
     |d|

     d := Dictionary new.
     d declareAll:#(a b c) from:#(10 20 30).
     d.
    "
    "
     |d1 d2 d3|

     d1 := Dictionary new.
     d1 declareAll:#(a b c) from:#(10 20 30).
     d2 := Dictionary new.
     d2 declareAll:#( b c d) from:#(100 200 300).
     d3 := Dictionary new.
     d3 declareAll:#(a b c) from:d1.
     d3 declareAll:#(c d) from:d2.
     d3
    "
!

declareAllFrom:aDictionaryOrNil
    "merge all key-value pairs from aDictionary into the receiver.

     sigh:
	For compatibility with #declare:from: the behavior should be changed as following:
	If the receiver already contains a key, the existing value is retained.
	To keep the compatibility with other smalltalks, the semantics of this remains
	as is, and #declareAllNewFrom: was added for convenience.
	See #declareAllNewFrom: which does exactly what this name implies."

    self ~~ aDictionaryOrNil ifTrue:[
	aDictionaryOrNil notNil ifTrue:[
	    aDictionaryOrNil keysAndValuesDo:[:key :value |
		self at:key put:value.
	    ].
	]
    ]

    "Modified: / 18-09-2006 / 22:01:12 / cg"
!

declareAllNewFrom:aDictionaryOrNil
    "merge all new key-value pairs from aDictionary into the receiver
     i.e. If the receiver already contains a key, the existing value is retained.
     See also #declareAllFrom:"

    self ~~ aDictionaryOrNil ifTrue:[
	aDictionaryOrNil notNil ifTrue:[
	    aDictionaryOrNil keysAndValuesDo:[:key :value |
		(self includesKey:key) ifFalse:[
		    self at:key put:value.
		].
	    ]
	]
    ]

    "Created: / 18-09-2006 / 21:58:54 / cg"
!

remove:oldObject ifAbsent:aBlock
    "remove oldObject from the collection and return it.
     If it was not in the collection return the value of aBlock.

     This is blocked here; you have to use one of
     #removeKey:, #saveRemoveKey:, #removeAssociation:,
     #removeValue: or #saveRemoveValue:"

    ^ self shouldNotImplement

    "Modified: 1.3.1996 / 21:21:38 / cg"
!

removeAllKeys:aKeyCollection
    "remove all associations under each key in aKeyCollection from the collection.
     If it was not in the collection report an error.

     WARNING: do not remove elements while iterating over the receiver.
              See #safeRemoveKey: to do this."

    aKeyCollection do:[:eachKey |
        self removeKey:eachKey ifAbsent:[self errorKeyNotFound:eachKey]
    ].
!

removeAllKeys:aKeyCollection ifAbsent:aBlock
    "remove all associations under each key in aKeyCollection from the collection.
     If it was not in the collection return the result from evaluating aBlock
     (invoked for each missing element).

     WARNING: do not remove elements while iterating over the receiver.
              See #saveRemoveKey: to do this."

    aKeyCollection do:[:eachKey |
        self removeKey:eachKey ifAbsent:aBlock
    ].
!

removeAssociation:assoc
    "remove the association from the collection.
     If it was not in the collection report an error.
     Only the key is used in the passed argument, and a new
     association, for the key and the previously stored value is returned.

     WARNING: do not remove elements while iterating over the receiver.
	      See #saveRemoveKey: to do this."

    |key|

    key := assoc key.
    ^ Association key:key value:(self removeKey:key)

    "Modified: 1.3.1996 / 21:21:11 / cg"
!

removeIdentityValue:aValue ifAbsent:aBlock
    "remove (first) the association to aValue from the collection,
     return the key under which it was stored previously.
     If it was not in the collection return result from evaluating aBlock.
     The value is searched using identity compare.

     Notice, this does a linear search through the values and may
     therefore be slow for big dictionaries.

     WARNING: do not remove elements while iterating over the receiver.
             See #saveRemoveValue: to do this."
    
    |next   "{ Class:SmallInteger }"
     oldKey|

    keyArray
        keysAndValuesDo:[:index :aKey |
            |idx "{Class:SmallInteger}"|

            (aKey notNil and:[ aKey ~~ DeletedEntry ]) ifTrue:[
                idx := index.
                ((valueArray at:idx) == aValue) ifTrue:[
                    "found it"
                    valueArray basicAt:idx put:nil.
                    oldKey := keyArray basicAt:idx.
                    oldKey == NilEntry ifTrue:[
                        oldKey := nil
                    ].
                    keyArray basicAt:idx put:nil.
                    tally := tally - 1.
                    tally == 0 ifTrue:[
                        self initializeForCapacity:0.
                        ^ oldKey
                    ].
                    idx == keyArray basicSize ifTrue:[
                        next := 1
                    ] ifFalse:[
                        next := index + 1.
                    ].
                    (keyArray basicAt:next) notNil ifTrue:[
                        keyArray basicAt:idx put:DeletedEntry
                    ].
                    self possiblyShrink.
                    ^ oldKey
                ]
            ]
        ].
    ^ aBlock value

    "Modified: 1.3.1996 / 21:22:11 / cg"
!

removeKey:aKey
    "remove the association under aKey from the collection.
     If it was not in the collection report an error.

     WARNING: do not remove elements while iterating over the receiver.
	      See #saveRemoveKey: to do this."

    ^ self removeKey:aKey ifAbsent:[self errorKeyNotFound:aKey]

    "Modified: 1.3.1996 / 21:21:52 / cg"
!

removeKey:aKey ifAbsent:aBlock
    "remove the association under aKey from the collection,
     return the value previously stored there.
     If it was not in the collection return the result
     from evaluating aBlock.

     WARNING: do not remove elements while iterating over the receiver.
             See #saveRemoveKey: to do this."

    |index "{ Class:SmallInteger }"
     "/ next  "{ Class:SmallInteger }"
     oldValue k|

    (k := aKey) isNil ifTrue:[
"/ no longer invalid
"/        ^ self errorInvalidKey:aKey
        k := NilEntry
    ].

    "/   below, I could have written:
    "/      index := self find:aKey ifAbsent:[^ aBlock value]
    "/   but the code below is slighlty more efficient, since it avoids
    "/   a garbage block creation - thus speeding up the good case.

    index := self find:k ifAbsent:0.
    index == 0 ifTrue:[^ aBlock value].

    oldValue := valueArray basicAt:index.

    valueArray basicAt:index put:nil.
    keyArray basicAt:index put:DeletedEntry.

    tally := tally - 1.
    tally == 0 ifTrue:[
        self initializeForCapacity:0
    ] ifFalse:[
"/        index == keyArray basicSize ifTrue:[
"/            next := 1
"/        ] ifFalse:[
"/            next := index + 1.
"/        ].
"/        (keyArray basicAt:next) notNil ifTrue:[
"/            keyArray basicAt:index put:DeletedEntry
"/        ].
        self possiblyShrink
    ].
    ^ oldValue

    "Modified: 1.3.1996 / 21:21:01 / cg"
!

removeValue:aValue
    "remove (first) the association to aValue from the collection,
     return the key under which it was stored previously.
     If it was not in the collection, report an error.
     The value is searched using equality compare here,
     but identity compare in the IdentityDictionary subclass.

     Notice, this does a linear search through the values and may
     therefore be slow for big dictionaries.

     WARNING: do not remove elements while iterating over the receiver.
	     See #saveRemoveValue: to do this."

    ^ self removeValue:aValue ifAbsent:[self errorValueNotFound:aValue]

    "
     |d|

     d := Dictionary new.
     d at:1 put:'one'.
     d at:2 put:'two'.
     d at:3 put:'three'.
     d removeValue:'two'.
     d
    "
!

removeValue:aValue ifAbsent:aBlock
    "remove (first) the association to aValue from the collection,
     return the key under which it was stored previously.
     If it was not in the collection return result from evaluating aBlock.
     The value is searched using equality compare here,
     but identity compare in the IdentityDictionary subclass.

     Notice, this does a linear search through the values and may
     therefore be slow for big dictionaries.

     WARNING: do not remove elements while iterating over the receiver.
             See #saveRemoveValue: to do this."

    |next  "{ Class:SmallInteger }"
     oldKey|

    keyArray keysAndValuesDo:[:index :aKey |
        |idx "{Class:SmallInteger}"|

        (aKey notNil and:[aKey ~~ DeletedEntry]) ifTrue:[
            idx := index.
            (self compareSame:(valueArray at:idx) with:aValue) ifTrue:[
                "found it"
                valueArray basicAt:idx put:nil.
                oldKey := keyArray basicAt:idx.
                oldKey == NilEntry ifTrue:[
                    oldKey := nil
                ].
                keyArray basicAt:idx put:nil.
                tally := tally - 1.
                tally == 0 ifTrue:[
                    self initializeForCapacity:0.
                    ^ oldKey
                ].

                idx == keyArray basicSize ifTrue:[
                    next := 1
                ] ifFalse:[
                    next := index + 1.
                ].
                (keyArray basicAt:next) notNil ifTrue:[
                    keyArray basicAt:idx put:DeletedEntry
                ].
                self possiblyShrink.
                ^ oldKey
            ]
        ]
    ].
    ^ aBlock value

    "Modified: 1.3.1996 / 21:22:11 / cg"
!

safeRemoveKey:aKey
    "remove the association under aKey from the collection.
     Return the value previously stored there.
     If it was not in the collection return nil.

     In contrast to #removeKey:, this does not resize the underlying collection
     and therefore does NOT rehash & change the elements order.
     Therefore this can be used while enumerating the receiver,
     which is not possible if #removeKey: is used.

     WARNING: since no resizing is done, the physical amount of memory used
              by the container remains the same, although the logical size shrinks.
              You may want to manually resize the receiver using #possiblyShrink."

    |index "{ Class:SmallInteger }"
     next  "{ Class:SmallInteger }"
     oldValue k|

    (k := aKey) isNil ifTrue:[
        k := NilEntry
    ].
"/    aKey isNil ifTrue:[^ nil].

    index := self find:k ifAbsent:0.
    index == 0 ifTrue:[^ nil].

    oldValue := valueArray basicAt:index.

    valueArray basicAt:index put:nil.
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
    ^ oldValue

    "does NOT work:

        |d|

        d := Dictionary new.
        d at:'one' put:1.
        d at:'two' put:2.
        d at:'three' put:3.
        d at:'four' put:4.
        d at:'five' put:5.
        d at:'six' put:6.
        d at:'seven' put:7.
        d at:'eight' put:8.
        d at:'nine' put:9.
        d keysAndValuesDo:[:k :v |
            v odd ifTrue:[
                d removeKey:k
            ]
        ].
        d inspect
    "

    "DOES work:

        |d|

        d := Dictionary new.
        d at:'one' put:1.
        d at:'two' put:2.
        d at:'three' put:3.
        d at:'four' put:4.
        d at:'five' put:5.
        d at:'six' put:6.
        d at:'seven' put:7.
        d at:'eight' put:8.
        d at:'nine' put:9.
        d keysAndValuesDo:[:k :v |
            v odd ifTrue:[
                d safeRemoveKey:k
            ]
        ].
        d inspect
    "

    "Created: 1.3.1996 / 21:14:42 / cg"
    "Modified: 1.3.1996 / 21:14:53 / cg"
!

safeRemoveValue:aValue
    "remove the (first) association to aValue from the collection,
     return the key under which it was stored previously.
     If it was not in the collection return nil.
     The value is searched using equality compare here,
     but identity compare in the IdentityDictionary subclass.

     In contrast to #removeValue:, this does not resize the underlying collection
     and therefore does NOT rehash & change the elements order.
     Therefore, this can be used while enumerating the receiver,
     which is not possible if #removeValue: is used.

     WARNING: since no resizing is done, the physical amount of memory used
              by the container remains the same, although the logical size shrinks.
              You may want to manually resize the receiver using #possiblyShrink."

    |next  "{ Class:SmallInteger }"
     oldKey|

    keyArray keysAndValuesDo:[:index :aKey |
        |idx "{Class:SmallInteger}"|

        (aKey notNil and:[aKey ~~ DeletedEntry]) ifTrue:[
            idx := index.
            (self compareSame:(valueArray at:idx) with:aValue) ifTrue:[
                "found it"
                valueArray basicAt:idx put:nil.
                oldKey := keyArray basicAt:idx.
                oldKey == NilEntry ifTrue:[
                    oldKey := nil
                ].
                keyArray basicAt:idx put:nil.
                tally := tally - 1.
                tally ~~ 0 ifTrue:[
                    idx == keyArray basicSize ifTrue:[
                        next := 1
                    ] ifFalse:[
                        next := index + 1.
                    ].
                    (keyArray basicAt:next) notNil ifTrue:[
                        keyArray basicAt:idx put:DeletedEntry
                    ].
                ].
                ^ oldKey
            ]
        ]
    ].
    ^ aValue

    "does NOT work:

        |d|

        d := Dictionary new.
        d at:'one' put:1.
        d at:'two' put:2.
        d at:'three' put:3.
        d at:'four' put:4.
        d at:'five' put:5.
        d at:'six' put:6.
        d at:'seven' put:7.
        d at:'eight' put:8.
        d at:'nine' put:9.
        d keysAndValuesDo:[:k :v |
            v odd ifTrue:[
                d removeValue:v ifAbsent:nil
            ]
        ].
        d inspect
    "

    "DOES work:

        |d|

        d := Dictionary new.
        d at:'one' put:1.
        d at:'two' put:2.
        d at:'three' put:3.
        d at:'four' put:4.
        d at:'five' put:5.
        d at:'six' put:6.
        d at:'seven' put:7.
        d at:'eight' put:8.
        d at:'nine' put:9.
        d keysAndValuesDo:[:k :v |
            v odd ifTrue:[
                d safeRemoveValue:v
            ]
        ].
        d inspect
    "

    "Created: 1.3.1996 / 21:17:10 / cg"
    "Modified: 1.3.1996 / 21:23:04 / cg"
!

saveRemoveKey:aKey
    <resource: #obsolete>
    "bad spelling - kept for backward compatibility (2014-06-04)"

    ^ self safeRemoveKey:aKey.
!

saveRemoveValue:aValue
    <resource: #obsolete>
    "bad spelling - kept for backward compatibility (2014-06-04)"

    ^ self safeRemoveValue:aValue.
! !

!Dictionary methodsFor:'comparing'!

= aCollection
    "return true, if the argument is a Dictionary containing the same
     key-value pairs as I do"

    aCollection species == self species ifFalse:[^ false].
    aCollection size == self size ifFalse:[^ false].
    "/ all of of my key-value associations must be in the other collection ...
    self keysAndValuesDo:[:key :value |
	((aCollection at:key ifAbsent:[^ false]) = value) ifFalse:[^ false]
    ].
    ^ true

    "
     |d1 d2|

     d1 := Dictionary new.
     d2 := Dictionary new.
     d1 at:1 put:'one'.
     d1 at:'one' put:1.
     d1 at:2 put:#two.
     d1 at:'two' put:2.

     d2 at:1 put:'one'.
     d2 at:'one' put:1.
     d2 at:2 put:#two.
     d2 at:'two' put:2.
     d1 = d2
    "

    "
     |d1 d2|

     d1 := Dictionary new.
     d2 := Dictionary new.
     d1 at:1 put:'uno'.
     d1 at:'one' put:1.
     d1 at:2 put:#two.
     d1 at:'two' put:2.

     d2 at:1 put:'one'.
     d2 at:'one' put:1.
     d2 at:2 put:#two.
     d2 at:'two' put:2.
     d1 = d2
    "

    "
     |d1 d2|

     d1 := Dictionary new.
     d2 := Dictionary new.
     d1 at:10 put:'one'.
     d1 at:'one' put:1.
     d1 at:2 put:#two.
     d1 at:'two' put:2.

     d2 at:1 put:'one'.
     d2 at:'one' put:1.
     d2 at:2 put:#two.
     d2 at:'two' put:2.
     d1 = d2
    "



! !

!Dictionary methodsFor:'converting'!

asDictionary
    ^ self
!

asNewDictionary
    "return myself as an unique new dictionary"

    ^ self copy
!

associationsOrderedBy:aCollectionOfKeys
    "return an OrderedCollection of my key-value pairs, ordered by the given key list"

    self assert:(aCollectionOfKeys size == self size).
    ^ aCollectionOfKeys collect:[:eachKey | eachKey -> (self at:eachKey) ] as: OrderedCollection

    "
     |d|

     d := Dictionary new.
     d at:'zzz' put:3.
     d at:'aaa' put:1.
     d at:'eee' put:2.
     d.
     d valuesOrderedBy:#('aaa' 'eee' 'zzz').
     d associationsOrderedBy:#('aaa' 'eee' 'zzz').
    "

    "Created: / 31-07-2012 / 17:32:34 / cg"
!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be of the form:
	(Dictionary key1 val1 ... keyN valN)"

    2 to:encoding size by:2 do:[:i |
	|key val|

	key := encoding at:i.
	val := encoding at:i+1.
	self at:key put:val
    ].

    "
     Dictionary new fromLiteralArrayEncoding:#(Dictionary 'hello' 'world' 1 'foo')
    "

    "Created: / 30.1.1998 / 04:30:47 / cg"
!

literalArrayEncoding
    |literalArrray idx|

    literalArrray := Array new:(self size * 2)+1.
    literalArrray at:1 put:self class name.
    idx := 2.
    self keysAndValuesDo:[:eachKey :eachValue |
	literalArrray
	    at:idx   put:eachKey literalArrayEncoding;
	    at:idx+1 put:eachValue literalArrayEncoding.
	idx := idx + 2.
    ].
    ^ literalArrray

    "
      |dict|

      dict := Dictionary new.
      dict at:1 put:'bla'.
      dict at:'fasel' put:#[1 2 3 4].
      dict literalArrayEncoding
    "
!

valuesOrderedBy:aCollectionOfKeys
    "return an OrderedCollection of my values, ordered by the given key list"

    self assert:(aCollectionOfKeys size == self size).
    ^ aCollectionOfKeys collect:[:eachKey | self at:eachKey ] as: OrderedCollection

    "Created: / 31-07-2012 / 17:33:12 / cg"
! !

!Dictionary methodsFor:'copying'!

, anotherDictionaryOrAssociation
    "return a new dictionary containing a merged set of associations.
     If anotherDictionaryOrAssociation includes any of the receiver's keys,
     the value from anotherDictionaryOrAssociation will be placed into the
     returned result."

    |newDictionary|

    newDictionary := self copy.
    newDictionary declareAllFrom:anotherDictionaryOrAssociation.
    ^ newDictionary

    "
     |d1 d2|

     d1 := Dictionary new.
     d1 at:#a put:'aaa'.
     d1 at:#b put:'bbb'.

     d2 := Dictionary new.
     d2 at:#b put:'bbbb'.
     d2 at:#c put:'ccc'.

     d1 , d2
    "
    "
     |d1 d2|

     d1 := Dictionary new.
     d1 at:#a put:'aaa'.
     d1 at:#b put:'bbb'.
     d2 := d1 , (#c -> 'ccc').
     d2
    "
!

postCopy
    "have to copy the valueArray too"

    super postCopy.
    valueArray := valueArray shallowCopy
! !

!Dictionary methodsFor:'enumerating'!

allKeysDo:aBlock
    "perform the block for all keys in the collection.
     Obsolete: use keysDo: for ST-80 compatibility."

    <resource:#obsolete>

    self obsoleteMethodWarning:'please use #keysDo:'.
    ^ self keysDo:aBlock

    "Modified: 20.4.1996 / 11:22:01 / cg"
!

associationsCollect:aBlock
    "for each key-value pair in the receiver, evaluate the argument, aBlock
     and return a collection with the results.

     See also:
	#keysAndValuesCollect: (which passes separate keys & values)
	#collect:              (which only passes values)

     This is much like #keysAndValuesCollect:, but aBlock gets the
     key and value as a single association argument.
     #keysAndValuesCollect: and is a bit faster therefore (no intermediate objects).

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |newCollection|

    newCollection := OrderedCollection new.
    self keysAndValuesDo:[:key :value |
	newCollection add:(aBlock value:(Association key:key value:value))
    ].
    ^ newCollection

    "
     |ages|

     ages := Dictionary new.
     ages at:'cg' put:37.
     ages at:'ca' put:33.
     ages at:'sv' put:36.
     ages at:'tk' put:28.
     ages associationsCollect:[:assoc |
		assoc key , '''s age is ' , assoc value printString]
    "

    "Modified: 20.4.1996 / 11:31:27 / cg"
!

associationsDo:aBlock
    "perform the block for all associations in the collection.

     See also:
	#do:              (which passes values to its block)
	#keysDo:          (which passes only keys to its block)
	#keysAndValuesDo: (which passes keys&values)

     This is much like #keysAndValuesDo:, but aBlock gets the
     key and value as a single association argument.
     #keysAndValuesDo: and is a bit faster therefore (no intermediate objects).

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |key n "{ Class: SmallInteger }"|

    tally == 0 ifTrue:[^ self].
    n := keyArray basicSize.
    1 to:n do:[:index |
	key := keyArray basicAt:index.
	(key notNil and:[key ~~ DeletedEntry]) ifTrue:[
	    key == NilEntry ifTrue:[
		key := nil
	    ].
	    aBlock value:(Association key:key value:(valueArray basicAt:index))
	]
    ]

    "Modified: 20.4.1996 / 11:31:39 / cg"
!

associationsDo:aBlock separatedBy:sepBlock
    "perform the block for all associations in the collection.

     See also:
	#do:              (which passes values to its block)
	#keysDo:          (which passes only keys to its block)
	#keysAndValuesDo: (which passes keys&values)

     This is much like #keysAndValuesDo:, but aBlock gets the
     key and value as a single association argument.
     #keysAndValuesDo: and is a bit faster therefore (no intermediate objects).

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |key n "{ Class: SmallInteger }"
     first|

    tally == 0 ifTrue:[^ self].

    first := true.
    n := keyArray basicSize.
    1 to:n do:[:index |
	key := keyArray basicAt:index.
	(key notNil and:[key ~~ DeletedEntry]) ifTrue:[
	    key == NilEntry ifTrue:[
		key := nil
	    ].
	    first ifTrue:[
		first := false.
	    ] ifFalse:[
		sepBlock value
	    ].
	    aBlock value:(Association key:key value:(valueArray basicAt:index))
	]
    ]

    "Modified: / 20-04-1996 / 11:31:39 / cg"
    "Created: / 23-09-2011 / 14:07:43 / cg"
!

associationsReverseDo:aBlock
    "perform the block for all associations in the collection.
     Since dictionary does not define any order of its elements,
     this is the same as #associationsDo: here.
     Provided for protocol compatibility with OrderedDictionary"

    ^ self associationsDo:aBlock

    "Created: 28.2.1997 / 16:08:52 / cg"
!

associationsSelect:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     The block gets keys and values as an association argument.

     See also: #keysAndValuesSelect: (which is slightly faster),
	       #select: (which only passes the value)

     This is much like #keysAndValuesSelect:, but aBlock gets the
     key and value as a single association argument.
     #keysAndValuesSelect: and is a bit faster therefore (no intermediate objects).

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |newCollection|

    newCollection := self species new.
    self keysAndValuesDo:[:key :value |
	(aBlock value:(Association key:key value:value)) ifTrue:[
	    newCollection at:key put:value
	]
    ].
    ^ newCollection

    "
     |ages|

     ages := Dictionary new.
     ages at:'cg' put:37.
     ages at:'ca' put:33.
     ages at:'sv' put:36.
     ages at:'tk' put:28.

     ages associationsSelect:[:assoc |
		(assoc key startsWith:'c') or:[assoc value < 30]].
    "

    "Modified: 20.4.1996 / 11:31:15 / cg"
!

do:aBlock
    "perform the block for all values in the collection.

     See also:
	#associationsDo:   (which passes key-value associations)
	#keysAndValuesDo:  (which passes keys & values separately)
	#keysDo:           (which passes keys only)

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |key n "{ Class: SmallInteger }"
     deletedEntry|

    tally == 0 ifTrue:[^ self].
    n := keyArray basicSize.
    deletedEntry := DeletedEntry.
    1 to:n do:[:index |
	key := keyArray basicAt:index.
	(key notNil and:[key ~~ deletedEntry]) ifTrue:[
	    aBlock value:(valueArray basicAt:index)
	].
    ]

    "Modified: 20.4.1996 / 11:32:11 / cg"
!

keysAndValuesDo:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both key and element as arguments.

     See also:
	#associationsDo:       (which passes keys->value pairs)
	#do:                   (which only passes values)
	#keysDo:               (which only passes keys)

     This is much like #associationsDo:, but aBlock gets the
     key and value as two separate arguments.
     #associationsDo: is a bit slower.

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |key n "{ Class: SmallInteger }"
     deletedEntry|

    tally == 0 ifTrue:[^ self].
    n := keyArray basicSize.
    deletedEntry := DeletedEntry.
    1 to:n do:[:index |
	key := keyArray basicAt:index.
	(key notNil and:[key ~~ deletedEntry]) ifTrue:[
	    key == NilEntry ifTrue:[
		key := nil
	    ].
	    aTwoArgBlock value:key value:(valueArray basicAt:index)
	].
    ]

    "Modified: 20.4.1996 / 11:33:42 / cg"
!

keysAndValuesSelect:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     The block gets keys and values as separate arguments.

     See also:
	#associationsSelect:    (which passes key-value pairs),
	#keysSelect:            (which passes key values),
	#select:                (which only passes the value)

     This is much like #associationsSelect:, but aBlock gets the
     key and value as two separate arguments.
     #associationsSelect: is a bit slower.

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |newCollection|

    newCollection := self species new.
    self keysAndValuesDo:[:key :value |
	(aBlock value:key value:value) ifTrue:[
	    newCollection at:key put:value
	]
    ].
    ^ newCollection

    "
     |ages|

     ages := Dictionary new.
     ages at:'cg' put:37.
     ages at:'ca' put:33.
     ages at:'sv' put:36.
     ages at:'tk' put:28.

     ages keysAndValuesSelect:[:name :age |
		(name startsWith:'c') or:[age < 30]].
    "

    "Modified: 20.4.1996 / 11:34:29 / cg"
!

keysDo:aBlock
    "evaluate the argument, aBlock for every key in the collection.

     See also:
	#associationsDo:   (which passes key-value associations)
	#keysAndValuesDo:  (which passes keys & values separately)
	#do:               (which passes values only)

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |sz "{ Class: SmallInteger }"
     key|

    sz := keyArray size.
    1 to:sz do:[:index |
	key := keyArray at:index.
	(key notNil and:[key ~~ DeletedEntry]) ifTrue:[
	    key == NilEntry ifTrue:[
		key := nil
	    ].
	    aBlock value:key
	]
    ]

    "Modified: / 24-08-2010 / 10:13:58 / cg"
!

keysSelect:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     The block gets the individual keys as its single argument.

     See also:
	#associationsSelect:            (which passes key->value associations),
	#keysAndValuesSelect:           (which passes key & value args)
	#select:                        (which passes values as arg),

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |newCollection|

    newCollection := self species new.
    self keysAndValuesDo:[:key :value |
	(aBlock value:key) ifTrue:[
	    newCollection at:key put:value
	]
    ].
    ^ newCollection

    "
     |d|

     d := Dictionary new.
     d at:#foo put:#bar.
     d at:#bar put:#baz.
     d at:#baz put:#foo.

     d select:[:el | el startsWith:'b'].
    "

    "Modified: / 12-10-2006 / 11:24:06 / cg"
!

select:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     The block gets the individual values as its single argument.

     See also:
	#associationsSelect:            (which passes key->value associations),
	#keysAndValuesSelect:           (which passes key & value args)
	#keysSelect:                    (which passes key values),

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |newCollection|

    newCollection := self species new.
    self keysAndValuesDo:[:key :value |
	(aBlock value:value) ifTrue:[
	    newCollection at:key put:value
	]
    ].
    ^ newCollection

    "
     |d|

     d := Dictionary new.
     d at:#foo put:#bar.
     d at:#bar put:#baz.
     d at:#baz put:#foo.

     d select:[:el | el startsWith:'b'].
    "

    "Modified: / 12-10-2006 / 11:24:06 / cg"
!

valuesDo:aBlock
    "perform the block for all values in the collection.
     Same as #do: - for VisualWorks compatibility"

    ^ self do:aBlock
!

xor:aCollection
    "return a new set containing all elements,
     which are contained in either the receiver or aCollection, but not in both."

    |newCollection|

    newCollection := self species new.
    self keysAndValuesDo:[:key :value |
        (aCollection includes:value) ifFalse:[
            newCollection at:key put:value
        ]
    ].
    aCollection keysAndValuesDo:[:key :value |
        (self includes:value) ifFalse:[
            newCollection at:key put:value
        ]
    ].

    ^ newCollection

    "
     (Dictionary withKeysAndValues:#(1 'uno' 2 'due' 3 'tre' 4 'quatro'))
        xor:(Dictionary withKeysAndValues:#(1 'uno'  4 'quatro' 5 'cinque'))
    "

    "Created: / 20-01-2017 / 19:43:48 / stefan"
! !



!Dictionary methodsFor:'printing & storing'!

printElementsDo:aBlock
    "redefined, so #printOn: prints associations"

    ^ self associationsDo:aBlock

    "Created: / 20.1.1998 / 14:11:02 / stefan"
!

storeOn:aStream
    "output a printed representation (which can be re-read)
     onto the argument aStream"

    |isEmpty|

    thisContext isRecursive ifTrue:[
        RecursiveStoreError raiseRequestWith:self.
        ('Dictionary [error]: storeOn: of self referencing collection.') errorPrintCR.
        aStream nextPutAll:'#recursive'.
        ^ self
    ].

    aStream nextPutAll:'('.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' new'.
    isEmpty := true.
    self keysAndValuesDo:[:key :value |
        aStream nextPutAll:' at:'.
        key storeOn:aStream.
        aStream nextPutAll:' put:'.
        value storeOn:aStream.
        aStream nextPutAll:'; '.
        isEmpty := false
    ].
    isEmpty ifFalse:[aStream nextPutAll:' yourself'].
    aStream nextPut:$)

    "
     Dictionary new storeOn:Transcript

     (Dictionary new at:1 put:'hello'; yourself) storeOn:Transcript

     (Dictionary new at:1 put:'hello'; at:2 put:nil; yourself) storeOn:Transcript
    "

    "
     |d|
     d := Dictionary new.
     d at:1 put:'hello'.
     d at:'hello' put:#world.
     d storeOn:Transcript
    "

    "
     |d|
     d := Dictionary new.
     d at:1 put:'hello'.
     d at:'hello' put:#world.
     d at:2 put:d.
     d storeOn:Transcript
    "

    "Modified: 28.1.1997 / 00:37:46 / cg"
! !

!Dictionary methodsFor:'private'!

compareSame:element1 with:element2
    "compare two elements for being the same. Here, return true if the
     elements are equal (i.e. using #=).
     Redefinable in subclasses."

    ^ element1 = element2

    "Modified: 22.4.1996 / 17:34:27 / cg"
!

emptyCollectionForKeys
    "return an empty collection to hold keys. Here, a Set is returned.
     Redefinable in subclasses."

    ^ Set new:(self size)

    "Modified: 22.4.1996 / 17:35:17 / cg"
!

grow:newSize
    "grow the receiver to make space for at least newSize elements.
     To do this, we have to rehash into the new arrays.
     (which is done by re-adding all elements to a new, empty key/value array pair)."

    |key deletedEntry oldKeyArray oldValueArray n
     oldSize  "{ Class:SmallInteger }"
     newIndex "{ Class:SmallInteger }" |

    oldKeyArray := keyArray.
    oldValueArray := valueArray.

    n := self class goodSizeFrom:newSize.
    oldSize := oldKeyArray size.
    n == oldSize ifTrue:[^ self].

    keyArray := self keyContainerOfSize:n.
    valueArray := self valueContainerOfSize:n.


    deletedEntry := DeletedEntry.
    1 to:oldSize do:[:index |
	key := oldKeyArray basicAt:index.
	(key notNil and:[key ~~ deletedEntry]) ifTrue:[
	    newIndex := self findNil:key.
	    keyArray basicAt:newIndex put:key.
	    valueArray basicAt:newIndex put:(oldValueArray basicAt:index).
	]
    ]
!

initializeForCapacity:minSize
    "initialize the contents array (for at least minSize slots)
     and set tally to zero.
     The size is increased to the next prime for better hashing behavior."

    |n|

    n := self class goodSizeFrom:minSize.
    (keyArray notNil and:[n == keyArray size]) ifTrue:[
        keyArray atAllPut:nil.
        valueArray atAllPut:nil.
    ] ifFalse:[
        keyArray := self keyContainerOfSize:n.
        valueArray := self valueContainerOfSize:n.
    ].
    tally := 0

    "Modified: / 5.8.1998 / 10:48:51 / cg"
!

rehash
    "rehash contents - is done by re-adding all elements to a new, empty key/value array pair)."

    | oldKeyArray oldValueArray key
      n        "{ Class:SmallInteger }"
      newIndex "{ Class:SmallInteger }" |

    oldKeyArray := keyArray.
    oldValueArray := valueArray.

    n := keyArray size.
    keyArray := self keyContainerOfSize:n.
    valueArray := self valueContainerOfSize:n.

    1 to:n do:[:index |
	key := oldKeyArray basicAt:index.
	(key notNil and:[key ~~ DeletedEntry]) ifTrue:[
	    newIndex := self findNil:key.
	    keyArray basicAt:newIndex put:key.
	    valueArray basicAt:newIndex put:(oldValueArray basicAt:index).
	]
    ]
!

rehashFrom:startIndex
    "rehash elements starting at index - after a remove.
     NOTE: this method is no longer needed;
	   the trick using DeletedEntry avoids the need to do this time
	   consuming operation, making remove pretty fast :-)
    "

    |key i length
     index "{ Class:SmallInteger }" |

    length := keyArray basicSize.
    index := startIndex.
    key := keyArray basicAt:index.
    [key notNil] whileTrue:[
	key ~~ DeletedEntry ifTrue:[
	    i := self findNil:key.
	    i == index ifTrue:[
		^ self
	    ].
	    keyArray basicAt:i put:key.
	    valueArray basicAt:i put:(valueArray basicAt:index).
	    keyArray basicAt:index put:nil.
	    valueArray basicAt:index put:nil.
	].
	index == length ifTrue:[
	    index := 1
	] ifFalse:[
	    index := index + 1.
	].
	key := keyArray basicAt:index.
    ]
!

valueContainerOfSize:n
    "return a container for values of size n.
     Extracted to make life of weak subclasses easier ..."

    ^ Array basicNew:n
! !

!Dictionary methodsFor:'queries'!

speciesForCollecting
     "like species, but used when doing collect operations.
      Redefined for collections which return a different classes object when doing collect."

    ^ Bag

    "Created: / 20-01-2017 / 17:46:16 / stefan"
! !

!Dictionary methodsFor:'searching'!

findFirst:aBlock ifNone:exceptionValue
    "find the index of the first element, for which evaluation of the argument, aBlock returns true;
     return its index or the value from exceptionValue if none detected.
     This is much like #detect:ifNone:, however, here an INDEX is returned,
     while #detect:ifNone: returns the element.

     Here we return the first key for which aBlock matches the value.
     Note that there is no order in a Dictionary, so any element is first."

    self keysAndValuesDo:[:eachKey :eachValue| (aBlock value:eachValue) ifTrue:[^ eachKey]].
    ^ exceptionValue value.

    "
        (Dictionary withKeys:#('a' 'b' 'c') andValues:#('bla' 'hello' 'hallo'))
            findFirst:[:v| v first = $h].
    "
!

findFirstKey:aBlock
    "find and return the first key, for which evaluation of the argument, aBlock
     returns true; return nil if none is detected."

    self keysDo:[:key |
	(aBlock value:key) ifTrue:[^ key].
    ].
    ^ nil

    "Created: 5.6.1996 / 11:55:50 / stefan"
    "Modified: 8.10.1996 / 22:01:59 / cg"
! !

!Dictionary methodsFor:'testing'!

includes:anObject
    "return true, if the argument, aValue is stored in the dictionary,
     i.e. if there is an associaten, with aValue as value.
     This is a slow search, since there is no fast reverse mapping;
     the values have to be all scanned without any hashing.
     You need a special collection (or two Dictionaries) to get this
     reverse mapping fast."

    ^ self includesEqualValue:anObject

    "Modified: 22.4.1996 / 17:20:11 / cg"
!

includesAssociation:anAssociation
    "return true, if there is an association in the receiver with the
     same key and value as the argument, anAssociation.
     NOTICE: in contrast to #includes:, this compares both key and value."

    |val|

    val := self at:(anAssociation key) ifAbsent:[^ false].
    ^ self compareSame:val with:anAssociation value

    "Modified: / 5.3.1998 / 20:35:00 / cg"
!

includesEqualValue:aValue
    "return true, if the argument, aValue is stored in the dictionary,
     i.e. if there is an associaten, with aValue as value.
     This is a slow search, since there is no fast reverse mapping;
     the values have to be all scanned without any hashing.
     You need a special collection (or two Dictionaries) to get this
     reverse mapping fast."

    aValue isNil ifTrue:[
	"/ need a special case for that ...
	^ self includesIdenticalValue:aValue.
    ].

    ^ valueArray includes:aValue

    "
     |d|

     d := Dictionary new.
     d at:'1' put:'one'.
     d includes:nil.
    "

    "
     |d|

     d := Dictionary new.
     d at:'1' put:'one'.
     d at:2 put:nil.
     d includes:nil.
    "

!

includesIdenticalValue:aValue
    "return true, if the argument, aValue is stored in the dictionary,
     i.e. if there is an associaten, with aValue as value.
     This is a slow search, since there is no fast reverse mapping;
     the values have to be all scanned without any hashing.
     You need a special collection (or two Dictionaries) to get this
     reverse mapping fast."

    |idx|

    aValue isNil ifTrue:[
	"/ need a special case for that ...
	idx := 0.
	[true] whileTrue:[
	    idx := valueArray identityIndexOf:nil startingAt:idx+1.
	    idx == 0 ifTrue:[^ false].
	    (keyArray at:idx) notNil ifTrue:[^ true].
	]
    ].

    ^ valueArray includesIdentical:aValue

    "
     |d|

     d := Dictionary new.
     d at:'1' put:'one'.
     d includes:nil.
    "

    "
     |d|

     d := Dictionary new.
     d at:'1' put:'one'.
     d at:2 put:nil.
     d includes:nil.
    "

!

includesKey:aKey
    "return true, if the argument, aKey is a key in the receiver"

    ^ (self find:(aKey ? NilEntry) ifAbsent:0) ~~ 0

    "Modified: / 17-08-2006 / 21:06:41 / cg"
!

includesValue:aValue
    "return true, if the argument, aValue is stored in the dictionary,
     i.e. if there is an associaten, with aValue as value.
     This is a slow search, since there is no fast reverse mapping;
     the values have to be all scanned without any hashing.
     You need a special collection (or two Dictionaries) to get this
     reverse mapping fast."

    ^ self includesEqualValue:aValue

!

isDictionary
    "return true, if the receiver is some kind of dictionary;
     true returned here - the method is redefined from Object."

    ^ true
!

occurrencesOf:anObject
    "count & return how often anObject is stored in the dictionary.
     This counts values - not keys. Uses #= (i.e. equality) compare."

    |idx count|

    anObject isNil ifTrue:[
	"/ need a special case for that ...
	idx := 0.
	count := 0.
	[true] whileTrue:[
	    idx := valueArray identityIndexOf:nil startingAt:idx+1.
	    idx == 0 ifTrue:[^ count].
	    (keyArray at:idx) notNil ifTrue:[
		count := count + 1
	    ]
	]
    ].

    ^ valueArray occurrencesOf:anObject

    "
     |d|

     d := Dictionary new.
     d at:'1' put:'one'.
     d occurrencesOf:nil.
    "

    "
     |d|

     d := Dictionary new.
     d at:'1' put:'one'.
     d at:2 put:nil.
     d at:5 put:nil.
     d occurrencesOf:nil.
    "

! !

!Dictionary methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitDictionary:with: to aVisitor"

    ^ aVisitor visitDictionary:self with:aParameter
! !


!Dictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

