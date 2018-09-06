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

ValueHolder subclass:#TriggerValue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!TriggerValue class methodsFor:'documentation'!

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
    a triggerValue sends updates on every store of a value, even if the same
    value is stored again.
    It can be used as a triggerChannel of a bufferedValueHolder.

    (however, in this specific use, you can also use normal ValueHolder,
     and set it value to nil before setting it to the actual trigger value)

    [author:]
        Claus Gittinger
"
!

examples 
"
                                                                        [exBegin]
        |trigger|

        trigger := TriggerValue new.
        trigger onChangeEvaluate:[ Transcript showCR:'hello' ].
        trigger value:true.
        Delay waitForSeconds:1.
        trigger value:true
                                                                        [exEnd]

    buffered editing with a TriggerValue
                                                                        [exBegin]
        |firstName lastName trigger dialog|

        firstName :=  'foo' asValue.
        lastName := 'bar' asValue.
        trigger := TriggerValue new.

        dialog := Dialog new.
        (dialog addTextLabel:'Name:') layout:#left.
        (dialog addInputFieldOn:(BufferedValueHolder
                                    subject:firstName
                                    triggerChannel:trigger)) immediateAccept:true.
        dialog addVerticalSpace.
        (dialog addTextLabel:'Address:') layout:#left.
        (dialog addInputFieldOn:(BufferedValueHolder
                                    subject:lastName
                                    triggerChannel:trigger)) immediateAccept:true.

        dialog addAbortButton; 
               addButton:(Button new 
                                label:'undo'; 
                                action:[trigger value:false]);
               addOkButton.

        dialog okAction:[trigger value:true].
        dialog open.

        Transcript show:firstName value; show:' '; showCR:lastName value
                                                                        [exEnd]
"
! !

!TriggerValue methodsFor:'accessing'!

value:anObject
    "redefined to send change notifications on every store,
     even if the same value is stored again."

    self setValue:anObject.
    self changed:#value

    "Modified: / 28.7.1998 / 11:22:32 / cg"
! !

!TriggerValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/TriggerValue.st,v 1.11 2014-11-14 11:40:20 cg Exp $'
! !

