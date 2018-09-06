"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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

IdentityDictionary subclass:#WeakIdentityDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Weak'
!

!WeakIdentityDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    WeakIdentityDictionaries behave like IdentityDictionaries,
    as long as the keys are still referenced by some
    other (non-weak) object.
    However, once the last non-weak reference ceases to exist,
    the object will be automatically removed from the Weakcollection
    (with some delay: it will be removed after the next garbage collect).

    This class was added to support keeping track of dependents without
    keeping the values alive - values simply become nil when no one else
    references it. The original dependency mechanism used a regular Dictionary,
    which usually leads to a lot of garbage being kept due to a forgotten
    release. Using a WeakDictionary may be incompatible to ST-80 but is much
    more comfortable, since no manual release of dependents is needed.

    [Warning:]
      If you use this, be very careful since the collections size changes
      'magically' - for example, testing for being nonEmpty and then
      removing the first element may fail, since the element may vanish inbetween.
      In general, never trust the value as returned by the size/isEmpty messages.


    [author:]
	Claus Gittinger

    [See also:]
	WeakArray WeakValueDictionary WeakIdentitySet
"
! !

!WeakIdentityDictionary methodsFor:'accessing'!

keys
    "return a collection containing all valid keys of the receiver"

    |keySet|

    keySet := self emptyCollectionForKeys.
    keyArray validElementsDo:[:key |
        (key notNil and:[key ~~ DeletedEntry]) ifTrue:[
            key == NilEntry ifTrue:[
                keySet add:nil.
            ] ifFalse:[
                keySet add:key.
            ]
        ]
    ].
    ^ keySet
! !

!WeakIdentityDictionary methodsFor:'adding & removing'!

at:key ifAbsent:exceptionBlock
    "redefined to block interrupts
     (avoid change of the dictionary while accessing)"

    |val|

    key class == SmallInteger ifTrue:[  
        "SmallIntegers cannot be stored into a WeakArray"
        ^ exceptionBlock value.
    ].

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super at:key ifAbsent:exceptionBlock.
    ].

    [
        val := super at:key ifAbsent:exceptionBlock.
    ] ensure:[
        OperatingSystem unblockInterrupts.
    ].
    ^ val

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Modified: 1.7.1997 / 10:45:47 / cg"
!

at:key ifAbsentPut:replacementBlock
    "redefined to block interrupts
     (avoid change of the dictionary while accessing)"

    |val|

    key class == SmallInteger ifTrue:[  
        "SmallIntegers cannot be stored into a WeakArray"
        self error:'WeakidentityDictionary: cannot store a SmallInteger'.
    ].

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super at:key ifAbsentPut:replacementBlock.
    ].

    [
        val := super at:key ifAbsentPut:replacementBlock.
    ] ensure:[
        OperatingSystem unblockInterrupts.
    ].
    ^ val
!

at:key put:anObject
    "add the argument anObject under key, aKey to the receiver.
     Return anObject (sigh).
     Redefined to block interrupts, to avoid trouble when dependencies
     are added within interrupting high prio processes."

    |val|

    key class == SmallInteger ifTrue:[  
        "SmallIntegers cannot be stored into a WeakArray"
        self error:'WeakidentityDictionary: cannot store a SmallInteger'.
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

removeKey:aKey ifAbsent:aBlock
    "remove the association under aKey from the collection,
     return the value previously stored there.
     If it was not in the collection return the result
     from evaluating aBlock.

    Redefined to avoid synchronization problems, in case
    of interrupts (otherwise, there could be some other operation
    on the receiver done by another process, which garbles my contents)."

    |ret|

    aKey class == SmallInteger ifTrue:[  
        "SmallIntegers cannot be stored into a WeakArray"
        ^ aBlock value.
    ].

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super removeKey:aKey ifAbsent:aBlock.
    ].

    [
        ret := super removeKey:aKey ifAbsent:aBlock
    ] ensure:[
        OperatingSystem unblockInterrupts
    ].
    ^ ret

    "Modified: 6.5.1996 / 12:44:51 / stefan"
    "Modified: 29.1.1997 / 15:09:11 / cg"
!

safeRemoveKey:key
    "redefined to block interrupts
     (avoid change of the dictionary while accessing)"

    |val|

    key class == SmallInteger ifTrue:[  
        "SmallIntegers cannot be stored into a WeakArray"
        ^ nil.
    ].

    (OperatingSystem blockInterrupts) ifTrue:[
        "/ already blocked
        ^ super safeRemoveKey:key.
    ].

    [
        val := super safeRemoveKey:key.
    ] ensure:[
        OperatingSystem unblockInterrupts.
    ].
    ^ val

    "Modified: 6.5.1996 / 12:22:26 / stefan"
    "Modified: 1.7.1997 / 10:45:52 / cg"
    "Created: 1.7.1997 / 10:46:34 / cg"
! !

!WeakIdentityDictionary methodsFor:'element disposal'!

clearDeadSlots
    |wasBlocked anyChange|

    "
     have to block here - dispose may be done at a low priority
     from the background finalizer. If new items are added by a
     higher prio process, the dictionary might get corrupted otherwise
    "
    wasBlocked := OperatingSystem blockInterrupts.
    anyChange := false.
    [
        keyArray
            forAllDeadIndicesDo:[:idx |
                                    valueArray basicAt:idx put:nil.
                                    tally := tally - 1.
                                    anyChange := true.
                                ]
            replacingCorpsesWith:DeletedEntry.
    ] ensure:[
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    anyChange ifTrue:[
        self changed:#ElementExpired
    ].    

    "Modified: / 13.12.2001 / 14:18:17 / martin"
!

update:something with:aParameter from:changedObject
    "an element (either key or value) died - clear out slots for
     disposed keys."

    something == #ElementExpired ifTrue:[
	self clearDeadSlots.
    ]

    "Created: / 7.1.1997 / 16:59:30 / stefan"
    "Modified: / 13.12.2001 / 14:17:58 / martin"
! !

!WeakIdentityDictionary methodsFor:'enumerating'!

keysDo:aBlock
    "evaluate aBlock for each registered object"

    "#Dictionary>>keysDo: would not work, since the keyArray instvar may change if
     elements are unregistered while looping."

    ^ keyArray validElementsDo:[:each|
        each ~~ DeletedEntry ifTrue:[
            each == NilEntry ifTrue:[
                aBlock value:nil.
            ] ifFalse:[
                aBlock value:each.
            ]
        ].
    ]
! !

!WeakIdentityDictionary methodsFor:'private'!

findKeyOrNil:key
    "Look for the key in the receiver.
     If it is found, return the index,
     otherwise the index of the first unused slot.
     Grow the receiver, if key was not found, and no unused slots were present.

     Warning: an empty slot MUST be filled by the sender - it is only to be sent
              by at:put: / add: - like methods."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe
     delIndex "{ Class:SmallInteger }"|

    (OperatingSystem blockInterrupts) ifFalse:[
        "/
        "/ may never be entered with interrupts enabled
        "/
        OperatingSystem unblockInterrupts.
        self error:'unblocked call of findKeyOrNil'.
    ].

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

        probe class == SmallInteger ifTrue:[
            probe := DeletedEntry.
            keyArray basicAt:index put:probe.
            valueArray basicAt:index put:nil.
            tally := tally - 1.
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

    "Modified: 30.1.1997 / 15:04:34 / cg"
    "Modified: 1.10.1997 / 11:25:32 / stefan"
!

findKeyOrNilOrDeletedEntry:key
    "Look for the key in the receiver.
     If it is found, return the index,
     otherwise the index of the first unused slot.
     Grow the receiver, if key was not found, and no unused slots were present."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe
     delIndex "{ Class:SmallInteger }"|

    (OperatingSystem blockInterrupts) ifFalse:[
        "/
        "/ may never be entered with interrupts enabled
        "/
        OperatingSystem unblockInterrupts.
        self error:'unblocked call of findKeyOrNil'.
    ].

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

        probe class == SmallInteger ifTrue:[
            probe := DeletedEntry.
            keyArray basicAt:index put:probe.
            valueArray basicAt:index put:nil.
            tally := tally - 1.
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

    "Modified: 30.1.1997 / 15:04:34 / cg"
    "Modified: 1.10.1997 / 11:25:32 / stefan"
!

grow:newSize
    "Grow the receiver to make space for at least newSize elements.
     To do this, we have to rehash into the new arrays. (which is done 
     by re-adding all elements to a new, empty key/value array pair).

     Redefined here to avoid higher-prio process to modify the receiver while
     grwoing and to handle corpses. 
     "


    | key deletedEntry oldKeyArray oldValueArray n
      oldSize  "{ Class:SmallInteger }"
      newIndex "{ Class:SmallInteger }" 
      wasBlocked 
      anyDead |

    oldKeyArray := keyArray.
    oldValueArray := valueArray.

    n := self class goodSizeFrom:newSize.
    oldSize := oldKeyArray size.
    n == oldSize ifTrue:[^ self].

    keyArray := self keyContainerOfSize:n.
    valueArray := self valueContainerOfSize:n.


    deletedEntry := DeletedEntry.
    anyDead := false.
    wasBlocked := OperatingSystem blockInterrupts.
    1 to:oldSize do:[:index |
        key := oldKeyArray basicAt:index.
        (key notNil and:[key ~~ deletedEntry]) ifTrue:[
            key class == SmallInteger ifTrue:[ 
                "/ Oops, we found a corpse, make a note
                "/ and continue.
                anyDead := true.
            ] ifFalse:[
                newIndex := self findNil:key.
                keyArray basicAt:newIndex put:key.
                valueArray basicAt:newIndex put:(oldValueArray basicAt:index).
            ].
        ]
    ].
    wasBlocked ifFalse:[ OperatingSystem unblockInterrupts ].
    anyDead ifTrue:[ 
        self changed:#ElementExpired      
    ].

    "Created: / 28-01-1997 / 23:41:39 / cg"
    "Modified: / 29-01-1997 / 15:10:12 / cg"
    "Modified: / 31-07-2017 / 09:16:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeForCapacity:minSize
    "reset the receiver's contents.
     Redefined to block interrupts, to avoid trouble when dependencies
     are added within interrupting high prio processes."

"/ 'setTally:' printCR.

    (OperatingSystem blockInterrupts) ifTrue:[
	"/ already blocked
	super initializeForCapacity:minSize.
	^ self.
    ].

    [
	super initializeForCapacity:minSize
    ] ensure:[
	OperatingSystem unblockInterrupts
    ].

    "Created: 29.1.1997 / 11:40:12 / cg"
    "Modified: 29.1.1997 / 15:11:11 / cg"
!

keyContainerOfSize:n
    "return a container for keys of size n.
     use WeakArrays here."

    |w|

    w := WeakArray new:n.
    w addDependent:self.
    ^ w

    "Modified: 7.1.1997 / 17:01:15 / stefan"
    "Modified: 29.1.1997 / 14:18:49 / cg"
!

rehash
    "grow the receiver.
     Redefined to block interrupts, to avoid trouble when dependencies
     are added within interrupting high prio processes."

"/ 'rehash' printCR.

    (OperatingSystem blockInterrupts) ifTrue:[
	"/ already blocked
	super rehash.
	^ self.
    ].

    [
	super rehash
    ] ensure:[
	OperatingSystem unblockInterrupts
    ].

    "Created: 29.1.1997 / 11:39:42 / cg"
    "Modified: 29.1.1997 / 14:18:52 / cg"
! !

!WeakIdentityDictionary methodsFor:'testing'!

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
    "Created: 1.7.1997 / 10:47:13 / cg"
!

includesKey:key
    "redefined to block interrupts
     (avoid change of the dictionary while accessing)"

    |val|

    key class == SmallInteger ifTrue:[  
        "SmallIntegers cannot be stored into a WeakArray"
        ^ false.
    ].

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
    "Created: 1.7.1997 / 10:45:14 / cg"
    "Modified: 1.7.1997 / 10:45:52 / cg"
!

isWeakCollection
    "return true, if the receiver has weak references to its elements."

    ^ true
! !

!WeakIdentityDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

