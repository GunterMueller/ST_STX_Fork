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

HTMLMarkup variableSubclass:#HTMLList
	instanceVariableNames:'nextNumber numberType markerType markerSize'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLList class methodsFor:'documentation'!

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
    Attention: Please read the warning in HTMLElement.

    a list element.
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLList methodsFor:'accessing'!

markerSize
    ^ markerSize

    "Created: 18.6.1996 / 22:20:38 / cg"
!

markerSize:something
    markerSize := something.

    "Created: 18.6.1996 / 22:20:38 / cg"
!

markerType
    ^ markerType

    "Created: 18.6.1996 / 22:08:08 / cg"
!

markerType:something
    markerType := something.

    "Created: 18.6.1996 / 22:08:08 / cg"
!

nextNumber
    ^ nextNumber

    "Created: 18.6.1996 / 22:08:08 / cg"
!

nextNumber:something
    nextNumber := something.

    "Created: 18.6.1996 / 22:08:08 / cg"
!

numberType
    ^ numberType

    "Created: 18.6.1996 / 22:08:08 / cg"
!

numberType:something
    numberType := something.

    "Created: 18.6.1996 / 22:08:08 / cg"
! !

!HTMLList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLList.st,v 1.7 2016-04-28 20:45:39 cg Exp $'
! !

