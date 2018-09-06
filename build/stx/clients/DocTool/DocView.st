"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"

ObjectView subclass:#DocumentView
	 instanceVariableNames:'currentX currentY baseDirectory fontBox cursorObject cursorPos
		fileBox leftIndent rightIndent pageWidth leftMargin rightMargin
		lineSpacing lastFont firstIndent first topMargin'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'Views-Document'
!

!DocumentView class methodsFor:'menu definition'!

initMenu:menu for:aView
    |resources|

    resources := self classResources.
    menu labels:(resources array:#(
				  'file' 
"
				  'edit' 
				  'font' 
				  'form' 
				  'extra'
"
				 )).

    menu at:1
	    putLabels:(resources array:#(
"
			'new' 
"
			'open' 
"
			'-' 
			'save' 
			'save as ...' 
			'-' 
			'print'
"
			'-' 
			'quit'))
	    selectors:#(
"
			doNew 
"
			doOpen  
"
			nil 
			doSave 
			doSaveAs 
			nil 
			doPrint
"
			nil 
			doQuit)
	     receiver:aView.

"
    menu at:2
	    putLabels:(resources array:#(
			'copy' 
			'cut' 
			'paste'))
	    selectors:#(copySelection deleteSelection pasteBuffer)
	     receiver:aView.

    menu at:3
	    putLabels:(resources array:#(
			'larger' 
			'spaller' 
			'-'
			'normal' 
			'bold' 
			'italic' 
			'bold italic' 
			'-'
			'font panel'))
	    selectors:#(largerFont
			smallerFont
			nil
			normalFont
			boldFont
			italicFont
			boldItalicFont
			nil
			showFontPanel)
	     receiver:aView.

    menu at:4
	    putLabels:(resources array:#(
			'show margins' 
			'-'
			'hide ruler'))
	    selectors:#(showMargins nil scaleOff)
	     receiver:aView
"
! !

!DocumentView class methodsFor:'startup'!

openOn:aFileName
    |top frame docView menu label|

    aFileName isNil ifTrue:[
	label := 'unnamed'
    ] ifFalse:[
	label := OperatingSystem baseNameOf:aFileName
    ].

    top := StandardSystemView
		 label:label
		  icon:(Form fromFile:'DocView.icn' resolution:100)
	     minExtent:(100 @ 100).

    menu := PullDownMenu in:top.

    frame := HVScrollableView for:self in:top.
    frame origin:[0 @ menu height]
	  extent:[top width @ (top height - menu height)].

    docView := frame scrolledView.
    self initMenu:menu for:docView.
    top open.

    aFileName notNil ifTrue:[
	docView fromFile:aFileName
    ]

    "DocumentView openOn:'../fileIn/bitmaps/test.fax'"
    "DocumentView openOn:'../doc/misc/language.doc'"
    "DocumentView openOn:'../doc/misc/gettingStarted.rtf'"
!

open
    "start a DocumentView on a new file"

    self startOn:nil

    "DocumentView opn"
! !

!DocumentView methodsFor:'accessing'!

fromFile:aFileName
    "take contents from a named file"

    |aStream isPicture newObject|

"
    self cursor:Cursor wait.
"
    self showBusyWhile:[

	isPicture := aFileName endsWith:'.fax'.
	isPicture := isPicture or:[aFileName endsWith:'.tif'].
	isPicture := isPicture or:[aFileName endsWith:'.tiff'].
	isPicture := isPicture or:[aFileName endsWith:'.gif'].
	isPicture := isPicture or:[aFileName endsWith:'.xbm'].
	isPicture := isPicture or:[aFileName endsWith:'.im8'].
	isPicture := isPicture or:[aFileName endsWith:'.icon'].
	isPicture := isPicture or:[aFileName endsWith:'.cursor'].
	isPicture := isPicture or:[aFileName endsWith:'.face'].
	isPicture := isPicture or:[aFileName endsWith:'.ico'].
	isPicture := isPicture or:[aFileName endsWith:'.ps'].
	isPicture ifTrue:[
	    self removeAll.
	    self scrollToTop.

	    newObject := DisplayPicture fromFile:aFileName.
	    newObject notNil ifTrue:[
		newObject origin:(0 @ 0).
		self addWithoutRedraw:newObject
	    ].
"
	    self extent:newObject extent.
	    self topView sizeToFit.
"
	    self contentsChanged.
	    baseDirectory := OperatingSystem directoryNameOf:aFileName.
	    shown ifTrue:[
		self redraw
	    ].
	] ifFalse:[
	    (aFileName endsWith:'.rtf') ifTrue:[
		self fromRTFFile:aFileName
	    ] ifFalse:[
		aStream := FileStream readonlyFileNamed:aFileName.
		aStream isNil ifTrue:[
		    self notify:('cannot open ' , aFileName)
		] ifFalse:[
		    self fromStream:aStream.
		    aStream close
		].
		sorted := true
	    ]
	].
    ].
    self cursor:Cursor normal.
!

fromRTFFile:aFileName
    "take contents from a named RTF-file"

    |aStream|

    aStream := FileStream readonlyFileNamed:aFileName.
    aStream isNil ifTrue:[
	self notify:('cannot open ' , aFileName)
    ] ifFalse:[
	self fromRTFStream:aStream.
	aStream close
    ].
    sorted := true.
!

fromRTFStream:aStream
    "take contents from an RTF-text-Stream"

    |reader|

    self cursor:Cursor wait.

    self removeAll.
    self scrollToTop.

    (aStream isKindOf:FileStream) ifTrue:[
	baseDirectory := aStream directoryName
    ].
    baseDirectory isNil ifTrue:[
	baseDirectory := '.'
    ].
    self initializeDefaults.
    reader := RTFReader new on:aStream.
    reader readRTFInto:self.
    sorted := true.
    self contentsChanged.
    shown ifTrue:[
	self redraw
    ].
    self cursor:Cursor normal.
!

fromText:aList
    "take contents from a Text-Object"

    self cursor:Cursor wait.
    self removeAll.
    self scrollToTop.

    self initializeDefaults.

    lastFont := Font family:'courier' face:'medium' style:'roman' size:12.
    currentY := lastFont height.
    leftMargin := device horizontalPixelPerMillimeter rounded.
    topMargin := device verticalPixelPerMillimeter rounded.

    aList do:[:line |
	line notNil ifTrue:[
	    self addString:line font:lastFont
	].
	self addNewline:lastFont
    ].
    sorted := true.
    self contentsChanged.
    self redraw.
    self cursor:Cursor normal.
!

fromStream:aStream
    "take contents from a Text-Stream"

    |line|

    self cursor:Cursor wait.
    self removeAll.
    self scrollToTop.
    self initializeDefaults.

    lastFont := Font family:'courier' face:'medium' style:'roman' size:12.
    currentY := lastFont height.
    leftMargin := device horizontalPixelPerMillimeter rounded.
    topMargin := device verticalPixelPerMillimeter rounded.

    [aStream atEnd] whileFalse:[
	line := aStream nextLine.
	line notNil ifTrue:[
	    self addString:line font:lastFont
	].
	self addNewline:lastFont
    ].
    sorted := true.
    self contentsChanged.
    shown ifTrue:[
	self redraw
    ].
    self cursor:Cursor normal.
!

fromRTFText:someText
    "take contents from an RTF-text"

    |reader|

    self cursor:Cursor wait.
    self removeAll.
    self scrollToTop.

    baseDirectory isNil ifTrue:[
	baseDirectory := '.'
    ].
    self initializeDefaults.
    reader := RTFReader new from:someText.
    reader readRTFInto:self.
    sorted := true.
    self cursor:Cursor normal.
!

selection
    (selection isKindOf:DisplayText) ifTrue:[
	^ selection text asString
    ].
    ^ nil
!

contents:someThing
    "take contents from a text object"

    |firstLine inStream|

    someThing isNil ifTrue:[
	self removeAll.
	^ self
    ].
    firstLine := someThing at:1.
    (firstLine startsWith:'{\rtf') ifTrue:[
	inStream := ReadStream on:someThing.
	self fromRTFStream:inStream.
	inStream close
    ] ifFalse:[
	self fromText:someThing
    ]
!

baseDirectory:aFileName
    baseDirectory := aFileName
! !

!DocumentView methodsFor:'adding elements'!

addString:aString
    ^ self addString:aString font:lastFont from:1
!

addString:aString font:aFont
    ^ self addString:aString font:aFont from:1
!

addString:aString font:aFont from:startIndex
    | index len next w nextX newObject f space rightEnd|

    f := aFont on:device.
    f isNil ifTrue:[
	self error:'no such font'.
	^ self
    ].

    index := startIndex.
    len := aString size.
    rightEnd := pageWidth - rightMargin.

    currentX == 0 ifTrue:[
	f == lastFont ifFalse:[
	    currentY := currentY + f ascent.
	    lastFont notNil ifTrue:[
		currentY := currentY - lastFont ascent
	    ]
	]
    ].

    w := f widthOf:aString from:index to:len.
    nextX := currentX + w.
    (nextX <= rightEnd) ifTrue:[
	"it fits - no need to break into words"
	newObject := DisplayText font:f.
	newObject text:(aString copyFrom:index to:len).
	newObject origin:((currentX + leftMargin) @ (currentY - f ascent)).
	self addWithoutRedraw:newObject.
	currentX := nextX.
	lastFont := f.
	^ self
    ].

    "must break into words"

    space := f widthOf:' '.

    [index <= len] whileTrue:[
	(aString at:index) isSeparator ifTrue:[
	    index := index + 1.
	    currentX := currentX + space
	] ifFalse:[
	    next := aString indexOfSeparatorStartingAt:index.
	    (next == 0) ifTrue:[
		^ self addWord:(aString copyFrom:index) font:f.
	    ].
	    self addWord:(aString copyFrom:index to:(next - 1)) font:f.
	    currentX := currentX + space.
	    index := next + 1.
	]
    ].
!

addWord:aString font:aFont
    |newObject nextX w f|

    f := aFont on:device.
    f isNil ifTrue:[
	self error:'no such font'.
	^ self
    ].
    currentX == 0 ifTrue:[
	f == lastFont ifFalse:[
	    currentY := currentY + f ascent.
	    lastFont notNil ifTrue:[
		currentY := currentY - lastFont ascent
	    ]
	]
    ].
    newObject := DisplayText font:f.
    newObject text:aString.
    w := f widthOf:aString.
    nextX := currentX + w.
    (nextX > (pageWidth - rightMargin)) ifTrue:[
	currentX := leftIndent.
	currentY := currentY + (f height).
	nextX := currentX + w
    ].
    newObject origin:((currentX + leftMargin) @ (currentY - f ascent)).
    self addWithoutRedraw:newObject.
    currentX := nextX.
    lastFont := f
!

addCenteredString:aString font:aFont
    |w nextX newObject f|

    f := aFont on:device.
    f isNil ifTrue:[
	self error:'no such font'.
	^ self
    ].
    currentX == 0 ifTrue:[
	f == lastFont ifFalse:[
	    currentY := currentY + f ascent.
	    lastFont notNil ifTrue:[
		currentY := currentY - lastFont ascent
	    ]
	]
    ].
    w := f widthOf:aString.
    nextX := (pageWidth - rightMargin - w) // 2.

    newObject := DisplayText font:f.
    newObject text:aString.
    newObject origin:((nextX + leftMargin) @ (currentY - f ascent)).
    self addWithoutRedraw:newObject.
    lastFont := f
!

addAttachment:aFileName
    |newObject name|

    name := aFileName.
    OperatingSystem isBSDlike ifFalse:[
	name size > 14 ifTrue:[
	    name := aFileName copyFrom:(name size - 14 + 1)
	]
    ].
    baseDirectory isNil ifTrue:[
	baseDirectory := '.'
    ].

    (name endsWith:'.tiff') ifTrue:[
	newObject := DisplayPicture fromFile:(baseDirectory , '/' , name).
    ].
    (name endsWith:'.vox') ifTrue:[
	newObject := DisplaySound forFile:(baseDirectory , '/' , name).
    ].
    newObject isNil ifTrue:[
	newObject := DisplayIcon forFile:(baseDirectory , '/' , name).
    ].

    newObject notNil ifTrue:[
	newObject origin:((currentX + leftMargin) @ currentY).
	self addWithoutRedraw:newObject.
	currentY := currentY + newObject frame height.
	currentX := leftIndent.
	^ self
    ]
!

addPicture:data type:type width:w height:h
    |newObject bitmap|

    type == #macpict ifTrue:[
	'cannot interpret macpict-coded pictures' errorPrintNL
    ].

    bitmap isNil ifTrue:[
	"
	 create an empty bitmap, with a frame.
	"
	bitmap := Form width:w height:h.
	bitmap paint:(Color colorId:0).
	bitmap fillRectangleX:0 y:0 width:w height:h.
	bitmap paint:(Color colorId:1).
	bitmap displayLineFromX:0 y:0 toX:(w-1) y:0.
	bitmap displayLineFromX:(w-1) y:0 toX:(w-1) y:(h-1).
	bitmap displayLineFromX:0 y:0 toX:0 y:(h-1).
	bitmap displayLineFromX:0 y:(h-1) toX:(w-1) y:(h-1).
    ].
    newObject := DisplayPicture from:bitmap.
    newObject notNil ifTrue:[
	newObject origin:((currentX + leftMargin) @ currentY).
	self addWithoutRedraw:newObject.
	currentY := currentY + newObject frame height.
	currentX := leftIndent.
    ]
!

addLineBreak
    lastFont notNil ifTrue:[
	lastFont := lastFont on:device.
	currentY := currentY + (lastFont height)
    ].
    currentX := leftIndent + firstIndent.
    firstIndent := 0
!

addLineBreak:aFont
    |f|

    f := aFont.
    f notNil ifTrue:[
	f := f on:device.
	currentY := currentY + (f height)
    ].
    currentX := leftIndent + firstIndent.
    firstIndent := 0
!

addNewline:aFont
    self addLineBreak:aFont
!

addNewline
    self addLineBreak
! !

!DocumentView methodsFor:'selection actions'!

performSelection:aSelector with:a1 with:a2 with:a3 with:a4
    "for every object in the selection, send a message to self
     with the object and anArgument as arguments
     - a helper for manipulation methods"

    |objectsToChange args|

    selection notNil ifTrue:[
	args := Array new:5.
	args at:1 put:a1.
	args at:2 put:a2.
	args at:3 put:a3.
	args at:4 put:a4.
	objectsToChange := selection.
	self unselect.
	self forEach:objectsToChange do:[:object |
	    args at:5 put:object.
	    self perform:aSelector withArguments:args
	].
	self select:objectsToChange
    ]
!

performSelection:aSelector 
    "for every object in the selection, send a message to self
     with the object as argument
     - a helper for manipulation methods"

    |objectsToChange|

    selection notNil ifTrue:[
	objectsToChange := selection.
	self unselect.
	self forEach:objectsToChange do:[:object |
	    self perform:aSelector with:object
	].
	self select:objectsToChange
    ]
!

performSelection:aSelector with:anArgument
    "for every object in the selection, send a message to self
     with the object and anArgument as arguments
     - a helper for manipulation methods"

    |objectsToChange|

    selection notNil ifTrue:[
	objectsToChange := selection.
	self unselect.
	self forEach:objectsToChange do:[:object |
	    self perform:aSelector with:object with:anArgument
	].
	self select:objectsToChange
    ]
! !

!DocumentView methodsFor:'layout control'!

leftIndent:x
    "set leftindent in twips"

    currentX := currentX - leftIndent.
    leftIndent := (x / 1440 * device horizontalPixelPerInch) rounded asInteger.
    currentX := currentX + leftIndent
!

pageWidth:x
    "set pageWidth in twips"

    pageWidth := (x / 1440 * device horizontalPixelPerInch) rounded asInteger
!

leftMargin:x
    "set leftMargin in twips"

    leftMargin := (x / 1440 * device horizontalPixelPerInch) rounded asInteger
!

rightMargin:x
    "set rightMargin in twips"

    rightMargin := (x / 1440 * device horizontalPixelPerInch) rounded asInteger
!

topMargin:x
    "set topMargin in twips"

    topMargin := (x / 1440 * device horizontalPixelPerInch) rounded asInteger
!

bottomMargin:x
    "set bottomMargin in twips"

    bottomMargin := (x / 1440 * device horizontalPixelPerInch) rounded asInteger
!

rightIndent:x
    "set rightIndent in twips"

    rightIndent := (x / 1440 * device horizontalPixelPerInch) rounded asInteger
!

leftIndent
    "return current left indent in twips"

    ^ (leftIndent * 1440 / device horizontalPixelPerInch) rounded asInteger 
!

firstIndent:x
    "set firstindent in twips"

    firstIndent := (x / 1440 * device horizontalPixelPerInch) rounded asInteger
!

lineSpacing:x
    "set linespacing in points"

    lineSpacing := x
!

currentX
    "return current X position in twips"

    ^ (currentX * 1440 / device horizontalPixelPerInch) rounded asInteger 
!

currentX:x
    "set current X position in twips"

    currentX := (x / 1440 * device horizontalPixelPerInch) rounded asInteger.
! !

!DocumentView methodsFor:'misc queries'!

heightOfContents
    "answer the height of the document in pixels
     in this case, the max y extent is returned"

    |maxY|

    maxY := 0.
    contents do:[:something |
	(something frame bottom > maxY) ifTrue:[
	    maxY := something frame bottom
	]
    ].
    ^ maxY
!

widthOfContents
    "answer the height of the document in pixels
     in this case, the max y extent is returned"

    |maxX|

    maxX := 0.
    contents do:[:something |
	(something frame right > maxX) ifTrue:[
	    maxX := something frame right
	]
    ].
    ^ maxX
!

rectangleForScroll
    "redefined since it takes longer to find the area than to
     scroll if we have many small objects"

    ^ Rectangle left:margin right:(width - margin)
		 top:margin bottom:(height - margin)
! !

!DocumentView methodsFor:'scrolling'!

scrollDown
    "change origin to scroll down one line
     - where line is defined as a 10-point height line"

    self scrollDown:(font height)
!

scrollUp
    "change origin to scroll up a line"

    self scrollUp:(font height)
! !

!DocumentView methodsFor:'events'!

clickOnObject:aPoint
    |anObject|

    anObject := self findObjectAt:aPoint.
    anObject notNil ifTrue:[
	anObject doubleClick
    ]
! !

!DocumentView methodsFor:'user interaction'!

fontSelection
    ^ self
!

copySelection
    ^ self
!

cutSelection
    ^ self
!

pasteSelection
    ^ self
!

doOpen
    baseDirectory isNil ifTrue:[
	baseDirectory := '.'
    ].
    fileBox isNil ifTrue:[
	fileBox := FileSelectionBox
			title:(resources string:'get file')
			"pattern:'*.draw'"
			okText:(resources string:'ok')
			abortText:(resources string:'abort')
			action:[]
    ].
    fileBox title:(resources string:'get file').
    fileBox action:[:fileName | self fromFile:fileName].
    fileBox directory:baseDirectory.
    fileBox showAtPointer
!

save
    ^ self
!

doQuit
    fileBox notNil ifTrue:[
	fileBox destroy.
	fileBox := nil
    ].
    self topView destroy

!

print
    ^ self
!

largerFont
    selection notNil ifTrue:[
	self performSelection:#largerFont:
    ] ifFalse:[
	"createFontSize := createFontSize + 1  "
    ]
!

smallerFont
    selection notNil ifTrue:[
	self performSelection:#smallerFont:
    ] ifFalse:[
	"createFontSize := createFontSize - 1  "
    ]
!

normalFont
    selection notNil ifTrue:[
	self performSelection:#normalFont:
    ] ifFalse:[
"
	createFontFace := 'medium'.
	createFontStyle := 'normal'
"
    ]
!

boldFont
    selection notNil ifTrue:[
	self performSelection:#boldFont:
    ] ifFalse:[
"
	createFontFace := 'bold'.
	createFontStyle := 'normal'
"
    ]
!

italicFont
    selection notNil ifTrue:[
	self performSelection:#italicFont:
    ] ifFalse:[
"
	createFontFace := 'normal'.
	createFontStyle := 'italic'
"
    ]
!

boldItalicFont
    selection notNil ifTrue:[
	self performSelection:#boldItalicFont:
    ] ifFalse:[
"
	createFontFace := 'bold'.
	createFontStyle := 'italic'
"
    ]
!

showFontPanel
    |action fontPanel|

    fontPanel isNil ifTrue:[
	fontPanel := FontPanel new 
    ].

    selection notNil ifTrue:[
	action := [:family :face :style :size |
		       self performSelection:#changeFontFamily:face:style:size:of:
					with:family
					with:face
					with:style
					with:size
		  ]
    ] ifFalse:[
 "
       action := [:family :face :style :size |
		       createFontFamily := family.
		       createFontFace := face.
		       createFontStyle := style.
		       createFontSize := size
		  ]
"
    ].

    fontPanel action:action.
    fontPanel showAtPointer
! !

!DocumentView methodsFor:'initialization'!

initializeMiddleButtonMenu
"
    self middleButtonMenu:(
	     PopUpMenu
		 labels:(resources array:
			  #(
			     'copy'
			     'cut'
			     'paste'
			     '-'
			     'font'
			     '-'
			     'save'
			     'print'
			    )
			)
	      selectors:#(copySelection
			  cut
			  paste
			  nil
			  fontSelect
			  nil
			  save
			  print)
	       receiver:self
		    for:self)
"
!

initializeDefaults
    self setupDefaults.
    lastFont := font. 
"
Font family:'courier' face:'medium' style:'roman' size:10.
"
lastFont := nil.

    currentX := 0.
    currentY := topMargin "(lastFont on:device) ascent".
!

setupDefaults
    leftIndent := 0.
    rightIndent := 0.
    firstIndent := 0.
    leftMargin := 0.
    rightMargin := 0.
    topMargin := 0.
    pageWidth := width.
    first := true
!

realize
    super realize.
    doublePressAction := [:p | self clickOnObject:p].
    pressAction := [:p | self startSelectOrMove:p].
    shiftPressAction := [:p | self startSelectMoreOrMove:p].
"
    motionAction := [:p | self doObjectMove:p].
    releaseAction := [self endObjectMove]
"
    ^ self
! !
