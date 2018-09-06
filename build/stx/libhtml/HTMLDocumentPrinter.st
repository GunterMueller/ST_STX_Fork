"
 COPYRIGHT (c) 1997 by eXept Software AG
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

Object subclass:#HTMLDocumentPrinter
	instanceVariableNames:'style directory bindings contents documentEncoding fontEncoding
		currentURL'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLDocumentPrinter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    prints single documents or a collection of documents (book).
    Keeps track of header positions and appends a table-of-contents
    with page numbers at the end.

    [author:]
        Claus Atzkern
"
!

examples
"
    printing of single documents or collection of documents (book)


    For example:

    print one document

                                                                        [exBegin]
        HTMLDocumentPrinter print:'/home2/stx/lib/doc/online/english/TOP.html'
                                                                        [exEnd]

    print a document with some bindings

                                                                        [exBegin]
        |b f|

        f := '/home2/stx/lib/doc/online/english/TOP.html'.
        b := Dictionary new.

        b at:#date        put:(Date today printString).
        b at:#url         put:f.
        b at:#exception   put:'no exception information'.
        b at:#message     put:'no message'.

        HTMLDocumentPrinter print:f contents:nil bindings:b style:nil
                                                                        [exEnd]

    print a collection of documents: book
        the book is implemented as an html file which contains a list
        of documents: 
                <A HREF=....document name(path)....>...short name...</A><BR>

                                                                        [exBegin]
        HTMLDocumentPrinter printBook:'/home2/stx/lib/doc/online/english/book.html'
                                                                        [exEnd]

"
!

test
        HTMLDocumentPrinter printBookURL:'/home2/stx/lib/doc/online/english/programming/ca.html'
! !

!HTMLDocumentPrinter class methodsFor:'instance creation'!

defaultStyle
    "initialize default style
    "
    |style fontStyle fontStyles fontSize|

    style := HTMLPageStyle new.

    fontStyles := Dictionary new.
    style fontStyles:fontStyles.

    fontStyle := HTMLFontStyle new.
    fontStyles at:#'iso8859-1' put:fontStyle.

    fontSize := 10.
    fontStyle fontSize:fontSize.

    fontStyle normalFont:           (Font family:'times' face:'medium' style:'roman' size:fontSize).
    fontStyle boldNormalFont:       (Font family:'times' face:'bold'   style:'roman' size:fontSize).
    fontStyle italicNormalFont:     (Font family:'times' face:'medium' style:'italic' size:fontSize).
    fontStyle boldItalicNormalFont: (Font family:'times' face:'bold'   style:'italic' size:fontSize).

    fontStyle codeFont:             (Font family:'courier' face:'medium' style:'roman' size:fontSize).
    fontStyle boldCodeFont:         (Font family:'courier' face:'bold'   style:'roman' size:fontSize).
    fontStyle italicCodeFont:       (Font family:'courier' face:'medium' style:'oblique' size:fontSize).
    fontStyle boldItalicCodeFont:   (Font family:'courier' face:'bold'   style:'oblique' size:fontSize).

    fontStyle normalSmallFont:      (Font family:'times' face:'medium' style:'roman' size:fontSize-2).

    fontStyle h1Font:   (Font family:'times' face:'bold' style:'roman' size:(fontSize * 1.8) rounded).
    fontStyle h2Font:   (Font family:'times' face:'bold' style:'roman' size:(fontSize * 1.4) rounded).
    fontStyle h3Font:   (Font family:'times' face:'bold' style:'roman' size:(fontSize * 1.2) rounded).
    fontStyle h4Font:   (Font family:'times' face:'bold' style:'roman' size:(fontSize)).
    fontStyle h5Font:   (Font family:'times' face:'bold' style:'roman' size:(fontSize * 0.8) rounded).
    fontStyle h6Font:   (Font family:'times' face:'bold' style:'roman' size:(fontSize * 0.8) rounded).

    fontStyle symbolFont:(Font family:'symbol' face:'medium' style:'roman' size:fontSize).

    "/ for now: no support to print JIS or big5 documents.
    "/ needs more work.

    style activeAnchorFGColor:  (Color red).
    style activeAnchorBGColor:  (Color white).
    style anchorFGColor:        (Color blue).
    style exampleFGColor:       (Color red:40 green:0 blue:0).
    style textFGColor:          (Color black).
    style codeFGColor:          (Color black).
    style visitedAnchorFGColor: (Color red:15 green:2 blue:36).
    style fontSize:10.
    style initialHeaderNumbers:#(1 1 1 1 1 1).
    style headerNumbers:true.
    style printTOC:true.
    style anchorUnderline:false.


    Printer supportsColor ifFalse:[
        style activeAnchorFGColor:  (Color black).
        style activeAnchorBGColor:  (Color white).
        style anchorFGColor:        (Color black).
        style exampleFGColor:       (Color black).
        style textFGColor:          (Color black).
        style visitedAnchorFGColor: (Color black).
    ].
    ^ style

    "Modified: / 6.8.1997 / 15:22:06 / cg"
    "Created: / 24.1.2001 / 16:02:21 / ps"
!

style:aPrintStyle bindings:someBindings
    "creation of an instance; on error nil is returned
    "
    ^ self new style:aPrintStyle bindings:someBindings
! !

!HTMLDocumentPrinter class methodsFor:'printing documents'!

print:aFile
    "print a document. On success true is returned otherwise false
    "
    ^ self print:aFile contents:nil bindings:nil style:nil

!

print:aFileOrDirectory contents:aContents bindings:someBindings style:aPrintStyle
    "print a document or contents. On success true is returned
     otherwise false
    "
    |rslt psgc|

    psgc := self openPSGraphicContext.
    psgc isNil ifTrue:[
        ^ false
    ].

    [
        rslt := self print:aFileOrDirectory contents:aContents bindings:someBindings style:aPrintStyle on:psgc
    ] ensure:[
        psgc close.
    ].
    ^ rslt
!

print:aFileOrDirectory contents:aContents bindings:someBindings style:aPrintStyle on:psgc
    "print a document or contents. On success true is returned
     otherwise false
    "
    |inst|

    inst := self style:aPrintStyle bindings:someBindings.
    inst isNil ifTrue:[
        ^ false
    ].
    ^ inst printDocument:aFileOrDirectory contents:aContents on:psgc
!

printBook:aBookURL
    "printing a book (collection of documents). On success
     true is returned otherwise false
    "
    self obsoleteMethodWarning:'use printBookURL:'.
    ^ self printBookURL:aBookURL
!

printBook:aBookURL bindings:someBindings style:aPrintStyle
    "printing a book (collection of documents). On success
     true is returned otherwise false
    "
    self obsoleteMethodWarning:'use printBookURL:bindings:style:'.
    ^ self printBookURL:aBookURL bindings:someBindings style:aPrintStyle
!

printBook:aBookURL from:aDocumentView
    "printing a book (collection of documents).
     Take the bindings from the documentView.
     On success true is returned; otherwise false
    "
    self obsoleteMethodWarning:'use printBookURL:from:'.
    ^ self printBookURL:aBookURL from:aDocumentView
!

printBookURL:aBookURL
    "printing a book (collection of documents). On success
     true is returned otherwise false
    "
    ^ self printBookURL:aBookURL bindings:nil style:nil
!

printBookURL:aBookURL bindings:someBindings style:aPrintStyle
    "printing a book (collection of documents). On success
     true is returned otherwise false
    "
    |psgc rslt|

    psgc := self openPSGraphicContext.
    psgc isNil ifTrue:[
        ^ false
    ].

    [
        rslt := self printBookURL:aBookURL bindings:someBindings style:aPrintStyle on:psgc
    ] ensure:[
        psgc close.
    ].
    ^ rslt
!

printBookURL:aBookURL bindings:someBindings style:aPrintStyle on:psgc
    "printing a book (collection of documents). On success
     true is returned otherwise false
    "
    |inst|

    inst := self style:aPrintStyle bindings:someBindings.
    inst isNil ifTrue:[
        ^ false
    ].

    ^ inst printBookURL:aBookURL on:psgc
!

printBookURL:aBookURL from:aDocumentView
    "printing a book (collection of documents).
     Take the bindings from the documentView.
     On success true is returned; otherwise false
    "
    ^ self printBookURL:aBookURL bindings:(aDocumentView ampersandBindings) style:nil

    "Created: 6.8.1997 / 14:40:04 / cg"
! !

!HTMLDocumentPrinter class methodsFor:'private'!

openPSGraphicContext
    "open a PSGraphicsContext on a stream. On success the
     context is returned otherwise nil
    "
    |stream|

    stream := Printer newNative.

    stream notNil ifTrue:[
        PSGraphicsContext isNil ifTrue:[
            Smalltalk loadPackage:'stx:goodies/postscript'.
        ].
        PSGraphicsContext isNil ifTrue:[
            self warn:'Cannot print due to missing PSGraphicsContext class.'.
            ^ nil.
        ].
        ^ PSGraphicsContext on:stream extent:(1.0 @ 1.0)
    ].
    self warn:'cannot open printer stream'.
    ^ nil
! !

!HTMLDocumentPrinter methodsFor:'accessing'!

bindings
    "accessing bindings"

    ^ bindings

    "Modified: / 24.1.2001 / 16:07:31 / ps"
!

bindings:someBindings
    "changing bindings
    "
    bindings := someBindings
!

currentURL
    "return the current URL"

    ^ currentURL

    "Created: 6.8.1997 / 13:24:18 / cg"
!

documentEncoding
    "return the value of the instance variable 'documentEncoding' (automatically generated)"

    ^ documentEncoding ? #'iso8859-1'

    "Modified: 7.8.1997 / 18:14:51 / cg"
!

documentEncoding:anEncodingSymbol
    documentEncoding := anEncodingSymbol.
    fontEncoding := self fontEncodingFor:documentEncoding.

"/    Transcript show:'docEncoding: '; showCR:documentEncoding.
"/    Transcript show:'fontEncoding: '; showCR:fontEncoding.

    "Modified: 1.7.1997 / 00:50:11 / cg"

!

style
    "accessing printing style
    "
    ^ style
!

style:aStyle
    "change printing style
    "
    (style := aStyle) isNil ifTrue:[
        style := self class defaultStyle
    ].

    style := style copy. "/ deepCopy.

    "Modified: / 17.9.1996 / 21:15:47 / cg"
    "Modified: / 24.1.2001 / 16:02:38 / ps"
! !

!HTMLDocumentPrinter methodsFor:'dummy for protocol compatibility'!

infoDisplay:msg
    "/ ignored here
! !

!HTMLDocumentPrinter methodsFor:'instance creation'!

defaultStyle
    ^ self class defaultStyle.

    "Created: / 24.1.2001 / 16:06:32 / ps"
!

style:aStyle bindings:someBindings
    "initialize instance
    "
    bindings := someBindings.

    self style:aStyle.

    Printer supportsPostscript ifTrue:[
        ^ self
    ].

    self warn:(HTMLDocumentView classResources string:'Sorry, I can only print on postscript printers.').
    ^ nil.

    "Modified: 6.8.1997 / 13:41:22 / cg"
! !

!HTMLDocumentPrinter methodsFor:'printing'!

printBookURL:aFile on:aPostscriptGC
    "printing a book (collection of documents). On success
     true is returned otherwise false
    "
    |file book|

    (file := self stringAsFilename:aFile) isNil ifTrue:[^ false].

    file isDirectory ifTrue:[
        self warn:'cannot print a directory: ', file pathName.
      ^ false
    ].

    directory := file directory.
    book      := self parse:file.

    book isNil ifTrue:[
        ^ false
    ].

    style printTOC:false.

    contents := OrderedCollection new.

    self printBook:book on:aPostscriptGC.
    self printContentsOn:aPostscriptGC.

    ^ true

    "Modified: 7.8.1997 / 17:34:00 / cg"
!

printDocument:fileOrDirectory contents:aContents
    "printing a document or contents. In case that the contents is not nil,
     the fileOrDirectory instance is used as the top directory for accessing
     images or files. On success true is returned otherwise false
    "

    |postscriptGC rslt|

    self obsoleteMethodWarning.
    postscriptGC := self class openPSGraphicContext.
    postscriptGC isNil ifTrue:[
        ^ false
    ].
    [
        rslt := self printDocument:fileOrDirectory contents:aContents on:postscriptGC
    ] ensure:[
        postscriptGC close
    ].
    ^ rslt
!

printDocument:fileOrDirectory contents:aContents on:aPostscriptGC
    "printing a document or contents. In case that the contents is not nil,
     the fileOrDirectory instance is used as the top directory for accessing
     images or files. On success true is returned otherwise false
    "
    |file doc|

    file     := self stringAsFilename:fileOrDirectory.
    contents := nil.

    file notNil ifTrue:[
        file isDirectory ifTrue:[directory := file] 
                        ifFalse:[directory := file directory].
    ].

    aContents notNil ifTrue:[
        currentURL := 'internal-document'. 
        doc := self parse:aContents
    ] ifFalse:[
        file notNil ifTrue:[
            currentURL := file pathName.
            doc := self parse:file
        ]
    ].
    doc isNil ifTrue:[
        ^ false
    ].
    self printDocument:doc on:aPostscriptGC.
    ^ true
! !

!HTMLDocumentPrinter methodsFor:'private'!

element:element for:aPSGraphicContext
    "prepare a document derived from element for printing. On success
     the document is writen to the graphic context and true is returned.
     Otherwise false returns.
    "
    |file doc hdrOffset savDir headers el|

    headers := #(h1 h2 h3 h4 h5 h6 /h1 /h2 /h3 /h4 /h5 /h6 ).

    file := self stringAsFilename:(element hrefString).

    (doc := self parse:file) isNil ifTrue:[
        Transcript showCR:('*** document not found: ' , element hrefString).
        ^ false
    ].
    hdrOffset := element numericParameterFor:'HEADERINDEX' default:0.
    savDir    := directory.
    directory := file directory.

    Transcript showCR:('printing ' , (element hrefString) , ' for book ...').

    hdrOffset == 0 ifFalse:[
        el := doc.
        [el notNil] whileTrue:[
            |i min max|

            i := headers indexOf:(el type).
            i ~~ 0 ifTrue:[
                i <= 6 ifTrue:[min := 1. max :=  6]
                      ifFalse:[min := 7. max := 12].

                i := i + hdrOffset.
                i < min ifTrue:[i := min]
                       ifFalse:[i > max ifTrue:[i := max]].

                el type:((headers at:i) asSymbol)
            ].
            el := el next.
        ]
    ].
    self printDocument:doc on:aPSGraphicContext.
    directory := savDir.
    ^ true.

    "Modified: 11.10.1996 / 11:23:09 / cg"
!

fontEncodingFor:encodingSymbol
    |fn|

    fn := FontDescription fontNamePatternForCharset:encodingSymbol.
    fn isNil ifTrue:[
        fn := #'iso8859-1'
    ].
    ^ fn

    "Created: 30.6.1997 / 11:24:46 / cg"
    "Modified: 1.7.1997 / 00:36:23 / cg"
!

parse:stringOrFile
    "parse string.or file. On success the document is returned
     otherwise nil.
    "
    |stream doc|

    stringOrFile notNil ifTrue:[
        stringOrFile isString ifTrue:[
            doc := HTMLParser new 
                        parseText:stringOrFile 
                        withBindings:bindings
                        for:self
        ] ifFalse:[
            stream := stringOrFile readStream.
            stream notNil ifTrue:[
                doc := HTMLParser new 
                        parseText:stream 
                        withBindings:bindings
                        for:self.
                stream close.
            ] ifFalse:[
                self warn:'cannot open stream for: ', stringOrFile pathName
            ]
        ]
    ].
    ^ doc

    "Modified: 7.8.1997 / 18:11:01 / cg"
!

stringAsFilename:aString
    "returns string as an absolute filename or nil
    "
    |file strLower strUpper|

    aString notNil ifTrue:[
        file := aString asFilename.
        file exists ifTrue:[^ file asAbsoluteFilename].

        strLower := aString asString asLowercase.
        file     := strLower asFilename.
        file exists ifTrue:[^ file asAbsoluteFilename].

        strUpper := aString asString asUppercase.
        file     := strUpper asFilename.
        file exists ifTrue:[^ file asAbsoluteFilename].

        directory notNil ifTrue:[
            file := directory construct:aString.
            file exists ifTrue:[^ file asAbsoluteFilename].

            file := directory construct:strLower.
            file exists ifTrue:[^ file asAbsoluteFilename].

            file := directory construct:strUpper.
            file exists ifTrue:[^ file asAbsoluteFilename].
        ].
        Transcript showCR:('**** not a valid URL (in book): ', aString asString).
    ].
    ^ nil

    "Modified: 12.9.1996 / 00:41:24 / cg"
! !

!HTMLDocumentPrinter methodsFor:'private printer interface'!

imageFor:urlString now:now
    "returns image assigned to urlString or nil
    "
    |file|

    (file := self stringAsFilename:urlString) notNil ifTrue:[
        ^ Image fromFile:(file pathName)
    ].
    ^ nil
!

visitTest:urlString action:actionString
    ^ false

! !

!HTMLDocumentPrinter methodsFor:'private printing'!

printBook:book on:aPSGraphicContext
    "print documents of book to a grafic context
    "
    |noError newPage savDir subBookFile subBook e|

    noError := true.
    newPage := false.

    e := book markup.
    [e notNil] whileTrue:[
        e type == #a ifTrue:[
            (e hasParameterFor:#'NOPRINT') ifFalse:[

                newPage ifTrue:[
                    aPSGraphicContext startPage.
                    newPage := false.
                ].

                (e hasParameterFor:#'ISBOOK') ifTrue:[
                    (subBookFile := self stringAsFilename:(e hrefString)) notNil ifTrue:[

                        subBookFile isDirectory ifFalse:[
                            savDir := directory.
                            directory := subBookFile directory.
                            subBook      := self parse:subBookFile.

                            subBook notNil ifTrue:[
                                Transcript showCR:('including book: ' , (e hrefString) , ' ...').
                                self printBook:subBook on:aPSGraphicContext.
                                newPage := true
                            ].
                            directory := savDir.
                        ]
                    ]
                ] ifFalse:[
                    newPage := self element:e for:aPSGraphicContext.

                    newPage ifFalse:[
                        noError := false
                    ].
                ]
            ]
        ].
        e := e next.
    ].
    ^ noError

    "Modified: 6.8.1997 / 15:19:27 / cg"
!

printContentsOn:aPSGraphicContext
    "print contents to a grafic context
    "
    |painter dummy|

    (contents isNil or:[contents isEmpty]) ifTrue:[
        ^ self
    ].

    aPSGraphicContext pageName:'I'.

    aPSGraphicContext startPage.

    painter := HTMLDocumentPainter new.
    dummy   := HTMLMarkup for:#html.
    style initialHeaderNumbers:(Array new:6 withAll:1).
    painter format:dummy for:aPSGraphicContext resolver:self style:style.
    painter displayX:0 y:0 width:9000 height:5000000 on:aPSGraphicContext.

    painter printContents:contents pageNumber:1 romanPageNumbers:true.

    "Modified: 11.10.1996 / 11:38:06 / cg"
!

printDocument:document on:aPSGraphicContext
    "print document to a grafic context
    "
    |painter listOfHdrs hdrsIdx|

    painter := HTMLDocumentPainter new.
    painter format:document markup for:aPSGraphicContext resolver:self style:style.
    painter displayX:0 y:0 width:9000 height:5000000 on:aPSGraphicContext.

    (hdrsIdx := painter arrayOfHeaderIndex) notNil ifTrue:[
        style initialHeaderNumbers:(hdrsIdx collect:[:n | n+1])
    ].

    contents notNil ifTrue:[
        (listOfHdrs := painter listOfHeaders) notNil ifTrue:[
            contents := contents , listOfHdrs
        ]
    ].

    "Modified: 11.10.1996 / 11:30:45 / cg"
! !

!HTMLDocumentPrinter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentPrinter.st,v 1.28 2016-01-18 13:51:21 cg Exp $'
! !

