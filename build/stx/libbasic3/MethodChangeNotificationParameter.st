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

ChangeNotificationParameter variableSubclass:#MethodChangeNotificationParameter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Notifications'
!

!MethodChangeNotificationParameter class methodsFor:'documentation'!

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
! !

!MethodChangeNotificationParameter class methodsFor:'instance creation'!

changeClass:changeClassArg changeSelector:changeSelectorArg
    ^ (self new:2)
        changeClass:changeClassArg changeSelector:changeSelectorArg
! !

!MethodChangeNotificationParameter methodsFor:'accessing'!

changeClass
    ^ self at:1
!

changeMethod
    ^ self at:2
! !

!MethodChangeNotificationParameter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/MethodChangeNotificationParameter.st,v 1.2 2014-02-05 17:51:44 cg Exp $'
! !

