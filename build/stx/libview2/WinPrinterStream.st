"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

PrinterStream subclass:#WinPrinterStream
	instanceVariableNames:'printerContext printJobName printFileName currentLineBuffer
		currentPageBuffer cX cY colNr lineNr pageCount heightOfFont
		jobStarted pageStarted'
	classVariableNames:'PrinterInfo'
	poolDictionaries:''
	category:'Interface-Printing'
!

!WinPrinterStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!WinPrinterStream class methodsFor:'instance creation'!

new
    | printerContext |

    PrinterInfo := PrintingDialog getPrinterInfo.
    PrinterInfo isNil ifTrue:[
        "/ cancelled
        AbortSignal raiseRequest.
        ^nil
    ].

    printerContext := WinPrinterContext fromPrinterInfo: PrinterInfo.

    ^ self basicNew printerContext:printerContext.

    "Modified: / 12-10-2006 / 10:07:36 / fm"
    "Modified: / 16-04-2007 / 12:58:13 / cg"
!

newForFile:aFileNameOrNil
    "return a new stream for printing into aFileName"

    |printer|

    printer := self basicNew initialize.
    printer setPrintFileName:aFileNameOrNil.
    printer startPrint.
    ^ printer

    "Modified: / 12-10-2006 / 14:35:09 / fm"
    "Modified: / 16-04-2007 / 12:58:18 / cg"
!

newNative
    self halt:'unimplemented feature'
! !

!WinPrinterStream class methodsFor:'class initialization'!

initialize
    "in some configurations (expecco), libview2 is loaded lazy and later,
     and the printer is setup to be PrinterStream (which is stupid).
     Here, we install ourself."

    (Printer isNil or:[Printer == PrinterStream]) ifTrue:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            "don't change printer, if simply autoloading this class in linux"
            Printer := self.
        ].
    ].

    "Created: / 09-02-2011 / 13:46:27 / cg"
! !

!WinPrinterStream class methodsFor:'queries'!

isDrivenByCommand
    "return true if this printer is driven via an OS-command
     (as opposed to writing a file or using a native printing API)"

    ^ false

    "Created: / 10-10-2006 / 18:22:13 / cg"
!

printerTypeName
    "return a descriptive name"

    ^ 'Windows Printer'

    "Created: / 10-10-2006 / 18:26:22 / cg"
    "Modified: / 08-11-2007 / 12:13:59 / cg"
!

supportsContext
    ^ true

    "Created: / 31-01-2012 / 18:15:44 / cg"
!

supportsPrintingToCommand
    ^ false

    "Created: / 10-10-2006 / 18:27:16 / cg"
!

supportsPrintingToFile
    ^ false

    "Created: / 10-10-2006 / 18:27:16 / cg"
! !

!WinPrinterStream methodsFor:'accessing'!

fontWidthForTabComputing
    ^ 120

    "Created: / 12-10-2006 / 11:59:33 / fm"
    "Modified: / 16-04-2007 / 13:00:05 / cg"
!

hasJobStarted

    ^jobStarted = true

    "Created: / 12-10-2006 / 14:38:00 / fm"
    "Modified: / 16-04-2007 / 13:00:26 / cg"
!

hasPageStarted

    ^pageStarted = true

    "Created: / 12-10-2006 / 14:41:39 / fm"
    "Modified: / 16-04-2007 / 13:00:32 / cg"
!

heightOfFont

    heightOfFont isNil ifTrue:[heightOfFont := printerContext getCharHeight].
    ^heightOfFont

    "Created: / 12-10-2006 / 12:00:57 / fm"
    "Modified: / 16-04-2007 / 13:00:35 / cg"
!

linesPerPage

    ^printerContext linesPerPageFor: nil

    "Created: / 12-10-2006 / 11:57:53 / fm"
    "Modified: / 16-04-2007 / 13:00:38 / cg"
!

printerContext
    ^ printerContext

    "Created: / 31-01-2012 / 18:13:54 / cg"
!

printerContext:something
    printerContext := something.
! !

!WinPrinterStream methodsFor:'open/close'!

endPage
    printerContext endPage.
    pageStarted := false.

    "Created: / 12-10-2006 / 14:42:18 / fm"
    "Modified: / 16-04-2007 / 12:58:33 / cg"
!

endPrint
    printerContext endPrintJob.
    jobStarted := false.

    "Created: / 10-10-2006 / 18:50:05 / cg"
    "Modified: / 12-10-2006 / 14:41:11 / fm"
    "Modified: / 16-04-2007 / 12:58:36 / cg"
!

formFeed
    printerContext formFeed.
    self resetPage

    "Created: / 12-10-2006 / 10:41:40 / fm"
    "Modified: / 12-10-2006 / 14:40:53 / fm"
    "Modified: / 16-04-2007 / 13:00:21 / cg"
!

startPage
    printerContext startPage.
    pageStarted := true.
    self resetPage

    "Created: / 12-10-2006 / 14:39:27 / fm"
    "Modified: / 16-04-2007 / 13:00:58 / cg"
!

startPrint
    printerContext isNil ifTrue:[
        PrinterInfo isNil ifTrue:[
            PrinterInfo := PrintingDialog getPrinterInfo.
            PrinterInfo isNil ifTrue:[^self].
        ].
        printerContext := WinPrinterContext fromPrinterInfo: PrinterInfo.
    ].
    printerContext foreground:(Color black) background:(Color white).
    self resetPage.
    printerContext startPrintJob: (printJobName ? 'ST/X PrintJob') fileName:printFileName.
    pageCount := 1.
    jobStarted := true.
    pageStarted := true.

    "Created: / 10-10-2006 / 18:49:55 / cg"
    "Modified: / 12-10-2006 / 15:25:29 / fm"
    "Modified: / 16-04-2007 / 13:01:01 / cg"
! !

!WinPrinterStream methodsFor:'private'!

resetPage

    cX := cY := colNr := lineNr := 0.

    "Created: / 12-10-2006 / 14:40:23 / fm"
    "Modified: / 16-04-2007 / 13:00:52 / cg"
!

setPrintFileName:something
    printFileName := something.

    "Created: / 10-10-2006 / 19:07:16 / cg"
! !

!WinPrinterStream methodsFor:'writing'!

cr
    self hasJobStarted ifFalse:[self startPrint].
    self hasPageStarted ifFalse:[self startPage].

    colNr := 0.
    lineNr := lineNr + 1.
    cX := 0 "+ self leftX".
    cY := cY + self heightOfFont.
    lineNr >= self linesPerPage ifTrue:[
            pageCount := pageCount + 1.
            self endPage
    ].

    "Modified: / 12-10-2006 / 14:42:57 / fm"
    "Modified: / 16-04-2007 / 12:58:30 / cg"
!

nextPut:aCharacter

    self hasJobStarted ifFalse:[self startPrint].
    self hasPageStarted ifFalse:[self startPage].

    aCharacter codePoint < 16r20 ifTrue:[
        aCharacter == Character cr ifTrue:[
            self cr.    
        ].
        aCharacter == Character tab ifTrue:[
           colNr := ((colNr + 8) // 8) * 8. 
           cX := "self leftX +" (colNr * self fontWidthForTabComputing).
           ^ self
        ].
        aCharacter == Character newPage ifTrue:[
            self endPage. 
        ].
        ^ self.
    ].

    printerContext displayString:aCharacter asString x:cX y:cY.
    colNr := colNr + 1.
    cX := cX + (printerContext stringWidthOf: aCharacter asString).

    "Modified: / 12-10-2006 / 15:06:14 / fm"
    "Modified: / 16-04-2007 / 13:00:44 / cg"
!

nextPutAll:aString

    self hasJobStarted ifFalse:[self startPrint].
    self hasPageStarted ifFalse:[self startPage].

    (aString contains:[:char | char codePoint < 16r20]) ifTrue:[
        super nextPutAll:aString.
        ^ self.
    ].

    #TODO. "/ use aString, when problem with Text-extent is fixed... 
    printerContext displayString: aString string x:cX y:cY.
    colNr := colNr + aString size.
    cX := cX + (printerContext stringWidthOf: aString string).

    "Modified: / 12-10-2006 / 15:21:02 / fm"
    "Modified: / 16-04-2007 / 13:00:46 / cg"
! !

!WinPrinterStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/WinPrinterStream.st,v 1.13 2013-06-20 14:57:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/WinPrinterStream.st,v 1.13 2013-06-20 14:57:19 cg Exp $'
! !


WinPrinterStream initialize!
