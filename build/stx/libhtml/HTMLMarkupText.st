"{ Encoding: utf8 }"

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

HTMLText variableSubclass:#HTMLMarkupText
	instanceVariableNames:'text'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLMarkupText class methodsFor:'documentation'!

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

    a piece of text in a document.
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLMarkupText class methodsFor:'instance creation'!

text:arg
    "Create & return a new instance for arg."

    ^ self new text:arg

    "Modified: / 08-08-2018 / 16:48:45 / Claus Gittinger"
! !

!HTMLMarkupText methodsFor:'accessing'!

text
    ^ text
!

text:aString
    text := aString.

    "Modified (format): / 08-08-2018 / 16:47:52 / Claus Gittinger"
! !

!HTMLMarkupText methodsFor:'queries'!

isTextElement
    ^ true
! !

!HTMLMarkupText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLMarkupText.st,v 1.13 2018-08-08 15:57:41 cg Exp $'
! !

