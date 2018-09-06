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

Object subclass:#HTMLTableCol
	instanceVariableNames:'color bgColor background markupElement x xText xRight yBot
		netWidth cellWidth'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLTableCol class methodsFor:'documentation'!

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

    a table column.
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLTableCol methodsFor:'accessing'!

background
    ^ background
!

background:aColor
    background := aColor
!

cellWidth
    "return cellWidth"

    ^ cellWidth

    "Created: 22.9.1996 / 17:13:51 / cg"
!

cellWidth:something
    "set cellWidth"

    cellWidth := something.

    "Created: 22.9.1996 / 17:13:58 / cg"
!

color
    ^ color
!

color:aColor
    color := aColor
!

markupElement
    "return markupElement"

    ^ markupElement

    "Created: 17.9.1996 / 15:33:49 / cg"
!

markupElement:something
    "set markupElement"

    markupElement := something.

    "Created: 17.9.1996 / 15:33:49 / cg"
!

netWidth
    "return netWidth"

    ^ netWidth

    "Created: 22.9.1996 / 17:11:58 / cg"
!

netWidth:something
    "set netWidth"

    netWidth := something.

    "Created: 22.9.1996 / 17:12:02 / cg"
!

x
    "return x"

    ^ x

    "Created: 17.9.1996 / 15:33:49 / cg"
!

x:something
    "set x"

    x := something.

    "Created: 17.9.1996 / 15:33:49 / cg"
!

xRight
    "return the value of the instance variable 'xRight' (automatically generated)"

    ^ xRight

    "Created: 5.3.1997 / 18:57:37 / cg"
!

xRight:something
    "set the value of the instance variable 'xRight' (automatically generated)"

    xRight := something.

    "Created: 5.3.1997 / 18:57:37 / cg"
!

xText
    "return xText"

    ^ xText

    "Created: 17.9.1996 / 15:33:49 / cg"
!

xText:something
    "set xText"

    xText := something.

    "Created: 17.9.1996 / 15:33:49 / cg"
!

yBottom
    "return yBottom"

    ^ yBot

    "Created: 17.9.1996 / 19:01:38 / cg"
!

yBottom:y
    "set yBottom"

    yBot := y

    "Created: 17.9.1996 / 19:01:47 / cg"
! !

!HTMLTableCol methodsFor:'accessing-color & font'!

bgColor
    ^ bgColor
!

bgColor:aColor
    bgColor := aColor
! !

!HTMLTableCol class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLTableCol.st,v 1.11 2017-11-28 18:24:23 cg Exp $'
! !

