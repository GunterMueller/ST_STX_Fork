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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Model subclass:#TabItem
	instanceVariableNames:'view rawLabel label enabled argument canvas activeHelpText
		translateLabel applicationProvidesLabel shortcutKey majorKey
		minorKey miniScrollerVertical miniScrollerHorizontal
		hasVerticalScrollBar hasHorizontalScrollBar foregroundColor
		createNewBuilder autoHideScrollBars accessCharacterPosition
		activeHelpKey builder nameKey destroyTabButtonAction
		destroyTabAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!TabItem class methodsFor:'documentation'!

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
    describes one tab entry; could be used for tabs instead of a string. Whenever
    a value changed, a change notification is raised

    [see also:]
        TabItemEditor
        TabView
        NoteBookView
        UIPainter

    [author:]
        Claus Atzkern
"


!

examples
"
    labels derived from item
                                                                                [exBegin]                                      
    |top tab|

    top := StandardSystemView new label:'tabs at top'; extent:250@100.
    tab  := TabView origin:0.0 @ 0.0 corner:1.0 @ 0.5 in:top.

    tab direction:#top.
    tab list:(#( 'Foo' 'Bar' 'Baz' ) collect:[:l| TabItem label:l ]).
    tab action:[:aName|Transcript showCR:aName].
    top open.
                                                                                [exEnd]

                                                                                [exBegin]                                      
    |top tab list item|

    top := StandardSystemView new label:'tabs at top'; extent:400@400.
    tab  := NoteBookView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.

    tab direction:#top.
    list := #( 'Foo' 'Bar' 'Baz' ) collect:[:l| TabItem label:l ].

    item := list at:1.
    item majorKey:ClockView.

    item := list at:2.
    item majorKey:CodingExamples_GUI::GUIDemoNoteBook.

    item := list at:3.
    item majorKey:CodingExamples_GUI::GUIDemoMenu.

    tab list:list.
    top open.
                                                                                [exEnd]

    testing tab configuration and change notifications
                                                                                [exBegin]                                      
    |top tab list idx label|

    top := StandardSystemView new label:'tabs at top'; extent:250@100.
    tab  := TabView origin:0.0 @ 0.0 corner:1.0 @ 0.5 in:top.

    tab direction:#top.
    list := (#( 'Foo' 'Bar' 'Baz' ) collect:[:l| TabItem label:l ]).
    tab list:list.
    tab action:[:aName|Transcript showCR:aName].
    top openAndWait.

    [
        idx := 0.
        label := LabelAndIcon icon:(Image fromFile:('xpmBitmaps/document_images/tiny_yellow_dir.xpm' ))
                            string:'Test Tab'.

        [top shown] whileTrue:[
            |aTab lbl|

            (idx := idx + 1) > list size ifTrue:[idx := 1].

            aTab := list at:idx.
            lbl  := aTab label.

            Delay waitForSeconds:0.5. aTab label:label.
            Delay waitForSeconds:0.5. aTab enabled:false.
            Delay waitForSeconds:0.5. aTab enabled:true.
            Delay waitForSeconds:0.5. aTab foregroundColor:(Color red).
            Delay waitForSeconds:0.5. aTab foregroundColor:nil.
            aTab label:lbl.
        ]
    ] forkAt:1.
                                                                                [exEnd]

"
! !

!TabItem class methodsFor:'instance creation'!

label:aLabel
    ^ self new label:aLabel
! !

!TabItem methodsFor:'accessing'!

accessCharacterPosition
    "get the index of the access character in the label text or string, or 0 if none"

    ^ accessCharacterPosition ? 0

    "Modified: / 06-09-2006 / 14:57:08 / cg"
!

accessCharacterPosition:anIndex
    "set the index of the access character in the label"

    accessCharacterPosition := anIndex

    "Modified: / 06-09-2006 / 14:57:44 / cg"
!

argument
    "returns a user defined argument or nil
    "
    ^ argument
!

argument:anArgument
    "set a user defined argument
    "
    (anArgument isString and:[anArgument isEmpty]) ifTrue:[
        argument := nil
    ] ifFalse:[
        argument := anArgument
    ].
    argument := anArgument
!

createNewBuilder
    "returns true if a new builder is used to create the canvas;
     the default is true"

    ^ createNewBuilder ? true

    "Modified: / 06-09-2006 / 14:58:58 / cg"
!

createNewBuilder:aBool
    "set/clear the flag which controls if a new ui-builder is used to create the canvas;
     the default is true. This affects if the bindings will be shared or not between tabs."

    createNewBuilder := aBool

    "Modified: / 06-09-2006 / 15:00:04 / cg"
!

destroyTabAction
    "if non-nil, this tab has its own private destroyButton.
     This can be used for individual tabs; for an overall tab-destroy capability,
     change the destroyTab: action of my owning tabView"

    ^ destroyTabAction
!

destroyTabAction:aBlock
    "if non-nil, this tab has its own private destroyButton.
     This can be used for individual tabs; for an overall tab-destroy capability,
     change the destroyTab: action of my owning tabView"

    destroyTabAction := aBlock
!

enabled
    "get the enabled state of the tab
    "
    ^ enabled ? true
!

enabled:aState
    "set the enabled state of the tab
    "
    |s|

    s := aState ? true.

    self enabled ~~ s ifTrue:[
        enabled := s.
        self changed:#enabled
    ]
!

foregroundColor
    "get the label color or nil"

    ^ foregroundColor

    "Modified: / 06-09-2006 / 15:14:46 / cg"
!

foregroundColor:aColor
    "set the label color or nil"

    foregroundColor ~= aColor ifTrue:[
        foregroundColor := aColor.
        self changed:#foregroundColor
    ].

    "Modified: / 06-09-2006 / 15:00:31 / cg"
!

hasView
    ^ view notNil
!

label
    "get the label or selector to access a label/bitmap. To get the label to be shown
     use: #rawLabel
    "
    ^ label
!

label:aLabel
    "set the label or selector to access the label/bitmap"

    label := aLabel.

    (aLabel ~= rawLabel
    or:[aLabel class ~~ rawLabel class 
    or:[aLabel isString 
        and:[rawLabel isString
        and:[(aLabel sameStringAndEmphasisAs:rawLabel) not]]]])

    ifTrue:[
        rawLabel := aLabel.
        self changed
    ]

    "Modified: / 06-09-2006 / 15:54:13 / cg"
!

labelForegroundColor
    "get the label color or nil
    "
    ^ self foregroundColor
!

labelForegroundColor:aColor
    "set the label color or nil
    "
    self foregroundColor:aColor
!

nameKey
    "an additional (untranslated) key (do not use the label to identify tabs)"

    ^ nameKey

    "Created: / 21-09-2010 / 16:57:54 / cg"
!

nameKey:aStringOrSymbol
    "an additional (untranslated) key (do not use the label to identify tabs)"

    nameKey := aStringOrSymbol

    "Created: / 21-09-2010 / 16:58:05 / cg"
!

shortcutKey
    "get the key to press to select the tab item from the keyboard; a symbol or nil"

    ^ shortcutKey

    "Modified: / 06-09-2006 / 15:09:18 / cg"
!

shortcutKey:aKeyOrNil
    "set the key to press to select the tab item from the keyboard; a symbol or nil"

    |key|

    aKeyOrNil size ~~ 0 ifTrue:[
        key := aKeyOrNil asSymbol
    ].
    shortcutKey := key

    "Modified: / 06-09-2006 / 15:09:31 / cg"
!

view
    ^ view

    "Created: / 25-07-2010 / 11:58:53 / cg"
!

view:aView
    aView isNil ifTrue:[
        view := aView.
        ^ self.
    ].

    view notNil ifTrue:[
        aView ~~ view ifTrue:[
            self error:'TabItems cannot be reused'.
        ].
    ].
    view := aView.
    self setAttributesWithBuilder:view application builder.

    "Modified: / 06-09-2006 / 17:58:58 / cg"
! !

!TabItem methodsFor:'accessing-canvas'!

canvas
    "returns the application or view. Creates one if not already present"

    |view cls wsel classNameKey oldBuilder usedBuilder appl|

    canvas notNil ifTrue:[
        ^ canvas
    ].

    (classNameKey := majorKey) notNil ifTrue:[
        oldBuilder := builder.

        (oldBuilder notNil
        and:[(appl := oldBuilder application) notNil]) ifTrue:[
            canvas := appl subApplicationFor:majorKey.
            canvas isNil ifTrue:[
                cls := appl resolveName:classNameKey.
            ]
        ] ifFalse:[
            "/ cls := Smalltalk resolveName:classNameKey inClass:self class.
            cls := Smalltalk classNamed:classNameKey.
        ].
        canvas isNil ifTrue:[
            cls isNil ifTrue:[
                self error:('no canvas for majorKey: ' , classNameKey) mayProceed:true.
                "/ self majorKey:nil.
                ^ nil
            ].
            canvas := cls new.
        ].

        self isCanvasApplicationModel ifTrue:[
            view := ApplicationSubView new.
            wsel := minorKey ? #windowSpec.

            (usedBuilder := canvas builder) isNil ifTrue:[
                (usedBuilder := oldBuilder) isNil ifTrue:[
                    canvas createBuilder.
                    usedBuilder := canvas builder.
                ] ifFalse:[
                    canvas builder:usedBuilder.
                ].
            ].

            (appl notNil and:[canvas masterApplication isNil]) ifTrue:[
                canvas masterApplication:appl
            ].
            self createNewBuilder ifTrue:[
                usedBuilder application:canvas
            ].
            view client:canvas spec:wsel builder:usedBuilder.
            canvas window:(self setupCanvasView:view).
        ] ifFalse:[
            canvas := self setupCanvasView:canvas
        ]
    ].
    ^ canvas

    "Modified: / 06-09-2006 / 15:07:55 / cg"
!

canvasApplication
    "returns the application the canvas is running"

    |canvas|

    (canvas := self canvas) isNil ifTrue:[^ nil].
    (canvas isKindOf:ApplicationModel) ifTrue:[ ^ canvas ].
    ^ canvas application
!

canvasOrNil
    "returns the application or nil - does NOT create one"

    ^ canvas 
!

canvasView
    "returns the view the canvas is running in or nil if no canvas
     specified or not yet created
    "
    |canvas|

    (canvas := self canvas) notNil ifTrue:[
        ^ canvas perform:#window ifNotUnderstood:[canvas]
    ].
    ^ nil
!

destroyCanvas
    |canvasView|

    canvas notNil ifTrue:[
        self isCanvasApplicationModel ifTrue:[
            canvas releaseAsSubCanvas.
        ].
        (canvasView := self canvasView) notNil ifTrue:[
            canvasView destroy.
        ].
        canvas := nil
    ].

    "Modified: / 02-11-2007 / 14:54:47 / cg"
!

majorKey
    ^ majorKey

    "Modified: / 06-09-2006 / 15:01:14 / cg"
!

majorKey:aMajorKey
    |key|

    aMajorKey notNil ifTrue:[
        aMajorKey isBehavior ifTrue:[
            key := aMajorKey name asSymbol
        ] ifFalse:[
            aMajorKey size ~~ 0 ifTrue:[
                key := aMajorKey asSymbol
            ]
        ]
    ].

    self majorKey ~~ key ifTrue:[
        self destroyCanvas
    ].
    majorKey := key.

    "Modified: / 06-09-2006 / 15:01:22 / cg"
!

minorKey
    ^ minorKey

    "Modified: / 06-09-2006 / 15:01:58 / cg"
!

minorKey:aMinorKey
    minorKey := aMinorKey.

    "Modified: / 06-09-2006 / 15:02:04 / cg"
!

setupCanvasView:aView
    |frame isV isH auto viewScroller|

    isH := self hasHorizontalScrollBar.
    isV := self hasVerticalScrollBar.

    (isH or:[isV]) ifFalse:[
        frame := aView
    ] ifTrue:[
        frame := ScrollableView for:ViewScroller.
        viewScroller := frame scrolledView.

        frame horizontalScrollable:isH.
        frame verticalScrollable:isV.

        isH ifTrue:[
            frame horizontalMini:(self miniScrollerHorizontal)
        ] ifFalse:[
            "/ not horizontal scrollable - always set x to scrolled view x
            viewScroller resizeScrolledViewHorizontal:true.
        ].
        isV ifTrue:[
            frame verticalMini:(self miniScrollerVertical)
        ] ifFalse:[
            "/ not vertical scrollable - always set y to scrolled view y
            viewScroller resizeScrolledViewVertical:true.
        ].

        (auto := self autoHideScrollBars) notNil ifTrue:[
            frame autoHideScrollBars:auto
        ].
        viewScroller scrolledView:aView.
    ].
    frame objectAttributeAt:#isTabItem put:true.
    ^ frame
! !

!TabItem methodsFor:'accessing-scrollbars'!

autoHideScrollBars
    ^ autoHideScrollBars

    "Modified: / 06-09-2006 / 14:58:38 / cg"
!

autoHideScrollBars:aBoolOrNil
    autoHideScrollBars := aBoolOrNil

    "Modified: / 06-09-2006 / 14:58:45 / cg"
!

hasHorizontalScrollBar
    ^ hasHorizontalScrollBar ? false

    "Modified: / 06-09-2006 / 15:00:39 / cg"
!

hasHorizontalScrollBar:aBool
    |flag|

    aBool == true ifTrue:[flag := true]
                 ifFalse:[self miniScrollerHorizontal:false].

    hasHorizontalScrollBar := flag

    "Modified: / 06-09-2006 / 15:00:58 / cg"
!

hasVerticalScrollBar
    ^ hasVerticalScrollBar ? false

    "Modified: / 06-09-2006 / 15:01:03 / cg"
!

hasVerticalScrollBar:aBool
    |flag|

    aBool == true ifTrue:[flag := true]
                 ifFalse:[self miniScrollerVertical:false].

    hasVerticalScrollBar := flag

    "Modified: / 06-09-2006 / 15:01:10 / cg"
!

miniScrollerHorizontal
    ^ miniScrollerHorizontal ? false

    "Modified: / 06-09-2006 / 15:01:29 / cg"
!

miniScrollerHorizontal:aBool
    miniScrollerHorizontal := aBool

    "Modified: / 06-09-2006 / 15:01:40 / cg"
!

miniScrollerVertical
    ^ miniScrollerVertical ? false

    "Modified: / 06-09-2006 / 15:01:45 / cg"
!

miniScrollerVertical:aBool
    miniScrollerVertical := aBool

    "Modified: / 06-09-2006 / 15:01:55 / cg"
! !

!TabItem methodsFor:'building'!

applicationProvidesLabel
    "returns true if the label is acquired from the application"

    ^ applicationProvidesLabel ? false
!

applicationProvidesLabel:aBool
    "set/clear the flag which controls if the label is provided by the application"

    applicationProvidesLabel := aBool.
!

editAgument
    "used by TabItemEditor to get the argument
    "
    ^ argument isSymbol ifTrue:['#', argument] ifFalse:[argument]
!

editAgument:anArgument
    "used by TabItemEditor to set the argument
    "
    |size|

    anArgument size ~~ 0 ifTrue:[
        argument := anArgument withoutSeparators.

        (size := argument size) == 0 ifTrue:[
            argument := nil
        ] ifFalse:[
            (argument startsWith:$#) ifTrue:[
                size > 1 ifTrue:[
                    argument := (argument copyFrom:2) asSymbol
                ] ifFalse:[
                    argument := nil
                ]
            ]
        ]
    ] ifFalse:[
        argument := nil
    ]
!

rawLabel
    "returns the label to be shown
    "
    ^ rawLabel ? ' '


!

setAttributesFromClass:aClass
    "setup attributes from aClass 
     Ugly: used only with the tabListEditor."

    |spec cls|

    rawLabel := nil.

    cls := aClass.
    cls isBehavior ifFalse:[
        self halt:'please pass a class, not its name as argument'.
        cls := Smalltalk classNamed:aClass
    ].

    cls notNil ifTrue:[
        (self translateLabel and:[label isString]) ifTrue:[
            rawLabel := cls perform:(label asSymbol) ifNotUnderstood:nil
        ].
        (majorKey isNil and:[minorKey notNil]) ifTrue:[
"/            Error handle:[:ex|
"/            ] do:[
                "/ spec := cls perform:(minorKey asSymbol) ifNotUnderstood:nil.
                "/ spec notNil ifTrue:[
                    canvas := ApplicationSubView new.
                    canvas client:nil spec:minorKey "spec" builder:(UIBuilder new).
                    canvas := self setupCanvasView:canvas.
                "/ ].
"/            ]
        ]        
    ].

    rawLabel isNil ifTrue:[
        rawLabel := label isNil ifTrue:[''] ifFalse:[label printString]
    ].

    "Modified: / 06-09-2006 / 17:48:37 / cg"
!

setAttributesWithBuilder:aBuilder
    "setup attributes dependent on the builder"

    |appl usedBuilder |

    usedBuilder := self createNewBuilder ifTrue:[UIBuilder new] ifFalse:[aBuilder].
    builder := usedBuilder.

    (self applicationProvidesLabel) ifTrue:[
        rawLabel := aBuilder labelFor:label.
    ] ifFalse:[
        (self translateLabel) ifTrue:[
            rawLabel := aBuilder application resources string:label.
        ].
    ].
    rawLabel isNil ifTrue:[
        rawLabel := label printString.
    ].

    (aBuilder notNil and:[aBuilder isEditing not]) ifTrue:[
        appl := aBuilder application.
    ].
    appl notNil ifTrue:[
        "/ now lazy - when actually asked for (to allow for more dynamics)
        "/        activeHelpKey notNil ifTrue:[
        "/            activeHelpText := appl helpTextForKey:activeHelpKey.
        "/        ].
        usedBuilder application isNil ifTrue:[
            usedBuilder application:appl
        ].

        (majorKey isNil and:[minorKey notNil]) ifTrue:[
            canvas := ApplicationSubView new.
            canvas client:appl spec:minorKey builder:usedBuilder.
            canvas := self setupCanvasView:canvas.
        ]
    ].

    "Modified: / 25-07-2010 / 11:26:23 / cg"
!

translateLabel
    "returns true if the label derives from the application"

    ^ translateLabel ? true

    "Modified: / 06-09-2006 / 15:09:40 / cg"
!

translateLabel:aBool
    "set/clear the flag which controls if the label is translated to a national language
     via the applications resources"

    translateLabel := aBool.

    "Modified: / 06-09-2006 / 15:11:16 / cg"
! !

!TabItem methodsFor:'converting'!

skippedInLiteralEncoding
    |skipped|

    skipped := super skippedInLiteralEncoding asOrderedCollection.

    skipped add:#view.
    skipped add:#rawLabel.
    skipped add:#canvas.

    self enabled                      ifTrue:[ skipped add:#enabled ].
    self accessCharacterPosition == 0 ifTrue:[ skipped add:#accessCharacterPosition ].
    self createNewBuilder             ifTrue:[ skipped add:#createNewBuilder ].
    self miniScrollerVertical        ifFalse:[ skipped add:#miniScrollerVertical ].
    self miniScrollerHorizontal      ifFalse:[ skipped add:#miniScrollerHorizontal ].
    "/ self translateLabel              ifFalse:[ skipped add:#translateLabel ].
    self applicationProvidesLabel    ifFalse:[ skipped add:#applicationProvidesLabel ].

    ^ skipped
! !

!TabItem methodsFor:'displaying'!

displayOn:aGC x:x y:y
    |s|

    (s := rawLabel ? label) isNil ifTrue:[
        ^ self
    ].
    s isNumber ifTrue:[
        s := s printString
    ].
    s displayOn:aGC x:x y:y
!

heightOn:aGC
    |s|

    (s := rawLabel ? label) isNil ifTrue:[
        ^ aGC font height
    ].
    ^ s heightOn:aGC
!

widthOn:aGC
    |s|

    (s := rawLabel ? label) isNil ifTrue:[
        ^ 4
    ].
    ^ s widthOn:aGC
! !

!TabItem methodsFor:'help'!

activeHelpKey
    ^ activeHelpKey

    "Modified: / 06-09-2006 / 14:58:11 / cg"
!

activeHelpKey:aKey
    |key|

    aKey size > 0 ifTrue:[key := aKey asSymbol].
    activeHelpKey := key

    "Modified: / 06-09-2006 / 14:58:32 / cg"
!

activeHelpText
    |appl|

    activeHelpText notNil ifTrue:[^ activeHelpText].

    activeHelpKey notNil ifTrue:[
        view notNil ifTrue:[
            appl := view application.
        ].
        appl isNil ifTrue:[
            builder notNil ifTrue:[
                appl := builder application.
            ].
        ].
        appl notNil ifTrue:[
            ^ appl flyByHelpTextForKey:activeHelpKey.
        ].
    ].

    ^ nil
!

activeHelpText:aString
    activeHelpText := aString
! !

!TabItem methodsFor:'queries'!

isCanvasApplicationModel
    "returns true if the canvas is an application model"

    canvas notNil ifTrue:[
        ^ canvas isKindOf:ApplicationModel.
    ].
    ^ false.

    "Modified: / 06-09-2006 / 15:11:50 / cg"
!

isEnabled
    ^ self enabled
! !

!TabItem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

