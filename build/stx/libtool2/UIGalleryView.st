"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

NoteBookView subclass:#UIGalleryView
	instanceVariableNames:'majorKey minorKeys minorKeysHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-UIPainter'
!

View subclass:#Palette
	instanceVariableNames:'clientSpecHolder selection specification lastClickPoint
		menuSelector uiBuilder hiddenCounter showBorders
		didWarnAboutUnknownSpecs'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIGalleryView
!

DropObject subclass:#DropSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIGalleryView::Palette
!

!UIGalleryView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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
    implements a selection panel, keeping widgets which could be placed
    into other components by drag & drop or copy @ paste. The objects
    which are draged/droped must be kind of UISpecification's.
    The UISelectionPanel used by the UIPainter is implemented in this way.

    [author:]
	Claus Gittinger
	Claus Atzkern

    [see also:]
	UIPainter
	UISelectionPanel
"

!

examples
"
    opens a gallery

									[exBegin]
    |top sel|

    top := StandardSystemView new label:'gallery'; extent:500@300.
    sel := UIGalleryView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.

    sel labels:#(    'Buttons'
		     'Panels'
		     'Text'
		   ).

    sel minorKeys:#( #standardButtonToggle
		     #standardPanels
		     #standardText
		   ).

    sel majorKey:UISelectionPanel.
    top open.
									[exEnd]
"
! !

!UIGalleryView methodsFor:'accessing'!

builder
    "get the builder used to setup a window from a specification (or nil in case
     of using a new builder)
    "
  ^ canvas builder
!

builder:aBuilderOrNil
    "set the builder used to setup a window from a specification (or nil in case
     of using a new builder)
    "
    canvas builder:aBuilderOrNil
!

canvas:aCanvas
    ^ self

!

labels:listOfLabels minorKeys:listOfMinorKeys majorKey:aMajorKey
    "setup for labels, selectors and class provider
    "
    self labels:listOfLabels.
    minorKeys := listOfMinorKeys.
    majorKey  := aMajorKey.
!

majorKey
    "get the class providing the window specifications
    "
  ^ majorKey
!

majorKey:aKey
    "get the class providing the window specifications
    "
    |appl|

    appl := self application.

    appl notNil ifTrue:[
	majorKey := appl resolveName:aKey
    ] ifFalse:[
	majorKey := Smalltalk resolveName:aKey inClass:self class
    ].
    self selection:nil
!

minorKeys
    "get the list of selector keys
    "
  ^ minorKeys
!

minorKeys:aListOfSelectors
    "set the list of selectors
    "
    minorKeys := aListOfSelectors.
    self selection:nil.
!

showBorders:aBoolean
    "show borders around dragable objects"

    canvas showBorders:aBoolean.
! !

!UIGalleryView methodsFor:'accessing-colors'!

viewBackground:aColor
    canvas notNil ifTrue:[
        canvas viewBackground:aColor.
    ].
    ^ super viewBackground:aColor
! !

!UIGalleryView methodsFor:'accessing-holders'!

clientSpecHolder
    "get the holder which keeps the current selection or in case of
     no selection the specification under the cursor
    "
  ^ canvas clientSpecHolder
!

clientSpecHolder:aHolder
    "set the holder which keeps the current selection or in case of
     no selection the specification under the cursor
    "
    canvas clientSpecHolder:aHolder
!

menuSelector
    ^ canvas menuSelector
!

menuSelector:aSelector
    ^ canvas menuSelector:aSelector
!

minorKeysHolder
    "get the holder keeping the minor keys; the selectors to access
     specifications from a class associated with the majorKey.
    "
  ^ minorKeysHolder
!

minorKeysHolder:aValueHolder
    "set the holder keeping the minor keys; the selectors to access
     specifications from a class associated with the majorKey.
    "
    minorKeysHolder notNil ifTrue:[
	minorKeysHolder removeDependent:self. 
    ].

    (minorKeysHolder := aValueHolder) notNil ifTrue:[
	minorKeysHolder addDependent:self.
    ].
    self minorKeys:(minorKeysHolder value)
! !

!UIGalleryView methodsFor:'change & update'!

selectionHasChanged
    "selection changed
    "
    |specification selector selection application|

    selection := self listIndexOf:(self selection).

    minorKeysHolder notNil ifTrue:[
        minorKeys := minorKeysHolder value.
    ].
    (selection notNil and:[minorKeys size >= selection]) ifTrue:[
        selector := minorKeys at:selection.

        (majorKey respondsTo:selector) ifTrue:[
            specification := majorKey perform:selector
        ] ifFalse:[
            (application := self application) notNil ifTrue:[
                MessageNotUnderstood handle:[:ex|
                    (application class respondsTo:selector) ifTrue:[
                        specification := application class perform:selector
                    ]
                ] do:[
                    specification := application aspectFor:selector
                ]
            ]
        ]
    ].
"/    self withWaitCursorDo:[
        [
            canvas specification:specification.
        ] on:NotFoundError do:[:ex|
            Transcript showCR:ex description.
            ex proceed.
        ]
"/    ]
!

update
    self selectionHasChanged.
!

update:something with:aParameter from:changedObject
    "one of my models changed its value
    "
    changedObject == minorKeysHolder ifTrue:[
        ^ self minorKeys:( minorKeysHolder value)
    ].
    super update:something with:aParameter from:changedObject.

! !

!UIGalleryView methodsFor:'initialization & release'!

initialize
    "setup default attributes
    "
    canvas := Palette in:self.

    super initialize.

    self action:[:something| self selectionHasChanged ].
!

release
    minorKeysHolder notNil ifTrue:[
        minorKeysHolder removeDependent:self. 
        minorKeysHolder := nil.
    ].
    super release.
! !

!UIGalleryView::Palette class methodsFor:'documentation'!

documentation
"
    I am the palette of a gallery. Most of what I do is to allow dragging of a widget out
    of myself and to care for the drawing of the selection.
    The arrangement into multiple pages is done by my container, which holds me
    in a subcanvas.
"
! !

!UIGalleryView::Palette methodsFor:'accessing'!

builder
    "get the builder used to setup a window from a specification (or nil in case
     of using a new builder)
    "
  ^ uiBuilder
!

builder:something
    "set the builder used to setup a window from a specification (or nil in case
     of using a new builder)
    "
    uiBuilder := something.
!

clientSpecHolder
    "get the holder which keeps the current selection or in case of
     no selection the specification under the cursor
    "
    ^ clientSpecHolder
!

clientSpecHolder:aHolder
    "set the holder which keeps the current selection or in case of
     no selection the specification under the cursor
    "
    |spec|

    spec := clientSpecHolder value.

    aHolder notNil ifTrue:[ clientSpecHolder := aHolder ]
                  ifFalse:[ clientSpecHolder := nil asValue ].

    clientSpecHolder value:spec.
!

menuSelector
    "return the value of the instance variable 'menuSelector' (automatically generated)"

    ^ menuSelector
!

menuSelector:something
    "set the value of the instance variable 'menuSelector' (automatically generated)"

    menuSelector := something.
!

showBorders:aBoolean
    showBorders := aBoolean.
!

specification
    "get current specification
    "
    ^ specification
!

specification:aSpecOrSpecArray
    "set a new specification"

    |builder newSpec|

    self selection:nil.
    self destroySubViews.

    specification := nil.
    aSpecOrSpecArray isNil ifTrue:[^ self].

    "/ only warn once - otherwise, its annoying
    MissingClassInLiteralArrayErrorSignal handle:[:ex |
        didWarnAboutUnknownSpecs == true ifFalse:[
            Dialog warn:(ex description,'\\(Will not warn again - please check for unloaded classes/packages)' withCRs).
        ].
        didWarnAboutUnknownSpecs := true.
        ex proceed.
    ] do:[
        newSpec := UISpecification from:aSpecOrSpecArray.
    ].
    newSpec isNil ifTrue:[^ self].
    (newSpec respondsTo:#'buildViewFor:in:') ifFalse:[^ self].
    specification := newSpec.

    (builder := uiBuilder) isNil ifTrue:[
        builder := UIBuilder new isEditing:true.
        builder showDefaults:true.
        builder application:self application. "/ for resources like images
    ].

    specification buildViewFor:builder in:self.

    "/ components notEmptyOrNil ifTrue:[ self halt ].
    subViews size ~~ 0 ifTrue:[
        showBorders ifTrue:[
            subViews do:[:v|
                (self findSpecFor:v) notNil ifTrue:[
                    v borderWidth:1
                ].
            ].
        ].
        realized ifTrue:[ self realizeAllSubViews ].
    ].
! !

!UIGalleryView::Palette methodsFor:'building'!

recursiveBuildSpecFromSpecPrototype:aSpec
    "build spec out of spec prototype"

    |spec comp coll|

    (aSpec notNil and:[aSpec canUIDrag]) ifFalse:[
        ^ nil
    ].

    spec := aSpec copy.
    (aSpec class supportsSubComponents and:[aSpec component notNil]) ifFalse:[
        ^ spec
    ].
    comp := aSpec component.
    spec component:nil.

    comp canUIDrag ifFalse:[
        ^ spec
    ].
    coll := OrderedCollection new.

    comp do:[:anEntry|
        |spc|

        (spc := self recursiveBuildSpecFromSpecPrototype:anEntry) notNil ifTrue:[
            coll add:spc
        ]
    ].
    coll isEmpty ifTrue:[
        ^ spec
    ].
    comp := comp copy.
    comp collection:coll.
    spec component:comp.
    ^ spec
! !

!UIGalleryView::Palette methodsFor:'drag & drop'!

startDragFrom:evView
    "start drag at lastClickPoint"

    |spec dragObj offset clickPos dragAndDropManager|

    clickPos := lastClickPoint.
    clickPos isNil ifTrue:[^ self].
    lastClickPoint := nil.

    spec := clientSpecHolder value.
    spec isNil ifTrue:[^ self].

    self withSelectionHiddenDo:[
        spec := self recursiveBuildSpecFromSpecPrototype:spec.
        spec name:nil.

        dragObj := DropSpec for:selection specification:spec.
        offset  := clickPos - selection origin.
    ].

    dragAndDropManager := DragAndDropManager new.
    dragAndDropManager giveFocusToTargetWidget:false.

    dragAndDropManager 
        startDrag:dragObj
        from:self
        offset:offset
        atEnd:nil
        display:nil.
! !

!UIGalleryView::Palette methodsFor:'event handling'!

processEvent:anEvent
    "filter keyboard events.
     Return true, if I have eaten the event"

    |evView p|

    evView := anEvent view.
    evView isNil ifTrue:[ ^ false ].
    (evView ~~ self and:[ (evView isComponentOf:self) not ]) ifTrue:[ ^ false ].

    (anEvent isButtonPressEvent or:[anEvent isButtonReleaseEvent])ifTrue:[
        lastClickPoint := nil.
    ].
    anEvent isButtonEvent ifFalse:[
        anEvent isInputEvent ifTrue:[^ true].

        anEvent isDamage ifTrue:[ self redrawSelection ].
        ^ false
    ].

    anEvent isButtonReleaseEvent ifTrue:[ ^ true ].

    anEvent isButtonMotionEvent ifTrue:[
        (lastClickPoint notNil and:[anEvent state ~~ 0]) ifTrue:[
            p := Point x:(anEvent x) y:(anEvent y).
            p := device translatePoint:p fromView:evView toView:self.

            (lastClickPoint dist:p) > 20.0 ifTrue:[
                self startDragFrom:evView.
                lastClickPoint := nil.
            ]
        ].
        ^ true
    ].

    anEvent isButtonPressEvent ifTrue:[
        |button application|

        button := anEvent button.

        (button == 1 or:[button == #select]) ifTrue:[
            p := Point x:(anEvent x) y:(anEvent y).
            p := device translatePoint:p fromView:evView toView:self.

            self selection:(self findObjectAt:p).

            selection notNil ifTrue:[
                lastClickPoint := p.
            ]
        ] ifFalse:[
            (menuSelector notNil and:[(application := self application) notNil]) ifTrue:[
                MessageNotUnderstood catch:[
                    application aspectFor:menuSelector
                ]
            ]
        ].
        ^ true
    ].

    ^ true
! !

!UIGalleryView::Palette methodsFor:'focus handling'!

subviewsInFocusOrder
    "returns none views - focus not handled within buildin canvas"

    ^ #()
! !

!UIGalleryView::Palette methodsFor:'initialization'!

destroy
    |winGrp|

    winGrp := self windowGroup.
    winGrp notNil ifTrue:[
        winGrp removePreEventHook:self.
    ].
    super destroy.
!

initialize
    super initialize.
    clientSpecHolder := nil asValue.
    hiddenCounter := 0.
    showBorders := true.
!

realize
    |winGrp|

    super realize.
    winGrp := self windowGroup.
    winGrp notNil ifTrue:[
        winGrp addPreEventHook:self.
   ].
! !

!UIGalleryView::Palette methodsFor:'searching'!

findObjectAt:aPoint
    |seeIfWidgetIsHit p x y|

    seeIfWidgetIsHit := 
        [:v |
            p := device translatePoint:aPoint fromView:self toView:v.
            x := p x.
            y := p y.

            (     x >= 0 and:[x <= v width
             and:[y >= 0 and:[y <= v height
             and:[(self findSpecFor:v) notNil]]]]
            ) ifTrue:[
                ^ v
            ]
        ].

    subViews notNil ifTrue:[ subViews do:seeIfWidgetIsHit ].
    components notNil ifTrue:[ components do:seeIfWidgetIsHit ].
    ^ nil
!

findSpecFor:aWidget
    "returns the spec which is assigned to aWidget or nil"

    |name|

    aWidget notNil ifTrue:[
        name := aWidget name.

        specification do:[:aSpec|
            (aSpec notNil and:[aSpec name = name]) ifTrue:[
                aSpec canUIDrag ifFalse:[^ nil ].
                ^ aSpec
            ]
        ]
    ].
    ^ nil

    "Modified: / 18.5.1999 / 14:47:25 / cg"
! !

!UIGalleryView::Palette methodsFor:'selection'!

handlesOf:aComponent do:aOneArgBlock
    "evaluate the block on each handle; the argument to the block is a rectangle"

    |ext|

    ext := 8@8.

    aComponent notNil ifTrue:[
        aOneArgBlock value:(aComponent origin       - (3@3) extent:ext).
        aOneArgBlock value:(aComponent corner       - (2@2) extent:ext).
        aOneArgBlock value:(aComponent topRight     - (2@3) extent:ext).
        aOneArgBlock value:(aComponent bottomLeft   - (3@2) extent:ext).
        aOneArgBlock value:(aComponent leftCenter rounded   - (3@0) extent:ext).
        aOneArgBlock value:(aComponent rightCenter rounded  - (2@0) extent:ext).
        aOneArgBlock value:(aComponent topCenter rounded    - (0@3) extent:ext).
        aOneArgBlock value:(aComponent bottomCenter rounded - (0@2) extent:ext).
    ]
!

redrawSelection
    "redraw all items selected"

    (shown and:[selection notNil and:[hiddenCounter == 0]]) ifTrue:[
        self clippedByChildren:false.

        self handlesOf:selection do:[:aRectangle|
            self paint:self blackColor.
            self fillRectangle:aRectangle.

            self paint:self whiteColor.
            self displayRectangle:(aRectangle insetBy:0).
        ].
        self clippedByChildren:true.
    ].
!

selection:aView
    "selection changed"

    |spec|

    selection == aView ifTrue:[^ self].

    self withSelectionHiddenDo:[
        spec := self findSpecFor:aView.

        selection := (spec isNil) ifTrue:[nil] ifFalse:[aView].
        clientSpecHolder value:spec.
    ].
!

withSelectionHiddenDo:aOneArgBlock
    [ 
        |r forceExpose|
        
        hiddenCounter :=  hiddenCounter + 1.
        hiddenCounter == 1 ifTrue:[
            (shown and:[selection notNil]) ifTrue:[
                self clippedByChildren:false.

                self handlesOf:selection do:[:aRectangle|
                    self clearRectangle:aRectangle.
                    self invalidateRectangle:aRectangle repairNow:false.
                ].
                self clippedByChildren:true.

                r := selection bounds.

                forceExpose := 
                    [:sv|
                        |absOrg absFrame|

                        (sv bounds intersects:r) ifTrue:[   
                            sv isView ifTrue:[
                                sv borderColor:(self whiteColor).           "/ kludge to force a redraw
                                sv borderColor:(self blackColor).

                                sv withAllSubViewsDo:[:v|
                                    v realized ifTrue:[
                                        v fill:v viewBackground.
                                        v exposeX:0 y:0 width:v width height:v height.
                                    ]
                                ]
                            ] ifFalse:[
                                sv invalidate.
                            ].
                        ]
                    ].

                (subViews ? #()) do:forceExpose.
                (components ? #()) do:forceExpose.
            ].
        ].
        self repairDamage.  "/ ensure that any outstanding clear/redraw of the unselect are done before
        aOneArgBlock value.
    ] ensure:[
        self repairDamage.  "/ ensure that any outstanding clear/redraw of the unselect are done before

        hiddenCounter := hiddenCounter - 1.
        self redrawSelection.
    ].
! !

!UIGalleryView::Palette::DropSpec class methodsFor:'instance creation'!

for:aWidget specification:aSpec
    "create drop object for a widget derived from a specification"

    |point extent rootView widgetsDevice inst displayObject view|

    widgetsDevice   := aWidget device.
    rootView := widgetsDevice rootView.
    extent   := aWidget extent.
    aWidget isView ifTrue:[
        view := aWidget.
        point := widgetsDevice translatePoint:0@0 fromView:aWidget toView:rootView.
    ] ifFalse:[
        view := aWidget container.
        point := widgetsDevice translatePoint:(aWidget origin) fromView:view toView:rootView.
    ].
    (point x > 0 and:[point y > 0]) ifTrue:[
        point := point + extent.
        (point x < rootView width and:[point y < rootView height]) ifTrue:[
            aWidget topView raise.
            widgetsDevice flush.
            aWidget invalidate.
            aWidget windowGroup processExposeEvents.
            displayObject := Image fromView:aWidget grab:false.
        ]
    ].
    displayObject isNil ifTrue:[
        displayObject := Form extent:extent depth:1.
        displayObject colorMap:(Array with:Color white with:Color black).
        displayObject fill:(Color colorId:0).
        displayObject paint:(Color colorId:1).
        displayObject displayRectangleX:0 y:0 width:aWidget extent x height:aWidget extent y.
    ].
    aSpec class == UISubSpecification ifTrue:[
        aSpec layout:(LayoutOrigin fromPoint:0@0)
    ].

    inst := self new.
    inst displayObject:displayObject.
    inst theObject:aSpec.
    ^ inst.

    "Modified: / 10.10.2001 / 14:03:00 / cg"
! !

!UIGalleryView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

