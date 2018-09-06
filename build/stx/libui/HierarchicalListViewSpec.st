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

SelectionInListModelViewSpec subclass:#HierarchicalListViewSpec
	instanceVariableNames:'showLines showIndicators showLeftIndicators indicatorSelector
		retrieveIconsSelector useDefaultIcons autoScrollHorizontal
		showRoot'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!HierarchicalListViewSpec class methodsFor:'documentation'!

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

!HierarchicalListViewSpec class methodsFor:'interface specs'!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HierarchicalListViewSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Channels'
         name: 'SequenceView Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 429 377)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 120 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 1 0.0 4 1.0 26 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification7'
                   layout: (LayoutFrame 0 0.0 27 0.0 4 1.0 52 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 53 0.0 4 1.0 78 0)
                   majorKey: UISpecification
                   minorKey: subSpecForDoubleClickChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Callbacks'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 121 0.0 0 1.0 294 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification8'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 30 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification5'
                   layout: (LayoutFrame 0 0.0 36 0.0 4 1.0 64 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectConditionCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 61 0.0 4 1.0 89 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectedValueChangeCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification6'
                   layout: (LayoutFrame 0 0.0 86 0.0 4 1.0 114 0)
                   majorKey: UISpecification
                   minorKey: subSpecForDoubleClickCallBack
                 )
                (LabelSpec
                   label: 'Indicator:'
                   name: 'indicatorLabel'
                   layout: (AlignmentOrigin 100 0 123 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'indicatorField'
                   layout: (LayoutFrame 100 0 112 0 4 1 134 0)
                   activeHelpKey: indicatorClickSelector
                   tabable: true
                   model: indicatorSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Fetch Keys & Icons'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 295 0.0 0 1.0 360 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Resource:'
                   name: 'resourcesLabel'
                   layout: (AlignmentOrigin 100 0 15 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'resourcesField'
                   layout: (LayoutFrame 100 0 4 0 4 1 26 0)
                   activeHelpKey: resourceSelector
                   tabable: true
                   model: retrieveIconsSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          )
        
       )
     )
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HierarchicalListViewSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Details'
         name: 'SequenceView Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 435 388)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'detailsEditSpec'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 167 0)
             majorKey: ListModelViewSpec
             minorKey: detailsEditSpec
           )
          (FramedBoxSpec
             label: 'Selection Attributes'
             name: 'SelectionAttributes'
             layout: (LayoutFrame 0 0.0 170 0.0 0 1.0 266 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Highlight:'
                   name: 'highlightLabel'
                   layout: (AlignmentOrigin 125 0 15 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (ComboListSpec
                   name: 'highlightMode'
                   layout: (LayoutFrame 126 0 6 0 259 0 25 0)
                   activeHelpKey: highlightMode
                   tabable: true
                   model: highlightMode
                   comboList: highlightModeList
                   useIndex: false
                   hidePullDownMenuButton: false
                 )
                (LabelSpec
                   label: 'Auto Scroll Horizontal:'
                   name: 'autoScrollHorizontalLabel'
                   layout: (AlignmentOrigin 180 0 43 0 1 0.5)
                   activeHelpKey: autoScrollHorizontal
                   translateLabel: true
                   adjust: left
                 )
                (PopUpListSpec
                   label: 'Default'
                   name: 'autoScrollHorizontalPopUpList'
                   layout: (AlignmentOrigin 180 0 44 0 0 0.5)
                   activeHelpKey: autoScrollHorizontal
                   translateLabel: true
                   tabable: true
                   model: autoScrollHorizontalIdx
                   menu: autoScrollHorizontalList
                   useIndex: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Drawing Attributes'
             name: 'Drawing Box'
             layout: (LayoutFrame 0 0.0 267 0 0 1.0 388 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Show Lines'
                   name: 'showLines'
                   layout: (Point 10 1)
                   activeHelpKey: showLines
                   tabable: true
                   model: showLines
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Show Indicators'
                   name: 'showIndicators'
                   layout: (Point 147 1)
                   activeHelpKey: showIndicators
                   tabable: true
                   model: showIndicators
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Default Icons'
                   name: 'useDefaultIcons'
                   layout: (Point 10 28)
                   activeHelpKey: useDefaultIcons
                   tabable: true
                   model: useDefaultIcons
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Show Left Indicator'
                   name: 'ShowLeftIndicators'
                   layout: (Point 147 28)
                   activeHelpKey: showDirectoryIndicatorForRoot
                   tabable: true
                   model: showLeftIndicators
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Show Root of Tree'
                   name: 'CheckBox1'
                   layout: (Point 10 55)
                   activeHelpKey: useDefaultIcons
                   tabable: true
                   model: showRoot
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!HierarchicalListViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    |hideIdx|

    super addBindingsTo:env for:inst channel:aChannel.

    self adaptApects:#( 
                        showLines 
                        showRoot
                        showIndicators 
                        showLeftIndicators 
                        useDefaultIcons 
                        autoScrollHorizontal )
                  to:env 
                 for:inst 
             channel:aChannel.

    self adaptApects:#( indicatorSelector retrieveIconsSelector )
                  to:env 
                 for:inst 
             channel:aChannel
           converter:#symbolOrNil.

    hideIdx := (#(nil true false) indexOf:(env at:#autoScrollHorizontal) value) asValue.
    env at:#autoScrollHorizontalIdx put:hideIdx.
    hideIdx
        onChangeEvaluate:[ (env at:#autoScrollHorizontal) value:(#(nil true false) at:hideIdx value).
                           "(env at:#modifiedChannel)  value:true" ].
    env at:#autoScrollHorizontalList put:#('Default' 'On' 'Off')
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics             basicsEditSpec)
            (Details1           detailsEditSpec)
            (Details2           details2EditSpec)
            (Channels           channelsEditSpec)
            ('Drag && Drop'      dragAndDropSpec)
       )

! !

!HierarchicalListViewSpec methodsFor:'accessing'!

autoScrollHorizontal
    ^ autoScrollHorizontal
!

autoScrollHorizontal:aBoolean
    autoScrollHorizontal := aBoolean.
!

indicatorSelector
    ^ indicatorSelector
!

indicatorSelector:something
    indicatorSelector := something.
!

retrieveIconsSelector
    ^ retrieveIconsSelector
!

retrieveIconsSelector:something
    retrieveIconsSelector := something.
!

showIndicators
    ^ showIndicators ? true
!

showIndicators:aBoolean
    showIndicators := aBoolean.
!

showLeftIndicators
    ^ showLeftIndicators ? true
!

showLeftIndicators:aBoolean
    showLeftIndicators := aBoolean.
!

showLines
    ^ showLines ? true
!

showLines:aBoolean
    showLines := aBoolean.
!

showRoot
    ^ showRoot ? true
!

showRoot:aBoolean
    showRoot := aBoolean.
!

useDefaultIcons
    ^ useDefaultIcons ? true
!

useDefaultIcons:aBoolean
    useDefaultIcons := aBoolean.
! !

!HierarchicalListViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"
    |icons|

    aView showLines:(self showLines).
    aView showIndicators:(self showIndicators).
    aView showLeftIndicators:(self showLeftIndicators).
    aView showRoot:(self showRoot).
    aView useDefaultIcons:(self useDefaultIcons).
    autoScrollHorizontal notNil ifTrue:[aView autoScrollHorizontal:autoScrollHorizontal].

    aBuilder isEditing ifFalse:[                 
        indicatorSelector notNil ifTrue:[
            aView indicatorAction:(self callBackActionFor:indicatorSelector with:aBuilder).
        ].
        retrieveIconsSelector notNil ifTrue:[
            icons := self getBindingIn:aBuilder binding:retrieveIconsSelector.
            aView registerKeysAndIcons:icons.
        ]
    ].
    super setAttributesIn:aView with:aBuilder.
! !

!HierarchicalListViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self showRoot               ifTrue:[ l add:#showRoot ].
    self showLines              ifTrue:[ l add:#showLines ].
    self showIndicators         ifTrue:[ l add:#showIndicators ].
    self showLeftIndicators     ifTrue:[ l add:#showLeftIndicators].
    self useDefaultIcons        ifTrue:[ l add:#useDefaultIcons].
    self autoScrollHorizontal isNil   ifTrue:[ l add:#autoScrollHorizontal].
    indicatorSelector     isNil ifTrue:[ l add:#indicatorSelector ].
    retrieveIconsSelector isNil ifTrue:[ l add:#retrieveIconsSelector ].
    ^ l
! !

!HierarchicalListViewSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    showRoot             := aView showRoot.
    showLines            := aView showLines.
    showLeftIndicators   := aView showLeftIndicators.
    showIndicators       := aView showIndicators.
    useDefaultIcons      := aView useDefaultIcons.
    autoScrollHorizontal := aView autoScrollHorizontal.

    super fromView:aView callBack:aBlock
! !

!HierarchicalListViewSpec methodsFor:'queries'!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator
    "
    ^ someAspect == listModel 
        ifTrue:[HierarchicalList]
        ifFalse:[super defaultModelClassFor:someAspect]
! !

!HierarchicalListViewSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    indicatorSelector     notNil ifTrue:[more add:indicatorSelector].
    retrieveIconsSelector notNil ifTrue:[more add:retrieveIconsSelector].
    ^ more

    "Modified: / 10.2.2000 / 01:25:51 / cg"
! !

!HierarchicalListViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitHierarchicalListViewSpec:self
! !

!HierarchicalListViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/HierarchicalListViewSpec.st,v 1.31 2015-11-19 13:53:15 cg Exp $'
! !

