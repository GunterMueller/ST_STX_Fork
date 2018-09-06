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

ViewWithScrollerSpec subclass:#SelectionInTreeViewSpec
	instanceVariableNames:'showLines showRoot showDirectoryIndicatorForRoot
		showDirectoryIndicator isMultiSelect valueChangeSelector
		doubleClickSelector hierarchicalList validateDoubleClickSelector
		validateExpandabilitySelector selectConditionSelector
		contentsSelector labelSelector childrenSelector iconSelector
		highlightMode supportsExpandAll doubleClickChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SelectionInTreeViewSpec class methodsFor:'documentation'!

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

!SelectionInTreeViewSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'SelectionInTreeViewSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@DUUUUU0A@@@@BBD***+H@R???4 AKC??RMD/@@MH@R<??4 AK0@CRAD/O?=H@R<@@4 !!K???R@D5UUUH@P@@@@#S*****@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!SelectionInTreeViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SelectionInTreeViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'SelectionInTree Basics'
         name: 'SelectionInTree Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 367)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 151 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 5 0 5 1.0 27 0)
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
                   activeHelpKey: selectionHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 30 0 5 1 52 0)
                   activeHelpKey: selectionHolder
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Root:'
                   name: 'listLabel'
                   layout: (AlignmentOrigin 100 0 66 0 1 0.5)
                   activeHelpKey: hierarchicalList
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'listField'
                   layout: (LayoutFrame 100 0 55 0 5 1 77 0)
                   activeHelpKey: hierarchicalList
                   tabable: true
                   model: hierarchicalList
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (ActionButtonSpec
                   label: 'Hierarchical List Editor'
                   name: 'listButton'
                   layout: (LayoutFrame 100 0 82 0 5 1 106 0)
                   activeHelpKey: hierarchicalListButton
                   translateLabel: true
                   tabable: true
                   model: openHierarchicalListEditor
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'menuSubSpec'
             layout: (LayoutFrame 0 0.0 150 0 0 1.0 265 0)
             majorKey: UISpecification
             minorKey: menuSubSpec
           )
          (UISubSpecification
             name: 'scrollerSubSpec'
             layout: (LayoutFrame 0 0.0 269 0 0 1.0 365 0)
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
     UIPainter new openOnClass:SelectionInTreeViewSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'SelectionInTree Channels'
         name: 'SelectionInTree Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 472)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'subSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 318 0)
             majorKey: FileSelectionTreeSpec
             minorKey: channelsEditSpec
           )
          (FramedBoxSpec
             label: 'Callbacks - Tree Items'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 319 0.0 0 1.0 464 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Contents:'
                   name: 'contentsLabel'
                   layout: (AlignmentOrigin 100 0 21 0 1 0.5)
                   activeHelpKey: itemContentsSelector
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'contentsSelectorField'
                   layout: (LayoutFrame 100 0 10 0 5 1 32 0)
                   activeHelpKey: itemContentsSelector
                   tabable: true
                   model: contentsSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Labels:'
                   name: 'labelsLabel'
                   layout: (AlignmentOrigin 100 0 46 0 1 0.5)
                   activeHelpKey: itemLabelSelector
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'labelSelectorField'
                   layout: (LayoutFrame 100 0 35 0 5 1 57 0)
                   activeHelpKey: itemLabelSelector
                   tabable: true
                   model: labelSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Children:'
                   name: 'childrenLabel'
                   layout: (AlignmentOrigin 100 0 71 0 1 0.5)
                   activeHelpKey: itemChildrenSelector
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'childrenSelectorField'
                   layout: (LayoutFrame 100 0 60 0 5 1 82 0)
                   activeHelpKey: itemChildrenSelector
                   tabable: true
                   model: childrenSelector
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Icons:'
                   name: 'iconsLabel'
                   layout: (AlignmentOrigin 100 0 96 0 1 0.5)
                   activeHelpKey: itemIconSelector
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'iconSelectorField'
                   layout: (LayoutFrame 100 0 85 0 5 1 107 0)
                   activeHelpKey: itemIconSelector
                   tabable: true
                   model: iconSelector
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

details2EditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SelectionInTreeViewSpec andSelector:#details2EditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: details2EditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Details2'
         name: 'SequenceView Details2'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 323)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Selection Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 124 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Allow Multiple Selections'
                   name: 'isMultiSelectCheckBox'
                   layout: (Point 17 1)
                   activeHelpKey: isMultiSelect
                   tabable: true
                   model: isMultiSelect
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Support Expand ALL'
                   name: 'SupportExpandAll'
                   layout: (Point 17 27)
                   activeHelpKey: supportsExpandAll
                   tabable: true
                   model: supportsExpandAll
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Hilight:'
                   name: 'ShowSelectedLabel'
                   layout: (AlignmentOrigin 100 0 69 0 1 0.5)
                   activeHelpKey: highlightMode
                   translateLabel: true
                   adjust: right
                 )
                (ComboListSpec
                   name: 'ComboList1'
                   layout: (LayoutFrame 100 0 60 0 200 0 79 0)
                   activeHelpKey: highlightMode
                   tabable: true
                   model: highlightMode
                   comboList: highlightModeList
                   useIndex: false
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 126 0 0 1.0 215 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 197 0 0 1.0 268 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabableCheckBox'
                   layout: (Point 10 4)
                   activeHelpKey: tabable
                   tabable: true
                   model: tabable
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
     UIPainter new openOnClass:SelectionInTreeViewSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'SelectionInTree Details'
         name: 'SelectionInTree Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 256)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'detailsEditSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 182 0)
             majorKey: SequenceViewSpec
             minorKey: detailsEditSpec
           )
          (FramedBoxSpec
             label: 'Tree Item Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 165 0 0 1.0 259 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Lines'
                   name: 'showLinesCheckBox'
                   layout: (Point 5 3)
                   activeHelpKey: showLines
                   tabable: true
                   model: showLines
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Root'
                   name: 'showRootCheckBox'
                   layout: (LayoutOrigin 115 0 3 0)
                   activeHelpKey: showRoot
                   tabable: true
                   model: showRoot
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Indicators'
                   name: 'showDirectoryIndicatorCheckBox'
                   layout: (LayoutOrigin 5 0 28 0)
                   activeHelpKey: showDirectoryIndicator
                   tabable: true
                   model: showDirectoryIndicator
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Root Indicator'
                   name: 'showDirectoryIndicatorForRootCheckBox'
                   layout: (Point 115 28)
                   activeHelpKey: showDirectoryIndicatorForRoot
                   tabable: true
                   model: showDirectoryIndicatorForRoot
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!SelectionInTreeViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        showRoot
                        showLines
                        showDirectoryIndicator
                        showDirectoryIndicatorForRoot
                        isMultiSelect
                        supportsExpandAll
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        selectConditionSelector
                        doubleClickSelector
                        doubleClickChannel
                        validateDoubleClickSelector
                        validateExpandabilitySelector
                        valueChangeSelector
                        hierarchicalList
                        contentsSelector 
                        labelSelector
                        childrenSelector 
                        iconSelector
                        highlightMode
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    env at:#highlightModeList put:(ValueHolder with:#( line label )).
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

!SelectionInTreeViewSpec class methodsFor:'queries'!

supportsDrag
    ^ true


!

supportsDrop
    ^ true

! !

!SelectionInTreeViewSpec methodsFor:'accessing'!

childrenSelector
    "return the children selector"

    ^childrenSelector
!

childrenSelector:something
    "set the label selector"

    childrenSelector := something.
!

contentsSelector
    "get the contents selector"

    ^contentsSelector
!

contentsSelector:something
    "set the contents selector"

    contentsSelector := something.
!

doubleClickSelector
    "return the value of the instance variable 'doubleClickSelector' (automatically generated)"

    ^ doubleClickSelector
!

doubleClickSelector:something
    "set the value of the instance variable 'doubleClickSelector' (automatically generated)"

    doubleClickSelector := something.
!

hierarchicalList
    "return the value of the instance variable 'hierarchicalList' (automatically generated)"

    ^ hierarchicalList
!

hierarchicalList:something
    "set the value of the instance variable 'hierarchicalList' (automatically generated)"

    hierarchicalList := something.
!

highlightMode
    "return the value of the instance variable 'highlightMode' (automatically generated)"

    ^ highlightMode ? #line
!

highlightMode:aSymbol
    "set the value of the instance variable 'highlightMode' (automatically generated)"

    (highlightMode := aSymbol) ~~ #label ifTrue:[
        highlightMode := #line
    ].
!

iconSelector
    "return the icon selector"

    ^iconSelector
!

iconSelector:something
    "set the icon selector"

    iconSelector := something.
!

isMultiSelect
    "return the value of the instance variable 'isMultiSelect' (automatically generated)"

    ^ isMultiSelect ? false
!

isMultiSelect:aBool
    "set the value of the instance variable 'isMultiSelect' (automatically generated)"

    isMultiSelect := aBool
!

labelSelector
    "return the label selector"

    ^labelSelector
!

labelSelector:something
    "set the label selector"

    labelSelector := something.
!

selectConditionSelector
    "return the value of the instance variable 'selectConditionSelector' (automatically generated)"

    ^ selectConditionSelector
!

selectConditionSelector:something
    "set the value of the instance variable 'selectConditionSelector' (automatically generated)"

    selectConditionSelector := something.
!

showDirectoryIndicator
    "return the value of the instance variable 'showDirectoryIndicator' (automatically generated)"

    ^ showDirectoryIndicator ? false
!

showDirectoryIndicator:aBool
    "set the value of the instance variable 'showDirectoryIndicator' (automatically generated)"

    showDirectoryIndicator := aBool
!

showDirectoryIndicatorForRoot
    "return the value of the instance variable 'showDirectoryIndicatorForRoot' (automatically generated)"

    ^ showDirectoryIndicatorForRoot ? true
!

showDirectoryIndicatorForRoot:aBool
    "set the value of the instance variable 'showDirectoryIndicatorForRoot' (automatically generated)"

    showDirectoryIndicatorForRoot := aBool
!

showLines
    "return the value of the instance variable 'showLines' (automatically generated)"

    ^ showLines ? true
!

showLines:aBool
    "set the value of the instance variable 'showLines' (automatically generated)"

    showLines := aBool
!

showRoot
    "return the value of the instance variable 'showRoot' (automatically generated)"

    ^ showRoot ? true
!

showRoot:aBool
    "set the value of the instance variable 'showRoot' (automatically generated)"

    showRoot := aBool
!

supportsExpandAll
    "return the value of the instance variable 'supportsExpandAll' (automatically generated)"

    supportsExpandAll notNil ifTrue:[
        ^ supportsExpandAll
    ].
    ^ self class == SelectionInTreeViewSpec
!

supportsExpandAll:aBool
    "set the value of the instance variable 'supportsExpandAll' (automatically generated)"

    supportsExpandAll := aBool
!

validateDoubleClickSelector
    "return the value of the instance variable 'validateDoubleClickSelector' (automatically generated)"

    ^ validateDoubleClickSelector
!

validateDoubleClickSelector:something
    "set the value of the instance variable 'validateDoubleClickSelector' (automatically generated)"

    validateDoubleClickSelector := something.
!

validateExpandabilitySelector
    "return the value of the instance variable 'validateExpandabilitySelector' (automatically generated)"

    ^ validateExpandabilitySelector
!

validateExpandabilitySelector:something
    "set the value of the instance variable 'validateExpandabilitySelector' (automatically generated)"

    validateExpandabilitySelector := something.
!

valueChangeSelector
    "return the value of the instance variable 'valueChangeSelector' (automatically generated)"

    ^ valueChangeSelector
!

valueChangeSelector:something
    "set the value of the instance variable 'valueChangeSelector' (automatically generated)"

    valueChangeSelector := something.
! !

!SelectionInTreeViewSpec methodsFor:'accessing-channels'!

doubleClickChannel
    ^ doubleClickChannel

    "Created: / 20-05-1998 / 23:30:05 / cg"
    "Modified: / 25-10-2010 / 12:28:52 / cg"
!

doubleClickChannel:something
    doubleClickChannel := something.

    "Created: / 20-05-1998 / 23:30:05 / cg"
    "Modified: / 25-10-2010 / 12:59:10 / cg"
! !

!SelectionInTreeViewSpec methodsFor:'building'!

createViewFor:aBuilder in:aView
    "low level create - no attributes are set."

    ^ self createScrollableViewFor:aBuilder in:aView
!

retrieveAction:aSelector with:aBuilder
    |action|

    aSelector isNil ifTrue:[^nil].
    action := self getBindingIn:aBuilder binding:aSelector.
    action isNil ifTrue:[
        ('no action for ' , aSelector) infoPrintCR
    ].
    ^ action
!

setActionsIn:aSelTree with:aBuilder

    |b|

    (b := self retrieveAction:contentsSelector with:aBuilder) notNil ifTrue:[ aSelTree contentsAction:b ].
    (b := self retrieveAction:labelSelector    with:aBuilder) notNil ifTrue:[ aSelTree labelAction:b ].
    (b := self retrieveAction:childrenSelector with:aBuilder) notNil ifTrue:[ aSelTree childrenAction:b ].
    (b := self retrieveAction:iconSelector     with:aBuilder) notNil ifTrue:[ aSelTree iconAction:b ].

!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |appl list item action callBack chnl|

    super setAttributesIn:aView with:aBuilder.

    aView showDirectoryIndicator:(self showDirectoryIndicator).
    aView showDirectoryIndicatorForRoot:(self showDirectoryIndicatorForRoot).
    aView showLines:(self showLines).
    aView showRoot:(self showRoot).

    aBuilder isEditing ifTrue:[
"/        aBuilder showDefaults ifTrue:[
            self class == SelectionInTreeViewSpec ifTrue:[
                item := TreeItem name:'Tree List' contents:nil.
                list := Array with:(TreeItem name:'Child 1')
                              with:(TreeItem name:'Child 2').
                item children:list.
                aView root: item
            ].
"/        ].
        ^ self
    ].

    aView multipleSelectOk:(self isMultiSelect).

    supportsExpandAll notNil ifTrue:[
        aView supportsExpandAll:supportsExpandAll
    ].
    aView highlightMode:(self highlightMode).

    doubleClickSelector notNil ifTrue:[
        action := callBack := self callBackActionFor:doubleClickSelector with:aBuilder.
    ].

    "/
    "/ new - allow both action and channel
    "/
    doubleClickChannel notNil ifTrue:[
        chnl := self getBindingIn:aBuilder binding:doubleClickChannel.
    ].
    chnl notNil ifTrue:[
        callBack notNil ifTrue:[
            "/ mhmh - has both a dbl-click channel and a callBack
            "/ should occur seldom
            action := [:arg | chnl value:arg. 
                              callBack value:arg.].
        ] ifFalse:[
            action := [:arg | chnl value:arg]
        ]
    ].

    aView doubleClickAction:action.
    valueChangeSelector notNil ifTrue:[
        aView action:(self callBackActionFor:valueChangeSelector with:aBuilder).
    ].
    validateDoubleClickSelector notNil ifTrue:[
        aView validateDoubleClickBlock:(self callBackActionFor:validateDoubleClickSelector with:aBuilder).
    ].
    validateExpandabilitySelector notNil ifTrue:[
        aView validateExpandabilityBlock:(self callBackActionFor:validateExpandabilitySelector with:aBuilder).
    ].

    (selectConditionSelector notNil and:[(appl := aBuilder application) notNil]) ifTrue:[
        selectConditionSelector numArgs == 1 ifTrue:[
            aView selectConditionBlock:[:n| appl perform:selectConditionSelector
                                                    with:(aView nodeAtIndex:n)
                                       ]
        ] ifFalse:[
            aView selectConditionBlock:[:n| appl perform:selectConditionSelector]
        ]
    ].

    self setModelAttributeIn:aView with:aBuilder.
"/    self setMenuIn:aView with:aBuilder.
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |list model|

    aBuilder isEditing ifFalse:[
        model := self modelInBuilder:aBuilder.

        (list := hierarchicalList) isSymbol ifTrue:[
            list := self getBindingIn:aBuilder binding:hierarchicalList
        ].

        (model isKindOf:SelectionInTree) ifTrue:[
            self setActionsIn:model with:aBuilder.

            (list isKindOf:TreeItem) ifTrue:[

                model root:list
            ].

            aView model:model.
        ] ifFalse:[
            aView selectionHolder:model.

            (list isKindOf:SelectionInTree) ifTrue:[
                self setActionsIn:list with:aBuilder.
                list expand.
                aView model:list.
                ^ self.
            ].

            (model := aView model) notNil ifTrue:[
                self setActionsIn:model with:aBuilder
            ].                

            list notNil ifTrue:[
                (list isKindOf:TreeItem) ifTrue:[aView root:list]
                                        ifFalse:[aView rootHolder:list]
            ]
        ]
    ]
! !

!SelectionInTreeViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    (self showRoot)                     ifTrue:[ l add:#showRoot ].
    (self showLines)                    ifTrue:[ l add:#showLines ].
    (self isMultiSelect)               ifFalse:[ l add:#isMultiSelect ].

    supportsExpandAll           isNil   ifTrue:[ l add:#supportsExpandAll ].
    validateDoubleClickSelector   isNil   ifTrue:[ l add:#validateDoubleClickSelector ].
    validateExpandabilitySelector isNil   ifTrue:[ l add:#validateExpandabilitySelector ].
    selectConditionSelector     isNil   ifTrue:[ l add:#selectConditionSelector ].
    valueChangeSelector         isNil   ifTrue:[ l add:#valueChangeSelector ].
    doubleClickSelector         isNil   ifTrue:[ l add:#doubleClickSelector ].
    doubleClickChannel          isNil   ifTrue:[ l add:#doubleClickChannel ].
    hierarchicalList            isNil   ifTrue:[ l add:#hierarchicalList ].
    contentsSelector            isNil   ifTrue:[ l add:#contentsSelector ].
    labelSelector               isNil   ifTrue:[ l add:#labelSelector ].
    childrenSelector            isNil   ifTrue:[ l add:#childrenSelector ].
    iconSelector                isNil   ifTrue:[ l add:#iconSelector ].

    self showDirectoryIndicator ifFalse:[
        l add:#showDirectoryIndicator.
        l add:#showDirectoryIndicatorForRoot.
    ] ifTrue:[
        self showDirectoryIndicatorForRoot ifTrue:[
            l add:#showDirectoryIndicatorForRoot
        ]
    ].

    ^ l

    "Modified: / 20.6.1998 / 13:41:28 / cg"
! !

!SelectionInTreeViewSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    showDirectoryIndicator        := aView showDirectoryIndicator.
    showDirectoryIndicatorForRoot := aView showDirectoryIndicatorForRoot.
    showLines                     := aView showLines.
    showRoot                      := aView showRoot.
    isMultiSelect                 := aView multipleSelectOk.
    highlightMode                 := aView highlightMode.
    supportsExpandAll             := aView supportsExpandAll.

    super fromView:aView callBack:aBlock



! !

!SelectionInTreeViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'TreeList'
!

viewClass
    "return the corresponding view class of the spec"

    ^ SelectionInTreeView

! !

!SelectionInTreeViewSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    selectConditionSelector     notNil ifTrue:[more add:selectConditionSelector].
    doubleClickSelector         notNil ifTrue:[more add:doubleClickSelector].
    valueChangeSelector         notNil ifTrue:[more add:valueChangeSelector].
    validateDoubleClickSelector   notNil ifTrue:[more add:validateDoubleClickSelector].
    validateExpandabilitySelector notNil ifTrue:[more add:validateExpandabilitySelector].
    contentsSelector            notNil ifTrue:[more add:contentsSelector].
    labelSelector               notNil ifTrue:[more add:labelSelector].
    childrenSelector            notNil ifTrue:[more add:childrenSelector].
    iconSelector                notNil ifTrue:[more add:iconSelector].
    ^ more

    "Modified: / 10.2.2000 / 01:25:56 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    hierarchicalList isSymbol ifTrue:[more add:hierarchicalList].
    ^ more

    "Modified: / 10.2.2000 / 01:24:43 / cg"
! !

!SelectionInTreeViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitSelectionInTreeViewSpec:self
! !

!SelectionInTreeViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SelectionInTreeViewSpec.st,v 1.67 2017-11-28 18:21:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/SelectionInTreeViewSpec.st,v 1.67 2017-11-28 18:21:27 cg Exp $'
! !

