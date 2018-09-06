"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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

TopView subclass:#StandardSystemView
	instanceVariableNames:'label icon iconView iconLabel minExtent maxExtent sizeFixed
		application windowEventsForApplication deviceIcon labelChannel'
	classVariableNames:'DefaultExtent DefaultIcon DefaultMinExtent IncludeHostNameInLabel
		TimedRaiseAction WindowLabelFormat'
	poolDictionaries:''
	category:'Views-Basic'
!

!StandardSystemView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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
    I represent standard application topViews
    i.e. those views which have a title-label, an icon etc.

    The name `StandardSystemView' is probably misleading and
    results from ST-80 (rel2.x) compatibility reasons.
    Think of it as an ApplicationWindow.


    In ST/X, StandardSystemViews were subclassed for special views
    in the past (for example: FileBrowser, ChangesBrowser etc.).
    Although this worked, it may lead to the following
    problems and inconveniences:
        - applications inherit a big number of methods through the
          SimpleView->View->TopView->StandardSystemView hierarchy.
          There is quite a danger that by accident, some method gets
          redefined which is required by one of those classes.
          (typical candidates are: terminate, destroy, open ...)
          This may lead to strange effects, which may not be obvious to
          non experts ...

        - applications with multiple topViews are difficult to implement
          and manage.

        - use of a windowBuilder is difficult.

    For all those reasons, we HIGHLY recommend to NOT define applications
    as subclasses of StandardSystemView, but instead base them on
    ApplicationModel, and reference the topView(s) as instance variables of
    if (if at all).

    [instance variables:]
        label                   <String>    the label in the windows title

        icon                    <Form>      the icon
                                            [ignored if the display does not
                                             support icons]

        iconView                <View>      an optional icon-view (for animated icons)
                                            [ignored if the display does not
                                             supports this]

        iconLabel               <String>    the label in the icon
                                            [ignored if the display does not
                                             support label-tabs with icons]

        minExtent               <Point>     the minimum size
                                            No limit, if nil
                                            [the window manager may have its own
                                             limit; typically some small area]

        maxExtent               <Point>     the maximum size
                                            No limit, if nil.
                                            [the window manager may have its own
                                             limit; typically the screen size]

        sizeFixed               <Boolean>   prevents the view from resizing itself
                                            (especially to freeze a dialogs size)

        application             <AppModel>  if nonNil, that's the application
                                            Many requests (such as open/close etc.
                                            are forwarded to it, if present.



     [class variables:]

        DefaultIcon             <Form>      cached default icon

        TakeFocusWhenMapped     <Boolean>   if true, views grab the keyboard
                                            focus (convenient with some stupid
                                            windowManagers)

        IncludeHostNameInLabel  <Boolean>   if true, the windows title shall
                                            include the hostname.
                                            (convenient if you have many remote
                                            views open simultaneously)

        WindowLabelFormat       <Boolean>   specifies the format for windowLabels


    [author:]
        Claus Gittinger

    [see also:]
        WindowGroup
        ApplicationModel
"
!

examples
"
    simple, empty topView:
									[exBegin]
	|topView|

	topView := StandardSystemView new.
	topView label:'my first view'.
	topView extent:200 @ 200.
	topView open.
									[exEnd]

    with an icon & iconLabel:
									[exBegin]
	|topView|

	topView := StandardSystemView extent:200 @ 200.
	topView label:'Hello world'.

	topView icon:(Image fromFile:'hello_world.icon').
	topView open.
									[exEnd]


    with an animated iconView [not supported on all display devices]:
									[exBegin]
	|iconView topView|

	iconView := ClockView new.

	topView := StandardSystemView extent:200 @ 200.
	topView label:'Hello world'.

	topView iconView:iconView.
	topView open.
									[exEnd]


    placing a subView into it:
									[exBegin]
	|topView button|

	topView := StandardSystemView new.
	topView label:'my second view'.
	topView extent:200 @ 200.

	button := Button label:'close' in:topView.
	button action:[topView destroy].

	topView open.
									[exEnd]

    same, relative sized subview:
									[exBegin]
	|topView button|

	topView := StandardSystemView new.
	topView label:'my second view'.
	topView extent:200 @ 200.

	button := Button label:'close' in:topView.
	button action:[topView destroy].
	button origin:0.25 @ 0.25 corner:0.75 @ 0.75.

	topView open.
									[exEnd]

    multiple buttons in a panel in a topView:
									[exBegin]
	|topView panel button1 button2 button3|

	topView := StandardSystemView new.
	topView label:'my second view'.
	topView extent:200 @ 200.

	panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:topView.
	panel inset:10.
	panel level:-1.

	button1 := Button label:'one' in:panel.
	button1 action:[Transcript showCR:'one pressed'].

	button2 := Button label:'two' in:panel.
	button2 action:[Transcript showCR:'two pressed'].

	button3 := Button label:'three' in:panel.
	button3 action:[Transcript showCR:'three pressed'].

	topView open.
									[exEnd]
"
! !

!StandardSystemView class methodsFor:'instance creation'!

extent:anExtent label:aLabel icon:aForm
    "create a new topView and define its extent, label and icon"

    ^ self origin:nil extent:anExtent
	   label:aLabel icon:aForm
	   minExtent:nil maxExtent:nil
!

extent:anExtent label:aLabel icon:aForm minExtent:minExtent
    ^ self origin:nil extent:anExtent
	   label:aLabel icon:aForm
	   minExtent:minExtent maxExtent:nil
!

extent:anExtent label:aLabel icon:aForm minExtent:minExtent maxExtent:maxExtent
    ^ self origin:nil extent:anExtent
	   label:aLabel icon:aForm
	   minExtent:minExtent maxExtent:maxExtent
!

extent:anExtent label:aLabel minExtent:minExtent
    "create a new topView and define its extent, label and minumum extent"

    ^ self origin:nil extent:anExtent
	   label:aLabel icon:nil
	   minExtent:minExtent maxExtent:nil
!

label:aLabel
    "create a new topView and define its label"

    ^ self origin:nil extent:nil
	   label:aLabel icon:nil
	   minExtent:nil maxExtent:nil
!

label:aLabel icon:aForm
    "create a new topView and define its label and icon"

    ^ self origin:nil extent:nil
	   label:aLabel icon:aForm
	   minExtent:nil maxExtent:nil
!

label:aLabel icon:aForm minExtent:anExtent
    "create a new topView and define its label, icon and minumum extent"

    ^ self origin:nil extent:nil
	   label:aLabel icon:aForm
	   minExtent:anExtent maxExtent:nil
!

label:aLabel icon:aForm minExtent:minExtent maxExtent:maxExtent
    "create a new topView and define its label, icon, min and max extents"

    ^ self origin:nil extent:nil
	   label:aLabel icon:aForm
	   minExtent:minExtent maxExtent:maxExtent
!

label:aLabel minExtent:anExtent
    "create a new topView and define its label and minimum extent"

    ^ self origin:nil extent:nil
	   label:aLabel icon:nil
	   minExtent:anExtent maxExtent:nil
!

model:aModel label:aLabel minimumSize:minExtent
    "ST80-style instance creation"

    |newView|

    newView := self origin:nil
		    extent:minExtent
		     label:aLabel
		      icon:nil
		 minExtent:minExtent
		 maxExtent:nil.
    newView model:aModel.
"/    newView controller:(self defaultControllerClass new view:newView).
    ^ newView
!

origin:anOrigin extent:anExtent label:aLabel
    "create a new topView and define its origin, extent and label"

    ^ self origin:anOrigin extent:anExtent
	   label:aLabel icon:nil
	   minExtent:nil maxExtent:nil
!

origin:anOrigin label:aLabel icon:aForm
		minExtent:minExtent maxExtent:maxExtent
    "create a new topView and define its origin, extent, label, icon
     and extent-boundaries."

    ^ self origin:anOrigin extent:nil
	   label:aLabel icon:aForm
	   minExtent:minExtent maxExtent:maxExtent
! !

!StandardSystemView class methodsFor:'Compatibility-VW'!

promptForOpen:aBoolean
    "not implemented here"
! !

!StandardSystemView class methodsFor:'class initialization'!

initialize
    IncludeHostNameInLabel := false.
    WindowLabelFormat := self defaultWindowLabelFormat.

    TakeFocusWhenMapped := (Screen notNil and:[Screen isWindowsPlatform]).

    "Created: / 20.8.1997 / 14:16:32 / cg"
    "Modified: / 24.8.1998 / 17:16:33 / cg"
! !

!StandardSystemView class methodsFor:'defaults'!

defaultExtent
    "return a standardSystemViews default window extent"

    DefaultExtent notNil ifTrue:[
	^ DefaultExtent
    ].
    ^ super defaultExtent

    "Created: 15.8.1997 / 01:36:21 / cg"
!

defaultIcon
    "return a topViews default window icon"

    <resource: #programImage>
    <resource: #style (#ICON #ICON_FILE)>

    |n nm i|

    (i := DefaultIcon) isNil ifTrue:[
	i := self classResources at:'ICON' default:nil.
	i isNil ifTrue:[
"/            OperatingSystem platformName == #win32 ifTrue:[
"/                n := 'stx_16x16.xpm'.
"/            ] ifFalse:[
"/                n := 'SmalltalkX.xbm'.
"/            ].
	    nm := ClassResources at:'ICON_FILE' default:n.
	    nm notNil ifTrue:[
		i := Smalltalk imageFromFileNamed:nm inPackage:'stx:libtool'.
	    ].
	    i isNil ifTrue:[
		i := self defaultSTXIcon
	    ].
	].
	i notNil ifTrue:[
	    DefaultIcon := i := i onDevice:Display
	]
    ].
    ^ i

    "
     DefaultIcon := nil.
     self defaultIcon inspect
    "

    "Modified: / 17-09-2007 / 11:36:25 / cg"
!

defaultIconForAboutBox
    ^ self defaultIcon
!

defaultLabel
    "return the default label for views of my kind.
     This can be redefined in subclasses or overwritten in
     initialize methods."

    ^ self nameWithoutPrefix. "/ 'aView'

    "Modified: / 27.9.1999 / 11:38:57 / cg"
!

defaultWindowLabelFormat
    "%2 is the hostName;
     %1 is the actual window label."

    "/ ^ '%2:%1'.    "/ the old format
    "/ ^ '%1 @ %2'.
    ^ '%1 (%5@%2)'.
!

includeHostNameInLabel
    "return the flag which controls if a views label should
     include the hostname.
     This flag is usually set/cleared in your private.rc file;
     the default is false."

    ^ IncludeHostNameInLabel

    "Created: 10.9.1995 / 19:21:16 / claus"
!

includeHostNameInLabel:aBoolean
    "set/clear the flag which controls if a views label should
     include the hostname - this is highly useful if you have
     multiple smalltalks open simultaneously ...
     This flag is usually set/cleared in your private.rc file;
     the default is false."

    IncludeHostNameInLabel := aBoolean

    "Modified: 24.4.1996 / 09:09:21 / cg"
!

takeFocusWhenMapped
    ^ TakeFocusWhenMapped

    "
     StandardSystemView takeFocusWhenMapped
    "
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'standardSystemView.defaultExtent')>

    DefaultExtent := StyleSheet at:'standardSystemView.defaultExtent' default:nil.

    "
     self updateStyleCache
    "

    "Modified: 31.8.1995 / 03:01:14 / claus"
    "Created: 15.8.1997 / 01:34:37 / cg"
    "Modified: 20.10.1997 / 15:13:50 / cg"
!

windowLabelFormat
    ^ WindowLabelFormat
!

windowLabelFormat:aFormatString
    WindowLabelFormat := aFormatString
! !

!StandardSystemView class methodsFor:'image specs'!

defaultSTXIcon
    <resource: #programImage>

    ^ Icon stxIcon.
! !

!StandardSystemView class methodsFor:'startup'!

cancelAutoRaise
    "cancel any schedule autoraise action"

    |b|

    (b := TimedRaiseAction) notNil ifTrue:[
	TimedRaiseAction := nil.
	Processor removeTimeoutWithID:b.
    ].
!

start
    "create, realize the view - this topview and all its subviews will
     run as a separate process with its own windowGroup.
     This method exists for backward compatibility - use open."

    ^ self open
! !

!StandardSystemView methodsFor:'Compatibility-ST80'!

maximumSize
    "same as maxExtent; for ST-80 compatibility"

    ^ self maxExtent
!

maximumSize:anExtent
    "same as maxExtent; for ST-80 compatibility"

    ^ self maxExtent:anExtent
!

menuBar
    "return my menuBar or nil if I have none.
     This is only valid for topViews which were built with the UIBuilder."

    ^ application builder menuBar

    "Created: / 27.10.1997 / 16:23:13 / cg"
!

minimumSize
    "same as minExtent; for ST-80 compatibility"

    ^ self minExtent
!

minimumSize:anExtent
    "same as minExtent; for ST-80 compatibility"

    ^ self minExtent:anExtent
!

quit
    "same as closeRequest
     (but sometimes sent via the sensors event queue from VW programs)"

    self closeRequest

    "Created: / 30.10.1997 / 19:23:01 / cg"
    "Modified: / 3.8.1998 / 20:04:22 / cg"
! !

!StandardSystemView methodsFor:'accessing'!

application
    "return the topViews application.
     This is new protocol for ST-80 compatibility and not yet fully supported"

    ^ application
!

application:anApplicationModel
    "set the topViews application.
     This is new protocol for ST-80 compatibility and not yet fully supported"

    application := anApplicationModel.
    anApplicationModel notNil ifTrue:[
	anApplicationModel window isNil ifTrue:[
	    anApplicationModel window:self
	]
    ]

    "Modified: 18.4.1996 / 14:55:44 / cg"
!

keyboardMap
    "Return a KeyboardMap used to translate symbolic shortcuts to real key combinations."

    | map |

    application notNil ifTrue:[ 
        [ 
            map := application keyboardMap.
        ] on: MessageNotUnderstood do:[
            map := super keyboardMap
        ].
    ] ifFalse:[ 
        map := super keyboardMap
    ].
    ^ map

    "Created: / 02-02-2017 / 00:18:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StandardSystemView methodsFor:'accessing-behavior'!

bePartner
    "define me as a partner-View.
     All partners within the applications windowGroup iconify/deiconify together."

    self setWindowGroupFromApplication.
    super bePartner.

    "
     see example in TopView>>bePartner
    "

    "Created: 22.9.1995 / 17:40:15 / claus"
    "Modified: 6.3.1996 / 16:16:42 / cg"
!

beSlave
    "define me as a slave-View.
     All slaves within the application's windowGroup iconify/deiconify with the masterView(s)
     (i.e. they follow their master(s))"

    self setWindowGroupFromApplication.
    super beSlave.

    "
     see example in TopView>>beSlave
    "

    "Created: / 22-09-1995 / 17:40:15 / claus"
    "Modified: / 06-03-1996 / 16:16:50 / cg"
    "Modified (comment): / 28-08-2013 / 21:27:46 / cg"
!

sendWindowEvents:collectionOfEventSymbols
    "define the events that are to be forwarded to the application.
     This is being implemented ..."

    windowEventsForApplication := collectionOfEventSymbols
!

sizeFixed:aBoolean
    "this prevents the view from resizing itself when realized.
     For normal topViews, this is void, since they don't do this anyway.

     However, modalBoxes (especially: DialogBoxes) typically resize themselfes
     to the preferredExtent of their components. In some cases, this behavior is
     not desired and it should be turned off by setting sizeFixed to true.

     To avoid confusion:
        This does NOT prevent the window manager from resizing the view,
        instead it tells the view to NOT resize ITSELF."

    sizeFixed := aBoolean.

    "example: dialog which resizes itself on #open:
              (thereby ignoring the 200@200 extent)

        |dialog|

        dialog := Dialog new.
        dialog addInputFieldOn:'' asValue.
        dialog addOkButton.
        dialog extent:200@200.
        dialog open.


    using sizeFixed:

        |dialog|

        dialog := Dialog new.
        dialog addInputFieldOn:'' asValue.
        dialog addOkButton.
        dialog extent:200@200; sizeFixed:true.
        dialog open.


    using openWithExtent (also sets sizeFixed):

        |dialog|

        dialog := Dialog new.
        dialog addInputFieldOn:'' asValue.
        dialog addOkButton.
        dialog openWithExtent:200@200.
    "
! !

!StandardSystemView methodsFor:'accessing-channels'!

labelChannel
    "return the labelChannel - or nil"

    ^ labelChannel.
!

labelChannel:aValueHolder
    "set the labelChannel - a valueHolder holding a string
     which is shown as title bar"

    |prev|

    prev := labelChannel.
    labelChannel := aValueHolder.
    self setupChannel:aValueHolder for:nil withOld:prev.
! !

!StandardSystemView methodsFor:'accessing-dimensions'!

maxExtent
    "return the view's maximum allowed extent"

    ^ maxExtent
!

maxExtent:max
    "define the maximum extent the view may have -
     depends on good-will of window manager"

    |id|

    maxExtent ~= max ifTrue:[
	maxExtent := max.
	maxExtent x isNil ifTrue:[
	    maxExtent := 99999 @ maxExtent y.
	].
	maxExtent y isNil ifTrue:[
	    maxExtent := maxExtent x @ 99999.
	].

	(id := self drawableId) notNil ifTrue:[
	    device setWindowMinExtent:nil maxExtent:max in:id
	].

	"/ if my current extent is larger than the new
	"/ maxExtent, adjust.

	(width notNil and:[height notNil]) ifTrue:[
	    ((width > (max x)) or:
	     [height > (max y)]) ifTrue: [
		self extent:(max min:self extent)
	    ]
	]
    ].
!

minExtent
    "return the view's minimum allowed extent"

    ^ minExtent
!

minExtent:min
    "define the minimum extent the view may have -
     depends on good-will of window manager"

    |id|

    minExtent ~= min ifTrue:[
	minExtent := min.
	(id := self drawableId) notNil ifTrue:[
	    device setWindowMinExtent:min maxExtent:nil in:id
	].

	"/ if my current extent is smaller than the new
	"/ minExtent, adjust.

	(width notNil and:[height notNil]) ifTrue:[
	    ((width < (min x)) or:
	     [height < (min y)]) ifTrue: [
		self extent:(min max:self extent)
	    ]
	]
    ]
! !

!StandardSystemView methodsFor:'accessing-look'!

icon
    "return the form defined as icon"

    ^ icon value
!

icon:aFormOrImage
    "define the form or image (bitmap) used as icon"

    |i m iconValue|

    icon := aFormOrImage.
    iconValue := icon value.
    iconValue notNil ifTrue:[
	self drawableId notNil ifTrue:[
	    i := device convertedIcon:iconValue.
	    (i notNil and:[i id notNil]) ifTrue:[
		(m := iconValue mask) notNil ifTrue:[
		    m := device convertedIconMask:m.
		].
		device setWindowIcon:i mask:m in:self drawableId
	    ]
	]
    ]

    "Modified: / 30-10-2007 / 16:39:15 / cg"
!

iconLabel
    "return the name displayed in the icon"

    ^ iconLabel
!

iconLabel:aString
    "define the name to be displayed in the icon"

    |newLabel|

    (newLabel := aString string) ~= iconLabel ifTrue:[
	iconLabel := newLabel.
	self drawableId notNil ifTrue:[
	    device setIconName:newLabel in:self drawableId.
	    "
	     unbuffered - to make it visible right NOW
	    "
	    self flush.
	]
    ]
!

iconMask
    "return the form defined as iconMask.
     Notice, that many windowManagers ignore this mask
     (usually, only managers which place icons on the background desktop
      care for an icon - if at all ...)"

    |mask|

    "/ only images possibly have iconMasks
    icon notNil ifTrue:[
	(mask := icon value mask) notNil ifTrue:[
	    ^ device convertedIconMask:mask
	]
    ].

    ^ nil

    "Modified: / 30-10-2007 / 20:59:40 / cg"
!

iconName:aString
    "this method will vanish soon ... - for backward compatibility"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #iconLabel:'.
    self iconLabel:aString
!

iconView
    "return the view used as icon-view"

    ^ iconView
!

iconView:aView
    "specify the view to be used as icon.
     This may not be supported on all display types"

    iconView := aView.
    self drawableId notNil ifTrue:[
	aView create.
	device setWindowIconWindow:aView in:self drawableId.
	aView setRealized:true.
    ]

    "Modified: 4.4.1997 / 16:21:37 / cg"
!

label
    "return the view's name in the title area"

    ^ label
!

label:aString
    "define the view's name in the window's title area.
     If IncludeHostNameInLabel is true, prepend the hostname - now done in windowLabelFor:
     (you will appreciate this, if you are working on multiple
      machines simultaneously - as I do ...)"

    |newLabel expandedLabel|

    newLabel := aString.
    newLabel notNil ifTrue:[newLabel := newLabel string].
    newLabel ~= label ifTrue:[
	label := newLabel.
	"/ fix: cg: realized is a bad test here - could still be unmapped...
	self drawableId notNil "realized" ifTrue: [
	    expandedLabel := self windowLabelFor:label.
	    self windowName:(expandedLabel ? '').
	    shown ifTrue:[
		"
		 unbuffered - to make it visible right NOW
		"
		self flush.
	    ]
	]
    ]

    "Created: / 08-09-1995 / 19:37:06 / claus"
    "Modified: / 06-10-2006 / 11:55:06 / cg"
!

label:labelString iconLabel:iconLabelString
    "set both the label and the iconLabel"

    self label:labelString.
    self iconLabel:iconLabelString
! !

!StandardSystemView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "the MVC way of changing the label ..."

    changedObject notNil ifTrue:[
	changedObject == labelChannel ifTrue:[
	    self label:labelChannel value.
	    ^ self
	].
    ].
    ^ super update:something with:aParameter from:changedObject
! !

!StandardSystemView methodsFor:'destroying'!

release
    self removeFromCurrentProject.
    labelChannel notNil ifTrue:[
	labelChannel removeDependent:self.
	labelChannel := nil.
    ].
    windowGroup notNil ifTrue:[
	windowGroup focusSequence:nil.
    ].
    super release.
!

saveAndTerminate
    "save & terminate request from the windowManager. The application should
     save its data/files/text etc. somehow and close.
     If there is an application, let it decide how do do that.
     Otherwise, forward it to superclasses which knows how to do this.
     (it defaults to a terminate there).
     Notice, that not all windowmanagers are nice enough
     to send this request; some simply distroy the view."

    application notNil ifTrue:[
	application saveAndTerminateRequestFor:self
    ] ifFalse:[
	super saveAndTerminate
    ]
!

terminate
    "terminate request from the windowManager. If there is an application,
     let it decide if it really wants to be close. Otherwise, forward it to
     superclasses terminate which knows how to do this.
     Notice, that not all windowmanagers are nice enough
     to send this request; some simply distroy the view."

    application notNil ifTrue:[
	application closeRequestFor:self
    ] ifFalse:[
	self closeRequest.
    ]

    "Modified: / 3.8.1998 / 19:49:45 / cg"
! !

!StandardSystemView methodsFor:'event handling'!

delayedAutoRaiseEvent
    "called with a delay by the focusIn code, iff the userPref setting is active.
     Some (a small number only) may want to prevent autoraise in certain situations
     - for example, if one view is controlling another. These get a chance to redefine this
     method"

    |wg app|

    "/ not, if my windowGroup is in a modal or popup action
    ((wg := self windowGroup) notNil
    and:[ wg isInModalLoop not
    and:[ wg mainGroup isInModalLoop not
    and:[ self isModal not ]]]) ifTrue:[
	self sensor anyButtonPressed ifFalse:[
	    "/ if I have an application, let it decide
	    (app := self application) notNil ifTrue:[
		app delayedAutoRaiseEventFor:self
	    ] ifFalse:[
		self raise.
	    ].
	]
    ]
!

focusIn
    "the view got the keyboard focus (via the window manager).
     I.e. the mouse was moved out into the topView area - restore the
     focus to the previous focusView.."

    |viewToGetFocus viewUnderMousePointer ms|

    windowGroup notNil ifTrue:[
	"/ a hack for window managers, which do not honor the
	"/ WMTransientFor attribute (i.e. XQuartz).
	"/ This flag would prevent a popup (dialog or notification) from being
	"/ covered by its underlying regular view. But on MAC, it does not.
	"/ However, focus is coming in, when doing this, so we manually fix this
	"/ here. Should not hurt on other systems, where the view is already on top.
	"/ if it does, add some conditional check here (device WMTransientForBroken or similar)
	"/ You can check for you WM to be correct, by disabling the line below,
	"/ then click on a smallLint-note icon, to see the smallLint info,
	"/ then click on the underlying codeView, to raise it.
	"/ if the smallLint view can be covered, your WM is broken.
	"/ cg: turns out to be a bad idea - it does help solve the above problem (on mac),
	"/ but raises unwanted topViews (for example, if a modal dialog's popup menu closes)
	"/ windowGroup topViews first raise.

	"/ I got the focus - tell the current focus-windowgroup
	"/ that its focus is gone elsewhere ...
	"/ 'focusIn ' print. windowGroup process name printCR.
	"/ 'focusView is ' print. windowGroup focusView printCR.

	"/ although the foucs has usually already been taken (see focusOut),
	"/ there are situations where this does not happen;
	"/ I am not sure if that is a WM bug or an ST/X bug, but sometimes (with popups),
	"/ I only get a focus in. Could be a race, when the loosing view is already destroyed,
	"/ at the time the focus event arrives.
	"/ Anyway: it should not matter to take it again...
	WindowGroup takeFocusFromDevice:device.

	windowGroup isInModalLoop ifTrue:[
	    windowGroup allTopViewsDo:[:t |
		t ~~ self ifTrue:[
		    t focusIn.
		    t raise.
		    ^ self.
		].
	    ]
	].

	"/ Transcript show:self; show:' focus in '; showCR:windowGroup isInModalLoop.

	viewToGetFocus := windowGroup focusView.
	viewToGetFocus isNil ifTrue:[
	    UserPreferences current focusFollowsMouse ~~ false ifTrue:[
		viewUnderMousePointer := windowGroup pointerView.
		"/ 'viewUnderMousePointer is ' print. viewUnderMousePointer printCR.
		(viewUnderMousePointer notNil
		and:[viewUnderMousePointer isKeyboardConsumer
		and:[viewUnderMousePointer wantsFocusWithPointerEnter]]) ifTrue:[
		    viewToGetFocus := viewUnderMousePointer.
		]
	    ].
	].
	viewToGetFocus isNil ifTrue:[
	    windowGroup focusBackToPreviousFocusView.
	    windowGroup focusView isNil ifTrue:[
		self assignInitialKeyboardFocus.
	    ].
	] ifFalse:[
	    "/ v requestFocus.  - will be denied; but we must force it here
	    "/ to force a change...
	    windowGroup setFocusView:nil.
	    windowGroup focusView:viewToGetFocus byTab:nil.
	].

	"/ optionally bring the window to the front after some delay.
	"/ but not, if my windowGroup is in a modal or popup action
	(ms := UserPreferences current autoRaiseOnFocusInDelay) notNil ifTrue:[
	    self scheduleAutoRaiseAfter:ms
	].
    ].
    super focusIn

    "Modified: / 20-01-2011 / 20:51:20 / cg"
!

focusOut
    "the top-view lost the keyboard focus (via the window manager).
     I.e. the mouse was moved out of the topView area."

    |v wg|

    "/ 'fout ' print. self printCR.

    (wg := windowGroup) notNil ifTrue:[
	"/ '  fout-focusView: ' print. windowGroup focusView printCR.
	(v := wg focusView) notNil ifTrue:[
	    "/ wg focusView:nil.  "/ -- let windowGroup do it.
	    v showNoFocus:(windowGroup explicitFocusView == v).
	    "/ '  send-has-nofocus to: ' print. v printCR.
	    v hasKeyboardFocus:false.
	]
    ].
    super focusOut

    "Modified: 25.2.1997 / 23:19:46 / cg"
!

processShortcut:aKeyEvent
    "a shortcut key event as forwarded from the keyboardProcessor - if there is the
     shortcut key defined, process the shortcut and return true - otherwise false."

    application notNil ifTrue:[
	(application processShortcut:aKeyEvent) ifTrue:[ ^ true ]
    ].
    ^super processShortcut:aKeyEvent

    "Created: / 23-07-2013 / 18:15:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-07-2013 / 23:57:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scheduleAutoRaiseAfter:ms
    "bring the window to the front after some delay.
     but not, if my windowGroup is in a modal or popup action"

    |wg actionID|

    (wg := self windowGroup) isNil ifTrue:[^ self].
    wg isInModalLoop ifTrue:[^ self].
    wg mainGroup isInModalLoop ifTrue:[^ self].
    "/ self isModal ifTrue:[^ self].

    TimedRaiseAction notNil ifTrue:[
	Processor removeTimeoutWithID:TimedRaiseAction.
    ].
    TimedRaiseAction := actionID := Processor
			    addTimedBlock:
				[
				    TimedRaiseAction == actionID ifTrue:[
					TimedRaiseAction := nil.
					self sensor pushUserEvent: #delayedAutoRaiseEvent for: self
				    ].
				]
			    afterMilliseconds:ms.
!

showActivity:someMessage
    "some activityNotification shalt be communicated to
     the user. Forward it to my application (if any).
     (that one should know how to deal with it).
     Otherwise, simply ignore it."

    application notNil ifTrue:[
	application showActivity:someMessage
    ]

    "Created: 16.12.1995 / 18:40:44 / cg"
    "Modified: 23.4.1996 / 21:38:11 / cg"
! !

!StandardSystemView methodsFor:'initialization & release'!

addToCurrentProject
    "add the receiver (a topview) to the current projects set-of-views.
     (If there is a current project)"

    |p|

    "
     the following check allows systems
     without projects and changeSets
    "
    (Project notNil and:[(p := Project current) notNil]) ifTrue:[
	p addView: self
    ]
!

defaultControllerClass
    "for ST-80 compatibility only - not used in ST/X"

    ^ nil "/ StandardSystemController
!

initEvents
    super initEvents.
    self enableFocusEvents.
!

initialize
    super initialize.

    "/ self setBorderWidth:2.         "- notice: many window managers ignore this"
    device isWindowsPlatform ifTrue:[
	minExtent := 0 @ 0.
    ] ifFalse:[
	minExtent := 10 @ 10.
    ].

    label isNil ifTrue:[label := self class defaultLabel].
    icon isNil ifTrue:[icon := self class defaultIcon].
    sizeFixed := false.

    "Modified: / 27-10-2012 / 12:16:39 / cg"
!

mapped
    super mapped.
    device isWindowsPlatform ifTrue:[
	"don't do this in X11 - switching between
	 virtual desktops would change the window stacking all the time"
	self setForegroundWindow.
	self activate.
    ].

    "Created: / 01-12-2010 / 15:57:22 / cg"
!

reAdjustGeometry
    "sent as a final step when an image is restarted.
     when we come up on a smaller display,
     make certain, that the receiver is visible"

    |dX dY limitRight limitBottom graphicsDevice|

    graphicsDevice := device.
    dX := (graphicsDevice horizontalPixelPerMillimeter * 20) rounded.
    dY := (graphicsDevice verticalPixelPerMillimeter * 20) rounded.

    limitRight := graphicsDevice usableWidth - dX.
    limitBottom := graphicsDevice usableHeight - dY.
    ((self left > limitRight) or:[
      self top > limitBottom]) ifTrue:[
	'StandardSystemView [info]: moving view into visible area' infoPrintCR.
	self origin:limitRight @ limitBottom
    ]

    "Modified: 10.1.1997 / 15:12:19 / cg"
!

reinitialize
    "reopen the receiver if it was visible before.
     This is called right after snapIn; Notice, that all instance variables
     (such as shown, realized etc.) are left-overs from the time the snapout
     was done. Remap the receiver, if it was mapped at snapout time"

    |myController|

    "if I have already been reinited - return"
    self drawableId notNil ifTrue:[
        ^ self
    ].

    "have to kludge with the controller
     - otherwise its startup performs unwanted actions ..."

    myController := controller.
    controller := nil.

    "physically create the view & subviews"
    self recreate.

    "if I was iconified (not realized), remap iconified"
    device
        mapView:self id:self drawableId iconified:(realized "shown" not)
        atX:left y:top width:width height:height
        minExtent:minExtent maxExtent:maxExtent.

    "and restart the window-group process"
    windowGroup notNil ifTrue:[
        windowGroup restart
    ].

    "restore controller"
    controller := myController

    "Modified: / 6.5.1999 / 09:50:13 / cg"
!

removeFromCurrentProject
    "remove the receiver (a topview) from the current projects set-of-views.
     (If there is a current project)"

    |p|

    "
     the following check allows systems
     without projects and changeSets
    "
    (Project notNil and:[(p := Project current) notNil]) ifTrue:[
	p removeView:self
    ]
!

restarted
    "sent by my windowGroup, when restarted from an image.
     Nothing done here, but can be redefined to perform any actions
     required to reset the application after an image-restart.
     (for example: check if application files are still around, restart
     subprocesses etc.)."

    application notNil ifTrue:[
	application restarted
    ].
! !

!StandardSystemView methodsFor:'printing & storing'!

printOn:aStream
    "just for your convenience in inspectors ...
     ... add the view's label to the displayString."

    super printOn:aStream.
    label notNil ifTrue:[
        aStream nextPut:$(.  label printOn:aStream. aStream nextPut:$).
    ].
! !

!StandardSystemView methodsFor:'private'!

convertedIcon
    "make certain, that the icon is compatible with my device;
     this means converting it to a format (typically: monochrome) which
     the device supports. Return a compatible version of the icon."

    ^ device convertedIcon:icon

    "Modified: / 30-10-2007 / 16:39:55 / cg"
!

convertedIcon:iconArg
    "make certain, that the image argument is compatible with my device;
     this means converting it to a format (typically: monochrome) which
     the device supports. Return a compatible version of the icon."

    ^ device convertedIcon:iconArg

    "Modified: / 30-10-2007 / 16:37:31 / cg"
!

convertedIconMask:aMask
    "return a version of the argument which can be used as an iconMask
     on my device. Typically, this means conversion to a monochrome
     mask - future versions may add alpha channel masks, if the device supports
     them ..."

    ^ device convertedIconMask:aMask

    "Modified: / 30-10-2007 / 16:38:58 / cg"
!

setWindowGroupFromApplication
    "get the applications topView and set my windowGroup to its wg."

    |win master|

    windowGroup isNil ifTrue:[
	application notNil ifTrue:[
	    (win := application window) notNil ifTrue:[
		win ~~ self ifTrue:[
		    windowGroup := win windowGroup.
		    ^ self
		].
		(master := application masterApplication) notNil ifTrue:[
		    (win := master window) notNil ifTrue:[
			windowGroup := win windowGroup.
			^ self
		    ].
		].
	    ]
	]
    ].

    "Created: 22.9.1995 / 17:40:36 / claus"
    "Modified: 6.3.1996 / 16:17:32 / cg"
!

windowLabelFor:labelString
    "return an expanded labelString, according to the hostName-in-window setting.
     The labelString may include positional parameters:
	%1 - the actual label
	%2 - the hostname
	%3 - the userName
	%4 - the processId
	%5 - the TOP-directories name
	%6 - the TOP-directories path
    "

    |wg proc id pidString lbl windowLabelFormat stxPackageDirectory topDirectory|

    (IncludeHostNameInLabel == true
    and:[(windowLabelFormat := self class windowLabelFormat) notNil]) ifTrue:[
	(wg := self windowGroup) notNil ifTrue:[
	    (proc := wg process) notNil ifTrue:[
		(id := proc id) notNil ifTrue:[
		    pidString := id printString
		]
	    ]
	].
	stxPackageDirectory := Smalltalk getPackageDirectoryForPackage:'stx'.
	stxPackageDirectory isNil ifTrue:[
	    'StdSysView [info]: cannot figure out stx package directory.' infoPrintCR.
	    stxPackageDirectory := OperatingSystem pathOfSTXExecutable asFilename.
	].
	stxPackageDirectory isNil ifTrue:[
	    topDirectory := OperatingSystem getHomeDirectory asFilename.
	] ifFalse:[
	    topDirectory := stxPackageDirectory directory.
	    "/ a hack to make it look nicer on mac... (shows Packages otherwise)
	    topDirectory baseName = 'Packages' ifTrue:[
		topDirectory := topDirectory directory
	    ].
	].
	lbl := windowLabelFormat
		bindWith:labelString
		with:[OperatingSystem getHostName]
		with:[OperatingSystem getLoginName]
		with:pidString
		with:[topDirectory baseName]
		with:[topDirectory pathName].
	^ lbl
    ].
    ^ labelString

    "Created: / 22-09-1997 / 10:10:32 / cg"
    "Modified: / 22-08-2006 / 11:42:53 / cg"
! !

!StandardSystemView methodsFor:'queries'!

processName
    "return a string to be shown for my process in the
     process monitor. This has no semantic meaning, but exists
     for your convenience only."

    application notNil ifTrue:[
	^ application processName
    ].
    label notNil ifTrue:[^ label].
    ^ super processName

    "Modified: 24.4.1996 / 09:47:01 / cg"
! !

!StandardSystemView methodsFor:'realization'!

collapse
    "iconify the receiver"

    shown ifTrue:[
	self unmap.

	"if it was iconified, try to remap iconified"
	device
	    mapView:self id:self drawableId iconified:true
	    atX:left y:top width:width height:height
	    minExtent:minExtent maxExtent:maxExtent.

	shown ifTrue:[
	    shown := false.
	    dependents notNil ifTrue:[ self changed:#visibility ].
	].
    ].

    "
     |top|

     top := StandardSystemView new.
     top label:'hello'.
     top openAndWait.
     Delay waitForSeconds:2.
     top collapse.
     Delay waitForSeconds:2.
     top expand.
    "

    "Modified: 24.7.1997 / 12:32:17 / cg"
!

create
    "create - make certain that icon is available"

    super create.

    iconView notNil ifTrue:[
	iconView create.
	device setWindowIconWindow:iconView in:self drawableId.
	iconView setRealized:true.
    ].
    iconLabel notNil ifTrue:[
	device setIconName:iconLabel string in:self drawableId
    ]

    "Modified: 10.6.1996 / 20:14:50 / cg"
!

expand
    "de-iconify the receiver at its old position"

    shown ifFalse:[
	self unmap.

	"if it was iconified, try to remap non-iconified"
	device
	    mapView:self id:self drawableId iconified:false
	    atX:left y:top width:width height:height
	    minExtent:minExtent maxExtent:maxExtent.
    ].

    "
     |top|

     top := StandardSystemView new.
     top label:'hello'.
     top openAndWait.
     top collapse.
     Delay waitForSeconds:5.
     top expand.
    "

    "Modified: / 3.2.1998 / 16:02:56 / cg"
!

physicalCreate
    "common code for create & recreate"

    |dev currentUserPrefs lbl iconValue icn icnMask windowClassNameString org devBounds windowNameString|

    dev := device.
    currentUserPrefs := UserPreferences current.
    currentUserPrefs forceWindowsIntoMonitorBounds ifTrue:[
	"/ MULTI SCREEN support
	devBounds := dev monitorBoundsAt:( left @ top ).
	"/ adjust origin, if too large
	left + width > devBounds right ifTrue:[
	    left := devBounds right - width.
	].
	top + height > devBounds bottom ifTrue:[
	    top := devBounds bottom - height.
	].
	top  := top  max:(devBounds top).
	left := left max:(devBounds left).
    ].

    dev isWindowsPlatform ifTrue:[
	top := top + dev captionHeight.
    ].
    org := (left @ top) rounded.
    lbl := self windowLabelFor:label.

    icon notNil ifTrue:[
	iconValue := icon value.
	icn := dev convertedIcon:iconValue.
	(icnMask := iconValue mask) notNil ifTrue:[
	    icnMask := dev convertedIconMask:icnMask.
	].
	"this is to keep the references"
	deviceIcon := Array with:icn with:icnMask.
    ].

    "/ give global eventListeners a chance to intercept windowCreation
    "/ and provide another origin (by payching my origin via setOrigin:).
    WindowSensor preViewCreateNotification:self.

    gc
      createWindowFor:self
      type:(self windowType)
      origin:org
      extent:(width @ height)
      minExtent:minExtent
      maxExtent:maxExtent
      borderWidth:0 "self borderWidth"
      subViewOf:nil
      style:(self windowStyle)
      inputOnly:(self isInputOnly)
      label:lbl
      owner:nil
      icon:icn iconMask:icnMask
      iconView:iconView.

    "/ give global listeners a chance to track views
    WindowSensor postViewCreateNotification:self.

    self originChangedFlag:false extentChangedFlag:false.

"/    (borderColor notNil and:[borderColor ~= Black]) ifTrue:[
"/        self setBorderColor
"/    ].

"/  (viewGravity notNil "and:[viewGravity ~~ #NorthWest]") ifTrue:[
"/        super viewGravity:viewGravity
"/  ].

"/  (bitGravity notNil "and:[bitGravity ~~ #NorthWest]") ifTrue:[
"/      super bitGravity:bitGravity
"/  ].

    viewShape notNil ifTrue:[
	self setViewShape
    ].

    (backed notNil and:[backed ~~ false]) ifTrue:[
	self backingStore:backed.
    ].
    self saveUnder ifTrue:[
	self saveUnder:true.
    ].
    cursor notNil ifTrue:[
	self setCursor
    ].

    "Modified: / 14-06-1996 / 17:14:25 / stefan"
    "Modified: / 04-01-2013 / 16:13:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-05-2015 / 21:09:35 / cg"
!

postRealize
    "postRealize actions - tell the application (if any)."

    super postRealize.

    "/
    "/ let the application add its views to the current project
    "/
    application notNil ifTrue:[
	application opened:self.
    ] ifFalse:[
	self addToCurrentProject.
    ].

    "Created: 24.7.1997 / 18:11:26 / cg"
!

preRealize
    "invoked right before the view is realized.
     preRealize actions - tell the application (if any)."

    super preRealize.

    application notNil ifTrue:[
	application aboutToOpen:self.
    ].
!

recreate
    "recreate the view after a snap-in or a migration"

    super recreate.

    iconView notNil ifTrue:[
	iconView recreate.
	device setWindowIconWindow:iconView in:self drawableId.
	iconView setRealized:true.
    ] ifFalse:[
	icon notNil ifTrue:[
	    self icon:(device convertedIcon:icon).
	].
    ].

    iconLabel notNil ifTrue:[
	device setIconName:iconLabel in:self drawableId
    ]

    "Modified: / 30-10-2007 / 16:39:42 / cg"
! !

!StandardSystemView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


StandardSystemView initialize!
