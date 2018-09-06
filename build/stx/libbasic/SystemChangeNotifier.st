"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SystemChangeNotifier
	instanceVariableNames:'silenceLevel'
	classVariableNames:'UniqueInstance'
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!SystemChangeNotifier class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
!

documentation
"
    For now, this implementation is mostly for squeak compatibility.
    However, in the future, we may move the change notification code from ClassDescription to here,
    to make things easier to understand, and classDescription a little bit more lightweight.
"
! !

!SystemChangeNotifier class methodsFor:'instance creation'!

uniqueInstance
    "I am a singleton"

    UniqueInstance isNil ifTrue: [UniqueInstance := self basicNew initialize].
    ^ UniqueInstance

    "
     UniqueInstance releaseAll.
     UniqueInstance := nil
    "
! !

!SystemChangeNotifier methodsFor:'change notifications'!

class: trait recategorizedFrom: oldCategory to:newCategory    
    "dummy for now - will write a change record eventually"
!

classAdded:aClass inCategory:aCategoryString
    "dummy for now - will write a change record eventually"
!

traitDefinitionChangedFrom:oldTrait to:newTrait
    "dummy for now - will write a change record eventually"
! !

!SystemChangeNotifier methodsFor:'initialization'!

initialize
    "/ eventSource := SystemEventManager new.
    silenceLevel := 0.
! !

!SystemChangeNotifier methodsFor:'public'!

doSilently: aBlock
    "Perform the block, and ensure that no system notification are broadcasted while doing so."

    |result|

    silenceLevel := silenceLevel + 1.
    [
        "/ temporary hack:
        Class withoutUpdatingChangesDo:[
            result := aBlock value
        ]
    ] ensure: [
        silenceLevel > 0 ifTrue: [
            silenceLevel := silenceLevel - 1
        ]
    ].
    ^ result.
!

isBroadcasting
    ^ silenceLevel = 0
!

noMoreNotificationsFor: aStakeHolder
    "dummy for now "
!

notify:aStakeHolder ofAllSystemChangesUsing:changeMessage
    "dummy for now "
!

notify:aStakeHolder ofSystemChangesOfItem:anItemSymbol change: changeTypeSymbol using: changeMessage
    "dummy for now "
! !

!SystemChangeNotifier class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

