"
 COPYRIGHT (c) 1999 by eXept Software AG
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

WidgetSpec subclass:#ExtendedComboBoxSpec
	instanceVariableNames:'menuWidgetHolder menuWidget usePreferredWidthForMenu readOnly
		adjustRight menuHeight openAction autoHideScrollBars
		closeOnSelect hasHorizontalScrollBar hasVerticalScrollBar
		miniScrollerVertical miniScrollerHorizontal menuSelector
		performer'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ExtendedComboBoxSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


! !

!ExtendedComboBoxSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ExtendedComboBoxSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'ExtendedComboBox Basics'
         name: 'ExtendedComboBox Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 424 318)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'ComboBox'
             name: 'comboBoxFrame'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 176 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 5 0 3 1.0 27 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 41 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 30 0 3 1.0 52 0)
                   activeHelpKey: selectionHolder
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Adjust Button Right'
                   name: 'Adjust'
                   layout: (AlignmentOrigin 85 0 70 0 0 0.5)
                   tabable: true
                   model: adjustRight
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Read Only'
                   name: 'ReadOnly'
                   layout: (AlignmentOrigin 85 0 95 0 0 0.5)
                   tabable: true
                   model: readOnly
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Close Menu if Model changed'
                   name: 'closeOnSelect'
                   layout: (AlignmentOrigin 85 0 120 0 0 0.5)
                   tabable: true
                   model: closeOnSelect
                   translateLabel: true
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'menuSubSpec'
             layout: (LayoutFrame 0 0.0 179 0 0 1.0 294 0)
             majorKey: UISpecification
             minorKey: menuSubSpec
           )
          )
        
       )
     )
!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ExtendedComboBoxSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'ExtendedComboBoxSpec Channels'
         name: 'ExtendedComboBoxSpec Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 407 222)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'Channels'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 120 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 3 0.0 4 1.0 28 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 54 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (LabelSpec
                   label: 'Widget:'
                   name: 'widgetLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ComboBoxSpec
                   name: 'widgetField'
                   layout: (LayoutFrame 100 0 56 0 -15 1 78 0)
                   activeHelpKey: menuWidget
                   tabable: true
                   model: menuWidgetHolder
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 56 0 5 1 78 0)
                   activeHelpKey: menuWidget
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseActionMethod:
                   actionValue: menuWidgetHolder
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Callbacks'
             name: 'Callbacks'
             layout: (LayoutFrame 0 0.0 128 0.0 0 1.0 214 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (LabelSpec
                   label: 'Before Open:'
                   name: 'OpenLabel'
                   layout: (AlignmentOrigin 100 0 39 0 1 0.5)
                   activeHelpKey: beforeOpenAction
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ComboBoxSpec
                   name: 'OpenActionField'
                   layout: (LayoutFrame 100 0 27 0 -15 1 49 0)
                   activeHelpKey: beforeOpenAction
                   tabable: true
                   model: openAction
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfCallbacks
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button2'
                   layout: (LayoutFrame -15 1 27 0 5 1 49 0)
                   activeHelpKey: browseAction
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseActionMethod:
                   actionValue: openAction
                 )
                )
              
             )
           )
          )
        
       )
     )
!

menuEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ExtendedComboBoxSpec andSelector:#menuEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: menuEditSpec
       window: 
      (WindowSpec
         label: 'ExtendedComboBox Basics'
         name: 'ExtendedComboBox Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 429 374)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Widget'
             name: 'WidgetFrame'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 126 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Widget:'
                   name: 'WidgetLabel'
                   layout: (AlignmentOrigin 120 0 17 0 1 0.5)
                   activeHelpKey: widgetHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'WidgetInput'
                   layout: (LayoutFrame 120 0 5 0 3 1.0 27 0)
                   activeHelpKey: widgetHolder
                   tabable: true
                   model: menuWidget
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Max. Height:'
                   name: 'menuHeightLabel'
                   layout: (AlignmentOrigin 120 0 42 0 1 0.5)
                   activeHelpKey: maxMenuHeight
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'menuHeight'
                   layout: (LayoutFrame 120 0 30 0 3 1.0 52 0)
                   activeHelpKey: maxMenuHeight
                   tabable: true
                   model: menuHeight
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Use Preferred Width'
                   name: 'UsePreferredWidth'
                   layout: (AlignmentOrigin 85 0 70 0 0 0.5)
                   activeHelpKey: usePreferredWidth
                   tabable: true
                   model: usePreferredWidthForMenu
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Scroll Bars'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 133 0.0 0 1.0 270 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Vertical'
                   name: 'verticalScrollBarCheckBox'
                   layout: (Point 10 4)
                   activeHelpKey: verticalScroller
                   tabable: true
                   model: hasVerticalScrollBar
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Horizontal'
                   name: 'horizontalScrollBarCheckBox'
                   layout: (Point 165 4)
                   activeHelpKey: horizontalScroller
                   tabable: true
                   model: hasHorizontalScrollBar
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Mini'
                   name: 'miniScrollerVerticalCheckBox'
                   layout: (Point 10 29)
                   activeHelpKey: verticalMiniScroller
                   tabable: true
                   model: miniScrollerVertical
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Mini'
                   name: 'miniScrollerHorizontalCheckBox'
                   layout: (Point 165 29)
                   activeHelpKey: horizontalMiniScroller
                   tabable: true
                   model: miniScrollerHorizontal
                   translateLabel: true
                 )
                (DividerSpec
                   name: 'Separator1'
                   layout: (LayoutFrame 0 0.0 58 0 0 1.0 62 0)
                 )
                (CheckBoxSpec
                   label: 'Auto-Hide Scroll Bars'
                   name: 'AutoHideScrollBars'
                   layout: (Point 10 71)
                   activeHelpKey: autoHideScrollBarsBoolean
                   tabable: true
                   model: autoHideScrollBars
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ExtendedComboBoxSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self adaptApects:#( menuWidget
                        menuWidgetHolder
                        openAction
                        menuSelector 
                        performer
                      )
                  to:env 
                 for:anInstance 
             channel:aChannel
           converter:#symbolOrNil.

    self adaptApects:#( adjustRight
                        readOnly
                        closeOnSelect
                        usePreferredWidthForMenu 
                        autoHideScrollBars
                        hasHorizontalScrollBar
                        hasVerticalScrollBar
                        miniScrollerVertical
                        miniScrollerHorizontal
                      )
                  to:env 
                 for:anInstance 
             channel:aChannel.

    self adaptApects:#( menuHeight )
                  to:env 
                 for:anInstance 
             channel:aChannel
           converter:#numberOrNil.
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Menu     menuEditSpec)
            (Channels channelsEditSpec)
       )

! !

!ExtendedComboBoxSpec methodsFor:'accessing'!

adjustRight
    "return the value of the instance variable 'adjustRight' (automatically generated)"

    ^ adjustRight ? true
!

adjustRight:something
    "set the value of the instance variable 'adjustRight' (automatically generated)"

    adjustRight := something.
!

autoHideScrollBars
    ^ autoHideScrollBars ? true
!

autoHideScrollBars:aBool
    autoHideScrollBars := aBool
!

closeOnSelect
    ^ closeOnSelect ? true
!

closeOnSelect:aBoolean
    closeOnSelect := aBoolean.
!

hasHorizontalScrollBar
    ^ hasHorizontalScrollBar ? true
!

hasHorizontalScrollBar:aBool
    hasHorizontalScrollBar := aBool
!

hasVerticalScrollBar
    ^ hasVerticalScrollBar ? true
!

hasVerticalScrollBar:aBool
    hasVerticalScrollBar := aBool
!

menuHeight
    "return the value of the instance variable 'menuHeight' (automatically generated)"

    ^ menuHeight
!

menuHeight:something
    "set the value of the instance variable 'menuHeight' (automatically generated)"

    menuHeight := something.
!

menuSelector
    ^ menuSelector
!

menuSelector:something
    menuSelector := something
!

menuWidget
    "return the value of the instance variable 'menuWidget' (automatically generated)"

    ^ menuWidget
!

menuWidget:something
    "set the value of the instance variable 'menuWidget' (automatically generated)"

    menuWidget := something.
!

menuWidgetHolder
    "return the value of the instance variable 'menuWidgetHolder' (automatically generated)"

    ^ menuWidgetHolder
!

menuWidgetHolder:something
    "set the value of the instance variable 'menuWidgetHolder' (automatically generated)"

    menuWidgetHolder := something.
!

miniScrollerHorizontal
    ^ miniScrollerHorizontal ? true
!

miniScrollerHorizontal:aBool
    miniScrollerHorizontal := aBool
!

miniScrollerVertical
    ^ miniScrollerVertical ? false
!

miniScrollerVertical:aBool
    miniScrollerVertical := aBool
!

openAction
    "return the value of the instance variable 'openAction' (automatically generated)"

    ^ openAction
!

openAction:something
    "set the value of the instance variable 'openAction' (automatically generated)"

    openAction := something.
!

performer
    ^ performer
!

performer:something
    performer := something
!

readOnly
    "return the value of the instance variable 'readOnly' (automatically generated)"

    ^ readOnly ? true
!

readOnly:aBoolean
    "set the menuField to be readonly or writable"

    readOnly := aBoolean.
!

usePreferredWidthForMenu
    "return the value of the instance variable 'usePreferredWidthForMenu' (automatically generated)"

    ^ usePreferredWidthForMenu ? false
!

usePreferredWidthForMenu:something
    "set the value of the instance variable 'usePreferredWidthForMenu' (automatically generated)"

    usePreferredWidthForMenu := something.
! !

!ExtendedComboBoxSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    |tmp|

    super setAttributesIn:aView with:aBuilder.

    tmp := self adjustRight ifTrue:[#right] ifFalse:[#left].

    aView adjust:tmp.
    aView readOnly:(self readOnly).
    aView usePreferredWidthForMenu:(self usePreferredWidthForMenu).
    aView menuHeight:menuHeight.
    aView closeOnSelect:(self closeOnSelect).

    aBuilder isEditing ifTrue:[
        aView contents:aView name.
        aView disable.
    ] ifFalse:[
        aView autoHideScrollBars:(self autoHideScrollBars).
        aView hasHorizontalScrollBar:(self hasHorizontalScrollBar).
        aView hasVerticalScrollBar:(self hasVerticalScrollBar).
        aView miniScrollerVertical:(self miniScrollerVertical).
        aView miniScrollerHorizontal:(self miniScrollerHorizontal).

        openAction notNil ifTrue:[
            aView openAction:(self callBackActionFor:openAction with:aBuilder).
        ].

        menuWidgetHolder notNil ifTrue:[
            tmp := self getBindingIn:aBuilder binding:menuWidgetHolder.
            tmp notNil ifTrue:[
                aView menuWidgetHolder:tmp
            ]
        ].

        menuWidget notNil ifTrue:[
            tmp := (self getBindingIn:aBuilder binding:menuWidget).
            tmp notNil ifTrue:[
                aView menuWidget:tmp
            ]
        ].
        self setMenuIn:aView with:aBuilder.                             
    ]
! !

!ExtendedComboBoxSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    menuWidgetHolder   isNil       ifTrue:[l add:#menuWidgetHolder].
    openAction         isNil       ifTrue:[l add:#openAction].
    menuSelector       isNil       ifTrue:[l add:#menuSelector].
    performer          isNil       ifTrue:[l add:#performer].
    menuWidget         isNil       ifTrue:[l add:#menuWidget].
    menuHeight         isNil       ifTrue:[l add:#menuHeight].
    self usePreferredWidthForMenu ifFalse:[l add:#usePreferredWidthForMenu].
    self readOnly                  ifTrue:[l add:#readOnly].
    self adjustRight               ifTrue:[l add:#adjustRight].
    self closeOnSelect             ifTrue:[l add:#closeOnSelect].
    self autoHideScrollBars        ifTrue:[l add:#autoHideScrollBars].
    self hasHorizontalScrollBar    ifTrue:[l add:#hasHorizontalScrollBar].
    self hasVerticalScrollBar      ifTrue:[l add:#hasVerticalScrollBar].
    self miniScrollerVertical     ifFalse:[l add:#miniScrollerVertical].
    self miniScrollerHorizontal    ifTrue:[l add:#hasHorizontalScrollBar].

    ^ l
! !

!ExtendedComboBoxSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    menuHeight               := aView menuHeight.
    readOnly                 := aView readOnly.
    adjustRight              := aView adjust == #right.
    usePreferredWidthForMenu := aView usePreferredWidthForMenu.
    closeOnSelect            := aView closeOnSelect.

    autoHideScrollBars       := aView autoHideScrollBars.
    hasHorizontalScrollBar   := aView hasHorizontalScrollBar.
    hasVerticalScrollBar     := aView hasVerticalScrollBar.
    miniScrollerVertical     := aView miniScrollerVertical.
    miniScrollerHorizontal   := aView miniScrollerHorizontal.

    super fromView:aView callBack:aBlock.
! !

!ExtendedComboBoxSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    menuWidget notNil ifTrue:[more add:menuWidget].
    openAction notNil ifTrue:[more add:openAction].
    ^ more

    "Modified: / 10.2.2000 / 01:25:48 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    menuWidgetHolder notNil ifTrue:[more add:menuWidgetHolder].
    ^ more

    "Modified: / 10.2.2000 / 01:25:03 / cg"
! !

!ExtendedComboBoxSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ExtendedComboBoxSpec.st,v 1.31 2017-01-20 16:21:10 cg Exp $'
! !

