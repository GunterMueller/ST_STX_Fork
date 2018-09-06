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

MenuComponentSpec subclass:#TabViewSpec
	instanceVariableNames:'backgroundColor direction useIndex fitLastRow callbacksSpec
		selectConditionBlock valueChangeSelector accessTabMenuAction
		tabLeftMargin tabRightMargin translateLabel hasScrollButtons
		destroyTabAction addTabAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!TabViewSpec class methodsFor:'documentation'!

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

!TabViewSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'TabViewSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01????>@G***?8@^<<<? Q;2"".@G/??<8$^???3 A;???N@G/??<8L^???3 A;???N@G0@@@8D_???? C*****O@@@@@@@b');
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

!TabViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TabViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'TabView Basics'
         name: 'TabView Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 402 218)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 153 0)
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
                   layout: (LayoutFrame 100 0 7 0 3 1.0 29 0)
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
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 32 0 -17 1.0 54 0)
                   activeHelpKey: selectionHolder
                   tabable: true
                   model: model
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -17 1 32 0 3 1 54 0)
                   activeHelpKey: browseAction
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseActionMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'List:'
                   name: 'listLabel'
                   layout: (AlignmentOrigin 100 0 70 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'listField'
                   layout: (LayoutFrame 100 0 58 0 -72 1.0 80 0)
                   activeHelpKey: listHolder
                   tabable: true
                   model: listSelector
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
                   layout: (AlignmentOrigin 10 1.0 70 0 1 0.5)
                   activeHelpKey: useIndex
                   tabable: true
                   model: useIndex
                   translateLabel: true
                 )
                (ActionButtonSpec
                   label: 'Tab List Editor'
                   name: 'listButton'
                   layout: (LayoutFrame 100 0 84 0 3 1 108 0)
                   activeHelpKey: openTabListEditor
                   translateLabel: true
                   tabable: true
                   model: openTabListEditor
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 153 0 0 1.0 220 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Translate Label'
                   name: 'translateLabel'
                   layout: (Point 26 0)
                   activeHelpKey: translateLabel
                   tabable: true
                   model: translateLabel
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

channelsEditSpec
    ^ self channelsEditSpecWithCallBack
!

channelsEditSpecWithCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TabViewSpec andSelector:#channelsEditSpecWithCallBack
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpecWithCallBack
       window: 
      (WindowSpec
         label: 'TabViewSpec Channels'
         name: 'TabViewSpec Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 424 352)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 92 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'EnableChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 25 0.0 4 1.0 50 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Callbacks'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 97 0.0 0 1.0 324 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 0 0.0 5 1.0 30 0.0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (LabelSpec
                   label: 'Select Cond:'
                   name: 'selectConditionLabel'
                   layout: (AlignmentOrigin 140 0 50 0 1 0.5)
                   activeHelpKey: selectConditionSelector
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'selectConditionField'
                   layout: (LayoutFrame 140 0 38 0 5 1 60 0)
                   activeHelpKey: selectConditionSelector
                   tabable: true
                   model: selectConditionBlock
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 64 0.0 4 1.0 92 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectedValueChangeCallBack
                 )
                (LabelSpec
                   label: 'TabMenu at:'
                   name: 'TabMenuLabel'
                   layout: (AlignmentOrigin 140 0 120 0 1 0.5)
                   activeHelpKey: accessTabMenuAction
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'accessTabMenuAction'
                   layout: (LayoutFrame 140 0 109 0 5 1 131 0)
                   activeHelpKey: accessTabMenuAction
                   tabable: true
                   model: accessTabMenuAction
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Destroy Tab:'
                   name: 'DestroyTabLabel'
                   layout: (AlignmentOrigin 140 0 149 0 1 0.5)
                   activeHelpKey: destroyTabAction
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'destroyTabAction'
                   layout: (LayoutFrame 140 0 138 0 5 1 160 0)
                   activeHelpKey: destroyTabAction
                   tabable: true
                   model: destroyTabAction
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Add Tab:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 140 0 176 0 1 0.5)
                   activeHelpKey: destroyTabAction
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 140 0 165 0 5 1 187 0)
                   activeHelpKey: addTabAction
                   tabable: true
                   model: addTabAction
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
     UIPainter new openOnClass:TabViewSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'NoteBookView Details'
         name: 'NoteBookView Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 427 361)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 274 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 110 0 27 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                 )
                (FontMenuSpec
                   name: 'fontMenu'
                   layout: (LayoutFrame 110 0 15 0 5 1.0 37 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 110 0 55 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 110 0 43 0 5 1 65 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Orientation:'
                   name: 'directionLabel'
                   layout: (AlignmentOrigin 110 0 91 0 1 0.5)
                   activeHelpKey: tabOrientation
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'Orientation'
                   name: 'directionPopUpList'
                   layout: (LayoutFrame 110 0 79 0 5 1.0 103 0)
                   activeHelpKey: tabOrientation
                   translateLabel: true
                   tabable: true
                   model: direction
                   menu: directionList
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'levelLabel'
                   layout: (AlignmentOrigin 110 0 120 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 110 0 107 0 157 0 133 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Fit Tabs To View'
                   name: 'fitLastRowCheckBox'
                   layout: (LayoutFrame 10 0 144 0 0 1 169 0)
                   activeHelpKey: fitLastRow
                   tabable: true
                   model: fitLastRow
                   translateLabel: true
                   resizeForLabel: true
                 )
                (CheckBoxSpec
                   label: 'Is Scrollable'
                   name: 'hasScrollButtons'
                   layout: (LayoutFrame 10 0 173 0 0 1 195 0)
                   activeHelpKey: scrollTabs
                   model: hasScrollButtons
                   translateLabel: true
                   resizeForLabel: true
                 )
                (LabelSpec
                   label: 'Margin Left:'
                   name: 'tabLeftMarginLabel'
                   layout: (AlignmentOrigin 117 0 218 0 1 0.5)
                   activeHelpKey: tabLeftMargin
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabLeftMargin'
                   layout: (LayoutFrame 117 0 204 0 157 0 230 0)
                   activeHelpKey: tabLeftMargin
                   tabable: true
                   model: tabLeftMargin
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Right:'
                   name: 'tabRightMarginLabel'
                   layout: (AlignmentOrigin 204 0 218 0 0 0.5)
                   activeHelpKey: tabRightMargin
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'tabRightMargin'
                   layout: (LayoutFrame 265 0 204 0 305 0 230 0)
                   activeHelpKey: tabRightMargin
                   tabable: true
                   model: tabRightMargin
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 279 0.0 0 1.0 350 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'canTabCheckBox'
                   layout: (Point 10 5)
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
! !

!TabViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        selectConditionBlock
                        accessTabMenuAction
                        valueChangeSelector
                        destroyTabAction
                        addTabAction
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        useIndex
                        fitLastRow
                        direction
                        backgroundColor
                        translateLabel
                        hasScrollButtons
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        tabRightMargin
                        tabLeftMargin
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#numberOrNil.

    self 
        adaptApects:
                    #(  
                        listSelector
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#arrayLiteralOrSymbolOrNil.

    env at:#directionList put:#(#top #bottom #left #right ) asValue.

    "Modified: / 26.10.1997 / 14:30:41 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec) 
            (Channels channelsEditSpecWithCallBack)
       )


! !

!TabViewSpec class methodsFor:'queries'!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ false


! !

!TabViewSpec methodsFor:'accessing'!

accessTabMenuAction
    ^ accessTabMenuAction
!

accessTabMenuAction:something
    accessTabMenuAction := something.
!

addTabAction
    ^ addTabAction
!

addTabAction:aspectSelector
    addTabAction := aspectSelector.
!

callbacksSpec
    "return the value of the instance variable 'callbacksSpec' (automatically generated)"

    ^ callbacksSpec
!

callbacksSpec:something
    "set the value of the instance variable 'callbacksSpec' (automatically generated)"

    callbacksSpec := something.
!

destroyTabAction
    ^ destroyTabAction
!

destroyTabAction:aspectSelector
    destroyTabAction := aspectSelector.

    "Modified (format): / 05-07-2011 / 15:35:21 / cg"
!

direction
    "get the direction: #top #bottom #left or #right
    "
    ^ direction ? #top


!

direction:something
    "set the direction: #top #bottom #left or #right
    "
    something isNil ifTrue:[
        direction := #top
    ] ifFalse:[
        direction := something asSymbol.
    ]
!

fitLastRow
    "fit the last row to the view's size
    "
    ^ fitLastRow ? true


!

fitLastRow:aBool
    "fit the last row to the view's size
    "
    fitLastRow := aBool


!

hasScrollButtons
    "returns true if scrollButtons are configured
    "
    ^ hasScrollButtons ? false
!

hasScrollButtons:aBoolean
    "true if scrollButtons are configured
    "
    hasScrollButtons := aBoolean.
!

listSelector
    ^ self menu


!

listSelector:something
    self menu:something


!

selectConditionBlock
    "return the value of the instance variable 'selectConditionBlock' (automatically generated)"

    ^ selectConditionBlock
!

selectConditionBlock:something
    "set the value of the instance variable 'selectConditionBlock' (automatically generated)"

    selectConditionBlock := something.
!

tabLeftMargin
    ^ tabLeftMargin ? 0
!

tabLeftMargin:aMargin
    tabLeftMargin := aMargin.
!

tabRightMargin
    ^ tabRightMargin ? 0
!

tabRightMargin:aMargin
    tabRightMargin := aMargin.
!

translateLabel
    "get the translateLabel attribute (language string translation)"

    ^ translateLabel ? true
!

translateLabel:aBoolean
    "set/clear the translateLabel attribute (language string translation)"

    translateLabel := aBoolean.
!

useIndex
    "use index instead of name
    "
    ^ useIndex ? false


!

useIndex:aBool
    "use index instead of name
    "
    useIndex := aBool ? false


!

valueChangeSelector
    "return the value of the instance variable 'valueChangeSelector' (automatically generated)"

    ^ valueChangeSelector


!

valueChangeSelector:aSelector
    "set the value of the instance variable 'valueChangeSelector' (automatically generated)"

    valueChangeSelector := aSelector
! !

!TabViewSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.
! !

!TabViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |list nm usedValueChangeSelector selectionHolder|

    aView translateLabel:(self translateLabel).    

    super setAttributesIn:aView with:aBuilder.

    backgroundColor notNil 
        ifTrue: [aView backgroundColor:backgroundColor]
        ifFalse:[aBuilder isEditing ifTrue: [aView backgroundColor: self viewClass defaultViewBackgroundColor]].

    aView hasScrollButtons:(self hasScrollButtons).
    aView direction:(self direction).
    aView fitLastRow:(self fitLastRow).
    aView tabRightMargin:(self tabRightMargin).
    aView tabLeftMargin:(self tabLeftMargin).

    aBuilder isEditing ifTrue:[
        nm := self class name copyReplaceString:'ViewSpec' withString:''.
        list := Array with:name with:'***'.
        aView list:list.
        aView selection:list first.
    ] ifFalse:[
        selectConditionBlock notNil ifTrue:[
            aView selectConditionBlock:(self callBackActionFor:selectConditionBlock with:aBuilder).
        ].
        accessTabMenuAction notNil ifTrue:[
            aView accessTabMenuAction:(self callBackActionFor:accessTabMenuAction with:aBuilder).
        ].
        destroyTabAction notNil ifTrue:[
            aView showDestroyTabButton:true.
            aView destroyTabAction:(self callBackActionFor:destroyTabAction with:aBuilder).
        ].
        addTabAction notNil ifTrue:[
            aView addTabAction:(self callBackActionFor:addTabAction with:aBuilder).
        ].

        self setModelIn:aView useIndex:useIndex with:aBuilder.

        callbacksSpec notNil ifTrue:[
            usedValueChangeSelector := callbacksSpec valueChangeSelector.
        ] ifFalse:[
            usedValueChangeSelector := valueChangeSelector.
        ].
        usedValueChangeSelector notNil ifTrue:[
            (selectionHolder := aView model) isNil ifTrue:[
                aView 
                    action:[:selIdx | 
                        aBuilder application perform: usedValueChangeSelector withOptionalArgument:selIdx
                    ]
            ] ifFalse:[    
                selectionHolder 
                    onChangeEvaluate:[ 
                        aBuilder application perform: usedValueChangeSelector withOptionalArgument:selectionHolder value
                    ]
            ].
        ]
    ]

    "Modified: / 27-02-2018 / 11:37:04 / stefan"
!

validateModel:aModel forView:aView withValue:constantList
    "about to set the model.
     If it's a plain valueHolder, change the listMessage
     to #value"

    ^ self
        validateSelectionInListModel:aModel forView:aView withValue:constantList

    "Created: / 26-10-1997 / 19:12:12 / cg"
    "Modified (comment): / 13-02-2017 / 20:31:50 / cg"
! !

!TabViewSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    callbacksSpec notNil ifTrue:[
        callbacksSpec := callbacksSpec decodeAsLiteralArray.
    ].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].



!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    callbacksSpec        isNil ifTrue:[ l add:#callbacksSpec].
    valueChangeSelector  isNil ifTrue:[ l add:#valueChangeSelector].
    backgroundColor      isNil ifTrue:[ l add:#backgroundColor].
    selectConditionBlock isNil ifTrue:[ l add:#selectConditionBlock].
    accessTabMenuAction  isNil ifTrue:[ l add:#accessTabMenuAction].
    destroyTabAction     isNil ifTrue:[ l add:#destroyTabAction].
    addTabAction         isNil ifTrue:[ l add:#addTabAction].
    hasScrollButtons     isNil ifTrue:[ l add:#hasScrollButtons ].

    self tabLeftMargin  == 0 ifTrue:[ l add:#tabLeftMargin  ].
    self tabRightMargin == 0 ifTrue:[ l add:#tabRightMargin ].

    (self direction) == #top    ifTrue:[l add:#direction].

    self fitLastRow       ifTrue:[l add:#fitLastRow].
    self useIndex        ifFalse:[l add:#useIndex].
    "/ self translateLabel  ifFalse:[l add:#translateLabel ].

    ^ l

    "Modified: / 20.6.1998 / 13:41:33 / cg"
! !

!TabViewSpec methodsFor:'obsolete'!

moveSelectedRow
    "true if selection always is moved to the first row
    "
    ^ true


!

moveSelectedRow:something

!

oneTabPerLine
    "return the value of the instance variable 'oneTabPerLine' (automatically generated)"

    ^ false
!

oneTabPerLine:something
!

tabWidget
    "return the value of the instance variable 'tabWidget' (automatically generated)"

    ^ nil


!

tabWidget:something
! !

!TabViewSpec methodsFor:'parsing a view'!

fromView:aTabView callBack:aBlock
    "extract attributes from aView"

    direction        := aTabView direction.
    fitLastRow       := aTabView fitLastRow.
    useIndex         := aTabView useIndex.
    backgroundColor  := aTabView backgroundColor.
    hasScrollButtons := aTabView hasScrollButtons.
    tabRightMargin   := aTabView tabRightMargin.
    tabLeftMargin    := aTabView "tabLeftMargin" tabRightMargin.

    super fromView:aTabView callBack:aBlock
! !

!TabViewSpec methodsFor:'queries'!

menuSelector
    ^ nil


!

menuSelector:something


!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'TabHeader'



! !

!TabViewSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    selectConditionBlock notNil ifTrue:[more add:selectConditionBlock].
    accessTabMenuAction  notNil ifTrue:[more add:accessTabMenuAction].
    valueChangeSelector  notNil ifTrue:[more add:valueChangeSelector].
    destroyTabAction     notNil ifTrue:[more add:destroyTabAction].
    addTabAction         notNil ifTrue:[more add:addTabAction].
    ^ more

    "Modified: / 10.2.2000 / 01:26:05 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    menu notNil ifTrue:[more add:menu].
    ^ more

    "Modified: / 10.2.2000 / 01:24:34 / cg"
! !

!TabViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitTabViewSpec:self
! !

!TabViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/TabViewSpec.st,v 1.96 2018-02-27 11:02:02 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/TabViewSpec.st,v 1.96 2018-02-27 11:02:02 stefan Exp $'
! !

