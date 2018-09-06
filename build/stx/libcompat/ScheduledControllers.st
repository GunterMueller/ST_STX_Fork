"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ScheduledControllers
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!ScheduledControllers class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to access
    work unchanged in ST/X.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!ScheduledControllers class methodsFor:'display refresh'!

restore
    "ScheduledControllers restore"

    Screen current restoreWindows
! !

!ScheduledControllers class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ScheduledControllers.st,v 1.3 2017-01-28 00:02:24 cg Exp $'
! !

