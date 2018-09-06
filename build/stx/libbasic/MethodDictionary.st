"
 COPYRIGHT (c) 1995 by eXept Software AG
 COPYRIGHT (c) 2010 Jan Vrany
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

KeyedCollection variableSubclass:#MethodDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!MethodDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by eXept Software AG
 COPYRIGHT (c) 2010 Jan Vrany
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
    Instances of MethodDictionary store selector/method associations
    in classes. Conceptionally, they behave like IdentityDictionaries, but are
    implemented using a single array (instead of Dictionary, which uses
    two arrays to store keys and values separately).
    Also, they do not use hashing, since due to caching in the VM, hashing
    does not make too much of a difference in speed, but complicates the 
    VM implementation.

    [author:]
        Stefan Vogel

    [see also:]
        Dictionary
        IdentityDictionary
        Behavior Class
        Method 
        Symbol
"
! !

!MethodDictionary class methodsFor:'instance creation'!

new:sz 
    "create and return a new methodDictionary holding sz
     key->value associations"

    ^ self basicNew:(sz * 2)
!

withAll:aDictionary
    "create a MethodDictionary from another Dictionary"

    |newDict i "{ Class: SmallInteger }" |

    newDict := self new:aDictionary size.
    i := 1.
    aDictionary keysAndValuesDo:[:key :value |
        newDict basicAt:i   put:key.
        newDict basicAt:i+1 put:value.
        i := i+2.
    ].
    ^ newDict

    "
        |d|

        d := Dictionary withKeys:#(a b c d e) andValues:#(1 2 3 4 5).
        MethodDictionary withAll:d.
    "

    "Created: 12.6.1996 / 13:46:43 / stefan"
    "Modified: 12.6.1996 / 13:56:36 / stefan"
    "Modified: 3.7.1996 / 11:05:55 / cg"
!

withKeys:keys andValues:values
    "create a MethodDictionary from a key (selector) array and value (method) array"

    |inst 
     sz "{ Class: SmallInteger }"
     idx "{ Class: SmallInteger }" |

    sz := keys size.
    inst := self new:sz.
    idx := 2.
    1 to:sz do:[:i |
        inst basicAt:(idx-1)  put:(keys   at:i).
        inst basicAt:(idx)    put:(values at:i).
	idx := idx + 2.
    ].
    ^ inst

    "Created: 12.6.1996 / 13:46:43 / stefan"
    "Modified: 3.7.1996 / 11:05:34 / cg"
! !


!MethodDictionary class methodsFor:'queries'!

isBuiltInClass
    "this class is known by the run-time-system"

    ^ self == MethodDictionary

    "Modified: / 08-08-2006 / 16:06:26 / cg"
! !

!MethodDictionary methodsFor:'accessing'!

associationAt:key 
    "return an association consisting of aKey and the element indexed 
     by aKey - 
     report an error, if no element is stored under aKey."

    ^ Association key:key value:(self at:key)
!

at:key ifAbsent:exceptionBlock
    "return the element indexed by aKey - 
     return result of exceptionBlock if no element is stored under aKey"

    |sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    1 to:sz by:2 do:[:i |
        (self basicAt:i) == key ifTrue:[^ self basicAt:(i + 1)]
    ].
    ^ exceptionBlock value
!

at:key put:value 
    "set the value for a given key, which is supposed to be a symbol.
     In contrast to dictionaries, we allow adding elements only, if there is an
     empty slot (nil key) present."

    |slot sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    1 to:sz by:2 do:[:i |
        slot := self basicAt:i.
        (slot == key) ifTrue:[
            ^ self basicAt:(i + 1) put:value
        ].
        slot isNil ifTrue:[
            self basicAt:i put:key.
            ^ self basicAt:(i + 1) put:value
        ].
    ].
    ^ self errorKeyNotFound:key

    "Modified: 7.6.1996 / 09:39:04 / stefan"
    "Modified: 23.1.1997 / 13:59:29 / cg"
!

at:key putOrAppend:value 
    "set the value for a given key, which is supposed to be a symbol.
     In contrast to dictionaries, we allow adding elements only, if there is an
     empty slot (nil key) present.
     Otherwise a new MethodDictionary is created & returned"

    |slot emptySlot newDict sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    1 to:sz by:2 do:[:i |
        slot := self basicAt:i.
        (slot == key) ifTrue:[
            self basicAt:(i + 1) put:value .
            ^ self.
        ].
        slot isNil ifTrue:[
            emptySlot := i.
        ]
    ].

    emptySlot notNil ifTrue:[
        self basicAt:emptySlot       put:key.
        self basicAt:(emptySlot + 1) put:value.
        ^ self.
    ].

    "/ not enough room for new entry, copy to new dictionary
    newDict := self class new:sz//2+1.

"/ cannot do this ...
"/    newDict replaceFrom:1 to:sz with:self startingAt:1.
"/ must use basicAt
    1 to:sz do:[:i |
        newDict basicAt:i put:(self basicAt:i).
    ].

    newDict basicAt:(sz+1) put:key.
    newDict basicAt:(sz+2) put:value.
    ^ newDict.

    "Created: 7.6.1996 / 15:01:54 / stefan"
    "Modified: 7.6.1996 / 17:32:40 / stefan"
    "Modified: 23.1.1997 / 14:00:03 / cg"
!

keyAtValue:value ifAbsent:exceptionBlock
    "return the first key with value - 
     return result of exceptionBlock if no key can be found"

    |sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    2 to:sz by:2 do:[:i |
        (self basicAt:i) == value ifTrue:[^ self basicAt:(i - 1)]
    ].
    ^ exceptionBlock value

    "Created: 7.6.1996 / 14:53:57 / stefan"
! !


!MethodDictionary methodsFor:'enumerating'!

do:aBlock
    "evaluate aBlock for each value (i.e. each method)"

    |key value sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    1 to:sz by:2 do:[:i |
        key := self basicAt:i. 
        key notNil ifTrue:[
            value := self basicAt:(i+1).
            value notNil ifTrue:[
                aBlock value:value.
            ]
        ]
    ].
!

keysAndValuesDo:aBlock
    "evaluate the 2 arg block aBlock for each key (i.e. each selector)
     and each value (i.e. each method)"

    |key value sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    1 to:sz by:2 do:[:i |
        key := self basicAt:i. value := self basicAt:(i+1).
        key notNil ifTrue:[
            value notNil ifTrue:[
                aBlock value:key value:value.
            ]
        ]
    ].

    "Created: / 07-06-1996 / 09:27:42 / stefan"
    "Modified: / 08-08-2006 / 16:11:30 / cg"
! !


!MethodDictionary methodsFor:'private'!

compressed
    "compress - return either the myself or a new, compressed MethodDictionary"

    |newDict tally key mySize
     dstIndex "{ Class: SmallInteger }" 
     sz       "{ Class: SmallInteger }" |

    sz := self basicSize.
    mySize := sz // 2.
    tally := 0.
    1 to:sz by:2 do:[:i |
        (self basicAt:i) notNil ifTrue:[
            tally := tally + 1
        ]
    ].

    tally == mySize ifTrue:[^ self].

    newDict := self species new:tally.
    dstIndex := 1.
    1 to:sz by:2 do:[:i |
        key := self basicAt:i.
        key notNil ifTrue:[
           newDict basicAt:dstIndex   put:key.
           newDict basicAt:dstIndex+1 put:(self basicAt:i+1).
           dstIndex := dstIndex + 2.
        ]
    ].
    ^ newDict

    "Modified: / 05-08-2004 / 20:05:44 / stefan"
! !

!MethodDictionary methodsFor:'queries'!

size
    "return the number of elements (associations) in the receiver"

    ^ self basicSize // 2
!

speciesForCollecting
    ^ Bag

    "Created: / 20-01-2017 / 18:07:53 / stefan"
! !

!MethodDictionary methodsFor:'removing'!

removeKey:key ifAbsent:failBlock
    "remove key from dictionary, 
     return the value previously stored there.
     If it was not in the collection return the result
     from evaluating failBlock.
     We actually do not remove it, but set it to nil."

    |value sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    1 to:sz by:2 do:[:i |
        (self basicAt:i) == key ifTrue:[
           value := self basicAt:(i + 1).
           self basicAt:i put:nil. 
           self basicAt:(i+1) put:nil.
           ^ value
        ]
    ].

    ^ failBlock value.

    "Created: / 07-06-1996 / 15:57:56 / stefan"
    "Modified: / 16-07-2006 / 13:08:41 / cg"
!

removeKeyAndCompress:key
    "remove key from dictionary. 
     A new, compressed MethodDictionary will be returned,
     or nil, if key is not present."

    |newDict dstIndex sz "{ Class: SmallInteger }"|

    sz := self basicSize.
    1 to:sz by:2 do:[:i |
        (self basicAt:i) == key ifTrue:[
            dstIndex := i
        ]
    ].

    dstIndex isNil ifTrue:[^ self].

    sz := self basicSize.
    newDict := self class new:(sz//2-1).
    dstIndex := 1.
    1 to:sz by:2 do:[:i |
        (self basicAt:i) ~~ key ifTrue:[
           newDict basicAt:dstIndex   put:(self basicAt:i).
           newDict basicAt:dstIndex+1 put:(self basicAt:i+1).
           dstIndex := dstIndex + 2.
        ]
    ].
    dstIndex > sz ifTrue:[
        ^ nil
    ].
    ^ newDict

    "Created: 7.6.1996 / 15:57:56 / stefan"
    "Modified: 7.6.1996 / 16:47:02 / stefan"
    "Modified: 12.2.1997 / 19:47:23 / cg"
! !

!MethodDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

