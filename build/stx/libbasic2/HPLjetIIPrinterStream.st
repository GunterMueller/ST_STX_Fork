"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

PrinterStream subclass:#HPLjetIIPrinterStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Printing'
!

!HPLjetIIPrinterStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    This class defines protocol for simple text prinitng on an HP Laserjet 2/3
    (and compatible) printer. 
    It does not support multiple fonts, but knows how to print bold, italic etc.

    Graphics printing is not supported - you need a postscriptprinter for this.

    Notice: 
        This class only defines some minimum protocol for printing on
        HP-LJ - you really should use a PostscriptPrinter ...
        ... however, if you own a LJ, here is some class to start with.
        It may need to be enhanced at some places (for example: provide more
        fonts/emphasis's, better international character translation,
        image printing etc.)

    [Disclaimer:]    
        This class is not officially supported - take it or leave it.

    [author:]
        Claus Gittinger
"
! !

!HPLjetIIPrinterStream class methodsFor:'initialization'!

initialize
    DefaultCommands := #('lpr' 
                         'lpr -P<your-printer>' 
                         'cat | rsh <printHost> lpr -h' 
                        ).
    super initialize

    "
     self initialize
    "

! !

!HPLjetIIPrinterStream class methodsFor:'queries'!

printerTypeName
    "return a descriptive name"

    ^ 'hp laserjet III compatible printer'
! !

!HPLjetIIPrinterStream methodsFor:'access writing'!

cr
    "send a carriage-return (newLine) to the printer.
     We have to output cr-nl here"

    super nextPutUntranslated:(Character value:13).
    super nextPutUntranslated:(Character value:10).
    self spaces:self class leftMargin

    "Modified: 1.6.1996 / 00:13:42 / cg"
!

nextPut:aCharacter
    stream nextPut:aCharacter
! !

!HPLjetIIPrinterStream methodsFor:'emphasis change'!

bold
    "switch to bold emphasis"

    "send <ESC>(s0S<ESC>(s3B"

    super escapeAll:'(s0S'.
    super escapeAll:'(s3B'

    "Modified: 18.5.1996 / 09:10:39 / cg"
!

italic
    "switch to italic/oblique emphasis"

    super escapeAll:'(s1S'.
    super escapeAll:'(s0B'

    "Modified: 18.5.1996 / 09:10:44 / cg"
!

normal
    "switch to normal/roman emphasis"

    super escapeAll:'(s0S'.
    super escapeAll:'(s0B'

    "Modified: 18.5.1996 / 09:10:48 / cg"
! !

!HPLjetIIPrinterStream methodsFor:'font change'!

courier
    "switch to courier font"

    super escapeAll:'(s3T'
!

helvetica
    "switch to helvetica font"

    super escapeAll:'(s4T'
!

times
    "switch to times font"

    super escapeAll:'(s5T'
! !

!HPLjetIIPrinterStream class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


HPLjetIIPrinterStream initialize!
