"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

WidgetRenderer subclass:#ButtonRenderer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Rendering'
!

!ButtonRenderer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    work in progress - unfinished; do not use
"
! !

!ButtonRenderer methodsFor:'rendering'!

render:aButton on:aGC at:offset
    aButton redraw
! !

!ButtonRenderer class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview/ButtonRenderer.st,v 1.2 2009-12-07 14:56:00 cg Exp $'
! !
