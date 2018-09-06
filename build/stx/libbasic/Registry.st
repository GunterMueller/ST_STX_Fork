"
 COPYRIGHT (c) 1993,2015 by Claus Gittinger
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

WeakIdentityDictionary subclass:#Registry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Weak'
!

!Registry class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993,2015 by Claus Gittinger
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
    Registries provide an easy interface to using WeakArrays.
    A class, which wants to be informed of instance-death, can put a created object
    into a registry. The registry will create an executor, which is a (shallow-)copy
    of the object, and watch out for death of the original object. When it dies,
    the executor will be sent a #finalize message.
    The trick with the shallow copy is especially nice, you can think of it as
    being the original object which died.

    All objects, which keep external resources (such as fileDescriptors, fonts,
    colormap-entries etc.) should be registered, so that the underlying resource
    can be freed when the object goes away.

    Of course, you too can use it to do whatever you need to do in case of the
    death of an object.

    Registries use #executor to acquire the copy of the original,
    this can be redefined in individual classes for faster copying
    (typically, not all internal state, but only some device handles are needed for
    finalization). If the to-be-registered object is large, this method may also
    return a stub (placeHolder) object. (i.e. there is no need for the copy to be
    of the same class as the original, as long as it implements #finalize and frees
    the relevant OS resources. Some classes return a specialized private-class instance,
    which only holds on the handle and implements #finalize.)
    Example uses are found in Form, Color, ExternalStream and Font

    [author:]
        Claus Gittinger

    [see also:]
        WeakArray WeakIdentityDictionary
        Font Form Color Cursor ExternalStream

"
! !

!Registry methodsFor:'accessing'!

contents
    "return the collection of registered objects"

    ^ self keys.
! !

!Registry methodsFor:'element disposal'!

clearDeadSlots
    |wasBlocked executors|

    "
     have to block here - dispose may be done at a low priority
     from the background finalizer. If new items are added by a
     higher prio process, the dictionary might get corrupted otherwise
    "
    wasBlocked := OperatingSystem blockInterrupts.
    [
        keyArray
            forAllDeadIndicesDo:[:idx |
                                    executors isNil ifTrue:[
                                        executors := OrderedCollection new.
                                    ].
                                    executors add:(valueArray basicAt:idx).
                                    valueArray basicAt:idx put:nil.
                                    tally := tally - 1.
                                ]
            replacingCorpsesWith:DeletedEntry.
    ] ensure:[
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
        executors notNil ifTrue:[
            executors do:[:eachExecutor|
                [
                    self informDispose:eachExecutor.
                ] on:Error do:[:ex|
                    Logger error:'Error %1 during finalization of: %2' with:ex description with:eachExecutor.
                    ex suspendedContext fullPrintAllLevels:10.
                ].
            ].
        ].
    ].
!

informDispose:someHandle
    "send a dispose message - this is sent to the executor,
     since the original is already gone"

    someHandle finalize
!

update:something with:aParameter from:changedObject
    "an instance has been destroyed - look which one it was"

    something == #ElementExpired ifTrue:[
        self clearDeadSlots. 
        ^ self.
    ].
    something == #earlyRestart ifTrue:[
        self removeAll.
    ].
    super update:something with:aParameter from:changedObject.

    "Created: 15.6.1996 / 15:24:41 / cg"
    "Modified: 8.1.1997 / 14:05:02 / stefan"
    "Modified: 2.6.1997 / 18:15:23 / cg"
! !

!Registry methodsFor:'enumerating'!

detect:aBlock ifNone:exceptionValue
    "detect a key, for which aBlock answers true"

    keyArray validElementsDo:[:eachElement |
        eachElement ~~ DeletedEntry ifTrue:[
            |realObject|

            realObject := eachElement.
            eachElement == NilEntry ifTrue:[realObject := nil].
            (aBlock value:realObject) ifTrue:[^ realObject].
        ].
    ].
    ^ exceptionValue value
!

do:aBlock
    "evaluate aBlock for each registered object"

    ^ self keysDo:aBlock.
! !

!Registry methodsFor:'private'!

findKeyOrNil:key
    "Look for the key in the receiver.
     If it is found, return the index,
     otherwise the index of the first unused slot.
     Grow the receiver, if key was not found, and no unused slots were present.

     Warning: an empty slot MUST be filled by the sender - it is only to be sent
              by at:put: / add: - like methods.

     Redefined to not nil values of expired keys here."

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
     Grow the receiver, if key was not found, and no unused slots were present. 

     Redefined to not nil values of expired keys here."

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

     Redefined here again to avoid higher-prio process to modify the 
     receiver while grwoing and to handle corpses. 
     "


    | key deletedEntry oldKeyArray oldValueArray n
      oldSize  "{ Class:SmallInteger }"
      newIndex "{ Class:SmallInteger }" 
      wasBlocked 
      executors |

    oldKeyArray := keyArray.
    oldValueArray := valueArray.

    n := self class goodSizeFrom:newSize.
    oldSize := oldKeyArray size.
    n == oldSize ifTrue:[^ self].

    keyArray := self keyContainerOfSize:n.
    valueArray := self valueContainerOfSize:n.


    deletedEntry := DeletedEntry.
    wasBlocked := OperatingSystem blockInterrupts.
    1 to:oldSize do:[:index |
        key := oldKeyArray basicAt:index.
        (key notNil and:[key ~~ deletedEntry]) ifTrue:[
            key class == SmallInteger ifTrue:[ 
                "/ Oops, we found a corpse, register it
                "/ and continue.
                tally := tally - 1.
                executors isNil ifTrue:[
                    executors := OrderedCollection new.
                ].
                executors add:(oldValueArray basicAt:index).        
            ] ifFalse:[
                newIndex := self findNil:key.
                keyArray basicAt:newIndex put:key.
                valueArray basicAt:newIndex put:(oldValueArray basicAt:index).
            ].
        ]
    ].
    wasBlocked ifFalse:[ OperatingSystem unblockInterrupts ].
    executors notNil ifTrue:[ 
        executors do:[:eachExecutor|
            [
                self informDispose:eachExecutor.
            ] on:Error do:[:ex|
                Logger error:'Error %1 during finalization of: %2' with:ex description with:eachExecutor.
                ex suspendedContext fullPrintAllLevels:10.
            ].
        ]. 
    ].

    "Created: / 31-07-2017 / 09:19:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Registry methodsFor:'registering objects'!

register:anObject
    "register anObject, so that a copy of it gets the disposed message
     when anObject dies (some time in the future)"

    |executor|

    executor := anObject executor.
    executor notNil ifTrue:[
        self register:anObject as:executor.
    ].
!

register:anObject as:aHandle
    "register anObject, so that I later receive informDispose: with aHandle
     (some time in the future)"

    aHandle isNil ifTrue:[
        self unregister:anObject.
        ^ self.
    ].

    self at:anObject put:aHandle.
!

registerChange:anObject
    "a registered object has changed, create a new executor"

    self register:anObject as:anObject executor.
!

unregister:anObject
    "remove registration of anObject, without telling the executor;
     should be sent, if we are no more interested in destruction of
     anObject (i.e. it no longer holds external resources)."

    self removeKey:anObject ifAbsent:[].
!

unregisterAllForWhich:aBlock
    "remove registration of all entries, for which the argument block
     evaluates to true.
     should be sent, if we are no more interested in destruction of
     a group of objects (i.e. it no longer holds external resources)."

    |wasBlocked any|

    wasBlocked := OperatingSystem blockInterrupts.
    keyArray validElementsDo:[:eachObject|
        (eachObject ~~ DeletedEntry and:[aBlock value:eachObject]) ifTrue:[
            self safeRemoveKey:eachObject.      
            any := true.
        ].
    ].
    any ifTrue:[ self possiblyShrink ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

unregisterAllForWhichHandle:aBlock
    "remove registration of all handles, for which the argument block
     evaluates to true.
     should be sent, if we are no more interested in destruction of
     a group of objects (i.e. it no longer holds external resources)."

    |wasBlocked any|

    wasBlocked := OperatingSystem blockInterrupts.
    self keysAndValuesDo:[:eachObject :eachHandle|
        (eachObject class ~~ SmallInteger and:[aBlock value:eachHandle]) ifTrue:[
            self safeRemoveKey:eachObject.      
            any := true.
        ].
    ].
    any ifTrue:[ self possiblyShrink ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
! !

!Registry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

