"{ Encoding: utf8 }"

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
"{ Package: 'stx:clients/DirView' }"

"{ NameSpace: Demos }"

ObjectView subclass:#DirectoryView
	instanceVariableNames:'currentDirectoryName currentDirectory fileAction dirAction
		systemIconDefs userIconDefs localIconDefs systemActionDefs
		userActionDefs localActionDefs propertyBox settingBox sortBy
		checkBlock timeOfLastCheck checkDelta warnBox anyObscured
		bgAction'
	classVariableNames:'KnownForms'
	poolDictionaries:''
	category:'demos-DirectoryView'
!

!DirectoryView class methodsFor:'documentation'!

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



!

documentation
"
    WARNING:
	This is a very old example - not really up-to-date.
	One of the very first desktop apps written in ST/X,
	This was written in 1989, and first published in 1991!!
	when screens were typically black & white, and the first macs just appeared.
	So don't expect too much.

    This is a demo class (showing subclassing of ObjectView) - no warranty.

    It reads a file called '.DeskTop.def' in your current or your
    home directory, and opens a directory view.
    The definitions file defines what is done on a double click.
    (a sample file is found in the 'clients/DirView' directory).

    [start with:]
	DirectoryView open
"
! !

!DirectoryView class methodsFor:'cleanup'!

releaseRememberedForms
    KnownForms := nil

    "DirectoryView releaseRememberedForms"
! !

!DirectoryView class methodsFor:'defaults'!

defaultExtentOn:aDisplay
    ^ (aDisplay width // 2) @ (aDisplay height // 2)
!

hitDelta
    "when clicking an object, allow for hitDelta pixels around object;
     0 is exact."
    ^ 0
!

icon
    ^ (Image fromFile:'bitmaps/DirObj.xbm' resolution:100)

    "Modified: 24.1.1997 / 16:54:53 / cg"
! !

!DirectoryView class methodsFor:'startup'!

open
    ^ self openOn:nil

    "DirectoryView open"
!

openOn:pathName
    |topView scrollView dirView|

    topView := StandardSystemView new.
    topView extent:(self defaultExtentOn:Display).
    topView icon:self icon.
    scrollView := HVScrollableView for:self in:topView.
    scrollView origin:(0.0 @ 0.0) extent:(1.0 @ 1.0).
    dirView := scrollView scrolledView.
    pathName notNil ifTrue:[
	dirView showContentsOf:pathName
    ].
    topView open.
    ^ dirView

    "DirectoryView openOn:'.'"
    "ArchiveView openOn:'../SRCDISTRIB/upd.tar'"
! !

!DirectoryView methodsFor:'accessing'!

currentDirectory:aPathName
    currentDirectoryName := aPathName.
    currentDirectory := FileDirectory directoryNamed:currentDirectoryName
!

label:aString
    "label change"

    superView notNil ifTrue:[
	superView label:currentDirectoryName
    ] ifFalse:[
	super label:currentDirectoryName
    ]
! !

!DirectoryView methodsFor:'drag & drop'!

canDrop:something
    "return true, if anObjectOrCollection can be
     dropped in the receiver."

    (something isKindOf:Collection) ifTrue:[
	"everything must be a DirectoryViewObject"
	something do:[:anObject |
	    (anObject isKindOf:DirectoryViewObject) ifFalse:[
		(anObject respondsTo:#asDirectoryViewObject) ifFalse:[
		    ^ false
		]
	    ]
	].
	^ true
    ].
    (something isKindOf:DirectoryViewObject) ifTrue:[^ true].
    ^ something respondsTo:#asDirectoryViewObject

!

drop:something at:aPoint from:aView with:aBlock ifFail:failBlock
    "another view wants me to take an object. Take the object
     and evaluate aBlock for each successful takeover. Evaluate
     failBlock if something went wrong."

    |o|

    (something isKindOf:Collection) ifTrue:[
	"everything must be a DirectoryViewObject"
	something do:[:anObject |
	    (anObject isKindOf:DirectoryViewObject) ifTrue:[
		o := anObject
	    ] ifFalse:[
		o := anObject asDirectoryViewObject
	    ].
	    (self dropObject:o at:aPoint) ifTrue:[aBlock value:anObject]
					 ifFalse:[failBlock value:anObject]
	]
    ] ifFalse:[
	(something isKindOf:DirectoryViewObject) ifTrue:[
	    o := something
	] ifFalse:[
	    o := something asDirectoryViewObject
	].
	(self dropObject:o at:aPoint) ifTrue:[aBlock value:something]
				     ifFalse:[failBlock value:something]
    ].
    self updateContents.
    aView updateContents
!

dropObject:anObject at:aPoint
    "Takeover the object - return true if successfull"

    |oldPathName newPathName moveOk|

    oldPathName := anObject pathName.
    newPathName := currentDirectory pathName , '/' , anObject name.
    oldPathName = newPathName ifTrue:[
	^ false
    ].

    moveOk := true.
    (OperatingSystem linkFile:oldPathName to:newPathName) ifTrue:[
	(OperatingSystem removeFile:oldPathName) ifTrue:[^ true]
    ].
    OperatingSystem removeFile:newPathName.

    "move failed - try mv command"

    (OperatingSystem executeCommand:('mv ' , oldPathName, ' ' , newPathName))
    ifTrue:[
	^ true
    ].

    "is it a directory ?"

    (OperatingSystem isDirectory:oldPathName) ifTrue:[
	(OperatingSystem executeCommand:
			   ('mvdir ' , oldPathName, ' ' , newPathName))
	ifTrue:[
	    ^ true
	]
    ].

    "try copying"

    (OperatingSystem isDirectory:oldPathName) ifTrue:[^ false].
    (OperatingSystem executeCommand:('cp ' , oldPathName, ' ' , newPathName))
    ifTrue:[
	(OperatingSystem removeFile:oldPathName) ifTrue:[^ true].
	(OperatingSystem executeCommand:('rm -f ' , oldPathName))
	ifTrue:[^ true].
	OperatingSystem executeCommand:('rm -f ' , newPathName)
    ].
    ^ false
!

move:something to:aPoint in:aView
    "move something into another view"

    |nm|

    (aView canDrop:something) ifFalse:[
	nm := aView name.
	(nm ~~ aView class name) ifTrue:[
	    self notify:('cannot drop object(s) in '
			 , aView name)
	] ifFalse:[
	    self notify:('cannot drop object(s) in '
			 , aView classNameWithArticle)
	].
	^ self
    ].
    aView drop:something at:aPoint from:self
    with:[:takenObject |
	"takeover was successful - remove it here"

	'takeover of: ' print. takenObject pathName print.
	' ok' printNewline
    ]
    ifFail:[:failedObject |
	"takeover was not successful"

	'takeover of: ' print. failedObject pathName print.
	' failed' printNewline
    ]
!

move:something to:aPoint inAlienViewId:aViewId
    "move something into another view (which is not a smalltalk
     view)"

    self notify:'cannot move object(s) to alien views'
! !

!DirectoryView methodsFor:'events'!

destroy
    Processor removeTimedBlock:checkBlock.
    warnBox notNil ifTrue:[warnBox destroy].
    propertyBox notNil ifTrue:[propertyBox destroy].
    settingBox notNil ifTrue:[settingBox destroy].
    super destroy
!

sizeChanged:how
    self reorgContents.
    super sizeChanged:how

! !

!DirectoryView methodsFor:'group selection'!

endRectangleDrag
    "objectView selects objects fully contained in lasso -
     here we want to select all objects touched by lasso"

    self invertDragRectangle.
    self cursor:Cursor normal.
    self selectAllIntersecting:dragObject
! !

!DirectoryView methodsFor:'initializing'!

defaultActionDefinitions
    ^ nil
!

defaultIconDefinitions
    ^ Array
	with:
	    [:name :typ :mime :mode |
		(typ == #directory)         ifTrue:[^ 'DirObj'].
		(mime startsWith:'audio/')  ifTrue:[^ 'SoundObj'].
		(mime startsWith:'image/')  ifTrue:[^ 'ImageFile'].
	    ]
!

fullScreen
    "make me running in fullscreen mode"

    |rootView|

    rootView := DisplayRootView new.
    rootView isWindowManagerRunning ifTrue:[^ nil].
    drawableId := rootView id. "a kludge"
!

initialize
    checkBlock := [self checkIfDirectoryHasChanged].
    checkDelta := 5.

    super initialize.

    anyObscured := false.
    canDragOutOfView := true.

    self initializeDefinitions.

    self setupActions.

    doublePressAction := [:pressPoint | self doubleClick:pressPoint].

    pressAction := [:aPoint | self startSelectOrMove:aPoint].
    shiftPressAction := [:aPoint | self startSelectMoreOrMove:aPoint].

    self setupContentsSpecific

    "DirectoryView start"
!

initializeDefinitions
    |homeDir|

    '/usr/lib/smalltalk/DeskTop.defs' asFilename exists ifTrue:[
	systemIconDefs := self readIconDefinitionsFrom:'/usr/lib/smalltalk/DeskTop.defs'.
	systemActionDefs := self readActionDefinitionsFrom:'/usr/lib/smalltalk/DeskTop.defs'.
    ] ifFalse:[
	"/ systemIconDefs := self readIconDefinitionsFrom:(self class packageDirectory /  'sample.defs').
	"/ systemActionDefs := self readActionDefinitionsFrom:(self class packageDirectory /  'sample.defs').
    ].

    systemIconDefs isNil ifTrue:[
	systemIconDefs := self defaultIconDefinitions
    ].
    systemActionDefs isNil ifTrue:[
	systemActionDefs := self defaultActionDefinitions
    ].

    homeDir := OperatingSystem getHomeDirectory.
    homeDir notNil ifTrue:[
	userIconDefs := self readIconDefinitionsFrom:(homeDir , '/.DeskTop.defs').
	userActionDefs := self readActionDefinitionsFrom:(homeDir , '/.DeskTop.defs')
    ].
!

initializeFullScreen
    |rootView|

    self initialize.
    drawableId notNil ifTrue:[
	'too late to change to rootWindow' printNL.
	^ nil
    ].
    rootView := DisplayRootView new.
    rootView isWindowManagerRunning ifTrue:[
	'another window manager is running' printNL.
	^ false
    ].
    width := device width.
    height := device height.
    realized := true.
    shown := true.
    drawableId := device rootWindowFor:self.
    self initGC
!

initializeMiddleButtonMenu
    self middleButtonMenu:(PopUpMenu
				labels:(resources array:
				     #(
					 'open'
					 'show'
					 'fileIn'
					 '-'
					 'remove'
"
					 'rename'
					 'properties'
"
					 '-'
					 'execute'
					 'print'
"
					 '-'
					 'settings'
"
				       ))
			     selectors:#(open
					 show
					 fileIn
					 nil
					 remove
"
					 rename
					 properties
"
					 nil
					 execute
					 print
"
					 nil
					 settings
"
					)
				receiver:self
				     for:self)
!

privateRealize
    self directoryChanged
!

readActionDefinitionsFrom:aFileName
    ^ self readDefinitionsFrom:aFileName for:#actions
!

readDefinitionsFrom:aFileName for:aKeyWord
    |definitions skipping aStream chunk value|

    FileDoesNotExistException handle:[:ex |
    ] do:[
	aStream := FileStream readonlyFileNamed:aFileName.
    ].
    aStream notNil ifTrue:[
	definitions := OrderedCollection new.
	skipping := true.
	[aStream atEnd] whileFalse:[
	    chunk := aStream nextChunk.
	    chunk notNil ifTrue:[
		value := Compiler evaluate:chunk.
		skipping ifTrue:[
		    (value = aKeyWord) ifTrue:[
			skipping := false
		    ]
		] ifFalse:[
		    value isBlock ifTrue:[
			definitions add:value
		    ] ifFalse:[
			skipping := true
		    ]
		]
	    ]
	].
	aStream close
    ].
    ^ definitions
!

readIconDefinitionsFrom:aFileName
    ^ self readDefinitionsFrom:aFileName for:#icons
!

realize
    super realize.
    self privateRealize
!

setupActions
    fileAction := [:aFileName | self executeFile:aFileName].
    dirAction := [:aFileName | self changeDirectory:aFileName]
!

setupContentsSpecific
    currentDirectory := FileDirectory directoryNamed:'.'.
    currentDirectory notNil ifTrue:[
	currentDirectoryName := currentDirectory pathName
    ].
    self topView label:currentDirectoryName.
    self topView iconLabel:(currentDirectory baseName)

    "Modified: / 4.4.1998 / 23:15:24 / cg"
!

showContentsOf:pathName
    self changeDirectory:pathName
! !

!DirectoryView methodsFor:'layout manipulation'!

moveObject:anObject to:newOrigin
    "move anObject to newOrigin, aPoint. Redefined to recompute the anyObscured
     flag."

    |objectsIntersectingFrame frame|

    super moveObject:anObject to:newOrigin.
    anyObscured ifFalse:[
	frame := self frameOf:anObject.
	objectsIntersectingFrame := self objectsIntersecting:frame.
	objectsIntersectingFrame size == 1 ifFalse:[
	    anyObscured := true
	]
    ]
! !

!DirectoryView methodsFor:'misc queries'!

heightOfContents
    "answer the height of the document in pixels
     in this case, the max y extent is returned"

    ^ (contents inject:0 into:[:maxSoFar :something |
	something frame bottom max:maxSoFar
    ]) + 8

"/    |maxY|
"/
"/    maxY := 0.
"/    contents do:[:something |
"/        (something frame bottom > maxY) ifTrue:[
"/            maxY := something frame bottom
"/        ]
"/    ].
"/  ^ maxY + 8
!

isObscured:anObject
    "return true, if anObject is obscured by some other"

    anyObscured ifTrue:[
	^ super isObscured:anObject
    ].
    ^ false
!

rectangleForScroll
    "no need to waste time looking for objects; need full width always"

    ^ Rectangle left:0 top:0 width:width height:height
!

widthOfContents
    "answer the height of the document in pixels
     in this case, the max y extent is returned"

    ^ contents inject:0 into:[:maxSoFar :something |
	something frame right max:maxSoFar
    ]

"/  |maxX|

"/  maxX := 0.
"/  contents do:[:something |
"/      (something frame right > maxX) ifTrue:[
"/          maxX := something frame right
"/      ]
"/  ].
"/  ^ maxX
! !

!DirectoryView methodsFor:'private'!

accessRightsOfSelectionAsNumber

    selection isNil ifTrue:[^ nil].
    ^ currentDirectory accessModeOf:(selection name)
!

changeAccessRightOfSelection:bitMask to:aBoolean
    |mode|

    selection isNil ifTrue:[^ nil].
    mode := currentDirectory accessModeOf:(selection name).
    aBoolean ifTrue:[
	mode := mode bitOr:bitMask
    ] ifFalse:[
	mode := mode bitAnd:(bitMask bitInvert)
    ].
    ^ currentDirectory changeAccessModeOf:(selection name) to:mode
!

checkIfDirectoryHasChanged
    "every checkDelta secs, check if directoy has changed and update view if so"

    realized ifTrue:[
	(currentDirectory notNil) ifTrue:[
	    (currentDirectory timeOfLastChange > timeOfLastCheck) ifTrue:[
		 self updateContents
	    ] ifFalse:[
		 Processor addTimedBlock:checkBlock afterSeconds:checkDelta
	    ]
	]
    ]
!

directoryChanged
    Processor removeTimedBlock:checkBlock.

    localIconDefs := self readIconDefinitionsFrom:'.DeskTop.defs'.
    localActionDefs := self readActionDefinitionsFrom:'.DeskTop.defs'.
    self topView label:currentDirectoryName.
    self removeAllWithoutRedraw.
    self scrollToTop.
    self updateContents
!

getFormFromFile:fileName
    "this one looks for already known forms - to not create too many
     forms"

    | aForm image|

    KnownForms notNil ifTrue:[
	aForm := KnownForms at:fileName ifAbsent:[nil].
	aForm notNil ifTrue:[
	    ^ aForm
	]
    ].

    image := Smalltalk imageFromFileNamed:fileName inPackage:(self class package).
    image isNil ifTrue:[
	image := Smalltalk imageFromFileNamed:('bitmaps/' , fileName) inPackage:(self class package).
    ].
    image notNil ifTrue:[
       aForm := image asFormOn:device
    ].

    aForm notNil ifTrue:[
	KnownForms isNil ifTrue:[
	    KnownForms := Dictionary new
	].
	KnownForms at:fileName put:aForm
    ].
    ^ aForm

    "Modified: 24.1.1997 / 16:56:42 / cg"
!

maximumObjectBounds
    |maxX maxY w h frame|

    "find the widest width and highest height"
    maxX := 0.
    maxY := 0.
    contents do:[:obj |
	frame := obj frame.
	w := frame width.
	h := frame height.
	maxX := maxX max:w.
	maxY := maxY max:h
    ].
    ^ maxX @ maxY
!

objectForFile:aFileName
    |type mime mode sz index fName iconFileName val
     icon mask newObject|

    type := currentDirectory typeOf:aFileName.
    (type == #regular) ifTrue:[
	(currentDirectory isExecutable:aFileName) ifTrue:[
	    mode := #executable
	].
	mime := MIMETypes mimeTypeForFilename:aFileName
    ].
    mime := mime ? ''.

    "get an icon-filename"
    localIconDefs notNil ifTrue:[
	index := 1.
	sz := localIconDefs size.
	[index <= sz] whileTrue:[
	    "
	     stupid: I have defined the blocks to ^ the value,
	     which is no longer allowed in ST/X starting with 2.10.3.
	     (the blocks home method is no longer living).
	     Well, after all, we can demonstrate some exception handling
	     here ... nice isn't it ?
	    "
	    Context cannotReturnSignal handle:[:ex |
		val := ex parameter.
		ex return.
	    ] do:[
		val := (localIconDefs at:index) value:aFileName value:type value:mode.
	    ].
	    val isString ifTrue:[
		fName := val.
		index := sz  "exit loop"
	    ].
	    index := index + 1
	]
    ].
    fName isNil ifTrue:[
	userIconDefs notNil ifTrue:[
	    index := 1.
	    sz := userIconDefs size.
	    [index <= sz] whileTrue:[
		Context cannotReturnSignal handle:[:ex |
		    val := ex parameter.
		    ex return.
		] do:[
		    val := (userIconDefs at:index) value:aFileName value:type value:mode.
		].
		val isString ifTrue:[
		    fName := val.
		    index := sz  "exit loop"
		].
		index := index + 1
	    ]
	]
    ].
    fName isNil ifTrue:[
	systemIconDefs notNil ifTrue:[
	    index := 1.
	    sz := systemIconDefs size.
	    [index <= sz] whileTrue:[
		Context cannotReturnSignal handle:[:ex |
		    val := ex parameter.
		    ex return.
		] do:[
		    val := (systemIconDefs at:index) value:aFileName value:type value:mime value:mode.
		].
		val isString ifTrue:[
		    fName := val.
		    index := sz  "exit loop"
		].
		index := index + 1
	    ]
	]
    ].
    fName isNil ifTrue:[
	(type == #directory) ifTrue:[
	    fName := 'DirObj'
	] ifFalse:[
	    fName := 'FileObj'
	]
    ].
    iconFileName := fName.
    icon := self getFormFromFile:(iconFileName , '.xbm').
    mask := self getFormFromFile:(fName , '_m.xbm').

    icon isNil ifTrue:[
	(type == #directory) ifTrue:[
	    icon := self getFormFromFile:'DirObj.xbm'.
	    mask := self getFormFromFile:'DirObj_m.xbm'
	] ifFalse:[
	    icon := self getFormFromFile:'FileObj.xbm'.
	    mask := self getFormFromFile:'FileObj_m.xbm'
	]
    ].
    (type == #directory) ifTrue:[
	newObject := (DirectoryObject new) icon:icon mask:mask
    ] ifFalse:[
	newObject := (FileObject new) icon:icon mask:mask
    ].
    ^ newObject
!

performActionForFile:aFileName
    "perform actionblock"

    |type mode actionBlock val|

    type := currentDirectory typeOf:aFileName.
    (type == #regular) ifTrue:[
	(currentDirectory isExecutable:aFileName) ifTrue:[
	    mode := #executable
	]
    ].

    localActionDefs notNil ifTrue:[
	localActionDefs do:[:anAction |
	    val := anAction value:aFileName value:type value:mode.
	    val notNil ifTrue:[^ self]
	]
    ].
    userActionDefs notNil ifTrue:[
	userActionDefs do:[:anAction |
	    val := anAction value:aFileName value:type value:mode.
	    val notNil ifTrue:[^ self]
	]
    ].
    systemActionDefs notNil ifTrue:[
	systemActionDefs do:[:anAction |
	    val := anAction value:aFileName value:type value:mode.
	    val notNil ifTrue:[^ self]
	]
    ].
    "
     none specified - perform default action
    "
    (type == #directory) ifTrue:[
	actionBlock := dirAction
    ] ifFalse:[
	actionBlock := fileAction
    ].
    actionBlock value:aFileName
!

reorgContents
    "reorganize elements to make them fit nicely"

    |frame oldOrigin newOrigin movingUp
     xPos yPos deltaY spaceX spaceY t w h index newOrigins
     max allInOne|

    self cursor:Cursor wait.

    anyObscured := false.

    "find the widest width and highest height"
    max := self maximumObjectBounds.

    deltaY := 0.
    spaceX := max x + 8 "font widthOf:'wwwwwwwwwwwwwww'" .
    spaceY := 8.
    xPos := 8.
    yPos := spaceY.
    movingUp := false.

    contents size > 100 ifFalse:[
	newOrigins := OrderedCollection new.
	"to make visible effect better, first get all new origins without any update"
    ].

    contents do:[:obj |
	frame := obj frame.
	w := frame width.
	t := (spaceX - w) // 2.
	oldOrigin := obj origin.
	newOrigin := ((xPos + t) @ yPos).
	newOrigins isNil ifTrue:[
	    (newOrigin ~= oldOrigin) ifTrue:[
		self moveObject:obj to:newOrigin.
	    ]
	] ifFalse:[
	    (newOrigin = oldOrigin) ifTrue:[
		newOrigins add:nil
	    ] ifFalse:[
		newOrigins add:newOrigin.
		(newOrigin y < oldOrigin y) ifTrue:[
		    movingUp := true
		]
	    ].
	].

	"advance to the right -"
	xPos := xPos + spaceX.
	((xPos + spaceX) >= width) ifTrue:[
	    "right of view reached - advance to next row"
	    xPos := 8.
	    yPos := yPos + deltaY + spaceY.
	    deltaY := 0
	].
	"keep track of highest object in this row for next row advance"
	deltaY := deltaY max:(frame height)
    ].

    "then update"
    newOrigins notNil ifTrue:[
	shown ifTrue:[
	    "must react on previous exposes first"
	    [self sensor hasExposeEventFor:self "self exposeEventPending"] whileTrue:[
		  self waitForExpose
	    ].

	    movingUp ifTrue:[
		index := 1.
		contents do:[:obj |
		    newOrigin := newOrigins at:index.
		    newOrigin notNil ifTrue:[
			self moveObject:obj to:newOrigin.
		   ].
		    index := index + 1
		]
	    ] ifFalse:[
		index := newOrigins size.
		contents reverseDo:[:obj |
		    newOrigin := newOrigins at:index.
		    newOrigin notNil ifTrue:[
			self moveObject:obj to:newOrigin
		    ].
		    index := index - 1
		]
	    ].
	].
    ].
    "sorted := true."
    self contentsChanged.
    self cursor:Cursor normal.
!

showAlert:aMessage
    warnBox isNil ifTrue:[
	warnBox := WarningBox new
    ].
    warnBox title:aMessage.
    warnBox showAtPointer
!

showObjects
    "reorganize and show pictures"

    |files obj frame
     xPos yPos max deltaY spaceX spaceY t w h|

    self cursor:Cursor wait.

    "find the widest width and highest height"
    max := self maximumObjectBounds.

    deltaY := max y.
    spaceX := max x + 8 "font widthOf:'wwwwwwwwwwwwwww'" .
    spaceY := 8.
    xPos := 8.
    yPos := spaceY.

    contents do:[:obj |
	frame := obj frame.
	w := frame width.
	t := (spaceX - w) // 2.
	    obj origin:(xPos + t @ yPos).
	    xPos := xPos + spaceX.
	    ((xPos + spaceX) >= width) ifTrue:[
		xPos := 8.
		yPos := yPos + deltaY + spaceY.
	    ].
    ].
    "sorted := true."
    anyObscured := false.
    self contentsChanged.
    shown ifTrue:[
	self redraw
    ].
    self cursor:Cursor normal
!

updateContents
    "read in currentDirectory - show pictures"

    |files|

    self removeAllWithoutRedraw.
    self label:currentDirectoryName.
    self topView iconLabel:(currentDirectory baseName).

    currentDirectory isNil ifTrue:[
	currentDirectory := FileDirectory directoryNamed:currentDirectoryName
    ].
    timeOfLastCheck := Timestamp now.
    files := currentDirectory asStringCollection asSortedCollection.
    (files includes:'..') ifFalse:[
	files add:'..'
    ].
    files do:[:aFileName |
	|obj|

	(aFileName = '.') ifFalse:[
	    obj := self objectForFile:aFileName.
	    obj font:font.
	    obj pathName:(currentDirectoryName , '/' , aFileName).
	    obj origin:0@0.
	    self addWithoutRedraw:obj.
	]
    ].

    self showObjects.
    Processor addTimedBlock:checkBlock afterSeconds:checkDelta.

    "Modified: / 4.4.1998 / 23:18:00 / cg"
! !

!DirectoryView methodsFor:'property-dialog'!

rGroup
    ^ self accessRightsOfSelectionAsNumber bitTest:8r040
!

rGroup:aBoolean
    ^ self changeAccessRightOfSelection:8r040 to:aBoolean
!

rOther
    ^ self accessRightsOfSelectionAsNumber bitTest:8r004
!

rOther:aBoolean
    ^ self changeAccessRightOfSelection:8r004 to:aBoolean
!

rOwner
    ^ self accessRightsOfSelectionAsNumber bitTest:8r400
!

rOwner:aBoolean
    ^ self changeAccessRightOfSelection:8r400 to:aBoolean
!

wGroup
    ^ self accessRightsOfSelectionAsNumber bitTest:8r020
!

wGroup:aBoolean
    ^ self changeAccessRightOfSelection:8r020 to:aBoolean
!

wOther
    ^ self accessRightsOfSelectionAsNumber bitTest:8r002
!

wOther:aBoolean
    ^ self changeAccessRightOfSelection:8r002 to:aBoolean
!

wOwner
    ^ self accessRightsOfSelectionAsNumber bitTest:8r200
!

wOwner:aBoolean
    ^ self changeAccessRightOfSelection:8r200 to:aBoolean
!

xGroup
    ^ self accessRightsOfSelectionAsNumber bitTest:8r010
!

xGroup:aBoolean
    ^ self changeAccessRightOfSelection:8r010 to:aBoolean
!

xOther
    ^ self accessRightsOfSelectionAsNumber bitTest:8r001
!

xOther:aBoolean
    ^ self changeAccessRightOfSelection:8r001 to:aBoolean
!

xOwner
    ^ self accessRightsOfSelectionAsNumber bitTest:8r100
!

xOwner:aBoolean
    ^ self changeAccessRightOfSelection:8r100 to:aBoolean
! !

!DirectoryView methodsFor:'user interaction'!

changeDirectory:pathName
    |newCurrentDirectory|

    newCurrentDirectory := FileDirectory directoryNamed:pathName.
    newCurrentDirectory notNil ifTrue:[
	currentDirectory := newCurrentDirectory.
	currentDirectoryName := currentDirectory pathName.
	self directoryChanged
    ]
!

doubleClick:aPoint
    |anObject|

    anObject := self findObjectAt:aPoint.
    (anObject ~~ selection) ifTrue:[self unselect].
    anObject notNil ifTrue:[
	self cursor:Cursor wait.
	self performActionForFile:(anObject pathName).
"        anObject activate.     "
	self cursor:Cursor normal
    ]
!

edit
    "start a document editor on the selected file"

    self cursor:Cursor wait.
    self selectionDo:[:anObject |
	EditTextView openOn:(anObject pathName)
    ].
    self cursor:Cursor normal
!

executeFile:name
    |nm|

    name notNil ifTrue:[
	((currentDirectory typeOf:name) == #regular) ifTrue:[
	    (currentDirectory isExecutable:name) ifTrue:[
		OperatingSystem executeCommand:('(cd ' , currentDirectoryName , '; ' , name , ') &').
		^ self
	    ]
	].
	name size > 40 ifTrue:[
	    nm := OperatingSystem baseNameOf:name
	] ifFalse:[
	    nm := name
	].
	self showAlert:(resources string:'cannot execute %1' with:nm)
    ]
!

fileIn
    "load the selected file(s)"

    |fileName aStream prevState|

    self cursor:Cursor wait.
    self selectionDo:[:anObject |
	fileName := anObject name.
	((currentDirectory typeOf:fileName) == #regular) ifTrue:[
	    aStream := FileStream readonlyFileNamed:fileName
						 in:currentDirectory.
	    aStream isNil ifFalse:[
		prevState := Class noUpdateChanges.
		aStream fileIn.
		Class updateChanges:prevState.
		aStream close
	    ]
	]
    ].
    self cursor:Cursor normal
!

open
    "open selection i.e. start a document editor if its a file,
     start directory view of directory"

    |name type|

    self cursor:Cursor wait.
    self selectionDo:[:anObject |
	name := anObject name.
	type := currentDirectory typeOf:name.
	(type == #regular) ifTrue:[
	    anObject activate
	].
	(type == #directory) ifTrue:[
	    DirectoryView openOn:(anObject pathName)
	]
    ].
    self cursor:Cursor normal
!

properties
    "start a box to view/change file properties"

    |label|

    (selection isNil or:[selection isKindOf:Collection]) ifTrue:[
	self notify:'you must select exactly one object'.
	^ self
    ].
    label := resources string:'properties'.
    propertyBox isNil ifTrue:[
	propertyBox := DialogBox label:label for:self
				 names:(resources array:#(
					 'access'
					 'owner'
					 'read'
					 'write'
					 'executeP'
					 'group'
					 'read'
					 'write'
					 'execute'
					 'others'
					 'read'
					 'write'
					 'execute'
					))
				fields:#(
					 (   nil          0 nil      nil)
					 (   nil          0 nil      nil)
					 (   CheckToggle  0 rOwner   rOwner:)
					 (   CheckToggle  0 wOwner   wOwner:)
					 (   CheckToggle  0 xOwner   xOwner:)
					 (   nil          0 nil      nil)
					 (   CheckToggle  0 rGroup   rGroup:)
					 (   CheckToggle  0 wGroup   wGroup:)
					 (   CheckToggle  0 xGroup   xGroup:)
					 (   nil          0 nil      nil)
					 (   CheckToggle  0 rOther   rOther:)
					 (   CheckToggle  0 wOther   wOther:)
					 (   CheckToggle  0 xOther   xOther:)
					)
    ].
    propertyBox showAtPointer
!

remove
    "remove the selected file"

    |name ok anythingRemoved|

    anythingRemoved := false.
    self selectionDo:[:anObject |
	name := anObject name.
	name notNil ifTrue:[
	    ok := currentDirectory remove:name.
	    ok ifFalse:[
		"was not able to remove it"
		self showAlert:(resources string:'cannot remove %1' with:name)
	    ] ifTrue:[
		self removeObject:anObject.
		anythingRemoved := true
	    ]
	]
    ].
    anythingRemoved ifTrue:[
	timeOfLastCheck := AbsoluteTime now.
	self reorgContents "updateContents"
    ]
!

reorg
    self updateContents
!

settings
    "start a box to change settings"

    |label|

    label := resources string:'settings'.
    settingBox isNil ifTrue:[
	settingBox := DialogBox label:label for:self
				names:resources array:
				      #(
					'sort by'
				       )
			       fields:#(
					( EditField  0 sortBy   sortBy:)
				       )
    ].
    settingBox showAtPointer
!

show
    "start a document editor on the selected file(s)"

    |fileName|

    self cursor:Cursor wait.
    self selectionDo:[:anObject |
	fileName := anObject pathName.
	((currentDirectory typeOf:fileName) == #regular) ifTrue:[
	    (EditTextView openOn:fileName) readOnly
	]
    ].
    self cursor:Cursor normal
!

startObjectMove:something at:aPoint
    "redefined since here, all clocked upon objects are brought to front"

    self toFront:something.
    super startObjectMove:something at:aPoint
! !

!DirectoryView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DirView/DirectoryView.st,v 1.19 2016-11-01 14:42:46 cg Exp $'
! !
