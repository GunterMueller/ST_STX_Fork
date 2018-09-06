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

HTMLWidget variableSubclass:#HTMLApplet
	instanceVariableNames:'align appClass widget parameters codeBase archive'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLApplet class methodsFor:'documentation'!

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
    an applet element.
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"


! !

!HTMLApplet methodsFor:'accessing'!

appClass
    ^ appClass

    "Created: 8.10.1996 / 18:48:05 / cg"
!

appClass:something
    appClass := something.

    "Created: 8.10.1996 / 18:48:05 / cg"
!

archive
    ^ archive

    "Created: / 14.10.1998 / 13:29:27 / cg"
!

archive:something
    archive := something.

    "Created: / 14.10.1998 / 13:29:33 / cg"
!

codeBase
    ^ codeBase

    "Created: 10.10.1996 / 19:55:46 / cg"
!

codeBase:something
    codeBase := something.

    "Created: 10.10.1996 / 19:55:46 / cg"
!

parameters
    ^ parameters

    "Created: 8.10.1996 / 18:56:29 / cg"
!

parameters:something
    parameters := something.

    "Created: 8.10.1996 / 18:56:29 / cg"
! !

!HTMLApplet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLApplet.st,v 1.9 2003-09-22 18:12:55 cg Exp $'
! !
