"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

PrinterStream subclass:#EpsonFX1PrinterStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Printing'
!

!EpsonFX1PrinterStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    This class defines protocol for simple text printing on an Epson-FX1
    (and compatible) printer. 
    It does not support multiple fonts, but knows how to print bold, italic etc.

    Graphics printing is not supported - you need a postscriptprinter for this.

    I cannot tell, if this is really an Epson -
    all I had to test was a Citizen 120D - its documentation claims it to be 
    FX1 compatible.

    Notice: 
        This class only defines some minimum protocol for printing on
        Epsons - you really should use a PostscriptPrinter ...
        ... however, if you own an Epson, here is some class to start with.
        It may need to be enhanced at some places (for example: provide more
        fonts/emphasis's; better international character translation etc.)

    [Disclaimer:]    
        This class is not officially supported - take it or leave it.

    [author:]
        Claus Gittinger
"
! !

!EpsonFX1PrinterStream class methodsFor:'initialization'!

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

!EpsonFX1PrinterStream class methodsFor:'queries'!

printerTypeName
    "return a descriptive name"

    ^ 'Epson FX1 compatible printer'
! !

!EpsonFX1PrinterStream methodsFor:'access writing'!

cr
    "send a carriage return (newLine).
     We have to output cr-nl here"

    super nextPutUntranslated:(Character value:13).
    super nextPutUntranslated:(Character value:10).
    self spaces:self class leftMargin

    "Modified: 1.6.1996 / 00:13:39 / cg"
!

nextPut:aCharacter
    "send aCharacter to the printer.
     Catch special characters 
     - currently only german umlauts are handled - If you own this type
       of printer and depend on it, add more translation here ..."

    |ascii|

    ascii := aCharacter codePoint.
    (ascii < 128) ifTrue:[
        ^ stream nextPut:aCharacter
    ].
    (ascii == 16rfc) ifTrue:[   "udiaeresis"
        ^ self character:$} fromCharacterSet:2
    ].
    (ascii == 16re4) ifTrue:[   "adiaeresis"
        ^ self character:${ fromCharacterSet:2
    ].
    (ascii == 16rf6) ifTrue:[   "odiaeresis"
        ^ self character:$| fromCharacterSet:2
    ].
    (ascii == 16rdc) ifTrue:[   "Udiaeresis"
        ^ self character:$] fromCharacterSet:2
    ].
    (ascii == 16rc4) ifTrue:[   "Adiaeresis"
        ^ self character:$[ fromCharacterSet:2
    ].
    (ascii == 16rd6) ifTrue:[   "Odiaeresis"
        ^ self character:$\ fromCharacterSet:2
    ].
    (ascii == 16rdf) ifTrue:[   "ssharp"
        ^ self character:$~ fromCharacterSet:2
    ]

    "Modified: 18.5.1996 / 09:03:18 / cg"
! !

!EpsonFX1PrinterStream methodsFor:'emphasis change'!

bold
    "set emphasis to bold"

    "send: <ESC>G "

    super escape:$G

    "Modified: 18.5.1996 / 09:03:31 / cg"
!

italic
    "set emphasis to italic"

    "send: <ESC>4 will do that"

    super escape:$4

    "Modified: 18.5.1996 / 09:03:33 / cg"
!

normal
    "set emphasis to normal"

    "send: <ESC>H<ESC>5"

    super escape:$H. super escape:$5

    "Modified: 18.5.1996 / 09:03:35 / cg"
! !

!EpsonFX1PrinterStream methodsFor:'layout'!

linesPerPage:n
    "change the lines-per-page setting"

    "send: <ESC>C<n>"

    super escape:$C.
    super nextPut:(Character value:n)

    "Modified: 18.5.1996 / 09:03:50 / cg"
!

newPage
    "force a newPage"

    super nextPut:(Character value:12)

    "Modified: 18.5.1996 / 09:04:04 / cg"
!

noTopMargin
    "turn off topMargin in the printer"

    "send <ESC>0"

    super escape:$O

    "Modified: 18.5.1996 / 09:04:19 / cg"
!

pageHeight:inches
    "set the pageHeight in inches"

    "send <ESC>G<0><inch>"

    super escape:$C.
    super nextPut:(Character value:0).
    super nextPut:(Character value:inches)

    "Modified: 18.5.1996 / 09:04:38 / cg"
!

proportional:aBoolean
    "turn on/off proportional printing"

    "send <ESC>p0 or <ESC>p1"

    super escape:$p.
    super nextPut:(aBoolean ifTrue:[$1] ifFalse:[$0])

    "Modified: 18.5.1996 / 09:05:18 / cg"
!

reset
    "reset the printer - send <ESC>@"

    super escape:$@

    "Modified: 18.5.1996 / 09:05:27 / cg"
!

topMargin:n
    "set the topMargin"

    "send <ESC>N<n>"

    super escape:$N.
    super nextPut:(Character value:n)

    "Modified: 18.5.1996 / 09:05:43 / cg"
! !

!EpsonFX1PrinterStream methodsFor:'private'!

character:char fromCharacterSet:set
    "send a character from an alternate character set"

    "send: <ESC>R<set><char><ESC>R<0>"

    super escape:$R.
    super nextPut:(Character value:set).
    super nextPut:char.
    super escape:$R.
    super nextPut:(Character value:0)
! !

!EpsonFX1PrinterStream class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


EpsonFX1PrinterStream initialize!
