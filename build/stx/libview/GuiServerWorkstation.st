"{ Encoding: utf8 }"

"
COPYRIGHT (c) 2014 by Claus Gittinger
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

DeviceWorkstation subclass:#GuiServerWorkstation
	instanceVariableNames:'guiServerPid out in connectionTimeout
		connectionTimeoutForWindowCreation hasConnectionBroken
		dispatchingExpose buttonsPressed displayName listOfFonts fontMap
		viewMap nextId useExtraCanvas answerSemaphore accessLock
		useNativeWidgets'
	classVariableNames:'DefaultConnectionTimeout
		DefaultConnectionTimeoutForWindowCreation KeyPressMask
		KeyReleaseMask ButtonPressMask ButtonReleaseMask ButtonMotionMask
		PointerMotionMask ExposureMask FocusChangeMask EnterWindowMask
		LeaveWindowMask KeymapStateMask VisibilityChangeMask
		StructureNotifyMask ResizeRedirectMask PropertyChangeMask
		ColormapChangeMask SubstructureNotifyMask
		SubstructureRedirectMask'
	poolDictionaries:''
	category:'Interface-Graphics'
!

!GuiServerWorkstation class methodsFor:'documentation'!

copyright
"
COPYRIGHT (c) 2014 by Claus Gittinger
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
    This is an experimental UI interface, not yet ready for general use.

    This class provides the interface to the GUIServer. 
    It redefines all required methods from DeviceWorkstation.

    The GUIServer is a little Java program, which provides a socket interface,
    allowing for GUI operations to be sent and events to be received.
    Thus providing a platform independent, portable and nice looking GUI interface alternative.

    [author:]
        Claus Gittinger
"
!

example
"
     Smalltalk at:#D2 put:(self new initializeFor:nil).
     Smalltalk at:#D2 put:(self new initializeFor:'localhost:64001')

     D2 startDispatch.

     (View onDevice:D2) open.
     (Button onDevice:D2) label:'Hello'; open.

     |v b1 b2|
     v := View onDevice:D2.
     v extent:200@200.
     b1 := Button label:'Press Me' in:v. b1 extent:100@50.
     b2 := Button label:'Me Too' in:v. b2 extent:100@50.
     b2 top:60.
     b1 action:[ Transcript showCR:'b1 pressed'. b1 extent:150@40].
     b2 action:[ Transcript showCR:'b2 pressed'].
     v open.
     v inspect.

     (SystemBrowser onDevice:D2) open
"
!

example1
"
     |v b1 b2|

     'Smalltalk at:#D2 put:(self new initializeFor:nil)'.
     Smalltalk at:#D2 put:(self new initializeFor:'localhost:64001').

     D2 startDispatch.

     v := View onDevice:D2.
     v extent:200@200.
     b1 := Button label:'Press Me' in:v. b1 extent:100@50.
     b2 := Button label:'Me Too' in:v. b2 extent:100@50.
     b2 top:60.
     b1 action:[ Transcript showCR:'b1 pressed'. self halt. b1 extent:150@40].
     b2 action:[ Transcript showCR:'b2 pressed'].
     v open.
"
!

example1b
"
     |v b1 b2|

     Smalltalk at:#D2 put:(self new initializeFor:nil).
     Smalltalk at:#D2 put:(self new initializeFor:'localhost:64001').

     D2 startDispatch.

     v := View onDevice:D2.
     v extent:200@200.

     v open.
     Delay waitForSeconds:2.
     v displayString:'hello' x:10 y:20.
"
!

example2
"
     |v v1 v2 v3|

     Smalltalk at:#D2 put:(self new initializeFor:nil).

     D2 startDispatch.

     v := View onDevice:D2.
     v extent:200@220.
     v1 := View in:v. 
     v1 origin:5@5 corner:95@95.
     v1 viewBackground:Color red.

     v2 := View in:v. 
     v2 origin:100@5 corner:195@95.
     v2 viewBackground:Color green.

     v3 := View in:v. 
     v3 origin:5@100 corner:95@195.
     v3 viewBackground:Color blue.
     v open
"
!

example3
"
    |v v1 |

    Smalltalk at:#D2 put:(self new initializeFor:nil).

    D2 startDispatch.

    v := View onDevice:D2.
    v extent:200@220.

    v1 := ScrollBar in:v. 
    v1 origin:5@5 corner:25@1.0.
    v1 viewBackground:Color red.

    v open
"
!

example3b
"
    |v v1 v2|

    Smalltalk at:#D2 put:(self new initializeFor:nil).

    D2 startDispatch.

    v := View onDevice:D2.
    v extent:200@220.

    v1 := ScrollBar in:v. 
    v1 origin:5@5 corner:25@1.0.

    v2 := HorizontalScrollBar in:v. 
    v2 origin:25@5 corner:1.0@25.

    v open
"
!

example4
"
    |v v1 r1 r2 if c1 grp chk tm|

    Smalltalk at:#D2 put:(self new initializeFor:nil).

    D2 startDispatch.

    v := View onDevice:D2.
    v extent:200@220.

    v1 := Label label:'label' in:v. 
    v1 origin:5@5 corner:125@25.

    grp := RadioButtonGroup new.
    r1 := RadioButton label:'radio 1' in:v. 
    r1 origin:5@25 corner:1.0@50.
    grp add:r1 value:1.

    r2 := RadioButton label:'radio 2' in:v. 
    r2 origin:5@50 corner:1.0@75.
    grp add:r2 value:2.
    grp onChangeEvaluate:[ Transcript showCR:'changed'].

    r2 := RadioButton label:'radio 2' in:v. 
    r2 origin:5@50 corner:1.0@75.
    grp add:r2 value:2.
    grp onChangeEvaluate:[ Transcript showCR:'changed'].

    chk := false asValue.
    c1 := CheckBox label:'check' in:v. 
    c1 origin:5@75 corner:1.0@100.
    c1 model:chk.
    chk onChangeEvaluate:[ Transcript showCR:'changed'].

    tm := 'hello' asValue.
    if := EditField in:v.
    if viewBackground:(Color yellow lightened).
    if origin:5@100 corner:1.0@125.
    if model:tm.
    ' if passwordCharacter:$* '.
    tm onChangeEvaluate:[ Transcript showCR:'changed'].

    v open
"
!

example5
"
    |v v1 r1 r2 v3 c1 grp chk|

    Smalltalk at:#D2 put:(self new initializeFor:nil).

    D2 startDispatch.

    v := View onDevice:D2.
    v extent:200@220.

    v1 := TextView in:v.
    v1 viewBackground:Color red.
    v1 origin:5@5 corner:1.0@1.0.
    v1 contents:'line1
line2
line3'.
    v1 textChanged.
    v open
"
!

example5b
"
    |v v1 v2 v3|

    Smalltalk at:#D2 put:(self new initializeFor:nil).

    D2 startDispatch.

    v := View onDevice:D2.
    v extent:200@220.
    v viewBackground:Color yellow.

    v1 := View in:v.
    v1 extent:180@180.
    v1 viewBackground:Color green.

    v2 := SelectionInListView in:v1.
    v2 viewBackground:Color red.
    v2 origin:5@5 corner:100@100.
    v2 list:#('line1' 'line2' 'line3').
    v open.

    Delay waitForSeconds:2.
    D2 send:'set-visible ',v2 id,' true'.
    D2 send:'set-bounds ',v2 id,' 10 10 50 50'.
"
! !

!GuiServerWorkstation class methodsFor:'class initialization'!

initialize
    KeyPressMask := 16r01.
    KeyReleaseMask := 16r02.
    ButtonPressMask := 16r04.
    ButtonReleaseMask := 16r08.
    ButtonMotionMask := 16r10.
    PointerMotionMask := 16r20.
    ExposureMask := 16r40.
    FocusChangeMask := 16r80.
    EnterWindowMask := 16r100.
    LeaveWindowMask := 16r200.
    KeymapStateMask := 16r400.
    VisibilityChangeMask := 16r800.
    StructureNotifyMask := 16r1000.
    ResizeRedirectMask := 16r2000.
    PropertyChangeMask := 16r4000.
    ColormapChangeMask := 16r8000.
    SubstructureNotifyMask := 16r10000.
    SubstructureRedirectMask := 16r20000.
! !

!GuiServerWorkstation class methodsFor:'defaults'!

defaultGUIServerPath
    ^ nil.
    ^ Smalltalk projectDirectory constructString:'../support/guiServer/guiserver.jar'    
"/  ^ '/Users/cg/Downloads/languages/lisp/newLisp/newlisp-10.6.0/guiserver/guiserver.jar'.
"/    ^ self projectDirectory constructString:'guiserver.jar'
!

defaultGUIServerPort
    ^ 64001
    "/ ^ 47011
! !

!GuiServerWorkstation methodsFor:'bitmap/window creation'!

createBitmapFromArray:data width:w height:h
    "create a monochrome, depth1 bitmap from a given (byte-)array.
     The rows are aligned to a multiple of 8"

    "/ for now, just return a dummy id...
    ^ 4711

    "/ todo: save as png and use that path in the future...
"/    self halt.
!

createWindowFor:aView type:typeSymbol origin:org extent:ext
        minExtent:minE maxExtent:maxE borderWidth:bw subViewOf:sv
        style:styleSymbol inputOnly:inp
        label:label owner:owner
        icon:icn iconMask:icnM iconView:icnV

    |nr id nativeWindowType x y w h containerId|

    nr := nextId.
    nextId := nextId + 1.

    useNativeWidgets ifTrue:[
        nativeWindowType := aView nativeWindowType.
    ].

    x := org x.
    y := org y.
    w := ext x.
    h := ext y.

    id := '%1_%2' bindWith:aView class nameWithoutPrefix with:nr.

    sv isNil ifTrue:[
        self gs_frame:id x:org x y:org y width:w height:h label:'x' visible:false.
        "/ self send:('canvas ','canvas_',id).
        useExtraCanvas ifTrue:[
            self send:('canvas ','canvas_',id).
            self send:('add-to ',id,' canvas_',id).
            self send:('set-visible ','canvas_',id,' true').
            self send:('set-null-layout ','canvas_',id).
        ] ifFalse:[
            self send:('set-null-layout ',id).
        ].
    ] ifFalse:[
        containerId := sv id.
        useExtraCanvas ifTrue:[
            sv superView isNil ifTrue:[
                containerId := 'canvas_',containerId
            ].
        ].
        nativeWindowType notNil ifTrue:[
            nativeWindowType == #Button ifTrue:[
                self send:('button ',id,' button-action ',(Base64Coder encode:aView label),' ',x printString,' ',y printString)
                "/ (gs:set-flow-layout 'ButtonDemo "center" 2 15)
                "/ (gs:add-to 'ButtonDemo 'ColorPanel 'aButton)
            ] ifFalse:[ nativeWindowType == #VerticalScrollBar ifTrue:[
                "/ action orientation minPos maxPos pos pageIncrement
                self send:('scrollbar ',id,' scrollbar-action vertical 0 100 0 10')
            ] ifFalse:[ nativeWindowType == #HorizontalScrollBar ifTrue:[
                "/ action orientation minPos maxPos pos pageIncrement
                self send:('scrollbar ',id,' scrollbar-action horizontal 0 100 0 10')
            ] ifFalse:[ nativeWindowType == #Label ifTrue:[
                "/ "left", "center", "right", "leading", "trailing", "bottom" and "top"
                self send:('label ',id,' ',(Base64Coder encode:aView label),' center ',w printString,' ',h printString).
            ] ifFalse:[ nativeWindowType == #RadioButton ifTrue:[
                self send:('radio-button ',id,' radio-button-action ',(Base64Coder encode:aView label),' ',(aView isOn printString)).
            ] ifFalse:[ nativeWindowType == #CheckBox ifTrue:[
                self send:('check-box ',id,' check-box-action ',(Base64Coder encode:aView label),' ',(aView isOn printString)).
            ] ifFalse:[ nativeWindowType == #EditField ifTrue:[
                aView passwordCharacter notNil ifTrue:[
                    self send:('text-field ',id,' text-field-action ',(aView maxChars ? 9999) printString,' ',(Base64Coder encode:aView passwordCharacter asString)).
                ] ifFalse:[
                    self send:('text-field ',id,' text-field-action ',(aView maxChars ? 9999) printString).
                ].
                self changeText:(aView contents asString) in:id.
            ] ifFalse:[ nativeWindowType == #TextView ifTrue:[
                self send:('text-area ',id,' text-area-action ',w printString,' ',h printString).
                self changeText:(aView contents) in:id.
            ] ifFalse:[ nativeWindowType == #SelectionInListView ifTrue:[
                self send:('list-box ',id,' list-box-action ',((aView list collect:[:l | (Base64Coder encode:l?'')]) asStringCollection asStringWith:' ')).
                "/ self changeList:aView list in:id.
            ] ifFalse:[
self halt.
                self send:('canvas ',id)
            ]]]]]]]]].
        ] ifFalse:[
            self send:('canvas ',id)
        ].
        self send:('add-to ',containerId,' ',id).
        self send:('set-visible ',id,' true').
        self send:('set-null-layout ',id).
        self send:('set-bounds ',id,' %1 %2 %3 %4' bindWith:x with:y with:w with:h).
    ].
    viewMap at:id put:aView.
    ^ id
!

destroyGC:gcId
!

destroyPixmap:pixmapId
!

destroyView:aView withId:id
    |container|

    container := aView superView.

    viewMap removeKey:id ifAbsent:[].
    container isNil ifTrue:[
        self send:('dispose ',id)
    ] ifFalse:[
        (useExtraCanvas and:[container superView isNil]) ifTrue:[
            self send:('remove-from canvas_',container id,' ',id)
        ] ifFalse:[
            self send:('remove-from ',container id,' ',id)
        ].
    ].
!

gcFor:aDrawableId
    "create a GC for drawing into aDrawable"

    ^ aDrawableId
!

supportsNativeWidgetType:aWidgetTypeSymbol
    useNativeWidgets ifFalse:[^ false].

    aWidgetTypeSymbol == #Button ifTrue:[^ true].
    aWidgetTypeSymbol == #Scrollbar ifTrue:[^ true].
    aWidgetTypeSymbol == #Label ifTrue:[^ true].
    aWidgetTypeSymbol == #Toggle ifTrue:[^ true].
    aWidgetTypeSymbol == #ScrolledView ifTrue:[^ true].
    aWidgetTypeSymbol == #CheckBox ifTrue:[^ true].
    aWidgetTypeSymbol == #RadioButton ifTrue:[^ true].
    aWidgetTypeSymbol == #ComboBox ifTrue:[^ true].
    aWidgetTypeSymbol == #Slider ifTrue:[^ true].
    aWidgetTypeSymbol == #ProgressBar ifTrue:[^ true].
    aWidgetTypeSymbol == #ListBox ifTrue:[^ true].
    aWidgetTypeSymbol == #EditField ifTrue:[^ true].
    aWidgetTypeSymbol == #TextView ifTrue:[^ true].
    aWidgetTypeSymbol == #Menu ifTrue:[^ true].
    aWidgetTypeSymbol == #MenuBar ifTrue:[^ true].
    aWidgetTypeSymbol == #Table ifTrue:[^ true].

    ^ false
! !

!GuiServerWorkstation methodsFor:'cursor stuff'!

builtInCursorShapes
    "return a collection of standard cursor names.
     Those are built into the XServer and need not be created as
     user cursors.
     (actually, there are more than those below ...)"

    "/ if you add something here, also add to #shapeNumberFromCursor ...

    ^ #(
        #upLeftArrow            "/ default
        #upRightHand            "/ hand
        #text                   "/ text
        #wait                   "/ wait
        #crossHair              "/ crosshair
        #origin                 "/ nw-resize
        #topLeft                "/ nw-resize
        #corner                 "/ se-resize
        #bottomRight            "/ se-resize
        #topRight               "/ ne-resize
        #bottomLeft             "/ sw-resize
      )
!

createCursorShape:aShapeSymbol
    |cursors i|

    cursors := #(
        (#upLeftArrow            #default      )
        (#upRightHand            #hand         )
        (#text                   #text         )
        (#wait                   #wait         )
        (#crossHair              #crosshair    )
        (#origin                 #nw-resize    )
        (#topLeft                #nw-resize    )
        (#corner                 #se-resize    )
        (#bottomRight            #se-resize    )
        (#topRight               #ne-resize    )
        (#bottomLeft             #sw-resize    )
      ).
      i := cursors findFirst:[:entry | entry first == aShapeSymbol].
      i == 0 ifTrue:[^ nil].
      ^ (cursors at:i) second
!

destroyCursor:aCursorId 
!

setCursor:aCursorId in:aWindowId
    "/    ;; @syntax (gs:set-cursor <sym-id> <str-shape>)
    "/    ;; @param <sym-id> The name of the frame, dialog or window.
    "/    ;; @param <str-shape> The string describing the cursor shape.
    "/    ;;
    "/    ;; The cursor shape can be one of the following:
    "/    ;; <pre>
    "/    ;;  "default"
    "/    ;;  "crosshair"
    "/    ;;  "text"
    "/    ;;  "wait"
    "/    ;;  "sw-resize"
    "/    ;;  "se-resize"
    "/    ;;  "nw-resize"
    "/    ;;  "ne-resize"
    "/    ;;  "n-resize"
    "/    ;;  "s-resize"
    "/    ;;  "w-resize"
    "/    ;;  "e-resize"
    "/    ;;  "hand"
    "/    ;;  "move"

    self gs_set_cursor:aWindowId cursor:aCursorId
! !

!GuiServerWorkstation methodsFor:'event handling'!

addToKnownScreens
!

base64StringFromLineStream:s
    |str|

    str := s upToAny:')( '.
    (str first = $") ifTrue:[
        str := str withoutQuotes.
    ].
    ^ (Base64Coder decodeAsString:str) 
!

defaultEventMask
    ^ ExposureMask | StructureNotifyMask |
      KeyPressMask | KeyReleaseMask |
      PointerMotionMask |
      EnterWindowMask | LeaveWindowMask |
      ButtonPressMask | ButtonMotionMask | ButtonReleaseMask |
      PropertyChangeMask 
!

dispatchEventFor:aViewIdOrNil withMask:eventMask
    "central event handling method:
     get next event and send appropriate message to the sensor or view.
     If the argument aViewIdOrNil is nil, events for any view are processed,
     otherwise only events for the view with given id are processed.
     If the argument aMask is nonNil, only events for this eventMask are
     handled.
     WARNING: this may block to wait for an event - you better check for a
              pending event before calling this."

    |line|

    EndOfStreamNotification handle:[:ex |
    ] do:[
        line := in nextLine.
    ].
    line isNil ifTrue:[
        hasConnectionBroken := true.
        self brokenConnection.
        ^ self.
    ].
    self handleInput:line.
!

eventMaskFor:anEventSymbol
    "return the eventMask bit-constant corresponding to an event symbol"

    anEventSymbol == #keyPress ifTrue:[^ KeyPressMask].
    anEventSymbol == #keyRelease ifTrue:[^ KeyReleaseMask].
    anEventSymbol == #buttonPress ifTrue:[^ ButtonPressMask].
    anEventSymbol == #buttonRelease ifTrue:[^ ButtonReleaseMask].
    anEventSymbol == #buttonMotion ifTrue:[^ ButtonMotionMask].
    anEventSymbol == #pointerMotion ifTrue:[^ PointerMotionMask].
    anEventSymbol == #expose ifTrue:[^ ExposureMask].
    anEventSymbol == #focusChange ifTrue:[^ FocusChangeMask].
    anEventSymbol == #enter ifTrue:[^ EnterWindowMask].
    anEventSymbol == #leave ifTrue:[^ LeaveWindowMask].
    anEventSymbol == #keymapState ifTrue:[^ KeymapStateMask].
    anEventSymbol == #visibilityChange ifTrue:[^ VisibilityChangeMask].
    anEventSymbol == #structureNotify ifTrue:[^ StructureNotifyMask].
    anEventSymbol == #resizeRedirect ifTrue:[^ ResizeRedirectMask].
    anEventSymbol == #propertyChange ifTrue:[^ PropertyChangeMask].
    anEventSymbol == #colormapChange ifTrue:[^ ColormapChangeMask].
    anEventSymbol == #substructureNotify ifTrue:[^ SubstructureNotifyMask].
    anEventSymbol == #substructureRedirect ifTrue:[^ SubstructureRedirectMask].
    ^ 0
!

eventPending
    ^ in notNil
    and:[ in isOpen
    and:[ in canReadWithoutBlocking ]]

    "
     self new initializeFor:nil
    "
!

handleInput:line
    "handle an incoming event from the guiServer"

    |s cmd var view text|

    "/ gui server sends lisp-like lines:
    "/  (action id)
    "/  ...
Transcript showCR:'<< ',line.

    s := line readStream.
    s next == $( ifFalse:[^ false ].

    s skipSeparators.
    cmd := s upToAny:'")( '.
    s skipSeparators.

    cmd = 'button-action' ifTrue:[
        view := self viewFromLineStream:s.
Transcript showCR:view.
Transcript showCR:view isNativeWidget.
        self buttonPress:1 x:1 y:1 view:view.
        self buttonRelease:1 x:1 y:1 view:view.
        ^ true.
    ].
    cmd = 'radio-button-action' ifTrue:[
        view := self viewFromLineStream:s.
Transcript showCR:view.
Transcript showCR:view isNativeWidget.
        self buttonPress:1 x:1 y:1 view:view.
        self buttonRelease:1 x:1 y:1 view:view.
        ^ true.
    ].
    cmd = 'check-box-action' ifTrue:[
        view := self viewFromLineStream:s.
Transcript showCR:view.
Transcript showCR:view isNativeWidget.
        self buttonPress:1 x:1 y:1 view:view.
        self buttonRelease:1 x:1 y:1 view:view.
        ^ true.
    ].
    cmd = 'scrollbar-action' ifTrue:[
        view := self viewFromLineStream:s.
Transcript showCR:view.
Transcript showCR:view isNativeWidget.
        ^ true.
    ].
    cmd = 'text-field-action' ifTrue:[
        view := self viewFromLineStream:s.
        text := self base64StringFromLineStream:s.
Transcript showCR:view.
Transcript showCR:view isNativeWidget.
Transcript showCR:text.
        ^ true.
    ].

    cmd = 'set' ifTrue:[
        var := s upToAny:')( '.
        s skipSeparators.
        var first == $' ifTrue:[ var := var copyFrom:2 ].

        var = 'gs:screen' ifTrue:[
            s peek == $' ifTrue:[ s next ].
            s peek ~~ $( ifTrue:[ self halt].
            s next.
            width := (Number readFrom:s) asInteger.
            s skipSeparators.
            height := (Number readFrom:s) asInteger.
            s skipSeparators.
            resolutionHor := resolutionVer := (Number readFrom:s) asInteger "is dpi" / 25.4.
            widthMM := width / resolutionHor.
            heightMM := height / resolutionVer.
            "/ self halt.
            ^ true.
        ].
    ].

    self halt.
    ^ false.

    "
     self new initializeFor:nil
    "
!

setEventMask:mask in:viewID
!

viewFromLineStream:s
    |id|

    id := s upToAny:')( '.
    (id first = $") ifTrue:[
        id := id withoutQuotes.
    ].
    ^ viewMap at:id ifAbsent:nil.
! !

!GuiServerWorkstation methodsFor:'font stuff'!

ascentOf:id
    ^ 16
!

descentOf:id
    ^ 8
!

getFontWithFamily:familyString face:faceString style:styleString size:sizeArg sizeUnit:sizeUnit encoding:encodingSym
    |spec id|

    spec := { familyString . faceString . styleString . sizeArg }.
    id := fontMap at:spec ifAbsent:nil.
    id isNil ifTrue:[
        id := (fontMap size // 2) + 1.
        fontMap at:spec put:id.
        fontMap at:id put:spec.
    ].
    ^ id
!

maxAscentOf:id
    ^ 16
!

maxDescentOf:id
    ^ 8
!

maxWidthOfFont:id
    ^ 10
!

minWidthOfFont:id
    ^ 10
!

subclassResponsibility
    MiniDebugger enter.
    AbortSignal raise
!

widthOf:aString from:index1 to:index2 inFont:aFontId
    ^ (index2-index1+1) * 10
! !

!GuiServerWorkstation methodsFor:'gc stuff'!

displayString:aString from:start to:stop x:x y:y in:aDrawable with:aGCId opaque:opaque
    |cmd|

    cmd := 'draw-text ',aGCId,' ',(Base64Coder encode:aString utf8Encoded).
    self send:cmd.
!

setBackground:fg in:aGC
    "nothing done - color sent with each draw request"
!

setBackgroundColor:clr in:aGC
    "nothing done - color sent with each draw request"
!

setFont:aFontId in:aGCId
    |cmd spec familyString faceString styleString size|

    spec := fontMap at:aFontId ifAbsent:nil.
    spec isNil ifTrue:[
        self halt:'no such font'.
        ^ self.
    ].
    familyString := spec first.
    faceString := spec second.
    styleString := spec third.
    size := spec fourth.

    cmd := 'set-font ',aGCId,' ',(Base64Coder encode:familyString utf8Encoded), ' ',size printString.
    
    self send:cmd. 
!

setForeground:fg background:bg in:aGC
    "nothing done - color sent with each draw request"
!

setForeground:fg in:aGC
    "nothing done - color sent with each draw request"
!

setForegroundColor:clr in:aGC
    "nothing done - color sent with each draw request"
!

setFunction:aFunctionSymbol in:aGCId
    |cmd|

    cmd := 'set-function ',aGCId,' ',aFunctionSymbol printString.
    self send:cmd. 
!

setLineWidth:lw style:s cap:c join:j in:aGC
! !

!GuiServerWorkstation methodsFor:'gs interaction'!

gs_frame:id x:x y:y width:w height:h label:label visible:visible
    label isNil ifTrue:[
        self send:('frame %1 %2 %3 %4' 
                    bindWith:id with:x with:y with:w with:h)
    ] ifFalse:[
        self send:('frame %1 %2 %3 %4 %5 %6' 
                    bindWith:id with:x with:y with:w with:h
                        with:(Base64Coder encode:label) with:visible)
    ]
!

gs_set_background:id color:colorId
    self gs_set_color:id color:colorId
!

gs_set_background:id r:redFraction g:greenFraction b:blueFraction alpha:alphaFraction
    self gs_set_color:id r:redFraction g:greenFraction b:blueFraction alpha:alphaFraction
!

gs_set_color:id color:colorId
    self gs_set_color:id     
            r:(((colorId rightShift:16) bitAnd:16rFF) / 255.0) 
            g:(((colorId rightShift:8) bitAnd:16rFF) / 255.0) 
            b:((colorId bitAnd:16rFF) / 255.0) 
            alpha:1
!

gs_set_color:id r:redFraction g:greenFraction b:blueFraction alpha:alphaFraction
    self send:('set-color %1 %2 %3 %4 %5' 
            bindWith:id 
                with:redFraction
                with:greenFraction
                with:blueFraction
                with:alphaFraction)
!

gs_set_cursor:id cursor:cursorId
    self send:('set-cursor ',id,' ',cursorId) 
!

gs_set_foreground:id r:redFraction g:greenFraction b:blueFraction alpha:alphaFraction
    self send:('set-foreground %1 %2 %3 %4 %5' 
            bindWith:id 
                with:redFraction
                with:greenFraction
                with:blueFraction
                with:alphaFraction)
!

gs_set_resizable:id resizable:aBoolean
    self send:'set-resizable %1 %2' with:id with:aBoolean
!

gs_set_trace:aBoolean
    self send:'set-trace System %1' with:aBoolean
!

gs_set_utf8:aBoolean
    self send:'set-utf8 System %1' with:aBoolean
!

gs_set_visible:id visible:visible
    self send:('set-visible ',id,' ',visible printString) 
!

send:cmdString
    out isNil ifTrue:[^ self].
    out nextPutLine:cmdString
!

send:cmd with:arg
    self send:(cmd bindWith:arg)
!

send:cmd with:arg1 with:arg2
    self send:(cmd bindWith:arg1 with:arg2)
! !

!GuiServerWorkstation methodsFor:'initialization & release'!

closeConnection
    |c p|

    (c := in) notNil ifTrue:[
        in := nil.
        c close.
    ].
    (c := out) notNil ifTrue:[
        out := nil.
        c close.
    ].
    ((p := guiServerPid) notNil and:[p ~~ #alreadyRunning]) ifTrue:[
        guiServerPid := nil.
        OperatingSystem terminateProcess:p
    ].
!

guiServerTerminated
    "connection to GUIServer broken"

    |c|

    Transcript showCR:'guiServer terminated'.

    (c := in) notNil ifTrue:[
        in := nil.
        c close.
    ].
    (c := out) notNil ifTrue:[
        out := nil.
        c close.
    ].
    self brokenConnection
!

initializeFor:aHostName
    "initialize the receiver for a connection to a GUIServer;
     the argument, aHostName may be nil (for a new server on the local machine)
     or the name:port of an already running server"

    in notNil ifTrue:[
        "/ already connected - you bad guy try to trick me manually ?
        ^ self
    ].

    self openConnectionTo:aHostName.

    "/ useNativeWidgets := false.
    useNativeWidgets := true.
    useExtraCanvas := false.
    "/ useExtraCanvas := true.

    connectionTimeout := connectionTimeout ? DefaultConnectionTimeout.
    connectionTimeoutForWindowCreation := connectionTimeoutForWindowCreation ? DefaultConnectionTimeoutForWindowCreation.
    hasConnectionBroken := false.

    dispatching := false.
    dispatchingExpose := false.
    isSlow := false.
    shiftDown := false.
    ctrlDown := false.
    metaDown := false.
    altDown := false.
    motionEventCompression := true.
    buttonsPressed := 0.

    visualType := #TrueColor.
    depth := 24.
    redShift := 16. greenShift := 8. blueShift := 0.
    listOfFonts := nil.
    nextId := 1.

    fontMap := Dictionary new.
    viewMap := Dictionary new.

    self initializeDeviceResourceTables.
    self initializeScreenProperties.

    self initializeDefaultValues.
    self initializeSpecialFlags.
    self initializeKeyboardMap.
    self initializeDeviceSignals.

    self initializeViewStyle.
!

initializeScreenProperties
    "setup screen specific properties."

    super initializeScreenProperties.

    out nextPutLine:'get-screen System'.
    self handleInput:(in nextLine).

    width := 1280.
    height := 1024.
!

initializeSpecialFlags
    ^ self
!

nativeWidgets:aBoolean
    "enable/disable native widgets on a display"

    useNativeWidgets := aBoolean
!

openConnectionTo:aHostNameOrNil
    "open a connection to aHostNameOrNil;
     if nil, a new GUIServer is started; otherwise, try to connect to that host."

    |host port hostAndPort startGUIServer acceptSocket connectionFromGS connectionToGS|

    startGUIServer := false.

    aHostNameOrNil isNil ifTrue:[
        host := 'localhost'.
        port := self guiServerPort.
        startGUIServer := true.
    ] ifFalse:[
        hostAndPort := aHostNameOrNil splitBy:$:.
        host := hostAndPort first.
        port := (hostAndPort at:2 ifAbsent:[self guiServerPort]) asNumber.
        guiServerPid := #alreadyRunning.
    ].

    displayName := (host , ':' , port printString).

    startGUIServer ifTrue:[
        self startGUIServerWithPort:port
    ].

    acceptSocket := Socket newTCPserverAtPort:(port+1).
    acceptSocket listenFor:1.

    "/ give GUI server a chance to come up
    [connectionFromGS isNil] whileTrue:[
        connectionFromGS := Socket newTCPclientToHost:host port:port.
        connectionFromGS isNil ifTrue:[
            Delay waitForSeconds:0.1
        ].
    ].

    acceptSocket readWaitWithTimeoutMs:500.
    connectionToGS := acceptSocket accept.
    acceptSocket close.

    out := connectionFromGS.
    in := connectionToGS.

    "/ self startReaderProcess.

    self gs_set_trace:true.
    self gs_set_utf8:true.

    "
     Smalltalk at:#D2 put:(self new initializeFor:nil).
     Smalltalk at:#D2 put:(self new initializeFor:'localhost:47020')

     WorkspaceApplication openOnDevice:D2

     D2 startDispatch.
     SystemBrowser openOnDevice:d
    "
!

startGUIServerWithPort:portNr
    "start the java GUIServer"

    |cmd args javaHome guiServerPath|

    guiServerPath := self guiServerPath.
    guiServerPath isNil ifTrue:[
        "/ assume already runnning
        guiServerPid := #alreadyRunning.
        ^ self.
    ].

    OperatingSystem isMSWINDOWSlike ifTrue:[
        cmd := 'cmd/c'
    ] ifFalse:[
        javaHome := OperatingSystem getEnvironment:'JAVA_HOME'.
        cmd := javaHome isNil 
                        ifTrue:'/usr/bin/java'
                        ifFalse:[ javaHome asFilename constructString:'bin/java' ].
    ].
    args := { 'java' . '-jar' . guiServerPath . portNr asString }.

    Processor
               monitor:[
                  guiServerPid := OperatingSystem
                      exec:cmd
                      withArguments:args
                      fork:true
               ]
               action:[:status |
                  status stillAlive ifFalse:[
                      OperatingSystem closePid:guiServerPid.
                      guiServerPid := nil.  
                      self guiServerTerminated.
                  ].
               ].

    guiServerPid isNil ifTrue:[
        self error:'failed to launch guiserver.jar'
    ].

    "
     self new initializeFor:nil
    "
! !

!GuiServerWorkstation methodsFor:'misc'!

halt
    Screen currentScreenQuerySignal answer:Display do:[
        super halt.
    ].
!

mapWindow:viewId
    self gs_set_visible:viewId visible:true
!

setWindowBackground:colorId in:viewId
    self gs_set_background:viewId color:colorId.
!

setWindowName:label in:viewId
!

unmapWindow:viewId
    self gs_set_visible:viewId visible:false
! !

!GuiServerWorkstation methodsFor:'native window stuff'!

changeButtonState:stateBoolean in:id
    out nextPutLine:('set-selected ',id,' ',stateBoolean printString).
!

changeLabel:label in:id
    out nextPutLine:('set-text ',id,' ',(Base64Coder encode:label)).
!

changeList:list in:id
    out nextPutLine:('clear-list ',id).
    list do:[:each |
        out nextPutLine:('add-list-item ',id,' ',(Base64Coder encode:each asString)).
    ].
!

changeText:text in:id
    out nextPutLine:('set-text ',id,' ',(Base64Coder encode:text asString)).
! !

!GuiServerWorkstation methodsFor:'queries'!

displayFileDescriptor
    "return the file descriptor associated with the display
     if any. If there is no underlying filedescriptor, return nil.
     (used for event select/polling)"

    in isNil ifTrue:[^ nil].
    ^ in fileDescriptor
!

displayName
    ^ displayName
!

guiServerPath
    ^ self class defaultGUIServerPath
!

guiServerPort
    ^ self class defaultGUIServerPort
!

isOpen
    "answer true, if device can be used"

    ^ hasConnectionBroken not
        and:[guiServerPid notNil
        and:[in notNil 
        and:[out notNil 
        and:[in isOpen 
        and:[out isOpen]]]]].
!

mayOpenDebugger
    ^ false
!

supportsNativeWidgets
    ^ useNativeWidgets
! !

!GuiServerWorkstation methodsFor:'window stuff'!

moveResizeWindow:aWindowId x:x y:y width:w height:h
    self send:('set-bounds %1 %2 %3 %4 %5' bindWith:aWindowId with:x with:y with:w with:h)
!

moveWindow:aWindowId x:x y:y 
    self send:('set-location %1 %2 %3 %4 %5' bindWith:aWindowId with:x with:y)
!

resizeWindow:aWindowId width:w height:h
    self send:('set-current-size %1 %2 %3' bindWith:aWindowId with:w with:h)
! !

!GuiServerWorkstation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


GuiServerWorkstation initialize!
