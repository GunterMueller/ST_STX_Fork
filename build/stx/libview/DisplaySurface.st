"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2015 Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

GraphicsMedium subclass:#DisplaySurface
	instanceVariableNames:'viewBackground cursor eventMask moreAttributes renderer uuid
		backed flags delegate updateRegion'
	classVariableNames:'GotExposeFlagMask SaveUnderFlagMask'
	poolDictionaries:''
	category:'Graphics-Support'
!

!DisplaySurface class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2015 Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
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
    this abstract class describes stuff common to any Window on a display
    device. i.e. RootWindow, TopWindows, PopUps and Subwindows.
    That is, they have a viewBackground, cursor etc. and especially events.
    A special feature is the delegate field, which allows key- and button
    events to be stolen from a view.
    If the delegate is non-nil, these events will be sent to it instead.
    So you can change a views behavior even if it was not initially designed
    for it. Also, controller functionality could be simulated using delegates.

    [instance variables:]

        viewBackground  <Color|Form|Image>      the view's background

        cursor          <Cursor>                the cursor

        eventMask                               mask specifying the enabled
                                                events.

        moreAttributes                          optional dictionary, allowing for more attributes
                                                to be store there
            fields:
                middleButtonMenu                a fix popup menu for the middle button.

                keyCommands                     not yet supported


        backed                                  one of #always, #whenMapped or #never
                                                corresponds to X's backing store mechanism.
                                                May be ignored by other devices.

        flags                                   flag bits

            saveUnder                               bit 1; 1 if saveunder store for
                                                            that view is enabled

            gotExpose                               bit 2; 1 if an expose/noExpose event arrived
                                                            (for exposure handling after a scroll)

       delegate                                for event delegation

    [see also:]
        DeviceWorkstation
        WindowGroup
        StandardSYstemView SimpleView View

    [author:]
        Claus Gittinger
"
! !

!DisplaySurface class methodsFor:'initialization'!

initialize
    SaveUnderFlagMask := 1.
    GotExposeFlagMask := 2.
! !

!DisplaySurface methodsFor:'accessing'!

addUpdateRectangle:newRectangle
    "return true, if the newRectangle is not already contained in the updateRegion
     (i.e. if it added any pixels to the region"

    |closure lastRect numRect lastTop lastBottom lastLeft lastRight
     newTop newBottom newLeft newRight|

    updateRegion isNil ifTrue:[
	updateRegion := OrderedCollection with:newRectangle.
	^ true
    ].
    (updateRegion contains:[:oldRectangle | (newRectangle isContainedIn:oldRectangle)]) ifTrue:[
	^ false.
    ].

    numRect := updateRegion size.
    numRect > 20 ifTrue:[
	closure := updateRegion
			inject:newRectangle
			into:[:boundsSoFar :thisRectangle |
				boundsSoFar quickMerge:thisRectangle
			     ].
	updateRegion := OrderedCollection with:closure.
	^ true
    ].

    lastRect := updateRegion at:numRect.
    lastTop := lastRect top.
    lastBottom := lastRect bottom.
    lastLeft := lastRect left.
    lastRight := lastRect right.
    newTop := newRectangle top.
    newBottom := newRectangle bottom.
    newLeft := newRectangle left.
    newRight := newRectangle right.

    lastTop = newTop ifTrue:[
	lastBottom = newBottom ifTrue:[
	    lastLeft <= newLeft ifTrue:[
		lastRight >= newLeft ifTrue:[
		    updateRegion at:numRect put:(lastRect copy right:newRight).
		    ^ false "/ true
		]
	    ]
	].
    ].
    lastLeft = newLeft ifTrue:[
	lastRight = newRight ifTrue:[
	    lastTop <= newTop ifTrue:[
		lastBottom >= newTop ifTrue:[
		    updateRegion at:numRect put:(lastRect copy bottom:newBottom).
		    ^ false "/ true
		]
	    ]
	].
    ].

    updateRegion add:newRectangle.
    ^ true
!

basicViewBackground:something
    "set the viewBackground to something, a color, image or form.
     The viewBackground is the color or pattern with which exposed
     regions are filled - do not confuse this with the drawing background
     color, which is used with opaque drawing."

    viewBackground ~~ something ifTrue:[
	viewBackground := something.
	self drawableId notNil ifTrue:[
	    self setViewBackground
	]
    ]
!

controller
    "return nil - I have no controller"

    ^ nil
!

depth
    "return the depth in pixels of the view.
     Notice, that this is currently the devices depth,
     but support for mixed depth views is being prepared.
     (especially useful on SGI, with 24bit view)"

    ^ device depth
!

insideColor:aColor
    "set the view's background color - ST-80 compatibility"

    self viewBackground:aColor.
    self background:aColor
!

keyboardMap
    "by default, use my devices standard mapping.
     However, subclasses may redefine this, to return their own
     keyboard map (for example a terminalView may want treat CTRL-C as regular key)"

    ^ device keyboardMap
!

renderer
    "warning: this is experimental and not yet implemented"
    ^ renderer
!

renderer:something
    "warning: this is experimental and not yet implemented"
    renderer := something.
!

sensor
    "I can only return a SynchronousWindowSensor,
     since I do not have a window group"

    ^ SynchronousWindowSensor new
!

setViewBackground
    "install the viewBackground for the receiver on the device"

    |id devBgPixmap bgPixmap w h colorMap
     pixmapDepth deviceDepth defBG|

    self drawableId notNil ifTrue:[
        viewBackground isColor ifTrue:[
	    viewBackground := viewBackground onDevice:device.
            id := viewBackground colorId.
            "
             a real color (i.e. one supported by the device) ?
            "
            id notNil ifTrue:[
		device setWindowBackground:id in:self drawableId.
                ^ self
            ].
            "
             no, a dithered one - must have a dither-pattern
             (which is ready for the device, since viewBackground
              is already assigned to the device)
            "
            bgPixmap := viewBackground ditherForm.
        ] ifFalse:[
            viewBackground notNil ifTrue:[
                viewBackground isViewBackground ifTrue:[
                    ^ self.
                ].

                "
                 assume, it can convert itself to a form
                "
		bgPixmap := viewBackground asFormOn:device.
                bgPixmap isNil ifTrue:[
                    "/ assume it knows how to draw itself
                    ^ self
                ].
            ].
        ].

        "
         must now have:
         a dithered color or bitmap or pixmap
        "
        bgPixmap isNil ifTrue:[
            'DisplaySurface [warning]: background not convertable - ignored' errorPrintCR.
            ^ self
        ].

        "/ if the device does not support background pixmaps,
        "/ set the backgroundColor to the default background.
        "/ this will avoid flicker in win32 systems,
        "/ since that background is drawn directly in the
        "/ devices expose event handling.
        "/ (in contrast, the pixmap filling is done by the
        "/ window itself in its expose event handler)

	(device supportsViewBackgroundPixmap:bgPixmap) ifFalse:[
            defBG := View defaultViewBackgroundColor.
            defBG isColor ifTrue:[
		defBG := defBG onDevice:device.
                id := defBG colorId.
                id notNil ifTrue:[
		    device setWindowBackground:id in:self drawableId.
                ].
            ].
            ^ self
        ].

        w := bgPixmap width.
        h := bgPixmap height.

        deviceDepth := self depth.
        pixmapDepth := bgPixmap depth.

        (pixmapDepth ~~ deviceDepth) ifTrue:[
            (pixmapDepth ~~ 1) ifTrue:[
                'DisplaySurface [warning]: Bad dither depth (must be one or devices depth)' errorPrintCR.
                ^ self
            ].

            "
             convert it into a deep form
            "
            colorMap := bgPixmap colorMap.
	    devBgPixmap := Form width:w height:h depth:deviceDepth onDevice:device.
            devBgPixmap isNil ifTrue:[
                'DisplaySurface [warning]: could not create a device form for viewBackground' infoPrintCR.
                ^ self
            ].
            devBgPixmap paint:(colorMap at:1).
            devBgPixmap fillRectangleX:0 y:0 width:w height:h.
            devBgPixmap foreground:(colorMap at:2) background:(colorMap at:1).
            devBgPixmap copyPlaneFrom:bgPixmap x:0 y:0 toX:0 y:0 width:w height:h.
            bgPixmap := devBgPixmap.
        ] ifFalse:[
            (pixmapDepth == 1) ifTrue:[
                "
                 although depth matches,
                 values in the dither are to be interpreted via the ditherForms
                 colormap, which is not always the same as blackpixel/whitepixel ...
                "
                colorMap := bgPixmap colorMap.
		(colorMap at:1) colorId == device whitepixel ifTrue:[
		    (colorMap at:2) colorId == device blackpixel ifTrue:[
                        "
                         ok, can use it
                        "
			device setWindowBackgroundPixmap:(bgPixmap id) in:self drawableId.
                        ^ self
                    ]
                ].

                "
                 no, must invert it
                "
		devBgPixmap := Form width:w height:h depth:deviceDepth onDevice:device.
                devBgPixmap paint:(colorMap at:2) on:(colorMap at:1).
                devBgPixmap copyPlaneFrom:bgPixmap x:0 y:0 toX:0 y:0 width:w height:h.
                bgPixmap := devBgPixmap.
            ]
        ].
	device setWindowBackgroundPixmap:(bgPixmap id) in:self drawableId.
    ]

    "Modified: / 23-01-2011 / 01:44:38 / cg"
!

updateRegion
    ^ updateRegion
!

updateRegion:something
    updateRegion := something.
!

viewBackground
    "return the viewBackground"

    ^ viewBackground
!

viewBackground:something
    "set the viewBackground to something, a color, image or form.
     The viewBackground is the color or pattern with which exposed
     regions are filled - do not confuse this with the drawing background
     color, which is used with opaque drawing."

    viewBackground ~~ something ifTrue:[
	self basicViewBackground:something
    ]
!

viewBackgroundAndClear:something
    "set the viewBackground to something, a color, image or form.
     and clear the View.
     The viewBackground is the color or pattern with which exposed
     regions are filled - do not confuse this with the drawing background
     color, which is used with opaque drawing."

    self viewBackground:something.
    self clearView.

    "Created: 27.4.1996 / 14:09:08 / cg"
!

viewGravity
    "return the view's gravity"

    ^ #NorthWest
!

viewOrigin
    "0@0 here, since by default we cannot be scrolled"

    ^ 0 @ 0
!

widget
    "ST-80 compatibility"

    ^ self
!

windowClass:classString name:nameString
    gc windowClass:classString name:nameString.
!

windowGroup
    "return nil - I have no windowGroup"

    ^ nil
!

windowName:aString
    gc windowName:aString.
! !

!DisplaySurface methodsFor:'accessing-cursor'!

cursor
    "return the view's cursor"

    ^ cursor
!

cursor:aCursor
    "set the view's cursor. This cursor will be automatically displayed whenever
     the mouse-pointer enters the receiver.
     Cursors are typically set at view creation time and left as installed."

    self cursor:aCursor now:true

    "
     |v|

     v := View new.
     v cursor:(Cursor wait).
     v open.
     [v shown] whileFalse:[Processor yield].
     [v shown] whileTrue:[
        (Delay forSeconds:1) wait.
        v cursor:(Cursor normal).
        (Delay forSeconds:1) wait.
        v cursor:(Cursor wait).
     ]
    "

    "Modified: 14.12.1995 / 21:28:14 / cg"
!

cursor:aCursor now:showImmediately
    "set the view's cursor. This cursor will be automatically displayed whenever
     the mouse-pointer enters the receiver.
     Cursors are typically set at view creation time and left as installed.
     The showImmediately parameter controls if the request is to be buffered,
     or enforced immediately. Under XWindows, that makes a performance difference if many
     cursors (a whole group) are set, because the setting involves an XServer round trip."

    aCursor notNil ifTrue:[
        (aCursor ~~ cursor) ifTrue:[
            cursor := aCursor.
            self drawableId notNil ifTrue:[
                self setCursor.
                (showImmediately and:[realized]) ifTrue:[
                    "flush, to make cursor immediately visible"
                    self flush
                ]
            ]
        ]
    ]

    "
     |v|

     v := View new.
     v cursor:(Cursor wait).
     v open.
     [v shown] whileFalse:[Processor yield].
     [v shown] whileTrue:[
        (Delay forSeconds:1) wait.
        v cursor:(Cursor normal).
        (Delay forSeconds:1) wait.
        v cursor:(Cursor wait).
     ]
    "

    "Created: 14.12.1995 / 21:28:00 / cg"
    "Modified: 28.3.1997 / 13:47:58 / cg"
!

setCursor
    |id|

    cursor isNil ifTrue:[ ^ self].
    cursor := cursor onDevice:device.
    cursor isNil ifTrue:[ ^ self].

    id := cursor id.
    id isNil ifTrue:[
	'DisplaySurface [warning]: nil cursorId ignored; shape=' errorPrint.
	cursor shape errorPrintCR.
	^ self.
    ].
    gc setCursorId:id .
!

withCursor:aCursor do:aBlock
    "evaluate aBlock showing aCursor until ready; then restore the old cursor
     and return the value as returned by aBlock.

     Notice, that this method only changes the cursor for a SINGLE (sub-)view.
     Most applications want to have the cursor changed in all of its views.
     Use 'aView windowGroup withCursor:do:' or 'aView topView withCursor:do:'
     to acomplish this."

    |savedCursor|

    cursor == aCursor ifTrue:[
        ^ aBlock value
    ].

    savedCursor := cursor.
    ^ [
        self cursor:aCursor now:true.
        aBlock value
    ] ensure:[
        self cursor:savedCursor now:true
    ]

    "Modified: 27.2.1997 / 17:20:43 / cg"
!

withExecuteCursorDo:aBlock
    "evaluate aBlock while showing an execute cursor in all my views.
     Return the value as returned by aBlock."

    ^ self withCursor:(Cursor execute) do:aBlock

    "Created: 10.1.1996 / 13:53:03 / cg"
!

withReadCursorDo:aBlock
    "evaluate aBlock while showing a readCursor in all my views.
     Return the value as returned by aBlock."

    ^ self withCursor:(Cursor read) do:aBlock

    "Modified: 14.12.1995 / 20:57:40 / cg"
    "Created: 10.1.1996 / 13:52:52 / cg"
!

withVisibleCursor:aCursor do:aBlock
    "evaluate aBlock, showing a aCursor.
     Return the value of aBlock.
     Ensure, that the cursor is visible for the user for a minimal amount of time
     (even if the computation would be too quick for a cursor to be visible,
      show the execute cursor for some time as a feedback)."

    |ret|

    cursor == aCursor ifTrue:[
	^ aBlock value
    ].

    self
	withCursor:aCursor do:[
	    |timeToExecute remainingShowTime|

	    timeToExecute := Time millisecondsToRun:[ ret := aBlock value].
	    remainingShowTime := UserPreferences current waitCursorVisibleTime - timeToExecute.
	    remainingShowTime > 0 ifTrue:[
		Delay waitForMilliseconds:remainingShowTime.
	    ].
	].
    ^ ret.

    "Modified (comment): / 12-09-2011 / 12:14:29 / cg"
!

withWaitCursorDo:aBlock
    "evaluate aBlock while showing a waitCursor in all my views.
     Return the value as returned by aBlock."

    ^ self withCursor:(Cursor wait) do:aBlock

    "Created: 10.1.1996 / 13:51:08 / cg"
!

withWriteCursorDo:aBlock
    "evaluate aBlock while showing a writeCursor in all my views.
     Return the value as returned by aBlock."

    ^ self withCursor:(Cursor write) do:aBlock

    "Modified: / 14-12-1995 / 20:57:40 / cg"
    "Created: / 27-07-2012 / 09:43:08 / cg"
! !

!DisplaySurface methodsFor:'accessing-hierarchy'!

delegate
    "return the delegate - that's the one getting keyboard and button events.
     See dispatchEvent:... method"

    ^ delegate
!

delegate:someOne
    "set the delegate - keyboard- and button events will be forwarded to
     that object if it is interested in them.
     See the dispatchEvent... method."

    delegate := someOne
!

superView
    "return the superView - nil here"

    ^ nil
!

topComponent
    "return the topView - that the one with no superview"

    ^ self

    "Created: 9.5.1996 / 01:39:43 / cg"
!

topView
    "return the topView - that's the one with no superview"

    ^ self
! !

!DisplaySurface methodsFor:'accessing-limits'!

maxExtent
    "return the view's maximum extent - this is nil here.
     Only standardSystemViews support this."

    ^ nil
!

maxExtent:extent
    "set the view's maximum extent - ignored here.
     Only standardSystemViews support this."

    ^ self
!

minExtent
    "return the view's minimum extent - this is nil here.
     Only standardSystemViews support this."

    ^ nil
!

minExtent:extent
    "set the view's minimum extent - ignored here.
     Only standardSystemViews support this."

    ^ self
! !

!DisplaySurface methodsFor:'accessing-misc'!

backingStore:how
    "turn on/off backingStore (saving my pixels)
     how may true/false, but also #always, #whenMapped or #never."

    how ~~ backed ifTrue:[
	backed := how.
	super backingStore:how.
    ]
!

eventMask
    "return a (numeric) mask of allowed events -
     this is X-specific and will be removed / replaced by symbolic values)"

    ^ eventMask
!

eventMask:aMask
    "set a (numeric) mask of allowed events -
     this is X-specific and will be removed / replaced by symbolic values)"

    eventMask := aMask
!

getKeyboardFocus
    "tell the Display to assign keyboard focus to the receiver"

    self shown ifTrue:[
	device setInputFocusTo:self drawableId.
    ].

    "Modified: / 15.3.1999 / 08:25:10 / cg"
!

isInputOnly
    "return true, if the receiver is an input only view - that is:
     the view will realize as a transparent view, into which you cannot
     draw, but get events as usual. Thich can be used to catch events away from
     others, which where never meant to work in such a setup.
     (for example, if you want to manipulate views in some DrawTool-like manner).
     This uses a special X feature, which might not be supported in the near future
     or on other plattforms."

    ^ false

    "Created: 1.6.1996 / 13:21:51 / cg"
!

preferredDepth
    "return a non nil integer, if a specific depth is wanted in this view.
     Return nil if we do not care (i.e. the displays default is wanted).
     This is experimental and may change/vanish - do not use it."

    ^ nil
!

preferredVisual
    "return a non nil id, if a specific visual is wanted in this view.
     Return nil if we do not care (i.e. the displays default is wanted).
     This is experimental and may change/vanish - do not use it."

    ^ nil
!

saveUnder
    "return the saveUnder flag"

    ^ flags bitTest:SaveUnderFlagMask
!

saveUnder:aBoolean
    "turn on/off saveUnder (saving pixels under myself)
     - used for temporary views (i.e. PopUps and ModalBoxes)"

    aBoolean ifTrue:[
	flags := flags bitOr:SaveUnderFlagMask.
    ] ifFalse:[
	flags := flags bitClear:SaveUnderFlagMask.
    ].
    gc saveUnder:aBoolean.
!

setPointerPosition:aRelativePoint
    "set the pointer to aRelativePoint relative to the view's origin"

    device setPointerPosition:aRelativePoint in:self drawableId.

    "
	Transcript setPointerPosition:Transcript extent // 2.
	Screen current rootView setPointerPosition:100@100.
    "
! !

!DisplaySurface methodsFor:'accessing-names'!

icon
    "return the view's icon - this is nil here.
     Only standardSystemViews support labels and icons."

    ^ nil
!

icon:aBitmap
    "set the view's icon - ignored here.
     Only standardSystemViews support labels and icons."

    ^ self
!

iconLabel
    "return the view's icon label - this is nil here.
     Only standardSystemViews support labels and icons."

    ^ nil
!

iconLabel:aLabel
    "set the view's icon label - ignored here.
     Only standardSystemViews support labels and icons."

    ^ self
!

iconMask
    "return the view's iconMask - this is nil here.
     Only standardSystemViews may support labels and icons."

    ^ nil
!

iconView
    "return the view's iconView - this is nil here.
     Only standardSystemViews support labels and icons."

    ^ nil
!

iconView:aView
    "set the view's icon view - ignored here.
     Only standardSystemViews support labels and icons."

    ^ self
!

label
    "return the view's label - this is nil here.
     Only standardSystemViews support labels and icons."

    ^ nil
!

label:aLabel
    "set the view's label - ignored here.
     Only standardSystemViews support labels and icons."

    ^ self
! !

!DisplaySurface methodsFor:'accessing-private'!

clearGotExposeFlag
    "internal; used to wait for an expose-event after a scroll operation"

    flags := flags bitClear:GotExposeFlagMask.
!

getAttribute:key
    "a place for additional attributes;
     allows for non-instvar slots to be added"
     
    moreAttributes isNil ifTrue:[ ^ nil].
    ^ moreAttributes at:key ifAbsent:nil.
!

gotExpose
    "internal; used to wait for an expose-event after a scroll operation"

    ^ flags bitTest:GotExposeFlagMask.
!

setAttribute:key to:newValue
    "a place for additional attributes;
     allows for non-instvar slots to be added"

    newValue isNil ifTrue:[
        moreAttributes notNil ifTrue:[
            moreAttributes removeKey:key ifAbsent:[].
            moreAttributes := moreAttributes asNilIfEmpty
        ]
    ] ifFalse:[
        moreAttributes isNil ifTrue:[
            moreAttributes := IdentityDictionary new.
        ].
        moreAttributes at:key put:newValue.
    ].
!

setGotExposeFlag
    "internal; used to wait for an expose-event after a scroll operation"

    flags := flags bitOr:GotExposeFlagMask.
! !


!DisplaySurface methodsFor:'button menus'!

getMiddleButtonMenu
    "return the menu associated with the middle mouse button.
     This is a possibly obsolete hook for views which do not define their own menu,
     but are configured from the outside. Nowadays, widgets provide their own menu
     or are configured using a menuHolder."

    ^ self getAttribute:#middleButtonMenu

    "Created: / 07-07-2011 / 18:16:21 / cg"
!

middleButtonMenu
    "return the menu associated with the middle mouse button.
     Here, return a hooked on menu, but usually redefined to provide a widget-specific
     menu."

    ^ self getMiddleButtonMenu

    "Modified (comment): / 07-07-2011 / 18:18:28 / cg"
!

middleButtonMenu:aMenu
    "associate aMenu with the middle mouse button.
     This is a possibly obsolete hook for views which do not define their own menu,
     but are configured from the outside. Nowadays, widgets provide their own menu
     or are configured using a menuHolder."

    |oldMenu|

    (oldMenu := self getMiddleButtonMenu) notNil ifTrue:[
	oldMenu isArray ifFalse:[
	    oldMenu destroy
	]
    ].
    self setMiddleButtonMenu:aMenu

    "Modified: / 07-07-2011 / 18:18:00 / cg"
!

setMiddleButtonMenu:aMenu
    "associate aMenu with the middle mouse button.
     Do not destroy the old menu if any"

    self setAttribute:#middleButtonMenu to:aMenu
! !

!DisplaySurface methodsFor:'clipboard'!

getClipboardObject
    "return the object selection
     - either the local one, or the displays clipBoard buffer."

    ^ device getClipboardObjectFor:self drawableId.

    "Modified: 13.2.1997 / 13:18:50 / cg"
!

getClipboardText
    "return the copyBuffers contents
     - either the local one, or the displays clipBoard buffer."

    ^ self getClipboardText:#clipboard
!

getClipboardText:selectionBufferSymbol
    "return the text selection - either the local one, or one of the displays
     clipBoard buffers determined by selectionBufferSymbol, which should be one of:
	#clipboard
     or:
	#selection.

     Return aString or nil if there is no selection"

    ^ device getClipboardText:selectionBufferSymbol for:self drawableId.
!

getSelection
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #getClipboardObject'.
    ^ self getClipboardObject
!

getTextSelection
    "return the copyBuffers contents
     - either the local one, or the displays clipBoard buffer."

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #getClipboardText'.
    ^ self getClipboardText
!

getTextSelection:selectionBufferSymbol
    "return the text selection - either the local one, or one of the displays
     clipBoard buffers determined by selectionBufferSymbol, which should be one of:
	#clipboard
     or:
	#selection.

     Return aString or nil if there is no selection"

    <resource: #obsolete>

    self obsoleteMethodWarning:'#use getClipboardText:'.
    ^ self getClipboardText:selectionBufferSymbol
!

setClipboardObject:something
    "set the object selection - both the local one, and tell the display
     that we have changed it (i.e. place it into the clipBoard)."

    device setClipboardObject:something ownerView:self.
!

setClipboardText:aString
    "set the text selection - both the local one, and tell the display
     that we have changed it (i.e. place it into the clipBoard)."

    device setClipboardText:aString ownerView:self

    "Modified (format): / 21-11-2016 / 23:36:59 / cg"
!

setSelection:something
    "set the object selection - both the local one, and tell the display
     that we have changed it (i.e. place it into the clipBoard)."

    <resource: #obsolete>

    self obsoleteMethodWarning:'use setClipboardObject:'.
    device setClipboardObject:something ownerView:self.
!

setTextSelection:something
    "set the text selection - both the local one, and tell the display
     that we have changed it (i.e. place it into the clipBoard)."

    <resource: #obsolete>

    self obsoleteMethodWarning:'use setClipboardText:'.
    device setClipboardText:something ownerView:self
! !

!DisplaySurface methodsFor:'drawing'!

clearDeviceRectangleX:x y:y width:w height:h
    "clear a rectangular area to viewBackground -
     redefined since GraphicsMedium fills with background
     - not viewBackground as we want here."

    |oldPaint org patternOffsetX patternOffsetY|

    (w <= 0 or:[h <= 0]) ifTrue:[^ self].
    
    gc isNil ifTrue:[
        "nothing to clear"
        ^ self.
    ].
    viewBackground isNil ifTrue:[^ self]. "/ how can this happen?

    viewBackground isColor ifFalse:[
        viewBackground isViewBackground ifTrue:[
            oldPaint := self paint.
            self 
                paint:gc background;
                fillDeviceRectangleX:x y:y width:w height:h;
                paint:oldPaint.
            viewBackground fillRectangleX:x y:y width:w height:h in:self.
            ^ self.
        ].

        org := self viewOrigin.
        (device supportsMaskedDrawingWith:viewBackground) ifFalse:[
            "/ hand-fill: the device cannot draw with a bitmap pattern underneath.
            self fillDeviceRectangleWithPattern:viewBackground x:x y:y width:w height:h patternOffset:org.
            ^ self.
        ].

        patternOffsetX := (org x rounded \\ viewBackground width).
        patternOffsetY := (org y rounded \\ viewBackground height).
        (patternOffsetX ~= 0 or:[patternOffsetY ~= 0]) ifTrue:[
            (device supportsMaskedDrawingWithOffset:viewBackground) ifFalse:[
                "/ hand-fill: the device cannot draw with a shifted bitmap pattern underneath.
                self fillDeviceRectangleWithPattern:viewBackground x:x y:y width:w height:h patternOffset:org.
                ^ self.
            ].
        ].
        gc setDeviceMaskOriginX:patternOffsetX negated y:patternOffsetY negated.
    ].

    "
     fill in device coordinates - not logical coordinates
    "
    oldPaint := self paint.
    self 
        paint:viewBackground;
        fillDeviceRectangleX:x y:y width:w height:h "with:viewBackground";
        paint:oldPaint.

    "Modified: / 4.5.1999 / 13:00:34 / cg"
!

clearRectangleX:x y:y width:w height:h
    "clear a rectangular area to viewBackground -
     redefined since GraphicsMedium fills with background
     - not viewBackground as we want here."

    |pX pY pW pH currentTransformation|

    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
        pX := currentTransformation applyToX:x.
        pY := currentTransformation applyToY:y.
        pW := currentTransformation applyScaleX:w.
        pH := currentTransformation applyScaleY:h.
    ] ifFalse:[
        pX := x.
        pY := y.
        pW := w.
        pH := h.
    ].

    ^ self clearDeviceRectangleX:pX rounded y:pY rounded width:pW ceiling height:pH ceiling.

    "Modified: / 30.10.1998 / 15:00:37 / cg"
!

fillDeviceRectangleWithPattern:aPixmap x:xIn y:yIn width:wIn height:hIn patternOffset:pattOffs
    "Fill a rectangular area with some pattern.
     Caller must ensure that aPixmap is really a form.
     CG: mhm it seems that XQuartz has a bug and also has problems doing this.
         therefore it is actually not obsolete."

    |r b
     pW "{ Class: SmallInteger }"
     pH "{ Class: SmallInteger }"
     xR0
     xR "{ Class: SmallInteger }"
     yR "{ Class: SmallInteger }"
     xE "{ Class: SmallInteger }"
     yE "{ Class: SmallInteger }"
     oldFg oldBg oldClip x y w h fg bg clrMap
     offsX "{ Class: SmallInteger }"
     offsY "{ Class: SmallInteger }"
     oX "{ Class: SmallInteger }"
     oY "{ Class: SmallInteger }"|

    x := xIn.
    y := yIn.
    w := wIn.
    h := hIn.

    x := x max:0.
    y := y max:0.
    r := (xIn + w) min:width.
    b := (yIn + h) min:height.

    pW := aPixmap width.
    pH := aPixmap height.

    oldClip := gc deviceClippingBoundsOrNil.
    oldClip notNil ifTrue:[
        x := x max:oldClip left.
        y := y max:oldClip top.
        r := r min:oldClip right.
        b := b min:oldClip bottom.
    ].
    w := r-x.
    h := b-y.

    yR := (y // pH) * pH.
    yE := y+h.

    yR >= yE ifTrue:[^ self].

    xR0 := (x // pW) * pW.
    xE := x+w.

    xR0 >= xE ifTrue:[^ self].

    aPixmap depth == 1 ifTrue:[
        oldFg := gc foreground.
        oldBg := gc background.
        (clrMap := aPixmap colorMap) notNil ifTrue:[
            bg := clrMap at:1.
            fg := clrMap at:2.
        ] ifFalse:[
            bg := self whiteColor.
            fg := self blackColor.
        ].
        gc foreground:fg background:bg.
    ].
    self deviceClippingBounds:(Rectangle left:x top:y width:w height:h).

    offsX := (xR0 + pattOffs x) \\ pW.
    offsY := (yR + pattOffs y) \\ pH.

    oY := offsY.
    [yR < yE] whileTrue:[
        xR := xR0.
        oX := offsX.
        [xR < xE] whileTrue:[
            self
                copyFrom:aPixmap
                x:oX y:oY
                toX:xR y:yR
                width:(pW - oX) height:(pH - oY)
                async:true.
            xR := xR + pW - oX.
            oX := 0.
        ].
        yR := yR + pH - oY.
        oY := 0.
    ].

    oldFg notNil ifTrue:[
        gc foreground:oldFg background:oldBg.
    ].
    gc deviceClippingBounds:oldClip.

    "Created: / 06-09-1998 / 14:00:50 / cg"
    "Modified: / 04-05-1999 / 20:38:07 / ps"
    "Modified: / 04-05-1999 / 20:40:12 / cg"
    "Modified: / 09-01-2017 / 23:20:58 / jv"
!

fillRectangleWithPattern:aPixmap x:x y:y width:w height:h patternOffset:pattOffs
    "Fill a rectangular area with aPixmap.
     Caller must ensure that the aPixmap is really a form.
     CG: mhm it seems that XQuartz has a bug and also has problems doing this.
         therefore it is actually not obsolete."

    |pX pY nW nH currentTransformation|

    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
        pX := currentTransformation applyToX:x.
        pY := currentTransformation applyToY:y.
        nW := currentTransformation applyScaleX:w.
        nH := currentTransformation applyScaleY:h.
        nW < 0 ifTrue:[
              nW := nW abs.
              pX := pX - nW.
        ].
        nH < 0 ifTrue:[
              nH := nH abs.
              pY := pY - nH.
        ].
    ] ifFalse:[
        pX := x.
        pY := y.
        nW := w.
        nH := h.
    ].
    pX := pX rounded.
    pY := pY rounded.
    nW := nW rounded.
    nH := nH rounded.

    self
        fillDeviceRectangleWithPattern:aPixmap
        x:pX y:pY width:nW height:nH
        patternOffset:pattOffs

    "Modified: 4.6.1996 / 17:58:49 / cg"
!

redraw
    "nothing done here"
    ^ self
! !

!DisplaySurface methodsFor:'enable/disable events'!

compressMotionEvents:aBoolean
    "enable/disable motion event compression
     (i.e. replacing all motion events by the last one).
     Compression makes almost always sense, except when
     doing things like freehand drawing"

    |windowGroup|

    windowGroup := self windowGroup.
    windowGroup notNil ifTrue:[
	windowGroup sensor compressMotionEvents:aBoolean.
    ].
!

disableButtonEvents
    "disable all button events"

    self disableEvent:#buttonPress; disableEvent:#buttonRelease

    "Modified: 29.4.1996 / 11:09:25 / cg"
!

disableButtonMotionEvents
    "disable button motion-while-button-is-pressed events"

    self disableEvent:#buttonMotion
!

disableButtonPressEvents
    "disable button press events"

    self disableEvent:#buttonPress
!

disableButtonReleaseEvents
    "disable button release events"

    self disableEvent:#buttonRelease
!

disableEnterLeaveEvents
    "disable both mouse-pointer enter and leave events"

    self disableEvent:#enter; disableEvent:#leave

    "Modified: 29.4.1996 / 11:09:37 / cg"
!

disableEvent:anEventSymbol
    "disable an event -
     this is a private (internal) method not to be used externally.
     for a list of allowed event symbols see Workstation class"

    eventMask := eventMask bitAnd:(device eventMaskFor:anEventSymbol) bitInvert.
    self drawableId notNil ifTrue:[
	device setEventMask:eventMask in:self drawableId
    ]
!

disableMotionEvents
    "disable mouse-pointer motion events"

    self disableEvent:#pointerMotion
!

enableButtonEvents
    "enable both mouse button press and release events.
     These are enabled by default anyway."

    self enableEvent:#buttonPress; enableEvent:#buttonRelease

    "Modified: 29.4.1996 / 11:09:46 / cg"
!

enableButtonMotionEvents
    "enable mouse-pointer motion-while-button-is-pressed events.
     These are enabled by default anyway."

    self enableEvent:#buttonMotion
!

enableButtonPressEvents
    "enable mouse button press events.
     These are enabled by default anyway."

    self enableEvent:#buttonPress
!

enableButtonReleaseEvents
    "enable mouse button release events.
     These are enabled by default anyway."

    self enableEvent:#buttonRelease
!

enableEnterEvents
    "enable mouse-pointer enter events"

    self enableEvent:#enter
!

enableEnterLeaveEvents
    "enable both mouse-pointer enter and leave events"

    self enableEvent:#enter; enableEvent:#leave

    "Modified: 29.4.1996 / 11:09:55 / cg"
!

enableEvent:anEventSymbol
    "enable an event -
     this is a private (internal) method not to be used externally.
     for a list of allowed event symbols see Workstation class"

    eventMask := (eventMask ? 0) bitOr:(device eventMaskFor:anEventSymbol).
    self drawableId notNil ifTrue:[
	device setEventMask:eventMask in:self drawableId
    ]
!

enableFocusEvents
    "enable keyboard focus change events"

    self enableEvent:#focusChange
!

enableKeyEvents
    "this is a compatibility leftover -
     starting with 2.10.3, keyPress is always enabled to allow
     ^C processing."

!

enableKeyPressEvents
    "this is a compatibility leftover -
     starting with 2.10.3, keyPress is always enabled to allow
     ^C processing."

!

enableKeyReleaseEvents
    "enable key release events"

    self enableEvent:#keyRelease
!

enableLeaveEvents
    "enable mouse-pointer leave events"

    self enableEvent:#leave
!

enableMotionEvents
    "enable mouse-pointer motion events (those without a pressed button)"

    self enableEvent:#pointerMotion
! !

!DisplaySurface methodsFor:'event dispatching'!

dispatchEvent:event
    "dispatch an event"

    ^ self
	dispatchEvent:event
	withFocusOn:nil
	delegate:true

    "Modified: / 20.5.1998 / 23:01:15 / cg"
!

dispatchEvent:type arguments:arguments
    "dispatch an event"

    "/ XXXX: TO BE ELIMINATED
    ^ self
	dispatchEvent:nil
	type:type
	arguments:arguments
	withFocusOn:nil
	delegate:true

    "Modified: / 20.5.1998 / 22:50:31 / cg"
!

dispatchEvent:ev type:type arguments:argArray withFocusOn:focusView delegate:doDelegate
    "dispatch the event represented by type and arguments either to my delegate,
     or to my controller (which may be myself, if I implement the controller functionality myself).
     If focusView is nonNil, and it is a keyboard event, it is forwarded to this
     view (but not if there was a delegate in the first place).

     If doDelegate is true, keyboard and button events are forwarded to a
     delegate object (if non-nil). DoDelegate may be passed as true, to
     handle events which are already delegated.
     If there is a delegate, only messages which are understood by it are
     forwarded. Also, the delegate is asked if it is willing to handle the event
     before.
     Delegated messages get the original view as an extra argument.
     Delegation has higher priority than both controller or focusView
     forwarding."

    |delegate selector delegateMessage delegateQuery
     eventReceiver controller deviceMessage
     isKeyEvent isButtonEvent isMouseWheelEvent isPointerEvent isExposeEvent

     rect x y w h delegatedEvent rgn|

    type == #damage ifTrue:[
        "/ OLDdamage scheme - this will vanish
        self shown ifTrue:[
            rect := argArray.
            x := rect left.
            y := rect top.
            w := rect width.
            h := rect height.
            gc transformation notNil ifTrue:[
                self deviceExposeX:x y:y width:w height:h
            ] ifFalse:[
                self exposeX:x y:y width:w height:h
            ]
        ].
        ^ self
    ].

    type == #newDamage ifTrue:[
        "/ New damage scheme
        rgn := updateRegion.
        updateRegion := nil.
        self shown ifTrue:[
            rgn notNil ifTrue:[
                rgn do:[:rect |
                    "/ cg: I think the check for being realized may not be enough;
                    "/ there is a race here, if the view gets closed, while in the loop...
                    realized ifTrue:[
                        x := rect left.
                        y := rect top.
                        w := rect width.
                        h := rect height.
                        gc transformation notNil ifTrue:[
                            self deviceExposeX:x y:y width:w height:h
                        ] ifFalse:[
                            self exposeX:x y:y width:w height:h
                        ]
                    ]
                ]
            ]
        ].
        ^ self
    ].

    isKeyEvent := isButtonEvent := isPointerEvent := isMouseWheelEvent := isExposeEvent := false.

    (type == #'keyPress:x:y:') ifTrue:[
        isKeyEvent := true.
        deviceMessage := #'deviceKeyPress:x:y:'.
        delegateMessage := #'keyPress:x:y:view:'.
        delegateQuery := #'handlesKeyPress:inView:'.
    ] ifFalse:[ (type == #'keyRelease:x:y:') ifTrue:[
        isKeyEvent := true.
        deviceMessage := #'deviceKeyRelease:x:y:'.
        delegateMessage := #'keyRelease:x:y:view:'.
        delegateQuery := #'handlesKeyRelease:inView:'.
    ] ifFalse:[ (type == #'buttonMotion:x:y:') ifTrue:[
        isButtonEvent := true.
        deviceMessage := #'deviceButtonMotion:x:y:'.
        delegateMessage := #'buttonMotion:x:y:view:'.
        delegateQuery := #'handlesButtonMotion:inView:'.
    ] ifFalse:[ (type == #'buttonPress:x:y:') ifTrue:[
        isButtonEvent := true.
        deviceMessage := #'deviceButtonPress:x:y:'.
        delegateMessage := #'buttonPress:x:y:view:'.
        delegateQuery := #'handlesButtonPress:inView:'.
    ] ifFalse:[ (type == #'buttonRelease:x:y:') ifTrue:[
        isButtonEvent := true.
        deviceMessage := #'deviceButtonRelease:x:y:'.
        delegateMessage := #'buttonRelease:x:y:view:'.
        delegateQuery := #'handlesButtonRelease:inView:'.
    ] ifFalse:[ (type == #'buttonShiftPress:x:y:') ifTrue:[
        isButtonEvent := true.
        deviceMessage := #'deviceButtonShiftPress:x:y:'.
        delegateMessage := #'buttonShiftPress:x:y:view:'.
        delegateQuery := #'handlesButtonShiftPress:inView:'.
    ] ifFalse:[ (type == #'buttonMultiPress:x:y:') ifTrue:[
        isButtonEvent := true.
        deviceMessage := #'deviceButtonMultiPress:x:y:'.
        delegateMessage := #'buttonMultiPress:x:y:view:'.
        delegateQuery := #'handlesButtonMultiPress:inView:'.
    ] ifFalse:[ (type == #mouseWheelMotion:x:y:amount:deltaTime:) ifTrue:[
        isMouseWheelEvent := true.
        deviceMessage := type.
        delegateMessage := #mouseWheelMotion:x:y:amount:deltaTime:view:.
        delegateQuery := #handlesMouseWheelMotion:inView:.
    ] ifFalse:[ (type == #'pointerEnter:x:y:') ifTrue:[
        isPointerEvent := true.
        deviceMessage := #'devicePointerEnter:x:y:'.
        delegateMessage := #'pointerEnter:x:y:view:'.
        delegateQuery := #'handlesPointerEnter:inView:'.
    ] ifFalse:[ (type == #'pointerLeave:') ifTrue:[
        isPointerEvent := true.
        deviceMessage := type.
        delegateMessage := #'pointerLeave:view:'.
        delegateQuery := #'handlesPointerLeave:inView:'.
    ] ifFalse:[ (type == #'exposeX:y:width:height:') ifTrue:[
        isExposeEvent := true.
        deviceMessage := #'deviceExposeX:y:width:height:'.
    ] ifFalse:[ (type == #'graphicsExposeX:y:width:height:final:') ifTrue:[
        isExposeEvent := true.
        deviceMessage := #'deviceGraphicsExposeX:y:width:height:final:'.
    ]]]]]]]]]]]].

    "
     if there is a focusView, and its a keyboard event, pass it
     to that view (or its controller, or its delegate).
     In this case, a coordinate which is outside of
     the focusView (0 @ 0) is passed as x/y coordinates.
    "
    ((isKeyEvent "or:[isMouseWheelEvent]")
    and:[focusView notNil and:[self ~~ focusView]]) ifTrue:[
        delegatedEvent := ev shallowCopy.
        delegatedEvent delegatedFrom:ev.
        delegatedEvent arguments:(ev arguments shallowCopy).
        delegatedEvent x:-1; y:-1.

        focusView
            dispatchEvent:delegatedEvent
            withFocusOn:nil
            delegate:doDelegate.
        ^ self
    ].

    doDelegate ifTrue:[
        "
         handle delegated messages
        "
        (isKeyEvent
         or:[isButtonEvent
         or:[isMouseWheelEvent
         or:[isPointerEvent]]]) ifTrue:[
            delegate := self delegate.

            "
             what a kludge - sending to delegate requires
             another selector and an additional argument ...
            "
            (delegate notNil) ifTrue:[
                "
                 is the delegate interested in that event ?
                 (if it does not respond to the handlesXXX message, assume: NO)
                "
                (delegate askFor:delegateQuery with:(argArray at:1) with:self) ifTrue:[
                    "
                     mhmh ... have to convert to logical coordinates
                    "
                    |currentTransformation|

                    currentTransformation := gc transformation.
                    currentTransformation notNil ifTrue:[
                        argArray size > 2 ifTrue:[
                            argArray at:2 put:(currentTransformation applyInverseToX:(argArray at:2)).
                            argArray at:3 put:(currentTransformation applyInverseToY:(argArray at:3)).
                        ].
                    ].
                    argArray isNil ifTrue:[
                        delegate perform:delegateMessage with:self
                    ] ifFalse:[
                        delegate perform:delegateMessage withArguments:(argArray copyWith:self)
                    ].
                    ^ self
                ]
            ].
        ].
    ].

    "
     if I am not shown, ignore input events
    "
    (isKeyEvent
     or:[isButtonEvent
     or:[isMouseWheelEvent
     or:[isPointerEvent]]]) ifTrue:[
        realized ifFalse:[
            ^ self
        ]
    ].

    "
     if there is a controller, that one gets all user events
    "
    eventReceiver := self.
    (controller := self controller) notNil ifTrue:[
        (isKeyEvent
         or:[isButtonEvent
         or:[isMouseWheelEvent
         or:[isPointerEvent
         or:[(type == #focusIn)
         or:[(type == #focusOut)]]]]]) ifTrue:[
            eventReceiver := controller.
        ]
    ].

    "
     finally, another one:
     if I have a transformation, edit the selector from #foo to #deviceFoo...
     This allows for the event to be handled either in device or
     logical coordinates. (since the deviceFoo-messages default implementation
     in DisplaySurface translates and resends).
     Actually, I could always send deviceXXX without speed penalty
     (event sending is no high frequency operation), but that just adds
     another context to any debuggers walkback, making things less clear.
    "
    selector := type.

        (isKeyEvent
         or:[isButtonEvent
         or:[isMouseWheelEvent
         or:[isPointerEvent
         or:[isExposeEvent]]]]) ifTrue:[
        gc transformation notNil ifTrue:[
            selector := deviceMessage
        ]
    ].

    eventReceiver perform:selector withArguments:argArray

    "Created: / 20.5.1998 / 22:46:25 / cg"
    "Modified: / 21.5.1999 / 19:55:31 / cg"
!

dispatchEvent:event withFocusOn:focusViewOrNil
    "dispatch the event"

    ^ self
	dispatchEvent:event
	withFocusOn:focusViewOrNil
	delegate:true

    "Modified: / 20.5.1998 / 23:01:15 / cg"
!

dispatchEvent:event withFocusOn:focusViewOrNil delegate:doDelegate
    "dispatch the event"

    ^ self
	dispatchEvent:event
	type:event type
	arguments:(event arguments)
	withFocusOn:focusViewOrNil
	delegate:doDelegate

    "Modified: / 20.5.1998 / 23:01:15 / cg"
! !

!DisplaySurface methodsFor:'event handling'!

activateMenu
    "if there is a menu, show it."

    |menu|

    (menu := self middleButtonMenu) notNil ifTrue:[
	menu isArray ifTrue:[
	    "/ a spec array
	    menu := menu decodeAsLiteralArray.
	    menu receiver:self.
	].
	menu showAtPointer
    ]

    "Created: 1.3.1996 / 13:24:55 / cg"
!

buttonMotion:state x:x y:y
    "mouse was moved while button is pressed - do nothing here"

    ^ self
!

buttonMultiPress:button x:x y:y
    "button was pressed fast after previous press - default to press-again"

    ^ self buttonPress:button x:x y:y
!

buttonPress:button x:x y:y
    "button was pressed - if its middle button and there is a menu, show it."

    (button == 2) ifTrue:[
	UserPreferences current showRightButtonMenuOnRelease ifFalse:[
	    self activateMenu.
	].
    ]

    "Modified: 1.3.1996 / 13:25:07 / cg"
!

buttonRelease:button x:x y:y
    (button == 2) ifTrue:[
	UserPreferences current showRightButtonMenuOnRelease ifTrue:[
	    self activateMenu.
	].
    ].
!

catchExpose
    "this MUST be sent BEFORE doing a bit-blt copy (i.e. copyFrom...),
     to tell the sensor that incoming expose events are to be remembered.
     Sometime after the bit-blt, waitForExpose should be sent, to finally
     suspend until the expose/noExpose event arrives.
     This is an X speciality - for devices which do not need this kind of
     asynchronous bit-blt confirmation, this is a noop.
     Answer true if the sender is reqired to do a waitForExpose, false if not.
    "

    |wg|

    device scrollsAsynchronous ifFalse:[
        self setGotExposeFlag.
        ^ false
    ].

    self setGraphicsExposures:true.

    self clearGotExposeFlag.
    wg := self windowGroup.
    wg notNil ifTrue:[
        "
         must process eny pending expose events, since
         usually the origin is changed soon so that previous
         expose events coordinates are invalid
        "
        wg processRealExposeEventsFor:self.
        wg sensor catchExposeFor:self.
        ^ true
    ].
    ^ false.

    "Modified: 6.8.1997 / 19:50:15 / cg"
!

coveredBy:aView
    "the receiver has been covered by another view;
     we are not interested in that here (but see modalBox for more)."
!

deviceButtonMotion:state x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a #buttonMotion with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonMotion:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	].
    ].
    self buttonMotion:state x:lx y:ly

    "Modified: 20.5.1996 / 17:45:25 / cg"
    "Modified: 14.10.1996 / 22:25:12 / stefan"
!

deviceButtonMultiPress:butt x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonMultiPress with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonMultiPress:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	].
    ].
    self buttonMultiPress:butt x:lx y:ly

    "Modified: 20.5.1996 / 17:45:22 / cg"
    "Modified: 14.10.1996 / 22:25:22 / stefan"
!

deviceButtonPress:butt x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonPress with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonPress:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	].
    ].
    self buttonPress:butt x:lx y:ly

    "Modified: 20.5.1996 / 17:45:18 / cg"
    "Modified: 14.10.1996 / 22:25:30 / stefan"
!

deviceButtonRelease:butt x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonRelease with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonRelease:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	].
    ].
    self buttonRelease:butt x:lx y:ly

    "Modified: 20.5.1996 / 17:45:14 / cg"
    "Modified: 14.10.1996 / 22:25:37 / stefan"
!

deviceButtonShiftPress:butt x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonShiftPress with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonShiftPress:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	].
    ].
    self buttonShiftPress:butt x:lx y:ly

    "Modified: 20.5.1996 / 17:45:09 / cg"
    "Modified: 14.10.1996 / 22:25:49 / stefan"
!

deviceExposeX:x y:y width:w height:h
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send an expose with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #exposeX:x:y:width:height:"

    |lx ly lw lh currentTransformation|

    lx := x.
    ly := y.
    lw := w.
    lh := h.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx := currentTransformation applyInverseToX:lx.
	ly := currentTransformation applyInverseToY:ly.
	lw := currentTransformation applyInverseScaleX:lw.
	lh := currentTransformation applyInverseScaleY:lh.
    ].
    self exposeX:lx y:ly width:lw height:lh

    "Modified: 13.5.1996 / 11:31:44 / cg"
    "Modified: 14.10.1996 / 22:26:00 / stefan"
!

deviceGraphicsExposeX:x y:y width:w height:h final:final
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a graphicsExpose with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #graphicsExposeX:x:y:width:height:"

    |lx ly lw lh currentTransformation|

    lx := x.
    ly := y.
    lw := w.
    lh := h.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx := currentTransformation applyInverseToX:lx.
	ly := currentTransformation applyInverseToY:ly.
	lw := currentTransformation applyInverseScaleX:lw.
	lh := currentTransformation applyInverseScaleY:lh.
    ].
    self graphicsExposeX:lx y:ly width:lw height:lh final:final

    "Modified: 13.5.1996 / 11:31:54 / cg"
    "Modified: 14.10.1996 / 22:26:08 / stefan"
!

deviceKeyPress:key x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a keyPress with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #keyPress:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	]
    ].
    self keyPress:key x:lx y:ly

    "Modified: 20.5.1996 / 17:44:59 / cg"
    "Modified: 14.10.1996 / 22:26:17 / stefan"
!

deviceKeyRelease:key x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a keyRelease with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #keyRelease:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	]
    ].
    self keyRelease:key x:lx y:ly

    "Modified: 20.5.1996 / 17:44:42 / cg"
    "Modified: 14.10.1996 / 22:26:28 / stefan"
!

devicePointerEnter:state x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a pointerEnter with the logical coordinates.

     Views which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #pointerEnter:x:y:"

    |lx ly currentTransformation|

    lx := x.
    ly := y.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	lx notNil ifTrue:[
	    lx := currentTransformation applyInverseToX:lx.
	    ly := currentTransformation applyInverseToY:ly.
	]
    ].
    self pointerEnter:state x:lx y:ly

    "Modified: 20.5.1996 / 17:44:54 / cg"
    "Modified: 14.10.1996 / 22:26:35 / stefan"
!

exposeX:x y:y width:w height:h
    "an expose event - nothing done here"

    ^ self
!

focusIn
    "got keyboard focus - do nothing here"

    ^ self
!

focusOut
    "lost keyboard focus - do nothing here"

    ^ self
!

graphicsExposeX:x y:y width:w height:h final:final
    "an expose event after a scroll - do normal redraw processing"

    self exposeX:x y:y width:w height:h
!

hotkeyWithId:aId rawKey:aKey
    "default action is to do nothing - may be reimplemented "
    ^ self
!

keyPress:key x:x y:y
    "a key was pressed in this view.
     Here only keyCommands are handled - more action has to
     be implemented by redefining this method"

    |action rest restKey keyCommands|

    (keyCommands := self keyCommands) notNil ifTrue:[
	action := keyCommands at:key ifAbsent:[nil].
	action value
    ].

    key isSymbol ifTrue:[
	(key startsWith:'Basic') ifTrue:[
	    "/ an unhandled BasicFoo key;
	    "/ retry as Foo
	    rest := key withoutPrefix:'Basic'.
	    restKey := rest asSymbolIfInterned.
	    restKey notNil ifTrue:[
		self keyPress:restKey x:x y:y
	    ]
	].
    ].

    "Modified: 6.11.1996 / 17:51:15 / cg"
!

keyRelease:key x:x y:y
    "default action is to do nothing"

    key isSymbol ifTrue:[
	(key startsWith:#Basic) ifTrue:[
	    "/ an unhandled BasicFoo key;
	    "/ retry as Foo

	    self keyRelease:(key copyFrom:#Basic size) asSymbol x:x y:y
	].
    ].

    ^ self

    "Modified: 6.11.1996 / 17:51:20 / cg"
!

mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime
    "ignored"

    ^ self
!

noExpose
    "a no expose event after a scroll (event-mode only)"

    self setGotExposeFlag.
!

pointerEnter:state x:x y:y
    "mouse cursor entered view - do nothing here"

    ^ self
!

pointerLeave:state
    "mouse cursor left view - do nothing here"

    ^ self
!

resizeRequest
    ^ self
!

waitForExpose
    "wait until an expose event arrives (to wait for scroll-finish)"

    |wg endPollTime pollDelay|

    device scrollsAsynchronous ifFalse:[
        self setGotExposeFlag.
        ^ self
    ].

    wg := self windowGroup.
    wg notNil ifTrue:[
        "/
        "/ a normal (suspendable) view.
        "/ wait by doing a real wait
        "/
         wg sensor waitForExposeFor:self
    ] ifFalse:[
        "/
        "/ a pure event driven view.
        "/ wait by doing a direct dispatch loop until the event arrives.
        "/ i.e. poll for the event
        "/
        device isWindowsPlatform ifTrue:[
            pollDelay := 0.5.
        ] ifFalse:[
            pollDelay := 1.
        ].
        endPollTime := Timestamp now addSeconds:pollDelay.

        [self gotExpose] whileFalse:[
            realized ifTrue:[
                (device exposeEventPendingFor:gc drawableId withSync:true) ifTrue:[
                    device dispatchExposeEventFor:gc drawableId.
                ].
            ].
            realized ifFalse:[
                self setGotExposeFlag.
                ^ self
            ].

            "/ break out of the poll after a while

            Timestamp now > endPollTime ifTrue:[
                'DisplaySurface [warning]: lost expose event' errorPrintCR.
                self setGotExposeFlag.
                ^ self
            ].
            Processor yield.
        ].
    ]

    "Modified: / 9.1.1999 / 01:58:09 / cg"
! !

!DisplaySurface methodsFor:'initialization & release'!

destroy
    "view is about to be destroyed -
     first destroy menu if there is one and also destroy the GC.
     then the view is physically destroyed."

    self
        middleButtonMenu:nil;
        keyCommands:nil.
    device notNil ifTrue:[
        device removeKnownView:self withId:nil.
    ].
    super destroy.
!

destroyed
    "view has been destroyed by someone else"

    |id|

    (id := self drawableId) notNil ifTrue:[
	self setId:nil.
	device removeKnownView:self withId:id.
	realized := false.
    ].
    self destroy

    "Modified: 22.3.1997 / 14:56:34 / cg"
!

initCursor
    "default cursor for all views"

    cursor := Cursor normal
!

initStyle
    "nothing done here"

    ^ self
!

initialize
    "initialize defaults"

    super initialize.

    eventMask := 0.
    device notNil ifTrue:[
        eventMask := device defaultEventMask.
    ].
    gc notNil ifTrue:[ viewBackground := gc background].
    backed := false.
    flags := 0.
    self initCursor

    "Modified: 18.1.1997 / 18:09:41 / cg"
!

prepareForReinit
    gc notNil ifTrue:[
	gc prepareForReinit.
    ].
!

reAdjustGeometry
    "sent late during snapin processing, nothing done here"

    ^ self
!

recreate
    "recreate (i.e. tell X about me) after a snapin or a migration"

    viewBackground isColor ifTrue:[
        viewBackground := viewBackground onDevice:device.
    ].
    super recreate.
    cursor notNil ifTrue:[
        cursor := cursor onDevice:device.
    ].

    "Modified: 28.3.1997 / 13:48:06 / cg"
!

reinitStyle
    "nothing done here"

    ^ self
!

releaseDeviceResources
    super destroy.
! !

!DisplaySurface methodsFor:'keyboard commands'!

addActionForKey:aKey action:aBlock
    "define a keyboard command function"

    |keyCommands|

    (keyCommands := self keyCommands) isNil ifTrue:[
	self keyCommands:(keyCommands := IdentityDictionary new).
    ].
    keyCommands at:aKey put:aBlock
!

keyCommands
    ^ self getAttribute:#keyCommands
!

keyCommands:aDictionaryOrNil
    self setAttribute:#keyCommands to:aDictionaryOrNil
!

removeActionForKey:aKey
    |keyCommands|

    (keyCommands := self keyCommands) notNil ifTrue:[
	keyCommands removeKey:aKey ifAbsent:nil
    ]
! !

!DisplaySurface methodsFor:'queries'!

buttonMotionEventPending
    "return true, if a button motion event is pending.
     Normally, you don't want to use this, since no polling is needed
     (not even for mouse-tracking).
     Also, don't use it, since it does not honor the windowGroup,
     but goes directly to the device instead.
     Actually, its a historical leftover"

    device flush.
    ^ device eventPending:#buttonMotion for:gc drawableId
!

buttonReleaseEventPending
    "return true, if a button release event is pending.
     Don't use it, since it does not honor the windowGroup, but
     goes directly to the device instead.
     Actually, its a historical leftover"

    device flush.
    ^ device eventPending:#buttonRelease for:gc drawableId
!

exposeEventPending
    "return true, if an expose event is pending."

    |windowGroup|

    windowGroup := self windowGroup.
    windowGroup notNil ifTrue:[
	(windowGroup sensor hasExposeEventFor:self) ifTrue:[^ true].
    ].
    ^ device eventPending:#expose for:gc drawableId

    "Modified: / 15.9.1998 / 23:18:16 / cg"
!

redrawsFull
    ^ false

    "Created: 4.3.1996 / 14:17:22 / cg"
!

shown
    "return true if at least a part of myself is currently visible
     (I am mapped and not completely covered).
     Assumed that I am always visible when realized."

    ^ realized
! !

!DisplaySurface methodsFor:'queries-contents'!

heightOfContents
    "return the height of the contents in pixels.
     Since we don't know here, just return the view's size.
     This will make your scrollbars show 100%-visible.
     Must be redefined in subviews to make scrollbars really work."

    ^ self height
!

widthOfContents
    "return the width of the contents in pixels.
     Since we don't know here, just return the view's size.
     This will make your scrollbars show 100%-visible.
     Must be redefined in subviews to make scrollbars really work."

    ^ self width
!

xOriginOfContents
    "return the x-origin of the contents in pixels.
     Since we don't know here, just return 0 for left.
     Must be redefined in subviews to make scrollbars really work."

    ^ 0
!

yOriginOfContents
    "return the y-origin of the contents in pixels.
     Since we don't know here, just return 0 for top.
     Must be redefined in subviews to make scrollbars really work."

    ^ 0
! !

!DisplaySurface methodsFor:'testing'!

isDebugView
    ^ false
!

isPopUpView
    "return true, if this view should be put on top (raised) automatically.
     usually this is true for alertBoxes etc."

    ^ false

    "Created: / 22.1.1998 / 15:01:32 / stefan"
!

isRootView
    "return true, if the receiver is a root view
     false is returned here, this is only redefined in DisplayRootView."

    ^ false

    "Modified: 28.5.1996 / 19:27:34 / cg"
    "Created: 5.7.1996 / 14:58:55 / cg"
!

isTopView
    "return true, if the receiver is some kind of topview;
     false is returned here; redefined in some subclasses."

    ^ false

    "Modified: 28.5.1996 / 19:27:34 / cg"
    "Created: 22.3.1997 / 14:45:29 / cg"
!

isView
    "return true, if the receiver is some kind of view;
     true is returned here."

    ^ true

    "Modified: 28.5.1996 / 19:27:34 / cg"
! !

!DisplaySurface methodsFor:'user interaction & notifications'!

beep
    "output an audible beep or bell on my screen device"

    device beep; flush

    "Created: 28.5.1996 / 16:16:13 / cg"
    "Modified: 28.5.1996 / 16:58:25 / cg"
!

showActivity:aMessage
    "this is sent indirectly by the activityNotification mechanism.
     Defined here as a fallback, if ever sent to non topviews."

    Transcript showCR:aMessage

    "Modified: 18.5.1996 / 15:44:33 / cg"
! !

!DisplaySurface class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


DisplaySurface initialize!
