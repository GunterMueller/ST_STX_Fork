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

Dictionary subclass:#WeakValueDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Weak'
!

!WeakValueDictionary class methodsFor:'documentation'!

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
    WeakValueDictionaries behave like Dictionaries,
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
	Stefan Vogel

    [See also:]
	WeakArray WeakIdentityDictionary WeakIdentitySet
"
! !

!WeakValueDictionary methodsFor:'adding & removing'!

at:key ifAbsent:somethingRespondingToValue
    "Redefined to handle collected values (which are set to a SmallInteger)
     snd to block interrupts, to avoid trouble when dependencies
     are added within interrupting high prio processes."

    |ret|

    OperatingSystem blockInterrupts ifTrue:[
        "/ already blocked
        ret := super at:key ifAbsent:0.
    ] ifFalse:[
        "do not use somethingRespondingToValue here, it might be a block answering
         an integer and be therefore called twice"
        [
            ret := super at:key ifAbsent:0.
        ] ensure:[
            OperatingSystem unblockInterrupts.
        ].
    ].

    (ret isNil or:[ret class == SmallInteger]) ifTrue:[
        ret := somethingRespondingToValue value
    ].
    ^ ret
!

at:key ifAbsentPut:replacementBlock
    "return the element indexed by aKey if present,
     if not present, store the result of evaluating valueBlock
     under aKey and return it.

     Redefined to block interrupts, to avoid trouble when dependencies
     are added within interrupting high prio processes.
     WARNING: do not add elements while iterating over the receiver.
              Iterate over a copy to do this."

    |val|

    OperatingSystem blockInterrupts ifTrue:[
        "/ already blocked
        val := super at:key ifAbsentPut:replacementBlock.
    ] ifFalse:[
        [
            val := super at:key ifAbsentPut:replacementBlock.
        ] ensure:[
            OperatingSystem unblockInterrupts.
        ].
    ].

    (val isNil or:[val class == SmallInteger]) ifTrue:[
        self error:'WeakValueDictionary: invalid value'.
    ].

    ^ val
!

at:key put:anObject
    "add the argument anObject under key, aKey to the receiver.
     Return anObject (sigh).
     Redefined to block interrupts, to avoid trouble when dependencies
     are added within interrupting high prio processes."

    |val|

    (anObject isNil or:[anObject class == SmallInteger]) ifTrue:[
        self error:'WeakValueDictionary: invalid value'.
    ].

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super at:key put:anObject.
    ].

    [
        val := super at:key put:anObject.
    ] ensure:[
        OperatingSystem unblockInterrupts.
    ].
    ^ val

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Modified: 29.1.1997 / 15:08:45 / cg"
!

removeIdentityValue:aValue ifAbsent:aBlock 
    "remove the association under aValue from the collection,
     return the key previously stored there.
     If it was not in the collection return the result
     from evaluating aBlock.

     Redefined to avoid synchronization problems, in case
     of interrupts (otherwise, there could be some other operation
     on the receiver done by another process, which garbles my contents)."
    
    |ret|

    (aValue isNil or:[ aValue class == SmallInteger ]) ifTrue:[
        ^ aBlock value.
    ].
    OperatingSystem blockInterrupts ifTrue:[
        "/ already blocked
        ret := super removeIdentityValue:aValue ifAbsent:aBlock
    ] ifFalse:[
        [
            ret := super removeIdentityValue:aValue ifAbsent:aBlock
        ] ensure:[ OperatingSystem unblockInterrupts. ].
    ].
    ^ ret.

    "Created: 6.5.1996 / 14:47:37 / stefan"
    "Modified: 8.5.1996 / 14:54:09 / stefan"
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

    OperatingSystem blockInterrupts ifTrue:[
        "/ already blocked
        ret := super removeKey:aKey ifAbsent:aBlock
    ] ifFalse:[
        [
            ret := super removeKey:aKey ifAbsent:aBlock
        ] ensure:[
            OperatingSystem unblockInterrupts.
        ].
    ].

    (ret isNil or:[ret class == SmallInteger]) ifTrue:[
        ^ aBlock value.
    ].

    ^ ret

    "Modified: 6.5.1996 / 12:44:07 / stefan"
    "Created: 6.5.1996 / 14:47:37 / stefan"
!

removeValue:aValue ifAbsent:aBlock
    "remove the association under aValue from the collection,
     return the key previously stored there.
     If it was not in the collection return the result
     from evaluating aBlock.

    Redefined to avoid synchronization problems, in case
    of interrupts (otherwise, there could be some other operation
    on the receiver done by another process, which garbles my contents)."

    |ret|

    (aValue isNil or:[aValue class == SmallInteger]) ifTrue:[
        ^ aBlock value.
    ].

    OperatingSystem blockInterrupts ifTrue:[
        "/ already blocked
        ret := super removeValue:aValue ifAbsent:aBlock
    ] ifFalse:[
        [
            ret := super removeValue:aValue ifAbsent:aBlock
        ] ensure:[
            OperatingSystem unblockInterrupts.
        ].
    ].

    ^ ret.

    "Created: 6.5.1996 / 14:47:37 / stefan"
    "Modified: 8.5.1996 / 14:54:09 / stefan"
! !

!WeakValueDictionary methodsFor:'element disposal'!

update:something with:aParameter from:changedObject
    "an element (either key or value) died - clear out slots for
     disposed keys."

    |wasBlocked|

    something == #ElementExpired ifTrue:[
	self clearDeadSlots.
    ]

    "Created: 7.1.1997 / 16:59:30 / stefan"
! !

!WeakValueDictionary methodsFor:'enumerating'!

do:aBlock
    super do:[:eachValue|
        "garbage collected values will change to nil or a SmallInteger"
        (eachValue notNil and:[eachValue class ~~ SmallInteger]) ifTrue:[
            aBlock value:eachValue.
        ].
    ].
!

keysAndValuesDo:aBlock
    super keysAndValuesDo:[:eachKey :eachValue|
        "garbage collected values will change to a SmallInteger"
        eachValue class ~~ SmallInteger ifTrue:[
            aBlock value:eachKey value:eachValue.
        ].
    ].
! !

!WeakValueDictionary methodsFor:'private'!

clearDeadSlots
    |wasBlocked|

    "
     have to block here - dispose may be done at a low priority
     from the background finalizer. If new items are added by a
     higher prio process, the dictionary might get corrupted otherwise
    "
    wasBlocked := OperatingSystem blockInterrupts.

    valueArray
	forAllDeadIndicesDo:[:idx | keyArray at:idx put:DeletedEntry.
				    tally := tally - 1.
			    ]
	replacingCorpsesWith:nil.

    wasBlocked ifFalse:[
	OperatingSystem unblockInterrupts.
    ].

    "Modified: / 13.12.2001 / 14:18:56 / martin"
!

possiblyShrink
    "check if the receiver has become too empty (after a remove)
     and shrink if it makes sense.
     Definition of 'too empty' is: 'filled less than 12.5% (i.e. 1/8th)'"

    keyArray basicSize > 56 ifTrue:[
        self clearDeadSlots.
        super possiblyShrink.
    ].
!

valueContainerOfSize:n
    "return a container for values of size n.
     use WeakArrays here."

    |a|

    a := WeakArray new:n.
    a addDependent:self.
    ^ a

    "Created: 6.5.1996 / 14:47:37 / stefan"
! !

!WeakValueDictionary methodsFor:'testing'!

includes:anObject
    "redefined to block interrupts
     (avoid change of the dictionary while accessing)"

    |ret wasBlocked|

    (anObject isNil or:[anObject class == SmallInteger]) ifTrue:[
        "Integers cannot be stored into a WeakValueDictionary"
        ^ false.
    ].

    wasBlocked := OperatingSystem blockInterrupts.
    ret := super includes:anObject.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
     ^ ret

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Modified: 1.7.1997 / 10:45:52 / cg"
    "Created: 1.7.1997 / 15:41:14 / cg"
!

includesIdentical:anObject
    "redefined to block interrupts
     (avoid change of the dictionary while accessing)"

    |ret wasBlocked|

    (anObject isNil or:[anObject class == SmallInteger]) ifTrue:[
        "Integers cannot be stored into a WeakValueDictionary"
        ^ false.
    ].

    wasBlocked := OperatingSystem blockInterrupts.
    ret := super includesIdentical:anObject.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
     ^ ret
!

includesKey:key
    "redefined to check for already collected values"

    ^ (self at:key ifAbsent:DeletedEntry) ~~ DeletedEntry.

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Modified: 1.7.1997 / 10:45:52 / cg"
    "Created: 1.7.1997 / 15:41:32 / cg"
!

isWeakCollection
    "return true, if the receiver has weak references to its elements."

    ^ true
! !

!WeakValueDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

