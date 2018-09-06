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
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

NamedSpec subclass:#MeterWidgetSpec
	instanceVariableNames:'labelColor numberColor scaleColor pointerColor backgroundColor
		chassisColor label'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!MeterWidgetSpec class methodsFor:'documentation'!

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

!MeterWidgetSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        model
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        backgroundColor
                        chassisColor
                        labelColor
                        pointerColor
                        scaleColor
                        numberColor
                        label
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MeterWidgetSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'UISpecification Basics'
         name: 'UISpecification Basics'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 143)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 133 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 23 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 12 0 1 1.0 34 0)
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
                   layout: (AlignmentOrigin 100 0 50 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 39 0 1 1.0 61 0)
                   activeHelpKey: id
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Label:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 100 0 77 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'labelField'
                   layout: (LayoutFrame 100 0 66 0 1 1.0 88 0)
                   activeHelpKey: id
                   tabable: true
                   model: label
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
     UIPainter new openOnClass:MeterWidgetSpec andSelector:#detailsEditSpec
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
         bounds: (Rectangle 0 0 400 237)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 230 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Chassis-Color:'
                   name: 'chassisColorLabel'
                   layout: (AlignmentOrigin 100 0 25 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuChassis'
                   layout: (LayoutFrame 100 0 13 0 2 1.0 35 0)
                   activeHelpKey: foregroundColor
                   model: chassisColor
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 55 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 43 0 2 1.0 65 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                 )
                (LabelSpec
                   label: 'Arm-Color:'
                   name: 'pointerColorLabel'
                   layout: (AlignmentOrigin 100 0 85 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenuPointer'
                   layout: (LayoutFrame 100 0 73 0 2 1.0 95 0)
                   activeHelpKey: foregroundColor
                   model: pointerColor
                 )
                (LabelSpec
                   label: 'Scale-Color:'
                   name: 'scaleColorLabel'
                   layout: (AlignmentOrigin 100 0 115 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenuScale'
                   layout: (LayoutFrame 100 0 103 0 2 1.0 125 0)
                   activeHelpKey: backgroundColor
                   model: scaleColor
                 )
                (LabelSpec
                   label: 'Number-Color:'
                   name: 'numberColorLabel'
                   layout: (AlignmentOrigin 100 0 145 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenuNumber'
                   layout: (LayoutFrame 100 0 133 0 2 1.0 155 0)
                   activeHelpKey: foregroundColor
                   model: numberColor
                 )
                (LabelSpec
                   label: 'Label-Color:'
                   name: 'nameColorLabel'
                   layout: (AlignmentOrigin 100 0 175 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenuName'
                   layout: (LayoutFrame 100 0 163 0 2 1.0 185 0)
                   activeHelpKey: backgroundColor
                   model: labelColor
                 )
                )
              
             )
           )
          )
        
       )
     )
!

slices
    "return the slices for the attribute sections in the GUI Painter"
    "each item consists of a label and a window-spec selector"

    ^#(     
        (Basics basicsEditSpec)
        (Details detailsEditSpec)
        (Channels visibilityAndBackgroundChannelEditSpec)
      )
! !

!MeterWidgetSpec methodsFor:'accessing'!

label
    "return the value of the instance variable 'label' (automatically generated)"

    ^ label
!

label:something
    "set the value of the instance variable 'label' (automatically generated)"

    label := something.
! !

!MeterWidgetSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.
!

chassisColor
    "return the value of the instance variable 'chassisColor' (automatically generated)"

    ^ chassisColor
!

chassisColor:something
    "set the value of the instance variable 'chassisColor' (automatically generated)"

    chassisColor := something.
!

labelColor
    "return the value of the instance variable 'labelColor' (automatically generated)"

    ^ labelColor
!

labelColor:something
    "set the value of the instance variable 'labelColor' (automatically generated)"

    labelColor := something.
!

numberColor
    "return the value of the instance variable 'numberColor' (automatically generated)"

    ^ numberColor
!

numberColor:something
    "set the value of the instance variable 'numberColor' (automatically generated)"

    numberColor := something.
!

pointerColor
    "return the value of the instance variable 'pointerColor' (automatically generated)"

    ^ pointerColor
!

pointerColor:something
    "set the value of the instance variable 'pointerColor' (automatically generated)"

    pointerColor := something.
!

scaleColor
    "return the value of the instance variable 'scaleColor' (automatically generated)"

    ^ scaleColor
!

scaleColor:something
    "set the value of the instance variable 'scaleColor' (automatically generated)"

    scaleColor := something.
! !

!MeterWidgetSpec methodsFor:'building'!

setAttributesIn:newView with:aBuilder
    |m|

    super setAttributesIn:newView with:aBuilder.

    m := self getBindingIn:aBuilder binding:model.
    newView meterHolder:m.
    newView meterName:label.

    labelColor notNil ifTrue:[
        newView colorName:labelColor
    ].
    numberColor notNil ifTrue:[
        newView colorNumber:numberColor
    ].
    scaleColor notNil ifTrue:[
        newView colorScale:scaleColor
    ].
    pointerColor notNil ifTrue:[
        newView colorPointer:pointerColor
    ].
    backgroundColor notNil ifTrue:[
        newView colorBackgr:backgroundColor
    ].
    chassisColor notNil ifTrue:[
        newView colorChassis:chassisColor
    ]

! !

!MeterWidgetSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
    chassisColor notNil ifTrue:[chassisColor := chassisColor decodeAsLiteralArray].
    labelColor notNil ifTrue:[labelColor := labelColor decodeAsLiteralArray].
    numberColor notNil ifTrue:[numberColor := numberColor decodeAsLiteralArray].
    scaleColor notNil ifTrue:[scaleColor := scaleColor decodeAsLiteralArray].
    pointerColor notNil ifTrue:[pointerColor := pointerColor decodeAsLiteralArray].


! !

!MeterWidgetSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/MeterWidgetSpec.st,v 1.13 2017-11-28 18:21:57 cg Exp $'
! !

