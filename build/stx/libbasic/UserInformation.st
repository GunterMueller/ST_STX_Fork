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

UserNotification subclass:#UserInformation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Notifications'
!

!UserInformation class methodsFor:'documentation'!

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
    UserInformation is similar to UserNotification,
    but used for less important messages. 
    It produces an info box with the message on the screen. 
    If no display is available, the message is written to the Transcript (headless operation).

    [author:]
        Stefan Vogel

    [see also:]
        Signal
"
! !

!UserInformation class methodsFor:'initialization'!

initialize

    NotifierString := 'User Information:'.

    "
     self initialize
    "
! !

!UserInformation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UserInformation.st,v 1.4 2008/10/04 08:42:26 cg Exp $'
!

version_SVN
    ^ '$Id: UserInformation.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

UserInformation initialize!



