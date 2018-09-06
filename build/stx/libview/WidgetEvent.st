"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

WindowEvent subclass:#WidgetEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!WidgetEvent class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    Abstract superclass for higher level internal widget events (like menu-selections).
"
! !

!WidgetEvent methodsFor:'testing'!

isWidgetEvent
    ^ true

    "Created: / 29-06-2011 / 12:05:17 / cg"
! !

!WidgetEvent class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

