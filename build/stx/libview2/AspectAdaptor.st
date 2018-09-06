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

"{ NameSpace: Smalltalk }"

ProtocolAdaptor subclass:#AspectAdaptor
	instanceVariableNames:'myAspect getMsg putMsg'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!AspectAdaptor class methodsFor:'documentation'!

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
    an AspectAdaptor forwards updates and change messages from/to a complex model.

    Consider the case where editFields are required for the
    elements (instance variables) of a compound object:
    - without an aspect adaptor, you needed to copy the individual
      values out-of the object and move these into multiple valueHolders.
      Then, let the editFields modify the valueHolders contents and
      finally, fetch the values and put them back into the compound object.

    An aspectAdaptor makes this easier, by playing model with
    value/value: symbols towards the editField, and forwarding changes and
    updates to/from the compound object using different aspect symbols
    and access messages.

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger

    [see also:]
        ValueHolder Model
"
!

examples
"
    a dialog on a points x/y coordinates:
                                                                        [exBegin]
        |dialog data f|

        data := 0@0.

        dialog := DialogBox new.
        dialog addTextLabel:'x:'.
        f := dialog addInputFieldOn:(AspectAdaptor new
                                        subject:data; 
                                        accessWith:#x 
                                        assignWith:#x:).
        f converter:(PrintConverter new initForNumber).

        dialog addTextLabel:'y:'.
        f := dialog addInputFieldOn:(AspectAdaptor new
                                        subject:data; 
                                        forAspect:#y).
        f converter:(PrintConverter new initForNumber).

        dialog addOkButton.
        data inspect.
        dialog open.

        dialog accepted ifTrue:[
            Transcript showCR:'data now: ' , data printString
        ]
                                                                        [exEnd]


    a dialog on a four-field complex model:
                                                                        [exBegin]
        |dialog data dataModel|

        data := #('hello' 'one' 'two' 'three').
        dataModel := Plug new.
        dataModel respondTo:#field1 with:[data at:1].
        dataModel respondTo:#field2 with:[data at:2].
        dataModel respondTo:#field3 with:[data at:3].
        dataModel respondTo:#field4 with:[data at:4].
        dataModel respondTo:#field1: with:[:arg | data at:1 put:arg].
        dataModel respondTo:#field2: with:[:arg | data at:2 put:arg].
        dataModel respondTo:#field3: with:[:arg | data at:3 put:arg].
        dataModel respondTo:#field4: with:[:arg | data at:4 put:arg].

        dialog := DialogBox new.
        dialog addTextLabel:'1:'.
        dialog addInputFieldOn:(AspectAdaptor new
                                        subject:dataModel; 
                                        accessWith:#field1
                                        assignWith:#field1:). 
        dialog addTextLabel:'2:'.
        dialog addInputFieldOn:(AspectAdaptor new
                                        subject:dataModel; 
                                        forAspect:#field2).
        dialog addTextLabel:'3:'.
        dialog addInputFieldOn:(AspectAdaptor new
                                        subject:dataModel; 
                                        accessWith:#field3
                                        assignWith:#field3:
                                        aspect:#field3). 
        dialog addTextLabel:'4:'.
        dialog addInputFieldOn:(AspectAdaptor new
                                        subject:dataModel; 
                                        forAspect:#field4).
        dialog addOkButton.
        dataModel inspect.
        dialog open.
        dialog accepted ifTrue:[
            Transcript showCR:'data now: ' , data printString
        ]
                                                                        [exEnd]
"
! !

!AspectAdaptor class methodsFor:'instance creation'!

accessWith:getSelector assignWith:putSelector 
    "create and return an adaptor which uses getSelector to fetch a value
     and setSelector to change it."

    ^ (self new) accessWith:getSelector assignWith:putSelector
!

forAspect:anAspect
    "create and return a new adaptor, which forwards requests
     to anObject, using anAspect as get-selector and anAspect-colon as putSelector
     for access. The returned object can be used in place of a ValueHolder"

    ^ self new forAspect:anAspect

    "Modified: 22.1.1997 / 12:00:42 / cg"
!

subject:anObject sendsUpdates:aBoolean accessWith:getSel assignWith:putSel aspect:aspect
    "create and return a new adaptor, which forwards requests
     to anObject, using getSel/putSel for access.
     The returned object can be used in place of a ValueHolder"

    ^ (self subject:anObject sendsUpdates:aBoolean) 
                accessWith:getSel assignWith:putSel aspect:aspect

    "Modified: 22.1.1997 / 12:00:42 / cg"
! !

!AspectAdaptor methodsFor:'accessing-spec'!

accessWith:getSelector assignWith:putSelector
    "setup the receiver to use getSelector to fetch a value
     and putSelector to change it."

    getMsg := getSelector.
    putMsg := putSelector

    "Modified: 22.1.1997 / 18:28:46 / cg"
!

accessWith:getSelector assignWith:putSelector aspect:aspectSymbol
    "setup the receiver to use getSelector to fetch a value
     and putSelector to change it."

    getMsg := getSelector.
    putMsg := putSelector.
    myAspect := aspectSymbol

    "Modified: 22.1.1997 / 18:28:51 / cg"
!

aspect:aSelector
    "set the adapters change aspect - this is the aspect of the update message,
     on which the adaptor reacts"

    myAspect := aSelector.
!

forAspect
    "get the adapters aspect - if none was defined, the getMsg is returned"

    myAspect isNil ifTrue:[
        ^ getMsg
    ].
    ^ myAspect

    "Modified: 22.1.1997 / 18:27:24 / cg"
!

forAspect:aSelector
    "set the adapters aspect - this sets both the get- and put-Messages
     (the putMessage is the aspect with a colon)"

    getMsg := myAspect := aSelector.
    putMsg := aSelector asMutator.

    "Modified: 22.1.1997 / 18:29:05 / cg"
! !

!AspectAdaptor methodsFor:'accessing-value'!

defaultValueIfNoSubject
    "if there is no subject (taget to provide the value),
     this value is returned."

    ^ nil

    "Created: / 01-03-2012 / 08:53:38 / cg"
!

setValue:newValue
    "set the value - this forwards a putMessage to the target"

    |target oldValue|

    target := super value.
    target notNil ifTrue:[
        oldValue := target perform:getMsg.
        oldValue ~~ newValue ifTrue:[
            target perform:putMsg with:newValue.
        ]
    ].

    "Modified: / 01-03-2012 / 08:54:10 / cg"
!

value
    "translate a query for my value from my user
     into an aspect access towards my subject"

    |target|

    target := super value.
    target isNil ifTrue:[^ self defaultValueIfNoSubject].

    ^ target perform:getMsg

    "Modified (format): / 01-03-2012 / 08:54:33 / cg"
!

value:newValue
    "set the value - this forwards a putMessage to the target
     and sends out a changeNotification if the value did really change."

    |target oldValue|

    target := super value.
    target notNil ifTrue:[
        oldValue := target perform:getMsg.
        oldValue ~~ newValue ifTrue:[
            target perform:putMsg with:newValue.
            subjectSendsUpdates ifFalse:[
                self changed:#value
            ]
        ]
    ].

    "Modified: / 01-03-2012 / 08:54:27 / cg"
! !

!AspectAdaptor methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "translate an update from the model into a #value-change
     via my depenedents ..."

    ((changedObject == subject and:[something == self forAspect])
    or:[changedObject == subjectChannel]) ifTrue:[
        self changed:#value
    ].
! !

!AspectAdaptor class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

