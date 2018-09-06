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

MethodChangeNotificationParameter variableSubclass:#MethodCategoryChangeNotificationParameter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Notifications'
!

!MethodCategoryChangeNotificationParameter class methodsFor:'documentation'!

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

!MethodCategoryChangeNotificationParameter class methodsFor:'instance creation'!

changeClass:changeClassArg changeMethod:changeMethodArg oldCategory:oldCategoryArg
    ^ (self new:3)
        changeClass:changeClassArg changeMethod:changeMethodArg oldCategory:oldCategoryArg
! !

!MethodCategoryChangeNotificationParameter methodsFor:'accessing'!

changeClass:changeClassArg changeMethod:changeMethodArg oldCategory:oldCategoryArg
    self at:1 put:changeClassArg.
    self at:2 put:changeMethodArg.
    self at:3 put:oldCategoryArg.
!

oldCategory
    ^ self at:3
! !

!MethodCategoryChangeNotificationParameter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/MethodCategoryChangeNotificationParameter.st,v 1.2 2014-02-05 17:52:21 cg Exp $'
! !

