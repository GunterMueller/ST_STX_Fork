"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

IdentitySet subclass:#WeakIdentitySet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Weak'
!

!WeakIdentitySet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    WeakIdentitySets behave like IdentitySets, as long as the contained
    objects are still referenced by some other (non-weak) object.
    However, once the last non-weak reference ceases to exist,
    the object will be automatically removed from the Weakcollection
    (with some delay: it will be removed after the next garbage collect).

    This class was added to support dependencies which do not
    prevent objects from dying. (i.e. which do not fill up your memory
    if you forget to #release it).

    [Warning:]
	If you use this, be very careful since the collections size changes
	'magically' - for example, testing for being nonEmpty and then
	removing the first element may fail, since the element may vanish inbetween.
	In general, never trust the value as returned by the size/isEmpty messages.
	WeakIdentitySet is not meant as a 'public' class.

    [author:]
	Claus Gittinger

    [See also:]
	WeakArray WeakIdentityDictionary
"
! !

!WeakIdentitySet class methodsFor:'instance creation'!

new
    "return a new empty WeakIdentitySet"

    ^ self new:1

    "Modified: 23.4.1996 / 13:56:08 / cg"
! !

!WeakIdentitySet class methodsFor:'queries'!

goodSizeFrom:arg
    "return a good array size for the given argument.
     Since WeakIdentitySets are mostly used for dependency management, we typically
     have only a small number of elements in the set.
     Therefore use exact size for small sets
     (instead of rounding up to the next prime 11)."

    arg <= 10 ifTrue:[
	arg < 1 ifTrue:[^ 1].
	^ arg.
    ].
    ^ super goodSizeFrom:arg
! !

!WeakIdentitySet methodsFor:'accessing'!

firstIfEmpty:exceptionValue
    "return the first element of the collection or the
     value of the exceptionBlock, if empty.
     Redefine, since the inherited method does not work if
     elements change silently to nil"

    |index "{ Class: SmallInteger }"
     element|

    index := 1.
    "/ allow for the size to change during enumeration
    [index <= keyArray size] whileTrue:[
	element := keyArray basicAt:index.
	element notNil ifTrue:[
	    element class ~~ SmallInteger ifTrue:[
		element ~~ DeletedEntry ifTrue:[
		    element == NilEntry ifTrue:[
			element := nil.
		    ].
		    ^ element
		]
	    ]
	].
	index := index + 1
    ].

    ^ exceptionValue value.
! !

!WeakIdentitySet methodsFor:'adding & removing'!

add:newElement
    "add the argument, newElement to the receiver.
     Returns the argument, newElement (sigh).

     Redefined to avoid synchronization problems, in case of interrupts
     (otherwise, there could be some other operation on the receiver
       done by another process, which garbles my contents)"

    |ret|

    (OperatingSystem blockInterrupts) ifTrue:[
	"/ already blocked
	^ super add:newElement.
    ].

    [
	ret := super add:newElement.
    ] ensure:[
	OperatingSystem unblockInterrupts
    ].
    ^ ret

    "Modified: 29.1.1997 / 15:06:57 / cg"
!

remove:anObject ifAbsent:exceptionBlock
    "redefined to avoid synchronization problems, in case of interrupts
     (otherwise, there could be some other operation on the receiver
       done by another process, which garbles my contents)"

    |ret|

    (OperatingSystem blockInterrupts) ifTrue:[
	"/ already blocked
	^ super remove:anObject ifAbsent:exceptionBlock.
    ].

    [
	ret := super remove:anObject ifAbsent:exceptionBlock
    ] ensure:[
	OperatingSystem unblockInterrupts
    ].
    ^ ret

    "Modified: 29.1.1997 / 15:07:19 / cg"
! !

!WeakIdentitySet methodsFor:'element disposal'!

update:something with:aParameter from:changedObject
    "an element died - must rehash"

    |wasBlocked|

    something == #ElementExpired ifTrue:[
	"
	 must block interrupts here - finalization
	 may be done at low prio in the background
	 finalizer, we do not want to be interrupted
	 while rehashing
	"
	wasBlocked := OperatingSystem blockInterrupts.
	keyArray forAllDeadIndicesDo:[:idx | tally := tally - 1] replacingCorpsesWith:DeletedEntry.
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].

    "Created: 7.1.1997 / 17:00:33 / stefan"
! !

!WeakIdentitySet methodsFor:'enumerating'!

do:aBlock
    "perform the block for all members in the collection.
     This method has been rewritten to be more robust about
     changed contents while enumerating elements (which might
     happen during change&update processing, if dependents
     are added or removed within the update)."

    |index "{ Class: SmallInteger }"
     element|

    index := 1.
    "/ allow for the size to change during enumeration
    [index <= keyArray size] whileTrue:[
	element := keyArray basicAt:index.
	element notNil ifTrue:[
	    element class ~~ SmallInteger ifTrue:[
		element ~~ DeletedEntry ifTrue:[
		    aBlock value:element
		]
	    ]
	].
	index := index + 1
    ]
! !

!WeakIdentitySet methodsFor:'private'!

findKeyOrNil:key
    "Look for the key in the receiver.
     If it is found, return return the index, otherwise
     the index of the first unused slot.
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
            tally := tally - 1.
        ].
        delIndex == 0 ifTrue:[
            probe == DeletedEntry ifTrue:[
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

    "Modified: 30.1.1997 / 15:04:38 / cg"
!

findKeyOrNilOrDeletedEntry:key
    "Look for the key in the receiver.
     If it is found, return return the index, otherwise
     the index of the first unused slot.
     Grow the receiver, if key was not found, and no unused slots were present"

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
            tally := tally - 1.
        ].
        delIndex == 0 ifTrue:[
            probe == DeletedEntry ifTrue:[
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

    "Modified: 30.1.1997 / 15:04:38 / cg"
!

isWeakCollection
    "return true, if the receiver has weak references to its elements."

    ^ true
!

keyContainerOfSize:n
    "return a container for keys and values of size n.
     use WeakArrays here."

    |w|

    w := WeakArray new:n.
    w addDependent:self.
    ^ w

    "Modified: 7.1.1997 / 17:01:28 / stefan"
! !

!WeakIdentitySet class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

