"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

HTMLMarkup variableSubclass:#HTMLBullet
	instanceVariableNames:'nr markerType origin markerImage'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLBullet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    a list bullet element.
    Please read the warning in HTMLElement.
    
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLBullet methodsFor:'accessing'!

markerImage
    ^ markerImage

    "Created: 17.3.1997 / 14:35:01 / cg"
!

markerImage:something
    markerImage := something.

    "Created: 17.3.1997 / 14:35:01 / cg"
!

markerType
    ^ markerType

    "Created: 18.6.1996 / 22:25:05 / cg"
!

markerType:something
    markerType := something.

    "Created: 18.6.1996 / 22:25:05 / cg"
!

nr
    ^ nr

    "Created: 21.5.1996 / 09:49:01 / cg"
!

nr:something
    nr := something.

    "Created: 21.5.1996 / 09:49:01 / cg"
!

origin
    ^ origin

    "Created: 16.9.1996 / 16:52:07 / cg"
!

origin:something
    origin := something.

    "Created: 16.9.1996 / 16:52:07 / cg"
! !

!HTMLBullet methodsFor:'queries'!

boundsTop
    origin isNil ifTrue:[^ nil].
    ^ origin y

    "Modified: 21.5.1996 / 10:16:12 / cg"
    "Created: 21.5.1996 / 11:16:18 / cg"
! !

!HTMLBullet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLBullet.st,v 1.8 2016-01-20 10:08:04 cg Exp $'
! !

