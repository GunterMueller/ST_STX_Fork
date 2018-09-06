"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

Array variableSubclass:#ChangeNotificationParameter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Notifications'
!

!ChangeNotificationParameter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    In previous ST/X versions, change notification parameters were often
    arrays, to pass multiple values in an update:with:from: message.

    These are now replaced by instances of this class or subclasses.
    For backward compatibility, instances also respond to the array protocol,
    so old code can access the slots via #at:.
    Should be phased out over time.
"
! !

!ChangeNotificationParameter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/ChangeNotificationParameter.st,v 1.2 2014-02-05 17:52:33 cg Exp $'
! !

