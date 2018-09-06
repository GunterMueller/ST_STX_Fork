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

ViewWithLabelAndModelSpec subclass:#UpDownButtonSpec
	instanceVariableNames:'orientation upAction downAction upArgument downArgument step min
		max minChannel maxChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!UpDownButtonSpec class methodsFor:'documentation'!

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
        Claus Gittinger

    [see also:]
        UIBuilder
        UIPainter
"
! !

!UpDownButtonSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'UpDownButtonSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01????>@G<@@?8@_1US? Q?GNO>@G<PH?8$_1*#? A?@@O>@G<UT?8L_1@#? A?GNO>@G<Z(?8D_0@C? C*****O@@@@@@@b');
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

!UpDownButtonSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UpDownButtonSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'UpDownButton Basics'
         name: 'UpDownButton Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 294 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: id
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
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   activeHelpKey: upAction
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 32 0 5 1.0 54 0)
                   activeHelpKey: upAction
                   tabable: true
                   model: model
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Step:'
                   name: 'stepLabel'
                   layout: (AlignmentOrigin 100 0 69 0 1 0.5)
                   activeHelpKey: stepValue
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'stepField'
                   layout: (LayoutFrame 100 0 58 0 5 1.0 80 0)
                   activeHelpKey: stepValue
                   tabable: true
                   model: step
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Min:'
                   name: 'minLabel'
                   layout: (AlignmentOrigin 100 0 96 0 1 0.5)
                   activeHelpKey: minValueOfRange
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'minField'
                   layout: (LayoutFrame 100 0 84 0 150 0 106 0)
                   activeHelpKey: minValueOfRange
                   tabable: true
                   model: min
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Max:'
                   name: 'maxLabel'
                   layout: (AlignmentOrigin 210 0 96 0 1 0.5)
                   activeHelpKey: maxValueOfRange
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'maxField'
                   layout: (LayoutFrame 210 0 84 0 260 0 106 0)
                   activeHelpKey: maxValueOfRange
                   tabable: true
                   model: max
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Up-Action:'
                   name: 'upLabel'
                   layout: (AlignmentOrigin 100 0 135 0 1 0.5)
                   activeHelpKey: upAction
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'upAction'
                   layout: (LayoutFrame 100 0 124 0 5 1.0 146 0)
                   activeHelpKey: upAction
                   tabable: true
                   model: upAction
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Up-Arg:'
                   name: 'upArgLabel'
                   layout: (AlignmentOrigin 100 0 160 0 1 0.5)
                   activeHelpKey: actionArg
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'upArgField'
                   layout: (LayoutFrame 100 0 149 0 5 1.0 171 0)
                   activeHelpKey: actionArg
                   tabable: true
                   model: upArgument
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Dn-Action:'
                   name: 'downLabel'
                   layout: (AlignmentOrigin 100 0 185 0 1 0.5)
                   activeHelpKey: downAction
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'downActionField'
                   layout: (LayoutFrame 100 0 174 0 5 1.0 196 0)
                   activeHelpKey: downAction
                   tabable: true
                   model: downAction
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Dn-Arg:'
                   name: 'downArgLabel'
                   layout: (AlignmentOrigin 100 0 210 0 1 0.5)
                   activeHelpKey: actionArg
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'downArgField'
                   layout: (LayoutFrame 100 0 199 0 5 1.0 221 0)
                   activeHelpKey: actionArg
                   tabable: true
                   model: downArgument
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Orientation:'
                   name: 'orientationLabel'
                   layout: (AlignmentOrigin 100 0 237 0 1 0.5)
                   activeHelpKey: orientation
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'Orientation'
                   name: 'orientationPopUpList'
                   layout: (LayoutFrame 100 0 225 0 5 1 249 0)
                   activeHelpKey: orientation
                   translateLabel: true
                   tabable: true
                   model: orientation
                   menu: orientationList
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
     UIPainter new openOnClass:UpDownButtonSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'UpDownButton Channels'
         name: 'UpDownButton Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 411 264)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 206 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilitySubSpecification'
                   layout: (LayoutFrame 0 0.0 7 0.0 4 1.0 32 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'EnableChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 33 0.0 4 1.0 58 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (UISubSpecification
                   name: 'FGColorChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 59 0.0 4 1.0 84 0)
                   majorKey: UISpecification
                   minorKey: subSpecForFGColorChannel
                 )
                (UISubSpecification
                   name: 'BGColorChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 85 0.0 4 1.0 110 0)
                   majorKey: UISpecification
                   minorKey: subSpecForBGColorChannel
                 )
                (UISubSpecification
                   name: 'MinChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 111 0.0 4 1.0 136 0)
                   majorKey: UISpecification
                   minorKey: subSpecForMinChannel
                 )
                (UISubSpecification
                   name: 'MaxChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 138 0.0 4 1.0 163 0)
                   majorKey: UISpecification
                   minorKey: subSpecForMaxChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 198 0 0 1.0 262 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
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
     UIPainter new openOnClass:UpDownButtonSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: detailsEditSpec
        window: 
       (WindowSpec
          label: 'UpDownButton Details'
          name: 'UpDownButton Details'
          min: (Point 10 10)
          bounds: (Rectangle 16 46 416 290)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'fontColorSubSpec'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 101 0)
              majorKey: UISpecification
              minorKey: colorSubSpec
            )
           (UISubSpecification
              name: 'detailsInitSubSpec'
              layout: (LayoutFrame 0 0.0 105 0 0 1.0 171 0)
              majorKey: UISpecification
              minorKey: detailsInitSubSpec
            )
           (FramedBoxSpec
              label: 'Keyboard Attributes'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 174 0 0 1.0 242 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (CheckBoxSpec
                    label: 'Can Tab'
                    name: 'tabableCheckBox'
                    layout: (LayoutFrame 10 0 11 0 166 0 33 0)
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

!UpDownButtonSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        orientation
                        upArgument
                        downArgument
                        foregroundColor 
                        backgroundColor
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        step
                        max
                        min
                        minChannel
                        maxChannel
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    self 
        adaptApects:
                    #(  
                        upAction
                        downAction
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    env at:#orientationList put:#(horizontal #vertical) asValue

!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics    basicsEditSpec)
            (Details   detailsEditSpec)
            (Channels  channelsEditSpec)
       )




! !

!UpDownButtonSpec methodsFor:'accessing'!

downAction
    "return the value of the instance variable 'downAction' (automatically generated)"

    ^ downAction
!

downAction:something
    "set the value of the instance variable 'downAction' (automatically generated)"

    downAction := something.
!

downArgument
    "return the value of the instance variable 'downArgument' (automatically generated)"

    ^ downArgument
!

downArgument:something
    "set the value of the instance variable 'downArgument' (automatically generated)"

    downArgument := something.
!

max
    "return the value of the instance variable 'max' (automatically generated)"

    ^ max
!

max:something
    "set the value of the instance variable 'max' (automatically generated)"

    max := something.
!

min
    "return the value of the instance variable 'min' (automatically generated)"

    ^ min
!

min:something
    "set the value of the instance variable 'min' (automatically generated)"

    min := something.
!

orientation
    "return the value of the instance variable 'orientation' (automatically generated)"

    ^ orientation ? #vertical

!

orientation:something
    "set the value of the instance variable 'orientation' (automatically generated)"

    orientation := something.
!

step
    "return the value of the instance variable 'step' (automatically generated)"

    ^ step
!

step:something
    "set the value of the instance variable 'step' (automatically generated)"

    step := something.
!

upAction
    "return the value of the instance variable 'upAction' (automatically generated)"

    ^ upAction
!

upAction:something
    "set the value of the instance variable 'upAction' (automatically generated)"

    upAction := something.
!

upArgument
    "return the value of the instance variable 'upArgument' (automatically generated)"

    ^ upArgument
!

upArgument:something
    "set the value of the instance variable 'upArgument' (automatically generated)"

    upArgument := something.
! !

!UpDownButtonSpec methodsFor:'accessing-channels'!

maxChannel

    ^maxChannel
!

maxChannel: something

    maxChannel :=  something
!

minChannel

    ^minChannel
!

minChannel: something

    minChannel := something
! !

!UpDownButtonSpec methodsFor:'building'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    minChannel notNil ifTrue:[more add:minChannel].
    maxChannel notNil ifTrue:[more add:maxChannel].
    ^ more

    "Created: / 26.10.1997 / 13:31:56 / cg"
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |upActionBlock dnActionBlock realUpActionBlock realDownActionBlock m maxHolder minHolder|

    super setAttributesIn:aView with:aBuilder.
    (foregroundColor isNil and:[foregroundChannel isNil]) ifTrue:[
        aView viewBackground:(View defaultViewBackgroundColor).
    ].

    aView orientation:self orientation.

    aBuilder isEditing ifFalse:[
        upAction notNil ifTrue:[
            upAction numArgs == 1 ifTrue:[
                upActionBlock := aBuilder actionFor:upAction withValue:upArgument
            ] ifFalse:[
                upActionBlock := aBuilder actionFor:upAction
            ].
            realUpActionBlock := upActionBlock.
        ].

        downAction notNil ifTrue:[
            downAction numArgs == 1 ifTrue:[
                dnActionBlock := aBuilder actionFor:downAction withValue:downArgument
            ] ifFalse:[
                dnActionBlock := aBuilder actionFor:downAction
            ].
            realDownActionBlock := dnActionBlock.
        ].

        model notNil ifTrue:[
            m := self modelInBuilder:aBuilder
        ].

        "/ somewhat complicated, since there could be both a model
        "/ and actions
        "/ NOTE that step may be negative!!
        (step notNil and:[m notNil]) ifTrue:[
            maxHolder := self channel:#maxChannel inBuilder:aBuilder.
            minHolder := self channel:#minChannel inBuilder:aBuilder.

            realUpActionBlock := [   |v|

                                v := m value ? (min ? 0).
                                v := v + step.

                                max notNil ifTrue:[v := v min:max].
                                v := v min:(maxHolder value ? v).
                                min notNil ifTrue:[v := v max:min].
                                v := v max:(minHolder value ? v).

                                m value:v.
                                upActionBlock value.
                            ].

            realDownActionBlock := [ |v|
                                v := m value ? (max ? 0).
                                v := v - step.

                                max notNil ifTrue:[v := v min:max].
                                v := v min:(maxHolder value ? v).
                                min notNil ifTrue:[v := v max:min].
                                v := v max:(minHolder value ? v).

                                m value:v.
                                dnActionBlock value.
                            ].
        ].

        aView upAction:realUpActionBlock.
        aView downAction:realDownActionBlock.
   ].
!

setModelAttributeIn:aView with:aBuilder
    "/ ignored here - see setAttributesIn:with:

! !

!UpDownButtonSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    upAction   isNil ifTrue:[
        l add:#upAction.
        l add:#upArgument.
    ] ifFalse:[
        upArgument isNil ifTrue:[
            l add:#upArgument
        ]
    ].
    downAction isNil ifTrue:[
        l add:#downAction.
        l add:#downArgument.
    ] ifFalse:[
        downArgument isNil ifTrue:[
            l add:#downArgument
        ]
    ].
    step isNil ifTrue:[l add:#step].
    min isNil ifTrue:[l add:#min].
    max isNil ifTrue:[l add:#max].
    minChannel isNil         ifTrue:[l add:#minChannel].
    maxChannel isNil         ifTrue:[l add:#maxChannel].


    self orientation == #vertical ifTrue:[l add:#orientation].

  ^ l

    "Modified: / 20.6.1998 / 13:41:49 / cg"
! !

!UpDownButtonSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    orientation := aView orientation.

    super fromView:aView callBack:aBlock


! !

!UpDownButtonSpec methodsFor:'queries'!

viewClass
    "return the corresponding view class of the spec"

    ^ UpDownButton


! !

!UpDownButtonSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.

    upAction   notNil ifTrue:[more add:upAction].
    downAction notNil ifTrue:[more add:downAction].

    ^ more

    "Modified: / 10.2.2000 / 01:26:30 / cg"
! !

!UpDownButtonSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitUpDownButtonSpec:self
! !

!UpDownButtonSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/UpDownButtonSpec.st,v 1.44 2017-11-28 18:21:53 cg Exp $'
! !

