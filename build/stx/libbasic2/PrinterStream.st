"
 COPYRIGHT (c) 1990 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#PrinterStream
	instanceVariableNames:'stream native pageFormat underline strikeout'
	classVariableNames:'DefaultPageFormat'
	poolDictionaries:''
	category:'Interface-Printing'
!

PrinterStream class instanceVariableNames:'PrintCommand PrintFilename DefaultCommands PageFormat DefaultPageFormats
	Landscape PrintDevice DefaultDevices'

"
 No other class instance variables are inherited by this class.
"
!

!PrinterStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    a stream for printing; this (concrete or abstract) class can handle only
    very dumb printers. 
    No attributes (italic, bold etc) and no multiple fonts are supported 
    - just plain single font text printing.

    More intelligence is added by subclasses (see PostscriptPrinterStream among others.)

    These classes do not support graphics printing - they are only for text; 
    although some limited font functionality (such as bold or italic printing)
    may be supported by some subclasses.


    [usage:]

    The concrete printer class is bound to the global variable Printer,
    which is either set to PrinterStream (for dumb printers) or to one of
    the subclasses (PostscriptPrinterStream etc.).

    To print:

        |p|

        p := Printer new.
        p notNil ifTrue:[
            p nextPutAll:'hello world'; cr.
            p nextPutAll:' ...'; cr.
            p close
        ].

    See users of the Printer global variable for more examples.

    [class variables:]
        PrintCommand    <String>        UNIX only: the operatingSystem command for printing.
                                        Usually something like 'lp' or 'lpr'

        PrintDevice     <String>        VMS only: the printers device.
                                        Usually something like 'sys$print:'

    [author:]
        Claus Gittinger
"
! !

!PrinterStream class methodsFor:'initialization'!

initialize
    "this is usually redefined by the startup-file"

    "/ self initializePrintParameters  -- now done lazily
!

initializePrintParameters
    "this is usually redefined by the startup-file"

    OperatingSystem isUNIXlike ifTrue:[
        DefaultCommands isNil ifTrue:[
            DefaultCommands := #(
                                 'lpr' 
                                 'lpr -P<your-printer>' 
                                 'rsh <printHost> lpr -h' 
                                 'cat >preview.ps ; gv preview.ps'
                                 'cat >printfile'
                                 'gs -q -DNOPAUSE -sDEVICE=pdfwrite -sOutputFile=/tmp/preview.pdf -'
                                 'a2ps'
                                 'a2ps | rsh <printHost> lpr -h' 
                                 'a2ps >printfile' 
                                ).
        ].

        PrintCommand isNil ifTrue:[
            (OperatingSystem canExecuteCommand:'lpr') ifTrue:[
                PrintCommand := 'lpr'
            ] ifFalse:[
                PrintCommand := 'lp'
            ]
        ]
    ].
    OperatingSystem isVMSlike ifTrue:[
        DefaultDevices isNil ifTrue:[
            DefaultDevices := #(
                                 'sys$print:'
                                ).
        ].

        PrintDevice isNil ifTrue:[
            PrintDevice := 'sys$print:'
        ]
    ].

    DefaultPageFormats isNil ifTrue:[
        "/ UnitConverter must support all of them.
        self defaultPageFormats:#(
                                    a3
                                    a4
                                    a5
                                    a6
                                    b5
                                    letter
                                    legal
                                    ledger
                               ).
    ].

    Landscape isNil ifTrue:[
        Landscape := false
    ].

    PageFormat isNil ifTrue:[
        Smalltalk language == #us ifTrue:[
            PageFormat := #letter
        ] ifFalse:[
            PageFormat := #a4
        ]
    ]

    "
     DefaultPageFormats := nil.
     DefaultCommands := nil.
     PrintCommand := nil.
     PrinterStream initialize
    "

    "Modified: 4.6.1996 / 17:16:32 / cg"
!

reInitPage
    "nothing done here"

    "Created: 1.6.1996 / 00:49:40 / cg"
! !

!PrinterStream class methodsFor:'instance creation'!

new
    "return a new stream for printing.
     If printFilename is nonNil, printOut goes into that file.
     otherwise, it is piped through the printCommand OS-command."

    ^ self newForFile:(self printFilename) native:false.
!

newForFile:aFileNameOrNil
    "return a new stream for printing into aFileName"

    ^ self newForFile:aFileNameOrNil native:false

    "
     |p|

     p := PostscriptPrinterStream newForFile:'/tmp/out.ps'.
     True printOutOn:p.
     p close.
    "
!

newForFile:aFileNameOrNil native:nativePrinting
    "return a new stream for printing into aFileName"

    |str printer|

    printer := self basicNew initialize.

    aFileNameOrNil notNil ifTrue:[
        str := aFileNameOrNil asFilename writeStream.
        printer stream:str.
    ].
    nativePrinting ifTrue:[
        printer setNative
    ].
    printer startPrint.
    ^ printer

    "
     |p|

     p := PostscriptPrinterStream newForFile:'/tmp/out.ps'.
     True printOutOn:p.
     p close.
    "
!

newNative
    "return a new stream for untranslated printing
     (i.e. text should be sent via nextPutUntranslated in the printers native format).
     For example, this is used with PostScriptPrinterStream,
     if the application generates postscript."

    ^ self newForFile:(self printFilename) native:true.
! !

!PrinterStream class methodsFor:'accessing-defaults'!

bottomMargin
    "return the bottomMargin (in inches). Here, no margin is supported,
     but its redefined in some printer classes"

    ^ 0

    "Created: 5.9.1996 / 21:37:49 / cg"
!

defaultCommands
    "UNIX only: 
     return a list presented as possible commands for printing
     (in the launchers printer configuration).
     This list can be set from the startup script with:
        PrinterStream defaultCommands:#( ... )"

    DefaultCommands isNil ifTrue:[
        self == PrinterStream ifFalse:[
            ^ self superclass defaultCommands
        ].
        self initializePrintParameters
    ].
    ^ DefaultCommands

    "Created: 23.4.1996 / 18:25:18 / cg"
!

defaultCommands:collectionOfCommandStrings
    "UNIX only: 
     set the list which will be presented as possible commands for printing.
     (shown in in the launchers printer configuration).
     This can be done from the startup script with:
        PrinterStream defaultCommands:#( ... )"

    DefaultCommands := collectionOfCommandStrings

    "Created: 23.4.1996 / 18:26:06 / cg"
!

defaultDevices
    "VMS only: 
     return a list presented as possible devices for printers.
     (in the launchers printer configuration).
     This list can be set from the startup script with:
        PrinterStream defaultDevices:#( ... )"

    DefaultDevices isNil ifTrue:[
        self == PrinterStream ifFalse:[
            ^ self superclass defaultDevices
        ].
        self initializePrintParameters
    ].
    ^ DefaultDevices
!

defaultDevices:collectionOfDeviceNameStrings
    "VMS only:
     set the list which will be presented as possible devices for printing.
     (shown in in the launchers printer configuration).
     This can be done from the startup script with:
        PrinterStream defaultDevices:#( ... )"

    DefaultDevices := collectionOfDeviceNameStrings
!

defaultPageFormats
    "return a list of supported page formats.
     This list can be set from the startup script with:
        PrinterStream defaultPageFormats:#( ... )"

    DefaultPageFormats isNil ifTrue:[
        self == PrinterStream ifFalse:[
            ^ self superclass defaultPageFormats
        ].
        self initializePrintParameters
    ].
    ^ DefaultPageFormats

    "Created: 23.4.1996 / 18:25:18 / cg"
    "Modified: 11.9.1996 / 11:17:44 / stefan"
!

defaultPageFormats:aList
    "set the list of supported page formats.
     (shown in in the launchers printer configuration).
     This list can be set from the startup script with:
        PrinterStream defaultPageFormats:#( ... ).
     All symbols must be known by UnitConverter"

    DefaultPageFormats := aList.

    "/ validate the list
    aList do:[:name |
        |unit ok|

        ok := true.
        #('W' 'H' 'lW' 'lH') do:[:what |
            unit := (name , what) asSymbolIfInterned.
            (unit isNil 
            or:[(UnitConverter convert:1 from:unit to:#millimeter) isNil]) ifTrue:[
                ok := false
            ]
        ].
        ok ifFalse:[
            ('PRINTER: UnitConverter has no size-info for ''' , name , '''-format') errorPrintCR
        ]
    ].

    "
     PrinterStream
        defaultPageFormats:#(
                                'letter'
                                'a4'
                                'a5'
                                'a6'
                            )
    "

    "Created: 23.4.1996 / 18:25:18 / cg"
    "Modified: 11.9.1996 / 11:19:01 / stefan"
!

defaultPrinter
    OperatingSystem isMSWINDOWSlike ifTrue:[
        WinPrinterStream notNil ifTrue:[
            ^ WinPrinterStream
        ].
    ].

    ^ PrinterStream

    "
     self defaultPrinter
    "

    "Created: / 25-10-2006 / 17:36:21 / cg"
!

landscape
    "return the landscape setting"

    Landscape isNil ifTrue:[
        self == PrinterStream ifFalse:[
            ^ self superclass landscape
        ].
        self initializePrintParameters
    ].
    ^ Landscape
!

landscape:aBoolean
    "set/clear landscape printing"

    Landscape := aBoolean.
    self reInitPage.

    "Modified: 1.6.1996 / 00:49:22 / cg"
!

leftMargin
    "return the leftMargin (in inches). Here, no margin is supported,
     but its redefined in some printer classes"

    ^ 0

    "Created: 5.9.1996 / 21:37:49 / cg"
    "Modified: 5.9.1996 / 21:39:55 / cg"
!

pageFormat
    "return a symbol describing the default page format.
     This can be set from the startup script with:
        PrinterStream pageFormat:#...
     or via the launchers settings menu."

    PageFormat isNil ifTrue:[
        self == PrinterStream ifFalse:[
            ^ self superclass pageFormat
        ].
        self initializePrintParameters
    ].
    ^ PageFormat

    "Created: 23.4.1996 / 18:25:18 / cg"
    "Modified: 11.9.1996 / 11:16:51 / stefan"
!

pageFormat:aSymbol
    "set the default page format to be aSymbol.
     Valid symbols are #letter, #a4, #a5 etc.
     The UnitConverter must contain width/height information on
     that symbol, in order for printing to be correct.
    "

    PageFormat := aSymbol.
    self reInitPage.

    "Created: 23.4.1996 / 18:25:18 / cg"
    "Modified: 1.6.1996 / 00:49:06 / cg"
    "Modified: 11.9.1996 / 11:16:04 / stefan"
!

printCommand
    "UNIX only: 
     return the command used for printing (usually 'lp' or 'lpr').
     This is either set from the startup file, or via the launchers
     settings menu."

    PrintCommand isNil ifTrue:[
        self ~~ PrinterStream ifTrue:[  
            ^ self superclass printCommand
        ].
        self initializePrintParameters.
    ].
    ^ PrintCommand

    "Modified: 18.5.1996 / 09:12:35 / cg"
!

printCommand:aString
    "UNIX only:
     set the command for printing (usually 'lp' or 'lpr').
     This is either set from the startup file, or via the launchers
     settings menu."

    PrintCommand := aString

    "
     PrinterStream printCommand:'lpr'
     PrinterStream printCommand:'lpr -h'
     PrinterStream printCommand:'rsh ibm lpr -h'
     PrinterStream printCommand:'gs -sDEVICE=djet500 -sOutputFile=/tmp/stx.ps -sPAPERSIZE=a4 -q -; cat /tmp/stx.ps | rsh ibm lpr -h'
    "

    "Modified: 18.5.1996 / 09:12:48 / cg"
!

printDevice
    "VMS only: return the device for printing (usually 'sys$print:')
     This is either set from the startup file, or via the launchers
     settings menu."

    PrintDevice isNil ifTrue:[
        self ~~ PrinterStream ifTrue:[
            ^ self superclass printDevice
        ].
        self initializePrintParameters.
    ].
    ^ PrintDevice
!

printDevice:aString
    "VMS only:
     set the device for printing (usually 'sys$print:').
     This is either set from the startup file, or via the launchers
     settings menu."

    PrintCommand := aString

    "
     PrinterStream printDevice:'lta1739:'
    "
!

printFilename
    "UNIX only: 
     return the file into which the print-document should be generated.
     If nil (the default), printOut is piped through printCommand, 
     which is usually a variant of the lpr-command."

    ^ PrintFilename

    "
     PrinterStream printFilename
     Printer printFilename 
    "
!

printFilename:aString
    "UNIX only:
     set the output file for printing. If non nil, printout goes into that file.
     If nil, it is piped through printCommand.
     This is either set from the startup file, or via the launcher's settings menu."

    PrintFilename := aString

    "
     PrinterStream printFilename:'/tmp/out.ps'
    "
!

rightMargin
    "return the rightMargin (in inches). Here, no margin is supported,
     but its redefined in some printer classes"

    ^ 0

    "Modified: 5.9.1996 / 21:39:55 / cg"
    "Created: 6.11.1996 / 15:40:12 / cg"
!

topMargin
    "return the topMargin (in inches). Here, no margin is supported,
     but its redefined in some printer classes"

    ^ 0

    "Created: 5.9.1996 / 21:40:13 / cg"
! !

!PrinterStream class methodsFor:'queries'!

isDrivenByCommand
    "return true if this printer is driven via an OS-command
     (as opposed to writing a file or using a native printing API)"

    ^ true

    "Created: / 10-10-2006 / 18:12:47 / cg"
!

printerTypeName
    "return a descriptive name"

    ^ 'Dumb Printer (or Filter Program)'
"/    ^ 'dumb printer (or print filter)'

    "Modified: / 08-11-2007 / 12:09:16 / cg"
!

supportsColor
    "return true if this is a color printer"

    ^ false

    "Created: 3.6.1996 / 18:00:36 / cg"
!

supportsContext
    "return true if this printer supports a graphicContext (fonts, colors etc.)"

    ^ false

    "Created: / 31-01-2012 / 18:16:08 / cg"
!

supportsGreyscale
    ^ false
!

supportsMargins
    "return true if this printer supports margin settings (in inches)
     if not, it supports at least a leftMargin to be specified in columns."

    ^ false

    "Created: 3.6.1996 / 10:47:54 / cg"
    "Modified: 3.6.1996 / 18:24:20 / cg"
!

supportsPageSizes
    "return true if this printer supports different page sizes"

    ^ false

    "Created: 31.5.1996 / 22:35:26 / cg"
!

supportsPostscript
    "return true if this is a postscript printer"

    ^ false

    "Created: 10.2.1996 / 16:23:07 / cg"
!

supportsPrintingToCommand
    ^ true
!

supportsPrintingToFile
    ^ true

    "Created: / 10-10-2006 / 18:27:10 / cg"
! !

!PrinterStream methodsFor:'emphasis'!

bold
    "set emphasis to bold
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Modified: 18.5.1996 / 08:55:10 / cg"
!

boldItalic
    "set emphasis to boldItalic
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Created: 14.5.1996 / 18:53:43 / cg"
    "Modified: 18.5.1996 / 08:55:14 / cg"
!

emphasis:anEmphasis
    "change the emphasis"

    |b i|

    (Text emphasis:anEmphasis includes:#underline) ifTrue:[
        underline ifFalse:[
            self underline
        ]
    ] ifFalse:[
        underline ifTrue:[
            self noUnderline
        ]
    ].

    (Text emphasis:anEmphasis includes:#strikeout) ifTrue:[
        strikeout ifFalse:[
            self strikeout
        ]
    ] ifFalse:[
        strikeout ifTrue:[
            self noStrikeout
        ]
    ].

    b := (Text emphasis:anEmphasis includes:#bold).
    i := (Text emphasis:anEmphasis includes:#italic).

    b ifTrue:[
        i ifTrue:[
            ^ self boldItalic
        ] ifFalse:[
            ^ self bold
        ]
    ] ifFalse:[
        i ifTrue:[
            ^ self italic
        ]
    ].

    ^ self normal

    "Modified: 8.6.1996 / 08:15:00 / cg"
!

italic
    "set emphasis to italic
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Modified: 18.5.1996 / 08:55:18 / cg"
!

normal
    "set emphasis to normal (non-bold, non-italic)
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Modified: 18.5.1996 / 08:55:21 / cg"
!

strikeout
    "set emphasis to strikeout
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Modified: 18.5.1996 / 08:55:10 / cg"
    "Created: 18.5.1996 / 08:56:13 / cg"
!

underline
    "set emphasis to underline
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Modified: 18.5.1996 / 08:55:10 / cg"
    "Created: 18.5.1996 / 08:56:24 / cg"
! !

!PrinterStream methodsFor:'emphasis change'!

noStrikeout
    "set emphasis to no strikeout
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Modified: 18.5.1996 / 08:55:10 / cg"
    "Created: 8.6.1996 / 08:15:20 / cg"
!

noUnderline
    "set emphasis to no underline
     - ignore here, since this class does not know anything about the printer"

    ^ self

    "Modified: 18.5.1996 / 08:55:10 / cg"
    "Created: 8.6.1996 / 08:15:12 / cg"
! !

!PrinterStream methodsFor:'font change'!

courier
    "set font to courier 
     - ignore here, since this class does not know anything about the printer"

    ^ self
!

helvetica
    "set font to helvetic
     - ignore here, since this class does not know anything about the printer"

    ^ self
!

times
    "set font to times 
     - ignore here, since this class does not know anything about the printer"

    ^ self
! !

!PrinterStream methodsFor:'helpers writing'!

escape:aCharacter
    "since its so common, this method sends escape followed by aCharacter"

    stream nextPut:(Character esc); nextPut:aCharacter
!

escapeAll:aString
    "since its so common, this method sends escape followed by aString"

    stream nextPut:(Character esc); nextPutAll:aString
! !

!PrinterStream methodsFor:'initialization'!

initialize
    native := false.
    pageFormat := DefaultPageFormat.

    "Created: 31.5.1996 / 20:14:36 / cg"
!

printCommand
    ^ self class printCommand
!

printJobName:aString
    "ignored here - some subclass might implement this"

    "Created: / 10-10-2006 / 18:52:29 / cg"
!

stream:aStream
    stream notNil ifTrue:[
        self error
    ].
    stream := aStream.
! !

!PrinterStream methodsFor:'open & close'!

basicClose
    stream close
!

close
    self endPrint.
    stream notNil ifTrue:[ stream close ]

    "Modified: / 12-10-2006 / 14:58:43 / User"
!

endPrint
    ^ self
!

setNative
    self setNative:true

!

setNative:aBoolean
    native := aBoolean

    "Created: 30.5.1996 / 17:49:09 / cg"
!

startPrint
    stream isNil ifTrue:[
        stream := PipeStream basicNew.

        stream
            openPipeFor:(self class printCommand) 
            withMode:'w' 
            errorDisposition:#stderr 
            inDirectory:nil.
    ].

    "Modified: / 26.5.1999 / 16:14:57 / cg"
! !

!PrinterStream methodsFor:'queries'!

bottomMargin
    ^ self class bottomMargin

    "Modified: 3.6.1996 / 10:27:45 / cg"
    "Created: 5.9.1996 / 21:37:26 / cg"
!

landscape
    ^ self class landscape

    "Modified: 3.6.1996 / 10:27:45 / cg"
    "Created: 5.9.1996 / 21:38:23 / cg"
!

leftMargin
    ^ self class leftMargin

    "Modified: 3.6.1996 / 10:27:45 / cg"
    "Created: 5.9.1996 / 21:38:23 / cg"
!

lineLength
    "the printer pages width (in characters)"

    ^ 80
!

pageFormat
    ^ self class pageFormat

    "Modified: 3.6.1996 / 10:27:45 / cg"
!

printerContext
    ^ nil

    "Created: / 31-01-2012 / 18:15:03 / cg"
!

rightMargin
    ^ self class rightMargin

    "Modified: 3.6.1996 / 10:27:45 / cg"
    "Created: 5.9.1996 / 21:38:23 / cg"
!

supportsColor
    "return true if this is a color printer"

    ^ self class supportsColor

    "Created: 3.6.1996 / 18:00:27 / cg"
!

supportsContext
    ^ self class supportsContext

    "Created: / 31-01-2012 / 18:15:29 / cg"
!

supportsGreyscale
    ^ self class supportsGreyscale
!

supportsMargins
    "return true if this printer supports margin settings (in inches)
     if not, it supports at least a leftMargin to be specified in columns."

    ^ self class supportsMargins

    "Created: 3.6.1996 / 17:59:35 / cg"
    "Modified: 3.6.1996 / 18:24:04 / cg"
!

supportsPostscript
    "return true if this is a postscript printer"

    ^ self class supportsPostscript

    "Created: 3.6.1996 / 17:59:58 / cg"
!

supportsPrintingToCommand
    ^ self class supportsPrintingToCommand
!

supportsPrintingToFile
    ^ self class supportsPrintingToFile
!

topMargin
    ^ self class topMargin

    "Modified: 3.6.1996 / 10:27:45 / cg"
    "Created: 5.9.1996 / 21:40:32 / cg"
! !

!PrinterStream methodsFor:'testing'!

isPrinterStream
    "return true, if this is a printerStream.
     Always true here."

    ^ true

    "Created: 3.6.1996 / 12:06:21 / cg"
! !

!PrinterStream methodsFor:'writing'!

flush
    stream flush
!

next:count put:aCharacter
    "send some character multiple times to the printer - translate as needed.
     Redefined to allow individual character translation in subclasses"

    count timesRepeat:[
        self nextPut:aCharacter
    ]

    "Created: 10.4.1996 / 13:08:13 / cg"
    "Modified: 10.4.1996 / 13:09:06 / cg"
!

nextPut:aCharacter
    "send a character to the printer"

    self nextPutUntranslated:aCharacter
!

nextPutAll:aCollection
    "send some characters to the printer - translate as needed.
     The argument, aCollection can be a Text (i.e. include emphasis)"

    native ifTrue:[
        stream nextPutAll:aCollection.
        ^ self.
    ].

    aCollection hasChangeOfEmphasis ifTrue:[
        self nextPutAllText:aCollection.
    ] ifFalse:[
        aCollection do:[:eachChar |
            self nextPut:eachChar
        ]
    ]

    "Modified: 3.6.1996 / 17:12:31 / cg"
!

nextPutAll:aCollection startingAt:first to:last
    "append the elements with index from first to last
     of the argument, aCollection onto the receiver.
     This is only allowed, if the receiver supports writing."

    aCollection from:first to:last do:[:element |
        self nextPut:element
    ].
    ^ aCollection
!

nextPutAllText:aText
    "send some characters to the printer - translate as needed.
     The argument is a String or Text (i.e. includes emphasis)"

    |lastE|

    native ifTrue:[
        stream nextPutAllText:aText.
        ^ self.
    ].

    lastE := 42.    "initialize to something that is not a valid emphasis"

    aText keysAndValuesDo:[:idx :aChar |
        |e|

        e := aText emphasisAt:idx.
        lastE ~~ e ifTrue:[
            self emphasis:e.
            lastE := e.
        ].
        self nextPut:aChar.
    ].
    self emphasis:nil.

    "Modified: 3.6.1996 / 17:12:31 / cg"
!

nextPutAllUntranslated:aCollection
    "send some raw characters to the printer - even if not in native mode"

    stream nextPutAll:aCollection

    "Modified: 10.4.1996 / 13:08:35 / cg"
!

nextPutUntranslated:aCharacter
    "send a raw character to the printer - even if not in native mode"

    stream nextPut:aCharacter

    "Modified: 10.4.1996 / 13:08:28 / cg"
! !

!PrinterStream class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


PrinterStream initialize!
