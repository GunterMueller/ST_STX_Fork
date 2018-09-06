"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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

ProtocolAdaptor subclass:#DictionaryAdaptor
	instanceVariableNames:'myAspect'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!DictionaryAdaptor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    Similar to AspectAdaptor, but accesses a Dictionary instead of
    a classes instance variables.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
                                                                        [exBegin]
        |dialog dict dataModel|

        dict := Dictionary new.
        dict
            at:#field1 put:'hello';
            at:#field2 put:'one';
            at:#field3 put:'two';
            at:#field4 put:'three'.

        dialog := DialogBox new.
        dialog addTextLabel:'1:'.
        dialog addInputFieldOn:(DictionaryAdaptor new
                                        subject:dict; 
                                        aspect:#field1). 
        dialog addTextLabel:'2:'.
        dialog addInputFieldOn:(DictionaryAdaptor new
                                        subject:dict; 
                                        forAspect:#field2).
        dialog addTextLabel:'3:'.
        dialog addInputFieldOn:(DictionaryAdaptor new
                                        subject:dict; 
                                        aspect:#field3). 
        dialog addTextLabel:'4:'.
        dialog addInputFieldOn:(DictionaryAdaptor new
                                        subject:dict; 
                                        forAspect:#field4).
        dialog addOkButton.
        dict inspect.
        dialog open.
        dialog accepted ifTrue:[
            Transcript showCR:'data now: ' , dict printString
        ]
                                                                        [exEnd]
"
! !

!DictionaryAdaptor class methodsFor:'instance creation'!

forAspect:anAspect
    "create and return a new adaptor, which forwards requests
     to anObject, using anAspect to access a Dictionary. 
     The returned object can be used in place of a ValueHolder"

    ^ self new forAspect:anAspect
!

subject:anObject sendsUpdates:aBoolean aspect:aspect
    "create and return a new adaptor, which forwards requests
     to anObject, using #at:aspect and #at:aspect put: for access.
     The returned object can be used in place of a ValueHolder"

    ^ (self subject:anObject sendsUpdates:aBoolean) aspect:aspect
! !

!DictionaryAdaptor methodsFor:'accessing-spec'!

aspect:aSelector
    "set the adapters change aspect - this is the aspect of the update message,
     on which the adaptor reacts"

    myAspect := aSelector.
!

forAspect
    "get the adapters aspect"

    ^ myAspect
!

forAspect:aSelector
    "set the adapters aspect"

    myAspect := aSelector.
! !

!DictionaryAdaptor methodsFor:'accessing-value'!

setValue:newValue
    "set the value - this forwards a putMessage to the target"

    |target oldValue|

    target := self subjectValue.
    target isNil ifTrue:[^ nil].

    oldValue := target at:myAspect.
    oldValue ~~ newValue ifTrue:[
        target at:myAspect put:newValue.
    ]
!

value
    "translate a query for my value from my user
     into an aspect access towards my subject"

    |target|

    target := self subjectValue.
    target isNil ifTrue:[^ nil].
    ^ target at:myAspect ifAbsent:[].
!

value:newValue
    "set the value - this changes the target with #at:put:
     and sends out a changeNotification if the value did really change."

    |target oldValue|

    target := self subjectValue.
    target isNil ifTrue:[^ self].

    oldValue := target at:myAspect ifAbsent:[].
    oldValue ~~ newValue ifTrue:[
        target at:myAspect put:newValue.
        subjectSendsUpdates ifFalse:[
            self changed:#value
        ]
    ]
! !

!DictionaryAdaptor methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "translate an update from the model into a #value-change
     via my depenedents ..."

    ((changedObject == subject and:[something == myAspect])
    or:[changedObject == subjectChannel]) ifTrue:[
        self changed:#value
    ].
! !

!DictionaryAdaptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DictionaryAdaptor.st,v 1.2 2009-09-18 16:14:09 cg Exp $'
! !

