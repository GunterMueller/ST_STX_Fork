"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

ViewWithScrollerSpec subclass:#SequenceViewSpec
	instanceVariableNames:'isMultiSelect doubleClickSelector valueChangeSelector useIndex
		sequenceList callbacksSpec doubleClickChannel useModifierKeys
		selectCondition ignoreReselect allowToggleSelect'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SequenceViewSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!SequenceViewSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'SequenceViewSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@(UUUUU11@@@@B@D***+H@R???4!!QH@@@R@D/??=H@R@@@D AK???RJD @@AH\R???4 AH@@@R@D5UUUHTP@@@@ C*****@@@@@@@@b');
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

!SequenceViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SequenceViewSpec andSelector:#basicsEditSpec
     SequenceViewSpec new openInterface:#basicsEditSpec
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'SequenceView Basics'
              #layout: #(#LayoutFrame 93 0 185 0 492 0 522 0)
              #label: 'SequenceView Basics'
              #min: #(#Point 10 10)
              #max: #(#Point 1160 870)
              #bounds: #(#Rectangle 93 185 493 523)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#UISubSpecification
                    #name: 'modelListSubSpec'
                    #layout: #(#LayoutFrame 0 0.0 6 0 0 1.0 126 0)
                    #majorKey: #UISpecification
                    #minorKey: #modelListSubSpec
                )
                 #(#UISubSpecification
                    #name: 'menuSubSpec'
                    #layout: #(#LayoutFrame 0 0.0 123 0 0 1.0 238 0)
                    #majorKey: #UISpecification
                    #minorKey: #menuSubSpec
                )
                 #(#UISubSpecification
                    #name: 'scrollerSubSpec'
                    #layout: #(#LayoutFrame 0 0.0 242 0 0 1.0 345 0)
                    #majorKey: #UISpecification
                    #minorKey: #scrollerSubSpec
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
     UIPainter new openOnClass:SequenceViewSpec andSelector:#channelsEditSpec
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
         bounds: (Rectangle 0 0 400 273)
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
                   name: 'SubSpecification1'
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
             layout: (LayoutFrame 0 0.0 121 0.0 0 1.0 270 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification3'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 26 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 36 0.0 4 1.0 64 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectedValueChangeCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification5'
                   layout: (LayoutFrame 0 0.0 62 0.0 4 1.0 90 0)
                   majorKey: UISpecification
                   minorKey: subSpecForDoubleClickCallBack
                 )
                (LabelSpec
                   label: 'SelectCond:'
                   name: 'selectCondLabel'
                   layout: (AlignmentOrigin 100 0 99 0 1 0.5)
                   activeHelpKey: selectConditionSelector
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'selectCondField'
                   layout: (LayoutFrame 100 0 89 0 5 1 111 0)
                   activeHelpKey: selectConditionSelector
                   tabable: true
                   model: selectCondition
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
     UIPainter new openOnClass:SequenceViewSpec andSelector:#details2EditSpec
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
         bounds: (Rectangle 0 0 402 252)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Selection Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 112 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Allow Multiple Selections'
                   name: 'isMultiSelectCheckBox'
                   layout: (LayoutFrame 10 0 3 0 251 0 26 0)
                   activeHelpKey: isMultiSelect
                   tabable: true
                   model: isMultiSelect
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Allow Toggle of a Selection'
                   name: 'CheckBox1'
                   layout: (LayoutFrame 10 0 25 0 251 0 48 0)
                   activeHelpKey: allowToggleSelect
                   tabable: true
                   model: allowToggleSelect
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Ignore Reselect'
                   name: 'allowReselectCheckBox'
                   layout: (LayoutFrame 10 0 46 0 292 0 69 0)
                   activeHelpKey: ignoreReselect
                   tabable: true
                   model: ignoreReselect
                   translateLabel: true
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 105 0 0 1.0 194 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 162 0 0 1.0 228 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabableCheckBox'
                   layout: (Point 10 0)
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
     UIPainter new openOnClass:SequenceViewSpec andSelector:#detailsEditSpec
     SequenceViewSpec new openInterface:#detailsEditSpec
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'SequenceView Details'
              #layout: #(#LayoutFrame 216 0 173 0 615 0 334 0)
              #label: 'SequenceView Details'
              #min: #(#Point 10 10)
              #max: #(#Point 1160 870)
              #bounds: #(#Rectangle 216 173 616 335)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#UISubSpecification
                    #name: 'detailsInitSubSpec'
                    #layout: #(#LayoutFrame 0 0.0 6 0 0 1.0 161 0)
                    #majorKey: #UISpecification
                    #minorKey: #fontColorBorderSubSpec
                )

              )
          )
      )

    "Modified: / 21.8.1998 / 21:30:34 / cg"
! !

!SequenceViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        isMultiSelect
                        useIndex
                        ignoreReselect
                        allowToggleSelect
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        doubleClickSelector
                        valueChangeSelector
                        doubleClickChannel
                        selectCondition
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        listSelector
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#arrayLiteralOrSymbolOrNil.

    "Modified: / 20.5.1998 / 23:29:55 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:DataSetSpec
        with:HierarchicalListViewSpec

    "Modified (comment): / 05-09-2012 / 19:27:10 / cg"
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

!SequenceViewSpec class methodsFor:'queries'!

supportsDrag
    ^ true
!

supportsDrop
    ^ true
!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ false

! !

!SequenceViewSpec methodsFor:'accessing'!

allowToggleSelect
    "controls if clicking on an already selected item deselects it or not.
     The default is on, meaning that click on the selection deselects.
     However, there the ignoreReselect-flag is checked first;
     if that is true, no toggling will be done"

    ^ allowToggleSelect
!

allowToggleSelect:aBoolean
    "controls if clicking on an already selected item deselects it or not.
     The default is on, meaning that click on the selection deselects.
     However, there the ignoreReselect-flag is checked first;
     if that is true, no toggling will be done"
     
    allowToggleSelect := aBoolean.
!

autoSelect:aBoolean
    "VW: CodeCrawler"
!

callbacksSpec
    "return the value of the instance variable 'callbacksSpec' (automatically generated)"

    ^ callbacksSpec

    "Created: / 19.4.1998 / 12:36:05 / cg"
!

callbacksSpec:something
    "set the value of the instance variable 'callbacksSpec' (automatically generated)"

    callbacksSpec := something.

    "Created: / 19.4.1998 / 12:36:05 / cg"
!

doubleClickSelector
    "return the value of the instance variable 'doubleClickSelector' (automatically generated)"

    ^ doubleClickSelector
!

doubleClickSelector:something
    "set the value of the instance variable 'doubleClickSelector' (automatically generated)"

    doubleClickSelector := something.
!

ignoreReselect
    "controls if clicking on an already selected item should
     be ignored or should perform the select action again.
     By default, these are ignored"

    ^ ignoreReselect ? true

    "Created: 28.3.1997 / 21:16:55 / cg"
!

ignoreReselect:aBoolean
    "controls if clicking on an already selected item should
     be ignored or should perform the select action again.
     By default, these are ignored"
     
    ignoreReselect := aBoolean.
!

isMultiSelect
    "return the value of the instance variable 'isMultiSelect' (automatically generated)"

    ^ isMultiSelect ? false

    "Created: 28.3.1997 / 21:16:55 / cg"
!

isMultiSelect:something
    "set the value of the instance variable 'isMultiSelect' (automatically generated)"

    isMultiSelect := something.

    "Created: 28.3.1997 / 21:16:55 / cg"
!

listSelector
    ^ sequenceList


!

listSelector:something
    self sequenceList:something
!

multipleSelections
    "VW: KAISER"
    ^ self isMultiSelect
!

multipleSelections:aBoolean
    "VW: KAISER"
    self isMultiSelect:aBoolean
!

selectCondition
    "return the value of the instance variable 'selectCondition' (automatically generated)"

    ^ selectCondition
!

selectCondition:something
    "set the value of the instance variable 'selectCondition' (automatically generated)"

    selectCondition := something.
!

selectionType
    "VW: KAISER"
    ^ nil
!

selectionType:aType
    "VW: KAISER"

!

sequenceList
    "return the value of the instance variable 'sequenceList' (automatically generated)"

    ^ sequenceList
!

sequenceList:something
    "set the value of the instance variable 'sequenceList' (automatically generated)"

    sequenceList := something.
!

useIndex
    "return the value of the instance variable 'useIndex' (automatically generated)"

    ^ useIndex ? false
!

useIndex:something
    "set the value of the instance variable 'useIndex' (automatically generated)"

    useIndex := something.
!

useModifierKeys
    "unused for now - VW compatibility"

    ^ useModifierKeys
!

useModifierKeys:something
    "unused for now - VW compatibility"

    useModifierKeys := something.
!

valueChangeSelector
    "return the value of the instance variable 'valueChangeSelector' (automatically generated)"

    ^ valueChangeSelector
!

valueChangeSelector:something
    "set the value of the instance variable 'valueChangeSelector' (automatically generated)"

    valueChangeSelector := something.
! !

!SequenceViewSpec methodsFor:'accessing-channels'!

doubleClickChannel
    ^ doubleClickChannel

    "Created: / 20-05-1998 / 23:30:05 / cg"
    "Modified: / 25-10-2010 / 12:28:58 / cg"
!

doubleClickChannel:something
    doubleClickChannel := something.

    "Created: / 20-05-1998 / 23:30:05 / cg"
    "Modified: / 25-10-2010 / 12:58:46 / cg"
! !

!SequenceViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |usedValueChangeSelector usedDoubleClickChangeSelector
     chnl callBack action lbl|

    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
"/ now done from UISpec setAttributes ...
"/         self setChannelsIn:aView with:aBuilder.

        "/
        "/ setup a callBack for selectionChange (if req'd)
        "/ and a callBack for doubleClick (if req'd)
        "/
        callbacksSpec notNil ifTrue:[
            usedValueChangeSelector := callbacksSpec valueChangeSelector.
            usedDoubleClickChangeSelector := callbacksSpec doubleClickSelector.
        ] ifFalse:[
            usedValueChangeSelector := valueChangeSelector.
            usedDoubleClickChangeSelector := doubleClickSelector.
        ].
        usedValueChangeSelector notNil ifTrue:[
            aView action:(self callBackActionFor:usedValueChangeSelector with:aBuilder).
        ].
        usedDoubleClickChangeSelector notNil ifTrue:[
            action := callBack := self callBackActionFor:usedDoubleClickChangeSelector with:aBuilder.
        ].

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

        aView multipleSelectOk:(self isMultiSelect).
        ignoreReselect notNil ifTrue:[ aView ignoreReselect:ignoreReselect].
        allowToggleSelect notNil ifTrue:[ aView toggleSelect:allowToggleSelect].
        aView changeMessage:#value:.
        aView aspectMessage:#value.
        self setModelIn:aView useIndex:useIndex with:aBuilder.
"/        self setMenuIn:aView with:aBuilder.

        selectCondition notNil ifTrue:[
            aView selectConditionBlock:[:newSelection |       
                                          aBuilder application perform:selectCondition
                                       ]
        ]
    ] ifTrue: [
        aBuilder showDefaults ifTrue:[
            aView list: #('List' '... Item ...' '... Item ...').
        ] ifFalse:[
            lbl := model ? name.
            lbl notNil ifTrue:[
                aView list:(Array with:lbl)
            ]
        ]
    ]

    "Modified: / 30.10.2001 / 14:52:01 / cg"
!

validateModel:aModel forView:aView withValue:constantList
    "about to set the model.
     If it's a plain valueHolder, change the listMessage
     to #value"

    ^ self
        validateSelectionInListModel:aModel forView:aView withValue:constantList

    "Modified: / 26-10-1997 / 19:11:22 / cg"
    "Modified (comment): / 13-02-2017 / 20:30:22 / cg"
! !

!SequenceViewSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    callbacksSpec notNil ifTrue:[
        callbacksSpec := callbacksSpec decodeAsLiteralArray.
    ].

    "/in ST-80, the default is true

    hasHorizontalScrollBar isNil ifTrue:[
        hasHorizontalScrollBar := true.
        miniScrollerHorizontal := true.
    ].
    hasVerticalScrollBar isNil ifTrue:[
        hasVerticalScrollBar := true
    ].

    "Created: / 7.4.1997 / 19:19:44 / cg"
    "Modified: / 19.4.1998 / 12:43:06 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    (self isMultiSelect)          ifFalse:[ l add:#isMultiSelect ].

    callbacksSpec isNil            ifTrue:[ l add:#callbacksSpec].
    doubleClickSelector isNil      ifTrue:[ l add:#doubleClickSelector ].
    doubleClickChannel  isNil      ifTrue:[ l add:#doubleClickChannel ].
    valueChangeSelector isNil      ifTrue:[ l add:#valueChangeSelector ].
    selectCondition     isNil      ifTrue:[ l add:#selectCondition ].
    sequenceList        isNil      ifTrue:[ l add:#sequenceList].
    ignoreReselect ~~ false        ifTrue:[ l add:#ignoreReselect].
    allowToggleSelect == true      ifTrue:[ l add:#allowToggleSelect].
    ^ l

    "Modified: / 20.6.1998 / 13:41:30 / cg"
! !

!SequenceViewSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    useIndex := aView useIndex.
    super fromView:aView callBack:aBlock

! !

!SequenceViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'List'
! !

!SequenceViewSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    doubleClickSelector notNil ifTrue:[more add:doubleClickSelector].
    valueChangeSelector notNil ifTrue:[more add:valueChangeSelector].
    ^ more

    "Modified: / 10.2.2000 / 01:25:59 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    sequenceList notNil ifTrue:[more add:sequenceList].
    ^ more

    "Modified: / 10.2.2000 / 01:24:40 / cg"
!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator
    "
    sequenceList notNil ifTrue:[
        ^ super defaultModelClassFor:someAspect
    ].

    self isMultiSelect ifTrue:[^ MultiSelectionInList]
                      ifFalse:[^ SelectionInList]

    "Modified: / 26.10.1997 / 18:57:49 / cg"
! !

!SequenceViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitSequenceViewSpec:self
! !

!SequenceViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SequenceViewSpec.st,v 1.119 2017-11-28 18:21:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/SequenceViewSpec.st,v 1.119 2017-11-28 18:21:22 cg Exp $'
! !

