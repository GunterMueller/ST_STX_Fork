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

MethodChangeNotificationParameter variableSubclass:#MethodTrapChangeNotificationParameter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Notifications'
!

!MethodTrapChangeNotificationParameter class methodsFor:'documentation'!

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

!MethodTrapChangeNotificationParameter methodsFor:'accessing'!

changeClass:changeClassArg changeSelector:changeSelectorArg
    self at:1 put:changeClassArg.
    self at:2 put:changeSelectorArg.
!

changeMethod
    ^ nil
!

changeSelector
    ^ self at:2
! !

!MethodTrapChangeNotificationParameter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/MethodTrapChangeNotificationParameter.st,v 1.3 2014-02-05 17:52:01 cg Exp $'
! !

