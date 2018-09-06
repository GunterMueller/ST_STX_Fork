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

SliderSpec subclass:#ThumbWheelSpec
	instanceVariableNames:'endlessRotation startMotionCallBack endMotionCallBack'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ThumbWheelSpec class methodsFor:'documentation'!

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

!ThumbWheelSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        endlessRotation
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        startMotionCallBack
                        endMotionCallBack
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    "Modified: / 18.8.1998 / 17:14:09 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
            (CallBacks callBacksEditSpec)
       )

    "Created: / 18.8.1998 / 17:15:29 / cg"
! !

!ThumbWheelSpec class methodsFor:'interface specs'!

callBacksEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ThumbWheelSpec andSelector:#callBacksEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: callBacksEditSpec
       window: 
      (WindowSpec
         label: 'UpDownButton Channels'
         name: 'UpDownButton Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 123)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 122 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Start Move:'
                   name: 'startMoveLabel'
                   layout: (AlignmentOrigin 100 0 39 0 1 0.5)
                   activeHelpKey: startMotionCallBack
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'startMoveField'
                   layout: (LayoutFrame 100 0 28 0 0 1 50 0)
                   activeHelpKey: startMotionCallBack
                   tabable: true
                   model: startMotionCallBack
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'End Move:'
                   name: 'endMoveLabel'
                   layout: (AlignmentOrigin 100 0 64 0 1 0.5)
                   activeHelpKey: endMotionCallBack
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'endMoveField'
                   layout: (LayoutFrame 100 0 53 0 0 1 75 0)
                   activeHelpKey: endMotionCallBack
                   tabable: true
                   model: endMotionCallBack
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
     UIPainter new openOnClass:ThumbWheelSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'Slider Details'
         name: 'Slider Details'
         min: (Point 10 10)
         max: (Point 1152 900)
         bounds: (Rectangle 0 0 400 269)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 132 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 21 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 9 0 5 1 31 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'levelLabel'
                   layout: (AlignmentOrigin 100 0 47 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 100 0 36 0 140 0 58 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Endless Rotation'
                   name: 'endlessRotationCheckBox'
                   layout: (Point 10 60)
                   tabable: true
                   model: endlessRotation
                   translateLabel: true
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 130 0 0 1.0 203 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 199 0 0 1.0 262 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabableCheckBox'
                   layout: (LayoutFrame 10 0 4 0 166 0 26 0)
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

!ThumbWheelSpec methodsFor:'accessing'!

endMotionCallBack
    "return the value of the instance variable 'endMotionCallBack' (automatically generated)"

    ^ endMotionCallBack

    "Created: / 18.8.1998 / 17:10:23 / cg"
!

endMotionCallBack:something
    "set the value of the instance variable 'endMotionCallBack' (automatically generated)"

    endMotionCallBack := something.

    "Created: / 18.8.1998 / 17:10:24 / cg"
!

endlessRotation
    "return the value of the instance variable 'endlessRotation' (automatically generated)"

    ^ endlessRotation ? false
!

endlessRotation:something
    "set the value of the instance variable 'endlessRotation' (automatically generated)"

    endlessRotation := something.
!

startMotionCallBack
    "return the value of the instance variable 'startMotionCallBack' (automatically generated)"

    ^ startMotionCallBack

    "Created: / 18.8.1998 / 17:10:18 / cg"
!

startMotionCallBack:something
    "set the value of the instance variable 'startMotionCallBack' (automatically generated)"

    startMotionCallBack := something.

    "Created: / 18.8.1998 / 17:10:19 / cg"
! !

!ThumbWheelSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    aView endlessRotation:(self endlessRotation).

    startMotionCallBack notNil ifTrue:[
        aView startMoveAction:(aBuilder actionFor:startMotionCallBack)
    ].
    endMotionCallBack notNil ifTrue:[
        aView endMoveAction:(aBuilder actionFor:endMotionCallBack)
    ].

    "Modified: / 18.8.1998 / 17:12:49 / cg"
! !

!ThumbWheelSpec methodsFor:'converting'!

defaultStep
    ^ nil

    "Created: / 18.4.1998 / 14:45:02 / cg"
!

defaultStop
    ^ 360

    "Created: / 18.4.1998 / 14:44:57 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self endlessRotation ifFalse:[l add:#endlessRotation].
    startMotionCallBack isNil ifTrue:[l add:#startMotionCallBack].
    endMotionCallBack   isNil ifTrue:[l add:#endMotionCallBack].

    ^ l

    "Modified: / 18.8.1998 / 17:13:22 / cg"
! !

!ThumbWheelSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    endlessRotation := aView endlessRotation.

    super fromView:aView callBack:aBlock


! !

!ThumbWheelSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ThumbWheelSpec.st,v 1.19 2015-11-19 13:52:33 cg Exp $'
! !

