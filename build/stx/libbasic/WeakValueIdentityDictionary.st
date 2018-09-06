"
 COPYRIGHT (c) 1999 by eXept Software AG
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

IdentityDictionary subclass:#WeakValueIdentityDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Weak'
!

!WeakValueIdentityDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    WeakValueIdentityDictionaries behave like IdentityDictionaries, 
    as long as the values are still referenced by some 
    other (non-weak) object.
    However, once the last non-weak reference ceases to exist,
    the Dictionary will return nil for the value at position key.
    (with some delay: it will be removed after the next garbage collect).

    [Warning:]
      If you use this, be very careful since the collections size changes
      'magically' - for example, testing for being nonEmpty and then
      removing the first element may fail, since the element may vanish inbetween.
      In general, never trust the value as returned by the size/isEmpty messages.


    [author:]
        Claus (stolen from Stefans WeakValueDictionary)

    [See also:]
        WeakArray WeakIdentityDictionary WeakIdentitySet WeakValueDictionary
"
! !

!WeakValueIdentityDictionary methodsFor:'adding & removing'!

at:key put:anObject
    "add the argument anObject under key, aKey to the receiver.
     Return anObject (sigh).
     Redefined to block interrupts, to avoid trouble when dependencies
     are added within interrupting high prio processes."

    |ret|

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super at:key put:anObject
    ].

    [
        ret := super at:key put:anObject.
    ] ensure:[
        OperatingSystem unblockInterrupts
    ].
    ^ ret

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Created: 6.5.1996 / 14:47:37 / stefan"
    "Modified: 20.10.1996 / 14:05:04 / cg"
!

removeKey:aKey ifAbsent:aBlock
    "remove the association under aKey from the collection,
     return the value previously stored there.
     If it was not in the collection return the result 
     from evaluating aBlock.

    Redefined to avoid synchronization problems, in case
    of interrupts (otherwise, there could be some other operation 
    on the receiver done by another process, which garbles my contents)."

    |ret|

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super removeKey:aKey ifAbsent:aBlock
    ].

    [
        ret := super removeKey:aKey ifAbsent:aBlock
    ] ensure:[
        OperatingSystem unblockInterrupts
    ].
    ^ ret

    "Modified: 6.5.1996 / 12:44:07 / stefan"
    "Created: 6.5.1996 / 14:47:37 / stefan"
!

removeValue:aKey ifAbsent:aBlock
    "remove the association under aValue from the collection,
     return the key previously stored there.
     If it was not in the collection return the result 
     from evaluating aBlock.

    Redefined to avoid synchronization problems, in case
    of interrupts (otherwise, there could be some other operation 
    on the receiver done by another process, which garbles my contents)."

    |ret|

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super removeValue:aKey ifAbsent:aBlock
    ].

    [
        ret := super removeValue:aKey ifAbsent:aBlock
    ] ensure:[
        OperatingSystem unblockInterrupts
    ].
    ^ ret.

    "Created: 6.5.1996 / 14:47:37 / stefan"
    "Modified: 8.5.1996 / 14:54:09 / stefan"
! !

!WeakValueIdentityDictionary methodsFor:'element disposal'!

update:something with:aParameter from:changedObject
    "an element (either key or value) died - clear out slots for
     disposed keys."

    |wasBlocked|

    something == #ElementExpired ifTrue:[
        "
         have to block here - dispose may be done at a low priority
         from the background finalizer. If new items are added by a 
         higher prio process, the dictionary might get corrupted otherwise
        "
        wasBlocked := OperatingSystem blockInterrupts.

        keyArray 
            forAllDeadIndicesDo:[:idx | 
                                    valueArray basicAt:idx put:nil.
                                    tally := tally - 1.
                                ]
            replacingCorpsesWith:DeletedEntry.

        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ]

    "Created: 7.1.1997 / 16:59:30 / stefan"




! !

!WeakValueIdentityDictionary methodsFor:'private'!

valueContainerOfSize:n
    "return a container for values of size n.
     use WeakArrays here."

    |a|

    a := WeakArray new:n.
    a addDependent:self.
    ^ a

    "Created: 6.5.1996 / 14:47:37 / stefan"
! !

!WeakValueIdentityDictionary methodsFor:'testing'!

includes:anObject
    "redefined to block interrupts 
     (avoid change of the dictionary while accessing)"

    |val|

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super includes:anObject.
    ].

    [
        val := super includes:anObject.
    ] ensure:[
        OperatingSystem unblockInterrupts.
    ].
    ^ val

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Modified: 1.7.1997 / 10:45:52 / cg"
    "Created: 1.7.1997 / 15:41:14 / cg"
!

includesKey:key
    "redefined to block interrupts 
     (avoid change of the dictionary while accessing)"

    |val|

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super includesKey:key.
    ].

    [
        val := super includesKey:key.
    ] ensure:[
        OperatingSystem unblockInterrupts.
    ].
    ^ val

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Modified: 1.7.1997 / 10:45:52 / cg"
    "Created: 1.7.1997 / 15:41:32 / cg"
!

isWeakCollection
    "return true, if the receiver has weak references to its elements."

    ^ true
! !

!WeakValueIdentityDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !



