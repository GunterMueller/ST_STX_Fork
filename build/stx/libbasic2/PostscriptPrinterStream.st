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

PrinterStream subclass:#PostscriptPrinterStream
	instanceVariableNames:'xPos yPos lineStream colNr lineNr fFamily fStyle pageStartAction
		pageEndAction pageCount sendXPosition'
	classVariableNames:'Prolog Trailer PageProlog PageTrailer FontNames FontHeight
		FontWidth LeftX TopY PageHeight LinesPerPage PhysicalPageHeight
		Italic Bold Normal BoldItalic Courier Times Helvetica TopMargin
		LeftMargin BottomMargin RightMargin SupportsColor Resolution
		SupportsGreyscale'
	poolDictionaries:''
	category:'Interface-Printing'
!

!PostscriptPrinterStream class methodsFor:'documentation'!

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
    This class provides simple text output to postscript printers;
    to use it, evaluate 
        Smalltalk at:#Printer put:PostscriptPrinterStream
    (usually in some rc file) or change it via the launchers settings-menu.

    See examples on how to send something to the printer.

    For now, only Helvetica, Courier and Times fonts in italic, roman and bold are supported.

    It does not directly support graphics and other fancy features of Postscript,
    but provides a compatible interface for simple text line-printing 
    (see other subclasses of PrinterStream).

    If you already have a postscript string at hand, this can be sent to the printer in native mode.

    To output graphics, you need the PSGraphicsContext (and friend-) classes.
    These provide protocol similar to the one provided by display graphicContexts.
    PSGraphicsContext generates its own postscript - not caring for the margin/font settings
    here (these are only used if the printer-stream protocol is used (i.e. nextPut, cr etc.)

    [Disclaimer:]    
        Notice, that these postscript classes are derived from public domain code; 
        there is no warranty.

    [see also:]
        PSGraphicsContext 
        EpsonFX1PrinterStream HPLjetIIPrinterStream PrinterStream

    [author:]
        Claus Gittinger
"
!

examples
"
    For text printing, use:
                                                                        [exBegin]
        |s|

        s := Printer new.
        s nextPutAll:'hello'; cr.
        s nextPutAll:'normal '.
        s bold; nextPutAll:'this is bold'; normal; cr.
        s nextPutAll:'normal '.
        s italic; nextPutAll:'this is italic'; normal; cr.
        s nextPutAll:'normal '.
        s boldItalic; nextPutAll:'this is boldItalic'; normal; cr.
        s nextPutAll:'normal '.
        s underline; nextPutAll:'this is underlined'; noUnderline; cr.
        s nextPutAll:'normal again '.
        s strikeout; nextPutAll:'this is strikedout'; noStrikeout; cr.
        s helvetica.
        s nextPutAll:'helvetica '.
        s underline; nextPutAll:' helv-underline'; noUnderline;
          space; strikeout; nextPutAll:'helv-strikeout'; noStrikeout;
          bold; nextPutAll:' helv-bold'; normal; cr.
        s times.
        s nextPutAll:'times'; cr.
        s courier.
        s nextPutAll:'courier'; cr.
        s close
                                                                        [exEnd]
    or, if you already have emphasized text at hand:
                                                                        [exBegin]
        |s|

        s := Printer new.
        s nextPutAll:'hello'; cr.
        s nextPutAll:'this is '; 
          nextPutAll:(Text string:'bold' emphasis:#bold); 
          cr;
          nextPutAll:'this is '; 
          nextPutAll:(Text string:'italic' emphasis:#italic); 
          cr;
          nextPutAll:'this is ';
          nextPutAll:(Text string:'boldItalic' emphasis:#(bold italic)); 
          cr;
          nextPutAll:'normal again'; 
          cr;
          helvetica;
          nextPutAll:'helvetica';
          cr;
          times;
          nextPutAll:'times'; 
          cr;
          courier;
          nextPutAll:'courier';
          cr.
        s close
                                                                        [exEnd]

    placing a page-hook, to add a page number:
    (page hooks require that you understand some postscript ...
     ... and have a look at how this class generates its postscript code)
                                                                        [exBegin]
        |s hook pageNr|

        s := Printer new.

        pageNr := 0.
        hook := [ 

                    pageNr := pageNr + 1.
                    s placeString:('page ' , pageNr printString) at:(5500 @ 400).
                ].

        s pageEndAction:hook.
        (1 to:200) do:[:lineNr |
            s nextPutAll:'line ' , lineNr printString.
            s cr.
        ].
        s close.
                                                                        [exEnd]


    placing a page-hook, to add a custom frame, logo or company letter-head:
    (page hooks require that you understand some postscript ...
     ... and have a look at how this class generates its postscript code.
     ... and notice that the code below is a q&d demo, working with letter-sized
     pages only; a real program should ask the printerStream about the actual 
     pageHeight/pageWidth.)
                                                                        [exBegin]
        |s hook pageNr|

        s := Printer new.

        pageNr := 0.
        hook := [ 

                    pageNr := pageNr + 1.
                    s placeString:('page ' , pageNr printString) at:(5500 @ 400).
                    s placeString:('Document revision:') at:(900 @ 1200).
                    s placeString:('Revieved by:')       at:(900 @ 900).

                    s setNative:true.
                    s nextPutAll:'0 setlinewidth'; cr.
                    s nextPutAll:'800 800 moveto'; cr.
                    s nextPutAll:'11000 800 lineto'; cr.
                    s nextPutAll:'11000 15500 lineto'; cr.
                    s nextPutAll:'800 15500 lineto'; cr.
                    s nextPutAll:'800 800 lineto'; cr.
                    s nextPutAll:'stroke'; cr.

                    s nextPutAll:'800 1100 moveto'; cr.
                    s nextPutAll:'11000 1100 lineto'; cr.
                    s nextPutAll:'stroke'; cr.

                    s nextPutAll:'800 1400 moveto'; cr.
                    s nextPutAll:'11000 1400 lineto'; cr.
                    s nextPutAll:'stroke'; cr.

                    s setNative:false.
                ].

        s pageEndAction:hook.
        (1 to:200) do:[:lineNr |
            s nextPutAll:'line ' , lineNr printString.
            s cr.
        ].
        s close.
                                                                        [exEnd]


    If you already have a postscript string at hand, this can be sent to
    the printer in native mode:
                                                                        [exBegin]
        |s|

        s := Printer newNative.
        s nextPutAll:<your postscript string>.
                                                                        [exEnd]
        s close

    To output graphics, you need the PSGraphicsContext (and friend-) classes.
    These provide protocol similar to the one provided by display graphicContexts.
    Notice, that these postscript classes are derived from public domain code;
    there is no warranty.

    Usage:
                                                                        [exBegin]
        |drawable s|

        s := Printer newNative.
        drawable := PSGraphicsContext on:s.

        drawable displayLineFrom:(0@0) to:(100@100).
        drawable displayLineFrom:(100@0) to:(0@100).
        drawable displayCircle:(150@150) radius:50.
        (Image fromFile:'bitmaps/SBrowser.xbm') displayOn:drawable at:(50@30).

        drawable close.
                                                                        [exEnd]

      the same in a view:
                                                                        [exBegin]
        |drawable|

        drawable := (View extent:200@200) openAndWait.

        drawable displayLineFrom:(0@0) to:(100@100).
        drawable displayLineFrom:(100@0) to:(0@100).
        drawable displayCircle:(150@150) radius:50.
        (Image fromFile:'bitmaps/SBrowser.xbm') displayOn:drawable at:(50@30).
                                                                        [exEnd]
"
! !

!PostscriptPrinterStream class methodsFor:'initialization'!

initCharacterSize
    "setup the character parameters"

    FontHeight := 200.   "/ used to scale fonts - corresponds to a 10 point font size
    FontWidth := 120.    "/ used to compute width of tabs

    "Created: 23.4.1996 / 19:53:34 / cg"
    "Modified: 23.4.1996 / 20:05:17 / cg"
    "Modified: 30.5.1996 / 17:24:05 / ca"
!

initFonts
    "setup the font names.
     initProlog uses those parameters."

    Italic := 0.     "/ offset from base-font# to italic version
    Bold := 1.       "/ offset from base-font# to bold version
    BoldItalic := 2. "/ offset from base-font# to boldItalic version
    Normal := 3.     "/ offset from base-font# to normal version

    Helvetica := 0.  "/ # of helvetica base font
    Times := 4.      "/ # of times base font
    Courier := 8.    "/ # of courier base font

    FontNames := #( 
                    'Helvetica-Oblique'
                    'Helvetica-Bold'
                    'Helvetica-BoldOblique'
                    'Helvetica'
                    'Times-Italic'
                    'Times-Bold'
                    'Times-BoldItalic'
                    'Times'
                    'Courier-Oblique'
                    'Courier-Bold'
                    'Courier-BoldOblique'
                    'Courier' 
                  )

    "
     PostscriptPrinterStream initFonts
    "

!

initPage
    "setup the page parameters.
     All coordinates are scaled by 20 w.r.t the PS coordinates (i.e. in twips)."

    self pageFormat isNil ifTrue:[
        self pageFormat:#a4
    ].

    TopMargin isNil ifTrue:[
        TopMargin := 0.6.      "/ inches
    ].
    BottomMargin isNil ifTrue:[
        BottomMargin := 1.2    "/ inches
    ].
    LeftMargin isNil ifTrue:[
        LeftMargin := 0.6.     "/ inches
    ].
    RightMargin isNil ifTrue:[
        RightMargin := 0.6.    "/ inches
    ].
    Resolution isNil ifTrue:[
        Resolution := 300@300. "/ DPI
    ].

    "/     +-----------------------------------------------+  PageHeight
    "/     |                   TOPMARGIN             |     |
    "/     | LeftX +---------------------------------------|  TopY
    "/     |       |1st printed line                 |     |
    "/     |       |                                 |     |
    "/     | LEFT  |                                 |RIGHT| (only used by
    "/     | MARGIN|                                 |MARG.|  PSGraphicsContext)
    "/     |       |                                 |     |
    "/     |       |last line (linesPerPage)         |     |
    "/     |       +---------------------------------------|
    "/     |                   BOTTOMMARGIN          |     |
    "/     (0/0)-------------------------------------------+  0

    LeftX := (UnitConverter convert:LeftMargin from:#inch to:#twip) rounded.

    PhysicalPageHeight := (UnitConverter convert:1 from:(self pageFormat , 'H') to:#twip) rounded.
    self landscape == true ifTrue:[
        PageHeight := (UnitConverter convert:1 from:(self pageFormat , 'lH') to:#twip) rounded.
    ] ifFalse:[
        PageHeight := (UnitConverter convert:1 from:(self pageFormat , 'H') to:#twip) rounded.
    ].

    TopY := PageHeight - (UnitConverter convert:TopMargin from:#inch to:#twip) rounded.
    LinesPerPage := TopY - (UnitConverter convert:BottomMargin from:#inch to:#twip) rounded // 200.

    "
     TopMargin := LeftMargin := BottomMargin := nil.
     self initPage
    "

    "Modified: 30.5.1996 / 17:24:55 / ca"
    "Modified: 5.9.1996 / 21:43:00 / cg"
!

initPageProlog
    "define the page prolog"

    PageProlog :=
'StartPage
'.

    "Created: 23.4.1996 / 19:56:16 / cg"
!

initPageTrailer
    "define the page epilog"

    PageTrailer :=
'EndPage
'.

    "Modified: 23.4.1996 / 19:55:50 / cg"
    "Created: 23.4.1996 / 19:56:30 / cg"
!

initProlog
    "define the documents prolog"

    |tmpString t fontNr|

    tmpString :=
'%!!PS-Adobe-2.0
%%Creator: Smalltalk/X
%%CreationDate: ' , Timestamp now printString , '
%%DocumentFonts: '.

    FontNames do:[:aName |
        tmpString := tmpString , aName , ' '
    ].

    tmpString := tmpString , '
%%Pages: (atend)
%%EndComments

save /SmalltalkJob exch def

/OriginalState gstate def
/StartSmalltalkDoc{$smalltalk begin}def
/$smalltalk 50 dict def $smalltalk begin
/EndSmalltalkDoc{end}def

/S/show load def
/X{exch 0 rmoveto S}def
/Y{exch 0 exch rmoveto S}def
/B{3 1 roll moveto S}def
/SUL {gsave currentpoint currentfont /FontInfo get /UnderlinePosition get
 0 exch currentfont /FontMatrix get dtransform exch pop add newpath moveto
 dup stringwidth rlineto stroke grestore S} def
/SSO {gsave currentpoint 300
 0 exch currentfont /FontMatrix get dtransform exch pop add 
 newpath moveto dup stringwidth rlineto stroke grestore S} def
/BUL{3 1 roll moveto SUL}def
/BSO{3 1 roll moveto SSO}def
/F{$fd exch get setfont}def
/StartPage{/svpg save def .05 dup scale}def
/EndPage{svpg restore showpage}def
/DoPreFeed{/statusdict where{pop
 statusdict/prefeed known{statusdict exch/prefeed exch put 0}if}if pop}def
/Landscape{90 rotate 0 -' , PageHeight printString "15840", ' translate}def
/ISOrecode {findfont dup length dict begin
 {1 index /FID ne {def} {pop pop} ifelse} forall
 /Encoding ISOLatin1Encoding def
 currentdict end definefont pop} def
/SetUpFonts
 {dup/$fd exch array def{findfont exch scalefont $fd 3 1 roll put}repeat}def
/InitGaudy{/TwoColumn exch def /BarLength exch def
/ftD /ISO-Times-Bold findfont 12 UP scalefont def
/ftF /ISO-Times-Roman findfont 14 UP scalefont def
/ftP /ISO-Helvetica-Bold findfont 30 UP scalefont def}def
/U{1440 mul}def
/UP{U 72 div}def
/LB{/pts exch UP def /charcolor exch def /boxcolor exch def /font exch def
 /label exch def /dy exch def /dx exch def /lly exch def /llx exch def
 gsave boxcolor setgray
 llx lly moveto dx 0 rlineto 0 dy rlineto dx neg 0 rlineto closepath fill
 /lines label length def
 /yp lly dy add dy lines pts mul sub 2 div sub pts .85 mul sub def
 font setfont charcolor setgray
 label {dup stringwidth pop 2 div llx dx 2 div add exch sub yp moveto show
   /yp yp pts sub def}forall grestore}def
/Gaudy{/Page exch def /Date exch def /File exch def /Comment exch def
 .25 U 10.2 U BarLength .1 sub U .25 U [File] ftF .97 0 14 LB
 .25 U 10.45 U BarLength .1 sub U .25 U [Comment] ftF 1 0 14 LB
 .25 U 10.2 U 1 U .5 U Date ftD .7 0 12 LB
 BarLength .75 sub U 10.2 U 1 U .5 U [Page] ftP .7 1 30 LB
 TwoColumn{BarLength 2 div .19 add U 10.2 U moveto 0 -10 U rlineto stroke}if
}def
end
StartSmalltalkDoc 
% end of fixed prolog
'.

    t := ''.
    FontNames do:[:aName |
        t := t , '/ISO-' , aName , ' /' , aName , ' ISOrecode
'.
    ].
    t := t , '
'.
    tmpString := tmpString , t.

    t := ''.
    fontNr := 0.
    FontNames do:[:aName |
        t := t , (fontNr printString) , ' ' 
               , (FontHeight printString) , ' '
               , '/ISO-' , aName , (Character nl) asString.
        fontNr := fontNr + 1
    ].
    tmpString := tmpString , t.
    tmpString := tmpString , fontNr printString , ' SetUpFonts

% end of prolog
%%EndProlog
'.
    Prolog := tmpString.

    "
     PostscriptPrinterStream initProlog
    "

    "Created: 23.4.1996 / 19:40:44 / cg"
    "Modified: 7.9.1996 / 16:01:52 / cg"
!

initTrailer
    "define the documents epilog"

        Trailer :=
'
%%Trailer
EndSmalltalkDoc
SmalltalkJob restore
'

    "Modified: 7.9.1996 / 16:27:49 / cg"
!

initialize
    Normal isNil ifTrue:[
        self initFonts.
        self initPage.
        self initCharacterSize.

        "/ self initProlog.   - now done lazy
        "/ self initTrailer.  - now done lazy

        self initPageProlog.
        self initPageTrailer
    ]

    "
     Normal := nil.
     self initialize
    "

    "Modified: 18.5.1996 / 09:46:15 / cg"
!

reInitPage
    self initPage.
    Prolog := nil.
    "/ self initProlog.   - now done lazy

    "Created: 31.5.1996 / 23:35:18 / cg"
! !

!PostscriptPrinterStream class methodsFor:'accessing-defaults'!

bottomMargin
    "return the bottom margin (in inches)"

    ^ BottomMargin

    "Modified: 3.6.1996 / 10:44:44 / cg"
    "Created: 5.9.1996 / 21:42:08 / cg"
!

bottomMargin:inches
    "set the bottom margin (in inches)"

    BottomMargin := inches.
    self reInitPage.

    "Modified: 3.6.1996 / 10:47:16 / cg"
    "Created: 5.9.1996 / 21:42:13 / cg"
!

leftMargin
    "return the left margin (in inches)"

    ^ LeftMargin

    "Modified: 3.6.1996 / 10:45:11 / cg"
    "Created: 5.9.1996 / 21:42:16 / cg"
!

leftMargin:inches
    "set the left margin (in inches)"

    LeftMargin := inches.
    self reInitPage.

    "Created: 3.6.1996 / 10:46:33 / cg"
    "Modified: 5.9.1996 / 21:42:19 / cg"
!

psProlog
    Prolog isNil ifTrue:[
        self initProlog
    ].
    ^ Prolog
!

psTrailer
    Trailer isNil ifTrue:[
        self initTrailer
    ].
    ^ Trailer
!

resolution
    "return the printers actual resolution (if known)"

    ^ Resolution

    "Modified: 3.6.1996 / 10:45:17 / cg"
    "Created: 5.9.1996 / 21:41:49 / cg"
!

resolution:dpiValuePoint
    "set the printers actual resolution (if known)"

    Resolution := dpiValuePoint

    "Modified: 3.6.1996 / 10:45:17 / cg"
    "Created: 5.9.1996 / 21:41:49 / cg"
!

rightMargin
    "return the right margin (in inches)"

    ^ RightMargin

    "Modified: 3.6.1996 / 10:45:11 / cg"
    "Created: 5.9.1996 / 21:42:16 / cg"
!

rightMargin:inches
    "set the right margin (in inches)"

    RightMargin := inches.
    self reInitPage.
!

supportsColor
    SupportsColor notNil ifTrue:[^ SupportsColor].
    ^ false
!

supportsColor:aBoolean
    SupportsColor := aBoolean.
!

supportsGreyscale
    SupportsGreyscale notNil ifTrue:[^ SupportsGreyscale].
    ^ true
!

supportsGreyscale:aBoolean
    SupportsGreyscale := aBoolean.
!

topMargin
    "return the top margin (in inches)"

    ^ TopMargin

    "Modified: 3.6.1996 / 10:45:17 / cg"
    "Created: 5.9.1996 / 21:41:49 / cg"
!

topMargin:inches
    "set the top margin (in inches)"

    TopMargin := inches.
    self reInitPage.

    "Modified: 3.6.1996 / 10:47:26 / cg"
    "Created: 5.9.1996 / 21:41:55 / cg"
! !

!PostscriptPrinterStream class methodsFor:'queries'!

printerTypeName
    "return a descriptive name"

    ^ 'Postscript Printer'

    "Modified: / 08-11-2007 / 12:14:05 / cg"
!

supportsMargins
    "return true if this printer supports margins"

    ^ true

    "Created: 3.6.1996 / 10:48:04 / cg"
!

supportsPageSizes
    "return true if this printer supports different page sizes"

    ^ true

    "Created: 31.5.1996 / 22:35:39 / cg"
!

supportsPostscript
    "return true if this is a postscript printer"

    ^ true

    "Created: 10.2.1996 / 16:23:23 / cg"
! !

!PostscriptPrinterStream methodsFor:'access-writing'!

cr
    "send line termination"

    self flushLine.
    native == true ifTrue:[
        stream cr.
        ^ self
    ].

    xPos := LeftX.
    colNr := 0.
    sendXPosition := true.
    yPos := yPos - FontHeight.

    lineNr := lineNr + 1.
    lineNr > LinesPerPage ifTrue:[
        self nextPage
    ]

    "Modified: 1.6.1996 / 13:09:30 / cg"
!

nextPut:aCharacter
    |code|

    (aCharacter == Character cr) ifTrue:[
        ^ self cr
    ].

    native == true ifTrue:[
        stream nextPut:aCharacter.
        ^ self.
    ].

    (aCharacter == $( ) ifTrue:[
        lineStream nextPutAll:'\(' .
        ^ self
    ].
    (aCharacter == $) ) ifTrue:[
        lineStream nextPutAll:'\)' .
        ^ self
    ].
    (aCharacter == $\ ) ifTrue:[
        lineStream nextPutAll:'\\' .
        ^ self
    ].

    (aCharacter == Character tab ) ifTrue:[
        self flushLine.
        colNr := ((colNr + 8) // 8) * 8. 
        xPos := LeftX + (colNr * FontWidth).
        sendXPosition := true.
        ^ self
    ].

    (code := aCharacter codePoint) > 16r7F ifTrue:[
        lineStream nextPut:$\ ; nextPutAll:(code printStringRadix:8)
    ] ifFalse:[
        lineStream nextPut:aCharacter
    ].

    "Modified: 23.4.1996 / 20:05:59 / cg"
! !

!PostscriptPrinterStream methodsFor:'accessing'!

colNr
    "return the current column-Nr (within the line)"

    ^ colNr

    "Created: 2.1.1997 / 13:29:55 / cg"
!

lineNr
    "return the current line-Nr (within the page)"

    ^ lineNr

    "Created: 2.1.1997 / 13:29:38 / cg"
!

pageCount
    "returns the number of the currently printed page"

    ^ pageCount

    "Created: 5.9.1996 / 18:29:23 / cg"
!

pageEndAction:something
    "set pageEndAction - if non-nil, that will be called before
     and EndPage is emmitted. 
     An example use is a private block,
     which draws a company frame around the page ..."

    pageEndAction := something.

    "Modified: 30.5.1996 / 16:45:09 / ca"
!

pageStartAction:something
    "set pageStartAction - if nonNil, that is evaluated prior to every page."

    pageStartAction := something.

    "Modified: 30.5.1996 / 16:44:20 / ca"
! !

!PostscriptPrinterStream methodsFor:'emphasis change'!

bold
    "further printing is in bold"

    (fStyle ~~ Bold) ifTrue:[
	self flushLine.
	fStyle := Bold.
	self setFont.
    ].

    "Modified: 8.6.1996 / 08:17:15 / cg"
!

boldItalic
    "further printing is in boldItalic"

    (fStyle ~~ BoldItalic) ifTrue:[
	self flushLine.
	fStyle := BoldItalic.
	self setFont.
    ].

    "Created: 18.5.1996 / 09:36:36 / cg"
    "Modified: 8.6.1996 / 08:17:21 / cg"
!

italic
    "further printing is in italic"

    (fStyle ~~ Italic) ifTrue:[
	self flushLine.
	fStyle := Italic.
	self setFont.
    ].

    "Modified: 8.6.1996 / 08:17:28 / cg"
!

noStrikeout
    "further printing is not strikedout"

    strikeout ifTrue:[
	self flushLine.
	strikeout := false
    ]

    "Modified: 8.6.1996 / 08:15:56 / cg"
    "Created: 8.6.1996 / 08:16:35 / cg"
!

noUnderline
    "further printing is not underlined"

    underline ifTrue:[
	self flushLine.
	underline := false
    ]

    "Created: 8.6.1996 / 08:11:07 / cg"
    "Modified: 8.6.1996 / 08:15:56 / cg"
!

normal
    "further printing is in normal style (i.e. non-bold/non-italic)"

    (fStyle ~~ Normal) ifTrue:[
	self flushLine.
	fStyle := Normal.
	self setFont.
    ].

    "Modified: 8.6.1996 / 08:17:34 / cg"
!

strikeout
    "further printing is strikedout"

    strikeout ifFalse:[
	self flushLine.
	strikeout := true
    ]

    "Modified: 8.6.1996 / 08:10:49 / cg"
    "Created: 8.6.1996 / 08:16:18 / cg"
!

underline
    "further printing is underlined"

    underline ifFalse:[
	self flushLine.
	underline := true
    ]

    "Modified: 8.6.1996 / 08:16:05 / cg"
! !

!PostscriptPrinterStream methodsFor:'font change'!

courier
    "further printing is in the courier font"

    self flushLine.
    fFamily := Courier.
    self setFont

    "Modified: 10.4.1996 / 13:34:49 / cg"
!

helvetica
    "further printing is in the helvetica font"

    self flushLine.
    fFamily := Helvetica.
    self setFont

    "Modified: 10.4.1996 / 13:34:58 / cg"
!

times
    "further printing is in the times font"

    self flushLine.
    fFamily := Times.
    self setFont

    "Modified: 10.4.1996 / 13:36:07 / cg"
! !

!PostscriptPrinterStream methodsFor:'open & close'!

endPrint
    "finish a document - finish page; then send documentTrailer.
     Send nothing if nativePrinting."

    native == true ifFalse:[
        self endPage.

        self nextPutAllUntranslated:(self class psTrailer).
        self nextPutAllUntranslated:'%%Pages: ' , pageCount printString.
        self nextPutUntranslated:(Character cr).
        self nextPutAllUntranslated:'%%EOF'.
        self nextPutUntranslated:(Character cr).
    ].
    super endPrint

    "Modified: 7.9.1996 / 16:28:20 / cg"
!

setNative:aBoolean

    aBoolean ifTrue:[self flushLine].
    super setNative:aBoolean.
!

startPrint
    "start a document - send documentProlog & start a page.
     Send nothing if nativePrinting."

    pageCount := 1.

    fFamily := Courier.
    fStyle := Normal.
    underline := false.
    strikeout := false.

    super startPrint.
    native == true ifFalse:[
        self nextPutAllUntranslated:(self class psProlog).
        self startPage
    ]

    "Modified: / 26.5.1999 / 16:15:27 / cg"
! !

!PostscriptPrinterStream methodsFor:'private'!

endPage
    "end a page - flush buffered text & send pageTrailer"

    self flushLine.
    pageEndAction value.
    self nextPutAllUntranslated:PageTrailer

    "Modified: 23.4.1996 / 20:00:01 / cg"
!

flushLine
    "flush buffered line text"

    |lineBuffer|

    lineStream isNil ifTrue:[^ self].

    lineBuffer := lineStream contents.

    (lineBuffer size > 0) ifTrue:[
        sendXPosition ifTrue:[
            self nextPutAllUntranslated:(xPos printString).
            self nextPutUntranslated:Character space.
            self nextPutAllUntranslated:(yPos printString).
        ].
        self nextPutUntranslated:$(.
        self nextPutAllUntranslated:lineBuffer.
        self nextPutUntranslated:$).
        sendXPosition ifTrue:[
            self nextPutUntranslated:$B.
            sendXPosition := false.
        ] ifFalse:[
            self nextPutUntranslated:$S.
        ].
        underline == true ifTrue:[
            self nextPutAllUntranslated:'UL'.
        ] ifFalse:[
            strikeout == true ifTrue:[
                self nextPutAllUntranslated:'SO'.
            ]
        ].

        self nextPutUntranslated:(Character cr).
        xPos := xPos + (FontWidth * lineBuffer size).
        colNr := colNr + lineBuffer size
    ].
    self flush.
    lineStream reset.

    "Modified: 8.6.1996 / 11:40:29 / cg"
!

nextPage
    "new page - finish previous page & start enew.
     Should not be sent when nativePrinting."

    self endPage.

    pageCount := pageCount + 1.
    self startPage

    "Modified: 5.9.1996 / 18:30:00 / cg"
!

placeString:aString at:pos
    "special entry: place a string at some particular position in my ps-coordinate
     system. Can be used with endPageActions to place a page-number."

    self flushLine;
         nextPutAllUntranslated:(pos x printString);
         nextPutUntranslated:Character space;
         nextPutAllUntranslated:(pos y printString);
         nextPutUntranslated:$(;
         nextPutAllUntranslated:aString;
         nextPutAllUntranslated:')B';
         nextPutUntranslated:(Character cr).

    "Created: 30.5.1996 / 17:06:36 / ca"
!

setFont
    "change the font. 
     Uses current fFamily and fStyle (which give the font's nr)"

    |fontNumber|

    fontNumber := fFamily + fStyle.
    self nextPutAllUntranslated:fontNumber printString;
         nextPutAllUntranslated:' F'; 
         nextPutUntranslated:(Character cr).

    "Modified: 23.4.1996 / 20:01:28 / cg"
!

startPage
    "start a page - send pageProlog, reset x/y position and line/col."

    self nextPutAllUntranslated:'%%Page: ' , pageCount printString , ' ' , pageCount printString.
    self nextPutUntranslated:(Character cr).

    pageStartAction value.
    self nextPutAllUntranslated:PageProlog.
    self class landscape ifTrue:[
        self nextPutAllUntranslated:'Landscape
'.
    ].

    self setFont.

    yPos := TopY.
    xPos := LeftX.
    lineStream isNil ifTrue:[
        lineStream := WriteStream on:''.
    ] ifFalse:[
        lineStream reset.
    ].
    lineNr := 1.
    colNr := 0.
    sendXPosition := true.

    "Modified: 5.9.1996 / 18:30:08 / cg"
! !

!PostscriptPrinterStream methodsFor:'queries'!

fontHeight
    "the used fonts height in my postscript coordinate system 
     (i.e. in twips, which is 1/20th of a point)"

    ^ FontHeight

    "Modified: 30.5.1996 / 16:47:37 / ca"
    "Modified: 1.6.1996 / 13:14:51 / cg"
!

leftX
    "the left x startPosition (i.e. leftMargin) in my postscript coordinate system.
     (i.e. in twips, which is 1/20th of a point)"

    ^ LeftX

    "Modified: 30.5.1996 / 16:48:56 / ca"
    "Modified: 1.6.1996 / 13:14:59 / cg"
!

linesPerPage
    "the number of lines per page"

    ^ LinesPerPage

    "Modified: 30.5.1996 / 16:48:20 / ca"
!

overAllPageSize
    "the overAll pageSize in my postscript coordinate system.
     (i.e. in twips, which is 1/20th of a point)"

    ^ PageHeight

    "Created: 30.5.1996 / 16:56:51 / ca"
    "Modified: 30.5.1996 / 16:58:01 / ca"
    "Modified: 1.6.1996 / 13:15:06 / cg"
!

topY
    "the top y startPosition (i.e. page-size - topMargin) in my own coordinate system
     (i.e. in twips, which is 1/20th of a point)"

    ^ TopY

    "Modified: 30.5.1996 / 16:48:48 / ca"
    "Modified: 1.6.1996 / 13:15:23 / cg"
! !

!PostscriptPrinterStream class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


PostscriptPrinterStream initialize!
