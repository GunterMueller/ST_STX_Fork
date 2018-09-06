"
 COPYRIGHT (c) 1995 by Claus Gittinger / eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

UIObjectView subclass:#UIPainterView
	instanceVariableNames:'treeView listHolder superclassName className methodName
		categoryName handleColorBlack handleColorWhite handleMasterColor
		sketchPainter listOfAspectsHolder'
	classVariableNames:'HandCursor RedefineAspectMethods AspectsAsInstances'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

Object subclass:#ViewProperty
	instanceVariableNames:'view spec identifier'
	classVariableNames:'Identifier'
	poolDictionaries:''
	privateIn:UIPainterView
!

!UIPainterView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger / eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    buildIn view used by the UIPainter; from this view, the layout of the
    new application derives from.

    [see also:]
	UIBuilder
	UIObjectView

    [author:]
	Claus Gittinger
	Claus Atzkern
"
! !

!UIPainterView class methodsFor:'initialization'!

initialize

    AspectsAsInstances := true. "/ false.
    RedefineAspectMethods := false.

    "Created: / 22.9.1999 / 12:32:31 / stefan"
! !

!UIPainterView class methodsFor:'code generation mode'!

generateAspectsAsInstanceVariables
    "if on, aspects are held as instance variables;
     if off (the default), they are kept in the bindings dictionary."

    ^ AspectsAsInstances

    "Created: / 29.7.1998 / 11:21:38 / cg"
    "Modified: / 29.7.1998 / 11:22:01 / cg"
!

generateAspectsAsInstanceVariables:aBoolean
    "if on, aspects are held as instance variables;
     if off (the default), they are kept in the bindings dictionary."

    AspectsAsInstances := aBoolean

    "Created: / 29.7.1998 / 11:21:26 / cg"
    "Modified: / 29.7.1998 / 11:22:11 / cg"
!

generateCommentedCode
    "comments in generated aspect methods; yes or no."

    ^ UserPreferences current generateComments
    and:[ UserPreferences current generateCommentsForAspectMethods ]
!

generateCommentedCode:aBoolean
    "comments in generated aspect methods; yes or no."

    UserPreferences current generateComments ifFalse:[
        aBoolean ifTrue:[
            UserPreferences current generateComments:true
        ].
    ].

    UserPreferences current 
        generateCommentsForAspectMethods:aBoolean.
!

redefineAspectMethods
    "redefine methods yes or no. 
     If a method is defined in super class should the message be reinstalled ?"

    ^ RedefineAspectMethods

    "Modified: / 22.9.1999 / 12:33:03 / stefan"
!

redefineAspectMethods:aBoolean
    "redefine methods yes or no.
     If a method is defined in super class should the message be reinstalled ?"

    RedefineAspectMethods := aBoolean
! !

!UIPainterView class methodsFor:'defaults'!

defaultMenuMessage
    "This message is the default yo be sent to the menuHolder to get a menu
    "
    ^ #showMiddleButtonMenu


! !

!UIPainterView methodsFor:'accessing'!

application
    ^ nil

    "Modified: 6.9.1995 / 00:46:44 / claus"
!

applicationName
    ^ self className
!

applicationName:aName
    self className:aName
!

class:aClass superclassName:aSuperclassName selector:aSelector
    self assert:(aClass isBehavior).
    className      := aClass name.
    superclassName := aSuperclassName.
    methodName     := aSelector.
!

className
    ^ className
!

className:aName
    self assert:(aName isString).
    className := aName
!

className:aClassName superclassName:aSuperclassName selector:aSelector
    self assert:(aClassName isString).
    className      := aClassName.
    superclassName := aSuperclassName.
    methodName     := aSelector.
!

listOfAspectsHolder:something
    listOfAspectsHolder := something.
!

methodName
    ^ methodName
!

methodName:aName
    methodName := aName
!

selectNames:aStringOrCollection
    |prop coll s n newSel|

    (aStringOrCollection size == 0) ifTrue:[
	newSel := nil.
    ] ifFalse:[
	(s := aStringOrCollection) isString ifFalse:[
	    s size == 1 ifTrue:[
		s := s first
	    ] ifFalse:[
		coll := OrderedCollection new.

		s do:[:aName|
		    (prop := self propertyOfName:aName) notNil ifTrue:[
			coll add:(prop view)
		    ]
		].
		(n := coll size) == 1 ifTrue:[
		    newSel := coll at:1
		] ifFalse:[
		    n == 0 ifTrue:[
			newSel := nil
		    ] ifFalse:[
			newSel := coll
		    ]
		].
		^ self select:newSel.
	    ]
	].

	prop := self propertyOfName:s.
	prop isNil ifTrue:[
	    newSel := nil
	] ifFalse:[
	    newSel := prop view
	].
    ].

    ^ self select:newSel
! !

!UIPainterView methodsFor:'change & update'!

layoutChanged
    treeView notNil ifTrue:[
	treeView layoutChanged
    ]
! !

!UIPainterView methodsFor:'copy & cut & paste'!

changeSelectionAfterPasteOf:sel
    sel notNil ifTrue:[
        self select:sel.
    ].
!

commonContainerOf:someComponents
    |container|

    container := someComponents first container.
    [container notNil
     and:[ (someComponents conform:[:eachComponent | eachComponent isComponentOf:container]) not]]
	whileTrue:[
	container := container container.
    ].
    ^ container
!

copySelection
    "copy the selection into the cut & paste-buffer"

    |specs coll|

    coll := self minClosedViewSetFor:(self selection).

    coll notNil ifTrue:[
"/        self select:nil.
        specs := coll collect:[:eachView | self fullSpecWithAbsolutePositionFor:eachView].
        self setClipboardObject:specs.
"/        treeView selection: sel
    ].
!

deleteSelection
    "delete the selection buffered"

    self deleteSelectionBuffered: true
!

deleteSelectionBuffered:buffered
    "cut the selection. If buffered is true, place it into the cut&paste-buffer"

    |specs viewsToRemove newSelection firstView|

    treeView askForSelectionChangeAllowed ifFalse:[^ self].

    viewsToRemove := self minClosedViewSetFor:(self selection).
    viewsToRemove isEmptyOrNil ifTrue:[ ^ self].

    buffered ifTrue:[
        specs := viewsToRemove collect:[:aView| self fullSpecWithAbsolutePositionFor:aView ].
        self setClipboardObject:specs
    ].
    firstView    := viewsToRemove first.
    newSelection := self findContainerOfView:firstView.

    newSelection isNil ifTrue:[
        newSelection := self.
    ] ifFalse:[
        viewsToRemove size == 1 ifTrue:[
            |subviews index|

            "/ newSelection components notEmptyOrNil ifTrue:[ self halt ].
            subviews := newSelection subViews.

            subviews size > 1 ifTrue:[
                index := subviews findFirst:[:eachView| eachView isSameOrComponentOf:firstView ].
                index > 0 ifTrue:[
                    newSelection := subviews
                            at:(index + 1)
                            ifAbsent:[subviews at:index -1].
                ].
            ].
        ].
    ].

    self withSelectionHiddenDo:[
        self select:newSelection.

        treeView canvasEventsDisabledDo:[
            self withinTransaction:#cut objects:viewsToRemove do:[
                viewsToRemove reverseDo:[:aView|
                    self createUndoRemove:aView.
                    self remove:aView.
                ]
            ].
        ].
        self windowGroup processRealExposeEvents.
    ].
!

deleteTotalSelection
    "delete the selection"

    self deleteSelectionBuffered: false
!

getSelectedViewsAndSpecs
    "return an array filed with selected views and corresponding specs.
     Nil if there is none."

    |specs coll sel|

    sel := treeView selection.

    coll := self minClosedViewSetFor:(self selection).

    coll isNil ifTrue:[^ nil].

    specs := coll collect:[:aView| self fullSpecFor:aView ].
    ^ Array with: coll with: specs
!

pasteBuffer
    "add the objects in the paste-buffer to the object view; 
     don't change the layout if more than a single item has been selected"

    |sel clipboard|

    self enabled ifFalse:[
        Dialog warn:'Operation currently disabled (In geometry test mode)'.
        ^ self
    ]. 

    clipboard := self getClipboardObject.
    clipboard isString ifTrue:[
        Dialog warn:'can only paste widgets here'.
    ] ifFalse:[
        sel := self pasteSpecifications:clipboard keepLayout:true "(clipboard size > 1)".
        self changeSelectionAfterPasteOf:sel.
    ].
!

pasteKeepingPosition
    "add the objects in the paste-buffer to the object view;
     translate the layout as appropriate, to position the component
     at the same absolute position (relative to topView) as before"

    |sel|

    sel := self
        pasteSpecifications:(self getClipboardObject)
        keepLayout:true
        keepPosition:true
        at:#keep.

    self changeSelectionAfterPasteOf:sel.
!

pasteSpecifications:aSpecificationOrList into:aContainerOrNil beforeIndex:anIndexOrNil keepLayout:keepLayout keepPosition:keepPosition at:aPointOrNilOrKeep
    "add the specs to the object view; 
     if given a collection of specs, returns a list of pasted widgets;
     if given a single spec, returns that view (sigh - a stupid bw-compatibility kludge)"

    |sensor specsToPaste pasteOffset builder newSel 
     bounds containerToPasteInto pastePoint beforeIndex count|

    treeView askForSelectionChangeAllowed ifFalse:[^ nil].

    sensor := self window sensor.

    containerToPasteInto := aContainerOrNil.

    (aPointOrNilOrKeep == #keep
    or:[ sensor shiftDown
    or:[ sensor ctrlDown ]]) ifTrue:[
        "/ paste into the selection
        containerToPasteInto isNil ifTrue:[
            containerToPasteInto := self singleSelection.
        ].
    ] ifFalse:[
        "/ ignore the selection and paste where we drop!!
        pastePoint := aPointOrNilOrKeep.
        pastePoint isNil ifTrue:[
            pastePoint := device 
                                translatePoint:(sensor mousePoint)
                                fromView:nil
                                toView:self.
        ].
        containerToPasteInto isNil ifTrue:[
            containerToPasteInto := self findObjectAt:pastePoint.
        ].
    ].

    containerToPasteInto isNil ifTrue:[
        self selection size > 0 ifTrue:[
            containerToPasteInto := self commonContainerOf:self selection
        ] ifFalse:[
            containerToPasteInto := self
        ].
"/        self selection:containerToPasteInto.
    ].

    "/ search up parent list for something we can paste into
    [containerToPasteInto notNil and:[(self canPasteInto:containerToPasteInto) not]] whileTrue:[
        containerToPasteInto == self ifTrue:[
            containerToPasteInto := nil
        ] ifFalse:[
            containerToPasteInto := containerToPasteInto container.
        ].
    ].
    containerToPasteInto isNil ifTrue:[
        containerToPasteInto := self
    ].

    (self canPaste:aSpecificationOrList into:containerToPasteInto)
    ifFalse:[
        self enabled ifTrue:[
            Dialog warn:'Cannot paste into selected component (not a container ?)'.
        ] ifFalse:[
            Dialog warn:'Operation currently disabled (In geometry test mode)'.
        ]. 
        ^ nil
    ].

    self hideSelection.

    aSpecificationOrList isCollection ifTrue:[
        specsToPaste := aSpecificationOrList
    ] ifFalse:[
        specsToPaste := Array with:aSpecificationOrList
    ].
"/    self setClipboardObject:nil.

    newSel  := OrderedCollection new.
    builder := UIBuilder new isEditing:true.

    className notNil ifTrue:[
        builder applicationClass:(self resolveName:className)
    ].
    bounds := Rectangle origin:0@0 extent:(containerToPasteInto bounds extent).

    pasteOffset := 0.

    (anIndexOrNil notNil and:[anIndexOrNil > 0]) ifTrue:[
        beforeIndex := anIndexOrNil.
    ].
    specsToPaste do:[:eachSpec|
        |view newOrigin uiPainterAttributes thisAbsOrigin|

        uiPainterAttributes := eachSpec otherAttributeAt:#uiPainterAttributes.
        eachSpec otherAttributeAt:#uiPainterAttributes put:nil.

        view := self addSpec:eachSpec builder:builder in:containerToPasteInto beforeIndex:beforeIndex.
        beforeIndex notNil ifTrue:[
            beforeIndex := beforeIndex + 1
        ].
        (keepLayout or:[eachSpec keepUILayout]) ifTrue:[
            eachSpec layout isAssociation ifTrue:[
                eachSpec layout key == #extent ifTrue:[
                    view pixelExtent:eachSpec layout value
                ] ifFalse:[
                    "/ self halt.
                    view geometryLayout:eachSpec layout value
                ].
            ] ifFalse:[    
                view geometryLayout:eachSpec layout.
            ]
        ] ifFalse:[
            (keepPosition and:[ uiPainterAttributes notNil ]) ifTrue:[
                aPointOrNilOrKeep == #keep ifTrue:[
                    newOrigin := uiPainterAttributes at:#origin.
                ] ifFalse:[
                    thisAbsOrigin := uiPainterAttributes at:#absOrigin.

                    newOrigin := device 
                                        translatePoint:thisAbsOrigin
                                        fromView:self
                                        toView:containerToPasteInto.
                ].
            ] ifFalse:[
                pastePoint isNil ifTrue:[ pastePoint := 0@0 ].
                newOrigin := device 
                                    translatePoint:pastePoint
                                    fromView:self
                                    toView:containerToPasteInto.
            ].

            (bounds containsPoint:newOrigin) ifFalse:[
                newOrigin := pasteOffset asPoint.
                pasteOffset := pasteOffset + 4.
            ].
            newOrigin notNil ifTrue:[
                self moveObject:view to:newOrigin.
            ].
        ].
        view realized ifFalse:[
            view realize.
        ].
        newSel add:view.
    ].

    self 
        withinTransaction:#paste 
        objects:newSel 
        do:[
            undoHistory 
                addUndoSelector:#undoCreate:
                withArgs:(newSel collect:[:v| (self propertyOfView:v) identifier]).
            self undoHistoryChanged.
        ].

    self realizeAllSubViews.
    "/ newSel do:[:v| v raise].
    self elementChangedSize:containerToPasteInto.

    "/ nil wg if embedded in a browser
    self windowGroup notNil ifTrue:[
        "/ because the new-created view will destroy the handles, when it redraws itself,
        "/ give it a chance to do so, before we return. (bail out after half a second, in case of trouble)
        count := 0.
        [ (newSel conform:[:v | v shown]) or:[count > 50] ] whileFalse:[
            self windowGroup repairDamage.
            Delay waitForSeconds:0.01.
            count := count+1.
        ].
        Delay waitForSeconds:0.01.
        self windowGroup repairDamage.
    ].

    newSel size == 1 ifTrue:[newSel := newSel at:1].
    ^ newSel

    "Modified: / 03-11-2010 / 07:20:06 / cg"
!

pasteSpecifications:aSpecificationOrList into:aContainerOrNil keepLayout:keepLayout keepPosition:keepPosition at:aPointOrNilOrKeep 
    "add the specs to the object view; returns list of pasted widgets"
    
    ^ self 
        pasteSpecifications:aSpecificationOrList
        into:aContainerOrNil
        beforeIndex:nil
        keepLayout:keepLayout
        keepPosition:keepPosition
        at:aPointOrNilOrKeep
!

pasteSpecifications:aSpecificationOrList keepLayout:keepLayout
    "add the specs to the object view; returns list of pasted widgets"

    ^ self
        pasteSpecifications:aSpecificationOrList
        keepLayout:keepLayout
        keepPosition:true
        at:#keep "/ nil

    "Modified: 11.8.1997 / 01:00:35 / cg"
!

pasteSpecifications:aSpecificationOrList keepLayout:keepLayout at:aPointOrNil
    "add the specs to the object view; returns list of pasted widgets"

    ^ self
        pasteSpecifications:aSpecificationOrList
        keepLayout:keepLayout
        keepPosition:true
        at:aPointOrNil
!

pasteSpecifications:aSpecificationOrList keepLayout:keepLayout keepPosition:keepPosition at:aPointOrNilOrKeep
    "add the specs to the object view; returns list of pasted widgets"

    ^ self pasteSpecifications:aSpecificationOrList
        into:nil
        beforeIndex:nil
        keepLayout:keepLayout
        keepPosition:keepPosition
        at:aPointOrNilOrKeep
!

pasteWithLayout
    "add the objects in the paste-buffer to the object view - keep the old layout"

    |sel|

    sel := self 
            pasteSpecifications:(self getClipboardObject)
            keepLayout:true
            keepPosition:true
            at:#keep.
    self changeSelectionAfterPasteOf:sel.
!

pasteWithoutLayout
    "add the objects in the paste-buffer to the object view - do not keep the old layout"

    |sel|

    sel := self 
            pasteSpecifications:(self getClipboardObject)
            keepLayout:false
            keepPosition:true
            at:#keep.
    self changeSelectionAfterPasteOf:sel.
!

replaceSelectionBy:aNewSpec
    "replace the selected widget by another one."

    |oldSelection treeModel newView oldView container specs index|

    (self singleSelection notNil and:[treeView askForSelectionChangeAllowed]) ifFalse:[
        ^ self
    ].
    
    treeModel    := treeView model.
    oldSelection := treeModel selectedNodes at:1 ifAbsent: nil.
    oldSelection isNil ifTrue:[^ self].

    oldView := oldSelection contents view.

    (oldSelection hasChildren and:[aNewSpec class supportsSubComponents]) ifTrue:[
        specs := 
            oldSelection children collect:[:each|
                self fullSpecWithAbsolutePositionFor:(each contents view)
            ].
    ].

    aNewSpec
        otherAttributeAt:#uiPainterAttributes 
        put:(Dictionary new
                at:#origin put:oldView origin;
                at:#extent put:oldView extent;
                at:#absOrigin put:(oldView originRelativeTo:self);
                yourself).

    index := oldSelection parent children identityIndexOf:oldSelection.
    container := self singleSelection container.
    
    self withinTransaction:#replaceBy objects:(Array with:oldView) do:[
        self withSelectionHiddenDo:[
            newView := self 
                    pasteSpecifications:(Array with:aNewSpec)
                    into:container
                    beforeIndex:index
                    keepLayout:true
                    keepPosition:true
                    at:#keep.

            self deleteSelectionBuffered:false.

            specs size > 0 ifTrue:[
                self pasteSpecifications:specs 
                            into:newView
                            keepLayout:(aNewSpec class canResizeSubComponents)
                            keepPosition:(aNewSpec class isLayoutContainer not)
                            at:index.
            ].
            self select:newView.
       ].
    ].
    ^ newView.
! !

!UIPainterView methodsFor:'drag & drop'!

canDrop:aDropContext
    ^ self canDropObjects:aDropContext dropObjects

    "Created: / 13-10-2006 / 17:46:11 / cg"
!

canDropObjects:aCollectionOfDropObjects
    "returns true if something can be dropped"

    ^ (true "aCollectionOfDropObjects size == 1" 
    and:[ self enabled 
    and:[ true "self numberOfSelections <= 1"
    and:[ aCollectionOfDropObjects conform:[:each| each theObject isKindOf:UISpecification]
              ]]])

    "Created: / 13-10-2006 / 16:09:24 / cg"
!

canPaste
    "returns true if there is something which can be pasted in the clipboard"

    ^ self canPaste:(self getClipboardObject)
!

canPaste:something
    "returns true if something could be pasted"

    ^ self canPaste:something into:(self singleSelection)
!

canPaste:something into:containerToPasteInto
    "returns true if something could be pasted"

    (self enabled) ifFalse:[
        ^ false
    ].
    something isCollection ifTrue:[
        something isEmpty ifTrue:[ ^ false].
        ^ something conform:[:el | (self canPaste:el into:containerToPasteInto)]
    ].

    (something isKindOf:UISpecification) ifFalse:[
        ^ false
    ].

    ^ self canPasteInto:containerToPasteInto
!

canPasteInto:aView
    "return true, if I can paste into a view"

    |prop|

    aView isNil ifTrue:[ ^ false ].
    aView == self ifTrue:[ ^ true ].

    (prop := self propertyOfView:aView) notNil ifTrue:[
        ^ prop spec class supportsSubComponents
    ].
    ^ aView specClass supportsSubComponents.
!

dropObjects:aCollectionOfDropObjects at:aPoint
    |spec newSel oldSel dragOffset dropPoint widg|

    self selection notNil ifTrue:[
        oldSel := self singleSelection.

        "/ search selections hierarchy for a widget into which we can paste
        widg := oldSel.
        [widg isNil or:[self canPasteInto:widg]] whileFalse:[
            widg notNil ifTrue:[
                widg := widg container
            ].
        ].

        oldSel := nil.
        self setSelection:widg withRedraw:true.
    ].
    spec := (aCollectionOfDropObjects at:1) theObject.

    dragOffset := DragAndDropManager dragOffsetQuerySignal query.
    aPoint isNil ifTrue:[
        dropPoint := #keep.
    ] ifFalse:[
        dropPoint := aPoint - dragOffset.
    ].
    newSel := self pasteSpecifications:spec keepLayout:false keepPosition:false at:dropPoint.

    self select:(oldSel ? newSel).

    "Modified: / 18-03-1999 / 18:29:43 / stefan"
    "Created: / 13-10-2006 / 16:09:27 / cg"
! !

!UIPainterView methodsFor:'drawing'!

clearRectangle:visRect
    super clearRectangle:visRect.
    sketchPainter notNil ifTrue:[
        sketchPainter redrawInTargetView
    ].

    "Created: / 16-01-2008 / 17:52:27 / cg"
!

clearView
    super clearView.
    sketchPainter notNil ifTrue:[
        sketchPainter redrawInTargetView
    ].

    "Created: / 16-01-2008 / 17:46:08 / cg"
!

useSketchFile:aFilename 
    "a little neat goody: allow for a tablet-sketch file (WALTROP digital notepad)
     to be used as a background of the UIPainter window. This allows for sketches to
     be drawn, shown in the UIPainter, and then used as a placement hint (manual placement)
     for the user. Not a high-tech solution, but helped a lot, when we protoyped GUIs."

    |mime sketchPainterClass|

    mime := aFilename asFilename mimeTypeFromName.
    mime isNil ifTrue:[
        mime := aFilename asFilename mimeTypeOfContents.
    ].

    mime notNil ifTrue:[
        (mime startsWith:'image') ifTrue:[
            self viewBackground:(ImageReader fromFile:aFilename).
            ^ self.
        ].
        mime = 'application/x-waltop-digital-notepad' ifTrue:[
            sketchPainterClass := TOPFileDrawer.
        ].
    ].
    sketchPainterClass isNil ifTrue:[
        self error:'Unsupported sketch file format'
    ].

    sketchPainter := sketchPainterClass new.
    sketchPainter targetView:self.
    sketchPainter readFile:aFilename.
    sketchPainter ajustSketch.
    self invalidate.

    "Created: / 16-01-2008 / 17:46:26 / cg"
! !

!UIPainterView methodsFor:'event handling'!

keyPress:key x:x y:y view:aView
    "a delegated keyEvent from aView"

    self keyPress:key x:x y:y

    "Modified: / 31.10.1997 / 20:27:22 / cg"
!

keyRelease:key x:x y:y view:aView
    "a delegated keyEvent from aView"

    self keyRelease:key x:x y:y

    "Modified: / 31.10.1997 / 20:27:32 / cg"
!

sizeChanged:how

    super sizeChanged:how.

    self layoutChanged
! !

!UIPainterView methodsFor:'generating output'!

aspectMethods
    "extract a list of aspect methods - for browsing"

    |cls methods|

    className isNil ifTrue:[
	self warn:'No class defined !!'.
	^ #()
    ].

    cls := self resolveName:className.
    methods := IdentitySet new.

    self aspectSelectorsAndTypesDo:
	[:selector :typeSymbol |
	    |skip|

	    (cls includesSelector:selector) ifTrue:[

		skip := false.
		(typeSymbol == #modelAspect) ifTrue:[
		    (cls isSubclassOf:SimpleDialog) ifTrue:[
			skip := SimpleDialog includesSelector:(selector asSymbol)
		    ].
		].
		skip ifFalse:[
		    methods add:(cls compiledMethodAt:selector)
		].
	    ]
	].

    ^ methods

    "Created: / 25.10.1997 / 18:58:25 / cg"
    "Modified: / 26.10.1997 / 15:06:18 / cg"
!

aspectSelectorsAndTypesDo:aTwoArgBlock
    "evaluate aBlock for every aspect methods selector; 2nd arg describes the aspects type"

    |cls selector protoSpec|

    className isNil ifTrue:[
        self warn:'No class defined !!'.
        ^ self
    ].

    cls := self resolveName:className.

    treeView propertiesDo:[:aProp|
        |selector|

        (selector := aProp model) notNil ifTrue:[
            selector isArray ifFalse:[
                aTwoArgBlock value:(selector asSymbol) value:#modelAspect
            ].
        ].

        (selector := aProp menu) notNil ifTrue:[
            selector isArray ifFalse:[
                aTwoArgBlock value:(selector asSymbol) value:#menu
            ].
        ].

        (aProp spec aspectSelectors) do:[:aSel |
            (aSel isString or:[aSel isSymbol]) ifTrue:[
                aTwoArgBlock value:(aSel asSymbol) value:#channelAspect
            ].
        ].
        aProp spec actionSelectors do:[:aSel|
            (aSel isString or:[aSel isSymbol]) ifTrue:[
                aTwoArgBlock value:(aSel asSymbol) value:#actionSelector
            ].
        ].
        aProp spec valueSelectors do:[:aSel|
            (aSel isString or:[aSel isSymbol]) ifTrue:[
                aTwoArgBlock value:(aSel asSymbol) value:#valueSelector
            ].
        ]
    ].

    protoSpec := treeView canvasSpec.

    (selector := protoSpec menu) notNil ifTrue:[
        selector isArray ifFalse:[
            aTwoArgBlock value:(selector asSymbol) value:#menu
        ].
    ].
!

generateActionMethodFor:aspect spec:protoSpec inClass:targetClass
    |selector args showIt codeStream alreadyInSuperclass numArgs method|

    selector := aspect asSymbol.

    alreadyInSuperclass := targetClass superclass canUnderstand:selector.

    numArgs := selector numArgs.
    method  := aspect.

    numArgs == 1 ifTrue:[
        args := 'anArgument'.
        showIt := ''' , anArgument printString , ''...''.'.
    ] ifFalse:[
        args := ''.
        showIt := ' ...''.'.

        numArgs ~~ 0 ifTrue:[
            method := ''.

            selector keywords keysAndValuesDo:[:i :key|
                method := method, key, 'arg', i printString, ' '
            ]
        ]
    ].
    codeStream := WriteStream on:(String new:100).
    codeStream  
        nextPutLine:('!!',targetClass name,' methodsFor:''actions''!!');
        nextPutLine:(method,args);
        nextPutLine:'    <resource: #uiCallback>';
        cr.

    self class generateCommentedCode ifTrue:[
        codeStream
            nextPutAll:'    "automatically generated by UIPainter..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

'.

        alreadyInSuperclass ifTrue:[
            codeStream  
                nextPutLine:'    "action for ' , aspect , ' is already provided in a superclass."';
                nextPutLine:'    "It may be redefined here..."';
                cr.
        ] ifFalse:[
            codeStream  
                nextPutLine:'    "action to be defined here..."';
                cr.
        ].
    ].

    codeStream  
        nextPutAll:'    Logger info:'''.

    alreadyInSuperclass ifTrue:[
        codeStream  
            nextPutAll:'inherited '.
    ].
    codeStream  
        nextPutAll:'action for ';
        nextPutAll:aspect;
        nextPutLine:showIt.

    alreadyInSuperclass ifTrue:[
        codeStream  
            nextPutAll:'    super ';
            nextPutAll:aspect;
            nextPutAll:args;
            nextPutLine:'.'.
    ].

    codeStream  
        nextPutLine:'!! !!'; cr.

    ^ codeStream contents.

    "Modified: / 12-01-2008 / 10:21:52 / cg"
!

generateAspectMethodCode
    "generate aspect, action & menu methods
     - but do not overwrite existing ones.
     Return a string ready to compile into the application class.
     TODO: refactor and move to CodeGenerator"

    ^ self generateAspectMethodCodeFiltering:nil
!

generateAspectMethodCodeFiltering:aFilterOrEmpty
    "generate aspect, action & menu methods
     - but do not overwrite existing ones.
     Return a string ready to compile into the application class.
     TODO: refactor and move to CodeGenerator"

    |cls codePieces skip protoSpec thisCode
     definedMethodSelectors iVars t exportSels|

    cls := self targetClass.
    cls isNil ifTrue:[
        ^ nil
    ].

    codePieces := OrderedCollection new.
    definedMethodSelectors := IdentitySet new.

    treeView propertiesDo:[:aProp|
        |modelSelector|

        protoSpec := aProp spec.

        (modelSelector := aProp model) notNil ifTrue:[
            self generateCodeFrom:(Array with:modelSelector) in:cls
                do:[:aSel|
                    (aFilterOrEmpty isNil or:[aFilterOrEmpty includes:aSel]) ifTrue:[
                        skip := false.

                        (cls isSubclassOf:SimpleDialog) ifTrue:[
                            skip := SimpleDialog includesSelector:aSel
                        ].
                        (definedMethodSelectors includes:aSel) ifTrue:[
                            skip := true.
                        ].

                        skip ifFalse:[
                            "/ kludge ..
                            "/ (protoSpec isKindOf:ActionButtonSpec)
                            (protoSpec defaultModelIsCallBackMethodSelector:aSel)
                            ifTrue:[
                                thisCode := (self generateActionMethodFor:aSel spec:protoSpec inClass:cls).
                            ] ifFalse:[
                                thisCode := (self generateAspectMethodFor:aSel spec:protoSpec inClass:cls).
                            ].
                            codePieces add:thisCode.
                            definedMethodSelectors add:aSel.
                            Transcript showCR:'code generated for aspect: ' , aSel
                        ] ifTrue:[
                            Transcript showCR:'*** no code generated for aspect: ' , aSel , ' (method already exists)'
                        ].
                    ].
                ].
        ].

        "/ for each aspect, generate getter (if not yet implemented)
        self generateCodeFrom:(aProp spec aspectSelectors) in:cls
                do:[:aSel|
                    (aFilterOrEmpty isNil or:[aFilterOrEmpty includes:aSel]) ifTrue:[
                        (definedMethodSelectors includes:aSel) ifFalse:[
                            thisCode := (self generateAspectMethodFor:aSel spec:protoSpec inClass:cls).
                            codePieces add:thisCode.
                            definedMethodSelectors add:aSel.
                            Transcript showCR:'code generated for aspect: ' , aSel
                        ]
                    ]
                ].

        "/ exported aspects - need setter methods
        exportSels := (treeView exportedAspects ? #()) collect:[:entry | (entry subAspect) asMutator].
        self generateCodeFrom:exportSels in:cls
                do:[:aSel|
                    |aspect|

                    (aFilterOrEmpty isNil or:[aFilterOrEmpty includes:aSel]) ifTrue:[
                        (definedMethodSelectors includes:aSel) ifFalse:[
                            aspect := (aSel copyButLast) asSymbol.
                            thisCode := (self generateAspectSetMethodFor:aspect spec:protoSpec inClass:cls).
                            codePieces add:thisCode.
                            definedMethodSelectors add:aSel.
                            Transcript showCR:'export code generated for aspect: ' , aSel
                        ]
                    ]
                ].

        self generateCodeFrom:(aProp spec actionSelectors) in:cls
                do:[:aSel|
                    (aFilterOrEmpty isNil or:[aFilterOrEmpty includes:aSel]) ifTrue:[
                        (definedMethodSelectors includes:aSel) ifFalse:[
                            thisCode := (self generateActionMethodFor:aSel spec:protoSpec inClass:cls).
                            codePieces add:thisCode.
                            definedMethodSelectors add:aSel.
                            Transcript showCR:'action generated for aspect: ' , aSel
                        ]
                    ]
                ].

        self generateCodeFrom:(aProp spec valueSelectors) in:cls
                do:[:aSel|
                    (aFilterOrEmpty isNil or:[aFilterOrEmpty includes:aSel]) ifTrue:[
                        (definedMethodSelectors includes:aSel) ifFalse:[
                            "/ uppercase: - assume its a globals name.
                            aSel isUppercaseFirst ifFalse:[
                                thisCode := (self generateValueMethodFor:aSel spec:protoSpec inClass:cls).
                                codePieces add:thisCode.
                                definedMethodSelectors add:aSel.
                                Transcript showCR:'code generated for aspect: ' , aSel
                            ]
                        ]
                    ]
                ].
    ].

    AspectsAsInstances ifTrue:[
        iVars := cls instVarNames asOrderedCollection.
        definedMethodSelectors do:[:ivar |
            (iVars includes:ivar) ifFalse:[
                iVars add:ivar
            ]
        ].
        iVars := iVars asArray.
        t := cls shallowCopy.
        t setInstanceVariableString:iVars asStringCollection asString.
        codePieces addFirst:(t definition , '!!\' withCRs).
    ].

    ^ String
        streamContents:
            [:codeStream |
                codePieces do:[:eachPiece | codeStream nextPutAll:eachPiece].
            ].

    "Modified: / 29.7.1998 / 12:21:19 / cg"
!

generateAspectMethodFor:aspect spec:protoSpec inClass:targetClass
    |modelClass modelValueString modelValue modelGen codeStream|

    modelClass := protoSpec defaultModelClassFor:aspect.
    modelValueString := protoSpec defaultModelValueStringFor:aspect.
    modelValueString notNil ifTrue:[
        modelGen := modelValueString
    ] ifFalse:[
        modelValue := protoSpec defaultModelValueFor:aspect.
        modelValue isNil ifTrue:[
            modelGen := modelClass name , ' new'
        ] ifFalse:[
            modelGen := modelValue storeString , ' asValue'
        ].

    ].

    codeStream := WriteStream on:(String new:100).
    codeStream  
        nextPutLine:('!!' , targetClass name , ' methodsFor:''aspects''!!');
        nextPutLine:aspect;
        nextPutLine:'    <resource: #uiAspect>';
        cr.

    self class generateCommentedCode ifTrue:[
        codeStream  
            nextPutAll:'    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

'.
    ].

    AspectsAsInstances ifTrue:[
        codeStream
            nextPutLine:('    ',aspect,' isNil ifTrue:[');
            nextPutLine:('        ',aspect,' := ',modelGen,'.').

        modelClass ~~ TriggerValue ifTrue:[
            self class generateCommentedCode ifTrue:[
                codeStream
                    nextPutLine:'"/ if your app needs to be notified of changes, uncomment one of the lines below:'.
            ].
            codeStream
                nextPutLine:'"/       ',aspect,' addDependent:self.';
                nextPutLine:'"/       ',aspect,' onChangeSend:#',aspect,'Changed to:self.'.
        ].
        codeStream
            nextPutLine:'    ].';
            nextPutLine:'    ^ ',aspect,'.'.
    ] ifFalse:[
        codeStream
            nextPutLine:('    |holder|');
            cr;
            nextPutLine:('    (holder := builder bindingAt:#',aspect,') isNil ifTrue:[');
            nextPutLine:('        holder := ',modelGen,'.');
            nextPutLine:('        builder aspectAt:#',aspect,' put:holder.').

        modelClass ~~ TriggerValue ifTrue:[
            self class generateCommentedCode ifTrue:[
                codeStream
                    nextPutLine:'"/ if your app needs to be notified of changes, uncomment one of the lines below:'.
            ].
            codeStream
                nextPutLine:'"/       holder addDependent:self.';
                nextPutLine:'"/       holder onChangeSend:#',aspect,'Changed to:self.'.
        ].
        codeStream
            nextPutLine:'    ].';
            nextPutLine:'    ^ holder.'.
    ].

    codeStream
        nextPutLine:'!! !!'; cr.
"/ self halt.
    ^ codeStream contents.

    "Modified: / 22-09-1999 / 12:33:47 / stefan"
    "Modified: / 12-01-2008 / 10:21:43 / cg"
!

generateAspectSelectorsMethod
    "generate aspectSelectors method.
     Return a string ready to compile into the application class."

    |cls code spec|

    cls := self targetClass.
    cls isNil ifTrue:[
	^ nil
    ].

    spec := treeView exportedAspects.
    spec size == 0 ifTrue:[^ nil].

    "/ make it an array ...
    spec := spec collect:[:entry | |subAspect type|
		subAspect := entry subAspect asSymbol.
		(type := entry type) isNil ifTrue:[
		    subAspect
		] ifFalse:[
		    Array with:subAspect with:type asSymbol
		].
	    ].
    spec := spec asArray.

    code := '!!' , cls name , ' class methodsFor:''plugIn spec''!!\\' .

    code := code , 'aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(\'.
    spec do:[:el | code := code , ('        ' , el storeString , '\') ].
    code := code , '      ).\'.
    code := code , '\!!\'.
    code := code withCRs.
    ^ code

    "Modified: / 18.2.2000 / 02:08:34 / cg"
!

generateAspectSetMethodFor:aspect spec:protoSpec inClass:targetClass
    |code|

    code := '!!' , targetClass name , ' methodsFor:''aspects - exported''!!\\' ,
      aspect , ':something\' ,
      '    "automatically generated by UIPainter ..."\\' ,
      '    "This method is used when I am embedded as subApplication,"\' ,
      '    "and the mainApp wants to connect its aspects to mine."\'.

    AspectsAsInstances ifTrue:[
	code := (code , '\' ,
	  '"/     ' , aspect , ' notNil ifTrue:[\' ,
	  '"/        ' , aspect , ' removeDependent:self.\' ,
	  '"/     ].\' ,
	  '    ' , aspect ,' := something.\' ,
	  '"/     ' , aspect ,' notNil ifTrue:[\' ,
	  '"/        ' , aspect , ' addDependent:self.\' ,
	  '"/     ].\' ,
	  '    ^ self.\' ,
	  '!! !!\\')
    ] ifFalse:[
	code := (code , '\' ,
	  '"/     |holder|\' ,
	  '\' ,
	  '"/     (holder := builder bindingAt:#' , aspect , ') notNil ifTrue:[\' ,
	  '"/         holder removeDependent:self.\' ,
	  '"/     ].\' ,
	  '    builder aspectAt:#' , aspect , ' put:something.\',
	  '"/     something notNil ifTrue:[\' ,
	  '"/         something addDependent:self.\' ,
	  '"/     ].\' ,
	  '    ^ self.\' ,
	  '!! !!\\')
    ].

    ^ code withCRs

    "Modified: / 29.7.1998 / 11:29:16 / cg"
    "Modified: / 22.9.1999 / 12:33:47 / stefan"
!

generateCodeFrom:aListOfSelectors in:aClass do:aBlock
    |realSelectors redefCondition redefMessage|

    realSelectors := aListOfSelectors select:[:sel | sel isString or:[sel isSymbol]].

    self class redefineAspectMethods ifTrue:[
        redefCondition := [:cls :sel | (cls includesSelector:sel) not].
        redefMessage := ' skipped - already implemented in the class'.
    ] ifFalse:[
        redefCondition := [:cls :sel | (cls canUnderstand:sel) not].
        redefMessage := ' skipped - already implemented in the class (or superclass)'.
    ].

    realSelectors do:[:aSelector|
        (redefCondition value:aClass value:aSelector) ifTrue:[
            aBlock value:aSelector asSymbol
        ] ifFalse:[
            Transcript showCR:('#' , aSelector , redefMessage)
        ]
    ]
!

generateHookMethodFor:selectorSpec comment:commentWhen note:noteOrNil defaultCode:defaultCode inClass:targetClass
    ^ ('!!' , targetClass name , ' methodsFor:''hooks''!!\\' ,
      selectorSpec , '\' ,
      '    "automatically generated by UIPainter ..."\\' ,
      '    "*** the code here does nothing. It is invoked when"\' ,
      '    "*** ' , commentWhen , '"\' ,
      '    "*** Please change as required and accept in the browser."\' ,
      '\' ,
      '    "specific code to be added below ..."\' ,
      '    "' , (noteOrNil ? '') , '"\' ,
      '\' ,
      (defaultCode ? '^ self.') ,
      '!! !!\\') withCRs

    "Modified: / 25.10.1997 / 19:22:17 / cg"
    "Created: / 31.10.1997 / 17:31:53 / cg"
!

generateHookMethods
    "generate hook methods
     - but do not overwrite existing ones.
     Return a string ready to compile into the application class."

    |cls|

    cls := self targetClass.
    cls isNil ifTrue:[
	^ nil
    ].

    ^ self generateHookMethodsInClass:cls.
!

generateHookMethodsInClass:targetClass
    |code|

    code := ''.

    (targetClass includesSelector:#postBuildWith:) ifFalse:[
	code := code
		, (self
		    generateHookMethodFor:'postBuildWith:aBuilder'
		    comment:'the widgets have been built, but before the view is opened'
		    note:'or after the super send'
		    defaultCode:'    super postBuildWith:aBuilder'
		    inClass:targetClass)
    ].
    (targetClass includesSelector:#postOpenWith:) ifFalse:[
	code := code
		, (self
		    generateHookMethodFor:'postOpenWith:aBuilder'
		    comment:'the topView has been opened, but before events are dispatched for it'
		    note:'or after the super send'
		    defaultCode:'    super postOpenWith:aBuilder'
		    inClass:targetClass)
    ].
    (targetClass includesSelector:#closeRequest) ifFalse:[
	code := code
		, (self
		    generateHookMethodFor:'closeRequest'
		    comment:'the topView has been asked to close'
		    note:'return without the ''super closeRequest'' to stay open'
		    defaultCode:'    ^super closeRequest'
		    inClass:targetClass)
    ].
    ^ code

    "Modified: / 31.10.1997 / 17:30:34 / cg"
    "Created: / 31.10.1997 / 17:32:49 / cg"
!

generateMenuMethodFor:menuSel inClass:targetClass
    |selector args showIt code alreadyInSuperclass numArgs method category|

    selector := menuSel asSymbol.
    category := UserPreferences current categoryForMenuActionsMethods.

    alreadyInSuperclass := targetClass superclass canUnderstand:selector.

    code := '!!' , targetClass name , ' methodsFor:''' , category , '''!!\\'.

    selector = 'openAboutThisApplication' ifTrue:[
	code := code ,
		'openAboutThisApplication\' ,
		'    "opens an about box for this application."\\' ,
		'    "automatically generated by UIPainter ..."\\' ,

		'    |rev box myClass clsRev image msg|\\' ,

		'    rev := ''''.\' ,
		'    myClass := self class.\' ,

		'    (clsRev := myClass revision) notNil ifTrue:[\' ,
		'       rev := ''  (rev: '', clsRev printString, '')''].\\' ,

		'    msg := Character cr asString , myClass name asBoldText, rev.\' ,
		'    msg := (msg , ''\\*** add more info here ***\\'') withCRs.\\' ,
		'    box := AboutBox title:msg.\' ,

		'    "/ *** add a #defaultIcon method in the class\' ,
		'    "/ *** and uncomment the following line:\' ,
		'    "/ image := self class defaultIcon.\\' ,
		'    image notNil ifTrue:[\' ,
		'        box image:image\' ,
		'    ].\' ,
		'    box   label:(resources string:''About %1'' with:myClass name).\' ,
		'    box   autoHideAfter:10 with:[].\' ,
		'    box   showAtPointer.\' ,
		'!! !!\\'.
	^ code withCRs
    ].

    selector = 'menuOpen' ifTrue:[
	code := code ,
		'menuOpen\' ,
		'    "automatically generated by UIPainter ..."\\' ,
		'    "*** the code below opens a dialog for file selection"\' ,
		'    "*** and invokes the #doOpen: method with the selected file."\' ,
		'    "*** Please change as required and accept in the browser."\\' ,
		'    |file|\\' ,
		'    file :=\' ,
		'        (FileSelectionBrowser\' ,
		'            request: ''Open''\' ,
		'            fileName: ''''\' ,
		'            "/ inDirectory: lastOpenDirectory\' ,
		'            withFileFilters: #(''*'')).\\' ,
		'    file notNil ifTrue:[\' ,
		'       "/ lastOpenDirectory := file asFilename directory.\' ,
		'       self doOpen:file\' ,
		'    ]\' ,
		'!! !!\'.
	^ code withCRs
    ].

    numArgs := selector numArgs.
    method  := selector.

    numArgs == 1 ifTrue:[
	args := 'anArgument'.
	showIt := ''' , anArgument printString , '' ...''.\'.
    ] ifFalse:[
	args := ''.
	showIt := ' ...''.\'.

	numArgs ~~ 0 ifTrue:[
	    method := ''.

	    selector keywords keysAndValuesDo:[:i :key|
		method := method, key, 'arg', i printString, ' '
	    ]
	]
    ].

    code := code ,
		method , args , '\' ,
		'    "automatically generated by UIPainter ..."\\' ,
		'    "*** the code below performs no action"\' ,
		'    "*** (except for some feedback on the Transcript)"\' ,
		'    "*** Please change as required and accept in the browser."\' ,
		'\' .

    alreadyInSuperclass ifTrue:[
	code := code ,
		    '    "action for ' , selector , ' is already provided in a superclass."\' ,
		    '    "It may be redefined here ..."\\'.
    ] ifFalse:[
	code := code ,
		    '    "action to be added ..."\\'.
    ].

    code := code ,
		'    Transcript showCR:self class name, '': '.
    alreadyInSuperclass ifTrue:[
	code := code , 'inherited '.
    ].
    code := code , 'menu action for ' , selector , showIt.

    alreadyInSuperclass ifTrue:[
	code := code ,
			'    super ' , selector , args , '.\'.
    ].

    code := code ,
		'!! !!\\'.
    ^ code withCRs

    "Created: / 23.8.1998 / 16:46:51 / cg"
    "Modified: / 23.8.1998 / 18:13:05 / cg"
!

generateMenuMethods
    "generate menu methods
     - but do not overwrite existing ones.
     Return a string ready to compile into the application class."

    |cls code menuSelector thisCode
     definedMethodSelectors
     spec specArray fullSpec winSpec menuSpec|

    cls := self targetClass.
    cls isNil ifTrue:[
        ^ nil
    ].

    spec := treeView generateFullSpecForComponents:#() named:nil.
    specArray := spec literalArrayEncoding.
    fullSpec := specArray decodeAsLiteralArray.
    winSpec := fullSpec window.
    menuSelector := winSpec menu.

    (menuSelector notNil
    and:[ (cls respondsTo:menuSelector) ]) ifFalse:[
        self warn:'No menu defined (yet)'.
        ^ nil.
    ].
    menuSpec := cls perform:menuSelector.
    menuSpec := menuSpec decodeAsLiteralArray.

    definedMethodSelectors := IdentitySet new.
    code := ''.

    menuSpec allItemsDo:[:item |
        |sel|

        (sel := item value) notNil ifTrue:[
            (definedMethodSelectors includes:sel) ifFalse:[
                self generateCodeFrom:(Array with:sel) in:cls do:[:aSel|
                    thisCode := (self generateMenuMethodFor:aSel inClass:cls).
                    code := code, thisCode.
                ].
                definedMethodSelectors add:sel.
            ].
        ]
    ].

    (definedMethodSelectors includes:#menuOpen) ifTrue:[
        self generateCodeFrom:(Array with:#doOpen:) in:cls do:[:aSel|
            thisCode := (self generateMenuMethodFor:aSel inClass:cls).
            code := code, thisCode.
        ].
    ].

    ^ code

    "Created: / 23.8.1998 / 16:12:09 / cg"
    "Modified: / 23.8.1998 / 18:12:23 / cg"
!

generateValueMethodFor:aspect spec:protoSpec inClass:targetClass
    ^ ('!!' , targetClass name , ' methodsFor:''values''!!\\' ,
      aspect , '\' ,
      '    "automatically generated by UIPainter ..."\\' ,
      '    "*** the code below returns a default value when invoked."\' ,
      '    "*** (which may not be the one you wanted)"\' ,
      '    "*** Please change as required and accept in the browser."\' ,
      '\' ,
      '    "value to be added below ..."\' ,
      '    Transcript showCR:self class name , '': no value yet for ' , aspect , ' ...''.\' ,
      '\' ,
      '^ nil.' ,
      '!! !!\\') withCRs

    "Modified: / 25.10.1997 / 19:22:17 / cg"
!

generateWindowSpec
    |spec addToSpec specsAlready|

    spec := OrderedCollection new.
    specsAlready := IdentitySet new.

    addToSpec :=
        [:aView|
            |vSpec|
            "/ care for wrapped views ...
            vSpec := self fullSpecFor:aView.
            vSpec isNil ifTrue:[
                aView subViews size == 1 ifTrue:[
                    vSpec := self fullSpecFor:(aView subViews first).
                ]
            ].
            vSpec isNil ifTrue:[
                (Dialog 
                    confirm:('Oops - could not create spec for view: %1\\Continue ?' bindWith:aView printString) withCRs
                    noLabel:'Abort')
                ifFalse:[
                    AbortOperationRequest raise
                ].
            ].
            (specsAlready includes:vSpec) ifTrue:[self halt].
            specsAlready add:vSpec.
            spec add:vSpec
        ].

    self subViews do:addToSpec.
    self components do:addToSpec.
    spec := treeView generateFullSpecForComponents:spec named:methodName.
    ^ spec

    "Modified: / 30-07-2013 / 09:13:13 / cg"
!

generateWindowSpecMethodSource
    ^ self 
        generateWindowSpecMethodSourceFor:(self generateWindowSpec) 
        class:className 
        selector:methodName

    "Modified: / 5.9.1995 / 21:01:35 / claus"
    "Modified: / 15.10.1998 / 11:29:53 / cg"
!

generateWindowSpecMethodSourceFor:spec class:className selector:methodName
    |specArray str code category cls mthd specCode|

    specArray := spec literalArrayEncoding.

    str  := WriteStream on:''.
    UISpecification prettyPrintSpecArray:specArray on:str indent:4.
    specCode := str contents.

    (specCode includes:$!!) ifTrue:[
        "/ oops - must be chunk format ...
        str  := WriteStream on:''.
        str nextPutAllAsChunk:specCode.
        specCode := str contents.
    ].

    "/ if that method already exists, do not overwrite the category

    category := 'interface specs'.
    cls := self resolveName:className.

    cls notNil ifTrue:[
        (mthd := cls class compiledMethodAt:methodName asSymbol) notNil ifTrue:[
            category := mthd category.
        ]
    ].

    code := '!!'
            , className , ' class methodsFor:' , category storeString
            , '!!' , '\\'

            , methodName , '\'
            , ((ResourceSpecEditor codeGenerationCommentForClass: UIPainter) replChar:$!! withString:'!!!!')
            , '\\    "\'
            , ('     UIPainter new openOnClass:' , className , ' andSelector:#' , methodName , '\').

    (cls notNil and:[cls isSubclassOf:ApplicationModel]) ifTrue:[
        code := code
            , ('     ' , className , ' new openInterface:#' , methodName , '\').
    ].

    code := code
            ,(methodName = 'windowSpec'
                ifTrue:['     ' , className , ' open\'] ifFalse: [''])
            , '    "\'.

    code := code
            , '\'
            , '    <resource: #canvas>\\'.
    code := code withCRs.
    code := code
            , '    ^ ' , specCode
            , '\' withCRs
            , '!! !!'
            , '\\' withCRs.

    ^ code
!

listOfAspects
    |cls aspects|

    listOfAspectsHolder notNil ifTrue:[
        ^ listOfAspectsHolder value
    ].

    aspects := IdentitySet new.

    cls := self targetClass.
    cls notNil ifTrue:[
        cls withAllSuperclassesDo:[:cls |
            cls methodsDo:[:m |
                ((m resources ? #()) includes:#uiAspect) ifTrue:[
                    aspects add:m selector
                ].                  
            ]
        ]
    ].

    treeView propertiesDo:[:aProp|
        |modelSelector|

        (modelSelector := aProp model) notNil ifTrue:[
            aspects add:modelSelector asSymbol
        ].

"/        aspects addAll:aProp spec actionSelectors.

        aspects addAll:(aProp spec valueSelectors select:[:a | a isString or:[a isSymbol]]).
        aspects addAll:(aProp spec aspectSelectors select:[:a | a isString or:[a isSymbol]]).
    ].

    ^ aspects asOrderedCollection sort.

    "Created: / 12-01-2008 / 19:24:45 / cg"
!

listOfCallbacks
    |cls aspects|

    aspects := IdentitySet new.

    cls := self targetClass.
    cls notNil ifTrue:[
        cls methodsDo:[:m |
            ((m resources ? #()) includes:#uiCallback) ifTrue:[
                aspects add:m selector
            ].                  
        ]
    ].

    treeView propertiesDo:[:aProp|
        |modelSelector|

        aspects addAll:aProp spec actionSelectors.
"/        aspects addAll:aProp spec valueSelectors.
"/        aspects addAll:aProp spec aspectSelectors.
    ].

    ^ aspects asOrderedCollection sort.

    "Created: / 12-01-2008 / 19:25:19 / cg"
!

targetClass
    |cls|

    className isNil ifTrue:[
        self warn:'No TargetClass defined !!'.
        ^ nil
    ].
    (cls := self resolveName:className) isNil ifTrue:[
"/        self warn:('Class ', className asString, ' does not exist !!').
        ^ nil
    ].
    ^ cls.
! !

!UIPainterView methodsFor:'grid manipulation'!

newGrid
    "define a new grid - this is a private helper which has to be
     called after any change in the grid. It (re)creates the gridPixmap,
     clears the view and redraws all visible objects."

    |defaultViewBackground|

    gridPixmap := nil.
    defaultViewBackground := self class defaultViewBackgroundColor.

    shown ifTrue:[
        self viewBackground: (defaultViewBackground isColor
            ifTrue: [defaultViewBackground]
            ifFalse:[self blackColor]).
        self clear.
    ].

    gridShown ifTrue:[
        self defineGrid.
        gridPixmap colorMap: (defaultViewBackground isColor
            ifTrue: [Array with:defaultViewBackground with:Color darkGray]
            ifFalse:[Array with:self whiteColor with:self blackColor]).
        self viewBackground:gridPixmap.
    ].

    self invalidate
! !

!UIPainterView methodsFor:'group & ungroup'!

group

    self groupSelectionWithLayout: false
!

groupSelectionWithLayout: withLayout
    |minViews specs spec menu newView target keepLyt keepPos rectangle|

    self canGroup ifFalse:[^ self ].

    keepLyt := withLayout.
    keepPos := true.

    menu := Menu new.
    menu receiver: self.
    menu addItem:(MenuItem label:'Box' itemValue:[spec := ViewSpec new]).
    menu addItem:(MenuItem label:'TBox' itemValue:[spec := TBoxSpec new]).
    menu addItem:(MenuItem label:'FramedBox' itemValue:[spec := FramedBoxSpec new]).

    menu addItem:(MenuItem 
                    label:'HorizontalPanel'
                    itemValue:[
                        keepLyt := keepPos := false.
                        spec := HorizontalPanelViewSpec new.
                        spec verticalLayout: #fit.
                        spec horizontalLayout: #leftSpace.
                    ]).
    menu addItem:(MenuItem 
                    label:'VerticalPanel'
                    itemValue:[
                        keepLyt := keepPos := false.
                        spec := VerticalPanelViewSpec new.
                        spec verticalLayout: #topSpace.
                        spec horizontalLayout: #fit.
                    ]).

    menu startUp.
    spec isNil ifTrue:[^ self].

    minViews := self minClosedViewSetFor:(self selection).
    minViews size > 1 ifFalse:[^ self].

    specs     := OrderedCollection new.
    rectangle := minViews first frame copy.

    minViews do:[:eachView|
        specs add:(self fullSpecWithAbsolutePositionFor:eachView).
        rectangle := rectangle quickMerge:(eachView frame).
    ].
    spec layout:rectangle.

    target := self findContainerOfView:(minViews first).

    self withinTransaction:#group objects:(Array with:target) do:[ |widgets|
        self deleteSelectionBuffered:false.

        spec otherAttributeAt:#uiPainterAttributes put:(Dictionary new
                at:#origin put:(rectangle origin);
                at:#extent put:(rectangle extent);
                at:#absOrigin put:(rectangle origin);
                yourself).

        newView := self pasteSpecifications:(Array with:spec) 
                    into:target
                    keepLayout:true
                    keepPosition:true
                    at:#keep.

        widgets := self pasteSpecifications:specs
                into:newView
                keepLayout:keepLyt
                keepPosition:keepPos
                at:nil.
    ].
    self select:newView.
!

groupWithLayout

    self groupSelectionWithLayout: true
!

ungroup

    self ungroupSelectionWithLayout: false
!

ungroupSelectionWithLayout: withLayout

    | canvas cS views specs frame view layout superView|

    self canUngroup ifFalse:[^ self ].

    canvas := self painter.
    cS := canvas getSelectedViewsAndSpecs.
    cS isNil ifTrue:[^self].
    views := cS first first subViews copy.
    superView := cS first first superView.
    cS last first component isNil ifTrue:[^self].
    cS last first component collection isEmpty ifTrue:[^self].
    specs := cS last first component collection copy.
    frame := cS first first frame.
    canvas deleteSelection.
    withLayout ifFalse:[
        1 to: specs size do:[:i|
            view := views at: i.
            layout :=  LayoutFrame leftFraction:0.0 offset: (view origin x + frame origin x)
                                  rightFraction:0.0 offset: (view corner x + frame origin x + 1)
                                    topFraction:0.0 offset: (view origin y + frame origin y )
                                 bottomFraction:0.0 offset: (view corner y + frame origin y + 1).
            (specs at: i) layout: layout.
        ].
    ].
    canvas selection: superView.
    canvas pasteSpecifications:specs keepLayout:true.
    canvas selection: superView.
!

ungroupWithLayout

    self ungroupSelectionWithLayout: true
! !

!UIPainterView methodsFor:'initialization'!

create
    "colors on device"
    
    super create.
    handleColorBlack := handleColorBlack onDevice:device.
    handleColorWhite := handleColorWhite onDevice:device.
    handleMasterColor := handleMasterColor onDevice:device.
!

initialize
    "setup attributes
    "
    super initialize.
    superclassName    := 'ApplicationModel'.
    className         := 'NewApplication'.
    methodName        := 'windowSpec'.
    categoryName      := 'Applications'.
    HandCursor        := Cursor leftHand.
    handleColorBlack  := self blackColor.
    handleColorWhite  := self whiteColor.
    handleMasterColor := Color red.

    self backgroundColor: self class defaultViewBackgroundColor.
!

setupFromSpec:specOrSpecArray
    |spec builder specWindow|

    Cursor wait showWhile: [
        self removeAll.
        specOrSpecArray notNil ifTrue:[
            spec := UISpecification from:specOrSpecArray.
        ].
        builder := UIBuilder new isEditing:true.
        "set applicationClass, in order that subspecifications may be resolved"
        className notNil ifTrue:[
            builder applicationClass:(self resolveName:className).
        ].
        spec notNil ifTrue:[
            specWindow := spec window.
        ].
        specWindow notNil ifTrue:[
            specWindow setupView:self topView for:builder.
            self addSpec:(spec component) builder:builder in:self.
        ].
        self realizeAllSubViews.
        specWindow notNil ifTrue:[
            treeView setAttributesFromWindowSpec:specWindow
        ].
    ].
!

treeView:aTreeView
    treeView := aTreeView.

    treeView delegate:(
	"/
	"/ I want to handle everything typed
	"/ in the treeView, except for Return and Cursor-keys
	"/
	KeyboardForwarder
	    toView:self
	    condition:nil
	    filter:[:k | (k isSymbol
			 and:[k ~~ #Return
			 and:[k ~~ #Tab
			 and:[(k startsWith:#Cursor) not]]])
		   ]
    )

    "Modified: / 31.10.1997 / 20:22:09 / cg"
! !

!UIPainterView methodsFor:'menus'!

showMiddleButtonMenu
    "show the middle button menu; this returns nil"

    |m|

    self enabled ifTrue:[
        m := MenuPanel fromSpec:(UIPainter menuEdit) receiver:self superView application.
        self startUpMenu:m
    ].
    ^ nil

    "Modified: / 31-10-2007 / 11:10:10 / cg"
! !

!UIPainterView methodsFor:'private-handles'!

painter
    ^ treeView canvas
!

showSelected:aComponent
    "show object selected
    "
    |wasClipped sel hInsideColor hOutsideColor bg|

    selectionHiddenLevel == 0 ifTrue:[
        sel := treeView selection.
        (sel size > 1 and: [(treeView model list at: sel first) contents view == aComponent])
        ifTrue: [
            hInsideColor := handleMasterColor.
        ] ifFalse:[
            bg := aComponent viewBackground.
            bg isColor ifTrue:[
                bg brightness < 0.5 ifTrue:[
                    hInsideColor := handleColorWhite
                ] ifFalse:[
                    hInsideColor := handleColorBlack
                ]
            ] ifFalse:[
                hInsideColor := handleColorBlack
            ]
        ].

        hInsideColor brightness < 0.5 ifTrue:[
            hOutsideColor := handleColorWhite
        ] ifFalse:[
            hOutsideColor := handleColorBlack
        ].

        (wasClipped := clipChildren) ifTrue:[
            self clippedByChildren:(clipChildren := false).
        ].

        self handlesOf:aComponent do:[:aRectangle :what| 
            |l t w h|

            l := aRectangle left.
            t := aRectangle top.
            w := aRectangle width.
            h := aRectangle height.

            self paint:hOutsideColor.
            self displayRectangleX:l y:t width:w height:h.

            self paint:hInsideColor.

            what == #view ifTrue:[
                self displayRectangleX:l+1 y:t+1 width:w-2 height:h-2
            ] ifFalse:[
                self fillRectangleX:l+1 y:t+1 width:w-2 height:h-2
            ]
        ].

        wasClipped ifTrue:[
            self clippedByChildren:(clipChildren := true).
        ]
    ]

    "Modified: / 6.12.2001 / 00:00:16 / cg"
! !

!UIPainterView methodsFor:'queries'!

isEditingSpecOnly
    "/ should not be invoked
    self breakPoint:#ca.
    ^ false.
!

isNotEditingSpecOnly
    "/ should not be invoked
    self breakPoint:#ca.
    ^ true.
!

resolveName:aName
    |appl|

    appl := self application.

    appl notNil ifTrue:[
	^ appl resolveName:aName
    ].
    ^ Smalltalk resolveName:aName inClass:self class
! !

!UIPainterView methodsFor:'removing components'!

remove:anObject
    "remove anObject from the contents do redraw
    "
    anObject notNil ifTrue:[
	treeView removeView:anObject.
    ]
!

removeAll
    "remove all objects and properties
    "
    self select:nil.
    treeView removeAll.
    self removeUndoHistory.
! !

!UIPainterView methodsFor:'searching'!

findContainerOfView:aView
    "returns the super view assigned to a view
    "
    |p|

    (p := self propertyOfParentForView:aView) isNil ifTrue:[
	^ self
    ].
    ^ p view
!

findObjectAt:aPoint
    |view prop|

    view := super findObjectAt:aPoint.
    view isNil ifTrue:[^ nil].

    "/ stupid check, if I know about this view
    prop := self propertyOfView:view.
    prop notNil ifTrue:[^ prop view].
    self halt:'nil property'.
    ^ nil
!

findViewWithId:aViewId
    "finds view assigned to identifier and returns the view or nil
    "
    |prop|

    prop := self propertyOfIdentifier:aViewId.

    prop notNil ifTrue:[^ prop view]
	       ifFalse:[^ nil]
!

propertyOfIdentifier:anId
    "returns property assigned to unique identifier
    "
    anId notNil ifTrue:[
	^ treeView propertyDetect:[:p| p identifier == anId ]
    ].
    ^ nil
!

propertyOfName:aString
    "returns the property for a given widgets name (name in tree)"

    |name|

    aString isNil ifFalse:[
        name := aString string withoutSeparators.
        ^ treeView propertyDetect:[:p| p name = name ].
    ].
    ^ nil
!

propertyOfParentForView:aSubView
    "returns the property of the parent or nil
    "
    |item|

    (item := treeView detectItemCorespondingToView:aSubView) notNil ifTrue:[
        (item := item parent) notNil ifTrue:[^ item contents]
    ].
    ^ nil
!

propertyOfView:aView
    "detect the property for the argument, a view. The property of the view or
     the first subview providing the properties is returned. If no property is detected
     nil is returned.
    "
    |item|

    item := treeView detectItemCorespondingToView:aView.
    (item notNil and:[item parent notNil]) ifTrue:[
        ^ item contents
    ].
    ^ nil
!

uniqueNameFor:aSpecOrString
    "generate and return a unique name for a specClass or an items name.
     (unique name in the tree)"

    |maxUsedIndex name nameLen|

    name := aSpecOrString isString 
                ifFalse:[aSpecOrString userFriendlyName]
                ifTrue:[aSpecOrString].

    nameLen := name size.
    maxUsedIndex := 0.

    treeView propertiesDo:[:p|
        |thisName|

        thisName := p name.

        (thisName size > nameLen and:[thisName startsWith:name]) ifTrue:[
            maxUsedIndex := maxUsedIndex max:(p extractNumberStartingAt:nameLen+1)
        ]
    ].
    ^ name, (maxUsedIndex+1) printString.
!

uniqueNameOf:aView
    |prop|

    (prop := self propertyOfView:aView) notNil ifTrue:[
	prop name isNil ifTrue:[
	    prop name:(self uniqueNameFor:(prop spec)).
	].
	^ prop name
    ].
    ^ 'self'

! !

!UIPainterView methodsFor:'selection basics'!

addToSelection:anObject
    "add an object to the selection
    "
    (self enabled and:[(self isSelected:anObject) not]) ifTrue:[
        selection isCollection ifFalse:[
            selection isNil ifTrue:[
                selection := anObject
            ] ifFalse:[
                selection := OrderedCollection with:selection with:anObject
            ]
        ] ifTrue:[
            "/ to enforce the change-message (value is identical to oldValue)
            selection isList ifTrue:[
                selection add:anObject
            ] ifFalse:[
                selection := selection asOrderedCollection.
                selection := selection copyWith:anObject
            ]
        ].
        self showSelected:anObject.
        treeView canvasSelectionAdd:anObject.
    ]

    "Modified: / 11.2.2000 / 01:39:05 / cg"
!

removeFromSelection:anObject
    "remove an object from the selection
    "
    (self isSelected:anObject) ifTrue:[
        self showUnselected:anObject.

        selection size > 1 ifTrue:[
            selection isList ifTrue:[
                selection remove:anObject ifAbsent:nil
            ] ifFalse:[
                "/ to enforce the change-message (value is identical to oldValue)
                selection := selection asOrderedCollection.
                selection := selection copyWithout:anObject
            ].
            self showSelection.
        ] ifFalse:[
            selection := nil
        ].
        treeView canvasSelectionRemove:anObject.
    ]

    "Modified: / 11.2.2000 / 01:41:11 / cg"
!

select:something
    "change selection to something
    "
    (self enabled and:[something ~= self selection]) ifTrue:[
        something isNil
            ifTrue: [treeView selection: (Array with: 1)]
            ifFalse:[treeView canvasSelection:something].
        self setSelection:something withRedraw:true
    ]
!

selectNextUpInHierarchy
    | sel |

    (sel := self selection) isNil ifTrue:[^self].
    sel isCollection ifTrue:[
        sel := self selection first.
    ].
    sel := sel superView.
    sel isNil ifTrue:[^self].
    treeView canvasSelection: sel.
    self selection: sel.
!

selectedNodes
    ^ treeView model selectedNodes
!

updateSelectionFromModel:aSelOrNil
    "update selection from a new selection
    "
    |list|

    "/ do not return here if not shown - we NEED the correct selection
    selectionHiddenLevel == 0 ifTrue:[
        aSelOrNil size ~~ 0 ifTrue:[
            list := OrderedCollection new.

            self selectionDo:[:el|
                (aSelOrNil includes:el) ifFalse:[list add:el]
            ].
            self shown ifTrue:[self showUnselected:list].
        ] ifFalse:[
            self shown ifTrue:[self hideSelection].
        ]
    ].
    self repairDamage.
    self setSelection:aSelOrNil withRedraw:false.
    self showSelection.
! !

!UIPainterView methodsFor:'specification'!

addSpec:aSpecification builder:aBuilder in:aFrame
    "build view and subviews from aSpecification into a frame. The top view
     is returned. The contained components of a spec are set to nil
    "
    ^ self addSpec:aSpecification builder:aBuilder in:aFrame beforeIndex:nil.
!

addSpec:aSpecification builder:aBuilder in:aFrame beforeIndex:anIndexOrNil
    "build view and subviews from aSpecification into a frame. The top view
     is returned. The contained components of a spec are set to nil
    "
    |cls newView viewPosition subviewToRealize|

    cls := self resolveName:className.

    cls notNil ifTrue:[
        aBuilder applicationClass:cls.
    ].

    (     anIndexOrNil notNil
     and:[anIndexOrNil between:1 and:(aFrame subViews size)]
    ) ifTrue:[
        viewPosition := anIndexOrNil.
    ].

    "/ remember view<->spec associations to tree
    aBuilder 
        componentCreationHook:[:aView :aSpec :builder|
            |newProperty copyOfSpec nameOfSpec beforeIndex|

            (viewPosition notNil and:[aSpecification == aSpec]) ifTrue:[
                subviewToRealize := aView.

                [ (subviewToRealize notNil and:[subviewToRealize superView ~~ aFrame]) ] whileTrue:[
                    subviewToRealize := subviewToRealize superView.
                ].
                subviewToRealize notNil ifTrue:[
                    beforeIndex := viewPosition.
                    aFrame changeSequenceOrderFor:subviewToRealize to:viewPosition.
                ].
            ].

            newProperty := ViewProperty new.
            copyOfSpec := aSpec copy.
            newProperty spec:copyOfSpec.
            newProperty view:aView.

            "/ break refs to child-specs
            "/ (not needed, as we keep the child info in the view hierarchy)
            copyOfSpec class supportsSubComponents ifTrue:[
                copyOfSpec component:nil
            ].

            nameOfSpec := copyOfSpec name.
            "/ old: enforce a name
            "/ (nameOfSpec isNil or:[(self propertyOfName:nameOfSpec) notNil]) ifTrue:[
            "/     copyOfSpec name:(nameOfSpec := self uniqueNameFor:copyOfSpec)
            "/ ].
            "/ aView name:nameOfSpec.
            "/ new:
            (nameOfSpec isNil "notEmptyOrNil" or:[ (self propertyOfName:nameOfSpec) notNil]) ifTrue:[
                copyOfSpec name:(nameOfSpec := self uniqueNameFor:copyOfSpec).
                aView name:nameOfSpec.
            ].
            "/ end

            treeView addProperty:newProperty beforeIndex:beforeIndex.
        ].

    newView := aSpecification buildViewWithLayoutFor:aBuilder in:aFrame.

    subviewToRealize notNil ifTrue:[
        subviewToRealize realize.

        aFrame components notEmptyOrNil ifTrue:[ self halt ].
        aFrame subViews from:(viewPosition + 1 ) do:[:v|
            v shown ifTrue:[v raise]
        ].
    ].
    ^ newView

    "Modified: / 17-08-2011 / 13:56:24 / cg"
!

fullSpecFor:aView
    "generate a full spec for aView (or component)"

    |mySpec subSpecs|

    mySpec := self specFor:aView.
    (mySpec notNil and:[mySpec class supportsSubComponents]) ifTrue:[
        subSpecs isNil ifTrue:[
            subSpecs := OrderedCollection new
        ].

        ((aView components ? #()) , (aView subViews ? #())) do:[:aSubViewOrComponent |
            |spec|

            spec := self fullSpecFor:aSubViewOrComponent.
            spec notNil ifTrue:[
                subSpecs add:spec.
            ].
        ].

        subSpecs notEmptyOrNil ifTrue:[
            mySpec component:(SpecCollection new collection:subSpecs)
        ]
    ].
    ^ mySpec

    "Modified: / 30-07-2013 / 09:12:18 / cg"
!

fullSpecWithAbsolutePositionFor:aView
    |spec|

    spec := self fullSpecFor:aView.
    spec 
        otherAttributeAt:#uiPainterAttributes 
        put:(Dictionary new
                at:#origin put:aView origin;
                at:#extent put:aView extent;
                at:#absOrigin put:(aView originRelativeTo:self);
                yourself).
    ^ spec
!

rebuildView:aView fromSpec:aSpec withBuilder:aBuilderOrNil
    self
        rebuildView:aView fromSpec:aSpec withBuilder:aBuilderOrNil forceNewView:false
!

rebuildView:aView fromSpec:aSpec withBuilder:aBuilderOrNil forceNewView:forceNewView
    |v builder|

    (builder := aBuilderOrNil) isNil ifTrue:[
        "/ create a dummy builder
        builder := UIBuilder new isEditing:true.
        className notNil ifTrue:[
            builder applicationClass:(self resolveName:className).
        ].
    ].

    aSpec class isLayoutContainer ifTrue:[
        "/ TODO:
        "/ go through subviews and let them resize to their default/preferred
        "/ needed if we change a containers layout from fit to non-fit.

        (aView subViews ? #()) do:[:aSubView |
            |fix spec prop container|

            (prop := self propertyOfView:aSubView) notNil ifTrue:[
                spec := prop spec.

                spec useDefaultExtent ifTrue:[
                    fix := aSubView sizeFixed:false.
                    aView class == VerticalPanelView ifTrue:[
                        aSubView height:aSubView preferredHeight.
                    ] ifFalse:[
                        aView class == HorizontalPanelView ifTrue:[
                            aSubView width:aSubView preferredWidth.
                        ] ifFalse:[
                            aSubView extent:aSubView preferredExtent.
                        ].
                    ].
                    aSubView sizeFixed:fix
                ]
            ]
        ].
    ].

    (forceNewView or:[aSpec needsRebuildForAttributes]) ifTrue:[
        "/ needs a full rebuild (in case view class depends upon spec-attribute)
        v := aSpec buildViewWithLayoutFor:builder in:(self findContainerOfView:aView).
        v realize.
        aView destroy.
        self sync.
        aView becomeSameAs:v.
        "/ inputView raise.
    ] ifFalse:[
        aSpec setAttributesIn:aView with:builder.
        self elementChangedSize:aView.
    ].
!

specFor:aView
    "returns a copy of the spec assigned to an object"

    |prop spec|

    (prop := self propertyOfView:aView) isNil ifTrue:[^ nil].
    "/ attention: the above prop may be a superview's prop,
    "/ for subviews which have not been built by me
    "/ (for example, in a box with a given viewClass like Inspector,
    "/ we would return the boxes spec for the subviews.
    "/ This is definitely NOT what we want (as it generates wrong specs).
    "/ therefore check:
    prop view == aView ifFalse:[^ nil].

    spec := prop spec copy.
    spec layoutFromView:aView.
    ^ spec

    "Modified (comment): / 30-07-2013 / 09:47:51 / cg"
!

specForSelection
    "returns the spec assigned to current single selection or nil.
     Nil is also returned for multiple selections (sigh)"

    |theSpec|

    theSpec := self specFor:(self singleSelection).
    theSpec isNil ifTrue:[
        treeView isCanvasSelected ifTrue:[
            theSpec := treeView canvasSpec.
        ]
    ].
    ^ theSpec
!

updateFromSpec:aSpec
    "update current selected view from specification
    "
    |props name|

    aSpec class == WindowSpec ifTrue:[
         ^ treeView canvasSpec:aSpec
    ].

    self singleSelection notNil ifTrue:[
        self withSelectionHiddenDo:[
            self transaction:#specification selectionDo:[:aView|

                props   := self propertyOfView:aView.
                name    := (aSpec name) withoutSeparators.

                name isNil ifTrue:[
                    "/ not yet given a name
                    (name ~= props name) ifTrue:[
                        (self propertyOfName:name) notNil ifTrue:[
                            name := props name
                        ]
                    ].
                ].
                aSpec name:name.
                self createUndoSpecModify:props.
                self rebuildView:aView fromSpec:aSpec withBuilder:nil.
                props spec:(aSpec copy).
                treeView propertyChanged:props.
            ]
        ]
    ]

    "Modified: / 17-08-2011 / 13:56:38 / cg"
    "Modified (format): / 18-08-2011 / 02:19:01 / cg"
! !

!UIPainterView methodsFor:'testing'!

canChangeLayoutOfView:aView
    "returns true if the view can change its layout.
     This is dependent on its parent view."

    |item parent|

    item := treeView itemOfView:aView.
    item isNil ifTrue:[
        "/ I don't know anything about that view (cg: how can this happen ?)
        "/ self breakPoint:#cg.
        ^ false
    ].
    parent := item parent.
    parent isNil ifTrue:[
        "/ that view has no parent (cg: does this mean its the canvas itself ?)
        "/ self breakPoint:#cg.
        ^ false
    ].
    parent contents view == self ifTrue:[
        "aView is a direct subview of the canvas
         -- and the canvas supports layout changes of its subviews"
        ^ true.
    ].
    ^ parent contents spec class isLayoutContainer not
!

canExchangeSelectionLayouts
    "returns true if the selection size is exactly 2
     and all elements in the selection can be moved or aligned
    "
    selection size ~~ 2 ifTrue:[
        ^ false
    ].
    ^ self canMoveOrAlignSelection
!

canGroup
    "test whether selected elements can be grouped; minimum two elements
     must be selected and all must have the same parent"

    |selectedNodes parent|

    selectedNodes := self selectedNodes.

    selectedNodes size < 2ifTrue:[ ^ false ].

    parent := selectedNodes first parent.
    parent isNil ifTrue:[ ^ false ].    "/ test whether not the canvas itself is selected

    selectedNodes do:[:each|
        each parent ~~ parent ifTrue:[^ false ].
    ].

    ^true
!

canKeepLayoutInSelection
    "returns true if layout can be kept during a paste operation
    "
    |prop|

    prop := self propertyOfView:(self singleSelection).
  ^ (prop isNil or:[prop spec class isLayoutContainer not])
!

canMove:something
    "checks whether something is not nil and if all widgets derived from
     something can change their layout ( move, align, ... operation ).
    "
    something notNil ifTrue:[
        self forEach:something do:[:aView|
            (self canChangeLayoutOfView:aView) ifFalse:[^ false]
        ].
        ^ true
    ].
    ^ false
!

canMoveOrAlignSelection
    "returns true if a selection exists and all elements in the selection
     can be moved or aligned
    "
    ^ self canMove:(self selection)
!

canResize:something
    "checks whether something is not nil and if all widgets derived from
     something can be resized."

    something notNil ifTrue:[
        self forEach:something do:[:aView|
            (self canResizeView:aView) ifFalse:[^ false]
        ].
        ^ true
    ].
    ^ false
!

canResizeSelection
    "returns true if a selection exists and all elements in the selection
     can be resized"

    ^ self canResize:(self selection)
!

canResizeView:aView
    "returns true if the view can be resized.
     This is dependent on its parent view."

    |item parent|

    item := treeView itemOfView:aView.
    item isNil ifTrue:[
        "/ I don't know anything about that view (cg: how can this happen ?)
        "/ self breakPoint:#cg.
        ^ false
    ].
    parent := item parent.
    parent isNil ifTrue:[
        "/ that view has no parent (cg: does this mean its the canvas itself ?)
        "/ self breakPoint:#cg.
        ^ false
    ].
    parent contents view == self ifTrue:[
        "aView is a direct subview of the canvas
         -- and the canvas supports resizing of its subviews"
        ^ true.
    ].
    ^ parent contents spec class canResizeSubComponents
!

canUngroup
    "test whether the selected element can be ungrouped; only one
     element is selected and has children"

    "/ the #ungroupSelectionWithLayout: dosnot work yet - so disable

"/    |selectedNodes node|
"/
"/    selectedNodes := self selectedNodes.
"/
"/
"/    selectedNodes size == 1 ifTrue:[
"/        node := selectedNodes first.
"/        node parent isNil ifTrue:[ ^ false ].    "/ test whether not the canvas itself is selected
"/
"/        ^ node hasChildren
"/    ].
    ^ false
! !

!UIPainterView methodsFor:'transaction'!

transaction:aType objects:something do:aOneArgBlock
    "opens a transaction and evaluates a block within the transaction; the
     argument to the block is a view from derived from something
    "
    self withinTransaction:aType objects:something do:[
	self forEach:something do:aOneArgBlock
    ]
!

withinTransaction:aType objects:objects do:aNoArgBlock
    "evaluate a block within a transaction"

    |text size prop|

    objects isNil ifTrue:[ ^ self ].

    size := objects size.

    objects isCollection ifTrue:[
        size == 0 ifTrue:[ ^ self ].
        size == 1 ifTrue:[ 
            prop := self propertyOfView:(objects first) 
        ]
    ] ifFalse:[
        prop := self propertyOfView:objects
    ].

    prop notNil ifTrue:[
        text := prop name
    ] ifFalse:[
        text := size printString, ' elements'
    ].

    undoHistory withinTransaction:aType text:text do:aNoArgBlock.
    self undoHistoryChanged.
! !

!UIPainterView methodsFor:'undo actions'!

createUndoLayout:aView
    "create undo action before changing a views layout"

    |lyt args prop|

    undoHistory isTransactionOpen ifTrue:[
        prop := self propertyOfView:aView.

        prop notNil ifTrue:[
            args := Array new:3.
            args at:1 put:(prop identifier).

            (lyt := aView geometryLayout) notNil ifTrue:[
                args at:2 put:#geometryLayout:
            ] ifFalse:[
                lyt := aView extent.
                args at:2 put:#extent:
            ].
            args at:3 put:(lyt copy).
            undoHistory addUndoSelector:#undoLayout: withArgs:args.
            self undoHistoryChanged.
        ]
    ]
!

createUndoRemove:aView
    "create undo method before deleting views
    "
    |item itemParent prop args|

    item := treeView detectItemCorespondingToView:aView.
    item isNil ifTrue:[^ self ].

    itemParent := item parent.
    itemParent isNil ifTrue:[^ self ].

    prop  := item contents.

    args := Array
            with:(self fullSpecFor:aView)
            with:(prop identifier)
            with:(itemParent contents identifier)
            with:(itemParent indexOfChild:item).


    undoHistory addUndoSelector:#'undoRemove:' withArgs:args.
    self undoHistoryChanged.
!

createUndoSpecModify:aProp
    "undo method when changing the specification for an object
    "
    aProp notNil ifTrue:[
        undoHistory addUndoSelector:#undoSpecModify:
                           withArgs:(Array with:(aProp spec) with:(aProp identifier)).
        self undoHistoryChanged.
    ]
!

createUndoStartPointEndPoint:aComponent
    "create an undo action before changing aComponent"

    |args prop|

    undoHistory isTransactionOpen ifTrue:[
        prop := self propertyOfView:aComponent.

        prop notNil ifTrue:[
            args := Array new:4.
            args at:1 put:(prop identifier).
            args at:2 put:#'startPoint:endPoint:'.
            args at:3 put:(aComponent startPoint).
            args at:4 put:(aComponent endPoint).
            undoHistory addUndoSelector:#undoStartPointEndPoint: withArgs:args.
            self undoHistoryChanged.
        ]
    ]
!

undoCreate:something
    "undo method for creating or pasting an object
    "
    self forEach:something do:[:anId|self remove:(self findViewWithId:anId)].
!

undoHistory
    ^ undoHistory

    "Created: / 30.10.2001 / 13:42:45 / cg"
!

undoLayout:args
    "undo method to set the old layout; see 'createUndoLayout:'
    "
    |view|

    (view := self findViewWithId:(args at:1)) notNil ifTrue:[
        view perform:(args at:2) with:(args at:3).
        self elementChangedSize:view.
        self layoutChanged.
    ]
!

undoRemove:args
    "undo method when removing an object; see 'createUndoRemove:'
    "
    |frame prop view position parentId|

    position := args at:4 ifAbsent:nil.
    parentId := args at:3 ifAbsent:nil.

    parentId notNil ifTrue:[
        frame := self findViewWithId:parentId.
    ].

    frame isNil ifTrue:[ frame := self. ].

    view := self addSpec:(args at:1)
                 builder:(UIBuilder new isEditing:true)
                      in:frame 
             beforeIndex:position.

    view realize.
    prop := self propertyOfView:view.
    prop identifier:(args at:2).
!

undoSpecModify:args
    "undo method when changing a spec; see 'createUndoSpecModify:'
    "
    |view spec props|

    props := self propertyOfIdentifier:(args at:2).

    props notNil ifTrue:[
	view    := props view.
	spec    := args at:1.

	props spec:spec.
	self rebuildView:view fromSpec:spec withBuilder:nil.
	treeView propertyChanged:props.
    ]
!

undoStartPointEndPoint:args
    "undo method to set the old start/endPoint; see 'createUndoStartPointEndPoint:'
    "
    |view|

    (view := self findViewWithId:(args at:1)) notNil ifTrue:[
        view perform:(args at:2) with:(args at:3) with:(args at:4).
        self elementChangedSize:view.
        self layoutChanged.
    ]
! !

!UIPainterView::ViewProperty class methodsFor:'instance creation'!

new
    Identifier notNil ifTrue:[Identifier := Identifier + 1]
		     ifFalse:[Identifier := 1].

  ^ self basicNew initialize
! !

!UIPainterView::ViewProperty methodsFor:'accessing'!

identifier
    "return the unique identifier assigned to property
    "
    ^ identifier
!

identifier:anIdentifier
    "set the unique identifier assigned to property; called after an restore of
     a deleted instance
    "
    identifier := anIdentifier
!

spec
    "return the value of the instance variable 'spec' (automatically generated)"

    ^ spec
!

spec:something
    "set the value of the instance variable 'spec' (automatically generated)"

    spec := something.
!

view
    "return the value of the instance variable 'view' (automatically generated)"

    ^ view
!

view:something
    "set the value of the instance variable 'view' (automatically generated)"

    view := something.
! !

!UIPainterView::ViewProperty methodsFor:'initialization'!

initialize
    super initialize.
    identifier := Identifier
! !

!UIPainterView::ViewProperty methodsFor:'misc'!

extractNumberStartingAt:anIndex
    "return the number from the name starting at anIndex (or 0 if there is no number)."

    "/ cg: code cleanup.
    ^ Integer 
        readFrom:(self name readStream skip:(anIndex-1))
        onError:0

"/    |val|
"/
"/    val := 0.
"/
"/    self name from:anIndex do:[:c|
"/        c isDigit ifTrue:[val := val * 10 + c digitValue]
"/                 ifFalse:[^ 0]
"/    ].
"/    ^ val

    "
     (self basicNew spec:(ButtonSpec new name:'button12')) extractNumberStartingAt:7 
    "
! !

!UIPainterView::ViewProperty methodsFor:'spec messages'!

doesNotUnderstand:aMessage
    spec notNil ifTrue:[
        (spec respondsTo:(aMessage selector)) ifTrue:[^ aMessage sendTo:spec]
    ].
    ('[UIPainter::ViewProperty] warning: message ignored: ',aMessage selector) errorPrintCR.
    ^ nil
!

layout
    ^ spec layout
!

layout:aLayout
    spec layout:aLayout
!

name
    ^ spec name
!

name:aName
    spec name:aName
! !

!UIPainterView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


UIPainterView initialize!
