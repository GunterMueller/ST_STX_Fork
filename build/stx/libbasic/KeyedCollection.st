"
 COPYRIGHT (c) 1998 by eXept Software AG
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

Collection subclass:#KeyedCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Abstract'
!

!KeyedCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    Abstract superclass for collections which have a key->value mapping.
    This abstract class provides functionality common to those collections,
    without knowing how the concrete class implements things. 
    Thus, all methods found here depend on some basic mechanisms 
    to be defined in the concrete class. 
    These basic methods are usually defined as #subclassResponsibility here.
    Some methods are also redefined for better performance.

    Subclasses should at least implement:
        at:ifAbsent:        - accessing elements
        removeKey:ifAbsent  - removing
        keysAndValuesDo:    - enumerating

    [author:]
        Claus Gittinger
"
! !

!KeyedCollection class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for KeyedCollection here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == KeyedCollection
! !

!KeyedCollection methodsFor:'accessing'!

at:key
    "return the value stored under akey.
     Raise an error if not found"

    ^ self at:key ifAbsent:[self errorKeyNotFound:key].

    "Modified: / 19.6.1998 / 00:48:27 / cg"
!

at:key ifAbsent:exceptionBlock
    "return the value stored under akey.
     Return the value from evaluating exceptionBlock if not found"

    ^ self subclassResponsibility

    "Created: / 19.6.1998 / 00:48:23 / cg"
!

keyAtValue:value
    "return the key under which value is stored.
     Raise an error if not found"

    ^ self keyAtValue:value ifAbsent:[self errorValueNotFound:value].

    "Modified: / 19.6.1998 / 00:48:27 / cg"
    "Created: / 19.6.1998 / 00:49:16 / cg"
!

keyAtValue:value ifAbsent:exceptionBlock
    "return the key under which value is stored.
     If not found, return the value from evaluating exceptionBlock"

    self keysAndValuesDo:[:elKey :elValue |
        value == elValue ifTrue:[^ elKey]
    ].
    ^ exceptionBlock value

    "Modified: / 19.6.1998 / 00:48:27 / cg"
    "Created: / 19.6.1998 / 00:50:34 / cg"
!

keys
    "return a collection containing the keys of the receiver"

    |keyCollection|

    keyCollection := OrderedCollection new.
    self keysDo:[:aKey |
        keyCollection add:aKey
    ].
    ^ keyCollection

    "Modified: / 19.6.1998 / 00:48:27 / cg"
    "Created: / 19.6.1998 / 00:51:49 / cg"
! !

!KeyedCollection methodsFor:'enumerating'!

do:aBlock
    "evaluate aBlock for each value"

    self keysAndValuesDo:[:elKey :elValue | aBlock value:elValue]

    "Created: / 19.6.1998 / 00:56:24 / cg"
!

findFirstKey:aBlock
    "find and return the first key, for which evaluation of the argument, aBlock
     returns true; return nil if none is detected."

    self keysDo:[:key |
        (aBlock value:key) ifTrue:[^ key].
    ].
    ^ nil

    "Created: 8.10.1996 / 22:01:31 / cg"
    "Modified: 8.10.1996 / 22:02:03 / cg"
!

keysAndValuesDo:aBlock
    "evaluate aBlock for each key and value"

    ^ self subclassResponsibility

    "Created: / 19.6.1998 / 00:56:52 / cg"
! !

!KeyedCollection methodsFor:'removing'!

removeKey:aKey
    "remove key (and the value stored under that key) from the
     receiver; raise an error if no such element is contained"

    ^ self removeKey:aKey ifAbsent:[self errorKeyNotFound:aKey]

    "Created: / 19.6.1998 / 00:53:25 / cg"
    "Modified: / 19.6.1998 / 00:54:02 / cg"
!

removeKey:aKey ifAbsent:exceptionBlock
    "remove key (and the value stored under that key) from the
     receiver; return the value which was stored previously there.
     If no such element is contained, return the value
     from evaluating exceptionBlock"

    ^ self subclassResponsibility

    "Created: / 19.6.1998 / 00:53:58 / cg"
! !

!KeyedCollection methodsFor:'testing'!

includesIdenticalKey:aKey
    "return true, if the argument, aKey is a key in the receiver"

    self keysDo:[:elKey | aKey == elKey ifTrue:[^ true]].
    ^ false

    "Created: / 19.6.1998 / 00:55:05 / cg"
!

includesKey:aKey
    "return true, if the argument, aKey is a key in the receiver"

    self keysDo:[:elKey | aKey = elKey ifTrue:[^ true]].
    ^ false

    "Created: / 19.6.1998 / 00:55:05 / cg"
! !

!KeyedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

