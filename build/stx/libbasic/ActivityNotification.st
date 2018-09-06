"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

UserNotification subclass:#ActivityNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Notifications'
!

!ActivityNotification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    ActivityNotification can be raised from deeply nested methods, which are going to perform
    some long-time activity.

    If there is a handler for the ActivityNotification, that one is called,
    passing the argument. The handler should show this message whereever it likes,
    and proceed. If there is no handler, ActivityNotification is simply ignored.

    This is very useful to pass busy messages up to some higher level (typically a view)
    which likes to display that message in its label or a busy-box.
    It could also be put into some logfile or printed on the standard output/error.

    [see also:]
        Signal
"
! !

!ActivityNotification class methodsFor:'initialization'!

initialize

    NotifierString := 'activity'.

    "
     self initialize
    "
! !

!ActivityNotification methodsFor:'default actions'!

defaultAction
    "the default action is to do nothing"

    self proceed.
! !

!ActivityNotification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/ActivityNotification.st,v 1.4 2008/10/04 08:42:14 cg Exp $'
!

version_SVN
    ^ '$Id: ActivityNotification.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

ActivityNotification initialize!



