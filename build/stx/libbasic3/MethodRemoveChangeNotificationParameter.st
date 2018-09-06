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

"{ NameSpace: Smalltalk }"

MethodChangeNotificationParameter variableSubclass:#MethodRemoveChangeNotificationParameter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Notifications'
!

!MethodRemoveChangeNotificationParameter class methodsFor:'documentation'!

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

!MethodRemoveChangeNotificationParameter methodsFor:'accessing'!

changeClass
    ^ self at:1
!

changeClass:changeClassArg changeSelector:changeSelectorArg
    self at:1 put:changeClassArg.
    self at:2 put:changeSelectorArg.
!

changeMethod
    self shouldNeverBeSent
!

changeSelector
    ^ self at:2
! !

!MethodRemoveChangeNotificationParameter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/MethodRemoveChangeNotificationParameter.st,v 1.3 2015-03-20 13:17:02 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

