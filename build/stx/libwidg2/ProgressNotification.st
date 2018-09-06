"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ActivityNotification subclass:#ProgressNotification
	instanceVariableNames:'statusInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Notifications'
!

!ProgressNotification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    This should be used in long-going activites to tell the caller about any
    progress (percentage). 
    Being a notification, it will be ignored if no one is interested.
    If someone is interested, the caller may present this information as a progress-bar,
    percentage display or whatever is useful in the UI.
    Examples are:
        http-requests, ftp requests, long lint checks etc.

    See examples on how this is used by searching for references to me.    
"
! !

!ProgressNotification class methodsFor:'notification'!

notify: message progress: progress
    ^ self new
        messageText: message;
        parameter: progress;
        raiseRequest

    "Created: / 31-07-2012 / 16:13:54 / cg"
!

progressPercentage:aPercentageNumber
    self raiseRequestWith:aPercentageNumber
! !

!ProgressNotification methodsFor:'accessing'!

progressValue
    ^ parameter
!

statusInfo
    "any additional info (opaque to me)"
    
    ^ statusInfo
!

statusInfo:something
    "any additional info (opaque to me)"

    statusInfo := something.
! !

!ProgressNotification class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

