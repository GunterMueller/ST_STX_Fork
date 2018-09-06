"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

DisplaySurface subclass:#SimpleView
	instanceVariableNames:'superView subViews components styleSheet resources border unused
		viewShape top left flagBits relativeOrigin relativeExtent
		relativeCorner originRule extentRule cornerRule insets layout
		shown hiddenOnRealize name level margin innerClipRect shadowColor
		lightColor bitGravity viewGravity controller windowGroup
		preferredExtent explicitExtent dependents layoutManager
		visibilityChannel helpKey dropTarget'
	classVariableNames:'CentPoint DefaultBorderColor DefaultBorderWidth
		DefaultFocusBorderWidth DefaultFocusColor DefaultLightColor
		DefaultShadowColor DefaultStyle DefaultViewBackgroundColor
		FlagBeingDestroyed FlagCanTab FlagCornerChanged
		FlagDoNotRequestFocusOnPointerEnter FlagExtentChanged
		FlagExtentChangedBeforeCreated FlagHasExplicitExtent
		FlagHiddenOnRealize FlagIsMDIChild FlagIsUnmappedModalBox
		FlagNativeWidget FlagOriginChanged FlagRequestFocusOnPointerEnter
		FlagTakeFocusWhenMapped Grey ReturnFocusWhenClosingModalBoxes
		StyleSheet ViewSpacing'
	poolDictionaries:''
	category:'Views-Basic'
!

SimpleView class instanceVariableNames:'ClassResources DefaultFont'

"
 No other class instance variables are inherited by this class.
"
!

ProceedingNotification subclass:#AboutToOpenBoxNotificationSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SimpleView
!

Object subclass:#ViewShape
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SimpleView
!

ProceedingNotification subclass:#BoxClosedNotificationSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SimpleView
!

SimpleView::ViewShape subclass:#RoundViewShape
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SimpleView
!

SimpleView::ViewShape subclass:#ArbitraryViewShape
	instanceVariableNames:'viewShapeForm borderShapeForm'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SimpleView
!

!SimpleView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    this class implements functions common to all Views which do not work on / show a model.
    Previously, all of this functionality used to be in the old View class, but has been
    separated into this new SimpleView (which does not know about models) and the new View,
    which does so.
    I'd prefer to call this class View and the current View class a ModelView,
    but for backward compatibility it is better to leave things the way they are
    (there are simply too many subclasses of View around...).

    Instances of SimpleView are seldom used directly, most views in the system inherit
    from this class. However, sometimes a view is needed to create a dummy view for framing
    or layout purposes.

    [Instance variables:]

	superView               <View>                  my superview i.e. the view I am in

	subViews                <Collection>            the collection of subviews
							These are the views proper.

	components              <Collection>            collection of gadgets (will be merged with subViews, soon)
							These are lightweight gadgets (not seen by windows/x11).

	styleSheet              <ResourcePack>          contains widget attributes (see libview/styles/*.style)

	resources               <ResourcePack>          contains national language translations (see lib*/resources/*.rs)

	border                  <Border>                color and width of border

	unused                  <nil>                   to keep the instVar size constant

	viewShape               <Form>                  shape of view & border (if device supports it)

	top                     <Number>                actual top coordinate (pixels) in superview

	left                    <Number>                actual left coordinate (pixels) in superview

	flagBits                <Integer>               flag bits (used to be individual booleans)
	    extendChanged                                   true if extend changed during setup
	    originChanged                                   true if origin changed during setup

	relativeOrigin          <Number>                relative origin in percent within superview

	relativeExtent          <Number>                relative extent in percent within superview

	relativeCorner          <Number>                relative corner in percent within superview

	originRule              <Block>                 rule to compute origin if superview changes size

	extentRule              <Block>                 rule to compute extent if superview changes size

	cornerRule              <Block>                 rule to compute corner if superview changes size

	insets                  <Array>                 array with top, left, bottom & right insets (or nil)

	layout                  <LayoutObject>          not yet implemented - will replace the above layout
							variables.

	shown                   <Boolean>               true if visible (false if iconified, unmapped or covered)

	unused_hiddenOnRealize  <Boolean>               don't show automatically when superview is realized.
							now encoded in the flags.
							(kept to keep the instVar size constant)

	name                    <String>                my name (future use for resources)

	level (**)              <Number>                3D level relative to superview

	margin                  <Number>                convenient margin; that is the number of pixels
							which are taken up by border plus 3D level
							(i.e. borderWidth + level abs)

	innerClipRect           <Rectangle>             convenient inner clip (minus margin)

	shadowColor (**)        <Color>                 color used to draw 3D shadowed edges

	lightColor (**)         <Color>                 color used to draw 3D lighted edges

	bitGravity              <nil | Symbol>          gravity of contents (if device supports it)

	viewGravity             <nil | Symbol>          gravity of view (if device supports it)

	controller              <nil | Controller>      the controller (if any)

	windowGroup             <WindowGroup>           the windowGroup

	preferredExtent(*)      <nil | Point>           preferredExtent overWrite
							if nonNil, the widget will not compute
							its pref-extent, but use that value.

	explicitExtent(*)       <nil | Point>           preferredExtent overWrite
							if nonNil, the widget will not compute
							its pref-extent, but use that value.

	dependents              <nil | Collection>      who depends on me

	layoutManager                                   currently unused; will be responsible for
							child layout management

	visibilityChannel                               valueHolder to control the visiblity

	helpKey                                         for tooltips

	dropTarget                                      for drag&drop

    (*) about to be changed to use preferredExtent as a cache and explicitExtent as
	an overwrite value.

    (**) We have recently started to change the system to use borders instead of separate
	 borderWidth, borderColor, level, shadow- and lightColors.
	 Expect more changes here in the near future..

    [Class variables:]

	Grey                    <Color>                 the color grey - its used so often

	ViewSpacing             <Number>                preferred spacing between views; 1mm

	CentPoint               <Point>                 100 @ 100 - its used so often

	StyleSheet              <ResourcePack>          contains all view-style specifics

	ReturnFocusWhenClosingModalBoxes                if true, a closing modalBox returns
				<Boolean>               the keyboard focus to the view which was
							active when the box was opened.
							If false (the default), it is left to
							window manager to assign a new focus.
							If running on olwm/olvwm (which requires an
							explicit click to reassign a focus), it is
							better to turn this on in a private.rc file.

    [styleSheet parameters:]

	popupShadow             <Boolean>               if true, popupViews show a shadow below

	popupLevel              <nil | Integer>         3D level

	borderWidth             <nil | Integer>         borderWidth (ignored in 3D styles)

	borderColor             <nil | Color>           borderColor (ignored in 3D styles)

	viewBackground          <nil | Color>           views background

	shadowColor             <nil | Color>           color for shadow edges (ignored in 2D styles)

	lightColor              <nil | Color>           color for light edges (ignored in 2D styles)

	font                    <nil | Font>            font to use


    TODO:
	get rid of relativeOrigin, relativeCorner, originRule, extentRule,
	and insets; replace by a single object which defines the size
	(mhmh - ST-80 seems to call this LayoutFrame ?)
	-> be prepared for a change here in the near future and ONLY use
	   access methods to get those instance variables' values

	get rid of 3D level & margin, move it to extra wrappers
	(although this will make view setup more complicated, it will remove
	 complexity from the internals of view. Also, it will allow for more
	 varieties of borders.)

	add components (could also call them gadgets or lightweight views)
	- views are expensive in terms of X resources. This would make all
	framing/edge and panel helper views become cheap ST objects, instead
	of views.


    [see also:]
	StandardSystemView DialogBox
	WindowGroup WindowEvent
	Layout
	( introduction to view programming :html: programming/viewintro.html )

    [author:]
	Claus Gittinger
"
!

examples
"
    (all examples below use different viewBackgrounds,
     to make the individual subviews visible)

    a subView in a topView:
									[exBegin]
	|top v|

	top := StandardSystemView new.
	v := View new.
	v origin:0.25 @ 0.25 corner:0.75 @ 0.75.
	top addSubView:v.
	top open
									[exEnd]


    the same, a bit more compact:
									[exBegin]
	|top v|

	top := StandardSystemView new.
	v := View origin:0.25 @ 0.25 corner:0.75 @ 0.75 in:top.
	top open
									[exEnd]


    fixed position/size:
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View origin:10@10
		  corner:50@50
		      in:top.
       v2 := View origin:60@10
		  corner:150@100
		      in:top.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top open
									[exEnd]

    same, using ST-80 way of bulding up view hierarchies
    (recommended, if you plan to port applications later)
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v1 origin:10@10 corner:50@50.

       v2 := View new.
       v2 origin:60@10 corner:150@100.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1.
       top add:v2.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top open
									[exEnd]

    fixed origin, variable size:
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v1 origin:10@10 corner:50@0.5.

       v2 := View new.
       v2 origin:60@10 corner:150@0.5.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1.
       top add:v2.

       top open
									[exEnd]

    fixed origin, variable size,
    bottomInset for constant distance from bottom:
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v1 origin:10@10 corner:50@1.0.
       v1 bottomInset:10.

       v2 := View new.
       v2 origin:60@10 corner:150@1.0.
       v2 bottomInset:10.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1.
       top add:v2.

       top open
									[exEnd]

    variable origin, variable size,
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v1 origin:0.0@0.0 corner:0.5@0.5.

       v2 := View new.
       v2 origin:0.5@0.0 corner:1.0@0.5.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1.
       top add:v2.

       top open
									[exEnd]

    variable origin, variable size,
    insets for some constant distance
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v1 origin:0.0@0.0 corner:0.5@0.5.
       v1 rightInset:5.

       v2 := View new.
       v2 origin:0.5@0.0 corner:1.0@0.5.
       v2 leftInset:5.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1.
       top add:v2.

       top open
									[exEnd]

    using layout objects (ST-80 style):
    fully specifying the frame
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v2 := View new.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1 in:(LayoutFrame new
			leftFraction:0.25;
			rightFraction:0.75;
			topFraction:0.0;
			bottomFraction:0.5).
       top add:v2 in:(LayoutFrame new
			leftFraction:0.5;
			rightFraction:1.0;
			topFraction:0.5;
			bottomFraction:0.75).

       top open
									[exEnd]

    another one, with offsets:
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v2 := View new.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1 in:(LayoutFrame new
			leftFraction:0.0 offset:10;
			rightFraction:1.0 offset:-10;
			topFraction:0.0 offset:10;
			bottomFraction:0.5).
       top add:v2 in:(LayoutFrame new
			leftFraction:0.0 offset:30;
			rightFraction:1.0 offset:-30;
			topFraction:0.5 offset:10;
			bottomFraction:0.75).

       top open
									[exEnd]

    specifying origin only. Extent is views preferred
    (notice, that plain views have some defaultExtent of 100@100)
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       v2 := View new.

       v1 viewBackground:(Color red).
       v2 viewBackground:(Color yellow).

       top add:v1 in:(LayoutOrigin new
			leftFraction:0.25;
			topFraction:0.0).
       top add:v2 in:(LayoutOrigin new
			leftFraction:0.5;
			topFraction:0.5).

       top open
									[exEnd]

    same example, using buttons which compute their preferredBounds:
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := Button label:'foo'.
       v2 := Button label:'a very long buttonLabel'.

       v1 backgroundColor:(Color red).
       v2 backgroundColor:(Color yellow).

       top add:v1 in:(LayoutOrigin new
			leftFraction:0.25;
			topFraction:0.0).
       top add:v2 in:(LayoutOrigin new
			leftFraction:0.5;
			topFraction:0.5).

       top open
									[exEnd]

    border:
									[exBegin]
       |top v1 v2|

       top := StandardSystemView new.
       top extent:300@300.

       v1 := View new.
       top add:v1 in:(10@10 corner: 30@30).
       v2 := View new.
       top add:v2 in:(30@30 corner: 50@50).

       v1 border:(SimpleBorder width:1 color:Color red).
       v2 border:(SimpleBorder width:1 color:Color blue).
       top open
									[exEnd]
"
!

examples_MDI
"
    Currently, these are experimental and work under Windows only

    an MDI child:
									[exBegin]
	|top v1 v2|

	top := StandardSystemView new.
	top extent:450 @ 300.
	top name:'MDI Client'.
	top beMDIClientView.
	top open.

	v1 := View new.
	v1 viewBackground:Color red.
	v1 origin:50 @ 50 corner:150 @ 100.
	v1 beMDIChildView.
	top addSubView:v1.

	v2 := View new.
	v2 viewBackground:Color green.
	v2 origin:50 @ 50 corner:150 @ 100.
	v2 beMDIChildView.
	top addSubView:v2.
									[exEnd]
"
!

layoutComputation
"
    Due to historic reasons, there are 2 mechanisms to resize a view:
        - (old, to be eliminated mechanism)
            based upon info found in
                relativeOrigin / relativeCorner / relativeExtent
                originRule / cornerRule / extentRule

        - (new, will migrate to that one)
            letting a layoutObject compute things

    Actually, the old mechanism is just as powerful, as the new (layoutObject
    based) mechanism; with the help of block=rules, you can compute whatever
    geometry is desired.
    However, having 6 instance variables in every view creates some overhead,
    which can be avoided in most cases (most views are either fixed-size or
    relative-sized).
    Therefore (and also to make porting of ST-80 apps easier), ST/X will migrate
    to use layoutObjects.
    You will not see a difference at the view's protocol level, since
    existing interfaces will (silently) create layoutObjects as appropriate.
    However, you should remove all direct accesses to the above mentioned
    instance variables, to be prepared for that change.

    Notice, that a view recomputes its size whenever its superview
    changes size. This is done via:
        sizeChanged
            -> allSubviews: superViewChangedSize

    If the geometry computation as performed in superViewChangedSize
    is not powerful enough for your application, you can either:
        - redefine superViewChangedSize
        - create a special layoutObject which computes a new layout.
"
!

popupMenus
"
    Due to historic reasons, there are multiple mechanisms for popupMenu
    definition:

	- static menus

	- dynamic menus from the view

	- dynamic menus from the model / menuHolder


    static menus
    ------------

    The easiest to use is a static menu; this is useful, if some view
    has a constant menu which never changes.
    It can be defined at initialization time or redefined any time later.
    The menu is defined with:

	someView middleButtonMenu:<aPopUpMenu>

    Compatibility note:
	static menus should no longer be used - their operation
	is incompatible with ST-80 and ST/X's dynamic menus.
	Do not use them if you care for compatibility.
    Also, they do not care for any menuPerformers or menuHolders.
    (instead, they use a receiver instance variable, which gets the messages).

    example:
	|top v1 v2|

	top := StandardSystemView new.
	top extent:300@300.

	v1 := View origin:0.0@0.0 corner:0.5@1.0 in:top.
	v1 viewBackground:Color red.

	v2 := View origin:0.5@0.0 corner:1.0@1.0 in:top.
	v2 viewBackground:Color yellow.

	v1 middleButtonMenu:(
				PopUpMenu
				   labels:#('foo' 'bar')
				   selectors:#(foo bar)
				   receiver:v1
			    ).

	top open.



    dynamic menus
    -------------

    A dynamic menu can be provided by the view itself, or by the model.
    In addition, TextViews allow a separate menuHolder to provide the menu
    (i.e. it may be different from the model).
    If the model shall provide the menu, set the view's menuMessage to a selector
    which is sent to the model. This message should return a popUpMenu.

    For textViews, the above is also valid, except if the menuHolder is explicitely
    set - in this case, that one provides the menu; not the model.
    Don't get confused by the fact that menuHolders are only supported
    by textViews.

    example: (in your application, the plug would be your application, topView or model)
    Notice, that all menu messages are sent to the view (because no model was set)
    - so the textView still performs the copy-function correctly
    (but of course, does not respond to the fooBar messages).
    If a model was set, the menu would try the model first, but send its messages
    to the view IFF the model would not respond to the menu message.
    (this allows mixing of menu messages for the view AND the model).

	|top v1 v2 holder|

	holder := Plug new.
	holder respondTo:#menu1
		    with:[
			    v1 menuMessage:#otherMenu1.
			    PopUpMenu
				labels:#('foo' 'bar')
				selectors:#(foo bar).
			 ].
	holder respondTo:#otherMenu1
		    with:[
			    v1 menuMessage:#menu1.
			    PopUpMenu
				labels:#('other foo' 'other bar')
				selectors:#(foo bar).
			 ].
	holder respondTo:#menu2
		    with:[  PopUpMenu
				labels:#('copy' 'bar2')
				selectors:#(copySelection bar2)
			 ].

	top := StandardSystemView new.
	top extent:300@300.

	v1 := View origin:0.0@0.0 corner:0.5@1.0 in:top.
	v1 viewBackground:Color red.

	v2 := TextView origin:0.5@0.0 corner:1.0@1.0 in:top.
	v2 contents:'pop me up'.

	v1 model:holder; menuMessage:#menu1.
	v2 menuHolder:holder; menuMessage:#menu2.

	top open.

    an additional goody is the possibility, to change the menuPerformer (textViews only).
    If defined, that one will get the menus message (instead of the model/view).
    However, like above, if it does not respond to the message, its still sent to
    the view. Notice, that with non-textViews, the menuPerformer is always the model.

    example:
    (Notice: the executor understands the #copySelection message - therefore, the
     views built-in copy is NOT performed
     - it could be forwarded to the view, though.
     This could be useful to intercept/filter things).

	|top v menuProvider menuExecutor |

	menuProvider := Plug new.
	menuProvider respondTo:#menu
		    with:[  PopUpMenu
				labels:#('copy' 'foo')
				selectors:#(copySelection foo)
			 ].

	menuExecutor := Plug new.
	menuExecutor respondTo:#copySelection
			   with:[Transcript showCR:'copy function'].
	menuExecutor respondTo:#foo
			   with:[Transcript showCR:'foo function'].

	top := StandardSystemView new.
	top extent:300@300.

	v := TextView origin:0.0@0.0 corner:1.0@1.0 in:top.
	v contents:'pop me up'.

	v menuHolder:menuProvider; menuMessage:#menu.
	v menuPerformer:menuExecutor.

	top open.
"

! !

!SimpleView class methodsFor:'initialization'!

initialize
    DefaultStyle isNil ifTrue:[
	Font initialize.
	Form initialize.
	Color initialize.
    ].
    self == SimpleView ifTrue:[
	Smalltalk addDependent:self   "/ to get language changes
    ].

    ReturnFocusWhenClosingModalBoxes := true. "/ false.

    FlagOriginChanged                   := 2r00000000000001.
    FlagExtentChanged                   := 2r00000000000010.
    FlagCornerChanged                   := 2r00000000000100.

    FlagCanTab                          := 2r00000000001000.
    FlagExtentChangedBeforeCreated      := 2r00000000010000.
    FlagRequestFocusOnPointerEnter      := 2r00000000100000.
    FlagDoNotRequestFocusOnPointerEnter := 2r00000001000000.
    FlagNativeWidget                    := 2r00000010000000.
    FlagIsUnmappedModalBox              := 2r00000100000000.
    FlagIsMDIChild                      := 2r00001000000000.

    FlagHiddenOnRealize                 := 2r00010000000000.
    FlagHasExplicitExtent               := 2r00100000000000.
    FlagTakeFocusWhenMapped             := 2r01000000000000.
    FlagBeingDestroyed                  := 2r10000000000000.

    "Modified: / 09-12-2010 / 10:32:01 / cg"
!

postAutoload
    (Screen notNil and:[Screen current notNil]) ifTrue:[
	self updateStyleCache.
    ]
! !

!SimpleView class methodsFor:'instance creation'!

extent:extent
    "create a new view with given extent"

    ^ self origin:nil extent:extent borderWidth:nil font:nil label:nil in:nil
!

extent:extent in:aView
    "create a new view as a subview of aView with given extent"

    ^ self origin:nil extent:extent borderWidth:nil font:nil label:nil in:aView
!

extent:extent label:label
    "create a new view with given extent and label"

    ^ self origin:nil extent:extent borderWidth:nil font:nil label:label in:nil
!

in:aView
    "return a new view as a subview of aView.
     If aView is nil, it is left unspecified, in which superview
     the new view will be placed. The view can later be assigned
     by adding it to the superview via #addSubView:.
     If its later realized and no superview has ever been set,
     it will come up as a topview."

    |newView viewsDevice|

    newView := self basicNew.
    aView notNil ifTrue:[
        viewsDevice := aView graphicsDevice.
"/      newView container:aView.
    ].
    viewsDevice isNil ifTrue:[
        viewsDevice := Screen current
    ].
    newView initializeForDevice:viewsDevice.
    (viewsDevice supportsNativeWidgetType:newView nativeWindowType) ifTrue:[
        newView beNativeWidget
    ].
    aView notNil ifTrue:[aView addSubView:newView].
    ^ newView

    "Modified: 28.5.1996 / 20:24:58 / cg"
!

label:label
    "create a new view with given label"

    ^ self origin:nil extent:nil borderWidth:nil font:nil label:label in:nil
!

label:label in:aView
    "create a new view as subview of aView with given label"

    ^ self origin:nil extent:nil borderWidth:nil font:nil label:label in:aView
!

model:aModel
    "st-80 style view creation: create a new view and set its model.
     Notice, that simpleViews do not understand #model:; however,
     subclasses may."

    ^ self new model:aModel

    "Created: 28.2.1997 / 19:27:40 / cg"
    "Modified: 28.2.1997 / 19:28:12 / cg"
!

on:aModel
    "create a new drawable on aModel"

    "although this one does not know about models,
     it can still send the model-assign message. This was done
     to catch obsolete calls to on:aDevice.
    "
    ^ self new model:aModel.
!

onSameDeviceAs:anotherView
    "create a view on the same device as anotherView.
     Used with popUpMenus, which should be created on the device of
     its masterView."

    |viewsDevice|

    anotherView notNil ifTrue:[
	viewsDevice := anotherView graphicsDevice.
    ] ifFalse:[
	viewsDevice := Screen current.
    ].
    ^ self onDevice:viewsDevice

    "Modified: 28.5.1996 / 20:25:05 / cg"
!

origin:origin corner:corner
    "create a new view with given origin and extent"

    ^ self origin:origin corner:corner borderWidth:nil font:nil label:nil in:nil
!

origin:anOrigin corner:aCorner borderWidth:bw font:aFont label:aLabel in:aView
    |newView|

    newView := self in:aView.
    bw notNil ifTrue:[newView borderWidth:bw].
    anOrigin notNil ifTrue:[newView origin:anOrigin].
    aCorner notNil ifTrue:[newView corner:aCorner].
    aFont notNil ifTrue:[newView font:aFont].
    aLabel notNil ifTrue:[newView label:aLabel].
    ^ newView

    "Modified: 28.5.1996 / 20:25:15 / cg"
!

origin:origin corner:corner borderWidth:bw in:aView
    "create a new view as a subview of aView with given origin and extent"

    ^ self origin:origin corner:corner borderWidth:bw font:nil label:nil in:aView
!

origin:origin corner:corner in:aView
    "create a new view as a subview of aView with given origin and extent"

    ^ self origin:origin corner:corner borderWidth:nil font:nil label:nil in:aView
!

origin:origin extent:extent
    "create a new view with given origin and extent"

    ^ self origin:origin extent:extent borderWidth:nil font:nil label:nil in:nil
!

origin:origin extent:extent borderWidth:bw
    "create a new view with given origin, extent and borderWidth"

    ^ self origin:origin extent:extent borderWidth:bw font:nil label:nil in:nil
!

origin:anOrigin extent:anExtent borderWidth:bw font:aFont label:aLabel in:aView
    |newView|

    newView := self in:aView.
    bw notNil ifTrue:[newView borderWidth:bw].
    anExtent notNil ifTrue:[newView extent:anExtent].
    anOrigin notNil ifTrue:[newView origin:anOrigin].
    aFont notNil ifTrue:[newView font:aFont].
    aLabel notNil ifTrue:[newView label:aLabel].
    ^ newView

    "Modified: 28.5.1996 / 20:25:19 / cg"
!

origin:origin extent:extent borderWidth:bw in:aView
    "create a new view as a subview of aView with given origin, extent
     and borderWidth"

    ^ self origin:origin extent:extent borderWidth:bw font:nil label:nil in:aView
!

origin:origin extent:extent font:aFont label:label
    ^ self origin:origin extent:extent borderWidth:nil font:nil label:label in:nil
!

origin:origin extent:extent font:aFont label:label in:aView
    ^ self origin:origin extent:extent borderWidth:nil font:aFont label:label in:aView
!

origin:origin extent:extent in:aView
    "create a new view as a subview of aView with given origin and extent"

    ^ self origin:origin extent:extent borderWidth:nil font:nil label:nil in:aView
!

origin:origin extent:extent label:label
    "create a new view with given origin, extent and label"

    ^ self origin:origin extent:extent borderWidth:nil font:nil label:label in:nil
!

origin:anOrigin extent:anExtent
		label:aLabel icon:aForm
		minExtent:minExtent maxExtent:maxExtent
    |newView|

    newView := self new. "/ onDevice:Screen current.
    anOrigin notNil ifTrue:[newView origin:anOrigin].
    anExtent notNil ifTrue:[newView extent:anExtent].
    aLabel notNil ifTrue:[newView label:aLabel].
    aForm notNil ifTrue:[newView icon:aForm].
    minExtent notNil ifTrue:[newView minExtent:minExtent].
    maxExtent notNil ifTrue:[newView maxExtent:maxExtent].
    ^ newView
!

origin:origin in:aView
    "create a new view as a subview of aView with given origin"

    ^ self origin:origin extent:nil borderWidth:nil font:nil label:nil in:aView
! !

!SimpleView class methodsFor:'Signal constants'!

aboutToOpenBoxNotificationSignal
    "the following allows for knowledgable programmers to suppress dialog boxes,
     (by proceeding with #abort) or to patch common controls right before opening..."

    ^ AboutToOpenBoxNotificationSignal

    "Modified: / 27-01-2011 / 17:35:00 / cg"
!

boxClosedNotificationSignal
    "the following allows for knowledgable programmers to handle closed dialog boxes,
     this is raised right after closing..."

    ^ BoxClosedNotificationSignal
! !

!SimpleView class methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == Smalltalk ifTrue:[
	(something == #Language or:[something == #LanguageTerritory]) ifTrue:[
	    "flush resources on language changes"
	    self flushAllClassResources.
	    self allSubInstancesDo:[:eachView | eachView languageChanged].
	].
    ]

    "Created: 15.6.1996 / 15:23:04 / cg"
! !

!SimpleView class methodsFor:'defaults'!

defaultBackgroundColor
    "return the default background color for drawing - usually,
     that is the same as the viewBackgroundColor."

    ^ self defaultViewBackgroundColor

    "
     View defaultBackgroundColor
    "

    "Modified: 13.8.1997 / 19:37:55 / cg"
!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    CentPoint isNil ifTrue:[CentPoint := 100 @ 100].
    ^ CentPoint

    "Modified: 22.4.1996 / 23:38:39 / cg"
!

defaultFont
    |f|

    DefaultFont notNil ifTrue:[^ DefaultFont].

    self == SimpleView ifTrue:[
	f := super defaultFont
    ] ifFalse:[
	f := self superclass defaultFont.
    ].

    f notNil ifTrue:[
	DefaultFont := f.
	f := f onDevice:Screen current.
	f notNil ifTrue:[
	    DefaultFont := f.
	]
    ].
    ^ DefaultFont

    "Modified: 27.2.1996 / 02:20:54 / cg"
!

defaultFont:aFont
    "set the default font used for drawing"

    |f|

    DefaultFont := aFont.
    aFont notNil ifTrue:[
	Display notNil ifTrue:[
	    f := aFont onDevice:(Screen current).
	    f notNil ifTrue:[
		DefaultFont := f.
	    ]
	]
    ]

    "Modified: 18.3.1996 / 12:56:20 / cg"
!

defaultStyle
    "return the default view style"

    ^ DefaultStyle

    "
     View defaultStyle
    "
!

defaultStyle:aStyle
    "set the view style for new views"

    DefaultStyle := aStyle.

    MIMETypeIconLibrary notNil ifTrue:[
	MIMETypeIconLibrary flushIcons
    ].

    "/ no need to read the stylesheet always here
    "/ done later if the system is not already up and running
    "/ (which is the case, if there is already a styleSheet)
    "/ this will make startup of expecco and similar applications
    "/ faster, because often, they find that another instance is already
    "/ running and they simply forward the request to that one.
    "/ no need to read the stylesheet, then.
    "/ used to be unconditional, before.
    StyleSheet notNil ifTrue:[
	(Screen notNil and:[Screen current notNil]) ifTrue:[
	    self readStyleSheetAndUpdateAllStyleCaches.
	].
    ].

    "
     View defaultStyle:#next. SystemBrowser start
     View defaultStyle:#motif. SystemBrowser start
     View defaultStyle:#iris. SystemBrowser start
     View defaultStyle:#st80. SystemBrowser start
     View defaultStyle:#normal. SystemBrowser start
    "

    "Modified: / 05-02-2011 / 15:26:34 / cg"
!

defaultViewBackgroundColor
    "return the default view background"

    ^ DefaultViewBackgroundColor

    "
     View defaultViewBackgroundColor
    "

    "Modified: 13.8.1997 / 19:37:55 / cg"
!

readStyleSheet
    "(re)load the styleSheet."

    |iconLibraryClass |

    DefaultStyle isNil ifTrue:[
	self setDefaultStyle
    ].

    StyleSheet := ViewStyle fromFile:(DefaultStyle , '.style').
    StyleSheet fileReadFailed ifTrue:[
	('SimpleView [warning]: ***** no styleSheet for ' , DefaultStyle , '-style.') errorPrintCR.
	DefaultStyle ~~ #normal ifTrue:[
	    DefaultStyle := #normal.
	    StyleSheet := ViewStyle fromFile:(DefaultStyle , '.style').

	    StyleSheet fileReadFailed ifTrue:[
		'SimpleView [warning]: not even a styleSheet for normal-style (using ugly defaults).' errorPrintCR.
	    ]
	]
    ].

    iconLibraryClass := StyleSheet at:#ToolbarIconLibrary.
    ToolbarIconLibrary := iconLibraryClass ? GenericToolbarIconLibrary.

    "Created: / 15.9.1998 / 22:03:06 / cg"
!

readStyleSheetAndUpdateAllStyleCaches
    "reload all style caches in all view classes.
     Needed after a style change or when a style file has been changed"

    DefaultStyle notNil ifTrue:[
	self readStyleSheet.
	self updateAllStyleCaches.
    ].

    "Created: / 15.9.1998 / 22:03:59 / cg"
!

returnFocusWhenClosingModalBoxes
    "return the current focus-return behavior.
     See #returnFocusWhenClosingModalBoxes: for a description."

    ^ ReturnFocusWhenClosingModalBoxes
!

returnFocusWhenClosingModalBoxes:aBoolean
    "control the keyboard-focus behavior when a modal dialog
     is closed. The default (true) is to return the focus to the view
     which was active when the dialog was opened.
     If false, it is left up to the display to set the focus.
     For owm / ovwm (which requires an explicit click for the focus),
     it is better to return the focus automatically.
     For managers which assign the focus according the pointer position,
     it may be better to turn the focus-return off.
     You should add a corresponding expression into your private.rc or
     display.rc file."

    ReturnFocusWhenClosingModalBoxes := aBoolean

    "
     Dialog returnFocusWhenClosingModalBoxes:false
     Dialog returnFocusWhenClosingModalBoxes:true
    "
!

setDefaultStyle
    "set a default style as appropriate for the underlying system.
     This is used if no setting is coming from a startup file or a preferences,
     i.e. for standalone apps (with no .rc file)"

    |defStyle|

    true "DefaultStyle isNil" ifTrue:[
        defStyle := OperatingSystem getEnvironment:'STX_VIEWSTYLE'.
        defStyle isNil ifTrue:[
            defStyle := UserPreferences current viewStyle
        ].
        defStyle notNil ifTrue:[
            DefaultStyle := defStyle asSymbol.
        ] ifFalse:[
            "/ use XP for both linux and older windows systems;
            DefaultStyle := ViewStyle msWindowsXP.

            OperatingSystem isMSWINDOWSlike ifTrue:[
                "/ use Vista for vista and newer systems;
                OperatingSystem isVistaLike ifTrue:[
                    DefaultStyle := ViewStyle msWindowsVista.
                    OperatingSystem isWin8Like ifTrue:[
                        "/ use win8 for 8 and newer systems;
                        DefaultStyle := ViewStyle msWindows8
                    ].
                ].
            ] ifFalse:[
                OperatingSystem isOSXlike ifTrue:[
                    DefaultStyle := ViewStyle macosx_yosemite
                ] ifFalse:[
                    DefaultStyle := ViewStyle adwaita
                ]
            ].
        ].
    ].

    "Modified: / 24-11-2016 / 18:00:43 / cg"
!

styleSheet
    "return the view style sheet information (a dictionary)"

    StyleSheet isNil ifTrue:[
	self updateAllStyleCaches.
    ].
    ^ StyleSheet

    "
     View styleSheet
    "

    "Modified: 9.1.1997 / 13:47:42 / cg"
!

styleSheet:aViewStyle
    "set the view style from a style-sheet"

    StyleSheet := aViewStyle.
    DefaultStyle := (StyleSheet at:'name' ifAbsent:'unknown') asSymbol.
    self updateAllStyleCaches.
!

updateAllStyleCaches
    "reload all style caches in all view classes.
     Needed after a style change or when a style file has been changed"

    (Screen isNil or:[Screen current isNil]) ifTrue:[^ self].

    "
     Don't do anything when restarting from a snapshot. Otherwuse
     all fonts and so on got reset to defaults which is what we
     DON'T want. If the font is not available, then font ioself 
     should pick a proper replacement.
    "
    Smalltalk isRestarting ifTrue:[ ^ self ].
    "
     Tell all view classes to flush any
     cached style-data
    "
    self changed:#style.
    SimpleView updateStyleCache.
    SimpleView allSubclassesDo:[:aClass |
        aClass defaultFont:nil.
	(aClass class includesSelector:#updateStyleCache) ifTrue:[
	    aClass updateStyleCache
	].
    ].

    "/ use #at: to avoid introducing a depency to libview2
    (Smalltalk at:#MIMETypeIconLibrary) notNil ifTrue:[
	(Smalltalk at:#MIMETypeIconLibrary) flushIcons
    ].


    "
     View updateAllStyleCaches
    "

    "Modified: / 15-09-1998 / 22:04:15 / cg"
    "Modified (format): / 05-10-2011 / 16:08:47 / az"
    "Modified: / 20-04-2016 / 08:46:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateStyleCache
    "this method gets some heavily used style stuff and keeps
     it in class-variables for faster access.
     Subclasses should redefine this to load any cached style-values
     into faster class variables as well. These should NOT do a
     super updateStyleCache, since this method is called for all view-classes
     anyway."

    <resource: #style (#viewSpacing #font #borderWidth #borderColor
		       #viewBackground #shadowColor #lightColor
		       #focusColor #focusBorderWidth)>

    |styleSheet bgGrey currentScreen|

    styleSheet := StyleSheet.

    "
     when coming here the first time, we read the styleSheet
     and keep the values in fast class variables
    "
    styleSheet isNil ifTrue:[
	self setDefaultStyle.
	self readStyleSheet.
	styleSheet := StyleSheet.
    ].

    currentScreen := Screen current ? Screen default.

    Grey := styleSheet viewGrey.
    Grey isNil ifTrue:[
	Grey := Color gray
    ].
    Grey := Grey onDevice:currentScreen.

    styleSheet fileReadFailed ifTrue:[
	bgGrey := Color white
    ] ifFalse:[
	currentScreen hasGrayscales ifTrue:[
	    bgGrey := Grey
	] ifFalse:[
	    bgGrey := Color white.
	]
    ].
    bgGrey := bgGrey onDevice:currentScreen.

    ViewSpacing := styleSheet at:#viewSpacing.
    ViewSpacing isNil ifTrue:[
	ViewSpacing := currentScreen defaultStyleValueFor:#viewSpacing.
    ].

    DefaultBorderColor := styleSheet colorAt:#borderColor.
    DefaultBorderColor isNil ifTrue:[
	DefaultBorderColor := currentScreen defaultStyleValueFor:#borderColor
    ].

    styleSheet fileReadFailed ifTrue:[
	DefaultBorderWidth := 1.
	DefaultFocusColor := DefaultShadowColor := Color black.
	DefaultViewBackgroundColor := DefaultLightColor :=  Color white.
	DefaultFocusBorderWidth := 1.
    ] ifFalse:[
	DefaultBorderWidth := styleSheet at:#borderWidth default:0.
	DefaultViewBackgroundColor := styleSheet colorAt:#viewBackground default:bgGrey.
	DefaultShadowColor := styleSheet colorAt:#shadowColor.
	DefaultLightColor := styleSheet colorAt:#lightColor.
	DefaultFocusColor := styleSheet colorAt:#focusColor default:Color red.
	DefaultFocusBorderWidth := styleSheet at:'focusBorderWidth' default:2.
    ].

    self == SimpleView ifTrue:[
	DefaultFont := styleSheet at:#font.
	DefaultFont isNil ifTrue:[
	    DefaultFont := Font family:'courier' face:'medium' style:'roman' size:12.
	].
	DefaultFont := DefaultFont onDevice:currentScreen.
    ] ifFalse:[
	DefaultFont := nil
    ].

    DefaultViewBackgroundColor isNil ifTrue:[
	'SimpleView [warning]: bad viewBackground in style - using white' errorPrintCR.
	DefaultViewBackgroundColor := Color white
    ].

    "Modified: / 29-04-1997 / 11:16:52 / dq"
    "Modified: / 20-12-2010 / 14:40:22 / cg"
!

viewSpacing
    "return a convenient number of pixels used to separate views (usually 1mm).
     Having this value here at a common place makes certain that all views
     get a common look"

    ^ ViewSpacing
! !


!SimpleView class methodsFor:'resources'!

classResources
    "if not already loaded, get the classes resourcePack and return it"

    ClassResources isNil ifTrue:[
	ClassResources := super classResources.
    ].
    ^ ClassResources
!

classResources:aResourcePack
    "allow setting of the classResources"

    ClassResources := aResourcePack
!

flushAllClassResources
    "flush all classes resource translations.
     Needed after a resource file has changed."

    ResourcePack flushCachedResourcePacks.
    SimpleView withAllSubclassesDo:[:aClass |
	aClass flushClassResources.
    ]

    "
     View flushAllClassResources
    "
    "to change the language:
	Language := #en.
	Smalltalk changed:#Language.
	View flushAllClassResources
     or:
	Language := #de.
	Smalltalk changed:#Language.
	View flushAllClassResources
    "
!

flushClassResources
    "flush classes resource string translations.
     Needed whenever a resource file or language has changed"

    ClassResources := nil.
!

resources
    "return the view's resources -
     that's a ResourcePack containing national language strings"

    ^ self classResources

    "Created: / 25.5.1998 / 13:00:30 / cg"
!

updateClassResources
    "flush classes resource string translations and reload them.
     Needed whenever a resource file or language has changed"

    ClassResources := nil.
    self classResources
! !

!SimpleView class methodsFor:'startup'!

open
    "create, realize the view - this topview and all its subviews will
     run as a separate process with its own windowGroup"

    ^ self new open
!

openOnXScreenNamed:aScreenName
    "create an instance of the view and open it
     on some X display screen. The argument aScreenName must be
     a valid x-display name (i.e. of the form '<host>:<screenNr>' as in 'foo:0').
     For more info, read the document on multiple display
     support and the documentation of the DeviceWorkstation class."

    |newDevice|

    (XWorkstation notNil and:[ XWorkstation isLoaded ]) ifFalse:[
        self warn:'Could not open display (no XWorkstation class)'.
        ^ self
    ].    
    
    [
        newDevice := XWorkstation newDispatchingFor:aScreenName.
    ] on:Screen deviceOpenErrorSignal do:[:ex|
        self warn:'Could not open display: ' , aScreenName.
        ^ self
    ].
    ^ (self onDevice:newDevice) open.

    "
     FileBrowser openOnXScreenNamed:'bitsy:0'
     FileBrowser openOnXScreenNamed:':0'
     View openOnXScreenNamed:'bitsy:0'
    "

    "Modified: 13.1.1997 / 20:55:27 / cg"
! !

!SimpleView methodsFor:'Compatibility-ST80'!

checkForEvents
    "ST-80 compatibility:
     check for any pending events and process them"

    (shown and:[windowGroup notNil]) ifTrue:[windowGroup processEvents].

    "Modified: 10.1.1997 / 19:46:06 / cg"
!

closeAndUnschedule
    "actually sent to a controller in VW...
     however, #open returns the view in ST/X, so we respond here"

    self topView destroy
!

displayOn:aGCOrStream
    "ST-80 compatibility: (re-)display myself"

    "/ what a kludge - Dolphin and Squeak mean: printOn:;
    "/ ST/X (and some old ST80's) mean: draw-yourself on.
    (aGCOrStream isStream) ifTrue:[
	^ super displayOn:aGCOrStream
    ].
    self redraw

    "Created: 4.6.1996 / 21:25:59 / cg"
    "Modified: 10.1.1997 / 19:46:58 / cg"
!

displayPendingInvalidation
    "dummy - for ST-80 compatibility"

    "Created: 6.3.1997 / 15:17:14 / cg"
    "Modified: 6.3.1997 / 15:17:31 / cg"
!

invalidateRectangle:aRectangle repairNow:doRepairNow
    self invalidate:aRectangle repairNow:doRepairNow
!

isEnabled
    "return true, if this view is enabled (i.e. accepts user interaction).
     Most views are enabled - only a few (buttons, SelectionInList etc.) can
     be disabled.
     #isEnabled is ST-80's equivalent of #enabled"

    ^ self enabled
!

isOpen
    "ST80 compatibility"

    ^ realized


!

lookPreferences:prefs
    "ignored - but required for some apps"

    "Created: / 19.6.1998 / 00:05:10 / cg"
!

newLayout:aLayoutObject
    "set the layout object which controls my geometry.
     ST80-compatibility."

    here layout:aLayoutObject.

    "Created: 3.3.1997 / 18:54:53 / cg"
!

refresh
    self invalidate
!

takeKeyboardFocus
    self requestFocus
! !

!SimpleView methodsFor:'Compatibility-Squeak'!

insetDisplayBox
    "Squeak mimicri: return my bounds"

    ^ 0@0 corner:(self corner)

! !

!SimpleView methodsFor:'accessing'!

automationUUID
    ^ self uuid

    "Created: / 17-11-2017 / 11:37:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

automationUUID: anUUID
    self uuid: anUUID

    "Created: / 17-11-2017 / 11:42:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

client:anApplicationModel
    "release existing components and generate new components from
     the applications windowSpec.
     ATTENTION: this is a low level interface; postBuild is NOT invoked"

    ^ self client:anApplicationModel spec:#windowSpec


!

client:anApplication spec:aWindowSpecOrSelector
    "release existing components and generate new components from
     the applications windowSpec.
     ATTENTION: this is a low level interface; postBuild is NOT invoked"

    ^ self client:anApplication spec:aWindowSpecOrSelector builder:nil

!

client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder
    "release existing components and generate new components from
     the given windowSpec, using the given builder."

    self client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder withMenu:false
!

client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder withMenu:withMenuBoolean
    "release existing components and generate new components from
     the given windowSpec, using the given builder.
     ATTENTION: this is a low level interface.
     TODO: this code is so ugly and badly designed - it must be redesigned
     or at least well documented."

    |builder subSpec isApplicationModel thisApp savedView masterApp thisIsANewBuild|

    aWindowSpecOrSpecSymbol isNil ifTrue:[^ self].

    isApplicationModel := true.

    (builder := aBuilder) isNil ifTrue:[
	"/ problem: anApplication could have no builder
	"/          or anApplication could be a non-appModel (theoretically - only providing a spec)
	builder := anApplication perform:#builder ifNotUnderstood:[isApplicationModel := false. nil].
	builder isNil ifTrue:[
	    isApplicationModel ifTrue:[
		anApplication createBuilder.
		builder := anApplication builder
	    ] ifFalse:[
		builder := UIBuilder new.
	    ]
	]
    ].

    (subSpec := aWindowSpecOrSpecSymbol) isSymbol ifTrue:[
	anApplication isNil ifTrue:[^ self].
	subSpec := anApplication interfaceSpecFor:aWindowSpecOrSpecSymbol.
	subSpec isNil ifTrue:[
	    ^ self
	].
    ].

    "/ if the appl is not the master, but the masters builder is used,
    "/ we have to temporarily change the builders window

    masterApp := anApplication perform:#masterApplication ifNotUnderstood:[isApplicationModel := false. nil].
    masterApp isNil ifTrue:[
	isApplicationModel := false.
    ].
    thisApp := builder application.
    (isApplicationModel and:[anApplication ~~ thisApp]) ifTrue:[
	masterApp ~~ thisApp ifTrue:[
	    self error:'should not happen' mayProceed:true.
	    masterApp isNil ifTrue:[
		anApplication masterApplication:thisApp.
	    ].
	].

	builder application:anApplication.
	savedView := builder window.
	builder window:self.
	[
	    anApplication buildSubCanvas:subSpec withMenu:withMenuBoolean withBuilder:builder.
	] ensure:[
	    builder window:savedView.
	    builder application:thisApp.
	].
    ] ifFalse:[
	thisIsANewBuild := builder window isNil.
	thisIsANewBuild ifTrue:[
	    builder window:self.
	    anApplication buildSubCanvas:subSpec withMenu:withMenuBoolean withBuilder:builder.
	] ifFalse:[
	    "/ WARNING: in case of rebuilding, we do NOT invoke pre- and postBuilds
	    builder buildFromSpec:subSpec in:self.
	]
    ].

"/    postBuildWith: will be called twice if code below is enabled
"/    notAnAppModel isNil ifTrue:[
"/        notAnAppModel := (anApplication isKindOf:ApplicationModel) not
"/    ].
"/    notAnAppModel ifTrue:[
"/        builder buildFromSpec:subSpec in:self.
"/    ] ifFalse:[
"/        savedView := builder window.
"/        builder window:self.
"/        [
"/            anApplication buildSubCanvas:subSpec withBuilder:builder.
"/        ] ensure:[
"/            savedView notNil ifTrue:[
"/                builder window:savedView.
"/            ]
"/        ].
"/    ].
!

helpKey
    "The helpKey (symbol) or nil.
     This can be set programatically, in views which are constructed
     'by hand' - i.e. not va the UI painter.
     When constructed from a UI-spec, this key is typically specified there
     (however, special apps may change it dynamically, if a component changes
      its semantic meaning dynamically)"
     
    ^ helpKey
!

helpKey:aSymbolOrNil
    "The helpKey (symbol) or nil.
     This can be set programatically, in views which are constructed
     'by hand' - i.e. not va the UI painter.
     When constructed from a UI-spec, this key is typically specified there
     (however, special apps may change it dynamically, if a component changes
      its semantic meaning dynamically)"

    helpKey := aSymbolOrNil.
!

keyboardMap
    "Return a KeyboardMap used to translate symbolic shortcuts to real key combinations.

     By default, use my parent's map or my device's default map if view has no parent.

     However, subclasses may redefine this, to return their own keyboard map (for example 
     a terminalView may want treat CTRL-C as regular key)."

    superView notNil ifTrue:[
        ^ superView keyboardMap
    ].
    ^ device keyboardMap

    "Created: / 01-02-2017 / 23:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyboardProcessor
    "return my keyboard processor.
     If non-nil, that one gets a chance to intercept and deal with things like
     escape or return in modal boxes."

    ^ nil

    "Created: / 13.2.1999 / 10:31:39 / cg"
! !


!SimpleView methodsFor:'accessing-behavior'!

disable
   "alternative method; redirected to basic mechanism"

   self enabled:false

    "Modified: / 30.3.1999 / 14:47:30 / stefan"
    "Created: / 30.3.1999 / 15:54:11 / stefan"
!

enable
   "alternative method; redirected to basic mechanism"

   self enabled:true

    "Modified: / 30.3.1999 / 14:47:22 / stefan"
    "Created: / 30.3.1999 / 15:54:16 / stefan"
!

enabled
   "views are enabled by default"

   ^ true

    "Modified: / 30.3.1999 / 16:27:57 / stefan"
!

enabled:bool
   "this is the basic machanism to enable/disable a view.
    empty in this class; may be redefined by subclasses"

    "Modified: / 30.3.1999 / 14:46:24 / stefan"
    "Created: / 30.3.1999 / 15:54:21 / stefan"
!

isEnabled:aState
    "ST-80 compatibility; set enabled state
    "
    self enabled:aState

    "Created: / 30.3.1999 / 15:54:29 / stefan"
!

preferFirstInputFieldWhenAssigningInitialFocus
    "define the focus behavior for dialogs.
     If true is returned, input fields take precedence over other keyboard consumers.
     This used to return true, but the behavior is somewhat ugly."

    ^ false

    "Created: / 29-08-2006 / 14:28:54 / cg"
!

readOnly:aBoolean
    "ignored here; present for compatibility with some textView subclasses,
     so that UIPainter can handle it in its TextView spec (which contains a
     readOnly field)"
! !

!SimpleView methodsFor:'accessing-bg & border'!

allSubViewsBackground:something
    "set the viewBackground to something, a color, image or form,
     recursively in all of my subviews"

    self allSubViewsBackground:something if:[:v |true]
!

allSubViewsBackground:something if:condition
    "set the viewBackground to something, a color, image or form,
     recursively in all of my subviews"

    subViews notNil ifTrue:[
	subViews do:[:v|
	    v allViewBackground:something if:condition
	]
    ]

    "Modified: / 18.7.1996 / 13:34:26 / cg"
    "Created: / 31.10.2000 / 13:06:02 / bg"
!

allSubViewsForeground:something
    "set the foreground to something, a color, image or form,
     recursively in all of my subviews"

    subViews notNil ifTrue:[
	subViews do:[:v|
	    v allViewForeground:something
	]
    ]
!

allViewBackground:something
    "set the viewBackground to something, a color, image or form,
     in myself and recursively in all of my subviews"

    self allViewBackground:something if:[:v |true]
!

allViewBackground:something if:condition
    "set the viewBackground to something, a color, image or form,
     in myself and recursively in all of my subviews"

    self viewBackground:something if:condition.
    self allSubViewsBackground:something if:condition
!

allViewForeground:something
    "set the foreground to something, a color, image or form,
     in myself and recursively in all of my subviews"

    self foregroundColor:something.
    self allSubViewsForeground:something

    "Modified: / 31.10.2000 / 13:06:17 / bg"
!

backgroundColor
    "return the background color of the contents -
     here, (since there is no contents), the viewBackground is returned."

    ^ self viewBackground

    "Modified: / 3.5.1997 / 10:28:04 / cg"
    "Created: / 18.6.1998 / 15:59:36 / cg"
!

backgroundColor:aColor
    "set the background color of the contents -
     here, (since there is no contents), the viewBackground is changed."

    self viewBackground:aColor.
    shown ifTrue:[
	self clear; invalidate.
    ].

    "Created: 3.5.1997 / 10:26:49 / cg"
    "Modified: 3.5.1997 / 10:28:04 / cg"
!

border
    "return my border"

    (superView notNil and:[superView isBorderedWrapper]) ifTrue:[
	^ superView border
    ].

    ^ border
!

border:aBorder
    "set my border"

    |prevMargin m|

    prevMargin := margin.
    border := aBorder.
    self computeMargin.
    realized ifTrue:[
	m := prevMargin max:margin.
	self invalidate:(0@0 corner:width@m).               "/ top margin
	self invalidate:((width-m)@m corner:width@height).  "/ right margin
	self invalidate:(0@(height-m) corner:width@height). "/ bottom margin
	self invalidate:(0@m corner:m@(height-m)).          "/ left margin
    ].
!

borderColor
    "return my borderColor"

    |clr|

    (superView notNil and:[superView isBorderedWrapper]) ifTrue:[
	^ superView borderColor
    ].

    "/ ^ borderColor
    border notNil ifTrue:[
	clr := border color
    ].
    clr isNil ifTrue:[
	^ self blackColor
    ].
    ^ clr.

    "Modified: 5.6.1996 / 14:11:44 / cg"
!

borderColor:aColor
    "set my borderColor"

    "/ backward compatibility
    "/ superView will be renamed to container soon.
    (superView notNil and:[superView isBorderedWrapper]) ifTrue:[
	superView borderColor:aColor.
	^ self
    ].

    aColor isNil ifTrue:[
	border isNil ifTrue:[^ self].
	self border:nil.
    ] ifFalse:[
	aColor = (self borderColor) ifTrue:[^ self].
	self border:(SimpleBorder new width:(self borderWidth) color:aColor)
    ].
    self invalidate.

"/    (aColor ~~ borderColor) ifTrue:[
"/        borderColor := aColor.
"/        drawableId notNil ifTrue:[
"/            self setBorderColor
"/        ]
"/    ]

    "Modified: 5.6.1996 / 14:11:50 / cg"
    "Modified: 23.10.2009 / 14:11:50 / cg"
!

borderShape:aForm
    "set the borderShape to aForm"

    aForm isNil ifTrue:[
	viewShape := nil.
	self drawableId notNil ifTrue:[
	    device setWindowBorderShape:nil in:self drawableId
	]
    ] ifFalse:[
	viewShape isNil ifTrue:[
	    viewShape := ArbitraryViewShape new
	].
	viewShape borderShapeForm:aForm.
	self drawableId notNil ifTrue:[
	    device setWindowBorderShape:(aForm id) in:self drawableId
	]
    ]

    "Modified: 18.9.1997 / 11:09:40 / cg"
!

borderWidth
    "return my borderWidth"

    (superView notNil and:[superView isBorderedWrapper]) ifTrue:[
	^ superView borderWidth
    ].

    border isNil ifTrue:[^ 0].
    ^ border width ? 0

    "Modified: 5.6.1996 / 14:11:57 / cg"
    "Modified: 23.10.2009 / 14:11:50 / cg"
!

borderWidth:aNumberOrNil
    "set my borderWidth"
    |aNumber|

    aNumber := aNumberOrNil.
    aNumber notNil ifTrue:[
	self assert:(aNumber >= 0).
	aNumber := aNumber max: 0
    ].

    "/ backward compatibility
    "/ superView will be renamed to container soon.
    (superView notNil and:[superView isBorderedWrapper]) ifTrue:[
	^ superView borderWidth:aNumber
    ].

    (aNumber == 0 or:[aNumber isNil]) ifTrue:[
	border isNil ifTrue:[^ self].
	self border:nil.
    ] ifFalse:[
	border notNil ifTrue:[
	    self border:(border copy width:aNumber)
	] ifFalse:[
	    self border:(SimpleBorder new width:aNumber color:(self borderColor)).
	]
    ].

"/    (aNumber ~~ borderWidth) ifTrue:[
"/        borderWidth := aNumber.
"/        drawableId notNil ifTrue:[
"/            self setBorderWidth.
"/        ]
"/    ]

    "Modified: 5.6.1996 / 14:12:05 / cg"
!

computeMargin
    border isNil ifTrue:[
	margin := level abs.
	^ self.
    ].
    margin := border width.
!

fillFormWithBorderShape:aForm
    "fill aForm with my borderShape"

    aForm fillRectangle:(Rectangle origin:self origin corner:self corner).
!

foregroundColor
    "return the foreground color of the contents -
     here, (since there is no contents), some default is returned."

    ^ self blackColor

    "Modified: / 3.5.1997 / 10:28:04 / cg"
    "Created: / 18.6.1998 / 16:57:33 / cg"
!

foregroundColor:aColor
    "set the foreground color of the contents -
     ignored here, since there is no contents."
!

foregroundColor:fgColor backgroundColor:bgColor
    "set both the foreground and background colors of the contents"

    self
	foregroundColor:fgColor;
	backgroundColor:bgColor
!

level
    "return my level relative to superView (3D)"

    (superView notNil and:[superView isBorderedWrapper]) ifTrue:[
	^ superView level
    ].
    border notNil ifTrue:[^ border level].
    ^ level

    "Modified: 5.6.1996 / 14:12:10 / cg"
!

level:aNumber
    "set my level relative to superView (3D)"

    |oldMargin how|

    "/ backward compatibility
    "/ superView will be renamed to container soon.
    (superView notNil and:[superView isBorderedWrapper]) ifTrue:[
	^ superView level:aNumber
    ].

    (aNumber ~~ level and:[aNumber notNil]) ifTrue:[
	self is3D ifTrue:[
	    level := aNumber.
	    oldMargin := margin.
	    margin := level abs.

	    realized ifTrue:[
		margin ~~ oldMargin ifTrue:[
		    (margin > oldMargin) ifTrue:[
			how := #smaller
		    ] ifFalse:[
			how := #larger
		    ].
		    self sizeChanged:how.
		    self setInnerClip.
		].
		shown ifTrue:[
		    margin ~~ oldMargin ifTrue:[
			self clearView.
			self redrawX:margin y:margin
			       width:width-(margin*2)
			      height:height-(margin*2)
		    ].
		    self redrawEdges.
	       ]
	    ]
	]
    ]

    "Modified: 5.6.1996 / 14:12:17 / cg"
!

lightColor
    "return the color to be used for lighted edges (3D only)"

    lightColor isNil ifTrue:[
	|avgColor|
        
	avgColor := viewBackground averageColorIn:(0@0 corner:7@7).
	lightColor := avgColor lightened.
    ].
    ^ lightColor
!

lightColor:aColorOrImage
    "set the color to be used for lighted edges (3D only)"

    lightColor := aColorOrImage
!

margin
    "return my inner margin - this is usually the level,
     but can be more for some views
     (textViews which add more margin between the border and the text)"

    ^ margin

    "Modified: 5.6.1996 / 14:37:54 / cg"
!

setBorderWidth
    "set my borderWidth in the devices physical view"

"/    |bw|
"/
"/    bw := borderWidth.
"/    (device supportsWindowBorder:bw) ifFalse:[
"/        bw > 1 ifTrue:[
"/            (device supportsWindowBorder:(bw := 1)) ifFalse:[
"/                ^ self
"/            ].
"/        ]
"/    ].
"/
"/    drawableId notNil ifTrue:[
"/        device setWindowBorderWidth:bw in:drawableId
"/    ]
!

setBorderWidth:aNumber
    "set my borderWidth without affecting the real view (private only)"

    "/ borderWidth := aNumber
    self borderWidth:aNumber
!

shadowColor
    "return the color to be used for shadowed edges (3D only)"

    shadowColor isNil ifTrue:[
	|avgColor|

	avgColor := viewBackground averageColorIn:(0@0 corner:7@7).
	shadowColor := avgColor darkened.
    ].
    ^ shadowColor
!

shadowColor:aColorOrImage
    "set the color to be used for shadowed edges (3D only)"

    shadowColor := aColorOrImage
!

viewBackground:something
    "set the viewBackground to something, a color, image or form.
     If its a color and we run on a color display, also set shadow and light
     colors - this means, that a red view will get light-red and dark-red
     edges."

    |avgColor|

    "/ debug check only:
    self assert:(something notNil) message:'invalid viewBackground argument'.

    something isColor ifTrue:[
        (device notNil and:[device hasGrayscales]) ifTrue:[
            avgColor := something averageColorIn:(0@0 corner:7@7).
            shadowColor := avgColor darkened "on:device".
            lightColor := avgColor lightened "on:device".
        ]
    ].
    super viewBackground:something

    "Modified: 4.7.1997 / 20:09:22 / cg"
!

viewBackground:something if:condition
    "set the viewBackground to something, a color, image or form,
     in myself and recursively in all of my subviews"

    (condition value:self) ifTrue:[
	viewBackground ~~ something ifTrue:[
	    self viewBackground:something.
	    self invalidate
	].
    ].
!

viewShape:aForm
    "set the viewShape to aForm"

    aForm isNil ifTrue:[
	viewShape := nil.
	self drawableId notNil ifTrue:[
	    device setWindowShape:nil in:self drawableId
	]
    ] ifFalse:[
	viewShape isNil ifTrue:[
	    viewShape := ArbitraryViewShape new
	].

	viewShape viewShapeForm:aForm.
	self drawableId notNil ifTrue:[
	    device setWindowShape:(aForm id) in:self drawableId
	]
    ]

    "Modified: 18.9.1997 / 11:11:04 / cg"
! !

!SimpleView methodsFor:'accessing-channels'!

setupChannel:newChannel for:changeSelector withOld:oldChannel
    "common code to change a channel.
     If changeSelector is non-nil, arrange for it to be sent when
     the channel changes its value; otherwise, arrange for a simple update.
     This is so common, that it's worth a helper method:
     release any old channel (if non-nil),
     arrange for changeSelector (or #update) to be sent for the new channel."

    |oldValue|

    oldChannel == newChannel ifTrue:[^ self].

    oldChannel notNil ifTrue:[
        changeSelector isNil ifTrue:[
            oldChannel removeDependent:self
        ] ifFalse:[
            oldChannel retractInterestsFor:self.
        ].
        oldValue := oldChannel value.
    ].
    newChannel notNil ifTrue:[
        changeSelector isNil ifTrue:[
            newChannel addDependent:self.
            newChannel value ~~ oldValue ifTrue:[
                self update:#value with:nil from:newChannel.
            ]
        ] ifFalse:[
            newChannel onChangeSend:changeSelector to:self.
            newChannel value ~~ oldValue ifTrue:[
                self perform:changeSelector.
            ]
        ]
    ].

    ^ newChannel

    "Modified: / 31.10.1997 / 14:47:21 / cg"
! !

!SimpleView methodsFor:'accessing-contents'!

heightOfContents
    "return the height of the contents in logical units
     - defaults to view's visible area here.
    This method MUST be redefined in all view classess which are
    going to be scrolled AND show data which has different size than
    the view. For example, a view showing A4-size documents should return
    the number of vertical pixels such a document has on this device.
    A view showing a bitmap of height 1000 should return 1000.
    If not redefined, scrollbars have no way of knowing the actual size
    of the contents being shown. This is called by scrollBars to compute
    the relative height of the document vs. the views actual size.
    The value returned here must be based on a scale of 1, since users
    of this will scale as appropriate."

    ^ (self innerHeight max:(self maxSubViewBottom)) max:self maxComponentBottom

    "Modified: 26.5.1996 / 12:44:21 / cg"
!

heightOfContentsDependsOnWidth
    "a very special which is only used by the scrollableView,
     to check if it should NOT automatically hide scrollbars, when the
     pointer leaves the view.
     Currently, there are only a small number of views which return true here,
     one being the HTML view, which rearranges its text depending on the width,
     and therefore, it is a bad idea to hide/show scrollbars dynamically"
     
    ^ false  
!

widthOfContents
    "return the width of the contents in logical units
     - defaults to views visible area here.
    This method MUST be redefined in all view classess which are
    going to be scrolled AND show data which has different size than
    the view. For example, a view showing A4-size documents should return
    the number of horizontal pixels such a document has on this device.
    A view showing a bitmap of width 500 should return 500.
    If not redefined, scrollbars have no way of knowing the actual size
    of the contents being shown. This is called by scrollBars to compute
    the relative width of the document vs. the view's actual width.
    The value returned here must be based on a scale of 1, since users
    of this will scale as appropriate."

    ^ (self innerWidth max:(self maxSubViewRight)) max:self maxComponentRight

    "Modified: 26.5.1996 / 13:02:50 / cg"
!

widthOfContentsDependsOnHeight
    "a very special query which is only used by the scrollableView,
     to check if it should NOT automatically hide scrollbars, when the
     pointer leaves the view.
     Currently, there is no view, which returns true
     (maybe if we ever support chinese writing top to bottom..."
     
    ^ false  
! !

!SimpleView methodsFor:'accessing-dimensions'!

allInset:aNumber
    "set all insets; positive makes the view smaller,
     negative makes it larger..
     Obsolete: please use a layout object."

    insets isNil ifTrue:[
	insets := Array new:4.
    ].
    insets atAllPut:aNumber.

    "force recomputation"
"/    drawableId isNil ifTrue:[
"/        self originChangedFlag:true
"/    ] ifFalse:[
	self containerChangedSize.
"/    ]

    "Modified: 19.7.1996 / 17:30:18 / cg"
!

bottom
    "return the y position of the actual bottom edge (in pixels)"

    ^ top + height - 1
!

bottom:aNumber
    "set the corners y position"

    self corner:(self corner x @ aNumber)
!

bottomInset
    "return the inset of the bottom edge; positive is to the top,
     negative to the bottom.
     Obsolete: please use a layout object."

    insets isNil ifTrue:[^ 0].
    ^ insets at:4
!

bottomInset:aNumber
    "set the inset of the bottom edge;
     positive is to the top (view becomes smaller),
     negative to the bottom (becomes larger).
     Obsolete: please use a layout object."

    |newInset|

    insets isNil ifTrue:[
	insets := Array with:0 with:0 with:0 with:0
    ].
    newInset := aNumber.
    newInset isNil ifTrue:[
	newInset := 0.
    ].
    (insets at:4) ~= newInset ifTrue:[
	insets at:4 put:newInset.
	self containerChangedSize
    ]

    "Modified: 19.7.1996 / 17:30:22 / cg"
!

bounds
    "ST-80 compatibility: return my bounds"

    ^ (self origin) corner:(self corner)

    "Created: 4.6.1996 / 21:23:27 / cg"
    "Modified: 10.1.1997 / 19:46:21 / cg"
!

bounds:aRectangle
    "ST-80 compatibility: change my bounds"

    self explicitExtent:true.
    self pixelOrigin:aRectangle origin
	      corner:aRectangle corner

    "Created: 4.6.1996 / 21:44:27 / cg"
    "Modified: 10.1.1997 / 19:46:36 / cg"
!

center
    "return the point at the center of the receiver (in pixels)"

    ^ (left + (width // 2)) @ (top + (height // 2))
!

center:newCenter
    "move the receiver so that newCenter, aPoint becomes the center point"

    self origin:(newCenter - ((width // 2) @ (height // 2)))
!

computeCorner
    "compute my corner; if I have a layoutObject,
     relative origins or blocks to evaluate, compute it now ..
     Blocks may return relative values or nil; nil means: take current value.
     Returns the corner point in device coordinates (pixels)."

    |org newCorner newExt x y|

    "
     slowly migrating to use layoutObjects ...
    "
    layout notNil ifTrue:[
	superView isNil ifTrue:[^ self preferredBounds corner].
	^ (layout rectangleRelativeTo:(superView viewRectangle)
			    preferred:[self preferredBounds]) corner rounded
    ].

    (cornerRule notNil) ifTrue:[
	newCorner := cornerRule value.
	"
	 allow return of relative values ...
	"
	x := newCorner x.
	y := newCorner y.
	x isNil ifTrue:[x := self corner x].
	y isNil ifTrue:[y := self corner y].
	((x isInteger not) or:[y isInteger not]) ifTrue:[
	    newCorner := self cornerFromRelativeCorner:x@y
	]
    ] ifFalse:[
	(relativeCorner notNil) ifTrue:[
	    newCorner := self cornerFromRelativeCorner:relativeCorner
	] ifFalse:[
	    org := self computeOrigin.
	    (extentRule notNil) ifTrue:[
		newExt := extentRule value
	    ] ifFalse:[
		(relativeExtent notNil) ifTrue:[
		    newExt := self extentFromRelativeExtent:relativeExtent
		] ifFalse:[
		    newExt := self extent.
		]
	    ].
	    newCorner := org + newExt
	]
    ].
    ^ newCorner

    "Modified: 28.2.1997 / 10:33:39 / cg"
!

computeExtent
    "compute my extent; if I have a layoutObject, a relative extent
     or blocks to evaluate, compute it now ..
     There is one catch here, if the dimension was defined
     by origin/corner, compute them here and take that value.
     I.e. origin/corner definition has precedence over extent definition.
     Returns the extent in device coordinates (pixels)."

    |newOrg newExt newCorner x y|

    "
     slowly migrating to use layoutObjects ...
    "
    layout notNil ifTrue:[
	^ (layout rectangleRelativeTo:(superView viewRectangle)
			    preferred:[self preferredBounds]) extent rounded
    ].

    (cornerRule notNil) ifTrue:[
	newCorner := cornerRule value.
	"
	 allow return of relative values ...
	"
	x := newCorner x.
	y := newCorner y.
	x isNil ifTrue:[x := self corner x].
	y isNil ifTrue:[y := self corner y].
	((x isInteger not) or:[y isInteger not]) ifTrue:[
	    newCorner := self cornerFromRelativeCorner:x@y
	]
    ] ifFalse:[
	(relativeCorner notNil) ifTrue:[
	    newCorner := self cornerFromRelativeCorner:relativeCorner
	] ifFalse:[
	    (extentRule notNil) ifTrue:[
		newExt := extentRule value.
		"
		 allow return of relative values ...
		"
		x := newExt x.
		y := newExt y.
		x isNil ifTrue:[x := width].
		y isNil ifTrue:[y := height].
		((x isInteger not) or:[y isInteger not]) ifTrue:[
		    newExt := self extentFromRelativeExtent:x@y
		]
	    ] ifFalse:[
		(relativeExtent notNil) ifTrue:[
		    newExt := self extentFromRelativeExtent:relativeExtent
		] ifFalse:[
		    newExt := (width @ height).
		].
	    ].
	].
    ].

    newCorner notNil ifTrue:[
	newOrg := self computeOrigin.
	^ newCorner - newOrg.
    ].
    ^ newExt.
!

computeOrigin
    "compute my origin; if I have a layoutObject, a relative origin
     or blocks to evaluate, compute it now ..
     Blocks may return relative values or nil; nil means: take current value.
     Returns the origin point in device coordinates (pixels)."

    |newOrg x y|

    "
     slowly migrating to use layoutObjects ...
    "
    layout notNil ifTrue:[
	superView isNil ifTrue:[^ 0@0].
	^ (layout rectangleRelativeTo:(superView viewRectangle)
			    preferred:[self preferredBounds]) origin rounded
    ].

    (originRule notNil) ifTrue:[
	newOrg := originRule value.
	"
	 allow return of relative values ...
	"
	x := newOrg x.
	y := newOrg y.
	x isNil ifTrue:[x := self origin x].
	y isNil ifTrue:[y := self origin y].
	((x isInteger not) or:[y isInteger not]) ifTrue:[
	    newOrg := self originFromRelativeOrigin:x@y.
	]
    ] ifFalse:[
	(relativeOrigin notNil) ifTrue:[
	    newOrg := self originFromRelativeOrigin:relativeOrigin.
	] ifFalse:[
	    ^ (left @ top).
	].
    ].
    ^ newOrg
!

corner
    "return the lower right corner-point (in pixels)"

"/    ^ (left + width "- 1") @ (top + height "- 1")
    ^ (left + width - 1) @ (top + height - 1)

    "Modified: 31.8.1995 / 16:51:40 / claus"
!

corner:corner
    "set the view's corner;
     the corner argument may be:
         a point
            where integer fields mean 'pixel-values'
            and float values mean 'relative-to-superview'
            and nil means 'take current value';
     or a block returning a point which is interpreted as above.
     Please migrate to use layoutObjects, if possible."

    |x y pixelCorner c|

    self explicitExtent:true.

    corner isBlock ifTrue:[
        cornerRule := corner.
        self drawableId notNil ifTrue:[
            pixelCorner := corner value
        ] ifFalse:[
            self extentChangedFlag:true
        ]
    ] ifFalse:[
        x := corner x.
        y := corner y.
        x isNil ifTrue:[x := self corner x].
        y isNil ifTrue:[y := self corner y].
        c := x @ y.
        ((x isInteger not) or:[y isInteger not]) ifTrue:[
            relativeCorner := c.
            pixelCorner := self cornerFromRelativeCorner.
            pixelCorner isNil ifTrue:[
                self extentChangedFlag:true
            ]
        ] ifFalse:[
            pixelCorner := c
        ]
    ].

    pixelCorner notNil ifTrue:[
        self pixelCorner:pixelCorner
    ]

    "Modified: 15.7.1996 / 09:51:06 / cg"
!

cornerRule
    "return the corner block - non public; this will vanish without notice"

    ^ cornerRule
!

extent:extent
    "set the view's extent;
     extent may be:
        a point
            where integer fields mean 'pixel-values'
            and float values mean 'relative-to-superview'
            and nil means 'leave current value';
     or a block returning a point which is interpreted as above.
     Be careful when using relative extents: rounding errors may
     accumulate. Better use origin/corner.
     Best: migrate to use layour objects.

     Notice: this sets the views explicitExtent flag, which prevents it normally
             from resizing itself to its preferredExtent.
             See initialExtent: for a variation."

    |w h pixelExtent e|

    self explicitExtent:true.

    extent isBlock ifTrue:[
        extentRule := extent.
        self drawableId notNil ifTrue:[
            pixelExtent := extent value
        ] ifFalse:[
            self extentChangedFlag:true
        ]
    ] ifFalse:[
        extentRule := nil.
        w := extent x.
        h := extent y.
        w isNil ifTrue:[w := width].
        h isNil ifTrue:[h := height].
        e := w@h.
        ((w isInteger not) or:[h isInteger not]) ifTrue:[
            "/ w > 1 ifTrue:[self halt].
            relativeExtent := e.
            pixelExtent := self extentFromRelativeExtent.
            pixelExtent isNil ifTrue:[
                self extentChangedFlag:true
            ]
        ] ifFalse:[
            relativeExtent := nil.
            pixelExtent := e
        ]
    ].
    pixelExtent notNil ifTrue:[
        self pixelExtent:pixelExtent
    ]

    "Modified: / 07-07-2010 / 16:44:57 / cg"
!

extentRule
    "return the extent block - non public; this will vanish without notice"

    ^ extentRule
!

frame
    "compatibility with displayObjects: returns my bounds"

    ^ self bounds
!

geometryLayout
    "this method will vanish, as soon as all implementations of
     #layout: are removed ...
     (conflict for example in label>>layout:).
     DO NOT USE #geometryLayout: in your code; it will be removed without
     notice."

    ^ here layout
!

geometryLayout:aLayoutObject
    "this method will vanish, as soon as all implementations of
     #layout: are removed ...
     (conflict for example in label>>layout:).
     DO NOT USE #geometryLayout: in your code; it will be removed without
     notice."

    here layout:aLayoutObject
!

hasExplicitExtent
    "/ ^ explicitExtent.
    ^ flagBits bitTest:FlagHasExplicitExtent.
!

height:aNumber
    "set the view's height in pixels"

    "/ check: the following leads to an error in the notebook...
"/    aNumber isInteger ifTrue:[
"/        height := aNumber.
"/    ] ifFalse:[
        self extent:(width @ aNumber)
"/    ].

    "Modified: / 02-02-2011 / 12:16:44 / cg"
!

heightIncludingBorder
    "return my height including border
     (this is my height as seen from the outside view;
      while #height returns the height as seen by myself)"

    ^ height + (2*self borderWidth)
!

horizontalInset:aNumber
    "set the insets of the left/right edge;
     positive makes it smaller, negative makes it larger.
     Obsolete: please use a layout object."

    |newInset|

    insets isNil ifTrue:[
	insets := Array with:0 with:0 with:0 with:0
    ].
    newInset := aNumber.
    aNumber isNil ifTrue:[
	newInset := 0.
    ].
    insets at:1 put:newInset.
    insets at:3 put:newInset.

    "force recomputation"
"/    drawableId isNil ifTrue:[
"/        self originChangedFlag:true
"/    ] ifFalse:[
	self containerChangedSize.
"/    ]

    "Modified: / 30-09-2006 / 15:19:28 / cg"
!

initialExtent:extent
    "set the view's extent, but don't change its explicitExtent setting.
     a variant of #extent."

    |expl|

    expl := self hasExplicitExtent.
    self extent:extent.
    self explicitExtent:expl
!

initialHeight:aNumber
    "set the view's height in pixels, but don't change its explicitExtent setting"

    self initialExtent:(width @ aNumber)
!

initialWidth:aNumber
    "set the view's width in pixels, but don't change its explicitExtent setting"

    self initialExtent:(aNumber @ height)
!

innerHeight
    "return the height of the view minus any 3D-shadow-borders"

    (margin == 0) ifTrue:[^ height].
    ^ height - (2 * margin)
!

innerHeight:pixels
    "set the height of the view plus any 3D-shadow-borders.
     This does not work with a relative size."

    ^ self height:( pixels + (margin + self innerVerticalMargin * 2) ).
!

innerHorizontalMargin
    "return any additional inner margin (i.e. contents margin).
     This should be redefined by views which do add margins
     (for example: textViews do this)"

    ^ 0
!

innerVerticalMargin
    "return any additional inner margin (i.e. contents margin).
     This should be redefined by views which do add margins
     (for example: textViews do this)"

    ^ 0
!

innerWidth
    "return the width of the view minus any 3D-shadow-borders"

    (level == 0) ifTrue:[^ width].
    ^ width - (2 * margin)
!

innerWidth:pixels
    "set the width of the view plus any 3D-shadow-borders.
     This does not work with a relative size."

    ^ self width:( pixels + (margin + self innerHorizontalMargin * 2) ).
!

inset:aNumber
    "set all insets; positive makes the view smaller,
     negative makes it larger..
     Obsolete: please use a layout object."

    self allInset:aNumber
!

layout
    "return the layout object which controls my geometry.
     Currently, this is nil in most cases, and my geometry is
     defined by relativeOrigin/relativeCorner/relativeExtent,
     originRule/extentRule/cornerRule and inset.
     Applications should be changed to use layoutObjects,
     since the above listed instance variables will vanish."

    ^ layout
!

layout:aLayoutObject
    "set the layout object which controls my geometry."

    layout ~= aLayoutObject ifTrue:[
	layout := aLayoutObject.
	self layoutChanged.
    ].

    "Modified: 19.9.1995 / 16:17:25 / claus"
    "Modified: 19.7.1996 / 17:30:27 / cg"
!

layoutChanged
    superView isNil ifTrue:[
	self originChangedFlag:true extentChangedFlag:true cornerChangedFlag:true.
    ] ifFalse:[
	self containerChangedSize.
    ]

    "Modified: 19.9.1995 / 16:17:25 / claus"
    "Modified: 19.7.1996 / 17:30:27 / cg"
!

left
    "return the x position of the left border (in pixels)"

    ^ left
!

left:aNumber
    "set the x position"

    self origin:(aNumber @ top)
!

left:newLeft top:newTop width:newWidth height:newHeight
    "another way of specifying origin and extent"

    self origin:(newLeft @ newTop) extent:(newWidth @ newHeight)
!

leftInset
    "return the inset of the left edge; positive is to the right,
     negative to the left.
     Obsolete: please use a layout object."

    insets isNil ifTrue:[^ 0].
    ^ insets at:1
!

leftInset:aNumber
    "set the inset of the left edge;
     positive is to the right (view becomes smaller),
     negative to the left (becomes larger).
     Obsolete: please use a layout object."

    |newInset|

    insets isNil ifTrue:[
	insets := Array with:0 with:0 with:0 with:0
    ].
    newInset := aNumber.
    newInset isNil ifTrue:[
	newInset := 0.
    ].
    (insets at:1) ~= newInset ifTrue:[
	insets at:1 put:newInset.
	self containerChangedSize.
    ]

    "Modified: 19.7.1996 / 17:30:30 / cg"
!

makeFullyVisible
    "make sure, that the view is fully visible by shifting it
     into the visible screen area if nescessary."

    |myDevice originVisible cornerVisible newTop newLeft deviceBounds
     deviceLeft deviceRight deviceTop deviceBottom origin corner
     referencePoint|

    myDevice := device.

    newTop := top.
    newLeft := left.

    origin := left@top.
    corner := (left + width)@(top + height).

    originVisible := myDevice pointIsVisible:origin.
    cornerVisible := myDevice pointIsVisible:corner.

    (myDevice pointsAreOnSameMonitor:origin and:corner) ifTrue:[
	referencePoint := origin.
    ] ifFalse:[
	originVisible ifTrue:[
	    "origin is visible"
	    referencePoint := origin.
	] ifFalse:[
	    cornerVisible notNil ifTrue:[
		"corner is visible"
		referencePoint := corner.
	    ] ifFalse:[
		referencePoint := 1@1.
	    ].
	].
    ].
    deviceBounds := myDevice monitorBoundsAt:referencePoint.

    deviceLeft := deviceBounds left.
    deviceRight := deviceBounds right.
    deviceTop := deviceBounds top.
    deviceBottom := deviceBounds bottom.

    originVisible ifTrue:[ deviceBottom := deviceBottom min:(myDevice usableHeightAt:origin) ].
    cornerVisible ifTrue:[ deviceBottom := deviceBottom min:(myDevice usableHeightAt:corner) ].

    corner y > deviceBottom ifTrue:[
	cornerVisible := false.
    ].

    UserPreferences current forceWindowsIntoMonitorBounds ifFalse:[
	(originVisible and:[cornerVisible]) ifTrue:[^ self].
    ].

    "/ deviceRight := deviceRight min:device usableWidth.
    originVisible ifFalse:[
	cornerVisible ifFalse:[
	    newTop := deviceBottom - height.
	    newLeft := deviceRight - width.
	    newLeft := newLeft max:deviceLeft.
	    newTop := newTop max:deviceTop.
	] ifTrue:[
	    "/ origin is not; corner is in
	    newLeft := (deviceLeft max:newLeft).
	    newTop := (deviceTop max:newTop).
	].
    ] ifTrue:[
	"/ notice, the position-dependent query: if there is a higher secondary screen,
	"/ this makes a difference in where a popUpMenu is allowed...
	(corner y > deviceBottom) ifTrue:[
	    newTop := deviceBottom - height
	].
	(corner x > deviceRight) ifTrue:[
	    newLeft := deviceRight - width
	].
	newLeft := newLeft max:deviceLeft.
	newTop := newTop max:deviceTop.
    ].

    ((newTop ~~ top) or:[newLeft ~~ left]) ifTrue:[
	self origin:newLeft @ newTop
    ].

    "Modified: / 27-10-2012 / 13:15:58 / cg"
!

makeRoundViewShapeWithBorder:bw
    "setup my window for a round shaped view;
     this is not supported by all devices"

    self makeRoundViewShapeWithBorder:bw opaque:true.

!

makeRoundViewShapeWithBorder:bw opaque:opaque
    "setup my window for a round shaped view;
     this is not supported by all devices"

    |extent shapeForm borderForm w h f lw|

"/    device supportsRoundShapedViews ifTrue:[
"/        "/ TODO: add code for round shaped view (mswin)
"/    ].

    device supportsArbitraryShapedViews ifTrue:[
	extent := self extent.
	w := extent x.
	h := extent y.
	borderForm := Form extent:extent.
	shapeForm  := Form extent:extent.

	borderForm fillArcX:0 y:0
		  width:w
		 height:h
		   from:0
		  angle:360.

	opaque ifFalse:[
	    f := borderForm.
	    borderForm foreground:(Color colorId:0).
	] ifTrue:[
	    f := shapeForm.
	    shapeForm foreground:(Color colorId:1).
	].

	f fillArcX:(lw := gc lineWidth) y:lw
		width:w - (bw * 2)
	       height:h - (bw * 2)
		 from:0
		angle:360.

	self borderShape:borderForm.
	self viewShape:shapeForm.
	^ self.

"/
"/        extent := self extent.
"/
"/        w := extent x.
"/        h := extent y.
"/        borderForm := Form width:w height:h.
"/        "/        borderForm fill:(Color colorId:0).
"/
"/        shapeForm := Form width:w height:h.
"/        "/        shapeForm fill:(Color colorId:0).
"/
"/        borderForm foreground:(Color colorId:1).
"/        borderForm
"/            fillArcX:0 y:0
"/            width:w
"/            height:h
"/            from:0
"/            angle:360.
"/
"/        opaque ifFalse:[
"/            f := borderForm.
"/            borderForm foreground:(Color colorId:0).
"/        ] ifTrue:[
"/            f := shapeForm.
"/            shapeForm foreground:(Color colorId:1).
"/        ].
"/        f
"/            fillArcX:bw y:bw
"/            width:(w - (bw * 2))
"/            height:(h - (bw * 2))
"/            from:0
"/            angle:360.
"/
"/        self borderShape:borderForm.
"/        self viewShape:shapeForm
    ]
!

makeTransparentRectangularViewShapeWithBorder:bw
    "setup my window for a rectangluar transparent shaped view;
     this is not supported by all devices"

    |extent shapeForm borderForm w h f|

"/    device supportsPolygonShapedViews ifTrue:[
"/        "/ TODO: add code for mswin
"/    ].

    device supportsArbitraryShapedViews ifTrue:[
	extent := self extent.
	w := extent x.
	h := extent y.
	borderForm := Form extent:extent.
	shapeForm  := Form extent:extent.

	borderForm
	    fillRectangleX:0 y:0
	    width:w
	    height:h.

	f := borderForm.
	borderForm foreground:(Color colorId:0).

	borderForm
	    fillRectangleX:bw y:bw
	    width:w - (bw * 2)
	    height:h - (bw * 2).

	self borderShape:borderForm.
	self viewShape:shapeForm.
	^ self.
    ]
!

maxExtent
    ^ self getAttribute:#maxExtent.
!

maxExtent:aPoint
    ^ self setAttribute:#maxExtent to:aPoint.
!

minExtent
    ^ self getAttribute:#minExtent.
!

minExtent:aPoint
    ^ self setAttribute:#minExtent to:aPoint.
!

origin
    "return the origin (in pixels)"

    ^ left@top
!

origin:origin
    "set the view's origin;
     origin may be:
        a point
            where integer fields mean 'pixel-values'
            and float values mean 'relative-to-superview'
            and nil means 'take current value';
     or a block returning a point which is interpreted as above.
     Please migrate to use layout objects."

    |newLeft newTop pixelOrigin o|

    origin isBlock ifTrue:[
        originRule := origin.
        self drawableId notNil ifTrue:[
            pixelOrigin := origin value
        ] ifFalse:[
            self originChangedFlag:true
        ]
    ] ifFalse:[
        o := origin.
        newLeft := origin x.
        newTop := origin y.
        newLeft isNil ifTrue:[newLeft := left].
        newTop isNil ifTrue:[newTop := top].
        o := newLeft @ newTop.
        ((newLeft isInteger not) or:[newTop isInteger not]) ifTrue:[
            relativeOrigin := o.
            pixelOrigin := self originFromRelativeOrigin.
            pixelOrigin isNil ifTrue:[
                self originChangedFlag:true
            ]
        ] ifFalse:[
            relativeOrigin := nil.
            pixelOrigin := o
        ]
    ].
    pixelOrigin notNil ifTrue:[
        self pixelOrigin:pixelOrigin
    ].

    "Modified: 19.4.1996 / 15:12:36 / cg"
!

origin:origin corner:corner
    "set both origin and extent"

    |newLeft newTop newRight newBot|

    self explicitExtent:true.

    "do it as one operation if possible"

    origin isBlock ifFalse:[
	corner isBlock ifFalse:[
	    newLeft := origin x.
	    newLeft isInteger ifTrue:[
		newTop := origin y.
		newTop isInteger ifTrue:[
		    newRight := corner x.
		    newRight isInteger ifTrue:[
			newBot := corner y.
			newBot isInteger ifTrue:[
			    self pixelOrigin:origin corner:corner
			]
		    ]
		]
	    ]
	]
    ].
    self origin:origin.
    self corner:corner

    "Modified: 15.7.1996 / 09:52:43 / cg"
!

origin:origin extent:extent
    "set both origin and extent"

    |newLeft newTop newWidth newHeight|

    self explicitExtent:true.

    "do it as one operation if possible"

    origin isBlock ifFalse:[
	extent isBlock ifFalse:[
	    newLeft := origin x.
	    newLeft isInteger ifTrue:[
		newTop := origin y.
		newTop isInteger ifTrue:[
		    newWidth := extent x.
		    newWidth isInteger ifTrue:[
			newHeight := extent y.
			newHeight isInteger ifTrue:[
			    self pixelOrigin:origin extent:extent
			]
		    ]
		]
	    ]
	]
    ].
    self extent:extent.
    self origin:origin

    "Modified: 15.7.1996 / 09:52:39 / cg"
!

originRelativeTo:aView
    "return the origin (in pixels) relative to a superView,
     or relative to the rootView (if the aView argument is nil).
     If the receiver is nonNil and not a subview of aView, return nil."

    |currentView
     bw   "{ Class: SmallInteger }"
     sumX "{ Class: SmallInteger }"
     sumY "{ Class: SmallInteger }" |

    currentView := self.
    sumX := 0.
    sumY := 0.
    [currentView notNil] whileTrue:[
	(currentView == aView) ifTrue:[
	    ^ (sumX @ sumY)
	].
	bw := currentView borderWidth.
	sumX := sumX + (currentView left) + bw.
	sumY := sumY + (currentView top) + bw.
	currentView := currentView superView
    ].
    (aView isNil or:[aView == device rootView]) ifTrue:[
	"return relative to screen ..."
	^ (sumX @ sumY)
    ].
    ^ nil

    "
     |top sub1 sub2|

     top := StandardSystemView new.
     top extent:200@200.
     sub1 := View origin:0.2 @ 0.2 corner:0.8 @ 0.8 in:top.
     sub2 := Button origin:0.3 @ 0.3 corner:0.7 @ 0.7 in:sub1.
     top openAndWait.
     Transcript show:'button in top:'; showCR:(sub2 originRelativeTo:top).
     Transcript show:'button on screen:'; showCR:(sub2 originRelativeTo:nil).
    "

    "Modified: / 5.12.1998 / 14:30:57 / cg"
!

originRule
    "return the origin block - non public; this will vanish without notice"

    ^ originRule
!

preferredExtent:anExtentPoint
    "override the view's own preferredExtent computation,
     and let it prefer the size given by the argument."

    preferredExtent := anExtentPoint.
    explicitExtent := anExtentPoint.

    "Modified: 22.8.1996 / 13:41:47 / cg"
!

relativeCorner
    "return the relative corner or nil"

    "MB:added  {" "needed if layout is used e.g. POUEditor"
    layout notNil ifTrue:[
	layout isRectangle ifTrue:[
	    ^ 0@0
        ].    
	^(layout rightFraction) @ (layout bottomFraction)
    ].
    "MB:added  }"

    ^relativeCorner
!

relativeCorner:aPoint
    "set the relative corner"

    aPoint notNil ifTrue:[relativeExtent := nil].
    relativeCorner := aPoint.
    "MB:added  {" "needed if layout is used e.g. POUEditor"
    layout notNil ifTrue:[
	layout rightFraction: aPoint x.
	layout bottomFraction: aPoint y.
    ].
    "MB:added  }"
!

relativeExtent
    "return the relative extent or nil.
     Obsolete: please use a layout object."

    ^ relativeExtent
!

relativeExtent:aPoint
    "set the relative extent.
     Obsolete: please use a layout object."

    aPoint notNil ifTrue:[relativeCorner := nil].
    relativeExtent := aPoint
!

relativeOrigin
    "return the relative corner or nil"

    "MB:added  {"  "needed if layout is used e.g. POUEditor"
    layout notNil ifTrue:[
	layout isRectangle ifTrue:[
	    ^ 0@0
        ].    
	^(layout leftFraction) @ (layout topFraction)
    ].
    "MB:added  }"
    ^relativeOrigin
!

relativeOrigin:aPoint
    "set the relative origin"

    relativeOrigin := aPoint.
    "MB:added  {" "needed if layout is used e.g. POUEditor"
    layout notNil ifTrue:[
	layout leftFraction: aPoint x.
	layout topFraction: aPoint y.
    ].
    "MB:added  }"
!

right
    "return the x position of the right edge  (in pixels)"

    ^ left + width - 1

    "Modified: 31.8.1995 / 19:31:10 / claus"
!

right:aNumber
    "set the corners x position"

    self corner:(aNumber @ self corner y)
!

rightInset
    "return the inset of the right edge; positive is to the left,
     negative to the right.
     Obsolete: please use a layout object."

    insets isNil ifTrue:[^ 0].
    ^ insets at:3
!

rightInset:aNumber
    "set the inset of the right edge;
     positive is to the left (view becomes smaller),
     negative to the right (becomes larger).
     Obsolete: please use a layout object."

    |newInset|

    insets isNil ifTrue:[
	insets := Array with:0 with:0 with:0 with:0
    ].
    newInset := aNumber.
    newInset isNil ifTrue:[
	newInset := 0.
    ].
    (insets at:3) ~= newInset ifTrue:[
	insets at:3 put:newInset.
	self containerChangedSize.
    ]

    "Modified: 19.7.1996 / 17:30:32 / cg"
!

screenBounds
    "return my bounds on the screen"

    ^ (self originRelativeTo:nil) extent:(self extent)
!

setHeight:aNumber
    "set the view's height in pixels"

    height := aNumber.

    "Created: / 01-02-2011 / 23:34:51 / cg"
!

setOrigin:aPoint
    "set the origin only"

    left := aPoint x.
    top := aPoint y.
!

setWidth:aNumber
    "set the view's width in pixels"

    width := aNumber.

    "Created: / 01-02-2011 / 23:36:44 / cg"
!

sizeFixed:aBoolean
    "set/clear the fix-size attribute, if supported by concrete subclasses.
     Views which want to resize themselfes as appropriate to their contents
     should cease to do so and take their current size if sizeFixed is set to
     true. Currently, only supported by Labels.
     This does NOT prevent the window manager from resizing the view,
     instead it tell the view to NOT resize ITSELF.
     Added here to provide a common protocol for all views."

    ^ self
!

superViewRectangle
    "return the inside area of the superView."

    superView isNil ifTrue:[
	^ Rectangle left:0 top:0 right:0 bottom:0.
    ].

    ^ superView viewRectangle.
!

top
    "return the y position of the top border"

    ^ top
!

top:aNumber
    "set the y position"

    self origin:(left @ aNumber)
!

topInset
    "return the inset of the top edge; positive is to the bottom,
     negative to the top.
     Obsolete: please use a layout object."

    insets isNil ifTrue:[^ 0].
    ^ insets at:2
!

topInset:aNumber
    "set the inset of the top edge;
     positive is to the bottom (view becomes smaller),
     negative to the top (becomes larger).
     Obsolete: please use a layout object."

    |newInset|

    insets isNil ifTrue:[
	insets := Array with:0 with:0 with:0 with:0
    ].
    newInset := aNumber.
    newInset isNil ifTrue:[
	newInset := 0.
    ].
    (insets at:2) ~= newInset ifTrue:[
	insets at:2 put:newInset.
	self containerChangedSize.
    ]

    "Modified: 19.7.1996 / 17:30:45 / cg"
!

verticalInset:aNumber
    "set the insets of the top/bottom edge;
     positive makes it smaller, negative makes it larger.
     Obsolete: please use a layout object."

    |newInset|

    insets isNil ifTrue:[
	insets := Array with:0 with:0 with:0 with:0
    ].
    newInset := aNumber.
    aNumber isNil ifTrue:[
	newInset := 0.
    ].
    insets at:2 put:newInset.
    insets at:4 put:newInset.

    "force recomputation"
"/    drawableId isNil ifTrue:[
"/        self originChangedFlag:true
"/    ] ifFalse:[
	self containerChangedSize.
"/    ]

    "Modified: / 30-09-2006 / 15:19:45 / cg"
!

viewRectangle
    "return the inside area.
     This is used by relative sized subviews and layout-computations
     to base relative coordinates on.
     For most views, the value returned here (actual extent minus any
     margins required for 3D levels) is ok.
     However, views which want some extra area around (for example: FramedBox)
     may redefine this method to return a rectangle without this area
     (thus, a relative sized subviews coordinates will be based on this net area) "

    |m2|

    m2 := margin + margin.
    ^ (margin @ margin) extent:((width - m2) @ (height - m2))

    "Modified: 8.2.1996 / 20:05:00 / cg"
!

width:aNumber
    "set the view's width in pixels"

    "/ check: the following leads to an error in the notebook...
"/    aNumber isInteger ifTrue:[
"/        width := aNumber.
"/    ] ifFalse:[
        self extent:(aNumber @ height)
"/    ]

    "Modified: / 02-02-2011 / 12:16:26 / cg"
!

widthIncludingBorder
    "return my width including border
     (this is my width as seen from the outside view;
      while #width returns the width as seen by myself)"

    ^ width + (2*self borderWidth)
! !

!SimpleView methodsFor:'accessing-display attributes'!

beMDIChildView
    flagBits := (flagBits ? 0) bitOr:FlagIsMDIChild
!

beNativeWidget
    flagBits := (flagBits ? 0) bitOr:FlagNativeWidget
!

beNonNativeWidget
    flagBits := (flagBits ? 0) bitClear:FlagNativeWidget
!

isMDIChildView
    ^ flagBits bitTest:FlagIsMDIChild
!

isMarkedAsUnmappedModalBox
    ^ flagBits bitTest:FlagIsUnmappedModalBox
!

isNativeWidget
    ^ flagBits bitTest:FlagNativeWidget
!

markAsUnmappedModalBox
    flagBits := (flagBits ? 0) bitOr:FlagIsUnmappedModalBox
!

unmarkAsUnmappedModalBox
    flagBits := (flagBits ? 0) bitClear:FlagIsUnmappedModalBox
! !

!SimpleView methodsFor:'accessing-hierarchy'!

components
    "return the collection of non-view components"

    ^ components ? #()

    "Created: 28.5.1996 / 23:59:37 / cg"
!

container
    "return my container"

    ^ superView

    "Created: 5.6.1996 / 01:08:36 / cg"
    "Modified: 10.1.1997 / 19:47:59 / cg"
!

container:aContainer
    "set my container (i.e. superView) to be aContainer"

    superView == aContainer ifTrue:[
	"/ no change
	^ self.
    ].

    (self drawableId notNil) ifTrue:[
	"/ actually, this is worth an exception
	"/ ('View [error]: ' , self printString , ' already realized - cannot change container') errorPrintCR.
	self error:'already realized - cannot change container' mayProceed:true.
    ].
    (superView notNil and:[superView ~~ aContainer]) ifTrue:[
	"/ actually, this is worth an exception
	('View [warning]: ' , self printString , ' already has a container') errorPrintCR.
	superView removeComponent:self.
    ].
    superView := aContainer

    "Created: 9.5.1996 / 00:40:56 / cg"
    "Modified: 29.1.1997 / 17:37:38 / cg"
!

hierarchicalIndex
    ^ superView hierarchicalIndexOfChild:self
!

hierarchicalIndexInList:aViewCollection
    |viewsWithSameName myName|

    myName := self uuidStringOrName.
    viewsWithSameName := aViewCollection select:[:v | v uuidStringOrName = myName].
    viewsWithSameName size = 1 ifTrue:[
	^ nil "/ no conflict
    ].
    ^ viewsWithSameName indexOf:self
!

hierarchicalIndexOfChild:aView
    ^ nil
!

hierarchicalUUID

    |uuidOrName superV hierarchicalViews hierarchicalUUID separator indexOrNil indexString|

    hierarchicalUUID := ''.
    hierarchicalViews := OrderedCollection with: self.
    superV := self superView.

    [superV isNil] whileFalse:[
	hierarchicalViews addFirst: superV.
	superV := superV superView.
    ].

    hierarchicalViews doWithIndex:[:aView :index |
	uuidOrName := aView uuidStringOrName.
	indexString := nil.
	index > 1 ifTrue:[
	    indexOrNil := aView hierarchicalIndex.
	    (indexOrNil notNil and:[indexOrNil ~= 1]) ifTrue:[
		indexString := '[',indexOrNil printString,']'
	    ]
	].
	separator := index == 1 ifTrue:[''] ifFalse:['.'].
	hierarchicalUUID := hierarchicalUUID,separator,uuidOrName,(indexString?'').
    ].
    ^ hierarchicalUUID
!

lower
    "bring to back"

    self drawableId isNil ifTrue:[self create].
    device lowerWindow:self drawableId

    "
     Transcript topView lower
    "
!

raise
    "bring to front"

    "MS-windows:
     Raise does not raise a window above windows marked as 'TOPMOST'.
     (e.g. cmd.exe appears to mark itself as topmost when it gets the focus).
     Use #setForegroundWindow to raise above the currently active window,
     or mark as #beScreenDialog before opening"

    self drawableId isNil ifTrue:[self create].
    device raiseWindowToTop:self drawableId

    "
     Transcript topView raise
    "

    "Modified: / 29-08-2013 / 16:19:02 / cg"
!

scrolledView
    "for compatibility with scrolledView, return myself.
     So you can ignore the scrollability of a component when accessing it,
     without a need to ask for being a scrollwrapper first.
     Eg, you can send someView scrolledView to get the underlying view,
     without a danger of a DNU, if the component is not scrolled."

    ^ self

    "Created: / 22-01-2011 / 12:00:41 / cg"
!

setContainer:aContainer
    "set my container (i.e. superView) to be aContainer"

    superView := aContainer
!

subViews
    "return the collection of subviews"

    ^ subViews ? #()
!

subViews:aListOfViews
    <resource: #obsolete>
    "set the collection of subviews"

    self obsoleteMethodWarning.

    subViews := aListOfViews.
    subViews notNil ifTrue:[
	subViews do:[:view |
	    view container:self
	]
    ]

    "Modified: 9.5.1996 / 00:42:28 / cg"
!

superView
    "return my superView"

    ^ superView
!

superView:aView
    "set my superView to be aView"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #container:'.
    self container:aView.

    "Modified: 9.5.1996 / 00:46:24 / cg"
!

topComponent
    "return the topmost component - that's the one with no superview.
     For ST-80 compatibility."

    ^ self topView

    "Modified: 9.5.1996 / 01:40:24 / cg"
!

topView
    "return the topView - that's the one with no superview"

    |v next n|

    n := 1.
    v := self.
    [v notNil] whileTrue:[
	(next := v container) isNil ifTrue:[^ v].
	v := next.
	n := n + 1.
	n > 1000 ifTrue:[self error:'circular superView chain'].
    ].

    ^ nil

    "Modified: 5.6.1996 / 01:09:12 / cg"
!

uuidStringOrName
    |uuid|

    (uuid := self uuid) isNil ifTrue: [^ self name].
    ^ uuid printString
!

view
    "return my view - for real views, that's the receiver.
     For wrappers, its the real view that contains it"

    ^ self

    "Created: 4.6.1996 / 21:32:11 / cg"
! !

!SimpleView methodsFor:'accessing-keyboard mappings'!

shortKeyStringFor:symbolicOrRawKey
    ^ device shortKeyStringFor:symbolicOrRawKey usingMap: self keyboardMap.

    "Created: / 08-02-2017 / 23:20:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'accessing-menus'!

menuHolder
    "who has the menu ?
     By default, I have it."

    ^ self
!

menuMessage
    "Return the symbol sent to myself to acquire the menu"

    ^ #middleButtonMenu
!

menuPerformer
    "who should perform the menu actions ?
     By default, I do it."

    ^ self
!

yellowButtonMenu
    "actually, this should be called 'middleButtonMenu'.
     But for ST-80 compatibility ....
     This method will vanish, once all views have controllers
     associated with them; for now, duplicate some code also found in
     controller."

    |sym menuHolder|

    menuHolder := self menuHolder.
    menuHolder isNil ifTrue:[^ nil].

    (menuHolder isKindOf:Menu) ifTrue:[^ menuHolder].

    sym := self menuMessage.
    sym isNil ifTrue:[^ nil].

    "
     mhmh - for backward compatibility, try to ask
     the model first, then use the view's menu.
    "
    (menuHolder respondsTo:sym) ifFalse:[
        (self respondsTo:sym) ifTrue:[
            menuHolder := self
        ]
    ].

    sym numArgs > 0 ifTrue:[
        "/ squeak compatibility (with args): create the empty menu here, let model add items
        ^ menuHolder perform:sym withOptionalArgument:(Menu new) and:(device shiftDown).
    ].

    "
     ask the menuHolder for the menu
    "
    ^ menuHolder perform:sym.
! !

!SimpleView methodsFor:'accessing-misc'!

bitGravity
    "return the bitGravity - that's the direction where the contents will move
     when the view is resized."

    ^ bitGravity
!

bitGravity:gravity
    "set the bitGravity - that's the direction where the contents will move
     when the view is resized."

    bitGravity ~~ gravity ifTrue:[
	bitGravity := gravity.
	gc bitGravity:gravity.
    ]
!

clippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in logical coordinates);
     a nil argument turns off clipping (i.e. whole view is drawable).
     Redefined to care for any margin."

    |x y w h currentClippingBounds newBounds|

    currentClippingBounds := gc clippingBoundsOrNil.
    (currentClippingBounds = aRectangleOrNil) ifTrue:[
	^ self
    ].
    newBounds := aRectangleOrNil.

    aRectangleOrNil notNil ifTrue:[
	|currentTransformation|

	x := aRectangleOrNil left.
	y := aRectangleOrNil top.
	w := aRectangleOrNil width.
	h := aRectangleOrNil height.
	currentTransformation := gc transformation.
	currentTransformation notNil ifTrue:[
	    x := currentTransformation applyToX:x.
	    y := currentTransformation applyToY:y.
	    w := currentTransformation applyScaleX:w.
	    h := currentTransformation applyScaleY:h.
	].
	(x class ~~ SmallInteger) ifTrue:[
	    w := w + (x - x truncated).
	    x := x truncated
	].
	(y class ~~ SmallInteger) ifTrue:[
	    h := h + (y - y truncated).
	    y := y truncated
	].
	(w class ~~ SmallInteger) ifTrue:[
	    w := w truncated + 1
	].
	(h class ~~ SmallInteger) ifTrue:[
	    h := h truncated + 1
	].
	x < margin ifTrue:[
	    x := margin.
	].
	y < margin ifTrue:[
	    y := margin.
	].
	x + w - 1 >= (width-margin) ifTrue:[
	    w := width - margin - x
	].
	y + h - 1 >= (height-margin) ifTrue:[
	    h := height - margin - y
	].
	w := w max:0.
	h := h max:0.
	newBounds := Rectangle left:x top:y width:w height:h.
    ].
    gc deviceClippingBounds:newBounds

    "Created: 28.5.1996 / 19:50:03 / cg"
    "Modified: 28.5.1996 / 22:32:15 / cg"
!

fullName
    "return my full name to be used for resource-access"

    superView notNil ifTrue:[
	^ superView fullName , '.' , self name
    ].
    ^ self name
!

name
    "return my name component to be used for resource-access"

    name isNil ifTrue:[
	name := self class name "asString" asLowercaseFirst
    ].
    ^ name
!

name:aString
    "set my name component to be used for resource-access"

    name := aString
!

processName
    "return a string to be shown in the process monitor"

    ^ self name
!

styleSheet
    "return the styleSheet. This is set at early view-creation time,
     from the defaultStyleSheet which is valid at that time.
     It is not affected by later defaultStyle changes"

    ^ styleSheet

    "Created: 10.9.1995 / 11:02:20 / claus"
!

styleSheet:aStyleSheet
    "change the styleSheet. Knowledgable users only, please."

    styleSheet := aStyleSheet.
!

uuid
    "return my uuid (for the pollonium st/x capture/replay tool)"

    ^ uuid
!

uuid:aUUID
    "set my uuid (for the pollonium st/x capture/replay tool)"

    uuid := aUUID
!

viewGravity
    "return the viewGravity - that's the direction where the view will move
     when the superView is resized."

    ^ viewGravity
!

viewGravity:gravity
    "set the viewGravity - that's the direction where the view will move
     when the superView is resized."

    viewGravity ~~ gravity ifTrue:[
	viewGravity := gravity.
	gc viewGravity:gravity.
    ]
! !

!SimpleView methodsFor:'accessing-mvc'!

application
    "return the application, under which this view was opened,
     or nil, if there is no application"

    superView notNil ifTrue:[
	^ superView application
    ].
    ^ nil

    "Modified: 13.1.1997 / 20:30:31 / cg"
!

aspect:aspectSymbol
    "ST-80 style updating: If a views aspectSymbol is nonNil,
     it will respond to changes of this aspect from the model.
     Alias for aspectMessage: for ST-80 compatibility."

    self aspectMessage:aspectSymbol
!

controller
    "return the controller. For views which implement the controller
     functionality themself, return the receiver itself"

    ^ controller ? self

    "Modified: / 31.10.1997 / 19:58:10 / cg"
!

controller:aController
    "set the controller - that's the one handling user events"

    aController == self ifTrue:[
        controller := nil
    ] ifFalse:[    
        controller := aController.
        controller notNil ifTrue:[
            controller view:self.
        ]
    ]

    "Modified: / 31.10.1997 / 19:58:33 / cg"
!

model
    "return nil - simpleViews have no model (only providing geometric)"

    ^ nil

    "Modified: 5.6.1996 / 14:17:29 / cg"
!

sensor
    "return the view's sensor"

    windowGroup notNil ifTrue:[
        ^ windowGroup sensor.
    ].

    "there is no window group. Deliver events synchronously"

    ^ SynchronousWindowSensor new.

    "Modified: 10.1.1997 / 19:47:13 / cg"
!

setController:aController
    "set the controller but do not affect the model/view releationship"

    controller := aController.

    "Created: 18.7.1996 / 11:43:40 / cg"
!

setWindowGroup:aGroup
    "set the window group."

    windowGroup := aGroup

    "Created: 19.8.1997 / 17:58:35 / cg"
!

windowGroup
    "return the window group. For old style views, return nil"

    ^ windowGroup
!

windowGroup:newGroup
    "set the window group of myself and recursively of any children.
     If I am currently in a group, remove me from it it."

    windowGroup notNil ifTrue:[
	windowGroup removeView:self.
	windowGroup := nil
    ].
    windowGroup := newGroup.
    newGroup notNil ifTrue:[
	newGroup addView:self.

    ].
    subViews notNil ifTrue:[
	subViews do:[:aSubview |
	    aSubview windowGroup:newGroup
	]
    ].

    "Modified: 20.8.1997 / 13:26:37 / cg"
! !

!SimpleView methodsFor:'accessing-transformation'!

maxComponentBottom
    "return the maximum of all components bottoms"

    components isNil ifTrue:[^ 0].
    ^ components inject:0 into:[:maxSoFar :sub | (sub bottom) max:maxSoFar].

    "Created: / 26-05-1996 / 12:44:05 / cg"
    "Modified: / 22-10-2010 / 10:49:08 / cg"
!

maxComponentRight
    "return the maximum of all components rights"

    components isNil ifTrue:[^ 0].
    ^ components inject:0 into:[:maxSoFar :sub | (sub right) max:maxSoFar].

    "Created: / 26-05-1996 / 13:02:19 / cg"
    "Modified: / 22-10-2010 / 10:48:53 / cg"
!

maxSubViewBottom
"/    subViews isNil ifTrue:[^ 0].
"/    ^ subViews inject:0 into:[:maxSoFar :sub | (sub top + sub height) max:maxSoFar].
      ^ 0
!

maxSubViewRight
"/    subViews isNil ifTrue:[^ 0].
"/    ^ subViews inject:0 into:[:maxSoFar :sub | (sub left + sub width) max:maxSoFar].
    ^ 0
!

scale:aPoint
    "set the scale factor of the transformation"

    super scale:aPoint.
    self computeInnerClip
!

setViewOrigin:aPoint
    "set the viewOrigin - i.e. virtually scroll without redrawing"

    |currentTransformation|

    currentTransformation := gc transformation.
    currentTransformation isNil ifTrue:[
	(aPoint x ~~ 0 or:[aPoint y ~~ 0]) ifTrue:[
	    gc transformation:(WindowingTransformation scale:1 translation:aPoint negated).
	].
    ] ifFalse:[
	currentTransformation translation:aPoint negated.
    ].
    self clippingBoundsOrNil notNil ifTrue:[
	self setInnerClip.
    ].
!

viewOrigin
    "return the viewOrigin; that's the coordinate of the contents
     which is shown topLeft in the view
     (i.e. the origin of the visible part of the contents)."

    |currentTransformation|

    currentTransformation := gc transformation.
    currentTransformation isNil ifTrue:[
	^ 0@0
    ].
    ^ currentTransformation translation negated
!

visibleArea
    "return the rectangle that contains the visible part
     of the view in user coordinates."


    |currentTransformation|

    currentTransformation := gc transformation.
    currentTransformation isNil ifTrue:[
	^ Rectangle left:0 top:0 width:width height:height.
    ].
    ^ Rectangle origin:(currentTransformation translation negated)
		extent:((width @ height) scaledBy:(currentTransformation scale)).

    "Created: 12.7.1996 / 11:57:04 / stefan"
!

xOriginOfContents
    "return the x coordinate of the viewOrigin in pixels;
     used by scrollBars to compute thumb position within the document."

    ^ self viewOrigin x
!

yOriginOfContents
    "return the y coordinate of the viewOrigin in pixels;
     used by scrollBars to compute thumb position within the document."

    ^ self viewOrigin y
! !

!SimpleView methodsFor:'accessing-visibility'!

beInvisible
    "make the view invisible; if my container is visible,
     change visibility immediately;
     otherwise, arrange for the receiver to be not realized,
     when the container is made visible."

    self hiddenOnRealize:true.
    realized ifTrue:[
	(superView isNil              "/ I am a topView
	or:[superView realized        "/ superview already shown
	or:[superView id notNil]])     "/ superview already created
	    ifTrue:[
		self unmap
	    ]
    ]

    "Modified: 3.4.1997 / 21:20:40 / cg"
!

beVisible
    "make the view visible; if my container is already visible,
     change visibility immediately; otherwise, arrange for the receiver
     to be made visible when the container is made visible.
     Notice, that the command may not be sent immediately to the display,
     and that ST/X considers the view to be still invisible until a
     visibility event arrives from the display.
     Thus, the view may remain logically invisible
     for a while. (see #beVisibleNow for more on this)"

    self hiddenOnRealize:false.
    realized ifFalse:[
	superView isNil ifTrue:[                "/ I am a topView
	    self drawableId isNil ifTrue:[
		"this once was:
		   self realize.
		 but we don't want Topviews to realize implicitly.
		 BTW. the code doesn't work anyway"
	    ] ifFalse:[
		self remap.
	    ].
	] ifFalse:[
	    (superView realized          "/ superview already shown
	    or:[superView id notNil])    "/ superview already created
	    ifTrue:[
		self realize
	    ]
	].
    ]

    "
     |top topFrame check list|

     top := StandardSystemView new.
     top extent:150@400.
     topFrame := VerticalPanelView origin:0.0@0.0 corner:1.0@0.4 in:top.
     topFrame horizontalLayout:#leftSpace.

     topFrame add:(check := CheckBox label:'hidden').
     check pressAction:[list beInvisible].
     check releaseAction:[list beVisible].

     list := ScrollableView for:SelectionInListView.
     list origin:0.0@0.4 corner:1.0@1.0.
     list list:#('foo' 'bar' 'baz').
     top add:list.

     check turnOn.
     list beInvisible.

     top open
    "

    "Created: / 22.9.1995 / 15:50:33 / claus"
    "Modified: / 17.6.1997 / 11:23:00 / cg"
    "Modified: / 14.1.1998 / 17:33:15 / stefan"
!

beVisibleNow
    "make the view visible immediately.
     In contrast to #beVisible, this waits until the view is really
     visible."

    self beVisible.
    device sync.    "that's a round-trip; when returning, the view is definitely visible"

"/    realized := true.
"/    shown := true.

    "Created: 3.4.1997 / 21:23:28 / cg"
!

hidden
    "return true, if the view does not want to be realized
     automatically when superview is realized"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #isHiddenOnRealize'.
    ^ self isHiddenOnRealize

    "Modified: 17.6.1997 / 11:19:55 / cg"
!

hidden:aBoolean
    "if the argument is true, the receiver view will not
     be realized automatically when superview is realized"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #hiddenOnRealize:'.
    self hiddenOnRealize:aBoolean

    "Modified: 17.1.1996 / 11:45:06 / cg"
!

hiddenOnRealize:aBoolean
    "if the argument is true, the receiver view will not
     be mapped (i.e. shown) automatically when the superview is realized.
     The hiddenOnRealize flag is useful to create views which are
     to be made visible conditionally or later.
     Notice: if there is a visibilityChanne, this static flag is ignored.
     For ST-80 compatibility, please use #beVisible / #beInvisible."

    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagHiddenOnRealize
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagHiddenOnRealize
    ].

    "Modified: 17.6.1997 / 11:23:26 / cg"
!

isBeingDestroyed
    "a flag which is set, when the view is being destroyed.
     Can be checked to avoid some resizing and other layout reorganizations
     (especially in panels), which otherwise occur while subviews are removed."

    ^ flagBits bitTest:FlagBeingDestroyed.
!

isBeingDestroyed:aBoolean
    "a flag which is set, when the view is being destroyed.
     Can be checked to avoid some resizing and other layout reorganizations
     (especially in panels), which otherwise occur while subviews are removed."

    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagBeingDestroyed
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagBeingDestroyed
    ].
!

isHiddenOnRealize
    "return true, if the receiver will NOT be mapped when realized.
     False otherwise.
     The hiddenOnRealize flag is useful to create views which are
     to be made visible conditionally or later.
     Notice: if there is a visibilityChanne, the static flag is ignored."

    visibilityChannel isNil ifTrue:[
        ^ flagBits bitTest:FlagHiddenOnRealize.
    ].
    ^ visibilityChannel value not
    
    "Created: 17.6.1997 / 11:21:42 / cg"
!

isReallyShown
    "return true, if the view is visible AND all of its containers are"

    |v|

    v := self.
    [v notNil] whileTrue:[
	v shown ifFalse:[^ false].
	v := v container.
    ].
    ^ true

    "Created: / 21-01-2011 / 15:54:18 / cg"
!

isVisible
    "return true, if the view is visible"

    ^ self realized
!

isVisible:aBoolean
    "make the view visible or invisible"

    aBoolean ifTrue:[
	self beVisible
    ] ifFalse:[
	self beInvisible
    ]

    "Created: / 27.10.1997 / 04:23:04 / cg"
!

setVisibilityChannel:aValueHolder
    "set the valueHolder, which holds the visible boolean value"

    visibilityChannel := aValueHolder

    "
      |v h|

      v := View new.
      v visibilityChannel:(h := ValueHolder with:true).
      v open.
      Delay waitForSeconds:2.
      h value:false.
      Delay waitForSeconds:2.
      h value:true.
      Delay waitForSeconds:2.
    "
!

shown
    "return true if the view is shown; false if not.
     Shown means: the view is mapped and is not completely covered."

    ^ shown
!

visibilityChannel
    "return a valueHolder for visible/invisible"

    ^ visibilityChannel

    "Modified: / 30.3.1999 / 13:49:56 / stefan"
!

visibilityChannel:aValueHolder
    "set the valueHolder, which holds the visible boolean value"


    |prev|

    prev := visibilityChannel.
    visibilityChannel := aValueHolder.
    self setupChannel:aValueHolder for:#visibilityStateChanged withOld:prev

    "
      |v h|

      v := View new.
      v visibilityChannel:(h := ValueHolder with:true).
      v open.
      Delay waitForSeconds:2.
      h value:false.
      Delay waitForSeconds:2.
      h value:true.
      Delay waitForSeconds:2.
    "

    "Created: / 14.1.1998 / 17:11:15 / stefan"
    "Modified: / 14.1.1998 / 17:33:40 / stefan"
! !

!SimpleView methodsFor:'adding & removing components'!

add:aComponent
    "add a component (either a view or gadget) to the collection of
     subComponents."

    self addComponent:aComponent
!

add:aComponent at:anOrigin
    "for ST-80 compatibility.
     add a component at some origin"

    |l comp|

    comp := aComponent.

"/    (comp isWrapper not
"/    or:[comp isLayoutWrapper not]) ifTrue:[
"/        comp := LayoutWrapper on:comp
"/    ].

    l := anOrigin asLayout.
    comp layout:l.

    self addComponent:comp

    "Modified: 18.4.1997 / 20:00:20 / cg"
!

add:aComponentOrCollection in:aRectangleOrLayoutFrame
    "for ST-80 compatibility.
     add a component in some frame; the argument may be either a rectangle
     with relative coordinates, or an instance of LayoutFrame, specifying
     both relative coordinates and the insets."

    |l wrapper|

    aComponentOrCollection isCollection ifTrue:[
	wrapper := View new.
	aComponentOrCollection do:[:aComponent |
	    wrapper add:aComponent
	]
    ] ifFalse:[
	wrapper := aComponentOrCollection
    ].

    l := aRectangleOrLayoutFrame asLayout.

"/  will soon be replaced by:
"/    aComponent layout:l.
    wrapper geometryLayout:l.

    self addComponent:wrapper.

    ^ wrapper

    "Modified: 17.6.1997 / 18:03:34 / cg"
!

addComponent:aComponent
    "components (i.e. gadgets or lightweight views) are being prepared.
     Don't use this right now for non-views"

    aComponent isView ifTrue:[
	self addSubView:aComponent
    ] ifFalse:[
	components isNil ifTrue:[
	    components := OrderedCollection new
	].
	components add:aComponent.
	aComponent container:self.
	shown ifTrue:[
	    aComponent displayOn:self
	]
    ]

    "Modified: 13.5.1996 / 21:19:51 / cg"
!

addSubView:newView
    "add a view to the collection of subviews"

    subViews isNil ifTrue:[
	subViews := OrderedCollection with:newView
    ] ifFalse:[
	(subViews includesIdentical:newView) ifTrue:[
	    self error:'trying to add a view twice' mayProceed:true.
	    ^ self.
	].
	subViews add:newView.
    ].
    self setContainerIn:newView.

    "Modified: 9.5.1996 / 00:47:16 / cg"
!

addSubView:newView after:aViewOrNil
    "add a view to the collection of subviews after another view.
     If the argument aViewOrNil is nil, the newView is added at the end.
     This makes sense, in Panels and other layout views, to enter a new
     element at some defined place."

    subViews isNil ifTrue:[
	subViews := OrderedCollection with:newView
    ] ifFalse:[
	(subViews includesIdentical:newView) ifTrue:[
	    self error:'trying to add a view twice' mayProceed:true.
	    ^ self.
	].
	aViewOrNil isNil ifTrue:[
	    subViews add:newView
	] ifFalse:[
	    subViews add:newView after:aViewOrNil.
	]
    ].
    self setContainerIn:newView.

    "Modified: / 09-05-1996 / 00:47:20 / cg"
    "Modified (comment): / 22-03-2012 / 10:39:04 / cg"
!

addSubView:newView before:aViewOrNil
    "add a view to the collection of subviews before another view.
     If the argument aViewOrNil is nil, the newView is added at the end.
     This makes sense, in Panels and other layout views, to enter a new
     element at some defined place."

    subViews isNil ifTrue:[
	subViews := OrderedCollection with:newView
    ] ifFalse:[
	(subViews includesIdentical:newView) ifTrue:[
	    self error:'trying to add a view twice' mayProceed:true.
	    ^ self.
	].
	aViewOrNil isNil ifTrue:[
	    subViews addFirst:newView
	] ifFalse:[
	    subViews add:newView before:aViewOrNil.
	]
    ].
    self setContainerIn:newView.

    "Modified: / 09-05-1996 / 00:47:23 / cg"
    "Modified (comment): / 22-03-2012 / 10:39:18 / cg"
!

addSubView:aView in:bounds borderWidth:bw
    "for ST-80 V2.x compatibility"

    aView borderWidth:bw.
    self add:aView in:bounds.
!

addSubViewFirst:newView
    "add a view to the front of the collection of subviews"

    subViews isNil ifTrue:[
	subViews := OrderedCollection with:newView
    ] ifFalse:[
	(subViews includesIdentical:newView) ifTrue:[
	    self error:'trying to add a view twice' mayProceed:true.
	    ^ self.
	].
	subViews addFirst:newView.
    ].
    self setContainerIn:newView.

    "Modified: 9.5.1996 / 00:47:16 / cg"
    "Created: 6.3.1997 / 18:43:38 / cg"
!

component:aComponent
    "components (i.e. gadgets or lightweight views) are being prepared.
     Don't use this right now for non-views"

    aComponent origin:0.0@0.0 corner:1.0@1.0.
    aComponent isView ifTrue:[
	self addSubView:aComponent
    ] ifFalse:[
	components := OrderedCollection with:aComponent.
	aComponent container:self.

	shown ifTrue:[
	    aComponent displayOn:self
	]
    ]

    "Modified: 13.5.1996 / 21:20:29 / cg"
!

destroySubViews
    "remove all subviews"

    subViews notNil ifTrue:[
	subViews copy do:[:aSubView |
	    aSubView destroy.
	].

	"/ paranoia ;-)
	subViews size ~~ 0 ifTrue:[
	    (self class name , ' >>View [warning]: some subView(s) did not destroy: ' , subViews printString) infoPrintCR.
	    subViews := nil
	].
    ].

    components notNil ifTrue:[
	components copy do:[:aComponent |
	    aComponent destroy.
	].
	components := nil.
    ]
!

removeComponent:aComponent
    "components (i.e. gadgets or lightweight views) are being prepared.
     Don't use this right now for non-views"

    aComponent isView ifTrue:[
	self removeSubView:aComponent
    ] ifFalse:[
	components isNil ifTrue:[^self].
	components remove:aComponent ifAbsent:[].
	aComponent container:nil
    ]

    "Modified: / 11-09-2006 / 17:14:30 / User"
!

removeSubView:aView
    "remove a view from the collection of subviews"

    subViews notNil ifTrue:[
	subViews remove:aView ifAbsent:[nil].
	aView setContainer:nil.

	(subViews size == 0) ifTrue:[
	    subViews := nil
	]
    ]
!

setContainerIn:aView
    "common code for addSubView* methods"

    aView container:self.
    (aView graphicsDevice ~~ device) ifTrue:[
	'SimpleView [warning]: subview (' errorPrint. aView class name errorPrint.
	') has different device than me (' errorPrint.
	self class name errorPrint. ').' errorPrintCR.
	aView device:device
    ].

    "Created: 9.5.1996 / 00:46:59 / cg"
    "Modified: 10.1.1997 / 18:06:49 / cg"
! !

!SimpleView methodsFor:'change & update'!

changedPreferredBounds:someArgument
    "tell any dependents, that I have changed my preferred bounds;
     Interface is provided mostly provided for ST80 compatibility;
     here, translate into ST/X's mechanism for telling others about this."

    dependents notNil ifTrue:[ self changed:#preferredExtent ]

    "Modified: 6.3.1997 / 16:12:02 / cg"
!

languageChanged
!

update:aspect with:aParameter from:changedObject
    "an update request"

    aspect == #sizeOfView ifTrue:[
	"one of the views we depend on changed its size"
	"/ cg: #containerChangedSize has already been sent by the caller
	^ self "containerChangedSize".
    ].
    super update:aspect with:aParameter from:changedObject

    "Modified: 19.7.1996 / 17:30:48 / cg"
! !

!SimpleView methodsFor:'cursor animation'!

showBusyWhile:aBlock
    "evaluate some time consuming block, while doing this,
     show a spinning wheel cursor. If those bitmaps are not found,
     fallback to the standard busy cursor.
     Experimental."

    |ok bitmaps cursors maskForm process oldCursor|

    oldCursor := cursor.

    ok := true.
    bitmaps := #('wheel1' 'wheel2' 'wheel3' 'wheel4')
	       collect:[:name |
		   |f|

		   f := Smalltalk imageFromFileNamed:(name , '.xbm') forClass:self class.
		   f isNil ifTrue:[
			('SimpleView [warning]: no bitmap file: ' , name , '.xbm') errorPrintCR.
			ok := false
		   ].
		   f
	       ].

    ok ifTrue:[
	maskForm := Smalltalk imageFromFileNamed:'wheelm.xbm' forClass:self class.
	maskForm isNil ifTrue:[
	    ('SimpleView [warning]: no bitmap file: wheelm.xbm') errorPrintCR.
	    ok := false
	].
    ].

    ok ifFalse:[
	self cursor:Cursor wait.
	aBlock ensure:[
	    self cursor:oldCursor
	]
    ] ifTrue:[
	cursors := bitmaps collect:[:form | (Cursor sourceForm:form
						      maskForm:maskForm
							  hotX:8
							  hotY:8) onDevice:device].

	process := [
		    Delay waitForSeconds:0.25.
		    [
			cursors do:[:curs |
			    self cursor:curs.
			    Delay waitForSeconds:0.05.
			]
		    ] loop.
	   ] forkAt:(Processor activeProcess priority + 1).

	aBlock ensure:[
	    process terminate.
	    self cursor:oldCursor
	]
    ].

    "
     View new realize showBusyWhile:[ Delay waitForSeconds:5 ]
     Transcript showBusyWhile:[ Delay waitForSeconds:5 ]
    "

    "Modified: / 31.10.1997 / 19:59:49 / cg"
! !

!SimpleView methodsFor:'dependents access'!

addDependent:anObject
    "make the argument, anObject be a dependent of the receiver"

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    [
	|deps|

	deps := dependents.
	"/
	"/ store the very first dependent directly in
	"/ the dependents instVar
	"/
	(deps isNil and:[anObject isCollection not]) ifTrue:[
	    dependents := anObject
	] ifFalse:[
	    "/
	    "/ store more dependents in the dependents collection
	    "/
	    deps isCollection ifTrue:[
		deps add:anObject
	    ] ifFalse:[
		deps == anObject ifFalse:[
		    deps isNil ifTrue:[
			dependents := (IdentitySet with:anObject)
		    ] ifFalse:[
			dependents := (IdentitySet with:deps with:anObject)
		    ]
		]
	    ]
	]
    ] ensure:[
	wasBlocked ifFalse:[
	    OperatingSystem unblockInterrupts
	]
    ]

    "Modified: 8.1.1997 / 23:40:30 / cg"
    "Created: 11.6.1997 / 13:10:40 / cg"
!

dependents
    "return a Collection of dependents.
     Views keep them in an instance variable to avoid overhead."

    dependents isNil ifTrue:[^ #()].
    dependents isCollection ifTrue:[
	^ dependents
    ].
    ^ IdentitySet with:dependents

    "Created: / 11.6.1997 / 13:10:44 / cg"
    "Modified: / 26.1.1998 / 11:18:36 / cg"
!

dependents:aCollection
    "set the collection of dependents.
     Views keep them in an instance variable to avoid overhead."

    |dep|

    aCollection size == 1 ifTrue:[
	dep := aCollection first.
	dep isCollection ifFalse:[
	    dependents := aCollection first.
	    ^ self
	]
    ].
    dependents := aCollection

    "Modified: 19.4.1996 / 12:23:05 / cg"
    "Created: 11.6.1997 / 13:10:47 / cg"
!

dependentsDo:aBlock
    "evaluate aBlock for all of my dependents.
     Views keep them in an instance variable to avoid overhead."

    |deps|

    deps := dependents.
    deps notNil ifTrue:[
	deps isCollection ifTrue:[
	    deps do:aBlock
	] ifFalse:[
	    aBlock value:deps
	]
    ]

    "Created: 11.6.1997 / 13:10:51 / cg"
!

removeDependent:anObject
    "make the argument, anObject be independent of the receiver"

    |wasBlocked|

    "/ must do this save from interrupts, since the dependents collection
    "/ is possibly accessed from multiple threads.
    "/ Used to use #valueUninterruptably here; inlined that code for slightly
    "/ faster execution.

    wasBlocked := OperatingSystem blockInterrupts.
    [
	|deps sz dep|

	deps := dependents.
	deps notNil ifTrue:[
	    deps isCollection ifTrue:[
		deps remove:anObject ifAbsent:[].
		(sz := deps size) == 0 ifTrue:[
		    dependents := nil
		] ifFalse:[
		    sz == 1 ifTrue:[
			(dep := deps first) isCollection ifFalse:[
			    dependents := dep
			]
		    ]
		]
	    ] ifFalse:[
		deps == anObject ifTrue:[
		    dependents := nil
		]
	    ]
	]
    ] ensure:[
	wasBlocked ifFalse:[
	    OperatingSystem unblockInterrupts
	]
    ]

    "Modified: 8.1.1997 / 23:41:39 / cg"
    "Created: 11.6.1997 / 13:11:58 / cg"
! !

!SimpleView methodsFor:'dependents access (non weak)'!

addNonWeakDependent:anObject
    "make the argument, anObject be a dependent of the receiver.
     Since all dependencies are nonWeak in Model, this is simply
     forwarded to addDependent:"

    ^ self addDependent:anObject

    "Created: 11.6.1997 / 13:15:40 / cg"
!

interests
    "return a Collection of interests - empty if there is none.
     Here, we use the normal dependents collection for interests."

    ^ self dependents

    "Modified: / 14.10.1996 / 22:19:58 / stefan"
    "Created: / 11.6.1997 / 13:15:44 / cg"
    "Modified: / 30.1.1998 / 14:07:48 / cg"
!

nonWeakDependents
    "return a Collection of dependents - empty if there is none.
     Since all dependencies are nonWeak in Model, this is a dummy."

    ^ self dependents

    "Created: / 11.6.1997 / 13:15:48 / cg"
    "Modified: / 30.1.1998 / 14:06:55 / cg"
!

removeNonWeakDependent:anObject
    "make the argument, anObject be independent of the receiver.
     Since all dependencies are nonWeak in Model, this is simply
     forwarded to removeDependent:"

    ^ self removeDependent:anObject

    "Created: 11.6.1997 / 13:15:52 / cg"
! !

!SimpleView methodsFor:'drag & drop'!

canDrop:aDropContext
    "return true, if we can drop using a dropContexts information (the new drop interface).
     This method should be redefined in views which can take objects"

    ^ false

    "Modified: / 13-10-2006 / 16:05:23 / cg"
!

canDrop:aDropContext at:positionInView
    "return true, if we can drop using a dropContexts information (the new drop interface).
     This method should be redefined in views which can take objects"

    ^ self canDrop:aDropContext

    "Modified: / 13-10-2006 / 16:05:42 / cg"
!

canDropObjects:aCollectionOfDropObjects
    "return true, if we can drop aCollectionOfDropObjects (the OLD drop interface).
     This method should be redefined in views which can take objects"

    ^ false

    "Modified: / 13-10-2006 / 16:06:03 / cg"
!

canDropObjects:aCollectionOfDropObjects at:positionInView
    "return true, if we can drop aCollectionOfDropObjects (the OLD drop interface).
     This method should be redefined in views which can take objects"

    ^ self canDropObjects:aCollectionOfDropObjects

    "Modified: / 13-10-2006 / 16:06:15 / cg"
!

dragAutoScroll:aContext
    "called by the DragAndDropManager to scroll during a drag/drop operation
     if necassery (decided by the widget itself);
     If a scroll is done, return true otherwise false (used to restore the background).
     By default false is returned."

    ^ false
!

drop:aDropContext
    "drop manager wants to drop using info in aDropContext (the new drop interface).
     An error here, because this is only sent, if #canDrop: returned true;
     if you redefined #canDrop: in a subclass, #drop: must also be redefined."

    self subclassResponsibility

    "Modified: / 13-10-2006 / 16:07:58 / cg"
!

drop:aDropContext at:aPoint
    "drop manager wants to drop using info in aDropContext (the new drop interface).
     If I have an application, forward the request.
     Otherwise, ignore it. This is only sent, if #canDrop: returned true;
     if you redefined #canDrop: in a subclass, #drop:at: must also be redefined."

    self drop:aDropContext

    "Modified: / 13-10-2006 / 16:07:41 / cg"
!

dropObjects:aCollectionOfDropObjects
    "someone wants to drop aCollectionOfDropObjects (the OLD drop interface).
     An error here, because this is only sent, if #canDrop: returned true;
     if you redefined #canDropObjects: in a subclass, #dropObjects: must also be redefined."

    self subclassResponsibility

    "Created: / 13-10-2006 / 16:06:48 / cg"
!

dropObjects:aCollectionOfDropObjects at:aPoint
    "someone wants to drop aCollectionOfDropObjects (the OLD drop interface).
     An error here, because this is only sent, if #canDrop: returned true;
     if you redefined #canDropObjects: in a subclass, #dropObjects: must also be redefined."

    self dropObjects:aCollectionOfDropObjects

    "Created: / 13-10-2006 / 16:07:03 / cg"
!

dropTarget
    "returns the dropTarget or nil"

    ^ dropTarget
!

dropTarget:aDropTragetOrNil
    "set the dropTarget"

    dropTarget := aDropTragetOrNil.
! !

!SimpleView methodsFor:'edge drawing'!

drawBottomEdge
    "draw bottom 3D edge into window frame"

    self drawBottomEdgeLevel:level
		      shadow:shadowColor
		      light:lightColor
		      halfShadow:nil
		      halfLight:nil
		      style:nil.
!

drawBottomEdgeLevel:level shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
    |botFg
     count "{ Class: SmallInteger }"
     b r|

    count := level.
    count == 0 ifTrue:[^ self].

    (count < 0) ifTrue:[
	botFg := lightColor.
	count := count negated
    ] ifFalse:[
	((edgeStyle == #soft) and:[level > 1]) ifTrue:[
	    botFg := halfShadowColor
	] ifFalse:[
	    botFg := shadowColor
	].
    ].
    super paint:botFg.
    super lineWidth:0.

    r := width - 1.
    0 to:(count - 1) do:[:i |
	b := height - 1 - i.
	super displayDeviceLineFromX:i y:b toX:(r - i) y:b
    ].

    ((edgeStyle == #soft) and:[level > 1]) ifTrue:[
	b := height - 1.
	super paint:shadowColor.
	super displayDeviceLineFromX:1 y:b toX:r y:b.
    ].

    self edgeDrawn:#bottom.

    "Modified: 7.3.1997 / 17:59:39 / cg"
!

drawEdges
    "draw all of my 3D edges"

    self drawEdgesForX:0 y:0 width:width height:height level:level
		shadow:shadowColor
		light:lightColor
		halfShadow:nil
		halfLight:nil
		style:nil
!

drawEdgesForX:x y:y width:w height:h level:l
    "draw 3D edges into a rectangle"

    self
	drawEdgesForX:x y:y width:w height:h level:l
	shadow:shadowColor light:lightColor
	halfShadow:nil halfLight:nil
	style:nil
!

drawLeftEdge
    "draw left 3D edge into window frame"

    self drawLeftEdgeLevel:level
		    shadow:shadowColor
		     light:lightColor
		     halfShadow:nil
		     halfLight:nil
		     style:nil.
!

drawLeftEdgeLevel:level shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
    |leftFg leftHalfFg paint b
     count "{ Class: SmallInteger }" |

    count := level.
    count == 0 ifTrue:[^ self].

    (count < 0) ifTrue:[
	leftFg := shadowColor.
	leftHalfFg := halfShadowColor.
	count := count negated.
    ] ifFalse:[
	leftFg := lightColor.
	leftHalfFg := halfLightColor.
    ].
    leftHalfFg isNil ifTrue:[
	leftHalfFg := leftFg
    ].

    ((edgeStyle == #soft) and:[level > 0]) ifTrue:[
	paint := leftHalfFg
    ] ifFalse:[
	paint := leftFg
    ].
    super paint:paint.
    super lineWidth:0.

    b := height - 1.
    0 to:(count - 1) do:[:i |
	super displayDeviceLineFromX:i y:i toX:i y:(b - i)
    ].

    ((edgeStyle == #soft) and:[level > 2]) ifTrue:[
	super paint:(device blackColor).
	super displayDeviceLineFromX:0 y:0 toX:0 y:b.
    ].

    self edgeDrawn:#left.

    "Modified: 7.3.1997 / 17:59:53 / cg"
!

drawRightEdge
    "draw right 3D edge into window frame"

    self drawRightEdgeLevel:level
		     shadow:shadowColor
		      light:lightColor
		      halfShadow:nil
		      halfLight:nil
		      style:nil.
!

drawRightEdgeLevel:level shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
    |rightFg
     count "{ Class: SmallInteger }"
     r b|

    count := level.
    count == 0 ifTrue:[^ self].

    (count < 0) ifTrue:[
	rightFg := lightColor.
	count := count negated
    ] ifFalse:[
	((edgeStyle == #soft) and:[level > 1]) ifTrue:[
	    rightFg := halfShadowColor
	] ifFalse:[
	    rightFg := shadowColor
	].
    ].
    super paint:rightFg.
    super lineWidth:0.

    b := height - 1.
    0 to:(count - 1) do:[:i |
	r := width - 1 - i.
	super displayDeviceLineFromX:r y:i toX:r y:(b - i)
    ].
    ((edgeStyle == #soft) and:[level > 1]) ifTrue:[
	r := width - 1.
	super paint:shadowColor.
	super displayDeviceLineFromX:r y:1 toX:r y:b.
    ].

    self edgeDrawn:#right.

    "Modified: 7.3.1997 / 18:00:02 / cg"
!

drawTopEdge
    "draw top 3D edge into window frame"

    self drawTopEdgeLevel:level
		   shadow:shadowColor
		    light:lightColor
		    halfShadow:nil
		    halfLight:nil
		    style:nil.
!

drawTopEdgeLevel:level atY:y shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
    |topFg topHalfFg paint r
     count "{ Class: SmallInteger }" |

    count := level.
    count == 0 ifTrue:[^ self].

    (count < 0) ifTrue:[
	topFg := shadowColor.
	topHalfFg := halfShadowColor.
	count := count negated
    ] ifFalse:[
	topFg := lightColor.
	topHalfFg := halfLightColor.
    ].
    topHalfFg isNil ifTrue:[
	topHalfFg := topFg
    ].

    ((edgeStyle == #soft) and:[level > 0]) ifTrue:[
	paint := topHalfFg
    ] ifFalse:[
	paint := topFg
    ].
    super paint:paint.
    super lineWidth:0.

    r := width - 1.
    0 to:(count - 1) do:[:i |
	super displayDeviceLineFromX:i y:y+i toX:(r - i) y:y+i
    ].
    ((edgeStyle == #soft) and:[level > 2]) ifTrue:[
	super paint:(device blackColor).
	super displayDeviceLineFromX:0 y:y+0 toX:r y:y+0.
    ].

    self edgeDrawn:#top.

    "Modified: 7.3.1997 / 18:00:11 / cg"
!

drawTopEdgeLevel:level shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
    self drawTopEdgeLevel:level atY:0 shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
!

drawTopEdgeLevel:level y:y shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
    |topFg topHalfFg paint r
     count "{ Class: SmallInteger }" |

    count := level.
    count == 0 ifTrue:[^ self].

    (count < 0) ifTrue:[
	topFg := shadowColor.
	topHalfFg := halfShadowColor.
	count := count negated
    ] ifFalse:[
	topFg := lightColor.
	topHalfFg := halfLightColor.
    ].
    topHalfFg isNil ifTrue:[
	topHalfFg := topFg
    ].

    ((edgeStyle == #soft) and:[level > 0]) ifTrue:[
	paint := topHalfFg
    ] ifFalse:[
	paint := topFg
    ].
    super paint:paint.
    super lineWidth:0.

    r := width - 1.
    0 to:(count - 1) do:[:i |
	super displayDeviceLineFromX:i y:i toX:(r - i) y:i
    ].
    ((edgeStyle == #soft) and:[level > 2]) ifTrue:[
	super paint:(device blackColor).
	super displayDeviceLineFromX:0 y:0 toX:r y:0.
    ].

    self edgeDrawn:#top.

    "Modified: 7.3.1997 / 18:00:11 / cg"
!

redrawEdges
    "redraw my edges (if any)"

    (level ~~ 0) ifTrue:[
	shown ifTrue:[
	    gc clippingBounds:nil.
	    self drawEdges.
	    gc deviceClippingBounds:innerClipRect
	]
    ]

    "Modified: / 25.5.1999 / 14:50:25 / cg"
! !

!SimpleView methodsFor:'enumerating view hierarchy'!

allSubViewsDetect:aBlock ifNone:exceptionValue
    "find a subview for which aBlock returns true (recursively).
     If there is none, return the value from exceptionValue"

    subViews notNil ifTrue:[
	subViews do:[:aSubview |
	    |v|

	    (aBlock value:aSubview) ifTrue:[ ^ aSubview ].
	    v := aSubview allSubViewsDetect:aBlock ifNone:nil.
	    v notNil ifTrue:[^ v].
	]
    ].
    ^ exceptionValue value.

    "Modified: 12.2.1997 / 12:23:38 / cg"
!

allSubViewsDo:aBlock
    "evaluate aBlock for all subviews (recursively)"

    subViews notNil ifTrue:[
	subViews do:[:aSubview |
	    aSubview withAllSubViewsDo:aBlock
	]
    ]

    "Modified: 12.2.1997 / 12:23:38 / cg"
!

allSuperViewsDetect:aBlock ifNone:exceptionValue
    "find a container for which aBlock returns true (recursively).
     If there is none, return the value from exceptionValue"

    |v|

    v := self container.
    [v notNil] whileTrue:[
	(aBlock value:v) ifTrue:[^ v].
	v := v container.
    ].
    ^ exceptionValue value
!

allSuperViewsDo:aBlock
    "evaluate aBlock for all superviews (recursively)"

    |v|

    v := self container.
    [v notNil] whileTrue:[
	aBlock value:v.
	v := v container.
    ].
!

allVisibleSubViewsDetect:aBlock ifNone:exceptionBlock
    "find a visible subview for which aBlock returns true (recursively)"

    subViews notNil ifTrue:[
	subViews do:[:aSubview |
	    |v|

	    aSubview shown ifTrue:[
		(aBlock value:aSubview) ifTrue:[ ^ aSubview ].
		v := aSubview allVisibleSubViewsDetect:aBlock ifNone:nil.
		v notNil ifTrue:[^ v].
	    ].
	]
    ].
    ^ exceptionBlock value.
!

changeSequenceOrderFor:aSubViewOrComponent to:anIndex
    "change a subview's position in the subviews collection.
     Usually, this only affects the order of components in a panelView,
     unless they overlap. In that case, the later view is placed above the earlier."

    aSubViewOrComponent isView ifFalse:[
	^ self changeSequenceOrderForComponent:aSubViewOrComponent to:anIndex
    ].
    ^ self changeSequenceOrderForView:aSubViewOrComponent to:anIndex
!

changeSequenceOrderForComponent:aComponent to:anIndex
    "change a components's position in the components collection.
     The later components is drawn above the earlier."

    |removedComponent|

    (components notNil and:[components size >= anIndex]) ifTrue:[
	removedComponent := components remove:aComponent ifAbsent:nil.
	removedComponent notNil ifTrue:[
	    components add:removedComponent beforeIndex:anIndex.
	    ^ true
	]
    ].
    ^ false
!

changeSequenceOrderForView:aSubView to:anIndex
    "change a subview's position in the subviews collection.
     Usually, this only affects the order of components in a panelView,
     unless they overlap. In that case, the later view is placed above the earlier."

    |removedView|

    (subViews notNil and:[subViews size >= anIndex]) ifTrue:[
	removedView := subViews remove:aSubView ifAbsent:nil.
	removedView notNil ifTrue:[
	    subViews add:removedView beforeIndex:anIndex.
	    ^ true
	]
    ].
    ^ false
!

withAllSubViewsDo:aBlock
    "evaluate aBlock for the receiver and all subviews (recursively)"

    aBlock value:self.
    self allSubViewsDo:aBlock
! !

!SimpleView methodsFor:'event handling'!

alienDrop:aCollectionOfDropObjects position:positionOrNil
    "a drop from some other non-ST/X application."

    |view positionInView tDelayed
     anyNonExisting whichNonExisting checkForAnyNonExisting
     app target dropContext|

    "/ mhmh - sometimes, the dropped file is not present.
    "/ how comes ? And what should be done to avoid this ?

    checkForAnyNonExisting :=
	[
	    anyNonExisting := false.
	    aCollectionOfDropObjects do:[:eachDropObject |
		eachDropObject isFileObject ifTrue:[
		    eachDropObject isDirectory ifFalse:[
			eachDropObject theObject asFilename exists ifFalse:[
			    anyNonExisting := true.
			    whichNonExisting := eachDropObject theObject asFilename.
			]
		    ]
		].
	    ].
	    anyNonExisting
	].

    self withWaitCursorDo:[
	tDelayed := 0.
	checkForAnyNonExisting doWhile:[
	    anyNonExisting ifTrue:[
		Delay waitForSeconds:0.3.
		tDelayed := tDelayed + 0.3.
	    ].
	    anyNonExisting and:[ tDelayed <= 3].
	].
    ].

    (anyNonExisting and:[checkForAnyNonExisting value]) ifTrue:[
	Dialog warn:('Dropfile not present: %1' bindWith:whichNonExisting pathName).
	^ self
    ].

    view := self.
    positionInView := positionOrNil.

    app := view application.
    app notNil ifTrue:[
	(app canDropObjects:aCollectionOfDropObjects in:view at:positionInView) ifTrue:[
	    app dropObjects:aCollectionOfDropObjects in:view at:positionInView.
	    ^ self.
	].
    ].

    [view notNil] whileTrue:[
	"new mechanism to get a dropTarget"
	target := view dropTarget.
	target notNil ifTrue:[
	    dropContext := DropContext new.
	    dropContext dropObjects:aCollectionOfDropObjects.
	    dropContext dropTarget:target.

	    (target canDrop:dropContext) ifTrue:[
		target drop:dropContext.
		^ self.
	    ].
	].

	(view canDropObjects:aCollectionOfDropObjects at:positionInView) ifTrue:[
	    view dropObjects:aCollectionOfDropObjects at:positionInView.
	    ^ self.
	].
	view := view superView.
	positionInView := nil.
    ]

    "Modified: / 17-10-2006 / 18:00:46 / cg"
!

buttonMotion:state x:x y:y
    "button was moved"

    self topView == TopView currentWindowBeingMoved ifTrue:[
	self topView doWindowMove.
	^ self.
    ].

    "Created: / 03-03-2011 / 19:11:11 / cg"
!

buttonMultiPress:button x:x y:y
    "button was pressed quickly again - check my components for a hit."

    components notNil ifTrue:[
	self componentsContainingX:x y:y do:[:comp :cx :cy |
	    comp buttonMultiPress:button x:cx y:cy.
	    ^ self
	]
    ].

    super buttonMultiPress:button x:x y:y

    "Modified: / 08-05-1996 / 23:43:41 / cg"
    "Created: / 13-09-2006 / 16:34:23 / User"
!

buttonPress:button x:x y:y
    "button was pressed - check my components for a hit."

    |topView|

    components notNil ifTrue:[
	self componentsContainingX:x y:y do:[:comp :cx :cy |
	    comp buttonPress:button x:cx y:cy.
	    ^ self
	]
    ].

    "/ an undecorated (but modeless) topView -> do a window move
    (topView := self topView) startWindowMoveOnButtonPress ifTrue:[
	topView startWindowMove.
	^ self.
    ].

    super buttonPress:button x:x y:y

    "Modified: / 04-03-2011 / 08:57:01 / cg"
!

buttonRelease:button x:x y:y
    "button was released - check my components for a hit."

    components notNil ifTrue:[
	self componentsContainingX:x y:y do:[:comp :cx :cy |
	    comp buttonRelease:button x:cx y:cy.
	    ^ self
	]
    ].

    self topView == TopView currentWindowBeingMoved ifTrue:[
	self topView endWindowMove.
	^ self.
    ].

    super buttonRelease:button x:x y:y

    "Created: / 08-05-1996 / 23:43:25 / cg"
    "Modified: / 03-03-2011 / 19:23:48 / cg"
!

changeScaleForMouseWheelZoom:amount
    "CTRL-wheel action.
     ignored here - redefined in views which can zoom"

    |oldScale newScale factor|

    amount > 0 ifTrue:[
	factor := 1.2.
    ] ifFalse:[
	factor := 0.8.
    ].
    oldScale := self scale.
    newScale := (oldScale * factor) max:0.1.
    self scale:newScale.
    self invalidate.
!

clientMessage:msgType format:msgFormat eventData:msgData
    "a client message - very X-specific and only useful for special applications.
     Forwarded to my application (if I have one)"

    |app|

    (app := self application) notNil ifTrue:[
	app clientMessage:msgType format:msgFormat eventData:msgData
    ].
!

closeRequest
    "programmatic close request"

    self destroy

    "Modified: / 3.8.1998 / 19:50:50 / cg"
!

configureX:x y:y width:newWidth height:newHeight
    "my size has changed by window manager action"

    |how anyEdge mustRedrawBottomEdge mustRedrawRightEdge
     mustRedrawPreviousRightBorderArea mustRedrawPreviousBottomBorderArea p originChanged
     oldWidth oldHeight|

    originChanged := (left ~= x) or:[top ~= y].

    left := x.
    top := y.

    (superView isNil
    and:[self drawableId notNil]) ifTrue:[
        "/ have to be careful - some window managers (motif) wrap another
        "/ view around and the reported origin is relative to that.
        "/ not relative to the screen.
        p := device translatePoint:0@0 fromView:self toView:nil.
        p := p + self borderWidth.
        left := p x.
        top := p y.
    ].

    ((width ~~ newWidth) or:[height ~~ newHeight]) ifTrue:[
        realized ifFalse:[
            width := newWidth.
            height := newHeight.
            self extentChangedFlag:true.
            ^ self
        ].

        ((newWidth <= width) and:[newHeight <= height]) ifTrue:[
            how := #smaller
        ] ifFalse:[
            ((newWidth >= width) and:[newHeight >= height]) ifTrue:[
                how := #larger
            ]
        ].

        margin ~~ 0 ifTrue:[
            mustRedrawBottomEdge := newHeight < height.
            mustRedrawRightEdge := newWidth < width.
            anyEdge := mustRedrawBottomEdge or:[mustRedrawRightEdge].

            mustRedrawPreviousRightBorderArea := newWidth > width.
            mustRedrawPreviousBottomBorderArea := newHeight > height.
        ] ifFalse:[
            anyEdge := mustRedrawPreviousRightBorderArea := mustRedrawPreviousBottomBorderArea := false
        ].

        mustRedrawPreviousRightBorderArea ifTrue:[
            self invalidateDeviceRectangle:((width-margin)@0 extent:margin@height) repairNow:false.
        ].
        mustRedrawPreviousBottomBorderArea ifTrue:[
            self invalidateDeviceRectangle:((0 @ (height-margin)) extent:width@margin) repairNow:false.
        ].

        oldWidth := width.
        oldHeight := height.
        
        width := newWidth.
        height := newHeight.

        "recompute inner-clip if needed"
        self setInnerClip.

        "
         must first process pending exposes;
         otherwise, those may be drawn at a wrong position
        "
        "/ claus: no; expose events are in the same queue as configure events;
        "/        which is exactly for that reason ...

        "/        windowGroup notNil ifTrue:[
        "/            windowGroup processExposeEvents
        "/        ].
        self sizeChanged:how from:(oldWidth@oldHeight).

        (anyEdge and:[shown]) ifTrue:[
            mustRedrawBottomEdge ifTrue:[
                self invalidateDeviceRectangle:((0 @ (height-margin)) extent:width@margin) repairNow:false.
            ].
            mustRedrawRightEdge ifTrue:[
                self invalidateDeviceRectangle:((width-margin)@0 extent:margin@height) repairNow:false.
            ].
        ]
    ].

    originChanged ifTrue:[
        dependents notNil ifTrue:[ self changed:#origin ].
    ].

    "Modified: / 10.10.2001 / 14:14:19 / cg"
!

containerChangedSize
    "my container has changed size; if I have relative
     origin/extent or blocks to evaluate, do it now .."

    |oldWidth oldHeight oldTop oldLeft newExt newOrg r|

    oldWidth := width.
    oldHeight := height.
    oldTop := top.
    oldLeft := left.

    "
     slowly migrating to use layoutObjects ...
    "
    layout isNil ifTrue:[
	newOrg := self computeOrigin.
	newExt := self computeExtent.
    ] ifFalse:[layout isAssociation ifTrue:[
	layout key == #extent ifTrue:[
	    newOrg := 1@1.
	    newExt := layout value.
	] ifFalse:[
	    self shouldImplement.
	].
    ] ifFalse:[
	r := (layout rectangleRelativeTo:(superView viewRectangle)
			       preferred:[self preferredBounds]).
	newOrg := r origin rounded.
	newExt := r extent rounded.
"/ newOrg printCR.
"/ newExt printCR.
    ]].

"/    newOrg notNil ifTrue:[
"/        ((newOrg x == oldLeft) and:[newOrg y == oldTop]) ifTrue:[
"/            newOrg := nil
"/        ]
"/    ].
"/    newExt notNil ifTrue:[
"/        ((newExt x == width) and:[newExt y == height]) ifTrue:[
"/            newExt := nil
"/        ]
"/    ].
"/
"/    newExt isNil ifTrue:[
"/        newOrg notNil ifTrue:[
"/            self pixelOrigin:newOrg
"/        ]
"/    ] ifFalse:[
"/        newOrg isNil ifTrue:[
"/            self pixelExtent:newExt
"/        ] ifFalse:[
"/            self pixelOrigin:newOrg extent:newExt
"/        ]
"/    ]
    self pixelOrigin:newOrg extent:newExt

    "Modified: 19.7.1996 / 17:32:50 / cg"
!

containerMapped
    "my container was mapped (became visible).
     If I was previously realized, this implies that I myself
     am now mapped as well."

    "/ if I was not previously shown, tell it to all of
    "/ my subviews (they remember this in the shown instVar)

    realized ifTrue:[
	shown ifFalse:[
"/ old:
"/            shown := true.
"/            subViews notNil ifTrue:[
"/                subViews do:[:v |
"/                    v containerMapped
"/                ]
"/            ]

"/ which is equivalent to:
	    self mapped.
	]
    ].

    "Modified: 30.5.1996 / 11:41:02 / cg"
    "Created: 19.7.1996 / 17:41:10 / cg"
!

containerUnmapped
    "my container was unmapped
     - this implies that the receiver is now also unmapped."

    "/ if I was previously shown, tell it to all of
    "/ my subviews (they remember this in the shown instVar)

    realized ifTrue:[
	shown ifTrue:[
	    self unmapped
	]
    ]

    "Modified: 30.5.1996 / 11:41:25 / cg"
    "Created: 19.7.1996 / 17:43:50 / cg"
!

copyDataEvent:parameter eventData:msgData
    "a copyData message - very Win32-specific and only useful for special applications.
     Forwarded to my application (If I have one)"

    |app|

    (app := self application) notNil ifTrue:[
	app copyDataEvent:parameter eventData:msgData
    ].
!

createWindowX:x y:y width:w height:h

    "A window has been created in myself, nothing to do here.
     Note, that SubstructureNotify events must be enabled to get
     this event. To enable, do:

    self enableEvent: #substructureNotify

    "

    "Created: / 01-06-2011 / 12:59:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

destroyed
    "view has been destroyed by someone else (usually window system)"

    shown ifTrue:[
	shown := false.
	dependents notNil ifTrue:[
	    self changed:#visibility.
            self changed:#destroyed 
	].
    ].
    super destroyed

    "Modified: / 18.2.2000 / 11:20:34 / cg"
!

dropMessage:dropTypeSymbol data:dropValue position:dropPosition handle:dropHandle
    "a drop from some other window (X: DND or Win32 drag&drop).
     Convert to the ST/X drag and drop protocol here."

    |dropObjects|

    (dropTypeSymbol == WindowEvent dropType_file
    or:[dropTypeSymbol == WindowEvent dropType_directory]) ifTrue:[
	dropObjects := Array with:(DropObject newFile:dropValue)
    ] ifFalse:[
	dropTypeSymbol == WindowEvent dropType_files ifTrue:[
	   dropObjects := (dropValue collect:[:fn | DropObject newFile:fn])
	] ifFalse:[
	    dropTypeSymbol == WindowEvent dropType_text ifTrue:[
	       dropObjects := Array with:(DropObject newText:dropValue)
	    ] ifFalse:[
	       dropObjects := Array with:(DropObject new:dropValue)
	    ]
	]
    ].

"/    Transcript showCR:'Drop:'.
"/    Transcript show:'  View:'; showCR:self.
"/    Transcript show:'  Position:'; showCR:dropPosition.
"/    Transcript show:'  Data:'; showCR:dropObjects.

    self alienDrop:dropObjects position:dropPosition.
    device dragFinish:dropHandle.

    "Modified: / 13-10-2006 / 10:10:23 / cg"
!

exposeX:x y:y width:w height:h
    "a low level redraw event from device
      - let subclass handle the redraw and take care of edges here"

    |leftEdge topEdge rightEdge botEdge anyEdge nx ny nw nh old oldPaint|

    shown ifFalse:[
	^ self
    ].
    "/ JV@2016-02-21: Double check to make sure GC is not already destroyed
    "/ to avoid 'attempt to draw to closed drawable. Not sure how this could 
    "/ happen but apparently it sometimes happens...
    gc drawableId isNil ifTrue:[
        ^ self
    ].

    nw := w.
    nh := h.
    nx := x.
    ny := y.

    anyEdge := false.

    "
     check if there is a need to draw an edge (i.e. if margin is hit)
    "
    (margin ~~ 0) ifTrue:[
	|currentTransformation|

	leftEdge := false.
	topEdge := false.
	rightEdge := false.
	botEdge := false.
	currentTransformation := gc transformation.
	currentTransformation notNil ifTrue:[
	    "
	     need device coordinates for this test
	    "
	    nx := currentTransformation applyToX:nx.
	    ny := currentTransformation applyToY:ny.
	    nw := currentTransformation applyScaleX:nw.
	    nh := currentTransformation applyScaleY:nh.
	].
	"
	 adjust expose rectangle, to exclude the margin.
	 Care for rounding errors ...
	"
	(nx class ~~ SmallInteger) ifTrue:[
	    old := nx.
	    nx := nx truncated.
	    nw := nw + (nx - old).
	].
	(ny class ~~ SmallInteger) ifTrue:[
	    old := ny.
	    ny := ny truncated.
	    nh := nh + (ny - old).
	].
	(nw class ~~ SmallInteger) ifTrue:[
	    nw := nw truncated + 1
	].
	(nh class ~~ SmallInteger) ifTrue:[
	    nh := nh truncated + 1
	].

	(nx < margin) ifTrue:[
	    old := nx.
	    nx := margin.
	    nw := nw - (nx - old).
	    leftEdge := anyEdge := true.
	].
	((nx + nw - 1) >= (width - margin)) ifTrue:[
	    nw := (width - margin - nx).
	    rightEdge := anyEdge := true.
	].
	(ny < margin) ifTrue:[
	    old := ny.
	    ny := margin.
	    nh := nh - (ny - old).
	    topEdge := anyEdge := true.
	].
	((ny + nh - 1) >= (height - margin)) ifTrue:[
	    nh := (height - margin - ny).
	    botEdge := anyEdge := true.
	].
	currentTransformation notNil ifTrue:[
	    "
	     need logical coordinates for redraw
	    "
	    nx := currentTransformation applyInverseToX:nx.
	    ny := currentTransformation applyInverseToY:ny.
	    nw := currentTransformation applyInverseScaleX:nw.
	    nh := currentTransformation applyInverseScaleY:nh.
	].
    ].

    (nw > 0 and:[nh > 0]) ifTrue:[
	"
	 redraw inside area
	"
	self
	    clippingBounds:(Rectangle left:nx top:ny width:nw height:nh);
	    redrawX:nx y:ny width:nw height:nh.
    ].

    "
     redraw edge(s)
    "
    anyEdge ifTrue:[
	self clippingBounds:nil.
	oldPaint := self paint.
	border notNil ifTrue:[
	    border displayOn:self forDisplayBox:(Rectangle left:0 top:0 width:width height:height).
	] ifFalse:[
	    (topEdge and:[leftEdge and:[botEdge and:[rightEdge]]]) ifTrue:[
		self drawEdges
	    ] ifFalse:[
		topEdge ifTrue:[
		    self drawTopEdge
		].
		leftEdge ifTrue:[
		    self drawLeftEdge
		].
		botEdge ifTrue:[
		    self drawBottomEdge
		].
		rightEdge ifTrue:[
		    self drawRightEdge
		]
	    ].
	].
	self paint:oldPaint.
    ].
    gc deviceClippingBounds:innerClipRect.

    "Modified: / 25.5.1999 / 14:57:38 / cg"
!

focusIn
    "got keyboard focus (via the window manager).
     Nothing done here"

    ^ self
!

focusOut
    "lost keyboard focus (via the window manager).
     Nothing done here"
!

hasKeyboardFocus:aBoolean
    "notification from the windowGroup that I got the keyboardFocus."

    delegate notNil ifTrue:[
	delegate perform:#hasKeyboardFocus: with:aBoolean ifNotUnderstood:nil
    ].
    ^ self
!

keyPress:key x:x y:y
    "a key has been pressed. If there are components,
     pass it to the corresponding one.
     Otherwise, forward it to the superview, if there is any."

    <resource: #keyboard ( #Menu 
                           #ZoomIn #ZoomOut
                           #ZoomInAll #ZoomOutAll) >

    |focusView|

    components notNil ifTrue:[
	components notNil ifTrue:[
	    self componentsContainingX:x y:y do:[:comp :cx :cy |
		comp keyPress:key x:cx y:cy.
		^ self
	    ]
	].
    ].

    key == #Menu ifTrue:[
	((focusView := self windowGroup focusView) notNil
	and:[focusView ~~ self])
	ifTrue:[
	   "/ forward to the focusView
	   focusView keyPress:key x:-1 y:-1.
	    ^ self
	].
	^ self activateMenu.
    ].

    (key == #ZoomIn or:[key == #ZoomOut]) ifTrue:[ 
        self keyboardZoom:(key == #ZoomIn).
        ^ self
    ].
    (key == #ZoomInAll or:[key == #ZoomOutAll]) ifTrue:[ 
        self keyboardZoomInAllViews:(key == #ZoomInAll).
        ^ self
    ].

    x isNil ifTrue:[
	"/ already redelegated, but nowhere handled
	superView notNil ifTrue:[
	    superView keyPress:key x:nil y:nil.
	].
	^ self
    ].

    superView notNil ifTrue:[
	superView
	    dispatchEvent:#keyPress:x:y:
	    arguments:(Array with:key with:0 with:0)

"/        WindowEvent
"/            sendEvent:#keyPress:x:y:
"/            arguments:(Array with:key with:0 with:0)
"/            view:superView
    ] ifFalse:[
	super keyPress:key x:x y:y
    ]

    "Modified: / 20.5.1998 / 22:55:08 / cg"
!

keyRelease:key x:x y:y
    "a key has been released. If there are components,
     pass it to the corresponding one.
     Otherwise, do whatever my superclass would do."

    components notNil ifTrue:[
	components notNil ifTrue:[
	    self componentsContainingX:x y:y do:[:comp :cx :cy |
		comp keyRelease:key x:cx y:cy.
		^ self
	    ]
	].
    ].

    super keyRelease:key x:x y:y

    "Modified: 8.5.1996 / 23:44:36 / cg"
    "Created: 8.5.1996 / 23:45:28 / cg"
!

keyboardZoom:larger
    "CTRL+/- action.
     ignored here - redefined in views which can zoom"

    "/ self changeScaleForMouseWheelZoom:amount
!

keyboardZoomInAllViews:larger 
    "CTRL+/- zoom action global.
     Sent to all windows; some may ignore it."

    self device allViewsDo:[:each |
        each keyboardZoom:larger 
    ].    
!

mapped
    "the view has been mapped (by some outside
     action - i.e. window manager de-iconified me)"

    |shownBefore|

    "
     the old code was:

	realized := true.
	shown := true.
	...

     this created a race condition, if the view was
     realized and shortly after unrealized - before the mapped event
     arrived. This lead to realized being set to true even thought the
     view was not.
     Boy - that was a bad one (hard to reproduce and hard to find).
    "

    realized ifTrue:[
	shownBefore := shown.

	"/ currently, the 'shown ifFalse:' optimization is
	"/ not ok, since 'shown' is also modified by visibilityChanges.
	"/ Also, when remapped, X11 only sends a mapped event for the topView.
	"/ Therefore, synthetically generate those #superViewMapped messages
	"/ in any case.

	shown := true.
	"
	 backed views will not get expose events - have
	 to force a redraw here to get things drawn into
	 backing store.
	"
	backed ifTrue:[
	    self redrawX:0 y:0 width:width height:height
	].

	"/ tell my subViews ...
	subViews notNil ifTrue:[
            subViews do:[:v | 
"/                v shown ifFalse:[
		    v  mapped.
"/                ]
	    ]
	].
	shownBefore ~~ true ifTrue:[
	    dependents notNil ifTrue:[ self changed:#visibility ].
	].
	self takeFocusWhenMapped ifTrue:[
	    "/ this is a one-shot!!
	    self takeFocusWhenMapped:false.
	    self assignKeyboardFocusToFirstKeyboardConsumer.
	    "/ self requestFocus
	].
    ]

    "Modified: / 09-12-2010 / 18:12:24 / cg"
!

mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime
    "the mouseWheel was turned - handle as a scroll operation.
     Specialized application windows may redefine this for any other
     operation.
     Here, we scroll some amount which depends upon the view's contents height
     (but never too much);
     if shift is pressed, always scroll a single scroll-step;
     if ctrl is pressed, always scroll one page."

    |horizontal pageScroll amountToScroll zoomInOrOut sensor|

    sensor := self sensor.

    UserPreferences current allowMouseWheelZoom ifTrue:[
        zoomInOrOut := sensor ctrlDown or:[sensor metaDown].
        zoomInOrOut ifTrue:[
            self mouseWheelZoom:amount.
            ^ self.
        ].
    ].

    horizontal := pageScroll := false.
    (UserPreferences current shiftMouseWheelScrollsHorizontally) ifTrue:[
        horizontal := sensor shiftDown
    ] ifFalse:[                              
        pageScroll := sensor shiftDown.
    ].
    
    pageScroll ifFalse:[
        amountToScroll := horizontal 
                            ifTrue:[ self horizontalScrollStep]
                            ifFalse:[ self verticalScrollStep ].
        amountToScroll := self scaleMouseWheelScrollAmount:amountToScroll.
    ].

    amount > 0 ifTrue:[
        pageScroll ifTrue:[
            horizontal ifTrue:[self pageLeft] ifFalse:[self pageUp]
        ] ifFalse:[
            horizontal ifTrue:[self scrollLeft:amountToScroll] ifFalse:[self scrollUp:amountToScroll]
        ]
    ] ifFalse:[
        pageScroll ifTrue:[
            horizontal ifTrue:[self pageRight] ifFalse:[self pageDown]
        ] ifFalse:[
            horizontal ifTrue:[self scrollRight:amountToScroll] ifFalse:[self scrollDown:amountToScroll]
        ]
    ].

    "Modified: / 21.5.1999 / 19:58:42 / cg"
!

mouseWheelZoom:amount
    "CTRL-wheel action.
     ignored here - redefined in views which can zoom"

"/    self changeScaleForMouseWheelZoom:amount
!

pointerEnter:state x:x y:y
    "mouse pointer entered - request the keyboard focus (sometimes)"

    |doRequestFocus|

    "/ first ask my flags if its enforced or forbidden
    self requestFocusOnPointerEnter ifTrue:[
        doRequestFocus := true
    ] ifFalse:[
        self doNotRequestFocusOnPointerEnter ifTrue:[
            doRequestFocus := false
        ] ifFalse:[
            "/ then look for the settings.
            doRequestFocus := self wantsFocusWithPointerEnter
        ]
    ].

    doRequestFocus ifTrue:[
        self requestFocus.
    ].
    dependents notNil ifTrue:[ self changed:#pointerInView with:true ]
    
    "Modified: / 01-08-2012 / 17:06:41 / cg"
!

pointerLeave:buttonState
    "mouse pointer left"

    super pointerLeave:buttonState.
    dependents notNil ifTrue:[ self changed:#pointerInView with:false]
!

propertyChange:propertyId state: state

    "A property has changed, nothing to do here.
     Note:
     This is very X specific. PropertyChange events must be enabled
     to get this event. To enable, do:

    self enableEvent: #propertyChange

    "

    "Created: / 01-06-2011 / 13:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reparented
    "the view has changed its parent by some outside
     action - i.e. window manager has added a frame.
     nothing done here"

    ^ self
!

requestAutoAccept
    "request to accept: this is invoked when a dialog closes via accept or cancel.
     This forces my value to be accepted into my model.
     Any widget may suppress the ok/cancel, by returning false."

    ^ true
!

saveAndTerminate
    "window manager wants me to save and go away;
     - notice, that not all window managers are nice enough to
       send this event, but simply destroy the view instead.
     Can be redefined in subclasses to do whatever is required
     to prepare for restart."

    self closeRequest

    "Modified: / 3.8.1998 / 19:51:26 / cg"
!

scaleMouseWheelScrollAmount:amountToScroll
    |hCont factor innerHeight|

    "/ test whether innerHeight == 0
    "/ could happen if the view is resized to 0 (panel)
    innerHeight := self innerHeight.
    innerHeight > 0 ifFalse:[ ^ 1 ].

    hCont := self heightOfContents.
    hCont > (innerHeight * 3) ifTrue:[
	factor := (hCont // innerHeight) min:4.
	^ amountToScroll * factor.
    ].
    ^ amountToScroll
!

sizeChanged:how
    "tell subviews that I changed size.
     How is either #smaller, #larger or nil, and is used to control the order,
     in which subviews are notified (possibly reducing redraw activity)"

    |subViews|

    viewBackground isViewBackground ifTrue:[
	"/ there is only one, which needs this: a gradient over the actual height/width;
	"/ this cannot just fill the new exposed area, but must recompute the gradient scales
	(viewBackground needsFullRedrawOnChangeOfWidth
	or:[ viewBackground needsFullRedrawOnChangeOfHeight]) ifTrue:[
	    self invalidate
	]
    ].    

    (subViews := self subViews) notEmptyOrNil ifTrue:[
	(how isNil "false"
	or:[how == #smaller]) ifTrue:[
	    subViews do:[:view |
		view notNil ifTrue:[
		    view containerChangedSize
		]
	    ]
	] ifFalse:[
	    "doing it reverse speeds up resizing - usually subviews
	     are created from top-left to bottom-right; therefore
	     bottom-right views will be moved/resized first, then top-left ones;
	     this avoids multiple redraws of subviews"

	    subViews reverseDo:[:view |
		view notNil ifTrue:[
		    view containerChangedSize
		]
	    ]
	]
    ].

    components notNil ifTrue:[
	(how isNil "false"
	or:[how == #smaller]) ifTrue:[
	    components do:[:view |
		view containerChangedSize
	    ]
	] ifFalse:[
	    "doing it reverse speeds up resizing - usually subviews
	     are created from top-left to bottom-right; therefore
	     bottom-right views will be moved/resized first, then top-left ones;
	     this avoids multiple redraws of subviews"

	    components reverseDo:[:view |
		view containerChangedSize
	    ]
	]
    ].

    self changed:#sizeOfView with:how.

    superView notNil ifTrue:[
	superView subViewChangedSize
    ]

    "Modified: / 2.4.1998 / 13:59:59 / cg"
!

sizeChanged:how from:oldExtent
    "tell subviews that I changed size.
     How is either #smaller, #larger or nil, and is used to control the order,
     in which subviews are notified (possibly reducing redraw activity).

     In previous versions, there was only one argument, how,
     which was either #smaller or #larger or nil (if not known).
     This argument was used in some widgets to optimize (avoid) some recomputations.
     However, it was too unspecific on which dimension changed;
     therefore, now this method is called.
     For backward compatibility, it calls the old sizeChanged: method.
     If you redefine this, make sure to call super sizeChanged:, not super sizeChanged:from:,
     to avoid an endless recursion."
     
    self sizeChanged:how
!

subViewChangedSize
    "some subview has changed its size; we are not interested
     in that here, but some geometry managers redefine this, to reorganize
     components if that happens."

    "/ Inform the GC
    gc subViewChangedSizeOrOrigin.
    ^ self

    "Created: / 22-09-1995 / 14:44:59 / claus"
    "Modified: / 02-04-2016 / 15:36:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

terminate
    "window manager wants me to go away;
     - notice, that not all window managers are nice enough to
       send this event, but simply destroy the view instead.
     Can be redefined in subclasses to do whatever cleanup is
     required."

    self closeRequest

    "Modified: / 3.8.1998 / 19:51:23 / cg"
!

unmapped
    "the view has been unmapped
     (either by some outside action - i.e. window manager iconified me,
     or due to unmapping of my parentView)."

    "/ if I was previously shown, tell it to all of
    "/ my subviews (they remember this in the shown instVar)

    "/ currently, the 'shown ifTrue:' optimization is
    "/ not ok, since 'shown' is also modified by visibilityChanges.
    "/ Also, when remapped, X11 only sends a mapped event for the topView.
    "/ Therefore, synthetically generate those #superViewUnmapped messages
    "/ in any case.
    |wdgr|

    shown ifTrue:[
	shown := false.
	dependents notNil ifTrue:[ self changed:#visibility ].
    ].
    (wdgr := self windowGroup) notNil ifTrue:[
	wdgr focusView == self ifTrue:[
	    wdgr focusViewUnmapped.
	].
    ].

    subViews notNil ifTrue:[
	subViews do:[:v |
	    v containerUnmapped
	].
	dependents notNil ifTrue:[ self changed:#visibility ].
    ]

    "Modified: 25.2.1997 / 22:40:52 / cg"
!

visibilityChange:how
    "the visibility of the view has changed (by some outside
     action - i.e. window manager rearranged things).
     Using this knowledge avoids useless redraw in obscured views."

    |newShown|

    newShown := how ~~ #fullyObscured.
    newShown ~~ shown ifTrue:[
	shown := newShown.
	dependents notNil ifTrue:[ self changed:#visibility ].
    ].
!

visibilityStateChanged
    "this is called when our visibilityChannel changes"

    self isVisible:visibilityChannel value
!

win32NativeScroll:scrollCode position:newPosition
    "this is generated by a native scrollBar widget.
     We should never arrive here, as its only supposed to be
     sent to scrollableViews..."

    scrollCode == #SB_LINEDOWN ifTrue:[
	self scrollDown.
	^ self.
    ].
    scrollCode == #SB_LINEUP ifTrue:[
	self scrollUp.
	^ self.
    ].
    scrollCode == #SB_LINELEFT ifTrue:[
	self scrollLeft.
	^ self.
    ].
    scrollCode == #SB_LINERIGHT ifTrue:[
	self scrollRight.
	^ self.
    ].
    scrollCode == #SB_PAGEDOWN ifTrue:[
	self pageDown.
	^ self.
    ].
    scrollCode == #SB_PAGEUP ifTrue:[
	self pageUp.
	^ self.
    ].
    scrollCode == #SB_PAGELEFT ifTrue:[
	self pageLeft.
	^ self.
    ].
    scrollCode == #SB_PAGERIGHT ifTrue:[
	self pageRight.
	^ self.
    ].
    scrollCode == #SB_THUMBPOSITIONVERTICAL ifTrue:[
	self scrollVerticalToPercent:newPosition.
	^ self.
    ].
    scrollCode == #SB_THUMBPOSITIONHORIZONTAL ifTrue:[
	self scrollHorizontalToPercent:newPosition.
	^ self.
    ].
    scrollCode == #SB_THUMBTRACKVERTICAL ifTrue:[
	self scrollVerticalToPercent:newPosition.
	^ self.
    ].
    scrollCode == #SB_THUMBTRACKHORIZONTAL ifTrue:[
	self scrollHorizontalToPercent:newPosition.
	^ self.
    ].

    scrollCode == #SB_ENDSCROLL ifTrue:[
	^ self.
    ].
! !

!SimpleView methodsFor:'event simulation'!

pushEvent:aSelector
    "push some messageSend into my event queue -
     I will perform the corresponding method when its time
     to handle events (useful to update low-prio views from
     a higher prio process, to avoid blocking in the high prio one)"

    ^ self pushEvent:aSelector withArguments:#()

    "
     |v|

     v := View new openAndWait.
     v fill:Color red.
     v pushEvent:#redraw
    "

    "Modified: / 10.6.1998 / 17:28:40 / cg"
!

pushEvent:aSelector with:arg
    "push some 1-arg messageSend into my event queue -
     I will perform the corresponding method when its time
     to handle events (useful to update low-prio views from
     a higher prio process, to avoid blocking in the high prio one)"

    ^ self pushEvent:aSelector withArguments:(Array with:arg)

    "Created: / 10.6.1998 / 17:27:17 / cg"
!

pushEvent:aSelector with:arg1 with:arg2
    "push some 1-arg messageSend into my event queue -
     I will perform the corresponding method when its time
     to handle events (useful to update low-prio views from
     a higher prio process, to avoid blocking in the high prio one)"

    ^ self pushEvent:aSelector withArguments:(Array with:arg1 with:arg2)

    "Created: / 10.6.1998 / 17:27:41 / cg"
!

pushEvent:aSelector withArguments:args
    "push some messageSend into my event queue -
     I will perform the corresponding method when its time
     to handle events (useful to update low-prio views from
     a higher prio process, to avoid blocking in the high prio one)"

    self sensor pushUserEvent:aSelector for:self withArguments:args

    "
     |v|

     v := (Button label:'hello') openAndWait.
     Delay waitForSeconds:1.
     v pushEvent:#buttonPress:x:y: withArguments:#(1 10 10).
     Delay waitForSeconds:1.
     v pushEvent:#buttonRelease:x:y: withArguments:#(1 10 10).
    "

    "Modified: / 10.6.1998 / 17:28:16 / cg"
!

simulateButtonPress:button at:aPoint
    "simulate a button press by determining which sub-view is affected and
     synthetically generating a buttonPressEvent for whatever view is underneath.
     Returns the view which precessed the event or nil."

    ^ self simulateButtonPress:button at:aPoint sendDisplayEvent:false

    "Created: / 12-07-2011 / 14:36:02 / cg"
!

simulateButtonPress:button at:aPoint sendDisplayEvent:sendDisplayEvent
    "simulate a button press by determining which sub-view is affected and
     synthetically generating a buttonPressEvent for whatever view is underneath.
     Returns the view which precessed the event or nil."

    |ev|

    ev := WindowEvent buttonPress:button x:0 y:0 view:self.
    "/ x/y will be set in simulateUserEvent:ev at:aPoint
    ^ self simulateUserEvent:ev at:aPoint sendDisplayEvent:sendDisplayEvent

    "Created: / 12-07-2011 / 14:36:02 / cg"
!

simulateButtonRelease:button at:aPoint 
    "simulate a button release by determining which sub-view is affected and
     synthetically generating a buttonPressEvent for whatever view is underneath.
     Returns the view which precessed the event or nil."

    ^ self simulateButtonRelease:button at:aPoint sendDisplayEvent:false

    "Created: / 12-07-2011 / 14:54:37 / cg"
!

simulateButtonRelease:button at:aPoint sendDisplayEvent:sendDisplayEvent
    "simulate a button release by determining which sub-view is affected and
     synthetically generating a buttonPressEvent for whatever view is underneath.
     Returns the view which precessed the event or nil."

    |ev|

    ev := WindowEvent buttonRelease:button x:0 y:0 view:self.
    "/ x/y will be set in simulateUserEvent:ev at:aPoint
    ^ self simulateUserEvent:ev at:aPoint sendDisplayEvent:sendDisplayEvent

    "Created: / 12-07-2011 / 14:54:37 / cg"
!

simulateKeyPress:keyOrStringOrSymbol at:aPoint
    "simulate a key press by determining which sub-view is affected and
     synthetically generating a keyPressEvent for whatever view is underneath.
     Returns the view which processed the event or nil."

    ^ self simulateKeyPress:keyOrStringOrSymbol at:aPoint sendDisplayEvent:false
!

simulateKeyPress:keyOrStringOrSymbol at:aPoint sendDisplayEvent:sendDisplayEvent
    "simulate a key press by determining which sub-view is affected and
     synthetically generating a keyPressEvent for whatever view is underneath.
     Returns the view which processed the event or nil."

    |sequence ev lastView|

    (keyOrStringOrSymbol isCharacter or:[keyOrStringOrSymbol isSymbol])
	ifTrue:[ sequence := Array with:keyOrStringOrSymbol ]
	ifFalse:[ sequence := keyOrStringOrSymbol ].

    sequence do:[:each |
	ev := WindowEvent keyPress:each x:0 y:0 view:self.
	"/ x/y will be set in simulateUserEvent:ev at:aPoint
	lastView := self simulateUserEvent:ev at:aPoint sendDisplayEvent:sendDisplayEvent
    ].
    ^ lastView
!

simulateKeyPressRelease:keyOrStringOrSymbol at:aPoint
    "simulate a key release by determining which sub-view is affected and
     synthetically generating a keyPressEvent for whatever view is underneath.
     Returns the view which processed the event or nil."

    ^ self simulateKeyPressRelease:keyOrStringOrSymbol at:aPoint sendDisplayEvent:false
!

simulateKeyPressRelease:keyOrStringOrSymbol at:aPoint sendDisplayEvent:sendDisplayEvent
    "simulate a key release by determining which sub-view is affected and
     synthetically generating a keyPressEvent for whatever view is underneath.
     Returns the view which processed the event or nil."

    |sequence ev1 ev2 lastView|

    (keyOrStringOrSymbol isCharacter or:[keyOrStringOrSymbol isSymbol])
	ifTrue:[ sequence := Array with:keyOrStringOrSymbol ]
	ifFalse:[ sequence := keyOrStringOrSymbol ].

    sequence do:[:each |
	ev1 := WindowEvent keyPress:each x:0 y:0 view:self.
	"/ x/y will be set in simulateUserEvent:ev at:aPoint
	lastView := self simulateUserEvent:ev1 at:aPoint sendDisplayEvent:sendDisplayEvent.

	ev2 := WindowEvent keyRelease:each x:0 y:0 view:self.
	"/ x/y will be set in simulateUserEvent:ev at:aPoint
	lastView := self simulateUserEvent:ev2 at:aPoint sendDisplayEvent:sendDisplayEvent.
    ].
    ^ lastView
!

simulateKeyRelease:keyOrStringOrSymbol at:aPoint
    "simulate a key release by determining which sub-view is affected and
     synthetically generating a keyPressEvent for whatever view is underneath.
     Returns the view which processed the event or nil."

    ^ self simulateKeyRelease:keyOrStringOrSymbol at:aPoint sendDisplayEvent:false
!

simulateKeyRelease:keyOrStringOrSymbol at:aPoint sendDisplayEvent:sendDisplayEvent
    "simulate a key release by determining which sub-view is affected and
     synthetically generating a keyPressEvent for whatever view is underneath.
     Returns the view which processed the event or nil."

    |sequence ev lastView|

    (keyOrStringOrSymbol isCharacter or:[keyOrStringOrSymbol isSymbol])
	ifTrue:[ sequence := Array with:keyOrStringOrSymbol ]
	ifFalse:[ sequence := keyOrStringOrSymbol ].

    sequence do:[:each |
	ev := WindowEvent keyRelease:each x:0 y:0 view:self.
	"/ x/y will be set in simulateUserEvent:ev at:aPoint
	lastView := self simulateUserEvent:ev at:aPoint sendDisplayEvent:sendDisplayEvent
    ].
    ^ lastView
!

simulateUserEvent:ev at:aPoint
    "simulate a button press by determining which sub-view is affected and
     synthetically generating a buttonPressEvent for whatever view is underneath.
     Cares for any active grab - i.e. if some other view has grabbed the pointer or keyboard
     the event is sent to the grabView with pointer coordinate translated as required
     (typically these are popup views like menus)
     Returns the view which precessed the event or nil."

    ^ self simulateUserEvent:ev at:aPoint sendDisplayEvent:false
!

simulateUserEvent:ev at:aPoint sendDisplayEvent:sendDisplayEvent
    "simulate a button press by determining which sub-view is affected and
     synthetically generating a buttonPressEvent for whatever view is underneath.

     If sendDisplayEvent is true, a real physical event is generated via sendEvent,
     from the Display (xserver). Otherwise, the event is pushed into the widget's event
     queue, without a roundtrip through the display.

     Otherwise, care for any active grab - i.e. if some other view has grabbed the pointer or keyboard
     the event is sent to the grabView with pointer coordinate translated as required
     (typically these are popup views like menus)

     Returns the view which processed the event or nil. For displayEvent sending,
     always return the receiver, as we do not know how the grab processing came out at the end"

    |targetView pointXLated|

    sendDisplayEvent ifTrue:[
	"/ translate to screen coordinates
	pointXLated := device translatePoint:aPoint from:(self id) to:(device rootWindowId).
	device
	    sendKeyOrButtonEvent:ev type
	    x:pointXLated x y:pointXLated y
	    keyOrButton:(ev isKeyEvent ifTrue:[ev rawKey] ifFalse:[ev button])
	    state:(ev modifierFlags)
	    toViewId:self id.
	^ self.
    ].

    (ev isButtonEvent or:[ev isPointerEnterLeaveEvent]) ifTrue:[
	"/ if there is a pointer grab, the event has to sent to that one
        targetView := self device activePointerGrab.
    ] ifFalse:[
	(ev isKeyEvent) ifTrue:[
	    "/ if there is a pointer grab, the event has to sent to that one
            targetView := self device activeKeyboardGrab.
	].
    ].
    targetView isNil ifTrue:[
	((0@0 corner:self extent) containsPoint:aPoint) ifTrue:[
	    self subViews do:[:each |
		|whichView|

		whichView := each simulateUserEvent:ev at:(device translatePoint:aPoint fromView:self toView:each).
		whichView notNil ifTrue:[^ whichView].
	    ].
	    targetView := self.
	].
    ].

    targetView notNil ifTrue:[
	pointXLated := device translatePoint:aPoint fromView:self toView:targetView.
	ev x:(pointXLated x).
	ev y:(pointXLated y).
	ev view:targetView.
	targetView sensor pushEvent:ev.
	^ targetView
    ].

    ^ nil

    "Created: / 12-07-2011 / 14:53:19 / cg"
!

startButtonLongPressedHandlerProcess
    "start a process, which simulates a right-button press if the left-button
     has been pressed, but not released, and stayed pressed for a while.
     This is very handy for single-button-mice, as used with the MAC"

    |p|

    self stopButtonLongPressedHandlerProcess.
    p :=
	[
	    Delay waitForSeconds:0.7.
	    self sensor leftButtonPressed ifTrue:[
		"/ simulate a right-button press
		self buttonPress:2 x:0 y:0
	    ]
	] newProcess.

    device buttonLongPressedHandlerProcess:p.
    p resume.
!

stopButtonLongPressedHandlerProcess
    "stop any long-button-pressed process"

    |p|

    (p := device buttonLongPressedHandlerProcess) notNil ifTrue:[
"/ Transcript showCR:'stop'.
	device buttonLongPressedHandlerProcess:nil.
	p terminate.
    ].
! !

!SimpleView methodsFor:'focus handling'!

assignKeyboardFocusTo:aConsumer
    |wg|

    wg := self windowGroup.
    wg notNil ifTrue:[
	device isWindowsPlatform ifTrue:[
	    wg focusView:aConsumer byTab:true.
	] ifFalse:[
	    aConsumer requestFocus.
	    "/ consumer requestFocus. - could be denied; but we force it here
	    wg focusView:aConsumer byTab:false.
	].
    ].
!

assignKeyboardFocusToFirstInputField
    "assign the keyboard focus to the first first keyboardConsumer.
     (in older versions, this used to favour inputfields over editFields;
      see (or redefine) preferFirstInputFieldWhenAssigningInitialFocus)"

    self obsoleteMethodWarning.
    self assignKeyboardFocusToFirstKeyboardConsumer
!

assignKeyboardFocusToFirstKeyboardConsumer
    "assign the keyboard focus to the first first keyboardConsumer.
     (in older versions, this used to favour inputfields over editFields;
      see (or redefine) preferFirstInputFieldWhenAssigningInitialFocus)"

    |firstInputField firstConsumer firstCursorConsumer consumer|

    self withAllSubViewsDo:[:v |
	v shown ifTrue:[
	    (firstInputField isNil and:[v isInputField]) ifTrue:[
		firstInputField := v
	    ].
	    (firstConsumer isNil and:[v isKeyboardConsumer]) ifTrue:[
		firstConsumer := v
	    ].
	    (firstCursorConsumer isNil and:[v isCursorKeyConsumer]) ifTrue:[
		firstCursorConsumer := v
	    ].
	].
    ].
    (firstInputField notNil and:[self preferFirstInputFieldWhenAssigningInitialFocus]) ifTrue:[
	consumer := firstInputField.
    ].
    consumer := (consumer ? firstConsumer ? firstCursorConsumer).
    "/ Transcript showCR:consumer.
    consumer notNil ifTrue:[
	self assignKeyboardFocusTo:consumer
    ].

    "Modified: / 29-08-2006 / 14:32:30 / cg"
!

canTab
    "returns true if the widget is tabable"

    "/ ^ canTab == true
    ^ flagBits bitTest:FlagCanTab
!

canTab:aBoolean
    "set widget tabable or not"

    "/ canTab := aBoolean
    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagCanTab
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagCanTab
    ].
!

doNotRequestFocusOnPointerEnter
    "returns true if widget SHOULD NOT request the focus on pointer enter;
     if false is returned, the behavior depends upon the settings."

    ^ flagBits bitTest:FlagDoNotRequestFocusOnPointerEnter
!

doNotRequestFocusOnPointerEnter:aBoolean
    "if true, setup that the widget SHOULD NOT request the focus on pointer enter;
     if false, the behavior depends upon the settings."

    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagDoNotRequestFocusOnPointerEnter
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagDoNotRequestFocusOnPointerEnter
    ].
!

focusNext
    "get next focus view to self
     Skip invisible, disabled or widgets the extent is to small"

    shown ifFalse:[^ nil].

    ^ self focusNextForWhich:[:v | v shown]
!

focusNextChildAfter:aChildView
    "get the next focus view after aChildView in mySelf or nil,
     if there is none.
     Skip invisible or disabled widgets"

    |viewInSubView index subviewsInFocusOrder|

    shown ifFalse:[ ^ nil ].
    subViews isNil ifTrue:[ ^ nil ].
    subviewsInFocusOrder := self subviewsInFocusOrder.

    index := subviewsInFocusOrder identityIndexOf:aChildView.
    index == 0 ifTrue:[ ^ nil ].

    subviewsInFocusOrder from:(index + 1) do:[:eachChildAfterTheOne |
	eachChildAfterTheOne shown ifTrue:[
	    (eachChildAfterTheOne canTab
	    and:[eachChildAfterTheOne enabled]) ifTrue:[
		^ eachChildAfterTheOne
	    ].

	    (viewInSubView := eachChildAfterTheOne focusNext) notNil ifTrue:[
		^ viewInSubView
	    ].
	].
    ].
    ^ nil
!

focusNextForWhich:aCondition
    "get next focus view to self
     Skip invisible, disabled or widgets the extent is to small"

    |viewInSubView|

    self subviewsInFocusOrder do:[:aSubView|
	(aSubView canTab
	and:[aSubView enabled
	and:[aCondition value:aSubView]]) ifTrue:[
	    ^ aSubView
	].

	(viewInSubView := aSubView focusNextForWhich:aCondition) notNil ifTrue:[
	    ^ viewInSubView
	]
    ].
    ^ nil
!

focusPrevious
    "get previous focus view to self
     Skip invisible & disabled widgets."

    |viewInSubView|

    shown ifTrue:[
	self subviewsInFocusOrder reverseDo:[:aSubView|
	    aSubView shown ifTrue:[
		viewInSubView := aSubView focusPrevious.

		viewInSubView notNil ifTrue:[
		    ^ viewInSubView
		].
		(aSubView canTab and:[aSubView enabled]) ifTrue:[
		    ^ aSubView
		].
	    ]
	]
    ].
    ^ nil
!

focusPreviousChildBefore:aChildView
    "get the previous focus view before aChildView in mySelf or nil, if there is none.
     Skip invisible or disabled widgets"

    |viewInSubView index subviewsInFocusOrder|

    shown ifFalse:[ ^ nil ].
    subViews isNil ifTrue:[ ^ nil ].
    subviewsInFocusOrder := self subviewsInFocusOrder.

    index := subviewsInFocusOrder identityIndexOf:aChildView.
    index == 0 ifTrue:[ ^ nil ].

    subviewsInFocusOrder from:1 to:(index - 1) reverseDo:[:eachChildBeforeTheOne |
	eachChildBeforeTheOne shown ifTrue:[
	    (viewInSubView := eachChildBeforeTheOne focusPrevious) notNil ifTrue:[
		^ viewInSubView
	    ].

	    (eachChildBeforeTheOne canTab and:[eachChildBeforeTheOne enabled]) ifTrue:[
		^ eachChildBeforeTheOne
	    ].
	].
    ].
    "/ the code below allows for a notebooks tab-list to be reached
    (self canTab and:[self enabled]) ifTrue:[
	^ self
    ].

    ^ nil
!

requestDoNotFocusOnPointerEnter
    <resource: #obsolete>

    self obsoleteMethodWarning:'use doNotRequestFocusOnPointerEnter'.
    ^ flagBits bitTest:FlagDoNotRequestFocusOnPointerEnter

    "Modified: / 01-08-2012 / 17:05:56 / cg"
!

requestDoNotFocusOnPointerEnter:aBoolean
    "very bad naming - wrong english"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use doNotRequestFocusOnPointerEnter:'.
    self doNotRequestFocusOnPointerEnter:aBoolean

    "Modified (format): / 01-08-2012 / 17:05:42 / cg"
!

requestFocus
    "request focus from my windowGroup;
     typically, this is invoked when the mouse pointer enters a
     widget. The request may or may not be ignored by the wGroup
     (it will be ignored, if an explicit focus-change is currently
      active - i.e. if the user tabbed into a widget)"

    "/ Transcript show:'take: '; showCR:self.
    windowGroup notNil ifTrue:[
	^ windowGroup focusRequestFrom:self
    ].
    "/ Transcript show:'oops: '; showCR:self.
    ^ true

    "Modified: / 09-12-2010 / 14:33:40 / cg"
    "Modified (format): / 01-08-2012 / 17:02:30 / cg"
!

requestFocusOnPointerEnter
    "returns true if widget SHOULD request the focus on pointer enter;
     if false is returned, the behavior depends upon the settings.
    "
    ^ flagBits bitTest:FlagRequestFocusOnPointerEnter
!

requestFocusOnPointerEnter:aBoolean
    "if true, setup that the widget SHOULD request the focus on pointer enter;
     if false, the behavior depends upon the settings.
    "

    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagRequestFocusOnPointerEnter
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagRequestFocusOnPointerEnter
    ].
!

showFocus:explicit
    "highlight myself somehow to tell user that I have the focus.
     If explicit is true, the focus came via focusStepping (i.e. tabbing);
     if false, it came via the window manager (i.e. pointer entering).
     Only change my border, if this is an explicit focusChange."

    |delta clrId bd graphicsDevice|

    explicit ifTrue:[
	(self drawableId notNil
	and:[superView notNil
	and:[styleSheet notNil]]) ifTrue:[
	    (styleSheet at:#'focus.showBorder' default:true) ifTrue:[
		graphicsDevice := device.

		(graphicsDevice supportsWindowBorder:(bd := DefaultFocusBorderWidth)) ifFalse:[
		    (graphicsDevice supportsWindowBorder:(bd := 1)) ifFalse:[
			bd := 0.
		    ]
		].
		delta := bd - self borderWidth.
		delta ~~ 0 ifTrue:[
		    (left == 0 or:[top == 0]) ifTrue:[
			graphicsDevice resizeWindow:self drawableId width:width-delta-delta height:height-delta-delta.
		    ] ifFalse:[
			graphicsDevice moveWindow:self drawableId x:left-delta y:top-delta.
		    ].
		    graphicsDevice setWindowBorderWidth:bd in:self drawableId.
		].

		clrId := (DefaultFocusColor onDevice:graphicsDevice) colorId.
		clrId isNil ifTrue:[
		    clrId := graphicsDevice blackpixel
		].
		graphicsDevice setWindowBorderColor:clrId in:self drawableId.
	    ]
	]
    ] ifFalse:[
"/        superView notNil ifTrue:[
"/            superView showFocus:explicit
"/        ]
    ]

    "Modified: / 17.9.1998 / 15:08:34 / cg"
!

showNoFocus:explicit
    "undo the effect of showFocus.
     Explicit tells if the focus came via focusStepping (i.e. tabbing)
     or via the window manager (i.e. pointer entering).
     Only change my border, if this is an explicit focusChange."

    |delta bd graphicsDevice|

    explicit ifTrue:[
	(self drawableId notNil and:[superView notNil]) ifTrue:[
	    (styleSheet at:#'focus.showBorder' default:true) ifTrue:[
		graphicsDevice := device.

		(graphicsDevice supportsWindowBorder:(bd := self borderWidth)) ifFalse:[
		    (graphicsDevice supportsWindowBorder:(bd := 1)) ifFalse:[
			bd := 0.
		    ]
		].
		delta := DefaultFocusBorderWidth - bd.
		delta ~~ 0 ifTrue:[
		    graphicsDevice setWindowBorderWidth:bd in:self drawableId.
		    graphicsDevice moveWindow:self drawableId x:left y:top.
		    graphicsDevice resizeWindow:self drawableId width:width height:height.
		].
		self setBorderColor.
	    ]
	]
    ]

    "Modified: / 17.9.1998 / 15:08:02 / cg"
!

subviewsInFocusOrder
    ^ subViews ? #()
!

takeFocus
    "Unconditionally take the focus from my windowGroup"

    windowGroup notNil ifTrue:[
	windowGroup focusView:self byTab:nil "/false.
    ].
!

takeFocusWhenMapped
    ^ flagBits bitTest:FlagTakeFocusWhenMapped

    "Created: / 09-12-2010 / 10:34:30 / cg"
!

takeFocusWhenMapped:aBoolean
    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagTakeFocusWhenMapped
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagTakeFocusWhenMapped
    ].

    "Created: / 09-12-2010 / 10:34:11 / cg"
!

topViewWasMapped
    "invoked when my topView is mapped"

    self isKeyboardConsumer ifTrue:[
	self takeFocusWhenMapped ifTrue:[
	    self requestFocus
	]
    ] ifFalse:[
	subViews notNil ifTrue:[
	    subViews do:[:eachSubView |
		eachSubView topViewWasMapped
	    ].
	].
    ].

    "Created: / 09-12-2010 / 18:11:51 / cg"
!

wantsFocusWithButtonPress
    "views which do not like to take the keyboard focus
     with buttonPress can do so by redefining this
     to return false
     (actually: they should, because it is quite annoying
      in the UI, if a menuPanel or button takes my keyboard focus.
      So we should consider making the default false here, so every
      widget writer has to think twice...
      Can we do such a major change?)"

"/    (self class == SimpleView) ifTrue:[
"/        "/ a pure filler/geometric layout view
"/        ^ false
"/    ].
    ^ self enabled

    "Modified: / 17-11-2010 / 16:07:01 / cg"
!

wantsFocusWithPointerEnter
    "views which like to take the keyboard focus
     when the pointer enters can do so by redefining this
     to return true"

    ^ false
! !

!SimpleView methodsFor:'grabbing'!

forceUngrabKeyboard
    "force a keyboard ungrab - even if was not the grabber"

    device notNil ifTrue:[ gc device ungrabKeyboard ].
!

forceUngrabPointer
    "force a pointer ungrab - even if was not the grabber"

    device notNil ifTrue:[ device ungrabPointer ]
!

grabKeyboard
    "grab the keayboard - that is: report all keyboard events to myself,
     even if the mouse moved out of myself.
     Returns true, if the grab was sucessfull (could fail, if some other
     application has a grab - but that's very unlikely)."

    ^ device grabKeyboardInView:self.
!

grabPointer
    "grab the pointer - that is: report all motion events relative to
     myself, even if moved out of myself.
     Returns true, if the grab was sucessfull (could fail, if some other
     application has a grab - but that's very unlikely)."

    ^ self grabPointerWithCursor:nil
!

grabPointerWithCursor:aCursorOrNil
    "grab the pointer - that is: report all motion events relative to
     myself, even if moved out of myself.
     Show aCursor during the grab, if the cursor argument is not nil.
     Returns true, if the grab was sucessfull (could fail, if some other
     application has a grab - but that's very unlikely)."


"/    (sensor := self sensor) notNil ifTrue:[
"/        "/ make certain all X events have been received
"/        device sync.
"/        "/ now all events have been received.
"/        "/ now, flush all pointer events
"/        sensor flushMotionEventsFor:nil
"/    ].
    aCursorOrNil notNil ifTrue:[
	cursor := (aCursorOrNil onDevice:device).
	^ device grabPointerInView:self withCursor:cursor
    ].
    ^ device grabPointerInView:self
!

ungrabKeyboard
    "ungrab the keyboard - but only if I was the grabber"

    |sensor|

    device activeKeyboardGrab == self ifTrue:[
	(sensor := self sensor) notNil ifTrue:[
	    "/ make certain all X events have been received
	    device sync.
	    "/ now all events have been received.
	    "/ now, flush all pointer events
	    sensor flushKeyboardFor:self
	].
	device ungrabKeyboard.
    ].
!

ungrabPointer
    "ungrab the pointer - but only if I was the grabber"

    |sensor|

    device activePointerGrab == self ifTrue:[
	(sensor := self sensor) notNil ifTrue:[
	    "/ make certain all X events have been received
	    device sync.
	    "/ now all events have been received.
	    "/ now, flush all pointer events
	    sensor flushMotionEventsFor:self
	].
	device ungrabPointer.
    ]
! !

!SimpleView methodsFor:'informing others of changes'!

contentsChanged
    "this one is sent, whenever contents changes its size -
     tell dependents about the change (i.e. scrollers)."

    dependents notNil ifTrue:[ self changed:#sizeOfContents ]
!

noticeOfWindowClose
    |app|

    (app := self application) notNil ifTrue:[
	app noticeOfWindowClose:self
    ].
!

noticeOfWindowOpen
    |app|

    (app := self application) notNil ifTrue:[
	app noticeOfWindowOpen:self
    ].
    dependents notNil ifTrue:[ self changed:#opened ] 
!

originChanged:delta
    "this one is sent, after the origin of my contents has changed -
     tell dependents (i.e. scrollers) about this"

    (delta = (0@0)) ifTrue:[^ self].
    dependents notNil ifTrue:[ self changed:#originOfContents with:delta ].
"/   subViews notNil ifTrue:[
"/        subViews do:[:aSubView |
"/            aSubView pixelOrigin:((aSubView left @ aSubView top) - delta)
"/        ]
"/    ]
!

originWillChange
    "this one is sent, just before viewOrigin changes -
     gives subclasses a chance to catch scrolls easily
     (for example to hide cursor before scroll)"

    ^ self
! !

!SimpleView methodsFor:'initialization & release'!

defaultControllerClass
    ^ nil "/ Controller
!

defaultExtent
    "return the default extent of my instances."

    ^ self class defaultExtent

    "Created: 1.3.1996 / 19:20:46 / cg"
    "Modified: 22.4.1996 / 23:38:27 / cg"
!

defaultFont
    ^ self class defaultFont
!

destroy
    "unmap & destroy - make me invisible, destroy subviews then
     make me unknown to the device"

    self isBeingDestroyed:true.
    realized ifTrue:[
	self unmap.
    ].
    shown ifTrue:[
	shown := false.
	dependents notNil ifTrue:[ self changed:#visibility ].
    ].

"/    controller notNil ifTrue:[
"/      controller release.
"/      controller := nil.
"/    ].

    subViews notNil ifTrue:[
	self destroySubViews.
    ].
    superView notNil ifTrue:[
	superView removeSubView:self.
	superView := nil
    ].
    super destroy.

    dependents notNil ifTrue:[ self changed:#destroyed ]. "/ must do before release, which clears the dependents
    self release.

"/    superView isNil ifTrue:[
"/        device flush
"/    ].

    controller notNil ifTrue:[
	controller release.
	controller := nil.
    ].

    windowGroup notNil ifTrue:[
	windowGroup removeView:self.
	windowGroup := nil
    ].

    self noticeOfWindowClose.
!

initEvents
    "will be sent by create - can be redefined by subclasses to enable
     view events"

    ^ self
!

initStyle
    "this method sets up all style dependent things"

    self initStyleSheet.

    viewBackground := DefaultViewBackgroundColor.

    DefaultLightColor notNil ifTrue:[
	lightColor := DefaultLightColor.
    ] ifFalse:[
	device hasGrayscales ifTrue:[
	    (viewBackground isImageOrForm and:[viewBackground colorMap isNil]) ifTrue:[
		lightColor := viewBackground averageColor lightened.
	    ] ifFalse:[
		lightColor := viewBackground lightened.
	    ].
	    DefaultLightColor := lightColor.
	] ifFalse:[
	    "
	     this seems strange: on B&W screens, we create the light color
	     darker than normal viewBackground (White) -
	     to make the boundary of the view visible
	    "
	    lightColor := Color gray:50
	]
    ].
    DefaultShadowColor notNil ifTrue:[
	shadowColor := DefaultShadowColor.
    ] ifFalse:[
	shadowColor := self blackColor.
    ].

    ((DefaultBorderWidth ? 1) ~= 0 and:[DefaultBorderColor notNil]) ifTrue:[
	self border:(SimpleBorder width:(DefaultBorderWidth ? 1) color:DefaultBorderColor)
    ].

    "/ font := self defaultFont.  -- already done in #initialize

    "Modified: 28.5.1996 / 21:13:58 / cg"
!

initStyleSheet
    "this method gets the styleSheet"

    "
     when coming here the first time, we read the styleSheet
     and keep the values in fast class variables
    "
    StyleSheet isNil ifTrue:[
	DefaultStyle isNil ifTrue:[
	    "/ the very-very first time (no styleSheet yet)
	    View setDefaultStyle.
	    View defaultStyle:DefaultStyle.
	].
	SimpleView updateAllStyleCaches
    ].

    styleSheet := StyleSheet.

    "Modified: 25.7.1996 / 22:00:06 / cg"
!

initialize
    "initialize all state of the view - usually redefined in subclasses,
     but always doing a 'super initialize'. Each class should setup its
     locals - and not forget the others.
     View setup is separated into two parts, the general setup done here
     and the style specific setup in initStyle. Each view should be prepared
     for a stylechange by being sent another initStyle with a new style value.
     (in this case, it should set all of its style-dependent things, but
      leave the state and contents as-is)"

    |ext myClass controllerClass|

    flagBits := flagBits ? 0.

    super initialize.

    self basicFont:self defaultFont.

    shown := realized := false.
    "/ explicitExtent := false.

    "fill in some defaults - some of them are usually redefined in subclasses
     initialize methods"

    myClass := self class.
    "/ name := myClass name "asString" asLowercaseFirst. - now lazy
    resources := myClass classResources.

    level := margin := 0.
    self borderWidth:0.

    self initStyle.

    ext := self defaultExtent.
    left := top := 0.
    width := ext x.
    height := ext y.

    "/ not needed
    "/ self originChangedFlag:false extentChangedFlag:false cornerChangedFlag:false.

    name isNil ifTrue:[
	name := self class name.
    ].
    bitGravity := #NorthWest. "/ nil.
    viewGravity := nil.

    controllerClass := self defaultControllerClass.
    controllerClass notNil ifTrue:[
	controller := controllerClass new.
	controller view:self.
    ].

    self initializeMiddleButtonMenu.

    "Modified: / 1.10.1998 / 14:31:05 / cg"
!

initializeMiddleButtonMenu
    "a place to initialize menu - this one is sent once when the view-object is initialized.
     usually redefined in subclasses; default here is no menu.
     Notice, that static middleButtonmenus are a historic thing in ST/X;
     you may prefer to create the menu dynamically."

    ^ self
!

prepareForReinit
    super prepareForReinit.
    windowGroup notNil ifTrue:[
	windowGroup reinitialize
    ]
!

reinitStyle
    "this method is called for a style change"

    "Kludge: remember the old level.
     level may be set from the WindowSpec and not by the Stylesheet!!
     Systembrowser will look funny when I am called by Winworkstation>>#systemColorChange."

    |oldLevel oldBorder|

    oldLevel := self level.
    oldBorder := self border.
    self initStyle.
    (self drawableId notNil and:[self gcId notNil]) ifTrue:[
	"force a change"
	self border:oldBorder.
	self level:oldLevel.
	self viewBackground:self viewBackground.
	self clearView.
	self invalidate.
    ].

    "Modified: / 18.9.1998 / 21:15:33 / cg"
!

reinitialize
    "this is called right after snapIn"

    |myController sv|

    "if I have already been reinited - return"
    self drawableId notNil ifTrue:[
	^ self
    ].

    "
     superView must be there, first
    "
    superView notNil ifTrue:[
	(sv := superView view) id isNil ifTrue:[
	    sv reinitialize
	]
    ].

    "reinit cursor"
    self initCursor.

    myController := controller.
    controller := nil.
    self recreate.

    "if I was mapped, do it again"
    realized ifTrue:[
	"only remap if I have a superview - otherwise, I might be
	 a hidden iconView or menu ..."
	superView notNil ifTrue:[
"/            shown ifTrue:[
	    device
		moveResizeWindow:self drawableId x:left y:top width:width height:height;
		mapWindow:self drawableId
"/                mapView:self id:self drawableId iconified:false
"/                atX:left y:top width:width height:height
"/                minExtent:(self minExtent) maxExtent:(self maxExtent)
"/            ].
	].
    ].

    "restore controller"
    controller := myController.

    "Modified: / 6.5.1999 / 13:11:07 / cg"
!

release
    "remove all dependencies from the receiver"

    visibilityChannel notNil ifTrue:[
	visibilityChannel retractInterestsFor:self.
	visibilityChannel removeDependent:self. visibilityChannel := nil
    ].

    dependents := nil.

    "Modified: 19.4.1996 / 10:31:35 / cg"
    "Created: 11.6.1997 / 13:11:53 / cg"
!

restarted
    "sent by my windowGroup, when restarted from an image.
     Nothing done here, but can be redefined to perform any actions
     required to reset some state after an image-restart.

     Only top views (usually instances of TopView) get this message sent.
     Since SimpleViews can act as a top view, too this message is implemented
     in SimpleView"

    ^ self
!

subViewsHaveBeenReparented
    subViews := nil
! !


!SimpleView methodsFor:'keyboard control'!

defineShortcutAndTranslateLabelStringFrom:aString
    |i|

    aString isString ifFalse:[ ^ aString].

    (aString includes:$&) ifFalse:[ ^ aString].
    i := self shortcutAndTranslatedStringFrom:aString.
    self shortcutKey:(i at:1).
    ^ i at:2.
!

mnemonicKey
    "get the mnemonic key or nil if undefined"

    ^ self objectAttributeAt:#mnemonicKey
!

mnemonicKey:aSymbolOrNil
    "set or clear the mnemonic key"

    aSymbolOrNil isSymbol ifTrue:[
	self objectAttributeAt:#mnemonicKey put:aSymbolOrNil
    ] ifFalse:[
	self removeObjectAttribute:#mnemonicKey
    ].
!

mnemonicViewNext:aKeyEvent
    "a mnemonicKey event as forwarded from the keyboardProcessor - if there
     is the mnemonic-key defined for a subView return the view otherwise nil."

    |key rawKey mnemonic view|

    key := aKeyEvent key.
    rawKey := aKeyEvent rawKey.
    (shown and:[ subViews notNil ]) ifTrue:[
	subViews do:[:aSubView |
	    aSubView shown ifTrue:[
		(aSubView enabled
		    and:[ (mnemonic := aSubView mnemonicKey) notNil
		    and:[ (mnemonic == rawKey or:[ mnemonic == key ]) ]])
		ifTrue:[
		    ^ aSubView
		].
		(view := aSubView mnemonicViewNext:aKeyEvent) notNil ifTrue:[
		    ^ view
		].
	    ]
	]
    ].
    ^ nil

    "Modified (comment): / 06-10-2011 / 16:15:44 / cg"
!

performShortcutAction
    "perform my shortcutKey action.
    "
    "/ intentionally left blank here
!

processShortcut:aKeyEvent
    "a  shortcutKey event as forwarded from the keyboardProcessor - if there is the
     shortcut-key defined process the shortcut and return true otherwise false."

    |key|

    shown ifTrue:[
	self enabled ifTrue:[
	    (key := self shortcutKey) notNil ifTrue:[
		(key == aKeyEvent key or:[ key == aKeyEvent rawKey ]) ifTrue:[
		    self requestFocus.
		    (controller ? self) performShortcutAction.
		    ^ true
		]
	    ].
	].
	subViews notNil ifTrue:[
	    subViews do:[:aSubView |
		(aSubView processShortcut:aKeyEvent) ifTrue:[
		    ^ true
		]
	    ]
	]
    ].
    ^ false
!

shortcutAndTranslatedStringFrom:aString
    "return an array filled with an extracted shortcut key and a translated string;
     looks for and reemoves any ampercent character from aString, and adds underline emphasis to the
     following character"

    |xLatedString c n s pos shortcutCharacter shortcut|

    xLatedString := '' writeStream.
    s := aString readStream.

    [s atEnd] whileFalse:[
	c := s next.
	c == $& ifTrue:[
	   n := s peek.
	   (n notNil and:[n isLetter]) ifTrue:[
	       c := s next.
	       pos := xLatedString size + 1.
	   ] ifFalse:[
		n == $& ifTrue:[
		    s next.
		]
	   ]
	].
	c notNil ifTrue:[
	   xLatedString nextPut:c
	]
    ].

    xLatedString := xLatedString contents.
    pos notNil ifTrue:[
	shortcutCharacter := xLatedString at:pos ifAbsent:nil.

	xLatedString isText ifFalse:[
	    xLatedString := xLatedString asText
	].
	xLatedString emphasisAt:pos add:#underline.

	shortcut := ('Cmd' , shortcutCharacter asLowercase) asSymbol.
    ].
    ^ Array with:shortcut with:xLatedString

    "
     Transcript showCR:(self basicNew shortcutAndTranslatedStringFrom:'hello'        ) last
     Transcript showCR:(self basicNew shortcutAndTranslatedStringFrom:'he&llo'       ) last
     Transcript showCR:(self basicNew shortcutAndTranslatedStringFrom:'he&&llo'      ) last
     Transcript showCR:(self basicNew shortcutAndTranslatedStringFrom:'he& llo'      ) last
     Transcript showCR:(self basicNew shortcutAndTranslatedStringFrom:'he&123llo'    ) last
     Transcript showCR:(self basicNew shortcutAndTranslatedStringFrom:'hello &'      ) last
     Transcript showCR:(self basicNew shortcutAndTranslatedStringFrom:'hello &&'     ) last
    "
!

shortcutKey
    "get the shortcut key"

    ^ self objectAttributeAt:#shortcutKey
!

shortcutKey:aSymbolOrNil
    "set or clear the shortcut key"

    aSymbolOrNil notNil ifTrue:[
	self objectAttributeAt:#shortcutKey put:aSymbolOrNil
    ] ifFalse:[
	self removeObjectAttribute:#shortcutKey
    ].
! !

!SimpleView methodsFor:'menu & menu actions'!

fontLargerOrSmaller:largerBoolean
    |font oldSize newFont|

    font := gc font.
    oldSize := font size.
    newFont := font asSize:(largerBoolean
			    ifTrue:[(oldSize + 1) min:100]
			    ifFalse:[(oldSize-1) max:4]).
    self font:newFont.

    "Modified: / 27-02-1996 / 00:53:51 / cg"
    "Created: / 10-03-2012 / 09:38:32 / cg"
! !

!SimpleView methodsFor:'menu handling'!

activateMenu
    "activate my menu.
     This code will move into the controller ASAP
     If there is a static middleButtonMenu, that one is taken,
     and handled in the superClass (static menus are a historic leftOver).
     Otherwise, the follwing steps are performed:

        - ask the receiver for the menu (via #yellowButtonMenu)
        - ask the receiver for the menuPerformer.
        - startUp the menu - it is supposed to return an actionSelector
        - if the menuPerformer responds to the selector,
          send it to the performer;
          otherwise send it to the view (the receiver)
          This is funny, it allows additional menuItems to be added
          AND still get the view's copy/cut/paste functionality.
          Without this, you had to redefine and forward all of those
          messages in the performer."

    |menu menuPerformer actionSelector prevReceiver wg|

    self middleButtonMenu isNil ifTrue:[
        "
         try ST-80 style menus first:
         if there is a model, and a menuMessage is defined,
         ask model for the menu and launch that if non-nil.
        "
        menu := self yellowButtonMenu.
        menu notNil ifTrue:[
            "
             got one, launch the menu. It is supposed
             to return an actionSelector.
            "
            menuPerformer := self menuPerformer value.

            "/ could be a spec ...
            menu isArray ifTrue:[
                menu := menu decodeAsLiteralArray.
                menu receiver:menuPerformer.
                menu findGuiResourcesIn:(self menuHolder).
            ] ifFalse:[
                (menu respondsTo:#receiver) ifTrue:[
                    menuPerformer := menu receiver ? menuPerformer.
                ].
            ].

            "
             a temporary kludge:
                 pass myself as receiver, the menuPerformer as performer;
                 the menu will send its messages to either the
                 menuPerformer or me (its receiver).
                 This allows for the ST-80 behavior, where some messages
                 go to the model, others to the view
                 (copy/cut/paste).
            "
            (prevReceiver := menu receiver) isNil ifTrue:[
                "/ kludge for oldStyle menus (MenuView/PopUpMenu)
                "/ not req'd for real Menus
                "/ (menu isKindOf:Menu) ifFalse:[
                (menu respondsTo:#menuPerformer:) ifTrue:[
                    menu receiver:self.    "/ really ?
                    menu menuPerformer:menuPerformer.
                ] ifFalse:[
                "/ ] ifTrue:[
                    "/ new style menu
                    menu receiver:menuPerformer.
                ]
            ].

            "/
            "/ startup the menu - this returns a selector
            "/
            actionSelector := self startUpMenu:menu.

            "/ before doing anything else, redraw expose area from
            "/ the menu (in case the action changes my state)
            (wg := self windowGroup) notNil ifTrue:[
                wg processExposeEvents.
            ].

            (actionSelector notNil and:[actionSelector isSymbol]) ifTrue:[
                self dispatchMenuSelection:actionSelector to: menuPerformer.
            ].

            menu receiver:prevReceiver.

            ^ self
        ].
    ].

    "/
    "/ old style static menu
    "/
    super activateMenu

    "Created: / 1.3.1996 / 13:24:18 / cg"
    "Modified: / 14.8.1998 / 18:09:31 / cg"
!

dispatchMenuSelection:menuSelection to:aMenuPerformerOrNil
    "dispatch a menu message.
     This code will move into the controller ASAP"

    |actionSelector actionArg1 actionArg2 app menuPerformer|

    actionSelector := menuSelection.

    "
     mhmh - kludge for selectors with argument
    "
    (menuSelection isMemberOf:Array) ifTrue:[
	actionArg1 := menuSelection at:2.
	actionSelector := menuSelection at:1.
    ].

    menuPerformer := aMenuPerformerOrNil ? self menuPerformer.

    "
     mhmh - ST-80 seems to send some to the model and
     others (copy/cut/paste) to the controller/view
     Simulate this behavior, by looking what the model responds to.
    "
    actionSelector isSymbol ifTrue:[
	(menuPerformer respondsTo:actionSelector) ifFalse:[
	    ((app := self application) respondsTo:actionSelector) ifTrue:[
		menuPerformer := app.
		actionArg1 := self model.
		actionArg2 := self controller.
	    ] ifFalse:[
		(self respondsTo:actionSelector) ifTrue:[
		    menuPerformer := self
		]
	    ]
	].
	menuPerformer perform:actionSelector withOptionalArgument:actionArg1 and:actionArg2.
    ].

    "Created: / 20.6.1997 / 11:47:42 / cg"
    "Modified: / 1.11.1997 / 13:45:23 / cg"
!

menuFromSpec:aMenuOrMenuSpec
    "create a menu for the receiver from a spec"

    |spec|

    aMenuOrMenuSpec isNil ifTrue:[^ nil].

    aMenuOrMenuSpec isArray ifTrue:[
	spec := aMenuOrMenuSpec decodeAsLiteralArray.
    ] ifFalse:[
	spec := aMenuOrMenuSpec.
    ].
    "/ spec receiver:self.     -- now done in findGuiResources ...
    spec findGuiResourcesIn:self.
    ^ spec.
!

startUpMenu:aMenu
    ^ aMenu startUpFor:self
! !


!SimpleView methodsFor:'native widget support'!

nativeWindowType
    "return a symbol describing my native window type - here, nil is returned
     (may be used internally by the device as a native window creation hint,
      iff native windows are enabled AND the device supports it)"

    ^ nil
! !

!SimpleView methodsFor:'private'!

componentsContainingX:x y:y do:aBlock
    (x isNil or:[y isNil]) ifTrue:[
	"/ delegated
	^ self
    ].

    components notNil ifTrue:[
	components reverseDo:[:aComponent |
	    |thisFrame|

	    thisFrame := aComponent bounds.
	    (thisFrame containsPointX:x y:y) ifTrue:[
		"/ prepare for masked/non-rectangular components ...
		(aComponent perform:#containsPointX:y: with:x with:y ifNotUnderstood:true)
		ifTrue:[
		    aBlock value:aComponent
			   value:x - thisFrame left
			   value:y - thisFrame top.
		]
	    ]
	]
    ].

    "Created: / 08-05-1996 / 23:40:59 / cg"
    "Modified: / 13-09-2006 / 18:55:30 / User"
!

computeInnerClip
    "compute, but do not set the inside clip-area, in device coordinates"

    |m2 nX nY nW nH|

    margin isNil ifTrue:[margin := 0].
    (margin ~~ 0) ifTrue:[
	m2 := margin + margin.
	nX := nY := margin.
	nW := width - m2.
	nH := height - m2.
"/        transformation notNil ifTrue:[
"/            nX := transformation applyInverseToX:nX.
"/            nY := transformation applyInverseToY:nY.
"/            nW := transformation applyInverseScaleX:nW.
"/            nH := transformation applyInverseScaleY:nH.
"/        ].
	innerClipRect := Rectangle
				 left:nX
				 top:nY
				 width:nW
				 height:nH
    ] ifFalse:[
	"no clipping"
	innerClipRect := nil
    ]

    "Modified: / 22.5.1999 / 16:50:58 / cg"
!

cornerFromRelativeCorner
    "compute & return pixel corner from relativeCorner"

    ^ self cornerFromRelativeCorner:relativeCorner
!

cornerFromRelativeCorner:aPoint
    "compute & return pixel corner from a relativeCorner, aPoint"

    |p r b bw|

    p := self pointFromRelative:aPoint.

    bw := self borderWidth ? 0.
    insets isNil ifTrue:[
	bw == 0 ifTrue:[
	    ^ p
	].
	^ (p x - bw) @ (p y - bw)
    ].
    r := (insets at:3) + bw.
    b := (insets at:4) + bw.

"/    r := b := bw.
"/    rightInset notNil ifTrue:[
"/        r := rightInset + bw
"/    ].
"/    bottomInset notNil ifTrue:[
"/        b := bottomInset + bw
"/    ].
    ((r ~~ 0) or:[b ~~ 0]) ifTrue:[
	^ (p x - r) @ (p y - b)
    ].
    ^ p

    "Modified: / 1.10.1998 / 13:21:33 / cg"
!

detectViewAt:aPoint
    "find the subView which contains aPoint - invisible components are ignored.
     This is almost the same as #componentContainingX:y: (if that existed) "

    ^ self detectViewAt:aPoint ignoreInvisible:false
!

detectViewAt:aPoint ignoreInvisible:ignoreInvisible
    "find the subView which contains aPoint - invisible components are ignored if
     the ignoreInvisible argument is false.
     This is almost the same as #componentContainingX:y: (if that existed) "

    |subViews|

    (subViews := self subViews) notNil ifTrue:[
	subViews do:[:v| |p|
	    (ignoreInvisible or:[v shown]) ifTrue:[
		(    (aPoint x between:(v left) and:(v right))
		 and:[aPoint y between:(v top)  and:(v bottom)]
		) ifTrue:[
		    "/ found a subview - the point is there
		    p := device translatePoint:aPoint fromView:self toView:v.
		    ^ v detectViewAt:p ignoreInvisible:ignoreInvisible.
		]
	    ]
	]
    ].
    "/ no subview - the point is here
    ^ self

    "Modified: / 10.10.2001 / 13:45:26 / cg"
!

explicitExtent:aBoolean
    "set the exeplicit extent flag to aBoolean."

    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagHasExplicitExtent
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagHasExplicitExtent
    ].
!

extentFromRelativeExtent
    "compute & return pixel extent from relativeExtent"

    ^ self extentFromRelativeExtent:relativeExtent
!

extentFromRelativeExtent:aPoint
    "compute & return pixel extent from relativeExtent, aPoint"

    |rel newX newY inRect bw bw2 i|

    bw := self borderWidth ? 0.

    superView isNil ifTrue:[
	inRect := 0@0 extent:device extent
    ] ifFalse:[
	inRect := superView viewRectangle.
    ].

    bw2 := bw * 2.

    rel := aPoint x.
    rel isInteger ifFalse:[
	newX := (rel * (inRect width + bw2)) asInteger + inRect left.
	(bw ~~ 0) ifTrue:[
	    newX := newX - bw
	].
    ] ifTrue:[
	newX := rel
    ].

    rel := aPoint y.
    rel isInteger ifFalse:[
	newY := (rel * (inRect height + bw2)) asInteger + inRect top.
	(bw ~~ 0) ifTrue:[
	    newY := newY - bw
	].
    ] ifTrue:[
	newY := rel
    ].

    insets notNil ifTrue:[
	i := insets at:1.   "top"
	(i  ~~ 0) ifTrue:[
	    newX := newX - i
	].
	i := insets at:3.   "left"
	(i  ~~ 0) ifTrue:[
	    newX := newX - i
	].
	i := insets at:2.   "right"
	(i ~~ 0) ifTrue:[
	    newY := newY - i
	].
	i := insets at:4.   "bottom"
	(i ~~ 0) ifTrue:[
	    newY := newY - i
	].
    ].
    ^ newX @ newY
!

originFromRelativeOrigin
    "compute & return pixel origin from relativeOrigin"

    ^ self originFromRelativeOrigin:relativeOrigin
!

originFromRelativeOrigin:aPoint
    "compute & return pixel origin from relativeOrigin, aPoint"

    |p l t|

    p := self pointFromRelative:aPoint.

    insets isNil ifTrue:[
	^ p
    ].
    l := insets at:1.
    t := insets at:2.

"/  l := t := 0.
"/    leftInset notNil ifTrue:[
"/        l := leftInset
"/    ].
"/    topInset notNil ifTrue:[
"/        t := topInset
"/    ].
    ((l ~~ 0) or:[t ~~ 0]) ifTrue:[
	^ (p x + l) @ (p y + t)
    ].
    ^ p
!

pixelCorner:corner
    "set the view's corner in pixels"

    |w h|

    w := corner x - left + 1.
    h := corner y - top + 1.
    self pixelOrigin:(left @ top) extent:(w @ h)

    "Modified: 31.8.1995 / 18:20:22 / claus"
!

pixelExtent:extent
    "set the view's extent in pixels"

    self pixelOrigin:(left @ top) extent:extent
!

pixelOrigin
    "return the view's origin in pixels. For subviews. the origin is relative
     to the superview's top-left. For topViews, it's the screen origin."

    ^ self computeOrigin
!

pixelOrigin:origin
    "set the view's origin in pixels. For subviews. the origin is relative
     to the superview's top-left. For topViews, it's the screen origin."

    |newLeft newTop|

    newLeft := origin x.
    newTop := origin y.
    ((newTop ~~ top) or:[newLeft ~~ left]) ifTrue:[
	top := newTop.
	left := newLeft.

	"
	 if the receiver is visible, or is a topView, perform the
	 operation right away - otherwise, simply remember that the
	 origin has changed - will tell the display once we get realized
	"
"/        (shown
"/        or:[superView isNil and:[drawableId notNil]]) ifTrue:[

	"/ no, have to do it if drawableId is there
	"/ (otherwise, we could not move unmapped views around ...
	"/
	self drawableId notNil ifTrue:[
	    device moveWindow:self drawableId x:left y:top
	] ifFalse:[
	    self originChangedFlag:true
	]
    ]

    "Modified: / 21-01-2011 / 13:59:08 / cg"
!

pixelOrigin:origin corner:corner
    "set the view's origin and corner in pixels"

    |w h|

    w := corner x - origin x + 1.
    h := corner y - origin y + 1.
    self pixelOrigin:origin extent:(w @ h)

    "Modified: 31.8.1995 / 18:24:16 / claus"
!

pixelOrigin:origin extent:extent
    "set the view's origin and extent in pixels"

    |newLeft newTop newWidth newHeight how
     mustRedrawBottomEdge mustRedrawRightEdge mustRepaintBottom
     mustRepaintRight sameOrigin oldWidth oldHeight oldPaint|

    newLeft := origin x.
    newTop := origin y.
    sameOrigin := ((newTop == top) and:[newLeft == left]).

    newWidth := extent x.
    newHeight := extent y.

    "
     X complains badly if you try to create/resize a view with
     a dimension <= 0 ... (although I think that 0 makes sense ...)
    "
    newWidth < 1 ifTrue:[
        newWidth := 1.
    ].
    newHeight < 1 ifTrue:[
        newHeight := 1
    ].

    ((newWidth == width) and:[newHeight == height]) ifTrue:[
        sameOrigin ifTrue:[^ self].
        dependents notNil ifTrue:[ self changed:#origin ].
        ^ self pixelOrigin:origin
    ].

    top := newTop.
    left := newLeft.

"/    shown ifTrue:[                  "4-nov-94 actually correct,"
    self drawableId notNil ifTrue:[        "but theres a bug in menus when resized while hidden"
        mustRedrawBottomEdge := (margin ~~ 0) and:[newHeight < height].
        mustRedrawRightEdge := (margin ~~ 0) and:[newWidth < width].

        ((newHeight <= height) and:[newWidth <= width]) ifTrue:[
            how := #smaller
        ] ifFalse:[
            ((newHeight >= height) and:[newWidth >= width]) ifTrue:[
                how := #larger
            ]
        ].

        mustRepaintRight := false.
        mustRepaintBottom := false.

        oldWidth := width.
        oldHeight := height.

        shown ifTrue:[
            (margin ~~ 0) ifTrue:[
                "clear the old edges"

                oldPaint := nil.
                newWidth > width ifTrue:[
                    self clippingBounds:nil.
                    oldPaint := self paint.
                    self paint:viewBackground.
                    self fillDeviceRectangleX:(width - margin)
                                            y:0
                                        width:margin
                                       height:height.
                    mustRepaintRight := true.
                ].
                newHeight > height ifTrue:[
                    self clippingBounds:nil.
                    oldPaint := self paint.
                    self paint:viewBackground.
                    self fillDeviceRectangleX:0
                                            y:(height - margin)
                                        width:width
                                       height:margin.
                    mustRepaintBottom := true.
                ].
                oldPaint notNil ifTrue:[ self paint:oldPaint. ]
            ]
        ].

        width := newWidth.
        height := newHeight.

        self setInnerClip.

        "if view becomes smaller, send sizeChanged first"
        "now always"
        true  "(how == #smaller)" ifTrue:[
            self sizeChanged:how from:(oldWidth @ oldHeight)
        ].

        "have to tell X, when extent of view is changed"
        sameOrigin ifTrue:[
            device resizeWindow:self drawableId width:width height:height.
        ] ifFalse:[
            "claus: some xservers seem to do better when resizing
             first ...."
"
            (how == #smaller) ifTrue:[
                device resizeWindow:drawableId width:width height:height.
                device moveWindow:drawableId x:left y:top
            ] ifFalse:[
                device moveResizeWindow:drawableId x:left y:top width:width height:height
            ].
"
            device moveResizeWindow:self drawableId x:left y:top
                                           width:width height:height.
        ].

        "Have to tell graphics context when extent has changed.
         Some graphics context implementations need that (Cairo, for
         instance"
        ((width ~~ oldWidth) or:[height ~~ oldHeight]) ifTrue:[
            gc width:width height:height.
        ].

        "if view becomes bigger, send sizeChanged after"
        "no longer"
        false "(how ~~ #smaller)" ifTrue:[
            self sizeChanged:how from:(oldWidth @ oldHeight)
        ].

        shown ifTrue:[
            (mustRedrawBottomEdge or:[mustRedrawRightEdge]) ifTrue:[
                border notNil ifTrue:[
                    mustRedrawBottomEdge ifTrue:[
                        self invalidateDeviceRectangle:((0 @ (height - margin)) extent:width@margin) repairNow:false.
                    ].
                    mustRedrawRightEdge ifTrue:[
                        self invalidateDeviceRectangle:(((width - margin) @ 0) extent:margin@height) repairNow:false.
                    ].
                ] ifFalse:[
                    self deviceClippingBounds:nil.
                    oldPaint := self paint.
                    mustRedrawBottomEdge ifTrue:[
                        self drawBottomEdge
                    ].
                    mustRedrawRightEdge ifTrue:[
                        self drawRightEdge
                    ].
                    self paint:oldPaint.
                    self deviceClippingBounds:innerClipRect
                ]
            ].
        ].

        mustRepaintRight ifTrue:[
            self invalidateDeviceRectangle:(((oldWidth - margin) @ 0)
                                           extent:margin@height)
                                 repairNow:false.
"/            self redrawDeviceX:(oldWidth - margin)
"/                             y:0
"/                         width:margin
"/                        height:height.
        ].
        mustRepaintBottom ifTrue:[
            self invalidateDeviceRectangle:((0 @ (oldHeight - margin))
                                           extent:width@margin)
                                 repairNow:false.
"/            self redrawDeviceX:0
"/                             y:(oldHeight - margin)
"/                         width:width
"/                        height:margin.
        ].
    ] ifFalse:[
        "otherwise memorize the need for a sizeChanged message"

        width := newWidth.
        height := newHeight.
        sameOrigin ifFalse:[
            self originChangedFlag:true.
        ].
        self extentChangedFlag:true.
        subViews notEmptyOrNil ifTrue:[
            self extentChangedBeforeCreatedFlag:true.
        ].
    ].
    sameOrigin ifFalse:[
        dependents notNil ifTrue:[ self changed:#origin ].
    ].

    "Modified: / 25-05-1999 / 14:49:56 / cg"
    "Modified: / 17-07-2018 / 07:56:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pointFromRelative:p
    "compute absolute coordinate from p"

    |newX newY rel inRect bw superWidth superHeight superLeft superTop |

    bw := self borderWidth ? 0.

    superView isNil ifTrue:[
	superWidth := device width + bw.
	superHeight := device height + bw.
	superLeft := superTop := 0.
    ] ifFalse:[
	inRect := superView viewRectangle.
	superWidth := inRect width.
	superHeight := inRect height.
	superLeft := inRect left.
	superTop := inRect top.
    ].

    rel := p x.
    rel isInteger ifTrue:[
	newX := rel
    ] ifFalse:[
	newX := (rel * superWidth) asInteger + superLeft.
	(bw ~~ 0) ifTrue:[
	    rel ~= 1.0 ifTrue:[
		newX := newX - bw
	    ]
	]
    ].

    rel := p y.
    rel isInteger ifTrue:[
	newY := rel
    ] ifFalse:[
	newY := (rel * superHeight) asInteger + superTop.
	(bw ~~ 0) ifTrue:[
	    rel ~= 1.0 ifTrue:[
		newY := newY - bw
	    ]
	]
    ].
    ^ newX @ newY

    "Modified: / 1.10.1998 / 13:21:14 / cg"
!

setBorderColor
    "set my borderColor in the physical view (if supported by the device)"

"/    |id dither|
"/
"/    drawableId notNil ifTrue:[
"/        borderColor := borderColor onDevice:device.
"/        id := borderColor colorId.
"/        id notNil ifTrue:[
"/            device setWindowBorderColor:id in:drawableId
"/        ] ifFalse:[
"/            dither := borderColor ditherForm.
"/            dither notNil ifTrue:[
"/                device setWindowBorderPixmap:(dither id) in:drawableId
"/            ] ifFalse:[
"/                'SimpleView [warning]: bad borderColor' errorPrintCR
"/            ]
"/        ]
"/    ]

    "Modified: 10.1.1997 / 18:06:34 / cg"
!

setInnerClip
    "compute, and set the inside clip-area"

    self computeInnerClip.
    self clippingBounds:innerClipRect.

    "Modified: / 25.5.1999 / 14:45:53 / cg"
!

setShown:aState
    shown := aState

!

setViewShape
    |form|

    (form := viewShape borderShapeForm) notNil ifTrue:[
	gc windowBorderShape:form.
    ].
    (form := viewShape viewShapeForm) notNil ifTrue:[
	gc windowShape:form.
    ].

    "Created: 18.9.1997 / 11:09:00 / cg"
!

windowGroupClass
	^ WindowGroup
! !

!SimpleView methodsFor:'queries'!

anyComponentHasFocus
    "return true, if the receiver or any of my components has the keyboard focus
     (either via the focusView mechanism in the windowGroup,
      or via delegation)"

    |focusViewToCheck focusViewOnDisplay delegate|

    windowGroup isNil ifTrue:[^ false].

    "/ this is wrong (the old code).
    "/ focusViewInWindowGroup := windowGroup focusView.
    "/ focusViewToCheck := focusViewInWindowGroup.

    focusViewOnDisplay := device focusView.
    focusViewToCheck := focusViewOnDisplay.

    focusViewToCheck == self ifTrue:[ ^ true ].

    focusViewToCheck notNil ifTrue:[
	(focusViewToCheck isComponentOf: self) ifTrue:[ ^ true ].

	"mhmh - is there a delegation to me ?"
	(delegate := focusViewToCheck delegate) notNil ifTrue:[
	    delegate == self ifTrue:[^ true].
	    "/ no: delegate does not understand this (EnterFieldGroup or KbdForwarder)
	    "/ we will see, if commenting this leads to problems...
	    "/ (delegate isComponentOf: self) ifTrue:[ ^ true ].
	    ^ delegate askFor:#delegatesTo: with:self
	]
    ].
    ^ false

    "Modified: / 08-11-2006 / 12:10:32 / cg"
!

canHandle:aKey
    "return true, if I like to handle the key (from a keyPress event).
     OBSOLETE: do not use & depend on this method, it is a historic
     leftOver and will be removed. Use the delegation mechanism for this."

    ^ false
!

canHandle:aKey from:aView
    "return true, if I like to handle the key (from a keyPress event)
     in aView.
     OBSOLETE: do not use & depend on this method, it is a historic
     leftOver and will be removed. Use the delegation mechanism for this."

    ^ self canHandle:aKey
!

computePreferredExtent
    "compute answer the preferred extent, disregarding
     an explicit or cached preferred extent for the computation"

    |savedPref savedExplicit computedPref|

    savedPref := preferredExtent.
    savedExplicit := explicitExtent.
    [
	preferredExtent := explicitExtent := nil.
	computedPref := self preferredExtent.
    ] ensure:[
	preferredExtent := savedPref.
	explicitExtent := savedExplicit.
    ].
    ^ computedPref
!

cornerChangedFlag
    "/ ^ cornerChangedFlag == true
    ^ flagBits bitTest:FlagCornerChanged
!

cornerChangedFlag:aBoolean
    "/ cornerChangedFlag := aBoolean
    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagCornerChanged
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagCornerChanged
    ].
!

delegatesTo:someone
    "return true, if I delegate events to someone"

    delegate isNil ifTrue:[^ false].
    ^ delegate delegatesTo:someone
!

escapeIsCancel
    "return the escapeIsCancel setting - defaults to true for popupViews here."

    ^ self isPopUpView
!

extentChangedBeforeCreatedFlag
    ^ flagBits bitTest:FlagExtentChangedBeforeCreated
!

extentChangedBeforeCreatedFlag:aBoolean
    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagExtentChangedBeforeCreated
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagExtentChangedBeforeCreated
    ].
!

extentChangedFlag
    "/ ^ extentChangedFlag == true
    ^ flagBits bitTest:FlagExtentChanged
!

extentChangedFlag:aBoolean
    "/ extentChangedFlag := aBoolean
    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagExtentChanged
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagExtentChanged
    ].
!

hasExplicitFocus
    "return true, if the receiver has the keyboard focus
     via the focusView mechanism in the windowGroup"

    windowGroup isNil ifTrue:[^ false].
    ^ windowGroup explicitFocusView == self
!

hasFocus
    "return true, if the receiver has the keyboard focus
     (either via the focusView mechanism in the windowGroup,
      or via delegation)"

    |focusViewToCheck focusViewOnDisplay delegate|

    windowGroup isNil ifTrue:[^ false].

    "/ this is wrong (the old code).
    "/ focusViewInWindowGroup := windowGroup focusView.
    "/ focusViewToCheck := focusViewInWindowGroup.

    focusViewOnDisplay := device focusView.
    focusViewToCheck := focusViewOnDisplay.

    focusViewToCheck == self ifTrue:[ ^ true ].

    focusViewToCheck notNil ifTrue:[
	"mhmh - is there a delegation to me ?"
	(delegate := focusViewToCheck delegate) notNil ifTrue:[
	    delegate == self ifTrue:[^ true].
	    ^ delegate askFor:#delegatesTo: with:self
	]
    ].
    ^ false

    "Modified: / 08-11-2006 / 12:10:32 / cg"
!

is3D
    "return true, if my style is some kind of 3D style
     This is OBSOLETE and will be removed."

    ^ styleSheet is3D
!

isActive
    "true, if I have the focus (w.r.t the windowing system);
     i.e. if one of my subViews actually has the real focus.
     With click-to-focus behavior, this is obviously the current application.
     Use this query with caution, for example, to suppress tooltips for inactive apps."

    ^ windowGroup notNil and:[windowGroup anyViewHasFocus]
!

isBorderedWrapper
     ^ false

    "Created: 5.6.1996 / 14:11:15 / cg"
!

isComponentOf:aViewOrComponent
    "return true, if I am a (direct or indirect) component of aViewOrComponent"

    |sview|

    sview := self.

    [ (sview := sview container) notNil ] whileTrue:[
	sview == aViewOrComponent ifTrue:[^ true].
    ].
    ^ false
!

isCursorKeyConsumer
    "return true, if the receiver can be controlled by cursor keys;
     i.e. it can handle some keyboard input,
     isCursorKeyConsumer are potential candidates for getting the keyboard
     focus initially within dialogBoxes, or when the focus-follows-pointer
     mode is off.
     Return false here, this is redefined in SelectionInListView."

    ^ false
!

isDefault
    "return true, if I am a default widget;
     Used with autoAccept. Currently only default buttons are supposed to return
     true here"

     ^ false
!

isExternalTopView
    "return true, if this is an external topView - always false here"

    ^ false


!

isICCCWindowGroupWindow
    "needed for checkForEndOfDispatch"

    ^ false
!

isInputField
    "return true, if the receiver is some kind of input view,
     i.e. it should (can) be part of an enterGroup.
     Return false here, this is redefined in EnterField."

    ^ false

    "Created: 4.3.1996 / 11:34:07 / cg"
!

isJavaView
    ^ false

    "Created: / 4.12.1998 / 14:10:06 / cg"
!

isKeyboardConsumer
    "return true, if the receiver is a keyboard consumer;
     i.e. it can handle (non-shortkey) keyboard input,
     keyboardConsumer are potential candidates for getting the keyboard
     focus initially within dialogBoxes, or when the focus-follows-pointer
     mode is off.
     Return false here, this is redefined in EditTextView and EditField."

    ^ false

    "Modified: / 22.5.1999 / 16:19:27 / cg"
!

isLayoutWrapper
    "answer true, if this view defines the layout of it's subviews"

    ^ false

    "Created: 19.7.1996 / 17:51:04 / cg"
!

isMDIClientView
    ^false
!

isModal
    "return true, if the receiver has been opened modal.
     For compatibility with topView (if regular views are the window of an application),
     return false here."

    ^ false
!

isSameOrComponentOf:aView
    "return true, if I am aView or a (direct or indirect) component of aView"

    ^ self == aView or:[self isComponentOf:aView].
!

isScrollWrapper
     "answer true if this view wraps a possibly larger view and has scroll bars"

     ^ false

    "Created: / 5.6.1996 / 14:11:15 / cg"
    "Modified: / 20.6.1998 / 14:15:29 / cg"
!

isSubViewOf:aView
    "return true, if I am a (direct or indirect) subview of aView"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #isComponentOf:'.
    ^ self isComponentOf:aView.

    "Modified: 5.6.1996 / 14:25:35 / cg"
!

isTextView

    "Returns true, if the view displays text"

    "JV@2011-09-16: Do not remove this method, it is called
     at many places. See senders before removing!!!!!!"

    ^ false

    "Created: / 16-09-2011 / 17:49:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTransparentBox
     ^ false
!

isWrapper
     ^ false

    "Created: 5.6.1996 / 01:05:06 / cg"
!

originChangedFlag
    "/ ^ originChangedFlag == true
    ^ flagBits bitTest:FlagOriginChanged
!

originChangedFlag:aBoolean
    "/ originChangedFlag := aBoolean
    aBoolean ifTrue:[
	flagBits := flagBits bitOr:FlagOriginChanged
    ] ifFalse:[
	flagBits := flagBits bitClear:FlagOriginChanged
    ].
!

originChangedFlag:originChanged extentChangedFlag:extentChanged
    |newBits|

    newBits := flagBits bitClear:(FlagOriginChanged bitOr: FlagExtentChanged).

    originChanged ifTrue:[
	newBits := newBits bitOr:FlagOriginChanged
    ].
    extentChanged ifTrue:[
	newBits := newBits bitOr:FlagExtentChanged
    ].

    flagBits := newBits.
!

originChangedFlag:originChanged extentChangedFlag:extentChanged cornerChangedFlag:cornerChanged
    |newBits|

    newBits := flagBits bitClear:((FlagOriginChanged bitOr: FlagExtentChanged) bitOr: FlagCornerChanged).

    originChanged ifTrue:[
	newBits := newBits bitOr:FlagOriginChanged
    ].
    extentChanged ifTrue:[
	newBits := newBits bitOr:FlagExtentChanged
    ].
    cornerChanged ifTrue:[
	newBits := newBits bitOr:FlagCornerChanged
    ].

    flagBits := newBits.
!

originOrExtentChanged
    "/ ^ originChanged or:[extentChanged].
    ^ flagBits bitTest:( FlagOriginChanged + FlagExtentChanged )
!

originOrExtentOrCornerChanged
    "/ ^ originChanged or:[extentChanged or:[cornerChanged]].
    ^ flagBits bitTest:( FlagOriginChanged + FlagExtentChanged + FlagCornerChanged )
!

preferredBounds
    "ST-80 compatibility."

    ^ 0@0 extent:(self preferredExtent)

    "Modified: 19.7.1996 / 20:41:36 / cg"
!

preferredExtent
    "return my preferred extent - this is the minimum size I would like to have.
     If the preferredExtent has been set, that one is returned.
     Otherwise, if there are any components, a rectangle enclosing them
     is returned. Otherwise, the actual extent is returned."

    |maxX maxY|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
	^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
	^ preferredExtent
    ].

    "/ mhmh - if I have subViews, collect their
    "/ preferred bounds ...

    subViews notNil ifTrue:[
	maxX := maxY := 0.
	subViews do:[:aSubView |
	    |org corn|

	    org := aSubView computeOrigin.
	    corn := org + aSubView preferredExtent.
	    maxX := maxX max:corn x.
	    maxY := maxY max:corn y.
	]
    ].

    "/ mhmh - if I have components, collect their preferred bounds ...
    components notNil ifTrue:[
	maxX isNil ifTrue:[
	    maxX := maxY := 0.
	].
	components do:[:aComponent |
	    |bounds org corn|

	    bounds := aComponent preferredBounds.
	    corn := bounds corner.
	    maxX := maxX max:corn x.
	    maxY := maxY max:corn y.
	]
    ].

    "/ nothing found - return the actual size

    maxX isNil ifTrue:[
	^ self extent.
    ].

    ^ maxX @ maxY.

    "Modified: 19.7.1996 / 20:43:32 / cg"
!

preferredHeight
    ^ self preferredExtent y
!

preferredWidth
    ^ self preferredExtent x
!

reallyRealized
    "return true, if the receiver is realized and all containers are realized.
     Realized means that it has been mapped (i.e. made visible) on
     the display (as opposed to being only created and possibly invisible)"

    realized ifFalse:[^ false].
    superView isNil ifTrue:[^ true].
    ^ superView reallyRealized
!

resources
    "return the view's resources -
     that's a ResourcePack containing national language strings"

    ^ resources

    "Created: / 25.5.1998 / 13:00:02 / cg"
!

sizeFixed
    "return true, if this view wants its size to remain unchanged.
     Used by panels, to check if their components want to keep their size."

    ^ false

    "Created: 17.9.1995 / 20:29:20 / claus"
!

startWindowMoveOnButtonPress
    "if another view is used as topView"

    ^ false

    "Created: / 04-03-2011 / 08:57:45 / cg"
!

tabRequiresControl
    "returns true, if a focus tabbing requires a control-key to be pressed.
     The default is true for editTextView, false for other widgets,
     to allow for easier text entry"

    ^ false
!

window
    "for compatibility with applicationModels ... return the receiver"

    ^ self
! !

!SimpleView methodsFor:'queries-delegation'!

handlesMouseWheelMotion:event inView:aView
    "we do not handle delegated mousewheel events - subclasses may handle them"

    ^ false
! !

!SimpleView methodsFor:'queries-events'!

buttonMotionEventPending
    "return true, if a button motion event is pending.
     Normally, you don't want to use this, since no polling is needed
     (not even for mouse-tracking).
     Actually, its a historical leftover"

    windowGroup notNil ifTrue:[
	^ windowGroup sensor hasButtonMotionEventFor:self
    ].
    ^ super buttonMotionEventPending

    "Modified: 1.11.1996 / 17:04:38 / cg"
! !

!SimpleView methodsFor:'queries-internal'!

specClass
    "fallback - heuristics to get a specClass for some viewClass.
     Based upon my className, look for a corresponding Spec-class.
     If there is none, return ArbiraryComponentSpec as a fallBack"

    |myClass myName cls|

    myClass := self class.
    (myClass == View or:[myClass == SimpleView]) ifTrue:[
	^ ViewSpec "/ CompositeSpecCollection
    ].

    "/ try: appending 'Spec' to my classes name

    myName := self class name.
    cls := Smalltalk classNamed:(myName , 'Spec').
    cls notNil ifTrue:[
	cls := cls autoload.
	(cls isSubclassOf:UISpecification) ifTrue:[^ cls].
    ].

    (myName endsWith:'View') ifTrue:[
"/        "/ try name without 'View'
"/        cls := Smalltalk classNamed:(myName copyWithoutLast:4).
"/        cls notNil ifTrue:[
"/            cls := cls autoload.
"/            (cls isSubclassOf:UISpecification) ifTrue:[^ cls].
"/        ].

	"/ try with 'View' replaced by 'Spec'
	cls := Smalltalk classNamed:((myName copyButLast:4) , 'View').
	cls notNil ifTrue:[
	    cls := cls autoload.
	    (cls isSubclassOf:UISpecification) ifTrue:[^ cls].
	]
    ].

    "/ fall back for all others
    ^ ArbitraryComponentSpec


    "
     FramedBox new specClass
    "

    "Modified: / 31.10.1997 / 19:44:55 / cg"
!

windowStyle
    "return a symbol describing my style (one of: #dialog, #popUp or #normal)"

    self isPopUpView ifTrue:[
	^ #popUp
    ].
    self isMDIChildView ifTrue:[
	^ #mdiChild
    ].
    ^ #normal

    "Created: 2.5.1997 / 14:29:48 / cg"
    "Modified: 2.5.1997 / 14:30:14 / cg"
!

windowType
    "return a symbol describing my type (one of: #mdichild or nil)"

    ^ nil
! !

!SimpleView methodsFor:'realization'!

activate
    "noop for protocol compatibility with TopViews (in case you do a Button new open)"

    "Created: / 17-09-2010 / 16:30:24 / cg"
    "Modified: / 17-09-2010 / 18:39:35 / cg"
!

closeCancel
    "for protocol compatibility with modal dialogs"

    self hideRequest
!

create
    "create (i.e. tell my device about me) if not already created.
     This does not make the view visible (needs a #map for that)"

    self drawableId isNil ifTrue:[
	"
	 make certain that superview is created also
	"
	superView notNil ifTrue:[
	     superView view create.

"/            "and put my controller into the superviews controller list"
"/            controller notNil ifTrue:[
"/                superView controller notNil ifTrue:[
"/                    controller manager:(superView controller manager)
"/                ]
"/            ]
	] ifFalse:[
	    device isNil ifTrue:[ device := Screen current ].
	    "/
	    "/ if the display is not already dispatching events,
	    "/ this starts the event process.
	    "/
	    device startDispatch
	].

	cursor notNil ifTrue:[
	    cursor := cursor onDevice:device.
	].

	self extentChangedBeforeCreatedFlag ifTrue:[
	    "/ this is true, if the extent was changed before
	    "/ this view was created (and therefore, no sizeChangeEvent
	    "/ was sent to me, which would notify children.)
	    "/ have to do this here.
	    self sizeChanged:nil.   "/ must tell children (if any)
	].
	self hasExplicitExtent ifFalse:[
	    self resize
	].

	self physicalCreate.

	viewBackground notNil ifTrue:[
	   self setViewBackground
	].

	self initEvents.

	"
	 this is the first create,
	 force sizechange messages to be sent to the view
	"
	self originChangedFlag:true extentChangedFlag:true
    ]

    "Modified: 28.3.1997 / 13:50:17 / cg"
!

createWithAllSubViews
    "create, then create all subviews"

    self drawableId isNil ifTrue:[self create].
    subViews notNil ifTrue:[
	subViews do:[:subView | subView createWithAllSubViews]
    ]
!

fetchDeviceResources
    "fetch all device specific resources. This is invoked,
     when the view is made visible on some device for the very first
     time, to allocate device specific colors, fonts, bitmaps etc.
     The view may keep those in instance variables, to avoid reallocating
     those with every redraw.
     If you ommit to do this, the views will still be able to display themself,
     but possibly slower, since resources are reallocated over and over.
     If you redefine this method, make certain that 'super fetchDeviceResources'
     is always sent."
    
    shadowColor notNil ifTrue:[
	shadowColor := shadowColor onDevice:device
    ].
    lightColor notNil ifTrue:[
	lightColor := lightColor onDevice:device
    ].

    "Created: 13.1.1997 / 21:51:59 / cg"
!

fixSize
    "This is called right before the view is made visible.
     Adjust the size of the view according to either relative/abs or
     block extent; also set origin. Also, subclasses may redefine this
     method to adjust the size based on some extent (for example, PopUpMenus
     do so to take care of changed number of menu entries)."

    |org ext r|

    "
     slowly migrating to use layoutObjects ...
    "
    layout notNil ifTrue:[
	superView notNil ifTrue:[
	    (self originOrExtentOrCornerChanged) ifTrue:[
		layout isAssociation ifTrue:[
		    layout key == #extent ifTrue:[
			org := 1@1.
			ext := layout value.
		    ] ifFalse:[
			self shouldImplement.
		    ].
		] ifFalse:[
		    r := (layout rectangleRelativeTo:(superView viewRectangle)
					   preferred:[self preferredBounds]).
		    org := r origin rounded.
		    ext := r extent rounded.
		].
		self pixelOrigin:org extent:ext.
	    ].
	].
	^ self.
    ].

    "if the extent is not the one we created the window with ..."
"/    self extentChangedFlag ifTrue:[
"/        self sizeChanged:nil.
"/        self extentChangedFlag:false
"/    ].

    self originChangedFlag ifTrue:[
"/        org := self computeOrigin.
"/        self pixelOrigin:org.
	originRule notNil ifTrue:[
	    self pixelOrigin:self computeOrigin
	] ifFalse:[
	    relativeOrigin notNil ifTrue:[
		self originFromRelativeOrigin:relativeOrigin
	    ] ifFalse:[
		shown ifTrue:[
		    device moveWindow:self drawableId x:left y:top.
		] ifFalse:[
		    self pixelOrigin:left@top
		].
	    ].
	].
	self originChangedFlag:false
    ]

    "Modified: 18.6.1996 / 21:44:03 / cg"
!

forceResize
    "force resizing - even if already done"

    self explicitExtent:false.
    self resize
!

hide
    "only useful with modal views: hide the view and return control
     back to the suspended main view. Ignored for non-modal views."

    |masterGroup|

    realized ifFalse:[^ self].
    (windowGroup notNil and:[windowGroup isModal]) ifTrue:[
	masterGroup := windowGroup previousGroup.
	windowGroup focusView:nil.
    ].

    self unmap.
    self flush.

    masterGroup notNil ifTrue:[
	"
	 this is a kludge for IRIS and others which do not provide backingstore:
	 when we hide a modalbox (such as a searchbox) which covered
	 a scrollbar, the scrollbars bitblt-method will copy from the
	 not-yet redrawn area - effectively clearing the scroller.
	 We need a short delay here, since at this time, the expose event has
	 not yet arrived.
	"
	Delay waitForSeconds:0.05.
	masterGroup processExposeEvents
    ].

"/    WindowGroup leaveSignal raise.
"/    "/ not reached
!

hideForAction
    "for popUpMenu compatibility;
     this is invoked to hide a when it is going to perform its action
     (in contrast to the generic hide)."

    ^ self hide
!

hideRequest
    "for protocol compatibility with modal dialogs;
     ignored here."

    self isPopUpView ifTrue:[
	self hide
    ].
    ^ self
!

map
    "make the view visible on the screen.
     For topViews, the windowManager will choose (or ask for) the
     views position on the screen.
     Notice:
	Actually, this method is only valid for topViews;
	however, it is defined here to allow things like 'Button new realize'"

    self mapAt:nil iconified:false

    "Modified: 24.7.1997 / 13:44:25 / cg"
!

mapAt:aPoint
    "make the view visible on the screen.
     For topViews, if aPoint is nonNil, the view's origin is located there
     (unless you have a dictator as windowManager ;-)
     Notice:
        Actually, this method is only valid for topViews;
        however, it is defined here to allow things like 'Button new realize'"

    self mapAt:aPoint iconified:false

    "Modified: 24.7.1997 / 13:45:02 / cg"
!

mapAt:aPoint iconified:iconified
    "make the view visible on the screen.
     For topViews, if aPoint is nonNil, the view's origin is located there
     (unless you have a dictator as windowManager ;-).
     If the iconified argument is true, the window is created as icon initially.
     Notice:
        Actually, this method is only valid for topViews;
        however, it is defined here to allow things like 'Button new realize'"

    |subs|

    realized ifFalse:[
        self drawableId isNil ifTrue:[
            "
             first time ?
             yes, realize (implies a map)
            "
            self realizeKeepingGroup:false at:aPoint iconified:iconified
        ] ifFalse:[
            "
             no, map only
            "
            realized := true.
            aPoint isNil ifTrue:[
                iconified ifTrue:[
                    device
                        mapView:self id:self drawableId iconified:iconified
                        atX:0 y:0
                        width:width height:height
                        minExtent:(self minExtent) maxExtent:(self maxExtent).
                ] ifFalse:[
                    device mapWindow:self drawableId.
                ]
            ] ifFalse:[
                left := aPoint x.
                top := aPoint y.
                device
                    mapView:self id:self drawableId iconified:iconified
                    atX:left y:top
                    width:width height:height
                    minExtent:(self minExtent) maxExtent:(self maxExtent).
            ].

            "/
            "/ implies that all realized subviews
            "/ are now also mapped
            "/
            "/ not needed for topViews - the mapped event does exactly the same
            "/ however, X does not generate mapped events for non-topViews
            "/ when a view gets deiconified.

            superView notNil ifTrue:[
                (subs := self subViews) notNil ifTrue:[
                    subs do:[:v |
                        v realized "shown" ifFalse:[
                            v mapped
                        ]
                    ]
                ]
            ]
        ].
    ]

    "Modified: 23.8.1996 / 14:53:55 / stefan"
    "Created: 24.7.1997 / 13:43:23 / cg"
    "Modified: 24.7.1997 / 13:46:21 / cg"
!

mapIconified
    "make the view visible on the screen.
     For topViews, the view is created in iconified state"

    self mapAt:nil iconified:true

    "Modified: 24.7.1997 / 13:44:25 / cg"
    "Created: 24.7.1997 / 13:47:03 / cg"
!

physicalCreate
    "common code for create & recreate:
     physically create (but do not map) the view on the device."

    |sv isInputOnly|

    sv := superView isNil ifTrue:[nil] ifFalse:[superView view].

    "/ give global eventListeners a chance to intercept windowCreation
    "/ and provide another origin (by payching my origin via setOrigin:).
    WindowSensor preViewCreateNotification:self.

    isInputOnly := self isInputOnly.

    gc
      createWindowFor:self
      type:(self windowType)
      origin:(left @ top)
      extent:(width @ height)
      minExtent:nil
      maxExtent:nil
      borderWidth:0 "self borderWidth"
      subViewOf:sv
      style:(self windowStyle)
      inputOnly:isInputOnly
      label:nil
      owner:nil
      icon:nil iconMask:nil
      iconView:nil.

    "/ if there is a global eventListener,
    "/ give it a chance to track views

    "/ give global listeners a chance to track views
    WindowSensor postViewCreateNotification:self.

    self originChangedFlag:false extentChangedFlag:false.

"/    (borderColor notNil and:[borderColor ~= Black]) ifTrue:[
"/        isInputOnly ifFalse:[
"/            self setBorderColor
"/        ]
"/    ].
    (viewGravity notNil "and:[viewGravity ~~ #NorthWest]") ifTrue:[
	gc viewGravity:viewGravity.
    ].
    (bitGravity notNil "and:[bitGravity ~~ #NorthWest]") ifTrue:[
	isInputOnly ifFalse:[
	    gc bitGravity:bitGravity.
	]
    ].
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

    name notNil ifTrue:[
	self windowName:name.
    ].

    "Modified: / 9.4.1998 / 20:18:12 / cg"
!

postRealize
    "invoked after a view was realized.
     Can be redefined in subclasses to perform delayed actions."

    "/ nothing done here

    "Created: 24.7.1997 / 14:35:36 / cg"
!

preRealize
    "invoked right before a view is realized.
     Can be redefined in subclasses to perform delayed actions."

    "/ nothing done here

    "Created: 24.7.1997 / 14:35:36 / cg"
!

realize
    "realize - make visible;
     realizing is done very late (after layout is fixed) to avoid
     visible rearranging of windows on the screen"

    self isBeingDestroyed:false. "/ in case a view gets rerealized
    self realizeKeepingGroup:false at:nil iconified:false

    "Modified: 24.7.1997 / 13:14:28 / cg"
!

realizeAllSubViews
    "realize all my subviews - but not myself."

    subViews notNil ifTrue:[
	subViews do:[:subView |
	    subView realize
	]
    ].
    components notNil ifTrue:[
	components do:[:component |
	    component realize
	]
    ].

    "Modified: 5.9.1995 / 23:30:47 / claus"
    "Modified: 13.1.1997 / 21:25:49 / cg"
!

realizeAt:aPoint
    "realize - make visible;
     realizing is done very late (after layout is fixed) to avoid
     visible rearranging of windows on the screen"

    self realizeKeepingGroup:false at:aPoint iconified:false

    "Modified: 24.7.1997 / 13:14:28 / cg"
    "Created: 24.7.1997 / 13:21:04 / cg"
!

realizeInGroup
    "special realize - leave windowgroup as is;
     This allows a view to be realized in any windowgroup;
     for special applications, like the kill button in the Filebrowser which has
     a windowGroup different from its superview's and is handled as a separate process."

    windowGroup isForModalSubview:true.
"/    self realize.

    self realizeKeepingGroup:true at:nil iconified:false

    "Modified: 20.8.1997 / 14:56:20 / cg"
!

realizeKeepingGroup:keepGroupAsIs at:position iconified:iconified
    "common helper for realize and realizeInGroup.
     Create the view; if the keepGroupAsIs argument is not true,
     assign my windowGroup."

    |superGroup groupChange keep|

    "/ fetch device colors, to avoid reallocation at redraw time
    self fetchDeviceResources.

    self drawableId isNil ifTrue:[
        self create.
        self drawableId isNil ifTrue:[
            ('SimpleView [warning]: could not create view: ' , self class name) errorPrintCR.
            ^ self
        ]
    ].

    self isBeingDestroyed:false. "/ in case a view gets rerealized
    groupChange := false.

    (windowGroup notNil
     and:[superView isNil
     and:[windowGroup isForModalSubview]]) ifTrue:[
        keep := true.
    ] ifFalse:[
        keep := keepGroupAsIs
    ].

    keep ifFalse:[
        "
         put myself into superviews windowgroup if there is a superview
         This is the default behavior, which may be suppressed by
         passing true as keepGroupAsIs-argument.
         (it may be useful to assign a separate windowGroup to
          a childView to have it execute independent of the parent
          -> an example is found in the fileBrowsers kill-button)
        "
        superView notNil ifTrue:[
            superGroup := superView windowGroup.
            (windowGroup notNil and:[superGroup ~~ windowGroup]) ifTrue:[
                "
                 mhmh - seems that the windowgroup has changed ....
                "
"/                'oops - wgroup change on realize' printNL.
                groupChange := true.

                "/
                "/ recursively change the windowGroup of
                "/ myself and all of my children
                "/
                self windowGroup:superGroup.
            ] ifFalse:[
                windowGroup isNil ifTrue:[
                    "/
                    "/ only change the group of myself -
                    "/ subviews will fetch it when realized.
                    "/
                    windowGroup := superGroup.
                    superGroup notNil ifTrue:[superGroup addView:self].
                ]
            ].
        ].
    ].

    (self originOrExtentChanged) ifTrue:[
        self fixSize.
        self sizeChanged:nil.
    ].
    position notNil ifTrue:[
        self origin:position.
    ].

    (subViews notNil or:[components notNil]) ifTrue:[
        (realized not or:[groupChange]) ifTrue:[
            self isHiddenOnRealize ifFalse:[
                self realizeAllSubViews.
            ].
        ].
    ].

    self preRealize.

    iconified ifTrue:[
        realized ifFalse:[
            self mapIconified
        ]
    ] ifFalse:[
        self isHiddenOnRealize ifFalse:[
            self setInnerClip.

            realized ifFalse:[
                "
                 now, make the view visible
                "
                self mapAt:position
            ]
        ]
    ].

    controller notNil ifTrue:[
        controller startUp
    ].

    self postRealize

    "Modified: / 23.8.1996 / 15:07:16 / stefan"
    "Created: / 24.7.1997 / 13:10:17 / cg"
    "Modified: / 27.7.1998 / 20:01:02 / cg"
!

recreate
    "Recreate (i.e. tell the windowing system about me) after a snapin or a migration"

    "/ Issue #86: Do not recreate a view which has been
    "/ destroyed (by mean of sending it #destroy) but for
    "/ some other reason retained. 
    "/ See https://swing.fit.cvut.cz/projects/stx-jv
    self isBeingDestroyed ifTrue:[ ^self ].

    self drawableId isNil ifTrue:[
	super recreate.
	self physicalCreate.

	viewBackground notNil ifTrue:[
	    self setViewBackground
	].

	"
	 XXX has to be changed: eventmasks are device specific -
	 XXX will not allow restart on another Workstation-type.
	 XXX event masks must become symbolic
	"
	eventMask isNil ifTrue:[
	    eventMask := device defaultEventMask
	].
	device setEventMask:eventMask in:self drawableId
    ]
!

recursiveRealizeAllSubViews
    "realize all my subviews and all of their subviews - but not myself."

    subViews notNil ifTrue:[
	subViews do:[:subView |
	    subView realize.
	    subView recursiveRealizeAllSubViews.
	]
    ].
    components notNil ifTrue:[
	components do:[:component |
	    component realize.
	    component recursiveRealizeAllSubViews.
	]
    ].
!

remap
    "make the view visible on the screen at its previous position.
     In contrast to map, this asks the windowManager to show the view
     immediately (instead of asking for a frame). However, some windowManagers
     are known to ignore this ..."

    realized ifFalse:[
	self drawableId isNil ifTrue:[
	    self realize
	] ifFalse:[
	    "
	     now, make the view visible
	    "
	    realized := true.
	    device
		mapView:self id:self drawableId iconified:false
		atX:left y:top width:width height:height
		minExtent:(self minExtent) maxExtent:(self maxExtent)
	]
    ]

    "Created: 8.5.1996 / 09:33:06 / cg"
    "Modified: 25.2.1997 / 22:44:33 / cg"
!

rerealize
    "rerealize at old position in (a possibly different) windowGroup."

    self fetchDeviceResources.

    self rerealizeInGroup:windowGroup.

    "Created: 7.11.1996 / 16:27:09 / cg"
    "Modified: 13.1.1997 / 21:53:18 / cg"
!

rerealizeInGroup:aWindowGroup
    "rerealize at old position in (a possibly different) windowGroup."

    self drawableId isNil ifTrue:[self create].
    self drawableId notNil ifTrue:[
	aWindowGroup ~~ windowGroup ifTrue:[
	    windowGroup notNil ifTrue:[
		windowGroup removeView:self
	    ].
	    windowGroup := aWindowGroup.
	    aWindowGroup addTopView:self.
	].
	self remap.
    ]

    "Modified: 3.5.1996 / 23:59:30 / stefan"
    "Modified: 28.7.1997 / 18:53:01 / cg"
!

rerealizeWithAllSubViews
    "rerealize myself with all subviews"

    self drawableId notNil ifTrue:[
	realized := true.
	self realizeAllSubViews.
	superView isNil ifTrue:[
	    device
		mapView:self id:self drawableId iconified:false
		atX:left y:top width:width height:height
		minExtent:(self minExtent) maxExtent:(self maxExtent)
	] ifFalse:[
	    device
		mapWindow:self drawableId
	].
    ]

    "Modified: 28.1.1997 / 17:59:28 / cg"
!

resize
    "resize myself to make everything fit into me.
     Here, nothing special is done (except for setting my extent to the
     preferredExtent), but may be redefined in some subclasses."

    self hasExplicitExtent ifFalse:[
	layout isNil ifTrue:[
	    self extent:(self preferredExtent).
	    self explicitExtent:false.
	].
    ]

    "Modified: 15.7.1996 / 11:20:27 / cg"
!

setForegroundWindow
    "noop for protocol compatibility with TopViews (in case you do a Button new open)"

    "Created: / 17-09-2010 / 16:30:24 / cg"
    "Modified: / 17-09-2010 / 18:39:35 / cg"
!

unmap
    "unmap the view - the view stays created (but invisible), and can be remapped again later."

    realized ifTrue:[
	realized := false.
	self drawableId notNil ifTrue:[
	    device unmapWindow:self drawableId.

	    "/ make it go away immediately
	    "/ (this hides the subview killing)
	    self flush.
	].

	"/ Normally, this is not correct with X, where the
	"/ unmap is an asynchronous operation.
	"/ (shown is cleared also in unmapped event)
	"/ Do it anyway, to avoid synchronisation problems.

	shown ifTrue:[
	    shown := false.
	    dependents notNil ifTrue:[ self changed:#visibility ].
	]
    ].

    "
     |top sub|

     top := StandardSystemView new.
     top extent:200@200.

     sub := View
		origin:0.2@0.2
		corner:0.8@0.8
		in:top.

     sub viewBackground:Color red.
     sub hiddenOnRealize:true.

     top open.
     (Delay forSeconds:5) wait.
     sub map.
     (Delay forSeconds:3) wait.
     sub unmap.
     sub viewBackground:(Color green).
     (Delay forSeconds:3) wait.
     sub map.
    "

    "Modified: / 22.2.1999 / 20:10:58 / cg"
!

unrealize
    "alias for unmap, for historic reasons"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #unmap'.
    self unmap.

    "Modified: 4.5.1996 / 00:07:48 / stefan"
! !

!SimpleView methodsFor:'redrawing'!

clearExposedAreaInRedraw
    "return true here, if the exposed area should be cleared here
     or not. In almost every situation, it makes sense to do so..."

    ^ true
!

drawFocusFrame
    self hasFocus ifTrue:[
	(styleSheet at:#focusHighlightStyle) == #win95 ifTrue:[
	    self windowGroup focusCameByTab ifTrue:[
		self drawWin95FocusFrame
	    ]
	].
    ]
!

flash
    "flash the view - fill it black, then white, finally
     redraw completely.
     Can be used to wakeup the user :-)
     when problem or warning conditions arise.
     Someone may redefine this to flash its contents (instead of black/white)."

    self flash:nil

    "
     |v|

     v := View new openAndWait.
     Delay waitForSeconds:2.
     v flash.
     Delay waitForSeconds:2.
     v destroy
    "

    "Modified: / 16.7.1998 / 18:46:48 / cg"
!

flash:messageOrNil
    "flash the view - fill it black, then white, finally
     redraw completely.
     Can be used to wakeup the user :-)
     when problem or warning conditions arise.
     Someone may redefine this to flash its contents (instead of black/white)."

    self flash:messageOrNil withColor:self blackColor.

    "
     |v|

     v := View new openAndWait.
     Delay waitForSeconds:2.
     v flash:'Hello World'.
     Delay waitForSeconds:2.
     v destroy
    "
!

flash:messageOrNil withColor:flashColor
    "flash the view - fill it black, then white, finally
     redraw completely.
     Can be used to wakeup the user :-)
     when problem or warning conditions arise.
     Someone may redefine this to flash its contents (instead of black/white)."

    shown ifFalse:[^ self]. 

    self fill:flashColor.
    messageOrNil notNil ifTrue:[
        gc withForeground:self whiteColor do:[
            self displayString:messageOrNil centeredAt:(self center).
        ].
    ].
    Delay waitForSeconds:0.1.
    shown ifFalse:[^ self]. 
    
    self fill:self whiteColor.
    messageOrNil notNil ifTrue:[
        gc withForeground:self blackColor do:[
            self displayString:messageOrNil centeredAt:(self center).
        ].
    ].
    Delay waitForSeconds:0.1.
    shown ifFalse:[^ self]. 

    self fill:viewBackground.
    self invalidate

    "
     |v|

     v := View new openAndWait.
     Delay waitForSeconds:2.
     v flash:'Hello World' withColor:Color red.
     Delay waitForSeconds:2.
     v destroy
    "

    "Modified: / 16.7.1998 / 18:46:48 / cg"
!

flashReadOnly
    "flash the view and show 'Read Only' for a moment."

    self flash:(resources string:'Read Only')
!

invalidate
    "add a damage to redraw the receiver to its input event queue.
     This is preferable to calling redraw directly, in that the drawing is done by
     the view's process itself, and there is a possibilty to merge
     multiple damage rectangles into single redraws.
     However, be aware, that the redrawing may be delayed for some time,
     until the receiver's windowGroupProcess gets rescheduled."

    shown ifFalse:[
        "/ no need to add damage - will get a full-redraw anyway,
        "/ when I will be shown again.
        ^ self
    ].
    self
        invalidateDeviceRectangle:(Rectangle left:0 top:0 width:width height:height)
        repairNow:false

    "Modified: / 9.11.1998 / 21:04:16 / cg"
!

invalidate:aRectangle
    "add a damage to redraw part of the receiver, to its input event queue.
     This is preferable to calling redraw directly,
     in that the drawing is done by the view's process itself,
     and there is a possibilty to merge multiple damage rectangles into
     single redraws.
     However, be aware, that the redrawing may be delayed for some time,
     intil the receiver's windowGroupProcess gets rescheduled."

    shown ifFalse:[
        "/ no need to add damage - will get a full-redraw anyway,
        "/ when I will be shown again.
        ^ self
    ].
    self invalidate:aRectangle repairNow:false

    "Modified: / 9.11.1998 / 21:03:14 / cg"
!

invalidate:aRectangle repairNow:doRepairNow
    "add a damage to redraw part of the receiver, to its input event queue.
     and (if repairNow is true), force the receiver to repair all of its
     damaged areas right now.
     The given rectangle is in logical coordinate space."

    |r currentTransformation|

    shown ifFalse:[
	"/ no need to add damage - will get a full-redraw anyway,
	"/ when I will be shown again.
	^ self
    ].

    r := aRectangle.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	r := (currentTransformation transformPoint:r origin) corner:(currentTransformation transformPoint:r corner).
    ].
    self invalidateDeviceRectangle:r repairNow:doRepairNow

    "Modified: / 10-11-1998 / 01:55:03 / cg"
    "Modified: / 22-01-2015 / 14:23:09 / az"
!

invalidateDeviceRectangle:aRectangle repairNow:doRepairNow
    "add a damage to redraw part of the receiver, to its input event queue.
     and (if repairNow is true), force the receiver to repair all of its
     damaged areas right now.
     The given rectangle is in device coordinate space."

    shown ifFalse:[
	"/ no need to add damage - will get a full-redraw anyway,
	"/ when I will be shown again.
	^ self
    ].
    (aRectangle width <= 0 or:[aRectangle height <= 0]) ifTrue:[
	"/ no need to add damages with extent <= 0
	^ self
    ].
    self sensor addDamage:aRectangle view:self.
    doRepairNow ifTrue:[
	self repairDamage
    ]

    "Modified: / 10.11.1998 / 01:55:03 / cg"
    "Created: / 10.11.1998 / 19:02:01 / cg"
!

invalidateRepairNow:doRepair
    "add a damage to redraw all of the receiver, to its input event queue.
     and (if repairNow is true), force the receiver to repair all of its
     damaged areas right now."

    shown ifFalse:[
	"/ no need to add damage - will get a full-redraw anyway,
	"/ when I will be shown again.
	^ self
    ].
    self
	invalidateDeviceRectangle:(Rectangle left:0 top:0 width:width height:height)
	repairNow:doRepair

    "Created: 19.4.1997 / 11:58:04 / cg"
    "Modified: 19.4.1997 / 12:00:00 / cg"
!

invalidateX:x y:y width:w height:h
    "add a damage to redraw all of the receiver, to its input event queue."

    shown ifFalse:[
	"/ no need to add damage - will get a full-redraw anyway,
	"/ when I will be shown again.
	^ self
    ].
    self invalidate:(Rectangle left:x top:y width:w height:h)
!

invalidateX:x y:y width:w height:h repairNow:doRepair
    "add a damage to redraw all of the receiver, to its input event queue.
     and (if repairNow is true), force the receiver to repair all of its
     damaged areas right now."

    shown ifFalse:[
	"/ no need to add damage - will get a full-redraw anyway,
	"/ when I will be shown again.
	^ self
    ].
    self invalidate:(Rectangle left:x top:y width:w height:h) repairNow:doRepair
!

redraw
    "redraw myself completely - this is sent by redrawX:y:width:height:
     as a fallback.
     Cannot do much here - is redefined in subclasses which don't care for
     updating regions but instead update everything."

    "Modified: 29.5.1996 / 18:02:52 / cg"
!

redraw:aRectangle
    "redraw a part of the view immediately."

    self
        redrawX:(aRectangle left) y:(aRectangle top)
        width:(aRectangle width) height:(aRectangle height)

    "Modified: 19.4.1997 / 11:54:23 / cg"
!

redrawComponentsIn:aRectangle
    components notNil ifTrue:[
	components do:[:aComponent |
	    |thisFrame is|

	    thisFrame := aComponent bounds.
	    (thisFrame notNil and:[thisFrame intersects:aRectangle]) ifTrue:[
		aComponent displayOn:self
	    ]
	]
    ].
!

redrawDeviceX:x y:y width:w height:h
    "have to redraw part of the view.
     The coordinates are in device space - if there is a transformation,
     must inverse-transform back to logical coordinates. (since the view thinks
     in its coordinate space)"

    |lx ly lw lh currentTransformation|

    currentTransformation := gc transformation.
    currentTransformation isNil ifTrue:[
	lx := x.
	ly := y.
	lw := w.
	lh := h.
    ] ifFalse:[
	lx := currentTransformation applyInverseToX:x.
	ly := currentTransformation applyInverseToY:y.
	lw := currentTransformation applyInverseScaleX:w.
	lh := currentTransformation applyInverseScaleY:h.
    ].
    self redrawX:lx y:ly width:lw height:lh
!

redrawX:x y:y width:w height:h
    "redraw part of myself immediately, given logical coordinates
     (if transformation is nonNil)
     The default here is to redraw everything
     - subclasses usually redefine this, adding more intelligence"

    |area oldClip|

    shown ifFalse:[^ self].

    area := Rectangle left:x top:y width:w height:h.
    oldClip := gc clippingBoundsOrNil.
    self clippingBounds:area.

    self clearExposedAreaInRedraw ifTrue:[
	self clearRectangleX:x y:y width:w height:h.
    ].

    self renderOrRedraw.

    "/ draw them afterwards - they can be used to replace heavy-weight views.
    self redrawComponentsIn:area.
    self clippingBounds:oldClip.

    "Modified: 19.4.1997 / 11:55:08 / cg"
!

renderOrRedraw
    renderer notNil ifTrue:[
	"/ experimental feature
	thisContext isRecursive ifTrue:[self halt].
	renderer render:self on:self at:0@0
    ] ifFalse:[
	"/ redraw everything - a fallBack for lazy views.
	self redraw.
    ].
!

repairDamage
    "force the receiver to repair all of its
     damaged areas right now."

    |wg|

    shown ifTrue:[
	(wg := self windowGroup) notNil ifTrue:[
	    "/ wg processRealExposeEventsFor:self. "/ this ignores map/unmap
	    wg processExposeEventsFor:self.        "/ this handles map/unmap
	]
    ]

    "Created: / 19.4.1997 / 12:01:13 / cg"
    "Modified: / 3.12.1998 / 14:02:06 / cg"
!

showActive
    "redraw myself as active (i.e. busy).
     Nothing done here, but redefined in some classes."

    ^ self
!

showPassive
    "redraw myself as inactive (i.e. nonbusy).
     Nothing done here, but redefined in some classes."

    ^ self
! !


!SimpleView methodsFor:'scrolling'!

halfPageDown
    "scroll down half a page
    "
    self scrollDown:(self innerHeight // 2)


!

halfPageUp
    "scroll up half a page
    "
    self scrollUp:(self innerHeight // 2)

!

horizontalScrollStep
    "return the amount to scroll when stepping left/right.
     Subclasses may want to redefine this."

    ^ (device horizontalPixelPerMillimeter * 20) asInteger
!

pageDown
    self scrollDown:(self innerHeight)

    "Created: 13.9.1996 / 14:06:54 / cg"
!

pageLeft
    self scrollLeft:(self innerWidth)

    "Created: 13.9.1996 / 14:06:54 / cg"
!

pageRight
    self scrollRight:(self innerWidth)
!

pageUp
    self scrollUp:(self innerHeight)

    "Created: 13.9.1996 / 14:07:01 / cg"
!

scrollDown
    "scroll down by some amount; this is called when the scrollbars
     scroll-step down button is pressed."

    self scrollDown:(self verticalScrollStep)
!

scrollDown:nPixels
    "change origin to scroll down some pixels"

    self scrollRelative:nPixels

    "Modified: / 18-07-2010 / 09:10:47 / cg"
!

scrollHorizontalTo:aPixelOffset
    "change origin to make aPixelOffset be the left col"

    |orgY|

    orgY := self viewOrigin y.
    ^ self scrollTo:(aPixelOffset @ orgY).

    "Modified: 8.7.1996 / 15:34:54 / stefan"
!

scrollHorizontalToPercent:percent
    "scroll to a position given in percent of total"

    |wCont currentTransformation|

    wCont := self widthOfContents.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	wCont := currentTransformation applyScaleX:wCont.
    ].
    self scrollHorizontalTo:
	    ((((wCont * percent) / 100.0) + 0.5) asInteger)
!

scrollLeft
    "scroll left by some amount; this is called when the scrollbars
     scroll-step left button is pressed."

    self scrollLeft:(self horizontalScrollStep)
!

scrollLeft:nPixels
    "change origin to scroll left some pixels"

    |viewOrigin|

    nPixels ~~ 0 ifTrue:[
	viewOrigin := self viewOrigin.
	self scrollTo:((viewOrigin x - nPixels) @ viewOrigin y).
    ]

    "Modified: / 20.8.1996 / 17:35:09 / stefan"
    "Modified: / 21.5.1999 / 15:58:03 / cg"
!

scrollRelative:nPixels
    "change origin to scroll up (nPixels < 0) or down (nPixels > 0)"

    |viewOrigin|

    nPixels ~~ 0 ifTrue:[
	viewOrigin := self viewOrigin.
	self scrollTo:(viewOrigin x @ (viewOrigin y + nPixels))
    ]

    "Modified: / 20-08-1996 / 17:34:36 / stefan"
    "Created: / 18-07-2010 / 09:09:54 / cg"
!

scrollRight
    "scroll right by some amount; this is called when the scrollbars
     scroll-step right button is pressed."

    self scrollRight:(self horizontalScrollStep)
!

scrollRight:nPixels
    "change origin to scroll right some pixels"

    |viewOrigin|

    nPixels ~~ 0 ifTrue:[
	viewOrigin := self viewOrigin.
	self scrollTo:((viewOrigin x + nPixels) @ viewOrigin y)
    ]

    "Modified: / 20.8.1996 / 17:35:37 / stefan"
    "Modified: / 21.5.1999 / 15:58:08 / cg"
!

scrollToBottom
    self scrollTo:0 @ (self heightOfContents - self innerHeight)

    "Created: 13.9.1996 / 14:08:03 / cg"
    "Modified: 13.9.1996 / 14:09:32 / cg"
!

scrollToLeft
    "move viewOrigin to the left"

    self scrollHorizontalTo:0
!

scrollToPercent:originAsPercent
    "scroll to a position given in percent of total (x and y as a Point)"

    |wCont hCont percent currentTransformation|

    percent := originAsPercent asPoint.

    wCont := self widthOfContents.
    hCont := self heightOfContents.

    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	wCont := currentTransformation applyScaleX:wCont.
	hCont := currentTransformation applyScaleY:hCont.
    ].
    self scrollTo:
	    ((((wCont * percent x) / 100.0) + 0.5) asInteger) @
	    ((((hCont * percent y) / 100.0) + 0.5) asInteger)

    "Created: 5.8.1996 / 12:15:53 / stefan"
    "Modified: 5.8.1996 / 12:42:57 / stefan"
!

scrollToRight
    "move viewOrigin to the right"

    |wCont currentTransformation|

    wCont := self widthOfContents.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	wCont := currentTransformation applyScaleX:wCont.
    ].
    self scrollHorizontalTo:((wCont - self innerWidth) max:0)
!

scrollToTop
    "move viewOrigin to top"

    self scrollVerticalTo:0
!

scrollToTopLeft
    "move viewOrigin to top/left"

    self scrollTo:(0 @ 0).
!

scrollUp
    "scroll up by some amount; this is called when the scrollbars
     scroll-step up button is pressed."

    self scrollUp:(self verticalScrollStep)
!

scrollUp:nPixels
    "change origin to scroll up (towards the origin) by some pixels"

    self scrollRelative:nPixels negated

    "Modified: / 18-07-2010 / 09:10:59 / cg"
!

scrollVerticalTo:aPixelOffset
    "change origin to make aPixelOffset be the top line"

    |orgX|

    orgX := self viewOrigin x.
    ^ self scrollTo:(orgX @ aPixelOffset).

    "Modified: 8.7.1996 / 15:35:40 / stefan"
!

scrollVerticalToPercent:percent
    "scroll to a position given in percent of total"

    |hCont currentTransformation|

    hCont := self heightOfContents.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
	hCont := currentTransformation applyScaleY:hCont.
    ].
    self scrollVerticalTo:
	    ((((hCont * percent) / 100.0) + 0.5) asInteger)
!

verticalScrollStep
    "return the amount to scroll when stepping up/down (also used for mouseWheel).
     Subclasses may want to redefine this."

    ^ (device verticalPixelPerMillimeter * 20) asInteger
!

widthForScrollBetween:yStart and:yEnd
    "return the width in pixels for a scroll between yStart and yEnd
     - return full width here since we do not know how wide contents is.
     Views which only use part of their space (short lists, text) may redefine
     this method and return the number of pixels that have to be scrolled.
     On slow displays, this may make a difference; on fast ones you will probably
     not notice any difference."

    ^ (width - margin - margin)
! !

!SimpleView methodsFor:'scrolling-basic'!

scrollTo:newOrigin
    "change origin to have newOrigin be visible at the top-left.
     The argument defines the integer device coordinates of the new top-left
     point."

     ^ self scrollTo:newOrigin redraw:true

    "Modified: 15.7.1996 / 11:35:08 / stefan"
    "Modified: 13.9.1996 / 14:09:19 / cg"
!

scrollTo:newOrigin redraw:doRedraw
    "change origin to have newOrigin be visible at the top-left.
     The argument defines the integer device coordinates of the new top-left
     point."

    ^ self
	scrollTo:newOrigin
	redraw:doRedraw
	allowScrollBeyondContents:false
!

scrollTo:newOrigin redraw:doRedraw allowScrollBeyondContents:allowScrollBeyondContents
    "change origin to have newOrigin be visible at the top-left.
     The argument defines the integer device coordinates of the new top-left
     point."

    |dX   "{ Class:SmallInteger }"
     dY   "{ Class:SmallInteger }"
     orgX
     orgY
     x y iw ih
     hCont wCont fromX toX fromY toY copyWidth copyHeight
     redrawX redrawY wg currentTransformation|

    hCont := self heightOfContents.
    wCont := self widthOfContents.
    currentTransformation := gc transformation.
    currentTransformation isNil ifTrue:[
        orgY := orgX := 0
    ] ifFalse:[
        wCont := (currentTransformation applyScaleX:wCont) rounded.
        hCont := (currentTransformation applyScaleY:hCont) rounded.
        orgY := currentTransformation translation y negated.
        orgX := currentTransformation translation x negated
    ].

    iw := self innerWidth.
    ih := self innerHeight.

    "don't scroll outside of displayed area"

    x := newOrigin x.
    y := newOrigin y.

    allowScrollBeyondContents ifFalse:[
        x + iw > wCont ifTrue:[
            x := (wCont - iw) asInteger.
        ].
    ].
    x < 0 ifTrue:[
        x := 0
    ].
    allowScrollBeyondContents ifFalse:[
        y + ih > hCont ifTrue:[
            y := (hCont - ih) asInteger.
        ].
    ].
    y < 0 ifTrue:[
        y := 0.
    ].

    dX := x - orgX.
    dY := y - orgY.

    (dX == 0 and:[dY == 0]) ifTrue:[
       ^ self
    ].

    (wg := self windowGroup) notNil ifTrue:[
        wg processRealExposeEventsFor:self.
    ].

    self originWillChange.
    (shown and:[doRedraw]) ifTrue:[
        copyWidth := iw - dX abs.
        copyHeight := ih - dY abs.
        ((copyWidth > 0) and:[copyHeight > 0]) ifTrue:[
            "/ some of the currently displayed pixels
            "/ remain visible. Copy them

            dX < 0 ifTrue:[
              fromX := margin.
              toX := margin - dX.
              redrawX := margin
            ] ifFalse:[
              fromX := margin + dX.
              toX := margin.
              redrawX := margin + copyWidth.
            ].
            dY < 0 ifTrue:[
              fromY := margin.
              toY   := margin - dY.
              redrawY := margin.
            ] ifFalse:[
              fromY := margin + dY.
              toY   := margin.
              redrawY := margin + copyHeight.
            ].
            self catchExpose.
            self setViewOrigin:(x @ y).
            self
                copyFrom:self
                x:fromX y:fromY
                toX:toX   y:toY
                width:copyWidth
                height:copyHeight
                async:true.

            self setInnerClip.

            "first redraw the rectangle above/below the
             copied area (with full width)."

            copyHeight < ih ifTrue:[
                self invalidateDeviceRectangle:((margin@redrawY) extent:(iw@(ih - copyHeight))) repairNow:false.
            ].

            "second redraw the rectangle left/right of the
             copied area"

            copyWidth < iw ifTrue:[
                self invalidateDeviceRectangle:((redrawX@toY) extent:((iw-copyWidth)@copyHeight)) repairNow:false.
            ].
            self waitForExpose.
        ] ifFalse:[
            "redraw everything"

            self setViewOrigin:(x @ y).
            self invalidateDeviceRectangle:((margin@margin) extent:(iw@ih)) repairNow:false.
        ].
    ] ifFalse:[
        self setViewOrigin:(x @ y).
    ].

    self originChanged:(dX negated @ dY negated).

    "Modified: / 5.8.1996 / 11:57:09 / stefan"
    "Modified: / 1.12.1998 / 22:35:18 / cg"
! !

!SimpleView methodsFor:'startup'!

open
    "open up the view - for normal views, this is a modeless open
     (i.e. the new view comes up as independent process).
     Although #open is only to be sent to topviews (i.e. it could have been
     implemented in TopView), it is implemented here - therefore, every view
     can be opened as a topView.
     This is redefined in ModalBox, which comes up modal (i.e.
     control is under the current process, so that interaction with the
     current group is blocked while the modalBox is active).

     Notice: after the open, you cannot be sure that the view is really open and
     visible, since #open forks a new process, which does the actual window opening.
     To ensure visibility, use #openAndWait or waitUntilVisible after the open."

    ^ self openModeless

    "
     View new open
    "

    "
     (Button label:'hello') open
    "

    "
     |top|
     top := StandardSystemView new.
     top extent:200@200.
     Button label:'hello' in:top.
     top open
    "

    "
     YesNoBox new open
    "

    "Modified: 24.7.1997 / 13:26:42 / cg"
!

openAndWait
    "open up the view - wait until it is visible.
     In normal applications, you do not need to wait till the view is
     open - it should do all of its drawing itself when it gets the
     first expose event.
     However, if you want to 'manually' draw into the view (for example,
     in doIt expressions) the view must be visible (realized) before doing so.
     Use this open in those situations."

    self open.
    self waitUntilVisible.

    "does not work:

	|v|

	v := View new open.
	v displayLineFrom:0@0 to:50@50

     does work:

	|v|

	v := View new openAndWait.
	v displayLineFrom:0@0 to:50@50
    "
!

openAt:aPoint
    "open up the view modeless - positions the view"

    ^self openModelessAt:aPoint

    "
     (Button label:'hello') open

     (Button label:'hello') openAt:(100@100)
    "

    "Modified: 24.7.1997 / 13:26:23 / cg"
!

openAtCenter
    "open up the view modeless - positions the view"

    ^self openModelessAtCenter

    "
     (Button label:'hello') open

     (Button label:'hello') openAtCenter
    "

    "Modified: 24.7.1997 / 13:01:12 / cg"
!

openAutonomous
    "create and schedule a new windowgroup for me and open the view.
     The view will be handled by its own process, effectively running in
     parallel.
     Notice:
	This entry is for NON-topviews, which want to be served
	autonomous from their real topview.
	(see the fileBrowsers kill-button
	 when executing unix commands as an example)"

    |wg mainGroup|

    wg := self windowGroupClass new.
    self windowGroup:wg.

    mainGroup := WindowGroup activeGroup.
    mainGroup notNil ifTrue:[
	mainGroup := mainGroup mainGroup.
    ].

    wg isForModalSubview:true.        "/ make it handle update events for the main group
    wg startupWith:[wg mainGroup:mainGroup. self realizeInGroup].

    "/ wg startupModal:[true] forGroup:mainGroup
    "/ self realizeInGroup.

    "Modified: 20.8.1997 / 17:57:38 / cg"
!

openInGroup:aGroup
    "special open within another windowGroup.
     This allows a view to be realized in any windowgroup;
     for applications where multiple views act as a group
     (i.e. close and iconify together)."

    self windowGroup:aGroup.
    aGroup addTopView:self.

"/    self realizeKeepingGroup:true
    aGroup isForModalSubview:true.
    self realize.
!

openModal
    "create a new windowgroup, but start processing in the current process
     actually suspending event processing for the currently active group.
     Stay in the modalLoop while the view is visible.
     (i.e. control is returned to the sender when the receiver is closed)"

    self openModal:[true]

    "
     the same:
	 YesNoBox new open

	 YesNoBox new openModal

     different:
	 (Button label:'hello') open

	 (Button label:'hello') openModal
    "
!

openModal:aBlock
    "create a new windowgroup, but start processing in the current process -
     actually suspending event processing for the currently active group.
     Stay in this modal loop while aBlock evaluates to true AND the receiver is
     visible.
     (i.e. control is returned to the sender when the receiver is closed)
     This makes any interaction with the current window impossible -
     however, other views (in other windowgroups) still work."

    |activeGroup|

    activeGroup := WindowGroup activeGroup.

    "/ cg - because we raise that window, we should avoid to raise the main-non-modal view,
    "/ if a dialog is opend from another modal view (confirmation in a modal-box)

"/    mainGroup := activeGroup.
"/    mainGroup notNil ifTrue:[mainGroup := mainGroup mainGroup].

"/    masterGroup := activeGroup.
"/    [masterGroup notNil and:[masterGroup isPopUp or:[masterGroup isModal]]] whileTrue:[
"/        masterGroup := masterGroup previousGroup.
"/   ].
    ^ self openModal:aBlock inGroup:activeGroup "/ masterGroup "/ mainGroup.

    "Created: / 10.12.1995 / 14:06:45 / cg"
    "Modified: / 9.7.1998 / 01:20:57 / cg"
!

openModal:aBlock inGroup:activeWindowGroup
    "create a new windowgroup, but start processing in the current process -
     actually suspending event processing for the main group.
     Stay in this modal loop while aBlock evaluates to true AND the receiver is
     visible.
     (i.e. control is returned to the sender when the receiver is closed)
     This makes any interaction with the current window impossible -
     however, other views (in other windowgroups) still work."

    |tops mainView previousGroup mainGroup cursorChanged 
     isPopup inSystemProcess makeTransient transientFor|

    StandardSystemView cancelAutoRaise.

    isPopup := self isPopUpView.
    activeWindowGroup notNil ifTrue:[
        mainGroup := activeWindowGroup mainGroup.
	mainView := mainGroup mainView.
    ].

    "/ set the windowgroup BEFORE sending the aboutToOpen notification
    "/ (so the handler sees me with a wGroup, sensor etc).
    "/ this allows for the handler to enqueue an event,
    "/ or to add event hooks.
    (inSystemProcess := Processor activeProcessIsSystemProcess) ifTrue:[
	"
	 put myself into the modal group, let it handle events for
	 me as well. This is only a half way solution, since the view
	 is not modal at all ... however, the only situation
	 where this happens is with modal boxes popped while in a
	 modal browser. You will forgive me for that inconvenience.
	"
        windowGroup := activeWindowGroup.
        activeWindowGroup notNil ifTrue:[activeWindowGroup addTopView:self].
    ] ifFalse:[
        previousGroup := activeWindowGroup.
    ].

    windowGroup isNil ifTrue:[
	"/ create a new window group put myself into it
        windowGroup := self windowGroupClass new.
        windowGroup
            setProcess:Processor activeProcess;
				addTopView:self;
				setPreviousGroup:previousGroup.

	superView notNil ifTrue:[
	    "/
	    "/ special: this is a modal subview,
	    "/ prevent the view from reassigning its windowGroup when realized
            "/ (subviews normally place themself into the superviews group)
	    "/
	    windowGroup isForModalSubview:true.
	].
    ].

    makeTransient := true.
    transientFor := mainView.
    isPopup ifFalse:[
	"/ the following allows for knowledgable programmers to suppress dialog boxes,
	"/ or to patch common controls right before opening...
	(Dialog aboutToOpenBoxNotificationSignal raiseRequestWith:self) == #abort ifTrue:[
	    ^ self
	].
        windowGroup isNil ifTrue:[
            "/ the aboutToOpenBoxNotificationSignal handler destroyed me (although it should proceed with #abort)!!
            "/ Transcript showCR:(self class name,': box opening suppressed by aboutToOpenBoxNotificationSignal handler').
            ^ self.
        ].

	"/ the following allows for hooks to add a bell sound or other whenever a dialog opens
        device modalWindowListenersDo:[:listener | listener aboutToOpenWindow:self].

	"/ the following raises the corresponding mainview, so the dialog shows above
	"/ any currently covered view. However, be careful if being debugged, or if this dialog
	"/ is opened by an already open dialog.
        (mainView isNil or:[mainView windowGroup isInModalLoop]) ifTrue:[
            (previousGroup notNil and:[previousGroup isModal]) ifTrue:[
                transientFor := previousGroup mainView.
            ].
        ].

        transientFor notNil ifTrue:[
            (transientFor windowGroup isInModalLoop
                or:[ transientFor windowGroup isDebugged
                or:[ activeWindowGroup isDebugged
	    ]]) ifFalse:[
		self tracePoint:#cg message:'activate'.
                self debuggingCodeFor:#cg is:[ Transcript showCR:transientFor; showCR:transientFor windowGroup. ].
                transientFor activate; setForegroundWindow.
"/            ] ifTrue:[
"/                makeTransient := false.
	    ]
	].
    ].
    "/ makeTransient ifTrue:[
        transientFor notNil ifTrue:[
	    "set the transient property.
	     This is currently used for X, to tell the Window Manager
	     That this view should be always on top of the mainView"
	    self drawableId isNil ifTrue:[self create].
            device setTransient:self drawableId for:transientFor id.
        ].
    "/ ].

    self raise.

    inSystemProcess ifTrue:[
	self realize
    ] ifFalse:[
	"
	 show a stop-cursor in the suspended window groups
	"
	(mainGroup notNil and:[isPopup not]) ifTrue:[
	    mainGroup showCursor:(Cursor stop).
	    previousGroup ~~ mainGroup ifTrue:[
		previousGroup showCursor:(Cursor stop).
	    ].
	    cursorChanged := true.
	].

	"
	 go dispatch events in this new group
	 (thus current windowgroup is blocked from interaction)
	"
	AbortOperationRequest handle:[:ex |
	    "/ the dialog/popup is aborted - hide it. Care for another abort during the hide.
	    AbortOperationRequest handle:[:ex2 |
		"/ an aborted hide (possibly due to a cancelled user confirmation or similar)
		self breakPoint:#cg.
		ex exit.
	    ] do:[
		self hide.
		realized ifTrue:[
		    "/ self halt. "/ hide handled and closeRequest not wanted:
		    ex exit.
		].
	    ].
	] do:[
	    [
		[
                    windowGroup startupModal:[realized and:aBlock] forGroup:activeWindowGroup
		] ifCurtailed:[
		    self hide.
		]
	    ] ensure:[
                activeWindowGroup notNil ifTrue:[
                    activeWindowGroup graphicsDevice sync.  "that's a round trip - make sure that all drawing has been processed"
		    "/ ensure that eventListener runs here ...
                    Delay waitForMilliseconds:50.
                    activeWindowGroup processExposeEvents.

		    (self isPopUpView or:[ ReturnFocusWhenClosingModalBoxes ]) ifTrue:[
			"
			 return the input focus to the previously active group's top.
			 This helps with window managers which need an explicit click
			 on the view for the focus.
			 Only do this, if the previous group is still having the focus.
			 (i.e. no other view was opened in the meantime)
			"
                        activeWindowGroup graphicsDevice focusView isNil ifTrue:[
                            tops := activeWindowGroup topViews.
			    (tops notEmptyOrNil) ifTrue:[
				tops first getKeyboardFocus
			    ].
			].
		    ].

		    "
		     restore cursors in the changed groups
		    "
		    cursorChanged notNil ifTrue:[
			mainGroup restoreCursors.
			previousGroup ~~ mainGroup ifTrue:[
			    previousGroup restoreCursors.
			].
		    ].
		].
                Dialog boxClosedNotificationSignal raiseRequestWith:self.
	    ]
	].
    ]

    "Created: / 10-12-1995 / 14:06:14 / cg"
    "Modified: / 29-08-2013 / 16:17:10 / cg"
!

openModalAt:aPoint
    "open up the view modeless - positions the view
     (i.e. circumvents window managers positioning)"

    self origin:aPoint.
    self drawableId isNil ifTrue:[self create].
"/    device setTransient:self drawableId for:0.
    ^ self openModal

    "
     View new openModal
    "
    "
     View new openModalAt:100@100
    "

    "Created: 18.9.1995 / 23:21:42 / claus"
    "Modified: 18.9.1995 / 23:32:26 / claus"
    "Modified: 28.7.1997 / 18:52:29 / cg"
!

openModalAtCenter
    "open up the view modeless - positions the view
     (i.e. circumvents window managers positioning)"

    ^ self openModalAt:(device centerOfMonitorHavingPointer - (self extent//2)).

    "
     View new openModal
    "
    "
     View new openModalAtCenter
    "

    "Modified: / 22-03-2011 / 13:33:10 / cg"
!

openModalAtPointer
    ^ self openModalAt:(device pointerPosition)

    "
     View new openModalAtPointer
    "
!

openModeless
    "create and schedule a new windowgroup for me and open the view.
     The view will be handled by its own process, effectively running in
     parallel (i.e. control is returned to the sender immediately)."

    self openModelessAt:nil

    "
     the same:
	 (Button label:'hello') open

	 (Button label:'hello') openModeless

     different:
	 YesNoBox new open

	 YesNoBox new openModeless
    "
    "
     (almost) the same:
	 YesNoBox new open

	 YesNoBox new openModal

     different:
	 (Button label:'hello') open

	 (Button label:'hello') openModal
    "

    "Modified: 24.7.1997 / 13:17:49 / cg"
!

openModelessAt:aPoint
    "open up the view modeless - positions the view
     (i.e. tries to circumvent the window managers positioning)
     Notice: some windowManagers seem to ignore this and always
     ask the user to position the view."

    self openModelessAt:aPoint iconified:false

    "
     View new openModeless

     View new openModelessAt:100@100
    "

    "Created: 18.9.1995 / 23:21:42 / claus"
    "Modified: 24.7.1997 / 13:48:52 / cg"
!

openModelessAt:aPoint iconified:iconified
    "open up the view modeless - positions the view
     (i.e. tries to circumvent the window managers positioning)
     Notice: some windowManagers seem to ignore this and always
     ask the user to position the view."

    |newGroup|

    StandardSystemView cancelAutoRaise.
    self drawableId isNil ifTrue:[self create].

    windowGroup isNil ifTrue:[
	newGroup := true.
	windowGroup := self windowGroupClass new.
    ] ifFalse:[
	newGroup := false.
    ].

    windowGroup addTopView:self.

    "/ the following allows for hooks to be informed whenever a non-modal view opens
    device nonModalWindowListenersDo:[:listener | listener aboutToOpenWindow:self].

    newGroup ifTrue:[
	(aPoint isNil and:[iconified not]) ifTrue:[
	    windowGroup startupWith:[self realize].
	] ifFalse:[
	    windowGroup startupWith:[self realizeKeepingGroup:false at:aPoint iconified:iconified].
	].
    ] ifFalse:[
	self realizeInGroup.
    ].

    "
     StandardSystemView new openModeless

     StandardSystemView new openModelessAt:100@100

     StandardSystemView new openModelessAt:100@100 iconified:true
    "

    "Created: / 18-09-1995 / 23:21:42 / claus"
    "Modified: / 24-10-2010 / 15:22:53 / cg"
!

openModelessAtCenter
    "open up the view modeless - positions the view
     (i.e. circumvents window managers positioning)"

    ^ self openModelessAt:(device centerOfMonitorHavingPointer - (self extent//2)).

    "
     View new openModeless

     View new openModelessAtCenter
    "

    "Created: / 18-09-1995 / 23:21:42 / claus"
    "Modified: / 22-03-2011 / 13:33:13 / cg"
!

openModelessAtPointer
    "create and schedule a new windowgroup for me and open the view.
     The view will be handled by its own process, effectively running in
     parallel (i.e. control is returned to the sender immediately)."

    self openModelessAt:(device pointerPosition)

    "
     (Button label:'hello') openModelessAtPointer
    "
!

waitUntilEventsProcessed
    "Wait until all queued events for this view are processes.
     In normal applications, you do not need to call this, however,
     in tests you may need to delay assertions until all events
     are processed."

    | blocker |

    [ Screen current eventPending ] whileTrue.
    blocker := Semaphore new.
    self sensor pushAction: [ blocker signal ].  
    blocker wait.

    "Created: / 31-03-2016 / 22:33:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

waitUntilVisible
    "wait until the receiver visible.
     In normal applications, you do not need to wait till a view is
     open - it should do all of its drawing itself when it gets the
     first expose event.
     However, if you want to 'manually' draw into the view (for example,
     in doIt expressions), or subsequent views depend on some state of
     another view (which is only available once visible),
     use this to suspend the current process until the receiver is shown.
     Caveat:
	we poll here for the view to be shown - we need a semaphore
	which is raised by the view in order to do it right."

    |wg n|

    n := 0.
    [self shown] whileFalse:[
	(device notNil and:[device isOpen not]) ifTrue:[^ self].

	"/ this was added to avoid a deadlock, when called from within
	"/ the event dispatch process (as when doing foo inspect there).
	n > (10 / 0.05) ifTrue:[
	    'SimpleView [info]: View not visible after 10 seconds - will not wait any longer in waitUntilVisible' infoPrintCR.
	    ^ self
	].
	n := n + 1.
	Delay waitForMilliseconds:50.
	(wg := self windowGroup) notNil ifTrue:[
	    wg processExposeEvents.
	].
    ].

    "does not work (the view is in its opening phase,
     when we attempt to draw a line - this gives an error, since
     its internals are not yet correctly setup):

	|v|

	v := View new open.
	v displayLineFrom:0@0 to:50@50

     does work (since we wait until the view has completely finished
     its startup phase):

	|v|

	v := View new open.
	v waitUntilVisible.
	v displayLineFrom:0@0 to:50@50
    "

    "Modified: / 08-08-2010 / 14:46:34 / cg"
! !

!SimpleView methodsFor:'testing'!

hasOwnScrollbars
    "a hack for codeView2, which behaves like a TextView, but has its own
     scrollbars embedded - sigh (an extra load one).
     This allows for the UIBuilder to avoid creating an extra set around such
     a view (as is the case with TextSpec with scrollbars when using CodeView2)"

    ^ false
!

isApplicationSubView
    ^ false
!

isComboView
    ^ false
!

isPopUpList
    ^ false
! !

!SimpleView methodsFor:'user interaction & notifications'!

warn:aString
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    super warn:(resources stringWithCRs:aString)
!

warn:aString with:argument
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    super warn:(resources stringWithCRs:aString with:argument)
!

warn:aString with:arg1 with:arg2
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    super warn:(resources stringWithCRs:aString with:arg1 with:arg2)
!

warn:aString with:arg1 with:arg2 with:arg3
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    super warn:(resources stringWithCRs:aString with:arg1 with:arg2 with:arg3)
! !

!SimpleView::AboutToOpenBoxNotificationSignal class methodsFor:'documentation'!

documentation
"
    this is a hook notification, raised right before a dialog box is about to be opened.
    This allows for standard dialogs (such as confirmers, choosers or notifiers) to
    be customized by additional widgets.

    i.e. its typical use is like:
	|doNotShowHolder|

	doNotShowHolder := false asValue.
	Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
	    |box|

	    box := ex box.
	    box verticalPanel
		add:(CheckBox label:('Do not show this information in the future.')
			      model:doNotShowHolder).
	] do:[
	    Dialog information:'This is a standard information box.\(but has an additional check toggle in it)' withCRs.
	].

    Another application is to suppress dialogs, by returning #abort from the query
    (of course, in real life, the Dialog call is deeply nested below the handler and done elsewhere):

	Dialog aboutToOpenBoxNotificationSignal
	    answer:#abort
	    do:[
		Dialog information:'This box is not shown.'
	    ].

    or to automatically answer all dialogs by simulating user entering a return:

	Dialog aboutToOpenBoxNotificationSignal
	    handle:[:ex |
		ex box windowGroup sensor
		    pushEvent:
			(WindowEvent
				keyPress:#Return
				rawKey:#Return
				hasShift:false ctrl:false alt:false meta:false
				button1:false button2:false button3:false
				x:1 y:1 view:ex box).
	    ] do:[
		Transcript showCR:(Dialog confirm:'Please confirm.')
	    ].

    or an escape:

	Dialog aboutToOpenBoxNotificationSignal
	    handle:[:ex |
		ex box windowGroup sensor
		    pushEvent:
			(WindowEvent
				keyPress:#Escape
				rawKey:#Escape
				hasShift:false ctrl:false alt:false meta:false
				button1:false button2:false button3:false
				x:1 y:1 view:ex box).
	    ] do:[
		Transcript showCR:(Dialog confirm:'Please confirm.')
	    ].

    Finally, a recorder may want to keep track of which dialogs have been opened:
    (of course, again, the Dialog calls are deeply nested below the handler and done elsewhere):

	Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
	    Transcript showCR:ex box topView label
	] do:[
	    Dialog information:'box #1.'.
	    Dialog information:'box #2.'.
	    Dialog confirm:'bla'.
	].

"
! !

!SimpleView::AboutToOpenBoxNotificationSignal methodsFor:'accessing'!

application
    ^ self box application

    "Created: / 03-06-2013 / 17:33:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

box
    ^ parameter

    "Created: / 30-06-2011 / 19:24:02 / cg"
!

dialogBeingOpened
    ^ parameter
! !

!SimpleView::ViewShape methodsFor:'queries'!

isRoundShape
    ^ false
! !

!SimpleView::BoxClosedNotificationSignal class methodsFor:'documentation'!

documentation
"
    this is a hook notification, raised right after a dialog box has been closed.
    This allows for standard dialogs (such as confirmers, choosers or notifiers) to
    be wrapped by other programs.

    i.e. its typical use is like:
	Dialog boxClosedNotificationSignal handle:[:ex |
	    Transcript showCR:'box closed'
	] do:[
	    Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
		Transcript showCR:'box about to open'
	    ] do:[
		Dialog information:'This is a standard information box.'.
	    ].
	].

	Dialog boxClosedNotificationSignal handle:[:ex |
	    Transcript showCR:'box closed'
	] do:[
	    Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
		Transcript showCR:'box about to open'
	    ] do:[
		Dialog confirm:'Yes or No.'.
	    ].
	].
"
! !

!SimpleView::BoxClosedNotificationSignal methodsFor:'accessing'!

box
    ^ parameter
! !

!SimpleView::RoundViewShape methodsFor:'queries'!

isRoundShape
    ^ true


! !

!SimpleView::ArbitraryViewShape methodsFor:'accessing'!

borderShapeForm
    "return the value of the instance variable 'borderShapeForm' (automatically generated)"

    ^ borderShapeForm

    "Created: 18.9.1997 / 11:04:29 / cg"
!

borderShapeForm:something
    "set the value of the instance variable 'borderShapeForm' (automatically generated)"

    borderShapeForm := something.

    "Created: 18.9.1997 / 11:04:29 / cg"
!

viewShapeForm
    "return the value of the instance variable 'viewShapeForm' (automatically generated)"

    ^ viewShapeForm

    "Created: 18.9.1997 / 11:04:29 / cg"
!

viewShapeForm:something
    "set the value of the instance variable 'viewShapeForm' (automatically generated)"

    viewShapeForm := something.

    "Created: 18.9.1997 / 11:04:29 / cg"
! !

!SimpleView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'

!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


SimpleView initialize!
