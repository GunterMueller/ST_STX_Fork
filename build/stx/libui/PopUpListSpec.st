"{ Encoding: utf8 }"

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

ViewWithLabelAndModelSpec subclass:#PopUpListSpec
	instanceVariableNames:'menu useIndex showHandle callbacksSpec ignoreReselect
		stateChangeCallBackSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!PopUpListSpec class methodsFor:'documentation'!

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

    "Modified: 4.9.1995 / 19:40:10 / claus"
!

documentation
"
    not normally used by applications.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

    "Modified: 4.9.1995 / 19:35:38 / claus"
! !

!PopUpListSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'PopUpListSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU3A????>@G????8@_????!!A0@@@N@GEUU\8@\_?@# A1??>N@GN**(8@\@@@C A????>@G????8P_???? C*****@@@@@@@@b');
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

!PopUpListSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PopUpListSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'PopUpList Basic'
         name: 'PopUpList Basic'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 398 226)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'modelListSubSpec'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 126 0)
             majorKey: UISpecification
             minorKey: modelListSubSpec
           )
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 123 0 0 1.0 222 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Default:'
                   name: 'defaultLabel'
                   layout: (AlignmentOrigin 120 0 17 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'defaultField'
                   layout: (LayoutFrame 120 0 6 0 5 1.0 28 0)
                   activeHelpKey: defaultLabel
                   tabable: true
                   model: label
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Translate Label'
                   name: 'translateLabel'
                   layout: (Point 150 33)
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
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PopUpListSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'PopUpList Channels'
         name: 'PopUpList Channels'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 391 334)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 100 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 6 0.0 4 1.0 31 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'EnableChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 32 0.0 4 1.0 57 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Callbacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 99 0.0 0 1.0 194 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 0 0.0 5 1.0 25 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (LabelSpec
                   label: 'State Changed:'
                   name: 'stateChangeLabel'
                   layout: (AlignmentOrigin 100 0 41 0 1 0.5)
                   activeHelpKey: actionCallBackSelector
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'stateChangeCallBackSelectorField'
                   layout: (LayoutFrame 100 0 30 0 -15 1 52 0)
                   activeHelpKey: actionCallBackSelector
                   tabable: true
                   model: stateChangeCallBackSelector
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfCallbacks
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 30 0 5 1 52 0)
                   activeHelpKey: browseAction
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseActionMethod:
                   actionValue: stateChangeCallBackSelector
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
     UIPainter new openOnClass:PopUpListSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'PopUpList Details'
         name: 'PopUpList Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 510 509)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'fontSubSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 127 0)
             majorKey: UISpecification
             minorKey: fontColorSubSpec
           )
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 132 0 0 1.0 230 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Justification:'
                   name: 'justificationLabel'
                   layout: (AlignmentOrigin 120 0 15 0 1 0.5)
                   activeHelpKey: labelAlignment
                   translateLabel: true
                   resizeForLabel: false
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'Alignment'
                   name: 'alignmentPopUpList'
                   layout: (LayoutFrame 120 0 3 0 5 1 27 0)
                   activeHelpKey: labelAlignment
                   translateLabel: true
                   tabable: true
                   model: alignment
                   menu: alignmentList
                 )
                (CheckBoxSpec
                   label: 'Resize For Label'
                   name: 'resizeForLabelCheckBox'
                   layout: (LayoutOrigin 10 0 31 0)
                   activeHelpKey: resizeForLabel
                   tabable: true
                   model: resizeForLabel
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Show Handle'
                   name: 'showHandleCheckBox'
                   layout: (LayoutOrigin 0 0.5 31 0)
                   activeHelpKey: resizeForLabel
                   tabable: true
                   model: showHandle
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Selection Attributes'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 224 0 0 1.0 292 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Ignore Reselect'
                   name: 'ignoreReselectCheckBox'
                   layout: (LayoutFrame 10 0 6 0 0 1 29 0)
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
             layout: (LayoutFrame 0 0.0 291 0 0 1.0 356 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 361 0 0 1.0 430 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'canTabCheckBox'
                   layout: (LayoutOrigin 10 0 1 0)
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

!PopUpListSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        ignoreReselect
                        useIndex
                        showHandle
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        stateChangeCallBackSelector
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        listSelector
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#arrayLiteralOrSymbolOrNil.

    "Modified: / 6.3.1999 / 21:41:07 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
       )
! !

!PopUpListSpec methodsFor:'accessing'!

callbacksSpec
    "return the value of the instance variable 'callbacksSpec' (automatically generated)"

    ^ callbacksSpec
!

callbacksSpec:something
    "set the value of the instance variable 'callbacksSpec' (automatically generated)"

    callbacksSpec := something.

!

defaultAdjust
    ^ #left


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

    ignoreReselect := something.
!

listSelector
    ^ self menu

!

listSelector:something
    self menu:something

!

menu
    "return the value of the instance variable 'menu' (automatically generated)"

    ^ menu
!

menu:something
    "set the value of the instance variable 'menu' (automatically generated)"

    (something isNil 
    or:[something isArray]) ifTrue:[
        menu := something
    ] ifFalse:[
        menu := something asSymbol.
    ]

    "Modified: / 26.10.1997 / 14:05:23 / cg"
!

showHandle
    "return the value of the instance variable 'showHandle' (automatically generated)"

    ^ showHandle ? true

    "Created: / 6.3.1999 / 21:24:24 / cg"
    "Modified: / 6.3.1999 / 21:24:33 / cg"
!

showHandle:something
    "set the value of the instance variable 'showHandle' (automatically generated)"

    showHandle := something.

    "Created: / 6.3.1999 / 21:24:24 / cg"
!

stateChangeCallBackSelector
    ^ stateChangeCallBackSelector
!

stateChangeCallBackSelector:something
    stateChangeCallBackSelector := something.
!

tabable
    ^ tabable ? true
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

! !

!PopUpListSpec methodsFor:'accessing-dummy'!

isPopUp:dummy
! !

!PopUpListSpec methodsFor:'building'!

defineCallBacksFor:aBuilder view:aView
    |inpChgSel appl|

    "/ transform ST-80 Style callBackSpec
    "/ into ST/X actions ...

    (     aBuilder isEditing not
     and:[callbacksSpec notNil
     and:[(appl := aBuilder application) notNil]]
    ) ifTrue:[
        inpChgSel := callbacksSpec valueChangeSelector.
        inpChgSel notNil ifTrue:[
            aView action:[:t| 
                              "/ actually, ST80 apps expect the controller here ...  
                              self sendMessage:inpChgSel withOptionalArg:aView to:appl.
                         ].
        ]
    ].
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |appl|

    super setAttributesIn:aView with:aBuilder.

    showHandle notNil ifTrue:[aView showHandle:showHandle].
    adjust notNil     ifTrue:[aView adjust:adjust].
    ignoreReselect notNil ifTrue:[ aView ignoreReselect:ignoreReselect].

    aBuilder isEditing ifTrue:[
        model notNil ifTrue:[
            aView label:model
        ].
    ].

    (stateChangeCallBackSelector notNil
    and:[aBuilder isEditing not
    and:[(appl := aBuilder application) notNil]]
    ) ifTrue:[
        aView action:[:val | appl perform:stateChangeCallBackSelector withOptionalArgument:val].
    ]

    "Modified: / 30.10.2001 / 14:43:09 / cg"
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |m aMsg cMsg|

    aBuilder isEditing ifFalse:[
        m := self modelInBuilder:aBuilder.

        aView useIndex:(useIndex ? false).
        (m isMemberOf:SelectionInList) ifTrue:[
            aView listMessage:#list.
            (useIndex == true) ifTrue:[
                aMsg := #selectionIndex.
                cMsg := #selectionIndex:.
            ] ifFalse:[
                aMsg := #selection.
                cMsg := #selection:.
            ].
        ] ifFalse:[
            menu isArray ifTrue:[
                "/ special: constant menu-list
                aView list:menu.
            ] ifFalse:[
                aView listHolder:(self getBindingIn:aBuilder binding:menu).
            ].
            aMsg := #value.
            cMsg := #value:.
        ].
        aView aspectMessage:aMsg; changeMessage:cMsg.
        aView model:m.
        callbacksSpec notNil ifTrue:[self defineCallBacksFor:aBuilder view:aView].
     ]

    "Modified: / 20.6.1998 / 12:17:20 / cg"
!

validateModel:aModel forView:aView withValue:constantList
    "about to set the model.
     If it's a plain valueHolder, change the listMessage
     to #value"

    ^ self
        validateSelectionInListModel:aModel forView:aView withValue:constantList

    "Created: / 26-10-1997 / 19:12:02 / cg"
    "Modified (comment): / 13-02-2017 / 20:28:59 / cg"
! !

!PopUpListSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.
    callbacksSpec notNil ifTrue:[callbacksSpec := callbacksSpec decodeAsLiteralArray].
    menu notNil ifTrue:[
        menu first == #Array ifTrue:[
            menu := menu decodeAsLiteralArray
        ]
    ].

    "Modified: / 26-03-2007 / 22:27:53 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    showHandle ~~ false ifTrue:[l add:#showHandle].
    useIndex   ~~ true  ifTrue:[l add:#useIndex].
    ignoreReselect ~~ false ifTrue:[l add:#ignoreReselect].
    stateChangeCallBackSelector isNil ifTrue:[l add:#stateChangeCallBackSelector].
    ^ l

    "Created: / 29.10.1997 / 15:50:07 / cg"
    "Modified: / 6.3.1999 / 21:25:40 / cg"
! !

!PopUpListSpec methodsFor:'parsing a view'!

fromView:aPopUpList callBack:aBlock
    "extract attributes from aView"

    useIndex   := aPopUpList useIndex.
    showHandle := aPopUpList showHandle.
    adjust     := aPopUpList adjust.
    super fromView:aPopUpList callBack:aBlock

    "Modified: / 6.3.1999 / 21:26:02 / cg"
! !

!PopUpListSpec methodsFor:'queries'!

usefulReplacementSpecClassNames
    ^ #( ComboBoxSpec ComboListSpec InputFieldSpec )
! !

!PopUpListSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors these generate aspect methods in the definer"

    |more|

    more := super aspectSelectors.
    menu notNil ifTrue:[more add:menu].
    stateChangeCallBackSelector notNil ifTrue:[more add:stateChangeCallBackSelector].
    ^ more
!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator"

    menu isNil ifTrue:[^ SelectionInList].
    ^ ValueHolder

    "Modified: / 26.10.1997 / 18:58:46 / cg"
! !

!PopUpListSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitPopUpListSpec:self
! !

!PopUpListSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/PopUpListSpec.st,v 1.78 2018-01-15 21:16:09 cg Exp $'
! !

