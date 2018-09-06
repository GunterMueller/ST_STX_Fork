"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Notification subclass:#UserNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Notifications'
!

!UserNotification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    UserNotification is the superclass of all user notification 
    signals in the system. It produces an info box with the message on the screen. 
    If no display is available, the message is written to the Transcript (headless operation).

    [author:]
        Stefan Vogel

    [see also:]
        Signal
"
!

examples
"
                                                            [exBegin]
    UserNotification raiseRequest
                                                            [exEnd]

                                                            [exBegin]
    UserNotification raiseErrorString:'huh ?'
                                                            [exEnd]

                                                            [exBegin]
    UserNotification raiseRequestWith:nil errorString:'what ?'
                                                            [exEnd]

                                                            [exBegin]
    UserNotification raiseRequestWith:nil errorString:' what ?'
                                                            [exEnd]
"
! !

!UserNotification class methodsFor:'initialization'!

initialize

    NotifierString := 'User Notification:'.

    "
     self initialize
    "

    "Created: / 23.7.1999 / 15:31:44 / stefan"
! !

!UserNotification class methodsFor:'notification'!

notify:aString
    self raiseRequestErrorString:aString
!

notify:message progress:progress
    ^ ProgressNotification notify:message progress:progress

    "Created: / 31-07-2012 / 15:18:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserNotification methodsFor:'default actions'!

defaultAction
    "Default action for notifications: open a info box with description"

    self showInformationDialog.
    self proceed.

    "
      UserNotification raiseRequestErrorString:' abc'
    "

    "Modified: / 3.8.1999 / 14:06:55 / stefan"
!

showInformationDialog
    "open a info box with description"

    |text|

    text := self description.

    self hasDialog ifTrue:[
        Dialog information:text.
    ] ifFalse:[
        "
         on systems without GUI, simply show
         the message on the Transcript.
        "
        Transcript show:'notification: '; showCR:text.
    ].

    "
      UserNotification raiseRequestErrorString:' abc'
    "

    "Modified: / 3.8.1999 / 14:06:55 / stefan"
! !

!UserNotification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UserNotification.st,v 1.19 2014-05-13 22:10:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/UserNotification.st,v 1.19 2014-05-13 22:10:03 cg Exp $'
! !


UserNotification initialize!
