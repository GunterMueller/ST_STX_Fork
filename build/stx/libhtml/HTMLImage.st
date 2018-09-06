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

HTMLAnchor variableSubclass:#HTMLImage
	instanceVariableNames:'urlString image maxHeightInRow yTopInRow'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLImage class methodsFor:'documentation'!

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

    an image element.
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLImage methodsFor:'accessing'!

altParameter
    ^ self parameterFor:#'ALT'
!

image
    ^ image

    "Created: 22.5.1996 / 13:36:53 / cg"
!

image:cachedImage
    image := cachedImage.

    "Created: / 22-05-1996 / 13:36:53 / cg"
    "Modified (format): / 29-03-2017 / 12:58:24 / cg"
!

maxHeightInRow
    ^ maxHeightInRow

    "Created: 16.9.1996 / 11:06:10 / cg"
!

maxHeightInRow:something
    maxHeightInRow := something.

    "Created: 16.9.1996 / 11:06:10 / cg"
!

srcParameter
    ^ self parameterFor:#'SRC'
!

yTopInRow
    ^ yTopInRow

    "Created: 16.9.1996 / 16:11:33 / cg"
!

yTopInRow:something
    yTopInRow := something.

    "Created: 16.9.1996 / 16:11:33 / cg"
! !

!HTMLImage methodsFor:'queries'!

border
    ^ self numericParameterFor:#'BORDER' default:nil

    "Modified: 18.6.1996 / 21:00:00 / cg"
!

urlString
    urlString isNil ifTrue:[
        urlString := self srcString
    ].
    ^ urlString

    "Created: 17.5.1996 / 16:46:59 / cg"
    "Modified: 17.5.1996 / 16:56:01 / cg"
! !

!HTMLImage methodsFor:'testing'!

isImageElement
    ^ true
! !

!HTMLImage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLImage.st,v 1.17 2017-03-29 10:59:22 cg Exp $'
! !

