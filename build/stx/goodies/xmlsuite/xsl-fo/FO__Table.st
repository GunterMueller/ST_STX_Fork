"{ Package: 'stx:goodies/xmlsuite/xsl-fo' }"

"{ NameSpace: FO }"

VisualElement subclass:#Table
	instanceVariableNames:'colWidths'
	classVariableNames:''
	poolDictionaries:''
	category:'FO-fo:table'
!


!Table class methodsFor:'accessing'!

localName
    "Superclass says that I am responsible to implement this method"

    ^'table'

    "Created: / 07-04-2007 / 16:39:36 / janfrog"
! !

!Table methodsFor:'accessing - dimensions'!

maxCellHeight
    ^ (self foChildNodes inject:0
        into:[:maxHeight :tableRow | maxHeight max:tableRow preferredHeight ])

    "Created: / 08-04-2007 / 01:02:04 / janfrog"
!

maxCellWidth
    ^ (self foChildNodes inject:0
        into:[:maxWidth :tableRow | 
            maxWidth max:(tableRow foChildNodes inject:0
                        into:[:maxWidth :tableCell | maxWidth max:tableCell preferredWidth ])
        ])

    "Created: / 08-04-2007 / 01:01:39 / janfrog"
!

preferredHeight

    self tableLayout = 'matrix' ifTrue:
        [^self preferredHeightForMatrixLayout]

    "Created: / 08-04-2007 / 00:56:50 / janfrog"
!

preferredHeightForMatrixLayout
    ^self foChildNodes size * self maxCellHeight

    "Modified: / 09-04-2007 / 09:55:18 / janfrog"
!

preferredWidth

    self tableLayout = 'matrix' ifTrue:
        [^self preferredWidthForMatrixLayout]

    "Created: / 08-04-2007 / 00:56:36 / janfrog"
!

preferredWidthForMatrixLayout
    ^self foChildNodes foChildNodes size * self maxCellWidth.

    "Created: / 08-04-2007 / 00:56:50 / janfrog"
    "Modified: / 09-04-2007 / 09:55:22 / janfrog"
! !

!Table methodsFor:'accessing - layout'!

tableLayout

    ^self 
        getStringProperty:'table-layout'
        ifAbsent:['fixed']

    "Created: / 07-04-2007 / 16:37:51 / janfrog"
! !

!Table methodsFor:'layout computation'!

layoutChildren

    self tableLayout = 'matrix' ifTrue:
            [^self layoutChildrenForMatrixLayout].

    self error:'Unsupported layout type: ',self tableLayout

    "Created: / 08-04-2007 / 00:49:57 / janfrog"
!

layoutChildrenForMatrixLayout

    | cellExtent |
    cellExtent := self maxCellWidth @ self maxCellHeight.
    self foChildNodes keysAndValuesDo:[:y :row|
        row 
            origin: cellExtent * (0 @ (y - 1));
            extent: cellExtent * (row foChildNodes size @ 1).
        row foChildNodes keysAndValuesDo:[:x :cell|
            cell
                origin: cellExtent * ((x - 1)@0);
                extent: cellExtent;
                layoutChildren]]

    "Created: / 08-04-2007 / 00:53:52 / janfrog"
    "Modified: / 09-04-2007 / 10:28:01 / janfrog"
! !

!Table methodsFor:'rendering'!

acceptRenderer:arg 
    "Superclass says that I am responsible to implement this method"

    arg renderTable: self

    "Created: / 07-04-2007 / 16:39:36 / janfrog"
    "Modified: / 08-04-2007 / 00:44:59 / janfrog"
! !

!Table class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xsl-fo/FO__Table.st,v 1.1 2007-04-13 15:38:38 vranyj1 Exp $'
! !
