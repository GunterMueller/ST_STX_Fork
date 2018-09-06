"
COPYRIGHT (c) 1993 by Claus Gittinger
COPYRIGHT (c) 2016-2017 Jan Vrany
COPYRIGHT (c) 2018 Patrik Svestka
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

HostGraphicsDevice subclass:#DeviceWorkstation
	instanceVariableNames:'visualType monitorType depth ncells bitsPerRGB bitsRed bitsGreen
		bitsBlue redMask greenMask blueMask redShift greenShift blueShift
		hasColors hasGreyscales width height widthMM heightMM
		resolutionHor resolutionVer lastId lastView knownViews
		dispatching dispatchProcess exitOnLastClose ctrlDown shiftDown
		metaDown altDown superDown motionEventCompression keyboardMap
		rootView isSlow activeKeyboardGrab activePointerGrab
		buttonTranslation multiClickTimeDelta altModifiers metaModifiers
		ctrlModifiers shiftModifiers superModifiers buttonModifiers
		supportsDeepIcons preferredIconSize ditherColors fixColors
		numFixRed numFixGreen numFixBlue fixGrayColors copyBuffer
		blackColor whiteColor focusMode activeView clipBoardEncoding
		maxClipBoardSize focusView deviceErrorSignal deviceIOErrorSignal
		mayOpenDebugger suppressDebugger eventSema
		buttonLongPressedHandlerProcess buttonPressTimeForMenu
		aboutToOpenModalWindowHooks aboutToOpenNonModalWindowHooks'
	classVariableNames:'AllScreens ButtonTranslation CopyBufferHistory
		CopyBufferHistorySize CurrentScreenQuerySignal
		DefaultButtonPressTimeForMenu DefaultScreen DeviceErrorSignal
		DeviceIOErrorSignal DeviceIOTimeoutErrorSignal
		DeviceOpenErrorSignal DrawingOnClosedDeviceSignal ErrorPrinting
		ExitOnLastClose LastActiveProcess LastActiveScreen
		MultiClickTimeDelta WindowsRightButtonBehavior'
	poolDictionaries:''
	category:'Interface-Graphics'
!

Object subclass:#DeviceFontMetrics
	instanceVariableNames:'ascent descent maxAscent maxDescent minWidth maxWidth
		averageWidth minCode maxCode direction encoding overHang'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DeviceWorkstation
!

!DeviceWorkstation class methodsFor:'documentation'!

copyright
"
COPYRIGHT (c) 1993 by Claus Gittinger
COPYRIGHT (c) 2016-2017 Jan Vrany
COPYRIGHT (c) 2018 Patrik Svestka
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
    this abstract class defines common protocol to all Display types.
    For compatibility with ST-80, this class (actually a concrete subclass)
    is also bound to the global variable Screen.

    DeviceWorkstation (and its concrete subclasses) are the central classes
    around windowManagement and event processing.
    See the documentation in #events and #workstationDevices for more detailed
    info.

    [instance variables:]

      displayId       <Number>          the device id of the display
      visualType      <Symbol>          one of #StaticGray, #PseudoColor, ... #TrueColor
      monitorType     <Symbol>          one of #monochrome, #color, #unknown

      depth           <SmallInteger>    bits per color
      ncells          <SmallInteger>    number of colors (i.e. colormap size; not always == 2^depth)
      bitsPerRGB      <SmallInteger>    number of valid bits per rgb component
					(actual number taken in A/D converter; not all devices report the true value)
      bitsRed         <SmallInteger>    number of red bits (only valid for TrueColor displays)
      bitsGreen       <SmallInteger>    number of green bits (only valid for TrueColor displays)
      bitsBlue        <SmallInteger>    number of blue bits (only valid for TrueColor displays)
      redMask         <SmallInteger>    shifted red mask (only useful for TrueColor displays)
      greenMask       <SmallInteger>    shifted green mask (only useful for TrueColor displays)
      blueMask        <SmallInteger>    shifted blue mask (only useful for TrueColor displays)
      shiftRed        <SmallInteger>    number of bits to shift red bits (only valid for TrueColor displays)
      shiftGreen      <SmallInteger>    number of bits to shift green bits (only valid for TrueColor displays)
      shiftBlue       <SmallInteger>    number of bits to shift blue bits (only valid for TrueColor displays)

      hasColors       <Boolean>         true, if display supports colors
      hasGreyscales   <Boolean>         true, if display supports grey-scales (i.e is not b/w display)
      width           <SmallInteger>    number of horizontal pixels
      height          <SmallInteger>    number of vertical pixels
      heightMM        <Number>          screen height in millimeter
      widthMM         <Number>          screen width in millimeter
      resolutionHor   <Number>          pixels per horizontal millimeter
      resolutionVer   <Number>          pixels per vertical millimeter

      knownViews      <WeakValueDictionary>  viewId -> view all of my known views

      dispatching     <Boolean>         true, if currently in dispatch loop
      exitDispatchOnLastWindowClose
		      <Boolean>         if true, dispatch is finished when the last
					window closes (default:true).

      ctrlDown        <Boolean>         true, if control key currently pressed
      shiftDown       <Boolean>         true, if shift key currently pressed
      metaDown        <Boolean>         true, if meta key (cmd-key) is currently pressed
      altDown         <Boolean>         true, if alt key is currently pressed

      motionEventCompression
		      <Boolean>         if true motion events are compressed
					(obsolete: now done in sensor)

      lastId          <Number>          the id of the last events view (internal)
      lastView        <View>            the last events view (internal, for faster id->view mapping)

      keyboardMap     <KeyBdMap>        mapping for keys
      rootView        <DisplayRootView> this displays root window
      isSlow          <Boolean>         set/cleared from startup - used to turn off
					things like popup-shadows etc.

      focusMode       <Symbol>          nil, #pointer or #activeWindow
      activeWindow    <View>            WINDOWS only: the currently active (foreground) view

      clipBoardEncoding
		      <Symbol>          encoding of pasted clipBoard text;
					nil means: iso8859.
					set this to #shiftJis, if pasting
					SJIS text (for example, from netscape)
					Some systems pass encoding information
					in the clipBoard - there, this is not
					needed.

    [class variables:]

      MultiClickTimeDelta               in ms; controls how long of a delay is
					required between two clicks, to NOT take
					it as a multi-click.

      ErrorPrinting                     controls low-level (X-) error message printing

      AllScreens                        a collectin of known screens

    [see also:]
	GraphicsContext DeviceDrawable
	WindowSensor WindowGroup WindowEvent
	ProcessorScheduler
	PSMedium

    [author:]
	Claus Gittinger
"
!

events
"
    All events are processed in a workstation's dispatchEvent method.
    There, incoming events are first sent to itself, for a first (view independent)
    preprocessing. For example, the device's state of the shift-, alt-, control and
    meta keys are updated there. After that, the event is forwarded either to
    the view's sensor or to the view directly (if it has no sensor).
    (Sensorless views are a leftover from ancient times and will sooner or
     later vanish - simplifying things a bit. Do not depend on views without
     sensors to work correctly in future versions.)

    This event processing is done by the event dispatcher process, which is
    launched in ST/X's startup sequence (see Smalltalk>>start).
    Event processing is done at a high priority, to allow keyboard processing
    and CTRL-C handling to be performed even while other processes are running.
    The code executed by the event process is found in #startDispatch.

    Individual events can be enabled or disabled.
    The ones that are enabled by default are:
	keypress / keyRelease
	buttonPress / buttonRelease / buttonMotion (i.e. motion with button pressed)
	pointerEnter / pointerLeave

    Other events have to be enabled by sending a corresponding #enableXXXEvent
    message to the view which shall receive those events.
    For example, pointerMotion events (i.e. motion without button being pressed)
    are enabled by: 'aView enableMotionEvent'

    The above is only of interest, if you write your own widget classes;
    existing widgets set things as required in their #initEvents method.
"
!

workstationDevices
"
    In ST/X, all interaction with the graphics device is done through
    an instance of (a subclass) of DeviceWorkstation.
    Every view has a reference to the device it has been created on in
    its 'device' instance variable.

    One particular device instance is bound to the global variable Display:
    this is the default graphics display, on which new views are created
    (however, provisions exist for multi-display operation)

    Currently, there is are twoconcrete display classes (released to the public):

	XWorkstation    - a plain X window interface

	GLXWorkstation  - an X window interface with a GL(tm) (3D graphic library)
			  extension; either simulated (VGL) or a real GL
			  (real GL is only available on SGI machines)

    the following are coming soon:

	OpenGLWorkstation
			- an X window interface with a openGL(tm) (3D graphic library)
			  extension; either simulated (MESA) or a real openGL
			  (real openGL is only available on SGI/NT machines)

	WinWorkstation  - what will that be ?

    An experimental version for a NeXTStep interface exists, but is currently
    no longer maintained and not released.

    DeviceWorkstation itself is an abstract class; the methods as defined
    here perform things which are common to all graphic devices or block
    methods and raise a subclassResponsibilty error condition.
    To create a new graphic interface, at least the subclassResponsibility-methods
    have to be reimplemented in a concrete subclass.

    ST/X is designed to allow the use of multiple workstation devices in parallel,
    if the underlying window system supports this.
    For example, in X, it is possible to create another instance of XWorkstation,
    start a dispatch process for it, and to create and open views on this display.
    Multiple display operation does not work with other devices (i.e. Windows).

    If you want to experiment with multi-display applications,
    you have to:

    - create a new instance of XWorkstation:

	Smalltalk at:#Display2 put:(XWorkstation new).
      or:
	Smalltalk at:#Display2 put:(GLXWorkstation new).


    - have it connect to the display (i.e. the xServer):
      (replace 'localhost' below with the name of your display)

	Display2 := Display2 initializeFor:'localhost:0.0'

      returns nil, if connection is refused
      - leaving you with Display2==nil in this case.


    - start an event dispatcher process for it:
      (this is now no longer needed - the first opened view will do it for you)

	Display2 startDispatch


    - optionally set its keyboard map
      (since this is usually done for Display in the startup-file,
       the new display does not have all your added key bindings)

	Display2 keyboardMap:(Display keyboardMap)


    - create a view for it:

	(FileBrowser onDevice:Display2) open

	(Workspace onDevice:Display2) open

	(Launcher onDevice:Display2) open
	    does not work with Launcher, since its an ApplicationModel (not a view)
	    use:
		Launcher openOnDevice:Display2
	    instead.

    For all of the above, there is now a convenient helper method in
    ApplicationModel, which allows to write:
	Application openOnXScreenNamed:'foo:0'

    However, as mentioned above, there may be a few places, where the default
    display 'Display' is still hard-coded - especially, in contributed and
    Public domain code, you may find those.

    Beside this (little bug ;-), remote display operation works pretty well.
    If you write your application to work around those, multi-display applications are
    possible in the current release (and actually being used in a concrete application,
    where up to 6 x-terminals are connected to a single linux PC).

    To make your application ready for multi-display operation, replace all
    references to 'Display' by: 'Screen current', which evaluates to the currently
    active display. I.e. each view gets its actual display via this expression.
    Since ST/X views already use this, new views opened by remote views should
    come up on the remote display.

    There is no easy solution for things like Notifiers, WarnBoxes or
    Debuggers when opened from some background or non-view process.
    These will come up one the default Display, as returned by 'Screen default'.

    Finally, your application should care for I/O errors (i.e. lost connection when
    a remote display is switched off).
    The framework provides per-display signals, which are raised in the corresponding
    event dispatchers context.
    For a save environment, you should add static exception handler blocks on those
    signals; i.e. the setup for remote displays should look somewhat like:
	|newDpy|

	newDpy := GLXWorkstation new.
	newDpy := newDpy initializeFor:'localhost:0.0'.
	newDpy isNil ifTrue:[
	    self warn:'cannot connect ...'.
	] ifFalse:[
	    newDpy deviceIOErrorSignal handlerBlock:[:ex |
		Transcript beep.
		Transcript showCR:'Display (' , newDpy displayName , '): connection broken.'.
		AbortSignal raise.
	    ].
	    newDpy startDispatch.
	    Launcher openOnDevice:newDpy.
	].

    There may still some problems to be expected,
    if the screens have different display capabilities (b&w vs. greyscale vs.
    color display). The current styleSheet approach keeps default values
    only once (it should do so per display ...)
    For now, expect ugly looking views in this case - or set your styleSheet
    for the smallest common capabilities (i.e. for b&w).
    This may be fixed in a future version ...
"
! !

!DeviceWorkstation class methodsFor:'initialization'!

initialize
    "create local error signals; enable errorPrinting"

    DeviceErrorSignal isNil ifTrue:[
	DeviceErrorSignal := (Signal new) mayProceed:true.
	DeviceErrorSignal notifierString:'device error'.
	DeviceErrorSignal nameClass:self message:#deviceErrorSignal.

	DeviceOpenErrorSignal := DeviceErrorSignal newSignalMayProceed:true.
	DeviceOpenErrorSignal nameClass:self message:#deviceOpenErrorSignal.
	DeviceOpenErrorSignal notifierString:'cannot open device'.

	DeviceIOErrorSignal := (Signal new) mayProceed:false.
	DeviceIOErrorSignal notifierString:'device IO error'.
	DeviceIOErrorSignal nameClass:self message:#deviceIOErrorSignal.

	DeviceIOTimeoutErrorSignal := DeviceIOErrorSignal newSignalMayProceed:false.
	DeviceIOTimeoutErrorSignal notifierString:'device IO timeout error'.
	DeviceIOTimeoutErrorSignal nameClass:self message:#deviceIOTimeoutErrorSignal.

	CurrentScreenQuerySignal := QuerySignal new.
	CurrentScreenQuerySignal nameClass:self message:#currentScreenQuerySignal.
	CurrentScreenQuerySignal notifierString:'asking for current screen'.

	DrawingOnClosedDeviceSignal := DeviceErrorSignal newSignalMayProceed:true.
	DrawingOnClosedDeviceSignal nameClass:self message:#drawingOnClosedDeviceSignal.
	DrawingOnClosedDeviceSignal notifierString:'drawing attempt on closed graphics device'.
    ].

    ErrorPrinting := true.

    self initializeConstants.

    "/ for ST80 compatibility ...
    Screen := self.

    "Modified: 3.8.1997 / 18:14:58 / cg"
!

initializeConstants
    "initialize some (soft) constants"

    MultiClickTimeDelta := 300.             "a click within 300ms is considered a double one"
    CopyBufferHistorySize := 20.
    ButtonTranslation isNil ifTrue:[
	ButtonTranslation := #(1 2 2 2 2 2 2)  "all other buttons to middleButton menu"
	"/ ButtonTranslation := #(1 2 3 4 5 6 7)  "identity translation"
    ].

    "Modified: / 25-08-2010 / 21:57:43 / cg"
!

nativeWindows:aBoolean
    "enable / disable use of native windows - dummy here."

! !

!DeviceWorkstation class methodsFor:'instance creation'!

newDispatchingFor:aScreenName
    "create a new instance of mySelf, which serves aDeviceName.
     Only useful for device-classes which support multiple devices -
     i.e. X-Workstations"

    |newDevice someScreen|

    newDevice := self newFor:aScreenName.
    newDevice startDispatch.
    (someScreen := Screen current) isNil ifTrue:[
	someScreen := Screen default.
    ].
    someScreen notNil ifTrue:[
	newDevice keyboardMap:(someScreen keyboardMap).
	newDevice buttonTranslation:(someScreen buttonTranslation).
    ].

    "/ arrange for it to finish its event dispatch loop,
    "/ when the last view on it is closed.
    newDevice exitOnLastClose:true.

    ^ newDevice.
!

newFor:aDisplayName
    "Create an new instance for a connection to aDisplayName.
     If aDisplayName is nil, a connection to the standard display is opened"

    ^ self basicNew initializeFor:aDisplayName
!

openDefaultDisplay:aStringOrNil
    "open the default display. aStringOrNil may be the display name,
     if nil, the name is extracted from command-line-arguments or the environment.
     Raise a signal if open fails."

    |display displayName|

    displayName := aStringOrNil ? Screen defaultDisplayName.

    "find out about the concrete Workstation class"
    Screen isAbstract ifTrue:[
	|wsClass wsClasses|

	wsClasses := OrderedCollection new.

	#(OpenGLWorkstation GLXWorkstation XWorkstation)
	    detect:[:eachClassNameSymbol| (wsClass := Smalltalk classNamed:eachClassNameSymbol) notNil] ifNone:nil.
	wsClass notNil ifTrue:[wsClasses add:wsClass].

	"preparation for WIN32/NeXTStep/OS2 and Mac interfacing;
	 But if X11 is linked in and it is capable of setting up a connection, that will be used."
	#(
	    "/ #NeXTWorkstation  nil
	    OS2Workstation   isOS2like
	    MacWorkstation   isMAClike
	    WinWorkstation   isMSWINDOWSlike
	) pairWiseDo:[:wsClassName :checkSel|
	    (checkSel isNil or:[OperatingSystem perform:checkSel]) ifTrue:[
		(wsClass := Smalltalk classNamed:wsClassName) notNil ifTrue:[
		    wsClasses add:wsClass.
		]
	    ].
	].

	"/ try all classes until open of display works.
	wsClasses detect:[:cls|
		[
		    display := cls newFor:displayName.
		] on:Screen deviceOpenErrorSignal do:[:ex| ].
		display notNil
	    ] ifNone:nil.

    ] ifFalse:[
	display := Screen newFor:displayName.
    ].
    display isNil ifTrue:[
	Screen deviceOpenErrorSignal raiseWith:displayName.
    ].
    Screen := display class.
    Screen default:display.
! !

!DeviceWorkstation class methodsFor:'Signal constants'!

currentScreenQuerySignal
    "return the signal which can be used to provide a current
     screen (if background processes ask for one)"

    CurrentScreenQuerySignal isNil ifTrue:[
	DeviceWorkstation initialize
    ].
    ^ CurrentScreenQuerySignal

    "Created: 15.2.1997 / 15:07:20 / cg"
!

deviceErrorSignal
    "return the signal used for device error reporting.
     In multi-display configurations, this is the parent of
     all per-instance deviceErrorSignals."

    ^ DeviceErrorSignal
!

deviceIOErrorSignal
    "return the signal used for device I/O error reporting.
     In multi-display configurations, this is the parent of
     all per-instance deviceIOErrorSignals."

    ^ DeviceIOErrorSignal
!

deviceIOTimeoutErrorSignal
    "return the signal used for device I/O timeout error reporting.
     In multi-display configurations, this is the parent of
     all per-instance deviceIOTimeoutErrorSignals."

    ^ DeviceIOTimeoutErrorSignal
!

deviceOpenErrorSignal
    "return the signal used for reporting of errors while opening a device."

    ^ DeviceOpenErrorSignal
!

drawingOnClosedDeviceSignal
    ^  DrawingOnClosedDeviceSignal
! !

!DeviceWorkstation class methodsFor:'accessing'!

default
    "ST-80 compatibility.
     Return the default screen. This is typically the first opened
     Display screen in a session. Use of the global variable Display
     should vanish over time - replace it by Screen default."

    ^ DefaultScreen ? Display

    "
     Screen default
    "
!

default:aDevice
    "Set the default screen. This is sent very early during startup,
     and assigns the first opened screenDevice to both Display and the default
     screen."

    |old|

    old := DefaultScreen.
    DefaultScreen := aDevice.

    "as long as global variable Display exists, set it too"
    Display := aDevice.

    old ~~ aDevice ifTrue:[
	DisplayRootView initialize.
    ].
! !

!DeviceWorkstation class methodsFor:'clipboard support'!

bufferAsString:aBuffer
    "aBuffer (my current selection) as a string"

    aBuffer isString ifTrue:[
	^ aBuffer string.
    ].

    aBuffer isNil ifTrue:[
	^ ''
    ].

    aBuffer isStringCollection ifTrue:[
	^ aBuffer
	    from:1
	    to:aBuffer size
	    asStringWith:Character cr
	    compressTabs:false
	    final:nil
	    withEmphasis:false.
    ].

    Error handle:[:ex |
	Transcript showCR:'error while converting copyBuffer to store string: ', ex description.
	Error handle:[:ex |
	   Transcript showCR:'error while converting copyBuffer to print string: ', ex description.
	   ^ ''
	] do:[
	   ^ aBuffer printString
	]
    ] do:[
       ^ aBuffer storeString
    ]

    "Created: / 13.2.1997 / 13:10:30 / cg"
    "Modified: / 20.1.1998 / 14:11:01 / stefan"
! !

!DeviceWorkstation class methodsFor:'defaults'!

defaultButtonPressTimeForMenu
    ^ DefaultButtonPressTimeForMenu ? 1
!

defaultButtonPressTimeForMenu:seconds
    DefaultButtonPressTimeForMenu := seconds
!

defaultKeyboardMapDefinition
    "
     Return a default shortcut bindings. See comment in
     KeyboardMap >> loadKeyboardMapDefinition: for the description of definition
     format."

    ^ #(
"/      Logical             Shortcut        Aliases    Description
"/      ================================================================================

    (   Cmd                 Alt             (Menu Mode_switch)                              )
    (   Menu                Cmdz            (Appl CtrlAppl CmdAppl) 'Show context menu'     )

"/  (   Hardcopy            #'Super_R'                                                      )
    (   Alt                 #'Super_L'      #'Hyper_R'                                      )

    (   UserInterrupt       Break           (#'Cmd.' #'Ctrl.') 'Interrupt - enter debugger' )
    (   UserAbort           CtrlBreak       (CtrlCancel CtrlPause CmdY) 'Abort - do not enter debugger' )
    (   FlushInput          CtrlX                       'Flush (trow away) typeahead input' )
                                    
"/  (   DestroyView         CmdCtrlX                                                        )
"/  (   DestroyTopView      CmdCtrlX                                                        )

"/  (   CloseWindowRequest  CmdF4                       'Close active window'               )

    (   DoIt                Cmdd            Ctrld       'DoIt - evaluate expression'        )
    (   InspectIt           Cmdi            Ctrlq       'InspectIt - evaluate expression and inspect result')  
    (   PrintIt             Cmdp            Ctrlp       'PrintIt - evaluate expression and print result')
    (   ReplaceIt           CmdP                        'Replace selection with result of expression evaluation')

    (   BrowseIt            Cmdb            #(CmdB CtrlB)'Evaluate expression and browse result''s class')
    (   ImplementorsOfIt    Cmdm            #(CmdI CtrlI)'Browse implementors of selected selector')
    (   SendersOfIt         Cmdn            #CmdS        'Browse senders of selected selector')


"/      Logical             Shortcut        Aliases     Description
"/      ===========================================================

    (   ToggleInsertMode    AltInsert                                                       )

    (   Cut                 Ctrlx           Cmdx        'Cut'                               )
    (   Copy                Ctrlc           (Cmdc CtrlInsert) 'Copy'                        )
    (   Paste               Ctrlv           (Cmdv ShiftInsert) 'Paste'                      )

    (   PasteFromHistory    CtrlV           CmdV                                            )

    (   Replace             Cmdr            Ctrlr       'Replace'                           )
    (   Join                Cmdj            Ctrlj                                           )

    (   Find                Ctrlf           Cmds        'Search (open search dialog)'       )
    (   FindNext            Cmdf                        'Forward search (selection or previous search pattern)'  )
    (   FindPrev            Cmdb            Ctrlb       'Backward search (selection or previous search pattern)' )
    (   SelectAll           Ctrla           CmdA        'Select all'                        )
    (   GotoLine            Ctrlg           Ctrll       'Go to line'                        )
    (   SelectWord          Cmdw                        'Select Word under cursor'          )
    (   Undo                Ctrlz                       'Undo last operation'               )
    (   Redo                Ctrly                       'Redo last operation'               )
    (   Accept              Cmda            Ctrls       'Accept / Save (compile or save)'   )
    (   SaveAs              CmdS            CtrlS       'Save as (a file)'                  )
    (   Explain             Cmde            Cmdh        'Explain code'                      )
    (   Format              CmdF                                                            )


"/      Logical             Shortcut        Aliases     Description                         )
"/      ===========================================================

"/  (   DeleteLine          CtrlX                                                           )
    (   NextPage            Next                                                            )
    (   PreviousPage        Prior                                                           )
"/  (   HalfPageUp          Ctrlu                                                           )
"/  (   HalfPageDown        Ctrld                                                           )
    (   BeginOfLine         Home                        'Goto begin of line'                )
    (   BeginOfText         CtrlHome                    'Goto begin of whole text'          )

    (   EndOfLine           End             Ctrle       'Goto end of line'                  )
    (   EndOfText           CtrlEnd                     'Goto end of whole text'            )
    (   EndOfWord           CtrlW                       'Goto end of word under cursor'     )

    (   NextWord            CtrlCursorRight Ctrlw       'Move to next word'                 )
    (   PreviousWord        CtrlCursorLeft              'Move to previous word'             )

    (   ScrollUp            CtrlCursorUp                                                    )
    (   ScrollDown          CtrlCursorDown                                                  )

"/  (   SearchMatchingParent  Ctrlm                                                         )
    (   SelectMatchingParents Ctrlm                     'Select up to matching parenthesis' )

    (   SelectToEnd          CtrlE                      'Select from end of text'           )
    (   SelectFromBeginning  CtrlA                      'Select from beginning of text'     )
    (   ExpandSelectionByLine Cmdl                                                          )
    (   ExpandSelectionByWord CmdW                                                          )
    (   DeleteWordBeforeCursor CtrlBackSpace                                                )
    (   Return               KP_Enter                                                       )
    (   Delete               OK_Delete                                                      )

"/      Logical             Shortcut        Aliases     Description
"/      ===========================================================
    (   ZoomIn              #'Ctrl+'                                                        )
    (   ZoomOut             #'Ctrl-'                                                        )
    (   ZoomInAll           #'Ctrl*'                                                        )
    (   ZoomOutAll          #'Ctrlunderscore'                                               )

    (   FocusNext           CmdCursorRight  (CmdCursorDown AltCursorRight AltCursorDown CmdTab))
    (   FocusPrevious       CmdCursorLeft   (CmdCursorUp AltCursorLeft AltCursorUp #'CmdISO_Left_Tab'))

    (   NonInsertingTab     ShiftTab        #'ISO_Left_Tab'                                 )
    (   BackTab             CtrlTab                                                         )
"/  (   ToggleTabs          CtrlTab                                                         )

    (   Help                F1                          'Help / Explain code'               )
    (   Rename              F2                          'Rename'                            )
    (   CommentSelection    F3                          'Comment selection'                 )
    (   UncommentSelection  F4                          'Uncomment selection'               )
"/  (                       F5                                                              )
    (ConvertSelectionToLowercaseOrUppercaseOrUppercaseFirst                       
    	                    F6                          'Selection to lowercase/UPPERCASE/UpperCaseFirst (toggle through)' )
"/  (                       F7                                                              )
    (   Again               F8                          'Again (repeat last cut/replace)'   )
    (   UndentBy4           F9                          'Undent by 4 (move block to left)'  )
    (   IndentBy4           F10                         'Indent by 4 (move block to right)' )
    (   UndentBy1           F11                         'Undent by 1 (move block to left)'  )
    (   IndentBy1           F12                         'Indent by 4 (move block to right)' )

    (   ParenthizeSelection #'Cmd('                     'Add parentheses around selection'  )
    (   UnparenthizeSelection #'Cmd)'   	        'Remove parentheses'                )
    (   LearnKeyboardMacro  CmdL  		CtrlF2  'Enter/leave learn macro mode (CmdM) to replay macro)' )
    (   ExecuteKeyboardMacro CmdM               CmdF2   'Execute keyboard Macro (CMD-L to learn)' )

    (   ConvertSelectionToUppercase                       
    	                    CtrlF6                      'Selection to UPPERCASE'            )    
    (   ExpandAbbreviation   #'Cmd '                    'Insert Abbreviation (try <ALT-SPACE> behind the string ''it'')')                                    
    (   CodeCompletion       #'Ctrl '		#'Ctrlspace'				    )


"/      Logical             Shortcut        Aliases     Description
"/      ===========================================================

"/	Following was used only on NON-macOS systems, not sure why. In case it 
"/      would cause problems, refactor. I cannot test now ans would like to make
"/      the code simpler. 

    (   $[                  #'Cmd['         #'Alt['                         )
    (   $]                  #'Cmd]'         #'Alt]'                         )
    (   $|                  #'Cmd|'         #'Alt|'                         )
    (   ${                  #'Cmd{'         #'Alt{'                         )
    (   $}                  #'Cmd}'         #'Alt}'                         )
    (   $\                  #'Cmd\'         #'Alt\'                         )
    (   $~                  #'Cmd~'         #'Alt~'                         )
    (   $@                  #'Cmd@'         #'Alt@'                         )
    (   $#                  #'Cmd#'         #'Alt#'            	            )
    
    )
    "
    DeviceWorkstation defaultKeyboardMapDefinition.

    Screen current
        instVarNamed: #keyboardMap put: nil;
        initializeKeyboardMap;
        keyboardMap.

    Screen current keyboardMap. 
    "

    "Created: / 12-05-2017 / 21:51:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 14-05-2017 / 10:41:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DeviceWorkstation class methodsFor:'error handling'!

errorInterrupt:errID with:aParameter
    "{ Pragma: +optSpace }"

    "an error in the devices low level code (typically Xlib or XtLib)
     This is invoked via
	XError->errorInterrupt:#DisplayError->registeredErrorInterruptHandlers
     or
	XError->errorInterrupt:#DisplayIOError->registeredErrorInterruptHandlers

     looks if a signal handler for DeviceErrorSignal is present,
     and - if so raises the signal.
     If the signal not handled, simply output a message and continue.
     This allows for non disrupted error reporting OR to catch and
     investigate errors as required.
     However, io-errors are always delivered as a signal raise."

    |badResource msg theDevice theSignal p signalHolder|

    errID notNil ifTrue:[
	"/
	"/ timeoutError passes the device;
	"/ the others pass the devicesID
	"/
	errID == #DisplayIOTimeoutError ifTrue:[
	    theDevice := aParameter.
	    "/ 'device timeout error' printCR.
	] ifFalse:[
	    AllScreens do:[:aDisplayDevice |
		aDisplayDevice id = aParameter ifTrue:[
		    theDevice := aDisplayDevice.
		]
	    ]
	]
    ].

    "/ now, we have the bad guy at hand ...
    "/ get a per-instance signal.

    signalHolder := theDevice ? self.
    errID == #DisplayIOError ifTrue:[
	"always raises an exception"
	theSignal := signalHolder deviceIOErrorSignal.
	msg := 'Display I/O Error'.
	badResource := theDevice.
    ] ifFalse:[errID == #DisplayIOTimeoutError ifTrue:[
	"always raises an exception for the current process"
	theSignal := signalHolder deviceIOTimeoutErrorSignal.
	msg := 'Display I/O timeout Error'.
	badResource := theDevice.
    ] ifFalse:[ "errID == #DisplayError"
	"only raises an exception if handled"
	theSignal := signalHolder deviceErrorSignal.
	theDevice notNil ifTrue:[
	    "/ #resourceIdOfLastError will become instance-specific information in
	    "/ the near future ...
	    badResource := theDevice resourceOfId:self resourceIdOfLastError.
	].
	msg := 'Display error: ' , self lastErrorString.
    ]].
    Logger info:'%1 - %2' with:msg with:badResource.


    "interrupt that displays dispatch process
     and force it to shutdown"

    "DiplayIOTimeoutError is a synchronous event, that should hit the process
     that caused the timeout."

    (errID ~~ #DisplayIOTimeoutError and:[theDevice notNil]) ifTrue:[
	p := theDevice dispatchProcess.
	(p notNil and:[p ~~ Processor activeProcess]) ifTrue:[
	    Logger info:'interrupting: %1' with:p.

	    p interruptWith:[
		(errID == #DisplayError and:[theSignal isHandled not]) ifTrue:[
		    "unhandled display errors are ignored"
		    ErrorPrinting ifTrue:[
			Logger error:msg.
		    ].
		] ifFalse:[
		    Logger info:'raising exception ...'.
		    theSignal raiseSignalWith:badResource errorString:msg.
		    Logger warning:'exception returned - send brokenConnection'.
		    theDevice brokenConnection.
		    Logger warning:'stopping dispatch'.
		    theDevice stopDispatch.
		].
	    ].
	    ^ self.
"/            Processor reschedule.
"/            AbortOperationRequest raise.
	].
    ].

    "If we come here, this is a DiplayIOTimeoutError, we don't know
     the display device or we are running on top of the dispatchProcess"

    (theSignal isHandled or:[theSignal handlerBlock notNil]) ifTrue:[
	Logger info:'raising signal in current process' "with:Processor activeProcess displayString".
	theSignal raiseSignalWith:badResource errorString:msg.
    ].

    errID == #DisplayError ifTrue:[
	"unhandled display errors are ignored"
	^ self.
    ].

    theDevice notNil ifTrue:[
	Logger info:'sending #brokenConnection'.
	theDevice brokenConnection.
	theDevice dispatchProcess == Processor activeProcess ifTrue:[
	    "I am running in the dispatch process
	     and nobody handles theSignal, so abort the dispatcher"

	    Logger info:'raising AbortOperationRequest'.
	    AbortOperationRequest raise.
	] ifFalse:[
	    "Some other process (probably not even guilty - like someone doing a draw after a change) ...
	      ... see if we can unwind out of the drawing operation"

	    |context|

"/            thisContext fullPrintAll.
	    context := thisContext.
	    [
		"find the first returnable context where theDevice is the receiver"
		context := context sender.
	    ] doUntil:[
		context isNil or:[context receiver == theDevice and:[context canReturn]].
	    ].
	    context notNil ifTrue:[
		Logger info:'unwind the draw operation: %1'
		       with:context methodPrintString.
"/                context fullPrintAll.
		context unwind.
		"not reached"
	    ].
	]
    ].
    Logger info:'proceeding after error'.

    "Modified: 11.4.1997 / 11:28:27 / cg"
!

errorPrinting
    "return the `errorPrinting-is-on' flag"

    ErrorPrinting isNil ifTrue:[^ false].
    ^ ErrorPrinting

    "Modified: 24.4.1996 / 19:35:55 / cg"
!

errorPrinting:aBoolean
    "set/clear the `errorPrinting-is-on' flag"

    ErrorPrinting := aBoolean

    "Modified: 24.4.1996 / 19:36:02 / cg"
!

lastErrorString
    "return a string describing the last error"

    ^ self subclassResponsibility
!

resourceIdOfLastError
    "return the resource id responsible for the last error"

    ^ self subclassResponsibility
! !

!DeviceWorkstation class methodsFor:'queries'!

allScreens
    "Return a collection of active display devices.
     Typically, there is only one: Display or Screen current."

    ^ AllScreens ? #()

    "
     Screen allScreens
    "

    "Modified: 1.9.1995 / 13:38:35 / claus"
    "Modified: 18.8.1997 / 18:43:42 / cg"
!

current
    "Return the currently active screen,
     that is, the device of the currently executing windowGroup.
     It will be used in multi-display operation, to launch views on
     the correct device - even if not specified explicitely.
     This does not yet work fully satisfying if a background processes
     invokes this ... the default display is returned in this case.
     In a headless (i.e. non-GUI) application, nil is returned."

    |wg dev thisProcess|

    "/
    "/ if there is only one screen,
    "/ take that ... it ought to be the Display
    "/
    AllScreens size <= 1 ifTrue:[
        LastActiveProcess := LastActiveScreen := nil.
        Display notNil ifTrue:[
            ^ Display
        ]
    ].

    "/
    "/ someone willing to tell me ?
    "/
    (dev := self currentScreenQuerySignal query) notNil ifTrue:[
        ^ dev
    ].

    thisProcess := Processor activeProcess.
    LastActiveScreen notNil ifTrue:[
        LastActiveProcess == thisProcess ifTrue:[
            ^ LastActiveScreen
        ]
    ].

    "/
    "/ mhmh - multiple screens are active;
    "/ look for the active windowGroups screen.
    "/ Be careful, to not run into an error in case
    "/ the current windowGroup got corrupted somehow ...

    (wg := WindowGroup activeGroup) notNil ifTrue:[
        "/
        "/ ok, not a background process or scheduler ...
        "/
        (dev := wg graphicsDevice) notNil ifTrue:[
            LastActiveScreen := dev.
            LastActiveProcess := thisProcess.
            ^ dev
        ].
    ].

    "/
    "/ in all other cases, return the default display
    "/ (which may be nil in a headless system)
    "/
"/    'DevWorkstation [info]: cannot figure out current screen - use default' infoPrintCR.

    Display isNil ifTrue:[
        'DevWorkstation [info]: Display is nil.' infoPrintCR.
    ].    
    ^ Display

    "
     Screen current

     |s|
     Transcript topView windowGroup process interruptWith:[s := Screen current].
     Delay waitForSeconds:0.5.
     s inspect
    "

    "Modified: / 1.9.1995 / 13:40:05 / claus"
    "Modified: / 7.2.1997 / 16:16:58 / cg"
    "Modified: / 18.3.1999 / 18:20:39 / stefan"
!

currentWindow
    "Return the currently active window,
     that is, the topView of the currently executing windowGroup"

    |wg|

    wg := WindowGroup activeGroup.
    wg notNil ifTrue:[^ wg topViews first].
    ^ nil

    "
     Screen currentWindow
    "

    "Modified: / 1.9.1995 / 13:40:05 / claus"
    "Modified: / 7.2.1997 / 16:16:58 / cg"
    "Created: / 14.11.1997 / 21:52:24 / cg"
!

defaultDisplayName
    "extract the default display name from command line arguments
     and environment. Nil is a valid name which represents the builtin default"

    |displayName|

    "look for a '-display xxx' commandline argument"
    displayName := Smalltalk commandLineArgumentNamed:'-display'.
    displayName isNil ifTrue:[
	displayName := OperatingSystem getEnvironment:'DISPLAY'.
    ].
    ^ displayName.

    "
     self defaultDisplayName
    "
!

flushCachedLastScreen
    LastActiveScreen := nil.
    LastActiveProcess := nil.

!

isAbstract
    "answer true, if I am not a concrete Workstation class"

    ^ self == DeviceWorkstation

    "
     DeviceWorkstation isAbstract
     XWorkstation isAbstract
    "
!

isWindowsPlatform
    ^ false
!

isX11Platform
    ^ false
!

platformName
    "ST-80 compatibility.
     Return a string describing the display systems platform.
     Returns a dummy here. This must be redefined in concrete
     Workstation classes, to return somthing like 'X11', 'win32', 'os2' etc."

    ^ #unknown
! !

!DeviceWorkstation class methodsFor:'standalone setup'!

exitOnLastClose:aBoolean
    "set/clear the flag which controls if the
     event dispatching should stop when the last view is closed
     on the (main) Display connection.
     (standAlone applications will set it)"

    "/ here, a separate class variable is used, since this may have
    "/ to be set at init-time, when no display instance exists yet.
    "/ For all other (non-main-Display) connections, an instVar is used.

    ExitOnLastClose := aBoolean

    "Modified: 23.4.1996 / 22:01:28 / cg"
! !

!DeviceWorkstation methodsFor:'Compatibility-ST80'!

colorDepth
    "alias for depth - for ST-80 compatibility"

    ^ self depth
!

colorPalette
    "alias for colorMap - for ST-80 compatibility"

    ^ self colorMap
!

stackedWindows
    "supposed to return all topViews in stacking order;
     BUGGY: right now, the order is undefined"

    ^ self allTopViews
!

zoom:startRect to:endRect
    "animate a rubber-rectangle from startRect to endRect.
     Can be used by buttons, which open some dialog for nicer user feedback.
     Notice: since the displays window manager typically allows a topWindow
	     to be placed by the user, this should not be used for modeless
	     topViews.
    "

    ^ self zoom:startRect to:endRect duration:300

    "
     Screen current zoom:(10@10 corner:20@20) to:(20@20 corner:1000@1000)
     Screen current zoom:(20@20 corner:1000@1000) to:(10@10 corner:20@20)
    "

    "Modified: 27.1.1997 / 18:20:11 / cg"
!

zoom:startRect to:endRect duration:milliseconds
    "animate a rubber-rectangle from startRect to endRect.
     Can be used by buttons, which open some dialog for nicer user feedback.
     Notice: since the displays window manager typically allows a topWindow
	     to be placed by the user, this should not be used for modeless
	     topViews.
    "

    |steps dExt dOrg org ext root|

    root := self rootView.

    steps := 10.
    dExt := (endRect extent - startRect extent) / steps.
    dOrg := (endRect origin - startRect origin) / steps.
    0 to:steps do:[:step |
	org := (startRect origin + (dOrg * step)) rounded.
	ext := (startRect extent + (dExt * step)) rounded.
	root clippedByChildren:false.
	root xoring:[
	    root displayRectangleX:org x y:org y width:ext x height:ext y
	].
	Delay waitForMilliseconds:(milliseconds // steps).
	root xoring:[
	    root displayRectangleX:org x y:org y width:ext x height:ext y
	].
    ].
    root clippedByChildren:true.

    "
     Screen current zoom:(10@10 corner:20@20) to:(20@20 corner:1000@1000) duration:1000
     Screen current zoom:(20@20 corner:1000@1000) to:(10@10 corner:20@20) duration:1000
    "

    "Created: 27.1.1997 / 18:19:35 / cg"
!

zoom:startRect to:endRect speed:pixelsPerSecond
    "animate a rubber-rectangle from startRect to endRect.
     Can be used by buttons, which open some dialog for nicer user feedback.
     The speed is computed for the longest edge to run at the given speed.
     Notice: since the displays window manager typically allows a topWindow
	     to be placed by the user, this should not be used for modeless
	     topViews.
    "

    |maxDistance|

    maxDistance := (endRect origin - startRect origin).
    maxDistance := maxDistance max:(endRect topRight - startRect topRight).
    maxDistance := maxDistance max:(endRect bottomLeft - startRect bottomLeft).
    maxDistance := maxDistance max:(endRect corner - startRect corner).
    maxDistance := maxDistance x max:(maxDistance y).
    ^ self
	zoom:startRect to:endRect duration:(maxDistance abs / pixelsPerSecond * 1000)

    "
     Screen current zoom:(10@10 corner:20@20) to:(20@20 corner:1000@1000) speed:1000
     Screen current zoom:(20@20 corner:1000@1000) to:(10@10 corner:20@20) speed:10
    "

    "Created: 27.1.1997 / 18:19:35 / cg"
    "Modified: 27.1.1997 / 18:24:58 / cg"
! !

!DeviceWorkstation methodsFor:'Compatibility-Squeak'!

border:aRectangle width:bw
    "draw a rectangular border on the display with black.
     Added to allow for some squeak examples to be evaluated ..."

    |r root|

    root := self rootView.

    root clippedByChildren:false.
    root paint:self blackColor.
    r := aRectangle.
    0 to:bw-1 do:[:i |
	root displayRectangle:r.
	r := r insetBy:1.
    ].
    root clippedByChildren:true.

    "
     Display restoreAfter:[
	Display border:(10@10 corner:100@100) width:2.
     ]
    "

    "Modified: 15.10.1997 / 19:23:28 / cg"
!

cursorPoint
    "ST-80 compatibility: 
     return the position of the mouse pointer on this display
     (in screen coordinates)"

    ^ self pointerPosition

    "Modified (comment): / 17-11-2016 / 22:10:20 / cg"
!

displayOpaqueString:s x:x y:y
    "draw a string on the display with black.
     Added to allow for some squeak examples to be evaluated ..."

    |root|

    root := self rootView.

    root clippedByChildren:false.
    root paint:self blackColor.
    root displayOpaqueString:s x:x y:y.
    root clippedByChildren:true.

    "
     Display restoreAfter:[
	Display displayOpaqueString:'hello' x:10 y:10.
     ]
    "

    "Created: 15.10.1997 / 19:25:09 / cg"
    "Modified: 15.10.1997 / 19:29:05 / cg"
!

displayString:s x:x y:y
    "draw a string on the display with black.
     Added to allow for some squeak examples to be evaluated ..."

    |root|

    root := self rootView.

    root clippedByChildren:false.
    root paint:self blackColor.
    root displayString:s x:x y:y.
    root clippedByChildren:true.

    "
     Display restoreAfter:[
	Display displayString:'hello' x:10 y:10.
     ]
    "

    "Modified: 15.10.1997 / 19:29:10 / cg"
!

fill:aRectangle fillColor:aColor
    "fill a rectangular area on the display with aColor.
     Added to allow for some squeak examples to be evaluated ..."

    |oldPaint root|

    root := self rootView.

    oldPaint := root paint.
    root clippedByChildren:false.
    root paint:aColor.
    root fillRectangle:aRectangle.
    root clippedByChildren:true.
    root paint:oldPaint.

    "
     Display restoreAfter:[
	 Display fill:(10@10 corner:100@100) fillColor:Color yellow
     ]
    "

    "Modified: 15.10.1997 / 19:28:17 / cg"
!

fillWhite
    "fill all of the display with white.
     Added to allow for some squeak examples to be evaluated ..."

    self fillWhite:(self bounds)

    "
     Display restoreAfter:[
	 Display fillWhite
     ]
    "
    "
     Display restoreAfter:[
	 Display fillWhite:(10@10 corner:100@100)
     ]
    "

    "Modified: 15.10.1997 / 19:28:17 / cg"
!

fillWhite:aRectangle
    "fill a rectangular area on the display with white.
     Added to allow for some squeak examples to be evaluated ..."

    self fill:aRectangle fillColor:Color white

    "
     Display restoreAfter:[
	 Display fillWhite:(10@10 corner:100@100)
     ]
    "

    "Modified: 15.10.1997 / 19:28:17 / cg"
!

primMouseButtons
    "return the current button state"

    |mask|

    mask := 0.
    self leftButtonPressed ifTrue:[ mask := mask bitOr:4 ].
    self middleButtonPressed ifTrue:[ mask := mask bitOr:2 ].
    self rightButtonPressed ifTrue:[ mask := mask bitOr:1 ].
    ^ mask

    "
     Display primMouseButtons
    "

    "Modified: 15.10.1997 / 19:23:28 / cg"
!

restoreAfter:aBlock
    "evaluate aBlock, wait for a buttonPress, then restore the display.
     Added to allow for some squeak examples to be evaluated ..."

    aBlock value.
    self sync.
    [self anyButtonPressed] whileFalse:[].
    self restoreWindows.

    "
     Display restoreAfter:[Display fillWhite:(10@10 corner:100@100)]
    "

    "Modified: 15.10.1997 / 19:43:08 / cg"
!

supportsDisplayDepth:givenDepth
    "return true, if the given depth is supported by the display.
     (Actually, some displays support multiple depths (i.e. visuals),
     but for now, we want the displays native depth here."

    ^ depth == givenDepth
!

waitButton
    "wait for any button to be pressed"

    [self anyButtonPressed] whileFalse:[Delay waitForSeconds:0.05].

    "
     Sensor waitButton.
     Sensor waitNoButton
    "
!

waitClickButton
    "wait for any button to be pressed and released again.
     Return the screen coordinate of the click."

    |pos|

    self waitButton.
    pos := self pointerPosition.
    self waitNoButton.
    ^ pos

    "
     Sensor waitClickButton.
    "

    "Modified: / 17-11-2016 / 22:10:39 / cg"
!

waitNoButton
    "wait for no button to be pressed"

    [self anyButtonPressed] whileTrue:[Delay waitForSeconds:0.05].

    "
     Sensor waitButton.
     Sensor waitNoButton
    "
! !

!DeviceWorkstation methodsFor:'Signal constants'!

deviceErrorSignal
    "return the per-device signal, which is used for error reporting.
     The default here is the global DeviceErrorSignal
     (which is the parent of any per-instance error signals)."

    deviceErrorSignal notNil ifTrue:[^ deviceErrorSignal].
    ^ self class deviceErrorSignal
!

deviceIOErrorSignal
    "return the signal used for device I/O error reporting.
     The default here is the global DeviceIOErrorSignal
     (which is the parent of any per-instance I/O error signals)."

    deviceIOErrorSignal notNil ifTrue:[^ deviceIOErrorSignal].
    ^ self class deviceIOErrorSignal
!

deviceIOTimeoutErrorSignal
    "return the signal used for device I/O timeout error reporting.
     The default here is the global DeviceIOTimeoutErrorSignal
     (which is the parent of any per-instance I/O timeout signals)."

    ^ self class deviceIOTimeoutErrorSignal
! !

!DeviceWorkstation methodsFor:'accessing & queries'!

activateOnClick:aBoolean
    "enable/disable raise&activate on click;
     return the previous setting.
     This may be left unimplemented by a device."

    ^ false

    "Created: / 2.10.1998 / 01:07:51 / cg"
!

activeView
    ^ activeView

    "
     Display activeView
    "
!

allViews
    "return a collection of all my known views"

    ^ knownViews asIdentitySet.

    "Created: / 14.2.1997 / 14:29:43 / cg"
    "Modified: / 19.1.2000 / 10:07:05 / cg"
!

buttonMotionMask:aMask includesButton:aButton
    "given a device button mask, return true if a logical button
     (1 .. 3 for left .. right) is included."

    |buttonNr|

    "reverse buttonTranslation"
    buttonTranslation notNil ifTrue:[
	buttonNr := buttonTranslation indexOf:aButton ifAbsent:[1].
    ] ifFalse:[
	buttonNr := aButton.
    ].
    ^ (aMask bitTest:(self buttonMotionMask:buttonNr))
!

colorAt:aPoint
    |img|

    img := Image fromScreen:(aPoint corner:aPoint+1) on:self grab:false.
    ^ img colorAt:0@0

    "
     Screen current colorAt:0@0
    "
!

dispatchProcess
    ^ dispatchProcess
!

displayFileDescriptor
    "return the file descriptor associated with the display
     if any. If there is no underlying filedescriptor, return nil.
     (used for event select/polling)"

    ^ nil
!

getSystemColor:aKey
    "retrieve a windows system color.
     The styleSheet/View classes may use this to setup default colors."

    ^ nil

    "
     Display getSystemColor:#COLOR_WINDOW
     Display getSystemColor:#COLOR_HIGHLIGHT
    "
!

id
    "return the displayId"

    ^ displayId
!

isOpen
    "return true, if there is a valid connection to the display.
     Added for ST-80 compatibility."

    ^ displayId notNil

    "Created: 27.1.1997 / 18:28:30 / cg"
!

isOpenAndDispatching
    "return true, if there is a valid connection to the display and events are dispatched."

    ^ self isOpen and:[dispatching]
!

isPersistentInSnapshot
    "return true, if resources on this device are to be made
     persistent in a snapshot image."

    ^ true
!

knownViews
    <resource: #obsolete>

    ^ self allViews.
!

mayOpenDebugger
    "return true, if a debugger may open on this workstation;
     if false, the debugger opens on the main display.
     This should be made a variable ..."

    ^ mayOpenDebugger ? true
!

mayOpenDebugger:aBoolean
    "set/clear the flag, which controls if a debugger may open on this workstation;
     if false, the debugger opens on the main display."

    mayOpenDebugger := aBoolean
!

multiClickTimeDelta
    ^ multiClickTimeDelta
!

multiClickTimeDelta:milliseconds
    multiClickTimeDelta := milliseconds
!

nativeDialogs
    ^ false
!

nativeFileDialogs
    ^ false

    "Created: / 24-08-2010 / 17:22:27 / sr"
!

nativeWidgets
    ^ false
!

rootView
    "return the rootView (i.e. the background window) on the receiver screen.
     It is not guaranteed, that a particular display device supports this."

    rootView isNil ifTrue:[
	rootView := DisplayRootView onDevice:self
    ].
    ^ rootView

    "
     |v|
     v := Display rootView.
     v paint:Color red.
     v clippedByChildren:false.
     v fillRectangleX:10 y:10 width:100 height:100.
    "

    "
     |v|
     v := Display rootView.
     v paint:Color red.
     v clippedByChildren:true.
     v fillRectangleX:10 y:10 width:100 height:100.
    "

!

suppressDebugger
    "return true, if no debugger should be opened for applications running
     on this device (i.e. neither a debugger on the device nor on the
     main screen).
     If true, the debugger is either opened on the device or on the
     main display, depending on the mayOpenDebugger setting."

    ^ suppressDebugger ? false
!

suppressDebugger:aBoolean
    "set/clear the flag, which controls if no debugger should be opened for applications running
     on this device (i.e. neither a debugger on the device nor on the
     main screen).
     If true, the debugger is either opened on the device or on the
     main display, depending on the mayOpenDebugger setting."

    suppressDebugger := aBoolean
!

suppressShadowViews
    "return true, if this device wants to suppress shadow views
     (i.e. shadows under popups and modalBoxes).
     Some (slow) devices may want to return true here"

    ^ false
!

translatePoint:aPoint from:windowId1 to:windowId2
    "given a point in window1 (defined by its id), return the coordinate of
     aPoint in window2 (defined by its id).
     Use to xlate points from a window to rootwindow, mainly for rubber-line
     drawing on the displays root window."

    "This method has to be reimplemented in concrete display classes."

    ^ self subclassResponsibility

    "
     |v p root|

     v := View new.
     v openAndWait.

     root := v device rootView.

     p := v device translatePoint:10@10 from:(v id) to:(root id).

     root clippedByChildren:false.
     root displayLineFrom:0@0 to:p.
     root clippedByChildren:true.
    "
    "
     |v1 v2 p1 p2 root|

     v1 := View new.
     v1 openAndWait.

     v2 := View new.
     v2 openAndWait.

     root := v1 device rootView.

     p1 := v1 device translatePoint:10@10 from:(v1 id) to:(root id).
     p2 := v1 device translatePoint:10@10 from:(v2 id) to:(root id).

     root clippedByChildren:false.
     root displayLineFrom:p1 to:p2.
     root clippedByChildren:true.
    "
!

translatePoint:aPoint fromView:window1 toView:window2
    "given a point in window1, return the coordinate of aPoint in window2.
     Either window argument may be nil to specify the root window (screen)
     Use to xlate points from a window to another window (or from a window
     to the rootwindow), mainly for rubber-line drawing on the displays root window."

    |w1 w2 devicePoint offset1 offset2|

    w1 := window1 ? self rootView.
    w2 := window2 ? self rootView.

    (w1 device ~~ self or:[w2 device ~~ self]) ifTrue:[
        self error:'Huh - Cross device translation' mayProceed:true.
        ^ aPoint
    ].
    w1 isView ifTrue:[
        offset1 := 0
    ] ifFalse:[
        offset1 := w1 origin.
        w1 := w1 container.
    ].
    w2 isView ifTrue:[
        offset2 := 0
    ] ifFalse:[
        offset2 := w2 origin.
        w2 := w2 container.
    ].
    devicePoint := self translatePoint:aPoint from:(w1 drawableId) to:(w2 drawableId).
    devicePoint isNil ifTrue:[ ^ aPoint].
    ^ devicePoint + offset1 - offset2

    "Modified: / 27-10-2007 / 13:04:09 / cg"
!

translatePointFromRoot:aPoint toView:window
    "given a point as absolute root-window coordinate, return the coordinate within the window.
     Use to xlate points from the rootWindow to a window."

    ^ self translatePoint:aPoint fromView:nil toView:window

    "Modified: / 10.10.2001 / 14:09:05 / cg"
!

translatePointToRoot:aPoint fromView:window1
    "given a point in window1, return the absolute root-window coordinate.
     Use to xlate points from a window to the rootwindow,
     mainly for rubber-line drawing on the displays root window."

    ^ self translatePoint:aPoint fromView:window1 toView:nil

    "Modified: / 10.10.2001 / 14:09:22 / cg"
!

viewFromPoint:aScreenPoint
    "given a point on the screen, return the ST/X view in which that
     point is (this may be a subview).
     Return nil, if its not an ST/X view or if the point is on the background"

    |view id|

    id := self viewIdFromPoint:aScreenPoint.
    view := self viewFromId:id.
    view isNil ifTrue:[
	"/ search on other devices (if present).
	"/ This may find the view, in case another device
	"/ has its views on the same display screen
	"/ (i.e. under X, if its another display connection to the same
	"/  X-server)
	Screen allScreens do:[:aScreen |
	    |v|

	    aScreen ~~ self ifTrue:[
		(v := aScreen viewFromId:id) notNil ifTrue:[
		    ^ v
		]
	    ]
	]
    ].
    ^ view
!

viewIdFromPoint:aScreenPoint
    "given a point on the screen, return the id of the ST/X view in which that
     point is (this may be a subview). Return nil, if its not an ST/X view
     or if the point is on the background"

    |searchId foundId n|

    searchId := self realRootWindowId.

    "/ this is required, since X raises an error, when we come
    "/ along with an illegal id (which happens, if a view from another
    "/ screen-device is picked ...)
    self class deviceErrorSignal handle:[:ex |
	^ nil
    ] do:[
	n := 0.
	[searchId notNil] whileTrue:[
	    n := n + 1.
	    n > 1000 ifTrue:[
		self error:'endless view hierarchy'.
		^ nil
	    ].
	    foundId := searchId.
	    searchId := self viewIdFromPoint:aScreenPoint in:searchId.
	]
    ].
    ^ foundId
!

viewIdFromPoint:aPoint in:windowId
    "given a point in rootWindow, return the viewId of the subview of windowId
     hit by this coordinate. Return nil if no view was hit.
     - use to find window to drop objects after a cross-view drag"

    "returning nil here actually makes drag&drop impossible
     - could also be reimplemented to make a search over all knownViews here.
     This method has to be reimplemented in concrete display classes."

    ^ nil
!

windowAt:aScreenPoint
    "given a point on the screen, return the ST/X topview in which that
     point is.
     Return nil, if its not an ST/X view or if the point is on the background.
     Alias for viewFromPoint: for ST-80 compatibility"

    ^ self viewFromPoint:aScreenPoint
! !

!DeviceWorkstation methodsFor:'accessing-display attributes'!

bitsBlue
    "return the number of valid bits in the blue component."

    bitsBlue isNil ifTrue:[
	"/ not a truecolor display
	^ bitsPerRGB
    ].
    ^ bitsBlue

    "
     Display bitsBlue
    "

    "Created: 21.10.1995 / 00:45:27 / cg"
    "Modified: 16.4.1997 / 15:00:53 / cg"
!

bitsGreen
    "return the number of valid bits in the green component."

    bitsGreen isNil ifTrue:[
	"/ not a truecolor display
	^ bitsPerRGB
    ].
    ^ bitsGreen

    "
     Display bitsGreen
    "

    "Created: 21.10.1995 / 00:45:11 / cg"
    "Modified: 16.4.1997 / 15:01:02 / cg"
!

bitsPerRGB
    "return the number of valid bits per rgb component;
     Currently, assume that r/g/b all have the same precision,
     which is a stupid assumption (there may be some, where less
     resolution is available in the blue component).
     Therefore, this may be changed to return a 3-element vector.
     In the meantime, use bitsRed/bitsGreen/bitsBlue to get this information."

    ^ bitsPerRGB

    "
     Display bitsPerRGB
    "

    "Modified: 21.10.1995 / 00:46:27 / cg"
!

bitsRed
    "return the number of valid bits in the red component."

    bitsRed isNil ifTrue:[
	"/ not a truecolor display
	^ bitsPerRGB
    ].
    ^ bitsRed

    "
     Display bitsRed
    "

    "Created: 21.10.1995 / 00:44:55 / cg"
!

blackColor
    "return the black color on this device.
     This is the same as 'Color black onDevice:device', but much faster."

    blackColor isNil ifTrue:[
        "not yet initialized"
        ^ Color black onDevice:self.
    ].

    ^ blackColor

    "
     Display blackColor
    "

    "Created: 13.1.1997 / 22:37:05 / cg"
    "Modified: 13.1.1997 / 22:43:19 / cg"
!

blackpixel
    "return the colorId of black"

    visualType == #TrueColor ifTrue:[^ 0].

    ^ self subclassResponsibility
!

blueMask
    "return a mask, which extracts the blueBits from a color id.
     This only makes sense with trueColor displays;
     therefore, 0 is returned on all others."

    ^ blueMask

    "
     Display blueMask
    "

    "Modified: 21.10.1995 / 00:47:58 / cg"
    "Created: 24.7.1996 / 13:25:21 / cg"
!

depth
    "return the depth in pixels of the display"

    ^ depth

    "
     Display depth
    "
!

focusMode
    ^ focusMode
!

greenMask
    "return a mask, which extracts the greenBits from a color id.
     This only makes sense with trueColor displays;
     therefore, 0 is returned on all others."

    ^ greenMask

    "
     Display greenMask
    "

    "Modified: 21.10.1995 / 00:47:58 / cg"
    "Created: 24.7.1996 / 13:25:15 / cg"
!

hasColors
    "return true, if its a color display"

    ^ hasColors

    "
     Display hasColors
    "
!

hasGrayscales
    "return true, if this workstation supports grayscales
     (also true for color displays)"

    ^ hasGreyscales

    "
     Display hasGrayscales
    "

    "Created: 2.5.1996 / 11:49:07 / cg"
!

hasGreyscales
    "OBSOLETE english version; please use #hasGrayScales.
     Return true, if this workstation supports greyscales
     (also true for color displays)"

    ^ hasGreyscales

    "
     Display hasGreyscales
    "

    "Modified: 2.5.1996 / 11:51:03 / cg"
!

redMask
    "return a mask, which extracts the redBits from a color id.
     This only makes sense with trueColor displays;
     therefore, 0 is returned on all others."

    ^ redMask

    "
     Display redMask
    "

    "Created: 21.10.1995 / 00:45:27 / cg"
    "Modified: 24.7.1996 / 13:25:08 / cg"
!

shiftBlue
    "return the count by which the blue bits are to be shifted
     when forming a color index.
     This only makes sense with trueColor displays; therefore,
     nil is returned on all others."

    ^ blueShift

    "
     Display shiftBlue
    "

    "Created: 21.10.1995 / 00:45:27 / cg"
    "Modified: 21.10.1995 / 00:47:58 / cg"
!

shiftGreen
    "return the count by which the green bits are to be shifted
     when forming a color index.
     This only makes sense with trueColor displays; therefore,
     nil is returned on all others."

    ^ greenShift

    "
     Display shiftGreen
    "

    "Created: 21.10.1995 / 00:45:27 / cg"
    "Modified: 16.4.1997 / 15:02:37 / cg"
!

shiftRed
    "return the count by which the red bits are to be shifted
     when forming a color index.
     This only makes sense with trueColor displays; therefore,
     nil is returned on all others."

    ^ redShift

    "
     Display shiftRed
    "

    "Created: 21.10.1995 / 00:45:27 / cg"
    "Modified: 21.10.1995 / 00:48:10 / cg"
!

visualType
    "return a symbol representing the visual type of the display"

    ^ visualType

    "
     Display visualType
    "
!

visualType:aSymbol
    "set the visual type.
     The only situation, where setting the visual makes sense,
     is with my plasma-display, which ignores the palette and spits out
     grey scales, independent of color LUT definitions.
     (of which the server knows nothing).
     So, this should be used from a display-specific startup file only."

    visualType := aSymbol.
    (visualType == #StaticGray or:[visualType == #GrayScale]) ifTrue:[
	hasColors := false
    ] ifFalse:[
	hasColors := true
    ]
!

whiteColor
    "return the white color on this device.
     This is the same as 'Color white onDevice:device', but much faster."

    whiteColor isNil ifTrue:[
        "not yet initialized"
        ^ Color white onDevice:self.
    ].

    ^ whiteColor

    "Created: 13.1.1997 / 22:37:10 / cg"
    "Modified: 13.1.1997 / 22:43:04 / cg"
!

whitepixel
    "return the colorId of white"

    visualType == #TrueColor ifTrue:[^ (1 bitShift:depth)-1].

    ^ self subclassResponsibility
! !

!DeviceWorkstation methodsFor:'accessing-display capabilities'!

centerOfMonitorHavingPointer
    |pos bounds|

    pos := self pointerPosition.
    pos isNil ifTrue:[
	bounds := self bounds
    ] ifFalse:[
	bounds:= self monitorBoundsAt:pos.
    ].
    ^ bounds center rounded.

    "
     Screen current centerOfMonitorHavingPointer
    "
!

hasColors:aBoolean
    "set the hasColors flag - needed since some servers don't tell the
     truth if a monochrome monitor is connected to a color server.
     Clearing the hasColors flag in the rc file will force use of grey
     colors (which might make a difference, since some colors are hard to
     distinguish on a greyscale monitor)."

    hasColors := aBoolean
!

hasDPS
    "return true, if this workstation supports postscript output into views.
     Should be reimplemented in concrete classes which do support this."

    ^ false

    "
     Display hasDPS
    "
!

hasExtension:extensionString
    "query for an X extension. The method here is provide for XWorkstation
     protocol compatibility only."

    ^ false

    "
     Display hasExtension:'XVideo'
     Display hasExtension:'Input'
     Display hasExtension:'GLX'
     Display hasExtension:'X3D-PEX'
     Display hasExtension:'XInputExtension'
     Display hasExtension:'SHAPE'
     Display hasExtension:'MIT-SHM'
     Display hasExtension:'SGIFullScreenStereo'
    "
!

hasGrayscales:aBoolean
    "set the hasGrayscales flag - can be used to simulate b&w behavior
     on greyScale and color monitors.
     (You may want to check if your application looks ok if displayed on
      a b&w monitor - even if you have a color display. To do so, clear
       the hasGreyscales flag from your .rc file)"

    hasGreyscales := aBoolean

    "Created: 2.5.1996 / 11:50:04 / cg"
!

hasGreyscales:aBoolean
    "OBSOLETE english version - please use #hasGrayscales:
     Set the hasGreyscales flag - can be used to simulate b&w behavior
     on greyScale and color monitors.
     (You may want to check if your application looks ok if displayed on
      a b&w monitor - even if you have a color display. To do so, clear
       the hasGreyscales flag from your .rc file)"

    hasGreyscales := aBoolean

    "Modified: 2.5.1996 / 11:50:48 / cg"
!

hasImageExtension
    "return true, if this workstation supports the X Image extension"

    ^ false

    "
     Display hasImageExtension
    "
!

hasInputExtension
    "return true, if this workstation supports the X Input extension"

    ^ false

    "
     Display hasInputExtension
    "
!

hasMultibuffer
    "return true, if this workstation supports the X multibuffer extension"

    ^ false

    "
     Display hasMultibuffer
    "
!

hasPEX
    "return true, if this workstation supports PEX graphics.
     Should be reimplemented in concrete classes which do support this."

    ^ false

    "
     Display hasPEX
    "
!

hasShape
    "return true, if this workstation supports arbitrary shaped windows.
     This is obsolete - use #supportsArbitraryShapedViews."

    ^ self supportsArbitraryShapedViews

    "
     Display hasShape
    "
!

hasShm
    "return true, if this workstation supports shared memory pixmaps.
     Should be reimplemented in concrete classes which do support this."

    ^ false

    "
     Display hasShm
    "
!

hasStereoExtension
    "return true, if this workstation supports stereo GL drawing.
     Both the server must support it, and the feature must have been
     enabled in the smalltalk system, for true to be returned."

    ^ false

    "
     Display hasStereoExtension
    "
!

hasXVideo
    "return true, if this workstation supports the XVideo extension"

    ^ false

    "
     Display hasXVideo
    "
!

iconSizes
    "Get the supported icon sizes. These are typically set by the window manager.
     We return nil here (as if there are no special size preferences)."

    ^ nil

    "Created: 2.1.1996 / 15:08:16 / cg"
    "Modified: 7.5.1996 / 10:43:38 / cg"
!

ignoreBackingStore:aBoolean
    "if the argument is true, the view's backingStore setting will be ignored, and
     no backing store used - this can be used on servers where backing store is
     very slow (from rc-file)"

    ^ self
!

isSlow
    "return true, if this is a relatively slow device -
     used to turn off things like popup-shadows"

    ^ isSlow
!

isSlow:aBoolean
    "set/clear the slow flag.
     The slow-flag has no semantic meaning by itself;
     however, it can be set via the display.rc file and tested at various
     other places to turn off some bells&whistles which might slow down
     the drawing. For example, shadows under popUps are suppressed if isSlow
     is set."

    isSlow := aBoolean
!

monitorBoundsAt:aPoint
    "to be redefined for display systems which support MULTI SCREEN"

    ^ self bounds

    "Modified: / 22-10-2010 / 10:57:17 / cg"
!

monitorType
    "return a symbol representing the monitor type of the display.
     It is usually set to #unknown, #color or #monochrome.
     But it can be set to any value from the startup file, for later
     testing from anywhere. For example the startup for plasma-displays
     can set it to #plasma to later influence the colors used in widgets
     (indirectly through the resource file)."

    ^ monitorType

    "
     Display monitorType
    "
!

monitorType:aSymbol
    "set the monitorType - see comment in DeviceWorkstation>>monitorType"

    monitorType := aSymbol
!

ncells
    "return the number of usable color cells, the display has
     - this is not always 2 to the power of depth
     (for example, on 6bit displays, ncells is 64 while depth is 8)"

    ^ ncells

    "
     Display ncells
    "
!

pointIsVisible:aPoint
    "is the point visible?
     To be redefined for display systems which support MULTI SCREEN"

    ^ self bounds containsPoint:aPoint
!

pointsAreOnSameMonitor:point1 and:point2
    "are the two points on the same (multi-screen) monitors?
     To be redefined for display systems which support MULTI SCREEN"

    ^ true
!

preferredIconSize
    "Get the preferrered icon size. These are typically set by the window manager."

    |sizes spec sz sz2|

    preferredIconSize isNil ifTrue:[
	sizes := self iconSizes.
	sizes notNil ifTrue:[
	    spec := sizes first.

	    "/ we prefer square icons ...
	    sz := (spec at:#maxWidth) min: (spec at:#maxHeight).
	    sz > 64 ifTrue:[
		sz2 := (spec at:#minWidth) max: (spec at:#minHeight).
		sz2 <= 48 ifTrue:[
		    sz := 48
		]
	    ].
	    preferredIconSize := sz @ sz
	] ifFalse:[
	    preferredIconSize := 48@48
	].
    ].

    ^ preferredIconSize

    "
     Display preferredIconSize:nil.
     Display preferredIconSize.
     Display preferredIconSize:32@32
     Display preferredIconSize:nil
    "

    "Modified: 10.6.1996 / 22:10:58 / cg"
!

preferredIconSize:anExtentPoint
    "set the preferrered icon size.
     By default, the preferredIconSize is queried from the display,
     however, some windowManagers return stupid values.
     This methods allows overriding thngs from a startup file"

    preferredIconSize := anExtentPoint

    "
     Display preferredIconSize
     Display preferredIconSize:32@32
     Display preferredIconSize:48@48
    "

    "Modified: 10.6.1996 / 21:01:50 / cg"
!

scrollsAsynchronous
    "return true, if this display asynchronously sends expose events after a
     scroll operation. False otherwise. Asynchronous expose events are an X
     speciality, which affects a few methods outside of the display class (sorry)"

    ^ false
!

supportedClipboards
    "answer a collection of symbols with the supported clipboards..
     At least clipboard should be supported on any platform"

    ^ #(clipboard)
!

supportedImageFormatForDepth:aDepth
    "given a depth, return the devices image format info,
     which provides padding info. If the given depth is not
     supported, return nil."

    ^ self supportedImageFormats detect:[:fmt | (fmt at:#depth) == aDepth] ifNone:nil.

"/    self supportedImageFormats do:[:fmt |
"/        (fmt at:#depth) == aDepth ifTrue:[
"/            ^fmt
"/        ]
"/    ].
"/    ^ nil
!

supportedImageFormats
    "return an array with supported image formats; each array entry
     is another array, consisting of depth and bitsPerPixel values.
     Here, we return a single format only; every graphics device must
     support b&w single bit images."

    |info|

    info := IdentityDictionary new.
    info at:#depth put:1.
    info at:#bitsPerPixel put:1.
    info at:#padding put:32.
    ^ Array with:info
!

supportsAnyViewBackgroundPixmaps
    "return true, if the device allows any pixmap as
     viewBackground. False returned here - redefined in some
     device classes."

    ^ false

    "Created: / 4.5.1999 / 18:41:01 / cg"
!

supportsArbitraryShapedViews
    "return true, if this workstation supports arbitrary shaped
     windows.
     Should be reimplemented in concrete classes which do support this."

    ^ false

    "
     Display supportsArbitraryShapedViews
    "
!

supportsDeepIcons
    "return true, if this device supports non b&w (i.e. greyScale
     or colored icons). Many Xservers (and/or windowManagers) crash,
     if you pass them a deep form as icon; therefore, the default is false.
     It may be a good idea to check for the server vendor/release and
     return true sometimes.
     This flag can be set with #supportsDeepIcons:"

    ^ supportsDeepIcons

    "
     Display supportsDeepIcons:true

     |v|

     v := StandardSystemView new.
     v icon:((Image fromFile:'bitmaps/claus.gif') magnifiedTo:68@68).
     v open.
    "

    "Modified: 10.6.1996 / 20:11:48 / cg"
!

supportsDeepIcons:yesOrNo
    "set/clear the supportsDeepIcons flag.
     Many Xservers (and/or windowManagers) crash,
     if you pass them a deep form as icon; therefore, the default is false."

    supportsDeepIcons := yesOrNo

    "
     Display supportsDeepIcons
    "

    "Created: 10.6.1996 / 19:36:19 / cg"
!

supportsGLDrawing
    "return true, if this device supports 3D GL drawing.
     We do not depend on that being implemented."

    "This method should be reimplemented in concrete display classes."
    ^ false

    "
     Display supportsGLDrawing
    "
!

supportsIconMasks
    "return true, if this device supports masked icons.
     Assume true here - to be redefined in concrete classes."

    ^ true

    "
     Display supportsIconMasks
    "

    "Modified: / 28.4.1999 / 19:58:12 / cg"
!

supportsIconViews
    "return true, if this device supports views as icons.
     Only Xservers (currently) support this."

    ^ false

    "
     Display supportsIconViews
    "

    "Modified: 10.6.1996 / 21:08:04 / cg"
!

supportsMaskedDrawingWith:aForm
    "return true, if the device allows the given form pixmap
     to be used as paint color.
     False returned here, which forces higher level code to
     perform the filling manually (by copying the form)
     - redefined in most device classes."

    ^ false

    "Created: / 4.5.1999 / 12:16:18 / cg"
    "Modified: / 4.5.1999 / 12:58:04 / cg"
!

supportsMaskedDrawingWithOffset:aForm
    "return true, if the device allows the given form pixmap
     to be used as paint color AND it supports a pattern offset.
     Pattern offset is needed to display the form in a scrolled view,
     to correctly start bit-blitting within the pattern.
     False returned here, which forces higher level code to
     perform the filling manually (by copying the form)
     - redefined in most device classes."

    ^ false
!

supportsNativeDialogs
    ^ false

    "
     Screen current supportsNativeDialogs
    "
!

supportsNativeFileDialogs
    ^ false

    "Created: / 24-08-2010 / 17:23:51 / sr"
!

supportsNativeWidgetType:aWidgetTypeSymbol
    ^ false

    "
     Screen current supportsNativeWidgetType:#Button
    "
!

supportsNativeWidgets
    ^ false

    "
     Screen current supportsNativeWidgets
    "
!

supportsRoundShapedViews
    "return true, if this workstation supports round shaped
     (elliptical & circular) windows.
     Should be reimplemented in concrete classes which do support this."

    ^ false

    "
     Display supportsRoundShapedViews
    "
!

supportsScreenReading
    "can the screen be read?"

    ^ true
!

supportsVariableHeightFonts
    "are fonts with variable height supported?
     Subclasses may redefine this"

    ^ false
!

supportsViewBackgroundPixmap:aForm
    "return true, if the device allows the given pixmap as
     viewBackground. If false is returned,
     drawing is done by (possibly) slower smalltalk code.
     False returned here - redefined in some concrete device classes."

    ^ false

    "Created: / 4.5.1999 / 18:40:25 / cg"
    "Modified: / 4.5.1999 / 18:44:41 / cg"
!

supportsViewGravity
    "return true, if this device supports gravity attributes.
     We do not depend on the being implemented, but some resizing operations
     are faster, it is is."

    "This method should to be reimplemented in concrete display classes."
    ^ false

    "
     Display supportsViewGravity
    "
!

supportsWindowBorder:aNumber
    "return true, if this device supports bordered windows with the given borderWidth.
     Right now, some drawing stuff depends on (at least) a border of 1 pixel
     to be supported by the device.
     ST/X's views are being rewritten to draw the border manually in the
     future, since some systems do not support arbitrary wide borders (i.e. Windows).
     Also, most (all?) systems only support drawing a solid border, which may or may not be
     what we want."

    ^ true

    "
     Display supportsWindowBorder:1
    "
!

supportsXftFonts
    "can we draw into windows using Xft fonts?
     Obviously, this will only ever be answered true by XWindow displays"

    ^ false
!

supportsXftFontsInBitmaps
    "can we draw into bitmap/pixmaps using Xft fonts?
     Obviously, this will only ever be answered true by XWindow displays.
     This is a separate query (for now), because rendering into pixmaps
     seems not to work currently"
     
    ^ false
! !

!DeviceWorkstation methodsFor:'accessing-display geometry'!

boundingBox
    "return a rectangle representing the displays bounding box.
     For Smalltalk-80 2.x compatibility"

    ^ self bounds
!

bounds
    "return a rectangle representing the displays bounding box.
     For Smalltalk-80 4.x compatibility"

    ^ Rectangle left:0 top:0 width:width-1 height:height-1

    "
     Screen default bounds
    "
    "/ that's the same as:
    "
     Display bounds
    "

    "Modified: 8.5.1996 / 20:58:26 / cg"
!

captionHeight
    "return the height in pixels of the caption
     (i.e. title bar) of topWindows.
     Fallback of 0 (i.e. unknown) is returned here.
     Applications should not depend on that returned value
     to be exact - on some systems (windowManagers),
     its value cannot be retrieved"

    ^ 0
!

center
    "return the centerpoint in pixels of the display"

    ^ (width // 2) @ (height // 2)
!

drawingResolution
    "return a point consisting of the actual drawing resolution
     in pixel-per-inch horizontally and vertically.
     On screen devices, this is the same as resolution; on postscript
     devices, this is usually higher than the coordinate systems unit.
     This method is provided for compatibility with postscript media,
     to query the device if sub-pixel-coordinate drawing is possible.
     (there are a few situations, in which resolution-independ drawing
      leads to ugly looking output ... knowing about subPixel resolution
      may help there.)"

    ^ self resolution

    "Created: 4.6.1996 / 15:20:43 / cg"
    "Modified: 4.6.1996 / 17:56:26 / cg"
!

extent
    "return the extent of the display (in pixels)"

    ^ width @ height

    "
     Display extent
    "
!

extentOfResizeHandle
    "if the window system needs any area for a window resize handle (such as on MACOS-X),
     this area's extent is returned here. It is assumed, that this handle is located at the lower-right
     of the window.
     0@0 is returned for systems which locate the resize handles outside the client area.
     This may be used by the UI painter or programmatically to reserve some client area.
     This method must be redefined for displays which need it (i.e. X11 on osx)"

    ^ 0@0
!

height
    "return the height of the display (in pixels)"

    ^ height

    "Display height"
!

heightInMillimeter
    "return the height in millimeter of the display"

    ^ heightMM

    "Display heightInMillimeter"
!

heightInMillimeter:aNumber
    "set the height in millimeter of the display
     - needed since some displays do not tell the truth or do not know it"

    aNumber > 0 ifTrue:[
	heightMM := aNumber.
	resolutionVer := nil.
    ]

    "Modified: 10.9.1996 / 14:25:39 / cg"
!

horizontalPixelPerInch
    "return the number of horizontal pixels per inch of the display"

    ^ (width / widthMM) * 25.4

    "
     Display horizontalPixelPerInch
     Display widthInMillimeter:(Display width * 25.4) / 120
     Display heightInMillimeter:(Display height * 25.4) / 120
    "
!

horizontalPixelPerMillimeter
    "return the number of horizontal pixels per millimeter of the display"

    resolutionHor notNil ifTrue:[
        ^ resolutionHor
    ].
    resolutionHor := (width / widthMM) asFloat.
    ^ resolutionHor

    "
     Display horizontalPixelPerMillimeter
     Display verticalPixelPerMillimeter
     Display width
     Display widthInMillimeter
     Display heightInMillimeter
    "
!

pixelPerInch
    "return the number of horizontal/vertical pixels per inch of the display as Point"

    ^ ((width / widthMM) @ (height / heightMM)) * 25.4

    "Display pixelPerInch"
!

pixelPerMillimeter
    "return the number of horizontal/vertical pixels per millimeter of the display as Point"

    ^ (width / widthMM) @ (height / heightMM)

    "Display pixelPerMillimeter"
!

resolution
    "return a point consisting of pixel-per-inch horizontally and vertically.
     This is an ST-80 compatibility method"

    ^ self pixelPerInch
!

setUsableHeight:h
    height := h
!

setUsableWidth:w
    width := w
!

smallestMonitorHeight
    "returns the usable height of the smallest monitor in a mult-monitor setup.
     Subclasses supporting multi-monitors redefine this."

    ^ self usableHeight.
!

usableExtent
    "return the usable extent of the display (in pixels).
     Normally, the same as extent, but may be smaller, in
     case some menu space is taken up by the window manager (windows)"

    ^ width @ height

    "
     Display extent
     Display usableExtent
    "

    "Modified: 4.8.1997 / 01:40:14 / cg"
!

usableHeight
    "returns the usable height of the display (in pixels)
     Normally, the same as height, but may be smaller, in
     case some menu space is taken up by the window manager (windows)"

    ^ self usableExtent y
!

usableHeightAt:aPoint
    "returns the usable height of the display (in pixels) at a given point
     Normally, the same as height, but may be smaller, in
     case some menu space is taken up by the window manager (windows).
     On multi-display systems with different sized screens, this should care for
     which display is at the given x-position"

    ^ self usableHeight
!

usableWidth
    "returns the usable width of the display (in pixels)
     Normally, the same as width, but may be smaller, in
     case some menu space is taken up by the window manager (windows)"

    ^ self usableExtent x
!

verticalPixelPerInch
    "return the number of vertical pixels per inch of the display"

    ^ (height / heightMM) * 25.4
!

verticalPixelPerMillimeter
    "return the number of vertical pixels per millimeter of the display"

    resolutionVer notNil ifTrue:[
	^ resolutionVer
    ].
    resolutionVer := (height / heightMM) asFloat.
    ^ resolutionVer
!

virtualExtent
    "return the virtual extent of the display (in pixels).
     On most systems, this is the same as the physical width;
     except, if a window manager with a virtual desktop like olvwm
     (simulating a bigger screen) is running."

    ^ width @ height
!

virtualHeight
    "return the virtual height of the display (in pixels).
     On most systems, this is the same as the physical height;
     except, if a window manager with a virtual desktop like olvwm
     (simulating a bigger screen) is running."

    ^ self virtualExtent y

    "Display virtualHeight"
!

virtualWidth
    "return the virtual width of the display (in pixels).
     On most systems, this is the same as the physical width;
     except, if a window manager with a virtual desktop like olvwm
     (simulating a bigger screen) is running."

    ^ self virtualExtent x

    "Display virtualWidth"
!

width
    "return the width of the display (in pixels)"

    ^ width

    "Display width"
!

widthInMillimeter
    "return the width in millimeter of the display"

    ^ widthMM

    "Display widthInMillimeter"
!

widthInMillimeter:aNumber
    "set the width in millimeter of the display
     - needed since some displays do not tell the truth or do not know it"

    aNumber > 0 ifTrue:[
	widthMM := aNumber.
	resolutionHor := nil.
    ].

    "Modified: 10.9.1996 / 14:25:27 / cg"
! !

!DeviceWorkstation methodsFor:'accessing-keyboard mappings'!

buttonTranslation
    "return the buttonTranslation (for lefthanders)"

    ^ buttonTranslation
!

buttonTranslation:anArray
    "set the buttonTranslation (for lefthanders)"

    buttonTranslation := anArray

    "
     Screen current buttonTranslation
     Screen current buttonTranslation:#(1 2 1)
    "
!

keyboardMap
    "return the keyboard map"

    ^ keyboardMap

    "
     Screen current keyboardMap
    "

    "Modified: / 08-08-2006 / 15:00:35 / cg"
!

keyboardMap:aMap
    "set the keyboard map"

    keyboardMap := aMap
!

shortKeyPrefixSeparator
    "the saparator shown between the shortcut modified (CTRL, CMD etc.)
     and the actual character. I.e. makes a Ctrl+A"

    "/ used to be '-'
    ^ ' + '

    "Created: / 21-07-2011 / 16:04:22 / cg"
    "Modified: / 09-02-2017 / 11:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shortKeyStringFor:symbolicOrRawKey
    "Obsolete: For given symbolic or raw key, return a user-friendly shortcut description string.
     Examples:
       #Find -> Ctrl+f (depending on your default)
       #CtrlX -> Ctrl+X

     This method is used in menu panel (#shortcutKeyAsString) to display shortcuts in menus.
    "
    <resource: #obsolete>

    self obsoleteMethodWarning: 'Use #shortKeyStringFor:usingMap: instead'.  
    ^ self shortKeyStringFor: symbolicOrRawKey usingMap: self keyboardMap

    "Created: / 08-08-2006 / 15:45:38 / cg"
    "Modified: / 08-02-2017 / 23:54:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shortKeyStringFor:symbolicOrRawKey usingMap: kbdMap
    "For given symbolic or raw key, return a user-friendly shortcut description string.
     Examples:
       #Find -> Ctrl+f (depending mapping in `kbdMap` parameter)
       #CtrlX -> Ctrl+X

     This method is used in menu panel (#shortcutKeyAsString) to display shortcuts in menus.
    "

    |untranslatedKey prefix|

    "/ this is somewhat complicated: we have the symbolic key at hand,
    "/ but want to know the untranslated (inverse keyBoardMapped) key & modifier
    "/ this is used in the menu, to show the shortCut key beside the items.

    untranslatedKey := kbdMap bindingForLogical: symbolicOrRawKey.
    untranslatedKey isNil ifTrue:[
        "/ if its not an explicit command key (Ctrl-*, Alt-* or Cmd-*),
        "/ but a symbolic key, return nil.
        (#('Cmd' 'Ctrl' 'Alt' 'Meta' 'Shift')
            contains:[:k | (symbolicOrRawKey startsWith:k) ])
                ifFalse:[^ nil].

"/        (aSymbolicKey startsWith:'Cmd') ifFalse:[
"/            (aSymbolicKey startsWith:'Ctrl') ifFalse:[
"/                (aSymbolicKey startsWith:'Alt') ifFalse:[
"/                    (aSymbolicKey startsWith:'Meta') ifFalse:[
"/                        (aSymbolicKey startsWith:'Shift') ifFalse:[
"/                            ^ nil
"/                        ].
"/                    ].
"/                ].
"/            ].
"/        ].
        untranslatedKey := symbolicOrRawKey.
    ].

    "/
    "/ some modifier-key combination ?
    "/
    (untranslatedKey startsWith:#Cmd) ifTrue:[
        prefix := #Cmd.
    ] ifFalse:[(untranslatedKey startsWith:#Alt) ifTrue:[
        prefix := #Alt.
    ] ifFalse:[(untranslatedKey startsWith:#Meta) ifTrue:[
        prefix := #Meta.
    ] ifFalse:[(untranslatedKey startsWith:#Ctrl) ifTrue:[
        prefix := #Ctrl.
    ]]]].

    prefix notNil ifTrue:[
        |modifier rest|

        modifier := self modifierKeyTopFor:prefix.
        modifier := (modifier ? prefix).
        rest := (untranslatedKey copyFrom:(prefix size + 1)).
        rest isEmpty ifTrue:[^ modifier ].
        modifier := modifier , (self shortKeyPrefixSeparator).
        rest size == 1 ifTrue:[ 
            rest first isUppercase ifTrue:[ 
                ^ modifier , (self modifierKeyTopFor:#Shift) , self shortKeyPrefixSeparator , rest
            ] ifFalse:[ 
                ^ modifier , rest first asUppercase
            ].
        ].
        ^ modifier , rest
    ].
    ^ untranslatedKey

    "
    Screen current shortKeyStringFor: #CmdBackSpace usingMap: Screen current keyboardMap
    Screen current shortKeyStringFor: #Find usingMap: Screen current keyboardMap
    Screen current shortKeyStringFor: #CtrlX usingMap: Screen current keyboardMap
    Screen current shortKeyStringFor: #CursorLeft usingMap: Screen current keyboardMap
    "

    "Created: / 08-02-2017 / 23:28:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2017 / 21:17:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DeviceWorkstation methodsFor:'accessing-misc'!

defaultEventMask
    "return a mask to enable some events by default."

    self subclassResponsibility
!

displayName
    "return the display name - that is the name of the display connection
     or nil, for default display. For example, in X, this returns a string
     like 'hostname:0' for remote connections, and nil for a default local
     connection.
     - nothing known here, but maybe redefined in subclasses."

    ^ nil

    "
     Display displayName
    "
!

glVersion
    "return a string describing the GL version.
     Since the generic display does not support 3D GL graphics,
     a dummy is returned here."

    ^ 'noGL'

    "
     Display glVersion
    "
!

numberOfMonitors
    ^ 1 "a fallback value only"

    "
     Display numberOfMonitors
    "
!

platformName
    "return a string describing the display systems platform.
     Returns a dummy here."

    ^ self class platformName

    "
     Display platformName
    "
!

protocolVersion
    "return the display systems protocol version number.
     Returns a dummy here"

    ^ 0

    "
     Display protocolVersion
    "
!

serverVendor
    "return a string describing the display systems server vendor.
     Returns a dummy here"

    ^ 'generic'

    "
     Display serverVendor
    "
!

vendorRelease
    "return the display systems release number.
     Returns a dummy here."

    ^ 0

    "
     Display vendorRelease
    "
! !

!DeviceWorkstation methodsFor:'bitmap/window creation'!

convertedIcon:iconArg
    "make certain, that the image argument is compatible with myself;
     this means converting it to a format (typically: monochrome) which I support.
     Return a compatible version of the icon."

    |deviceIcon d toMono toDeep icon|

    icon := iconArg value.
    icon isNil ifTrue:[^ nil].

    toMono := toDeep := false.

    d := icon depth.
    self supportsDeepIcons ifFalse:[
	(d ~~ 1 or:[icon isImage]) ifTrue:[
	    "
	     dither to monochrome
	    "
	    toMono := true.
	]
    ] ifTrue:[
	d == 1 ifTrue:[
	    icon colorMap notNil ifTrue:[
		icon isImage ifFalse:[
		    toMono := true.
		] ifTrue:[
		    toDeep := true.
		]
	    ]
	] ifFalse:[
	    d ~~ self depth ifTrue:[
		icon isImage ifFalse:[
		    toMono := true.
		] ifTrue:[
		    toDeep := true.
		]
	    ]
	]
    ].

    deviceIcon := icon.
    toMono ifTrue:[
	deviceIcon := icon asMonochromeFormOn:self.
    ].
    toDeep ifTrue:[
	deviceIcon := (Image implementorForDepth:self depth) fromImage:icon.
    ].

    deviceIcon notNil ifTrue:[
	"
	 get device pixmap (i.e. allocate colors & resource)
	"
	deviceIcon := deviceIcon onDevice:self
    ].
    ^ deviceIcon

    "Created: / 30-10-2007 / 16:37:10 / cg"
!

convertedIconMask:aMask
    "return a version of the argument which can be used as an iconMask on myself.
     Typically, this means conversion to a monochrome mask -
     future versions may add alpha channel masks, if I support them ..."

    self supportsIconMasks ifFalse:[^ nil].

    aMask depth == 1 ifTrue:[
	^ aMask onDevice:self.
    ].
    ^ aMask asMonochromeFormOn:self

    "Created: / 30-10-2007 / 16:38:37 / cg"
!

createBitmapFromArray:anArray width:w height:h
    "create a monochrome, depth1 bitmap from a given (byte-)array.
     The rows are aligned to a multiple of 8"

    ^ self subclassResponsibility
!

createBitmapFromFile:aString for:aForm
    ^ nil
!

createBitmapWidth:w height:h
    "allocate a bitmap on the Xserver, the contents is undefined
     (i.e. random). Return a bitmap id or nil"

    ^ self subclassResponsibility
!

createPixmapWidth:w height:h depth:d
    "allocate a pixmap on the Xserver, the contents is undefined
     (i.e. random). Return a bitmap id or nil"

    ^ self subclassResponsibility
!

createWindowFor:aView type:typeSymbol origin:org extent:ext minExtent:minE maxExtent:maxE borderWidth:bw subViewOf:sv style:styleSymbol inputOnly:inp label:label cursor:curs icon:icn iconMask:icnM iconView:icnV
    "must be implemented by a concrete class"

    ^ self subclassResponsibility
!

createWindowFor:aView type:typeSymbol origin:org extent:ext
	minExtent:minE maxExtent:maxE borderWidth:bw subViewOf:sv
	style:styleSymbol inputOnly:inp
	label:label owner:owner
	icon:icn iconMask:icnM iconView:icnV
    "must be implemented by a concrete class"

    ^ self subclassResponsibility
!

destroyGC:aGCId
    "destroy a GC"

    ^ self subclassResponsibility
!

destroyPixmap:aDrawableId
    ^ self subclassResponsibility
!

destroyView:aView withId:aWindowId
    ^ self subclassResponsibility
!

gcFor:aDrawableId
    "create a GC for drawing into aDrawable"

    ^ self subclassResponsibility
!

gcForBitmap:aDrawableId
    "create a GC for drawing into a bitmap drawable"

    ^ self subclassResponsibility
!

realRootWindowFor:aView
    "the name of this method is historic;
     - it will vanish"

    |id|

    id := self realRootWindowId.
    self addKnownView:aView withId:id.
    ^ id
!

realRootWindowId
    "return the id of the real root window.
     This may or may not be the view you see as background,
     since some window managers install a virtual root window on top
     of the real one. In this case, this method returns the id of the
     covered real-root
     (in contrast, rootWindowId returns the id of the visible one).
     With most window systems, the realRoot is the same as the root window.
     The real root is only seldom of any interest."

    ^ self rootWindowId

    "Modified: 14.10.1996 / 22:25:03 / stefan"
!

rootWindowFor:aView
    |id|

    id := self rootWindowId.
    self addKnownView:aView withId:id.
    ^ id
!

rootWindowId
    "return the id of the root window.
     This is the window you see as background,
     however, it may or may not be the real physical root window,
     since some window managers install a virtual root window on top
     of the real one. If this is the case, that views id is returned here."

    ^ self subclassResponsibility
! !

!DeviceWorkstation methodsFor:'clipboard'!

clipboardEncoding
    "return the assumed default clibBoards encoding
     if a raw string (i.e. without encoding information) is pasted.
     Useful on X11, if a sjis or euc string is pasted from a netscape
     or other program."

    ^ clipBoardEncoding

    "
     Screen current clipBoardEncoding
    "

    "Created: 28.6.1997 / 13:46:02 / cg"
    "Modified: 28.6.1997 / 17:28:08 / cg"
!

clipboardEncoding:aSymbol
    "set the assumed default clipBoard's encoding
     if a raw string (i.e. without encoding information) is pasted.
     Useful on X11, if a sjis or euc string is pasted from a netscape
     or other program."

    clipBoardEncoding := aSymbol

    "
     Screen current clipBoardEncoding:#sjis
     Screen current clipBoardEncoding:#euc
     Screen current clipBoardEncoding:nil
    "

    "Created: 28.6.1997 / 13:46:12 / cg"
    "Modified: 28.6.1997 / 17:28:02 / cg"
!

copyBufferAsString
    "return my current selection as a string"

    ^ self class bufferAsString:self getCopyBuffer.
!

getClipboardObjectFor:drawableId
    "Retrieve the common per-display selection object.
     For clipBoard mechanisms to work (into ST/X),
     this must be redefined in a concrete subclass"

    ^ nil
!

getClipboardText:selectionBufferSymbol for:drawableId
    "Retrieve the common per-display selection text.
     For clipBoard mechanisms to work (into ST/X),
     this must be redefined in a concrete subclass"

    ^ nil
!

getCopyBuffer
    "return the copyBuffers contents.
     This is an ST/X internal buffer (i.e. its not visible to alien views)."

    ^ copyBuffer

    "Modified: 11.12.1996 / 12:55:42 / cg"
    "Created: 11.12.1996 / 13:34:34 / cg"
!

getCopyBufferHistory
    "return the copyBufferHistory.
     This is an ST/X internal buffer (i.e. its not visible to alien views)."

    ^ CopyBufferHistory ? #()
!

rememberCopyBuffer
    "remember the current copyBuffer value in the copyBuffer-history (for paste previous);
     but only do so, if it is a string"

    copyBuffer size == 0 ifTrue:[
	^ self
    ].
    copyBuffer isString ifFalse:[
	copyBuffer isStringCollection ifFalse:[
	    ^ self
	]
    ].
    self rememberInCopyBufferHistory:copyBuffer.

    "Modified: / 25-08-2010 / 21:58:26 / cg"
!

rememberInCopyBufferHistory:aString
    "add aString to the copyBuffer LRU-cache.
     Allows for the last 20 (or so) copy/cut strings to be recovered
     (via Shift-Paste)"

    CopyBufferHistory isNil ifTrue:[
	CopyBufferHistory := OrderedCollection new.
    ].
    CopyBufferHistory remove:aString ifAbsent:nil.
    CopyBufferHistory addFirst:aString.

    CopyBufferHistory size > (CopyBufferHistorySize ? 20) ifTrue:[
	CopyBufferHistory removeLast
    ].

    "Created: / 25-08-2010 / 21:57:08 / cg"
!

setClipboardObject:anObject owner:aWindowId
    "set the common per-display object selection.
     This can be used by other Smalltalk(X) applications only.
     For clipBoard mechanisms to work (out of ST/X),
     this must be redefined in a concrete subclass to copy
     anObject to the devices clipBoard."

    ^ nil
!

setClipboardObject:something ownerView:aView
    "set the object selection - both the local one, and tell the display
     that we have changed it (i.e. place it into the clipBoard)."

    |viewID|

    self rememberCopyBuffer.
    self setCopyBuffer:something.

    viewID := aView drawableId.
    viewID notNil ifTrue:[ "/ if the view is not already closed
        self setClipboardObject:something owner:viewID.
    ]
!

setClipboardText:aString owner:aView
    "Set the common per-display selection text.
     For clipBoard mechanisms to work (out of ST/X),
     this must be redefined in a concrete subclass to copy
     aString to the devices clipBoard."

    ^ nil

    "Modified: 11.12.1996 / 12:56:36 / cg"
!

setClipboardText:aString ownerView:aView
    "set the text selection - both the local one, and tell the display
     that we have changed it (i.e. place it into the clipBoard)."

    |s viewID|

    self rememberCopyBuffer.
    self setCopyBuffer:aString.

    s := aString ? ''.
    s isString ifFalse:[
        s := s asStringWithCRsFrom:1 to:(s size) compressTabs:false withCR:false
    ].

    viewID := aView drawableId.
    viewID notNil ifTrue:[ "/ if the view is not already closed
        "/ TODO: should add support to pass emphasis information too
        s := s string.
        self setClipboardText:s owner:viewID.
    ] ifFalse:[
        Transcript showCR:'DeviceWorkstation [warning]: setClipboardText - view has no id; selection only kept locally'
    ].
!

setCopyBuffer:something
    "set the copyBuffers contents.
     This is an ST/X internal buffer (i.e. its not visible to alien views)."

    copyBuffer := something.

    "Created: 11.12.1996 / 12:54:23 / cg"
    "Modified: 11.12.1996 / 12:55:53 / cg"
!

setPrimaryText: text ownerView: view
    "Overridden in XWorkstation to support X's PRIMARY selection, intentionally void here"

    "Created: / 27-03-2012 / 15:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSelection:anObject owner:aWindowId
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #setClipboardObject:owner:'.
    self setClipboardObject:anObject owner:aWindowId
!

setSelection:something ownerView:aView
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #setClipboardObject:ownerView:'.
    self setClipboardObject:something ownerView:aView
!

setTextSelection:aString owner:aWindowId
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #setClipboardText:owner'.
    self setClipboardText:aString owner:aWindowId
!

setTextSelection:aString ownerView:aView
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #setClipboardText:ownerView'.
    self setClipboardText:aString ownerView:aView
! !

!DeviceWorkstation methodsFor:'color stuff'!

availableDitherColors
    "return the table of preallocated emergency ditherColors
     plus possibly available fixColors."

    |s|

    s := IdentitySet new.
    fixColors notNil ifTrue:[
	s addAll:fixColors.
    ].
    fixGrayColors notNil ifTrue:[
	s addAll:fixGrayColors.
    ].
    ditherColors notNil ifTrue:[
	s addAll:ditherColors.
    ].
    ^ s asArray

    "Created: 11.7.1996 / 18:13:30 / cg"
    "Modified: 24.6.1997 / 16:23:50 / cg"
!

blueComponentOfColor:colorId
    "get blue component (0..100) of color in map at:index"

    ^ (self getRGBFrom:colorId) at:3

!

colorCell
    "allocate a color - return index or nil, if no color cell
     can be allocated (out of colors or trueColor device)"

    ^ nil
!

colorMap
    "return my displays colormap, or nil, if the display is not colorMap based
     (i.e. not PseudoColor)"

    |mapSize "{ Class: SmallInteger }"
     depthUsed mapArray|

    visualType == #DirectColor ifTrue:[
	Logger info:'directColor displays not fully supported'.
	^ nil
    ].

    (visualType == #StaticGray or:[visualType == #TrueColor]) ifTrue:[
	"
	 those have no colorMap - we're done
	"
	^ nil
    ].

    "
     get some attributes of the display device
    "
    depthUsed := depth.

    "/ kludge for 15bit XFree server
    "/ (but: I have never encountered a PseudoColor display with more
    "/  than 8 bits ...)

    depthUsed == 15 ifTrue:[
	depthUsed := 16
    ].
    depthUsed > 16 ifTrue:[
	"/ do not allocate zillions of colors ...
	self error:'unreasonably large colorMap ...'.
	^ nil
    ].

    mapSize := (1 bitShift:depthUsed).

    "/ get the palette
    mapArray := Array new:mapSize.
    1 to:mapSize do:[:i |
	self getRGBFrom:(i-1) into:[:r :g :b |
	    mapArray at:i put:(Color red:r green:g blue:b)
	]
    ].
    ^ mapArray.

    "
     Display colorMap
    "

    "Created: 11.7.1996 / 10:53:38 / cg"
    "Modified: 10.1.1997 / 15:40:10 / cg"
!

colorNamed:aString
    "allocate a color with color name - return the color index (i.e. colorID).
     Only a subset of the colorNames are available on all displays;
     therefore, don't use this method; at least only for the common names such as red, green, blue etc."

    ^ self
        getScaledRGBFromName:aString
        into:[:r :g :b |
            self colorScaledRed:r scaledGreen:g scaledBlue:b
        ]

    "
     Screen current colorNamed:'red'
    "
!

colorRed:redVal green:greenVal blue:blueVal
    "allocate a color with rgb values (0..100) - return the color index (i.e. colorID).
     This method is obsoleted by #colorScaledRed:scaledGreen:scaledBlue:"

    |r g b|

    r := self percentToDeviceColorValue:redVal.
    g := self percentToDeviceColorValue:greenVal.
    b := self percentToDeviceColorValue:blueVal.
    ^ self colorScaledRed:r scaledGreen:g scaledBlue:b
!

colorScaledRed:red scaledGreen:green scaledBlue:blue
    "return an id for a color.
     On trueColor displays, nothing is actually allocated,
     and the returned colorID is formed by simply packing the RGB values." 
    
    visualType == #TrueColor ifTrue:[
        ^ (((red asInteger bitShift:-8) bitShift:redShift)
          bitOr:((green asInteger bitShift:-8) bitShift:greenShift))
          bitOr:((blue asInteger bitShift:-8) bitShift:blueShift)
    ].

    self subclassResponsibility:'this fallback is only valid for trueColor displays'

    "Modified: / 03-02-2014 / 11:30:23 / cg"
!

deviceColorValueToPercent:deviceColorValue
    ^ self subclassResponsibility
!

ditherColors
    "return the table of preallocated emergency ditherColors"

    ^ ditherColors

    "Modified: 11.7.1996 / 18:13:37 / cg"
!

fixColors
    "return the table of preallocated fix colors (a colorCube),
     or nil if no fix colors were preallocated."

    ^ fixColors

    "Created: 11.7.1996 / 17:49:24 / cg"
!

fixGrayColors
    "return the table of preallocated fix grayScale colors,
     or nil if no fix gray colors were preallocated."

    ^ fixGrayColors

    "Created: 11.7.1996 / 17:49:24 / cg"
!

freeColor:colorIndex
    "free a color on the display, when its no longer needed"

    ^ self subclassResponsibility
!

getRGBFrom:index
    "get rgb components (0..100) of color in map at:index,
     and evaluate the 3-arg block, aBlock with them"

    |triple|

    triple := self getScaledRGBFrom:index.
    triple notNil ifTrue:[
	^ triple collect:[:val | self deviceColorValueToPercent:val]
    ].
    ^ nil
!

getRGBFrom:index into:aBlock
    "get rgb components (0..100) of color in map at:index,
     and evaluate the 3-arg block, aBlock with them"

    |triple|

    triple := self getRGBFrom:index.
    triple notNil ifTrue:[
	^ aBlock valueWithArguments:triple.
    ].
    ^ nil

!

getRGBFromName:colorNameArg
    "get rgb components (0..100) of color named colorName,
     and return a 3-element array, containing them.
     The method here only handles some often used colors;
     getRGBFromName should not be used, since colorNames other
     than those below are X specific."

    |colorName idx names triple r g b|

    colorName := colorNameArg.
    (colorName startsWith:$#) ifTrue:[
	"/ color in r/g/b hex notation
	colorName size < 7 ifTrue:[
	    "/ that's an error, but some web pages do that
	    colorName := '#',((colorName copyFrom:2) leftPaddedTo:6 with:$0).
	].
	r := Integer readFrom:(colorName copyFrom:2 to:3) radix:16.
	g := Integer readFrom:(colorName copyFrom:4 to:5) radix:16.
	b := Integer readFrom:(colorName copyFrom:6 to:7) radix:16.
	r := (r * 100 / 255).
	g := (g * 100 / 255).
	b := (b * 100 / 255).
	^ Array with:r with:g with:b
    ].

    names := #(
		'red'
		'green'
		'blue'
		'yellow'
		'magenta'
		'cyan'
		'white'
		'black'

		'olive'
		'teal'
		'silver'
		'lime'
		'fuchsia'
		'aqua'
	      ).
    idx := names indexOf:colorName.
    idx == 0 ifTrue:[
	idx := names indexOf:colorName asLowercase.
    ].
    idx ~~ 0 ifTrue:[
	triple := #(
			(100   0   0)  "red"
			(  0 100   0)  "green"
			(  0   0 100)  "blue"
			(100 100   0)  "yellow"
			(100   0 100)  "magenta"
			(  0 100 100)  "cyan"
			(100 100 100)  "white"
			(  0   0   0)  "black"

			( 50  50   0)  "olive"
			(  0  50  50)  "teal"
			( 40  40  40)  "silver"
			( 20 100   0)  "lime"
			( 60   3 100)  "fuchsia"
			( 10 100 100)  "aqua"
		   ) at:idx.

	^ triple
    ].
    ^ nil
!

getRGBFromName:colorName into:aBlock
    "get rgb components (0..100) of color named colorName,
     and evaluate the 3-arg block, aBlock with them"

    |triple|

    triple := self getScaledRGBFromName:colorName.
    triple notNil ifTrue:[
	^ aBlock value:(self deviceColorValueToPercent:(triple at:1))
		 value:(self deviceColorValueToPercent:(triple at:2))
		 value:(self deviceColorValueToPercent:(triple at:3))
    ].
    ^ nil

    "
     Display getRGBFromName:'red' into:[:r :g :b | r printCR. g printCR. b printCR.]
    "
!

getScaledRGBFrom:index
    "get rgb components (0..devicesMaxColorVal) of color in map at:index,
     and return a 3-element array containing them"

    ^ self subclassResponsibility
!

getScaledRGBFrom:index into:aBlock
    "get rgb components (0..devicesMaxColorVal) of color in map at:index,
     and evaluate the 3-arg block, aBlock with them"

    |triple|

    triple := self getScaledRGBFrom:index.
    triple notNil ifTrue:[
	^ aBlock valueWithArguments:triple.
    ].
    ^ nil

!

getScaledRGBFromName:colorName
    "get rgb components (0..devicesMaxColorVal) of color named colorName,
     and return a 3-element array containing them"

    |triple|

    triple := self getRGBFromName:colorName.
    triple notNil ifTrue:[
	^ triple collect:[:val | self percentToDeviceColorValue:val].
    ].
    ^ nil.

!

getScaledRGBFromName:colorName into:aBlock
    "get rgb components (0..devicesMaxColorVal) of color named colorName,
     and evaluate the 3-arg block, aBlock with them.
     Return nil for unknown color names."

    |triple|

    triple := self getScaledRGBFromName:colorName.
    triple notNil ifTrue:[
	^ aBlock valueWithArguments:triple.
    ].
    ^ nil
!

greenComponentOfColor:colorId
    "get green component (0..100) of color in map at:index"

    ^ (self getRGBFrom:colorId) at:2
!

listOfAvailableColors
    "return a list of all available colornames;
     This method should not be used, since colornames are
     very X specific. However, the names defined here are pretty common"

    ^ #('red' 'green' 'blue' 'yellow' 'magenta' 'cyan' 'white' 'black')
!

numFixBlue
    "return the number of blue shades in the
     preallocated fix color cube (or 0 if there is none)"

    ^ numFixBlue
!

numFixGreen
    "return the number of green shades in the
     preallocated fix color cube (or 0 if there is none)"

    ^ numFixGreen

    "Created: 11.7.1996 / 17:50:12 / cg"
!

numFixRed
    "return the number of red shades in the
     preallocated fix color cube (or 0 if there is none)"

    ^ numFixRed

    "Created: 11.7.1996 / 17:50:20 / cg"
!

percentToDeviceColorValue:percent
    ^ self subclassResponsibility
!

redComponentOfColor:colorId
    "get red component (0..100) of color in map at:index"

    ^ (self getRGBFrom:colorId) at:1

    "
     Display redComponentOfColor:1
    "
!

releaseFixColors
    "release the fix colorMap"

    fixColors := nil.
    numFixRed := numFixGreen := numFixBlue := 0.

    "
     Display releaseFixColors
    "

    "Created: 11.7.1996 / 18:00:42 / cg"
    "Modified: 23.6.1997 / 15:32:04 / cg"
!

releaseFixGrayColors
    "release the fix colorMap"

    fixGrayColors := nil.

    "
     Display releaseFixGrayColors
    "

    "Created: 23.6.1997 / 15:32:00 / cg"
!

setColor:index red:redVal green:greenVal blue:blueVal
    "change color in map at:index to rgb (0..100).
     This is a no-op on TrueColor systems."

    ^ self
!

setDitherColors:colors
    "set the table of preallocated emergency dither fix colors
     These preallocated colors
     (white, black, red, green, blue and a few grayScales) prevent
     running out of colors later, when images have to be dithered or
     pen colors must be approximated.
     ((Although, with such a small number of colors, the result will
       definitely look poor))"

    ditherColors := colors.

    "Created: 11.7.1996 / 18:11:45 / cg"
!

setFixColors:colors numRed:nR numGreen:nG numBlue:nB
    "set the table of preallocated fix colors (a colorCube),
     and the number of r/g/b entries in each dimension."

    fixColors := colors.
    numFixRed := nR.
    numFixGreen := nG.
    numFixBlue := nB.

    "Created: 11.7.1996 / 17:56:18 / cg"
    "Modified: 11.7.1996 / 17:57:10 / cg"
!

setFixGrayColors:colors
    "set the table of preallocated fix gray colors"

    fixGrayColors := colors.
! !

!DeviceWorkstation methodsFor:'copying'!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    ^ nil
! !

!DeviceWorkstation methodsFor:'cursor stuff'!

builtInCursorShapes
    "return a collection of standard cursor names.
     Hre none is assumed - so all cursors are created as user cursors
     (see Cursor>>initializeNewCursors)"

    "/ if you add something here, also add to #shapeNumberFromCursor ...

    ^ #()

    "Created: 8.4.1997 / 10:32:31 / cg"
!

colorCursor:aCursorId foreground:fgColor background:bgColor
    "change a cursors colors.
     Ignored on systems which do not support colored cursors."

    ^ self
!

createCursorShape:aShapeSymbol
    "create a cursor given a shape-symbol; return a cursorID or nil.
     This only works for a few standard cursors, and returns nil
     if no such cursor exists.
     Always care for a fallBack, in case of a nil return."

    ^  nil
!

createCursorSourceForm:sourceForm maskForm:maskForm hotX:hx hotY:hy width:w height:h
    "create a cursor given 2 bitmaps (source, mask) and a hotspot.
     Returns nil, if no cursor can be created (for any reason)"

    ^ self subclassResponsibility
!

destroyCursor:aCursorId
    "free a cursor"

    ^ self subclassResponsibility
!

needDeviceFormsForCursor
    "return true, if this device requires device-forms as opposed
     to a simple bitmap-byteArray for creation.
     Redefined in X- and Win- Workstation classes."

    ^ self subclassResponsibility
!

shapeNumberFromSymbol:shape
    "given a shape-symbol, return the corresponding cursor-number,
     or nil if no such standard cursor exists."

    ^ nil
! !

!DeviceWorkstation methodsFor:'drag & drop'!

dragFinish:dropHandle
!

drop:aCollectionOfDropObjects inWindowID:destinationId position:destinationPoint rootPosition:rootPoint
    "device specific drop here"

    "/ self subclassResponsibility

    "Created: 4.4.1997 / 18:33:44 / cg"
    "Modified: 11.4.1997 / 12:43:23 / cg"
! !

!DeviceWorkstation methodsFor:'drawing'!

copyFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt"

    ^ self subclassResponsibility
!

copyFromPixmapId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt from a pix- or bitmap.
     Here, fall back into copyFromId:, which should also work.
     Subclasses may redefine this for more performance or if required"

    ^ self copyFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
!

copyPlaneFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt, using the low-bit plane of the source only"

    ^ self subclassResponsibility
!

copyPlaneFromPixmapId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt from a pix- or bitmap, using the low-bit plane of the source only.
     Here, fall back into copyPlaneFromId:, which should also work.
     Subclasses may redefine this for more performance or if required"

    ^ self copyPlaneFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
!

displayArcX:x y:y width:width height:height from:startAngle angle:angle
	     in:aDrawableId with:aGCId
    "draw an arc"

    ^ self subclassResponsibility

    "Created: 8.5.1996 / 08:44:43 / cg"
!

displayLineFromX:x0 y:y0 toX:x1 y:y1 in:aDrawableId with:aGCId
    "draw a line"

    "
     could add a bresenham line drawer here ...
    "
    ^ self subclassResponsibility
!

displayLinesFromX:xStart step:xStep yValues:ydata scaleY:yScale transY:yTrans in:drawableId with:gcId
    "draw a polygon starting at x; the y values derives from the collection yValues.
     The associated x is a multiple of step. Each y value will be scaled and translated.
     The implementation here is a fallback, using the line-draw primitive;
     devices which support fast drawing of a polygon may redefine this for more performance."

    |x xLast yLast|

    ydata size == 0 ifTrue:[^ self].

    xLast := xStart.
    yLast := (ydata at:1) * yScale + yTrans.
    ydata from:2 do:[:y | |yT|
	x := xLast + xStep.
	yT := y * yScale + yTrans.
	self displayLineFromX:xLast rounded y:yLast rounded toX:x rounded y:yT rounded in:drawableId with:gcId.
	xLast := x.
	yLast := y.
    ]
!

displayOpaqueString:aString from:index1 to:index2 x:x y:y in:aDrawableId with:aGCId
    "draw a sub-string - draw foreground on background.
     If the coordinates are not integers, retry with rounded."

    self displayString:aString
	 from:index1
	 to:index2
	 x:x
	 y:y
	 in:aDrawableId
	 with:aGCId
	 opaque:true
!

displayOpaqueString:aString x:x y:y in:aDrawableId with:aGCId
    "draw a string - draw foreground on background.
     If the coordinates are not integers, retry with rounded."

    self displayString:aString
	 x:x
	 y:y
	 in:aDrawableId
	 with:aGCId
	 opaque:true
!

displayPointX:x y:y in:aDrawableId with:aGCId
    "draw a point"

    "/ could use
    "/ self displayLineFromX:x y:y toX:x y:y in:aDrawableId with:aGCId.
    "/ but then, we had to care for lineWidth & style ...

    ^ self subclassResponsibility

    "Modified: / 3.5.1999 / 14:26:32 / cg"
!

displayPolygon:aPolygon in:aDrawableId with:aGCId
    "draw a polygon"

    "
     could draw the lines here
     but then, we have to reimplement all line and join styles here
    "
    ^ self subclassResponsibility
!

displayPolylines:arrayOfPoints in:aDrawableId with:aGCId
    "draw a bunch of lines"

    |startPoint p|

    1 to:arrayOfPoints size by:2 do:[:idx |
	p := arrayOfPoints at:idx.
	idx odd ifTrue:[
	    startPoint := p
	] ifFalse:[
	    self
		displayLineFromX:startPoint x
		y:startPoint y
		toX:p x
		y:p y
		in:aDrawableId
		with:aGCId
	]
    ]
!

displayRectangleX:x y:y width:width height:height in:aDrawableId with:aGCId
    "draw a rectangle"

    "
     could draw four lines here
     but then, we have to reimplement all line and join styles here
    "
    ^ self subclassResponsibility
!

displayString:aString from:index1 to:index2 x:x y:y in:aDrawableId with:aGCId
    "draw a sub-string - draw foreground only.
     If the coordinates are not integers, retry with rounded."

    self
	displayString:aString
	from:index1
	to:index2
	x:x
	y:y
	in:aDrawableId
	with:aGCId
	opaque:false
!

displayString:aString from:i1 to:i2 x:x y:y in:aDrawableId with:aGCId opaque:opaque
    "draw part of a string"

    ^ self subclassResponsibility
!

displayString:aString x:x y:y in:aDrawableId with:aGCId
    "draw a string - draw foreground only.
     If the coordinates are not integers, retry with rounded."

    self
	displayString:aString
	x:x
	y:y
	in:aDrawableId
	with:aGCId
	opaque:false
!

displayString:aString x:x y:y in:aDrawableId with:aGCId opaque:opaque
    "draw a string"

    self displayString:aString
		  from:1
		    to:aString size
		     x:x
		     y:y
		     in:aDrawableId
		     with:aGCId
		     opaque:opaque
!

drawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth padding:pad
			  width:imageWidth height:imageHeight
			      x:srcx y:srcy
			   into:aDrawableId
			      x:dstx y:dsty
			  width:w height:h
			   with:aGCId
    "draw a bitimage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     It has to be checked elsewhere, that server can do it with the given
     depth; also it is assumed, that the colormap is setup correctly.
     The actual bits per pixel may be different from the depth (for example,
     on a depth-15 device, 16 bits/pixel may be used; also, many depth-24
     systems actually use 32 bits/pixel)"

    ^ self subclassResponsibility
!

drawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth
			  width:imageWidth height:imageHeight
			      x:srcx y:srcy
			   into:aDrawableId
			      x:dstx y:dsty
			  width:w height:h
			   with:aGCId

    "draw a bitimage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     It has to be checked elsewhere, that server can do it with the given
     depth; also it is assumed, that the colormap is setup correctly.
     The actual bits per pixel may be different from the depth (for example,
     on a depth-15 device, 16 bits/pixel may be used; also, many depth-24
     systems actually use 32 bits/pixel).
     This assumes a padding of 8-bits (i.e. byte-boundary),
     which is the natural padding within ST/X."

    ^ self
	drawBits:imageBits
	bitsPerPixel:bitsPerPixel
	depth:imageDepth
	padding:8
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:aDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId

    "Created: / 16.4.1997 / 14:55:57 / cg"
    "Modified: / 21.1.1998 / 13:27:58 / cg"
!

drawBits:imageBits depth:imageDepth padding:pad width:imageWidth height:imageHeight
	x:srcx y:srcy into:aDrawableId x:dstx y:dsty width:w height:h with:aGCId

    "draw a bitimage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     It has to be checked elsewhere, that server can do it with the given
     depth; also it is assumed, that the colormap is setup correctly"

    ^ self
	drawBits:imageBits
	bitsPerPixel:imageDepth
	depth:imageDepth
	padding:pad
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:aDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId
!

drawBits:imageBits depth:imageDepth width:imageWidth height:imageHeight
		       x:srcx y:srcy
		    into:aDrawableId x:dstx y:dsty width:w height:h with:aGCId

    "draw a bitimage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     It has to be checked elsewhere, that server can do it with the given
     depth; also it is assumed, that the colormap is setup correctly.
     This assumes a padding of 8-bits (i.e. byte-boundary),
     which is the natural padding within ST/X."

    ^ self
	drawBits:imageBits
	bitsPerPixel:imageDepth
	depth:imageDepth
	width:imageWidth height:imageHeight
	x:srcx y:srcy
	into:aDrawableId
	x:dstx y:dsty
	width:w height:h
	with:aGCId

    "Modified: / 21.1.1998 / 13:28:34 / cg"
!

fillArcX:x y:y width:width height:height from:startAngle angle:angle
	       in:aDrawableId with:aGCId
    "fill an arc"

    ^ self subclassResponsibility

    "Created: 8.5.1996 / 08:45:11 / cg"
!

fillPolygon:aPolygon in:aDrawableId with:aGCId
    "fill a polygon"

    ^ self subclassResponsibility
!

fillRectangleX:x y:y width:width height:height in:aDrawableId with:aGCId
    "fill a rectangle"

    ^ self subclassResponsibility
! !

!DeviceWorkstation methodsFor:'enumerating'!

allTopViews
    "return a collection of all my known top views"

    ^self allViews select:[:eachView | eachView isTopView].

!

allViewsDo:aBlock
    "evaluate the argument, aBlock for all of my known views.
     Warning do not use this to remove view
     (never remove elements from an enumerated collection)"

    knownViews notNil ifTrue:[
	knownViews do:aBlock
    ].

    "
     View defaultStyle:#iris.
     Display allViewsDo:[:v | v initStyle. v redraw]
    "
    "
     View defaultStyle:#next.
     Display allViewsDo:[:v | v initStyle. v redraw]
    "
    "
     View defaultStyle:#normal.
     Display allViewsDo:[:v | v initStyle. v redraw]
    "

    "Modified: / 19.1.2000 / 10:13:32 / cg"
! !

!DeviceWorkstation methodsFor:'error handling'!

primitiveFailedOrClosedConnection
    "sent by all primitives here, when something is wrong.
     Check what was wrong and raise a corresponding error here."

    self isOpen ifFalse:[
	"/ ignore in end-user apps
	(Smalltalk isSmalltalkDevelopmentSystem) ifTrue:[
	    DrawingOnClosedDeviceSignal raiseRequestWith:self.
	].
	^ nil
    ].
    ^ self primitiveFailed
!

resourceOfId:id
    "search through all device stuff for a resource.
     Needed for error handling.

     Since id may be an ExternalAddress, do not compare with =="

    |addr|

    id isNil ifTrue:[
	"nil id is no resource"
	^ nil
    ].

    self allViewsDo:[:aView |
	(aView drawableId = id or:[aView gcId = id]) ifTrue:[^ aView].
    ].

    Form allSubInstancesDo:[:f |
	(f drawableId = id and:[f graphicsDevice == self]) ifTrue:[^ f]
    ].

    Font allInstancesDo:[:f |
	 (f fontId = id and:[f graphicsDevice == self]) ifTrue:[^ f]
    ].

    "KLUDGE: XWorkstation stores all IDs in ExternalAddresses,
	     only colorId is stored as SmallInteger,
	     But resourceOfLastError returns an ExternalAddress even for colors."

    (id respondsTo:#address) ifTrue:[
	addr := id address.
    ].
    Color allInstancesDo:[:c |
	(c graphicsDevice == self
	and:[ c colorId = id or:[ c colorId = addr ]]) ifTrue:[^ c].
    ].
    ^ nil
! !

!DeviceWorkstation methodsFor:'event forwarding'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    "forward a button-motion for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor buttonMotion:buttonAndModifierState x:x y:y view:aView
!

buttonMultiPress:button x:x y:y view:aView
    "forward a button-multi-press event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor buttonMultiPress:button x:x y:y view:aView
!

buttonPress:buttonArg x:x y:y view:aView
    "forward a button-press event for some view"

    |sensor button|

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].

    button := buttonArg.
    "/ used that for X on a mac, with a single button.
    "/ No longer done automatically.
    (metaDown and:[button == 1]) ifTrue:[
	UserPreferences current button2WithAltKey ifTrue:[
	    button := 2.
	].
    ].

    sensor := aView sensor.
    WindowsRightButtonBehavior == true ifTrue:[
	button >= 2 ifTrue:[
	    sensor buttonPress:1 x:x y:y view:aView.
	    ^ self.
	]
    ].
    sensor buttonPress:button x:x y:y view:aView
!

buttonRelease:button x:x y:y view:aView
    "forward a button-release event for some view"

    |sensor|

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    sensor := aView sensor.
    WindowsRightButtonBehavior == true ifTrue:[
	button >= 2 ifTrue:[
	    sensor buttonRelease:1 x:x y:y view:aView.
	    sensor buttonPress:button x:x y:y view:aView.
	    sensor buttonRelease:button x:x y:y view:aView.
	    ^ self.
	].
    ].
    sensor buttonRelease:button x:x y:y view:aView
!

configureX:x y:y width:w height:h view:aView
    "forward a configure (i.e. size or position change) event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor configureX:x y:y width:w height:h view:aView
!

coveredBy:otherView view:aView
    "forward a covered for some view
     (aView has been covered by otherView)"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor coveredBy:otherView view:aView
!

destroyedView:aView
    "forward a destroyed event for some view"

    |sensor|

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].

    "/ this one has special treatment - the destroyed could
    "/ (in certain situations) arrive after the view has shutdown its
    "/ sensor.
    sensor := aView sensor.
    sensor notNil ifTrue:[
	sensor destroyedView:aView
    ].
!

exposeX:x y:y width:w height:h view:aView
    "forward an expose for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor exposeX:x y:y width:w height:h view:aView
!

focusInView:aView
    "forward a focusIn event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor focusInView:aView
!

focusOutView:aView
    "forward a focusOut event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor focusOutView:aView
!

graphicsExposeX:x y:y width:w height:h final:final view:aView
    "forward a graphic expose for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor graphicsExposeX:x y:y width:w height:h final:final view:aView
!

hotkeyWithId:aHotkeyId key:aKey view:aView
    "forward a hotkey press for a view
    "

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor hotkeyWithId:aHotkeyId key:aKey view:aView
!

keyPress:untranslatedKeyArg x:x y:y view:aView
    "forward a key-press event for some view"

    <resource: #keyboard (#Escape)>

    |untranslatedKey|

    untranslatedKeyArg isInteger ifTrue:[
	untranslatedKey := Character value:untranslatedKeyArg
    ] ifFalse:[
	untranslatedKey := untranslatedKeyArg
    ].

    "/ Timestamp now print. 'X: ' print. untranslatedKey printCR.

    "/ ctrl/meta-ESC give up focus& escapes an activePointerGrab
    untranslatedKey == #Escape ifTrue:[
	(activePointerGrab notNil
	and:[ctrlDown or:[metaDown]]) ifTrue:[
	    self ungrabPointer.
	    self ungrabKeyboard.
	    self setInputFocusTo:nil
	]
    ].

    self modifierKeyProcessing:untranslatedKey down:true.

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].

"/    xlatedKey := self translateKey:untranslatedKey forView:aView.
"/    xlatedKey == #Hardcopy ifTrue:[
"/        [
"/            Transcript topView application
"/                saveScreenImage:(Image fromView:(aView topView) "inset:0" grab:true) defaultName:'hardcopy'.
"/        ] forkAt:Processor userSchedulingPriority + 1.
"/        ^ self.
"/    ].
"/
    aView sensor keyPress:untranslatedKey x:x y:y view:aView

    "Modified (format): / 12-07-2012 / 18:37:40 / cg"
!

keyRelease:untranslatedKeyArg x:x y:y view:aView
    "forward a key-release event for some view"

    |untranslatedKey xlatedKey|

    untranslatedKeyArg isInteger ifTrue:[
	untranslatedKey := Character value:untranslatedKeyArg
    ] ifFalse:[
	untranslatedKey := untranslatedKeyArg
    ].

    self modifierKeyProcessing:untranslatedKey down:false.

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].

    xlatedKey := self translateKey:untranslatedKey forView:aView.
    xlatedKey == #Hardcopy ifTrue:[^ self].

    aView sensor keyRelease:untranslatedKey x:x y:y view:aView
!

mappedView:aView
    "forward a mapped event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor mappedView:aView
!

mouseWheelMotion:buttonState x:x y:y amount:amountArg deltaTime:dTime view:aView
    "the mousewheel was moved by some amount (signed).
     This event is sent to the current pointer view (like keyPress/release)."

    |amount|

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    amount := amountArg.
    UserPreferences current mouseWheelDirectionReversed ifTrue:[
	amount := amount negated
    ].
    aView sensor
	mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime view:aView

    "
     UserPreferences current mouseWheelDirectionReversed:true
     UserPreferences current mouseWheelDirectionReversed:false
    "
    "Modified: / 21.5.1999 / 13:05:53 / cg"
!

noExposeView:aView
    "forward a noExpose event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor noExposeView:aView
!

pointerEnter:buttonState x:x y:y view:aView
    "forward a pointer enter for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor pointerEnter:buttonState x:x y:y view:aView
!

pointerLeave:buttonState view:aView
    "forward a pointer leave for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor pointerLeave:buttonState view:aView
!

saveAndTerminateView:aView
    "forward a saveAndTerminate event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor saveAndTerminateView:aView
!

terminateView:aView
    "forward a terminate event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor terminateView:aView.
!

unmappedView:aView
    "forward an unmapped event for some view"

    aView isNil ifTrue:[
	"/ event arrived, after I destroyed it myself
	^ self
    ].
    aView sensor unmappedView:aView
! !

!DeviceWorkstation methodsFor:'event handling'!

addToKnownScreens
    AllScreens isNil ifTrue:[
	AllScreens := IdentitySet new:1
    ].
    AllScreens add:self.
!

checkForEndOfDispatch
    "if there are no longer any views of interest - stop dispatch.
     This ends the dispatcher process when the last view is closed on that device.
     We only do this for displays other that the default Display."

    dispatching ifFalse:[^ self].

    self == Display ifTrue:[
        ExitOnLastClose == true ifFalse:[^ self].
    ].
    exitOnLastClose == true ifFalse:[^ self].

    knownViews notNil ifTrue:[
        "/ if there is no non-popup topview, stop dispatching
        (knownViews contains:[:slot |
                slot notNil
                and:[(self viewIsRelevantInCheckForEndOfDispatch:slot)
                and:[true "slot isModal not"
                "and:[slot realized]"]]]
         ) ifFalse:[
            "/ my last view was closed
            dispatching := false.
            Logger info:'finished dispatch (last view closed): %1' with:self.
            self releaseDeviceResources.
            eventSema notNil ifTrue:[eventSema signal].  "/ get dispatchLoop out of its wait...
        ]
    ].

    "Modified: 19.9.1995 / 11:31:54 / claus"
    "Modified: 18.3.1997 / 10:42:11 / cg"
!

cleanupAfterDispatch
    eventSema notNil ifTrue:[
	Processor disableSemaphore:eventSema.
	eventSema := nil.
    ].
    dispatchProcess := nil.

    DefaultScreen == self ifTrue:[
	(Transcript isView and:[Transcript topView device ~~ self]) ifTrue:[
	    DefaultScreen := Transcript topView device
	] ifFalse:[
	    "/ what should the defaultScreen be - help !!!!!!

	    DefaultScreen := DeviceWorkstation allSubInstances
				detect:[:aDevice | aDevice isOpen] ifNone:nil
	]
    ]
!

dispatchEvent
    "get and process the next pending event - for any view"

    self dispatchEventFor:nil withMask:nil
!

dispatchEventFor:aViewIdOrNil withMask:eventMask
    "central event handling method:
     get next event and send an appropriate message to the view's sensor,
     or to the view directly (if the view has none).
     If the argument aViewIdOrNil is nil, events for any view are processed,
     otherwise only events for the view with given id are processed
     (in this case, nothing is done if no events are pending);
     if the argument aMask is nonNil, only events for this eventMask are
     handled. The mask is a device dependent event mask."

    ^ self subclassResponsibility
!

dispatchLoop
    "the actual event dispatching loop."

    [dispatching] whileTrue:[
	"abortAll is handled, but not asked for here!!"
	AbortAllOperationRequest handle:[:ex |
	    ex return
	] do:[
	    [self eventPending] whileFalse:[
		Processor activeProcess setStateTo:#ioWait if:#active.
		eventSema wait.
		"/ a temporary hack & workaround for semaphore-bug
"/                (eventSema waitWithTimeoutMs:500) isNil ifTrue:[
"/                    "/ timeout
"/                    eventSema wouldBlock ifFalse:[
"/                        Logger info:'sema did not wake up'.
"/                    ] ifTrue:[
"/                        self eventPending ifTrue:[
"/                            Logger info:'sema missed'.
"/                        ].
"/                    ].
"/                ].
		dispatching ifFalse:[^ self].
	    ].
	    dispatching ifTrue:[
		self dispatchPendingEvents.
	    ].
	]
    ]

    "Modified: / 09-02-2011 / 13:59:43 / cg"
!

dispatchModalWhile:aBlock
    "get and process next event for any view as long as the
     argument-block evaluates to true.
     This is a modal loop, not switching to other processes,
     effectively polling the device in a (nice) busy loop.
     This should only be (and is only) used for emergency cases.
     (such as a graphical debugger, debugging the event-dispatcher itself)"

    |myFd|

    "
     if this display has a fileDescriptor to wait on,
     it is used; otherwise we poll (with a delay to not lock up
     the workstation)
    "
    myFd := self displayFileDescriptor.
    [aBlock value] whileTrue:[
	self eventPending ifFalse:[
	    myFd isNil ifTrue:[
		OperatingSystem millisecondDelay:50
	    ] ifFalse:[
		OperatingSystem selectOn:myFd withTimeOut:50.
	    ].
	    Processor evaluateTimeouts.
	].
	self eventPending ifTrue:[
	    self dispatchEvent
	].
    ]
!

dispatchPendingEvents
    "go dispatch events as long as there is one.
     This is only used with modal operation.
     (i.e. when in the modal debugger)"

    OSSignalInterrupt handle:[:ex |
	ex return
    ] do:[
	[self eventPending] whileTrue:[
	    self dispatchEventFor:nil withMask:nil.
	    "/ multi-screen config: give others a chance
	    "/ (needed because we run at high (non-timesliced) prio)
	    Processor yield.
	]
    ]
!

disposeButtonEventsFor:aViewIdOrNil
    "dispose (i.e. forget) all pending button events on this display"

    |mask|

    mask := self eventMaskFor:#buttonPress.
    mask := mask bitOr:(self eventMaskFor:#buttonRelease).
    mask := mask bitOr:(self eventMaskFor:#buttonMotion).
    self disposeEventsWithMask:mask for:aViewIdOrNil
!

disposeEvents
    "dispose (i.e. forget) all events pending on this display"

    [self eventPending] whileTrue:[
	self getEventFor:nil withMask:nil into:nil
    ].
!

disposeEventsWithMask:aMask for:aWindowId
    "dispose (throw away) specific events"

    ^ self subclassResponsibility
!

eventMaskFor:anEventSymbol
    ^ self subclassResponsibility
!

eventPending
    "return true, if any event is pending"

    ^ self subclassResponsibility
!

eventPending:anEventSymbol for:aWindowId
    "return true, if a specific event is pending for a specific window.
     This expects device independent event symbols (such as #buttonPress,
     #buttonRelease etc.) as first argument."

    ^ self subclassResponsibility
!

eventPending:anEventMask for:aWindowId withSync:doSync
    "return true, if any of the masked events is pending
     for a specific window.
     This expects a device dependent event mask as first argument."

    ^ self subclassResponsibility
!

eventPendingWithSync:doSync
    "return true, if any event is pending"

    ^ self subclassResponsibility
!

eventQueued
    "return true, if any event is pending in some internal queue.
     The fallBack here returns true if events are pending on the display connection;
     only devices which use internal queues (i.e. Xlib) need to redefine this."

    ^ self eventPending
!

eventQueuedAlready
    "return true, if any event is pending in some internal queue.
     The fallBack here returns true if events are pending on the display connection;
     only devices which use internal queues (i.e. Xlib) need to redefine this."

    ^ self eventPending
!

eventsPending:anEventMask for:aWindowId withSync:doSync
    "obsolete - will vanish."

    ^ self eventPending:anEventMask for:aWindowId withSync:doSync
!

registerHotKeyForWindow:aDrawableId withId:anId modifiers:aModifier virtualKeyCode:aVirtualKeyCode
    "Defines a system-wide hot key."

    ^ self subclassResponsibility
!

setEventMask:aMask in:aWindowId
    "arrange that only events from aMask are reported to a view.
     Highly device specific, to be defined in concrete subclasses"

    ^ self subclassResponsibility
!

setupDispatchLoop
    "create & start the display event dispatch process."

    |fd checkBlock|

    fd := self displayFileDescriptor.

    eventSema := Semaphore new name:'display inputSema'.

    "/ arrange for the processor to signal that semaphore when input
    "/ is available or #eventPending returns true

    (fd isNil or:[ OperatingSystem isOSXlike]) ifTrue:[
	"no fd -- so have to check for input also"
	checkBlock := [self eventPending].
    ] ifFalse:[
	"there is a fd, so checkblock has to check only the internal queue"
	checkBlock := [self eventQueued].
    ].

    "/ handle all incoming events from the device, sitting on a semaphore.
    "/ Tell Processor to trigger this semaphore when some event arrives
    "/ for me. Since a select alone may not be enough to know if events are pending
    "/ (Xlib reads out event-queue while doing output), we also install a poll-check block.
    "/ The poll check is also req'd for systems where we cannot do a select
    "/ on the eventQ (i.e. windows).

    Processor signal:eventSema onInput:fd orCheck:checkBlock.

    DeviceIOErrorSignal handle:[:ex |
	"test for handlerBlock until the signal is changed to be class-based"
	ex creator handlerBlock notNil ifTrue:[
	    ex defaultAction.
	] ifFalse:[
	    (self == self class default and:[AllScreens size == 1]) ifTrue:[
		'DeviceWorkstation [error]: I/O error for default display - writing crash.img and exiting' errorPrintCR.
		SnapshotError ignoreIn:[ ObjectMemory writeCrashImage ].
		Smalltalk exit:1.
	    ].
	    'DeviceWorkstation [warning]: stop dispatch due to I/O error: ' errorPrint.
	    self errorPrintCR.
	    self brokenConnection.
	].
	ex return.
    ] do:[
	self initializeDeviceResources.
	[
	    self dispatchLoop
	] ifCurtailed:[
	    self cleanupAfterDispatch.
	    self emergencyCloseConnection.
	].
	self cleanupAfterDispatch.
	self close.
    ].

    "Modified: / 29-09-2006 / 12:28:04 / cg"
!

startDispatch
    "create & start the display event dispatch process."

    |p nm|

    "/
    "/ only allow one dispatcher process per display
    "/
    (dispatchProcess notNil and:[dispatchProcess isDead not]) ifTrue:[^ self].
    dispatching := true.

    self addToKnownScreens.

    p := [ self setupDispatchLoop ] newProcess.

    "/
    "/ give the process a nice name (for the processMonitor)
    "/
    (nm := self displayName) notNil ifTrue:[
	nm := 'event dispatcher (' ,  nm , ')'.
    ] ifFalse:[
	nm := 'event dispatcher'.
    ].
    p name:nm.
    p priority:(Processor userInterruptPriority).
    p beSystemProcess.
    dispatchProcess := p.
    p resume.
!

stopDispatch
    "stop the dispatch process"

    |p|

    LastActiveScreen == self ifTrue:[
	LastActiveScreen := nil.
	LastActiveProcess := nil.
    ].

    (p := dispatchProcess) notNil ifTrue:[
	dispatchProcess := nil.
	p terminateWithAllSubprocessesInGroup.
	p terminateNoSignal.   "/ just in case
    ]
!

unregisterHotKeyForWindow:aDrawableId withId:anId
    "Release a system-wide hot key."

    ^ self subclassResponsibility
!

viewIsRelevantInCheckForEndOfDispatch:aView
    "return true, if the argument is not to be treated as a user view.
     These, if any of them is still present, will prevent the endOfDispatch if the
     exitOnLastClose flag is set."

    ^ aView isRootView not
    and:[ aView isTopView
    and:[ aView isPopUpView not ]]
! !

!DeviceWorkstation methodsFor:'event sending'!

sendKeyOrButtonEvent:typeSymbol x:xPos y:yPos keyOrButton:keySymCodeOrButtonNr state:stateMask toViewId:targetId
    "send a keyPress/Release or buttonPress/Release event to some (possibly alien) view.
     TypeSymbol must be one of: #keyPress, #keyRelease, #buttonPress , #buttonRelease.
     For buttonEvents, the keySymCodeOrButtonNr must be the buttons number (1, 2 ...);
     for key events, it can be either a symbol (as listen in X's keySyms)
     or a numeric keysym code. If state is nil, the modifier bits (shift & control)
     are computed from the keyboardMap - if non-nil, these are passed as modifierbits.
     The non-nil case is the lowlevel entry, where state must include any shift/ctrl information
     (not very user friendly)"

    "/ WARNING: this is a generic implementation that completely bypasses underlaying
    "/ system event queue. It may not be complete - it has been written as a quick hack
    "/ to make UI testing framework kind-of working on systems where there's no proper
    "/ implementation of this method (e.g., Windows at the time)

    | view shiftWasDown ctrlWasDown altWasDown metaWasDown |

    view := self viewFromId: targetId.

    [
        shiftWasDown := shiftDown.
        altWasDown := altDown.
        metaWasDown := metaDown.
        ctrlWasDown := ctrlDown.
        stateMask notNil ifTrue:[ 
            shiftDown := (stateMask bitAnd: self shiftModifierMask) ~~ 0.
            altDown := (stateMask bitAnd: self altModifierMask) ~~ 0.
            metaDown := (stateMask bitAnd: self metaModifierMask) ~~ 0.
            ctrlDown := (stateMask bitAnd: self ctrlModifierMask) ~~ 0.
        ].
        (typeSymbol == #keyPress or:[ typeSymbol == #keyRelease ]) ifTrue:[
            | key |

            key := keySymCodeOrButtonNr.
            (#(Left Right Up Down) includes: key) ifTrue:[ 
                key := (#Cursor , key) asSymbol.
            ].
            typeSymbol == #keyPress ifTrue:[
                self keyPress:key x:1 y:1 view:view.
            ] ifFalse:[
                self keyRelease:key x:1 y:1 view:view.
            ]
        ] ifFalse:[  
            self notYetImplemented.
        ].
    ] ensure:[ 
        shiftDown := shiftWasDown.
        altDown := altWasDown.
        metaDown := metaWasDown.
        ctrlDown := ctrlWasDown.
    ].

    "Modified (comment): / 06-05-2017 / 11:15:25 / jv"
!

simulateKeyboardInput:aCharacterOrString inViewId:viewId
    "send input to some other view, by simulating keyPress/keyRelease
     events.
     Only a few control characters are supported.
     Notice: not all alien views allow this kind of synthetic input;
	     some simply ignore it."

    |control code state|

    aCharacterOrString isString ifTrue:[
	aCharacterOrString do:[:char |
	    self simulateKeyboardInput:char inViewId:viewId
	].
	^ self
    ].

    control := false.
    code := aCharacterOrString codePoint.

    (aCharacterOrString == Character cr) ifTrue:[
	code := #Return
    ] ifFalse:[
	(aCharacterOrString == Character tab) ifTrue:[
	    code := #Tab
	] ifFalse:[
	    (aCharacterOrString == Character esc) ifTrue:[
		code := #Escape
	    ]
	]
    ].

    control ifTrue:[
	state := self ctrlModifierMask
    ].


    "/ the stuff below should not be needed
    "/ (sendKeyOrButtonevent should be able to figure out things itself)
    "/ however, on some linux systems it seems to not work correctly.
    "/ Hopefully, this is correct ...

    code isNumber ifTrue:[
	code >= $A codePoint ifTrue:[
	    code <= $Z codePoint ifTrue:[
		state := self shiftModifierMask
	    ]
	]
    ].

    self sendKeyOrButtonEvent:#keyPress x:0 y:0 keyOrButton:code state:state toViewId:viewId.
    self sendKeyOrButtonEvent:#keyRelease x:0 y:0 keyOrButton:code state:state toViewId:viewId

    "
      sending input to some (possibly alien) view:

      |point id|

      point :=  Display pointFromUser.
      id := Display viewIdFromPoint:point.
      Display simulateKeyboardInput:'Hello_world' inViewId:id
    "

    "Modified: 11.6.1996 / 10:59:42 / cg"
! !

!DeviceWorkstation methodsFor:'font helpers'!

ascentOf:aFontId
    "return the number of pixels above the base line of a font"

    ^ self subclassResponsibility
!

descentOf:aFontId
    "return the number of pixels below the base line of a font"

    ^ self subclassResponsibility
!

encodingOf:aFontId
    "return the characterEncoding of a font.
     Here, we assume an iso8859-1 encoding"

    ^ #'iso8859-1'

    "Created: 23.2.1996 / 00:39:06 / cg"
!

maxAscentOf:aFontId
    "return the number of pixels above the base line of the tallest character
     in a font"

    ^ self subclassResponsibility
!

maxDescentOf:aFontId
    "return the number of pixels below the base line of the tallest character
     in a font"

    ^ self subclassResponsibility
!

maxWidthOfFont:aFontId
    "return the width in pixels of the widest character a specific font"

    ^ self subclassResponsibility
!

minWidthOfFont:aFontId
    "return the width in pixels of the smallest character a specific font"

    ^ self subclassResponsibility
! !

!DeviceWorkstation methodsFor:'font stuff'!

facesInFamily:aFamilyName
    "return a set of all available font faces in aFamily on this display"

    ^ self facesInFamily:aFamilyName filtering:nil


    "
     Display facesInFamily:'times'
     Display facesInFamily:'fixed'
    "

    "Modified: 27.2.1996 / 01:33:47 / cg"
!

facesInFamily:aFamilyName filtering:filterBlock
    "return a set of all available font faces in aFamily on this display.
     But only those matching filterBlock (if nonNil)."

    |fonts|

    fonts := self fontsInFamily:aFamilyName
		  filtering:[:f| f face notNil and:[filterBlock isNil or:[filterBlock value:f]]].
    fonts size == 0 ifTrue:[^ nil].

    ^ fonts collect:[:descr | descr face]

    "
     Display facesInFamily:'fixed' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "

    "Created: 27.2.1996 / 01:33:25 / cg"
    "Modified: 29.2.1996 / 04:29:01 / cg"
!

flushListOfAvailableFonts
    "flush any cached font information - dummy here,
     but should be implemented in subclasses, which keep
     a list of available device fonts.
     This should be flushed, to allow update whenever new fonts
     are installed or the system-font-path changes."

    "Created: / 4.8.1998 / 16:52:13 / cg"
!

fontFamilies
    "return a set of all available font families on this display"

    ^ self fontFamiliesFiltering:nil

    "
     Display fontFamilies
    "

    "Modified: 27.2.1996 / 01:31:14 / cg"
!

fontFamiliesFiltering:aFilterBlock
    "return a set of all available font families on this display,
     but only those matching aFilterBlock (if nonNil)."

    |fonts|

    fonts := self fontsFiltering:aFilterBlock.
    fonts size == 0 ifTrue:[^ nil].

    ^ fonts collect:[:descr | descr family] thenSelect:[:family | family notNil]

    "
     Display fontFamiliesFiltering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "

    "Modified: 29.2.1996 / 04:31:51 / cg"
!

fontMetricsOf:fontId
    "return a fonts metrics info object"

    |info|

    info := DeviceWorkstation::DeviceFontMetrics new.
    info
      ascent:(self ascentOf:fontId)
      descent:(self descentOf:fontId)
      maxAscent:(self maxAscentOf:fontId)
      maxDescent:(self maxDescentOf:fontId)
      minWidth:(self minWidthOfFont:fontId)
      maxWidth:(self maxWidthOfFont:fontId)
      avgWidth:(self widthOf:' ' inFont:fontId).

    ^ info
!

fontDetailMetricsOf:fontId userInputString:aString
    "return a average font Width and overHang for a specified character fonts metrics 
     info object"

    |info|

    info := DeviceWorkstation::DeviceFontMetrics new.
    info
      avgWidth:(self widthOf:aString inFont:fontId)
      overHang:(self overHangOf:aString inFont:fontId).

    ^ info
!

fontResolutionOf:fontId
    "return the resolution (as dpiX @ dpiY) of the font - this is usually the displays resolution,
     but due to errors in some XServer installations, some use 75dpi fonts on higher
     resolution displays and vice/versa."

    ^ self resolution
!

fontsFiltering:aFilterBlock
    "return a set of all available font on this display,
     but only those matching aFilterBlock (if nonNil)."

    |allFonts fonts|

    allFonts := self listOfAvailableFonts.
    allFonts isNil ifTrue:[^ nil].

    fonts := Set new.
    allFonts do:[:fntDescr |
	(aFilterBlock isNil or:[aFilterBlock value:fntDescr]) ifTrue:[
	    fonts add:fntDescr
	]
    ].
    ^ fonts

    "
     Display fontsFiltering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "

    "Modified: 29.2.1996 / 04:30:35 / cg"
!

fontsInFamily:aFamilyName face:aFaceName filtering:filter
    "return a set of all available fonts in aFamily/aFace on this display.
     But only thise matching filter (if nonNil)."

    ^ self
	fontsFiltering:[:fntDescr |
	    (aFamilyName match:fntDescr family caseSensitive:false)
	    and:[ (aFaceName match:fntDescr face caseSensitive:false)
	    and:[ (filter isNil or:[filter value:fntDescr]) ]]
	]

    "
     Display fontsInFamily:'fixed' face:'medium' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "

    "Created: 29.2.1996 / 04:32:56 / cg"
    "Modified: 30.6.1997 / 11:07:21 / cg"
!

fontsInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filter
    "return a set of all available font in aFamily/aFace/aStyle
     on this display.
     But only those matching filter (if nonNIl)."

    ^ self
	fontsFiltering:[:fntDescr |
		(aFamilyName match:fntDescr family caseSensitive:false)
		and:[ (aFaceName match:fntDescr face caseSensitive:false)
		and:[ (aStyleName match:fntDescr style caseSensitive:false)
		and:[ (filter isNil or:[filter value:fntDescr]) ]]]
	]

    "
     Display fontsInFamily:'fixed' face:'medium' style:'roman' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "
    "
     Display fontsInFamily:'fixed' face:'*' style:'roman' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "
    "
     Display fontsInFamily:'courier' face:'medium' style:'roman' filtering:nil
     Display fontsInFamily:'courier' face:'normal' style:'roman' filtering:nil
     Display fontsInFamily:'Courier' face:'normal' style:'roman' filtering:nil
    "

    "Created: 29.2.1996 / 04:25:30 / cg"
    "Modified: 30.6.1997 / 11:07:08 / cg"
!

fontsInFamily:aFamilyName filtering:filter
    "return a set of all available font in aFamily on this display.
     But only those matching filterBlock (if nonNil)."

    ^ self
	fontsFiltering:[:fntDescr |
	    (aFamilyName match:fntDescr family caseSensitive:false)
	    and:[ (filter isNil or:[filter value:fntDescr]) ]
	]

    "
     Display fontsInFamily:'fixed' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "
    "
     Display fontsInFamily:'*' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "

    "Created: 29.2.1996 / 04:27:49 / cg"
    "Modified: 30.6.1997 / 11:06:36 / cg"
!

fullFontNameOf:aFontId
    "return the full name of a font.
     Here, we return nil, not knowing anything about fonts"

    ^ nil

    "Created: 23.2.1996 / 00:43:19 / cg"
!

getDefaultFontWithEncoding:encoding
    "return a default font id
     - used when class Font cannot find anything usable.
     Subclasses will redefine this."

    "For backward compatibility..."
    ^ self getDefaultFont
!

getFontWithFamily:familyString face:faceString style:styleString pixelSize:sizeArg encoding:encodingSym
    "try to get the specified font, return id.
     If not available, try next smaller font.
     If no font fits, return nil"

    "/ for backward comaptibility - will vanish
    ^ self
	getFontWithFamily:familyString
	face:faceString
	style:styleString
	size:sizeArg
	sizeUnit:#px
	encoding:encodingSym
!

getFontWithFamily:familyString face:faceString style:styleString size:sizeArg encoding:encodingSym
    "try to get the specified font, return id.
     If not available, try next smaller font.
     If no font fits, return nil"

    ^ self
	getFontWithFamily:familyString
	face:faceString
	style:styleString
	size:sizeArg
	sizeUnit:#pt
	encoding:encodingSym
!

getFontWithFamily:familyString face:faceString style:styleString size:sizeArg sizeUnit:sizeUnit encoding:encodingSym
    "try to get the specified font, return id.
     If not available, try next smaller font.
     If no font fits, return nil"

    ^ self subclassResponsibility
!

heightOf:aString from:index1 to:index2 inFont:aFontId
    "return the width in pixels of a substring in a specific font"

    ^ self subclassResponsibility
!

heightOf:aString inFont:aFontId
    "return the width in pixels of a string in a specific font"

    |sz|

    sz := aString size.
    sz == 0 ifTrue:[
	^ 0.
    ].
    ^ self heightOf:aString from:1 to:sz inFont:aFontId
!

listOfAvailableFonts
    "return a list containing all fonts on this display.
     The returned list is an array of FontDescriptions."

    ^ self subclassResponsibility
!

pixelSizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filterBlock
    "return a set of all available pixel sizes in aFamily/aFace/aStyle on this display.
     But only those matching filterBlock (if notNil)."

    |fonts|

    fonts := self
		fontsInFamily:aFamilyName face:aFaceName style:aStyleName
		filtering:[:f |
		    f size notNil
		    and:[filterBlock isNil or:[filterBlock value:f]]
		].
    fonts size == 0 ifTrue:[^ nil].

    ^ fonts collect:[:descr | descr pixelSize "height"] thenSelect:[:pixelSize| pixelSize notNil].

    "
     Display
	pixelSizesInFamily:'fixed' face:'medium' style:'roman'
	filtering:[:f |
	    f encoding notNil and:[f encoding startsWith:'jis']
	]

     Display
	pixelSizesInFamily:'arial' face:'medium' style:'roman'
	filtering:[:f |
	    f encoding == #'ms-ansi'
	]
    "

    "Created: 27.2.1996 / 01:37:56 / cg"
    "Modified: 29.2.1996 / 04:26:52 / cg"
!

releaseFont:aFontId
    "free a font"

    ^ self subclassResponsibility
!

sizesInFamily:aFamilyName face:aFaceName style:aStyleName
    "return a set of all available font sizes in aFamily/aFace/aStyle
     on this display"

    ^ self sizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:nil

    "
     Display sizesInFamily:'times' face:'medium' style:'italic'
    "

    "Modified: 27.2.1996 / 01:38:42 / cg"
!

sizesInFamily:aFamilyName face:aFaceName style:aStyleName filtering:filterBlock
    "return a set of all available font sizes in aFamily/aFace/aStyle
     on this display.
     But only those matching filterBlock (if notNil)."

    |fonts|

    fonts := self
		fontsInFamily:aFamilyName face:aFaceName style:aStyleName
		filtering:[:f |
		    (f size notNil or:[f isScaledFont])
		    and:[filterBlock isNil or:[filterBlock value:f]]
		].
    fonts size == 0 ifTrue:[^ nil].

    ^ fonts collect:[:descr | descr size].

    "
     Display sizesInFamily:'fixed' face:'medium' style:'roman' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "

    "Created: 27.2.1996 / 01:37:56 / cg"
    "Modified: 29.2.1996 / 04:26:52 / cg"
!

stylesInFamily:aFamilyName face:aFaceName
    "return a set of all available font styles in aFamily/aFace on this display"

    ^ self stylesInFamily:aFamilyName face:aFaceName filtering:nil

    "
     Display stylesInFamily:'times' face:'medium'
     Display stylesInFamily:'times' face:'bold'
    "

    "Modified: 27.2.1996 / 01:35:43 / cg"
!

stylesInFamily:aFamilyName face:aFaceName filtering:filterBlock
    "return a set of all available font styles in aFamily/aFace on this display.
     But only thise matching filterBlock (if notNil)."

    |fonts|

    fonts := self
		fontsInFamily:aFamilyName face:aFaceName
		filtering:[:f|
				f style notNil
				and:[filterBlock isNil or:[filterBlock value:f]]
			  ].
    fonts size == 0 ifTrue:[^ nil].

    ^ fonts collect:[:descr | descr style]

    "
     Display stylesInFamily:'fixed' face:'medium' filtering:[:f |
	f encoding notNil and:[f encoding startsWith:'jis']]
    "

    "Created: 27.2.1996 / 01:35:22 / cg"
    "Modified: 29.2.1996 / 04:33:59 / cg"
!

widthOf:aString from:index1 to:index2 inFont:aFontId
    "return the width in pixels of a substring in a specific font"

    ^ self subclassResponsibility
!

widthOf:aString inFont:aFontId
    "return the width in pixels of a string in a specific font"

    ^ self widthOf:aString from:1 to:(aString size) inFont:aFontId
!

overHangOf:aString from:index1 to:index2 inFont:aFontId
    "return the overHang in pixels of a substring in a specific font"

    ^ self subclassResponsibility
!

overHangOf:aString inFont:aFontId
    "return the overHang in pixels of a string in a specific font"

    ^ self overHangOf:aString from:1 to:(aString size) inFont:aFontId
! !

!DeviceWorkstation methodsFor:'grabbing'!

activeKeyboardGrab
    "return the view, which currently has the keyboard grabbed,
     or nil, if there is none"

    ^ activeKeyboardGrab
!

activePointerGrab
    "return the view, which currently has the pointer grabbed,
     or nil, if there is none"

    ^ activePointerGrab
!

grabKeyboardIn:aWindowId
    "grab the keyboard - all keyboard input will be sent to the view
     with id aWindowId"

    ^ self subclassResponsibility
!

grabKeyboardInView:aView
    "grab the keyboard - all keyboard input will be sent to aView.
     Return true if ok, false if it failed for some reason."

    |vid|
    
    activeKeyboardGrab notNil ifTrue:[
        self ungrabKeyboard.
        activeKeyboardGrab := nil
    ].
    vid := aView drawableId.
    "/ the view might be already gone...
    vid notNil ifTrue:[
        (self grabKeyboardIn:vid) ifTrue:[
            activeKeyboardGrab := aView.
            ^ true
        ].
    ].
    ^ false
!

grabPointerIn:aWindowId
    "grap the pointer; all pointer events will be reported to the view
     with id aWindowId. Return true if ok, false if it failed for some reason."

    ^ self grabPointerIn:aWindowId withCursor:nil pointerMode:#async keyboardMode:#sync confineTo:nil
!

grabPointerIn:aWindowId withCursor:cursorId pointerMode:pMode keyboardMode:kMode confineTo:confineId
    "grap the pointer - all pointer events will be reported to aWindowId. The cursor will be set to cursorId
     for the duration of the grab. For pMode/kMode, see X documentation. The pointer is restricted to
     confineId - if non-nil."

    ^ self subclassResponsibility
!

grabPointerIn:aWindowId withCursorId:aCursorIdOrNil
    "grap the pointer; all pointer events will be reported to the view
     with id aWindowId. Return true if ok, false if it failed for some reason."

    ^ self grabPointerIn:aWindowId withCursor:aCursorIdOrNil pointerMode:#async keyboardMode:#sync confineTo:nil
!

grabPointerInView:aView
    "grap the pointer; all pointer events will be reported to
     aView. Return true if ok, false if it failed for some reason."

    ^ self grabPointerInView:aView withCursor:nil
!

grabPointerInView:aView withCursor:aCursorOrNil
    "grap the pointer; all pointer events will be reported to
     aView. Return true if ok, false if it failed for some reason."

    |cId vId ok|

    activePointerGrab notNil ifTrue:[
        self ungrabPointer.
        activePointerGrab := nil
    ].
    vId := aView drawableId.
    "/ the view might be already gone...
    vId notNil ifTrue:[
        aCursorOrNil notNil ifTrue:[
            cId := aCursorOrNil id.
            ok := self grabPointerIn:vId withCursorId:cId.
        ] ifFalse:[
            ok := self grabPointerIn:vId.
        ].

        ok ifTrue:[
            activePointerGrab := aView.
            ^ true
        ].
    ].
    ^ false
!

setActivePointerGrab:aView
    "DO NOT USE. private kludge - will vanish"

    activePointerGrab := aView
!

ungrabKeyboard
    "release the keyboard"

    ^ self subclassResponsibility
!

ungrabPointer
    "release the pointer"

    ^ self subclassResponsibility
! !

!DeviceWorkstation methodsFor:'graphic context stuff'!

noClipIn:aDrawableId gc:aGCId
    "disable clipping rectangle"

    ^ self subclassResponsibility
!

setBackground:bgColorIndex in:aGCId
    "set background color-index to be drawn with"

    ^ self subclassResponsibility
!

setBackgroundColor:color in:aGCId
    "set background color to be drawn with"

    |colorId deviceColor|

    (color isOnDevice:self) ifTrue:[
	colorId := color colorId.
    ] ifFalse:[
	deviceColor := color onDevice:self.
	deviceColor notNil ifTrue:[
	    colorId := deviceColor colorId.
	]
    ].
    colorId isNil ifTrue:[
	 Logger warning:'could not set bg color'.
    ] ifFalse:[
	self setBackground:colorId in:aGCId.
    ]
!

setBitmapMask:aBitmapId in:aGCId
    "set or clear the drawing mask - a bitmap mask using current fg/bg"

    ^ self subclassResponsibility
!

setClipByChildren:aBool in:aDrawableID gc:aGCId
    "enable/disable drawing into child views"

    ^ self subclassResponsibility
!

setClipX:clipX y:clipY width:clipWidth height:clipHeight in:drawableId gc:aGCId
    "clip to a rectangle"

    ^ self subclassResponsibility
!

setDashes:dashList dashOffset:offset in:aGCId
    "set dash attributes.
     Ignored here - it may be left unimplemented by some devices."

    ^ self subclassResponsibility

    "Created: 4.6.1996 / 18:50:38 / cg"
    "Modified: 4.6.1996 / 19:05:22 / cg"
!

setFont:aFontId in:aGCId
    "set font to be drawn in"

    ^ self subclassResponsibility
!

setForeground:fgColorIndex background:bgColorIndex in:aGCId
    "set foreground and background color-indices to be drawn with"

    self setForeground:fgColorIndex in:aGCId.
    self setBackground:bgColorIndex in:aGCId.
!

setForeground:fgColorIndex in:aGCId
    "set the foreground color-index to be drawn with"

    ^ self subclassResponsibility
!

setForegroundColor:fgColor backgroundColor:bgColor in:aGCId
    "set foreground and background colors to be drawn with"

    self setForegroundColor:fgColor in:aGCId.
    self setBackgroundColor:bgColor in:aGCId.
!

setForegroundColor:color in:aGCId
    "set the foreground color to be drawn with"

    |colorId deviceColor|

    (color isOnDevice:self) ifTrue:[
	colorId := color colorId.
    ] ifFalse:[
	deviceColor := color onDevice:self.
	deviceColor notNil ifTrue:[
	    colorId := deviceColor colorId.
	]
    ].
    colorId isNil ifTrue:[
	 Logger warning:'could not set fg color'.
    ] ifFalse:[
	self setForeground:colorId in:aGCId.
    ]
!

setFunction:aFunctionSymbol in:aGCId
    "set alu function to be drawn with"

    ^ self subclassResponsibility
!

setGraphicsExposures:aBoolean in:aGCId
    "set or clear the graphics exposures flag"

    ^ self subclassResponsibility
!

setLineWidth:aNumber style:lineStyle cap:capStyle join:joinStyle in:aGCId
    "set line attributes"

    ^ self subclassResponsibility
!

setMaskOriginX:orgX y:orgY in:aGCid
    "set the mask origin"

    ^ self subclassResponsibility
!

setPixmapMask:aPixmapId in:aGCId
    "set or clear the drawing mask - a pixmap mask providing full color"

    ^ self subclassResponsibility
! !

!DeviceWorkstation methodsFor:'hooks'!

addModalWindowListener:aListener
    aboutToOpenModalWindowHooks isNil ifTrue:[
	aboutToOpenModalWindowHooks := IdentitySet new.
    ].
    aboutToOpenModalWindowHooks add:aListener

    "Created: / 24-10-2010 / 14:57:39 / cg"
!

addNonModalWindowListener:aListener
    aboutToOpenNonModalWindowHooks isNil ifTrue:[
	aboutToOpenNonModalWindowHooks := IdentitySet new.
    ].
    aboutToOpenNonModalWindowHooks add:aListener

    "Created: / 24-10-2010 / 14:58:13 / cg"
!

addSelectionHandler:someone
    "ignored here"
!

modalWindowListenersDo:aBlock
    aboutToOpenModalWindowHooks notNil ifTrue:[
	aboutToOpenModalWindowHooks do:aBlock
    ].

    "
     aboutToOpenModalWindowHooks := nil
    "

    "Created: / 24-10-2010 / 14:58:40 / cg"
!

nonModalWindowListenersDo:aBlock
    aboutToOpenNonModalWindowHooks notNil ifTrue:[
	aboutToOpenNonModalWindowHooks do:aBlock
    ].

    "Created: / 24-10-2010 / 14:58:43 / cg"
!

removeModalWindowListener:aListener
    aboutToOpenModalWindowHooks notNil ifTrue:[
	aboutToOpenModalWindowHooks remove:aListener ifAbsent:[].
	aboutToOpenModalWindowHooks := aboutToOpenModalWindowHooks asNilIfEmpty.
    ]

    "Created: / 24-10-2010 / 14:58:02 / cg"
!

removeNonModalWindowListener:aListener
    aboutToOpenNonModalWindowHooks notNil ifTrue:[
	aboutToOpenNonModalWindowHooks remove:aListener ifAbsent:[].
	aboutToOpenNonModalWindowHooks := aboutToOpenNonModalWindowHooks asNilIfEmpty.
    ]

    "Created: / 24-10-2010 / 14:58:19 / cg"
!

removeSelectionHandler:someone
    "ignored here"
!

withoutExitingOnLastCloseDo:aBlock
    "evaluate a block, but do not exit when the last view is closed.
     This is used when an operation is to be performed, which possibly
     leads to a temporary no-more-windows-open situation.
     Concrete: when reopening a launcher"

    |sav|

    sav := exitOnLastClose.
    exitOnLastClose := false.
    aBlock ensure:[ exitOnLastClose := sav ].
! !

!DeviceWorkstation methodsFor:'initialization & release'!

brokenConnection
    "the connection to the display device was lost."

    dispatching ifTrue:[
	Logger info:'finished dispatch (broken connection): %1' with:self.
	dispatching := false.
    ].
    self emergencyCloseConnection.
    displayId := nil.

    LastActiveScreen == self ifTrue:[
	LastActiveScreen := nil.
	LastActiveProcess := nil.
    ].

    "/ tell all of my top views about this.

    self allTopViews do:[:eachTopView |
	|wg sensor model|

	"notice: we must manually wakeup the windowGroup process here
	 (it might be waiting on an event,
	 and the destroy below is executed by another thread.
	 Otherwise, the windowGroup process would
	 not terminate itself in this case."

	(wg := eachTopView windowGroup) notNil ifTrue:[
	    sensor := wg sensor
	].
	eachTopView destroyed.

	"the #destroyed above should release the application model - but is doesn't
	 yet (2006-10) - so we do it here"
	model := eachTopView model.
	model notNil ifTrue:[
	    model release.
	].
	sensor notNil ifTrue:[
	    sensor eventSemaphore signal.
	].
    ].

    self releaseDeviceResources.

    "Modified: / 19.1.2000 / 10:36:02 / cg"
!

close
    "close down connection to Display - usually never done for the main screen"

    self releaseDeviceResources.
    self closeConnection.
    self == Display ifTrue:[
        Display := nil.
    ].    
    dispatching ifTrue:[
        Logger info:'finished dispatch (close): %1' with:self.
        dispatching := false.
    ].
    dispatchProcess notNil ifTrue:[
        dispatchProcess terminate.
    ].    

    "Modified: 13.1.1997 / 22:13:18 / cg"
!

closeConnection
    "close down connection to Display - usually never done"

    ^ self subclassResponsibility

    "Created: 13.1.1997 / 22:10:07 / cg"
!

emergencyCloseConnection
    "close down connection to the Display in case of emergency;
     this is usually invoked after an error and should not try to flush
     any outstanding graphics requests - usually never done"

    ^ self close

    "Created: 13.1.1997 / 22:10:07 / cg"
!

exitOnLastClose:aBoolean
    "set/clear the flag which controls if the
     event dispatching should stop when the last view is closed."

    self == Display ifTrue:[
	ExitOnLastClose := aBoolean
    ].
    exitOnLastClose := aBoolean.

    "Modified: 23.4.1996 / 22:01:28 / cg"
!

initializeDefaultKeyboardMappingsIn:aKeyboardMap
    aKeyboardMap loadKeyboardMapDefinition: self class defaultKeyboardMapDefinition.

    "Modified: / 12-05-2017 / 21:55:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeDefaultValues
    isSlow := false.
    motionEventCompression := true.
    buttonTranslation isNil ifTrue:[
	buttonTranslation := ButtonTranslation.
    ].
    multiClickTimeDelta isNil ifTrue:[
	multiClickTimeDelta := MultiClickTimeDelta.
    ].
    shiftDown := false.
    ctrlDown := false.
    metaDown := false.
    altDown := false.

    self initializeModifierMappings
!

initializeDeviceResources
    "initialize heavily used device resources - to avoid looking them up later"

    blackColor isNil ifTrue:[
	blackColor := Color black onDevice:self.
	whiteColor := Color white onDevice:self.
	Color getPrimaryColorsOn:self.
    ]

    "Modified: 24.2.1997 / 22:07:50 / cg"
!

initializeDeviceSignals
    deviceErrorSignal := DeviceErrorSignal newSignal.
    deviceErrorSignal nameClass:self message:#deviceErrorSignal.
    deviceIOErrorSignal := DeviceIOErrorSignal newSignal.
    deviceIOErrorSignal nameClass:self message:#deviceIOErrorSignal.
!

initializeFor:aDisplayOrNilForAny
    "initialize the receiver for a connection to a display. If the
     argument is non-nil, it should specify which workstation should be
     connected to (in a device specific manner). For X displays, this is
     to be the display-string i.e. hostname:displayNr.
     If the argument is nil,  connect to the default display."

    ^ self subclassResponsibility
!

initializeKeyboardMap
    "keystrokes from the server are translated via the keyboard map.
     Untranslated keystrokes arrive either as characters, or symbols
     (which are the keySyms as symbol). The mapping table which is
     setup here, is used in sendKeyPress:... later.
     Here, an empty (no-translation) keyboard map is setup initially;
     this is usually filled via the keyboard.rc startup file.
    "

    keyboardMap isNil ifTrue:[
	keyboardMap := KeyboardMap new.
	self initializeDefaultKeyboardMappingsIn:keyboardMap
    ].

    "
     no more setup here - moved everything out into 'display.rc' file
    "
!

initializeModifierMappings
    shiftModifiers := ctrlModifiers := altModifiers := metaModifiers := nil.

    shiftModifiers := #(Shift_L Shift_R Shift).
    ctrlModifiers := #(Control_L Control_R Control).
    metaModifiers := #(Meta_L Meta_R Meta).
    altModifiers := #(Alt_L Alt_R Alt).

    "
     Display initializeModifierMappings
    "
!

initializeScreenProperties
    "setup screen specific properties."

    supportsDeepIcons isNil ifTrue:[
	supportsDeepIcons := true.
    ].

    fixColors := fixGrayColors := ditherColors := nil.
    numFixRed := numFixGreen := numFixBlue := 0.

    widthMM := 320.
    heightMM := 240.

    "Modified: / 23-07-2007 / 21:19:57 / cg"
!

initializeViewStyle
    "late viewStyle init - if no viewStyle has been read yet."

    self class currentScreenQuerySignal answer:self do:[
	SimpleView styleSheet isNil ifTrue:[
	    SimpleView readStyleSheetAndUpdateAllStyleCaches
	] ifFalse:[
	    "maybe some view classes have been loaded and theit styles have to
	     be initialized"
	    SimpleView updateAllStyleCaches.
	].
    ].
!

invalidateConnection
    "clear my connection handle - sent after an imageRestart to
     forget about our previous life"

    displayId := nil

    "Modified: 24.4.1996 / 19:38:46 / cg"
!

nativeWidgets:aBoolean
    "enable/disable native widgets on a display"

    "/ ignored here
!

reinitialize
    "historic leftover (old subclasses call super reinitialize)"
!

reinitializeFor:aDisplayName
    "reinit after snapin"

    |prevKnownViews prevWidth prevHeight|

    "do subclass specific reinitialization"
    self reinitialize.

    blackColor notNil ifTrue:[
        blackColor releaseFromDevice.
    ].
    whiteColor notNil ifTrue:[
        whiteColor releaseFromDevice.
    ].
    self releaseDeviceFonts.
    self releaseDeviceCursors.
    self releaseDeviceColors.

    displayId := nil.
    dispatching := false.
    dispatchProcess := nil.

    prevWidth := width.
    prevHeight := height.

    prevKnownViews := knownViews.
    knownViews := nil.
    lastId := nil.
    lastView := nil.

    self initializeFor:aDisplayName.
    displayId isNil ifTrue:[
        ^ nil
    ].

    "
     first, all Forms must be recreated
     (since they may be needed for view recreation as
      background or icons)
    "
    Form reinitializeAllOn:self.

    prevKnownViews notNil ifTrue:[
        "
         first round: flush all device specific stuff
        "
        prevKnownViews do:[:aView |
            aView notNil ifTrue:[
                aView prepareForReinit
            ]
        ].

        "
         2nd round: all views should reinstall themself
                    on the new display
        "

        prevKnownViews do:[:aView |
            aView notNil ifTrue:[
                "have to re-create the view"
                "abortAll is handled, but not asked for here!!"
                (UserInterrupt, AbortAllOperationRequest) catch:[
                    GraphicsContext drawingOnClosedDrawableSignal handle:[:ex |
                        'DeviceWorkstation [warning]: drawing attempt on closed drawable during reinit' errorPrintCR.
                        ex return
                    ] do:[
                        aView reinitialize
                    ]
                ]
            ]
        ].

        (prevWidth ~~ width
        or:[prevHeight ~~ height]) ifTrue:[
            "
             3rd round: all views get a chance to handle
                        changed environment (colors, font sizes etc)
            "
            prevKnownViews do:[:aView |
            aView notNil ifTrue:[
                    aView reAdjustGeometry
                ]
            ].
        ]
    ].
    dispatching := false.

    "Modified: / 09-02-2011 / 13:59:53 / cg"
!

releaseDeviceResources
    "release any cached device resources.
     This is invoked when closed or when the display connection is broken
     (i.e. be prepared to not be able to release resources regularily)"

    LastActiveScreen == self ifTrue:[
        LastActiveScreen := nil.
        LastActiveProcess := nil.
    ].

    Image releaseResourcesOnDevice:self.

    "This unregisters all the finalization handles"
    self releaseGraphicsContexts.

    blackColor notNil ifTrue:[
        blackColor releaseFromDevice.
        blackColor := nil.
    ].
    whiteColor notNil ifTrue:[
        whiteColor releaseFromDevice.
        whiteColor := nil.
    ].
    self releaseDeviceColors.
    self releaseDeviceCursors.
    self releaseDeviceFonts.

    focusView := activeView := rootView := lastView := nil.
    activeKeyboardGrab := activePointerGrab := nil.
    AllScreens remove:self ifAbsent:nil.

    "Modified: 16.1.1997 / 19:34:11 / cg"
! !

!DeviceWorkstation methodsFor:'interactive queries'!

colorFromUser
    "{ Pragma: +optSpace }"

    "let user specify a point on the screen (by pressing the left button),
     return the color of that pixel."

    |p|

    p := self pointFromUser.
    ^ self rootView colorAt:p

    "
     Display colorFromUser
    "

    "Modified: 1.8.1997 / 20:00:41 / cg"
!

originFromUser:extent
    "{ Pragma: +optSpace }"

    "let user specify a rectangles origin on the screen, return the rectangle.
     Start with initialRectangle.
     Can be used for dragging operations."

    |curs origin root rect prevGrab|

    curs := Cursor origin onDevice:self.

    "
     just in case; wait for button to be down ...
    "
    [self leftButtonPressed] whileFalse:[Delay waitForSeconds:0.05].

    root := self rootView.

    "
     grab and wait for leftButton being pressed
    "
    origin := self pointerPosition.

    root clippedByChildren:false.
    root foreground:blackColor background:whiteColor.

    root xoring:[
        |left right top bottom newOrigin newCorner p|

        rect := origin extent:extent.
        root displayRectangle:rect.

        prevGrab := activePointerGrab.
        self grabPointerInView:root withCursor:curs.

        [self leftButtonPressed] whileTrue:[
            newOrigin := self pointerPosition.

            (newOrigin ~= origin) ifTrue:[
                root displayRectangle:rect.

                self
                    grabPointerIn:root drawableId
                    withCursor:curs id
                    pointerMode:#async
                    keyboardMode:#sync
                    confineTo:nil.

                rect := newOrigin extent:extent.
                root displayRectangle:rect.
                self disposeButtonEventsFor:nil.
                self flush.
                origin := newOrigin.
            ] ifFalse:[
                Delay waitForSeconds:0.05
            ]
        ].
        root displayRectangle:rect.
    ].

    self ungrabPointer.
    prevGrab notNil ifTrue:[
        self grabPointerInView:prevGrab.
    ].

    "flush all events pending on my display"

    root clippedByChildren:true.

    self flush.
    self disposeButtonEventsFor:nil.

    ^ rect

    "
     Display originFromUser:200@200
    "

    "Modified: / 18.8.1998 / 15:00:14 / cg"
!

pointFromUser
    "{ Pragma: +optSpace }"

    "let user specify a point on the screen (by pressing the left button)"

    ^ self pointFromUserShowing:(Cursor crossHair).

    "
     Display pointFromUser
    "

    "Modified: 13.1.1997 / 22:53:05 / cg"
!

pointFromUserShowing:aCursor
    "{ Pragma: +optSpace }"

    "let user specify a point on the screen (by pressing leftButton).
     Show aCursor while waiting."

    ^ self
	pointFromUserShowing:aCursor
	positionFeedback:nil

    "
     Display pointFromUserShowing:(Cursor stop)
     Display pointFromUserShowing:(Cursor crossHair)
     Display pointFromUserShowing:(Cursor origin)
     Display pointFromUser
    "

    "Modified: / 18.8.1998 / 15:00:19 / cg"
!

pointFromUserShowing:aCursor positionFeedback:feedbackBlockOrNil
    "{ Pragma: +optSpace }"

    "let user specify a point on the screen (by pressing leftButton).
     Show aCursor while waiting. Pressing shift or ctrl cancels the operation,
     and aborts"

    |p prevGrab prevKbdGrab|

    prevGrab := activePointerGrab.
    prevKbdGrab := activeKeyboardGrab.

    self ungrabPointer.
    self grabPointerInView:(self rootView) withCursor:(aCursor onDevice:self).

    "
     wait for no leftButton...
    "
    [self leftButtonPressed] whileTrue:[
	Delay waitForSeconds:0.05.
    ].

    [
	self grabKeyboardInView:(self rootView).

	"
	 wait for leftButton...
	 ctrl, shift or escape terminate that operation
	"
	[self leftButtonPressed] whileFalse:[
	    (self ctrlDown or:[self shiftDown or:[activePointerGrab == nil]]) ifTrue:[
		AbortOperationRequest raise.
		^ nil
	    ].
	    feedbackBlockOrNil notNil ifTrue:[
		feedbackBlockOrNil value:(self pointerPosition)
	    ].
	    Delay waitForSeconds:0.05.
	].

	p := self pointerPosition.
    ] ensure:[
	self ungrabKeyboard.
	prevKbdGrab notNil ifTrue:[
	    self grabKeyboardInView:prevKbdGrab
	].
	self ungrabPointer.
	prevGrab notNil ifTrue:[
	    self grabPointerInView:prevGrab
	].
	"flush all events pending on myself"
	self disposeButtonEventsFor:nil.
    ].

    ^ p

    "
     Display pointFromUserShowing:(Cursor stop)
     Display pointFromUserShowing:(Cursor crossHair)
     Display pointFromUserShowing:(Cursor origin)
     Display pointFromUser
    "

    "Modified: / 08-02-2011 / 21:48:08 / cg"
!

rectangleFromUser
    "{ Pragma: +optSpace }"

    "let user specify a rectangle in the screen, return the rectangle.
     If the user presses ESC, an AbortSignal is raised."

    |origin|

    "
     get origin
    "
    origin := self pointFromUserShowing:(Cursor origin onDevice:self).

    "
     get corner
    "
    ^ self rectangleFromUser:(origin corner:origin).

    "
     Display rectangleFromUser
    "

    "Modified: 28.3.1997 / 16:14:44 / cg"
!

rectangleFromUser:initialRectangle
    "{ Pragma: +optSpace }"

    "let user specify a rectangle on the screen, return the rectangle.
     Start with initialRectangle.
     A helper for rectangleFromUser; can also be used for resizing operations."

    ^ self rectangleFromUser:initialRectangle keepExtent:false

    "
     Display rectangleFromUser:(100@100 corner:300@300)
    "

    "Modified: 24.7.1997 / 16:04:54 / cg"
!

rectangleFromUser:initialRectangle keepExtent:keepExtent
    "{ Pragma: +optSpace }"

    "let user specify a rectangle on the screen, return the rectangle.
     Start with initialRectangle.
     A helper for rectangleFromUser; can also be used for resizing operations."

    |curs1 origin corner root rect doRegrab prevGrab|

    "/ regrabbing leads to horrible flicker and
    "/ events being sent to applications under the mouse.
    "/ on windows displays.
    doRegrab := self class ~~ WinWorkstation.

    keepExtent ifTrue:[
	curs1 := Cursor origin
    ] ifFalse:[
	curs1 := Cursor corner
    ].
    curs1 := curs1 onDevice:self.
    root := self rootView.

    "
     grab and wait for leftButton being pressed
    "
    origin := initialRectangle origin.

    root clippedByChildren:false.
    root foreground:blackColor background:whiteColor.

    root xoring:[
	|left right top bottom newOrigin newCorner p curs|

	keepExtent ifFalse:[
	    corner := origin.
	    rect := origin corner:corner.
	    root displayRectangle:rect.
	].

	prevGrab := activePointerGrab.
	self grabPointerInView:root withCursor:curs1.

	"
	 just in case; wait for button to be down ...
	"
	[self leftButtonPressed] whileFalse:[Delay waitForSeconds:0.05].

	keepExtent ifTrue:[
	    p := self pointerPosition.
	    origin := p.
	    corner := origin + initialRectangle extent.
	    rect := origin corner:corner.
	    root displayRectangle:rect.
	].

	[self leftButtonPressed] whileTrue:[
	    left := initialRectangle origin x.
	    top := initialRectangle origin y.
	    right := initialRectangle corner x.
	    bottom := initialRectangle corner y.

	    p := self pointerPosition.
	    keepExtent ifTrue:[
		newOrigin := p.
		newCorner := newOrigin + initialRectangle extent.
		curs := curs1.
	    ] ifFalse:[
		p x < initialRectangle left ifTrue:[
		    p y < initialRectangle top ifTrue:[
			curs := Cursor topLeft.
			left := p x.
			top := p y.
		    ] ifFalse:[
			curs := Cursor bottomLeft.
			left := p x.
			bottom := p y
		    ]
		] ifFalse:[
		    p y < initialRectangle top ifTrue:[
			curs := Cursor topRight.
			right := p x.
			top := p y
		    ] ifFalse:[
			curs := Cursor bottomRight.
			right := p x.
			bottom := p y
		    ]
		].

		newOrigin := left @ top.
		newCorner := right @ bottom.
	    ].

	    ((newOrigin ~= origin) or:[newCorner ~= corner]) ifTrue:[
		root displayRectangle:rect.
		doRegrab ifTrue:[
		    self grabPointerInView:root withCursor:curs1.
		].

		origin :=  newOrigin.
		corner :=  newCorner.
		rect := origin corner:corner.
		root displayRectangle:rect.
		self disposeButtonEventsFor:nil.
		self flush.
	    ] ifFalse:[
		Delay waitForSeconds:0.05
	    ]
	].
	root displayRectangle:rect.
    ].


    self ungrabPointer.
    prevGrab notNil ifTrue:[
	self grabPointerInView:prevGrab
    ].

    "flush all events pending on my display"

    root clippedByChildren:true.

    self flush.
    self disposeButtonEventsFor:nil.

    ^ rect

    "
     Display rectangleFromUser
     Display rectangleFromUser:(100@100 corner:300@300)
     Display rectangleFromUser:(100@100 corner:300@300) keepExtent:true
    "

    "Created: / 24.7.1997 / 15:26:47 / cg"
    "Modified: / 10.9.1998 / 17:38:41 / cg"
!

topviewFromUser
    "{ Pragma: +optSpace }"

    "let user specify a view on the screen; if the selected view is
     not an ST/X view, nil is returned.
     Otherwise, the topview is returned."

    |v|

    v := self viewFromUser.
    v notNil ifTrue:[
	v := v topView
    ].
    ^ v

    "
     Display topviewFromUser
    "

    "Modified: 13.1.1997 / 22:53:15 / cg"
!

viewFromUser
    "{ Pragma: +optSpace }"

    "let user specify a view on the screen; if the selected view is
     not an ST/X view, nil is returned.
     This returns the view being clicked in, which is not always a topView.
     (send topView to the returned view or use topviewFromUser,
      to get the topview)"

    ^ self viewFromPoint:(self pointFromUser)

    "
     Display viewFromUser
    "
    "
     |v|
     v := Display viewFromUser.
     v notNil ifTrue:[v topView] ifFalse:[nil]
    "

    "Modified: 13.1.1997 / 22:53:17 / cg"
!

viewIdFromUser
    "{ Pragma: +optSpace }"

    "let user specify a view on the screen, return its window id.
     This works even for non smalltalk views.
     This returns the id of the view being clicked in,
     which is not always a topView."

    ^ self viewIdFromPoint:(self pointFromUser)

    "
     Display viewIdFromUser
    "

    "Created: 18.9.1995 / 23:07:20 / claus"
    "Modified: 13.1.1997 / 22:53:20 / cg"
! !

!DeviceWorkstation methodsFor:'keyboard mapping'!

altModifiers
    "Return the set of keys which are treated as Alt-keys.
     This set is initialized at startup from what the server thinks
     are alt-keys."

    ^ altModifiers

    "
     Display altModifiers
    "

    "Created: 2.1.1996 / 14:57:13 / cg"
    "Modified: 2.1.1996 / 15:01:54 / cg"
!

altModifiers:arrayOfAltModifierKeys
    "Change the set of keys which are treated as Alt-keys."

    altModifiers := arrayOfAltModifierKeys

    "Created: 2.1.1996 / 14:58:24 / cg"
!

metaModifiers
    "Return the set of keys which are treated as Meta-keys (i.e. Cmd-keys).
     This set is initialized at startup from what the server thinks
     are meta-keys."

    ^ metaModifiers

    "
     Display metaModifiers
    "

    "Created: 2.1.1996 / 14:57:35 / cg"
    "Modified: 2.1.1996 / 15:02:00 / cg"
!

metaModifiers:arrayOfMetaModifierKeys
    "Change the set of keys which are treated as Meta-keys (i.e. Cmd keys)."

    metaModifiers := arrayOfMetaModifierKeys

    "Created: 2.1.1996 / 14:58:41 / cg"
!

modifierKeyProcessing:key down:pressed
    "internal, private method.
     Called with every keyPress/keyRelease to update the xxxDown flags."

    (altModifiers notNil and:[altModifiers includes:key]) ifTrue:[
	altDown := pressed
    ] ifFalse:[
	(metaModifiers notNil and:[metaModifiers includes:key]) ifTrue:[
	    metaDown := pressed
	] ifFalse:[
	    (shiftModifiers notNil and:[shiftModifiers includes:key]) ifTrue:[
		shiftDown := pressed
	    ] ifFalse:[
		(ctrlModifiers notNil and:[ctrlModifiers includes:key]) ifTrue:[
		    ctrlDown := pressed
		]
	    ]
	]
    ]

    "Modified: 2.1.1996 / 15:00:25 / cg"
!

modifierKeyTopFor:key
    "reverse translation for a modifier key
     (i.e. to get the keyTop from a modifier)"

    |t modifiers|

    key == #Alt ifTrue:[
        modifiers := altModifiers
    ] ifFalse:[
        key == #Cmd ifTrue:[
            modifiers := metaModifiers
        ]
    ].

    "/ temporary kludge ...
    (modifiers size > 0) ifTrue:[
        (modifiers includes:'Num_Lock') ifTrue:[
            modifiers := modifiers copyWithout:'Num_Lock'
        ]
    ].

    (modifiers size > 0) ifTrue:[
        t := modifiers first.
        (t includes:$_) ifTrue:[
            t := t copyTo:(t indexOf:$_)-1
        ].
        ^ t
    ].
    ^ key

    "Created: / 28-02-1996 / 17:07:08 / cg"
    "Modified: / 07-02-1998 / 16:18:17 / cg"
    "Modified: / 09-02-2017 / 11:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modifierKeyTranslationFor:untranslatedKey
    "map possible modifiers to a smaller set of common symbols.
     Especially, left/right keys are mapped to a common one."

    "should this come from a configurable variable ?"

    "/ the next statement will vanish ....
    (untranslatedKey == #Control
    or:[untranslatedKey == #'Control_L'
    or:[untranslatedKey == #'Control_R']]) ifTrue:[
	^ #Ctrl
    ].

    (untranslatedKey == #Ctrl
    or:[untranslatedKey == #'Ctrl_L'
    or:[untranslatedKey == #'Ctrl_R']]) ifTrue:[
	^ #Ctrl
    ].
    (untranslatedKey == #'Shift'
    or:[untranslatedKey == #'Shift_L'
    or:[untranslatedKey == #'Shift_R']]) ifTrue:[
	^ #Shift
    ].
    (untranslatedKey == #'Alt'
    or:[untranslatedKey == #'Alt_L'
    or:[untranslatedKey == #'Alt_R']]) ifTrue:[
	^ #Alt
    ].
    (untranslatedKey == #'Meta'
    or:[untranslatedKey == #'Meta_L'
    or:[untranslatedKey == #'Meta_R']]) ifTrue:[
	^ #Meta
    ].
    (untranslatedKey == #'Cmd'
    or:[untranslatedKey == #'Cmd_L'
    or:[untranslatedKey == #'Cmd_R']]) ifTrue:[
	^ #Cmd
    ].
    (untranslatedKey == #'Super'
    or:[untranslatedKey == #'Super_L'
    or:[untranslatedKey == #'Super_R']]) ifTrue:[
	^ #Super
    ].

    "/ I know - this is stupid; however the tradition was Cmd for this...
    (untranslatedKey == #'Menu'
    or:[untranslatedKey == #'Menu_L'
    or:[untranslatedKey == #'Menu_R']]) ifTrue:[
	^ #Cmd
    ].
    ^ nil

    "Created: 28.2.1996 / 16:40:46 / cg"
    "Modified: 28.2.1996 / 17:11:34 / cg"
!

modifierKeys
    "a list of possible modifiers"

    ^ #( #Control #'Control_L' #'Control_R'
	 #Ctrl    #'Ctrl_L'    #'Ctrl_R'
	 #'Shift' #'Shift_L'   #'Shift_R'
	 #'Alt'   #'Alt_L'     #'Alt_R'
	 #'Meta'  #'Meta_L'    #'Meta_R'
	 #'Cmd'   #'Cmd_L'     #'Cmd_R'
	 #'Super' #'Super_L'   #'Super_R'
	 #'Menu'  #'Menu_L'    #'Menu_R'
     )
!

prependModifierToKey:untranslatedKey
    |xlatedKey s modifier k|

    (ctrlDown and:[ metaDown ]) ifTrue:[
	"/ right-ALT: already xlated (I hope)
	^ untranslatedKey
    ].

    xlatedKey := untranslatedKey.
    xlatedKey isCharacter ifFalse:[
	xlatedKey := xlatedKey asSymbol
    ].

    modifier := self modifierKeyTranslationFor:untranslatedKey.
"/ Transcript show: 'untranslatedKey: ' ; showCR: untranslatedKey storeString.
"/ Transcript show:  'modifier: ' ; showCR:  modifier storeString.
"/  'untranslatedKey: ' print. untranslatedKey storeString printCR.
"/  'modifier: ' print. modifier storeString printCR.

    "/
    "/ only prepend, if this is not a modifier (otherwise, we get CmdCmd or CtrlCtrl)
    "/
    modifier isNil ifTrue:[
	s := xlatedKey asString.

	"/ NO, do not prepend the Shift modifier.
	"/ although logical, this makes many keyPress methods incompatible.
	"/ sigh.
"/        xlatedKey isSymbol ifTrue:[
"/            shiftDown ifTrue:[
"/                xlatedKey := 'Shift' , s
"/            ].
"/        ].
	ctrlDown ifTrue:[
	    xlatedKey := 'Ctrl' , s
	].
	metaDown ifTrue:[                     "/ sigh - new hp's have both CMD and META keys.
	    xlatedKey := 'Cmd' , s
	].
	altDown ifTrue:[
	    xlatedKey := 'Alt' , s
	].
	xlatedKey isCharacter ifFalse:[
	    "/ prepend Shift modifier
	    "/   if done unconditionally, this breaks a lot of code.
	    "/   which is not prepared for that and checks shiftDown instead.
	    "/   Therefore, this must be changed at the places where shiftDown is checked for!!
	    "/   In the meanwhile, only do it iff there is a translation.
	    shiftDown ifTrue:[
		(k := ('Shift' , s) asSymbolIfInterned) notNil ifTrue:[
		    (self keyboardMap hasMappingFor:k) ifTrue:[
			xlatedKey := k.
			"/ Transcript show:k ; show:' -> '; showCR:(self keyboardMap valueFor:k).
		    ]
		].
	    ].

	    "/ sigh: twoByteSymbols are not (yet) allowed
	    xlatedKey isWideString ifFalse:[
		xlatedKey := xlatedKey asSymbol
	    ].
	].
    ].

    ^ xlatedKey

    "Modified (format): / 12-07-2012 / 18:37:22 / cg"
!

translateKey:untranslatedKey forView:aView
    "Return the key translated via the translation table.
     Your application program should never depend on the values returned
     by this method, but instead use symbolic keys (such as #FindNext).
     Doing so allows easier reconfiguration by changing the translation map
     in the 'smalltalk.rc' or 'display.rc' startup files.

     First, the modifier is prepended, making character X into
     AltX, CtrlX or CmdX (on many systems, no separate Cmd (or Meta)
     key exists; on those we always get AltX if the metaModifiers are not set correctly).
     If multiple modifiers are active, the symbol becoms the concatenation
     as in AltCtrlq (for control-alt-q). Shift will affect the last component,
     thus the above with shift becoms: AltCtrlQ instead.
     Some keyboards offer both Alt and Meta keys - on those, the first has a
     prefix of Alt, the second has Cmd as prefix. Keyboards with only an Alt
     key will will create prefix codes of Cmd for that.
     For symbolic keys (i.e.Tab, Backspace etc, shift is ignored).
     Then the result is used as a key into the translation keyboardMap
     to get the final return value."

    |xlatedKey|

    xlatedKey := self prependModifierToKey:untranslatedKey.

    "/ translate via keyboardMap

    xlatedKey := aView keyboardMap mappingFor:xlatedKey.
    xlatedKey notNil ifTrue:[
        xlatedKey isCharacter ifFalse:[
            xlatedKey isWideString ifFalse:[
                xlatedKey := xlatedKey asSymbol
            ]
        ]
    ].
    ^ xlatedKey

    "Modified: / 12-07-2012 / 18:37:47 / cg"
    "Modified: / 15-05-2017 / 21:36:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DeviceWorkstation methodsFor:'keyboard queries'!

altDown
    "return true, if the alt-key is currently pressed."

    ^ altDown
!

altModifierMask
    "return the mask bit for the alt modifier key"

    self subclassResponsibility

!

ctrlDown
    "return true, if the control-key is currently pressed."

    ^ ctrlDown
!

ctrlModifierMask
    "return the mask bit for the ctrl modifier key"

    self subclassResponsibility

!

leftShiftDown
    "return true, if the left shift-key is currently pressed.
     Here, we don't differentiate between left and right shift keys."

    ^ shiftDown

    "Created: 9.11.1996 / 19:06:48 / cg"
!

metaDown
    "return true, if the meta-key (alt-key on systems without meta)
     is currently pressed."

    ^ metaDown
!

metaModifierMask
    "return the mask bit for the meta modifier key"

    self subclassResponsibility

!

rightShiftDown
    "return true, if the right shift-key is currently pressed.
     Here, we don't differentiate between left and right shift keys."

    ^ shiftDown

    "Created: 9.11.1996 / 19:06:56 / cg"
!

shiftDown
    "return true, if the shift-key is currently pressed."

    ^ shiftDown
!

shiftModifierMask
    "return the mask bit for the shift modifier key"

    self subclassResponsibility

! !

!DeviceWorkstation methodsFor:'misc'!

beep
    "output an audible beep or bell"

    "{ Pragma: +optSpace }"

    UserPreferences current beepEnabled ifTrue:[
	Stdout nextPut:(Character bell)
    ]

    "Modified: / 13.1.1997 / 22:56:13 / cg"
    "Modified: / 3.12.1999 / 17:13:52 / ps"
!

buffered
    "buffer drawing - do not send it immediately to the display.
     This is the default; see comment in #unBuffered."

    ^ self
!

buttonLongPressedHandlerProcess
    ^ buttonLongPressedHandlerProcess
!

buttonLongPressedHandlerProcess:aProcess
    buttonLongPressedHandlerProcess := aProcess.
!

buttonPressTimeForMenu
    ^ buttonPressTimeForMenu
!

buttonPressTimeForMenu:seconds
    buttonPressTimeForMenu := seconds
!

compressMotionEvents:aBoolean
    "turn on/off motion event compression
     - compressions makes always sense except in free-hand drawing of curves"

    motionEventCompression := aBoolean
!

flush
    "send all buffered drawing to the display.
     This used to be called #synchronizeOutput, but has been renamed
     for ST-80 compatibility."

    ^ self
!

focusView
    "the view, which has got the focus from the operating system"

    ^ focusView
!

focusView:aView
    "the view, which has got the focus from the operating system"

    focusView := aView
!

redrawAllWindows
    self allViewsDo:[:eachView |
	(eachView shown and:[eachView isRootView not]) ifTrue:[
	    eachView clearView; invalidate
	].
    ].

    "
     Display redrawAllWindows
    "

    "Modified: 15.10.1997 / 19:06:26 / cg"
!

repadBits:givenBits width:imageWidth height:imageHeight depth:imageDepth from:givenPadding to:wantedPadding
    "repadding support - required for some devices when drawing images"

    |newBits bytesPerLineGiven bytesPerLineWanted
     dstIndex "{ Class: SmallInteger }"
     srcIndex "{ Class: SmallInteger }"|

    bytesPerLineGiven := ((width * imageDepth) + givenPadding - 1) // 8.
    bytesPerLineWanted := ((width * imageDepth) + wantedPadding - 1) // 8.

    bytesPerLineGiven == bytesPerLineWanted ifTrue:[^ givenBits].

    newBits := ByteArray new:(bytesPerLineWanted * height).
    srcIndex := dstIndex := 1.
    1 to:height do:[:row |
	newBits
	    replaceFrom:dstIndex
	    to:(dstIndex + bytesPerLineWanted - 1)
	    with:givenBits
	    startingAt:srcIndex.
	dstIndex := dstIndex + bytesPerLineWanted.
	srcIndex := srcIndex + bytesPerLineGiven.
    ].
    ^ newBits.

!

restoreWindows
    "restore the display.
     Here, a view is popped over all of the screen temporarily"

    |v|

    self flush.
    v := PopUpView onDevice:self.
    v origin:0@0 corner:(self bounds corner).
    v raise.
    v realize.
    self flush.

    Delay waitForSeconds:0.2.
    v destroy.
    self flush.
    Delay waitForSeconds:0.2.
    self flush.

    self redrawAllWindows.

    "
     Display restoreWindows
     Display redrawAllWindows
    "

    "Modified: 15.10.1997 / 19:06:26 / cg"
!

rightButtonIsLowerWindow:aBooleanOrNil
    "ignored here. Used with windows displays, to control the
     bahavior of the right mouse button, when clicking into the
     title area (to lower a view).
     With a non-nil argument, the flag is set.
     with a nil value, its current value is returned"
     
    ^ false
!

ringBell
    "{ Pragma: +optSpace }"

    "alias for beep; for ST-80 compatibility"

    self beep

    "Modified: 13.1.1997 / 22:56:02 / cg"
!

setInputFocusTo:aWindowId
    ^ self subclassResponsibility
!

shiftedLeftButtonIsLowerWindow:aBooleanOrNil
    "ignored here. Used with windows displays, to control the
     bahavior of the shifted right mouse button, when clicking into the
     title area (to lower a view).
     With a non-nil argument, the flag is set.
     with a nil value, its current value is returned"
     
    ^ false
!

sync
    "{ Pragma: +optSpace }"

    "send all buffered drawing to the display and wait until its processed/drawn.
     See also #flush, which does not wait.
     ST-80 seems to only support flush."

    self flush

    "Modified: 13.1.1997 / 22:55:44 / cg"
!

synchronizeOutput
    "{ Pragma: +optSpace }"

    <resource:#obsolete>

    "send all buffered drawing to the display.
     OBSOLETE: please use #flush for ST-80 compatibility."

    self obsoleteMethodWarning:'use #flush'.
    ^ self flush

    "Modified: 13.1.1997 / 22:53:44 / cg"
!

unBuffered
    "make all drawing be sent immediately to the display.
     This may horribly slow down your drawings, but will result
     in any errors to be delivered right after the bad operation
     (in X only). Only useful for debugging."

    ^ self
! !

!DeviceWorkstation methodsFor:'native window stuff'!

changeButtonState:state in:drawableId
    self subclassResponsibility
!

changeLabel:state in:drawableId
    self subclassResponsibility
!

enableScrollBar:enableBoolean in:drawableId
    self subclassResponsibility
! !

!DeviceWorkstation methodsFor:'pointer stuff'!

anyButtonMotionMask
    "return an integer for masking out any button from a motion
     buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility

    "Created: 15.10.1997 / 19:17:00 / cg"
!

anyButtonPressed
    "return true, if the any button is currently pressed"

    ^ (self buttonStates bitAnd:self anyButtonStateMask) ~~ 0

    "Created: 15.10.1997 / 19:16:32 / cg"
!

anyButtonStateMask
    "return an integer for masking out any button from a
     buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility

    "Created: 15.10.1997 / 19:17:00 / cg"
!

button1MotionMask
    "return an integer for masking out the left button from a
     motion buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

button2MotionMask
    "return an integer for masking out the middle button from a
     motion buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

button3MotionMask
    "return an integer for masking out the right button from a
     motion buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

buttonStates
    "return an integer representing the state of the pointer buttons;
     a one-bit represents a pressed button. The bit positions are device specific
     and to be returned by the *ButtonStateMask methods.
     Must be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

leftButtonPressed
    "return true, if the left button is currently pressed"

    ^ (self buttonStates bitAnd:self leftButtonStateMask) ~~ 0
!

leftButtonStateMask
    "return an integer for masking out the left button from a
     buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

middleButtonPressed
    "return true, if the middle button is currently pressed"

    ^ (self buttonStates bitAnd:self middleButtonStateMask) ~~ 0
!

middleButtonStateMask
    "return an integer for masking out the middle button from a
     buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

pointerPosition
    "return the current pointer position in root-window coordinates.
     Must be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

rightButtonPressed
    "return true, if the right button is currently pressed"

    ^ (self buttonStates bitAnd:self rightButtonStateMask) ~~ 0
!

rightButtonStateMask
    "return an integer for masking out the right button from a
     buttonStates value. This is very device specific and to
     be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

rootPositionOfLastEvent
    "return the position in root-window coordinates
     of the last button, key or pointer event.
     Must be redefined by concrete subclasses."

    ^ self subclassResponsibility
!

setPointerPosition:newPosition
    "change the pointer position in root-window coordinates."

    self setPointerPosition:newPosition in:(self rootView drawableId)

    "
     Display setPointerPosition:10@30
    "
!

setPointerPosition:newPosition in:aWindowID
    "change the pointer position relative to some views origin.
     Must be redefined by concrete subclasses."

    ^ self subclassResponsibility

    "
     Display setPointerPosition:10@30
    "
! !

!DeviceWorkstation methodsFor:'printing & storing'!

printOn:aStream
    "for your convenience, add the name of the display connection
     or 'default' to the printed representation."

    |name|

    super printOn:aStream.

    aStream nextPut:$(.
    (name := self displayName) isNil ifTrue:[
	name := 'defaultDisplay'
    ].
    aStream nextPutAll:name.
    self isOpen ifFalse:[
	aStream nextPutAll:' - closed'.
    ].
    aStream nextPut:$).
! !

!DeviceWorkstation methodsFor:'queries'!

isWindowsPlatform
    ^ self class isWindowsPlatform
!

isX11Platform
    ^ self class isX11Platform
! !

!DeviceWorkstation methodsFor:'retrieving pixels'!

getBitsFromId:aDrawableId x:srcx y:srcy width:w height:h into:imageBits
    "get bits from a view drawable into the imageBits. The storage for the bits
     must be big enough for the data to fit. If ok, returns an array with some
     info and the bits in imageBits. The info contains the depth, bitOrder and
     number of bytes per scanline. The number of bytes per scanline is not known
     in advance, since the X-server is free to return whatever it thinks is a good padding."

    self subclassResponsibility

    "Created: 19.3.1997 / 13:41:21 / cg"
!

getBitsFromPixmapId:aDrawableId x:srcx y:srcy width:w height:h into:imageBits
    "get bits from a drawable into the imageBits. The storage for the bits
     must be big enough for the data to fit. If ok, returns an array with some
     info and the bits in imageBits. The info contains the depth, bitOrder and
     number of bytes per scanline. The number of bytes per scanline is not known
     in advance, since the X-server is free to return whatever it thinks is a good padding."

    ^ self
	getBitsFromId:aDrawableId
	x:srcx
	y:srcy
	width:w
	height:h
	into:imageBits

    "Created: 19.3.1997 / 13:43:04 / cg"
    "Modified: 19.3.1997 / 13:43:38 / cg"
!

getBitsFromViewId:aDrawableId x:srcx y:srcy width:w height:h into:imageBits
    "get bits from a drawable into the imageBits. The storage for the bits
     must be big enough for the data to fit. If ok, returns an array with some
     info and the bits in imageBits. The info contains the depth, bitOrder and
     number of bytes per scanline. The number of bytes per scanline is not known
     in advance, since the X-server is free to return whatever it thinks is a good padding."

    ^ self
	getBitsFromId:aDrawableId
	x:srcx
	y:srcy
	width:w
	height:h
	into:imageBits

    "Created: 19.3.1997 / 13:43:04 / cg"
    "Modified: 19.3.1997 / 13:43:42 / cg"
!

getPixelX:x y:y from:aDrawableId with:gcId
    "return the pixel value at x/y"

    ^ self subclassResponsibility

    "Created: / 22.5.1999 / 01:40:42 / cg"
! !

!DeviceWorkstation methodsFor:'style defaults'!

defaultStyleValueFor:aKey
    "return a default style value, given a key.
     These defaults are used if nothing is specified
     in the style sheet
     This allows for empty values in style sheets, and defaults
     being provided by the display (which makes sense with Windows,
     where the systemDefaults are used ..."

    <resource: #style (#viewSpacing
		       #borderColor #borderWidth
		       #viewBackgroundColor #shadowColor #lightColor
		      )>

    aKey == #viewSpacing ifTrue:[
	^ self verticalPixelPerMillimeter rounded       "/ 1 millimeter
    ].

    aKey == #borderColor ifTrue:[
	^ self blackColor
    ].
    aKey == #borderWidth ifTrue:[
	^ 1
    ].

    aKey == #shadowColor ifTrue:[
	^ self blackColor
    ].
    aKey == #lightColor ifTrue:[
	^ self whiteColor
    ].
    aKey == #viewBackgroundColor ifTrue:[
	^ self whiteColor
    ].
    aKey == #scrollerViewBackgroundColor ifTrue:[
	^ self whiteColor
    ].

    aKey == #textForegroundColor ifTrue:[
	^ self blackColor.
    ].
    aKey == #textBackgroundColor ifTrue:[
	^ self whiteColor.
    ].
    aKey == #selectionForegroundColor ifTrue:[
	^ self whiteColor.
    ].
    aKey == #selectionBackgroundColor ifTrue:[
	^ self blackColor.
    ].

    ^ nil.

    "Modified: 29.4.1997 / 11:16:57 / dq"
    "Modified: 29.4.1997 / 17:17:15 / cg"
! !

!DeviceWorkstation methodsFor:'tray access'!

addTrayIconFor:aView icon:wicon iconMask:wiconMask toolTipMessage:toolTipMessage
    "add an icon to the tray for aView (which will receive tray-events in the future.
     intentionally ignored here - only supported by win32 (for now)"

    ^ self

    "Created: / 31-10-2007 / 01:56:33 / cg"
    "Modified: / 05-11-2007 / 12:19:04 / cg"
!

removeTrayIconFor:aView
    "remove the tray icon.
     intentionally ignored here - only supported by win32 (for now)"

    ^ self

    "Created: / 05-11-2007 / 12:17:38 / cg"
!

setTrayIconFor:aView icon:wicon iconMask:wiconMaskArg
    "change the tray icon.
     intentionally ignored here - only supported by win32 (for now)"

    ^ self

    "Created: / 05-11-2007 / 12:14:09 / cg"
!

setTrayIconsToolTipMessageFor:aView to:toolTipMessageArg
    "Change the toolTopText.
     intentionally ignored here - only supported by win32 (for now)"

    ^ self

    "Created: / 05-11-2007 / 12:14:21 / cg"
! !

!DeviceWorkstation methodsFor:'view registration'!

addKnownView:aView withId:aWindowID
    "add the View aView with id:aWindowID to the list of known views/id's.
     This map is needed later (on event arrival) to get the view from
     the view's id (which is passed along with the devices event) quickly."

    knownViews isNil ifTrue:[
        knownViews := WeakValueDictionary new:500.
    ].
    knownViews at:aWindowID put:aView.

"/    dispatching ifFalse:[
"/        self startDispatch
"/    ].

    "Modified: 2.4.1997 / 19:15:46 / cg"
!

initializeTopViewHookFor:aView
    "callBack from topViews initialize method.
     empty here, but may be useful ..."
!

realizedTopViewHookFor:aView
    "callBack from topViews realize method.
     empty here, but may be useful ..."
!

removeKnownView:aView withId:aViewId
    "remove aView from the list of known views/id's.
     One of aView of aViewId may be nil. The nil one is computed from the other variable."

    |removedView|

    lastId := nil.
    lastView := nil.

    knownViews notNil ifTrue:[
        aViewId notNil ifTrue:[
            removedView := knownViews removeKey:aViewId ifAbsent:[].
            focusView == removedView ifTrue:[
                focusView := nil
            ].
        ] ifFalse:[
            focusView == aView ifTrue:[
                focusView := nil
            ].
            knownViews removeIdentityValue:aView ifAbsent:[].
        ].
        self checkForEndOfDispatch.
    ].

    "Created: 22.3.1997 / 14:56:20 / cg"
    "Modified: 27.3.1997 / 17:13:28 / cg"
!

viewFromId:aWindowID
    "given an Id, return the corresponding view.
     Return nil for unknown windows
     (can happen for external window, if a key grab is active)"

    |view|

    knownViews isNil ifTrue:[
        ^ nil.
    ].

    lastId = aWindowID ifTrue:[
        ^ lastView.
    ].

    view := knownViews at:aWindowID ifAbsent:[].
    view notNil ifTrue:[
        lastView := view.
        lastId := aWindowID.
    ].
    ^ view.

    "Modified: 22.3.1997 / 17:19:59 / cg"
!

viewIdKnown:aWindowID
    "return true, if I still consider a windowId as being valid"

    ^ knownViews includesKey:aWindowID.

    "Created: 4.4.1997 / 11:01:07 / cg"
    "Modified: 4.4.1997 / 19:07:55 / cg"
! !

!DeviceWorkstation methodsFor:'window stuff'!

activateWindow:aWindowId
    "make a window active.
     Fall back to raiseWindow here"

    self raiseWindowToTop:aWindowId.
!

clearRectangleX:x y:y width:width height:height in:aWindowId
    "clear a rectangular area of a window to its view background"

    "/ mhmh - should not be needed
    ^ self subclassResponsibility
!

clearWindow:aWindowId
    "clear a windows to its view background"

    "/ mhmh - should not be needed
    ^ self subclassResponsibility
!

lowerWindow:aWindowId
    "lower a window"

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:40:04 / cg"
!

mapView:aView id:aWindowId iconified:aBoolean atX:xPos y:yPos width:w height:h
    "map a window - either as icon or as a real view - needed for restart"

    "/ OBSOLETE interface - this looses the minExtent/maxExtent properties
    "/ use mapView:...minWidth:minHeight:maxWidth:maxHeight:

    ^ self
	mapView:aView id:aWindowId iconified:aBoolean atX:xPos y:yPos
	width:w height:h minExtent:nil maxExtent:nil
!

mapView:aView id:aWindowId iconified:aBoolean atX:xPos y:yPos
	width:w height:h minExtent:minExt maxExtent:maxExt
    "make a window visible - either as icon or as a real view - needed for restart"

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:43:17 / cg"
!

mapWindow:aWindowId
    "map a window"

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:43:06 / cg"
!

mapWindow:aWindowId animation:animationSymbolorNil time:timeInMillisOrNil
    "unmap a window"

    ^ self mapWindow:aWindowId
!

moveResizeWindow:aWindowId x:x y:y width:w height:h
    "move & resize a window"

    "/ fallBack: move & resize as two individual operations

    self moveWindow:aWindowId x:x y:y.
    self resizeWindow:aWindowId width:w height:h.
!

moveWindow:aWindowId x:x y:y
    "move a window"

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:40:36 / cg"
!

raiseWindow:aWindowId
    "raise a window.
     In some systems (aka MSWindows), this raises only above all other st/x views,
     but not above other-application's views, which have a TOPMOST attribute.
     Se raiseWindowToTop for this."

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:40:42 / cg"
!

raiseWindowToTop:aWindowId
    "raise a window above all others (even above non-st/x windows)"

    self raiseWindow:aWindowId
!

reparentWindow:windowId to:newParentWindowId
    "change a windows parent (an optional interface).
     Returns true if successfull."

    ^ false
!

resizeWindow:aWindowId width:w height:h
    "resize a window"

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:40:47 / cg"
!

restoreCursors
    "restore the cursors of all views to their current cursor.
     This undoes the effect of #setCursors:"

    self allViewsDo:[:aView |
        |c vid cid|

        (vid := aView drawableId) notNil ifTrue:[
            c := aView cursor.
            (c notNil and:[(cid := c id) notNil]) ifTrue:[
                self setCursor:cid in:vid
            ]
        ]
    ].
    self flush.

    "
     Display setCursors:(Cursor wait).
     Delay waitForSeconds:5.
     Display restoreCursors
    "

    "Modified: 20.3.1997 / 16:28:25 / cg"
!

setBackingStore:how in:aWindowId
    "turn on/off backing-store for a window.
     A view with backingStore will redraw automatically
     from the backing pixmap (without sending expose events).
     An implementation may ignore this request."

    "/ default here is to ignore the request
!

setBitGravity:how in:aWindowId
    "set bit gravity for a window"

    "/ default here is to ignore the request
!

setCursor:aCursorId in:aWindowId
    "set a window's cursor"

    "/ mhmh - could be ignored
    ^ self subclassResponsibility
!

setCursors:aCursor
    "change the cursor of all views on the receiver device
     to aCursorId, without affecting the view's idea of what
     the cursor is (so that it can be restored from the view's
     cursor instance variable later).
     Use of this is not recommended - it's better to change
     the cursor of a windowGroup alone."

    |id|

    aCursor isNil ifTrue:[^ self].

    id := (aCursor onDevice:self) id.
    id notNil ifTrue:[
	self allViewsDo:[:aView |
	    |vid|

	    (vid := aView id) notNil ifTrue:[
		self setCursor:id in:vid
	    ]
	].
	self flush
    ]

    "
     Display setCursors:(Cursor wait).
     Delay waitForSeconds:5.
     Display restoreCursors.
    "

    "Modified: 28.3.1997 / 16:14:59 / cg"
!

setForegroundWindow:aWindowId
    "make a window active.
     Fall back to raiseWindow here"

    self raiseWindowToTop:aWindowId.
!

setIconName:aString in:aWindowId
    "set a windows icon name"

    "/ default here is to ignore the request
!

setSaveUnder:yesOrNo in:aWindowId
    "turn on/off save-under for a window.
     A view with saveUnder will save the pixels of the
     area covered by itself and repair from those when
     unmapped (therefore, no expose events are generated later).
     It is especially useful for popUp menus.
     An implementation may ignore this request."

    "/ default here is to ignore the request
!

setTransient:aWindowId for:aMainWindowId
    "set aWindowId to be a transient of aMainWindow.
     This informs the windowManager that those are to
     be handled as a group w.r.t. iconification and deiconification.
     An implementation may ignore this
     (being somewhat inconvenient to the user, though)"

    "/ default here is to ignore the request

    "Created: 20.8.1997 / 20:38:32 / cg"
!

setWindowBackground:aColorIndex in:aWindowId
    "set a windows background color"

    ^ self subclassResponsibility
!

setWindowBackgroundPixmap:aPixmapId in:aWindowId
    "set a windows background pattern to be a form.
     No need to be implemented in concrete workstation;
     if not implemented, its done by (slower) smalltalk code
     (must return false from #supportsViewBackgroundPixmap query)"

    ^ self

    "Modified: / 4.5.1999 / 19:06:13 / cg"
!

setWindowBorderColor:aColorIndex in:aWindowId
    "set a windows border color"

    "/ default here is to ignore the request

    ^ self
!

setWindowBorderPixmap:aPixmapId in:aWindowId
    "set a windows border pattern"

    "/ default here is to ignore the request

    ^ self
!

setWindowBorderShape:aPixmapId in:aWindowId
    "set a windows border shape"

    "/ default here is to ignore the request

    ^ self
!

setWindowBorderWidth:aNumber in:aWindowId
    "set a windows border width"

    ^ self subclassResponsibility
!

setWindowClass:wClass name:wName in:aWindowId
    "define class and name of a window.
     This may be used by the window manager to
     select client specific resources."

    "/ default here is to ignore the request

    "Created: 14.6.1996 / 17:23:34 / stefan"
!

setWindowGravity:how in:aWindowId
    "set window gravity for a window"

    "/ default here is to ignore the request
!

setWindowIcon:aForm in:aWindowId
    "define a bitmap to be used as icon"

    self
	setWindowIcon:aForm
	mask:nil
	in:aWindowId
!

setWindowIcon:aForm mask:aMaskForm in:aWindowId
    "set a windows icon & iconMask"

    "/ default here is to ignore the request
!

setWindowIconWindow:aView in:aWindowId
    "set a windows icon window"

    "/ default here is to ignore the request
!

setWindowMinExtent:minExt maxExtent:maxExt in:aWindowId
    "set a windows minimum & max extents.
     nil arguments are ignored."

    |minW minH maxW maxH|

    minExt notNil ifTrue:[
	minW := minExt x.
	minH := minExt y.
    ].
    maxExt notNil ifTrue:[
	maxW := maxExt x.
	maxH := maxExt y.
    ].
    self setWindowMinExtentX:minW y:minH maxExtentX:maxW y:maxH in:aWindowId
!

setWindowMinExtentX:minW y:minH maxExtentX:maxW y:maxH in:aWindowId
    "set a windows minimum & max extents.
     nil arguments are ignored."

    ^ self subclassResponsibility
!

setWindowName:aString in:aWindowId
    "define a windows name (i.e. windowTitle)"

    ^ self subclassResponsibility
!

setWindowPid:anIntegerOrNil in:aWindowId
    "Sets the _NET_WM_PID property for the window.
     This may be used by the window manager to group windows.
     If anIntegerOrNil is nil, then PID of currently running
     Smalltalk is used"

    "/ default here is to ignore the request

    "Created: / 04-01-2013 / 16:02:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setWindowShape:aPixmapId in:aWindowId
    "set a windows visible shape"

    "/ default here is to ignore the request
!

unmapWindow:aWindowId
    "unmap a window"

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:42:39 / cg"
!

unmapWindow:aWindowId animation:animationSymbolorNil time:timeInMillisOrNil
    "unmap a window"

    ^ self unmapWindow:aWindowId
!

windowIsIconified:aWindowId
    "return true, if a window is iconified"

    ^ self subclassResponsibility

    "Modified: 24.4.1996 / 19:42:39 / cg"
    "Created: 4.4.1997 / 14:45:26 / cg"
! !

!DeviceWorkstation::DeviceFontMetrics methodsFor:'accessing'!

ascent
    "return the ascent"

    ^ ascent
!

ascent:ascentArg descent:descentArg
    ascent := ascentArg.
    descent := descentArg.
!

ascent:ascentArg descent:descentArg maxAscent:maxAscentArg maxDescent:maxDescentArg minWidth:minWidthArg maxWidth:maxWidthArg avgWidth:avgWidthArg
    "set corresponding instance variables"

    ascent := ascentArg.
    descent := descentArg.
    maxAscent := maxAscentArg.
    maxDescent := maxDescentArg.
    minWidth := minWidthArg.
    maxWidth := maxWidthArg.
    averageWidth := avgWidthArg
!

ascent:ascentArg descent:descentArg maxAscent:maxAscentArg maxDescent:maxDescentArg
minWidth:minWidthArg maxWidth:maxWidthArg avgWidth:avgWidthArg minCode:minCodeArg maxCode:maxCodeArg
    "set corresponding instance variables"

    ascent := ascentArg.
    descent := descentArg.
    maxAscent := maxAscentArg.
    maxDescent := maxDescentArg.
    minWidth := minWidthArg.
    maxWidth := maxWidthArg.
    averageWidth := avgWidthArg.
    minCode := minCodeArg.
    maxCode := maxCodeArg.
!

ascent:ascentArg descent:descentArg maxAscent:maxAscentArg maxDescent:maxDescentArg
minWidth:minWidthArg maxWidth:maxWidthArg avgWidth:avgWidthArg minCode:minCodeArg maxCode:maxCodeArg
direction:directionArg
    "set corresponding instance variables"

    ascent := ascentArg.
    descent := descentArg.
    maxAscent := maxAscentArg.
    maxDescent := maxDescentArg.
    minWidth := minWidthArg.
    maxWidth := maxWidthArg.
    averageWidth := avgWidthArg.
    minCode := minCodeArg.
    maxCode := maxCodeArg.
    direction := directionArg.
!

ascent:ascentArg descent:descentArg maxAscent:maxAscentArg maxDescent:maxDescentArg
minWidth:minWidthArg maxWidth:maxWidthArg avgWidth:avgWidthArg minCode:minCodeArg maxCode:maxCodeArg
direction:directionArg encoding:encodingArg
    "set corresponding instance variables"

    ascent := ascentArg.
    descent := descentArg.
    maxAscent := maxAscentArg.
    maxDescent := maxDescentArg.
    minWidth := minWidthArg.
    maxWidth := maxWidthArg.
    averageWidth := avgWidthArg.
    minCode := minCodeArg.
    maxCode := maxCodeArg.
    direction := directionArg.
    encoding := encodingArg.
!

ascent:ascentArg descent:descentArg maxAscent:maxAscentArg maxDescent:maxDescentArg
minWidth:minWidthArg maxWidth:maxWidthArg avgWidth:avgWidthArg minCode:minCodeArg maxCode:maxCodeArg
direction:directionArg encoding:encodingArg overHang:overHangArg
    "set corresponding instance variables"

    ascent := ascentArg.
    descent := descentArg.
    maxAscent := maxAscentArg.
    maxDescent := maxDescentArg.
    minWidth := minWidthArg.
    maxWidth := maxWidthArg.
    averageWidth := avgWidthArg.
    minCode := minCodeArg.
    maxCode := maxCodeArg.
    direction := directionArg.
    encoding := encodingArg.
    overHang := overHangArg.
!

descent
    "return the descent"

    ^ descent
!

maxAscent
    "return the maxAscent"

    ^ maxAscent
!

maxDescent
    "return the maxDescent"

    ^ maxDescent
!

minWidth
    "return the minWidth"

    ^ minWidth
!

maxWidth
    "return the maxWidth"

    ^ maxWidth
!

averageWidth
    "return the averageWidth"

    ^ averageWidth
!

minCode
    ^ minCode ? 0
!

maxCode
    ^ maxCode ? 16rFFFF
!

direction
    "return the drawing direction (think of hebrew and arabic !!)"

    ^ direction ? #LeftToRight
!

encoding
    "return the encoding"

    ^ encoding
!

overHang
    "return font the overHang"

    ^ overHang
! !

!DeviceWorkstation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


DeviceWorkstation initialize!
