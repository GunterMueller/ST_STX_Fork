"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

DeviceGraphicsContext subclass:#PrinterContext
	instanceVariableNames:'abort jobid printerInfo textAlign'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Printing'
!

!PrinterContext class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    I am the mediator between the smalltalk printing protocol
    (which is the same as the graphics drawing protocol) and the
    windows printer.
    When you open a printer, you will typically talk to me, and I will
    forward the graphics commands to my printer.

    [author:]
        Felix Madrid (fm@exept.de)
"
! !

!PrinterContext class methodsFor:'instance creation'!

fromPrinterInfo: aPrinterInfo
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:56:56 / cg"
! !

!PrinterContext class methodsFor:'accessing'!

default
    "Answer the default Printer, or nil if none."

    |defaultName|

    ^ (defaultName := self defaultPrinterName) isNil
	ifTrue:[ nil ]
	ifFalse:[ self named:defaultName ]

    "
     self default
    "

    "Created: / 27-07-2006 / 17:51:43 / fm"
    "Modified: / 02-08-2006 / 17:27:09 / fm"
    "Modified: / 10-10-2006 / 17:30:31 / cg"
!

defaultMargins
    "Private - answer aPoint containing the default horizontal and vertical
     margins for a page (units in inches)."

    ^ 0.5 @ 0.75

    "Created: / 01-08-2006 / 16:09:31 / fm"
    "Modified: / 10-10-2006 / 17:30:49 / cg"
!

defaultPrinterName
    "Answer the name of the default printer, or nil if none."

    |printerInfo printerName|

    printerInfo := OperatingSystem getDefaultPrinterName.
    printerName := (printerInfo copyFrom:1 to:(printerInfo indexOf:$,) - 1) trimBlanks.
    ^ printerName size == 0 ifTrue:[ nil ] ifFalse:[ printerName ]

    "
     PrinterContext defaultPrinterName
    "

    "Modified: / 02-08-2006 / 17:26:09 / fm"
    "Modified: / 10-10-2006 / 17:32:45 / cg"
!

getPrinterInformation:printerNameString
    " Answer the printer information for the printer named printerNameString.  If no name is specified,
      answer the information for the default printer."

    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:56:31 / cg"
!

named: aName
    "Answer a new instance of Printer which represents
     the printer named aName as specified in the host
     Control Panel."

    aName isNil ifTrue: [ ^self default ].
    ^self new printerInfoWithName: aName

    "Created: / 27-07-2006 / 17:51:27 / fm"
    "Modified: / 02-08-2006 / 17:26:29 / fm"
    "Modified: / 10-10-2006 / 17:33:29 / cg"
!

printerNames
    "Answer a collection of all known printer names."

    ^ OperatingSystem getPrintersNames

    "Created: / 27-07-2006 / 17:54:45 / fm"
    "Modified: / 10-10-2006 / 18:57:51 / cg"
! !

!PrinterContext methodsFor:'abort handling'!

abortPrintJob
    "Abort the current print job."

    abort := true.
    jobid := nil.

    "Modified: / 02-08-2006 / 15:40:26 / fm"
    "Modified: / 10-10-2006 / 18:13:45 / cg"
!

aborted
    "Answer whether the user aborted from PrintAbortDialog."

    ^ abort

    "Created: / 27-07-2006 / 10:20:10 / fm"
    "Modified: / 10-10-2006 / 18:13:50 / cg"
! !

!PrinterContext methodsFor:'accessing'!

container

    ^self
!

getCharHeight
    "Private - answer the height of the font selected in the receiver's
     device context."

    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:50:06 / cg"
!

horizontalPixelsPerMeter
    "Answer horizontal pixels per meter on the screen."
    ^self pixelsPerInchOfScreenWidth  * 39.3700787

    "Modified: / 16-04-2007 / 12:55:21 / cg"
!

name
    "Answer the receiver's name from the current printerInfo."

    ^ self printerInfo printerName

    "Modified: / 02-08-2006 / 16:55:03 / fm"
    "Modified: / 10-10-2006 / 18:15:33 / cg"
!

name:aName
    "Set the receiver's printer name to aName."

    self printerInfo:(self class getPrinterInformation:aName)

    "Modified: / 10-10-2006 / 18:15:36 / cg"
!

numberOfColorBitsPerPixel
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:51:15 / cg"
!

physicalOffsetX
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:54:23 / cg"
!

physicalOffsetY
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:52:17 / cg"
!

pixelsPerInchOfScreenHeight
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:54:17 / cg"
!

pixelsPerInchOfScreenWidth
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:54:15 / cg"
!

printerHeightArea
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:52:28 / cg"
!

printerInfo
    ^ printerInfo

    "Created: / 02-08-2006 / 16:55:17 / fm"
    "Modified: / 16-04-2007 / 12:52:36 / cg"
!

printerInfo:aPrinterInfo
    printerInfo := aPrinterInfo

    "Modified: / 16-04-2007 / 12:54:07 / cg"
!

printerInfoWithName:aName
    self printerInfo:(self class getPrinterInformation:aName).

    "Modified: / 16-04-2007 / 12:54:04 / cg"
!

printerPhysicalHeight
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:54:00 / cg"
!

printerPhysicalWidth
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:53:56 / cg"
!

printerUserFriendlyName
    "Answer the receiver's name from the current printerInfo."

    ^ self printerInfo userFriendlyName

    "Created: / 03-08-2006 / 12:55:57 / fm"
    "Modified: / 10-10-2006 / 18:18:55 / cg"
!

printerWidthArea
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:53:51 / cg"
!

setPrinterFont:aFont

    self font: aFont

    "Created: / 27-11-2006 / 14:50:55 / User"
!

setTextAlign:aNumber
    textAlign :=aNumber.

    "Modified: / 16-04-2007 / 12:53:26 / cg"
!

setViewportOrg: aPoint
    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:53:44 / cg"
!

verticalPixelsPerMeter
    "Answer vertical pixels per meter on the screen."

    ^self pixelsPerInchOfScreenHeight * 39.3700787

    "Modified: / 16-04-2007 / 12:54:43 / cg"
! !

!PrinterContext methodsFor:'initialization & release'!

buildPrinter
    "Private - create all the operating system resources needed."

    self
	createDC;
	initExtent

    "Created: / 27-07-2006 / 10:20:36 / fm"
    "Modified: / 01-08-2006 / 15:57:49 / fm"
    "Modified: / 10-10-2006 / 18:14:04 / cg"
!

createDC
    "Private - Create a device context for the receiver"

    self subclassResponsibility

    "Created: / 27-07-2006 / 10:21:05 / fm"
    "Modified: / 02-08-2006 / 17:30:47 / fm"
    "Modified: / 16-04-2007 / 12:49:22 / cg"
!

initExtent
    "Private - init the width and height of GraphicsTool for the receiver."

    device
        width:self printerWidthArea;
        height:self printerHeightArea.


    "Modified: / 01-08-2006 / 16:14:49 / fm"
!

releaseDC
    "Private - Closes the device context of the receiver"

    self subclassResponsibility

    "Created: / 27-07-2006 / 10:21:05 / fm"
    "Modified: / 02-08-2006 / 17:30:47 / fm"
    "Modified: / 16-04-2007 / 12:49:22 / cg"
! !

!PrinterContext methodsFor:'printing'!

print:aString font:aFont title:aTitle wordWrap:wordWrapBoolean marginsRect:aMarginsRect
    "Answer the receiver.  Output the receiver string to
     the printer using aFont.  A Print abort dialog box will be opened
     with aTitle.  If collateBoolean is true, collate output, otherwise
     do not.  Print copiesInteger copies of the specified string.  If
     wordWrapBoolean is true, word wrap the lines, otherwise do not.
     Left, top, right & bottom margins are specified in inches in
     aMarginsRect."

    |lines linesPerPage totalPage marginsRect firstPage abortDialog|

    jobid isNil ifTrue:[
	self startPrintJob:aTitle
    ].
    abortDialog := PrintAbortDialog new open:aTitle printer:self.
    self font:aFont.
    marginsRect := self marginsRectangleFor:aMarginsRect.
    lines := self
		asArrayOfStringLines:aString
		in:marginsRect
		wordWrap:wordWrapBoolean.
    linesPerPage := self linesPerPageFor: marginsRect.
    totalPage := (lines size + linesPerPage - 1) // linesPerPage.
    firstPage := true.

"/    collateBoolean
"/        ifTrue: [
"/            copiesInteger timesRepeat: [

    1 to:totalPage do:[:page |
	abort ifTrue:[ ^ self ].
	firstPage ifFalse:[
	    self formFeed
	].
	abortDialog
	    updatePrintingPageInfo:(self class classResources
				    string:'Page %1/%2'
				    with:page printString
				    with:totalPage printString).

"/      self device font: printerFont.

	self font:aFont.
	self
	    printPage:page
	    in:marginsRect
	    lines:lines
	    linesPerPage:linesPerPage.
	firstPage := false
    ].

"/            ]
"/        ] ifFalse: [
"/            1 to: totalPage do: [ :page |
"/                copiesInteger timesRepeat: [
"/                    abort ifTrue: [ ^self endPrintJob ].
"/                    firstPage ifFalse: [ self formFeed ].
"/                    self device font: printerFont.
"/                    self printPage: page in: marginsRect lines: lines linesPerPage: linesPerPage.
"/                    firstPage := false
"/                 ]
"/            ]
"/        ].

    jobid notNil ifTrue:[
	self endPrintJob.
	abortDialog close.
    ].

    "/    abort ifFalse: [ abortDialog close ]

    "Created: / 03-08-2006 / 16:13:33 / fm"
    "Modified: / 04-08-2006 / 13:40:02 / fm"
    "Modified: / 10-10-2006 / 18:16:54 / cg"
    "Modified: / 12-10-2006 / 11:50:37 / User"
!

print: aString
    pageHeader: aString2
    font: aFont
    title: aTitle
    collate: collateBoolean
    copies: copiesInteger
    wordWrap: wordWrapBoolean
    marginsRect: aMarginsRect

	"Private - Answer the receiver.  Output the receiver string to
	the printer using aFont.  A Print abort dialog box will be opened
	with aTitle.  If collateBoolean is true, collate output, otherwise
	do not.  Print copiesInteger copies of the specified string.  If
	wordWrapBoolean is true, word wrap the lines, otherwise do not.
	Left, top, right & bottom margins are specified in inches in
	aMarginsRect.
	Mg: Erweitert um pageHeader"
       "Changed by K3/EES5-Mg, 08.01.96"

    | lines linesPerPage totalPage marginsRect firstPage charHeight  printerFont headerLines|

    printerFont := self setPrinterFont: aFont.
    charHeight := self "pen" getCharHeight.
    marginsRect := self marginsRectangleFor: aMarginsRect.
    lines := self "pen" asArrayOfStringLines: aString in: marginsRect wordWrap: wordWrapBoolean.
    headerLines := self "pen" asArrayOfStringLines: aString2 in: marginsRect wordWrap: wordWrapBoolean.
    linesPerPage := marginsRect bottom - marginsRect top // charHeight.

    linesPerPage > headerLines size
	ifFalse:
	  [Dialog information: 'Der Dokumentenkopf ist zu groß; wird ignoriert!!'.
	   headerLines := #().
	  ]
	ifTrue: [linesPerPage := linesPerPage - headerLines size].
    totalPage := lines size + linesPerPage - 1 // linesPerPage.
    firstPage := true.

"/    collateBoolean
"/        ifTrue: [
"/            copiesInteger timesRepeat: [

		1 to: totalPage do: [ :page |
		    abort ifTrue: [ ^self endPrintJob ].
		    firstPage ifFalse: [ self formFeed ].
		    self "pen" font: aFont "printerFont".
		    self printPage: page in: marginsRect lines: lines headerLines: headerLines linesPerPage: linesPerPage.
		    firstPage := false ]

"/              ]
"/          ]
"/        ifFalse: [
"/            1 to: totalPage do: [ :page |
"/                copiesInteger timesRepeat: [
"/                    abort ifTrue: [ ^self endPrintJob ].
"/                    firstPage ifFalse: [ self formFeed ].
"/                    self "pen" font: printerFont.
"/                    self printPage: page in: marginsRect lines: lines headerLines: headerLines linesPerPage: linesPerPage.
"/                    firstPage := false ] ] ].

    "Created: / 30-11-2006 / 13:19:06 / User"
!

print:aString pageHeader:aString2 font:aFont title:aTitle wordWrap:wordWrapBoolean marginsRect:aMarginsRect
    "Private - Answer the receiver.  Output the receiver string to
     the printer using aFont.  A Print abort dialog box will be opened
     with aTitle.  If collateBoolean is true, collate output, otherwise
     do not.  Print copiesInteger copies of the specified string.  If
     wordWrapBoolean is true, word wrap the lines, otherwise do not.
     Left, top, right & bottom margins are specified in inches in
     aMarginsRect."

    |lines linesPerPage totalPage marginsRect firstPage charHeight printerFont headerLines|

    self font:aFont.
    charHeight := self getCharHeight.
    marginsRect := self marginsRectangleFor:aMarginsRect.
    lines := self
		asArrayOfStringLines:aString
		in:marginsRect
		wordWrap:wordWrapBoolean.
    headerLines := self
		asArrayOfStringLines:aString2
		in:marginsRect
		wordWrap:wordWrapBoolean.
    linesPerPage := (marginsRect bottom - marginsRect top) // charHeight.
    linesPerPage > headerLines size ifFalse:[
	Dialog information:(self class classResources
				string:'The header is too large - ignored!!').
	headerLines := #().
    ] ifTrue:[
	linesPerPage := linesPerPage - headerLines size
    ].
    totalPage := (lines size + linesPerPage - 1) // linesPerPage.
    firstPage := true.

"/    collateBoolean
"/        ifTrue: [
"/            copiesInteger timesRepeat: [

    1 to:totalPage do:[:page |
	abort ifTrue:[ ^ self ].
	firstPage ifFalse:[
	    self formFeed
	].
	self font:printerFont.
	self
	    printPage:page
	    in:marginsRect
	    lines:lines
	    headerLines:headerLines
	    linesPerPage:linesPerPage.
	firstPage := false
    ]

    "/            ]
    "/        ] ifFalse: [
    "/            1 to: totalPage do: [ :page |
    "/                copiesInteger timesRepeat: [
    "/                    abort ifTrue: [ ^self endPrintJob ].
    "/                    firstPage ifFalse: [ self formFeed ].
    "/                    self device font: printerFont.
    "/                    self printPage: page in: marginsRect lines: lines headerLines: headerLines linesPerPage: linesPerPage.
    "/                    firstPage := false
    "/                ]
    "/            ]
    "/        ].

    "Created: / 03-08-2006 / 16:14:10 / fm"
    "Modified: / 10-10-2006 / 18:18:03 / cg"
! !

!PrinterContext methodsFor:'printing process'!

endPage
    "Informs device that we are finished writing to a page."

    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:47:31 / cg"
!

endPrintJob
    "End the print job.  Everything drawn between startPrintJob
     and endPrintJob will become one entry in the print queue.
     Close and clean the device context of the receiver"

    self endPrintJobWithoutRelease.
    self releaseDC.

    "Modified: / 16-04-2007 / 12:47:28 / cg"
!

endPrintJobWithoutRelease
    "End the print job.  Everything drawn between startPrintJob
     and endPrintJob will become one entry in the print queue.
     Won't close the DC "

    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:47:28 / cg"
!

formFeed
    "Send a form feed to the printer."

    self
	endPage;
	startPage

    "Created: / 27-07-2006 / 18:25:40 / fm"
    "Modified: / 10-10-2006 / 18:15:07 / cg"
!

startPage
    "Starts a page."

    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:47:13 / cg"
!

startPrintJob
    "Start a print job.  Everything drawn between startPrintJob
     and endPrintJob will become one entry in the print queue."

    self startPrintJob:nil

    "Created: / 27-07-2006 / 18:18:52 / fm"
    "Modified: / 10-10-2006 / 18:19:05 / cg"
!

startPrintJob:aString
    "Start a print job, using aString as the job title; everything
     drawn between startPrintJob and endPrintJob will become
     one entry in the print queue."

    ^ self startPrintJob:aString fileName:nil

    "Created: / 27-07-2006 / 18:19:09 / fm"
    "Modified: / 10-10-2006 / 18:19:12 / cg"
!

startPrintJob:aString fileName:aFileName
    "Start a print job, using aString as the job title; everything
     drawn between startPrintJob and endPrintJob will become
     one entry in the print queue."

    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:46:58 / cg"
! !

!PrinterContext methodsFor:'queries'!

supportsColor
    ^ false.

    "Modified: / 16-04-2007 / 12:44:19 / cg"
!

supportsGraphics
    ^ false

    "Modified: / 16-04-2007 / 12:44:29 / cg"
! !

!PrinterContext methodsFor:'testing'!

isPrinterContext

    ^true
! !

!PrinterContext methodsFor:'text printing'!

asArrayOfStringLines:aString in:aRectangle wordWrap:wordWrapBoolean
    "Private - convert aString into an array of lines; if wordWrapBoolean
     is true, also perform word wrapping on the lines, within aRectangle."

    |line lines stream x0 x1 partialLine leftMargin rightMargin partialLineWidth index|

    stream := ReadStream on:aString.
    lines := OrderedCollection new.
    wordWrapBoolean ifTrue:[
	leftMargin := aRectangle left.
	rightMargin := aRectangle right
    ].
    [ stream atEnd ] whileFalse:[
	line := stream nextLine.
	wordWrapBoolean ifFalse:[
	    lines add:line
	] ifTrue:[
	    x0 := x1 := 1.
	    1 to:line size do:[:i |
		((line at:i) = Character space "32"
		    and:[ (partialLine := line copyFrom:x0 to:i) trimBlanks notEmpty ])
			ifTrue:[
			    partialLineWidth := self stringWidthOf:partialLine.
			    (leftMargin + partialLineWidth) > rightMargin ifTrue:[
				partialLine := line copyFrom:x0 to:x1.
				lines add:partialLine.
				x0 := x1 + 1
			    ] ifFalse:[ x1 := i ]
			].
		index := i
	    ].
	    line isEmpty ifTrue:[
		lines add:line
	    ] ifFalse:[
		partialLine := line copyFrom:x0 to:index.
		partialLineWidth := self stringWidthOf:partialLine.
		(leftMargin + partialLineWidth) > rightMargin ifTrue:[
		    partialLine := line copyFrom:x0 to:x1.
		    lines add:partialLine.
		    partialLine := line copyFrom:x1 + 1 to:index
		].
		lines add:partialLine
	    ]
	]
    ].
    ^ lines asArray

    "Created: / 02-08-2006 / 17:56:51 / fm"
    "Modified: / 04-08-2006 / 13:39:50 / fm"
    "Modified: / 10-10-2006 / 18:14:00 / cg"
!

displayString:aString at:aPoint in:aRect options:ignoredForNow adx:unknownForNow
    |x y|
    x := aPoint x.
    y := aPoint y.
    (textAlign isNil or:[textAlign == 0 ]) ifTrue:[
	self displayString:aString at:aPoint.
	^ self
    ].
    (textAlign == 8 "TaBottom") ifTrue:[
	y := aPoint y - (self container font ascent) "container font ascent".
    ] ifFalse:[ (textAlign == 6 "TaCenter") ifTrue:[
"/        x := aRect left + ((aRect width-(container font widthOf:aString))//2).
    ] ifFalse:[ (textAlign == 2 "TaRight") ifTrue:[
	x := aRect right - (self "container font widthof:" stringWidthOf:aString).
"/        y := self "container font ascent" getCharHeight + aPoint y .
    ] ifFalse:[ (textAlign == 14 "TaCenterBottom") ifTrue:[
	y := aRect bottom - self getCharHeight "container font ascent".
	x := aRect left + ((aRect width-(self "container font widthOf:" stringWidthOf:aString))//2).
    ] ifFalse:[ (textAlign == 10) ifTrue:[
	x := aRect right - (self "container font widthof:" stringWidthOf:aString).
	y := aPoint y - (self container font ascent)"aRect bottom - self getCharHeight".
    ]]]]].

"/aString = '3' ifTrue:[
"/self halt.
"/    Transcript showCR: 'Original Pos: ', aPoint x printString, '@', aPoint y printString,
"/                       ' Pos: ', x printString, '@', y printString,
"/                       ' Text: ', aString,
"/                       ' Align: ', textAlign printString.
"/    self displayString:aString at:(aPoint x@ aPoint y).
"/].

    self displayString:aString at:(x@y).

    "Modified: / 14-12-2006 / 12:29:13 / User"
!

displayStringLines:anIndexedCollection from:startIndex to:endIndex in:aRectangle
    "Private - display Strings in anIndexedCollection starting at startIndex and
     ending at endIndex, clipped within the bounds of aRectangle."

    |charHeight ascent|

    charHeight := self getCharHeight.
    ascent := self font ascentOn:self device.
    startIndex to:endIndex do:[:i |
	|lineToPrint|

	lineToPrint := (anIndexedCollection at:i).
        device 
	    displayString:lineToPrint
	    from:1
	    to:lineToPrint size
	    x:aRectangle left
	    y:(aRectangle top + ((i - startIndex) * charHeight))
	    in:nil
	    with:self gcId
	    opaque:false
	    fontAscent:ascent.
    ].

    "/    region := self setClipRect: aRectangle.
    "/    ta := self getTextAlign.
    "/    self setTextAlign: TaTop.
    "/    startIndex to: endIndex do: [ :i |
    "/        self
    "/            displayText: ( anIndexedCollection at: i )
    "/            at: aRectangle left @ ( aRectangle top + ( i - startIndex * charHeight ) ) ].
    "/    self setTextAlign: ta.
    "/    self destroyRegion: region

    "Created: / 03-08-2006 / 11:37:52 / fm"
    "Modified: / 03-08-2006 / 12:38:43 / fm"
    "Modified: / 10-10-2006 / 18:14:36 / cg"
!

displayStringLines:anIndexedCollection in:aRectangle
    "Private - display anIndexedCollection of Strings clipped within
     the bounds of aRectangle."

    self
	displayStringLines:anIndexedCollection
	from:1
	to:anIndexedCollection size
	in:aRectangle

    "Created: / 03-08-2006 / 16:03:07 / fm"
    "Modified: / 10-10-2006 / 18:14:40 / cg"
!

displayText: aString at: aPoint
    self displayString:aString x:aPoint x y:aPoint y

    "Modified: / 16-04-2007 / 12:44:43 / cg"
!

linesPerPageFor: aRectangle
    |marginsRect charHeight|

    marginsRect := aRectangle isNil
	ifTrue:[self marginsRectangleFor: nil]
	ifFalse:[aRectangle].

    charHeight := self getCharHeight.
    ^(marginsRect bottom - marginsRect top) // charHeight

    "Created: / 12-10-2006 / 11:52:57 / User"
    "Modified: / 16-04-2007 / 12:44:56 / cg"
!

marginsRectangleFor:aRectangle
    "Private - Answer a Rectangle defining margins based on aRectangle.
     Units for aRectangle are in inches, returned margins rectangle is
     in device units (pixels)."

    |left top right bottom pixelsPerInchX pixelsPerInchY horzRes vertRes inset rectangle|

    pixelsPerInchX := self pixelsPerInchOfScreenWidth.
    pixelsPerInchX == 0 ifTrue:[self halt:'invalid definitions for screen resolution'].
    pixelsPerInchY := self pixelsPerInchOfScreenHeight.
    pixelsPerInchY == 0 ifTrue:[self halt:'invalid definitions for screen resolution'].

    aRectangle isNil ifTrue:[
	horzRes := self printerWidthArea.
	vertRes := self printerHeightArea.
	inset := self class defaultMargins.
	left := (inset x * pixelsPerInchX) asInteger.
	top := (inset y * pixelsPerInchY) asInteger.
	right := horzRes - (inset x * pixelsPerInchX) asInteger.
	bottom := vertRes - (inset y * pixelsPerInchY) asInteger
    ] ifFalse:[
	left := (aRectangle left * pixelsPerInchX) asInteger.
	top := (aRectangle top * pixelsPerInchY) asInteger.
	right := (aRectangle right * pixelsPerInchX) asInteger.
	bottom := (aRectangle bottom * pixelsPerInchY) asInteger
    ].
    rectangle := left @ top corner:right @ bottom.
    ^ rectangle

    "Created: / 27-07-2006 / 18:22:57 / fm"
    "Modified: / 04-08-2006 / 13:39:45 / fm"
    "Modified: / 16-04-2007 / 11:57:21 / cg"
!

printPage:pageIndex in:aRectangle lines:lines headerLines:headerLines linesPerPage:linesPerPage
    "Private - print page # pageIndex from lines, assuming
     the given number of linesPerPage."

    |firstLine lastLine l indexString p cHeight rect hLines|

    firstLine := (pageIndex - 1) * linesPerPage + 1.
    lastLine := (firstLine + linesPerPage - 1) min:lines size.
    rect := aRectangle deepCopy.
    hLines := headerLines deepCopy.
    headerLines size > 0 ifTrue:[
	l := hLines first.
	p := l indexOfSubCollection: "indexOfString:"'#P'.
	p = 0 ifFalse:[
	    indexString := pageIndex printString , ' '.
	    l := (l copyFrom:1 to:p - 1) , indexString , (l copyFrom:p + 2 to:l size).
	    hLines at:1 put:l.
	].
	cHeight := self getCharHeight.
	rect top:rect top + (hLines size * cHeight).
    ].
    self displayStringLines:hLines in:aRectangle.
    self
	displayStringLines:lines
	from:firstLine
	to:lastLine
	in:rect.

    "Created: / 27-07-2006 / 18:28:00 / fm"
    "Modified: / 03-08-2006 / 16:03:15 / fm"
    "Modified: / 10-10-2006 / 18:18:15 / cg"
    "Modified: / 30-11-2006 / 13:34:44 / User"
!

printPage:pageIndex in:aRectangle lines:lines linesPerPage:linesPerPage
    "Private - print page # pageIndex from lines, assuming
     the given number of linesPerPage."

    |firstLine lastLine|

    firstLine := (pageIndex - 1) * linesPerPage + 1.
    lastLine := (firstLine + linesPerPage - 1) min:lines size.
    self
	displayStringLines:lines
	from:firstLine
	to:lastLine
	in:aRectangle

    "Created: / 27-07-2006 / 18:24:59 / fm"
    "Modified: / 03-08-2006 / 12:47:24 / fm"
    "Modified: / 10-10-2006 / 18:18:22 / cg"
!

stringWidthOf:aString
    "Return the width of aString
     when written using the current font."

    ^ self stringWidthOf:aString at:aString size.

    "Modified: / 03-08-2006 / 10:18:23 / fm"
    "Modified: / 10-10-2006 / 18:20:08 / cg"
!

stringWidthOf:aString at:index
    "Return the width of aString up to index
     when written using the current font; expand tabs out
     to 4 spaces for calculations"

    self subclassResponsibility

    "Modified: / 16-04-2007 / 12:45:42 / cg"
!

withLineStyle:aSymbol lineWidth:lw paint:paintColor do:aBlock
    |savStyle savWidth savPaint|

    savStyle := self lineStyle.
    savWidth := self lineWidth.
    savPaint := self paint.

    self lineStyle:aSymbol.
    self lineWidth:lw.
    self paint:paintColor.
    aBlock value.
    self paint:savPaint.
    self lineWidth:savWidth.
    self lineStyle:savStyle.

    "Created: / 13-09-2006 / 15:38:56 / User"
! !

!PrinterContext class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

