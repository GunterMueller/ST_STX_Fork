"{ Encoding: utf8 }"

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

HTMLDocumentInterpreter subclass:#HTMLDocumentPainter
	instanceVariableNames:'destination x y fontHeight fontAscent fontAvgHeight codeFont
		fontSize normalFont boldNormalFont italicNormalFont
		boldItalicNormalFont boldCodeFont italicCodeFont
		boldItalicCodeFont h1Font h2Font h3Font h4Font h5Font h6Font
		symbolFont normalSmallFont leftIndent indentOffset rightIndent
		docWidth currentRightLimit wSpace collectingText normalFontHeight
		textFGColor anchorFGColor activeAnchorFGColor activeAnchorBGColor
		visitedAnchorFGColor exampleFGColor codeFGColor yNextLine
		maxWidth maxHeight anchorElement collectedText anchors
		boundsCollector previousIsEmpty inPre inDL inOL inBLOCKQUOTE
		formatting scanning displayTop displayBottom displayLeft
		displayRight yText underline strikeout liStack ulLevel
		needFontChange needColorChange currentColor currentBGColor
		currentUnderlineColor currentFont inSup inKbd hBegin syncPoints
		forms widgets currentForm fixFontWidth currentTextAreaElement
		currentTable noBreak center maps inHeader metaCommands
		subProcesses currentMap currentRowIndex currentColIndex
		imageDisplayProcess imagesToDisplay tabulators lastTextX
		needSpace topMargin leftMargin rightMargin imageAndStyleResolver
		listOfHeaders arrayOfHeaderIndex headerDefinition pageNumber
		collectHeaders formattingStyle maxHeightInRow firstElementInRow
		tableColX maxXInCol alreadyDisplayedTableElements drawnColors
		scriptObject applets rightAlign currentApplet
		anyElementsWithRelativeHeight tableStack anchorUnderline
		haveSpace createdAppletFrames appletContext styleStack
		inNoPrintingParagraph lineSpacing lock imageResolver'
	classVariableNames:'ULindent DLindent OLindent BLOCKQUOTEindent SUPshift
		InternalAppletsFirst Resources LEFTmargin RIGHTmargin TOPmargin
		BOTTOMmargin'
	poolDictionaries:''
	category:'System-Documentation'
!

Object subclass:#PainterState
	instanceVariableNames:'xPosition yPosition currentLeftIndent currentIndentOffset
		currentRightIndent yNextLine yText previousIsEmpty inPre inKbd
		inDL inOL inBLOCKQUOTE inSup inUnderline inStrikeout inNoBreak
		inCenter inRightAlign ulLevel needSpace haveSpace currentColor
		currentFont currentForm currentTable currentRowIndex
		currentColIndex hBegin currentElement styleStack
		inNoPrintingParagraph currentBGColor currentUnderlineColor'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTMLDocumentPainter
!

Object subclass:#TextStyle
	instanceVariableNames:'font color'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTMLDocumentPainter
!

Query subclass:#WidgetQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTMLDocumentPainter
!

!HTMLDocumentPainter class methodsFor:'documentation'!

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
    This one is responsible to paint a document (a linked list
    of HTMLElements) into some drawable.

    The major entry points are:
        format:for:resolver:style:
                to scan the list for applets, widgets
                and preformat it.

        reformatDocument
                to reformat the document after a size change of the            
                drawable.

        displayX:y:width:height:on:
                to redraw (part of) the document.

    Caveat:
        This was written at a time when machines with 4M of main memory were
        considered as ''big machines''. So the code tries hard to save memory,
        in order to be able to display big documents on such small machines reasonably fast.

        This is done by avoiding an in-memory html dom-tree, but instead reparsing the
        document for redraws, and repeating the layout computations every time we draw. 

        Of course, in order to figure out what to draw when positioning (scrolling),
        we would have to redo all calculations from the start of the document.
        (i.e. parse the whole document for every redraw).
        Which would be a stupid idea, making the thing super slow.
        Therefore, it saves so called sync-points, which contain the captured state 
        (x, y position, font, position in document etc.), after every few pages worth
        of text. So, to update any random page, it has to search for the last sync-point
        before that page, and rerender (parse) from there till the end of the visible page.

        This scheme works quite well for simple documents in those small-memory systems,
        but it is complicated, error prone, and has problems with more complex documents
        (involving style, box models, complex tables etc.). 
        So now, as we have gigabytes of memory, noone would do it that way.
        Meaning: 
            it ought to be rewritten, to implement a proper dom tree, and the drawing
            engine to implement a proper box model.

        However: 
            we are not going into the browser business here and there is no return of 
            investment if we tried.

        The HTMPainter was written for, and should only be used to display simple help texts, 
        online documentation and html tooltips.
        It will also not be enhanced and maintained, except for obvious bugs which
        break rendering the above mentioned use cases.
        
        Anyone in need for such a thing should investigate better renderers 
        (which exist - both written in Smalltalk and as plugins, 
         using common rendering engines or embedded frameworks like CEF).

    [pending bugs:]
        these should be fixed, to make the documentation viewing nicer.
        - <nobr> must    collect text and determine if a break should be done at the beginning
        - <pre>...</pre> inserts an extra empty line
        - <table>        is almost useless

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentView
"
! !

!HTMLDocumentPainter class methodsFor:'initialization'!

initialize
    LEFTmargin := 20.
    RIGHTmargin := 20.
    TOPmargin := 20.
    BOTTOMmargin := 20.
    ULindent := 20.
    DLindent := 20.
    OLindent := 20.
    BLOCKQUOTEindent := 20.
    SUPshift := 4.

    InternalAppletsFirst := false.

    "
     self initialize
    "

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 10.10.1996 / 20:58:43 / cg"
! !

!HTMLDocumentPainter class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HTMLDocumentPainter class methodsFor:'contents'!

headerAsString:anArray depht:depth
    <resource: #obsolete>
    self obsoleteMethodWarning:'Typo in selector name. Use #headerAsString:depth:'.

    ^ self headerAsString:anArray depth:depth

    "Modified: / 07-09-1996 / 18:13:17 / cg"
    "Modified: / 10-04-2017 / 06:54:25 / mawalch"
!

headerAsString:anArray depth:depth
    "returns printable header assigned to array
    "
    |header|

    header := ''.

    1 to:depth do:[:i|
        header := header, (anArray at:i) printString, '.'
    ].
"/    ^ header copyWithoutLast:1
    ^ header

    "Created: / 10-04-2017 / 06:52:28 / mawalch"
! !

!HTMLDocumentPainter class methodsFor:'helpers'!

fontFor:aFont onDevice:aDevice
    |deviceFont fontUsed sz startSize|

    fontUsed := aFont.
    sz := startSize := fontUsed size.
    [
        deviceFont := fontUsed onDevice:aDevice ifAbsent:nil.
        deviceFont notNil ifTrue:[^ deviceFont].
        sz := sz + 1.
        fontUsed := fontUsed asSize:sz.
        sz > (startSize*2) ifTrue:[
            ^ fontUsed replacementFontOnDevice:aDevice
        ].
    ] loop.
!

romanStringFor:aNumber
    ^ String streamContents:[:stream | aNumber printRomanOn:stream naive:true].

"/     aNumber >= 100 ifTrue:[
"/        ^ 'C' , (self romanStringFor:aNumber - 100)
"/    ].
"/    aNumber >= 50 ifTrue:[
"/        ^ 'L' , (self romanStringFor:aNumber - 50)
"/    ].
"/    aNumber >= 10 ifTrue:[
"/        ^ 'X' , (self romanStringFor:aNumber - 10)
"/    ].
"/    aNumber >= 5 ifTrue:[
"/        ^ 'V' , (self romanStringFor:aNumber - 5)
"/    ].
"/    aNumber >= 1 ifTrue:[
"/        ^ 'I' , (self romanStringFor:aNumber - 1)
"/    ].
"/    ^ ''

    "
     HTMLDocumentPainter new romanStringFor:110  
     HTMLDocumentPainter new romanStringFor:99  
     HTMLDocumentPainter new romanStringFor:9   
     HTMLDocumentPainter new romanStringFor:4    
     HTMLDocumentPainter new romanStringFor:5   
    "

    "Created: / 22.6.1996 / 16:49:01 / cg"
    "Modified: / 31.7.2002 / 09:47:41 / cg"
! !

!HTMLDocumentPainter class methodsFor:'image specs'!

bullet1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet1 inspect
     ImageEditor openOnClass:self andSelector:#bullet1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet1'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@@@@@@@@@H@@@@@@@@@@@@@@@b') ; yourself]
!

bullet2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet2 inspect
     ImageEditor openOnClass:self andSelector:#bullet2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet2'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@@@@@@@@@L@@0@@@@@@@@@@@@b') ; yourself]
!

bullet3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet3 inspect
     ImageEditor openOnClass:self andSelector:#bullet3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet3'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@@@@@@C@@^@A8@C@@@@@@@@@@b') ; yourself]
!

bullet4
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet4 inspect
     ImageEditor openOnClass:self andSelector:#bullet4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet4'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@@@@0@G @?@C<@G @L@@@@@@@b') ; yourself]
!

bullet5
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet5 inspect
     ImageEditor openOnClass:self andSelector:#bullet5
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet5'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@@@A8@O0@?@C<@O0@^@@@@@@@b') ; yourself]
!

bullet6
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet6 inspect
     ImageEditor openOnClass:self andSelector:#bullet6
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet6'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@\@C8@_0A?@G<@O @\@@@@@@@b') ; yourself]
!

bullet7
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet8 inspect
     ImageEditor openOnClass:self andSelector:#bullet8
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet7'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@^@C<@_8A? G>@_8@?@A8@@@@b') ; yourself]
!

bullet8
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bullet8 inspect
     ImageEditor openOnClass:self andSelector:#bullet8
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HTMLDocumentPainter bullet8'
        ifAbsentPut:[(Depth1Image new) width:10; height:10; bits:(ByteArray fromPackedString:'@@@^@C<@_8A? G>@_8@?@A8@@@@b') ; yourself]
! !

!HTMLDocumentPainter methodsFor:'accessing'!

applets
    "return a collection of my applets"

    ^ applets ? #()

    "Created: / 21.9.1996 / 14:49:28 / cg"
    "Modified: / 11.11.1998 / 00:57:15 / cg"
!

arrayOfHeaderIndex
    "returns current header index
    "
    ^ arrayOfHeaderIndex
!

forms
    "return a collection of my forms"

    ^ forms ? #()

    "Modified: / 11.11.1998 / 00:57:34 / cg"
!

imageResolver:somethingProvidingImagesGivenURL
    imageResolver := somethingProvidingImagesGivenURL.

    "Modified (format): / 29-06-2018 / 16:35:32 / Claus Gittinger"
!

leftMargin
    ^ leftMargin
!

leftMargin:something
    leftMargin := something.
!

listOfHeaders
    " returns current list of headers
    "
    ^ listOfHeaders

!

rightMargin
    ^ rightMargin
!

rightMargin:something
    rightMargin := something.
!

scriptObject
    "return my scriptObject - if any"

    ^ scriptObject

    "Modified: 21.9.1996 / 14:50:41 / cg"
    "Created: 27.9.1996 / 12:54:37 / cg"
!

topMargin
    ^ topMargin
!

topMargin:something
    topMargin := something.
! !

!HTMLDocumentPainter methodsFor:'accessing-private'!

currentBGColor
    ^ currentBGColor

    "Created: / 17-09-2007 / 11:58:44 / cg"
!

currentColIndex
    ^ currentColIndex

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentColor
    ^ currentColor

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentElement
    ^ element

    "Created: 17.9.1996 / 19:26:53 / cg"
    "Modified: 9.10.1996 / 18:21:01 / cg"
!

currentFont
    ^ currentFont

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentFontAscent
    ^ fontAscent

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentFontAvgHeight
    ^ fontAvgHeight

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentFontHeight
    ^ fontHeight

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentForm
    ^ currentForm

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentIndentOffset
    ^ indentOffset

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentLeftIndent
    ^ leftIndent

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentRightIndent
    ^ rightIndent

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentRowIndex
    ^ currentRowIndex

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentTable
    ^ currentTable

    "Created: 22.6.1996 / 16:48:59 / cg"
!

currentUnderlineColor
    ^ currentUnderlineColor
!

document:aDocument
    document := aDocument

    "Created: 22.6.1996 / 16:48:59 / cg"
!

hBegin
    ^ hBegin

    "Created: 22.6.1996 / 16:48:59 / cg"
!

haveSpace
    ^ haveSpace

    "Modified: 21.5.1996 / 21:33:44 / cg"
    "Created: 24.6.1997 / 17:23:40 / cg"
!

inBLOCKQUOTE
    ^ inBLOCKQUOTE

    "Created: 22.6.1996 / 16:48:59 / cg"
!

inCenter
    ^ center

    "Created: 19.9.1996 / 12:25:59 / cg"
!

inDL
    ^ inDL

    "Modified: 21.5.1996 / 21:30:37 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

inKbd
    ^ inKbd

    "Created: 11.4.1997 / 23:44:48 / cg"
!

inNoBreak
    ^ noBreak

    "Created: 22.6.1996 / 16:48:59 / cg"
!

inOL
    ^ inOL

    "Created: 22.6.1996 / 16:48:59 / cg"
!

inPre
    ^ inPre

    "Created: 22.6.1996 / 16:48:59 / cg"
!

inRightAlign
    ^ rightAlign

    "Created: 1.10.1996 / 14:41:02 / cg"
!

inStrikeout
    ^ strikeout

    "Created: 22.6.1996 / 16:48:59 / cg"
!

inSup
    ^ inSup

    "Created: 22.6.1996 / 16:48:59 / cg"
!

inUnderline
    ^ underline

    "Created: 22.6.1996 / 16:48:59 / cg"
!

needSpace
    ^ needSpace

    "Modified: 21.5.1996 / 21:33:44 / cg"
    "Created: 18.9.1996 / 12:04:36 / cg"
!

previousIsEmpty
    ^ previousIsEmpty

    "Created: 22.6.1996 / 16:48:59 / cg"
!

styleStack
    ^ styleStack

    "Created: 22.6.1996 / 16:48:59 / cg"
!

ulLevel
    ^ ulLevel

    "Created: 22.6.1996 / 16:48:59 / cg"
!

xPosition
    ^ x

    "Modified: 21.5.1996 / 21:33:44 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

yNextLine
    ^ yNextLine

    "Created: 22.6.1996 / 16:48:59 / cg"
!

yPosition
    ^ y

    "Created: 22.6.1996 / 16:48:59 / cg"
!

yText
    ^ yText

    "Modified: 21.5.1996 / 21:30:11 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
! !

!HTMLDocumentPainter methodsFor:'applets'!

createAppletFor:element
    |v wWant hWant lvl cls code codeBase archive t fn|

    destination isView ifFalse:[^ self].

    wWant := element numericParameterFor:#'WIDTH'.
    wWant isLimitedPrecisionReal ifTrue:[
        wWant := nil
    ].
    hWant := element numericParameterFor:#'HEIGHT'.
    hWant isLimitedPrecisionReal ifTrue:[
        anyElementsWithRelativeHeight := true.
        hWant := nil
    ].

    (v := element view) isNil ifTrue:[
        cls := element appClass.
        (cls isBehavior or:[cls == #delayedJavaLoad]) ifFalse:[
            Transcript showCR:'missing or bad class specified in applet tag'.
            ^ self
        ].

        lvl := element numericParameterFor:#'LEVEL' default:0.
        destination is3D ifFalse:[
            lvl := 0.
        ].

        code := element parameterFor:#'CODE'.

        codeBase := element parameterFor:#'CODEBASE'.
        codeBase isNil ifTrue:[
            t := element parameterFor:#'CODE'.
            t isNil ifTrue:[
                t := element parameterFor:#'URL'.
            ].
            t notNil ifTrue:[
                codeBase := t asFilename directoryName.
            ].
            codeBase isNil ifTrue:[
                codeBase := '???'
            ]
        ].
        codeBase asFilename isAbsolute ifFalse:[
            codeBase := (destination currentDirectoryName asFilename construct:codeBase) pathName
        ].

        archive := element parameterFor:#'ARCHIVE'.
        archive notNil ifTrue:[
            archive asFilename isAbsolute ifFalse:[
                archive := (destination currentDirectoryName asFilename construct:archive) pathName
            ]
        ].

        wWant isNil ifTrue:[wWant := 100].
        hWant isNil ifTrue:[hWant := 100].
    ] ifFalse:[
        wWant isNil ifTrue:[wWant := v width].
        hWant isNil ifTrue:[hWant := v height].
    ].

    "/ create the applet
    (cls isJavaClass 
    or:[cls == #delayedJavaLoad]) ifTrue:[
        Java isNil ifTrue:[
            Transcript showCR:'no Java support'.
            ^ self
        ].
        "/
        "/ a java applet
        "/
        createdAppletFrames size == 0 ifTrue:[
            destination infoDisplay:'initialize Java system ...'.
            Java startupJavaSystem.
            createdAppletFrames := IdentityDictionary new.
            appletContext := JavaEmbeddedFrameView newAppletContext.
            appletContext isNil ifTrue:[
                ^ self
            ]
        ] ifFalse:[
            JavaVM initializeVMIfNoEventThreadRunning
        ].
        appletContext isNil ifTrue:[
            self halt:'oops - no appletContext'.
            ^ self
        ].

        v := JavaEmbeddedFrameView in:destination.
        v extent:(wWant @ hWant).
        v level:lvl.
        v viewBackground:destination viewBackground.

        v infoDisplayReceiver:destination.

        fn := (codeBase asFilename construct:code) pathName.
"/        "/ temp kludge
"/        (fn startsWith:'C:') ifTrue:[
"/            fn := '/C|' , (fn copyFrom:3)
"/        ].
        v codeBaseURL:('file:' , fn).
        v documentURL:('file:' , destination currentURL).
        archive notNil ifTrue:[v archiveURL:('file:' , archive "codeBase")].
        v codeURL:code.
        v parameterDictionary:element parameters.

        v appletID:(createdAppletFrames size + 1).
        (v setupAppletFrameIn:appletContext initializeJava:false) ifFalse:[
            self warn:'cannot setup appletFrame'.
            ^ self
        ].

        element view:v.
        createdAppletFrames at:element put:v.

        v startApplet.
        ^ self.
    ].

    "/
    "/ a smalltalk applet
    "/
    v isNil ifTrue:[
        v := cls in:destination.
    ] ifFalse:[
        destination add:v.
    ].
    v viewBackground:(formattingStyle viewBGColor).
    v extent:(wWant @ hWant).
    v level:lvl.

    (v isKindOf:Applet) ifTrue:[
        v resolver:imageAndStyleResolver.
        v codeBase:element codeBase.
        v parameters:element parameters.
        v init
    ].
    element view:v.

    "Modified: / 24.12.1999 / 01:38:35 / cg"
!

defineAppletParameterFor:element
    |name value env|

    currentApplet notNil ifTrue:[
        env := currentApplet parameters.
    
        "/ add it to its environment information
        env isNil ifTrue:[
            env := IdentityDictionary new.
            currentApplet parameters:env.
        ].
        name := element nameString.
        name notNil ifTrue:[
            value := element valueString.
            env at:name asSymbol put:value
        ].
    ].

    "Modified: 4.1.1997 / 23:30:54 / cg"
!

destroyApplet:appletElement
    |v appletView|

    v := appletElement view.
    v notNil ifTrue:[appletElement view:nil. v destroy].

    applets isNil ifTrue:[
        ^ self.
    ].

    applets remove:appletElement.
    applets := applets asNilIfEmpty.

    createdAppletFrames isNil ifTrue:[
        appletContext := nil.
        ^ self.
    ].

    appletView := createdAppletFrames at:appletElement ifAbsent:nil.
    appletView isNil ifTrue:[^ self].

    appletView stopApplet.

    createdAppletFrames removeKey:appletElement.
    createdAppletFrames := createdAppletFrames asNilIfEmpty.

    "Modified: / 20.10.1998 / 15:43:01 / cg"
!

setupAppletElement:element
    |wWant hWant lvl clsName url cls codeBase archive id view|

    destination isView ifFalse:[^ self].

    wWant := element numericParameterFor:#'WIDTH'.
    hWant := element numericParameterFor:#'HEIGHT'.

    lvl := element numericParameterFor:#'LEVEL' default:0.
    destination is3D ifFalse:[
        lvl := 0.
    ].

    id := element parameterFor:#'widgetid'.
    id notNil ifTrue:[
        view := WidgetQuery raiseRequestWith:id.
        element view:view.
    ] ifFalse:[
        clsName := element parameterFor:#'CLASS'.
        codeBase := element parameterFor:#'CODEBASE'.
        archive := element parameterFor:#'ARCHIVE'.

        url := element parameterFor:#'URL'.
        url isNil ifTrue:[
            url := element parameterFor:#'CODE'.
            (url notNil and:[url endsWith:'.cls']) ifTrue:[
                clsName := url copyButLast:4
            ].

            InternalAppletsFirst ifTrue:[
                clsName notNil ifTrue:[
                    (Smalltalk classNamed:clsName) notNil ifTrue:[
                        "/ already present.
                        url := nil.
                    ]
                ]
            ]
        ].

        url isNil ifTrue:[
            clsName isNil ifTrue:[
                ('HTML [info]: no class given for applet:' , url printString) infoPrintCR.
                ^ self
            ].

            "/ the class must be already in the image ..
            destination internalAppletsEnabled ifFalse:[
                clsName isNil ifTrue:[
                    clsName := url printString.
                ].
                ('HTML [info]: internal applets disabled: ' , clsName) infoPrintCR.
                ^ self
            ].
            cls := Smalltalk classNamed:clsName.
        ] ifFalse:[
            destination alienAppletsEnabled ifFalse:[
                clsName isNil ifTrue:[
                    clsName := url printString.
                ].
                ('HTML: alien applets disabled: ' , clsName) infoPrintCR.
                ^ self
            ].

            codeBase notNil ifTrue:[
                url := (codeBase asFilename construct:url) pathName.
            ].
            clsName isNil ifTrue:[
                "/ no CLASS= param in applet tag;
                "/ look for CODE=
                clsName := url asFilename withoutSuffix baseName.
            ].
            cls := imageAndStyleResolver appletClass:clsName fromURL:url archive:archive.
            cls notNil ifTrue:[
                codeBase := imageAndStyleResolver fullURLPathFor:url.
                codeBase notNil ifTrue:[
                    codeBase := codeBase asFilename directoryName asString.
                ]
            ]
        ].

        cls isNil ifTrue:[
            clsName := url printString.
            ('HTML [info]: applet class not found/loadable: ' , clsName) infoPrintCR.
            ^ self
        ].

        element codeBase:codeBase.
        element archive:codeBase.
        element appClass:cls.
    ].

    widgets isNil ifTrue:[
        widgets := OrderedCollection new.
    ].
    widgets add:element.

    applets isNil ifTrue:[
        applets := OrderedCollection new.
    ].
    applets add:element.

    "Created: / 8.10.1996 / 18:50:51 / cg"
    "Modified: / 14.10.1998 / 13:29:48 / cg"
! !

!HTMLDocumentPainter methodsFor:'checking'!

checkInitialStateAtEndOfDocument
    "check for correct closing TAGS.
     Although, most HTML viewers can handle this case, its usually an
     indication of some error and often leads to badly formatted documents"

    center > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </center> for <center>'
    ].
    inKbd > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </kbd> for <kbd>'
    ].
    inPre > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </pre> for <pre>' 
    ].
    inDL > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </dl> for <dl>' 
    ].
    inOL > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </ol> for <ol>' 
    ].
    ulLevel > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </ul> for <ul>' 
    ].
    inBLOCKQUOTE > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </blockquote> for <blockquote>' 
    ].
    underline > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </underline> for <underline>' 
    ].
    strikeout > 0 ifTrue:[
        self printCheckInfoMessage:'no matching </strikeout> for <strikeout>' 
    ].

    "Modified: 6.8.1997 / 13:47:53 / cg"
!

printCheckInfoMessage:msg
    'HTML [info]: ' infoPrint.
    msg infoPrint. 
    ' [at end in ''' infoPrint. 
    (imageAndStyleResolver currentURL ? 'unnamed') infoPrint. 
    ''']' infoPrintCR.

    "Created: 6.8.1997 / 13:16:53 / cg"
    "Modified: 6.8.1997 / 13:48:37 / cg"
! !

!HTMLDocumentPainter methodsFor:'contents'!

contentsAddHeader:text
    "assign text to header and store in list of headers
    "
    |hdef index|

    hdef := text withoutSeparators.

    (hdef notNil and:[hBegin notNil]) ifFalse:[
        ^ text
    ].

    headerDefinition notEmpty ifTrue:[
        headerDefinition := headerDefinition, ' ', hdef.
        ^ text
    ].

    headerDefinition := hdef.
    index := hBegin type asString last digitValue.
    hdef  := self class headerAsString:arrayOfHeaderIndex depth:index.
    ^ hdef, ' ', text withoutLeadingSeparators

    "Modified: / 20-10-1998 / 16:35:09 / cg"
    "Modified: / 10-04-2017 / 06:55:06 / mawalch"
!

printContents
    |saveY endPageOfCont|

    ((destination isView) or:[listOfHeaders isNil]) ifTrue:[
        ^ self
    ].
    formattingStyle printTOC ifFalse:[
        ^ self
    ].
    saveY  := y.

    Resources isNil ifTrue:[
        Resources := self class classResources.
    ].

    "/ print contents pages

    self printContents:listOfHeaders pageNumber:nil romanPageNumbers:true.
    endPageOfCont := destination pageCounter.

    "/ restore for normal pages

    destination pageStartAction:[:pageNr | 
        destination pageName:(pageNr - endPageOfCont) printString
    ].

    destination startPage.
    y := saveY.

    destination pageEndAction:([:pageNr||s cY cX font|
        s  := (Resources string:'page'), ' ', (pageNr - endPageOfCont) printString.
        font := destination titleFont.
        cY := (destination bottomMargin + font height + font ascent) // 2.
        cX := (destination width) - (font widthOf:s) - rightMargin.

        destination displayString:s x:(destination transformX:cX) y:cY.
        s := destination title.
        s notNil ifTrue:[
            destination displayString:s x:(destination transformX:0) y:cY
        ].
    ]).

    "Modified: 11.9.1996 / 20:35:48 / cg"
!

printContents:aList pageNumber:initialPageNumber romanPageNumbers:romanPageNumbers
    "print contents to destination
    "
    |hdrs indent indent2 indents pageX
     chapterLevel subChapterLevel pgDelta savedAnchor|

    (aList isEmptyOrNil) ifTrue:[
        ^ self
    ].

    Resources isNil ifTrue:[
        Resources := self class classResources.
    ].

    savedAnchor := element.

    formatting      := false.
    chapterLevel    := 1.
    subChapterLevel := 2.
    element         := HTMLMarkupText new.

    initialPageNumber notNil ifTrue:[
        pgDelta := destination pageCounter - initialPageNumber
    ].

    destination pageStartAction:[:pageNr |
        |pn s|

        initialPageNumber notNil ifTrue:[
            pn := pageNr - pgDelta.
        ] ifFalse:[
            pn := pageNr.
        ].
        romanPageNumbers ifTrue:[
            s  := self class romanStringFor:pn.
        ] ifFalse:[
            s := pn printString.
        ].
        destination pageName:s
    ].

    hdrs := self initialHeaderNumbers.
    self setFont:h1Font.

    element text:(Resources string:'Contents').
    self specialMarkup.
    self break.
    self setFont:normalFont.

    indent  := currentFont widthOf:(String new:10 withAll:$w).
    indent2 := indent // 5.
    indents := (1 to:6) collect:[:i | indent + ((i-1)*indent2)].

    indent2 := indent // 5.
    pageX  := currentRightLimit 
              - (currentFont widthOf:(String new:4 withAll:$w)).

    destination pageEndAction:([:pageNr|
        |s cY cX pn font|

        pgDelta notNil ifTrue:[
            pn := pageNr - pgDelta.
        ] ifFalse:[
            pn := pageNr.
        ].
        romanPageNumbers ifTrue:[
            s  := self class romanStringFor:pn.
        ] ifFalse:[
            s := pn printString.
        ].
        font := destination titleFont.
        cY := (destination bottomMargin + font height + font ascent) // 2.
        cX := (destination width) - (font widthOf:s) - rightMargin.

        destination displayString:s x:(destination transformX:cX) y:cY.
        s := destination title.

        s notNil ifTrue:[
            destination displayString:s x:(destination transformX:0) y:cY
        ].
    ]).
        
    aList do:[:el|
        |text page headerLevel string|

        headerLevel := el at:1.
        page  := el at:2.
        text  := el at:3.

        hdrs at:headerLevel put:((hdrs at:headerLevel) + 1).
        hdrs from:(headerLevel + 1) to:hdrs size put:0.

        indent := indents at:headerLevel.

        headerLevel == chapterLevel ifTrue:[
             indentOffset := indent.
             self break.
             self break.
             self setFont:boldNormalFont.
             text := (Resources string:'Chapter'), 
                     ' ', (hdrs at:1) printString, ':  ', text.
        ] ifFalse:[
             headerLevel == subChapterLevel ifTrue:[
                self break.
             ].
             element text:(self class headerAsString:hdrs depth:headerLevel).
             self specialMarkup.
             x < indent ifTrue:[
                 lastTextX := nil.
                 x := indent
             ].
        ].
        
        element text:text.
        self specialMarkup.
        lastTextX := nil.
        x > pageX ifTrue:[
            self break
        ].
        x := pageX.
        lastTextX := nil.

        element text:(page printString).
        self specialMarkup.
        indentOffset := 0.
        self break.

        headerLevel == chapterLevel ifTrue:[
            self setFont:normalFont.
            self break.
        ]
    ].

    lastTextX       := nil.
    previousIsEmpty := false.
    indentOffset    := 0.

    element := savedAnchor.

    "Created: / 11-09-1996 / 20:26:32 / cg"
    "Modified: / 06-03-1997 / 01:15:57 / cg"
    "Modified: / 10-04-2017 / 06:54:58 / mawalch"
! !

!HTMLDocumentPainter methodsFor:'displaying'!

displayX:xLeft y:yTop width:w height:h on:aGC
    |prevClip|

    document isNil ifTrue:[
        ^ self
    ].
    docWidth isNil ifTrue:[
        ^ self
    ].

    self hideWidgets.

    displayTop := yTop.
    displayBottom := (yTop + h - 1).
    displayLeft := xLeft.
    displayRight := (xLeft + w - 1).

    destination := aGC.
    formatting := scanning := false.

    leftIndent := leftMargin.
    rightIndent := rightMargin.
    currentRightLimit := docWidth - rightIndent.
    indentOffset := 0.

    needFontChange := needColorChange := true.
    self setFont:normalFont.
    normalFontHeight := fontAvgHeight.

    lastTextX := nil.
    tableColX := nil.
    x := leftIndent.
    y := topMargin + fontAscent.

    collectingText := inPre := inKbd := 0.
    ulLevel := inDL := inOL := inBLOCKQUOTE := 0.
    underline := strikeout := inSup := 0.

    self setColor:textFGColor.

    yNextLine := nil.

    formatting := scanning := false.
    previousIsEmpty := false.
    liStack := OrderedCollection new.

    anchorElement := hBegin := nil.

    destination isView ifTrue:[
        prevClip := destination clippingBoundsOrNil.
        destination clippingBounds:(xLeft@yTop extent:w@h).

        AbortOperationRequest catch:[
            self redrawDocument.
        ].

        destination clippingBounds:prevClip.
        self showWidgets.
    ] ifFalse:[
        self redrawDocument.
    ].

"/    self conditionalBreak.

    "Created: / 22.6.1996 / 16:48:59 / cg"
    "Modified: / 11.11.1998 / 01:00:13 / cg"
!

pageBreak
    "/ (y > self pageBreakLimit and:[self atLeft and:[destination isView not]]) ifTrue:[

    (destination isView or:[self atTop]) ifFalse:[
        formatting ifFalse:[
            destination startPage
        ] ifTrue:[
            pageNumber := pageNumber + 1
        ].

        lastTextX := nil.
        previousIsEmpty := true.
        y := destination topMargin. 
    ].

    "Modified: 7.9.1996 / 17:04:50 / cg"
!

pageBreakLimit
    |h|

    h := destination height.

    ^ destination isView ifTrue:[h]
                        ifFalse:[h - destination bottomMargin]
!

redrawDocument
    lock critical:[
        |startIndex syncPoint displayHeight pageLimit type e syncTop skip selectorTable|

        selectorTable := self class selectorTable.

        displayHeight := 9999999.
        docWidth isNil ifTrue:[
            ^ self
        ].

        destination isView ifFalse:[
            displayHeight := destination height.
        ].

        "/ find a synchronization point

        (destination isView not
        or:[syncPoints size]) == 0 ifTrue:[
            startIndex := 0
        ] ifFalse:[
            "/ have to resync from above the element which draws below displayTop;
            "/ the previous element could be large and cover the area below
            "/ (especially images do)

            syncTop := displayTop - destination height. "/ an image or applet which covers a whole page.
            syncTop := syncTop max:0.
            startIndex := syncPoints findFirst:[:p | p yPosition >= syncTop].
            startIndex := startIndex - 1.
            startIndex > 0 ifTrue:[
                syncPoint := syncPoints at:startIndex
            ]
        ].

        syncPoint notNil ifTrue:[
            "/
            "/ if in a table, go back to the start of the table
            "/
            syncPoint currentTable notNil ifTrue:[
                [syncPoint currentElement type ~~ #table
                and:[startIndex > 1]] whileTrue:[
                    startIndex := startIndex - 1.
                    syncPoint := syncPoints at:startIndex
                ]
            ].
        ].

        syncPoint notNil ifTrue:[
            "/ fetch the state found there
            self resyncFrom:syncPoint.
            e := element := syncPoint currentElement.
        ] ifFalse:[
            self setupInitialState.
            e := element := document.
        ].

        pageLimit := self pageBreakLimit.

        self printContents.

        alreadyDisplayedTableElements := IdentitySet new.

        [e notNil] whileTrue:[
            type := e type.
            (skip := currentApplet notNil) ifTrue:[
                "/ skip upto applet end
                ((type == #'/app') or:[type == #'/applet']) ifTrue:[
                    skip := false
                ]
            ].
            inNoPrintingParagraph > 0 ifTrue:[
                destination isView ifFalse:[ 
                    (type = 'p' or:[type = '/p']) ifFalse:[
                        skip := true.
                    ].
                ]
            ].
            skip ifFalse:[
                type isNil ifTrue:[
                    self specialMarkup
                ] ifFalse:[
                    type := selectorTable at:type ifAbsent:nil.
                    type notNil ifTrue:[
                        self perform:type
                    ]
                ].

                y > (displayBottom+fontHeight) ifTrue:[
                    "/ finish current table's row, if any
                    currentTable isNil ifTrue:[
                        alreadyDisplayedTableElements := nil.
                        ^ self
                    ].
                ].
            ].
            element := e := e next.
        ].

        alreadyDisplayedTableElements := nil.
    ].

    "Created: / 22.6.1996 / 16:48:59 / cg"
    "Modified: / 20.10.1998 / 16:07:04 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-document'!

body
    |bg img clr lM tM rM|

    inHeader ifTrue:[
        scanning ifTrue:[
            'HTML: missing </head> before <body>' infoPrintCR.
        ].
        inHeader := false.
    ].

    scanning ifFalse:[^ self].

    lM := element numericParameterFor:#'LEFTMARGIN' default:leftMargin.
    lM ~~ leftMargin ifTrue:[
        leftIndent := leftIndent - leftMargin + lM.
        x := x - leftIndent - leftMargin + lM.
        leftMargin := lM.
    ].
    tM := element numericParameterFor:#'TOPMARGIN' default:topMargin.
    tM ~~ topMargin ifTrue:[
        y := y - topMargin + tM.
        topMargin := tM.
    ].
    rM := element numericParameterFor:#'RIGHTMARGIN' default:rightMargin.
    rM ~~ rightMargin ifTrue:[
        rightIndent := rightIndent - rightMargin + rM.
        rightMargin := rM.
        currentRightLimit := docWidth - rightIndent.
    ].

    destination isView ifTrue:[
        bg := element parameterFor:#'BACKGROUND'.
        bg notNil ifTrue:[
            imageResolver isBlock ifTrue:[
                img := imageResolver value:bg.
                img isNil ifTrue:[
                    img := (imageResolver ? imageAndStyleResolver) imageFor:bg now:true.
                ].
            ] ifFalse:[
                img := (imageResolver ? imageAndStyleResolver) imageFor:bg now:true.
            ].
        ].

        img notNil ifTrue:[
            clr := (img asFormOn:destination device).
        ] ifFalse:[
            clr := element colorParameter:#'BGCOLOR'.
            clr isNil ifTrue:[
                clr := formattingStyle viewBGColor.
                        "/ destination defaultViewBackgroundColor
            ].
        ].
        destination viewBackground:clr.
    ].

    clr := element colorParameter:#'TEXT'.
    clr notNil ifTrue:[  
        textFGColor := clr
    ].

    clr := element colorParameter:#'LINK'.
    clr notNil ifTrue:[
        anchorFGColor := clr
    ].

    clr := element colorParameter:#'VLINK'.
    clr notNil ifTrue:[
        visitedAnchorFGColor := clr
    ].

    clr := element colorParameter:#'ALINK'.
    clr notNil ifTrue:[
        activeAnchorFGColor := clr
    ].

    clr := element colorParameter:#'CODECOLOR'.
    clr notNil ifTrue:[
        codeFGColor := clr
    ].

    "Created: / 22-06-1996 / 16:48:59 / cg"
    "Modified: / 19-10-1997 / 22:35:24 / cg"
    "Modified: / 19-06-2018 / 17:11:09 / Claus Gittinger"
!

head
    inHeader := true

    "Modified: 24.2.1997 / 11:40:37 / cg"
!

headEnd
    inHeader := false

    "Modified: 24.2.1997 / 11:40:42 / cg"
!

meta
    |metaCommand metaArg|

    (scanning and:[inHeader]) ifTrue:[
        metaCommand := element parameterFor:#'HTTP-EQUIV'.
        metaCommand notNil ifTrue:[
            (metaCommand := metaCommand asLowercase) = 'refresh' ifTrue:[
                metaArg := element parameterFor:#'CONTENT'.
                metaArg notNil ifTrue:[
                    metaCommands isNil ifTrue:[
                        metaCommands := OrderedCollection new.
                    ].
                    metaCommands add:(metaCommand -> metaArg).
                    ^ self.
                ]
            ].
            metaCommand = 'content-type' ifTrue:[
                "/ already handled in parser ...
                ^ self.
            ].
            ('HTML [info]: unrecognized meta/args: ' , metaCommand) infoPrintCR
        ]
    ]

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 30.6.1997 / 20:13:52 / cg"
!

title
    collectingText := collectingText + 1.
    scanning ifTrue:[
        collectedText := ''
    ]

    "Modified: 24.5.1996 / 15:57:18 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

titleEnd
    |t|

    collectingText > 0 ifTrue:[
        collectingText := collectingText - 1.
        scanning ifTrue:[
            collectedText notNil ifTrue:[
                t := collectedText withoutSeparators.
                destination title:t.
            ].
            collectedText := nil.
        ]
    ] ifFalse:[
        scanning ifTrue:[
            'HTML: </TITLE> but not within TITLE tag' errorPrintCR
        ]
    ]

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 30.6.1997 / 13:02:32 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-forms'!

anyFormElement:element
    |widget|

    currentForm isNil ifTrue:[
        'HTML [info]: form element tag - but not within form' infoPrintCR.
        ^ self
    ].

    widget := element view.
    widget notNil ifTrue:[
        formatting ifTrue:[
            element bounds:(x @ (y-fontAscent) extent:(widget extent)).
        ].
        x ~~ element bounds origin x ifTrue:[
            "/
            "/ the element may have moved (in a table)
            "/
            element bounds:(x @ (y-fontAscent) extent:(widget extent))
        ].
        x := x + widget width + wSpace.
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 10.1.1997 / 15:41:20 / cg"
!

form
    currentForm notNil ifTrue:[
        'HTML [info]: form within form - ignored' infoPrintCR.
    ] ifFalse:[
        destination isView ifTrue:[
            yNextLine isNil ifTrue:[yNextLine := 0].
            yNextLine := yNextLine max:(y + element maxHeight + 3).
        ].
        self conditionalBreak.
        currentForm := element.
        scanning ifTrue:[
            forms isNil ifTrue:[
                forms := OrderedCollection new.
            ].
            forms add:currentForm.
        ]
    ]

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 1.2.1997 / 20:12:32 / cg"
!

formEnd
    currentForm isNil ifTrue:[
        'HTML [info]: </FORM> but not within a form' errorPrintCR.
        ^ self
    ].

    scanning ifTrue:[
        currentTextAreaElement notNil ifTrue:[
            'HTML [info]: unterminated textarea' infoPrintCR.
            self textareaEnd.
        ]
    ].

    self conditionalBreak.

    scanning ifTrue:[
        self fixupForm:currentForm.
    ].
    currentForm := nil

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 10.1.1997 / 15:41:56 / cg"
!

input
    self anyFormElement:element

    "Modified: 24.5.1996 / 16:09:00 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

prescanForm:aFormElement
    "prescan a form, for its widgets max height.
     a kludge - we need the form elements' heights BEFORE
     formatting (since the text-elements have no origin knowledge,
     which could be backpatched (also, we needed a way to break
     MarkupText into multiple individual text items"

    |e type|

    aFormElement maxHeight:0.
    e := aFormElement next.

    [e notNil] whileTrue:[
        type := e type.
        type == #'/form' ifTrue:[^ self].

        type == #form ifTrue:[
            'HTML [info]: unterminated form' infoPrintCR.
            ^ self
        ].

        (type == #input or:[type == #textarea]) ifTrue:[
           self createWidgetFor:e inForm:aFormElement
        ].

        e := e next.
    ].

    "Created: 9.10.1996 / 18:26:04 / cg"
    "Modified: 10.1.1997 / 17:51:54 / cg"
!

prescanForms
    "a kludge - we need the form elements' heights BEFORE
     formatting - since the text-elements have no origin knowledge,
     which could be backpatched (also, we needed a way to break
     MarkupText into multiple individual text items)"

    |e type|

    e := document.
    [e notNil] whileTrue:[
        type := e type.

        type == #form ifTrue:[
            self prescanForm:e
        ].

        ((type = #app) or:[type = #applet]) ifTrue:[
            currentApplet notNil ifTrue:[
                'oops : nested <applet> tag' infoPrintCR.
            ].
            currentApplet := e.
            self setupAppletElement:e
        ].

        type == #param ifTrue:[
            self defineAppletParameterFor:e
        ].

        ((type = #'/app') or:[type = #'/applet']) ifTrue:[
            currentApplet isNil ifTrue:[
                'oops : </applet> without <applet> tag' infoPrintCR.
            ] ifFalse:[
                self createAppletFor:currentApplet.
            ].
            currentApplet := nil.
        ].
        e := e next.
    ]

    "Created: / 22.6.1996 / 16:49:02 / cg"
    "Modified: / 9.4.1998 / 21:14:23 / cg"
!

textarea
    collectingText := collectingText + 1.
    currentTextAreaElement := element.
    scanning ifTrue:[
        collectedText := ''
    ].

    "Modified: 24.5.1996 / 16:13:00 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

textareaEnd
    collectingText := collectingText - 1.
    self anyFormElement:currentTextAreaElement.
    scanning ifTrue:[
        currentTextAreaElement view notNil ifTrue:[
            currentTextAreaElement view contents:collectedText.
        ].
    ].
    currentTextAreaElement := nil.

    "Created: / 22-06-1996 / 16:48:59 / cg"
    "Modified: / 01-04-2011 / 15:16:51 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-lists'!

blockquote
    self conditionalEmpty.

    leftIndent := leftIndent + BLOCKQUOTEindent.
    x := x + BLOCKQUOTEindent.  lastTextX := nil.
    inBLOCKQUOTE := inBLOCKQUOTE + 1.

    "Modified: 21.5.1996 / 12:31:56 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

blockquoteEnd
    self conditionalEmpty.

    inBLOCKQUOTE := inBLOCKQUOTE - 1.
    inBLOCKQUOTE < 0 ifTrue:[
        'HTML: </blockquote> does not match any <blockquote>' errorPrintCR.
        inBLOCKQUOTE := 0.
    ] ifFalse:[
        leftIndent := leftIndent - BLOCKQUOTEindent.
        x := x - BLOCKQUOTEindent.  lastTextX := nil.
    ].

    "Modified: 21.5.1996 / 11:28:48 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

dd
    "/ self conditionalBreak.
    self break

    "Modified: 26.5.1997 / 15:32:42 / cg"
!

dir
    self ul.
    element markerType isNil ifTrue:[
        element markerType:'disc'.
    ]

    "Modified: 18.6.1996 / 22:44:18 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

dirEnd
    self ulEnd

    "Created: 22.6.1996 / 16:48:59 / cg"
!

dl
    self conditionalBreak.
    leftIndent := leftIndent + DLindent.
    x := x + DLindent.  lastTextX := nil.

    inDL == 0 ifTrue:[
        previousIsEmpty ifFalse:[
            self break
        ]
    ].
    formatting ifTrue:[
        liStack add:element.
    ].
    inDL := inDL + 1.

    "Modified: 18.6.1996 / 22:19:13 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

dlEnd
    self conditionalBreak.

    inDL := inDL - 1.
    inDL < 0 ifTrue:[
        'HTML: </dl> does not match any <dl>' errorPrintCR.
        inDL := 0.
    ] ifFalse:[
        leftIndent := leftIndent - DLindent.
        x := x - DLindent.  lastTextX := nil.
        formatting ifTrue:[
            liStack removeLast
        ]
    ].

    inDL == 0 ifTrue:[
        self conditionalEmpty.
    ]

    "Modified: 18.6.1996 / 22:09:21 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

dt
    self conditionalBreak.
    inDL == 0 ifTrue:[
        scanning ifTrue:[
            'HTML [info]: <dt> but not within <dl> ... </dl>' infoPrintCR.
        ]
    ] ifFalse:[
        x := x - DLindent.
        needSpace := false.
    ].

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 10.1.1997 / 15:41:47 / cg"
!

li
    |xL yT listElement nr nrType nrString letterRange letterStart
     markerType markerSize elNr|

    self conditionalBreak.
    y := y + formattingStyle extraListItemSpacing.

    previousIsEmpty := true.    "/ this will ignore a followup BR or P

    liStack isEmpty ifTrue:[
        'HTML [info]: <li> but not within a list' infoPrintCR.
        ^ self
    ].

    "/ when reformatted, <li> markup is changed into either
    "/ <li_ul> or <li_ol>.
    "/ when displayed, <li> is never encountered ..

    formatting ifFalse:[
        self halt:'li called but not formatting - cannot happen'.
        ^ self.
    ].

    listElement := liStack last.
    listElement isNil ifTrue:[self halt:'oops - no current list element'].

    markerType := listElement markerType.
    markerType notNil ifTrue:[
        markerType := markerType asLowercase.
        markerType = 'none' ifTrue:[
            markerType := nil.
        ].
        listElement markerType:markerType.
    ].
    element markerType:markerType.

    nr := listElement nextNumber.

    (markerType = 'disc' 
    or:[markerType = 'arrow']) ifTrue:[
        markerSize := 15@10
    ] ifFalse:[
        ((markerType = 'square')
        or:[markerType = 'filledsquare']) ifTrue:[ 
            markerSize := 8@8
        ] ifFalse:[
            ulLevel > 2 ifTrue:[
                markerSize := 5@5
            ] ifFalse:[
                markerSize := 7@7
            ]
        ]
    ].

    destination isView ifFalse:[
        markerSize := markerSize * 0.7  "/ what a kludge
    ].

    nr isNil ifTrue:[
        "/ in <ul> ... </ul>
        "/ draw a bullet

        (markerType = 'disc' 
        or:[markerType = 'arrow']) ifTrue:[
            xL := x - (markerSize x + 1) - 8
        ] ifFalse:[
            xL := x - (markerSize x + 2) - 4.
        ].
        yT := y - (fontAscent//2) "+ 1" - (markerSize y // 2).
"/        markerType isNil ifTrue:[
"/            xL := 0
"/        ] ifFalse:[
"/            (markerType = 'disc' 
"/            or:[markerType = 'arrow']) ifTrue:[
"/                xL := x - 16 - 4
"/            ] ifFalse:[
"/                xL := x - 10 - 4.
"/            ].
"/        ].
"/        yT := y - (fontAscent//2) + 1 - 3.

        element type:#'li_ul'.
        element nr:ulLevel.
        element origin:(xL @ yT).
        ^ self
    ].

    (elNr := element numericParameterFor:#'VALUE') notNil ifTrue:[
        nr := elNr.
        listElement nextNumber:nr.
    ].

    nrType := listElement numberType.

    letterRange := $Z codePoint - $A codePoint + 1.
    nrType == #uppercaseLetters ifTrue:[
        letterStart := $A
    ] ifFalse:[
        nrType == #lowercaseLetters ifTrue:[
            letterStart := $a
        ] ifFalse:[
            nrType == #uppercaseRoman ifTrue:[
                nrString := self class romanStringFor:nr
            ] ifFalse:[
                nrType == #lowercaseRoman ifTrue:[
                    nrString := (self class romanStringFor:nr) asLowercase
                ] ifFalse:[
                    nrType == #none ifTrue:[
                        nrString := ''
                    ] ifFalse:[
                        nrString := nr printString.
                    ].
                ]
            ]
        ]
    ].

    letterStart notNil ifTrue:[
        nr := nr - 1.
        nr >= letterRange ifTrue:[
            nrString := (letterStart + (nr // letterRange - 1)) asString.
            nrString := nrString copyWith:(letterStart + (nr \\ letterRange))
        ] ifFalse:[
            nrString := (letterStart + (nr \\ letterRange)) asString
        ].
        nr := nr + 1.
    ].

    nrString := nrString , '.  '.

    xL := x - (currentFont widthOf:nrString).

    element origin:xL @ y.
    element type:#'li_ol'.
    element nr:nrString.

    listElement nextNumber:(nr + 1).
    ^ self.

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 17.6.1997 / 18:02:27 / cg"
!

li_ol
    |xL nrString|

    self conditionalBreak.
    y := y + formattingStyle extraListItemSpacing.

    previousIsEmpty := true.   "/ this will ignore a followup BR or P

    formatting ifTrue:[
        nrString := element nr.
        xL := x - (currentFont widthOf:nrString).
        element origin:xL @ y.
        ^ self
    ].

    y >= (displayTop-fontHeight) ifTrue:[
        y > (displayBottom+fontHeight) ifFalse:[
            xL := element origin x.
            xL > displayRight ifFalse:[
                needFontChange ifTrue:[
                    destination font:currentFont.
                    needFontChange := false.
                ].
                needColorChange ifTrue:[
                    self handleColorChange.
                ].

                "/ in <ol> ... </ol>
                "/ draw the items number

                nrString := element nr.

                destination displayString:nrString x:xL y:y.
            ]
        ]
    ].

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 17.6.1997 / 16:52:32 / cg"
!

li_ul
    " in <ul> ... </ul> - draw a bullet"

    |xL yT szY org lvl img markerType markerSize|

    self conditionalBreak.
    y := y + formattingStyle extraListItemSpacing.

    previousIsEmpty := true.  "/ this will ignore a followup BR or P

    markerType := element markerType.
    markerType notNil ifTrue:[
        markerType := markerType asLowercase
    ].

    markerType isNil ifTrue:[
        ^ self
    ].

    (markerType = 'disc' 
    or:[markerType = 'arrow']) ifTrue:[
        markerSize := 15@10
    ] ifFalse:[
        ((markerType = 'square')
        or:[markerType = 'filledsquare']) ifTrue:[ 
            markerSize := 8@8
        ] ifFalse:[
            ulLevel > 2 ifTrue:[
                markerSize := 3@3
            ] ifFalse:[
                markerSize := 7@7.
                markerSize := 5@5.
            ]
        ]
    ].

    destination isView ifFalse:[
        markerSize := markerSize * 0.7.  "/ what a kludge
    ].

    (formatting or:[destination isView not]) ifTrue:[
        (markerType = 'disc' 
        or:[markerType = 'arrow']) ifTrue:[
            xL := x - (markerSize x + 1) - 8
        ] ifFalse:[
            xL := x - (markerSize x + 2) - 4.
        ].
        yT := y - (fontAscent//2) "+ 1" - (markerSize y // 2).

        element nr:ulLevel.
        element origin:(xL @ yT).
        formatting ifTrue:[
            ^ self
        ]
    ].
"/ destination isView not ifTrue:[self halt].
    "/ displaying

    org := element origin.
    yT := org y.

    szY := markerSize y.

    yT >= (displayTop-szY) ifTrue:[
        yT <= (displayBottom+szY) ifTrue:[
            xL := org x.
            xL > displayRight ifFalse:[
                (xL+markerSize x) < displayLeft ifFalse:[

                    needColorChange ifTrue:[
                        self handleColorChange.
                    ].
                    lastTextX := nil.

                    markerType isNil ifTrue:[
                        lvl := element nr.

                        (lvl == 2) ifTrue:[markerType := 'square']
                    ].

                    markerType = 'disc' ifTrue:[
                        (img := element markerImage) isNil ifTrue:[
                            img := Depth1Image width:15 height:10 
                                            fromArray:#[
                                                        2r00011111 2r11111110
                                                        2r00100000 2r00000010
                                                        2r01000000 2r00000010
                                                        2r10000000 2r00000010
                                                        2r10000000 2r00000010
                                                        2r10000000 2r00000010
                                                        2r10000000 2r00000010
                                                        2r10000000 2r00000010
                                                        2r10000000 2r00000010
                                                        2r11111111 2r11111110
                                                       ].
                            element markerImage:img.    
                        ].
                        destination displayForm:img x:xL y:yT.
                        ^ self
                    ].

                    markerType = 'square' ifTrue:[
                        destination displayRectangleX:xL
                                                    y:yT
                                                width:markerSize x
                                               height:markerSize y.
                        ^ self
                    ].

                    markerType = 'filledsquare' ifTrue:[
                        destination fillRectangleX:xL
                                                 y:yT
                                             width:markerSize x
                                            height:markerSize y.
                        ^ self
                    ].

                    markerType = 'arrow' ifTrue:[
                        img := Depth1Image width:15 height:10 
                                        fromArray:#[
                                                    2r00000000 2r00000000
                                                    2r00000000 2r00100000
                                                    2r00000000 2r00110000
                                                    2r00000000 2r00111000
                                                    2r01111111 2r11111100
                                                    2r01111111 2r11111100
                                                    2r00000000 2r00111000
                                                    2r00000000 2r00110000
                                                    2r00000000 2r00100000
                                                    2r00000000 2r00000000
                                                   ].

                        destination displayForm:img x:xL y:yT.
                        ^ self
                    ].

                    markerType = 'circle' ifTrue:[
                        destination
                            displayArcX:xL y:yT 
                            width:markerSize x
                            height:markerSize y 
                            from:0
                            angle:360.
                        ^ self
                    ].

                    "/ default: a filled circle
                    destination isView ifTrue:[
                        destination scale = 1 ifTrue:[
                            markerSize x <= 8 ifTrue:[
                                img := self class perform:('bullet',markerSize x asString) asSymbol.
                                destination displayForm:img x:xL y:yT.
                                ^ self.
                            ].
                        ].
                    ].
                    destination
                        fillArcX:xL y:yT 
                        width:markerSize x
                        height:markerSize y 
                        from:0
                        angle:360.
                ]
            ]
        ].
    ].

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 27.6.1997 / 22:09:57 / cg"
!

listTypeOElement:anElement
    self obsoleteMethodWarning.
    ^ self listTypeOfElement:anElement

    "Modified: / 29-03-2017 / 13:12:04 / cg"
!

listTypeOfElement:anElement
    |typeString|

    typeString := element typeString.
    typeString notNil ifTrue:[
        typeString size == 1 ifTrue:[
            typeString = 'A' ifTrue:[
                ^ #uppercaseLetters
            ].
            typeString = 'a' ifTrue:[
                ^ #lowercaseLetters
            ].
            typeString = 'I' ifTrue:[
                ^ #uppercaseRoman
            ].
            typeString = 'i' ifTrue:[
                ^ #lowercaseRoman
            ].
            ^ nil.
        ].
    ].
    typeString := element parameterFor:#'LIST-STYLE'.
    typeString notNil ifTrue:[
        typeString = 'decimal' ifTrue:[
            ^ #decimal
        ].
        typeString = 'lower-roman' ifTrue:[
            ^ #lowercaseRoman
        ].
        typeString = 'upper-roman' ifTrue:[
            ^ #uppercaseRoman
        ].
        typeString = 'lower-alpha' ifTrue:[
            ^ #lowercaseLetters
        ].
        typeString = 'upper-alpha' ifTrue:[
            ^ #uppercaseLetters
        ].
        typeString = 'none' ifTrue:[
            ^ #none
        ].
    ].
    ^ nil.

    "Created: / 29-03-2017 / 13:11:40 / cg"
!

menu
    self ul.
    element markerType == #default ifTrue:[
        element markerType:nil.
    ]

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 10.10.1996 / 17:56:05 / cg"
!

menuEnd
    self ulEnd

    "Created: 22.6.1996 / 16:48:59 / cg"
!

ol
    | type nr indent|

    self conditionalBreak.

    "/ need to pass this info to </OL> element, for this to work
"/    indent := element numericParameterFor:'INDENT' default:OLindent.
    indent := OLindent.
    leftIndent := leftIndent + indent.
    x := x + indent.  
    lastTextX := nil.

    inOL == 0 ifTrue:[
        previousIsEmpty ifFalse:[
            self break
        ]
    ].
    inOL := inOL + 1.

    formatting ifTrue:[
        type := self listTypeOfElement:element.

        nr := element parameterFor:#'SEQNUM'.
        nr isNil ifTrue:[
            nr := element parameterFor:#'START'.
        ].
        nr isNil ifTrue:[
            nr := 1
        ] ifFalse:[
            nr := Integer readFrom:nr onError:nr.
            type == #uppercaseLetters ifTrue:[
                nr isNumber ifFalse:[
                    nr := nr first - $A
                ]
            ].
            type == #lowercaseLetters ifTrue:[
                nr isNumber ifFalse:[
                    nr := nr first - $a
                ]
            ].
        ].
        nr isNumber ifFalse:[
            nr := 1
        ].

        element nextNumber:nr.
        element numberType:type.
        liStack add:element.
    ]

    "Created: / 22-06-1996 / 16:48:59 / cg"
    "Modified: / 29-03-2017 / 13:11:35 / cg"
!

olEnd
    self conditionalBreak.

    inOL := inOL - 1.
    inOL < 0 ifTrue:[
        'HTML: </ol> does not match any <ol>' errorPrintCR.
        inOL := 0.
    ] ifFalse:[
        leftIndent := leftIndent - OLindent.
        x := x - OLindent.  lastTextX := nil.

        formatting ifTrue:[
            liStack removeLast
        ]
    ].

    inOL == 0 ifTrue:[
        self conditionalEmpty.
    ]

    "Modified: 21.5.1996 / 12:30:25 / cg"
    "Created: 22.6.1996 / 16:48:59 / cg"
!

ul
    |markerType indent|

    self conditionalBreak.


    "/ need to pass this info to </UL> element, for this to work
"/    indent := element numericParameterFor:'INDENT' default:ULindent.
    indent := ULindent.
    leftIndent := leftIndent + indent.
    x := x + indent.  lastTextX := nil.

    ulLevel == 0 ifTrue:[
        previousIsEmpty ifFalse:[
            self break
        ]
    ].
    ulLevel := ulLevel + 1.

    formatting ifTrue:[
        scanning ifTrue:[
            markerType := element parameterFor:#'TYPE'.
            markerType isNil ifTrue:[
                markerType := #default.
                (element hasParameterFor:#'PLAIN') ifTrue:[
                    markerType := nil
                ].
            ] ifFalse:[
                markerType := markerType asLowercase.
                markerType = 'none' ifTrue:[
                    markerType := nil
                ].
            ].
            element markerType:markerType.
        ].

        liStack add:element.
    ]

    "Created: 22.6.1996 / 16:48:59 / cg"
    "Modified: 27.6.1997 / 22:08:50 / cg"
!

ulEnd
    self conditionalBreak.

    ulLevel := ulLevel - 1.
    ulLevel < 0 ifTrue:[
        'HTML: </ul> does not match any <ul>' errorPrintCR.
        ulLevel := 0.
    ] ifFalse:[
        leftIndent := leftIndent - ULindent.
        x := x - ULindent.  lastTextX := nil.

        formatting ifTrue:[
            liStack removeLast
        ]
    ].

    ulLevel == 0 ifTrue:[
        self conditionalEmpty.
    ].

    "Modified: 21.5.1996 / 12:30:33 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-pseudo tags'!

internalMathFont
    self setFont:(symbolFont asSize:currentFont size).

    "Modified: 16.10.1996 / 13:31:37 / cg"
!

internalMathFontEnd
    |hType f|

    hBegin notNil ifTrue:[
        (hType := hBegin type) == #h1 ifTrue:[
            f := h1Font.
        ] ifFalse:[
            hType == #h2 ifTrue:[
                f := h2Font.
            ] ifFalse:[
                hType == #h3 ifTrue:[
                    f := h3Font.
                ] ifFalse:[
                    hType == #h4 ifTrue:[
                        f := h4Font.
                    ] ifFalse:[
                        hType == #h5 ifTrue:[
                            f := h5Font.
                        ] ifFalse:[
                            f := h6Font.
                        ]
                    ]
                ]
            ]
        ]
    ] ifFalse:[    
        inPre ~~ 0 ifTrue:[
            f := codeFont.
        ] ifFalse:[        
            f := normalFont.
        ]
    ].
    f notNil ifTrue:[
        self setFont:f
    ].

    "Modified: 16.10.1996 / 13:36:27 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-special'!

a
    |urlString actionString clr|

    needSpace := true.
    previousElement isTextElement ifTrue:[
        previousElement text isEmptyOrNil ifTrue:[
            x := x + (currentFont widthOf:' ').
            haveSpace := true.
        ].    
    ].    
    anchorElement notNil ifTrue:[
        boundsCollector notNil ifTrue:[
            boundsCollector isEmpty ifTrue:[
                boundsCollector := Array with:(Rectangle 
                                                left:x top:y-fontAscent 
                                                right:x bottom:y-fontAscent)
            ] ifFalse:[
                boundsCollector := boundsCollector asArray
            ].
            anchorElement bounds:boundsCollector.
            boundsCollector := nil.
        ].
        ('HTML [info]: <a> within anchor ',anchorElement printString) infoPrintCR.
    ].

    anchorElement := element.

    boundsCollector := nil.
    destination isView ifTrue:[
        boundsCollector := OrderedCollection new.
    ].

    scanning ifTrue:[
        anchorElement anchorText:nil.
        element isExample ifTrue:[
            clr := exampleFGColor.
            element color:clr.
        ] ifFalse:[
            (element hasParameterFor:#'ONCLICK') ifTrue:[
                clr := anchorFGColor.
                element color:clr.
            ]
        ]
    ] ifFalse:[
        element notNil ifTrue:[
            clr := element color
        ]
    ].

    clr isNil ifTrue:[
        clr := textFGColor.

        element isExample ifTrue:[
            clr := exampleFGColor.
        ] ifFalse:[
            urlString := element hrefString.
            actionString := element actionString.

            urlString notEmptyOrNil ifTrue:[
                (imageAndStyleResolver visitTest:urlString action:actionString) ifTrue:[
                    clr := visitedAnchorFGColor.
                ] ifFalse:[
                    clr := anchorFGColor.
                ]
            ] ifFalse:[
                actionString notNil ifTrue:[
                    clr := anchorFGColor.
                ]
            ]
        ].
        element color:clr.
    ].

    currentColor ~~ clr ifTrue:[
        self setColor:clr.
    ].
    anchorUnderline ifTrue:[
        underline := underline + 1
    ].

    formatting ifTrue:[
        anchors add:anchorElement
    ].
    "/ Transcript show:'a: '; show:needSpace; show:' '; showCR:anchorElement.

    "Created: / 22-06-1996 / 16:49:00 / cg"
    "Modified: / 16-11-2016 / 17:16:31 / cg"
    "Modified: / 08-08-2018 / 17:55:14 / Claus Gittinger"
!

aEnd
    |docName|

    formatting ifTrue:[
        currentColor := textFGColor.

        anchorElement isNil ifTrue:[
            'HTML: </a> but not within an anchor' errorPrintCR.
            docName := destination documentTitle.
            ('in ' , (docName ? 'unnamed document')) errorPrintCR.
        ].
    ] ifFalse:[
        currentColor ~~ textFGColor ifTrue:[
            self setColor:textFGColor.
        ].
    ].

    anchorElement notNil ifTrue:[
        boundsCollector notNil ifTrue:[
            boundsCollector isEmpty ifTrue:[
                boundsCollector := Array with:(Rectangle 
                                                left:x top:y-fontAscent 
                                                right:x bottom:y-fontAscent)
            ] ifFalse:[
                boundsCollector := boundsCollector asArray
            ].    
            anchorElement bounds:boundsCollector.
            boundsCollector := nil.
        ].
    ].
    anchorElement := nil.
    anchorUnderline ifTrue:[
        underline := (underline - 1) max:0
    ]

    "Created: / 22.6.1996 / 16:49:00 / cg"
    "Modified: / 2.2.1998 / 12:59:41 / cg"
!

app
    "backward compatible (now obsolete) applet tag"

    self applet

    "Modified: / 20.10.1998 / 15:55:52 / cg"
!

appEnd
    "backward compatible (now obsolete) applet end-tag"

    self appletEnd.

    "Created: / 22.6.1996 / 16:49:00 / cg"
    "Modified: / 20.10.1998 / 16:00:36 / cg"
!

applet
    |v wWant hWant w h sp yI align|

    currentApplet := element.
    (v := element view) isNil ifTrue:[
        ^ self
    ].

    w := v width.
    h := v height.

    formatting ifTrue:[
        wWant := element numericParameterFor:#'WIDTH'.
        wWant notNil ifTrue:[
            wWant isLimitedPrecisionReal ifTrue:[
                wWant := (destination width - leftIndent - rightIndent) * wWant // 100.
            ]
        ] ifFalse:[
            wWant := w.
        ].

        hWant := element numericParameterFor:#'HEIGHT'.
        hWant notNil ifTrue:[
            hWant isLimitedPrecisionReal ifTrue:[
                hWant := (destination height - topMargin) * hWant // 100.
            ]
        ] ifFalse:[
            hWant := h.
        ].

        (wWant ~~ w or:[hWant ~~ h]) ifTrue:[
            v extent:(wWant @ hWant).
            w := wWant.
            h := hWant.
        ]
    ].

    previousIsEmpty := false.
    inPre == 0 ifTrue:[self conditionalBreak].
    sp := 0.

    y := y - fontAscent.

    h > fontHeight ifTrue:[
        yNextLine isNil ifTrue:[yNextLine := 0].
        yNextLine := yNextLine max:(y + h + (sp*2) + fontAscent).
    ].

    formatting ifTrue:[
        h < fontHeight ifTrue:[
            yI := y+sp+((fontHeight-h)//2).
        ] ifFalse:[
            yI := y+sp.
        ].
        element bounds:(x@yI extent:(v extent)).
    ].

    align := element alignSymbol.

    (inPre ~~ 0 or:[align == #'top']) ifTrue:[
    ] ifFalse:[
        align == #'bottom' ifTrue:[
            yText := y + h + fontAscent.
        ] ifFalse:[
            h > fontHeight ifTrue:[
                yText := y + (h // 2) + fontAscent.
            ] ifFalse:[
                yText := y + fontAscent
            ]
        ]
    ].

    boundsCollector notNil ifTrue:[
        boundsCollector add:(Rectangle left:x top:y width:w height:h).
    ].

    x := x + w + wSpace + (sp*2).

    y := y + fontAscent.

    x > maxWidth ifTrue:[maxWidth := x].
    x > maxXInCol ifTrue:[maxXInCol := x].

    "Created: / 26.6.1996 / 09:14:52 / cg"
    "Modified: / 23.12.1998 / 21:29:07 / cg"
!

appletEnd
    currentApplet := nil.

    "Created: / 26.6.1996 / 09:15:23 / cg"
    "Modified: / 14.4.1998 / 16:11:42 / cg"
!

area
    currentMap notNil ifTrue:[
        'HTML [info]: area not (yet) implemented' infoPrintCR.
        "/ self halt.
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 18:02:04 / cg"
!

imageFor:urlString now:now
    |image|

    Error handle:[:ex |
        Transcript showCR:'image load error:',ex description.
        image := nil
    ] do:[
        imageResolver isBlock ifTrue:[
            image := imageResolver value:urlString.
            image isNil ifTrue:[
                image := imageAndStyleResolver imageFor:urlString now:true.
            ].
        ] ifFalse:[
            image := (imageResolver ? imageAndStyleResolver) imageFor:urlString now:(formatting not).
        ]
    ].
    ^ image
!

img
    "
     <IMG 
        SRC='image-url'
        ALT='alternative-text'
        WIDTH=w
        HEIGHT=h
        HSPACE=hSpc
        VSPACE=vSpc
        BORDER=bw
        NOPRINT                      // deprecated
        PRINT=yesOrNo                // deprecated
        LOWSRC='lowRes-image-url'    // not implemented
        STYLE='width:w; height:h'
     >
    "
        
    |lw image align xI yI sp oldLW border isBadImage
     hSpace vSpace overAllH overAllW explicitBorder explicitNoBorder
     alt noBrokenImage yDelta inQ imgPos drawBorder y0 downShift
     alwaysDisplayImagesAsynchronous w h urlString styleW styleH 
     magX magY mag|

    inHeader ifTrue:[^ self].
    element isNil ifTrue:[^ self].

    alwaysDisplayImagesAsynchronous := true.
    explicitNoBorder := false.
    
    destination isView ifFalse:[
        "/ when printing, ignore this element if not printable,
        "/ or contained in an non-printable anchor.

        element isPrintable ifFalse:[
            ^ self.
        ].
        (anchorElement notNil and:[anchorElement isPrintable not]) ifTrue:[
            ^ self.
        ].
    ].

    previousIsEmpty := false.

    scanning ifTrue:[
        isBadImage := false.

        (urlString := element urlString) notNil ifTrue:[
            image := self imageFor:urlString now:false "(formatting not)"                
        ].

        image isNil ifTrue:[
            alt := element parameterFor:#'ALT'.
            alt isNil ifTrue:[
                isBadImage := true.
                image := self imageFor:'internal-broken' now:true.
                image isNil ifTrue:[
                    image := Image fromFile:'broken.xpm'.
                    image isNil ifTrue:[
                        noBrokenImage := true
                    ]
                ]    
            ]
        ].
        image notNil ifTrue:[
            element image:image.
        ].
    ] ifFalse:[
        image := element image
    ].

    image isNil ifTrue:[
        "/ look for alternative
        alt := element parameterFor:#'ALT'.
        (alt isNil and:[noBrokenImage == true]) ifTrue:[
            alt := '[????]'
        ].
        alt notNil ifTrue:[
            self addText:alt fromElement:nil.
            ^ self
        ].
    ] ifFalse:[
        magX := magY := 1.
        
        w  := element numericParameterFor:#'WIDTH' default:nil.
        h  := element numericParameterFor:#'HEIGHT' default:nil.

        (styleW := element styleParameterFor:#'WIDTH') notNil ifTrue:[
            w := (Number readFrom:styleW) ceiling
        ].
        (styleH := element styleParameterFor:#'HEIGHT') notNil ifTrue:[
            h := (Number readFrom:styleH) ceiling
        ].
        w isNil ifTrue:[
            w := image width.
        ] ifFalse:[
            magX := w / (image width).
        ].    
        h isNil ifTrue:[
            h := image height.
        ] ifFalse:[
            magY := h / image height.
        ].    
        lw := 2.

        (magX ~= 1 or:[magY ~= 1]) ifTrue:[
            mag := magX min:magY.
            image := image magnifiedBy:mag
        ].    
        hSpace   := element numericParameterFor:#'HSPACE' default:2.
        vSpace   := element numericParameterFor:#'VSPACE' default:2.
        overAllH := vSpace + h + vSpace.
        overAllW := hSpace + w + hSpace.

        (border := element border) notNil ifTrue:[
            explicitBorder := (element hasParameterFor:#'BORDER') and:[border ~~ 0].
            lw := border max:0.
        ].
"/        (element hasParameterFor:#'NOBORDER') ifTrue:[
"/            lw := 0.
"/            explicitNoBorder := true.
"/            drawBorder := false.
"/            border := nil.
"/        ].

        (((lw ~~ 0) and:[false "self currentElementHasHREF"])
                or:[explicitBorder == true]) ifTrue:[
            drawBorder := true.
            sp := lw
        ] ifFalse:[
            drawBorder := false.
            sp := 0
        ].
        self needSpace:h.
        y0 := y.

        (x + w + sp) > currentRightLimit ifTrue:[
            self conditionalBreak.
            yDelta := 0.
        ] ifFalse:[
            yDelta := fontAscent.
        ].

        previousIsEmpty := false.
        y := y - yDelta.

        downShift := 0.
        overAllH > fontHeight ifTrue:[
            yNextLine isNil ifTrue:[yNextLine := 0].
            yNextLine := yNextLine max:(y + overAllH + (sp*2) + fontAscent).
        ] ifFalse:[
            overAllH < fontHeight ifTrue:[
                downShift := ((fontHeight-overAllH)//2).
            ].
        ].
        "/ the border (if any) is drawn immediately

        drawBorder ifTrue:[
            formatting ifFalse:[
                ( (y+overAllH+downShift+sp+sp) >= displayTop
                and:[y+downShift-sp <= displayBottom
                and:[(x+overAllW+sp+sp) >= displayLeft
                and:[x-sp <= displayRight]]]) ifTrue:[
                    needColorChange ifTrue:[
                        self handleColorChange.
                    ].
                    oldLW := destination lineWidth.
                    destination lineWidth:sp.

                    destination displayRectangleX:x+hSpace 
                                                y:y+downShift+vSpace 
                                                width:w+sp+sp 
                                                height:h+sp+sp.
                    destination lineWidth:oldLW.
                ]
            ]
        ].

        xI := x+sp+hSpace.
        yI := y+downShift+sp.

        destination isView ifFalse:[
            "/ synchronous display of images

            formatting ifFalse:[
                image := image onDevice:destination device.
                destination paint:textFGColor on:destination viewBackground.
                drawnColors add:textFGColor.
                "/ destination displayForm:image x:xI y:yI+vSpace.
                image displayOn:destination x:xI y:yI+vSpace.
            ]
        ] ifTrue:[
            image notNil ifTrue:[
                (image device == destination device) ifTrue:[
                    "/ synchronous, if it's already rendered
                    formatting ifFalse:[
                        destination paint:textFGColor on:destination viewBackground.
                        drawnColors add:textFGColor.
                        "/ destination displayForm:image x:xI y:yI+vSpace.
                        Error handle:[:ex |
                            Transcript showCR:'image display error:',ex description.
                        ] do:[
                            image displayOn:destination x:xI y:yI+vSpace.
                        ]
                    ]
                ] ifFalse:[
                    "/ asynchronous display of images

                    (imageDisplayProcess notNil 
                    and:[imageDisplayProcess isDead]) ifTrue:[
                        imageDisplayProcess := nil.
                        "/ imagesToRender := nil.
                        "/ imagesToDisplay := nil.
                    ].

                    imagesToDisplay isNil ifTrue:[
                        imagesToDisplay := SharedQueue new:150
                    ].
                    imageDisplayProcess isNil ifTrue:[
                        self startImageDisplayProcess
                    ].

                    formatting ifTrue:[
                        element bounds:(Rectangle left:xI top:(yI+vSpace) width:overAllW height:overAllH).
                        "/ image device ~~ destination device ifTrue:[
                        "/     Transcript showCR:'renderQ: +',image printString.
                        "/     imagesToRender nextPut:(Array with:element with:image).
                        "/ ].
                    ] ifFalse:[
                        ((yI+overAllH) >= displayTop 
                        and:[yI <= displayBottom
                        and:[(x+sp) <= displayRight
                        and:[(x+sp+overAllW) > displayLeft]]]) ifTrue:[
                            "/
                            "/ if the image is already rendered for the device,
                            "/ draw it immediately
                            "/
                            (alwaysDisplayImagesAsynchronous not
                            and:[image device == destination device]) ifTrue:[
                                destination paint:textFGColor on:destination viewBackground.
                                drawnColors add:textFGColor.
                                "/ destination displayForm:image x:xI y:yI+vSpace.
                                image displayOn:destination x:xI y:yI+vSpace.
                                "/ Transcript showCR:'show now: +',image printString.
                            ] ifFalse:[
                                "/
                                "/ otherwise, in the background
                                "/
                                inQ := false.
                                imgPos := xI @ (yI+vSpace).
"/ imagesToDisplay halt.
"/                                imagesToDisplay accessLock critical:[
"/                                    imagesToDisplay do:[:entry | 
"/                                        (entry at:1) == image ifTrue:[
"/                                            (entry at:2) = imgPos ifTrue:[
"/                                                inQ := true
"/                                            ]
"/                                        ]
"/                                    ].
"/                                ].
                                
                                inQ ifTrue:[
                                    Transcript showCR:'already inQ: ',image printString.
                                ] ifFalse:[
                                    Transcript showCR:'displayQ1 +',image printString.
                                    imagesToDisplay nextPut:(Array with:element
                                                                   with:image
                                                                   with:imgPos
                                                                   with:textFGColor
                                                                   with:destination viewBackground).

        "/                            destination paint:destination viewBackground.
        "/                            destination fillRectangleX:x+sp y:yI
        "/                                                 width:overAllW height:overAllH.
        "/
                                    needColorChange := true
                                ]
                            ]
                        ] ifFalse:[
"/                            image device ~~ destination device ifTrue:[
"/                                imagesToRender nextPut:(Array with:element with:image).
"/                            ] ifFalse:[
"/                                Transcript showCR:'displayQ: +2',image printString.
"/                                imagesToDisplay nextPut:(Array with:element
"/                                                               with:image
"/                                                               with:imgPos
"/                                                               with:textFGColor
"/                                                               with:destination viewBackground).
"/                            ]
                        ]
                    ]
                ]
            ]
        ].

        align := element alignSymbol.
        align == #'top' ifTrue:[
        ] ifFalse:[
            align == #'bottom' ifTrue:[
                yText := y + overAllH + fontAscent.
            ] ifFalse:[
                h > fontHeight ifTrue:[
                    yText := y + (overAllH // 2) + fontAscent.
                ] ifFalse:[
                    yText := y + fontAscent
                ]
            ]
        ].

        boundsCollector notNil ifTrue:[
            boundsCollector add:(Rectangle 
                                        left:x top:yI 
                                        width:overAllW height:overAllH).
        ].
        
        "/ separate

        x := x + overAllW + (sp*2). 
        "/ x := x + wSpace.
        needSpace := true.
        lastTextX := nil.

        x > maxWidth ifTrue:[maxWidth := x].
        x > maxXInCol ifTrue:[maxXInCol := x].

        y := y0.
    ].

    "Modified: / 29-03-2017 / 15:30:30 / cg"
    "Modified: / 22-07-2018 / 22:26:21 / Claus Gittinger"
!

map
    |nm|

    scanning ifTrue:[
        nm := element nameString.
        nm isNil ifTrue:[
            'HTML [info]: no name given to map' infoPrintCR
        ] ifFalse:[
            maps isNil ifTrue:[
                maps := Dictionary new.
            ].
            maps at:nm put:(currentMap :=IdentityDictionary new).
        ]
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 10.1.1997 / 15:42:15 / cg"
!

mapEnd
    currentMap := nil.

    "Modified: 12.6.1996 / 20:10:18 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

param
    "/ done in preparse - see #defineAppletParameterFor: ...

    "Modified: 12.8.1997 / 03:21:24 / cg"
!

script
    "the script is now loaded and evaluated by the parser
     (to allow it to generate the HTML text ...)
     However, we need to remember it, for startup & cleanup message
     sends."

    destination isView ifFalse:[^ self].        "/ ignored when printing
    scanning ifTrue:[
        destination scriptExecutionEnabled ifFalse:[
            'HTML [info]: script execution disabled' infoPrintCR.
            ^ self
        ].

        scriptObject := element scriptObject.
        scriptObject isNil ifTrue:[
            'HTML [warning]: no script object' infoPrintCR.
        ]
    ]

    "Modified: 26.5.1997 / 13:24:05 / cg"
!

specialMarkup
    |text|

    text := element text.

    collectingText ~~ 0 ifTrue:[
        scanning ifTrue:[
           collectedText size == 0 ifTrue:[
                text first == Character cr ifTrue:[
                    text := text copyFrom:2
                ].
                collectedText isNil ifTrue:[
                    collectedText := ''.
                ]
           ].
           text notNil ifTrue:[
               collectedText := collectedText , text.
           ] 
        ].
        ^ self
    ].

    inHeader ifFalse:[
        "/ currentApplet notNil ifTrue:[
            self addText:text fromElement:element
        "/ ]
    ].

    "Modified: / 14.4.1998 / 16:29:46 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-structure'!

br
    |v|

    previousIsEmpty ifFalse:[
        self break.
    ].

    v := self relativeValueFrom:#'INDENT' with:0.
    v notNil ifTrue:[
        x := x + v.
    ] ifFalse:[
        (element hasParameterFor:#'INDENT') ifTrue:[
            x := x + BLOCKQUOTEindent.
        ]
    ]
!

center
    center == 0 ifTrue:[
        self conditionalBreak.
    ].
    center := center + 1.

    "Created: 19.9.1996 / 12:13:52 / cg"
    "Modified: 2.10.1996 / 13:45:13 / cg"
!

centerEnd
    center > 0 ifTrue:[
        center := center - 1.
        self conditionalBreak.
    ] ifFalse:[
        'HTML [info]: no matching <center> for </center>' infoPrintCR
    ].

    "Created: 19.9.1996 / 12:17:01 / cg"
    "Modified: 10.1.1997 / 15:41:23 / cg"
!

div
    |defSZ|

    defSZ := 1.

    self conditionalBreak.

"/    w := element numericParameterFor:#'WIDTH' default:nil.
"/    sz := element numericParameterFor:#'SIZE' default:defSZ.
"/
"/    formatting ifFalse:[
"/        yL := y - fontAscent + (fontAvgHeight//2) + (sz//2).
"/        yL >= displayTop ifTrue:[
"/            yL <= (displayBottom+sz) ifTrue:[
"/                needColorChange ifTrue:[
"/                    destination paint:currentColor.
"/                    drawnColors add:currentColor.
"/                    needColorChange := false.
"/                ].
"/
"/                w isNil ifTrue:[
"/                    right := docWidth - rightIndent
"/                ] ifFalse:[
"/                    w isReal ifTrue:[
"/                        right := leftIndent + indentOffset + (docWidth - rightIndent * w // 100)
"/                    ] ifFalse:[
"/                        right := leftIndent + indentOffset+ w - 1
"/                    ]    
"/                ].
"/
"/                shade := true.  "/ should come from a config or classVar
"/
"/                destination is3D ifFalse:[shade := false].
"/
"/                (element hasParameterFor:#'SHADE') ifTrue:[
"/                    shade := true
"/                ].
"/                (element hasParameterFor:#'NOSHADE') ifTrue:[
"/                    shade := false
"/                ].
"/        
"/                shade ifFalse:[
"/                    destination 
"/                        fillRectangleX:leftIndent+indentOffset 
"/                                     y:yL 
"/                                 width:right - (leftIndent+indentOffset) + 1 
"/                                height:sz.
"/
"/                ] ifTrue:[
"/                    destination is3D ifTrue:[
"/                        destination 
"/                            displayLineFromX:leftIndent+indentOffset 
"/                                           y:yL 
"/                                         toX:right 
"/                                           y:yL.
"/
"/                        destination 
"/                            displayLineFromX:leftIndent+indentOffset
"/                                           y:yL+1 
"/                                         toX:leftIndent+indentOffset 
"/                                           y:yL+sz.
"/
"/                        destination paint:Color white.
"/                        needColorChange := true.
"/                        destination 
"/                            displayLineFromX:leftIndent+indentOffset 
"/                                           y:yL+sz 
"/                                         toX:right 
"/                                           y:yL+sz.
"/
"/                        destination 
"/                            displayLineFromX:right+1
"/                                           y:yL+1 
"/                                         toX:right+1 
"/                                           y:yL+sz.
"/                    ]
"/                ].
"/                destination lineWidth:0.
"/            ]
"/        ]
"/    ].
"/
"/    self empty.
"/    y := y + sz.
"/    previousIsEmpty := false.

    "Created: / 17.11.1998 / 18:33:39 / cg"
!

h1
    self header:1 font:h1Font space:5.

    "Modified: 1.10.1996 / 14:38:12 / cg"
!

h1End
    self headerEnd.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 1.10.1996 / 14:43:21 / cg"
!

h2
    self header:2 font:h2Font space:4
!

h2End
    self headerEnd

    "Modified: 17.5.1996 / 16:41:41 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

h3
    self header:3 font:h3Font space:3
!

h3End
    self headerEnd

    "Modified: 17.5.1996 / 16:41:54 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

h4
    self header:4 font:h4Font space:2
!

h4End
    self headerEnd

    "Created: 22.6.1996 / 16:49:00 / cg"
!

h5
    self header:5 font:h5Font space:2
!

h5End
    self headerEnd

    "Created: 22.6.1996 / 16:49:00 / cg"
!

h6
    self header:6 font:h6Font space:2
!

h6End
    self headerEnd

    "Created: 22.6.1996 / 16:49:00 / cg"
!

h7
    self header:7 font:h6Font space:2
!

h7End
    self headerEnd

    "Created: 22.6.1996 / 16:49:00 / cg"
!

h8
    self header:8 font:h6Font space:2
!

h8End
    self headerEnd

    "Created: 22.6.1996 / 16:49:00 / cg"
!

h9
    self header:9 font:h6Font space:2
!

h9End
    self headerEnd

    "Created: 22.6.1996 / 16:49:00 / cg"
!

hr
    |yL w sz right defSZ shade|

    defSZ := 1.

    self conditionalBreak.

    w := element numericParameterFor:#'WIDTH' default:nil.
    sz := element numericParameterFor:#'SIZE' default:defSZ.

    formatting ifFalse:[
        yL := y - fontAscent + (fontAvgHeight//2) + (sz//2).
        yL >= displayTop ifTrue:[
            yL <= (displayBottom+sz) ifTrue:[
                needColorChange ifTrue:[
                    self handleColorChange.
                ].

                w isNil ifTrue:[
                    right := docWidth - rightIndent
                ] ifFalse:[
                    right := leftIndent + indentOffset.
                    w isLimitedPrecisionReal ifTrue:[
                        right := right + ((docWidth - rightIndent) * w // 100)
                    ] ifFalse:[
                        right := right + w - 1
                    ]    
                ].

                shade := true.  "/ should come from a config or classVar

                destination is3D ifFalse:[shade := false].

                (element hasParameterFor:#'SHADE') ifTrue:[
                    shade := true
                ].
                (element hasParameterFor:#'NOSHADE') ifTrue:[
                    shade := false
                ].
        
                shade ifFalse:[
                    destination 
                        fillRectangleX:leftIndent+indentOffset 
                                     y:yL 
                                 width:right - (leftIndent+indentOffset) + 1 
                                height:sz.

                ] ifTrue:[
                    destination is3D ifTrue:[
                        destination 
                            displayLineFromX:leftIndent+indentOffset 
                                           y:yL 
                                         toX:right 
                                           y:yL.

                        destination 
                            displayLineFromX:leftIndent+indentOffset
                                           y:yL+1 
                                         toX:leftIndent+indentOffset 
                                           y:yL+sz.

                        destination paint:Color white.
                        needColorChange := true.
                        destination 
                            displayLineFromX:leftIndent+indentOffset 
                                           y:yL+sz 
                                         toX:right 
                                           y:yL+sz.

                        destination 
                            displayLineFromX:right+1
                                           y:yL+1 
                                         toX:right+1 
                                           y:yL+sz.
                    ]
                ].
                destination lineWidth:0.
            ]
        ]
    ].

    self empty.
    y := y + sz.
    previousIsEmpty := false.

"/    self break.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 2.10.1996 / 13:33:55 / cg"
!

nobr
    noBreak := noBreak + 1.

    "Modified: 17.5.1996 / 18:50:58 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

nobrEnd
    noBreak > 0 ifTrue:[
        noBreak := noBreak - 1.
    ] ifFalse:[
        'HTML [info]: no matching <nobr> for </nobr>' infoPrintCR
    ].

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 10.1.1997 / 15:42:20 / cg"
!

p
    |v|

    element isPrintable ifFalse:[
        inNoPrintingParagraph := inNoPrintingParagraph + 1.
        ^ self
    ].

    formatting ifFalse:[
        self do_starOfficeStyleBefore.
        self do_needAndNewPage.
    ].

    v := self relativeValueFrom:#'INDENT' with:indentOffset.
    v notNil ifTrue:[
        indentOffset := v.
        indentOffset < 0 ifTrue:[indentOffset := 0].
    ] ifFalse:[
        indentOffset := 0
    ].
    self conditionalEmpty.
    "/ cg: no, a P is a P
    "/ self empty.

    previousIsEmpty := true.

    "Created: / 22-06-1996 / 16:49:00 / cg"
    "Modified: / 27-10-1999 / 11:23:32 / stefan"
    "Modified (comment): / 20-07-2011 / 10:23:26 / cg"
    "Modified: / 01-09-2018 / 16:01:58 / Claus Gittinger"
    "Modified (format): / 01-09-2018 / 17:38:53 / Claus Gittinger"
!

pEnd
    inNoPrintingParagraph := 0.
    indentOffset := 0

    "Created: 22.9.1996 / 17:04:56 / cg"
!

pre
    |elClass|

    currentTable isNil ifTrue:[
        self conditionalHalfEmpty.
    ].
    self conditionalBreak.
    "/ self atLeft ifFalse:[ self break. ].
    "/ self setFont:codeFont.
    inPre := inPre + 1.
    needSpace := false.

    elClass := element parameterFor:#'CLASS'.
    elClass notNil ifTrue:[
        |clr|

        elClass := elClass asLowercase.
        elClass = 'code' ifTrue:[
            clr := exampleFGColor.
        ].
        elClass = 'example' ifTrue:[
            clr := exampleFGColor.
        ].
        elClass = 'examplecode' ifTrue:[
            clr := exampleFGColor.
        ].

        clr notNil ifTrue:[
            self setColor:clr.
        ].
    ].

    "Created: / 22-06-1996 / 16:49:00 / cg"
    "Modified: / 12-11-2010 / 11:16:45 / cg"
!

preEnd
    "if the last element was a newLine, remove it"

    (scanning and:[formatting]) ifTrue:[
        currentTable notNil ifTrue:[
            "/ if the previous element is text AND the last line of it
            "/ is empty, remove it (otherwise, we get too much spacing later
            previousElement isTextElement ifTrue:[
                |text|

                (text := previousElement text) isString ifFalse:[
                    (text notNil and:[text last isEmpty]) ifTrue:[
                        text removeLast.
                    ]
                ].
            ].
        ].
    ].

    currentTable isNil ifTrue:[
        self conditionalBreak.
        self halfEmpty.
    ].

    "/ self setFont:normalFont.
    inPre := inPre - 1.

    inPre < 0 ifTrue:[
        'HTML [info]: no matching <pre> for </pre>' infoPrintCR.
        inPre := 0.
    ].

    "Created: / 22-06-1996 / 16:49:00 / cg"
    "Modified: / 12-11-2010 / 11:16:59 / cg"
!

tab
    |id tab posX|

    posX := Integer readFrom:(element parameterFor:#'INDENT') onError:nil.
    posX notNil ifTrue:[
        posX := posX max:0.
    ].
    
    formatting ifTrue:[
        id := element parameterFor:#'ID'.
        id notNil ifTrue:[
            tabulators isNil ifTrue:[
                tabulators := Dictionary new
            ].
            tabulators at:id put:(posX ? x).
            ^ self
        ].
    ].

    id := element parameterFor:#'TO'.
    id notNil ifTrue:[
        tabulators notNil ifTrue:[
            tab := tabulators at:id ifAbsent:nil
        ].
        tab notNil ifTrue:[
            x := tab.  lastTextX := nil.
        ].
        ^ self.
    ].
    posX notNil ifTrue:[
        posX < x ifTrue:[
            self break.
        ].    
        x := posX.  lastTextX := nil.
        ^ self.
    ].    

    "Modified: 18.6.1996 / 21:48:30 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

wbr
    previousIsEmpty ifFalse:[
        self break.
    ]

    "Modified: 17.5.1996 / 18:40:47 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

xmp
    self conditionalEmpty.
    self setFont:codeFont.
    inPre := inPre + 1.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 18:02:36 / cg"
!

xmpEnd
    self empty.

    self setFont:normalFont.
    inPre := inPre - 1.

    inPre < 0 ifTrue:[
        'HTML [info]: no matching <xmp> for </xmp>' infoPrintCR.
        inPre := 0.
    ].

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 18:02:39 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-style'!

acronym
    self cite

    "Modified: 17.5.1996 / 18:50:58 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

acronymEnd
    self citeEnd

    "Modified: 17.5.1996 / 18:50:58 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

address
    self handlePendingSpaceNeed.
    self setFont:boldItalicNormalFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:40:26 / cg"
!

addressEnd
    self handlePendingSpaceNeed.
    inPre ~~ 0 ifTrue:[
        self setFont:codeFont.
    ] ifFalse:[        
        self setFont:normalFont.
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:40:24 / cg"
!

b
    |newFont|

    self handlePendingSpaceNeed.

    self pushStyle.

    currentFont == codeFont ifTrue:[
        newFont := boldCodeFont.
    ] ifFalse:[
        currentFont == boldCodeFont ifTrue:[
            newFont := boldCodeFont.
        ] ifFalse:[
            currentFont == normalFont ifTrue:[
                newFont := boldNormalFont.
            ] ifFalse:[
                newFont := currentFont asBold.
            ]
        ]
    ].
    self setFont:newFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 17:33:40 / cg"
!

bEnd

    self handlePendingSpaceNeed.

"/    inPre ~~ 0 ifTrue:[
"/        prevFont := codeFont.
"/    ] ifFalse:[        
"/        inKbd > 0 ifTrue:[
"/            prevFont := boldCodeFont.
"/        ] ifFalse:[
"/            prevFont := normalFont.
"/        ]
"/    ].

    self popStyle.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 17:33:43 / cg"
!

cite
    self handlePendingSpaceNeed.
    self setFont:italicNormalFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 18:02:11 / cg"
!

citeEnd
    self handlePendingSpaceNeed.
    inPre ~~ 0 ifTrue:[
        self setFont:codeFont.
    ] ifFalse:[        
        self setFont:normalFont.
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 18:02:14 / cg"
!

code
"/ (element hasParameterFor:'FOO') ifTrue:[self halt].
    self handlePendingSpaceNeed.
    self pushStyle.
    formatting ifFalse:[
"/        codeFGColor notNil ifTrue:[self setColor:codeFGColor].
"/        self handleColorAttribute.
    ].
    self setFont:codeFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 24.6.1997 / 11:46:30 / cg"
!

codeEnd
"/    self handlePendingSpaceNeed.
    self popStyle.
    self handlePendingSpaceNeed.
"/    inPre ~~ 0 ifTrue:[
"/        self setFont:codeFont.
"/    ] ifFalse:[        
"/        self setFont:normalFont.
"/    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:38:44 / cg"
!

dfn
    self handlePendingSpaceNeed.
    self cite.
    self u.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:38:48 / cg"
!

dfnEnd
    "/ self handlePendingSpaceNeed.
    self uEnd.
    self citeEnd.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:41:38 / cg"
!

em
    |font|

    self handlePendingSpaceNeed.
    currentFont == codeFont ifTrue:[
        font := italicCodeFont.
    ] ifFalse:[
        font := italicNormalFont.
    ].
    self setFont:font

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:38:54 / cg"
!

emEnd
    |font|

    self handlePendingSpaceNeed.
    (inPre ~~ 0 
    or:[currentFont == italicCodeFont]) ifTrue:[
        font := codeFont.
    ] ifFalse:[        
        font := normalFont.
    ].
    self setFont:font.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:38:57 / cg"
!

font
    |size face newFont|

    "/ self handlePendingSpaceNeed.

    self pushStyle.
    "/ formatting ifFalse:[
        self handleColorAttribute.
        
        newFont := (currentFont ? normalFont).

        size := self relativeValueFrom:#'SIZE' with:fontSize.
        (size notNil and:[size ~~ fontSize]) ifTrue:[
            newFont := newFont asSize:size.
        ].
        face := element parameterFor:#'FACE'.
        face notNil ifTrue:[
            newFont := newFont asFamily:face.
        ].
        newFont = currentFont ifFalse:[
            "/ self handlePendingSpaceNeed.
            "/ self pushStyle.
            self setFont:newFont.
        ].
    "/ ]

    "Created: / 22-06-1996 / 16:49:00 / cg"
    "Modified: / 14-11-2016 / 14:12:07 / cg"
!

fontEnd
    self popStyle.
    self handlePendingSpaceNeed.
"/    inPre ~~ 0 ifTrue:[
"/        self setFont:codeFont.
"/    ] ifFalse:[        
"/        self setFont:normalFont.
"/    ].
"/    self setColor:textFGColor.

    "Modified: / 14-11-2016 / 13:55:44 / cg"
!

i
    |newFont|

    self handlePendingSpaceNeed.

    self pushStyle.

    currentFont == boldNormalFont ifTrue:[
        newFont := boldItalicNormalFont.
    ] ifFalse:[
        currentFont == codeFont ifTrue:[
            newFont := italicCodeFont.
        ] ifFalse:[
            currentFont == normalFont ifTrue:[
                newFont := italicNormalFont
            ] ifFalse:[
                newFont := currentFont asItalic.
            ].
        ]
    ].
    self setFont:newFont

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 17:33:56 / cg"
!

iEnd

    self handlePendingSpaceNeed.

"/    inPre ~~ 0 ifTrue:[
"/        prevFont := codeFont.
"/    ] ifFalse:[        
"/        prevFont := normalFont.
"/    ]

    self popStyle.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 17:33:59 / cg"
!

kbd
    self handlePendingSpaceNeed.
    inKbd := inKbd + 1.
    self setFont:boldCodeFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:21 / cg"
!

kbdEnd
    self handlePendingSpaceNeed.
    inKbd := inKbd - 1.
    inPre ~~ 0 ifTrue:[
        self setFont:codeFont.
    ] ifFalse:[        
        self setFont:normalFont.
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:24 / cg"
!

s
    self strike

    "Modified: 8.8.1997 / 14:40:23 / cg"
!

sEnd
    self strikeEnd

    "Modified: 8.8.1997 / 14:40:30 / cg"
!

samp
    self code

    "Modified: 17.5.1996 / 18:50:58 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

sampEnd
    self codeEnd

    "Modified: 17.5.1996 / 18:50:58 / cg"
    "Created: 22.6.1996 / 16:49:00 / cg"
!

strike
    self handlePendingSpaceNeed.
    strikeout := strikeout + 1

    "Modified: 17.6.1997 / 19:39:27 / cg"
    "Created: 8.8.1997 / 14:40:09 / cg"
!

strikeEnd
    self handlePendingSpaceNeed.
    strikeout := (strikeout - 1) max:0

    "Modified: 17.6.1997 / 19:39:30 / cg"
    "Created: 8.8.1997 / 14:40:16 / cg"
!

strong
    |font|

    self handlePendingSpaceNeed.
    currentFont == codeFont ifTrue:[
        font := boldCodeFont.
    ] ifFalse:[
        font := boldNormalFont.
    ].
    self setFont:font

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:37 / cg"
!

strongEnd
    |font|

    self handlePendingSpaceNeed.
    (inPre ~~ 0 
    or:[currentFont == boldCodeFont]) ifTrue:[
        font := codeFont.
    ] ifFalse:[        
        font := normalFont.
    ].
    self setFont:font.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:40 / cg"
!

sub
    self handlePendingSpaceNeed.
    self setFont:normalSmallFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:43 / cg"
!

subEnd
    self handlePendingSpaceNeed.
    inPre ~~ 0 ifTrue:[
        self setFont:codeFont.
    ] ifFalse:[        
        self setFont:normalFont.
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:45 / cg"
!

sup
    self handlePendingSpaceNeed.
    inSup := inSup + 1.
    self setFont:normalSmallFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:49 / cg"
!

supEnd
    self handlePendingSpaceNeed.
    inSup := (inSup - 1) max:0.
    inSup == 0 ifTrue:[
        inPre ~~ 0 ifTrue:[
            self setFont:codeFont.
        ] ifFalse:[        
            self setFont:normalFont.
        ]
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:52 / cg"
!

tt
    self handlePendingSpaceNeed.
    self setFont:codeFont.

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:54 / cg"
!

ttEnd
    self handlePendingSpaceNeed.
    inPre ~~ 0 ifTrue:[
        self setFont:codeFont.
    ] ifFalse:[        
        self setFont:normalFont.
    ]

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:39:57 / cg"
!

u
    self handlePendingSpaceNeed.
    underline := underline + 1

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:40:00 / cg"
!

uEnd
    "/ self handlePendingSpaceNeed.
    underline := (underline - 1) max:0

    "Created: 22.6.1996 / 16:49:00 / cg"
    "Modified: 17.6.1997 / 19:41:45 / cg"
!

var
    self handlePendingSpaceNeed.
    self setFont:italicNormalFont.

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 17.6.1997 / 17:34:05 / cg"
!

varEnd
    self handlePendingSpaceNeed.
    inPre ~~ 0 ifTrue:[
        self setFont:codeFont.
    ] ifFalse:[        
        self setFont:normalFont.
    ].

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 17.6.1997 / 17:34:08 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-tables'!

caption
    currentTable notNil ifTrue:[
        self finishPreviousTableRow:false.
    ]

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 4.3.1997 / 19:03:40 / cg"
!

drawTable
    |rows lastRow clr img bg
     spacing yTop yBot xLeft xRight    
     bw bw2       
     cellLeft cellRight cellTop cellBot   
     minLeft minTop maxRight maxBot|

    "/
    "/ must now remember, if table has already been drawn
    "/ (cannot draw it twice, due to tables-background-filling
    "/
    alreadyDisplayedTableElements isNil ifTrue:[^ self].
    (alreadyDisplayedTableElements includes:currentTable) ifTrue:[^ self].
    alreadyDisplayedTableElements add:currentTable.

    formatting ifTrue:[^ self].

    bw  := currentTable borderWidth.
    bw2 := bw // 2.
    bw odd ifTrue:[bw2 := bw2 + 1].

    needColorChange ifTrue:[
        self handleColorChange
    ].

    (xLeft  := leftIndent + indentOffset)                    > displayRight  ifTrue:[^ self].
    (yTop   := currentTable top)                             > displayBottom ifTrue:[^ self].
    (yBot   := yTop + (currentTable height ? 0))             < displayTop    ifTrue:[^ self].
    (xRight := xLeft + bw2 + (currentTable width ? 0) + bw2) < displayLeft   ifTrue:[^ self].

    (     (bg  := currentTable parameterFor:#'BACKGROUND') notEmptyOrNil 
     and:[(img := self imageFor:bg now:true) notNil
     and:[(clr := img asFormOn:destination device) notNil]]
    ) ifFalse:[
        (clr := currentTable colorParameter:#'BGCOLOR') notNil ifTrue:[
            drawnColors add:(clr := clr onDevice:destination device)
        ]
    ].

    minLeft  := xLeft  max:displayLeft.
    minTop   := yTop   max:displayTop.
    maxRight := xRight min:displayRight.
    maxBot   := yBot   min:displayBottom.

    clr notNil ifTrue:[
        destination paint:clr.

        destination fillRectangleX:minLeft
                                 y:minTop 
                             width:(maxRight - minLeft + 1)
                            height:(maxBot - minTop  + 1).        

        destination paint:currentColor.
    ].

    rows := currentTable rows ? #().
    rows notEmptyOrNil ifTrue:[ lastRow := rows last ].
    cellTop := yTop.

    rows do:[:aRow|
        cellBot := lastRow ~~ aRow ifTrue:[aRow yRow] ifFalse:[yBot].

        (cellTop <= maxBot and:[cellBot >= minTop]) ifTrue:[
            cellLeft := xRight.

            aRow columns reverseDo:[:aCol|
                cellRight := cellLeft.
                cellLeft  := aCol x.

                cellLeft <= maxRight ifTrue:[
                    cellRight >= minLeft ifTrue:[
                        bg := aCol background.
                        bg isNil ifTrue:[bg := aCol bgColor].
                        bg notNil ifTrue:[
                            bg isColor ifTrue:[
                                drawnColors add:(clr := bg onDevice:destination device)
                            ] ifFalse:[
                                img := imageAndStyleResolver imageFor:bg now:true.
                                img notNil ifTrue:[
                                    img := img asFormOn:destination device.    
                                    img notNil ifTrue:[
                                        clr := img.
                                    ].
                                ].
                            ]
                        ].

                        clr notNil ifTrue:[
                            destination paint:clr.

                            destination fillRectangleX:cellLeft
                                                     y:cellTop
                                                 width:(cellRight - cellLeft + 1)
                                                height:(cellBot - cellTop + 1).

                            destination paint:currentColor.
                        ]
                    ]
                ]
            ]
        ].
        cellTop := cellBot.
    ].

    bw == 0 ifTrue:[^ self].

    clr := currentTable borderColor.

    clr notNil ifTrue:[
        clr := clr onDevice:destination device.
        destination paint:clr.
        drawnColors add:clr.
        needColorChange := true.  "/ force next textDraw to change color back.
    ].

    destination lineWidth:bw.
    destination capStyle:#projecting.

    (yTop + bw2) >= minTop ifTrue:[
        destination displayLineFromX:minLeft y:yTop toX:maxRight y:yTop
    ].

    xLeft >= minLeft ifTrue:[
        destination displayLineFromX:xLeft y:minTop toX:xLeft y:maxBot
    ].

    xRight <= maxRight ifTrue:[
        destination displayLineFromX:xRight y:minTop toX:xRight y:maxBot
    ].

    (yBot - bw2) <= maxBot ifTrue:[
        destination displayLineFromX:minLeft y:yBot toX:maxRight y:yBot
    ].

    (spacing := currentTable cellspacing) == 0 ifTrue:[^ self].

    destination lineWidth:spacing.
    destination capStyle:#butt.

    cellTop := yTop.

    rows do:[:aRow|
        "/ draw horizontal lines

        aRow ~~ lastRow ifTrue:[
            cellBot := aRow yBottom.

            (cellBot between:minTop and:maxBot) ifTrue:[
                destination displayLineFromX:xLeft y:cellBot toX:xRight y:cellBot.
            ]
        ] ifFalse:[
            cellBot := yBot
        ].
        (     (cellBot >= minTop or:[cellTop >= minTop])
         and:[(cellBot <= maxBot or:[cellTop <= maxBot])]
        ) ifTrue:[
            "/ draw vertical lines
            aRow columns from:2 do:[:aCol|
                cellLeft := aCol x.

                ((cellLeft >= minLeft) and:[cellLeft <= maxRight]) ifTrue:[
                    destination displayLineFromX:cellLeft y:cellTop toX:cellLeft y:cellBot.
                ]
            ]
        ].
        cellTop := cellBot.
   ].
   destination lineWidth:1.

    "Created: / 22-06-1996 / 16:49:01 / cg"
    "Modified: / 05-11-2007 / 21:56:17 / cg"
    "Modified: / 19-06-2018 / 17:10:52 / Claus Gittinger"
!

drawTableRow:row
    "draw one row
    "
    |xLeft xRight yBot yTop clr bw lW cols cellSpacing|

    formatting ifTrue:[^ self].

    (bw := currentTable borderWidth) == 0 ifTrue:[^ self].

    cellSpacing := currentTable cellspacing.

    needColorChange ifTrue:[
        self handleColorChange.
    ].

    clr := currentTable borderColor.
    clr notNil ifTrue:[
        destination paint:clr.
        drawnColors add:clr.
        needColorChange := true.  "/ force next textDraw to change color back.
    ].

    yBot   := row yBottom . "/yRow.
"/    xLeft  := leftIndent + indentOffset " + wSpace".
    xLeft  := leftIndent + indentOffset + (bw + 1 // 2).
    xRight := xLeft + currentTable width + bw.

    currentRowIndex == 1 ifTrue:[
        yTop := currentTable top
    ] ifFalse:[
        yTop := (currentTable rowAt:(currentRowIndex -1)) yRow
    ].
    yBot < yTop ifTrue:[
        yTop := destination topMargin.
    ].
    yTop > displayBottom ifTrue:[
        ^ self
    ].
    yBot < displayTop ifTrue:[
        ^ self
    ].

    destination lineWidth:bw.
    lW := bw.
    destination capStyle:#projecting.

    xRight > displayRight ifTrue:[
        xRight := displayRight
    ] ifFalse:[
        destination displayLineFromX:xRight y:yTop toX:xRight y:yBot.
    ].

    currentRowIndex == 1 ifTrue:[
        destination displayLineFromX:xLeft y:yTop toX:xRight y:yTop.
    ].

    currentRowIndex == currentTable rows size ifFalse:[
        lW := cellSpacing.    
        destination capStyle:#butt.
    ].
    lW ~~ 0 ifTrue:[
        destination lineWidth:lW.
        destination displayLineFromX:xLeft y:yBot toX:xRight y:yBot.
    ].
    lW := cellSpacing.
    destination lineWidth:lW.
    destination capStyle:#butt.

    cols := row columns.
    cols keysAndValuesDo:[:index :col| |xCol|
        (xCol := col x) <= displayRight ifTrue:[
            (index == 1) ifTrue:[
                xCol := xCol - (bw // 2).
                lW := bw.
            ].
            lW ~~ 0 ifTrue:[
                destination lineWidth:lW.
                destination displayLineFromX:xCol y:yTop toX:xCol y:yBot.
            ].
            lW := cellSpacing.
        ]
    ].

    "Modified: 5.3.1997 / 21:03:22 / cg"
!

finishPreviousTableColumn
    |currentRow thisCol w prevElement explicitWidth padding 
     spacing yB dx|

    currentRowIndex == 0 ifTrue:[
        scanning ifTrue:[
            'HTML [info]: table-col but not in a table-row' infoPrintCR.
        ].
        ^ self
    ].
    currentColIndex == 0 ifTrue:[
        scanning ifTrue:[
            "/ 'HTML [info]: empty table row' infoPrintCR.
        ].
        ^ self
    ].

    currentRow := currentTable rowAt:currentRowIndex.
    thisCol := currentRow columnAt:currentColIndex.
    padding := currentTable cellpadding.

    formatting ifTrue:[
        spacing := currentTable cellspacing.

        x > maxXInCol ifTrue:[maxXInCol := x]
        ifFalse:[x := maxXInCol].

        w := maxXInCol - thisCol xText.        "/ width of contents alone
        thisCol netWidth:w.
        w := padding + w + padding  + spacing + spacing.  "/ overall width.

        dx := 0.
        prevElement := thisCol markupElement.
        (prevElement hasParameterFor:#'WIDTH') ifTrue:[
            explicitWidth := prevElement numericParameterFor:#'WIDTH' default:0.
            explicitWidth isInteger ifFalse:[
                explicitWidth := leftIndent 
                                 + indentOffset 
                                 + ((docWidth - rightIndent) * explicitWidth // 100).
            ].
            explicitWidth > w ifTrue:[
                dx := explicitWidth - w.
                w := explicitWidth
            ]
        ].

        yB := y.
        yNextLine notNil ifTrue:[ 
            yB := yB max:yNextLine - fontAscent.    
        ].
        yText notNil ifTrue:[    
            yB := yB max:(yText "- fontAscent")
        ].
        y := yB.

        thisCol cellWidth:w.
        thisCol yBottom:yB.

        x := maxXInCol.
        x := x + padding + (spacing - (spacing//2)). "/ care for division of odd
        x := x + dx.        "/ from explicit width

        thisCol xRight:x.
"/ 'pass1 end col: ' print. currentColIndex print. ' w:' print. w print. ' xR:' print. thisCol xRight printCR.

        currentRow yBottom isNil ifTrue:[
            currentRow yBottom:yB
        ] ifFalse:[
            currentRow yBottom:(currentRow yBottom max:yB).
        ].
        maxXInCol := 0.

    ] ifFalse:[
        "/ back to left ...
        "/ x := thisCol xText.    "/ could be removed;
        x := thisCol xRight.   "/ could be removed;
    ].

    "/ back to top ...
    y := currentRow yRow - fontHeight + fontAscent - padding.

    yText := nil. yNextLine := nil.

    currentColor ~~ textFGColor ifTrue:[
        self setColor:textFGColor.
    ].

    "Modified: / 12-11-2016 / 00:33:56 / cg"
!

finishPreviousTableRow:final
    |row delta yB cols|

    currentRowIndex ~~ 0 ifTrue:[
        self finishPreviousTableColumn.

        row := currentTable rowAt:currentRowIndex.
        maxXInCol := 0.

        formatting ifTrue:[
            "/
            "/ ajust y for largest col
            "/
            yB := (row maxColumnBottom).
            cols := row columns.
            cols isEmpty ifTrue:[
                delta := 0
            ] ifFalse:[
                delta := yB - cols last yBottom.
                delta < 0 ifTrue:[
                    delta := 0
                ].
            ].

            y := y + delta.
            y := y max:yB.

            "/ y is baseline-y
            final ifFalse:[
                y := y + fontHeight - fontAscent.
                y := y + currentTable cellpadding
            ].
            row yBottom:y.
        ] ifFalse:[
            y := row yBottom.
        ]
    ]

    "Created: 4.3.1997 / 19:03:52 / cg"
    "Modified: 6.3.1997 / 00:47:22 / cg"
!

table
    |bw bw2 used|

    currentTable notNil ifTrue:[
        tableStack isNil ifTrue:[
            tableStack := OrderedCollection new.
        ].
        tableStack addLast:(Array with:currentTable
                                  with:currentRowIndex
                                  with:currentColIndex).
    ].

    self conditionalBreak.
    tableColX := nil.
    maxXInCol := 0.
    previousIsEmpty := true.

    scanning ifTrue:[
        currentTable notNil ifTrue:[
            'HTML [info]: table within table - this will not work' infoPrintCR.
        ]
    ].

    currentTable := element.
    currentRowIndex := currentColIndex := 0.

    bw := currentTable borderWidth.

    formatting ifTrue:[
        currentTable defaultCellPadding:(fontHeight//3).
        currentTable defaultCellSpacing:1.
    ].

    self needSpace:(fontHeight + 20).

    bw2 := (bw // 2).
    bw odd ifTrue:[bw2 := bw2 + 1].
    used := (fontHeight - fontAscent) "=fontDescent" + 2.       "/ 2 is spacing from previous lines descender
    used := used + bw2.                                         "/ allow space for tables border

    self needSpace:(2 * (used + fontHeight)).
    y := y + used.

    formatting ifTrue:[
        currentTable top:y - fontAscent.
    ] ifFalse:[
        destination isView ifTrue:[   "CLAUS"
            currentTable height isNil ifTrue:[
                'HTML [warning]: infinished table' infoPrintCR.
            ] ifFalse:[
                self drawTable
            ]
        ]
    ].

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 6.3.1997 / 02:04:15 / cg"
!

tableEnd
    |wMax yBot maxNumCols wMaxPerCol differentNumberOfCols
     numColsInRow wThisCol explicitWidth padding spacing bw columnFillUp info|

    currentRightLimit := docWidth - rightIndent.
    currentTable isNil ifTrue:[
        scanning ifTrue:[
            'HTML [info]: </table> but not within table - ignored' infoPrintCR.
        ].
        ^ self.
    ].

    tableColX := nil.

    self finishPreviousTableRow:true.
    self conditionalBreak.

    padding := currentTable cellpadding.

    formatting ifTrue:[
        spacing := currentTable cellspacing.

        "/
        "/ search through table - gather max width
        "/
        maxNumCols := 0.
        maxNumCols := (currentTable rows ? #())
                            inject:0 
                            into:[:maxSoFar :row | 
                                    maxSoFar max:(row columns size)
                                 ].

        wMaxPerCol := Array new:maxNumCols withAll:0.

        "/
        "/ any width argument ?
        "/
        explicitWidth := currentTable numericParameterFor:#'WIDTH' default:nil.
        explicitWidth notNil ifTrue:[
            explicitWidth isInteger ifFalse:[
                explicitWidth := leftIndent + indentOffset 
                                 + ((docWidth - rightIndent) * explicitWidth // 100).
            ].
        ].

        "/
        "/ find each cols max. width
        "/
        differentNumberOfCols := false.

        (currentTable rows ? #()) do:[:row |
            |cols numCols wSpread|

            cols := row columns.
            numCols := cols size.
                
            numCols ~~ maxNumCols ifTrue:[
                differentNumberOfCols := true.
                
                cols keysAndValuesDo:[:colIndex :col |
                    |wThis|

                    colIndex ~~ numCols ifTrue:[
                        wThis :=  col cellWidth.
                        wMaxPerCol at:colIndex put:((wMaxPerCol at:colIndex) max:wThis).
                    ].
                ].
                "/
                "/ spread the last cols size over the rest
                "/
                cols notEmpty ifTrue:[
                    wSpread := cols last cellWidth.
                    wSpread := wSpread // (maxNumCols - numCols + 1).
                    numCols to:maxNumCols do:[:colIndex |
                        wMaxPerCol at:colIndex put:((wMaxPerCol at:colIndex) max:wSpread).
                    ].
                ]
            ] ifFalse:[
                cols keysAndValuesDo:[:colIndex :col |
                    |wMax wThis|

                    wMax := wMaxPerCol at:colIndex.
                    wThis :=  col cellWidth.
                    wMaxPerCol at:colIndex put:(wMax max:wThis).
                ].
            ]
        ].
"/wMaxPerCol keysAndValuesDo:[:colIndex :max |
"/    'col: 'print. colIndex print. ' maxWidth:' print. max printCR.
"/].

        "/
        "/ get the tables overall width
        "/
        wMax := wMaxPerCol sum.

        columnFillUp := 0.
        explicitWidth notNil ifTrue:[
            explicitWidth > wMax ifTrue:[
                explicitWidth > (docWidth-rightIndent-leftIndent) ifTrue:[
                    explicitWidth := (docWidth-rightIndent-leftIndent).
                ].
                columnFillUp := (explicitWidth - wMax) // (maxNumCols max:1).
                wMax := explicitWidth.
            ]
        ].
        currentTable width:wMax.
    
        "/ patchup col-x positions
        "/ and xRights

        (currentTable rows ? #()) do:[:row |
            |cols el rowAlign xCol prevCol|

            "/ rows alignment
            el := row markupElement.
            rowAlign := el alignSymbol.

            cols := row columns.
            numColsInRow := cols size.
            prevCol := nil.

            cols keysAndValuesDo:[:colIndex :col |
                |x xText wCol colRight wMaxCol colAlign|

                wCol := col netWidth.                "/ the actual width req'd for this col
                wMaxCol := wMaxPerCol at:colIndex.   "/ the max width of this col (over all rows)
                wThisCol := wMaxCol.

                wThisCol := wThisCol + columnFillUp. "/ fullup from explicit width

                numColsInRow < maxNumCols ifTrue:[
                    "/ the last col in a row with less columns
                    colIndex == numColsInRow ifTrue:[
                        "/ extend it to the right
                    
                        colIndex+1 to:maxNumCols do:[:remainingColsIndex |
                            "/ wThisCol := wThisCol + (wMaxPerCol at:remainingColsIndex) + padding.
                            wThisCol := wThisCol + (wMaxPerCol at:remainingColsIndex).
                        ]
                    ]
                ].

                "/ adjust the cols x and xRight

                colIndex == 1 ifTrue:[
                    xCol := col x.
                ] ifFalse:[
                    col x:xCol.
                ].
                colRight := xCol + wThisCol.
                col xRight:colRight.

                "/ per-col alignment
                el := col markupElement.
                colAlign := el alignSymbol.
                colAlign isNil ifTrue:[
                    rowAlign notNil ifTrue:[
                        colAlign := rowAlign
                    ] ifFalse:[
                        "/
                        "/ for th, the default is center;
                        "/ for td, its left
                        "/
                        colAlign := (el type == #th) 
                                        ifTrue:[#center] 
                                        ifFalse:[#left].
                    ]
                ].
                colAlign == #right ifTrue:[
                    xText := colRight - padding - wCol.
                ] ifFalse:[
                    colAlign == #center ifTrue:[
                        xText := xCol + ((wThisCol - wCol) // 2).
                    ] ifFalse:[
                        "/ default to left
                        xText := xCol + spacing + padding.
                    ]
                ].
                col xText:xText.

                xCol := colRight.
                xCol > maxWidth ifTrue:[maxWidth := xCol].
                prevCol := col.
            ].
            prevCol notNil ifTrue:[
                prevCol xRight:xCol.
            ]
        ]
    ].

    bw := currentTable borderWidth.

    formatting ifTrue:[
        yBot := y - fontAscent + padding + (bw//2).
        currentTable height:yBot - (currentTable top).
        currentTable rows notEmptyOrNil ifTrue:[
            currentTable rows last yBottom:yBot.
        ].
        y := yBot.
    ] ifFalse:[
        destination isView ifTrue:[   "CLAUS"
            self drawTable
        ].
        currentTable rows notEmptyOrNil ifTrue:[
            y := currentTable rows last yBottom.
        ]
    ].

    currentTable := nil.

    y := y + fontAscent + (fontHeight//3) + bw. "/ 3 is spacing to next lines ascenders.
    self setFont:normalFont.

    tableStack notNil ifTrue:[
        info := tableStack removeLast.
        tableStack := tableStack asNilIfEmpty.
        currentTable := info at:1.
        currentRowIndex := info at:2.
        currentColIndex := info at:3.
    ].

    "Modified: 6.3.1997 / 01:18:13 / cg"
!

td
    currentTable notNil ifTrue:[
        self setFont:normalFont.
    ].
    self th_td_common

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 3.7.1996 / 14:50:44 / cg"
!

th
    currentTable notNil ifTrue:[
        self setFont:boldNormalFont.
    ].
    self th_td_common

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 3.7.1996 / 14:50:23 / cg"
!

th_td_common
    |row col padding spacing clr|

    currentTable isNil ifTrue:[ ^ self].

    currentRowIndex == 0 ifTrue:[
        self halt:'oops - no current row'.
        self tr
    ] ifFalse:[
        currentColIndex ~~ 0 ifTrue:[
            self finishPreviousTableColumn.
        ]
    ].

    row := currentTable rowAt:currentRowIndex.

    currentColIndex := currentColIndex + 1.

    scanning ifTrue:[
        col := HTMLTableCol new.
        row addColumn:col.
        col markupElement:element.
        col color:(element colorParameter:#'COLOR').
        col bgColor:(element colorParameter:#'BGCOLOR').
        col background:(element colorParameter:#'BACKGROUND').
    ] ifFalse:[
        col := row columnAt:currentColIndex.
    ].

    formatting ifTrue:[
        spacing := currentTable cellspacing.
        padding := currentTable cellpadding.
        col x:x.
        x := x + padding + (spacing // 2).
        col xText:x.
"/ 'pass1 col: ' print. currentColIndex print. ' x:' print. col x print. ' xT:' print. col xText printCR.
    ] ifFalse:[
"/ 'pass2 col: ' print. currentColIndex print. ' x:' print. col x print. ' xT:' print. col xText printCR.
        x := col xText.
        currentRightLimit := col xRight.
    ].

    tableColX := x.
    lastTextX := nil.
    yNextLine := yText := nil.
    needSpace := false.

    (clr := col color) notNil ifTrue:[
        self setColor:clr.
    ].
    (clr := col bgColor) notNil ifTrue:[
        self setBGColor:clr.
    ].

    "Created: 3.7.1996 / 14:50:33 / cg"
    "Modified: 6.3.1997 / 01:22:38 / cg"
!

tr
    |row padding bw bw2 used|

    currentTable isNil ifTrue:[^ self].

    self finishPreviousTableRow:false.
    currentRowIndex := currentRowIndex + 1.

    scanning ifTrue:[
        row := HTMLTableRow new.
        row columns:OrderedCollection new.
        row markupElement:element.

        currentTable addRow:row.
    ] ifFalse:[
        row := currentTable rowAt:currentRowIndex
    ].

    currentColIndex := 0.
    tableColX := nil.

    self conditionalBreak. 

    padding := currentTable cellpadding.

    currentRowIndex == 1 ifTrue:[
        bw := currentTable borderWidth.
        bw2 := bw // 2.
        bw odd ifTrue:[bw2 := bw2 + 1].
    ] ifFalse:[
        bw2 := 0
    ].

    used := fontHeight - fontAscent + padding.

    (self needSpace:(used + used + padding)) ifTrue:[
        y := y + (used + padding).

        (formatting or:[currentRowIndex ~~ 1]) ifFalse:[
            currentTable top:y - fontAscent
        ]
    ].

    "/ allow space for tables leftborder
    y := y + bw2.
    x := x + currentTable borderWidth.

    formatting ifTrue:[
        row yRow:(y + used).
    ] ifFalse:[
        destination isView ifTrue:[ "CLAUS"
            self drawTable
        ] ifFalse:[
            self drawTableRow:row
        ].
        y := row yRow - used.
    ].

    currentRightLimit := docWidth - rightIndent.
    needSpace := false.
    yNextLine := yText := nil.

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 6.3.1997 / 02:03:46 / cg"
! !

!HTMLDocumentPainter methodsFor:'elements-text'!

addText:txtIn fromElement:element
    |text wEnd w x0 l t lastLine fontWidth startsWithSep endsWithSep
     wordBuffer hadNeedSpaceBefore shift originalText tLen|

    "/ Transcript show:'T: '; show:needSpace; show:' '; showCR:txtIn.
    (text := txtIn) isNil ifTrue:[
        needSpace := true.
        ^ self
    ].

    hadNeedSpaceBefore  := needSpace.
    needSpace := false.

    headerDefinition notNil ifTrue:[
        text := self contentsAddHeader:text.
        element notNil ifTrue:[
            element text:text
        ]
    ].

    (formatting and:[scanning and:[anchorElement notNil]]) ifTrue:[
        t := anchorElement anchorText.
        t isNil ifTrue:[
            t := text.
        ] ifFalse:[
            t := t , text
        ].
        anchorElement anchorText:t.
    ].

    "/ that "optimization" seems to not work with xft fonts - sigh.
"/    currentFont == codeFont ifTrue:[
"/        fontWidth := fixFontWidth.
"/    ].

    inPre ~~ 0 ifTrue:[
        "/ preformatted text ...

        previousIsEmpty := false.

        yText notNil ifTrue:[
            y := yText.
            yText := nil.
        ].
        (formatting and:[text isString]) ifTrue:[
            text := text withTabsExpanded.

            (text includes:(Character cr)) ifTrue:[
                text := text asCollectionOfLines
            ].
            element notNil ifTrue:[
                element text:text.
            ]
        ].

        (text isString not and:[text size > 0]) ifTrue:[
            "/ multiple lines

            lastLine := text last.

            text do:[:aLine|
                l := aLine.

                l := l copyReplaceAll:(Character value:160) with:Character space ifNone:l.
                w := fontWidth notNil ifTrue:[l size * fontWidth]
                                     ifFalse:[currentFont widthOf:l].
                wEnd := x + w.

                formatting ifFalse:[
                    self privateDrawString:l atX:x y:y to:wEnd.
                ].
                boundsCollector notNil ifTrue:[
                    boundsCollector add:(Rectangle 
                                            left:x top:y-fontAscent 
                                            right:wEnd bottom:y-fontAscent+fontHeight).
                ].
                x := lastTextX := wEnd.

                formatting ifTrue:[
                    x > maxWidth  ifTrue:[maxWidth  := x].
                    x > maxXInCol ifTrue:[maxXInCol := x].
                ].
                aLine ~~ lastLine ifTrue:[ self break ].
            ]
        ] ifFalse:[
            text size > 0 ifTrue:[
                l := text.
                l := l copyReplaceAll:(Character value:160) with:Character space ifNone:l.

                w := fontWidth notNil ifTrue:[l size * fontWidth]
                                     ifFalse:[currentFont widthOf:l].
                wEnd := x + w.

                formatting ifFalse:[
                    self privateDrawString:l atX:x y:y to:wEnd.
                ].
                boundsCollector notNil ifTrue:[
                    boundsCollector add:(Rectangle left:x top:y-fontAscent right:wEnd bottom:y-fontAscent+fontHeight).
                ].

                x := lastTextX := wEnd.
                formatting ifTrue:[
                    x > maxWidth ifTrue:[maxWidth := x].
                    x > maxXInCol ifTrue:[maxXInCol := x].
                ].
            ].
        ].
        ^ self
    ].

    "/ to be formatted ...

    text isString ifTrue:[
        (tLen := text size) > 0 ifTrue:[
            startsWithSep := (text at:1) isSeparator.
            tLen > 1 ifTrue:[
                endsWithSep := (text at:tLen) isSeparator
            ] ifFalse:[
                endsWithSep := false
            ]
        ] ifFalse:[
            startsWithSep := endsWithSep := false
        ].
    ].

    scanning ifTrue:[
        "/ replace multi-whiteSpace by single spaces.

        (text := text asCollectionOfWords) isEmpty ifTrue:[
            element notNil ifTrue:[
                element text:nil.
            ].
            needSpace := true.
            ^ self
        ].
        text := text asStringWith:Character space.

        startsWithSep ifTrue:[
            endsWithSep ifTrue:[
                text := ' ' concatenate:text and:' '
            ] ifFalse:[
                text := ' ' , text
            ]
        ] ifFalse:[
            endsWithSep ifTrue:[
                text := text copyWith:(Character space)
            ]
        ].
        element notNil ifTrue:[
            element text:text.
        ]
    ].

    previousIsEmpty := false.

    yText notNil ifTrue:[
        y := yText.
        yText := nil.
    ].

    (haveSpace == true or:[self atOrLeftOfLeft]) ifTrue:[
        startsWithSep ifTrue:[
            text := text copyFrom:2
        ]
    ] ifFalse:[
        hadNeedSpaceBefore == true ifTrue:[
            text := ' ' , text
        ]
    ].
    haveSpace := false.

    text isString ifTrue:[
        "/ arrive here, for short strings, which fit
        "/ or for long strings, the very first time.
        "/ After that, for long strings, it will already be broken
        "/ into words.

        originalText := text.
        (text includes:(Character value:160)) ifTrue:[
            text := text copyReplaceAll:(Character value:160) with:Character space.
        ].

        w := fontWidth notNil ifTrue:[text size * fontWidth]
                             ifFalse:[currentFont widthOf:text on:destination device].
        wEnd := x + w.

        "/ ignore ending space for comparison ..

        endsWithSep ifTrue:[
            wEnd := wEnd - wSpace.
        ].
        currentRightLimit isNil ifTrue:[
            currentRightLimit := docWidth
        ].
        (wEnd <= currentRightLimit or:[noBreak ~~ 0]) ifTrue:[
            "/
            "/ all fits or forced-noBreak - don't break
            "/
            (center > 0 or:[rightAlign > 0]) ifTrue:[
                shift := (currentRightLimit-leftIndent) - (wEnd - x).
                center > 0 ifTrue:[
                    shift := shift // 2.
                ].
                shift > 0 ifTrue:[
                    x := x + shift.
                    wEnd := wEnd + shift
                ].
            ].

            formatting ifFalse:[
                "/ '[' print. text print. ']' printCR.
                self privateDrawString:text atX:x y:y to:wEnd.
            ].
            boundsCollector notNil ifTrue:[
                boundsCollector add:(Rectangle 
                                        left:x top:y-fontAscent 
                                        right:wEnd bottom:y-fontAscent+fontHeight).
            ].

            "/ do not ignore ending space for next-word position ..

            endsWithSep ifTrue:[
                wEnd := wEnd + wSpace.
                haveSpace := true.
            ].

            x := lastTextX := wEnd.
            formatting ifTrue:[
                x > maxWidth ifTrue:[maxWidth := x].
                x > maxXInCol ifTrue:[maxXInCol := x].
            ].
            center > 0 ifTrue:[
                self break.
            ].    
            ^ self
        ].

        "/ break it up - but only once
"/        text := originalText asCollectionOfWords.
        text := text asCollectionOfWords.
    ] ifFalse:[
        text do:[:aLine|
            (aLine includes:(Character value:160)) ifTrue:[
                aLine replaceAll:(Character value:160) with:Character space.
            ].
        ]
    ].

    "/
    "/ must break somewhere
    "/
    wordBuffer := ''.
    needSpace  := startsWithSep and:[self atLeft not].
    x0 := x.

    text do:[:word |
"/        (word includes:(Character value:160)) ifTrue:[
"/            "/ self halt:'should not happen'.
"/            word replaceAll:(Character value:160) with:Character space.
"/        ].

        w := fontWidth notNil ifTrue:[word size * fontWidth]
                             ifFalse:[currentFont widthOf:word].
        wEnd := x + w.

        wEnd >= currentRightLimit ifTrue:[
            "/
            "/ the word does not fit.
            "/ flush what has been collected so far.
            "/
            wordBuffer size > 0 ifTrue:[
                formatting ifFalse:[
                    self privateDrawString:wordBuffer atX:x0 y:y to:x.
                ] ifTrue:[
                    x > maxWidth  ifTrue:[maxWidth  := x].
                    x > maxXInCol ifTrue:[maxXInCol := x].
                ].
                boundsCollector notNil ifTrue:[
                    boundsCollector add:(Rectangle 
                                            left:x0 top:y-fontAscent 
                                            right:x bottom:y-fontAscent+fontHeight).
                ].
                lastTextX :=  x.
            ].
            self break.
            x0   := x .
            wEnd := x + w.

            formatting ifTrue:[ x0 := x0 min:x ].
            wordBuffer := word.
            x := wEnd.
        ] ifFalse:[
            formatting ifTrue:[ x0 := x0 min:x ].

            needSpace ifTrue:[
                wordBuffer := wordBuffer concatenate:' ' and:word.
                x := wEnd + wSpace.
            ] ifFalse:[
                wordBuffer size == 0 ifTrue:[
                    wordBuffer := word
                ] ifFalse:[
                    wordBuffer := wordBuffer, word
                ].
                x := wEnd.
            ].
        ].
        needSpace := true.
        previousIsEmpty := false.
    ].
    needSpace := endsWithSep.

    wordBuffer size > 0 ifTrue:[
        endsWithSep ifTrue:[
            x := x + wSpace.
            haveSpace := true.
        ].

        formatting ifFalse:[
"/ '[' print. wordBuffer print. ']' printCR.
"/            endsWithSep ifFalse:[
"/                wordBuffer := wordBuffer copyWithoutLast:1.
"/            ].
"/ '{' print. wordBuffer print. '}' printCR.

            self privateDrawString:wordBuffer atX:x0 y:y to:x.
        ] ifTrue:[
            x > maxWidth ifTrue:[maxWidth := x].
            x > maxXInCol ifTrue:[maxXInCol := x].
        ].

        boundsCollector notNil ifTrue:[
            boundsCollector add:(Rectangle 
                                    left:x0 top:y-fontAscent 
                                    right:x bottom:y-fontAscent+fontHeight).
        ].

        lastTextX := x.
        previousIsEmpty := false.
    ].

    "Created: / 19-07-1996 / 23:43:31 / cg"
    "Modified: / 30-08-2017 / 21:15:31 / cg"
    "Modified: / 08-08-2018 / 17:55:05 / Claus Gittinger"
!

privateDrawString:aString atX:xS y:yS to:xE
    |yt halfAscent limitTop limitBot|

    xE < displayLeft ifTrue:[^ self].
    xS > displayRight ifTrue:[^ self].

    limitTop := displayTop-fontHeight.
    yS < limitTop ifTrue:[^ self].
    limitBot := displayBottom+fontHeight.
    yS > limitBot ifTrue:[^ self].

    needColorChange ifTrue:[
        self handleColorChange.
    ].
    needFontChange ifTrue:[
        destination font:currentFont.
        needFontChange := false.
    ].

    inSup > 0 ifTrue:[
        yt := yS-SUPshift.
    ] ifFalse:[
        yt := yS.
    ].

    destination isView ifTrue:[
        destination displayString:aString x:xS y:yt.

        underline > 0 ifTrue:[
            destination paint:(currentUnderlineColor ? currentColor).
            destination displayLineFromX:xS y:(yS+1)
                                     toX:xE y:(yS+1).
            destination paint:currentColor.
        ].
        strikeout > 0 ifTrue:[
            halfAscent := (currentFont ascent // 2) - 1.
            destination displayLineFromX:xS y:(yS-halfAscent)
                                     toX:xE y:(yS-halfAscent).
        ].
    ] ifFalse:[
        destination underline:(underline > 0) strikeout:(strikeout > 0).
    
        lastTextX ~~ xS ifTrue:[
            destination displayString:aString x:xS y:yS.
        ] ifFalse:[
            destination displayStringAtLastPosition:aString.
        ].
        destination underline:false strikeout:false.
    ].

    "Modified: 30.6.1997 / 13:15:02 / cg"
! !

!HTMLDocumentPainter methodsFor:'formatting'!

flushAnchorColors
    ^ self.

"/    anchors notNil ifTrue:[
"/        anchors do:[:a |
"/            a isExample ifFalse:[
"/                a color ~~ visitedAnchorFGColor ifTrue:[
"/                    a color:nil
"/                ]
"/            ]
"/        ]
"/    ].

    "Modified: 21.5.1996 / 23:40:05 / cg"
    "Created: 22.6.1996 / 16:49:01 / cg"
!

format:docAnchor for:aGC resolver:aResolver style:aStyle
    |documentEncoding fontEncoding fontStyles fontStyle|

    documentEncoding := aResolver documentEncoding.
    scanning := true.
    imageAndStyleResolver := aResolver.
    formattingStyle := aStyle.

    docAnchor == document ifTrue:[
        ^ self.
    ].

    self destroyWidgets.
    anchors:= OrderedCollection new.
    document := docAnchor.
    docWidth := currentRightLimit := nil.
    metaCommands := nil.
    forms := nil.
    applets := nil.
"/    loadedAppletClasses := nil.

    maxWidth := maxHeight := maxXInCol := 0.
    anyElementsWithRelativeHeight := false.

    aGC title:''.
    docAnchor isNil ifTrue:[
        ^ self
    ].

    destination := aGC.

    textFGColor := aStyle textFGColor.
    anchorFGColor := aStyle anchorFGColor.
    anchorUnderline := aStyle anchorUnderline.
    activeAnchorFGColor := aStyle activeAnchorFGColor.
    activeAnchorBGColor := aStyle activeAnchorBGColor.
    visitedAnchorFGColor := aStyle visitedAnchorFGColor.
    exampleFGColor := aStyle exampleFGColor.
    codeFGColor := aStyle codeFGColor.

    fontStyles := aStyle fontStyles.
    fontStyles isNil ifTrue:[
        self halt:'HTML: no fontstyles - should not happen'.
    ].

    fontEncoding := aResolver fontEncodingFor:documentEncoding.
    fontStyle := fontStyles at:fontEncoding ifAbsent:nil.
    fontStyle isNil ifTrue:[
        fontStyle := fontStyles at:#'iso10646-1' ifAbsent:nil.
        fontStyle isNil ifTrue:[
            (( 'jis*0208*' match:fontEncoding) or:[( 'big5*' match:fontEncoding)])
            ifTrue:[
                fontStyle := HTMLFontStyle new.
                fontStyles at:fontEncoding put:fontStyle.
                aResolver initLazyFontStyle:fontStyle size:10 encoding:fontEncoding
            ].
        ]
    ].

    fontStyle isNil ifTrue:[
        self halt:'HTML: no fontstyle - should not happen'.
    ].

    fontSize := fontStyle fontSize ? 10.

    normalFont           := fontStyle normalFont.
    boldNormalFont       := fontStyle boldNormalFont.
    italicNormalFont     := fontStyle italicNormalFont.
    boldItalicNormalFont := fontStyle boldItalicNormalFont.

    codeFont             := fontStyle codeFont.
    boldCodeFont         := fontStyle boldCodeFont.
    italicCodeFont       := fontStyle italicCodeFont.
    boldItalicCodeFont   := fontStyle boldItalicCodeFont.

    normalSmallFont      := fontStyle normalSmallFont.
    symbolFont           := fontStyle symbolFont.

    h1Font               := fontStyle h1Font.
    h2Font               := fontStyle h2Font.
    h3Font               := fontStyle h3Font.
    h4Font               := fontStyle h4Font.
    h5Font               := fontStyle h5Font.
    h6Font               := fontStyle h6Font.

    self getFontsFor:aGC.

    self prescanForms.

    arrayOfHeaderIndex := self initialHeaderNumbers.
    collectHeaders     := arrayOfHeaderIndex notNil.
    listOfHeaders      := nil.

    self reformatDocument.

    collectHeaders := false.
    scanning       := false.

    self processMetaCommands.

    self checkInitialStateAtEndOfDocument.

    scriptObject notNil ifTrue:[
        "/ setup again; now, more info (forms & applets) is known
        scriptObject _setupForWindow:destination.
        scriptObject _start.
    ].

    "Created: / 05-09-1996 / 21:20:14 / cg"
    "Modified: / 10-08-2010 / 15:58:50 / cg"
!

process:aDocumentAnchor
    lock critical:[
        |nextSyncY prevType type e skip selector selectorTable|

        nextSyncY := 100.

        document := element := e := aDocumentAnchor.
        selectorTable := self class selectorTable.

        [e notNil] whileTrue:[
            type := e type.

            (skip := currentApplet notNil) ifTrue:[
                "/ skip upto applet end
                ((type == #'/app') or:[type == #'/applet']) ifTrue:[
                    skip := false
                ]
            ].
            inNoPrintingParagraph > 0 ifTrue:[
                destination isView ifFalse:[
                    (type = 'p' or:[type = '/p']) ifFalse:[
                        skip := true.
                    ].
                ]
            ].

            skip ifFalse:[
                (prevType == #'/form') ifTrue:[
                    self addSyncPoint.
                ].

                ((type == #form) or:[type == #table]) ifTrue:[
                    self addSyncPoint.
                ] ifFalse:[
                    (y >= nextSyncY) ifTrue:[
                        currentTable isNil ifTrue:[
                            self addSyncPoint.
                            nextSyncY := nextSyncY + 300.
                        ]
                    ].
                ].

                formatting ifTrue:[
                    destination isView ifTrue:[
                        previousElement notNil ifTrue:[
                            previousElement bounds isNil ifTrue:[
                                boundsCollector notEmptyOrNil ifTrue:[
                                    previousElement bounds:boundsCollector
                                ].    
                            ].    
                        ].
                        
                        boundsCollector := OrderedCollection new.
                    ].
                ].
                type isNil ifTrue:[
                    self specialMarkup
                ] ifFalse:[
                    selector := selectorTable at:type ifAbsent:nil.
                    selector isNil ifTrue:[
                         ('HTMLDocumentPainter [info]: unknown tag: ' , type) infoPrintCR.
                    ] ifFalse:[
                        self perform:selector
                    ]
                ].
            ].
            prevType := type.
            previousElement := element.
            element := e := e next.
        ].
    ].

    "Created: / 22-06-1996 / 16:49:01 / cg"
    "Modified: / 09-08-2010 / 17:14:55 / cg"
    "Modified: / 08-08-2018 / 17:56:09 / Claus Gittinger"
!

reformatDocument
    imageDisplayProcess notNil ifTrue:[
        imageDisplayProcess isDead ifFalse:[
            imageDisplayProcess terminateWithAllSubprocessesInGroup.
        ].
        imageDisplayProcess := imagesToDisplay := nil.
    ].

"/    destination width == docWidth ifTrue:[
"/        anyElementsWithRelativeHeight ifFalse:[
"/            ^ self.
"/        ].
"/    ].
    destination isNil ifTrue:[
        ^ self
    ].

    docWidth := destination width.
    currentRightLimit := docWidth.
    rightIndent notNil ifTrue:[
        currentRightLimit := currentRightLimit - rightIndent
    ].
    maxWidth := maxXInCol := 0.
    formatting := true.

    syncPoints := OrderedCollection new:50.

    self setupInitialState.

    self process:document.

    self conditionalBreak.
    maxHeight := y.

    "Created: / 22.6.1996 / 16:49:01 / cg"
    "Modified: / 1.4.1998 / 19:12:06 / cg"
! !

!HTMLDocumentPainter methodsFor:'helpers'!

atLeft
    ^ x == (leftIndent + indentOffset)

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 19.9.1996 / 10:15:36 / cg"
!

atOrLeftOfLeft
    ^ x <= (leftIndent + indentOffset)

    "Modified: 19.9.1996 / 10:15:36 / cg"
    "Created: 19.9.1996 / 10:18:35 / cg"
!

atTop
    ^ y <= (destination topMargin)

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 19.9.1996 / 10:15:36 / cg"
!

break
    yNextLine notNil ifTrue:[
        y := yNextLine
    ] ifFalse:[
        (currentForm notNil and:[destination isView]) ifTrue:[
            y := y + currentForm maxHeight + 3.
        ] ifFalse:[
            x = (leftIndent+indentOffset) ifTrue:[
                y := y + fontAvgHeight.
                previousIsEmpty := true.
            ] ifFalse:[
                y := y + fontHeight + lineSpacing
            ]
        ]
    ].
    x := leftIndent+indentOffset.  
    tableColX notNil ifTrue:[
        x := tableColX. 
    ].
    lastTextX := nil.

    yNextLine := nil.
    yText := nil.

    (destination isView not and:[y > self pageBreakLimit]) ifTrue:[
         self pageBreak
    ].

    "Modified: 18.9.1996 / 09:34:00 / cg"
!

conditionalBreak
    "break line if not already at the beginning"

    self atLeft ifFalse:[
        self break
    ].

    (y > self pageBreakLimit and:[destination isView not]) ifTrue:[
         self pageBreak
    ].

    "Created: 22.6.1996 / 16:49:01 / cg"
!

conditionalEmpty
    "add vertical space, but only if there is not already some"

    previousIsEmpty ifFalse:[
        self empty.
    ].

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 17.6.1997 / 17:16:45 / cg"
!

conditionalHalfEmpty
    "add vertical space, but only if there is not already some"

    previousIsEmpty ifFalse:[
        self halfEmpty.
    ].

    "Created: / 12-11-2010 / 11:16:37 / cg"
!

currentElementHasHREF
    ^ anchorElement notNil and:[ anchorElement hrefString notEmptyOrNil ].

    "Created: / 22-06-1996 / 16:49:01 / cg"
    "Modified: / 16-11-2016 / 17:17:10 / cg"
!

do_needAndNewPage
    "handle any NEWPAGE and NEED= attributes of the current element,
     put only if painting to paper (i.e. ignore if displaying)"

    |spc|

"/    formatting ifFalse:[
        destination isView ifFalse:[
            (element hasParameterFor:#'NEWPAGE') ifTrue:[
                self break.
                self pageBreak.
                previousIsEmpty := true.
            ] ifFalse:[
                (element hasParameterFor:#'NEED') ifTrue:[
                    spc := element numericParameterFor:#'NEED' default:0.
                    self needSpace:spc
                ]
            ]
        ].
"/    ].

    "Modified: 17.6.1997 / 17:08:14 / cg"
!

do_starOfficeStyleBefore
    "handle 
        STYLE='page-break-before: always'"

    |arg words|

    "/ STYLE="page-break-before: always"

"/    formatting ifFalse:[
        destination isView ifFalse:[
            (element hasParameterFor:#'STYLE') ifTrue:[
                arg := element parameterFor:#'STYLE'.
                arg notNil ifTrue:[
                    arg := arg asLowercase.
                    words := arg asCollectionOfWords.
                    words notEmpty ifTrue:[
                        (words at:1) = 'page-break-before:' ifTrue:[
                            words size > 1 ifTrue:[
                                (words at:2) = 'always' ifTrue:[
                                    self break.
                                    self pageBreak.
                                    previousIsEmpty := true.
                                ]
                            ]
                        ]
                    ].
                ]
            ].
        ].
"/    ].

    "Modified: / 17.6.1997 / 17:08:14 / cg"
    "Created: / 27.10.1999 / 11:22:29 / stefan"
    "Modified: / 27.10.1999 / 11:22:53 / stefan"
!

empty
    self empty:normalFontHeight

    "Created: 22.6.1996 / 16:49:01 / cg"
!

empty:height
    height <= 0 ifTrue:[^ self].

    self atLeft ifFalse:[
        self break
    ].

    yNextLine notNil ifTrue:[
        y := yNextLine.
        yNextLine := nil.
    ].

    y := y + height.
    yText := nil. 
    maxHeightInRow := 0.
    firstElementInRow := nil.
    previousIsEmpty := true.
    lastTextX := nil.

    (destination isView not and:[y > self pageBreakLimit]) ifTrue:[
         self pageBreak
    ].

    "Modified: 17.6.1997 / 17:10:22 / cg"
!

getFontsFor:aGC
    |gcDevice|

    gcDevice := aGC device.

    normalFont isNil ifTrue:[
        normalFont := View defaultFont.
    ].
    boldNormalFont isNil ifTrue:[boldNormalFont := normalFont].
    italicNormalFont isNil ifTrue:[italicNormalFont := normalFont].
    boldItalicNormalFont isNil ifTrue:[boldItalicNormalFont := normalFont].

    normalFont := normalFont onDevice:gcDevice.
    boldNormalFont := boldNormalFont onDevice:gcDevice.
    italicNormalFont := italicNormalFont onDevice:gcDevice.
    boldItalicNormalFont := boldItalicNormalFont onDevice:gcDevice.

    codeFont isNil ifTrue:[codeFont := normalFont].
    boldCodeFont isNil ifTrue:[boldCodeFont := codeFont].
    italicCodeFont isNil ifTrue:[italicCodeFont := codeFont].
    boldItalicCodeFont isNil ifTrue:[boldItalicCodeFont := codeFont].

    codeFont := codeFont onDevice:gcDevice.
    boldCodeFont := boldCodeFont onDevice:gcDevice.
    italicCodeFont := italicCodeFont onDevice:gcDevice.
    boldItalicCodeFont := boldItalicCodeFont onDevice:gcDevice.

    normalSmallFont isNil ifTrue:[normalSmallFont := normalFont].
    symbolFont isNil ifTrue:[symbolFont := normalFont].

    normalSmallFont := normalSmallFont onDevice:gcDevice.
    symbolFont := symbolFont onDevice:gcDevice.

    h1Font isNil ifTrue:[h1Font := normalFont].
    h2Font isNil ifTrue:[h2Font := normalFont].
    h3Font isNil ifTrue:[h3Font := normalFont].
    h4Font isNil ifTrue:[h4Font := normalFont].
    h5Font isNil ifTrue:[h5Font := normalFont].
    h6Font isNil ifTrue:[h6Font := normalFont].

    h1Font := self class fontFor:h1Font onDevice:gcDevice.
    h2Font := self class fontFor:h2Font onDevice:gcDevice.
    h3Font := self class fontFor:h3Font onDevice:gcDevice.
    h4Font := self class fontFor:h4Font onDevice:gcDevice.
    h5Font := self class fontFor:h5Font onDevice:gcDevice.
    h6Font := self class fontFor:h6Font onDevice:gcDevice.

    fixFontWidth := codeFont width.
    currentFont isNil ifTrue:[ 
        currentFont := normalFont.
        self getFontParameters.
    ].
    
    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 16.10.1996 / 13:29:26 / cg"
!

halfEmpty
    self empty:normalFontHeight // 2

    "Created: / 12-11-2010 / 11:16:06 / cg"
!

handlePendingSpaceNeed
    needSpace ifTrue:[
        self atOrLeftOfLeft ifFalse:[
            needSpace := false.
            self addText:' ' fromElement:nil
        ]
    ].

    "Created: 17.6.1997 / 17:33:14 / cg"
!

header:index font:aFont space:space
    |wasEmpty prevH align inList|

    inList := (inOL ~~ 0
              or:[inDL ~~ 0
              or:[ulLevel ~~ 0]]).

    "/ don't break for headers within a list
    inList ifFalse:[
        self needSpace:fontHeight * space.
"/        formatting ifFalse:[
            self do_starOfficeStyleBefore.
            self do_needAndNewPage.
"/        ].
    ].

    wasEmpty := previousIsEmpty.

    prevH := fontHeight.
    self setFont:aFont.

    inList ifFalse:[
        previousIsEmpty ifFalse:[
            index < 2 ifTrue:[
                self empty.
            ] ifFalse:[
                self halfEmpty.
            ].    
        ].    
        self empty:(fontHeight - prevH) // index.
    ].

    hBegin notNil ifTrue:[
        'HTML [info]: oops - nested headers' infoPrintCR.
    ].
    hBegin := element.

    (formatting and:[collectHeaders]) ifTrue:[
        arrayOfHeaderIndex size >= index ifTrue:[
            (element hasParameterFor:#'NOINDEX') ifFalse:[
                arrayOfHeaderIndex at:index put:((arrayOfHeaderIndex at:index) + 1).
                arrayOfHeaderIndex from:(index +1) to:arrayOfHeaderIndex size put:0.
                headerDefinition := ''
            ]
        ]
    ].

    align := element parameterFor:#'ALIGN'.
    align notNil ifTrue:[    
        align := align asLowercase.
        align = 'center' ifTrue:[
            center := center + 1.
        ] ifFalse:[
            align = 'right' ifTrue:[
                rightAlign := rightAlign + 1.
            ]   
        ]
    ].

    "Modified: / 20-10-1998 / 17:02:42 / cg"
    "Modified: / 27-10-1999 / 11:23:23 / stefan"
    "Modified: / 05-06-2018 / 06:13:54 / Claus Gittinger"
!

headerEnd
    |desc align inList|

    inList := (inOL ~~ 0
              or:[inDL ~~ 0
              or:[ulLevel ~~ 0]]).

    self conditionalBreak.

    self setFont:normalFont.
    self empty.

    (headerDefinition notNil 
     and:[hBegin notNil 
     and:[headerDefinition notEmpty]]) 
     ifTrue:[
        listOfHeaders isNil ifTrue:[
            listOfHeaders := OrderedCollection new
        ].
        desc := Array with:(hBegin type asString last digitValue)
                      with:pageNumber
                      with:headerDefinition.

        listOfHeaders add:desc.
    ].

    hBegin notNil ifTrue:[
        align := hBegin parameterFor:#'ALIGN'.
        align notNil ifTrue:[
            align asLowercase = 'center' ifTrue:[
                center := (center - 1) max:0.
            ] ifFalse:[
                align asLowercase = 'right' ifTrue:[
                    rightAlign := (rightAlign - 1) max:0.
                ]
            ]
        ]
    ].

    hBegin := nil.
    headerDefinition := nil.

    "Modified: / 20.10.1998 / 17:02:06 / cg"
!

initialHeaderNumbers
    |initialHeaderNumbers|

    formattingStyle headerNumbers ifTrue:[
        initialHeaderNumbers := formattingStyle initialHeaderNumbers.
        initialHeaderNumbers notNil ifTrue:[
            ^ (Array new:10 withAll:0) replaceFrom:1 with:( initialHeaderNumbers collect:[:n | n - 1] )
        ].
        ^ Array new:10 withAll:0.
    ].
    ^ nil

    "Created: 7.9.1996 / 15:34:59 / cg"
!

needSpace:nVerticalPixel
    |need|

    destination isView ifFalse:[
        "/
        "/ when printing, force a pageBreak, if not at least nPixel pixels available
        "/
        need := element numericParameterFor:#'NEED' default:nVerticalPixel.
        (y + need) > self pageBreakLimit ifTrue:[
            self break.
            previousIsEmpty := true.
            self pageBreak.
            ^ true
        ].
    ].
    ^ false
!

relativeValueFrom:aString with:aNumericValue
    |attr s|

    attr := element parameterFor:aString.
    attr isNil ifTrue:[^ nil].

    s := attr readStream.
    s peekOrNil == $+ ifTrue:[
        s next.
        ^ aNumericValue + (Number readFrom:s onError:0)
    ].
    s peekOrNil == $- ifTrue:[
        s next.
        ^ aNumericValue - (Number readFrom:s onError:0).
    ].
    ^ Number readFrom:s onError:aNumericValue

    "Created: / 25.2.1997 / 17:14:22 / cg"
    "Modified: / 14.4.1998 / 18:53:46 / cg"
! !

!HTMLDocumentPainter methodsFor:'initialization'!

initialize
    lock := RecursionLock new.
! !

!HTMLDocumentPainter methodsFor:'initialization & release'!

release
    "/ sent from docView, to release stuff

    HTMLMarkup releaseColors.

    scriptObject notNil ifTrue:[
        scriptObject _stop.
        scriptObject := nil.
    ].

    self destroyWidgets.

    imageDisplayProcess notNil ifTrue:[
        ProcessorScheduler invalidProcessSignal ignoreIn:[
            imageDisplayProcess terminateWithAllSubprocessesInGroup.
        ].
    ].
    imageDisplayProcess := imagesToDisplay := nil.

    self terminateMetaCommands.
    super release.

    "Created: / 22.6.1996 / 16:49:01 / cg"
    "Modified: / 1.4.1998 / 19:12:02 / cg"
!

terminateMetaCommands
    "/ sent from docView, to release stuff

    subProcesses notNil ifTrue:[
        subProcesses do:[:aProcess |
            aProcess terminate
        ].
        subProcesses := OrderedCollection new.
    ].

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 19.10.1997 / 23:17:24 / cg"
! !

!HTMLDocumentPainter methodsFor:'meta commands'!

processMetaCommands
    destination isView ifFalse:[^ self].

    metaCommands notNil ifTrue:[
        metaCommands do:[:entry |
            |metaCmd metaArg args time url p|

            metaCmd := entry key.
            metaArg := entry value.

"/            Transcript showCR:metaCmd , ' -> ' , metaArg.

            metaCmd = 'refresh' ifTrue:[
                args := metaArg asCollectionOfSubstringsSeparatedBy:$;.
                args size >= 2 ifTrue:[
                    time := Integer readFrom:(args at:1) onError:nil.
                    time notNil ifTrue:[
                        url := HTMLMarkup parameterFor:'URL' from:(args at:2).
                        url notNil ifTrue:[
                            subProcesses isNil ifTrue:[
                                subProcesses := OrderedCollection new.
                            ].
                            p := [
                                    [
                                        Delay waitForSeconds:time.
                                        self refreshDocument:url.
                                        Processor activeProcess terminate.
                                    ] ifCurtailed:[
                                        subProcesses removeIdentical:p ifAbsent:nil      
                                    ]    
                                 ] newProcess.
                            p name:'HTML meta'.
                            p priorityRange:((Processor userSchedulingPriority - 1) to:(Processor userSchedulingPriority)).
                            subProcesses add:p.
                            p resume.    
                        ]
                    ].
                ]
            ].
        ]
    ]

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 1.2.1997 / 12:07:00 / cg"
!

refreshDocument:url
    ('HTML [info]: automatic refresh: ' , url , ' ...') infoPrintCR.

    imageAndStyleResolver
        showDocument:url 
        text:nil
        action:nil
        remember:true
        source:false

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 10.1.1997 / 15:42:38 / cg"
! !

!HTMLDocumentPainter methodsFor:'private'!

addSyncPoint
    syncPoints add:self syncPoint

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 9.8.1997 / 01:57:18 / cg"
!

displayImagesOn:destinationDevice usingPlayers:players
    |entry el img pos fg bg imgSeq player ignoreImage
     w h dX dY|

    [imagesToDisplay notEmpty] whileTrue:[
        entry := imagesToDisplay next. "/ removeLast.
        el := entry at:1.
        img := entry at:2.
        pos := entry at:3.
        fg := entry at:4.
        bg := entry at:5.

        img device ~~ destinationDevice ifTrue:[
            Error catch:[
                img := img onDevice:destinationDevice.
            ].
            el image:img.
        ].

        ignoreImage := false.
        (imgSeq := img imageSequence) notNil ifTrue:[
            "/ start a player for that sequence ...
            player := players at:imgSeq ifAbsent:nil.
            (player notNil and:[player isDead]) ifTrue:[
                players at:imgSeq put:nil.
                player := nil.
            ].

            player isNil ifTrue:[
                player := self forkImageSequencePlayerFor:entry.
                players at:imgSeq put:player.
            ].
            "/
            "/ Q: should we show the first image immediately,
            "/    or wait until the whole film is available ?
            "/
            "/ ignoreImage := true.
        ].
        ignoreImage ~~ true ifTrue:[
            "/ a regular image (or the first in a sequence)
            h := img height.
            w := img width.
            
            destination windowGroup sensor 
                pushUserEvent:#'value:value:value:value:' 
                for:[:pos :img :fg :bg|
                    |savedFG savedBG vOrg dT dB dL dR|

                    x := pos x.
                    y := pos y.

                    vOrg := destination viewOrigin.
                    dT := vOrg y.
                    dB := dT + destination height.
                    dL := vOrg x.
                    dR := dL + destination width.

                    ((y+h) >= dT 
                      and:[y <= dB
                      and:[(x) <= dR
                      and:[(x + w) >= dL]]]
                    ) ifTrue:[
                        dX := x - dL.
                        dY := y - dT.

                        savedFG := destination paint.
                        savedBG := destination backgroundPaint.

                        destination paint:fg on:bg.
                        img displayOn:destination x:x y:y.
                        destination paint:savedFG on:savedBG.

                        "/ destination flush.
                    ]
                ]
                withArguments:{ pos . img . fg . bg }
        ]
    ]

    "Created: / 22-07-2018 / 15:36:43 / Claus Gittinger"
    "Modified (comment): / 22-07-2018 / 22:31:21 / Claus Gittinger"
!

forkImageSequencePlayerFor:entry
    ^ [ self playImageSequence:entry ] forkAt:(Processor activePriority - 1).

    "Created: / 1.4.1998 / 18:54:01 / cg"
    "Modified: / 2.4.1998 / 11:48:24 / cg"
!

handleColorAttribute
    |clr|

    clr := element colorParameter:#'COLOR'.
    clr notNil ifTrue:[
        self setColor:clr.
        self setUnderlineColor:clr.
    ].
    clr := element colorParameter:#'TEXT-COLOR'.
    clr notNil ifTrue:[
        self setColor:clr.
    ].
    clr := element colorParameter:#'BGCOLOR'.
    clr notNil ifTrue:[
        self setBGColor:clr.
    ].
    clr := element colorParameter:#'BACKGROUND-COLOR'.
    clr notNil ifTrue:[
        self setBGColor:clr.
    ].
    clr := element colorParameter:#'UNDERLINE-COLOR'.
    clr notNil ifTrue:[
        self setUnderlineColor:clr.
    ].
!

handleColorChange
    needColorChange ifTrue:[
        currentColor := currentColor onDevice:destination device.
        drawnColors add:currentColor.
        currentBGColor notNil ifTrue:[
            currentBGColor := currentBGColor onDevice:destination device.
            drawnColors add:currentBGColor.
            destination paint:currentColor on:currentBGColor.
        ] ifFalse:[
            destination paint:currentColor.
        ].
        needColorChange := false.
    ].

    "Modified: / 17-09-2007 / 11:58:29 / cg"
!

playImageSequence:entry
    |img prevImg pos posX posY fg bg savedFG savedBG el
     destinationDevice imgSeq stillPlaying playCount|

    destinationDevice := destination device.

    el := entry at:1.
    img := entry at:2.
    pos := entry at:3.
    fg := entry at:4.
    bg := entry at:5.

    posX := pos x.
    posY := pos y.

    imgSeq := img imageSequence.

    "/ get device images first ..
    "/ using an even lower priority ...
    Processor activeProcess withLowerPriorityDo:[
        imgSeq do:[:aFrame |
            |img|

            img := aFrame image.
            img device ~~ destinationDevice ifTrue:[
                img := img onDevice:destinationDevice.
                aFrame image:img.
            ].
        ].
    ].

    stillPlaying := true.
    playCount := 0.

    [stillPlaying] whileTrue:[
        imgSeq do:[:aFrame |
            |img millis delay tNext now|

            img := aFrame image.
            millis := aFrame delay ? 100.
            millis := millis max:50.
            tNext := Timestamp now addMilliseconds:millis.

            "/ must raise my prio above imageViews prio, 
            "/ to avoid scroll operations while drawing the image

            Processor activeProcess withHigherPriorityDo:[
                |vOrg dT dB dL dR m dX dY f imgW imgH prevW prevH|

                destination shown ifTrue:[
                    vOrg := destination viewOrigin.
                    dT := vOrg y.
                    dB := dT + destination height.
                    dL := vOrg x.
                    dR := dL + destination width.

                    imgH := img height.
                    imgW := img width.

                    ((posY+imgH) >= dT 
                    and:[posY <= dB
                    and:[posX <= dR
                    and:[(posX + imgW) >= dL]]]) ifTrue:[
                        "/ can draw quicker sometimes ...

                        dX := posX - dL.
                        dY := posY - dT.

                        savedFG := destination paint.
                        savedBG := destination backgroundPaint.

                        prevImg notNil ifTrue:[
                            prevW := prevImg width.
                            prevH := prevImg height.

                            (img mask isNil
                            and:[imgW >= prevW
                            and:[imgH >= prevH]]) ifTrue:[
                                "/ no need to clear - new frame is bigger any way
                            ] ifFalse:[
                                (prevW > imgW
                                or:[prevH > imgH
                                or:[prevImg mask notNil]]) ifTrue:[
"/                                    destination paint:(destination viewBackground).
"/                                    destination fillRectangleX:x y:y width:prevW height:prevH.
                                    destination clearRectangleX:posX y:posY width:prevW height:prevH.
                                ]
                            ].
                        ].
                        destination paint:fg on:bg.
                        destination displayDeviceForm:img x:dX y:dY.
                        destination paint:savedFG on:savedBG.
                    ] ifFalse:[
                        Processor activeProcess terminate.
                    ]
                ] ifFalse:[
                    Processor activeProcess terminate.
                ]
            ].

            tNext <= (now := Timestamp now) ifFalse:[
                delay := tNext millisecondDeltaFrom:now.
                Delay waitForMilliseconds:delay
            ].
            prevImg := img.
        ].

        imgSeq loop ifTrue:[
            "/ stillPlaying remains true ...
        ] ifFalse:[
            playCount := playCount + 1.
            imgSeq iterationCount notNil ifTrue:[
                imgSeq iterationCount > playCount ifFalse:[
                    stillPlaying := false
                ]
            ].
        ].
    ]

    "Created: / 1.4.1998 / 18:43:24 / cg"
    "Modified: / 2.4.1998 / 12:00:28 / cg"
!

processFrom:firstElement while:aBlock
    "process elements starting with firstElement, while aBlock
     returns true. Should be called from a saveExcursion block."

    |e selectorTable|

    element := e := firstElement.
    selectorTable := self class selectorTable.

    [e notNil] whileTrue:[     
        |prevType type|

        (aBlock value:e) ifFalse:[^ self].

        type := e type.

        type isNil ifTrue:[
            self specialMarkup
        ] ifFalse:[
            type := selectorTable at:type ifAbsent:type.
            (type endsWith:$/) ifFalse:[
                self perform:type
            ]
        ].
        prevType := type.
        element := e := e next.
    ]

    "Created: 18.10.1996 / 17:34:04 / cg"
    "Modified: 18.10.1996 / 17:36:59 / cg"
!

resyncFrom:syncPoint
    "/ fetch the state found there

    lock critical:[
        x := syncPoint xPosition.  lastTextX := nil.
        y := syncPoint yPosition.
        "/    fontHeight := syncPoint currentFontHeight.
        "/    fontAscent := syncPoint currentFontAscent.
        "/    fontAvgHeight := syncPoint currentFontAvgHeight.
        self setFont:syncPoint currentFont.
        self getFontParameters.

        leftIndent := syncPoint currentLeftIndent.
        indentOffset := syncPoint currentIndentOffset.
        rightIndent := syncPoint currentRightIndent.
        yNextLine := syncPoint yNextLine.
        yText := syncPoint yText.

        anchorElement := nil.
        previousIsEmpty := syncPoint previousIsEmpty.
        inNoPrintingParagraph := syncPoint inNoPrintingParagraph.
        inPre := syncPoint inPre.
        inKbd := syncPoint inKbd.
        inDL := syncPoint inDL.
        inOL := syncPoint inOL.
        inBLOCKQUOTE := syncPoint inBLOCKQUOTE.
        inSup := syncPoint inSup.
        needSpace := syncPoint needSpace.
        haveSpace := syncPoint haveSpace.

        underline := syncPoint inUnderline.
        strikeout := syncPoint inStrikeout.
        ulLevel := syncPoint ulLevel.
        noBreak := syncPoint inNoBreak.
        center := syncPoint inCenter.
        rightAlign := syncPoint inRightAlign.

        currentColor := syncPoint currentColor.
        currentBGColor := syncPoint currentBGColor.
        currentUnderlineColor := syncPoint currentUnderlineColor.
        currentForm := syncPoint currentForm.
        currentTable := syncPoint currentTable.
        currentRowIndex := syncPoint currentRowIndex.
        currentColIndex := syncPoint currentColIndex.
        needFontChange := needColorChange := true.

        hBegin := syncPoint hBegin.
        styleStack := syncPoint styleStack.

        element := syncPoint currentElement.
    ].

    "Created: / 22-06-1996 / 16:49:01 / cg"
    "Modified: / 17-09-2007 / 12:01:19 / cg"
!

saveExcursion:aBlock
    "save the current state, perform aBlock and restore the state afterwards"

    |syncPoint|

    syncPoint := self syncPoint.
    aBlock value.
    self resyncFrom:syncPoint

    "Modified: 9.8.1997 / 01:57:01 / cg"
!

saveExcursionFrom:firstElement while:testBlock
    "remember the current state, process elements starting with firstElement,
     while testBlock returns true, finally restore the state"

    self saveExcursion:[
        self processFrom:firstElement while:testBlock.
    ]

    "Created: 18.10.1996 / 17:35:37 / cg"
    "Modified: 18.10.1996 / 17:37:29 / cg"
!

setupInitialState
    "setup some initial state, such as margins, indents,
     colors, fonts etc."

    drawnColors := IdentitySet new.
    inHeader := false.

    destination isView ifTrue:[
        topMargin     := topMargin ? TOPmargin ? 20.
        leftMargin    := leftMargin ? LEFTmargin ? 20.
        rightMargin   := rightMargin ? RIGHTmargin ? 20.
        pageNumber    := 1.
    ] ifFalse:[
        leftMargin    := 0.
        topMargin     := destination topMargin.
        rightMargin   := destination rightMargin.
        pageNumber    := destination pageCounter.  
    ].

    leftIndent    := leftMargin.
    rightIndent   := rightMargin.
    currentRightLimit := docWidth - rightIndent.
    indentOffset  := 0.

    collectingText := inPre := inKbd := inBLOCKQUOTE := 0.
    ulLevel := inDL := inOL := inNoPrintingParagraph := 0.
    underline := strikeout := inSup := noBreak := center := rightAlign := 0.

    lineSpacing := 3.         "/ changed when changing font.
    self setFont:normalFont.
    normalFontHeight := fontAvgHeight.

    lastTextX := nil.
    x := leftIndent.
    y := topMargin + fontAscent.

    wSpace := currentFont widthOf:' '.

    currentColor := textFGColor.
    currentBGColor := nil.

    yNextLine := yText := nil. 
    maxHeightInRow := 0. 
    firstElementInRow := nil.
    previousIsEmpty := true. "/ false.
    liStack := OrderedCollection new.

    anchorElement := hBegin := nil.
    currentMap := currentForm :=  currentTable := nil.

    "Created: / 02-10-1996 / 13:43:56 / cg"
    "Modified: / 04-08-2011 / 18:53:03 / cg"
    "Modified: / 05-06-2018 / 07:30:35 / Claus Gittinger"
!

startImageDisplayProcess
    "handle two queues in the background; the first
     contains images which are to be loaded (i.e. which are
     contained in the current document) and have to be
     rendered for the device.
     The second contains those which are to be displayed.
     The displayList is always served first."

    lock critical:[
        imageDisplayProcess isNil ifTrue:[
            imageDisplayProcess :=
                [   
                    |destinationDevice players|

                    players := IdentityDictionary new.
                    destinationDevice := destination device.

                    [true] whileTrue:[
                        imagesToDisplay readSemaphore waitUncounted.
                        self displayImagesOn:destinationDevice usingPlayers:players.
                    ]
                ] newProcess.
            imageDisplayProcess priorityRange:((Processor userSchedulingPriority - 1) to:(Processor userSchedulingPriority)).
            imageDisplayProcess name:'image load & display [' , Processor activeProcessId printString , ']'.
            imageDisplayProcess resume.
        ]
    ].

    "Created: / 17-06-1996 / 20:53:01 / cg"
    "Modified: / 05-02-2011 / 10:39:42 / cg"
    "Modified (format): / 22-07-2018 / 22:28:23 / Claus Gittinger"
!

syncPoint
    "save my state in a sync point"

    |syncPoint|

    syncPoint := PainterState basicNew.

    syncPoint 
        currentElement:element
        haveSpace:haveSpace
        needSpace:needSpace
        yNextLine:yNextLine
        yText:yText
        xPosition:x  
        yPosition:y
        hBegin:hBegin.

    syncPoint 
        currentFont:currentFont
        currentColor:currentColor
        currentBGColor:currentBGColor
        currentUnderlineColor:currentUnderlineColor.

    syncPoint 
        currentLeftIndent:leftIndent
        currentRightIndent:rightIndent
        currentIndentOffset:indentOffset
        previousIsEmpty:previousIsEmpty.

    syncPoint 
        inBLOCKQUOTE:inBLOCKQUOTE 
        inCenter:center 
        inDL:inDL 
        inKbd:inKbd 
        inNoBreak:noBreak 
        inOL:inOL 
        inPre:inPre
        inNoPrintingParagraph:inNoPrintingParagraph.

    syncPoint 
        styleStack:styleStack copy.

    syncPoint 
        inRightAlign:rightAlign 
        inStrikeout:strikeout 
        inSup:inSup 
        inUnderline:underline
        ulLevel:ulLevel.

    syncPoint 
        currentForm:currentForm
        currentTable:currentTable
        currentRowIndex:currentRowIndex
        currentColIndex:currentColIndex.

    ^ syncPoint

    "Created: 9.8.1997 / 01:56:37 / cg"
    "Modified: 9.8.1997 / 02:18:19 / cg"
! !

!HTMLDocumentPainter methodsFor:'queries'!

anchorAt:aPoint
    "given a (click-) point, search for and return the corresponding
     anchorElement. Return nil, if there is none"

    anchors notNil ifTrue:[
        anchors do:[:a |
            |anchorBounds|

            (anchorBounds := a bounds) notNil ifTrue:[
                anchorBounds do:[:aRectangle |
                    (aRectangle containsPoint:aPoint) ifTrue:[
                        ^ a
                    ]
                ]
            ]
        ].
    ].
    ^ nil

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 4.3.1997 / 20:07:08 / cg"
!

elementAt:aPoint
    "given a (click-) point, search for and return the corresponding
     element. Return nil, if there is none"

    ^ self elementAt:aPoint type:nil
!

elementAt:aPoint type:typeOrNil
    "given a (click-) point, search for and return the corresponding
     element. Return nil, if there is none"

    |elementBounds|

    self elementsWithType:typeOrNil do:[:el |
        (elementBounds := el bounds) notNil ifTrue:[
            elementBounds size > 0 ifTrue:[
                (elementBounds contains:[:rect | (rect containsPoint:aPoint)]) ifTrue:[^ el].
            ] ifFalse:[    
                (elementBounds containsPoint:aPoint) ifTrue:[^ el]
            ]
        ].
    ].
    ^ nil
!

elementsDo:aBlock
    "enumerate the html elements"

    |el|

    el := document.
    [el notNil] whileTrue:[
        aBlock value:el.
        el := el next
    ].
    ^ nil
!

elementsWithType:typeOrNil do:aBlock
    "enumerate the html elements"

    |el|

    el := document.
    [el notNil] whileTrue:[
        (typeOrNil isNil or:[el type == typeOrNil]) ifTrue:[
            aBlock value:el.
        ].    
        el := el next
    ].
    ^ nil
!

height
    maxHeight isNil ifTrue:[^ 0].
    ^ maxHeight

    "Modified: 21.5.1996 / 15:24:02 / cg"
    "Created: 22.6.1996 / 16:49:01 / cg"
!

imageAt:aPoint
    "given a (click-) point, search for and return the corresponding
     imageElement. Return nil, if there is none"

    ^ self elementAt:aPoint type:#img
!

positionOfAnchor:aLocalAnchor
    |nm|

    anchors notNil ifTrue:[
        anchors do:[:a |
            |anchorBounds|

            nm := a nameString.
            nm notNil ifTrue:[
                nm = aLocalAnchor ifTrue:[
                    (anchorBounds := a bounds) notNil ifTrue:[
                        anchorBounds do:[:aRectangle |
                            ^ aRectangle origin
                        ]
                    ].
                    ('HTML [info]: boundLess anchor: ' , nm) infoPrintCR.
                    ^ nil
                ]
            ]
        ].
    ].
    ('HTML [info]: unknown anchor: ' , aLocalAnchor) infoPrintCR.
    ^ nil

    "Created: / 22.6.1996 / 16:49:01 / cg"
    "Modified: / 20.7.1998 / 15:54:21 / cg"
!

width
    maxWidth isNil ifTrue:[^ 0].
    ^ maxWidth

    "Modified: 21.5.1996 / 15:24:09 / cg"
    "Created: 22.6.1996 / 16:49:01 / cg"
! !

!HTMLDocumentPainter methodsFor:'style changes'!

currentStyle
    ^ TextStyle new 
        font:currentFont;
        color:currentColor;
        yourself
!

defaultStyle
    ^ TextStyle new font:normalFont color:textFGColor
!

getFontParameters
    fontAvgHeight := currentFont height.
    fontHeight := currentFont maxHeight.
    fontAscent := currentFont maxAscent.
    wSpace     := currentFont widthOf:' '.
    lineSpacing   := fontAvgHeight // 3.         "/ extra spacing.
!

normalStyle
    ^ TextStyle new font:normalFont color:textFGColor
!

popStyle
    |prevStyle|

    styleStack isEmptyOrNil ifTrue:[
        "/ should not happen
        prevStyle := self defaultStyle
    ] ifFalse:[
        prevStyle := styleStack removeLast.
    ].

    self setStyle:prevStyle
!

pushStyle
    styleStack isNil ifTrue:[
        styleStack := OrderedCollection new.
    ].
    styleStack addLast:(self currentStyle)
!

setBGColor:aColor
    aColor ~= currentBGColor ifTrue:[
        currentBGColor := aColor.
        needColorChange := true.
    ]

    "Created: / 17-09-2007 / 11:57:27 / cg"
!

setColor:aColor
    aColor ~= currentColor ifTrue:[
        currentColor := aColor.
        needColorChange := true.
    ]
!

setFont:aFont
    |f prevFontHeight|

    aFont ~~ currentFont ifTrue:[
        f := aFont onDevice:destination device.
        f ~~ currentFont ifTrue:[
            fontHeight isNil ifTrue:[ self getFontParameters ].
            prevFontHeight := fontHeight.

            currentFont := f.
            self getFontParameters.
            needFontChange := true.

            (prevFontHeight notNil 
            and:[fontHeight > prevFontHeight]) ifTrue:[
                "/ self halt.
"/                yNextLine isNil ifTrue:[yNextLine := 0].
"/                yNextLine := yNextLine max:(y + fontHeight + fontAscent).
            ].
        ].
    ]

    "Created: / 22-06-1996 / 16:49:01 / cg"
    "Modified: / 15-11-2016 / 11:00:53 / cg"
!

setStyle:aStyle
    self setFont:aStyle font.
    self setColor:aStyle color.
!

setUnderlineColor:aColor
    aColor ~= currentUnderlineColor ifTrue:[
        currentUnderlineColor := aColor.
    ]
! !

!HTMLDocumentPainter methodsFor:'widget-actions'!

buttonWidgetPressed:aWidgetElement
    |clickAction|

    clickAction := aWidgetElement parameterFor:#'ONCLICK'.
    clickAction isNil ifTrue:[
        ^ self
    ].

"/    "/ pass it to the script object - if any.
"/    "/ this one shall parse it based upon its language
"/    scriptObject isNil ifTrue:[
"/        "/ if there is no script, assume javaScript syntax,
"/        "/ and create an empty environment
"/        JavaScriptEnvironment notNil ifTrue:[
"/            scriptObject := JavaScriptEnvironment new.
"/            scriptObject _setupForWindow:destination.
"/        ].
"/    ].

    scriptObject notNil ifTrue:[
        scriptObject 
            _evaluateAction:clickAction 
                       with:(aWidgetElement parameterFor:#'NAME')
    ] ifFalse:[
        'HTML [info]: ONCLICK action but no script' infoPrintCR.
        destination scriptExecutionEnabled ifFalse:[
            destination infoDisplay:'Script execution is disabled (ONCLICK).'.
        ].
    ]

    "Created: 18.9.1996 / 16:02:59 / cg"
    "Modified: 26.5.1997 / 13:28:10 / cg"
!

formResetted:aFormElement from:aWidgetElement
    "reset forms contents to their original values"

    aFormElement widgets do:[:aWidgetElement |
        |valueString typeString widget done checked|

        widget := aWidgetElement view.
        widget notNil ifTrue:[
            valueString := aWidgetElement valueString.
            aWidgetElement type == #textarea ifTrue:[
                typeString := aWidgetElement type
            ] ifFalse:[
                typeString := aWidgetElement typeString.
                typeString notNil ifTrue:[
                    typeString := typeString asLowercase
                ]
            ].

            "/ not very object oriented ...
            done := false.

            typeString = 'label' ifTrue:[
                widget label:valueString.
                done := true.
            ].
            typeString = 'button' ifTrue:[
                widget label:valueString.
                done := true.
            ].
            typeString = 'submit' ifTrue:[
                valueString isNil ifTrue:[
                    widget label:typeString.
                ] ifFalse:[
                    widget label:valueString.
                ].
                done := true.
            ].
            typeString = 'reset' ifTrue:[
                valueString isNil ifTrue:[
                    widget label:typeString 
                ] ifFalse:[
                    widget label:valueString
                ].
                done := true.
            ].
            typeString = 'textarea' ifTrue:[
                widget contents:nil.
                done := true.
            ].
            typeString = 'checkbox' ifTrue:[
                checked := element hasParameterFor:#'CHECKED'.
                widget model value:checked.
                done := true.
            ].
            done ifFalse:[
                "/ must be a field
                valueString isNil ifTrue:[valueString := ''].
                widget model value:valueString
            ]
        ]     
    ].

    "Created: 18.9.1996 / 15:58:19 / cg"
    "Modified: 1.2.1997 / 20:55:54 / cg"
!

formSubmitted:aFormElement from:aWidgetElement
    |info hRef method encType attrs clickAction|

    aWidgetElement notNil ifTrue:[
        "/ submit-button may still have an onClick... (nil if submitted via RETURN)
        clickAction := aWidgetElement parameterFor:#'ONCLICK'.
        clickAction notNil ifTrue:[
            scriptObject notNil ifTrue:[
                scriptObject 
                    _evaluateAction:clickAction 
                               with:(aWidgetElement parameterFor:#'NAME')
            ] ifFalse:[
                destination scriptExecutionEnabled ifFalse:[
                    destination infoDisplay:'Script execution is disabled (ONCLICK).'.
                ].
            ]
        ].
    ].

    clickAction := aFormElement parameterFor:#'ONSUBMIT'.
    clickAction notNil ifTrue:[

        "/ pass it to the script object - if any.
        "/ this one shall parse it based upon its language

        scriptObject notNil ifTrue:[
            scriptObject 
                _evaluateAction:clickAction 
                           with:(aFormElement parameterFor:#'NAME')
        ] ifFalse:[
            destination scriptExecutionEnabled ifFalse:[
                destination infoDisplay:'Script execution is disabled (ONSUBMIT).'.
            ].
        ].
        ^ self.
    ].

    hRef := aFormElement actionString.
    method := aFormElement methodString.
    encType := aFormElement encTypeString.

    info := IdentityDictionary new.
    info at:#href put:hRef.
    info at:#method put:method.
    info at:#encType put:encType.

    attrs := Dictionary new.
    aFormElement values keysAndValuesDo:[:name :holder |
        attrs at:name put:holder value
    ].
    info at:#attributes put:attrs.

"/  'submit: ' print. info printCR.

    destination submitForm:info.

    "Created: 18.9.1996 / 15:55:51 / cg"
    "Modified: 26.5.1997 / 13:46:04 / cg"
!

mouseOverAnchor:anElement
    |mouseOverAction scriptEnvironment|

    mouseOverAction := anElement parameterFor:#'ONMOUSEOVER'.
    mouseOverAction isNil ifTrue:[
        ^ self
    ].

    destination scriptExecutionEnabled ifFalse:[
        destination infoDisplay:'Script execution is disabled (ONMOUSEOVER).'.
        ^ self
    ].

    "/ pass it to the script object - if any.
    "/ this one shall parse it based upon its language
    "/ (for now, only smalltalk is supported)

    (scriptEnvironment := scriptObject) isNil ifTrue:[
        "/ if there is no script, assume javaScript syntax in the ON-Action,
        "/ and create an empty environment
        JavaScriptEnvironment notNil ifTrue:[
            scriptEnvironment := JavaScriptEnvironment new.
            scriptEnvironment _beHTMLEnvironment.
            scriptEnvironment _setupForWindow:destination.
        ].
    ].

    scriptEnvironment notNil ifTrue:[
        scriptEnvironment
            _evaluateAction:mouseOverAction 
            with:(anElement parameterFor:#'NAME')
    ] ifFalse:[
        'HTML [info]: ONMOUSEOVER action but no script; assume javaScript' infoPrintCR
    ]

    "Created: / 18.5.1998 / 20:50:39 / cg"
    "Modified: / 18.5.1998 / 21:59:59 / cg"
! !

!HTMLDocumentPainter methodsFor:'widgets'!

createWidgetFor:element inForm:aForm
    |typeString widget sz nameString valueString holder theForm max
     checked rows cols clr|

    (widget := element view) notNil ifTrue:[
        ^ widget
    ].

    destination isView ifFalse:[^ nil].

    theForm := aForm.

    aForm isNil ifTrue:[
        'HTML [info]: input field not within form' infoPrintCR.
        ^ nil
    ].

    sz := element numericParameterFor:#'SIZE' default:nil.
    nameString := element nameString.
    valueString := element valueString.

    element type == #textarea ifTrue:[
        typeString := element type
    ] ifFalse:[
        typeString := element typeString.
        typeString notNil ifTrue:[
            typeString := typeString asLowercase
        ]
    ].

    typeString = 'label' ifTrue:[
        widget := Label label:valueString in:destination.
        widget font:normalFont.
        widget backgroundColor:(destination viewBackground).
    ].

    typeString = 'button' ifTrue:[
        widget := Button label:valueString in:destination.
        widget font:normalFont.
"/                    widget backgroundColor:(destination viewBackground).
        widget action:[self buttonWidgetPressed:element].
    ].

    typeString = 'submit' ifTrue:[
        valueString isNil ifTrue:[
            widget := Button label:typeString in:destination.
        ] ifFalse:[
            widget := Button label:valueString in:destination.
        ].
        widget font:normalFont.
"/                    widget backgroundColor:(destination viewBackground).
        widget action:[self formSubmitted:theForm from:element].
    ].

    typeString = 'reset' ifTrue:[
        valueString isNil ifTrue:[
            widget := Button label:typeString in:destination.
        ] ifFalse:[
            widget := Button label:valueString in:destination.
        ].
        widget font:normalFont.
"/                    widget backgroundColor:(destination viewBackground).
        widget action:[self formResetted:theForm from:element].
    ].

    typeString = 'textarea' ifTrue:[
        rows := element numericParameterFor:#'ROWS' default:5.
        cols := element numericParameterFor:#'COLS' default:40.
        widget := HVScrollableView for:EditTextView miniScrollerH:true in:destination.
        widget viewBackground:(destination viewBackground).
        widget scrollBar viewBackground:(destination viewBackground).
        widget horizontalScrollBar viewBackground:(destination viewBackground).
        (rows notNil and:[cols notNil]) ifTrue:[
            widget extent:(widget preferredExtentForLines:rows cols:cols)
        ].
        clr := EditField new backgroundColor.
        widget scrolledView backgroundColor:clr.
    ].

    typeString = 'checkbox' ifTrue:[
        checked := element hasParameterFor:#CHECKED.
        holder := checked asValue.
        aForm valueAt:nameString put:holder.

        widget := CheckToggle in:destination.
        widget model:holder.

        (element hasParameterFor:#ONCLICK)
        ifTrue:[
            widget pressAction:[self buttonWidgetPressed:element].
            widget releaseAction:[self buttonWidgetPressed:element].
        ].
    ].

    typeString = 'radio' ifTrue:[
        widget := RadioButton in:destination.
        (element hasParameterFor:#ONCLICK)
        ifTrue:[
            widget pressAction:[self buttonWidgetPressed:element].
            widget releaseAction:[self buttonWidgetPressed:element].
        ].
    ].

    typeString = 'hidden' ifTrue:[
"/        widget := View new.
    ].

    widget isNil ifTrue:[
        "/ inputField
"/                                    sz isNil ifTrue:[
"/                                        sz := 10
"/                                    ].
        valueString notNil ifTrue:[
            sz notNil ifTrue:[    
                valueString := valueString copyTo:(sz min:valueString size).
            ].
            holder := valueString asValue
        ] ifFalse:[
            valueString := ''.
        ].
        holder := valueString asValue.

        nameString notNil ifTrue:[
            aForm valueAt:nameString put:holder.
        ].

        widget := EditField in:destination.
        sz notNil ifTrue:[
            widget maxChars:sz.
            widget 
                preferredExtent:((normalFont widthOf:'O') * sz 
                                 @ 
                                 widget preferredHeight).
"/            widget width:(normalFont widthOf:'O') * sz.
        ].
"/        widget font:normalFont.
        widget font:codeFont.
        widget width:(widget preferredWidth).
        widget model:holder.
        widget immediateAccept:true.
        typeString = 'password' ifTrue:[
            widget bePassword
        ]
    ].

    aForm addWidget:element.

    widget notNil ifTrue:[
        (max := aForm maxHeight) isNil ifTrue:[
            max := 0
        ].
        aForm maxHeight:(max max:(widget height)).

        widget beInvisible.
        element view:widget.
        widgets isNil ifTrue:[
            widgets := OrderedCollection new.
        ].
        widgets add:element.
    ].

    ^ widget

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 22.10.1997 / 12:06:23 / cg"
!

destroyWidgets
    widgets notNil ifTrue:[
        widgets do:[:widgetElement | 
                        |v|

                        (applets notNil
                        and:[applets includes:widgetElement]) ifTrue:[
                             self destroyApplet:widgetElement
                        ] ifFalse:[
                            v := widgetElement view.
                            v notNil ifTrue:[widgetElement view:nil. v destroy]
                        ]
                   ].
        widgets := nil.
    ].

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 21.8.1997 / 16:04:45 / cg"
!

fixupForm:aForm
    |submit theForm
     widgets v inputFields anyInputFields anyOtherWidgets group
     rGroups rGroup|

    "/ fixup the form: if there is a single inputField,
    "/ let its return submitt.
    (widgets := aForm widgets) notNil ifTrue:[

        theForm := aForm.

        submit := nil.
        anyOtherWidgets := anyInputFields := false.
        inputFields := OrderedCollection new.
        group := EnterFieldGroup new.

        widgets do:[:aWidget |
            aWidget typeString = 'submit' ifTrue:[
                submit := aWidget
            ] ifFalse:[
                (v := aWidget view) notNil ifTrue:[
                    v isInputField ifTrue:[
                        group add:v.
                        anyInputFields := true.
                    ] ifFalse:[
                        aWidget typeString = 'radio' ifTrue:[
                            rGroups isNil ifTrue:[
                                rGroups := Dictionary new.
                            ].
                            rGroup := rGroups at:(aWidget nameString) ifAbsent:nil.
                            rGroup isNil ifTrue:[
                                rGroup := RadioButtonGroup new.
                                rGroups at:(aWidget nameString) put:rGroup
                            ].
                            rGroup add:v.
                            (aWidget hasParameterFor:#'CHECKED')
                            ifTrue:[
                                rGroup value:(rGroup size)
                            ].
                        ].
                        aWidget typeString ~= 'button' ifTrue:[
                            anyOtherWidgets := true
                        ]
                    ]
                ]
            ]
        ].

        submit isNil ifTrue:[
            anyOtherWidgets ifFalse:[
                anyInputFields ifTrue:[
                    group leaveAction:[self formSubmitted:theForm from:nil]   
                ]    
            ]
        ] ifFalse:[
            "/ mhmh - if there are only inputFields,
            "/ let the last trigger ....

            anyOtherWidgets ifFalse:[
                anyInputFields ifTrue:[
                    group leaveAction:[
                        submit view turnOn.
                        destination device flush.
                        self formSubmitted:theForm from:nil.
                        submit view turnOff.
                    ]
                ]
            ]
        ].

        "/ let user click into the field to get focus
        "/ (no automatic focus on the first field)
        group makeInactive.

        rGroups notNil ifTrue:[
            rGroups keysAndValuesDo:[:nm :group |
                aForm valueAt:nm put:group
            ]
        ]
    ]

    "Created: 22.6.1996 / 16:49:01 / cg"
    "Modified: 26.5.1997 / 13:16:01 / cg"
!

hideAllWidgets
    "hide any widget"

    |any|

    widgets notNil ifTrue:[
        any := false.

        widgets do:[:widget | 
            |v|

            v := widget view.
            v notNil ifTrue:[
                v realized ifTrue:[
                    v beInvisible.
                ]
            ]
        ].
        any ifTrue:[
            destination device flush.
        ]
    ]

    "Modified: 22.5.1996 / 17:53:37 / cg"
    "Created: 22.6.1996 / 16:49:01 / cg"
!

hideWidgets
    "hide any widget which became invisible"

    |any dH|

    widgets notNil ifTrue:[
        any := false.
        dH := destination height.

        widgets do:[:widget | 
            |bounds v vOrg org corner|

            bounds := widget bounds.
            bounds notNil ifTrue:[
                v := widget view.
                v notNil ifTrue:[
                    v realized ifTrue:[
                        vOrg := destination viewOrigin.
                        org := bounds origin - vOrg.
                        corner := bounds corner - vOrg.

                        (org y > dH
                        or:[corner y < 0]) ifTrue:[
                            any ifFalse:[
"/                                destination device flush.
"/                                destination sensor ignoreExposeEvents:true.
                                any := true.
                            ].
                            v beInvisible.
"/ 'u ' print. v class name printCR. 
                        ] ifFalse:[
                            v origin ~= org ifTrue:[
                                any ifFalse:[
"/                                    destination device flush.
"/                                    destination sensor ignoreExposeEvents:true.
                                    any := true.
                                ].
"/ 'mv ' print. v class name printCR. 
                                v origin:org.
                            ]
                        ].
                    ]
                ]
            ]
        ].
        any ifTrue:[
"/            destination device flush.
"/            destination sensor ignoreExposeEvents:false.
        ]
    ]

    "Created: 22.6.1996 / 16:49:02 / cg"
    "Modified: 8.8.1997 / 14:49:09 / cg"
!

prescanForm:aForm atIndex:startIndex
    "prescan a form, for its widgets max height.
     a kludge - we need the form elements' heights BEFORE
     formatting (since the text-elements have no origin knowledge,
     which could be backpatched (also, we needed a way to break
     MarkupText into multiple individual text items"

    |element type|

    startIndex+1 to:document size do:[:eachIndex|
        element := document at:eachIndex.
        type := element type.
        type == #'/form' ifTrue:[^ self].

        type == #form ifTrue:[
            'HTML [info]: unterminated form' infoPrintCR.
            ^ self
        ].
        type == #input ifTrue:[
            self createWidgetFor:element inForm:aForm
        ].
        type == #textarea ifTrue:[
            self createWidgetFor:element inForm:aForm
        ].
    ].

    "Created: 22.6.1996 / 16:49:02 / cg"
    "Modified: 10.1.1997 / 17:51:58 / cg"
!

showWidgets
    "show any widget which became visible"

    |dH|

    widgets notNil ifTrue:[
        dH := destination height.

        widgets do:[:widget | 
            |bounds v vOrg org corner|

            bounds := widget bounds.
            bounds notNil ifTrue:[
                v := widget view.
                v notNil ifTrue:[
                    v realized ifFalse:[
                        
"/                        widget widgetType == #textarea ifTrue:[
"/                            v viewBackground:(destination viewBackground).
"/                        ].

                        vOrg := destination viewOrigin.
                        org := bounds origin - vOrg.
                        corner := bounds corner - vOrg.

                        (corner y >= 0
                        and:[org y <= dH]) ifTrue:[
"/ 'm ' print. v class name printCR.                                
                            v origin:org.
                            v beVisible.
                            v invalidate.
                        ] ifFalse:[
"/ Transcript show:v class name; show:' at: '; show:org; showCR:' invisible'.                               
                        ].
                    ] ifTrue:[
"/ Transcript show:v class name; showCR:' already mapped'
                    ]
                ]
            ]
        ].
    ]

    "Created: 22.6.1996 / 16:49:02 / cg"
    "Modified: 6.8.1997 / 20:39:59 / cg"
! !

!HTMLDocumentPainter::PainterState class methodsFor:'documentation'!

documentation
"
    a document painters current state.
    This is a pure data holding class, providing no functionality.
"
! !

!HTMLDocumentPainter::PainterState methodsFor:'accessing-get'!

currentBGColor
    ^ currentBGColor
!

currentColIndex
    "return the value of the instance variable 'currentColIndex' (automatically generated)"

    ^ currentColIndex

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentColor
    "return the value of the instance variable 'currentColor' (automatically generated)"

    ^ currentColor

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentElement
    "return the value of the instance variable 'currentElement' (automatically generated)"

    ^ currentElement

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentFont
    "return the value of the instance variable 'currentFont' (automatically generated)"

    ^ currentFont

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentForm
    "return the value of the instance variable 'currentForm' (automatically generated)"

    ^ currentForm

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentIndentOffset
    "return the value of the instance variable 'currentIndentOffset' (automatically generated)"

    ^ currentIndentOffset

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentLeftIndent
    "return the value of the instance variable 'currentLeftIndent' (automatically generated)"

    ^ currentLeftIndent

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentRightIndent
    "return the value of the instance variable 'currentRightIndent' (automatically generated)"

    ^ currentRightIndent

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentRowIndex
    "return the value of the instance variable 'currentRowIndex' (automatically generated)"

    ^ currentRowIndex

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentTable
    "return the value of the instance variable 'currentTable' (automatically generated)"

    ^ currentTable

    "Created: 9.8.1997 / 01:52:16 / cg"
!

currentUnderlineColor
    ^ currentUnderlineColor
!

hBegin
    "return the value of the instance variable 'hBegin' (automatically generated)"

    ^ hBegin

    "Created: 9.8.1997 / 01:52:16 / cg"
!

haveSpace
    "return the value of the instance variable 'haveSpace' (automatically generated)"

    ^ haveSpace

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inBLOCKQUOTE
    "return the value of the instance variable 'inBLOCKQUOTE' (automatically generated)"

    ^ inBLOCKQUOTE

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inCenter
    "return the value of the instance variable 'inCenter' (automatically generated)"

    ^ inCenter

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inDL
    "return the value of the instance variable 'inDL' (automatically generated)"

    ^ inDL

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inKbd
    "return the value of the instance variable 'inKbd' (automatically generated)"

    ^ inKbd

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inNoBreak
    "return the value of the instance variable 'inNoBreak' (automatically generated)"

    ^ inNoBreak

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inNoPrintingParagraph
    "return the value of the instance variable 'inNoPrintingParagraph' (automatically generated)"

    ^ inNoPrintingParagraph
!

inOL
    "return the value of the instance variable 'inOL' (automatically generated)"

    ^ inOL

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inPre
    "return the value of the instance variable 'inPre' (automatically generated)"

    ^ inPre

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inRightAlign
    "return the value of the instance variable 'inRightAlign' (automatically generated)"

    ^ inRightAlign

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inStrikeout
    "return the value of the instance variable 'inStrikeout' (automatically generated)"

    ^ inStrikeout

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inSup
    "return the value of the instance variable 'inSup' (automatically generated)"

    ^ inSup

    "Created: 9.8.1997 / 01:52:16 / cg"
!

inUnderline
    "return the value of the instance variable 'inUnderline' (automatically generated)"

    ^ inUnderline

    "Created: 9.8.1997 / 01:52:16 / cg"
!

needSpace
    "return the value of the instance variable 'needSpace' (automatically generated)"

    ^ needSpace

    "Created: 9.8.1997 / 01:52:16 / cg"
!

previousIsEmpty
    "return the value of the instance variable 'previousIsEmpty' (automatically generated)"

    ^ previousIsEmpty

    "Created: 9.8.1997 / 01:52:16 / cg"
!

styleStack
    ^ styleStack.


!

ulLevel
    "return the value of the instance variable 'ulLevel' (automatically generated)"

    ^ ulLevel

    "Created: 9.8.1997 / 01:52:16 / cg"
!

xPosition
    "return the value of the instance variable 'xPosition' (automatically generated)"

    ^ xPosition

    "Created: 9.8.1997 / 01:52:15 / cg"
!

yNextLine
    "return the value of the instance variable 'yNextLine' (automatically generated)"

    ^ yNextLine

    "Created: 9.8.1997 / 01:52:16 / cg"
!

yPosition
    "return the value of the instance variable 'yPosition' (automatically generated)"

    ^ yPosition

    "Created: 9.8.1997 / 01:52:15 / cg"
!

yText
    "return the value of the instance variable 'yText' (automatically generated)"

    ^ yText

    "Created: 9.8.1997 / 01:52:16 / cg"
! !

!HTMLDocumentPainter::PainterState methodsFor:'accessing-set'!

currentElement:cE haveSpace:have needSpace:need yNextLine:yN yText:yT xPosition:x yPosition:y hBegin:hB
    currentElement := cE.
    haveSpace := have.
    needSpace := need.
    yNextLine := yN.
    yText := yT.
    xPosition := x.
    yPosition := y.
    hBegin := hB.

    "Created: 9.8.1997 / 02:17:08 / cg"
!

currentFont:f currentColor:cC currentBGColor:cBG currentUnderlineColor:cUC
    currentFont := f.
    currentColor := cC.
    currentBGColor := cBG.
    currentUnderlineColor := cUC.
!

currentForm:cF currentTable:cT currentRowIndex:cR currentColIndex:cC
    currentForm := cF.
    currentTable := cT.
    currentRowIndex := cR.
    currentColIndex := cC.

    "Created: 9.8.1997 / 02:15:18 / cg"
!

currentLeftIndent:cL currentRightIndent:cR currentIndentOffset:cIO previousIsEmpty:pE
    currentLeftIndent := cL.
    currentRightIndent := cR.
    currentIndentOffset := cIO.
    previousIsEmpty := pE.

    "Created: 9.8.1997 / 02:13:50 / cg"
!

inBLOCKQUOTE:inB inCenter:inC inDL:inD inKbd:inK inNoBreak:inN inOL:inO inPre:inP inNoPrintingParagraph:inNoPrint
    inBLOCKQUOTE := inB.
    inCenter := inC.
    inDL := inD.
    inKbd := inK.
    inNoBreak := inN.
    inOL := inO.
    inPre := inP.
    inNoPrintingParagraph := inNoPrint

    "Created: 9.8.1997 / 01:59:40 / cg"
!

inRightAlign:inR inStrikeout:inS inSup:inSu inUnderline:inU ulLevel:ul
    inRightAlign := inR.
    inStrikeout := inS.
    inSup := inSu.
    inUnderline := inU.
    ulLevel := ul.

    "Created: 9.8.1997 / 02:06:57 / cg"
!

styleStack:aCollection
    styleStack := aCollection.
! !

!HTMLDocumentPainter::TextStyle methodsFor:'accessing'!

color
    "return the value of the instance variable 'color' (automatically generated)"

    ^ color
!

color:something
    "set the value of the instance variable 'color' (automatically generated)"

    color := something.
!

font
    "return the value of the instance variable 'font' (automatically generated)"

    ^ font
!

font:something
    "set the value of the instance variable 'font' (automatically generated)"

    font := something.
! !

!HTMLDocumentPainter::TextStyle methodsFor:'accessing-color & font'!

font:fontArg color:colorArg 
    "set instance variables (automatically generated)"

    font := fontArg.
    color := colorArg.
! !

!HTMLDocumentPainter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentPainter.st,v 1.373 2018-09-01 15:39:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentPainter.st,v 1.373 2018-09-01 15:39:34 cg Exp $'
! !


HTMLDocumentPainter initialize!
