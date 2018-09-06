"{ Package: 'stx:clients/DocTool' }"

DocumentReader subclass:#RTFReader
	instanceVariableNames:'fontTable destination controlWord param fontNumber colorNumber
		buffer contents stateStack pageNumber footNoteNumber tabWidth
		headerY footerY codeSet imgWidth imgHeight imgType stylesheets
		currentStylesheet'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DocTool'
!

!RTFReader methodsFor:'file i/o'!

processRTFLine:lineString
    "take contents from an RTF-text-Stream"

    |special escaped inControl char charIndex nChars inHex hexVal|

    destination isNil ifTrue:[
	special := lineString includesAny:'\{}'.
	" special := lineString includesAny:'\{};'."
	special ifFalse:[
	    self handleBuffer.
	    buffer := lineString.
	    ^ self
	]
    ].

    inControl := false.
    inHex := 0.
    charIndex := 1.
    escaped := false.

    nChars := lineString size.
    [charIndex <= nChars] whileTrue:[
	char := lineString at:charIndex.
	(char == ${) ifTrue:[
	    escaped ifTrue:[
		buffer := buffer copyWith:char.
		escaped := false
	    ] ifFalse:[
		inControl ifTrue:[
		    self handleControl.
		    inControl := false
		] ifFalse:[
		    self handleBuffer
		].
		self pushState
	    ]
	] ifFalse:[ (char == $}) ifTrue:[
	    escaped ifTrue:[
		buffer := buffer copyWith:char.
		escaped := false
	    ] ifFalse:[
		inControl ifTrue:[
		    self handleControl.
		    inControl := false
		] ifFalse:[
		    self handleBuffer
		].
		self popState
	    ]
	] ifFalse:[ (char == $\) ifTrue:[
	    escaped ifTrue:[
		buffer := buffer copyWith:char.
		escaped := false
	    ] ifFalse:[
		inControl ifTrue:[
		    self handleControl.
		    inControl := false
		].
		escaped := true
	    ]
	] ifFalse:[
	    escaped ifTrue:[
		escaped := false.
		(char == $') ifTrue:[
		    inHex := 1
		] ifFalse:[
		    self handleBuffer.
		    inControl := true.
		    controlWord := char asString.
		    param := nil
		] 
	    ] ifFalse:[
		inControl ifTrue:[
		    (char isSeparator) ifTrue:[
			self handleControl.
			inControl := false
		    ] ifFalse:[
			('.,;' includes:char) ifTrue:[
			    self handleControl.
			    inControl := false.
			    charIndex := charIndex - 1
			] ifFalse:[
			    char isDigit ifTrue:[
				param isNil ifTrue:[
				    param := 0
				].
				param := param * 10 + char digitValue
			    ] ifFalse:[
				controlWord := controlWord copyWith:char
			    ]
			]
		    ]
		] ifFalse:[
		    (inHex == 0) ifTrue:[
			(destination notNil and:[char == $;]) ifTrue:[
			    self handleBuffer.
			    buffer := ''
			] ifFalse:[
			    buffer := buffer copyWith:char
			]
		    ] ifFalse:[
			(inHex == 1) ifTrue:[
			    inHex := 2.
			    hexVal := char digitValue
			] ifFalse:[
			    inHex := 0.
			    hexVal := hexVal * 16 + char digitValue.
			    buffer := buffer copyWith:(Character value:hexVal)
			]
		    ]
		]
	    ]
	]]].
	charIndex := charIndex + 1
    ].
"
    inGroup ifTrue:[
	self handleDestParameter.
	inControl := false.
	inGroup := false
    ].
"
    inControl ifTrue:[
	self handleControl
    ].
    escaped ifTrue:[
	self handleBuffer.
	destination isNil ifTrue:[
	    fontChange ifTrue:[
		self getFont
	    ].
	    master addLineBreak:currentFont
	].
	escaped := false
    ]
!

readRTFInto:someone
    "take contents from an RTF-text-Stream"

    |line|

    master := someone.
    self setupDefaults.

    buffer := ''.
    destination := nil.

    [inStream atEnd] whileFalse:[
	(inStream isKindOf:ExternalStream) ifTrue:[
	    line := inStream nextLine
	] ifFalse:[
	    line := inStream next
	].
	((line size == 0) or:[line isBlank]) ifFalse:[
	    self processRTFLine:line
	]
    ].
    self handleBuffer
! !

!RTFReader methodsFor:'private'!

addToNextGraphic:text
    master addAttachment:text.
" "
    'nextGraphic: <' errorPrint. text errorPrint. '>' errorPrintNewline.
" "
!

addToPicture:text
    imgType == #macpict ifTrue:[
	master addPicture:text type:imgType width:imgWidth height:imgHeight.
	^ self.
    ].
    'data for picture ignored:' errorPrint. text errorPrintNewline.
!

doCommand:aCommand with:aParam
    |sel|

    sel := ('x' , aCommand).
    sel knownAsSymbol ifTrue:[
	sel := sel asSymbol.
	(self respondsTo:sel) ifTrue:[
	    param := aParam.
	    controlWord := aCommand.
	    self perform:sel.
	    ^ self
	]
    ].

    "extra kludge - smalltalk syntax does not allow #'xfi-' as selector"
    (controlWord = 'fi-') ifTrue:[
	firstIndent := param negated.
	master firstIndent:firstIndent.
	^ self
    ].
    'unknown: ' errorPrint. controlWord errorPrint. ' ' errorPrint. param errorPrintNewline
!

handleBuffer
    |c nc nb index endIndex|

    (buffer size == 0) ifTrue:[^ self].

    destination isNil ifTrue:[
	fontChange ifTrue:[
	    self getFont
	].
	needBreak ifTrue:[
	    master addLineBreak.
	    needBreak := false
	].
	index := 1.
	endIndex := buffer size.
	[index <= endIndex] whileTrue:[
	    c := buffer at:index.                       
	    c asciiValue > 127 ifTrue:[
		nc := self mapCharacter:c asciiValue.
		nc isInteger ifTrue:[
		    buffer at:index put:(Character value:nc)
		] ifFalse:[
		    endIndex := buffer size + nc size - 1.
		    nb := String new:endIndex.
		    nb replaceFrom:1 to:(index - 1) with:buffer.
		    nb replaceFrom:(index + nc size) to:endIndex with:buffer startingAt:(index + 1).
		    nb replaceFrom:index to:(index + nc size - 1) with:nc.
		    index := index + nc size - 1.
		    buffer := nb
		]
	    ].
	    index := index + 1.
	].

	centered ifTrue:[
	    master addCenteredString:buffer font:currentFont
	] ifFalse:[
	    "
	     handle tabs
	    "
	    index := buffer indexOf:Character tab.
	    [index ~~ 0] whileTrue:[
		master addString:(buffer copyTo:index - 1).
self halt.
		self xtab.
		buffer := buffer copyFrom:index + 1.
		index := buffer indexOf:Character tab.
	    ].
	    master addString:buffer font:currentFont
	].
	buffer := ''.
	^ self
    ].
    (destination == #fonttbl) ifTrue:[
	fontNumber isNil ifTrue:[
	    'oops no fontNumber' errorPrintNewline
	] ifFalse:[
	    "some translation needed sometimes"
	    (buffer = 'Times-Roman') ifTrue:[
		buffer := 'Times'
	    ] ifFalse:[
		(buffer = 'Tms Rmn') ifTrue:[
		    buffer := 'Times'
		]
	    ].
	    fontTable isNil ifTrue:[
		fontTable := VariableArray new:0
	    ].
	    (fontNumber > (fontTable size)) ifTrue:[
		fontTable grow:fontNumber
	    ].
	    fontTable at:fontNumber put:buffer
	].
	buffer := ''.
	^ self
    ].
    (destination == #colormap) ifTrue:[
	buffer := ''.
	^ self
    ].
    (destination == #attachment) ifTrue:[
	master addAttachment:buffer withoutSpaces.
	buffer := ''.
	^ self
    ].
    (destination == #picture) ifTrue:[
	self addToPicture:buffer withoutSpaces.
	buffer := ''.
	^ self
    ].
    (destination == #nextGraphic) ifTrue:[
	self addToNextGraphic:buffer withoutSpaces.
	buffer := ''.
	^ self
    ].
    (destination == #stylesheet) ifTrue:[
	buffer := ''.
	^ self
    ].
    (destination == #info) ifTrue:[
	buffer := ''.
	^ self
    ].
    ('text for unknown destination: ' , destination , ' ignored') errorPrintNewline.
    buffer := ''
!

handleColorTable
    |r g b|

    (controlWord = 'red') ifTrue:[
	r := param.
	^ self
    ].
    (controlWord = 'green') ifTrue:[
	g := param.
	^ self
    ].
    (controlWord = 'blue') ifTrue:[
	b := param.
	^ self
    ].

    ^ self
!

handleControl
    |new first sel|

    (destination == #fonttbl) ifTrue:[
	self handleFontTable.
	^ self
    ].
    (destination == #colortbl) ifTrue:[
	self handleColorTable.
	^ self
    ].
    (destination == #info) ifTrue:[
	self handleInfo.
	^ self
    ].
    (destination == #picture) ifTrue:[
	self handlePicture.
	^ self
    ].
    (destination == #nextGraphic) ifTrue:[
	self handleNextGraphic.
	^ self
    ].
    (destination == #stylesheet) ifTrue:[
	self handleStylesheet.
	^ self
    ].
    (destination notNil) ifTrue:[
"
	'control: ' print. controlWord print. 
	' in dest: ' print. destination print. ' ignored' printNewline.
"
	^ self
    ].

    self doCommand:controlWord with:param
!

handleFontTable
    |fontFamilyGroup|

    (controlWord = 'f') ifTrue:[
	fontNumber := param + 1.
	^ self
    ].
    (controlWord startsWith:'f') ifTrue:[
	"\fxxx"
	fontFamilyGroup := controlWord copyFrom:2.
"
	'familygroup ' print. fontFamilyGroup printNewline.
"
	^ self
    ].
    ^ self
!

handleInfo
    controlWord = 'title' ifTrue:[
	^ self
    ].
    controlWord = 'author' ifTrue:[
	^ self
    ].
    controlWord = 'subject' ifTrue:[
	^ self
    ].
    controlWord errorPrint. ' for info ignored' errorPrintNewline.
    ^ self
!

handleNextGraphic
    controlWord = 'width' ifTrue:[
	imgWidth := param.
	^ self
    ].
    controlWord = 'height' ifTrue:[
	imgHeight := param.
	^ self
    ].
    controlWord errorPrint. ' for nextGraphic ignored' errorPrintNewline.
!

handlePicture
    controlWord = 'picw' ifTrue:[
	imgWidth := param.
	^ self
    ].
    controlWord = 'pich' ifTrue:[
	imgHeight := param.
	^ self
    ].
    controlWord = 'macpict' ifTrue:[
	imgType := #macpict.
	^ self
    ].
    controlWord errorPrint. ' for picture ignored' errorPrintNewline.
    ^ self
!

handleStylesheet
    |sel|

    (controlWord = 's') ifTrue:[
	currentStylesheet := param + 1.
	stylesheets isNil ifTrue:[
	    stylesheets := VariableArray new:currentStylesheet
	] ifFalse:[
	    stylesheets grow:currentStylesheet
	].
	stylesheets at:currentStylesheet put:(OrderedCollection new).
	^ self
    ].

    currentStylesheet isNil ifTrue:[
	controlWord errorPrint. ' in undef stylesheet ignored' errorPrintNewline.
	^ self.
    ].

    (stylesheets at:currentStylesheet) add:(Array with:controlWord with:param).
!

mapCharacter:ascii
    "map different codesets"

    (codeSet == #ansi) ifTrue:[
	ascii == 8r252 ifTrue:[ ^ $" asciiValue ].   "actually left dquote"
	ascii == 8r272 ifTrue:[ ^ $" asciiValue ].   "actually right dquote"
	ascii == 8r343 ifTrue:[ ^ 16rA9 ].   "(c)"
	ascii == 8r324 ifTrue:[ ^ 'TM' ].    "tm"
	ascii == 8r302 ifTrue:[ ^ 16r60 ].   "single back quote"
	^ ascii
    ].
    (codeSet == #pc) ifTrue:[
	(ascii == 16r94) ifTrue:[ ^ 16rf6 ]. "oe"
	(ascii == 16r81) ifTrue:[ ^ 16rfc ]. "ue"
	(ascii == 16r94) ifTrue:[ ^ 16re4 ]. "ae"
	(ascii == 16re1) ifTrue:[ ^ 16rdf ]. "ss"
	^ ascii
    ].
    (codeSet == #next) ifTrue:[
	(ascii == 16rc2) ifTrue:[ ^ 16r27 ]. "single quote"
	(ascii == 16rc1) ifTrue:[ ^ 16r60 ]. "back quote"
	^ ascii
    ].
    ^ ascii
!

paragraphStart
    needBreak ifTrue:[
	master addLineBreak.
	needBreak := true
    ].
    (firstIndent ~~ 0) ifTrue:[
	master firstIndent:firstIndent
    ]
!

popState
    |sav|

    sav := stateStack first.
    sav isNil ifTrue:[
	'oops - pop' errorPrintNewline.
	^ self
    ].
    stateStack removeFirst.
    sav := sav value.
    destination := sav at:1.
    currentFamily := sav at:2.
    fontChange := true
"
    currentFont := sav at:3
"

"
    'popped:' print. destination printNewline
"
!

pushState
    |sav|

"
    'push:' print. destination printNewline.
"
    sav := Array new:3.
    sav at:1 put:destination.
    sav at:2 put:currentFamily.
    sav at:3 put:currentFont.
    stateStack isNil ifTrue:[
	stateStack := LinkedList new
    ].
    stateStack addFirst:(ValueLink new value:sav)
!

setParagraphDefaults
    tabPositions := nil.
    (leftIndent ~~ 0) ifTrue:[
	leftIndent := 0.
	master leftIndent:leftIndent
    ].
    (rightIndent ~~ 0) ifTrue:[
	rightIndent := 0.
	master rightIndent:rightIndent
    ].
    (firstIndent ~~ 0) ifTrue:[
	firstIndent := 0.
	master firstIndent:firstIndent
    ].
    lineSpacing := 12.
    centered := false
!

setupDefaults
    super setupDefaults.

    fontTable := nil.

    headerY := 720.
    footerY := 720.

    "
     tell master my settings
    "
    master leftMargin:marginLeft.
    master rightMargin:marginRight.
    master topMargin:marginTop.
    master bottomMargin:marginBottom.
! !

!RTFReader methodsFor:'rtf-commands'!

xNeXTGraphic
    destination := #nextGraphic.
!

xansi
    codeSet := #ansi.
!

xattachment
    destination := #attachment.
!

xauthor
    ^ self
!

xb
    |newFace|

    (param == 0) ifTrue:[
	newFace := 'medium'
    ] ifFalse:[
	newFace := 'bold'
    ].
    (currentFace ~= newFace) ifTrue:[
	fontChange := true.
	currentFace := newFace
    ]
!

xbrdrth
!

xbrdrw
!

xcell 
!

xcellx 
!

xcf
!

xclbrdrb
!

xclbrdrt
!

xcolortbl
    destination := #colortbl
!

xcols
    nCols := param. 
!

xcomment
    destination := #comment.
!

xcreatim
!

xdeff
!

xdeflang
!

xdeftab
    tabWidth := param
!

xdn
!

xedmins
!

xemdash
    nCols := param.
!

xendash
!

xendnhere
!

xevtim
!

xf
    |new|

	    (fontTable isNil or:[param isNil or:[param >= fontTable size]]) ifTrue:[
		'oops invalid font selected' errorPrintNewline.
		^ self
	    ].
	    param := param + 1.
	    new := fontTable at:param.
	    (new ~~ currentFamily) ifTrue:[
		fontChange := true.
		currentFamily := new
	    ].
!

xfi
    firstIndent := param.
    master firstIndent:firstIndent.
!

xfonttbl
    destination := #fonttbl.
!

xfooter
    destination := #footer.
!

xfooterl
    destination := #footerl.
!

xfooterr
    destination := #footerr.
!

xfootery
    footerY := param. 
!

xfootnote
    destination := #footnote.
!

xfs
    |new|
	    (param == 0) ifTrue:[
		new := 10
	    ] ifFalse:[
		new := param // 2
	    ].
	    (currentSize ~= new) ifTrue:[
		fontChange := true.
		currentSize := new
	    ].
!

xftnbj
!

xftncn
    destination := #ftnsepc.
!

xftnsep
    destination := #ftnsep.
!

xftnsepc
    destination := #ftnsepc.
!

xftnstart
    footNoteNumber := param. 
!

xgray
!

xgutter
!

xheader
    destination := #header.
!

xheaderf
    destination := #headerf.
!

xheaderl
    destination := #headerl.
!

xheaderr
    destination := #headerr.
!

xheadery
    headerY := param. 
!

xhr
!

xi
    |newStyle|

    (param == 0) ifTrue:[
	newStyle := 'roman'
    ] ifFalse:[
	newStyle := 'oblique'
    ].
    (currentStyle ~= newStyle) ifTrue:[
	fontChange := true.
	currentStyle := newStyle
    ]
!

xinfo
    destination := #info.
!

xintbl
!

xkeep
!

xlang
!

xli
    leftIndent := param.
	    master leftIndent:leftIndent.
!

xlinemod
!

xlinex
!

xlotusoutlinelevel
!

xmac
    codeSet := #mac.
!

xmargb
    marginBottom := param. 
    master bottomMargin:marginBottom.
!

xmargl
    marginLeft := param.
    master leftMargin:marginLeft.
!

xmargr
    marginRight := param. 
    master rightMargin:marginRight.
!

xmargt
    marginTop := param. 
    master topMargin:marginTop.
!

xmin
!

xmo
!

xnextcset
    codeSet := #next.
!

xnofchars
!

xnofpages
!

xnofwords
!

xoperator
!

xpaperh
    pageHeight := param. 
!

xpaperw
    pageWidth := param. 
    master pageWidth:pageWidth.
!

xpar
    (firstIndent ~~ 0) ifTrue:[
	master firstIndent:firstIndent
    ].
    needBreak ifTrue:[
	master addLineBreak
    ].
    needBreak := true.
!

xpard
    self setParagraphDefaults.
!

xpc
    codeSet := #pc.
!

xpgnstart
    pageNumber := param.
!

xpict
    imgType := nil.
    destination := #picture.
!

xplain
    (currentFace = 'bold') ifTrue:[
	fontChange := true.
	currentFace := 'medium'
    ].
    (currentStyle = 'oblique') ifTrue:[
	fontChange := true.
	currentStyle := 'roman'
    ].
    (currentSize ~= 12) ifTrue:[
	fontChange := true.
	currentSize := 12
    ].
    underline := false.
!

xqc
    centered := true.
!

xqj
!

xql
!

xri
    rightIndent := param.
    master rightIndent:rightIndent.
!

xrow
!

xrtf
!

xs
    |sheet|

"
    'stylesheet ' errorPrint. param errorPrint. ' use' errorPrintNewline.
"
    sheet := stylesheets at:(param + 1) 
		   ifAbsent:[
			     'bad stylesheet use: ' errorPrint. param errorPrintNewline.
			     ^ self
			    ].
    sheet isNil ifTrue:[^ self].
    sheet do:[:aCommandPair |
"
	('stylesheet: ' , (aCommandPair at:1) , ' ' , (aCommandPair at:2) printString) printNewline.
"
	self doCommand:(aCommandPair at:1) with:(aCommandPair at:2)
    ].
!

xsbknone
!

xscaps
!

xsectd
!

xsl
    (param == 0) ifTrue:[
	lineSpacing := 12
    ] ifFalse:[
	lineSpacing := param
    ].
!

xsnext
!

xstrike
!

xstylesheet
    destination := #stylesheet.
!

xtab
    needBreak ifTrue:[
	master addLineBreak
    ].
    needBreak := false.
    master currentX:(self nextTabAfter:(master currentX)).
!

xtitle
!

xtqc
    "centering tab"
!

xtqr
    "right-adjusting tab"
!

xtrgaph
!

xtrgraph
!

xtrleft
!

xtrowd
!

xtrqc
    "centered row of a table"
!

xtrql
    "left-adjusted row of a table"
!

xtrqr
    "right-adjusted row of a table"
!

xtx
    tabPositions isNil ifTrue:[
	tabPositions := OrderedCollection new
    ].
    tabPositions add:param.
!

xu
    (param == 0) ifTrue:[
	underline := false
    ] ifFalse:[
	underline := true
    ].
!

xul
    (param == 0) ifTrue:[
	underline := false
    ] ifFalse:[
	underline := true
    ].
!

xuldb
!

xulnone
    underline := false
!

xup
!

xvern
!

xversion
!

xwidowctrl
!

xyr
! !

