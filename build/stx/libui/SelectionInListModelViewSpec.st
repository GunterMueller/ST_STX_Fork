"{ Encoding: utf8 }"

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

ListModelViewSpec subclass:#SelectionInListModelViewSpec
	instanceVariableNames:'multipleSelectOk useIndex highlightMode doubleClickSelector
		valueChangeSelector selectConditionSelector ignoreReselect
		doubleClickChannel selectOnMenuButton'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SelectionInListModelViewSpec class methodsFor:'documentation'!

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

!SelectionInListModelViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SelectionInListModelViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Basics'
         name: 'SequenceView Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 398 336)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 120 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 18 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 7 0 5 1.0 29 0)
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
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 32 0 5 1.0 54 0)
                   activeHelpKey: selectionHolder
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'List:'
                   name: 'listLabel'
                   layout: (AlignmentOrigin 100 0 68 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'listField'
                   layout: (LayoutFrame 100 0.0 58 0 -70 1.0 80 0)
                   activeHelpKey: listHolder
                   tabable: true
                   model: listModel
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Index'
                   name: 'useIndexCheckBox'
                   layout: (AlignmentOrigin 6 1.0 70 0 1 0.5)
                   activeHelpKey: useIndex
                   tabable: true
                   model: useIndex
                   translateLabel: true
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'menuSubSpec'
             layout: (LayoutFrame 0 0.0 123 0 0 1.0 238 0)
             majorKey: UISpecification
             minorKey: menuSubSpec
           )
          (UISubSpecification
             name: 'scrollerSubSpec'
             layout: (LayoutFrame 0 0.0 242 0 0 1.0 345 0)
             majorKey: UISpecification
             minorKey: scrollerSubSpec
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
     UIPainter new openOnClass:SelectionInListModelViewSpec andSelector:#channelsEditSpec
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
         bounds: (Rectangle 0 0 428 271)
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
             layout: (LayoutFrame 0 0.0 121 0.0 0 1.0 276 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 30 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification5'
                   layout: (LayoutFrame 0 0.0 40 0.0 4 1.0 68 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectConditionCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 66 0.0 4 1.0 94 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectedValueChangeCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification6'
                   layout: (LayoutFrame 0 0.0 92 0.0 4 1.0 120 0)
                   majorKey: UISpecification
                   minorKey: subSpecForDoubleClickCallBack
                 )
                )
              
             )
           )
          )
        
       )
     )
!

details2EditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SelectionInListModelViewSpec andSelector:#details2EditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: details2EditSpec
       window: 
      (WindowSpec
         label: 'ListDetails2'
         name: 'ListDetails2'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 449 284)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Selection Attributes'
             name: 'Selection Attributes'
             layout: (LayoutFrame 0 0.0 4 0 0 1.0 123 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Allow Multiple Selections'
                   name: 'multipleSelectOk'
                   layout: (Point 10 1)
                   activeHelpKey: isMultiSelect
                   tabable: true
                   model: multipleSelectOk
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Ignore Reselect'
                   name: 'allowReselectCheckBox'
                   layout: (Point 10 28)
                   activeHelpKey: ignoreReselect
                   tabable: true
                   model: ignoreReselect
                   translateLabel: true
                   resizeForLabel: true
                 )
                (LabelSpec
                   label: 'Select Item before Opening the Menu:'
                   name: 'selectOnButtonMenuLabel'
                   layout: (Point 10 62)
                   activeHelpKey: selectOnMenuButton
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (PopUpListSpec
                   label: 'Default'
                   name: 'selectOnButtonMenuList'
                   layout: (LayoutFrame 296 0 59 0 0 1.0 81 0)
                   activeHelpKey: selectOnMenuButton
                   translateLabel: true
                   tabable: true
                   model: selectOnMenuButtonIdx
                   menu: selectOnMenuButtonList
                   useIndex: true
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'InitAttributes'
             layout: (LayoutFrame 0 0.0 126 0 0 1.0 191 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'Keyboard Attributes'
             layout: (LayoutFrame 0 0.0 193 0 0 1.0 280 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabableCheckBox'
                   layout: (Point 10 -1)
                   activeHelpKey: tabable
                   tabable: true
                   model: tabable
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Has Initial Focus'
                   name: 'hasInitialFocusCheckBox'
                   layout: (LayoutFrame 10 0 26 0 175 0 53 0)
                   activeHelpKey: hasKeyboardFocusInitially
                   tabable: true
                   model: hasKeyboardFocusInitially
                   translateLabel: true
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
     UIPainter new openOnClass:SelectionInListModelViewSpec andSelector:#detailsEditSpec
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
         bounds: (Rectangle 0 0 403 232)
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
             layout: (LayoutFrame 0 0.0 170 0.0 0 1.0 234 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Highlight:'
                   name: 'highlightLabel'
                   layout: (AlignmentOrigin 100 0 15 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (ComboListSpec
                   name: 'highlightMode'
                   layout: (LayoutFrame 100 0 6 0 262 0 25 0)
                   activeHelpKey: highlightMode
                   tabable: true
                   model: highlightMode
                   comboList: highlightModeList
                   useIndex: false
                   hidePullDownMenuButton: false
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!SelectionInListModelViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    |idx|

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:#( 
            multipleSelectOk 
            useIndex 
            ignoreReselect 
            selectOnMenuButton )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:#( 
            doubleClickChannel 
            selectConditionSelector 
            doubleClickSelector 
            valueChangeSelector 
            highlightMode )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    env at:#highlightModeList put:(ValueHolder with:#( line label )).

    idx := (#(nil true false) indexOf:(env at:#selectOnMenuButton) value) asValue.
    env at:#selectOnMenuButtonIdx put:idx.
    idx onChangeEvaluate:[ (env at:#selectOnMenuButton) value:(#(nil true false) at:idx value) ].

    env at:#selectOnMenuButtonList put:#('Default' 'On' 'Off')
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

!SelectionInListModelViewSpec class methodsFor:'queries'!

supportsDrag
    ^ true


!

supportsDrop
    ^ true


! !

!SelectionInListModelViewSpec methodsFor:'accessing'!

doubleClickSelector
    "return the value of the instance variable 'doubleClickSelector' (automatically generated)"

    ^ doubleClickSelector
!

doubleClickSelector:something
    "set the value of the instance variable 'doubleClickSelector' (automatically generated)"

    doubleClickSelector := something.
!

highlightMode
    "return the value of the instance variable 'highlightMode' (automatically generated)"

    ^ highlightMode ? #line
!

highlightMode:something
    "set the value of the instance variable 'highlightMode' (automatically generated)"

    highlightMode := something.
!

ignoreReselect
    "controls if clicking on an already selected item should
     be ignored or should perform the select action again.
     By default, these are ignored"

    ^ ignoreReselect ? true
!

ignoreReselect:something
    "controls if clicking on an already selected item should
     be ignored or should perform the select action again.
     By default, these are ignored"

    ignoreReselect := something
!

multipleSelectOk
    "return the value of the instance variable 'multipleSelectOk' (automatically generated)"

    ^ multipleSelectOk ? false
!

multipleSelectOk:something
    "set the value of the instance variable 'multipleSelectOk' (automatically generated)"

    multipleSelectOk := something
!

selectConditionSelector
    "return the value of the instance variable 'selectConditionSelector' (automatically generated)"

    ^ selectConditionSelector
!

selectConditionSelector:something
    "set the value of the instance variable 'selectConditionSelector' (automatically generated)"

    selectConditionSelector := something.
!

selectOnButtomMenu
    <resource: #obsolete>
    self obsoleteMethodWarning:'use selectOnMenuButton'.
    ^ self selectOnMenuButton
!

selectOnButtomMenu:something
    <resource: #obsolete>
    self obsoleteMethodWarning:'use selectOnMenuButton:'.
    ^ self selectOnMenuButton:something
!

selectOnButtonMenu
    <resource: #obsolete>
    self obsoleteMethodWarning:'use selectOnMenuButton'.
    ^ self selectOnMenuButton
!

selectOnButtonMenu:something
    <resource: #obsolete>
    self obsoleteMethodWarning:'use selectOnMenuButton:'.
    self selectOnMenuButton:something
!

selectOnMenuButton
    "defines the menu-button (middle button) press behavior; 
     if true, the line under the mouse
     will be selected before the menu is opened (Windows behavior). 
     Otherwise the selection is unchanged and the menu is opened 
     for the current selection (Unix behavior)."

    ^ selectOnMenuButton

    "Modified (comment): / 28-05-2018 / 10:13:51 / Claus Gittinger"
!

selectOnMenuButton:aBoolean
    "defines the menu-button (middle button) press behavior; 
     if true, the line under the mouse
     will be selected before the menu is opened (Windows behavior). 
     Otherwise the selection is unchanged and the menu is opened 
     for the current selection (Unix behavior)."

    selectOnMenuButton := aBoolean

    "Modified (comment): / 28-05-2018 / 10:14:05 / Claus Gittinger"
!

useIndex
    "return the value of the instance variable 'useIndex' (automatically generated)"

    ^ useIndex ? true
!

useIndex:something
    "set the value of the instance variable 'useIndex' (automatically generated)"

    useIndex := something
!

valueChangeSelector
    "return the value of the instance variable 'valueChangeSelector' (automatically generated)"

    ^ valueChangeSelector
!

valueChangeSelector:something
    "set the value of the instance variable 'valueChangeSelector' (automatically generated)"

    valueChangeSelector := something.
! !

!SelectionInListModelViewSpec methodsFor:'accessing-channels'!

doubleClickChannel
    ^ doubleClickChannel

    "Modified: / 25-10-2010 / 12:28:54 / cg"
!

doubleClickChannel:something
    doubleClickChannel := something.

    "Modified: / 25-10-2010 / 12:58:59 / cg"
! !

!SelectionInListModelViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |list item child img1 img2 dblClickCallBack dblClickChannel dblClickAction|

    super setAttributesIn:aView with:aBuilder.
    aView multipleSelectOk:(self multipleSelectOk).
    aView ignoreReselect:(self ignoreReselect).
    aView useIndex:(self useIndex).
    aView highlightMode:(self highlightMode).

    selectOnMenuButton notNil ifTrue:[
        aView selectOnMenuButton:selectOnMenuButton
    ].

    aBuilder isEditing ifTrue:[
        list := HierarchicalList new.
        img1 := ResourceSelectionBrowser iconPrivateClass.
        img2 := ResourceSelectionBrowser iconCategory.
        item := HierarchicalItemWithLabelAndIcon new
                    children:#();
                    labeled:(Text string:'Alternative List/Tree') icon:img1.
        child := HierarchicalItemWithLabelAndIcon new 
                    children:#();
                    labeled:(Array with:'Child 1' with:img1)  icon:img1.
        item add:child.
        child := HierarchicalItemWithLabelAndIcon new 
                    children:#();
                    labeled:(Array with:img1 with:'Child 2' with:img2) icon:img2.
        item add:child.
        item expand.
        list root:item.
        aView list:list.
        ^ self
    ].

    aView model:(self getBindingIn:aBuilder binding:(self model)).
    valueChangeSelector notNil ifTrue:[
        aView action:(self callBackActionFor:valueChangeSelector with:aBuilder).
    ].
    selectConditionSelector notNil ifTrue:[
        aView selectConditionBlock:(self callBackActionFor:selectConditionSelector with:aBuilder).
    ].
    doubleClickSelector notNil ifTrue:[
        dblClickAction := self callBackActionFor:doubleClickSelector with:aBuilder.
    ].

    doubleClickChannel notNil ifTrue:[
        dblClickChannel := self getBindingIn:aBuilder binding:doubleClickChannel.

        dblClickChannel notNil ifTrue:[
            dblClickAction notNil ifTrue:[
                dblClickCallBack := dblClickAction.

                dblClickAction := [:arg | dblClickChannel  value:arg.
                                          dblClickCallBack value:arg.
                                  ].
            ] ifFalse:[
                dblClickAction := [:arg | dblClickChannel value:arg]
            ]
        ]
    ].
    aView doubleClickAction:dblClickAction.
! !

!SelectionInListModelViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self multipleSelectOk         ifFalse:[ l add:#multipleSelectOk ].
    self ignoreReselect            ifTrue:[ l add:#ignoreReselect ].
    self useIndex                  ifTrue:[ l add:#useIndex].
    doubleClickSelector     isNil  ifTrue:[ l add:#doubleClickSelector ].
    valueChangeSelector     isNil  ifTrue:[ l add:#valueChangeSelector ].
    selectConditionSelector isNil  ifTrue:[ l add:#selectConditionSelector ].
    doubleClickChannel      isNil  ifTrue:[ l add:#doubleClickChannel ].
    selectOnMenuButton      isNil  ifTrue:[ l add:#selectOnMenuButton ].

    ^ l
! !

!SelectionInListModelViewSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    useIndex           := aView useIndex.
    multipleSelectOk   := aView multipleSelectOk.
    highlightMode      := aView highlightMode.
    ignoreReselect     := aView ignoreReselect.

    super fromView:aView callBack:aBlock
! !

!SelectionInListModelViewSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.

    doubleClickSelector     notNil ifTrue:[more add:doubleClickSelector].
    valueChangeSelector     notNil ifTrue:[more add:valueChangeSelector].
    selectConditionSelector notNil ifTrue:[more add:selectConditionSelector].

    ^ more

    "Modified: / 10.2.2000 / 01:25:53 / cg"
! !

!SelectionInListModelViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitSelectionInListModelViewSpec:self
! !

!SelectionInListModelViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SelectionInListModelViewSpec.st,v 1.40 2018-05-28 08:15:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/SelectionInListModelViewSpec.st,v 1.40 2018-05-28 08:15:55 cg Exp $'
! !

