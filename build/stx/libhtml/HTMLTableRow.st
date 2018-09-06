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

Object subclass:#HTMLTableRow
	instanceVariableNames:'columns markupElement yRow yBottom'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLTableRow class methodsFor:'documentation'!

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

    a table row.
    Beside providing convenient access for
    some heavily used values (attributes), this also keeps
    track of the columns, and the (y-)position within the document.

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLTableRow methodsFor:'accessing'!

addColumn:aCol
    "add a column"

    columns isNil ifTrue:[
        columns := OrderedCollection new.
    ].
    columns add:aCol

    "Created: 17.9.1996 / 15:32:18 / cg"
!

columnAt:index
    "retrieve a column"

    columns isNil ifTrue:[^ nil].
    ^ columns at:index

    "Created: 17.9.1996 / 15:33:23 / cg"
!

columns
    "return columns"

    ^ columns

    "Created: 17.9.1996 / 15:30:03 / cg"
!

columns:something
    "set columns"

    columns := something.

    "Created: 17.9.1996 / 15:30:03 / cg"
!

markupElement
    "return markupElement"

    ^ markupElement

    "Created: 17.9.1996 / 15:30:03 / cg"
!

markupElement:something
    "set markupElement"

    markupElement := something.

    "Created: 17.9.1996 / 15:30:03 / cg"
!

yBottom
    "return yBottom"

    ^ yBottom

    "Created: 18.9.1996 / 18:21:09 / cg"
!

yBottom:something
    "set yBottom"

    yBottom := something.

    "Created: 18.9.1996 / 18:21:09 / cg"
!

yRow
    "return y"

    ^ yRow

    "Created: 17.9.1996 / 21:17:57 / cg"
!

yRow:something
    "set y"

    yRow := something.

    "Created: 17.9.1996 / 21:18:02 / cg"
! !

!HTMLTableRow methodsFor:'queries'!

maxColumnBottom
    columns isNil ifTrue:[^ nil].
    ^ columns 
        inject:0 
        into:[:maxSoFar :thisCol | |thisBot|
                thisBot := thisCol yBottom.
                thisBot isNil ifTrue:[
                    "/ an empty (colSpan-dummy) col
                    maxSoFar
                ] ifFalse:[
                    maxSoFar max:thisBot
                ]
             ].

    "Created: 17.9.1996 / 19:02:51 / cg"
    "Modified: 18.9.1996 / 11:38:48 / cg"
! !

!HTMLTableRow class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLTableRow.st,v 1.9 2016-04-28 20:45:51 cg Exp $'
! !

