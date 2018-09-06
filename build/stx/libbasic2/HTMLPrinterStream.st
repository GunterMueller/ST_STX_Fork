"
 COPYRIGHT (c) 2016 by Claus Gittinger
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

PrinterStream subclass:#HTMLPrinterStream
	instanceVariableNames:'htmlBuilder buffer currentStyle bold italic fontName'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Printing'
!

!HTMLPrinterStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by Claus Gittinger
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
    A simple HTML generating printer stream.
    Useful to generate indented listings, which need to be included in
    an html document.
    Currently only supports bold and normal printing; 
    needs more care & feeding for italic, underline and colors.

    [see also:]
        PSPrinterStream PrinterStream PDFPrinterStream 

    [author:]
        Claus Gittinger
"
! !

!HTMLPrinterStream class methodsFor:'queries'!

isDrivenByCommand
    ^ false
!

printerTypeName
    "return a descriptive name"

    ^ 'HTML Printer'
!

supportsMargins
    ^ false
!

supportsPageSizes
    ^ false
!

supportsPostscript
    ^ false
!

supportsPrintingToFile
    ^ true
! !

!HTMLPrinterStream methodsFor:'emphasis'!

bold
    "switch to bold emphasis"

    bold ifFalse:[
        self flushBuffer.
        htmlBuilder bold.
        bold := true.
    ].
!

emphasis:anEmphasis
    self flushBuffer.
    super emphasis:anEmphasis.

"/    self setupFontTypeEmphasis.
"/    self setupColorFromEmphasis:anEmphasis.
"/    self setupUnderlineFromEmphasis:anEmphasis.
!

normal
    "back to normal (non-bold, non-italic) emphasis"
    
    bold ifTrue:[
        self flushBuffer.
        htmlBuilder boldEnd.
        bold := false.
    ].
! !

!HTMLPrinterStream methodsFor:'initialization'!

close
    self flushBuffer.
    bold ifTrue:[
        htmlBuilder boldEnd.
    ].
    htmlBuilder preEnd.
    htmlBuilder bodyEnd.
    htmlBuilder printHtmlOn:stream.
    super close.
!

initialize
    super initialize.
    
    HTML::TreeBuilder isNil ifTrue:[
        Smalltalk loadPackage:#'stx:goodies/webServer/htmlTree'
    ].    
    bold := italic := false.
    htmlBuilder := HTML::TreeBuilder new.
    htmlBuilder body.
    htmlBuilder pre.
! !

!HTMLPrinterStream methodsFor:'writing'!

cr
    self flushBuffer.
    super cr.
!

flushBuffer
    |style|

    buffer notNil ifTrue:[
        htmlBuilder text:buffer contents.
"/        bold ifTrue:[ style := self style:style with: htmlBuilder boldEnd ].
"/        italic ifTrue:[ htmlBuilder italicEnd ].
"/        underline ifTrue:[ htmlBuilder underlineEnd ].
"/        strikeout ifTrue:[ htmlBuilder strikeoutEnd ].
"/        
"/        redefinedStyle := PdfStyle redefine.
"/        redefinedStyle color:currentFontColor.
"/        redefinedStyle setFont:currentFontTypeEmphasis.
"/        redefinedStyle underlinedColor:currentUnderlineColor.
"/
"/        currentUnderlineBool ifTrue:[
"/            redefinedStyle underlined.
"/        ].
"/
"/        pdfDocumentEditor
"/            text:buffer contents
"/            style:redefinedStyle.

        buffer := nil.    
    ].
!

nextPut:aCharacter
    buffer isNil ifTrue:[
        buffer := CharacterWriteStream new.
    ].
    buffer nextPut:aCharacter.
! !

!HTMLPrinterStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

