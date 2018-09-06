"{ Encoding: utf8 }"

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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ViewSpec subclass:#VariablePanelSpec
	instanceVariableNames:'handles barWidth showHandle snapMode handlePosition barLevel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!VariablePanelSpec class methodsFor:'documentation'!

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
    Not normally used by applications.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"





! !

!VariablePanelSpec class methodsFor:'interface specs'!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VariablePanelSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'View Details'
         name: 'View Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 492 287)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 212 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'BGColorLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'BGColorMenu'
                   layout: (LayoutFrame 100 0 8 0 5 1.0 30 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Border:'
                   name: 'BorderLabel'
                   layout: (AlignmentOrigin 110 0 52 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'BorderWidthField'
                   layout: (LayoutFrame 111 0 39 0 141 0 65 0)
                   activeHelpKey: borderWidth
                   tabable: true
                   model: borderWidth
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'LevelLabel'
                   layout: (AlignmentOrigin 246 0 53 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'LevelField'
                   layout: (LayoutFrame 247 0 39 0 287 0 65 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (DividerSpec
                   name: 'Separator1'
                   layout: (LayoutFrame 0 0.0 67 0 0 1.0 71 0)
                 )
                (LabelSpec
                   label: 'Bar Width:'
                   name: 'BarWidthLabel'
                   layout: (AlignmentOrigin 110 0 90 0 1 0.5)
                   activeHelpKey: barWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'BarWidthField'
                   layout: (LayoutFrame 110 0 76 0 140 0 102 0)
                   activeHelpKey: barWidth
                   tabable: true
                   model: barWidth
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Bar Level:'
                   name: 'BarLevelLabel'
                   layout: (AlignmentOrigin 244 0 90 0 1 0.5)
                   activeHelpKey: barLevel
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'BarLevelField'
                   layout: (LayoutFrame 246 0 76 0 286 0 102 0)
                   activeHelpKey: barLevel
                   tabable: true
                   model: barLevel
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Show Handles:'
                   name: 'ShowHandlesLabel'
                   layout: (LayoutFrame -2 0 114 0 140 0 133 0)
                   activeHelpKey: showHandle
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'Default'
                   name: 'ShowHandlesPopUpList'
                   layout: (LayoutFrame 140 0 114 0 223 0 133 0)
                   activeHelpKey: showHandle
                   translateLabel: true
                   resizeForLabel: true
                   adjust: center
                   tabable: true
                   model: showHandleIdx
                   menu: showHandleList
                   useIndex: true
                 )
                (LabelSpec
                   label: 'Position:'
                   name: 'HandlePositionLabel'
                   layout: (AlignmentOrigin 317 0 124 0 1 0.5)
                   activeHelpKey: handlePosition
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'Default'
                   name: 'HandlePositionPopUpList'
                   layout: (AlignmentOrigin 317 0 124 0 0 0.5)
                   activeHelpKey: handlePosition
                   translateLabel: true
                   resizeForLabel: true
                   adjust: center
                   tabable: true
                   model: handlePositionIdx
                   menu: handlePositionList
                   useIndex: true
                 )
                (LabelSpec
                   label: 'Snap Mode:'
                   name: 'SnapLabel'
                   layout: (LayoutFrame -2 0 145 0 140 0 167 0)
                   activeHelpKey: snapMode
                   translateLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'none'
                   name: 'SnapModePopUpList'
                   layout: (LayoutFrame 140 0 145 0 350 0 166 0)
                   activeHelpKey: snapMode
                   translateLabel: true
                   resizeForLabel: true
                   tabable: true
                   model: snapModeIdx
                   menu: snapModeList
                   useIndex: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 212 0 0 1.0 280 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (Point 15 3)
                   activeHelpKey: initiallyInvisible
                   tabable: true
                   model: initiallyInvisible
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!VariablePanelSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    |showHandleIdx snapModeIdx handlePositionIdx|

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        barWidth
                        barLevel
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    self 
        adaptApects:
                    #(  
                        showHandle
                        handlePosition
                        snapMode
                     )
        to:env 
        for:inst 
        channel:aChannel.

    handlePositionIdx := (#(nil #left #center #right) indexOf:(env at:#handlePosition) value) asValue.
    env at:#handlePositionIdx put:handlePositionIdx.
    handlePositionIdx
        onChangeEvaluate:[ (env at:#handlePosition) value:(#(nil #left #center #right) at:handlePositionIdx value).].
    env at:#handlePositionList put:#('Default' 'Left' 'Center' 'Right').

    showHandleIdx := (#(nil true false) indexOf:(env at:#showHandle) value) asValue.
    env at:#showHandleIdx put:showHandleIdx.
    showHandleIdx
        onChangeEvaluate:[ (env at:#showHandle) value:(#(nil true false) at:showHandleIdx value).
                           "(env at:#modifiedChannel)  value:true" ].
    env at:#showHandleList put:#('Default' 'On' 'Off').

    snapModeIdx := (#(nil #min #max #minMax #maxMin #both) indexOf:(env at:#snapMode) value) asValue.
    env at:#snapModeIdx put:snapModeIdx.
    snapModeIdx
        onChangeEvaluate:[ (env at:#snapMode) value:(#(nil #min #max #minMax #maxMin #both) at:snapModeIdx value).
                           "(env at:#modifiedChannel)  value:true" ].
    env at:#snapModeList put:#('none' 'to min' 'to max' 'alternating min/max' 'alternating max/min' 'allow both')
! !

!VariablePanelSpec class methodsFor:'queries'!

canResizeSubComponents
    "answer whether included sub components can be resized or are handled by the view itself"

    ^ false

!

isLayoutContainer
    "answer whether corresponding view instances of the spec class can contain (and arrange) other view"

    ^ true


!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ true


! !

!VariablePanelSpec methodsFor:'accessing'!

barLevel
    ^ barLevel
!

barLevel:something
    barLevel := something.
!

barWidth
    "return the value of the instance variable 'barWidth' (automatically generated)"

    ^ barWidth

    "Created: / 30.1.2000 / 22:19:51 / cg"
!

barWidth:something
    "set the value of the instance variable 'barWidth' (automatically generated)"

    barWidth := something.

    "Created: / 30.1.2000 / 22:19:51 / cg"
!

handlePosition
    "return the value of the instance variable 'handlePosition' (automatically generated)"

    ^ handlePosition
!

handlePosition:something
    "set the value of the instance variable 'handlePosition' (automatically generated)"

    handlePosition := something.
!

handles
    "return the value of the instance variable 'handles' (automatically generated)"

    ^ handles
!

handles:aCollectionOfRelativeFrations
    "set the initial handle positions"

    handles := aCollectionOfRelativeFrations.

    "Modified (comment): / 11-02-2017 / 16:54:00 / cg"
!

showHandle
    "return the value of the instance variable 'showHandle' (automatically generated)"

    ^ showHandle
!

showHandle:something
    "set the value of the instance variable 'showHandle' (automatically generated)"

    showHandle := something.
!

snapMode
    "return the value of the instance variable 'snapMode' (automatically generated)"

    ^ snapMode
!

snapMode:something
    "set the value of the instance variable 'snapMode' (automatically generated)"

    snapMode := something.
! !

!VariablePanelSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    barWidth notNil ifTrue:[aView setBarHeight:barWidth].
    barLevel notNil ifTrue:[aView barLevel:barLevel].
    (showHandle notNil or:[aBuilder isEditing]) ifTrue:[aView showHandle:showHandle].
    (handlePosition notNil or:[aBuilder isEditing]) ifTrue:[aView handlePosition:handlePosition].
    aView snapMode:snapMode.
    super setAttributesIn:aView with:aBuilder.

    "Created: / 30.1.2000 / 22:22:14 / cg"
    "Modified: / 30.1.2000 / 22:32:20 / cg"
!

setLayoutsInLayoutContainer:aPanel
    |x y subs isVertical fractionPart|

    (subs := aPanel subViews) notEmptyOrNil ifTrue:[
        handles size == subs size ifFalse:[
            handles size == (subs size - 1) ifTrue:[
                handles := handles copyWith:1.0
            ] ifFalse:[        
                "/ fix it; spread them evenly
                fractionPart := (1 / subs size).
                handles := (fractionPart to:1 by:fractionPart) asArray.
                handles := handles collect:[:each | each asFixedPoint:2].
            ]
        ].
        
        isVertical := self isVertical.
        y := x := 0.0.

        subs with:handles do:[:eachView :eachHandle|
            |handle|
            
            handle := eachHandle.
            
            handle isFloat ifFalse:[ handle := handle asFloat ].
            handle < 0 ifTrue:[ handle := 0.0 ].
            handle > 1 ifTrue:[ handle := 1.0 ].
            isVertical ifTrue:[
                eachView relativeOrigin:(0.0 @ y).
                y := handle max:y.
                eachView relativeCorner:(1.0 @ y).
            ] ifFalse:[
                eachView relativeOrigin:(x @ 0.0).
                x := handle max:x.
                eachView relativeCorner:(x @ 1.0).
            ]
        ]
    ]

    "Modified: / 12-02-2017 / 00:25:27 / cg"
! !

!VariablePanelSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.
    handles notNil ifTrue:[
        handles := handles asOrderedCollection.
        handles removeFirst.
    ].
!

otherAttributesLiteralArrayEncoding:aColl
    |size array|

    (size := handles size) ~~ 0 ifTrue:[
        array := #( Any ) , handles asArray.
"/        array := Array new:(size + 1).
"/        array replaceFrom:2 to:(size + 1) with:handles startingAt:1.
"/        array at:1 put:#Any.
        
        aColl add:#handles:.
        aColl add:array
    ].
    ^ super otherAttributesLiteralArrayEncoding:aColl
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |skipped|

    skipped := super skippedInLiteralEncoding.

    skipped add:#handles.
    barWidth isNil ifTrue:[skipped add:#barWidth].
    barLevel isNil ifTrue:[skipped add:#barLevel].
    showHandle isNil ifTrue:[skipped add:#showHandle].
    handlePosition isNil ifTrue:[skipped add:#handlePosition].
    snapMode isNil ifTrue:[skipped add:#snapMode].
    ^ skipped

    "Modified: / 30-01-2000 / 22:20:14 / cg"
    "Modified (comment): / 09-08-2018 / 17:17:24 / Claus Gittinger"
! !

!VariablePanelSpec methodsFor:'parsing a view'!

componentFromView:aPanel callBack:aBlock
    |subs|

    (subs := aPanel subViews) isNil ifTrue:[
        ^ self
    ].
    component := SpecCollection new fromViews:subs callBack:aBlock.

    component collection "with:subs" do:[:aSubSpec ":v" |
        aSubSpec layout:nil.
    ].
    handles := self recomputeHandlesFrom:aPanel.
!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    barWidth := aView perform:#barWidth ifNotUnderstood:nil.
    barLevel := aView perform:#barLevel ifNotUnderstood:nil.
    showHandle:= aView showHandle.
    handlePosition:= aView handlePosition.
    snapMode:= aView snapMode.
    super fromView:aView callBack:aBlock

    "Created: / 30.1.2000 / 22:21:07 / cg"
!

layoutFromView:aPanel
    super layoutFromView:aPanel.
    handles := self recomputeHandlesFrom:aPanel.
!

recomputeHandlesFrom:aPanel
    |subs isVertical|

    (subs := aPanel subViews) notNil ifTrue:[
        isVertical := self isVertical.
        ^ (subs 
            collect:[:v | 
                |rel h|
                rel := v relativeCorner. 
                isVertical ifTrue:[ h := rel y] ifFalse:[ h := rel x ].
                "/ I don't like these 9 digit precision numbers in the specs...
                h roundTo:0.01.
            ]
            as:Array)
    ].
    ^ nil
! !

!VariablePanelSpec methodsFor:'queries'!

isVertical
    self subclassResponsibility.
    ^ true
!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^self class userFriendlyName



! !

!VariablePanelSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/VariablePanelSpec.st,v 1.36 2018-08-09 15:19:15 cg Exp $'
! !

