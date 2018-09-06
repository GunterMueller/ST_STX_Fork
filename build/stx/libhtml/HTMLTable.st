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

HTMLMarkup variableSubclass:#HTMLTable
	instanceVariableNames:'rows top width height inset spaceInset defaultCellPadding
		defaultCellSpacing cellSpacing cellPadding borderWidth
		borderColor'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLTable class methodsFor:'documentation'!

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

    a table element.
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
! !

!HTMLTable methodsFor:'accessing'!

addRow:aRow
    rows isNil ifTrue:[
        rows := OrderedCollection new.
    ].
    rows add:aRow

    "Created: 13.6.1996 / 15:15:02 / cg"
!

borderColor

    borderColor isNil ifTrue:[
        borderColor := (self colorParameter:#'BORDERCOLOR') ? #NIL
    ].
    ^ borderColor isColor ifTrue:[borderColor] ifFalse:[nil]
!

defaultCellPadding:something
    "set defaultCellPadding"

    defaultCellPadding := something.

    "Created: 17.9.1996 / 16:29:50 / cg"
!

defaultCellSpacing:something
    "set defaultCellSpacing"

    defaultCellSpacing := something.

    "Created: 18.9.1996 / 10:23:10 / cg"
!

height
    ^ height

    "Created: 13.6.1996 / 16:16:41 / cg"
!

height:aNumberOrPercentString
    height := aNumberOrPercentString

    "Created: 13.6.1996 / 16:16:50 / cg"
!

inset
    "return inset"

    ^ inset

    "Created: 18.6.1996 / 18:10:52 / cg"
!

inset:something
    "set inset"

    inset := something.

    "Created: 18.6.1996 / 18:10:52 / cg"
!

rowAt:index
    ^ rows at:index

    "Created: 13.6.1996 / 15:17:04 / cg"
!

rows
    ^ rows

    "Created: 13.6.1996 / 15:26:53 / cg"
!

spaceInset
    "return spaceInset"

    ^ spaceInset

    "Created: 18.6.1996 / 18:50:32 / cg"
!

spaceInset:something
    "set spaceInset"

    spaceInset := something.

    "Created: 18.6.1996 / 18:50:32 / cg"
!

top
    "return top"

    ^ top

    "Created: 13.6.1996 / 16:21:32 / cg"
!

top:something
    "set top"

    top := something.

    "Created: 13.6.1996 / 16:21:32 / cg"
!

width
    ^ width

    "Created: 17.9.1996 / 16:18:51 / cg"
!

width:aNumberOrPercentString
    width := aNumberOrPercentString

    "Created: 17.9.1996 / 16:18:57 / cg"
! !

!HTMLTable methodsFor:'queries'!

borderWidth
    "return the tables border width (in pixels)"

    borderWidth isNil ifTrue:[
        (self hasParameterFor:#'BORDER') ifFalse:[
            borderWidth := 0
        ] ifTrue:[
            borderWidth := self numericParameterFor:#'BORDER' default:1
        ]
    ].
    ^ borderWidth
!

cellpadding
    "return the tables spacing between col-borders and their contents (in pixels)"

    cellPadding isNil ifTrue:[
        cellPadding := self numericParameterFor:#'CELLPADDING' default:defaultCellPadding
    ].
    ^ cellPadding
!

cellspacing
    "return the tables inner cell-border width (in pixels)"

    cellSpacing isNil ifTrue:[
        cellSpacing := self numericParameterFor:#'CELLSPACING' default:defaultCellSpacing
    ].
    ^ cellSpacing
! !

!HTMLTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLTable.st,v 1.11 2016-04-28 20:45:57 cg Exp $'
! !

