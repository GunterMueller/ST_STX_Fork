"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

ValueModel subclass:#ProtocolAdaptor
	instanceVariableNames:'accessPath subject subjectChannel subjectSendsUpdates'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!ProtocolAdaptor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    a ProtocolAdaptor allows access to embeded values in a
    complex model and plays model towards the outside world.

    Consider the case where editFields are required for the
    elements (instance variables) of a more complex model.
    Using ValueHolders, you had to copy the individual
    values out-of and into multiple valueHolders.
    A protocolAdaptor makes this easier, by playing model towards
    the editField, returning a value from the complex model, 
    and forwards changes to the complex model.

    Notice: 
        since you can specify the aspect- and changeSymbols in most ST/X
        widgets, ProtocolAdapters are not always needed 
        (at least, if no accesspath is required). 
        However, if you want to apply widgets on objects which where not 
        originally designed as models (such as Arrays), ProtocolAdapters 
        are very handy.

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger

    [see also:]
        Model AspectAdaptor ValueHolder
"
!

examples 
"
                                                                        [exBegin]
        |a obj|

        a := ProtocolAdaptor accessPath:#(1 2 3).
        obj := Array with:#(11 (121 122 123) 13)
                     with:#(21 (221 222 223) 23)
                     with:#(33 (321 322 323) 33).
        a valueUsingSubject:obj  
                                                                        [exEnd]



                                                                        [exBegin]
        |a obj|

        a := ProtocolAdaptor accessPath:#(1 2 origin).
        obj := Array with:(Array with:1@1 with:(1@2 corner:100@100))
                     with:(Array with:2@1 with:2@2)
                     with:(Array with:3@1 with:3@2).
        a valueUsingSubject:obj  
                                                                        [exEnd]



                                                                        [exBegin]
        |a model|

        a := ProtocolAdaptor accessPath:#(1 2 origin).
        model := (Array with:(Array with:1@1 with:(1@2 corner:100@100))
                     with:(Array with:2@1 with:2@2)
                     with:(Array with:3@1 with:3@2)) asValue.
        a subjectChannel:model.
        a value   
                                                                        [exEnd]
"
! !

!ProtocolAdaptor class methodsFor:'instance creation'!

accessPath:aCollectionOfSelectors
    ^ (self new) accessPath:aCollectionOfSelectors
!

subject:anObject
    ^ (self new) subject:anObject
!

subject:anObject accessPath:aCollectionOfSelectors
    ^ (self new) subject:anObject; accessPath:aCollectionOfSelectors
!

subject:anObject sendsUpdates:aBoolean
    ^ (self new) subject:anObject; subjectSendsUpdates:aBoolean

    "Modified: 18.4.1996 / 01:45:34 / cg"
!

subject:anObject sendsUpdates:aBoolean accessPath:aCollectionOfSelectors
    ^ (self new) subject:anObject; subjectSendsUpdates:aBoolean; accessPath:aCollectionOfSelectors

    "Modified: 18.4.1996 / 01:45:38 / cg"
!

subjectChannel:aValueHolder
    ^ (self new) subjectChannel:aValueHolder
!

subjectChannel:aValueHolder accessPath:aCollectionOfSelectors
    ^ (self new) subjectChannel:aValueHolder; accessPath:aCollectionOfSelectors
!

subjectChannel:aValueHolder sendsUpdates:aBoolean 
    ^ (self new) subjectChannel:aValueHolder; subjectSendsUpdates:aBoolean

    "Modified: 18.4.1996 / 01:45:45 / cg"
!

subjectChannel:aValueHolder sendsUpdates:aBoolean accessPath:aCollectionOfSelectors
    ^ (self new) subjectChannel:aValueHolder; subjectSendsUpdates:aBoolean; accessPath:aCollectionOfSelectors

    "Modified: 18.4.1996 / 01:45:50 / cg"
! !

!ProtocolAdaptor methodsFor:'accessing'!

setValue:newValue
    "set the value in my subject or subjectChannel."

    |obj|

    subject notNil ifTrue:[
	obj := subject.
    ] ifFalse:[
	obj := subjectChannel value
    ].
    ^ self setValue:newValue usingSubject:obj
!

setValue:newValue usingSubject:anObject
    "set a value in anObject, using the selectors in accessPath.
     A helper for setValue:."

    |obj lastIndex|

    obj := anObject.
    lastIndex := accessPath size.
    accessPath keysAndValuesDo:[:idx :aSelectorOrIndex |
        aSelectorOrIndex isInteger ifTrue:[
            idx == lastIndex ifTrue:[
                obj at:aSelectorOrIndex put:newValue
            ] ifFalse:[
                obj := obj at:aSelectorOrIndex
            ]
        ] ifFalse:[
            idx == lastIndex ifTrue:[
                obj perform:aSelectorOrIndex asMutator with:newValue
            ] ifFalse:[
                obj := obj perform:aSelectorOrIndex
            ]
        ]
    ].
    ^ newValue
!

subjectValue
    "return the value from my subject or subjectChannel."

    |obj|

    subject notNil ifTrue:[
        obj := subject.
    ] ifFalse:[
        obj := subjectChannel value
    ].
    ^ self valueUsingSubject:obj
!

value
    "return the value from my subject or subjectChannel."

    |obj|

    subject notNil ifTrue:[
	obj := subject.
    ] ifFalse:[
	obj := subjectChannel value
    ].
    ^ self valueUsingSubject:obj
!

value:newValue
    "set my value & send change notifications to my dependents
     if it changed. But only if my subject does not itself
     send change notifications (otherwise, we'd send double notifications)."

    |oldValue|

    oldValue := self value.
    oldValue ~~ newValue ifTrue:[
        self setValue:newValue.
        subjectSendsUpdates ifFalse:[
            self changed:#value
        ]
    ]

    "Created: / 1.11.1997 / 14:04:45 / cg"
!

valueUsingSubject:anObject
    "return the value from anObject, using the selectors in accessPath.
     A helper for value."

    |obj|

    obj := anObject.
    accessPath notNil ifTrue:[
	accessPath do:[:aSelectorOrIndex |
	    aSelectorOrIndex isInteger ifTrue:[
		obj := obj at:aSelectorOrIndex
	    ] ifFalse:[
		obj := obj perform:aSelectorOrIndex
	    ]
	].
    ].
    ^ obj
! !

!ProtocolAdaptor methodsFor:'accessing-spec'!

accessPath
    "return the access path"

    ^ accessPath

    "Modified: 27.4.1996 / 16:20:48 / cg"
!

accessPath:aCollectionOfSelectors
    "set the access path"

    accessPath := aCollectionOfSelectors

    "Modified: 27.4.1996 / 16:20:53 / cg"
!

subject
    "return the subject"

    ^ subject

    "Modified: 27.4.1996 / 16:21:03 / cg"
!

subject:anObject
    "set the subject"

    subject notNil ifTrue:[
        subject removeDependent:self
    ].
    subject := anObject.
    self changed:#value.
    subject notNil ifTrue:[
        subject addDependent:self
    ].

    "Modified: 27.4.1996 / 16:21:09 / cg"
!

subjectChannel
    "return the subjectChannel"

    ^ subjectChannel

    "Modified: 27.4.1996 / 16:21:21 / cg"
!

subjectChannel:aValueHolder
    "set the subjectChannel"

    |oldChannel|

    subjectChannel notNil ifTrue:[
        subjectChannel removeDependent:self
    ].
    oldChannel := subjectChannel.
    subjectChannel := aValueHolder.
    subjectChannel notNil ifTrue:[
        subjectChannel addDependent:self
    ].
    oldChannel notNil ifTrue:[
        self changed:#value.
    ].

    "Modified: 6.9.1995 / 01:19:27 / claus"
    "Modified: 27.4.1996 / 16:21:26 / cg"
!

subjectSendsUpdates
    "return true, if the subject sends updates itself
     If true, the receiver will not send updates on changes"

    ^ subjectSendsUpdates
!

subjectSendsUpdates:aBoolean
    "set/clear the flag which states if the subject sends updates itself.
     If true, the receiver will not send updates on changes"

    subjectSendsUpdates := aBoolean.
! !

!ProtocolAdaptor methodsFor:'change & update'!

update:something with:aPArameter from:changedObject
    "translate updates from my subject into value-changes towards
     my dependents. Since I have no specific aspect, every change is forwarded"

    (changedObject == subject
    or:[changedObject == subjectChannel]) ifTrue:[
	self changed:#value.
	^ self
    ].
! !

!ProtocolAdaptor methodsFor:'initialization'!

initialize
    "setup, assuming that the subject does not send change notifications"

    super initialize.
    subjectSendsUpdates := false.

    "Modified: 27.4.1996 / 16:21:56 / cg"
! !

!ProtocolAdaptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ProtocolAdaptor.st,v 1.15 2014-03-05 22:13:03 cg Exp $'
! !

