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

ValueHolder subclass:#BufferedValueHolder
	instanceVariableNames:'subject triggerChannel bufferedValue'
	classVariableNames:'NotYetAssigned'
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!BufferedValueHolder class methodsFor:'documentation'!

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
    a bufferedValueHolder keeps a temporary copy of the realHolders value,
    and only does a real store of the value when triggered.
    Triggering is done by depending on a trigger objects value, which is
    typically a ValueHolder for a boolean, which is set by an ok-button.

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [see also:]
        CodingExamples_GUI::BufferedValueHolderDemo

    [author:]
        Claus Gittinger
"
!

examples 
"
    unbuffered (values are changed, even if not accepted,
    iff a field is left with Return or accept is done in a field):
                                                                        [exBegin]
        |firstName lastName dialog|

        firstName :=  'foo' asValue.
        lastName := 'bar' asValue.

        dialog := Dialog new.
        (dialog addTextLabel:'Name:') layout:#left.
        dialog addInputFieldOn:firstName.
        dialog addVerticalSpace.
        (dialog addTextLabel:'Address:') layout:#left.
        dialog addInputFieldOn:lastName.

        dialog addAbortButton; addOkButton.

        dialog open.

        Transcript show:firstName value; show:' '; showCR:lastName value
                                                                        [exEnd]


    buffered (values are only stored when accepted; undo reloads old values)
    (use an instance of TriggerValue. If a ValueHolder was used, we had
     to temporarily set its value back to nil, to have the change really be
     forwarded to its dependends)
                                                                        [exBegin]
        |firstName lastName trigger dialog|

        firstName :=  'foo' asValue.
        lastName := 'bar' asValue.
        trigger := TriggerValue new.

        dialog := Dialog new.
        (dialog addTextLabel:'Name:') layout:#left.
        dialog addInputFieldOn:(BufferedValueHolder
                                    subject:firstName
                                    triggerChannel:trigger).
        dialog addVerticalSpace.
        (dialog addTextLabel:'Address:') layout:#left.
        dialog addInputFieldOn:(BufferedValueHolder
                                    subject:lastName
                                    triggerChannel:trigger).

        dialog addAbortButton; 
               addButton:(Button new 
                                label:'undo'; 
                                action:[trigger value:false]);
               addOkButton.

        dialog open.
        dialog accepted ifTrue:[
            trigger value:true
        ].

        Transcript show:firstName value; show:' '; showCR:lastName value
                                                                        [exEnd]
"
! !

!BufferedValueHolder class methodsFor:'initialization'!

intialize
    NotYetAssigned := Object new
! !

!BufferedValueHolder class methodsFor:'instance creation'!

subject:someModel triggerChannel:aTrigger
    "return a new BufferedValueHolder offering a buffered copy of someModels
     value - only updating this value, when aTrigger changes to true."

    ^ self new subject:someModel; triggerChannel:aTrigger
! !

!BufferedValueHolder methodsFor:'accessing'!

setValue:anObject
    "set my value without notification."

    bufferedValue := anObject.
!

subject:someModel
    subject notNil ifTrue:[
	subject removeDependent:self
    ].
    subject := someModel.
    subject notNil ifTrue:[
	subject addDependent:self
    ]
!

triggerChannel:aTrigger
    triggerChannel notNil ifTrue:[
	triggerChannel removeDependent:self
    ].
    triggerChannel := aTrigger.
    triggerChannel notNil ifTrue:[
	triggerChannel addDependent:self
    ]
!

value
    "return my value"

    bufferedValue == NotYetAssigned ifTrue:[
	bufferedValue := subject value
    ].
    ^ bufferedValue
! !

!BufferedValueHolder methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    |triggerVal|

    changedObject == triggerChannel ifTrue:[
        triggerVal := triggerChannel value.

        triggerVal == true ifTrue:[
            "
             now, store the buffered value into the subject
            "
            subject value:bufferedValue.
            ^ self
        ].
        triggerVal == false ifTrue:[
            "
             cancel: flush my buffered value
            "
            bufferedValue := NotYetAssigned.
            self changed:#value.
        ].
"/        self changed:#value.
        ^ self
    ].
    changedObject == subject ifTrue:[
        bufferedValue := NotYetAssigned.
        self changed:#value.
        ^ self
    ].

    "Modified: / 28.7.1998 / 11:54:39 / cg"
! !

!BufferedValueHolder methodsFor:'initialization'!

initialize
    super initialize.
    bufferedValue := NotYetAssigned
! !

!BufferedValueHolder methodsFor:'queries'!

isBuffering
    "return true, if the receiver is currently buffering something
     (i.e. its value has been assigned)"

    ^ bufferedValue ~~ NotYetAssigned

    "Modified: / 27.1.1998 / 12:09:46 / cg"
! !

!BufferedValueHolder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/BufferedValueHolder.st,v 1.14 1998-07-28 09:54:55 cg Exp $'
! !
