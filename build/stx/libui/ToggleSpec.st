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

ActionButtonSpec subclass:#ToggleSpec
	instanceVariableNames:'showLamp lampColor onCallBackSelector lampWidth'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ToggleSpec class methodsFor:'documentation'!

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

!ToggleSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ToggleSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU3A????>@G????8@]UZ*/!!A7?+?^@G_>/=8@]?:?7 A7?+?^@G_>/=8@]?:?7 A6*-U^@G????8P_???? C*****@@@@@@@@b');
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

!ToggleSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ToggleSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Toggle Basics'
         name: 'Toggle Basics'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 216)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 123 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 6 0 5 1.0 28 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Label:'
                   name: 'labelLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'labelInputField'
                   layout: (LayoutFrame 100 0 31 0 5 1 53 0)
                   activeHelpKey: label
                   tabable: true
                   model: label
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 56 0 -14 1.0 78 0)
                   activeHelpKey: booleanHolder
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
                   layout: (LayoutFrame -14 1 56 0 6 1 78 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'basicsEditSubSpec'
             layout: (LayoutFrame 0 0.0 122 0 0 1.0 263 0)
             majorKey: ActionButtonSpec
             minorKey: basicsEditSubSpec
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
     UIPainter new openOnClass:ToggleSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'Toggle Channels'
         name: 'Toggle Channels'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 1009 278)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Channels'
                   name: 'FramedBox1'
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
                      (UISubSpecification
                         name: 'LabelChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 50 0.0 4 1.0 75 0)
                         majorKey: UISpecification
                         minorKey: subSpecForLabelChannel
                       )
                      (UISubSpecification
                         name: 'FGColorChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 75 0.0 4 1.0 100 0)
                         majorKey: UISpecification
                         minorKey: subSpecForFGColorChannel
                       )
                      (UISubSpecification
                         name: 'BGColorChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 100 0.0 4 1.0 125 0)
                         majorKey: UISpecification
                         minorKey: subSpecForBGColorChannel
                       )
                      )
                    
                   )
                   extent: (Point 1009 160)
                 )
                (FramedBoxSpec
                   label: 'Callbacks'
                   name: 'FramedBox'
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
                         name: 'toggledLabel'
                         layout: (AlignmentOrigin 120 0 41 0 1 0.5)
                         activeHelpKey: actionCallBackSelector
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'onCallBackSelectorField'
                         layout: (LayoutFrame 120 0 30 0 -15 1 52 0)
                         activeHelpKey: actionCallBackSelector
                         tabable: true
                         model: onCallBackSelector
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
                         actionValue: onCallBackSelector
                       )
                      )
                    
                   )
                   extent: (Point 1009 90)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

colorSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ToggleSpec andSelector:#colorSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: colorSubSpec
       window: 
      (WindowSpec
         label: 'Toggle Colors'
         name: 'Toggle Colors'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 200)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 197 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 100 0 19 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (FontMenuSpec
                   name: 'fontMenu'
                   layout: (LayoutFrame 100 0 7 0 5 1.0 29 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                (LabelSpec
                   label: 'FG-Color:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 100 0 49 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenu1'
                   layout: (LayoutFrame 100 0 37 0 5 1.0 59 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 79 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 67 0 5 1.0 89 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (CheckBoxSpec
                   label: 'Show Lamp'
                   name: 'showLamp'
                   layout: (Point 10 97)
                   activeHelpKey: showLamp
                   tabable: true
                   model: showLamp
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Lamp Width:'
                   name: 'Label2'
                   layout: (AlignmentOrigin 238 0 113 0 1 0.5)
                   activeHelpKey: lampColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 240 0 102 0 280 0 124 0)
                   model: lampWidth
                   type: numberInRange
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   minValue: 0
                   maxValue: 100
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Lamp Color:'
                   name: 'foregroundLabel'
                   layout: (AlignmentOrigin 100 0 144 0 1 0.5)
                   activeHelpKey: lampColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFG'
                   layout: (LayoutFrame 100 0 132 0 4 1 154 0)
                   activeHelpKey: lampColor
                   model: lampColor
                   allowSymbolicColors: true
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
     UIPainter new openOnClass:ToggleSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'Toggle Details'
         name: 'Toggle Details'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 445 460)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'colorSubSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 196 0)
             minorKey: colorSubSpec
           )
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 202 0 0 1.0 447 0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Init Attributes'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Initially Disabled'
                         name: 'initiallyDisabledCheckBox'
                         layout: (Point 11 2)
                         activeHelpKey: initiallyDisabled
                         tabable: true
                         model: initiallyDisabled
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Initially Invisible'
                         name: 'initiallyInvisibleCheckBox'
                         layout: (Point 176 2)
                         activeHelpKey: initiallyInvisible
                         tabable: true
                         model: initiallyInvisible
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Bordered'
                         name: 'isDecoratedCheckBox'
                         layout: (Point 11 27)
                         activeHelpKey: hasBorder
                         tabable: true
                         model: isDecorated
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 445 96)
                 )
                (FramedBoxSpec
                   label: 'Keyboard Attributes'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Can Tab'
                         name: 'tabableCheckBox'
                         layout: (Point 11 2)
                         activeHelpKey: tabable
                         tabable: true
                         model: tabable
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 445 70)
                 )
                (FramedBoxSpec
                   label: 'Label Attributes'
                   name: 'FramedBox3'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Resize For Label'
                         name: 'CheckBox1'
                         layout: (Point 11 2)
                         activeHelpKey: resizeForLabel
                         tabable: true
                         model: resizeForLabel
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 445 70)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ToggleSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        showLamp
                        lampColor
                        lampWidth
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        onCallBackSelector
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil

    "Modified: / 26.10.1997 / 03:45:41 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec) 
            (Channels channelsEditSpec)
       )
! !

!ToggleSpec methodsFor:'accessing'!

lampWidth
    ^lampWidth
!

lampWidth: something
    lampWidth := something
!

onCallBackSelector
    ^ onCallBackSelector
!

onCallBackSelector:something
    onCallBackSelector := something.
!

showLamp
    ^ showLamp ? true
!

showLamp:something
    showLamp := something.
! !

!ToggleSpec methodsFor:'accessing-color & font'!

lampColor
    ^ lampColor
!

lampColor:something
    lampColor := something.
! !

!ToggleSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |appl|

    super setAttributesIn:aView with:aBuilder.

    aView showLamp:self showLamp.

    lampColor notNil ifTrue:[
        aView lampColor:lampColor
    ].
    lampWidth notNil ifTrue:[
        aView lampWidth:(lampWidth asInteger)
    ].

    (    onCallBackSelector notNil
    and:[aBuilder isEditing not
    and:[(appl := aBuilder application) notNil]]
    ) ifTrue:[
        onCallBackSelector numArgs == 1 ifTrue:[
            (self isKindOf:RadioButtonSpec) ifTrue:[
                aView action:[:val | appl perform:onCallBackSelector with:self select].
            ] ifFalse:[
                aView action:[:val | appl perform:onCallBackSelector with:val].
            ]
        ] ifFalse:[
            aView action:[:val | appl perform:onCallBackSelector].
        ]
    ]

    "Modified: / 21.4.1998 / 19:43:15 / cg"
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    (model isNil or:[aBuilder isEditing]) ifFalse:[
        aView model:(aBuilder aspectFor:model)    
    ]

! !

!ToggleSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    lampColor notNil ifTrue:[lampColor := lampColor decodeAsLiteralArray].


!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self lampWidth isNil ifTrue:[l add: #lampWidth].
    self showLamp ifTrue:[l add:#showLamp].
    lampColor isNil ifTrue:[l add:#lampColor].
    onCallBackSelector isNil ifTrue:[l add:#onCallBackSelector].

    ^l

    "Modified: / 20.6.1998 / 13:41:37 / cg"
! !

!ToggleSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    showLamp  := aView showLamp.
    lampColor := aView lampColor.
    lampWidth := aView lampWidth.

    super fromView:aView callBack:aBlock


! !

!ToggleSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^self class userFriendlyName
! !

!ToggleSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    onCallBackSelector notNil ifTrue:[more add:onCallBackSelector].
    ^ more

    "Modified: / 10.2.2000 / 01:26:08 / cg"
!

defaultModelIsCallBackMethodSelector:someAspect
    "used by the UIPainters aspectGenerator;
     Return true if the aspect specifies an action method
     (or callBack) as opposed to a real model value."

    ^ false

    "Created: / 5.6.1998 / 01:47:52 / cg"
!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspects default value"

    someAspect == model ifTrue:[
        ^ false
    ].

    ^ super defaultModelValueFor:someAspect

    "Created: / 26.10.1997 / 19:05:09 / cg"
    "Modified: / 10.2.2000 / 01:29:35 / cg"
! !

!ToggleSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitToggleSpec:self
! !

!ToggleSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ToggleSpec.st,v 1.83 2017-11-28 18:21:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ToggleSpec.st,v 1.83 2017-11-28 18:21:28 cg Exp $'
! !

